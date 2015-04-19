library ObjectLayer;

import "../Layer.dart";
import "MapObject.dart";

class ObjectLayer extends Layer {

    List<MapObject> objects;

    ObjectLayer(this.objects, Map<String, String> properties) : super(properties) {
    }

}