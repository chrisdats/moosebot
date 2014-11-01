/* Sweep
 by BARRAGAN <http://barraganstudio.com> 
 This example code is in the public domain.

 modified 8 Nov 2013
 by Scott Fitzgerald
 http://arduino.cc/en/Tutorial/Sweep
*/ 

#include <Servo.h> 
 
Servo myservoBase;  // create servo object to control base servo
Servo myservoMouth; // create servo object to control mouth serv

 
int pos1 = 65;    // variable to store the servo position for base
int pos2 = 0;     // variable to store the servo position for the mouth
 
void setup() 
{ 
  myservoBase.attach(0);  // attaches the servo on pin 10 to the servo object
  myservoMouth.attach(9);  // attaches the servo on pin 9 to the servo object
} 

void talk(int gesticulations)
{
    int i;
    for (i = 0; i <= gesticulations; i++)
    {
        // Produce talking action
        for(pos2 = 70; pos2 >= 0; pos2 -= 1)
        {
            myservoMouth.write(pos2);
            delay(1);
        }
        for(pos2 = 0; pos2 <= 70; pos2 += 1)
        {
            myservoMouth.write(pos2);
            delay(1);
        }
    }
}

void loop() 
{
    for(pos1 = 25; pos1 <= 105; pos1 += 1) // goes from 0 degrees to 180 degrees 
    {                                  // in steps of 1 degree 
      myservoBase.write(pos1);              // tell servo to go to position in variable 'pos' 
      delay(30);                       // waits 15ms for the servo to reach the position 
    }
    
    talk(10);
    
    for(pos1 = 105; pos1>=25; pos1-=1)     // goes from 180 degrees to 0 degrees 
    {                                
      myservoBase.write(pos1);              // tell servo to go to position in variable 'pos' 
      delay(30);                       // waits 15ms for the servo to reach the position 
    }

    talk(10);
} 
