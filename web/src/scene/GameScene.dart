library GameScene;

import 'Scene.dart';
import '../Game.dart';
import '../GameManager.dart';

class GameScene extends Scene {

    GameManager gameManager;

    GameScene(Game game) : super(game, 0x9DE0F2) {
        this.gameManager = new GameManager(game, this);

        print("Initialized new GamePlay scene");
    }

    void update() {
        super.update();
        this.gameManager.update();
    }

    void reset() {
        this.stage.children.clear();
        gameManager.reset();
    }
}