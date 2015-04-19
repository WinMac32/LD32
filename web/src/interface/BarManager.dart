library BarManager;

import "dart:html";

class BarManager {

    void setBar(String bar, double value, double max) {
        document.querySelector("#" + bar + "-bar").style.width = ((value / max) * 450).toString() + "px";
    }

}