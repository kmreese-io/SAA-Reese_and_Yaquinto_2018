## MIND THE GAP: THE MESA VERDE NORTH ESCARPMENT
## KELSEY M. REESE AND BRIAN YAQUINTO
## SOCIETY FOR AMERICAN ARCHAEOLOGY ANNUAL MEETING 
## Mesa Verde Ancestral Pueblo Villages: Recent Research
## Poster Session Chair: Donna M. Glowacki
## Washington, D.C. 2018

## ANALYSIS ##

#########################################################################################
#########################################################################################
## DEMOGRAPHY ESTIMATES

## Percentage area surveyed versus unsurveyed within study border
survey.coverage.proportion <- area(survey.coverage.study) / area(study.boundary)

## Separate sites by time period
time.period.list <- lapply(seq(48,61,1),2,FUN=function(x,...) {as.data.frame(sites.study.survey)[which(as.data.frame(sites.study.survey)[,x] >= 1 ),] } )

## Select only household sites for each time period to calculate total known number of households
time.period.list.sites <- lapply(time.period.list,FUN=function(x,...) { x[,48:61] } )
total.known.sites <- as.matrix(unlist(lapply(seq(1,14,1),FUN=function(x,...) { nrow(time.period.list.sites[[x]]) } )))

## Predict number of total households for study area
total.predicted.sites <- round(total.known.sites / survey.coverage.proportion)

## Select only household sites for each time period to calculate total known number of households
time.period.list.households <- lapply(time.period.list,FUN=function(x,...) {x[which(x$recordtypedesc == 'Habitation' ),] } )
time.period.list.households <- lapply(time.period.list.households,FUN=function(x,...) { x[,48:61] } )
total.known.households <- as.matrix(unlist(lapply(seq(1,14,1),FUN=function(x,...) { sum(time.period.list.households[[x]][,x],na.rm=T) } )))

## Predict number of total households for study area
total.predicted.households <- round(total.known.households / survey.coverage.proportion)

## Momentize total.predicted.households for population estimate through time 
momentize.proportion <- use.life / total.years
momentized.households <- round(total.predicted.households * momentize.proportion)

#########################################################################################
#########################################################################################
## SITE LOCATION PREDICTION LAYERS

## Prediction layer: Elevation
layer.1 <- dem.region

## Prediction layer: Slope
layer.2 <- raster::terrain(dem.region,'slope',unit='degrees')

## Prediction layer: Aspect
layer.3 <- raster::terrain(dem.region,'aspect',unit='degrees')

## Prediction layer: Maize productivity niche
study.extent.utm <- polygonUTM_NAD83(xmin(study.region)-10000,xmax(study.region)+10000,ymax(study.region)+10000,ymax(study.region)-30000,12)
study.extent.longlat <- sp::spTransform(study.extent.utm,longlat.projection)
dem.tile.cropped.longlat <- raster::crop(dem.tile,study.extent.longlat)
growing.niche <- get_bocinsky2016(template = extent(dem.tile.cropped.longlat),
                                  label = 'REESE_AND_YAQUINTO_2018_SAA',
                                  raw.dir = './ANALYSIS/PALEOCAR/RAW',
                                  extraction.dir = paste0('./ANALYSIS/PALEOCAR/EXTRACTIONS/'),
                                  prcp_threshold = 300,
                                  gdd_threshold = 1800,
                                  years = 1:2000,
                                  force.redo = T)
mean.stack <- raster::stackApply(growing.niche$niche[[600:1300]],indices=nlayers(growing.niche$niche[[600:1300]]),fun='mean')
mean.raster <- raster::projectRaster(mean.stack,crs=master.projection)
layer.4 <- raster::crop(mean.raster,extent(dem.region))
layer.4 <- resample(layer.4,dem.region)

## Prediction layer: check dam buffer
# cost.raster <- base::readRDS('../SPATIAL/RASTER_cost/mesa_verde_4.rds')
# uplift.coverage <- rgdal::readOGR('../SPATIAL/SHAPE_boundaries/survey_boundaries',layer='vepii_n_uplift_hull')
# projection(uplift.coverage) <- master.projection
# site.test.coords <- sites.all[uplift.coverage,]
# # Import mv check dams and sites
# mv.checkdam.channels <- raster::raster('../SPATIAL/SHAPE_hydrography/mesa_verde/mv_checkdam_channels')
# checkdam.channels <- raster::mask(mv.checkdam.channels,uplift.coverage)
# checkdam.coords <- raster::rasterToPoints(checkdam.channels,na.rm=T,spatial=T)
# cost.to.checkdams <- gDistance::costDistance(cost.raster,coordinates(site.test.coords),coordinates(checkdam.coords))
# write.csv(cost.to.checkdams,'../CULTURAL/REGION_mesaverde/cost_distance_to_checkdams.csv')
# cost.to.checkdams <- read.csv('../CULTURAL/REGION_mesaverde/cost_distance_to_checkdams.csv')
# diag(cost.to.checkdams) <- NA
# increasing.distance <- apply(cost.to.checkdams,2,sort)
# closest.6 <- as.matrix(unlist(lapply(c(1:length(increasing.distance)),FUN=function(x,...) {increasing.distance[[x]][1:6]} )))
# mean.checkdam.distance <- mean(closest.6)
# 
# # Potential check dam locations for the study area
# ## Fill depressions in DEM and calculate streams
# execGRASS('r.fill.dir',flags='overwrite',parameters=list(input='grass.dem',output='dem.fill.dir',direction='dem.direction'))
# execGRASS('r.watershed',flags='overwrite',parameters=list(elevation='dem.fill.dir',accumulation='dem.accumulation'))
# execGRASS('r.stream.extract',flags='overwrite',parameters=list(elevation='dem.fill.dir',threshold=2,stream_raster='dem.stream.raster',stream_vector='dem.stream.vector'))
# ## Export stream results into R environment, crop to study area, and save
# stream.raster <- readRAST('dem.stream.raster')
# writeOGR(stream.raster,'../SPATIAL/SHAPE_hydrography/north_escarpment',layer='ne_channels',driver='ESRI Shapefile')
# ## Load stream results calculated above, and create slope raster based on DEM
# channels <- readOGR('../SPATIAL/SHAPE_hydrography/north_escarpment',layer='ne_channels')
# projection(channels) <- master.projection
# channel.raster <- rasterize(coordinates(channels),dem.region)
# raster::writeRaster(channel.raster,'../SPATIAL/RASTER_cost/north_escarpment/raster_channels')
# channels <- channels[study.boundary,]
# slope.degrees <- terrain(dem.study,opt='slope',unit='degrees',neighbors=8)
# # Remove DEM cells that have a slope greater, or less than, known examples of check dam placement in the archaeological record
# dem.slope.degrees <- slope.degrees
# dem.slope.degrees[dem.slope.degrees < 5.71] <- NA
# dem.slope.degrees[dem.slope.degrees > 28.81] <- NA
# checkdam.slope <- raster::mask(dem.slope.degrees,dem.study)
# writeRaster(checkdam.slope,'../SPATIAL/SHAPE_hydrography/north_escarpment/ne_checkdam_slope',overwrite=T)
# checkdam.slope <- raster('../SPATIAL/SHAPE_hydrography/north_escarpment/ne_checkdam_slope')
# ## Remove potential check dam cells that do not overlap channel networks, and save raster
# checkdam.channels <- raster::mask(checkdam.slope,channels)
# writeRaster(checkdam.channels,'../SPATIAL/SHAPE_hydrography/north_escarpment/ne_checkdam_channels',overwrite=T)
# checkdam.channels <- raster('../SPATIAL/SHAPE_hydrography/north_escarpment/ne_checkdam_channels')
# checkdam.coords <- raster::rasterToPoints(checkdam.channels,na.rm=T,spatial=T)
# 
# difference.function <- function(x){x[2] - x[1]}
# height.difference <- transition(dem.region,difference.function,16,symm=F)
# height.difference.corrected <- geoCorrection(height.difference)
# adjacent.cells <- adjacent(dem.region,cells=1:ncell(dem.region),pairs=T,directions=16)
# speed <- adjacent.cells
# speed[adjacent.cells] <- 6 * exp(-3.5 * abs(slope[adjacent.cells] + 0.05))
# cost.raster.16 <- geoCorrection(speed)
# saveRDS(cost.raster.16,'../SPATIAL/RASTER_cost/north_escarpment/ne_cost_16.rds')
# cost.raster.16 <- base::readRDS('../SPATIAL/RASTER_cost/north_escarpment/ne_cost_16.rds')
# 
# layer <- accCost(cost.raster.16,coordinates(checkdam.coords))
# conversion <- layer * (5.036742/3.022045)
# layer.5 <- conversion
# raster::writeRaster(layer.5,'../SPATIAL/RASTER_cost/north_escarpment/cost_to_channels')
layer.5 <- raster::raster('../SPATIAL/RASTER_cost/north_escarpment/raster_channels')

#########################################################################################
#########################################################################################
## SITE LOCATION PREDICTION MODEL (NEEDS 'rJava' INSTALLED TO WORK)

# options(java.parameters = "-Xmx10g" )
# packages <- c('dismo','randomForest')
# for(p in packages) if(p %in% rownames(installed.packages()) == F) { install.packages(p) }
# for(p in packages) suppressPackageStartupMessages(library(p,quietly=T,character.only=T))

# dem.stack <- stack(layer.1,layer.2,layer.3,layer.4,layer.5)
# max.entropy <- maxent(dem.stack,coordinates(sites.study),removeDuplicates=F)
# site.predictions <- predict(max.entropy,dem.stack)
# raster::writeRaster(site.predictions,'../SPATIAL/RASTER_cost/north_escarpment/site_predictions_1-5')
site.predictions <- raster::raster('../SPATIAL/RASTER_cost/north_escarpment/site_predictions_1-5')
site.predictions.boundary <- raster::mask(site.predictions,study.boundary)
