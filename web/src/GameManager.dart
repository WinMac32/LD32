library GameManager;

import 'Game.dart';
import 'scene/Scene.dart';
import "loaders/TiledLoader.dart";
import "world/TiledMap.dart";
import "world/World.dart";
import "interface/BarManager.dart";

import "dart:html";

class GameManager {

    Game game;
    Scene scene;
    World currentWorld;
    BarManager barManager;
    TiledMap map;

    GameManager(this.game, this.scene) {
        this.barManager = new BarManager();
        changeWorld("main");
    }

    void changeWorld(String world) {
        TiledLoader loader = new TiledLoader("assets/maps/" + world.toLowerCase() + ".json/");
        loader.load();
        loader.addEventListener("loaded", tiledLoaded);
    }

    void tiledLoaded(CustomEvent map) {
        if (map.detail is TiledMap) {
            print("Tiled loaded, Creating world instance...");
            this.map = map.detail;
            reset();
        } else {
            print("Tiled loaded event got unknown datas");
        }
    }

    void reset() {
        currentWorld = new World(map, this);
        currentWorld.create();
    }

    void update() {
        if (currentWorld != null && game.delta < 100) {
            currentWorld.update();
        }
    }

}