/*!
  * KDE Plasma script to display the current IP address and ISP
  *
  * Juan de Hoyos <juanmahv@gmail.com>
  * 02.May.2014
  */
import QtQuick 2.0;
import QtQuick.Controls 1.4;
import QtQuick.Layouts 1.1

Item {
    id:root

    width: 500
    height: 400
    property string news: ""
    property string wrap:"WordWrap"
    property string label:"Sample text"
    property string key : '80d8f1b204614bb287eabdee85f39c4f'
    property string base_api : 'https://newsapi.org/v1/articles?'

    
    property int refresh: 1000 * plasmoid.configuration.refresh
    property var backColor: plasmoid.configuration.backColor
    property var foreColor: plasmoid.configuration.foreColor
    property var headerColor: plasmoid.configuration.headerColor
    property var listOpacity: plasmoid.configuration.listOpacity
    property int fontSize: plasmoid.configuration.fontSize


    // // property int refresh: 1000 * 30
    // // property var backColor: '#DFDFDF'
    // // property var foreColor: 'black'
    // // property var headerColor: 'blue'
    // // property var listOpacity: 0.8
    // property int fontSize: 12

    
    function callback(x,row){
        if (x.responseText) {
            var d = JSON.parse(x.responseText);
            if(row==1){
            r1c1.text = d.articles[0].title;
            r1c2.text = d.articles[1].title;
            r1c3.text = d.articles[2].title;
            r1c4.text = d.articles[3].title;
            r1c5.text = d.articles[4].title;
            }
            if(row==2){
            r2c1.text = d.articles[0].title;
            r2c2.text = d.articles[1].title;
            r2c3.text = d.articles[2].title;
            r2c4.text = d.articles[3].title;
            r2c5.text = d.articles[4].title;
            }
            if(row==3){
            r3c1.text = d.articles[0].title;
            r3c2.text = d.articles[1].title;
            r3c3.text = d.articles[2].title;
            r3c4.text = d.articles[3].title;
            r3c5.text = d.articles[4].title;
            }
            if(row==4){
            r4c1.text = d.articles[0].title;
            r4c2.text = d.articles[1].title;
            r4c3.text = d.articles[2].title;
            r4c4.text = d.articles[3].title;
            r4c5.text = d.articles[4].title;
            }
            if(row==5){
            r5c1.text = d.articles[0].title;
            r5c2.text = d.articles[1].title;
            r5c3.text = d.articles[2].title;
            r5c4.text = d.articles[3].title;
            r5c5.text = d.articles[4].title;
            }
            //source = d.articles[0].author;
            
           
        }
    }

    function request(url,row, callback) {
       var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function f() {callback(xhr,row)});
       xhr.open('GET', url, true);
       xhr.send();
   }

    Timer {
        running: true
        triggeredOnStart: true
        interval: refresh
        onTriggered: request('https://newsapi.org/v1/articles?source=the-telegraph&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',1,callback),
        request('https://newsapi.org/v1/articles?source=the-times-of-india&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',2,callback),
        request('https://newsapi.org/v1/articles?source=the-economist&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',3,callback),
        request('https://newsapi.org/v1/articles?source=espn-cric-info&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',4,callback),
        request('https://newsapi.org/v1/articles?source=mtv-news&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',5,callback)
    }

    function reload(){
        request('https://newsapi.org/v1/articles?source=the-next-web&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',1,callback);
        request('https://newsapi.org/v1/articles?source=the-times-of-india&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',2,callback);
        request('https://newsapi.org/v1/articles?source=the-economist&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',3,callback);
        request('https://newsapi.org/v1/articles?source=espn-cric-info&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',4,callback);
        request('https://newsapi.org/v1/articles?source=mtv-news&sortBy=latest&apiKey=80d8f1b204614bb287eabdee85f39c4f',5,callback);
    }
    MouseArea {
        id: itemMouseArea
        acceptedButtons: Qt.RightButton
        anchors.fill: parent
        onClicked: {
            //              right button is clicked
            contextMenu.popup()
        }
    }
    Menu {
        id: contextMenu
        MenuItem {
            text: "Reload"
            onTriggered: {
               reload()
            }
        }    
    }

Rectangle{
    anchors.fill : parent
    opacity : listOpacity
    color : backColor
    anchors.margins: 0
   
}
ScrollView {
   id : scroll
   anchors.fill: parent
   anchors.margins: 0
   clip:true
   frameVisible:false

   Column{ 
   id : thefeed 

   ColumnLayout{
    spacing:10
   
   Rectangle{
        height:30
        color : backColor
        width:root.width
    Text{
        text: "News Updates"
        color: '#3498DB'
        
        font.pointSize: fontSize+4
  
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    
    }
    }
    Rectangle{
        id:headerLine
        height:5
        width:root.width
        anchors.horizontalCenter: root.horizontalCenter
        color:"purple"
    }

    Column{
            
            id : col1
        
            Text {  text: 'The Telegraph'
            color: headerColor
            font.pointSize: fontSize
            wrapMode:wrap 
            }
            
            Text {  
            id: r1c1    
            font.family: "Helvetica"
            font.pointSize: fontSize
            color: foreColor
            text: ""
            wrapMode:wrap 
            }
            
            Text {  
            id: r1c2    
            font.family: "Helvetica"
            font.pointSize: fontSize
            color: foreColor
            text: ""
            wrapMode:wrap 
            }
            
            Text {  
            id: r1c3    
            font.family: "Helvetica"
            font.pointSize: fontSize
            color: foreColor
            text: ""
            wrapMode:wrap 
            }
            
            Text {  
            id: r1c4    
            font.family: "Helvetica"
            font.pointSize: fontSize
            color: foreColor
            text: ""
            wrapMode:wrap 
            }
            
            Text {  
            id: r1c5    
            font.family: "Helvetica"
            font.pointSize: fontSize
            color: foreColor
            text: ""
            wrapMode:wrap 
            }
        }
    
    Column{
        
        
        Text {  text: 'The Times of India'
        color: headerColor
        font.pointSize: fontSize
        wrapMode:wrap 
        }
        
        Text {  
        id: r2c1    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r2c2    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r2c3    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r2c4    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r2c5    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        
    }
    
    Column{
        
        
        Text {  text: 'The Economist'
        color: headerColor
        font.pointSize: fontSize
        wrapMode:wrap 
        }
        
        Text {  
        id: r3c1    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r3c2    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r3c3    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r3c4    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r3c5    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        
    }
    
    Column{
        
        
        Text {  text: 'ESPN Cric Info'
        color: headerColor
        font.pointSize: fontSize
        wrapMode:wrap 
        }
        
        Text {  
        id: r4c1    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r4c2    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r4c3    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r4c4    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r4c5    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        
    }
    
    Column{
        
        
        Text {  text: 'MTV News'
        color: headerColor
        font.pointSize: fontSize
        wrapMode:wrap 
        }
        
        Text {  
        id: r5c1    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r5c2    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r5c3    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r5c4    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        Text {  
        id: r5c5    
        font.family: "Helvetica"
        font.pointSize: fontSize
        color: foreColor
        text: ""
        wrapMode:wrap 
        }
        
        
    }
    Rectangle{
        id:footerLine
        height:5
        width:root.width
        anchors.horizontalCenter: root.horizontalCenter
        color:"purple"
    }

   Rectangle{
        height:15
        width:root.width
        color : backColor
    // Text{
    //     text: "News Updates by Aishwarya Mittal"

    //     font.family: "Helvetica"
    //     font.pointSize: 8
      
    //     anchors.verticalCenter: parent.verticalCeter
    // }
    }

    }
    }
    
}
}
