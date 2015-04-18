library KeyboardManager;

import "dart:html";

class KeyboardManager {

    List<int> keys = new List<int>();

    KeyboardManager() {
        window.onKeyDown.listen((KeyboardEvent e) {
            if (!keys.contains(e.keyCode)) keys.add(e.keyCode);
        });
        window.onKeyUp.listen((KeyboardEvent e) {
            keys.remove(e.keyCode);
        });
    }

    bool isKeyDown(int keyCode) {
        return keys.contains(keyCode);
    }

}