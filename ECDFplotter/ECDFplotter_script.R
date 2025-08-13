args <- commandArgs(trailingOnly = TRUE)
file_name <- args[1]

data<-read.csv(file_name ,sep = ",",header = T)

ECDFplotter<-function(data){
  #PLOT DISTRIBUTION
  png("distribution.png",width = 3000, height = 2100, res = 300)
  plot(density(data[[1]]), col = "blue", lwd = 2,cex.lab = 1.5, cex.axis = 1.5,xaxt="n",
       xlim=c(min(min(density(data[[1]])$x),min(density(data[[2]])$x)),
              max(max(density(data[[1]])$x),max(density(data[[2]])$x))),
       bty="l", cex.axis = 1.5,cex.main = 2.5, main = "Distribution of the data",
       ylim=c(0,max(max(density(data[[1]])$y),max(density(data[[2]])$y))),xlab = "values")
  abline(v = mean(na.omit(data[[1]])), col = "slategray1",lwd = 3.5,lty = 2)
  
  lines(density(data[[2]]), col = "red", lwd = 2)
  abline(v = mean(na.omit(data[[2]])), col = "red4",lwd = 3.5,lty = 2)
  
  legend("topright",
         legend = c(colnames(data)[1],colnames(data)[2],
                    paste0("Mean ",colnames(data)[1],": ",round(mean(na.omit(data[[1]])),digits=2)),
                    paste0("Mean ",colnames(data)[2],": ",round(mean(na.omit(data[[2]])),digits = 2))),
         col = c("blue","red","slategray1","red4"),
         cex = 1,
         lwd = 3,
         lty = 2)
  grid()
  axis(1, cex=1.5,lwd = 2,
       at = round(seq(min(c(min(density(data[[1]])$x),min(density(data[[2]])$x))), 
                      max(c(max(density(data[[1]])$x),max(density(data[[2]])$x))), 
                      by = max(c(max(density(data[[1]])$x),max(density(data[[2]])$x)))/15),
                  digits = 2))
  dev.off()
  
  #ECDFs AND KOLMOGOTOV-SMIRNOV TEST
  
  ks_result<-ks.test(data[[1]], data[[2]])
  cdf_1 <- ecdf(data[[1]])
  cdf_2 <- ecdf(data[[2]])
  x_values <- seq(min(c(data[[1]], data[[2]])), max(c(data[[1]], data[[2]])), 
                  length.out = length(data[[1]]))
  
  png("ECDF.png",width = 3000, height = 2100, res = 300)
  plot(x_values, cdf_1(x_values), 
       type = "l", col = "blue", lwd = 4, cex.main=2, cex.axis=1.5, bty="l",lty = 1,cex.lab=1.5,
       xlab = "values", ylab = "ECDF", xaxt="n",
       main = paste0("ECDFs: ", colnames(data)[1]," vs ",colnames(data)[2]))
  lines(x_values, cdf_2(x_values), col = "red", lwd = 4, lty = 2)
  legend("topleft", legend = c(colnames(data[1]), colnames(data)[2],
                               paste0("KS-test: D = ", round(ks_result$statistic, 3), 
                                      ", \np = ", round(ks_result$p.value, 5))),
         col = c("blue", "red","white"), 
         lwd = 2, lty = c(1, 2))
  axis(1, cex=1.5,lwd = 2,
       at = round(seq(min(c(min(density(data[[1]])$x),min(density(data[[2]])$x))), 
                      max(c(max(density(data[[1]])$x),max(density(data[[2]])$x))), 
                      by = max(c(max(density(data[[1]])$x),max(density(data[[2]])$x)))/15),
                  digits = 2))
  dev.off()
  
  
}

ECDFplotter(data)
