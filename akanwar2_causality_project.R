# Load the libraries 
# To install pcalg library you may first need to execute the following commands:
# source("https://bioconductor.org/biocLite.R")
# biocLite("graph")
# biocLite("RBGL")
# biocLite("Rgraphviz")
# Rgraphviz is needed to plot casual graph from PC algorithm

library("vars")
library("urca")
library("pcalg")

# Read the input data 
causal_data = read.csv("data.csv", header = TRUE)
# Build a VAR model 
model = VAR(causal_data, type ="const", lag.max=10, ic="SC" )
# Select the lag order using the Schwarz Information Criterion with a maximum lag of 10
# see ?VARSelect to find the optimal number of lags and use it as input to VAR()

# Extract the residuals from the VAR model 
# see ?residuals
resd = resid(model)

# Check for stationarity using the Augmented Dickey-Fuller test 
# see ?ur.df
stat1 = ur.df(resd[,1])
stat2 = ur.df(resd[,2])
stat3 = ur.df(resd[,3])

summary(stat1)
summary(stat2)
summary(stat3)
# Check whether the variables follow a Gaussian distribution  
# see ?ks.test
test1 = ks.test(as.numeric(resd[,1]), "pnorm")
test2 = ks.test(as.numeric(resd[,1]), "pnorm")
test3 = ks.test(as.numeric(resd[,1]), "pnorm")

summary(test1)
summary(test2)
summary(test3)

test1
test2
test3

# Write the residuals to a csv file to build causal graphs using Tetrad software
write.csv(resd, file = "residuals.csv", row.names = FALSE)

# OR Run the PC and LiNGAM algorithm in R as follows,
# see ?pc and ?LINGAM 

# PC Algorithm
pc.data = list(C=cor(resd), n=nrow(resd))
pc.fit = pc(pc.data, indepTest=gaussCItest, alpha=0.1, labels=colnames(resd), skel.method="original")
plot (pc.fit, main="PC Algorithm")

# LiNGAM Algorithm
lingam.fit = lingam(resd, verbose = TRUE)
show(lingam.fit)
lingam.plt <- as(lingam.fit, "amat")
lingam.plt
