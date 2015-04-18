library World;

import "package:pixi_dart/pixi.dart";

import "Layer.dart";
import "TiledMap.dart";
import "../GameManager.dart";
import "TileLayer.dart";
import "../view/ViewObject.dart";
import "../tileset/TilesetTile.dart";
import "../entity/Player.dart";

class World {

    TiledMap map;
    GameManager gameManager;

    List<ViewObject> worldTiles;

    Player player;

    World(this.map, this.gameManager) {
        worldTiles = new List<ViewObject>();
    }

    void create() {
        List<TileLayer> layers = map.getTileLayers();

        print("World has " + layers.length.toString() + " tile layers");

        print("Map width: " + map.width.toString() + ", height: " + map.height.toString());

        for (TileLayer layer in layers) {
            print("Adding layer");
            for (int x = 0; x < map.width; x++) {
                for (int y = 0; y < map.height; y++) {
                    TilesetTile tile = layer.tiles[x + (y * map.width)];
                    if (tile != null) {
                        Sprite tileSprite = new Sprite(tile.texture);
                        tileSprite.scale = new Point(2, 2);
                        ViewObject object = new ViewObject(gameManager.scene);
                        object.addChild(tileSprite);
                        object.setSize(64, 64);
                        object.x = x * 64;
                        object.y = y * 64;
                        worldTiles.add(object);
                        print("Adding child " + tile.id.toString());
                        gameManager.scene.stage.addChild(object.container);
                    }
                }
            }
        }

        player = new Player(0, 0, this.gameManager);
        player.create();
    }

    void update() {
        for (ViewObject tile in worldTiles) {
            tile.update();
        }

        player.update();
    }

}