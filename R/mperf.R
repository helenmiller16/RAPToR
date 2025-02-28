#' Model performance
#' 
#' Computes indices of model performance from real data and predictions.
#' 
#' @param Y,Yh The data and predictions matrices respectively with variables as columns, observations as rows ; must have the same dimensions.
#' @param global if TRUE (default), averages the index over all variables.
#' @param to_compute a vector with the indices to compute among c("aCC", "aRE", "MSE", "aRMSE").
#' @param is.t boolean ; if TRUE, Y and Yh should be transposed.
#' 
#' 
#' @section Indices:
#' 
#' Let \eqn{y} and \eqn{\hat{y}} be the data and predictions respectively, with \eqn{m} dependant variables and \eqn{n} observations.
#' The model performance indices are defined as follows.
#' 
#' \describe{
#'   \item{aCC}{average Correlation Coefficient. 
#'   \deqn{aCC=\frac{1}{m}\sum^{m}_{i=1}{CC}=\frac{1}{m}\sum^{m}_{i=1}{\cfrac{\sum^{n}_{j=1}{(y_i^{(j)}-\bar{y}_i)(\hat{y}_i^{(j)}-\bar{\hat{y}}_i)}}{\sqrt{\sum^{n}_{j=1}{(y_i^{(j)}-\bar{y}_i)^2(\hat{y}_i^{(j)}-\bar{\hat{y}}_i)^2}}}}}
#'   }
#'   
#'   \item{aRE}{average Relative Error. 
#'   \deqn{a\delta = \frac{1}{m}\sum^{m}_{i=1}{\delta} = \frac{1}{m} \sum^{m}_{i=1} \frac{1}{n} \sum^{n}_{j=1} \cfrac{| y_i^{(j)} - \hat{y}_i^{(j)} | }{y_i^{(j)}}}
#'   }
#'   
#'   \item{MSE}{Mean Squared Error. 
#'   \deqn{MSE = \frac{1}{m} \sum^{m}_{i=1} \frac{1}{n} \sum^{n}_{j=1} (y_i^{(j)} - \hat{y}_i^{(j)} )^2}
#'   }
#'   
#'   \item{aRMSE}{average Root Mean Squared Error. 
#'   \deqn{aRMSE = \frac{1}{m}\sum^{m}_{i=1}{RMSE} = \frac{1}{m} \sum^{m}_{i=1} \sqrt{\cfrac{\sum^{n}_{j=1} (y_i^{(j)} - \hat{y}_i^{(j)} )^2}{n}}}
#'   }
#' }
#' 
#' 
#' @examples 
#' 
#' m1 <- matrix(rnorm(1000), ncol = 5)
#' m2 <- matrix(rnorm(1000), ncol = 5)
#' mperf(m1, m2, is.t = TRUE)
#' 
#' @export
#' 
mperf <- function(Y, Yh, global = TRUE, 
                  to_compute = c("aCC", "aRE", "MSE", "aRMSE"),
                  is.t = FALSE){
  
  if(!all(dim(Y) == dim(Yh)))
    stop("Y and Yh must have the same dimensions")
  if(is.t){
    Y <- t(Y)
    Yh <- t(Yh)
  }
    
  res <- list()
  d <- ncol(Y)
  n <- nrow(Y)
  
  
  if("aCC" %in% to_compute){
    if(global){
      suppressWarnings(acc <- sum(mapply(cor, as.data.frame(Y), as.data.frame(Yh)), na.rm = T)/d)
    }
    else suppressWarnings(acc <- mapply(cor, as.data.frame(Y), as.data.frame(Yh)))
    
    res$aCC <- acc
  }
  
  if("aRE" %in% to_compute){
    
    if(global){
      are <- abs(Y-Yh)/ Y
      are <- sum(are[are < Inf], na.rm = T)/(d*n)
    } else are <- colSums( abs(Y-Yh)/ Y)/n
    
    res$aRE <- are
  }
  
  if("MSE" %in% to_compute | "aRMSE" %in% to_compute){
    
    if(global){
      mse <- sum((Y-Yh)^2, na.rm = TRUE)/(d*n)
    } else mse <- colSums((Y-Yh)^2)/n
    
    res$MSE <- mse
  }
  
  
  if("aRMSE" %in% to_compute){
    res$aRMSE <- sqrt(mse)
  }

  return(res)
}
