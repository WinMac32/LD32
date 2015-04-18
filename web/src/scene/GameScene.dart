library GameScene;

import 'Scene.dart';
import '../Game.dart';
import '../GameManager.dart';
import "../loaders/TiledLoader.dart";

class GameScene extends Scene {

    GameManager gameManager;

    GameScene(Game game) : super(game, 0) {
        this.gameManager = new GameManager(game, this);

        print("Initialized new GamePlay scene");
    }

    void update() {
        super.update();
        this.gameManager.update();
    }
}