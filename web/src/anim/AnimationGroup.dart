library AnimationGroup;

import "package:pixi_dart/pixi.dart";
import "Animation.dart";

class AnimationGroup {

    Map<String, Animation> animations;
    String _activeAnim;

    AnimationGroup(this.animations, this._activeAnim) {
    }

    void set activeAnim(String activeAnim) {
        _activeAnim = activeAnim;
        Animation act = animations[_activeAnim];
        act.changed = true;
        Sprite sprite = act.sprite;
        if (act.flipped) sprite.scale = new Point(-sprite.scale.x.abs(), sprite.scale.y);
        else sprite.scale = new Point(sprite.scale.x.abs(), sprite.scale.y);
    }

    Texture step(double deltaTime) {
        Animation anim = animations[_activeAnim];
        return anim.step(deltaTime);
    }

    void set paused(bool paused) {
        animations[_activeAnim].paused = paused;
    }


}