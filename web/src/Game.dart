library Game;

import 'package:pixi_dart/pixi.dart';
import 'dart:html';
import 'scene/Scene.dart';
import 'scene/GameScene.dart';
import "input/KeyboardManager.dart";

class Game {

    Renderer renderer;
    num delta;
    num lastTime;

    final int width = 900;
    final int height = 600;

    Scene currentScene;
    KeyboardManager keyboardManager;


    Game() {
        this.renderer = new Renderer.autoDetect(width: width, height: height);
        this.keyboardManager = new KeyboardManager();
    }

    void run() {
        this.delta = 0;
        this.lastTime = 0;

        this.currentScene = new GameScene(this);

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