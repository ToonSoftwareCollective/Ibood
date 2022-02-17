//2-2022
//by oepi-loepi

import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;

App {
	id: iboodApp
	property bool 		debugOutput: false
	property url 		tileUrl : "IboodTile.qml"
	//property url 		thumbnailIcon: "qrc:/tsc/bad_small.png"
	property url 		thumbnailIcon: "qrc://apps/statusUsage/drawables/tile_total_thumb.svg"
	property 			IboodTile iboodTile
	
	function init() {
		registry.registerWidget("tile", tileUrl, this, "iboodTile", {thumbLabel: qsTr("Ibood"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"})
	}
} 
