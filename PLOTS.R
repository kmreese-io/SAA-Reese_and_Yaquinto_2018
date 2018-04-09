## MIND THE GAP: THE MESA VERDE NORTH ESCARPMENT
## KELSEY M. REESE AND BRIAN YAQUINTO
## SOCIETY FOR AMERICAN ARCHAEOLOGY ANNUAL MEETING 
## Mesa Verde Ancestral Pueblo Villages: Recent Research
## Poster Session Chair: Donna M. Glowacki
## Washington, D.C. 2018

## PLOTS ##

################################################################################################
## POSTER: Background image for poster

pdf('./ANALYSIS/PLOTS/POSTER.pdf',height=9,width=16)
par(bg=NA,mai=c(0.00,0.00,0.00,0.00))

## Base plot
plot(1,type="n",xlab='',ylab='',xlim=c(xmin(plot.extent),xmax(plot.extent)),ylim=c(ymin(plot.extent),ymax(plot.extent)),xaxs="i",yaxs="i",axes=F,main='')
plot(plot.hillshade,col=colors(10000),legend=F,add=T,axes=F)
plot(plot.dem,col=alpha(colors(10000),alpha=0.50),add=T,axes=F,legend=F)
points(sites.all,pch=20,cex=0.35)
plot(dem.study.hillshade,col=colors(10000),legend=F,add=T,axes=F)
plot(dem.study,col=alpha(colors(10000),alpha=0.50),add=T,axes=F,legend=F)
plot(survey.coverage,col=alpha('gray25',alpha=0.50),border=NA,add=T,axes=F)
plot(site.predictions.boundary,col=rev(heatcolors(10000)),zlim=c(cellStats(site.predictions.boundary,'min'),cellStats(site.predictions.boundary,'max')),add=T,axes=F,legend=F)
points(sites.study.survey,pch=20,cex=0.35)
plot(gray.layer,col=alpha('gray',alpha=0.40),add=T,axes=F,legend=F)

## Landform outline and study area inset
lines(study.boundary,col='black',lwd=2.0)

## Scale
# segments(702440+4000,4122100-1000,707440+4000,4122100-1000,xpd=T)
# segments(702440+4000,4122200-1000,702440+4000,4122000-1000,xpd=T)
# segments(704940+4000,4122200-1000,704940+4000,4122000-1000,xpd=T)
# segments(707440+4000,4122200-1000,707440+4000,4122000-1000,xpd=T)
# text(702440+100,4122075,'0',pos=2,cex=0.7,xpd=T)
# text(707440-100,4122075,'5 km',pos=4,cex=0.7,xpd=T)

dev.off()

################################################################################################
## SUBPLOT: Regional overview of study area

pdf('./ANALYSIS/PLOTS/SUBPLOT.pdf')
par(bg=NA,mai=c(0.00,0.00,0.00,0.00))

plot(state.boundaries,col='gray75',border='gray40',type="n",xlab='',ylab='',xlim=c(550000,900000),ylim=c(3700000,4650000),xaxs="i",yaxs="i",axes=F,main='')
plot(federal.boundaries[which(federal.boundaries$FEATURE1 == 'National Park' ),],col=alpha('darkgreen',alpha=0.5),border=NA,axes=F,add=T)
plot(federal.boundaries[which(federal.boundaries$FEATURE1 == 'National Monument' ),],col=alpha('darkgreen',alpha=0.5),border=NA,axes=F,add=T)
lines(plot.extent,lwd=2)
# text(450000,4300000,'UT',col='gray40',cex=2)
# text(950000,4300000,'CO',col='gray40',cex=2)
# text(450000,3900000,'AZ',col='gray40',cex=2)
# text(950000,3900000,'NM',col='gray40',cex=2)
box(lwd=7)

dev.off()

################################################################################################
## FIGURE 1: Total expected sites and households in the study area through time

results <- read.csv('./ANALYSIS/RESULTS/RESULTS.csv')

pdf('./ANALYSIS/PLOTS/FIGURE_1.pdf',height=3,width=8)
par(bg=NA,mai=c(0.6,0.6,0.1,0.1))

plot(results$midpoint,results$total.predicted.households,xlim=c(600,1300),ylim=c(0,max(results$total.predicted.households)),axes=FALSE,type='l',lwd=1,xlab='',ylab='',col=NA)
abline(v=c(600,results$end.years),lty=3,col='black')
lines(results$midpoint,results$total.known.sites)
points(results$midpoint,results$total.known.sites,pch=21,bg='black',cex=0.75)

lines(results$midpoint,results$total.predicted.sites,col='blue')
points(results$midpoint,results$total.predicted.sites,pch=15,col='blue',cex=0.75)

lines(results$midpoint,results$total.predicted.households,col='red')
points(results$midpoint,results$total.predicted.households,pch=15,bg='red',col='red',cex=0.75)

# lines(results$midpoint,results$total.known.households)
# points(results$midpoint,results$total.known.households,pch=21,bg='black',cex=0.75)

# lines(results$midpoint,results$momentized.households,col='red')
# points(results$midpoint,results$momentized.households,pch=17,bg='red',col='red',cex=0.75)

axis(1,at=seq(600,1300,50),tick=T,labels=F)
axis(2,at=seq(0,80,20),tick=T,labels=F)
mtext('N',side=2,line=1.75,cex=0.75,srt=180)
text(x=600-30,y=seq(0,80,20),as.character(seq(0,80,20)),xpd=T,pos=2,cex=0.75)
text(x=seq(600,1300,50)+15,y=-8,as.character(seq(600,1300,50)),xpd=T,pos=2,srt=45,cex=0.75)
mtext('Years (A.D.)',side=1,line=1.75,cex=0.75)

dev.off()

################################################################################################
## FIGURE 2-6: 3D layers used in the predictive model and legend colors

# DEM
plot3D(dem.region,drape=layer.1,col=terrain.colors(10000))
rgl.postscript('./ANALYSIS/PLOTS/FIGURE_2.pdf','pdf')

pdf('./ANALYSIS/PLOTS/FIGURE_2a.pdf')
plot(layer.1,legend.only=T,horiz=T,axis.args=list(labels=F,tck=F),col=terrain.colors(10000))
dev.off()

# Slope
slope.colors <- grDevices::colorRampPalette(c('royalblue2','firebrick1','red4'))
plot3D(dem.region,drape=layer.2,col=slope.colors(10000))
rgl.postscript('./ANALYSIS/PLOTS/FIGURE_3.pdf','pdf')

pdf('./ANALYSIS/PLOTS/FIGURE_3a.pdf')
plot(layer.2,legend.only=T,horiz=T,axis.args=list(labels=F,tck=F),col=slope.colors(10000))
dev.off()

# Aspect
aspect.colors <- grDevices::colorRampPalette(c(rev(heat.colors(10000)),heat.colors(10000)))
plot3D(dem.region,drape=layer.3,col=aspect.colors)
rgl.postscript('./ANALYSIS/PLOTS/FIGURE_4.pdf','pdf')

pdf('./ANALYSIS/PLOTS/FIGURE_4a.pdf')
plot(layer.3,legend.only=T,horiz=T,axis.args=list(labels=F,tck=F),col=rev(heat.colors(10000)))
dev.off()

# Paleoproductivity
paleoproductivity.colors <- grDevices::colorRampPalette(c('wheat','wheat','wheat','wheat','wheat','darkgreen'))
plot3D(dem.region,drape=layer.4,col=paleoproductivity.colors(10000))
rgl.postscript('./ANALYSIS/PLOTS/FIGURE_5.pdf','pdf')

pdf('./ANALYSIS/PLOTS/FIGURE_5a.pdf')
paleoproductivity.colors <- grDevices::colorRampPalette(c('wheat','wheat','darkgreen'))
plot(layer.4,legend.only=T,horiz=T,axis.args=list(labels=F,tck=F),col=paleoproductivity.colors(10000))
dev.off()

# Check dams
water.colors <- grDevices::colorRampPalette(c('cornsilk','darkblue','darkblue','darkblue','darkblue','darkblue','darkblue','darkblue','darkblue','darkblue'))
plot3D(dem.region,drape=layer.5,col=water.colors)
rgl.postscript('./ANALYSIS/PLOTS/FIGURE_6.pdf','pdf')

pdf('./ANALYSIS/PLOTS/FIGURE_6a.pdf')
water.colors <- grDevices::colorRampPalette(c('cornsilk','cornsilk','darkblue'))
plot(layer.5,legend.only=T,horiz=T,axis.args=list(labels=F,tck=F),col=water.colors(10000))
dev.off()

################################################################################################
## FIGURE_8: legend for predictive model results

pdf('./ANALYSIS/PLOTS/FIGURE_8.pdf')
plot(site.predictions,legend.only=T,horiz=T,axis.args=list(labels=F,tck=F),col=rev(heatcolors(10000)))
dev.off()
