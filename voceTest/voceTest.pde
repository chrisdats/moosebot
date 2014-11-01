// import statements ------------------------------------------------------------------------------

import guru.ttslib.*;
import java.io.*;
import processing.serial.*;

// global settings --------------------------------------------------------------------------------

// Pick 1 for Windows,
//      2 for Mac,
//      3 for Linux.
int OS = 3;

File WORKING_DIR = new File("/home/arsalan/hackathon/moosebot/voceTest");

// other globals ----------------------------------------------------------------------------------

String CHICKEN_TENDERS = "No";

// setup ------------------------------------------------------------------------------------------

Serial moosePort;
TTS tts;

void setup() {

    // Intialize speech interface.
    voce.SpeechInterface.init("libraries/voce-0.9.1/lib", true, true,
                              "libraries/voce-0.9.1/lib/gram", "moose");

    // Initalize chicken-tenders-day response.
    String[] chickenCommand = {"./chicken-tenders"};
    CHICKEN_TENDERS = runCommand(chickenCommand);

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
        println("match = " + s);

        if (s.equals("is it chicken tenders day")) {
            String additionalSpeech = "";
            if (CHICKEN_TENDERS.equals("Yes")) {
                additionalSpeech = "it is chicken tenders day";
            } else {
                additionalSpeech = "it is not chicken tenders day";
            }
            println(additionalSpeech);
            say(CHICKEN_TENDERS + " " + additionalSpeech);
        
        } else if (s.equals("what is the best college")) {
            say("Ezra Stiles of course, go fucking moose");
        
        } else if (s.equals("jay ee") || s.equals("tee dee")) {
            say("boo");
        }
    }
}

void say(String speech) {
    if (OS == 1) {
        tts.speak(speech);
    } else if (OS == 2) {
        String[] command = {"say", "'" + speech + "'"};
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
