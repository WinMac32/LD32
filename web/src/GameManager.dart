library GameManager;

import 'Game.dart';
import 'scene/Scene.dart';
import "loaders/TiledLoader.dart";
import "world/TiledMap.dart";
import "world/World.dart";

import "dart:html";

class GameManager {

    Game game;
    Scene scene;
    World currentWorld;

    GameManager(this.game, this.scene) {
        changeWorld("test");
    }

    void changeWorld(String world) {
        TiledLoader loader = new TiledLoader("assets/maps/" + world.toLowerCase() + ".json/");
        loader.load();
        loader.addEventListener("loaded", tiledLoaded);
    }

    void tiledLoaded(CustomEvent map) {
        if (map.detail is TiledMap) {
            print("Tiled loaded, Creating world instance...");
            currentWorld = new World(map.detail, this);
            currentWorld.create();
        } else {
            print("Tiled loaded event got unknown datas");
        }
    }

    void update() {
        if (currentWorld != null) {
            currentWorld.update();
        }
    }

}