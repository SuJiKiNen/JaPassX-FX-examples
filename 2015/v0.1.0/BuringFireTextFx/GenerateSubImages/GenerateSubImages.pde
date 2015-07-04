import ass.object.*;
import ass.util.*;

ASS ass = ASSParser.parseFile("G:\\FXWorks\\ALTIMA\\I‘ll believe.ass",29.970);
Line [] lines = ass.getLines(); 

void setup(){
  size(ass.meta.width,ass.meta.height);
  Time.shift(lines,-lines[0].time.start+1);
  frameRate(29.970);
}

void draw(){

  
    for(int i=0; i<lines.length; i++) {
        Line line = lines[i];
        if(line.style.equals("rap")) {
           continue;
        }
        background(0);
        fill(255);
        PFont font = createFont(line.styleRef.fontName,line.styleRef.fontSize);
        textFont(font);
        textAlign(CENTER,CENTER);
        text(line.text,line.center,line.middle);
        
        for(int j=0; j<line.syls.size(); j++) {
           Syl syl = line.syls.get(j);

           for(int frameNum=syl.time.start; frameNum<syl.time.end; frameNum++) {
              float x1 = syl.left;
              float y1 = syl.bottom;
              float x2 = map(frameNum,syl.time.start,syl.time.end-1,syl.left,syl.right);
              float y2 = syl.bottom;
              stroke(255);
              strokeWeight(3);
              float yDelta = 3;
              line(x1,y1+yDelta,x2,y2+yDelta);
              String fileName="subs"+File.separator+String.valueOf(frameNum)+".png";
              saveFrame(fileName);
             // println(i);
           }
        }
    }  
    
    noLoop();
    exit();
}
