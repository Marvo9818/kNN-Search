
/*
Code for performance testing
*/
void PerformanceTest(){
  int maxNumOfPoints = 128000;
  int maxIterations = 250; 
  
  int start;
  int tDiff;
  
  int tStandardkNN;
  int tKDTree;
  int tRangeTree;
  int depth;
  
  println("Running Performance Test");
  for(int nPs = 1000; nPs <= maxNumOfPoints; nPs = nPs *2){
    
      System.out.println(nPs +" random points for the experiment of three algorithms with " + maxIterations + " iterations");     
      
      System.out.println("Testing with makeRandomPointsVersion1"); 
      start = millis();
      for(int i = 0; i < maxIterations; i++){
          makeRandomPointsVersion1(nPs);
          Point queryPt =  new Point( random(0,width), random(0,height));
          standardKNNSearch(points,numOfNeighbors,queryPt);
      }
      tStandardkNN  = (millis()-start);
      System.out.println("The standard KNN search costs: " + tStandardkNN  + " ms");
      
      
      start = millis();
      depth = 0;
      for(int i = 0; i < maxIterations; i++){
          makeRandomPointsVersion1(nPs);
          Point queryPt =  new Point( random(0,width), random(0,height));
          Node v1 = BuildKDTree(points, depth);
          SearchkNNInKDTree(v1, numOfNeighbors, queryPt);
      }
      tKDTree = (millis()-start);
      System.out.println("The KD-Tree costs: " + tKDTree + " ms");
      System.out.println("Improvement over standard kNN algorithm: " + (int)( 100.0f *(tStandardkNN-tKDTree)/(tStandardkNN) ) + "%" );
      
      
      start = millis();
      for(int i = 0; i < maxIterations; i++){
          makeRandomPointsVersion1(nPs);
          Point queryPt =  new Point( random(0,width), random(0,height));
          Node v2 = BuildRangeTree(points);
          SearchKNNInRangeTree(v2, numOfNeighbors, queryPt);
      }
      tRangeTree = (millis()-start);
      System.out.println("The Range Tree Algorithm costs: " + tRangeTree + " ms");
      System.out.println("Improvement over standard algorithm: " + (int)( 100.0f *(tStandardkNN-tRangeTree)/(tStandardkNN) ) + "%" );
      
      
      
      
      System.out.println("Testing with makeRandomPointsVersion2"); 
      start = millis();
      for(int i = 0; i < maxIterations; i++){
          makeRandomPointsVersion2(nPs);
          Point queryPt =  new Point( random(0,width), random(0,height));
          standardKNNSearch(points,numOfNeighbors,queryPt);
      }
      tStandardkNN  = (millis()-start);
      System.out.println("The standard KNN search costs: " + tStandardkNN  + " ms");
      
      
      start = millis();
      depth = 0;
      for(int i = 0; i < maxIterations; i++){
          makeRandomPointsVersion2(nPs);
          Point queryPt =  new Point( random(0,width), random(0,height));
          Node v1 = BuildKDTree(points, depth);
          SearchkNNInKDTree(v1, numOfNeighbors, queryPt);
      }
      tKDTree = (millis()-start);
      System.out.println("The KD-Tree costs: " + tKDTree + " ms");
      System.out.println("Improvement over standard kNN algorithm: " + (int)( 100.0f *(tStandardkNN-tKDTree)/(tStandardkNN) ) + "%" );
      
      
      start = millis();
      for(int i = 0; i < maxIterations; i++){
          makeRandomPointsVersion2(nPs);
          Point queryPt =  new Point( random(0,width), random(0,height));
          Node v2 = BuildRangeTree(points);
          SearchKNNInRangeTree(v2, numOfNeighbors, queryPt);
      }
      tRangeTree = (millis()-start);
      System.out.println("The Range Tree Algorithm costs: " + tRangeTree + " ms");
      System.out.println("Improvement over standard algorithm: " + (int)( 100.0f *(tStandardkNN-tRangeTree)/(tStandardkNN) ) + "%" );
      
      
      
      System.out.println("Testing with makeRandomPointsVersion3"); 
      start = millis();
      for(int i = 0; i < maxIterations; i++){
          makeRandomPointsVersion3(nPs);
          Point queryPt =  new Point( random(0,width), random(0,height));
          standardKNNSearch(points,numOfNeighbors,queryPt);
      }
      tStandardkNN  = (millis()-start);
      System.out.println("The standard KNN search costs: " + tStandardkNN  + " ms");
      
      
      start = millis();
      depth = 0;
      for(int i = 0; i < maxIterations; i++){
          makeRandomPointsVersion3(nPs);
          Point queryPt =  new Point( random(0,width), random(0,height));
          Node v1 = BuildKDTree(points, depth);
          SearchkNNInKDTree(v1, numOfNeighbors, queryPt);
      }
      tKDTree = (millis()-start);
      System.out.println("The KD-Tree costs: " + tKDTree + " ms");
      System.out.println("Improvement over standard kNN algorithm: " + (int)( 100.0f *(tStandardkNN-tKDTree)/(tStandardkNN) ) + "%" );
      
      
      start = millis();
      for(int i = 0; i < maxIterations; i++){
          makeRandomPointsVersion3(nPs);
          Point queryPt =  new Point( random(50,width-50), random(50,height-50));
          Node v2 = BuildRangeTree(points);
          SearchKNNInRangeTree(v2, numOfNeighbors, queryPt);
      }
      tRangeTree = (millis()-start);
      System.out.println("The Range Tree Algorithm costs: " + tRangeTree + " ms");
      System.out.println("Improvement over standard algorithm: " + (int)( 100.0f *(tStandardkNN-tRangeTree)/(tStandardkNN) ) + "%" );
      
      
    
  }
  
    
  
  
}
