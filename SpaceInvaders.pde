/*
    CSCI 144
    Programming Project 6: Final Project
    Lafaiet Castro and Paolla Mota
    Project title: Brazilian Invaders
*/

import ddf.minim.*;

//---------------------Global bariables----------------
int nEnemies = 30;
int liveEnemies = nEnemies;
Enemy[] enemies = new Enemy[nEnemies];
ArrayList bullets = new ArrayList();
int enemySize = 25;
int enemyW = enemySize, enemyH = enemySize;
int enemyGapX = enemySize*4/2;
int enemyGapY = enemySize*3/2; 
int pixelSize = enemySize/8;  // variable used on drawing and based on the the enemy size stipulated bellow
Player player;

int bulletW, bulletH;
int numStars = 100;
int Y1, Y2, a, b;  // Variables used for alternative coordenats
int playerW = enemyW + 10; 
int enemiesPercollum[] = new int[6];

// Adjustable variables used by the progammer at anytime (Characteristics of the gameplay):
int points = 50;
int enemySpeed = 10;  
int playerGap = 15; // Lenght of player's step
int bulletSpeed = 1;

//Used in the starryUniverse function
float[] x = new float[numStars];
float[] y = new float[numStars];
int[] opacity = new int[numStars];

//Constants:
final int RIGHTDIR  = 1;
final int LEFTDIR  = 2;
final int DOWNDIR  = 3;

final int STARTSCREEN = 1;
final int GAMESCREEN = 2;
final int GAMEOVERSCREEN = 3;
final int CREDITSCREEN = 4;

// Sound effects
AudioPlayer shootPlayer;
Minim mPlayer;//audio context

AudioPlayer expPlayer;
Minim expMPlayer;//audio context

// Musics
AudioPlayer startPlayer;
Minim startMPlayer;//audio context

AudioPlayer gamePlayer;
Minim gameMPlayer;//audio context

AudioPlayer overPlayer;
Minim overMPlayer;//audio context


int score = 0; //Current player score. Updates everytime an enemy is hit

boolean gameOver = false;
int currentScreen; // Variable used in the definition of current game screen

// Persisting highscore:
String pathToFile; // Path to the file where the highscore is stored
String maxScoreStr[]; 
int maxScore, highScore;
PrintWriter output; // used to write highscore to the file

//______________________________________________________


//CLASSES:

class MovingObj {
  int updateInterval, lastUpdate;
  int posX, posY;
  
  MovingObj(int posX, int posY, int updateInterval){
    this.updateInterval = updateInterval;
    this.lastUpdate = 0;
    this.posX = posX;
    this.posY = posY;
  }
 
  void updatePos(){
    lastUpdate = 0;
  }  

}

class Enemy extends MovingObj {
  
  int currDir;
  boolean isAlive;
  int value;
  int nSteps = 6;
  
  Enemy(int posX, int posY, int value){
    super(posX, posY, enemySpeed);
    this.isAlive = true;
    this.value = value;
    currDir = RIGHTDIR;
  }
  
  void drawShape(){ }
  
  void updatePos(boolean changeDir) {
    
    if(lastUpdate+1<updateInterval) lastUpdate++;
    
    else {
      if(currDir==RIGHTDIR) {
        if(changeDir) {
          posY+=nSteps;
          currDir = LEFTDIR;
        }
        
        else {
          posX+=nSteps;
        }
      }
      
      else {
        if(changeDir) {
          posY+=nSteps;
          currDir = RIGHTDIR;
        }
        
        else {
          posX-=nSteps;
        }
      }
      lastUpdate = 0;
    }
  }  
}

class EnemyOne extends Enemy {

    EnemyOne(int posX, int posY){
      super(posX, posY, points);
    }
    
    void drawShape(){        
        rect(posX+4*pixelSize, posY, 4*pixelSize, 1*pixelSize);
        rect(posX+1*pixelSize, posY+1*pixelSize, 10*pixelSize, 1*pixelSize);
        rect(posX, posY+2*pixelSize, 3*pixelSize, 1*pixelSize);
        rect(posX+5*pixelSize, posY+2*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+9*pixelSize, posY+2*pixelSize, 3*pixelSize, 1*pixelSize);
        rect(posX, posY+3*pixelSize, 12*pixelSize, 1*pixelSize);
        rect(posX+3*pixelSize, posY+4*pixelSize, 6*pixelSize, 1*pixelSize);
        rect(posX+3*pixelSize, posY+5*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+5*pixelSize, posY+5*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+8*pixelSize, posY+5*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+2*pixelSize, posY+6*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+8*pixelSize, posY+6*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX, posY+7*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+10*pixelSize, posY+7*pixelSize, 2*pixelSize, 1*pixelSize);
      
    }
}

class EnemyTwo extends Enemy {
    
    EnemyTwo(int posX, int posY){
      super(posX, posY, points);
    }
    
    void drawShape(){       
        rect(posX+4*pixelSize, posY, 4*pixelSize, 1*pixelSize);
        rect(posX+3*pixelSize, posY+1*pixelSize, 6*pixelSize, 1*pixelSize);
        rect(posX+2*pixelSize, posY+2*pixelSize, 8*pixelSize, 1*pixelSize);
        rect(posX+1*pixelSize, posY+3*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+5*pixelSize, posY+3*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+9*pixelSize, posY+3*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+1*pixelSize, posY+4*pixelSize, 10*pixelSize, 1*pixelSize);
        rect(posX+4*pixelSize, posY+5*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+7*pixelSize, posY+5*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+2*pixelSize, posY+6*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+5*pixelSize, posY+6*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+8*pixelSize, posY+6*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX, posY+7*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+4*pixelSize, posY+7*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+7*pixelSize, posY+7*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+10*pixelSize, posY+7*pixelSize, 2*pixelSize, 1*pixelSize);   
    }
}

class EnemyThree extends Enemy {

    EnemyThree(int posX, int posY){
      super(posX, posY, points);
    }
    
    void drawShape(){       
        rect(posX+2*pixelSize, posY, 1*pixelSize, 1*pixelSize);
        rect(posX+9*pixelSize, posY, 1*pixelSize, 1*pixelSize);
        rect(posX+3*pixelSize, posY+1*pixelSize, 1*pixelSize, 1*pixelSize);  
        rect(posX+8*pixelSize, posY+1*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+2*pixelSize, posY+2*pixelSize, 8*pixelSize, 1*pixelSize);
        rect(posX+1*pixelSize, posY+3*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+4*pixelSize, posY+3*pixelSize, 4*pixelSize, 1*pixelSize);
        rect(posX+9*pixelSize, posY+3*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX, posY+4*pixelSize, 12*pixelSize, 1*pixelSize);
        rect(posX, posY+5*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+2*pixelSize, posY+5*pixelSize, 8*pixelSize, 1*pixelSize);
        rect(posX+11*pixelSize, posY+5*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX, posY+6*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+2*pixelSize, posY+6*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+9*pixelSize, posY+6*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+11*pixelSize, posY+6*pixelSize, 1*pixelSize, 1*pixelSize);
        rect(posX+3*pixelSize, posY+7*pixelSize, 2*pixelSize, 1*pixelSize);
        rect(posX+7*pixelSize, posY+7*pixelSize, 2*pixelSize, 1*pixelSize);
    }
}

class Player extends MovingObj {
  int nLives;

  Player (int posX, int posY) {
    super(posX, posY, 0);
    this.nLives = 3;
  }
  
  void drawShape(){
    rect(this.posX, this.posY, playerW, 3*pixelSize, 3);
    rect(this.posX+pixelSize, this.posY-1*pixelSize, playerW-2*pixelSize, 2*pixelSize, 5);
    rect(this.posX+playerW/2-pixelSize, this.posY-3*pixelSize, playerW-9*pixelSize, 3*pixelSize, 7);   
  }
  
  void updatePos(int dir) {
      if(dir==RIGHTDIR && this.posX+playerGap<width) this.posX+=playerGap;
      if(dir==LEFTDIR && this.posX-playerGap>-30) this.posX-=playerGap;
  }  
}

class Bullet extends MovingObj {

  boolean hitEnemy;
  
  Bullet(int posX, int posY) {
    super(posX, posY, bulletSpeed);
    this.hitEnemy = false;
  }
  
  void drawShape() {
    rect(this.posX, this.posY, bulletW , bulletH);
  }
  
  void updatePos() {
    if(lastUpdate+1<updateInterval) lastUpdate++;
    
    else {
      posY-= 5;
      lastUpdate = 0;
    }    
  }
}

void drawScenary(){
  background(0);

  starryUniverse();
  
  // Draw separation lines:
  stroke(255);
  line(0, Y1, width, Y1);
  line(0, Y2, width, Y2);
   
  // Draw texts on screen:                 
  textSize(15);
  textAlign(CENTER, CENTER);
  text("Score: " + score, width*0.1, Y1*0.5);
  text("Lives: 1", width*0.9, Y1*0.5);
  text("Credits: 01", width*0.9, height*0.95);
  text("Player 1", width*0.1, height*0.95);
  textSize(20);
  text("High Score: " + highScore, width*0.5, Y1*0.5);
}

void starryUniverse(){
  for (int i = 0; i < 3; i++) {    // set opacity 3 stars at a time. Prevents from going too fast
    opacity[int(random(numStars))] = int(random(55, 255));
  }
  
  strokeWeight(1);
  for (int j = 0; j < numStars; j++) {
    stroke(255, opacity[j]);
    point(x[j], y[j]);
  }
}


void keyPressed() {

  if(keyCode == LEFT) {
    player.updatePos(LEFTDIR); 
  }

  if(keyCode == RIGHT){
   player.updatePos(RIGHTDIR); 
  }
  
  if(key == ' ' && currentScreen == GAMESCREEN) { // Shoot bullet. Don't allow to shoot in the first screen
    if (bullets.size()>2) return;
       
    bullets.add(new Bullet(player.posX+(enemyW+10)/2, player.posY-15));
    shootPlayer.rewind();
    shootPlayer.play();
  }
  
  int m = millis(); // function millis gets the current time of rolling
  
  if(m > 5000 && currentScreen == STARTSCREEN && keyCode== ENTER) { // Don' allow the player to press start before the instruction says so
   currentScreen = GAMESCREEN; 
   startPlayer.pause();
   gamePlayer.play();
  }
}


boolean edgeHit() {
  if(enemies[0].currDir==LEFTDIR) {
    int edge = getLeftEdge();
    return enemies[edge].posX<4;
  }
  
  else if(enemies[0].currDir==RIGHTDIR) {
    int edge = getRightEdge();
    return enemies[edge].posX>width-40;
  }
  return false;
}

int getCollumNumber(int index){ 
  index++;
  if(index%6==0) return 5;
  return (index%6-1);
}

int getLeftEdge() {
  int edge = 0;
  while(edge<=5 && enemiesPercollum[edge]==0) edge++;
  return edge;
}


int getRightEdge() {
  int edge = 5;
  while(edge>=0 && enemiesPercollum[edge]==0) edge--;
  return edge;
}


void updateHighScore() {
  output = createWriter(pathToFile); 
  output.println(highScore); // Write High score to file
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}

// SCREENS:
void gameOverScreen() {
  background(0);
  textSize(60);
  text("GAME OVER", width/2, height/2);
  return;
}

void creditsScreen(){
  
  //starryUniverse();
  background(0);
  PFont myFont;
  String str = "CONGRATULATIONS!\n YOU WON!\n\nBrazilian Invaders\n\nMade by:\nLafaiet Castro and Paolla Mota\n\nCSCI 144: Intro to Multimedia\n\nProfessor:\nDr. Michael Goldwasser";
  myFont = createFont("Skia-Regular_Black-Extended", 20);
  textFont(myFont);
  textAlign(CENTER);
  
  background(0);
  fill(255);
  text(str, a, b);
  b--;
  
}

void startScreen(){
  startPlayer.play();
  background(0);

  starryUniverse();

  PFont myFont;

  textAlign(CENTER, CENTER);
  String title1 = "Brazilian"; 
  String title2 = "Invaders";

  myFont = createFont("Skia-Regular_Black-Extended", 60);
  textFont(myFont);
  int m = millis();
  
  if (m > 1000) {
    
    // TITLE:
    int x = int(width*0.30);
    textAlign(CENTER);
    for (int i = 0; i < title1.length(); i++) {
      if (i%2 == 0) {
        fill(255, 255, 0);
        text(title1.charAt(i), x, height*0.3);
        // textWidth() spaces the characters out properly.
      } else {
        fill(0, 255, 0);
        text(title1.charAt(i), x, height*0.3);
      }
      x += textWidth(title1.charAt(i));
    }
    
    x = int(width*0.29);
    textAlign(CENTER);
    for (int i = 0; i < title2.length(); i++) {
      if (i%2 == 0) {
        fill(255, 255, 0);
        text(title2.charAt(i), x, height*0.45);
        // textWidth() spaces the characters out properly.
      } else {
        fill(0, 255, 0);
        text(title2.charAt(i), x, height*0.45);
      }
      x += textWidth(title2.charAt(i));  
    }    

    //NEW GAME:
    if (m>3400) {
      fill(255);
      textSize(25);
      m = millis();
      fill(m % 800);
      text("Press ENTER to start", width/2, height*0.6);
    }  

    // INSTRUCTIONS:
    if (m>4000) {
      fill(255);
      textSize(13);
      textAlign(LEFT);
      text("Commands:\n< >: Move spaceship\nSPACE: Shoot", width*0.1, height*0.8);
    }
  }
}

// SETUP FUNCTION

void setup() {
  
  //Initializes all SFX:
  mPlayer = new Minim(this);
  shootPlayer = mPlayer.loadFile("sounds/shoot.mp3", 2048);
  
  expMPlayer = new Minim(this);
  expPlayer = expMPlayer.loadFile("sounds/explosion.mp3", 2048);
  
  startMPlayer = new Minim(this);
  startPlayer = startMPlayer.loadFile("sounds/danger_zone.mp3", 2048);
  
  gameMPlayer = new Minim(this);
  gamePlayer = startMPlayer.loadFile("sounds/black_hole.mp3", 2048);
  
  overMPlayer = new Minim(this);
  overPlayer = overMPlayer.loadFile("sounds/ominous_sounds.mp3", 2048);
  
  //Initializes highscore:
  pathToFile = "maxScorePersist.txt";
  maxScoreStr =  loadStrings(pathToFile);
  maxScore = int(maxScoreStr[0]);
  highScore = maxScore;
  
  //Initializes current screen:
  currentScreen = STARTSCREEN;
  
  //Screen dimensions definition:
  size(500, 500); 
  Y1 = int(0.1*height);
  Y2 = int(height*0.9);
  
  a = width/2;
  b = height;
  
  // Instantiating moving objects:
  player = new Player(width/2,int(height-.2*height));
  bulletW = int(width*.010);
  bulletH = int(height*.010);
  
  //Initializes stars and draws them at random places:
  for (int i = 0; i < numStars; i++) {
    x[i] = random(width);
    y[i] = random(Y1, Y2); 
    opacity[i] = int(random(55, 255));
  }
  
  //Instantiating and drawing enemies:
  int eIndex = 0;
  
  for(int i = 2; i< 7; i++){
    for(int j = 0; j<6; j++){
      if(i==2) {
        EnemyOne en = new EnemyOne(j*enemyGapX,i*enemyGapY);
        enemies[eIndex++] = en;
      }
      else if(i > 2 && i < 5){
        EnemyTwo en = new EnemyTwo(j*enemyGapX,i*enemyGapY);
        enemies[eIndex++] = en;        
      }
      else {
        EnemyThree en = new EnemyThree(j*enemyGapX,i*enemyGapY);
        enemies[eIndex++] = en;      
      }    
    }
  }
  
  for(int i= 0 ; i<6 ; i++) enemiesPercollum[i] = 5;  // used to find the number of enemies per collum

}


// DRAW FUNCTION

void draw() {
  drawScenary(); 
  if(currentScreen==STARTSCREEN) {
    startScreen();
    return;
  }
 
  if(currentScreen==GAMEOVERSCREEN) { 
   gameOverScreen();
   return;
  } 
  
  if(currentScreen ==CREDITSCREEN) {
    creditsScreen();
    return;
  }
    
  for(int i=0; i<nEnemies; i++){
    if (enemies[i].isAlive) {
      if(enemies[i].posY > int(height*0.78)-25) {   // enemy reached the player
         currentScreen = GAMEOVERSCREEN;
          updateHighScore();
           gamePlayer.pause();
           overPlayer.play();
         return;         
      }
      enemies[i].drawShape();
    }
  }
  
  player.drawShape();
  
  for (int i = 0 ; i < bullets.size() ; i++){
    Bullet bl  = (Bullet)bullets.get(i); 
    bl.drawShape();
    
    // Checks if any bullet hits an enemy:
    for(int j=0; j<nEnemies;j++){
      if (enemies[j].isAlive) {
        if(bl.posX < enemies[j].posX+enemySize && bl.posX > enemies[j].posX) {
          if(bl.posY < enemies[j].posY) { // Enemy Down!
            expPlayer.rewind();
            expPlayer.play();
            bl.hitEnemy = true;
            enemies[j].isAlive = false;
            enemiesPercollum[getCollumNumber(j)]--;
            
            score+=enemies[j].value;
            if(score>highScore) highScore = score;
            
            liveEnemies--;
            if(liveEnemies==0) {  // Player killed all enemies
              currentScreen = CREDITSCREEN;
               updateHighScore();
               gamePlayer.pause();
               overPlayer.play();
              return;         
            }
          } 
        }
      }
    }
  }
  
  //Removing bullets that hit enemies 
  //or that have crossed the screen upper limit
  
  int index = 0;
  for (int i = 0; i< bullets.size();i++) {
    Bullet bl  = (Bullet)bullets.get(index); 
   
    
    if(bl.hitEnemy || bl.posY < Y1+10) {
      bullets.remove(index);
    }
  
    else {
      index++;
      bl.updatePos();
    }
  }

  // Updating enemies position
  boolean changeDir = edgeHit();
  
  for(int i = 0; i<nEnemies; i++ ) {
    enemies[i].updatePos(changeDir);
  }   
}
