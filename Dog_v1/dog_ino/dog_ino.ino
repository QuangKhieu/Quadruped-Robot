#include <Servo.h>

int temp =0;
Servo servo1;//join 11
Servo servo2;//join 12  
Servo servo3;//join 13


Servo servo4;//join 21
Servo servo5;//join 22
Servo servo6;//join 23

Servo servo7;//join 31
Servo servo8;//join 32
Servo servo9;//join 33

Servo servo10;//join 41
Servo servo11;//join 42
Servo servo12;//join 43


int i = 0;
const float pi = 3.141592654; 
const float L1 = 5; // in cm
const float L2 = 5;
const int T = 52; //c18 ki
float theta =180 ;
float amp = 2, hei = 1; // do dai, do cao buoc chan 1 chu kì
float z_begin= 7,y_begin = -1.7, x_begin=0  ;
//float offset_13[3],offset_24[3];



  float x13_sq;
  float y13_sq ;
  float z13_sq ;
  float x24_sq ;
  float y24_sq;
  float z24_sq ;
  float L13_sq ;
  float L24_sq ;
  float L1_sq ;
  float L2_sq  ;
  
  
  float alpha13 ;
  float alpha24 ;
  float gamma13 ;
  float gamma24 ;
  float beta13  ;
  float beta24 ; 



void setup() {
  

  
  servo1.attach(1);
  servo2.attach(2); 
  servo3.attach(3); 

  servo4.attach(4); 
  servo5.attach(5); 
  servo6.attach(6); 
  
  servo7.attach(7); 
  servo8.attach(8); 
  servo9.attach(9);
   
  servo12.attach(12); 
  servo10.attach(10); 
  servo11.attach(11); 





}


void loop() {



  
   temp =0;
  do{
    dog_walk(1,0,1);
    Serial.println(temp);
    temp++;
  }while(temp<5);
  do{
    dog_walk(0,0,1);
    
    Serial.println(temp);
    temp++;
  }while(temp<10);

}
 
 

}


void dog_walk(int check,float dr, int rot){
  
  for ( i = 0; i<=T; i++)
  {
   float offset_13[3] = {0,0,0};
    offset_13[1] =  amp * sin(2*(pi/T)*i)*cos(dr*pi/180);
   
    if (i>=T/4&&i<=3*T/4)
    {
        offset_13[2] = -hei * sin(2*(pi/T)*(i-T/4));
    }
    else 
    {
        offset_13[2]  = 0;
    }
    offset_13[0] =  amp * sin(2*(pi/T)*i)*sin(dr*pi/180);
    float posleg13[3] = {x_begin+offset_13[0]*check,y_begin+ offset_13[1]*check,z_begin+ offset_13[2]*check};
    
    float  offset_24[3]={0,0,0};
        offset_24[1] =  amp * sin(2*(pi/T)*(i+T/2))*cos(dr*pi/180);
        
    if (i>=T/4&&i<=3*T/4)
    {
        offset_24[2] = -hei * sin(2*(pi/T)*(i+T/2-T/4));
    }
      
    
    offset_24[0] =  amp * sin(2*(pi/T)*(i+T/2))*sin(dr*pi/180);
    float posleg24[3] = {x_begin+offset_24[0]*check,y_begin+ offset_24[1]*check,z_begin+ offset_24[2]*check};
    
  kin(posleg13,posleg24,rot);

  
    
    delay(20);
    
  }
  
  
}

void kin( float p13[], float p24[], int rot ){
  x13_sq = pow(p13[0],2); 
  y13_sq = pow(p13[1],2); 
  z13_sq = pow(p13[2],2); 
  x24_sq = pow(p24[0],2); 
  y24_sq = pow(p24[1],2); 
  z24_sq = pow(p24[2],2); 
  L13_sq = x13_sq + y13_sq + z13_sq;
  L24_sq = x24_sq + y24_sq + z24_sq;
  L1_sq = pow(L1,2); 
  L2_sq = pow(L2,2); 
  
  
  alpha13 = atan2(p13[2],p13[0]);
  alpha24 = atan2(p24[2],p24[0]);
  gamma13 = acos((L1_sq + L2_sq - L13_sq)/(2*L1*L2));
  gamma24 = acos((L1_sq + L2_sq - L24_sq)/(2*L1*L2));
  beta13  = atan2(sqrt(x13_sq+z13_sq),p13[1]) + acos((L1_sq + L13_sq - L2_sq)/ (2*L1*sqrt(L13_sq)));
  beta24  = atan2(sqrt(x24_sq+z24_sq),p24[1]) + acos((L1_sq + L24_sq - L2_sq)/ (2*L1*sqrt(L24_sq))) ;    
  
     // Serial.println(  (L1_sq + L2_sq - L13_sq)/(2*L1*L2));
  //Setial.println()
  //  Serial.println(p13[3]);
    //Serial.println(p24[2]);
  
   
    servo1.write((pi-alpha13)*180/pi-10);
    servo2.write((pi-beta13)*180/pi);
    servo3.write((gamma13)*180/pi);
  
    servo4.write((pi-alpha24)*180/pi);
    servo5.write(beta24*180/pi);
    servo6.write((pi-gamma24)*180/pi);
  
    servo7.write( atan2(p13[2],p13[0]*-rot)*180/pi+5); //alpha13
    servo8.write(beta13*180/pi);
    servo9.write((pi-gamma13)*180/pi);
  
    servo10.write(atan2(p24[2],p24[0]*-rot)*180/pi+10);//alpha24
    servo11.write((pi-beta24)*180/pi);
    servo12.write((gamma24)*180/pi);
  
 
 
  
 
  
}
#include <Servo.h>

int temp =0;
Servo servo1;//join 11
Servo servo2;//join 12  
Servo servo3;//join 13


Servo servo4;//join 21
Servo servo5;//join 22
Servo servo6;//join 23

Servo servo7;//join 31
Servo servo8;//join 32
Servo servo9;//join 33

Servo servo10;//join 41
Servo servo11;//join 42
Servo servo12;//join 43


int i = 0;
const float pi = 3.141592654; 
const float L1 = 5; // in cm
const float L2 = 5;
const int T = 52; //c18 ki
float theta =180 ;
float amp = 2, hei = 1; // do dai, do cao buoc chan 1 chu kì
float z_begin= 7,y_begin = -1.7, x_begin=0  ;
//float offset_13[3],offset_24[3];



  float x13_sq;
  float y13_sq ;
  float z13_sq ;
  float x24_sq ;
  float y24_sq;
  float z24_sq ;
  float L13_sq ;
  float L24_sq ;
  float L1_sq ;
  float L2_sq  ;
  
  
  float alpha13 ;
  float alpha24 ;
  float gamma13 ;
  float gamma24 ;
  float beta13  ;
  float beta24 ; 



void setup() {
  

  
  servo1.attach(1);
  servo2.attach(2); 
  servo3.attach(3); 

  servo4.attach(4); 
  servo5.attach(5); 
  servo6.attach(6); 
  
  servo7.attach(7); 
  servo8.attach(8); 
  servo9.attach(9);
   
  servo12.attach(12); 
  servo10.attach(10); 
  servo11.attach(11); 





}


void loop() {



  
dog_walk(1,180,-1);
 

}


void dog_walk(int check,float dr, int rot){
  
  for ( i = 0; i<=T; i++)
  {
   float offset_13[3] = {0,0,0};
    offset_13[1] =  amp * sin(2*(pi/T)*i)*cos(dr*pi/180);
   
    if (i>=T/4&&i<=3*T/4)
    {
        offset_13[2] = -hei * sin(2*(pi/T)*(i-T/4));
    }
    else 
    {
        offset_13[2]  = 0;
    }
    offset_13[0] =  amp * sin(2*(pi/T)*i)*sin(dr*pi/180);
    float posleg13[3] = {x_begin+offset_13[0]*check,y_begin+ offset_13[1]*check,z_begin+ offset_13[2]*check};
    
    float  offset_24[3]={0,0,0};
        offset_24[1] =  amp * sin(2*(pi/T)*(i+T/2))*cos(dr*pi/180);
        
    if (i>=T/4&&i<=3*T/4)
    {
        offset_24[2] = -hei * sin(2*(pi/T)*(i+T/2-T/4));
    }
      
    
    offset_24[0] =  amp * sin(2*(pi/T)*(i+T/2))*sin(dr*pi/180);
    float posleg24[3] = {x_begin+offset_24[0]*check,y_begin+ offset_24[1]*check,z_begin+ offset_24[2]*check};
    
  kin(posleg13,posleg24,rot);

  
    
    delay(25);
    
  }
  
  
}

void kin( float p13[], float p24[], int rot ){
 
  x13_sq = pow(p13[0],2); 
  y13_sq = pow(p13[1],2); 
  z13_sq = pow(p13[2],2); 
  x24_sq = pow(p24[0],2); 
  y24_sq = pow(p24[1],2); 
  z24_sq = pow(p24[2],2); 
  L13_sq = x13_sq + y13_sq + z13_sq;
  L24_sq = x24_sq + y24_sq + z24_sq;
  L1_sq = pow(L1,2); 
  L2_sq = pow(L2,2); 
  
  
  alpha13 = atan2(p13[2],p13[0]);
  alpha24 = atan2(p24[2],p24[0]);
  gamma13 = acos((L1_sq + L2_sq - L13_sq)/(2*L1*L2));
  gamma24 = acos((L1_sq + L2_sq - L24_sq)/(2*L1*L2));
  beta13  = atan2(sqrt(x13_sq+z13_sq),p13[1]) + acos((L1_sq + L13_sq - L2_sq)/ (2*L1*sqrt(L13_sq)));
  beta24  = atan2(sqrt(x24_sq+z24_sq),p24[1]) + acos((L1_sq + L24_sq - L2_sq)/ (2*L1*sqrt(L24_sq))) ;    
  
     // Serial.println(  (L1_sq + L2_sq - L13_sq)/(2*L1*L2));
  //Setial.println()
  //  Serial.println(p13[3]);
    //Serial.println(p24[2]);
  
   
    servo1.write((pi-alpha13)*180/pi-10);
    servo2.write((pi-beta13)*180/pi);
    servo3.write((gamma13)*180/pi);
  
    servo4.write((pi-alpha24)*180/pi);
    servo5.write(beta24*180/pi);
    servo6.write((pi-gamma24)*180/pi);
  
    servo7.write( atan2(p13[2],p13[0]*-rot)*180/pi+5); //alpha13
    servo8.write(beta13*180/pi);
    servo9.write((pi-gamma13)*180/pi);
  
    servo10.write(atan2(p24[2],p24[0]*-rot)*180/pi+10);//alpha24
    servo11.write((pi-beta24)*180/pi);
    servo12.write((gamma24)*180/pi);
  
 
 
  
 
  
}
