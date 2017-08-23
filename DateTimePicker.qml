import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

Rectangle {

    property alias year: yearTumbler.currentIndex
    property alias month: monthTumbler.currentIndex
    property alias day: dayTumbler.currentIndex
    property int hours: hoursTumbler.currentIndex
    property int minutes: minutesTumbler.currentIndex
    property int seconds: secondsTumbler.currentIndex
    property alias monthModel: dayTumbler.model
    property var locale: Qt.locale()
    property date currentDate: new Date()
    property var monthDayModel: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]

    anchors.fill: parent

    Row {
        id: dateRow

        Tumbler {
            id: datePicker
            height: widgetHeight * 3
            style: TumblerStyle {
                id: tumblerStyle
                visibleItemCount: 3
                delegate: Item {
                    implicitHeight: (datePicker.height - padding.top - padding.bottom) / tumblerStyle.visibleItemCount

                    Text {
                        id: label
                        text: styleData.value
                        color: styleData.current ? valueColor : "#808285"
                        font.bold: true
                        opacity: 0.4 + Math.max(0, 1 - Math.abs(styleData.displacement)) * 0.6
                        anchors.centerIn: parent
                    }
                }
            }

            TumblerColumn {
                id: yearTumbler
                model: 2100
                onCurrentIndexChanged: {
                    dayTumbler.model= monthDayModel.slice(0,calculateMonthDay(monthTumbler.currentIndex));
                }
            }

            TumblerColumn {
                id: monthTumbler
                model: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                onCurrentIndexChanged: {
                    dayTumbler.model= monthDayModel.slice(0,calculateMonthDay(currentIndex));
                }
            }

            TumblerColumn {
                id: dayTumbler
                model:monthDayModel
            }

            TumblerColumn {
                id:hoursTumbler
                model: 24
            }

            TumblerColumn {
                id:minutesTumbler
                model: 60
            }

            TumblerColumn {
                id:secondsTumbler
                model: 60
            }

        }
    }

    function updateTime() {
        currentDate = new Date();
        datePicker.setCurrentIndexAt(0,currentDate.getFullYear());
        datePicker.setCurrentIndexAt(1,currentDate.getMonth());
        datePicker.setCurrentIndexAt(2,currentDate.getDay());
        datePicker.setCurrentIndexAt(3,currentDate.getHours());
        datePicker.setCurrentIndexAt(4,currentDate.getMinutes());
        datePicker.setCurrentIndexAt(5,currentDate.getSeconds());
    }

    function formatText(count, modelData) {
        var data = count === 12 ? modelData + 1 : modelData;
        return data.toString().length < 2 ? "0" + data : data;
    }

    function isLeapYear(){

        if(year%4 == 0 ){
            if( year%100 == 0 && year%400 != 0) {
                return false;
            }
            return true;
        }
        return false;
    }

    function calculateMonthDay (monthIndex){

        switch(monthIndex) {
        case 0:
        case 2:
        case 4:
        case 6:
        case 7:
        case 9:
        case 11:
            return 31;
        case 1:
            if(isLeapYear())
                return 29;
            return 28;
        default:
            return 30;
        }
    }

}

