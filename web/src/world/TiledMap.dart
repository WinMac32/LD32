library TiledMap;

import "Layer.dart";
import "../tileset/TilesetGroup.dart";
import "TileLayer.dart";
import "object/ObjectLayer.dart";

class TiledMap {

    TilesetGroup tilesets;
    List<Layer> layers;

    int width;
    int height;

    TiledMap(this.layers, this.tilesets, this.width, this.height) {

    }

    List<TileLayer> getTileLayers() {
        List<TileLayer> tLayers = new List<Layer>();
        for (Layer layer in layers) {
            if (layer is TileLayer) {
                tLayers.add(layer);
            }
        }
        return tLayers;
    }

    ObjectLayer getCollisionLayer() {
        for (Layer layer in layers) {
            if (layer.properties["obj-type"] == "collision") {
                return layer;
            }
        }
        return null;
    }

}