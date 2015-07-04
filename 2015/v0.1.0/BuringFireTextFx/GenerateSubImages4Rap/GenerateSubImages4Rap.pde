import ass.object.*;
import ass.util.*;

ASS ass = ASSParser.parseFile("G:\\FXWorks\\ALTIMA\\I‘ll believe.ass",29.970);
Line [] lines = ass.getLines(); 
int inDur =  5; // syl in fx duration

void setup(){
  size(ass.meta.width,ass.meta.height);
  Time.shift(lines,-lines[0].time.start+1);
}

void draw(){

    background(0);
    for(int i=0; i<lines.length; i++) {
        Line line = lines[i];
        if(line.style.equals("main")) {
           continue;
        }
        fill(255);
        PFont font = createFont(line.styleRef.fontName,line.styleRef.fontSize);
        textFont(font);
        textAlign(LEFT,CENTER);
        
        String preText="";
        for(int j=0; j<line.syls.size(); j++) {

           Syl syl = line.syls.get(j);
           
           float endX = syl.left;
           float endY = syl.middle;
           float sign = -1;
           if(syl.time.start%2==0) {
             sign = 1;
           }
           float startX = endX + sign*random(10,16);
           float startY = endY + sign*random(10,16);
           //println(line.i+" "+syl.i+" "+syl.left+" "+syl.right);
           for(int frameNum = syl.time.start-inDur; frameNum<syl.time.start; frameNum++) {
              background(0);
              text(preText,line.left,line.middle);
              float curX = map(frameNum,syl.time.start-inDur,syl.time.start-1,startX,endX);
              float curY = map(frameNum,syl.time.start-inDur,syl.time.start-1,startY,endY);
              text(syl.text,curX,curY);
              String fileName="subs"+File.separator+String.valueOf(frameNum)+".png";
              saveFrame(fileName);
           }
           
           preText = preText + syl.preSpace+syl.text+syl.postSpace;
           for(int frameNum=syl.time.start; frameNum<syl.time.end; frameNum++) {
              background(0);
              text(preText,line.left,line.middle);
              String fileName="subs"+File.separator+String.valueOf(frameNum)+".png";
              saveFrame(fileName);
           }
           //println(preText);
        }
    }  
    
    noLoop();
    exit();
}
