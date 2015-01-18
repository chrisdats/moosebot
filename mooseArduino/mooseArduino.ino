/* 
 Arduino Code for Moosebot YHack 2014
 Christopher Datsikas, Arsalan Sufi, Sam Anklesaria, Adam Cimpeanu
 Works as of 1-18-2015
 
 Based on Serial ServoControl Sketch
 Written by Ryan Owens for SparkFun Electronics
 And Sweep by BARRAGAN <http://barraganstudio.com> 
 by Scott Fitzgerald
 
 This sketch listens to serial commands and uses the data
 to set the position of two servos.

 Serial Command Structure: 2 bytes - [ID Byte][Servo Position byte]
 ID byte should be 0 for mouth servo or 1 for base servo.
 Servo position should be a value between 0 and 180.
 Invalid commands are ignored
 The servo position is not error checked.
 
 Hardware Setup
 Servos should be connected to pins 10 and 9 of the Arduino.
 External power supply is recommended for servos since 5v arduino pin cannot always source enough current for servos.
*/

#include <Servo.h> 

Servo myservoBase;  // create servo object to control base servo
Servo myservoMouth; // create servo object to control mouth servo

int posBase = 65;    // variable to store the servo position for base
int posMouth = 10;     // variable to store the servo position for the mouth

int serialByte=0; //byte that will fold data from the Serial port.
byte valBase=0; // byte for storing the value representing the 
void setup() 
{ 
  myservoBase.attach(10);  // attaches the servo on pin 10 to the servo object
  myservoMouth.attach(9);  // attaches the servo on pin 9 to the servo object
  myservoBase.write(posBase);  //Sets the initial position of the servos
  myservoMouth.write(posMouth);
  Serial.begin(9600);      // Set up serial connection at 9600 baud
} 

void loop() 
{
  while(Serial.available() <=0) {};  //Wait for a character on the serial port.
  serialByte = Serial.read();     //Copy the character from the serial port to the variable
  if(serialByte == '1'){  //Check to see if the character is the servo ID for the base servo
    while(Serial.available() <=0) {};  //Wait for the second command byte from the serial port.
    valBase=Serial.read();
    myservoBase.write(valBase);  //Set the base servo position to the value of the second command byte received on the serial port
  }
  else if(serialByte == '0'){ //Check to see if the initial serial character was the servo ID for the mouth servo.
    while(Serial.available() <= 0);  //Wait for the second command byte from the serial port.
    talk(Serial.read());   //Set the mouth servo position to the value of the second command byte received from the serial port.
  }
  //If the character is not the pan or tilt servo ID, it is ignored.
} 

//currently not used; intended for robot to scan during idle period
void scan()
{
  for(posBase = 25; posBase <= 105; posBase += 1) // goes from 0 degrees to 180 degrees 
  {                                  // in steps of 1 degree 
    myservoBase.write(posBase);              // tell servo to go to position in variable 'pos' 
    delay(30);                       // waits 15ms for the servo to reach the position 
  }
  delay(1000);
  for(posBase = 105; posBase>=25; posBase-=1)     // goes from 180 degrees to 0 degrees 
  {                                
    myservoBase.write(posBase);              // tell servo to go to position in variable 'pos' 
    delay(30);                       // waits 15ms for the servo to reach the position 
  }
  delay(1000);
}

// produces talking behavior using mouth Motor
// argument gesticulations is proportional to duration of speech
void talk(int gesticulations)
{
  int i;
  for (i = 0; i <= gesticulations; i++)
  {
    // Produce talking action
    for(posMouth = 70; posMouth >= 0; posMouth -= 1)
    {
      myservoMouth.write(posMouth);
      delay(1);
    }
    for(posMouth = 0; posMouth <= 70; posMouth += 1)
    {
      myservoMouth.write(posMouth);
      delay(1);
    }
  }
}

