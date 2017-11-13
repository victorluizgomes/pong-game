/*
 * Author: Victor Gomes
 * Description: A high paced simple game of pong. 
 *              Left paddle (Red) is controlled with W and S.
 *              Right paddle (Blue) is controlled with UP arrow and DOWN arrow.
 *              The game starts when User clicks on screen and the game ends with
 *              the first side to make 3 points.
 *              Game can be restarted by clicking on the screen at the end.
 */
 
// Creates variables for ball and paddle positions and speed.
int ballX, ballY, ballW, ballH, speedX, speedY;
int leftPaddleX, leftPaddleY, paddleW, paddleH, paddleS;
int rightPaddleX, rightPaddleY;

// Creates boolean variables to keep track of keys being pressed
boolean upL, downL;
boolean upR, downR;

// Creates a start variable
boolean start = true;

// Variables for the current score of left and right paddles
int scoreL, scoreR; 

// Sets the score to win to 3
int winScore = 3;

void setup() {
  size(500, 500);
  
  // Starts the ball at the middle of the canvas
  ballX = 500/2; 
  ballY = 500/2;
  ballW = 25;
  ballH = 25;
  
  // Used to center width and height of the text (Instead of anoying bottom-left)
  textAlign(CENTER, CENTER); 
  textSize(30);
  
  // Sets the paddle variables, speed and placements
  paddleW = 12;
  paddleH = 50;
  paddleS = 6;
  leftPaddleX = 40;
  leftPaddleY = 500/2 - paddleH/2;
  rightPaddleX = 500-40 - paddleW;
  rightPaddleY = 500/2 - paddleH/2; 
}

void draw() {
  background(60);
  drawBall();
  moveBall();
  bounceBall();
  drawPaddles();
  movePaddle();
  paddleWallCollision();
  ballPaddleCollision();
  scores();
  if (start) {
    startGamePage("Click to Start");
  }
  gameOver();
}

// Prints the scores to the canvas
void scores() {
  fill(255);
  text(scoreL, 100, 50);
  text(scoreR, 500-100, 50);
}

// Draws both paddles
void drawPaddles() {
  // left Red paddle
  fill(255, 0, 0);
  rect(leftPaddleX, leftPaddleY, paddleW, paddleH);
  
  // right Blue paddle
  fill(0, 0, 255);
  rect(rightPaddleX, rightPaddleY, paddleW, paddleH);
}

// Draws the ball
void drawBall() {
  fill(0, 255, 0);
  ellipse(ballX, ballY, ballW, ballH);
}

// Allows for the ball to be constantly moving
void moveBall() {  
  ballX = ballX + speedX*2;
  ballY = ballY + speedY*2;
}

// Restricts the paddles from going out of the canvas 
void paddleWallCollision() {
  // Checks left paddle's collision with top
  if (leftPaddleY < 0) {
    leftPaddleY = leftPaddleY + paddleS;
  }
  // Checks left paddle's collision with bottom
  if (leftPaddleY + paddleH > 500) {
    leftPaddleY = leftPaddleY - paddleS;
  }
  
  // Checks right paddle's collision with top
  if (rightPaddleY < 0) {
    rightPaddleY = rightPaddleY + paddleS;
  }
  // Checks right paddle's collision with bottom
  if (rightPaddleY + paddleH > 500) {
    rightPaddleY = rightPaddleY - paddleS;
  }
}

// Checks for the collision of the ball on the paddles
void ballPaddleCollision() {
  
  // Checks for collision on left paddle
  if (ballX - ballW/2 < leftPaddleX + paddleW && 
  ballY - ballH/2 < leftPaddleY + paddleH && ballY + ballH/2 > leftPaddleY - 5 ) {
    // Changes direction of the speed
    if (speedX < 0) {
      speedX = -speedX*1;
    }
    
  // Checks for collision on right paddle
  } else if (ballX + ballW/2 > rightPaddleX && 
  ballY - ballH/2 < rightPaddleY + paddleH && ballY + ballH/2 > rightPaddleY - 5) {
    // Changes direction of the speed
    if (speedX > 0) {
      speedX = -speedX*1;
    }
  }
}

// Checks for ball bounces
void bounceBall() {
  // Check if left paddle scored
  if ( ballX > 495 - ballW/2) {
    setup();
    speedX = -speedX;
    scoreL = scoreL + 1;
  // Check if right paddle scored
  } else if ( ballX < 5 + ballW/2) {
    setup();
    scoreR = scoreR + 1;
  }
  
  // Bounces ball from top and bottom of canvas
  if ( ballY > 500 - ballH/2) {
    speedY = -speedY;
  } else if ( ballY < 0 + ballH/2) {
    speedY = -speedY;
  }
}

// Makes a start of game page that stops ball from moving 
// and waits for user to click to start game
void startGamePage(String text) {
  speedX = 0;
  speedY = 0;
  fill(255);
  text(text, 500/2, 500/3);
  if (mousePressed) {
    // Sets the scores to 0
    scoreR = 0;
    scoreL = 0;
    
    // Sets the speed back to 2
    speedX = 2;
    speedY = 2;
    start = false;
  }
}

// Makes a Game Over page that stops ball from moving, shows who won
// and waits for user to click to start game again.
void gameOverPage(String text, boolean redWin) {
  speedX = 0;
  speedY = 0;
  fill(255);
  text("Game over", 500/2, 500/3 - 40);
  text("Click to play again", 500/2, 500/3 + 40);
  // Sets the color of the text depending on who won
  if(redWin) {
    fill(255, 0, 0);
  } else {
    fill(0, 0, 255);
  }
  text(text, 500/2, 500/3);
  
  if (mousePressed) {
    // Sets the scores to 0
    scoreR = 0;
    scoreL = 0;
    
    // Sets the speed back to 2
    speedX = 2;
    speedY = 2;
  }
}

// Checks if either the left or right side won
void gameOver() {
  if (scoreL == winScore) {
    gameOverPage("Red wins!", true);
  }
  if (scoreR == winScore) {
    gameOverPage("Blue wins!", false);
  }
}

// Uses key presses and boolean variables to set the movement of the paddles.
// By using keyPressed() and keyReleased() the paddles move smoothly
void movePaddle() {
  if (upL) {
    leftPaddleY = leftPaddleY - paddleS;
  }
  if (downL) {
    leftPaddleY = leftPaddleY + paddleS;
  }
  if (upR) {
    rightPaddleY = rightPaddleY - paddleS;
  }
  if (downR) {
    rightPaddleY = rightPaddleY + paddleS;
  }
}

// Checks for the key presses of W, S, UP or DOWN
void keyPressed() {
  if (key == 'w') {
    upL = true;
  }
  if (key == 's') {
    downL = true;
  }
  if (keyCode == UP) {
    upR = true;
  }
  if (keyCode == DOWN) {
    downR = true;
  }
}

// Checks for when the keys were Released
void keyReleased() {
  if (key == 'w') {
    upL = false;
  }
  if (key == 's') {
    downL = false;
  }
  if (keyCode == UP) {
    upR = false;
  }
  if (keyCode == DOWN) {
    downR = false;
  }
}