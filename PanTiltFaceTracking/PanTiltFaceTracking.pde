/**********************************************************************************************
 * Moosebot Processing Sketch for YHack 2014
 * Based on Sparkfun Guide Written by Ryan Owens
 * Uses the OpenCV real-time computer vision framework from Intel
 * Based on the OpenCV Processing Examples from ubaa.net
 *
 * The Pan/Tilt Face Tracking Sketch interfaces with an Arduino Main board to control
 * two servos, pan and tilt, which are connected to a webcam. The OpenCV library
 * looks for a face in the image from the webcam. If a face is detected the sketch
 * uses the coordinates of the face to manipulate the pan and tilt servos to move the webcam
 * in order to keep the face in the center of the frame.
 *
 * Setup-
 * A webcam must be connected to the computer.
 * An Arduino must be connected to the computer. Note the port which the Arduino is connected on.
 * The Arduino must be loaded with the SerialServoControl Sketch.
 * Two servos mounted on a pan/tilt backet must be connected to the Arduino pins 2 and 3.
 * The Arduino must be powered by a 9V external power supply.
 * 
 * Read this tutorial for more information: https://www.sparkfun.com/tutorials/304
 **********************************************************************************************/
import hypermedia.video.*;  //Include the video library to capture images from the webcam
import java.awt.Rectangle;  //A rectangle class which keeps track of the face coordinates.
import java.awt.Point;      //A point class, if necessary.
import processing.serial.*; //The serial library is needed to communicate with the Arduino.
import guru.ttslib.*;       //The Processing Talk to Speech Library
import java.io.*;

// global settings --------------------------------------------------------------------------------

// Pick 1 for Windows,
//      2 for Mac,
//      3 for Linux.
int OS = 1;

File WORKING_DIR = new File(sketchPath(""));
// use sketchPath function

// Setup ------------------------------

OpenCV opencv;  //Create an instance of the OpenCV library.
TTS tts; //Create instance of Test to Speech Library
Serial port; // The serial port to connect with the arduino

String chickenTenders, bagel;

//Screen Size Parameters
// 640 x 480 is large enough to get a good
int width = 640;
int height = 480;

// contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;

//Variables for keeping track of the current servo positions.
char servoTiltPosition = 65;
char servoPanPosition = 10;
//The pan/tilt servo ids for the Arduino serial command interface.
char tiltChannel = 0;
char panChannel = '1';

//These variables hold the x and y location for the middle of the detected face.
int midFaceY=0;
int midFaceX=0;

//The variables correspond to the middle of the screen, and will be compared to the midFace values
int midScreenY = (height/2);
int midScreenX = (width/2);
int midScreenWindow = 10;  //This is the acceptable 'error' for the center of the screen. 

//The degree of change that will be applied to the servo each time we update the position.
int stepSize=1;

void setup() {

  //Create a window for the sketch.
  size( width, height );

  opencv = new OpenCV( this );
  opencv.capture( width, height );                   // open video stream
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"

  println(Serial.list()); // List COM-ports (Use this to figure out which port the Arduino is connected to)

  //select first com-port from the list (change the number in the [] if your sketch fails to connect to the Arduino)
  port = new Serial(this, Serial.list()[0], 9600);   //Baud rate is set to 57600 (why this value?) to match the Arduino baud rate.

  // print usage
  println( "Drag mouse on X-axis inside this sketch window to change contrast" );
  println( "Drag mouse on Y-axis inside this sketch window to change brightness" );

  //Send the initial pan/tilt angles to the Arduino to set the device up to look straight forward.
//  port.write(tiltChannel);    //Send the Tilt Servo ID
//  port.write(servoTiltPosition);  //Send the Tilt Position (currently 90 degrees)
  port.write(panChannel);         //Send the Pan Servo ID
  port.write(servoPanPosition);   //Send the Pan Position (currently 90 degrees)

  // Intialize speech interface.
  voce.SpeechInterface.init("libraries/voce-0.9.1/lib", false, true, 
  "libraries/voce-0.9.1/lib/gram", "moose");

  // Initalize is-it-chicken-tenders-day response.
  String[] chickenCommand = {
    "./chicken-tenders"
  };
  chickenTenders = runCommand(chickenCommand);
  String [] bagelCommand = {
    "./bagel-brunch"
  };
  bagel = runCommand(bagelCommand);

  // Initialize text-to-speech for Windows.
  if (OS == 1) {
    tts = new TTS();
    tts.setPitch(400);
    tts.setPitchRange(20);
    tts.setPitchShift(-10.5);
  }
}


public void stop() {
  opencv.stop();
  super.stop();
}



void draw() {
  // grab a new frame
  // and convert to gray
  opencv.read();
  opencv.convert( GRAY );
  opencv.contrast( contrast_value );
  opencv.brightness( brightness_value );

  // proceed detection
  Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );

  // display the image
  image( opencv.image(), 0, 0 );

  // draw face area(s)
  noFill();
  stroke(255, 0, 0);
  for ( int i=0; i<faces.length; i++ ) {
    rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height );
  }

  //Find out if any faces were detected.
  if (faces.length > 0) {
    //If a face was found, find the midpoint of the first face in the frame.
    //NOTE: The .x and .y of the face rectangle corresponds to the upper left corner of the rectangle,
    //      so we manipulate these values to find the midpoint of the rectangle.
    midFaceY = faces[0].y + (faces[0].height/2);
    midFaceX = faces[0].x + (faces[0].width/2);


    //Find out if the X component of the face is to the left of the middle of the screen.
    if (midFaceX < (midScreenX - midScreenWindow)) {
      if (servoPanPosition >= 5)servoPanPosition -= stepSize; //Update the pan position variable to move the servo to the left.
    }
    //Find out if the X component of the face is to the right of the middle of the screen.
    else if (midFaceX > (midScreenX + midScreenWindow)) {
      if (servoPanPosition <= 175)servoPanPosition +=stepSize; //Update the pan position variable to move the servo to the right.
    }
  }

  //Update the servo positions by sending the serial command to the Arduino.
  port.write(panChannel);        //Send the Pan servo ID
  port.write(servoPanPosition);  //Send the updated pan position.
  print("panChannel is ");
  println(panChannel);
  print("servopanposition is ");
  println(servoPanPosition);
  delay(1);


  if (voce.SpeechInterface.getRecognizerQueueSize() > 0) {
    String s = voce.SpeechInterface.popRecognizedString();
    voce.SpeechInterface.setRecognizerEnabled(false);
    println("match = " + s);
    if (s.equals("chicken tenders false")) {
      String additionalSpeech = "";
      if (chickenTenders.equals("Yes")) {
        additionalSpeech = "it is chicken tenders day";
      } 
      else {
        additionalSpeech = "it is not chicken tenders day";
      }
      println(additionalSpeech);
      say(chickenTenders + " " + additionalSpeech);
    } 
    else if (s.equals("best college")) {
      say("Ezra Stiles of course, go fucking moose");
    } 
    else if (s.equals("jay ee") || s.equals("saybrook") || s.equals("tee dee")) {
      say("booo");
    } 
    else if (s.equals("master")) {
      say("Master Pitti");
    } 
    else if (s.equals("dean")) {
      say("Dean L");
    } 
    else if (s.equals("moose fact")) {
      say("Did you know the moose is the most amazing animal in the world?");
    } 
    else if (s.equals("bagel brunch")) {
      if (bagel.equals("Yes")) {
        say("bagel brunch today");
      } else {
        say("no bagel brunch today");
      }
    } 
    else if (s.equals("joke")) {
      say("Jokes");
    }
    else if (s.equals("weather")) {
      String[] command = {"python", "weatherscrape.py"};
      String response = runCommand(command);
      say(response);
    }
    voce.SpeechInterface.setRecognizerEnabled(true);
  }
}

void say(String speech) {
    //Update the servo positions by sending the serial command to the Arduino.
    port.write('0');      //Send the tilt servo ID
    port.write(speech.length() / 4); //Send the updated tilt position.
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
    delay(1000);
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


/**
 * Changes contrast/brigthness values
 */
void mouseDragged() {
  contrast_value   = (int) map( mouseX, 0, width, -128, 128 );
  brightness_value = (int) map( mouseY, 0, width, -128, 128 );
}

