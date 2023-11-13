
/*
Comparator sorting vectors based on magnitude
*/
class VectorComparator implements Comparator<PVector> {
    public int compare(PVector p_1, PVector p_2)
    {   
        float mag_p_1 = p_1.mag();
        float mag_p_2 = p_2.mag();
       
        if(mag_p_1 < mag_p_2){
            return -1;
        } else if (mag_p_1 == mag_p_2){
            return 0;
        } else{
            return 1;
        }
    }
}

/*
Comparator sorting points based on x coordinates
*/
class XCoordinateComparator implements Comparator<Point> {
    public int compare(Point p_1, Point p_2)
    {   

        if(p_1.getX() < p_2.getX()){
            return -1;
        } else if (p_1.getX() == p_2.getX()){
            return 0;
        } else{
            return 1;
        }
    }
}


/*
Comparator sorting points based on y coordinates
*/
class YCoordinateComparator implements Comparator<Point> {
    public int compare(Point p_1, Point p_2)
    {   

        if(p_1.getY() < p_2.getY()){
            return -1;
        } else if (p_1.getY() == p_2.getY()){
            return 0;
        } else{
            return 1;
        }
    }
}

/*
Node used in KD-Tree and Range search Tree
*/
class Node{
   int left_val;
   int right_val;
   Point left_pt;
   Point right_pt;
   Node left;
   Node right;
   Point pt;
   boolean isHorizontal;
   boolean isVertical;
   boolean hasXLine;
   boolean hasYLine;
   float x_coordinate;
   float y_coordinate;
}


/*
Standard approach for searching k nearest neighbor.
*/
ArrayList<Point> standardKNNSearch(ArrayList<Point> points, int k, Point query){
    
    ArrayList<Point> kNN = new ArrayList<Point>();
    
    ArrayList<PVector> vector_list = new ArrayList<PVector>();
    HashMap<PVector, Point> vector_to_map = new HashMap<PVector, Point>();
    
    for(int i = 0; i < points.size(); i++){
        Point p_i = points.get(i);
        PVector v_i = new PVector(p_i.getX() - query.getX(),p_i.getY() - query.getY());
        
        vector_list.add(v_i);
        vector_to_map.put(v_i,p_i);
    }
    
    VectorComparator cmp = new VectorComparator();
    Collections.sort(vector_list, cmp);
    
    for(int i = 0; i < min(vector_list.size(), k); i++){
         PVector v_i = vector_list.get(i);
         Point p_i = vector_to_map.get(v_i);
         kNN.add(p_i);
    }
    
    return kNN;
}


/*
Build a KD-Tree
*/
Node BuildKDTree(ArrayList<Point> points, int depth){
    if(points.size()==1){  //<>//
       Node v = new Node();
       v.pt = points.get(0);
       return v; 
    } else if(depth % 2 == 0){
        ArrayList<Point> validPoints = new ArrayList<Point>();
        validPoints.addAll(points);
        
        XCoordinateComparator cmp = new XCoordinateComparator();  //<>//
        Collections.sort(validPoints,cmp);
        
        ArrayList<Point> leftPart = new ArrayList<Point>();
        ArrayList<Point> rightPart = new ArrayList<Point>();
        
        int midIndex = validPoints.size()/2;

        if(validPoints.size()%2==1){
            midIndex = validPoints.size()/2;
            
            for(int i = 0; i < midIndex;i++){
                leftPart.add(validPoints.get(i)); 
            }
        
            for(int i = midIndex + 1; i < validPoints.size();i++){
                rightPart.add(validPoints.get(i)); 
            }
           
        }else{
          midIndex = -1;
          int leftEnd =   validPoints.size()/2-1;
          int rightStart = leftEnd+1;
          for(int i = 0; i <= leftEnd;i++){
              leftPart.add(validPoints.get(i)); 
          }
          
          for(int i = rightStart; i < validPoints.size();i++){
              rightPart.add(validPoints.get(i)); 
          }    
        }
        

        Node v_left = BuildKDTree(leftPart, depth+1);
        Node v_right = BuildKDTree(rightPart, depth+1);
        
        Node v = new Node();
        v.hasXLine = true;
        v.hasYLine = false;
        v.left = v_left;
        v.right = v_right;  
        
        if(midIndex!=-1){
            v.pt = validPoints.get(midIndex);
        }
        
        return v;
    } else{
        ArrayList<Point> validPoints = new ArrayList<Point>();
        validPoints.addAll(points);
        
        YCoordinateComparator cmp = new YCoordinateComparator();
        Collections.sort(validPoints,cmp);
        
        ArrayList<Point> upperPart = new ArrayList<Point>();
        ArrayList<Point> lowerPart = new ArrayList<Point>();
        
        int midIndex = validPoints.size()/2;
       
        if(validPoints.size()%2==1){
            midIndex = validPoints.size()/2;
            
            for(int i = 0; i < midIndex;i++){
                lowerPart.add(validPoints.get(i)); 
            }
        
            for(int i = midIndex + 1; i < validPoints.size();i++){
                upperPart.add(validPoints.get(i)); 
            }
        }else{
          midIndex = -1;
          int leftEnd =   validPoints.size()/2-1;
          int rightStart = leftEnd+1;
          for(int i = 0; i <= leftEnd;i++){
              lowerPart.add(validPoints.get(i)); 
          }
          
          for(int i = rightStart; i < validPoints.size();i++){
              upperPart.add(validPoints.get(i)); 
          }    
        }
        
        Node v_upper = BuildKDTree(lowerPart,depth+1);
        Node v_lower = BuildKDTree(upperPart,depth+1);  //<>//
        
        Node v = new Node();
        v.hasXLine = false;
        v.hasYLine = true;
        v.left = v_lower;
        v.right = v_upper;
        
        if(midIndex!=-1){
            v.pt = validPoints.get(midIndex);
        }

        return v;
    }
}

/*
*/
ArrayList<Point> SearchkNNInKDTree(Node v, int k, Point queryPt){
    ArrayList<Point> kNN = new ArrayList<Point>();
    
    if(v.left==null && v.right==null){  //<>//
         Point p = v.pt;    
         kNN.add(p);
         return kNN;
    }
    
    if(v.hasXLine){
       ArrayList<Point> leftKNN = SearchkNNInKDTree(v.left, k, queryPt);
       ArrayList<Point> rightKNN = SearchkNNInKDTree(v.right, k, queryPt);  
       kNN.addAll(leftKNN);
       kNN.addAll(rightKNN);
    }
    
    if(v.hasYLine){
      ArrayList<Point> lowKNN = SearchkNNInKDTree(v.left, k, queryPt);
      ArrayList<Point> highKNN = SearchkNNInKDTree(v.right, k, queryPt);
      kNN.addAll(lowKNN);
      kNN.addAll(highKNN);
    }
    
    if(v.pt!=null){
      kNN.add(v.pt);
    }
    
    ArrayList<PVector> vector_list = new ArrayList<PVector>();
    ArrayList<Point> overallkNN = new  ArrayList<Point>();
    HashMap<PVector, Point> vector_point_map = new HashMap<PVector, Point>();
    
    for(int i = 0;i < kNN.size();i++){
       Point p_i = kNN.get(i);
       PVector v_i = new PVector(p_i.getX() - queryPt.getX(), p_i.getY() - queryPt.getY());
       vector_point_map.put(v_i, p_i);
       vector_list.add(v_i);
    }
    
    VectorComparator cmp = new VectorComparator();
    Collections.sort(vector_list,cmp);
    
    
    for(int i = 0; i < min(k, kNN.size());i++){
        PVector v_i = vector_list.get(i);
        Point kNN_i =  vector_point_map.get(v_i);
        
        overallkNN.add(kNN_i);
    }
 
    return overallkNN;
}

/*
Searching within KD-Tree
*/
ArrayList<Point> KDTreeSearch(ArrayList<Point> points, int k, Point query){
    int depth = 0;
    Node v = BuildKDTree(points, depth);
    ArrayList<Point> kNN = SearchkNNInKDTree(v, k, query);

    return kNN;
}

/*
Building Range Tree
*/
Node BuildRangeTree(ArrayList<Point> points){
    if(points.size()==1){  //<>//
       Node v = new Node();
       v.pt = points.get(0);
       return v;
    }else{
      ArrayList<Point> validPoints = new ArrayList<Point>();
      validPoints.addAll(points);
      XCoordinateComparator cmp = new XCoordinateComparator();
      Collections.sort(validPoints, cmp);
      
      int midIndex = validPoints.size()/2;
      
      ArrayList<Point> leftPart = new ArrayList<Point>();
      ArrayList<Point> rightPart = new ArrayList<Point>();
      
      if(validPoints.size()%2==1){       
          midIndex = validPoints.size()/2;
        
      for(int i = 0; i < midIndex; i++){
          leftPart.add(validPoints.get(i));   
      }
      
      for(int i = midIndex + 1; i < validPoints.size();i++){
          rightPart.add(validPoints.get(i));
      }
        
      }else{
        midIndex = -1;
        int leftEnd =   validPoints.size()/2-1;
        int rightStart = leftEnd+1;
        
        for(int i = 0; i <= leftEnd;i++){
            leftPart.add(validPoints.get(i));   
        }
        
        for(int i = rightStart; i < validPoints.size();i++){
            rightPart.add(validPoints.get(i));
        }  
      }
      
      Node left_part = BuildRangeTree(leftPart);  //<>//
      Node right_part = BuildRangeTree(rightPart);
  
      Node v = new Node();
      v.left = left_part;
      v.right = right_part;
      
      if(midIndex!=-1){
          v.pt = validPoints.get(midIndex);
      }
      
      return v;

    }
 
}

/*
Search within Range Tree
*/
ArrayList<Point> SearchKNNInRangeTree(Node v, int k, Point queryPt){
    ArrayList<Point> kNN = new ArrayList<Point>();
    
    if(v.left==null && v.right==null){
        kNN.add(v.pt);
        return kNN;
    }
    
    
    ArrayList<Point> kNN_left =  SearchKNNInRangeTree(v.left,k,queryPt); //<>// //<>// //<>//
    ArrayList<Point> kNN_right =  SearchKNNInRangeTree(v.right,k,queryPt);
    
    kNN.addAll(kNN_left);
    kNN.addAll(kNN_right);
    
    if(v.pt!=null){
        kNN.add(v.pt); 
    }
    
    
    ArrayList<PVector> vector_list = new ArrayList<PVector>();
    ArrayList<Point> overallkNN = new  ArrayList<Point>();
    HashMap<PVector, Point> vector_point_map = new HashMap<PVector, Point>();
    
    for(int i = 0;i < kNN.size();i++){
       Point p_i = kNN.get(i);
       PVector v_i = new PVector(p_i.getX() - queryPt.getX(), p_i.getY() - queryPt.getY());
       vector_point_map.put(v_i, p_i);
       vector_list.add(v_i);
    }
    
    VectorComparator cmp = new VectorComparator();
    Collections.sort(vector_list,cmp);
    
    
    for(int i = 0; i < min(k, kNN.size());i++){
        PVector v_i = vector_list.get(i);
        Point kNN_i =  vector_point_map.get(v_i);
        
        overallkNN.add(kNN_i);
    }
 
    return overallkNN;
}


/*
Return kNN using Range Tree Search Technique
*/
ArrayList<Point> RangeTreeSearch(ArrayList<Point> points, int k, Point query){
    
   Node v = BuildRangeTree(points);
   ArrayList<Point> kNN =  SearchKNNInRangeTree( v, k, query);
  
   return kNN;
}
