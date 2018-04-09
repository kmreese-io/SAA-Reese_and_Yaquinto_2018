## MIND THE GAP: THE MESA VERDE NORTH ESCARPMENT
## KELSEY M. REESE AND BRIAN YAQUINTO
## SOCIETY FOR AMERICAN ARCHAEOLOGY ANNUAL MEETING 
## Mesa Verde Ancestral Pueblo Villages: Recent Research
## Poster Session Chair: Donna M. Glowacki
## Washington, D.C. 2018

## ENVIRONMENT ##

packages <-c('sp','Hmisc','rgeos','rgdal','raster','scales','splancs','graphics','gdistance','grDevices','FedData','RColorBrewer','rgrass7','rgl','rasterVis')
for(p in packages) if(p %in% rownames(installed.packages()) == F) { install.packages(p) }
for(p in packages) suppressPackageStartupMessages(library(p,quietly=T,character.only=T))

## Environment universals
master.projection <- sp::CRS('+proj=utm +datum=NAD83 +zone=12')
longlat.projection <- sp::CRS('+proj=longlat +datum=WGS84 +ellps=WGS84')
colors <- grDevices::colorRampPalette(c('black','white'))
heatcolors <- grDevices::colorRampPalette(c(as.character(RColorBrewer::brewer.pal(11,'Spectral'))))

## SHAPEFILE data
study.region <- rgdal::readOGR('../SPATIAL/SHAPE_boundaries/region_boundaries',layer='mv_escarpment')
study.boundary <- rgdal::readOGR('../SPATIAL/SHAPE_boundaries/region_boundaries',layer='mv_n_escarpment')
state.boundaries <- rgdal::readOGR('../SPATIAL/SHAPE_boundaries/state_boundaries',layer='state_boundaries')
federal.boundaries <- rgdal::readOGR('../SPATIAL/SHAPE_boundaries/federal_boundaries',layer='federal_land')
survey.coverage <- rgdal::readOGR('../SPATIAL/SHAPE_boundaries/survey_boundaries',layer='vepii_coverage')
study.extent <- extent(xmin(study.boundary)-2000,xmax(study.boundary)+2000,4122500-750,ymax(study.boundary)+2912.36)
plot.extent <- spTransform(polygonUTM_NAD83(UTM_North=ymax(study.boundary)+10000,UTM_South=ymin(study.boundary)-2556.67,UTM_East=xmin(study.boundary)-3556.67,UTM_West=xmax(study.boundary)+16856.64,UTM_Zone=12),master.projection)

## SPATIAL regional data
dem.tile <- raster::raster('../SPATIAL/DEM_data/arcsecond_1-3/n38w109/grdn38w109_13/w001001.adf')
# study.extent.utm <- polygonUTM_NAD83(xmin(study.region)-3000,xmax(study.region)+3000,ymax(study.region)+9000,4122500-4000,12)
# study.extent.longlat <- sp::spTransform(study.extent.utm,longlat.projection)
# dem.tile.cropped.longlat <- raster::crop(dem.tile,study.extent.longlat)
# dem.tile.cropped.utm <- raster::projectRaster(dem.tile.cropped.longlat,crs=master.projection)
# dem.region <- raster::crop(cropped.dem.utm,study.extent)
# raster::writeRaster(dem.region,'../SPATIAL/DEM_regions/north_escarpment/ne_dem')
# dem.region.slope <- raster::terrain(dem.region,'slope')
# dem.region.aspect <- raster::terrain(dem.region,'aspect')
# dem.region.hillshade <- raster::hillShade(dem.region.slope,dem.region.aspect)
# raster::writeRaster(dem.region.hillshade,'../SPATIAL/DEM_regions/north_escarpment/ne_hillshade')
dem.region <- raster::raster('../SPATIAL/DEM_regions/north_escarpment/ne_dem')
dem.region.hillshade <- raster::raster('../SPATIAL/DEM_regions/north_escarpment/ne_hillshade')

## SPATIAL study data
# raster::projection(study.boundary) <- master.projection
# raster::projection(dem.region) <- master.projection
# raster::projection(dem.region.hillshade) <- master.projection
# dem.study <- mask(dem.region,study.boundary)
# raster::writeRaster(dem.study,'../SPATIAL/DEM_regions/north_escarpment/ne_dem_zoom')
# dem.study.slope <- raster::terrain(dem.study,'slope')
# dem.study.aspect <- raster::terrain(dem.study,'aspect')
# dem.study.hillshade <- raster::hillShade(dem.study.slope,dem.study.aspect)
# raster::writeRaster(dem.study.hillshade,'../SPATIAL/DEM_regions/north_escarpment/ne_hillshade_zoom')
dem.study <- raster::raster('../SPATIAL/DEM_regions/north_escarpment/ne_dem_zoom')
dem.study.hillshade <- raster::raster('../SPATIAL/DEM_regions/north_escarpment/ne_hillshade_zoom')

## SPATIAL plot data
# plot.extent.plus <- spTransform(polygonUTM_NAD83(UTM_North=ymax(plot.extent)+5000,UTM_South=ymin(plot.extent)-5000,UTM_East=xmin(plot.extent)-5000,UTM_West=xmax(plot.extent)+5000,UTM_Zone=12),master.projection)
# plot.extent.longlat <- sp::spTransform(plot.extent.plus,longlat.projection)
# plot.extent.cropped.longlat <- raster::crop(dem.tile,plot.extent.longlat)
# plot.extent.cropped.utm <- raster::projectRaster(plot.extent.cropped.longlat,crs=master.projection)
# plot.dem <- raster::crop(plot.extent.cropped.utm,plot.extent)
# raster::writeRaster(plot.dem,'../SPATIAL/DEM_regions/north_escarpment/dem_16-9',overwrite=T)
# plot.slope <- terrain(plot.dem,'slope')
# plot.aspect <- terrain(plot.dem,'aspect')
# plot.hillshade <- hillShade(plot.slope,plot.aspect)
# raster::writeRaster(plot.hillshade,'../SPATIAL/DEM_regions/north_escarpment/hillshade_16-9',overwrite=T)
plot.dem <- raster::raster('../SPATIAL/DEM_regions/north_escarpment/dem_16-9')
plot.hillshade <- raster::raster('../SPATIAL/DEM_regions/north_escarpment/hillshade_16-9')
# plot.inverse <- raster::mask(plot.dem,study.boundary)
# gray.layer <- raster::mask(plot.dem,plot.inverse,inverse=T)
# raster::writeRaster(gray.layer,'../SPATIAL/DEM_regions/north_escarpment/gray_layer',overwrite=T)
gray.layer <- raster::raster('../SPATIAL/DEM_regions/north_escarpment/gray_layer')

## CULTURAL known site location data
site.information <- utils::read.csv('../CULTURAL/REGION_northernsanjuan/db_vepii_n.csv')
site.matrix <- base::matrix(NA,nrow=nrow(site.information),ncol=2)
site.matrix[,1] <- site.information$UTMEast
site.matrix[,2] <- site.information$UTMNorth
sites.all <- sp::SpatialPointsDataFrame(coords=site.matrix,site.information,proj4string=master.projection)

## CULTURAL site locations in the study area
projection(study.boundary) <- master.projection
projection(survey.coverage) <- master.projection
sites.study <- sites.all[study.boundary,]
sites.study.survey <- sites.study[survey.coverage,]
survey.coverage.study <- gIntersection(survey.coverage,study.boundary,byid=T,drop_lower_td=T)

## Study-specific information
modeling.phase <- c(6:19)
start.years <- c(600,725,800,840,880,920,980,1020,1060,1100,1140,1180,1225,1260)
end.years <- c(725,800,840,880,920,980,1020,1060,1100,1140,1180,1225,1260,1280)
midpoint <- as.matrix(unlist(lapply(c(1:14),FUN=function(x,...) { mean(c(start.years[x],end.years[x]))} )))
total.years <- as.matrix(unlist(lapply(c(1:14),FUN=function(x,...) { (end.years[x] - start.years[x]) } )))
use.life <- c(8,13,18,18,18,18,18,21,21,40,40,45,35,20)

## GRASS environment
gisBase <- system('grass72 --config path',intern=T)
initGRASS(gisBase=gisBase,gisDbase='./ANALYSIS/GRASS/',location='2018_REESE_AND_YAQUINTO_SAA',mapset='PERMANENT',override=T)
rname <- paste('../SPATIAL/DEM_regions/mesa_verde','ne_dem.grd',sep='/')
execGRASS('r.in.gdal',flags='o',parameters=list(input=rname,output='grass.dem'))
execGRASS('g.region',parameters=list(raster='grass.dem')) 
execGRASS('g.proj',flags='c',epsg=26912)
