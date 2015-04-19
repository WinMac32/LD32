library AudioManager;

import "dart:html";

class AudioManager {

    Map<String, AudioElement> audios;

    AudioManager() {
        this.audios = new Map<String, AudioElement>();
    }

    AudioElement addAudio(String id, String url, bool autoplay, bool loop) {
        AudioElement audio = new Element.audio();
        audio.src = url;
        audio.autoplay = autoplay;
        audio.loop = loop;
        audios[id] = audio;
        print("Added audio track " + id);
        return audio;
    }

    AudioElement getAudio(String id) {
        return audios[id];
    }

    void stop(String id) {
        audios[id].currentTime = 0.0;
        audios[id].pause();
    }

}