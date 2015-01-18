// import statements ------------------------------------------------------------------------------

import guru.ttslib.*;
import java.io.*;
import processing.serial.*;

// global settings --------------------------------------------------------------------------------

// Pick 1 for Windows,
//      2 for Mac,
//      3 for Linux.
int OS = 2;
  //change working directory to where this file is!
File WORKING_DIR = new File("/Users/chris/Dropbox/moosebot/voceTest/");

// setup ------------------------------------------------------------------------------------------

Serial moosePort;
String chickenTenders;
TTS tts;

void setup() {
    // Intialize speech interface.
    voce.SpeechInterface.init("Documents/Processing/libraries/voce-0.9.1/lib", false, true,
                              "Documents/Processing/libraries/voce-0.9.1/lib/gram", "moose");

    // Initalize is-it-chicken-tenders-day response.
    String[] chickenCommand = {"./chicken-tenders"};
    chickenTenders = runCommand(chickenCommand);

    // Initialize text-to-speech for Windows.
    if (OS == 1) {
        tts = new TTS();
        tts.setPitch(400);
        tts.setPitchRange(20);
        tts.setPitchShift(-10.5);
    }
}

// main loop --------------------------------------------------------------------------------------

void draw() {
    
    if (voce.SpeechInterface.getRecognizerQueueSize() > 0) {

        String s = voce.SpeechInterface.popRecognizedString();
        voce.SpeechInterface.setRecognizerEnabled(false);
        println("match = " + s);
        if (s.equals("chicken tenders false")) {

            String additionalSpeech = "";
            if (chickenTenders.equals("Yes")) {
                additionalSpeech = "it is chicken tenders day";
            } else {
                additionalSpeech = "it is not chicken tenders day";
            }
            println(additionalSpeech);
            say(chickenTenders + " " + additionalSpeech);
        
        } else if (s.equals("best college")) {
            say("Ezra Stiles of course, go fucking moose");
        } else if (s.equals("jay ee") || s.equals("saybrook") || s.equals("tee dee")) {
            say("booo");
        } else if (s.equals("master")) {
          say("Master Pitti");
        } else if (s.equals("dean")) {
          say("Dean L");
        } else if (s.equals("moose fact")) {
          say("Did you know the moose is the most amazing animal in the world?");
        } else if (s.equals("bagel brunch")) {
          say("No bagel brunch today");
        } else if (s.equals("joke")) {
          say("Jokes");
        }

        voce.SpeechInterface.setRecognizerEnabled(true);
    }
}

void say(String speech) {
    if (OS == 1) {
        tts.speak(speech);
    } else if (OS == 2) {
        String[] command = {"say", "-v", "cellos", "'" + speech + "'"};
        runCommand(command);
    } else if (OS == 3) {
        println(speech);
        String[] command = {"espeak", "'" + speech + "'"};
        runCommand(command);
    }
}

String runCommand(String[] command) {
    String output = "";
    try {
        Process p = Runtime.getRuntime().exec(command, null, WORKING_DIR);
        int i = p.waitFor();
        if (i == 0) {
            BufferedReader stdIn = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String line;
            while ((line = stdIn.readLine()) != null) {
                output = output + line;
            }
        } else {
            BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));
            String line;
            while ((line = stdErr.readLine()) != null) {
                output = output + line;
            }
        }
    } catch (Exception e) {
        println("Error running command!"); 
        println(e);
    }
    return output;
}
