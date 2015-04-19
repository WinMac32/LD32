library Animation;

import "package:pixi_dart/pixi.dart";
import "dart:math";

class Animation {

    List<Texture> textures;
    Sprite sprite;

    double speed;
    double elapsed;
    bool changed;
    int activeFrame;
    bool flipped;
    bool paused;
    bool loop;

    void reset() {
        this.elapsed = 0;
        this.changed = true;
        this.activeFrame = 0;
        this.paused = false;
        this.loop = true;
    }

    Animation(this.textures, this.sprite, double fps) {
        this.speed = 1000 / fps;
        reset();
    }

    Animation.fromRoot(this.sprite, double fps, String root, int frames, this.flipped) {
        this.speed = 1000 / fps;
        reset();

        this.textures = new List<Texture>();

        for (int i = 0; i < frames; i++) {
            this.textures.add(new Texture.fromFrame(root + "-" + i.toString()));
        }
    }

    Texture step(double deltaTime) {
        this.elapsed += deltaTime;

        if (this.elapsed > this.speed) {
            this.elapsed = 0.0;
            this.changed = true;
            this.activeFrame++;

            if (this.activeFrame >= this.textures.length) {
                this.activeFrame = loop ? 0 : this.textures.length - 1;
            }
        }

        if (this.changed && !this.paused) {
            this.sprite.setTexture(this.textures[this.activeFrame]);
            this.changed = false;
        }

        return this.textures[this.activeFrame];
    }

}