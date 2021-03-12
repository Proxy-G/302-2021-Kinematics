Bone bone;
Bone draggedBone;

float time = 0; //how many seconds have passed since start

Bone mostRecentlyAddedBone;

void setup()
{
  size(600,600, P2D);
  bone = new Bone(5);
}

//ticks every 1/60th of sec
void draw()
{
  background(128);
  
  time = millis()/1000.0; //calc time
  
  if(draggedBone != null) draggedBone.drag();
  
  if(Keys.T() && mostRecentlyAddedBone != null){
    mostRecentlyAddedBone.removeFromParent();
    mostRecentlyAddedBone = null;
  }
  
  bone.calc();
  bone.draw();
}

void mousePressed() {
  Bone clickedBone = bone.onClick();
  
  if(Keys.SHIFT()) {
    if(clickedBone != null) {
      clickedBone.addBone(1);
    }
  }
  else
  {
    draggedBone = clickedBone;
  }
}

void mouseReleased() {
  draggedBone = null;
}
