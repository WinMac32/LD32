library Tileset;

import "package:pixi_dart/pixi.dart";
import "TilesetTile.dart";

class Tileset {

    int startingId;
    int endingId;
    List<TilesetTile> tiles;

    Tileset(this.startingId, this.tiles) {
        this.endingId = startingId + tiles.length;
    }

    TilesetTile getTile(int id) {
        for (TilesetTile tile in tiles) {
            if (tile.id == id) return tile;
        }
        return null;
    }

}