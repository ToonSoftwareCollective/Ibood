import QtQuick 2.1
import qb.components 1.0

Tile {
	id: fileinfoTile
	property var idArray : []
	property bool debugOutput: app.debugOutput
	property bool dimState: screenStateController.dimmedColors
	property bool showPrice:false;
	property bool showHunt:false;

	onClicked: {
		getIbood()	
	}

    Image {
		id: image1
		fillMode: Image.PreserveAspectFit
		height: isNxt? 150:120
		source: ""
		anchors {
			top: parent.top
			topMargin: isNxt? 45 :36
			horizontalCenter: parent.horizontalCenter
		}
		visible: !dimState
    }
	
	Rectangle {
		id: backgroundRect
		width: isNxt? 100:80
		height: isNxt? 40:32
		anchors {
			right: parent.right
			verticalCenter: parent.verticalCenter
		}
		radius: designElements.radius
		color: "blue"
		Text {
			id: newprice
			text: ""
			anchors {
				verticalCenter: parent.verticalCenter
				right: parent.right
			}
			color: "white"
			font.pixelSize: isNxt? 30:24
			font.family: qfont.bold.name
		}
		visible: !dimState & showPrice
	}
	
    Image {
		id: hunt
		fillMode: Image.PreserveAspectFit
		height: isNxt? 70:56
		source: "file:///qmf/qml/apps/ibood/drawables/hunt.png"
		anchors {
			bottom: parent.bottom
			bottomMargin: 0
			right: parent.right
			rightMargin : 0
		}
		visible: !dimState & showHunt
    }


    Text {
		id: title
		text: "Wacht op iBood"
		width: parent.width-20
		wrapMode: Text.WordWrap
		anchors {
			top: parent.top
			topMargin: 2
			horizontalCenter: parent.horizontalCenter
		}
		font.pixelSize: isNxt? 20:16
		font.family: qfont.bold.name
		color : dimState?  dimmableColors.clockTileColor : colors.clockTileColor
    }

    Text {
		id: oldprice
		text:  ""
		anchors {
			bottom: parent.bottom
			bottomMargin: isNxt? 4:3
			left: parent.left
			leftMargin : 2
		}
		font.pixelSize: isNxt? 20:16
		font.family: qfont.bold.name
		font.strikeout: true
		visible: !dimState
    }

    Text {
		id: dimmedPrice
		text:  ""
		anchors {
			horizontalCenter: parent.horizontalCenter
			bottom: parent.bottom
			bottomMargin: isNxt? 30:24
		}
		color : dimState?  dimmableColors.clockTileColor : colors.clockTileColor
		font.pixelSize:isNxt? 30:24
		font.family: qfont.bold.name
		visible: dimState
    }

    function getIbood(){
        if (debugOutput) console.log("*********IBOOD Start getIbood")
        var http = new XMLHttpRequest()
        var siteURL = "http://feeds.ibood.com/nl/nl/offer.json?" + Math.random()*Math.random();
            var xhr = new XMLHttpRequest();
            xhr.open("GET", siteURL, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    var json = xhr.responseText;
                    if (debugOutput) console.log("*********IBOOD "+ json);
                    json = json.replace(/^[^(]*\(([\S\s]+)\);?$/, '$1');
                    var current_deal = JSON.parse(json);
                    
					if (debugOutput) console.log("*********IBOOD " + current_deal.Id)
					
					var found = false;
					for (var index in idArray){
						if (current_deal.Title === idArray[index]){found =true}
					}
					if (!found){
						if (debugOutput) console.log("*********IBOOD " + current_deal.Title)
						if (debugOutput) console.log("*********IBOOD " + current_deal.SaleType)
						if (debugOutput) console.log("*********IBOOD " + current_deal.ShortTitle)
						if (debugOutput) console.log("*********IBOOD " + current_deal.Permalink)
						
						idArray.unshift(current_deal.Id);
						if (idArray.length>5){
							title.pop();
						}

						if(current_deal.SaleType!=="normal"){
							scrapeTimer.interval = 30000
							showHunt=true
						}else{
							scrapeTimer.interval = 300000
							showHunt = false
						}
						
						title.text =  current_deal.ShortTitle

						var begin = current_deal.Image.indexOf('data-large=') + 14;
						var einde = current_deal.Image.indexOf('jpg', begin) + 3;
						var newstring1 = current_deal.Image.substring (begin, einde);
						if (debugOutput) console.log("*********IBOOD " + 'http://' +newstring1);
						image1.source = 'http://' +newstring1

						begin = current_deal.Price.indexOf('old-price') + 11;
						var begin2 = current_deal.Price.indexOf('€ ',begin) + '€ '.length;
						einde = current_deal.Price.indexOf('</span>', begin2);
						var oldprice1 = current_deal.Price.substring (begin2, einde);
						if (debugOutput) console.log("*********IBOOD " + oldprice1);
						oldprice.text = oldprice1

						begin = current_deal.Price.indexOf('new-price') + 11;
						begin2 = current_deal.Price.indexOf('€ ',begin) + '€ '.length;
						einde = current_deal.Price.indexOf('</span>', begin2);
						var newprice1 = current_deal.Price.substring (begin2, einde);
						if (debugOutput) console.log("*********IBOOD " + newprice1)
						
						if (isNxt){
							backgroundRect.width = newprice1.length*17
						}else{
							backgroundRect.width = newprice1.length*14
						}
						showPrice=true
						newprice.text = newprice1
						dimmedPrice.text = newprice1
						
					}//not found
                }
            }
            xhr.send();
    }

    Timer {
		id: scrapeTimer
		interval: 5000
		repeat: true
		running: true
		triggeredOnStart: false
		onTriggered: {
			getIbood()
		}
   }

}
