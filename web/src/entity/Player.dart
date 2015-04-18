library Player;

import "package:pixi_dart/pixi.dart";
import "../GameManager.dart";
import "dart:html";
import "../anim/AnimationGroup.dart";
import "../anim/Animation.dart";
import "../view/ViewObject.dart";
import "../loaders/BetterJsonLoader.dart";
import "../input/KeyboardManager.dart";

class Player extends ViewObject {

    bool loaded;

    GameManager gameManager;

    AnimationGroup anims;

    Sprite sprite;

    Player(double x, double y, GameManager gameManager) : super(gameManager.scene) {
        this.gameManager = gameManager;
        this.loaded = false;
        super.x = x;
        super.y = y;
    }

    void create() {
        BetterJsonLoader loader = new BetterJsonLoader("assets/sprites/player.json");
        loader.load();
        loader.addEventListener("loaded", loadedSprite);
    }

    void loadedSprite(CustomEvent e) {
        this.sprite = new Sprite.fromFrame("player-right-1");
        this.sprite.anchor = new Point(0.5, 0.5);
        sprite.scale = new Point(2, 2);

        Map<String, Animation> playerAnims = new Map<String, Animation>();
        playerAnims.putIfAbsent("right", () {
            return new Animation.fromRoot(sprite, 5.0, "player-right", 4, false);
        });
        playerAnims.putIfAbsent("left", () {
            return new Animation.fromRoot(sprite, 5.0, "player-right", 4, true);
        });
        playerAnims.putIfAbsent("up", () {
            return new Animation.fromRoot(sprite, 5.0, "player-up", 4, false);
        });
        playerAnims.putIfAbsent("down", () {
            return new Animation.fromRoot(sprite, 5.0, "player-down", 4, false);
        });
        anims = new AnimationGroup(playerAnims, "down");

        this.container.addChild(this.sprite);
        this.setSize(64, 64);
        gameManager.scene.stage.addChild(this.container);

        print("Player sprite loaded");
        this.loaded = true;
    }

    void update() {
        if (loaded) {
            super.update();

            double dx = 0.0;
            double dy = 0.0;

            double speed = 0.25;

            KeyboardManager kb = gameManager.game.keyboardManager;
            if (kb.isKeyDown(KeyCode.W)) dy = -speed;
            if (kb.isKeyDown(KeyCode.D)) dx = speed;
            if (kb.isKeyDown(KeyCode.S)) dy = speed;
            if (kb.isKeyDown(KeyCode.A)) dx = -speed;

            if (dx > 0) anims.activeAnim = "right";
            else if (dx < 0) anims.activeAnim = "left";
            else if (dy > 0) anims.activeAnim = "down";
            else if (dy < 0) anims.activeAnim = "up";

            double delta = gameManager.game.delta;

            this.x += dx * delta;
            this.y += dy * delta;

            anims.paused = dx + dy == 0;
            anims.step(delta);

            gameManager.scene.view.move(
                x - gameManager.game.width / 2 + 32,
                y - gameManager.game.height / 2 + 32
            );
        }
    }

}