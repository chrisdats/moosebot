//import the libraries
import guru.ttslib.*;
import processing.serial.*;

//give our instances names
Serial treePort;
TTS tts;

void setup() {
  voce.SpeechInterface.init("libraries/voce-0.9.1/lib", true, true, "libraries/voce-0.9.1/lib/gram", "moose");
}

void draw() {
  if (voce.SpeechInterface.getRecognizerQueueSize() > 0) {
    String s = voce.SpeechInterface.popRecognizedString();
    println("you said: " + s);
  }
}
