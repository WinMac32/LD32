import 'dart:html';
import 'src/Game.dart';

void main() {
    print("Running game...");

    Game game = new Game();
    document.querySelector("#canvas-wrapper").append(game.renderer.view);
    game.run();
}