library Game;

import 'package:pixi_dart/pixi.dart';
import 'dart:html';
import 'scene/Scene.dart';
import 'scene/GameScene.dart';
import 'scene/GameOverScene.dart';
import "input/KeyboardManager.dart";
import "loaders/AssetGroupLoader.dart";
import "loaders/BetterJsonLoader.dart";
import "audio/AudioManager.dart";

class Game {

    Renderer renderer;
    num delta;
    num lastTime;

    final int width = 870;
    final int height = 510;

    GameScene gameScene;
    GameOverScene gameOverScene;

    Scene currentScene;
    KeyboardManager keyboardManager;
    AudioManager audioManager;

    Game() {
        this.renderer = new Renderer.autoDetect(width: width, height: height);
        this.keyboardManager = new KeyboardManager();
        this.audioManager = new AudioManager();
    }

    void run() {
        audioManager.addAudio("hippie-0", "assets/audio/dude.mp3", false, false);
        audioManager.addAudio("hippie-1", "assets/audio/man.mp3", false, false);
        audioManager.addAudio("hippie-2", "assets/audio/system.mp3", false, false);
        audioManager.addAudio("hippie-3", "assets/audio/lovenotwar.mp3", false, false);

        audioManager.addAudio("splat-0", "assets/audio/splat-1.mp3", false, false);
        audioManager.addAudio("splat-1", "assets/audio/splat-2.mp3", false, false);
        audioManager.addAudio("splat-2", "assets/audio/splat-3.mp3", false, false);

        audioManager.addAudio("grunt-0", "assets/audio/grunt-1.mp3", false, false);
        audioManager.addAudio("grunt-1", "assets/audio/grunt-2.mp3", false, false);
        audioManager.addAudio("grunt-2", "assets/audio/grunt-3.mp3", false, false);

        audioManager.addAudio("music-0", "assets/audio/music-1.mp3", true, true).volume = 0.5;
        audioManager.addAudio("music-1", "assets/audio/music-2.mp3", false, true).volume = 0.5;

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