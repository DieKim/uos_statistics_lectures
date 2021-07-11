# data(iris)
# data = iris[,1:4]
# centers = 2
# 
# result = kmeans(iris[,1:4], 3, iter.max = 20, algorithm = "Lloyd")
# 
# result = mykmeans(data = iris[,1:4], centers = 3, 50)
# 
# table( iris[result$cluster==1, 5] )
# table( iris[result$cluster==2, 5] )
# table( iris[result$cluster==3, 5] )


euclid = function(x, y)
{
  return(sqrt(sum((x - y)^2)))
}


euclid_mat = function(x, y)
{
  return(sqrt(colSums((x - y)^2)))
}

manhattan = function(x, y) 
{
  return(colSums(abs(x - y)))
}

dist_fun = euclid_mat
# dist_fun = manhattan

#### Clustering function ####
mykmeans = function(data, centers, iter.max = 50){
  # data : matrix or dataframe
  # centers : scalar or vector
  #           scalar means number of clusters and vector means medoids of each clusters.
  # iter.max : maximum number of iterations
  # par(mfrow = c(2,4))
  
  colClass = sapply(data, 2, function(x) class(x))
  colClass_ind = colClass %in% c("numeric")
  
  if (any(colClass %in% "character")) {
    stop("K-means does not allow characters")
  }
  
  if (sum(!colClass_ind) > 0) {
    warn_text = paste("Types of ", paste(which(colClass_ind == FALSE), collapse = ","), 
                       " columns are ", paste(colClass[colClass_ind == FALSE], collapse = ","), 
                       ". ", "Converts to numeric", sep = "")
    warning(warn_text)
  }
  
  data_mat = as.matrix(data) 
  n = nrow(data_mat)
  p = ncol(data_mat)
  
  center_mat = matrix(nrow = centers, ncol = p)
  cluster = sample(1:centers, n, replace = TRUE)
  
  for (i in 1:centers) {
    center_mat[i, ] = colMeans(data_mat[cluster == i, , drop = FALSE])
  }
  
  dist = matrix(nrow = n, ncol = centers)
  
  iter = 0
  center_mat_old = center_mat
  
  while ((iter = iter + 1) < iter.max) {
    # calcuate distance to each center
    # for (i in 1:centers){
    #     dist[,i] = apply(data_mat, 1, function(x) euclid(x, center_mat[i, , drop = FALSE])) 
    # } 
    for (i in 1:centers) {
      dist[, i] = dist_fun(t(data_mat), drop(center_mat[i, , drop = FALSE]))
    }
    
    cluster = apply(dist, 1, which.min) # make cluster
    
    # update cluster mean
    for(i in 1:centers){
      center_mat[i, ] = colMeans(data_mat[cluster == i, , drop = FALSE])
    } 
    
    if (sum(is.nan(center_mat)) > 0) {
      cluster = sample(1:centers, n, replace = TRUE)
      
      for (i in 1:centers) {
        center_mat[i, ] = colMeans(data_mat[cluster == i, , drop = FALSE])
      }
    }
    
    if (sqrt(sum((center_mat_old - center_mat)^2)) < 1e-10) {
      break
    } else {
      center_mat_old = center_mat
    }
    # plot(data_mat[,1:2], col = cluster)
    # points( x = center_mat[,1], y = center_mat[,2], pch="+", col = "blue", cex = 2)
  }
  
  result = list(cluster = cluster, centers = center_mat, iter = iter)
  return(result)
}


