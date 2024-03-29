install.packages('caTools')
install.packages('ROCR')

library(caTools)
library(ROCR)

# ----------------------  Importamos funciones  ----------------------  
source("./funciones/main.R")

set.seed(88)
split <- sample.split(encuestas$IdNivelEducativo, SplitRatio = 0.75)

#get training and test data
dresstrain <- subset(encuestas, split == TRUE)
dresstest <- subset(encuestas, split == FALSE)


#logistic regression model
model <- glm (IdNivelEducativo ~ IdTipoDeEmpresa + IdProvincia, data = encuestas, family = binomial)
summary(model)

predict <- predict(model, type = 'response', newdata=dresstrain, probability=TRUE)

#confusion matrix
table(dresstrain$IdNivelEducativo, predict > 0.5)



#ROCR Curve
labels <- dresstrain$IdNivelEducativo


ROCRpred <- prediction(predict, labels)
ROCRperf <- performance(ROCRpred, 'tpr','fpr')
plot(ROCRperf, colorize = TRUE, text.adj = c(-0.2,1.7))