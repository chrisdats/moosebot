//import the two libraries
import guru.ttslib.*;
import processing.serial.*;
//give our instances names
TTS tts;

//a default message
String message = "Ho Ho Ho";
String articulation = "111546";

void setup() {
  tts = new TTS();
  //the following settings control the voice sound
  tts.setPitch( 200 );
  tts.setPitchRange( 20 );
  tts.setPitchShift( -10.5 );

}

void draw() {
}

void mousePressed() {
  tts.speak(message);  //speak the message string
 
}

void keyPressed(){
  //the following changes the message and the articulation when we press the number keys
if(key=='1'){
   articulation = "111546";
   message = "Ho Ho Ho";
}
if(key=='2'){
   articulation = "225546";
  message = "Merry Christmas!!";
}
if(key=='3'){
   articulation = "1112546";
  message = "Have you been naughty";
}
if(key=='4'){
   articulation = "225546";
  message = "Bah humbug!";
}
if(key=='5'){
   articulation = "2246";
  message = "What do you want?";
}
if(key=='6'){
   articulation = "26157262756373564";
  message = "I wanna wish you! a Merrrrrry Christmas!";
}
if(key=='7'){
   articulation = "215363736373546";
  message = "Jingle Bells!";
}

}
