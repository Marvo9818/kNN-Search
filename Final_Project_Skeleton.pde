        
import java.util.*;

ArrayList<Point>    points       = new ArrayList<Point>();        //// Points for querying
ArrayList<Point>    kNNs =   new ArrayList<Point>();              /// k nearest neighbors result

boolean saveImage = false;            
boolean generatePoints = false;
boolean generateQueryPoint = false;
String searchMode = "Standard kNN";
int modeVal = 0;

int numOfPoints = 4;              ///// number of points
int numOfNeighbors = 3;           ///// number of neighbors

Point queryPoint = null;          ///// Query point to calculate k nearest neighbors

void setup(){
  size(800,800,P3D);
  frameRate(30);
}

/*
Draw data points, query point as a benchmark for calculating kNN and the kNNs returned.
In addition to that, display all the option to modify data points, query points, 
query mode or even search mode.
*/
void draw(){
  background(255);
  
  translate( 0, height, 0);
  scale( 1, -1, 1 );
  
  strokeWeight(3);
  
  fill(0);
  noStroke();
  for( Point p : points ){
    p.draw();
  }
  
  noFill();
  stroke(100);
  
  if(queryPoint!=null){
  color c_queryPt = color(0, 0, 255);
  fill(c_queryPt);
  noStroke();
  ellipse(queryPoint.getX(),queryPoint.getY(), 20,20);
  noFill();
  stroke(100);
  }
  
  color c = color(255, 0, 0);
  fill(c);
  noStroke();
  for(Point p : kNNs ){
     ellipse(p.getX(),p.getY(), 20,20);
  }
  noFill();
  stroke(100);
  
  fill(0);
  stroke(0);
  textSize(18);
  
  textRHC( "Controls", 10, height-20 );
  textRHC( "+/-: Increase/Decrease Number of Random Points Generated", 10, height-40 );
  textRHC( "i/d: Increase/Decrease Number of neighbors", 10, height-60 );
  textRHC( "q: Shift Query/Non-Query Points", 10, height-80 );
  textRHC( "g: Generate " + numOfPoints + " Random Point(s)", 10, height-100 );
  textRHC( "c: Clear Points", 10, height-120 );
  textRHC( "s: Save Image", 10, height-140 );
  textRHC( "t: Performance testing", 10, height-160 );
  textRHC( "f: Switching Searching Mode", 10, height-180 );
  textRHC( "Number of neighbors: " + numOfNeighbors, 10, height-200);
  textRHC( "Generate Query Point: " + generateQueryPoint, 10, height-220);
  textRHC( "Search Mode: " + searchMode, 10, height-240);
  
  for( int i = 0; i < points.size(); i++ ){
    textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
  }
  
  if( saveImage ) saveFrame( ); 
  saveImage = false;
  
}

/*
 Change the searching mode
*/
void ChangeMode(){
    modeVal = (modeVal + 1)% 3;
    
    switch(modeVal){
      case 0:
        searchMode = "Standard kNN";
        break;
      case 1:
        searchMode = "KD-Tree";
        break;
      case 2:
        searchMode = "Range Tree";
        break;
      default:
        searchMode = "N/a";
        break;
    }
}


/*
  Find kNNs
 */
void FindKNN(){
   kNNs.clear();
   ArrayList<Point> result = new ArrayList<Point>();;
   Node v;
   
   switch(modeVal){
      case 0:
        searchMode = "Standard kNN";
        result = standardKNNSearch(points, numOfNeighbors, queryPoint);
        break;
      case 1:
        searchMode = "KD-Tree";
        v = BuildKDTree(points, 0);
        result = SearchkNNInKDTree(v, numOfNeighbors, queryPoint);
        break;
      case 2:
        searchMode = "Range Tree"; 
        v = BuildRangeTree(points);
        result = SearchKNNInRangeTree(v, numOfNeighbors, queryPoint);
        break;
   }
    //<>//
   
   kNNs.addAll(result);
   
}


void keyPressed(){
  if( key == 's' ) saveImage = true;
  if( key == '+' ){ numOfPoints++;  }
  if( key == '-' ){ numOfPoints = max( numOfPoints-1, 1 ); }
  if( key == 'g' ){ generateQueryPoint = false; makeRandomPointsVersion1(numOfPoints);}
  if( key == 'q' ){ generateQueryPoint = ! generateQueryPoint; }
  if( key == 'c' ){ points.clear();  kNNs.clear(); generateQueryPoint = false; queryPoint = null; }
  if( key == 't' ){ points.clear();  kNNs.clear(); queryPoint = null; PerformanceTest(); }
  if( key == 'f' ){ ChangeMode();}
  if( key == 'i' ){ numOfNeighbors++;}
  if( key == 'd' ){ numOfNeighbors = max( numOfNeighbors-1, 1 ); }
}



void textRHC( int s, float x, float y ){
  textRHC( Integer.toString(s), x, y );
}


void textRHC( String s, float x, float y ){
  pushMatrix();
  translate(x,y);
  scale(1,-1,1);
  text( s, 0, 0 );
  popMatrix();
}

Point sel = null;

void mousePressed(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  
  float dT = 6;
  for( Point p : points ){
    float d = dist( p.p.x, p.p.y, mouseXRHC, mouseYRHC );
    if( d < dT ){
      dT = d;
      sel = p;
    }
  }
  
  if( sel == null ){
    if(generateQueryPoint){
         queryPoint = new Point(mouseXRHC,mouseYRHC);
         FindKNN();
    }else{
       sel = new Point(mouseXRHC,mouseYRHC);
       points.add( sel );
    }
  }
}

void mouseDragged(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  if( sel != null ){
    sel.p.x = mouseXRHC;   
    sel.p.y = mouseYRHC;
  }else{
     if(generateQueryPoint){
         queryPoint = new Point(mouseXRHC,mouseYRHC);
         FindKNN();
    } 
  }
}

void mouseReleased(){
  sel = null;
}




  
