class Bone
{
  //properties
  
  //relative direction for bone points, radians
  //if 0, then this bone points same way as parent
  float dir = random(-1,1);
  
  //length of bone in pixels
  float mag = random(50, 150);
  
  //references to parent and child bones
  //(implementing linked list data struct)
  Bone parent;
  ArrayList<Bone> children = new ArrayList<Bone>();
  
  boolean isRevolute = true; //can change angle?
  boolean isPrismatic = true; //can change length?
  
  float wiggleOffset = random(0,6.28);
  float wiggleAmp = random(.5f, 2);
  float wiggleTimeScale = random(.25f, 1);
  
  //cached/derived values
  PVector worldStart; //start of bone in world space
  PVector worldEnd; //end of bone in world space
  float worldDir = 0; //world space angle of bone
  int boneDepth = 0; //how "deep" in armature
  
  Bone(Bone parent) {
    this.parent = parent;
    //calc the DEPTH of the bone by traversing its parents
    int num = 0;
    Bone p = parent;
    while (p != null) {
      num++;
      p = p.parent;
    }
    boneDepth = num;
  }
    
  Bone(int chainLength) {
    if(chainLength > 1) addBone(chainLength - 1);
  }
  
  void addBone (int chainLength) {
    if(chainLength < 1) chainLength = 1;
    
    int numOfChildren = (int)random(1, 4);
    
    for(int i = 0; i < numOfChildren; i++)
    {
      Bone newBone = new Bone(this);
      children.add(newBone);
      
      if(chainLength > 1) newBone.addBone(chainLength-1);
    }
  }
  
  void removeFromParent(){
    if(parent == null) return;
    parent.children.remove(this);
  }
  
  void draw() {
    
    //draw line from bone start to bone end
    line(worldStart.x, worldStart.y, worldEnd.x, worldEnd.y);
    
    fill(100,100,200);
    ellipse(worldStart.x, worldStart.y, 20, 20);
    
    for(Bone child: children) child.draw();
    
    fill(150,150,200);
    ellipse(worldEnd.x, worldEnd.y, 15, 15);
  }
  
  void calc() {
    //calc bone start
    
    if(parent != null) {
      worldStart = parent.worldEnd;
      worldDir = parent.worldDir + dir;
    }
    else { //default values if parent is null:
      worldStart = new PVector(100,100);
      worldDir = dir;
    }
    
    worldDir += sin((time + wiggleOffset)*wiggleTimeScale) * wiggleAmp;
    
    //calc bone end
    PVector localEnd = PVector.fromAngle(worldDir);
    localEnd.mult(mag);
    
    worldEnd = PVector.add(worldStart, localEnd);
    
    //tell child bone(s) to calc
    for(Bone child: children) child.calc();
  }
  
  Bone onClick() {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector vToMouse = PVector.sub(mouse, worldEnd);
    
    //if dis to mouse < 20px, return this bone
    if(vToMouse.mag() < 20) return this;
    
    // checks all child bones:
    for(Bone child: children) 
    {
      Bone b = child.onClick();
      if(b != null) return b;
    }
    
    return null;
  }
  
  void drag()
  {
    PVector mouse = new PVector(mouseX, mouseY);
    PVector vToMouse = PVector.sub(mouse, worldStart);
    
    if(isRevolute)
    {
      if(parent != null) dir = vToMouse.heading() - parent.worldDir;
      else dir = vToMouse.heading(); //root bone can point right at mouse
    }
    if(isPrismatic) mag = vToMouse.mag();
    
  }
}
