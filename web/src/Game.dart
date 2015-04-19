library Game;

import 'package:pixi_dart/pixi.dart';
import 'dart:html';
import 'scene/Scene.dart';
import 'scene/GameScene.dart';
import 'scene/GameOverScene.dart';
import "input/KeyboardManager.dart";
import "loaders/AssetGroupLoader.dart";
import "loaders/BetterJsonLoader.dart";

class Game {

    Renderer renderer;
    num delta;
    num lastTime;

    final int width = 900;
    final int height = 600;

    GameScene gameScene;
    GameOverScene gameOverScene;

    Scene currentScene;
    KeyboardManager keyboardManager;

    Game() {
        this.renderer = new Renderer.autoDetect(width: width, height: height);
        this.keyboardManager = new KeyboardManager();
    }

    void run() {
        AssetGroupLoader loader = new AssetGroupLoader([
            new BetterJsonLoader("assets/sprites/player.json"),
            new BetterJsonLoader("assets/sprites/player-boost.json"),
            new BetterJsonLoader("assets/sprites/enemy.json"),
            new BetterJsonLoader("assets/sprites/blood.json")
        ]);
        loader.addEventListener("loaded", loaded);
        loader.load();
    }

    void loaded(e) {
        this.delta = 0;
        this.lastTime = 0;

        this.gameScene = new GameScene(this);
        this.gameOverScene = new GameOverScene(this);

        this.currentScene = gameScene;

        window.animationFrame.then(loop);
    }

    loop(num time) {
        this.delta = time - this.lastTime;
        this.lastTime = time;

        this.currentScene.update();
        this.renderer.render(this.currentScene.stage);

        window.animationFrame.then(loop);
    }

}