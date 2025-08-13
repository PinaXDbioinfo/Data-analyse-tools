args <- commandArgs(trailingOnly = TRUE)
file_name <- args[1]

data<-read.csv(file_name ,sep = ",",header = T)

StatBox<-function(data){

#preparing data and libraries  
library(multcompView)
data<-na.omit(data)
formated_data<-c()

#reformate the data
for (i in 1:length(colnames(data))) {
  temp_group<-rep(colnames(data)[i],length(data[[i]]))
  temp_data<-cbind(temp_group,data[[i]])
  formated_data<-rbind(formated_data,temp_data)
}
formated_data<-as.data.frame(formated_data)
colnames(formated_data)<-c("Group","Values")
formated_data$Values<-as.numeric(formated_data$Values)

#asign colors to the groups
colors<-colorspace::sequential_hcl(length(unique(formated_data$Group)))
  
#Anova and tukey test
formated_data$Group <- as.factor(formated_data$Group)
anova_result <- aov(Values ~ Group, data = formated_data)
capture.output(print(summary(anova_result)), file ="anova.txt")
tukey<-TukeyHSD(anova_result)
capture.output(print(tukey), file ="tukey.txt")

#letters of significance
tukey_letras <- multcompLetters4(anova_result, tukey)
letras <- tukey_letras$Group$Letters
  
#BoxPlot with significance letters
pdf(tempfile())
box<-boxplot(data)
dev.off()

png("boxplot.png",width = 3000, height = 2100, res = 300)
boxplot(data, main="Boxplot with significance letters",cex.main=2,cex.axis=1.5,yaxt="n",
        col = colors,pch=16, bty="l",lwd = 2,lty = 1,medcol = "black",staplelty = 0)
axis(2, at = round(seq(min(formated_data$Values), max(formated_data$Values), 
                       by = max(formated_data$Values)/15),digits = 2),cex.axis=1.5,lwd = 2)
grupos <- as.character(unique(formated_data$Group))
grid(nx=10,ny=10)
for (j in 1:length(grupos)) {
  valores_grupo <- formated_data[formated_data$Group == grupos[j],][[2]]
  # Media
  media_valor <- mean(valores_grupo,na.rm = T)
  text(j, box$stats[3,j], labels = round(media_valor, 2), col = "black", pos = 1, font = 2,cex = 1.5) # Pos=3 pone el texto arriba
  
  # n en el bigote superior
  bigote_superior <- max(na.exclude(valores_grupo))
  text(j, bigote_superior, labels = paste0("n=", length(valores_grupo)), col = "black", pos = 2, 
       font = 2,cex = 1.5)
  text(j, box$stats[5,j], labels = letras[j][[1]], col = "black", pos = 4, 
       font = 2,cex = 1.5)
}
dev.off()

}

StatBox(data)