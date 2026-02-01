//when in doubt, consult the Processsing reference: https://processing.org/reference/

//Importing some useful packages
import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

//Setting up a bunch of global variables
int margin = 200; //set the margin around the squares
final int padding = 50; // padding between buttons and also their width/height
final int buttonSize = 40; // padding between buttons and also their width/height
ArrayList<Integer> trials = new ArrayList<Integer>(); //contains the order of buttons that activate in the user study
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
int hits = 0; //number of successful clicks
int misses = 0; //number of missed clicks
Robot robot; //initialized in setup

int notJumpFrames = 0;

// NEW EDIT 1/21
/*New Features*/
boolean snapToCenter = false;
boolean greenHighlight = true;
boolean clickNear = true;
boolean redDot = true;
boolean loop = false;
boolean snapNear = false;
boolean verticalSnap = false;
boolean bigJump = false; // Do not use this feature, it does not work!!!
boolean brightColor = true;
boolean horizGuideLine = false;
boolean vertiGuideLine = false;
boolean nextPreview = true;
boolean spaceToClick = true;
/*New Features*/

/*Prof. Harrison's
boolean snapToCenter = false;
boolean greenHighlight = false;
boolean clickNear = false;
boolean redDot = true;
boolean loop = false;
boolean snapNear = false;
boolean verticalSnap = false;
boolean bigJump = false; // Do not use this feature, it does not work!!!
boolean brightColor = false;
boolean horizGuideLine = false;
boolean vertiGuideLine = false;
boolean nextPreview = false;
boolean spaceToClick = false;
/*Prof. Harrison's*/

<<<<<<< HEAD
int numRepeats = 20; //sets the number of times each button repeats in the user study. 1 = each square will appear as the target once.
=======
int numRepeats = 5; //sets the number of times each button repeats in the user study. 1 = each square will appear as the target once.
>>>>>>> 8c15a6af976e26ed4d5693cfe7c4a9ec840f8ceb

void setup()
{
  size(700, 700); // set the size of the window
  //noCursor(); //hides the system cursor if you want
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  textFont(createFont("Arial", 16)); //sets the font to Arial size 16
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT! By default, rectangles are drawn from their upper left corner. )
  //rectMode(CENTER); //enabling will break the scaffold code, but you might find it easier to work with centered rects

 //optional code below. This creates a "Java Robot" class that can move the system cursor.
  try {
    robot = new Robot(); 
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }

  //===DON'T MODIFY MY RANDOM ORDERING CODE==
  //generate list of targets and randomize the order
  for (int i = 0; i < 16; i++) //loop for the number of buttons in 4x4 grid (i.e., 16)
    for (int k = 0; k < numRepeats; k++) //loop for the number of times each button repeats. Scaffold code default is 1, but it will be higher in the actual bakeoff.
      trials.add(i);
  Collections.shuffle(trials); //randomize the order of the targets
  System.out.println("trial order: " + trials); //print out the target list for debugging
  
  surface.setLocation(0,0);// put window in top left corner of screen (doesn't always work)
  
  //NEW EDIT 1/22
  int centerX = width/2 + 5;
  int centerY = height/2 + 70;
  robot.mouseMove(centerX, centerY); 
  
}


void draw()
{
  background(0); //black out the window each time we draw.
  noStroke();
  fill(255); //set fill color to white

  if (trialNum >= trials.size()) //check to see if user study is over
  {
    float timeTaken = (finishTime-startTime) / 1000f;
    float penalty = constrain(((95f-((float)hits*100f/(float)(hits+misses)))*.2f),0,100);
    
    //writes to the screen (not console)
    text("Finished!", width / 2, height / 2); 
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + timeTaken + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + nf((timeTaken)/(float)(hits+misses),0,3) + " sec", width / 2, height / 2 + 100);
    text("Average time for each button + penalty: " + nf(((timeTaken)/(float)(hits+misses) + penalty),0,3) + " sec", width / 2, height / 2 + 140);
    return; //return, nothing else to do now experiment is over
  }

  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on
  
  if (clickNear) {
    text("CLICK ON A SQUARE OR NEAR A SQUARE TO CHOOSE IT", 240, 40);
}

  if (verticalSnap) {
    text("Press keys 1-4 to move to a vertical column.", 180, 60);
    for (int i = 1; i < 5; i++) {
      text(str(i), margin+buttonSize/2 + (i-1)*(padding+buttonSize), 190);
    }
  }

  for (int i = 0; i < 16; i++)// for all buttons
    drawButton(i); //draw button
  // NEW EDIT 1/20
  
  if (bigJump) {
    if (notJumpFrames >= 20 && sqrt(pow(mouseX - pmouseX,2) + pow(mouseY - pmouseY,2)) > 20){
      int oldx = ((mouseX - margin + padding/2) / (padding + buttonSize));
      int oldy = ((mouseY - margin + padding/2) / (padding + buttonSize));
      int xnow = oldx;
      int ynow = oldy;
      float angle = atan2((float) mouseY - pmouseY, (float) mouseX - pmouseX);
      int roundedAngle = (int) ((angle / QUARTER_PI)+0.5);
      if (angle == 0 && oldx < 3) {
        xnow += 1;
      } else if (angle == 1 && oldx < 3 && oldy < 3) {
        xnow += 1;
        ynow += 1;
      } else if (angle == 2 && oldy < 3) {
        ynow += 1;
      } else if (angle == 3 && oldx > 0 && oldy < 3) {
        xnow -= 1;
        ynow += 1;
      } else if (angle == 4 && oldx > 0) {
        xnow -= 1;
      } else if (angle == -3 && oldx > 0 && oldy > 0) {
        xnow -= 1;
        ynow -= 1;
      } else if (angle == -2 && oldy > 0) {
        ynow -= 1;
      } else if (angle == -1 && oldx < 3  && oldy > 0) {
        xnow += 1;
        ynow -= 1;
      }
      System.out.println("(" + notJumpFrames + ") The mouse moved away from (" + oldx + ", " + oldy + ") at an angle " + roundedAngle + " times pi/4 and moved to (" + xnow + ", " + ynow + ")");
      robot.mouseMove(margin + (padding+buttonSize)/2 + xnow * (padding + buttonSize), margin + (padding+buttonSize)/2 + ynow * (padding + buttonSize));
      notJumpFrames = 0;
    } else if (notJumpFrames < 20) {
      notJumpFrames++;
      fill(255, 235, 0, 200); // set fill color to translucent yellow
      ellipse(mouseX, mouseY, 20, 20); //draw user cursor as a circle with a diameter of 20
    }
  }
  
  if (redDot) {
    fill(255, 0, 0, 200); // set fill color to translucent red
    ellipse(mouseX, mouseY, 20, 20); //draw user cursor as a circle with a diameter of 20
  }
  
  // NEW EDIT 1/20
  for (int i = 1; i < 4; i = i+1) {
    strokeWeight(4);
    stroke(70);
    line(margin - padding/2 + i * (buttonSize + padding), margin - 20, margin - padding/2 + i * (buttonSize + padding), height - margin + 30);
    line(margin - padding/2, margin - padding/2 + i * (buttonSize + padding), width - margin + 30, margin - padding/2 + i * (buttonSize + padding));
  }
  
  if (horizGuideLine) {
    strokeWeight(12);
    stroke(255, 0, 0, 200);
    line(margin - padding/2, mouseY, width - margin + padding/2, mouseY);
  }
  if (vertiGuideLine) {
    strokeWeight(12);
    stroke(255, 0, 0, 200);
    line(mouseX, margin - padding/2, mouseX, width - margin + padding/2);
  }
  
  noStroke();
  
  int tolerance = 30;
  if (loop && !mousePressed && (mouseX < margin - tolerance - (padding / 2))) {
    robot.mouseMove(width + (padding / 2) - margin, mouseY);
  } else if (loop && !mousePressed && (mouseX > width + tolerance + (padding / 2) - margin)) {
    robot.mouseMove(margin + (padding/2), mouseY);
  }
  if (loop && !mousePressed && (mouseY < margin - tolerance - (padding / 2))) {
    robot.mouseMove(mouseX, height + (padding / 2) - margin);
  } else if (loop && !mousePressed && (mouseY > height + tolerance + (padding / 2) - margin)) {
    robot.mouseMove(mouseX, margin + (padding/2));
  }
  
}

//OUTPUT VARIABLES:
int participantID = 1; // We can do Zoey: 1 and Josiah: 2 -- change based on whose testing
int startMouseX;
int startMouseY;
float time;
int successOrFail;


void mousePressed() //mouse was pressed! Test to see if hit was in target!
{
  
  if (trialNum >= trials.size()) //if task is over, just return
    return;

  if (trialNum == 0) //check if first click, if so, start timer
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    
    println("we're done!"); //write to terminal some output. Useful for debugging too.
  }

  Rectangle bounds = getButtonLocation(trials.get(trialNum));


 //check to see if mouse cursor is inside target button 
 
  if ((clickNear && (mouseX > bounds.x - padding/2 && mouseX < bounds.x + bounds.width + padding/2) && (mouseY > bounds.y - padding/2 && mouseY < bounds.y + bounds.height + padding/2))
    || (mouseX > bounds.x && mouseX < bounds.x + bounds.width) && (mouseY > bounds.y && mouseY < bounds.y + bounds.height)) // test to see if hit was within bounds
  {
    //System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hits++; 
    successOrFail = 1;
    
  } 
  else //must be a miss...
  {
    //System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
    successOrFail = 0;
  }

  trialNum++; //doesn't matter if user hit or missed, we move onto next trial

  //in the example code below, we can use Java Robot to move the mouse back to the middle of window
  // NEW EDIT 1/21
  // Note: I hardcoded the 10 and 30. For some reason, the Robot was off-center by 10 and 30. It was really annoying!
  if (snapToCenter) {
    robot.mouseMove(width/2 + 10, (height)/2+30);
  }
  //robot.mouseMove(width/2, (height)/2); //on click, move cursor to roughly center of window!
  //robot.mouseMove(margin - padding/2 + 2 * (buttonSize + padding), margin - padding/2 + 2 * (buttonSize + padding));

  // OUTPUT PRINT STATEMENT
  
  // set the mouse position at be center of screen for trial 0
  if (trialNum == 0) {
    startMouseX = width/2 + 5;
    startMouseY = height/2 + 70;
  }

  int targetX = (bounds.x+bounds.width/2); // x position of center of target
  int targetY = (bounds.y+bounds.height/2); // y position of center of target
  int dx = abs(mouseX - targetX);
  int dy = abs(mouseY - targetY);
  double distance = Math.sqrt(dx*dx + dy*dy);
  int intDistance = (int) distance;
  
  if (trialNum == 0) {
    time = 0;
  }
  int timeAfterClick = millis();
  time = (timeAfterClick - time)*0.001;
  
  float roundedTime = (float) Math.round(time * 1000) / 1000.0f;

  int[] items = {trialNum, participantID, startMouseX, startMouseY, targetX, targetY, intDistance};
  for (int i = 0; i < items.length-2; i++) {
    print(items[i]);
    print(',');
  }
  print(roundedTime);
  print(',');
  print(successOrFail);
  println("");
  
  if (trialNum != 0) { // set mouse position at start of trial to mouse position of last click
    startMouseX = mouseX;
    startMouseY = mouseY;
  }
 
}  

//probably shouldn't have to edit this method
Rectangle getButtonLocation(int i) //for a given button index, what is its location and size
{
   int x = (i % 4) * (padding + buttonSize) + margin;
   int y = (i / 4) * (padding + buttonSize) + margin;
   return new Rectangle(x, y, buttonSize, buttonSize);
}

//you can edit this method to change how buttons appear if you wish. 
void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);

  // NEW EDIT 1/21
  if (greenHighlight && (mouseX > bounds.x - padding/2 && mouseX < bounds.x + bounds.width + padding/2) && (mouseY > bounds.y - padding/2 && mouseY < bounds.y + bounds.height + padding/2)) // test to see if hit was within bounds
  {
    fill(0, 80, 0); // dark green
    rect(bounds.x - padding / 4, bounds.y - padding / 4, bounds.width + padding / 2, bounds.height + padding / 2);
    //fill(0, 0, 0); // black
    //rect(bounds.x - padding / 8, bounds.y - padding / 8, bounds.width + padding / 4, bounds.height + padding / 4);
  }

  if (trials.get(trialNum) == i) { // see if current button is the target
    if (brightColor) {
      fill(255, 200, 0); // fill orange
    } else {
      fill(0, 255, 255); // if so, fill cyan
    }
    rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
  } else if (nextPreview && trialNum < trials.size() - 1 && trials.get(trialNum + 1) == i) {
    if (brightColor) {
      fill(160, 145, 120); // fill dim orange
    } else {
      fill(150, 200, 200); // if so, fill dim cyan
    }
    rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
    fill(0);
    text("next", bounds.x + bounds.width / 2, bounds.y + bounds.height / 2);
  } else {
    fill(200); // if not, fill gray
    rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
  }

}


// NEW EDIT 1/22 

boolean onButton = false;
int currX = 0;
int currY = 0;

void checkOnButton(int mouseX, int mouseY) {
  for (int i = 0; i < 16; i++) {
    Rectangle bounds = getButtonLocation(i);
    if ((bounds.x < mouseX && mouseX < bounds.x + buttonSize) &&
        (bounds.y < mouseY && mouseY < bounds.y + buttonSize)) {
      onButton = true;
      currX = bounds.x + buttonSize/2;
      currY = bounds.y + buttonSize/2;
      break;
    } else {
      onButton = false;
    }
  }
}

void mouseMoved()
{
   //can do stuff everytime the mouse is moved (i.e., not clicked)
   //https://processing.org/reference/mouseMoved_.html
   // tried to snap to the nearest button based on direction but I couldn't figure it out...
   //checkOnButton(mouseX, mouseY);
   //if (onButton == true) { 
   //  dx = mouseX - currX;
   //  dy = mouseY - currY;
     
   //  if (dx > 0 && dy < 0) {
   //    robot.mouseMove(mouseX+80, mouseY-20);
   //  } else if (dx > 0 && dy > 0) {
   //    robot.mouseMove(mouseX+80, mouseY+140);
     //} else if (dx < 0 && dy < 0) {
     //  robot.mouseMove(mouseX-80, mouseY-20);
     //} else if (dx < 0 && dy > 0) {
     //  robot.mouseMove(mouseX-80, mouseY+140);
     //}
     
}

void mouseDragged()
{
  //can do stuff everytime the mouse is dragged
  //https://processing.org/reference/mouseDragged_.html
}


int bestX = 0;
int bestY = 0;
int dx = 0;
int dy = 0;

void findNearestButton(int mouseX, int mouseY)
{
  int smallestX = 100000;
  int smallestY = 100000;
  for (int i = 0; i < 16; i++) {
    Rectangle bounds = getButtonLocation(i);
    //print("boundsX: " + bounds.x + "    ");
    //print("mouseX: " + mouseX + "    ");
    
    int centerX = bounds.x + buttonSize/2;
    int centerY = bounds.y + buttonSize/2;
    dx = mouseX - centerX;
    dy = mouseY - centerY;
    int distance = abs(dx) + abs(dy);
    int smallestDistance = abs(smallestX) + abs(smallestY);
    if (distance < smallestDistance) {
      smallestX = dx;
      smallestY = dy;
      bestX = centerX;
      bestY = centerY+65;
    }
  }
}

void keyPressed() 
{
 
  //can use the keyboard if you wish
  //https://processing.org/reference/keyTyped_.html
  //https://processing.org/reference/keyCode.html
  if ((key == 'l' || key == 'L')) {
    loop = false;
    bigJump = false;
  }
  
  if (key == ' ' && spaceToClick) {
    System.out.println("Spacebar");
    mousePressed();
  }

//NEW EDIT 1/22

  if (verticalSnap == true) {
    if (key == '1' || key == '2' || key == '3' || key == '4') {
      int column = (int(key)-49); // for some reason, you need to subtract 49
      robot.mouseMove(margin + buttonSize/2 + column * (padding+buttonSize), mouseY+66);
    }
  }
   



//Snap to nearest square feature by pressing a
 
 //checkOnButton(mouseX, mouseY);
 //checkOnButton(mouseX, mouseY);
 //print("terminate:" + terminate + "    ");
  if (snapNear == true && (key == 'a') || (key == 'A')) {
    findNearestButton(mouseX, mouseY);
    robot.mouseMove(bestX, bestY);
    
    // other attempts to snap to nearest square
    //int centerX = width/2 + 5;
    //int centerY = height/2 + 70;
    //int startX = mouseX;
    //int startY = mouseY;
    //int differenceX = mouseX - centerX; 
    //int differenceY = mouseY - centerY;
    //int dx = 0;
    //int dy = 0;
    //
    //checkOnButton(mouseX, mouseY);
    //if (terminate == false) {
    //count++;
    //print(mouseY);
    //robot.mouseMove(mouseX + dx*30, mouseY + dy*30);
    //terminate = true;
    // //break;
    //} 
    // //terminate = true;
    
  }
}
