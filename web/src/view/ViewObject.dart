library ViewObject;

import 'package:pixi_dart/pixi.dart';
import '../scene/Scene.dart';

class ViewObject {

    Scene scene;
    num x;
    num y;
    num sx;
    num sy;
    bool autoResize;
    DisplayObjectContainer container;

    num width;
    num height;

    ViewObject(this.scene) {
        this.x = 0;
        this.y = 0;
        this.sx = 0;
        this.sy = 0;

        this.width = 0;
        this.height = 0;

        this.container = new DisplayObjectContainer();
        this.autoResize = false;
    }

    void update() {
        this.container.x = this.sx = this.x - this.scene.view.x;
        this.container.y = this.sy = this.y - this.scene.view.y;

        if (this.sx - this.width > this.scene.view.width || this.sx + this.width < 0 || this.sy - this.height > this.scene.view.height || this.sy + this.height < 0) {
            this.container.visible = false;
        } else {
            this.container.visible = true;
        }
    }

    void updateSize(num w, num h) {
        this.width = w;
        this.height = h;
    }

    void setSize(num w, num h) {
        this.container.width = w;
        this.container.height = h;
        this.updateSize(w, h);
    }

    void addChild(DisplayObject child) {
        this.container.addChild(child);
        if (this.autoResize) this.updateSize(this.container.width, this.container.height);
    }


}