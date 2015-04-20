library BarManager;

import "dart:html";

class BarManager {

    void setBar(String bar, double value, double max) {
        document.querySelector("#" + bar + "-bar").style.width = ((value / max) * 435).toString() + "px";
    }

    void setCounter(String counter, int value) {
        document.querySelector("#" + counter).innerHtml = value.toString();
    }

}