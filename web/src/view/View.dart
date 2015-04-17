library View;

import '../Game.dart';

class View {

    Game game;
    num x;
    num y;
    num width;
    num height;

    num targetX;
    num targetY;

    View(this.game, this.x, this.y, this.width, this.height) {
        this.targetX = x;
        this.targetY = y;
    }

    void move(num x, num y) {
        this.targetX = x;
        this.targetY = y;
    }

    void update() {
        num dx = this.targetX - this.x;
        num dy = this.targetY - this.y;

        this.x += dx / 40;
        this.y += dy / 40;
    }


}