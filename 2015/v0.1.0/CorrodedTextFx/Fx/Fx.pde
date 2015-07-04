import ass.object.Syl;
import ass.object.*;
import ass.util.*;

Ass ass = AssParser.parseFile("G:\\FXWorks\\Fx\\data\\凛麗.ass");
Line [] lines = ass.getLines(); 

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/117624*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//Procedural portraits
//Ale González, 2013 
PGraphics pg;


int  WIDTH   = ass.meta.width+10;
int  HEIGHT  = ass.meta.height+10;
int  MAX_AGE = 100;
int  STEPS = 1200;
int FILL = 255;
int  STROKE = -1;
int  ALFA = 75;
color  BACKGROUND = color(0,0,0,0);
float SMOOTHNESS = 0.0005f;

PVector[] DIRECTIONS;
int[][] INDICES;
ArrayList<Particle> particles;

PImage base;

void setup() {
    size(ass.meta.width, ass.meta.height);
    fill(255, ALFA);
    noStroke();
    background(BACKGROUND);
    
    //LUT to store the indices associated with the vector field
    INDICES = new int[WIDTH][HEIGHT];
    for (int y = 0; y < HEIGHT; y++) for (int x = 0; x < WIDTH; x++) INDICES[x][y] = int(noise(x*SMOOTHNESS, y*SMOOTHNESS)*STEPS); 

    //LUT to store the directions associated with the vector field
    DIRECTIONS = new PVector[STEPS];
    for (int i = 0; i < STEPS; i++) DIRECTIONS[i] = new PVector(cos(i*.5)*.05, sin(i*.5)*.05);  
    
    //Particles
    particles = new ArrayList<Particle>();
    
    //Base picture
    frameRate(23.976);
}

void draw() {
    //text("Hello",100,100);
    if(frameCount<lines[ lines.length-1 ].endTime) {
       saveFrame("lyrics\\frame####");
    }else{
       exit(); 
    }
   
    //Draw when dragging
    
    for(int li=0; li<lines.length; li++) {
      
      Line line = lines[li];
      if(frameCount==line.startTime || frameCount == line.endTime) {
        background(BACKGROUND);
      }
      
      if(frameCount>=line.startTime && frameCount < line.endTime) {
        String name = String.valueOf(li)+".png";
        base= loadImage(name);
      }
      
      for(int i=0; i<line.syls.size(); i++) {
       Syl syl = line.syls.get(i);
      //println(syl.endTime);
       if(frameCount>=syl.startTime && frameCount<syl.endTime) {
        // System.out.println(frameCount);
            float px;
            float py;
            int times = 1600/syl.dur;
            for(int j=0; j<times; j++) {
              px = random(syl.left,syl.right);
              py = random(syl.top,syl.bottom);
              particles.add(new Particle((int)px, (int)py,syl.endTime-frameCount)); 
            }
       }
      }
    }
   //if (mousePressed) particles.add(new Particle(mouseX, mouseY));     
    
    
    //Update the particles
    for(int i = 0; i < particles.size(); i++) 
    {
        Particle p = particles.get(i);
        if (p.isDead() == false) {
            p.update();
            p.draw();
        }
        else particles.remove(i);
    }
} 

class Particle
{   
    PVector pos, vel;
    int x, y, s, age;
    
  Particle(int _x_, int _y_,int _age)
  {
    x = _x_;
    y = _y_;
    pos = new PVector(x, y);
    vel = new PVector();
    age = _age;
  }
   
  boolean isDead() { return age==0; } 
    
  void draw() { ellipse(pos.x, pos.y, s, s); }  
    
  void update() 
  { 
    vel.add(DIRECTIONS[INDICES[(x+WIDTH)%WIDTH][(y+HEIGHT)%HEIGHT]]);
    pos.add(vel);
    x = int(pos.x);
    y = int(pos.y);
    s = brightness(base.get(x, y)) >> 6;
    age--;
  }   
  
  //I don't like processing's brightness method. This one is simpler and more efficient
  int brightness(int c) { 
    int r = c >> 16 & 0xFF, g = c >> 8 & 0xFF, b = c & 0xFF; 
    return c = (c = r > g ? r : g) < b ? b : c; 
  } 
}



/*
void setup(){
   size(ass.meta.width,ass.meta.height,P3D);
   frameRate(23.976);
   smooth();
}
*/

/*

void draw(){
         background(0);
         lights();
         
         Line line = lines[0];
         if(frameCount>=line.startTime && frameCount < line.midTime) {
           rotateY(map(frameCount,line.startTime,line.midTime,PI,0));
           //println(map(frameCount,line.startTime,line.endTime,-PI,0));
           //println(frameCount);
         }
         PFont font = createFont(line.styleRef.fontName,line.styleRef.fontSize);
         textFont(font);
         textAlign(CENTER,CENTER);
         fill(255);
         text(line.text,line.center,line.middle);
         
         fill(0,0,255,125);
         
        for(int i=0; i<line.chars.size(); i++) {
          Char c = line.chars.get(i);
          text(c.text,c.center,c.middle);
        }
        
        
         
  //saveFrame("#####.png");
  //println(frameCount);
}
*/
