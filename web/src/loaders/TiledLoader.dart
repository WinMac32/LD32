library TiledLoader;

import "package:pixi_dart/pixi.dart";
import "dart:html";
import "dart:convert";

import "../tileset/TilesetTile.dart";
import "../tileset/Tileset.dart";
import "../world/TiledMap.dart";
import "../tileset/TilesetGroup.dart";
import "../world/Layer.dart";
import "../world/TileLayer.dart";
import "../world/object/MapObject.dart";
import "../world/object/ObjectLayer.dart";

class TiledLoader extends Loader {

    Map json;
    String url;

    int loadedTilesets;
    int tilesetsToLoad;

    int loadingDone;

    TiledMap map;

    TiledLoader(String url) : super(url) {
        this.url = url;
        this.loadedTilesets = 0;
        this.loadingDone = 0;
    }

    @override
    void load() {
        HttpRequest.getString(url).then(jsonLoaded).catchError(errorLoading);
    }

    void jsonLoaded(String rawJson) {
        print("JSON Loaded.");

        json = JSON.decode(rawJson);

        int width = json["width"];
        int height = json["height"];

        List<Map> tilesets = json["tilesets"];
        this.tilesetsToLoad = tilesets.length;

        List<Tileset> loadedTilesets = new List<Tileset>();

        for (Map tileset in tilesets) {
            print("Loading tileset...");

            String image = tileset["image"];;
            List<String> imageParts = image.split("/");
            image = imageParts[imageParts.length - 1];
            print("--> Image: " + image);

            int tilesetWidth = tileset["imagewidth"];
            int tilesetHeight = tileset["imageheight"];
            int tileWidth = tileset["tilewidth"];
            int tileHeight = tileset["tileheight"];

            int cols = (tilesetWidth / tileWidth).floor();
            int rows = (tilesetHeight / tileHeight).floor();

            int idOffs = tileset["firstgid"];
            Texture texture = new Texture.fromImage("assets/sprites/world/" + image, false, ScaleModes.NEAREST);
            texture.baseTexture.addEventListener("loaded", textureLoaded);
            print("Loading tileset texture " + image);
            List<TilesetTile> tiles = new List<TilesetTile>();

            for (int y = 0; y < rows; y++) {
                for (int x = 0; x < cols; x++) {
                    int id = x + (y * cols) + idOffs;
                    Rectangle<int> frame = new Rectangle<int>(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
                    Texture tileTexture = new Texture(texture.baseTexture, frame);
                    TilesetTile tile = new TilesetTile(id, tileTexture);
                    tiles.add(tile);
                }
            }

            Tileset loadedTileset = new Tileset(idOffs, tiles);
            loadedTilesets.add(loadedTileset);

            print("--> Loaded " + tiles.length.toString() + " tiles");
        }

        TilesetGroup group = new TilesetGroup(loadedTilesets);
        List<Map> layerData = json["layers"];

        List<Layer> layers = new List<Layer>();
        print("Loading " + layerData.length.toString() + " layers");

        for (Map layer in layerData) {
            String type = layer["type"];

            print("--> Loading " + type);

            Map<String, String> properties;
            if (layer["properties"] != null) {
                properties = layer["properties"];
            } else {
                properties = new Map<String, String>();
            }

            if (type == "tilelayer") {
                List<TilesetTile> tiles = new List<TilesetTile>();

                for (int tile in layer["data"]) {
                    if (tile > 0) {
                        tiles.add(group.getTile(tile));
                    } else {
                        tiles.add(null);
                    }
                }

                layers.add(new TileLayer(tiles, properties));
            } else if (type == "objectgroup") {
                List<Map> objectData = layer["objects"];
                List<MapObject> objects = new List<MapObject>();
                for (Map object in objectData) {
                    double width = object["width"];
                    double height = object["height"];
                    double xPos = object["x"];
                    double yPos = object["y"];
                    Map<String, String> properties = object["properties"];
                    objects.add(new MapObject(xPos, yPos, width, height, properties));
                }
                layers.add(new ObjectLayer(objects, properties));
            }
        }

        print("Loaded " + loadedTilesets.length.toString() + " tilesets");

        this.map = new TiledMap(layers, group, width, height);
        done();
    }

    void done() {
        loadingDone++;
        if (loadingDone >= 2) {
            print("Done loading da shit");
            this.dispatchEvent(new CustomEvent("loaded", detail: this.map));
        }
    }

    void textureLoaded(e) {
        loadedTilesets++;
        if (loadedTilesets >= tilesetsToLoad) {
            print("Tiled map loaded");
            done();
        }
    }

    void errorLoading(Error e) {
        dispatchEvent(new CustomEvent('error', detail: this));
    }

}