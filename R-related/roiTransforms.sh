#! /usr/bin/Rscript

args <- commandArgs(TRUE)
inFile=args[1]
outFile=args[2]
source('/pasteur/projets/specific/PF2_ngs/protected/scripts/Rnw/rfunctions/readROI.R')
source('/pasteur/projets/specific/PF2_ngs/protected/scripts/Rnw/rfunctions/writeROI.R')
print(inFile)
print(outFile)

roi=readROI(inFile)


roi$min = as.numeric(lapply(roi$counts ,min))
roi$median =  as.numeric(lapply(roi$counts ,median))
roi$mean =  as.numeric(lapply(roi$counts ,mean))
roi$quantile75 =  as.numeric(lapply(roi$counts ,quantile, probs=0.75))
roi$quantile95 =  as.numeric(lapply(roi$counts ,quantile, probs=0.95))


nac <- function(v){
  m=max(v)
  if(m==0)return (0)
  return (sum(v)/m/length(v))
}
roi$nac  =  as.numeric(lapply(roi$counts ,nac))

xreaXX <- function(v){
  vo=order(v)
  mx = max(v)
  mi = min(v)
  if((mx-mi)==0) return(0)
  vn=(v-mi)/(mx-mi)
  x=c(1:length(v))/length(v)
  vno=vn[vo]
  return(sum(x-vno)/length(v))
}
roi$xreaXX  =  as.numeric(lapply(roi$counts ,xreaXX))

changeSum <- function(v){
   v1 = append(v, v[length(v)])
   v2 = append(v[1], v)
   return( sum(abs(v2-v1)))
}
roi$changeSum = as.numeric(lapply(roi$counts ,changeSum))

changeSumN <- function(v){
   v1 = append(v, v[length(v)])
   v2 = append(v[1], v)
   m=max(v)
   if(m>0)nenner=m
   else nenner=1
   return( sum(abs(v2-v1))/nenner)
}
roi$changeSumN = as.numeric(lapply(roi$counts ,changeSumN))

meanMMedianN <- function(v){
   if(max(v)==0)return (0)
   v1 = v/max(v)
   return (mean(v1)-median(v1))
}
roi$meanMMedianN = as.numeric(lapply(roi$count, meanMMedianN))

meanMMedian <- function(v){
   v1 = v
   return (mean(v1)-median(v1))
}
roi$meanMMedian = as.numeric(lapply(roi$count, meanMMedian))

medianN <- function(v){
   if(max(v)==0)return (0)
   return(median(v/max(v)))
}
roi$medianN = as.numeric(lapply(roi$count, medianN))


library('boot')
roi$r3linear = as.numeric(lapply(roi$counts ,k3.linear))

distMax3p <- function(v){
   return(length(v)-which.max(rev(v))+1)
}
roi$distMax3p = as.numeric(lapply(roi$count, distMax3p))

distMax5p <- function(v){
   return (which.max(v))
}
roi$distMax5p = as.numeric(lapply(roi$count, distMax5p))


#data=roi[,8:length(roi)-1]
#pca=princomp(data, na.action=na.exclude)
#prj=predict(pca, data)
#roi$pca1=prj[,1]
#roi$pca2=prj[,2]

writeROI(roi, outFile)

q(status=0)

