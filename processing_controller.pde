import processing.serial.*;
import controlP5.*;
import java.util.*;
import processing.sound.*;

Serial port;
ControlP5 cp5;
PFont font;
PFont font2;
PImage rainbow_gradient;
SoundFile file;
Table data_table;

String file_name="";
boolean check_file_name=false;
float music_time=0.0;
float music_percent=0.0;

String table_name="";
boolean check_table_name=false;

boolean mode_flag=false;
int line_x;
int line_y;
int[] srgb=new int[6];
int[] r=new int[6];
int[] g=new int[6];
int[] b=new int[6];

int[] LED_Labels_pos=new int[1];
int[] LED_rect_type=new int[1];

int[] Servo_Labels_pos=new int[1];
int[] Servo_rect_type=new int[1];

boolean check_servo_1=true;
boolean check_servo_2=true;
boolean check_servo_3=true;
boolean check_led_1=true;
boolean check_led_2=true;
boolean check_led_3=true;
boolean check_led_4=true;
boolean check_led_5=true;

boolean check_led_r1=false;
boolean check_led_r2=false;
boolean check_led_r3=false;
boolean check_led_r4=false;
boolean check_led_r5=false;
boolean check_led_r6=false;

void setup(){
  // canvas size
  size(1440,900);
  
  // serial communication
  port=new Serial(this,"COM3",9600);
  
  // control p5 components
  cp5=new ControlP5(this);
  font=createFont("calibri light",16);
  font2=createFont("calibri light",14);
  rainbow_gradient=loadImage("data\\img.jpg");
  
  controllers();
  
  // default music
  file=new SoundFile(this,"music2.mp3");
  
  // default data table
  data_table=new Table();
  String[] code={"S1S1","S1D1","S2S1","S2D1","S2I1","S2S2","S2D2","S2I2","S2S3","S2D3","S3S1","S3D1","S3I1","S3S2","S3D2","S3I2","S3S3","S3D3",
  "CWL1","RLD1","L1L1","CWL2","RLD2","L2I1","L2S1","L3S1","CWL3","RLD3","L4S1","CWL4","RLD4","L5S1","CWL5","RLD5","L5S2","CWL6","RLD6","L5S3"};
  for(int i=0;i<code.length;i++){
    data_table.addColumn(code[i]);
  }
  
  LED_Labels_pos[0]=0;
  Servo_Labels_pos[0]=0;
}

void draw(){
  // background color
  background(0,0,0);
  
  // write data to default data table
  if(data_table.lastRowIndex()>=0){
    data_table.removeRow(0);
  }
  TableRow newRow = data_table.addRow();
  newRow.setInt("S1S1",int(cp5.get(Slider.class,"Servo1Speed").getValue()));
  newRow.setString("S1D1",cp5.get(Textfield.class,"Servo1Degree").getStringValue());
  
  newRow.setInt("S2S1",int(cp5.get(Slider.class,"Servo2Speed1").getValue()));
  newRow.setString("S2D1",cp5.get(Textfield.class,"Servo2Degree1").getStringValue());
  newRow.setString("S2I1",cp5.get(Textfield.class,"Servo2Interval1").getStringValue());
  newRow.setInt("S2S2",int(cp5.get(Slider.class,"Servo2Speed2").getValue()));
  newRow.setString("S2D2",cp5.get(Textfield.class,"Servo2Degree2").getStringValue());
  newRow.setString("S2I2",cp5.get(Textfield.class,"Servo2Interval2").getStringValue());
  newRow.setInt("S2S3",int(cp5.get(Slider.class,"Servo2Speed3").getValue()));
  newRow.setString("S2D3",cp5.get(Textfield.class,"Servo2Degree3").getStringValue());
  
  newRow.setInt("S3S1",int(cp5.get(Slider.class,"Servo3Speed1").getValue()));
  newRow.setString("S3D1",cp5.get(Textfield.class,"Servo3Degree1").getStringValue());
  newRow.setString("S3I1",cp5.get(Textfield.class,"Servo3Interval1").getStringValue());
  newRow.setInt("S3S2",int(cp5.get(Slider.class,"Servo3Speed2").getValue()));
  newRow.setString("S3D2",cp5.get(Textfield.class,"Servo3Degree2").getStringValue());
  newRow.setString("S3I2",cp5.get(Textfield.class,"Servo3Interval2").getStringValue());
  newRow.setInt("S3S3",int(cp5.get(Slider.class,"Servo3Speed3").getValue()));
  newRow.setString("S3D3",cp5.get(Textfield.class,"Servo3Degree3").getStringValue());
  
  newRow.setString("L1L1",cp5.get(Textfield.class,"LED1Length").getStringValue());
  newRow.setString("L2I1",cp5.get(Textfield.class,"LED2Interval").getStringValue());
  newRow.setInt("L2S1",int(cp5.get(Slider.class,"LED2Speed").getValue()));
  newRow.setInt("L3S1",int(cp5.get(Slider.class,"LED3Speed").getValue()));
  newRow.setInt("L4S1",int(cp5.get(Slider.class,"LED4Speed").getValue()));
  newRow.setInt("L5S1",int(cp5.get(Slider.class,"LED51Speed").getValue()));
  newRow.setInt("L5S2",int(cp5.get(Slider.class,"LED52Speed").getValue()));
  newRow.setInt("L5S3",int(cp5.get(Slider.class,"LED53Speed").getValue()));
  
  if(check_led_r1){
    newRow.setInt("RLD1",1);
  }else{
    newRow.setInt("RLD1",0);
  }
  
  if(check_led_r2){
    newRow.setInt("RLD2",1);
  }else{
    newRow.setInt("RLD2",0);
  }
  
  if(check_led_r3){
    newRow.setInt("RLD3",1);
  }else{
    newRow.setInt("RLD3",0);
  }
  
  if(check_led_r4){
    newRow.setInt("RLD4",1);
  }else{
    newRow.setInt("RLD4",0);
  }
  
  if(check_led_r5){
    newRow.setInt("RLD5",1);
  }else{
    newRow.setInt("RLD5",0);
  }
  
  if(check_led_r6){
    newRow.setInt("RLD6",1);
  }else{
    newRow.setInt("RLD6",0);
  }
  
  for(int i=0;i<6;i++){
    srgb[i]=cp5.get(ColorWheel.class,"led_cw"+(i+1)).getRGB();
    b[i]=srgb[i]&255;
    g[i]=(srgb[i]>>8)&255;
    r[i]=(srgb[i]>>16)&255;
    newRow.setString("CWL"+(i+1),str(r[i])+","+str(g[i])+","+str(b[i])+",");
  }
  
  // load music file
  if(check_file_name){
    file_name=file_name.toLowerCase();
    println("Searching for file……");
    File f = dataFile(file_name);
    String filePath = f.getPath();
    boolean exist = f.isFile();
    if(exist){
      file=new SoundFile(this,file_name);
      println("Find file!",filePath);
    }else{
      println("NO such file!");
    }
    check_file_name=false;
  }
  
  // load data table
  if(check_table_name){
    table_name=table_name.toLowerCase();
    println("Searching for data table……");
    File f_t = dataFile(table_name);
    String filePath_t = f_t.getPath();
    boolean exist_t = f_t.isFile();
    if(exist_t){
      data_table=loadTable(table_name,"header");
      println("Find data table!",filePath_t);
      
      for(TableRow row:data_table.rows()){
        println("Data is loading……");
        int S1S1_v=row.getInt("S1S1");
        cp5.get(Slider.class,"Servo1Speed").setValue(S1S1_v);
        String S1D1_v=row.getString("S1D1");
        cp5.get(Textfield.class,"Servo1Degree").setStringValue(S1D1_v).setText(S1D1_v);
        
        int S2S1_v=row.getInt("S2S1");
        cp5.get(Slider.class,"Servo2Speed1").setValue(S2S1_v);
        String S2D1_v=row.getString("S2D1");
        cp5.get(Textfield.class,"Servo2Degree1").setStringValue(S2D1_v).setText(S2D1_v);
        String S2I1_v=row.getString("S2I1");
        cp5.get(Textfield.class,"Servo2Interval1").setStringValue(S2I1_v).setText(S2I1_v);
        int S2S2_v=row.getInt("S2S2");
        cp5.get(Slider.class,"Servo2Speed2").setValue(S2S2_v);
        String S2D2_v=row.getString("S2D2");
        cp5.get(Textfield.class,"Servo2Degree2").setStringValue(S2D2_v).setText(S2D2_v);
        String S2I2_v=row.getString("S2I2");
        cp5.get(Textfield.class,"Servo2Interval2").setStringValue(S2I2_v).setText(S2I2_v);
        int S2S3_v=row.getInt("S2S3");
        cp5.get(Slider.class,"Servo2Speed3").setValue(S2S3_v);
        String S2D3_v=row.getString("S2D3");
        cp5.get(Textfield.class,"Servo2Degree3").setStringValue(S2D3_v).setText(S2D3_v);
        
        int S3S1_v=row.getInt("S3S1");
        cp5.get(Slider.class,"Servo3Speed1").setValue(S3S1_v);
        String S3D1_v=row.getString("S3D1");
        cp5.get(Textfield.class,"Servo3Degree1").setStringValue(S3D1_v).setText(S3D1_v);
        String S3I1_v=row.getString("S3I1");
        cp5.get(Textfield.class,"Servo3Interval1").setStringValue(S3I1_v).setText(S3I1_v);
        int S3S2_v=row.getInt("S3S2");
        cp5.get(Slider.class,"Servo3Speed2").setValue(S3S2_v);
        String S3D2_v=row.getString("S3D2");
        cp5.get(Textfield.class,"Servo3Degree2").setStringValue(S3D2_v).setText(S3D2_v);
        String S3I2_v=row.getString("S3I2");
        cp5.get(Textfield.class,"Servo3Interval2").setStringValue(S3I2_v).setText(S3I2_v);
        int S3S3_v=row.getInt("S3S3");
        cp5.get(Slider.class,"Servo3Speed3").setValue(S3S3_v);
        String S3D3_v=row.getString("S3D3");
        cp5.get(Textfield.class,"Servo3Degree3").setStringValue(S3D3_v).setText(S3D3_v);
        
        String L1L1_v=row.getString("L1L1");
        cp5.get(Textfield.class,"LED1Length").setStringValue(L1L1_v).setText(L1L1_v);
        String L2I1_v=row.getString("L2I1");
        cp5.get(Textfield.class,"LED2Interval").setStringValue(L2I1_v).setText(L2I1_v);
        int L2S1_v=row.getInt("L2S1");
        cp5.get(Slider.class,"LED2Speed").setValue(L2S1_v);
        int L3S1_v=row.getInt("L3S1");
        cp5.get(Slider.class,"LED3Speed").setValue(L3S1_v);
        int L4S1_v=row.getInt("L4S1");
        cp5.get(Slider.class,"LED4Speed").setValue(L4S1_v);
        int L5S1_v=row.getInt("L5S1");
        cp5.get(Slider.class,"LED51Speed").setValue(L5S1_v);
        int L5S2_v=row.getInt("L5S2");
        cp5.get(Slider.class,"LED52Speed").setValue(L5S2_v);
        int L5S3_v=row.getInt("L5S3");
        cp5.get(Slider.class,"LED53Speed").setValue(L5S3_v);
        
        int RLD1_v=row.getInt("RLD1");
        if(RLD1_v==1){
          check_led_r1=true;
        }else{
          String CWL1_v=row.getString("CWL1");
          String[] CWL1_vl=split(CWL1_v,",");
          cp5.get(ColorWheel.class,"led_cw1").setRGB(color(int(CWL1_vl[0]),int(CWL1_vl[1]),int(CWL1_vl[2])));
        }
        
        int RLD2_v=row.getInt("RLD2");
        if(RLD2_v==1){
          check_led_r2=true;
        }else{
          String CWL2_v=row.getString("CWL2");
          String[] CWL2_vl=split(CWL2_v,",");
          cp5.get(ColorWheel.class,"led_cw2").setRGB(color(int(CWL2_vl[0]),int(CWL2_vl[1]),int(CWL2_vl[2])));
        }
        
        int RLD3_v=row.getInt("RLD3");
        if(RLD3_v==1){
          check_led_r3=true;
        }else{
          String CWL3_v=row.getString("CWL3");
          String[] CWL3_vl=split(CWL3_v,",");
          cp5.get(ColorWheel.class,"led_cw3").setRGB(color(int(CWL3_vl[0]),int(CWL3_vl[1]),int(CWL3_vl[2])));
        }
        
        int RLD4_v=row.getInt("RLD4");
        if(RLD4_v==1){
          check_led_r4=true;
        }else{
          String CWL4_v=row.getString("CWL4");
          String[] CWL4_vl=split(CWL4_v,",");
          cp5.get(ColorWheel.class,"led_cw4").setRGB(color(int(CWL4_vl[0]),int(CWL4_vl[1]),int(CWL4_vl[2])));
        }
        
        int RLD5_v=row.getInt("RLD5");
        if(RLD5_v==1){
          check_led_r5=true;
        }else{
          String CWL5_v=row.getString("CWL5");
          String[] CWL5_vl=split(CWL5_v,",");
          cp5.get(ColorWheel.class,"led_cw5").setRGB(color(int(CWL5_vl[0]),int(CWL5_vl[1]),int(CWL5_vl[2])));
        }
        
        int RLD6_v=row.getInt("RLD6");
        if(RLD6_v==1){
          check_led_r6=true;
        }else{
          String CWL6_v=row.getString("CWL6");
          String[] CWL6_vl=split(CWL6_v,",");
          cp5.get(ColorWheel.class,"led_cw6").setRGB(color(int(CWL6_vl[0]),int(CWL6_vl[1]),int(CWL6_vl[2])));
        }
      }
      println("Data has loaded!");
    }else{
      println("NO such data table!");
    }
    check_table_name=false;
  }
  
  // divide area
  stroke(50);
  strokeWeight(4);
  strokeCap(ROUND);
  line(36,362,1440-36,362);
  line(720,362+36,720,900-36);
  
  // text
  fill(255);
  textFont(font);
  text("Servo 1",805,398+20);
  text("Servo 2",805,469+20);
  text("Servo 3",805,648+20);
  text("Click Enter to confirm degree/interval",805,827+20);
  text("degree",882,398+20);
  text("degree",882,469+20);
  text("Interval",882+96+16,469+20);
  text("degree",882,523+20);
  text("Interval",882+96+16,523+20);
  text("degree",882,577+20);
  text("degree",882,648+20);
  text("Interval",882+96+16,648+20);
  text("degree",882,702+20);
  text("Interval",882+96+16,702+20);
  text("degree",882,756+20);
  text("LED 1",85,398+20);
  text("LED 2",85,470+20);
  text("LED 3",85,541+20);
  text("LED 4",85,612+20);
  text("LED 5",85,683+20);
  text("Interval",286-18,470+20);
  text("Length",286-18,398+20);
  
  // timeline
  noStroke();
  fill(0,123,79);
  rect(36,240,1368,66);
  rect(36,341,(1440-72)*music_percent*0.01,18);
  
  fill(255);
  textFont(font);
  music_percent=file.percent();
  music_percent=round(music_percent*100)/100.00;
  text(music_percent+ " %",1284+60,341+8);
  music_time=file.duration()/60;
  music_time=round(music_time * 100) / 100.00;
  text(music_time+ " minutes",1440-128,240+18);
  
  stroke(255);
  strokeWeight(2);
  line(36,168,1440-36,168);
  line(36,239,1440-36,239);
  
  // led module color change & port write
  if(!mode_flag){
    for(int i=0;i<6;i++){
      srgb[i]=cp5.get(ColorWheel.class,"led_cw"+(i+1)).getRGB();
      b[i]=srgb[i]&255;
      g[i]=(srgb[i]>>8)&255;
      r[i]=(srgb[i]>>16)&255;
      
      if(i==0 && check_led_r1 || i==1 && check_led_r2 || i==2 && check_led_r3 || i==3 && check_led_r4 || i==4 && check_led_r5 || i==5 && check_led_r6){
        image(rainbow_gradient,cp5.get(Group.class,"led_g"+(i+1)).getPosition()[0],cp5.get(Group.class,"led_g"+(i+1)).getPosition()[1]-36);
        cp5.get(Group.class,"led_g"+(i+1)).setColorForeground(color(0,0,0,50));
        cp5.get(Group.class,"led_g"+(i+1)).setColorBackground(color(255,255,255,10));
      }else{
        cp5.get(Group.class,"led_g"+(i+1)).setColorForeground(color(r[i],g[i],b[i],200));
        cp5.get(Group.class,"led_g"+(i+1)).setColorBackground(color(r[i],g[i],b[i],255));
      }
      
      if(cp5.get(Bang.class,"led_r"+(i+1)).isMousePressed()){
        port.write("RLD"+str(i+1)+"\n");
      }
      
      if(cp5.get(ColorWheel.class,"led_cw"+(i+1)).isMousePressed()){
        port.write("CWL"+str(i+1)+str(r[i])+","+str(g[i])+","+str(b[i])+","+"\n");
        switch(i){
          case 0:
            check_led_r1=false;
            break;
          case 1:
            check_led_r2=false;
            break;
          case 2:
            check_led_r3=false;
            break;
          case 3:
            check_led_r4=false;
            break;
          case 4:
            check_led_r5=false;
            break;
          case 5:
            check_led_r6=false;
            break;
        }
      }
    }
  }else{
    for(int i=0;i<6;i++){
      if(i==0 && check_led_r1 || i==1 && check_led_r2 || i==2 && check_led_r3 || i==3 && check_led_r4 || i==4 && check_led_r5 || i==5 && check_led_r6){
        image(rainbow_gradient,cp5.get(Group.class,"led_g"+(i+1)).getPosition()[0],cp5.get(Group.class,"led_g"+(i+1)).getPosition()[1]-36);
        cp5.get(Group.class,"led_g"+(i+1)).setColorForeground(color(0,0,0,50));
        cp5.get(Group.class,"led_g"+(i+1)).setColorBackground(color(255,255,255,10));
      }
    }
  }
  
  // led block in timeline
  if(LED_Labels_pos.length>=2){
    for(int i=1;i<LED_Labels_pos.length;i+=2){
      noStroke();
      fill(color(255,255,107));
      rect(LED_Labels_pos[i-1],172-66,LED_Labels_pos[i]-LED_Labels_pos[i-1],36);
      fill(0);
      textFont(font);
      switch(LED_rect_type[i]){
        case 1:
          text("LED 1",(LED_Labels_pos[i-1]+(LED_Labels_pos[i]-LED_Labels_pos[i-1])/2)-14,172-44);
          break;
        case 2:
          text("LED 2",(LED_Labels_pos[i-1]+(LED_Labels_pos[i]-LED_Labels_pos[i-1])/2)-14,172-44);
          break;
        case 3:
          text("LED 3",(LED_Labels_pos[i-1]+(LED_Labels_pos[i]-LED_Labels_pos[i-1])/2)-14,172-44);
          break;
        case 4:
          text("LED 4",(LED_Labels_pos[i-1]+(LED_Labels_pos[i]-LED_Labels_pos[i-1])/2)-14,172-44);
          break;
        case 5:
          text("LED 5",(LED_Labels_pos[i-1]+(LED_Labels_pos[i]-LED_Labels_pos[i-1])/2)-14,172-44);
          break;
      }
      // delete led block
      if(!mode_flag && mousePressed && (mouseButton == RIGHT) && mouseX<LED_Labels_pos[i] && mouseX>LED_Labels_pos[i-1] && mouseY>172-66 && mouseY<172){
        LED_Labels_pos[i-1]=-10;
        LED_Labels_pos[i]=-10;
      }
      // change led block
      if(!mode_flag && mousePressed && (mouseButton == LEFT) && mouseX<LED_Labels_pos[i] && mouseX>LED_Labels_pos[i-1] && mouseY>172-66 && mouseY<172){
        if(LED_rect_type[i]+1<6){
          LED_rect_type[i]=LED_rect_type[i]+1;
          delay(100);
        }else{
          LED_rect_type[i]=1;
          delay(100);
        }
      }
    }
  }
  if(LED_Labels_pos[0]!=0 || LED_Labels_pos.length!=1){
    for(int i=0;i<LED_Labels_pos.length;i+=2){
      stroke(color(255,255,107));
      line(LED_Labels_pos[i],172-66,LED_Labels_pos[i],239);
    }
  }
  
  // servo block in timeline
  if(Servo_Labels_pos.length>=2){
    for(int i=1;i<Servo_Labels_pos.length;i+=2){
      noStroke();
      fill(color(255,177,255));
      rect(Servo_Labels_pos[i-1],172+4,Servo_Labels_pos[i]-Servo_Labels_pos[i-1],36);
      fill(0);
      textFont(font);
      switch(Servo_rect_type[i]){
        case 1:
          text("Servo 1",(Servo_Labels_pos[i-1]+(Servo_Labels_pos[i]-Servo_Labels_pos[i-1])/2)-18,172+26);
          break;
        case 2:
          text("Servo 2",(Servo_Labels_pos[i-1]+(Servo_Labels_pos[i]-Servo_Labels_pos[i-1])/2)-18,172+26);
          break;
        case 3:
          text("Servo 3",(Servo_Labels_pos[i-1]+(Servo_Labels_pos[i]-Servo_Labels_pos[i-1])/2)-18,172+26);
          break;
      }
      // delete servo block
      if(!mode_flag && mousePressed && (mouseButton == RIGHT) && mouseX<Servo_Labels_pos[i] && mouseX>Servo_Labels_pos[i-1] && mouseY>172+4 && mouseY<172+66){
        Servo_Labels_pos[i-1]=-10;
        Servo_Labels_pos[i]=-10;
      }
      // change servo block
      if(!mode_flag && mousePressed && (mouseButton == LEFT) && mouseX<Servo_Labels_pos[i] && mouseX>Servo_Labels_pos[i-1] && mouseY>172+4 && mouseY<172+66){
        if(Servo_rect_type[i]+1<4){
          Servo_rect_type[i]=Servo_rect_type[i]+1;
          delay(100);
        }else{
          Servo_rect_type[i]=1;
          delay(100);
        }
      }
    }
  }
  if(Servo_Labels_pos[0]!=0 || Servo_Labels_pos.length!=1){
    for(int i=0;i<Servo_Labels_pos.length;i+=2){
      stroke(color(255,177,255));
      line(Servo_Labels_pos[i],172+4,Servo_Labels_pos[i],239);
    }
  }
  
  // detect servo & led block in play mode
  if(mode_flag){
    // moving music_current_time_sign
    fill(255);
    textFont(font);
    text(music_time*60*music_percent*0.01,36+(1368*music_percent*0.01)-20,108-4);
    stroke(255);
    strokeWeight(2);
    strokeCap(ROUND);
    line(36+(1368*music_percent*0.01),108,36+(1368*music_percent*0.01),108+198);
    
    // detect servo block
    for(int i=1;i<Servo_Labels_pos.length;i+=2){
      // check_servo_1
      if(36+(1368*music_percent*0.01)>=Servo_Labels_pos[i-1]-8 && 36+(1368*music_percent*0.01)<=Servo_Labels_pos[i] && Servo_rect_type[i]==1){
        if(check_servo_1){
          port.write("S1S1"+int(cp5.get(Slider.class,"Servo1Speed").getValue())+"\n");
          delay(1050);
          port.write("S1D1"+int(cp5.get(Textfield.class,"Servo1Degree").getStringValue())+"\n");
          check_servo_1=false;
        }
        if(36+(1368*music_percent*0.01)>=Servo_Labels_pos[i]-2){
          port.write("S1S10\n");
          check_servo_1=true;
        }
      }
      // check_servo_2
      if(36+(1368*music_percent*0.01)>=Servo_Labels_pos[i-1]-8 && 36+(1368*music_percent*0.01)<=Servo_Labels_pos[i] && Servo_rect_type[i]==2){
        if(check_servo_2 && 36+(1368*music_percent*0.01)<=Servo_Labels_pos[i-1]+4){
          port.write("S2S1"+int(cp5.get(Slider.class,"Servo2Speed1").getValue())+"\n");
          delay(1050);
          port.write("S2D1"+int(cp5.get(Textfield.class,"Servo2Degree1").getStringValue())+"\n");
          delay(1050);
          port.write("S2S2"+int(cp5.get(Slider.class,"Servo2Speed2").getValue())+"\n");
          delay(1050);
          port.write("S2D2"+int(cp5.get(Textfield.class,"Servo2Degree2").getStringValue())+"\n");
          delay(1050);
          port.write("S2S3"+int(cp5.get(Slider.class,"Servo2Speed3").getValue())+"\n");
          check_servo_2=false;
        }
        if(36+(1368*music_percent*0.01)>=Servo_Labels_pos[i]-2){
          port.write("S2S10\n");
          delay(1050);
          port.write("S2S20\n");
          delay(1050);
          port.write("S2S30\n");
          check_servo_2=true;
        }
      }
      // check_servo_3
      if(36+(1368*music_percent*0.01)>=Servo_Labels_pos[i-1]-8 && 36+(1368*music_percent*0.01)<=Servo_Labels_pos[i] && Servo_rect_type[i]==3){
        if(check_servo_3 && 36+(1368*music_percent*0.01)<=Servo_Labels_pos[i-1]+4){
          port.write("S3S1"+int(cp5.get(Slider.class,"Servo3Speed1").getValue())+"\n");
          delay(1050);
          port.write("S3D1"+int(cp5.get(Textfield.class,"Servo3Degree1").getStringValue())+"\n");
          delay(1050);
          port.write("S3S2"+int(cp5.get(Slider.class,"Servo3Speed2").getValue())+"\n");
          delay(1050);
          port.write("S3D2"+int(cp5.get(Textfield.class,"Servo3Degree2").getStringValue())+"\n");
          delay(1050);
          port.write("S3S3"+int(cp5.get(Slider.class,"Servo3Speed3").getValue())+"\n");
          check_servo_3=false;
        }
        if(36+(1368*music_percent*0.01)>=Servo_Labels_pos[i]-2){
          port.write("S3S10\n");
          delay(1050);
          port.write("S3S20\n");
          delay(1050);
          port.write("S3S30\n");
          check_servo_3=true;
        }
      }
    }
    
    // detect led block
    for(int i=1;i<LED_Labels_pos.length;i+=2){
      // check_led_1
      if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i-1]-8 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i] && LED_rect_type[i]==1){
        if(check_led_1 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i-1]+4){
          if(check_led_r1){
            port.write("RLD1\n");
          }else{
            srgb[0]=cp5.get(ColorWheel.class,"led_cw1").getRGB();
            b[0]=srgb[0]&255;
            g[0]=(srgb[0]>>8)&255;
            r[0]=(srgb[0]>>16)&255;
            port.write("CWL1"+str(r[0])+","+str(g[0])+","+str(b[0])+","+"\n");
          }
          delay(1050);
          port.write("L1L1"+int(cp5.get(Textfield.class,"LED1Length").getStringValue())+"\n");
          delay(1050);
          check_led_1=false;
        }
        if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i]-2){
          port.write("CWL10,0,0,\n");
          check_led_1=true;
        }
      }
      // check_led_2
      if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i-1]-8 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i] && LED_rect_type[i]==2){
        if(check_led_2 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i-1]+4){
          if(check_led_r2){
            port.write("RLD2\n");
          }else{
            srgb[1]=cp5.get(ColorWheel.class,"led_cw2").getRGB();
            b[1]=srgb[1]&255;
            g[1]=(srgb[1]>>8)&255;
            r[1]=(srgb[1]>>16)&255;
            port.write("CWL2"+str(r[1])+","+str(g[1])+","+str(b[1])+","+"\n");
          }
          delay(1050);
          port.write("L2I1"+int(cp5.get(Textfield.class,"LED2Interval").getStringValue())+"\n");
          delay(1050);
          check_led_2=false;
        }
        if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i]-2){
          port.write("CWL20,0,0,\n");
          check_led_2=true;
        }
      }
      // check_led_3
      if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i-1]-8 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i] && LED_rect_type[i]==3){
        if(check_led_3 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i-1]+4){
          port.write("L3S1"+int(cp5.get(Slider.class,"LED3Speed").getValue())+"\n");
          check_led_3=false;
        }
        if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i]-2){
          port.write("L3S10\n");
          check_led_3=true;
        }
      }
      // check_led_4
      if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i-1]-8 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i] && LED_rect_type[i]==4){
        if(check_led_4 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i-1]+4){
          if(check_led_r3){
            port.write("RLD3\n");
          }else{
            srgb[2]=cp5.get(ColorWheel.class,"led_cw3").getRGB();
            b[2]=srgb[2]&255;
            g[2]=(srgb[2]>>8)&255;
            r[2]=(srgb[2]>>16)&255;
            port.write("CWL3"+str(r[2])+","+str(g[2])+","+str(b[2])+","+"\n");
          }
          delay(1050);
          port.write("L4S1"+int(cp5.get(Slider.class,"LED4Speed").getValue())+"\n");
          delay(1050);
          check_led_4=false;
        }
        if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i]-2){
          port.write("CWL30,0,0,\n");
          check_led_4=true;
        }
      }
      // check_led_5
      if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i-1]-8 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i] && LED_rect_type[i]==5){
        if(check_led_5 && 36+(1368*music_percent*0.01)<=LED_Labels_pos[i-1]+4){
          if(check_led_r4){
            port.write("RLD4\n");
          }else{
            srgb[3]=cp5.get(ColorWheel.class,"led_cw4").getRGB();
            b[3]=srgb[3]&255;
            g[3]=(srgb[3]>>8)&255;
            r[3]=(srgb[3]>>16)&255;
            port.write("CWL4"+str(r[3])+","+str(g[3])+","+str(b[3])+","+"\n");
          }
          delay(1050);
          if(check_led_r5){
            port.write("RLD5\n");
          }else{
            srgb[4]=cp5.get(ColorWheel.class,"led_cw5").getRGB();
            b[4]=srgb[4]&255;
            g[4]=(srgb[4]>>8)&255;
            r[4]=(srgb[4]>>16)&255;
            port.write("CWL5"+str(r[4])+","+str(g[4])+","+str(b[4])+","+"\n");
          }
          delay(1050);
          if(check_led_r6){
            port.write("RLD6\n");
          }else{
            srgb[5]=cp5.get(ColorWheel.class,"led_cw6").getRGB();
            b[5]=srgb[5]&255;
            g[5]=(srgb[5]>>8)&255;
            r[5]=(srgb[5]>>16)&255;
            port.write("CWL6"+str(r[5])+","+str(g[5])+","+str(b[5])+","+"\n");
          }
          delay(1050);
          port.write("L5S1"+int(cp5.get(Slider.class,"LED51Speed").getValue())+"\n");
          delay(1050);
          port.write("L5S2"+int(cp5.get(Slider.class,"LED52Speed").getValue())+"\n");
          delay(1050);
          port.write("L5S3"+int(cp5.get(Slider.class,"LED53Speed").getValue())+"\n");
          delay(1050);
          check_led_5=false;
        }
        if(36+(1368*music_percent*0.01)>=LED_Labels_pos[i]-2){
          port.write("CWL40,0,0,\n");
          delay(1050);
          port.write("CWL50,0,0,\n");
          delay(1050);
          port.write("CWL60,0,0,\n");
          check_led_5=true;
        }
      }
    }
  }else{
    line_x=constrain(mouseX,36,1440-36);
    fill(255);
    textFont(font);
    text(music_time*60*(line_x-36)/1368.0,line_x-20,108-4);
    stroke(255);
    strokeWeight(2);
    strokeCap(ROUND);
    line(line_x,108,line_x,108+198);
  }
}

// default control p5 controllers
void controllers(){
  cp5.addBang("Mode")
  .setPosition(36,36)
  .setSize(72*2,36)
  .setFont(font)
  .setColorForeground(color(0,255,0,180))
  .setColorActive(color(0,255,0,130))
  .setCaptionLabel("Test Mode On")
  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  cp5.addBang("Save")
  .setPosition(900,36)
  .setSize(72,36)
  .setFont(font)
  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  cp5.addBang("Start")
  .setPosition(1242+72+18,36)
  .setSize(72,36)
  .setFont(font)
  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  cp5.addBang("Pause")
  .setPosition(1152+72+18,36)
  .setSize(72,36)
  .setFont(font)
  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  cp5.addBang("Reset")
  .setPosition(1152,36)
  .setSize(72,36)
  .setFont(font)
  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  cp5.addTextfield("MusicName")
  .setPosition(900+72+18,36)
  .setSize(144,36)
  .setLabel("music file")
  .setAutoClear(false)
  .setFont(font);
  
  cp5.addTextfield("DataTableName")
  .setPosition(900-144-18,36)
  .setSize(144,36)
  .setLabel("data table")
  .setAutoClear(false)
  .setFont(font);
  
  cp5.addTextfield("LED1Length")
  .setPosition(286+36,398)
  .setSize(48,36)
  .setLabel("")
  .setAutoClear(false)
  .setFont(font);
  
  cp5.addSlider("LED2Speed")
  .setPosition(406,470)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addTextfield("LED2Interval")
  .setPosition(286+36,470)
  .setSize(48,36)
  .setLabel("")
  .setAutoClear(false)
  .setFont(font);
  
  cp5.addSlider("LED3Speed")
  .setPosition(406,541)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addSlider("LED4Speed")
  .setPosition(406,612)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addSlider("LED51Speed")
  .setPosition(406,683)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addSlider("LED52Speed")
  .setPosition(406,683+18+36)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addSlider("LED53Speed")
  .setPosition(406,683+18+18+36+36)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addSlider("Servo1Speed")
  .setPosition(1123,398)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addTextfield("Servo1Degree")
  .setPosition(936,398)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addSlider("Servo2Speed1")
  .setPosition(1123,469)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addTextfield("Servo2Degree1")
  .setPosition(936,469)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addTextfield("Servo2Interval1")
  .setPosition(936+96+18,469)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addSlider("Servo2Speed2")
  .setPosition(1123,469+18+36)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addTextfield("Servo2Degree2")
  .setPosition(936,469+18+36)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addTextfield("Servo2Interval2")
  .setPosition(936+96+18,469+18+36)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addSlider("Servo2Speed3")
  .setPosition(1123,469+18+36+18+36)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addTextfield("Servo2Degree3")
  .setPosition(936,469+18+36+18+36)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addSlider("Servo3Speed1")
  .setPosition(1123,648)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addTextfield("Servo3Degree1")
  .setPosition(936,648)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addTextfield("Servo3Interval1")
  .setPosition(936+96+18,648)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addSlider("Servo3Speed2")
  .setPosition(1123,648+18+36)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addTextfield("Servo3Degree2")
  .setPosition(936,648+18+36)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addTextfield("Servo3Interval2")
  .setPosition(936+96+18,648+18+36)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addSlider("Servo3Speed3")
  .setPosition(1123,648+18+36+18+36)
  .setRange(0,10)
  .setSize(229,36)
  .setNumberOfTickMarks(10)
  .setLabel("")
  .setFont(font);
  
  cp5.addTextfield("Servo3Degree3")
  .setPosition(936,648+18+36+18+36)
  .setSize(48,36)
  .setFont(font)
  .setLabel("")
  .setAutoClear(false);
  
  cp5.addBang("Clear")
  .setPosition(1280,827)
  .setSize(72,36)
  .setFont(font)
  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  
  // led_g6_color
  Group led_g6=cp5.addGroup("led_g6")
                  .setPosition(167,791+36)
                  .setSize(72,36)
                  .setBarHeight(36)
                  .setLabel("")
                  .close();
  cp5.addColorWheel("led_cw6",320,20,220)
     .setPosition(72+10,-220-1)
     .setLabel("")
     .setGroup(led_g6);
     
  cp5.addBang("led_r6")
     .setSize(72,36)
     .setPosition(72+10,10)
     .setGroup(led_g6)
     .setImage(rainbow_gradient);
     
  // led_g5_color
  Group led_g5=cp5.addGroup("led_g5")
                  .setPosition(167,737+36)
                  .setSize(72,36)
                  .setBarHeight(36)
                  .setLabel("")
                  .close();
  cp5.addColorWheel("led_cw5",320,20,220)
     .setPosition(72+10,-220-1)
     .setLabel("")
     .setGroup(led_g5);
     
  cp5.addBang("led_r5")
     .setSize(72,36)
     .setPosition(72+10,10)
     .setGroup(led_g5)
     .setImage(rainbow_gradient);
     
  // led_g4_color
  Group led_g4=cp5.addGroup("led_g4")
                  .setPosition(167,683+36)
                  .setSize(72,36)
                  .setBarHeight(36)
                  .setLabel("")
                  .close();
  cp5.addColorWheel("led_cw4",320,20,220)
     .setPosition(72+10,-220-1)
     .setLabel("")
     .setGroup(led_g4);
     
  cp5.addBang("led_r4")
     .setSize(72,36)
     .setPosition(72+10,10)
     .setGroup(led_g4)
     .setImage(rainbow_gradient);
  
  // led_g3_color
  Group led_g3=cp5.addGroup("led_g3")
                  .setPosition(167,612+36)
                  .setSize(72,36)
                  .setBarHeight(36)
                  .setLabel("")
                  .close();
  cp5.addColorWheel("led_cw3",320,20,220)
     .setPosition(72+10,-220-1)
     .setLabel("")
     .setGroup(led_g3);
     
  cp5.addBang("led_r3")
     .setSize(72,36)
     .setPosition(72+10,10)
     .setGroup(led_g3)
     .setImage(rainbow_gradient);
     
  // led_g2_color
  Group led_g2=cp5.addGroup("led_g2")
                  .setPosition(167,470+36)
                  .setSize(72,36)
                  .setBarHeight(36)
                  .setLabel("")
                  .close();
  cp5.addColorWheel("led_cw2",320,20,220)
     .setPosition(72+10,-36)
     .setLabel("")
     .setGroup(led_g2);
     
  cp5.addBang("led_r2")
     .setSize(72,36)
     .setPosition(72+10,220-26)
     .setGroup(led_g2)
     .setImage(rainbow_gradient);
  
  // led_g1_color
  Group led_g1=cp5.addGroup("led_g1")
                  .setPosition(167,398+36)
                  .setSize(72,36)
                  .setBarHeight(36)
                  .setLabel("")
                  .close();
  cp5.addColorWheel("led_cw1",320,20,220)
     .setPosition(72+10,-36)
     .setLabel("")
     .setGroup(led_g1);
     
  cp5.addBang("led_r1")
     .setSize(72,36)
     .setPosition(72+10,220-26)
     .setGroup(led_g1)
     .setImage(rainbow_gradient);
}

// test & play mode
void Mode(){
  if(mode_flag){
    mode_flag=false;
    cp5.get(Bang.class,"Mode").setCaptionLabel("Test Mode On");
    cp5.get(Bang.class,"Mode").setColorForeground(color(0,255,0,180));
    cp5.get(Bang.class,"Mode").setColorActive(color(0,255,0,130));
  }else{
    mode_flag=true;
    cp5.get(Bang.class,"Mode").setCaptionLabel("Play Mode On");
    cp5.get(Bang.class,"Mode").setColorForeground(color(255,0,0,200));
    cp5.get(Bang.class,"Mode").setColorActive(color(255,0,0,150));
    
    // default servo action
    println("Changing mode……");
    port.write("S1S10\n");
    delay(1100);
    port.write("S2S10\n");
    delay(1100);
    println("Changing……");
    port.write("S2S20\n");
    delay(1100);
    port.write("S2S30\n");
    delay(1100);
    println("Changing……");
    port.write("S3S10\n");
    delay(1100);
    port.write("S3S20\n");
    delay(1100);
    println("Changing……");
    port.write("S3S30\n");
    delay(1100);
    
    // default led color
    for(int i=0;i<6;i++){
      port.write("CWL"+str(i+1)+"0,0,0,\n");
      delay(1100);
      if(i%2==0){
        println("Changing……");
      }
    }
    println("Changing mode completed!");
  }
}

// music buttons
void Start(){
  if(mode_flag){
    if(!file.isPlaying()){
      file.play();
    }
  }
}

void Pause(){
  if(mode_flag){
    if(file.isPlaying()){
      file.pause();
    }
  }
}

void Reset(){
  if(mode_flag){
    file.cue(0);
    check_servo_1=true;
    check_servo_2=true;
    check_servo_3=true;
    check_led_1=true;
    check_led_2=true;
    check_led_3=true;
    check_led_4=true;
    check_led_5=true;
  }
}

// save data table
void Save(){
  saveTable(data_table, "data/data_table.csv");
  println("Data is saved & uploaded!");
}

// led rainbow gradient
void led_r1(){
  port.write("RLD1\n");
  check_led_r1=true;
}

void led_r2(){
  port.write("RLD2\n");
  check_led_r2=true;
}

void led_r3(){
  port.write("RLD3\n");
  check_led_r3=true;
}

void led_r4(){
  port.write("RLD4\n");
  check_led_r4=true;
}

void led_r5(){
  port.write("RLD5\n");
  check_led_r5=true;
}

void led_r6(){
  port.write("RLD6\n");
  check_led_r6=true;
}

// create servo & led block in timeline
void mousePressed(){
  if(!mode_flag){
    boolean check_pos=true;
    for(int i=1;i<LED_Labels_pos.length;i+=2){
      if(mouseX<LED_Labels_pos[i] && mouseX>LED_Labels_pos[i-1]){
        check_pos=false;
      }
    }
    if(mouseY<172 && mouseY>172-66 && mouseX>=35 && mouseX<=1440-35){
      if(check_pos){
        // create label
        if(LED_Labels_pos[0]!=0 || LED_Labels_pos.length!=1){
          LED_Labels_pos=expand(LED_Labels_pos,LED_Labels_pos.length+1);
          LED_Labels_pos[LED_Labels_pos.length-1]=mouseX;
          
          LED_rect_type=expand(LED_rect_type,LED_rect_type.length+1);
          LED_rect_type[LED_rect_type.length-1]=1;
        }else{
          LED_Labels_pos[LED_Labels_pos.length-1]=mouseX;
          LED_rect_type[LED_rect_type.length-1]=1;
        }
      }
    }
    
    boolean check_pos_2=true;
    for(int i=1;i<Servo_Labels_pos.length;i+=2){
      if(mouseX<Servo_Labels_pos[i] && mouseX>Servo_Labels_pos[i-1]){
        check_pos_2=false;
      }
    }
    if(mouseY<172+66 && mouseY>172 && mouseX>=35 && mouseX<=1440-35){
      if(check_pos_2){
        // create label
        if(Servo_Labels_pos[0]!=0 || Servo_Labels_pos.length!=1){
          Servo_Labels_pos=expand(Servo_Labels_pos,Servo_Labels_pos.length+1);
          Servo_Labels_pos[Servo_Labels_pos.length-1]=mouseX;
          
          Servo_rect_type=expand(Servo_rect_type,Servo_rect_type.length+1);
          Servo_rect_type[Servo_rect_type.length-1]=1;
        }else{
          Servo_Labels_pos[Servo_Labels_pos.length-1]=mouseX;
          Servo_rect_type[Servo_rect_type.length-1]=1;
        }
      }
    }
  }
}

// led speed
void LED2Speed(int speed){
  port.write("L2S1"+str(speed)+"\n");
}

void LED3Speed(int speed){
  port.write("L3S1"+str(speed)+"\n");
}

void LED4Speed(int speed){
  port.write("L4S1"+str(speed)+"\n");
}

void LED51Speed(int speed){
  port.write("L5S1"+str(speed)+"\n");
}

void LED52Speed(int speed){
  port.write("L5S2"+str(speed)+"\n");
}

void LED53Speed(int speed){
  port.write("L5S3"+str(speed)+"\n");
}

void Clear(){
  port.write("SECL\n");
}

// each textfield controller
void controlEvent(ControlEvent theEvent){
  if(theEvent.isAssignableFrom(Textfield.class) && !mode_flag) {
    String name=theEvent.getController().getName();
    switch(name){
      case "MusicName":
        file_name=theEvent.getStringValue()+".mp3";
        check_file_name=true;
        break;
      case "DataTableName":
        table_name=theEvent.getStringValue()+".csv";
        check_table_name=true;
        break;
      
      case "LED1Length":
        port.write("L1L1"+theEvent.getStringValue()+"\n");
        break;
      case "LED2Interval":
        port.write("L2I1"+theEvent.getStringValue()+"\n");
        break;
      case "Servo1Degree":
        port.write("S1D1"+theEvent.getStringValue()+"\n");
        break;
      case "Servo2Degree1":
        port.write("S2D1"+theEvent.getStringValue()+"\n");
        break;
      case "Servo2Degree2":
        port.write("S2D2"+theEvent.getStringValue()+"\n");
        break;
      case "Servo2Degree3":
        port.write("S2D3"+theEvent.getStringValue()+"\n");
        break;
      case "Servo3Degree1":
        port.write("S3D1"+theEvent.getStringValue()+"\n");
        break;
      case "Servo3Degree2":
        port.write("S3D2"+theEvent.getStringValue()+"\n");
        break;
      case "Servo3Degree3":
        port.write("S3D3"+theEvent.getStringValue()+"\n");
        break;
        
      case "Servo2Interval1":
        port.write("S2I1"+theEvent.getStringValue()+"\n");
        break;
      case "Servo2Interval2":
        port.write("S2I2"+theEvent.getStringValue()+"\n");
        break;
      case "Servo3Interval1":
        port.write("S3I1"+theEvent.getStringValue()+"\n");
        break;
      case "Servo3Interval2":
        port.write("S3I2"+theEvent.getStringValue()+"\n");
        break;
    }
  }
}

// servo speed
void Servo1Speed(int speed){
  if(!mode_flag){
    port.write("S1S1"+str(speed)+"\n");
  }
}

void Servo2Speed1(int speed){
  if(!mode_flag){
    port.write("S2S1"+str(speed)+"\n");
  }
}

void Servo2Speed2(int speed){
  if(!mode_flag){
    port.write("S2S2"+str(speed)+"\n");
  }
}

void Servo2Speed3(int speed){
  if(!mode_flag){
    port.write("S2S3"+str(speed)+"\n");
  }
}

void Servo3Speed1(int speed){
  if(!mode_flag){
    port.write("S3S1"+str(speed)+"\n");
  }
}

void Servo3Speed2(int speed){
  if(!mode_flag){
    port.write("S3S2"+str(speed)+"\n");
  }
}

void Servo3Speed3(int speed){
  if(!mode_flag){
    port.write("S3S3"+str(speed)+"\n");
  }
}
