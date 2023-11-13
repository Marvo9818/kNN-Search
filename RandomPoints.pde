
/*
Generate Points on interval [50, width-50]x[50, height-50]
*/
void makeRandomPointsVersion1(int numOfPoints){
  points.clear();
  kNNs.clear();
  
  for( int i = 0; i < numOfPoints; i++){
    points.add( new Point( random(50,width-50), random(50,height-50) ) );
  }
  

}


/*
Generate Points on diagonal grids under 2x2 grid format.
*/
void makeRandomPointsVersion2(int numOfPoints){
  points.clear();
  kNNs.clear();
  
  int numOfClusters = 2;
  
  int[] points_cluster_arr = new int[numOfClusters];
  
  int points_per_cluster = numOfPoints/numOfClusters;
  
  for(int i = 0; i <  points_cluster_arr.length-1;i++){
       points_cluster_arr[i] =  points_per_cluster;
  }
  
  points_cluster_arr[points_cluster_arr.length-1] =  numOfPoints - points_per_cluster * (numOfClusters-1);
  
  float x_interval_val = width/numOfClusters;
  float y_interval_val = height/numOfClusters;
  
  for(int i = 0; i < 2;i++){
      float x_start = x_interval_val * i;
      float x_end = x_start + x_interval_val;
      
      float y_start = y_interval_val * i;
      float y_end = y_start + y_interval_val;
      
      for(int j = 0; j < points_cluster_arr[i]; j++){
      points.add( new Point( random(x_start,x_end), random(y_start,y_end) ) );
      }
      
  }
 
}


/*
Generate Points on diagonal grids under 3x3 grid format.
*/
void makeRandomPointsVersion3(int numOfPoints){
  points.clear();
  kNNs.clear();
  
  int numOfClusters = 3;
  
  int[] points_cluster_arr = new int[numOfClusters];
  int points_per_cluster = numOfPoints/numOfClusters;
  
  
  for(int i = 0; i <  points_cluster_arr.length-1;i++){
       points_cluster_arr[i] =  points_per_cluster;
  }
  
  points_cluster_arr[points_cluster_arr.length-1] =  numOfPoints - points_per_cluster * (numOfClusters-1);
  
  float x_interval_val = width/numOfClusters;
  float y_interval_val = height/numOfClusters;
  
  for(int i = 0; i < 3;i++){
      float x_start = x_interval_val * i;
      float x_end = x_start + x_interval_val;
      
      float y_start = y_interval_val * i;
      float y_end = y_start + y_interval_val;
      
      for(int j = 0; j < points_cluster_arr[i]; j++){
      points.add( new Point( random(x_start,x_end), random(y_start,y_end) ) );
      }
  }
 
}
