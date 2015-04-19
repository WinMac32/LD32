library AssetGroupLoader;

import "package:pixi_dart/pixi.dart";
import "dart:html";

class AssetGroupLoader extends Loader {

    List<Loader> loaders;
    int assetsLoaded;

    AssetGroupLoader(this.loaders) : super("") {
        this.assetsLoaded = 0;
    }

    @override
    void load() {
        for (Loader l in loaders) {
            l.addEventListener("loaded", assetLoaded);
            l.load();
        }
    }

    void assetLoaded(e) {
        assetsLoaded++;
        if (assetsLoaded >= loaders.length) {
            this.dispatchEvent(new CustomEvent("loaded", detail: loaders));
        }
    }

}