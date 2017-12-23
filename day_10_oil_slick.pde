//HAVE TO HAVE TO REFACTOR
//SUUUPER MESSY
    
//       IN ORDER B, P, G:

//  1. circle(.1)
//     swirl(p, .01)
//     swirl(p, .05)
//  2. circle(.1)
//     circle( .001)
//     swirl(circle(.5), .01)
//  3. swirl(circle(4), 2)
//     circle( .001)
//     circle(.5)
//  4. swirl(p, 4)
//     swirl(p .05)
//     swirl(p, 1)
//  5. circle(4)
//     circle(2)
//     circle(1)


//dynamic list of points
ArrayList<PVector> blue_field = new ArrayList<PVector>();
ArrayList<PVector> pink_field = new ArrayList<PVector>();
ArrayList<PVector> green_field = new ArrayList<PVector>();
ArrayList<ArrayList> fields = new ArrayList<ArrayList>();  // will contain the above

// colors used for points
color[] blue_pal = {
  color(0, 91, 197, 60),
  color(0, 180, 252, 60),
  color(23, 249, 255, 60),
  color(223, 147, 0, 60),
};

color[] pink_pal = {
  color(91, 0, 197, 60),
  color(180, 0, 252, 60),
  color(249, 23, 255, 60),
  color(147, 223, 0, 60),
};

color[] green_pal = {
  color(91, 197, 20, 60),
  color(160, 252, 20, 60),
  color(0, 255, 23, 60),
  color(0, 223, 220, 60),
};




float vector_scale = 0.01; // vector scaling factor, we want smAAAAall steps
float time = 0; // time passes by

void setup(){
  
  size(600, 600);
  strokeWeight(0.66);
  background(0, 5, 25);
  noFill();
  smooth(8);
  
  fields.add(blue_field);
  fields.add(pink_field);
  fields.add(green_field);
  println(fields);
  
  for (ArrayList f: fields){
    for (float x=-6; x<=6; x+=0.07) {
      for (float y=-6; y<=6; y+=0.07) {
        // create point slightly distorted
        PVector v = new PVector(x+randomGaussian()*0.05, y+randomGaussian()*0.05);
        f.add(v);
      }
    }
  }
}


void draw(){
  // for each field in fields (blue, pink, green)
  for (ArrayList<PVector> f: fields){
    int point = 0;
    color pal[];
    PVector v1;
    float time1;  // var in n1
    float time2;  // var in n2

    for (PVector p : f){
      // depending on the field, use these vars ~~~~~ REFACTOR
      if (f == blue_field){
        pal = blue_pal;
        v1 = swirl(p, 4);
        time1 = time;
        time2 = -time;
      } else if (f == pink_field) {
        pal = pink_pal;
        v1 = swirl(p, .05);
        time1 = -time;
        time2 = time;
      } else {
        pal = green_pal;
        v1 = swirl(p, 1);
        time1 = time;
        time2 = -time;
      }
      
      // map floating point coordinates to screen coordinates
      float xx = map(p.x, -6.5, 6.5, 0, width);
      float yy = map(p.y, -6.5, 6.5, 0, height);
      
      int cn = (int)(100*pal.length*noise(point))%pal.length;
      stroke(pal[cn], 15);
      point(xx, yy); //draw
       
      float n1 = map(noise(v1.x,v1.y, time1),0,1,-1,1);
      float n2 = map(noise(p.x/3, p.y/3, time2),0,1,-1,1);
      
      PVector v = waves2(new PVector(n1,n2),9);
      
      p.x += vector_scale * v.x;
      p.y += vector_scale * v.y;
      
      point++;
    }
   
   time += 0.001;
  
  }

}


//FUNCTIONS FOR SHAPES

PVector hyperbolic(PVector v, float amount) {
  float r = v.mag() + 1.0e-10;
  float theta = atan2(v.x, v.y);
  float x = amount * sin(theta) / r;
  float y = amount * cos(theta) * r;
  return new PVector(x, y);
}

PVector waves2(PVector p, float weight) {
  float x = weight * (p.x + 0.9 * sin(p.y * 4));
  float y = weight * (p.y + 0.5 * sin(p.x * 5.555));
  return new PVector(x, y);
}

PVector swirl(PVector p, float weight) {
  float r2 = sq(p.x)+sq(p.y);
  float sinr = sin(r2);
  float cosr = cos(r2);
  float newX = 0.8 * (sinr * p.x - cosr * p.y);
  float newY = 0.8 * (cosr * p.y + sinr * p.y);
  return new PVector(weight * newX, weight * newY);
}

PVector circle(float n) {
  return new PVector(sin(n), cos(n));
}