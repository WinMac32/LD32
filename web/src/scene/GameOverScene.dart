library GameOverScene;

import "package:pixi_dart/pixi.dart";
import "Scene.dart";
import "../Game.dart";
import "dart:html";


class GameOverScene extends Scene {

    GameOverScene(Game game) : super(game, 0) {
        Sprite sprite = new Sprite(new Texture.fromImage("assets/interface/game-over.png"));
        sprite.x = 0;
        sprite.y = 0;
        sprite.width = 900;
        sprite.height = 600;
        stage.addChild(sprite);
    }

    void update() {
        super.update();

        if (game.keyboardManager.isKeyDown(KeyCode.ENTER)) {
            game.gameScene.reset();
            game.currentScene = game.gameScene;
        }
    }

}