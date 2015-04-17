library Scene;

import 'package:pixi_dart/pixi.dart';
import '../Game.dart';
import '../view/View.dart';

abstract class Scene {

    Stage stage;
    Game game;
    View view;

    Scene(this.game, int bg) {
        this.stage = new Stage(new Color(bg));

        this.view = new View(game, 0, 0, game.width, game.height);
        print("Created new scene.");
    }

    void update() {
        this.view.update();
    }

}