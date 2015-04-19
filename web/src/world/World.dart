library World;

import "package:pixi_dart/pixi.dart";

import "TiledMap.dart";
import "../GameManager.dart";
import "TileLayer.dart";
import "../view/ViewObject.dart";
import "../tileset/TilesetTile.dart";
import "../entity/Player.dart";
import "object/ObjectLayer.dart";
import "object/MapObject.dart";
import "../path/Pathfinder.dart";
import "../entity/Enemy.dart";
import "dart:math";

class World {

    TiledMap map;
    GameManager gameManager;

    List<ViewObject> worldTiles;
    List<bool> collision;
    Grid collisionGrid;

    Player player;
    List<Enemy> enemies;
    List<Enemy> pendingRemoval;

    Random rand;

    int currentLevel;

    World(this.map, this.gameManager) {
        worldTiles = new List<ViewObject>();
        collision = new List<bool>();
        enemies = new List<Enemy>();
        pendingRemoval = new List<Enemy>();

        for (int i = 0; i < map.width * map.height; i++) {
            collision.add(false);
        }

        rand = new Random();
        currentLevel = 1;
    }

    void create() {
        List<TileLayer> layers = map.getTileLayers();

        print("World has " + layers.length.toString() + " tile layers");

        print("Map width: " + map.width.toString() + ", height: " + map.height.toString());

        for (TileLayer layer in layers) {
            print("Adding layer...");
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
                        gameManager.scene.stage.addChild(object.container);
                    }
                }
            }
        }

        ObjectLayer col = map.getCollisionLayer();
        for (MapObject obj in col.objects) {
            int tx = (obj.x / 32).floor();
            int ty = (obj.y / 32).floor();
            int tw = (obj.width / 32).floor();
            int th = (obj.height / 32).floor();
            for (int w = 0; w < tw; w++) {
                for (int h = 0; h < th; h++) {
                    collision[tx + w + ((ty + h) * map.width)] = true;
                }
            }
        }

        collisionGrid = new Grid(collision, map.width, map.height);

        /*
        for (int y = 0; y < 100; y++) {
            String line = "";
            for (int x = 0; x < 100; x++) {
                line += (collision[y * 100 + x] ? 1 : 0).toString();
            }
            print(line);
        }
        */

        print("Initialized collision.");

        player = new Player(128.0, 128.0, this.gameManager);
        player.create();
    }

    bool isEnemyAt(int x, int y) {
        for (Enemy e in enemies) {
            if (e.tileX == x && e.tileY == y) return true;
        }
        return false;
    }

    void generateLevel(int difficulty) {
        for (int d = 0; d < difficulty; d++) {
            for (int i = 0; i < 20; i++) {
                int x;
                int y;
                while (true) {
                    x = rand.nextInt(map.width);
                    y = rand.nextInt(map.height);
                    if (!(hasCollisionAt(x, y) || isEnemyAt(x, y))) break;
                }
                Enemy enemy = new Enemy(x * 64.0, y * 64.0, gameManager, "enemy", 5 * difficulty, 0.1 * difficulty);
                gameManager.scene.stage.addChild(enemy.container);
                enemies.add(enemy);
            }
        }
    }

    bool hasCollisionAt(int x, int y) {
        if (x < 0 || x >= map.width || y < 0 || y >= map.height) return true;
        return collision[x + (y * map.height)];
    }

    Grid getCollisionGrid() {
        collisionGrid.reset();
        return collisionGrid;
    }

    void removeEnemy(Enemy e) {
        pendingRemoval.add(e);
        gameManager.scene.stage.removeChild(e.container);
    }

    void update() {
        for (ViewObject tile in worldTiles) {
            tile.update();
        }

        for (Enemy e in enemies) {
            e.update();
        }

        for (Enemy e in pendingRemoval) enemies.remove(e);

        player.update();

        if (player.health <= 0) {
            gameManager.game.audioManager.stop("music-0");
            gameManager.game.audioManager.getAudio("music-1").play();
            gameManager.game.currentScene = gameManager.game.gameOverScene;
        }

        gameManager.barManager.setCounter("enemies-remaining", enemies.length);

        if (enemies.length <= 5) {
            gameManager.barManager.setCounter("current-wave", currentLevel);
            generateLevel(currentLevel++);
            player.health = player.maxHealth;
        }
    }

}