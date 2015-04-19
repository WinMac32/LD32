library Player;

import "package:pixi_dart/pixi.dart";
import "../GameManager.dart";
import "dart:html";
import "../anim/AnimationGroup.dart";
import "../anim/Animation.dart";
import "../view/ViewObject.dart";
import "../input/KeyboardManager.dart";

class Player extends ViewObject {

    GameManager gameManager;

    AnimationGroup anims;
    AnimationGroup boostAnims;

    Sprite boostSprite;
    bool boosting;
    bool boostAllowed;

    double maxStamina;
    double maxHealth;

    double _stamina;
    double _health;

    Player(double x, double y, GameManager gameManager) : super(gameManager.scene) {
        this.gameManager = gameManager;
        super.x = x;
        super.y = y;

        this.boosting = false;
        this.boostAllowed = true;
        this.health = maxHealth = 100.0;
        this.stamina = maxStamina = 100.0;
    }

    void create() {
        Sprite sprite = new Sprite.fromFrame("player-right-1");
        sprite.anchor = new Point(0.5, 0.5);

        boostSprite = new Sprite.fromFrame("player-boost-right-1");
        boostSprite.anchor = new Point(0.5, 0.5);


        anims = new AnimationGroup({
            "right": new Animation.fromRoot(sprite, 30.0, "player-right", 4, false),
            "left": new Animation.fromRoot(sprite, 30.0, "player-right", 4, true),
            "up": new Animation.fromRoot(sprite, 30.0, "player-up", 4, false),
            "down": new Animation.fromRoot(sprite, 30.0, "player-down", 4, false)
        }, "down");

        boostAnims = new AnimationGroup({
            "right": new Animation.fromRoot(boostSprite, 30.0, "player-boost-right", 4, false),
            "left": new Animation.fromRoot(boostSprite, 30.0, "player-boost-right", 4, true),
            "up": new Animation.fromRoot(boostSprite, 30.0, "player-boost-up", 4, false),
            "down": new Animation.fromRoot(boostSprite, 30.0, "player-boost-down", 4, false)
        }, "down");

        this.container.addChild(sprite);
        this.container.addChild(boostSprite);
        this.setSize(64, 64);
        gameManager.scene.stage.addChild(this.container);

        print("Player sprite loaded");
    }

    void set animDir(String dir) {
        anims.activeAnim = dir;
        boostAnims.activeAnim = dir;
    }

    void set stamina(double stamina) {
        _stamina = stamina;
        gameManager.barManager.setBar("stamina", _stamina, maxStamina);
    }

    double get stamina {
        return _stamina;
    }

    void set health(double health) {
        _health = health;
        gameManager.barManager.setBar("health", _health, maxHealth);
    }

    double get health {
        return _health;
    }

    int get tileX {
        return (x / 64).floor();
    }

    int get tileY {
        return (y / 64).floor();
    }

    void update() {
        super.update();

        double dx = 0.0;
        double dy = 0.0;

        double speed = 0.25;

        KeyboardManager kb = gameManager.game.keyboardManager;
        if (kb.isKeyDown(KeyCode.W)) dy = -speed;
        if (kb.isKeyDown(KeyCode.D)) dx = speed;
        if (kb.isKeyDown(KeyCode.S)) dy = speed;
        if (kb.isKeyDown(KeyCode.A)) dx = -speed;

        if (!boostAllowed && stamina > 10) boostAllowed = true;
        boosting = kb.isKeyDown(KeyCode.SHIFT) && boostAllowed;

        if (dx > 0) animDir = "right";
        else if (dx < 0) animDir = "left";
        else if (dy > 0) animDir = "down";
        else if (dy < 0) animDir = "up";

        double delta = gameManager.game.delta;

        boostSprite.visible = boosting;
        if (boosting) {
            stamina -= delta / 10;
        } else {
            stamina += delta / 50;
        }
        if (stamina > 100) stamina = 100.0;

        if (stamina < 0) {
            boosting = false;
            stamina = 0.0;
            boostAllowed = false;
        }
        int speedMod = boosting ? 2 : 1;

        for (int i = 0; i < speedMod; i++) {
            double x = this.x + (dx * delta);
            double y = this.y + (dy * delta);

            int tx = (x / 64).floor();
            int ty = (y / 64).floor();

            int otx = (this.x / 64).floor();
            int oty = (this.y / 64).floor();

            if (gameManager.currentWorld.hasCollisionAt(tx, ty)) {
                if (otx != tx) {
                    x -= (dx * delta);
                    dx = 0.0;
                }
                if (oty != ty) {
                    y -= (dy * delta);
                    dy = 0.0;
                }
            }

            this.x = x;
            this.y = y;
        }

        anims.paused = dx.abs() + dy.abs() == 0;
        anims.step(delta);

        boostAnims.step(delta);

        gameManager.scene.view.move(
            this.x - gameManager.game.width / 2,
            this.y - gameManager.game.height / 2
        );
    }

}