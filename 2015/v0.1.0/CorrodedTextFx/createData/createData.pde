import ass.object.*;
import ass.util.*;

ASS ass = ASSParser.parseFile("G:\\FXWorks\\凛麗\\Fx\\data\\凛麗.ass");
Line [] lines = ass.getLines(); 
void setup(){
  size(ass.meta.width,ass.meta.height);
}

void draw(){
    for(int i=0; i<lines.length; i++) {
        Line line = lines[i];
        background(0);
        fill(255);
        PFont font = createFont(line.styleRef.fontName,line.styleRef.fontSize);
        textFont(font);
        textAlign(CENTER,CENTER);
        text(line.text,line.center,line.middle);
        String name=String.valueOf(i)+".png";
        save(name);
        println(i);
    }  
    noLoop();
}
