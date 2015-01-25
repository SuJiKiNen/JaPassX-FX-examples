import ass.object.*;
import ass.util.*;

import geomerative.*;

ASS ass;
ASS furiAss;
ASS sylAss;
Line [] lines;
Line [] furiLines;
Line [] sylLines;
RShape [] shapes;
RShape [] furiShapes;
RShape [] sylShapes;

RPoint [][] points;
RPoint [][] furiPoints;
RPoint [][] sylPoints;

RFont rfont;
int splitNums = 8000;
int furiSplitNums = 800;
int sylSplitNums = 1600;

int fxDur = 8;// frame unit 

void setup(){
  smooth();
  
  ass = ASSParser.parseFile(dataPath("natsu.ass"),29.970);
  furiAss = ASSParser.parseFile(dataPath("natsu-furigana.ass"),29.970);
  sylAss = ASSParser.parseFile(dataPath("natsu-syl-hilight.ass"),29.970);
  
  lines = ass.getLines();
  furiLines = furiAss.getLines();
  sylLines = sylAss.getLines();
  
  Time.shift(lines,-lines[0].time.start+1);
  Time.shift(furiLines,-furiLines[0].time.start+1);
  Time.shift(sylLines,-sylLines[0].time.start+1);
  
  lines = TextUnits.filterBlank(lines);
  furiLines = TextUnits.filterBlank(furiLines);
  sylLines = TextUnits.filterBlank(sylLines);
  
  size(ass.meta.width,ass.meta.height);
  frameRate(ass.meta.frameRate);
  
  float step = (1.0/splitNums);
  points = new RPoint[lines.length][splitNums];
  shapes = new RShape[ lines.length ];
  RG.init(this);
  rfont = new RFont(dataPath("EPMGOBLD.TTF"),lines[0].styleRef.fontSize,CENTER);
  for(int i=0; i<lines.length; i++) {
     shapes[i] = rfont.toShape(lines[i].text);
     for(int j=0; j<splitNums; j++) {
       points[i][j] = shapes[i].getPoint(j*step);
     }
  }
  
  step = (1.0/furiSplitNums);
  furiPoints = new RPoint[ furiLines.length ][ furiSplitNums ];
  furiShapes = new RShape[ furiLines.length ];
  RFont furiFont = new RFont(dataPath("EPMGOBLD.TTF"),furiLines[0].styleRef.fontSize,CENTER);
  for(int i=0; i<furiLines.length; i++) {
     furiShapes[i] = furiFont.toShape(furiLines[i].text);
     for(int j=0; j<furiSplitNums; j++) {
       furiPoints[i][j] = furiShapes[i].getPoint(j*step);
     }
  }  
  
  step =(1.0/sylSplitNums);
  sylPoints = new RPoint[ sylLines.length ][ sylSplitNums ];
  sylShapes = new RShape[ sylLines.length ];
  RFont sylFont = new RFont(dataPath("EPMGOBLD.TTF"),sylLines[0].styleRef.fontSize,CENTER);
  for(int i=0; i<sylLines.length; i++) {
     sylShapes[i] = sylFont.toShape(sylLines[i].text);
     for(int j=0; j<sylSplitNums; j++) {
       sylPoints[i][j] = sylShapes[i].getPoint(j*step);
     }
  }   
  
  strokeWeight(1.5);
  background(0);
  println(lines[ lines.length-1 ].endTime);
}

void draw(){
  if(frameCount>=lines[0].time.start && frameCount< lines[0].time.end-fxDur ) {
    background(0);
    for(int j=0; j<splitNums; j++) {
        float x = points[0][j].x;
        float y = points[0][j].y;
        color c = color(noise(x*0.04, y*0.04)*255,noise(x*0.04, y*0.04)*255,255);
        stroke(c);
        point(x+lines[0].center,y+lines[0].bottom);
    }
  }
  
  for(int i=1; i<lines.length; i++) {
      Line line  = lines[i];
      Line preline = lines[i-1];
      
       if(frameCount>= line.startTime && frameCount <line.endTime) {
           background(0);
           for(int j=0; j<splitNums; j++) {
               float x = points[i][j].x;
               float y = points[i][j].y;
               color c = color(noise(x*0.04, y*0.04)*255,noise(x*0.04, y*0.04)*255,255);
               stroke(c);
               point(x+line.center,y+line.bottom);
           }
      }
      
      //if adjacent lines gap not exceed fxDur,perform morph
      if(Math.abs(line.time.start-frameCount)<=fxDur && (line.time.start-preline.time.end<=fxDur*2) ){
           background(0);
           for(int j=0; j<splitNums; j++) {
               float x = lerp(points[i][j].x,points[i-1][j].x,(line.time.start-frameCount+fxDur)*0.5/fxDur );
               float y = lerp(points[i][j].y,points[i-1][j].y,(line.time.start-frameCount+fxDur)*0.5/fxDur );
               if(frameCount==line.time.start+fxDur) {
                   x = points[i][j].x;
                   y = points[i][j].y;
               }
               color c = color(noise(x*0.04, y*0.04)*255,noise(x*0.04, y*0.04)*255,255);
               stroke(c);
               point(x+line.center,y+line.bottom);
           }
      }
      
      if( (line.time.start-preline.time.end>fxDur*2) && frameCount >= preline.time.end && frameCount < line.time.start) {
          background(0);
      }     
  }
  
  // furi part
  
  for(int i=0; i<furiLines.length; i++) {
      Line furiLine = furiLines[i];
      if(frameCount>=furiLine.time.start && frameCount <furiLine.time.end) {
          for(int j=0; j<furiSplitNums; j++) {
               float x = furiPoints[i][j].x;
               float y = furiPoints[i][j].y;
               color c = color(noise(x*0.04, y*0.04)*255,noise(x*0.04, y*0.04)*255,255);
               stroke(c);
               point(x+furiLine.center+3,y+furiLine.bottom);
          }
      }
  }
  
  // highlight part
  for(int i=0; i<sylLines.length; i++) {
      Line sylLine = sylLines[i];
      if(frameCount>=sylLine.time.start && frameCount <sylLine.time.end) {
          for(int j=0; j<sylSplitNums; j++) {
               float x = sylPoints[i][j].x;
               float y = sylPoints[i][j].y;
               color c = color(255,noise(x*0.04, y*0.04)*255,noise(x*0.04, y*0.04)*255);
               stroke(c);
               point(x+sylLine.center,y+sylLine.bottom);
          }
      }
  }
  
  if(frameCount-1<lines[ lines.length-1 ].time.end) {
    saveFrame("images\\####.png");
  }else{
    exit();
  }
  
}
