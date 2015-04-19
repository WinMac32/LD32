library Enemy;

import "package:pixi_dart/pixi.dart";
import "../view/ViewObject.dart";
import "../GameManager.dart";
import "../anim/Animation.dart";
import "../anim/AnimationGroup.dart";
import "../path/Pathfinder.dart";
import "Player.dart";
import "dart:math";

class Enemy extends ViewObject {

    GameManager gameManager;

    int damage;
    double speed;

    double health;
    double healthMax;

    double damageTime;
    double attackTime;
    double deathTime;
    double bleedTime;
    double audioTime;

    int homeX;
    int homeY;

    Sprite sprite;
    AnimationGroup anims;
    Sprite bloodSprite;
    Animation blood;

    List<Point<int>> currentPath;
    int recalculateTimer;

    Random rand;

    Enemy(double x, double y, GameManager gameManager, String frameRoot, this.damage, this.speed) : super(gameManager.scene) {
        this.x = x;
        this.y = y;

        this.gameManager = gameManager;
        this.recalculateTimer = 0;

        rand = new Random();

        sprite = new Sprite(new Texture.fromFrame(frameRoot + "-right-0"));

        sprite.anchor = new Point(0.5, 0.5);
        sprite.scale = new Point(2, 2);

        anims = new AnimationGroup({
            "right": new Animation.fromRoot(sprite, 5.0, frameRoot + "-right", 4, false),
            "left": new Animation.fromRoot(sprite, 5.0, frameRoot + "-right", 4, true),
            "up": new Animation.fromRoot(sprite, 5.0, frameRoot + "-up", 4, false),
            "down": new Animation.fromRoot(sprite, 5.0, frameRoot + "-down", 4, false)
        }, "down");

        bloodSprite = new Sprite(new Texture.fromFrame("blood-0"));
        bloodSprite.anchor = new Point(0.5, 0.5);
        bloodSprite.scale = new Point(2, 2);

        blood = new Animation.fromRoot(bloodSprite, 10.0, "blood", 4, false);
        blood.loop = false;

        container.addChild(sprite);
        container.addChild(bloodSprite);
        setSize(64, 64);

        this.homeX = tileX;
        this.homeY = tileY;

        this.health = healthMax = 100.0;
        this.damageTime = 0.0;
        this.attackTime = 0.0;

        this.deathTime = 0.0;
        this.bleedTime = 0.0;

        this.audioTime = 0.0;
    }

    int get tileX {
        return (x / 64).floor();
    }

    int get tileY {
        return (y / 64).floor();
    }

    void update() {
        super.update();
        double delta = gameManager.game.delta;
        Player player = gameManager.currentWorld.player;

        if (deathTime == 0) {
            anims.step(delta);

            recalculateTimer += delta;
            if (recalculateTimer >= 100 && rand.nextInt(10) > 8) {
                recalculateTimer = 0;
                Player target = gameManager.currentWorld.player;

                int targetX = (target.x / 64).floor();
                int targetY = (target.y / 64).floor();

                if (((tileX - targetX).abs() > 10 && (tileY - targetY).abs() > 10)
                || ((tileX - homeX).abs() > 20 && (tileX - homeX).abs() > 20)) {
                    targetX = homeX;
                    targetY = homeY;
                }

                if (targetX != tileX || targetY != tileY) {
                    Grid grid = gameManager.currentWorld.getCollisionGrid();
                    Pathfinder finder = new Pathfinder();
                    currentPath = finder.getPath(tileX, tileY, targetX, targetY, grid);
                } else {
                    currentPath = null;
                }
            }

            if (currentPath != null && currentPath.isNotEmpty) {
                Point<int> next = currentPath[0];

                if (tileX == next.x && tileY == next.y) {
                    currentPath.removeAt(0);
                }

                double dx = (next.x - tileX) * speed * delta;
                double dy = (next.y - tileY) * speed * delta;

                if (dx > 0) anims.activeAnim = "right";
                else if (dx < 0) anims.activeAnim = "left";
                else if (dy > 0) anims.activeAnim = "down";
                else if (dy < 0) anims.activeAnim = "up";

                anims.paused = dx.abs() + dy.abs() == 0;

                x += dx;
                y += dy;
            }

            if (tileX != homeX || tileY != homeY) {
                for (Enemy e in gameManager.currentWorld.enemies) {
                    if (e.x - 32 < x && e.x + 32 > x && e.y - 32 < y && e.y + 32 > y) {
                        //Bounce
                        double dx = (x - e.x) * (speed / 100) * delta;
                        double dy = (y - e.y) * (speed / 100) * delta;

                        double newX = x + dx;
                        double newY = y + dy;
                        int nTileX = (newX / 64).floor();
                        int nTileY = (newX / 64).floor();
                        if (!gameManager.currentWorld.hasCollisionAt(nTileX, nTileY)) {
                            x = newX;
                            y = newY;
                        }
                    }
                }
            }

            if (player.x - 32 < x && player.x + 32 > x && player.y - 32 < y && player.y + 32 > y) {
                if (player.boosting) {
                    if (damageTime <= 0) {
                        health -= 50;
                        damageTime = 100.0;
                        bleedTime = 300.0;
                        int track = rand.nextInt(3);
                        gameManager.game.audioManager.getAudio("splat-" + track.toString()).play();
                        track = rand.nextInt(3);
                        gameManager.game.audioManager.getAudio("grunt-" + track.toString()).play();
                        if (health <= 0) deathTime = 1000.0;
                    }
                } else if (attackTime <= 0) {
                    player.health -= 10;
                    attackTime = 500.0;
                }
            }
        }
        if (damageTime > 0) damageTime -= delta;
        if (attackTime > 0) attackTime -= delta;
        if (bleedTime > 0) bleedTime -= delta;
        if (deathTime > 0) deathTime -= delta;
        if (audioTime > 0) audioTime -= delta;

        if ((player.tileX - tileX).abs() < 5 && (player.tileY - tileY).abs() < 5 && audioTime <= 0) {
            int chance = rand.nextInt(10);
            if (chance > 6) {
                int track = rand.nextInt(4);
                var e = gameManager.game.audioManager.getAudio("hippie-" + track.toString());
                e.volume = 0.5;
                e.play();
                audioTime = 1000.0;
            }
        }

        if (bleedTime > 0 || deathTime > 0) {
            bloodSprite.visible = true;
        } else {
            bloodSprite.visible = false;
        }

        if (deathTime > 0) blood.step(delta);

        if (health <= 0 && deathTime <= 0) {
            gameManager.currentWorld.removeEnemy(this);
        }

    }


}