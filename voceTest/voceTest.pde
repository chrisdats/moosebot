//import the libraries
import guru.ttslib.*;
import processing.serial.*;
import java.io.*;

//give our instances names
Serial treePort;
TTS tts;

void setup() {
  voce.SpeechInterface.init("libraries/voce-0.9.1/lib", true, true, "libraries/voce-0.9.1/lib/gram", "moose");
  tts = new TTS();
  //the following settings control the voice sound
  tts.setPitch( 400 );
  tts.setPitchRange( 20 );
  tts.setPitchShift( -10.5 );
}

void draw(){
  if (voce.SpeechInterface.getRecognizerQueueSize() > 0) {
    String s = voce.SpeechInterface.popRecognizedString();
    if (s.equals("is it chicken tenders day")) {

      println("Gonna run this command tho");
      
      String commandToRun = "./chicken-tenders";
      File workingDir = new File("/home/arsalan/hackathon/moosebot/voceTest");
      String returnedValues;
      // run the command!
      try {
    
        // complicated!  basically, we have to load the exec command within Java's Runtime
        // exec asks for 1. command to run, 2. null which essentially tells Processing to
        // inherit the environment settings from the current setup (I am a bit confused on
        // this so it seems best to leave it), and 3. location to work (full path is best)
        Process p = Runtime.getRuntime().exec(commandToRun, null, workingDir);
    
        // variable to check if we've received confirmation of the command
        int i = p.waitFor();
    
        // if we have an output, print to screen
        if (i == 0) {
    
          // BufferedReader used to get values back from the command
          BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
    
          // read the output from the command
          while ( (returnedValues = stdInput.readLine ()) != null) {
            println(returnedValues);
            tts.speak(returnedValues + "it is not. I am a talking moose.");
          }
        }
    
        // if there are any error messages but we can still get an output, they print here
        else {
          BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));
    
          // if something is returned (ie: not null) print the result
          while ( (returnedValues = stdErr.readLine ()) != null) {
            tts.speak(returnedValues);
          }
        }
      }
    
      // if there is an error, let us know
      catch (Exception e) {
        println("Error running command!"); 
        println(e);
      }
    }
  }
}
