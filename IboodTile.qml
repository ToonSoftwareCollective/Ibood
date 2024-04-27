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
		height: isNxt? 145:120
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
        var siteURL = "https://www.ibood.com/offers/nl/s-nl?" + Math.random()*Math.random();
            var xhr = new XMLHttpRequest();
            xhr.open("GET", siteURL, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    var parseString = xhr.responseText;
                    
                    var pieceofHTML= parseString.split("__NEXT_DATA__")[1]
                    pieceofHTML= pieceofHTML.split("\">")[1].split("</script>")[0]
                    if (debugOutput) console.log("*********IBOOD " + pieceofHTML)
                    var current_deal = JSON.parse(pieceofHTML);

                    var dealpart
                    if(current_deal.props.pageProps.hunt){
						dealpart = current_deal.props.pageProps.hunt
						showHunt=true;	
						scrapeTimer.interval = 30000
                    }else{
						dealpart = current_deal.props.pageProps.offers[0]
						showHunt=false;
						scrapeTimer.interval = 300000
                    }

                    if (debugOutput) console.log("*********IBOOD " + "Scraper Interval: " + scrapeTimer.interval)
                    if (debugOutput) console.log("*********IBOOD " + dealpart.classicId)
                    if (debugOutput) console.log("*********IBOOD " + dealpart.title)

                    title.text =  dealpart.title

                    image1.source = "https://images0.ibood.com/" + dealpart.image.id + ".jpg"

                    var oldprice1 = dealpart.referencePrice.value
                    var leftSide= oldprice1.toString().split(".")[0]
                    if (leftSide.toString() === undefined){leftSide = "00"}
                    var rightSide= oldprice1.toString().split(".")[1]
                    if (rightSide.toString() === undefined){rightSide = "00"}
                    if (rightSide.length === 0) rightSide = "00"
                    if (rightSide.length === 1) rightSide = rightSide + "0"
                    oldprice1 = leftSide.toString() + "," + rightSide.toString()
                    if (debugOutput) console.log ("*********IBOOD " + oldprice1);
                    oldprice.text = oldprice1

                    var newprice1 = dealpart.price.value
                    if (debugOutput) console.log (newprice1);
                    leftSide= newprice1.toString().split(".")[0]
                    if (leftSide.toString() === undefined){leftSide = "00"}
                    rightSide= newprice1.toString().split(".")[1]
                    if (rightSide.toString() === undefined){rightSide = "00"}
                    if (rightSide.length === 0) rightSide = "00"
                    if (rightSide.length === 1) rightSide = rightSide + "0"
                    newprice1 = leftSide.toString() + "," + rightSide.toString()
                    if (debugOutput) console.log ("*********IBOOD " + newprice1);
                    
					showPrice=true
					newprice.text = newprice1
					dimmedPrice.text = newprice1
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
