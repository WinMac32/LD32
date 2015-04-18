library TilesetGroup;

import "Tileset.dart";
import "TilesetTile.dart";

class TilesetGroup {

    List<Tileset> tilesets;

    TilesetGroup(this.tilesets) {
    }

    TilesetTile getTile(int id) {
        for (Tileset tileset in tilesets) {
            if (tileset.startingId <= id && tileset.endingId > id) {
                return tileset.getTile(id);
            }
        }
        return null;
    }


}