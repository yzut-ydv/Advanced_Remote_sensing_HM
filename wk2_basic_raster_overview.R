
### **1. Install packages**


#In order to be able to work in R, you need to use functions. Many of these are already built by other people, and they are compacted in the form of packages.  An R package is simply a bunch of data, functions, examples, among others, stored in one neat file. The first step is to install the packages you need with the function `install.packages` and afterwards you need to load its libraries with the command `library`. 

# Install packages
install.packages("raster")

# Load libraries
library(raster)

#### Installing multiple packages

##If you need to install multiple packages at once you can also do that by creating a vector with the package names and using `install.packages` and the function `lapply` to add all of them to your library at once. 
# `lapply` applies a Function over a list or a vector

x <- c("raster","rgdal", "ggplot2", "rasterVis", "ps", "RStoolbox", "dplyr","magrittr","sf", "devtools")
install.packages(x, dependencies = TRUE)
lapply(x, library, character.only = TRUE)

#### OR, if you are using RStudio, use the inbuilt package manager

# Press ctrl+7 to open the Packages tab, on the upper left you will see a button "Install".
# A window will open, in the empty box type all packages required, separated by comma or space.
# Within the package manager you can also tick or untick packages to add or remove them from your library and update all your installed packages via the "Update" button.

#### Installing packages from other sources

# It is possible to install packages from other sources by using the functions provided by the 'devtools' package. After installing it you have access to utility functions like `install_github` or `install_version`. To compile packages you also need to have 'r-base-dev' (Linux) or 'Rtools' (Windows) installed.  

# The installation of 'Rtools' has to be done manually outside of R.  You will need to download the latest version from https://cran.r-project.org/bin/windows/Rtools/ and install it via the installer (you will need Administrator privileges for that!).

# In some cases there will be a message telling you there is no package named 'XML' in that case install it like so:
install.packages("XML", type = "binary")
require(XML)
# Install the latest version of RStoolbox directly from github
install_github("bleutner/RStoolbox")
library(RStoolbox)

### **2. Set the working environment**

To start working in R, you need first to indicate the program where to store the information. This is the "Working Directory" or `wd()`. If not set, the working directory will always be the folder the R script is located in. 
To set up the working directory, add the path of the folder where your files are located in the following function:  

# Set the working directory ("wd") 
w <- setwd("C:\\yourpath\\yourfolder")

# Check where your wd is
getwd()

# In addition to the previous step, it is also useful to change the settings of R and adapt them to your needs. In R, under Tools > Global Options > General, you can also change the working directory. Explore the other options on the left panel to customize the settings to your taste and needs.

### **3.Load Rasters**

#### **What is a Raster?**  

# A raster is a database organized as a rectangular grid that is sub-divided into rectangular cells of equal area (in terms of the units of the coordinate reference system). In the spatial world, each pixel represents an area on the Earth's surface. For example in the raster below, each pixel represents a particular land cover class that would be found in that location in the real world. 

# The `raster` package defines a number of "S4 classes" to manipulate such data. The main user level classes are `RasterLayer`, `RasterStack` and `RasterBrick`. They all inherit from BasicRaster and can contain values for the raster cells.The packages `sp` and `rgdal` are also used for manipulating Raster data. 

# An object of the RasterLayer class refers to a single layer (variable) of raster data. The object can point to a file on disk that holds the values of the raster cells, or hold these values in memory. Or it can not have any associated values at all.


#### **Load and explore Rasters**  

# Landsat 8 images can be accessed through the website of the U.S. Geological Survey (USGS): https://earthexplorer.usgs.gov/. The scene of this exercise is from the 4.09.2018 from the area of Beirut in Lebanon.

# Load a single band
beirut_b5 <- raster("data\\LC08_L1TP_174037_20180904_20180912_01_T1\\LC08_L1TP_174037_20180904_20180912_01_T1_B5.TIF")

#### **Stats**

# To see the attributes, just print the name of your object of interest
beirut_b5

# * dimensions: the "size" of the file in pixels.
# * nrow, ncol: the number of rows and columns in the data (imagine a spreadsheet or a matrix).
# * ncells: the total number of pixels or cells that make up the raster.
# * resolution: the size of each pixel (in meters in this case). Each pixel represents a 30m x 30m area on the earth's surface.
# * extent: the spatial extent of the raster. This value will be in the same coordinate units as the coordinate reference system of the raster.
# * coord ref: the coordinate reference system string for the raster. This raster is in UTM (Universal Trans Mercator) zone 36 with a datum of WGS 84.

# You can also find those values with individual commands
# Coordinate Reference System (CRS)
crs(beirut_b5)
# Extent
extent(beirut_b5)
# Number of cells
ncell(beirut_b5)
# Number of rows, columns and layers
dim(beirut_b5)

# Min/Max values
cellStats(beirut_b5, min)
cellStats(beirut_b5, max)
cellStats(beirut_b5, range)

# Summary of object
summary(beirut_b5)
# Structure of object
str(beirut_b5)

# Explore the data using histograms. These allow us to view the distrubiton of values in the pixels.

hist(beirut_b5, main="Distribution of pixel values",
     xlab="Pixel values",
     ylab="Frecuency",
     col="red"
)
# TIP: in case R does not consider all the pixels for the hist calculation, include this line in the 'hist()' command: maxpixels=ncell(yourraster)

### **4. Plot rasters**

# Simple plot of one band
plot(beirut_b5, main="Band 5, Landsat 8. Beirut - Lebanon")

### **5. Raster Stack**

In order to create a `RasterStack` we need to import more than one band. In the following table you have an overview of the different bands from the sensor Landsat 8. For this practice, we will use only the bands Blue, Green and Red, which are Bands 2, 3, and 4.  

# Import some other bands
beirut_b2 <- raster("data\\LC08_L1TP_174037_20180904_20180912_01_T1\\LC08_L1TP_174037_20180904_20180912_01_T1_B2.TIF")
beirut_b3 <- raster("data\\LC08_L1TP_174037_20180904_20180912_01_T1\\LC08_L1TP_174037_20180904_20180912_01_T1_B3.TIF")
beirut_b4 <- raster("data\\LC08_L1TP_174037_20180904_20180912_01_T1\\LC08_L1TP_174037_20180904_20180912_01_T1_B4.TIF")
# Another way, is to list all files in a specific folder
rlistbeirut <-  list.files(path = paste(w,"\\data\\LC08_L1TP_174037_20180904_20180912_01_T1", sep=""),  pattern="*.TIF$", full.names=TRUE) # create list with files

# Stack the bands of your interest.

# Create a RasterStack with single bands B2, B3, B4, B5
rgbnSt1 <- stack(beirut_b2, beirut_b3, beirut_b4, beirut_b5)
# Or create the RasterStack with the files from the list
rgbnSt2 <- stack(rlistbeirut) # Why this code doesn't work? because B8 has a higher resolution and a slightly bigger extent

# Access to each band.

# Check the structure of the RasterStack
rgbnSt1

# Select band 1
rgbnSt1[[1]]

### **6. Plot Band compositions**

# To display 3-band color image, we use plotRGB. We have to select the index of bands we want to render in the red, green and blue regions.  Associating each spectral band (not necessarily a visible band) to a separate primary colour results in a colour composite image.  
# 
# If a multispectral image consists of the three visual primary colour bands (red, green, blue), the three bands may be combined to produce a "true colour" image. The display colour assignment for any band of a multispectral image can be done in an entirely arbitrary manner. In this case, the colour of a target in the displayed image does not have any resemblance to its actual colour. The resulting product is known as a false colour composite image.  
# 
# Combine the bands in different order to create a true and false composite of the image. The function `plotRGB()` can only be used for `RasterStack` or `RasterBrick`.  

# Simple plot of a RasterStack
plot(rgbnSt1)

# The layout( ) function has the form layout(mat) where mat is a matrix object specifying the location of the N figures to plot. 
nf <- layout(matrix(c(1,2), nrow=1, ncol=2, byrow = TRUE))  
# TIP: To get a preview of the ensuing layout, you can use 'layout.show'
# Indicate the 2 images that will be plotted in the  1X2 matrix
plotRGB(rgbnSt1, r=3, g=2, b=1, axes=TRUE, stretch="hist", main = "Landsat 8 True Color Composite")
plotRGB(rgbnSt1, r=4, g=3, b=2, axes=TRUE, stretch="hist", main = "Landsat 8 False Color Composite")
# Stretch: allows for increased contrast. Options are "lin" & "hist". Explore...

# When the range of pixel brightness values is closer to 0, we see a darker image. Streching the full 0-255 range of potential values, increases the visual contrast of the image.

### **7. Operations**

#### **Subset**

Depending the analysis you want to make, it is sometimes useful to subset and rename the spectral bands. You can select specific bands using the `subset` function.  

# Select only the first 3 bands (i.e. Bands 2, 3, 4)
rgbnSt1_sub <- subset(rgbnSt1, 1:3) # The numbers 1:3 refer to the position of the layer in the RasterStack. In this case, Band 2 is located in the first layer place.

# Check the number of layers in original and new data
nlayers(rgbnSt1) 
nlayers(rgbnSt1_sub)   

#### **Rename**  

# Set or change the names of the bands using the following function:  

# Check the default names of the RasterStack
names(rgbnSt1)
# Rename the layers
names(rgbnSt1) <- c("blue", "green", "red", "nir")
# Check the result
names(rgbnSt1)

#### **Crop**
# Crop or cut the raster to the desired extent, using the crop function. In this case, we crop a raster to the extent of a given vector or shapefile.  

# Load vector file (shapefile)
aoi <- st_read("vector", "aoi_beirut")

# Reproject shapefiles
refsys <- crs(beirut_b2)
aoi <- st_transform(aoi, refsys)

# Crop to desired extent
rgbnSt1_crop <- crop(rgbnSt1, aoi)

# See the results
plot(rgbnSt1_crop)

#### **Resampling**

To be able to compare the NIR band (Band 5 for Sentinel) to the Thermal Infrared band ('TIRS', Band 10 or 11 for Sentinel) you need to resample the NIR band to the resolution of the TIRS band (from 30 to 100 meters). 

# Import TIRS band (band 10 here)
beirut_b10 <- raster("data\\LC08_L1TP_174037_20180904_20180912_01_T1\\LC08_L1TP_174037_20180904_20180912_01_T1_B10.TIF")
# Crop images (band 5)
NIR_crop <- crop(beirut_b5, aoi)
TIRS_crop <- crop(beirut_b10, aoi)
# Resample NIR image to size 100 (from 30)
NIR_crop_ra <- aggregate(NIR_crop, (100/30)) # Aggregates by factor
# Compare Images
nf <- layout(matrix(c(1,2,3), nrow=1, ncol=3, byrow = TRUE))
plot(NIR_crop, main = "Cropped NIR band image")
plot(NIR_crop_ra, main = "Cropped resampled NIR band image")
plot(TIRS_crop, main = "Cropped TIRS band image")


### **8. Panchromatic sharpening**

Panchromatic sharpening is a type of resampling in which an image A is merged with an image B of higher resolution. The result will give you an image A of higher resolution. In the case of Landsat, most of the multispectral bands have a 30m pixel size. Band 8, also called "Panchromatic band", is a gray-scale 15m pixel size band, which can be used to increase the resolution of other multispectral bands. 

In this case, we are using the function `panSharpen` from the `RStoolbox` package. There are many other implementations of this function from other packages. Feel free to explore them. More info: https://www.rdocumentation.org/packages/RStoolbox/versions/0.2.6/topics/panSharpen

# Drop the NIR band from the rasterstack created earlier
rgbStack <- dropLayer(rgbnSt1_crop, 4)
# Import the Panchromatic band (Band 8)
beirut_b8 <- raster("data\\LC08_L1TP_174037_20180904_20180912_01_T1\\LC08_L1TP_174037_20180904_20180912_01_T1_B8.TIF")
# Crop image
pan_crop <- crop(beirut_b8, aoi)
# Sharpen
# For the resampling many methods are used: PCA or Intensity-Hue-Saturation space transformation.
panSharpen_ihs <- panSharpen(rgbStack, pan_crop, 3, 2, 1, method = "ihs", norm = TRUE)
panSharpen_pca <- panSharpen(rgbStack, pan_crop, method = "pca", norm = TRUE)
nf <- layout(matrix(c(1,2), nrow=1, ncol=2, byrow = TRUE))
plotRGB(panSharpen_ihs, r = 3, g = 2, b = 1, axes=TRUE, main = "Method Intensity-Hue-Saturation", scale = max(maxValue(panSharpen_ihs)))
plotRGB(panSharpen_pca, r = 3, g = 2, b = 1, axes=TRUE, main = "Method PCA", scale = max(maxValue(panSharpen_pca)))

### **9. Mosaicking images**


# To create a mosaic of several rasters simply use the `mosaic` function of the raster package.
# `fun` specifies the function used to compute cell values in areas where layers overlap.

# example with NTL images of india
r1 <- raster("data\\NTL\\VNP46A2.A2019100.h26v06.001.2021020141752_DNB_BRDF-Corrected_NTL.tif")
r2 <- raster("data\\NTL\\VNP46A2.A2019100.h26v07.001.2021020141743_DNB_BRDF-Corrected_NTL.tif")
plot(r1)
plot(r2)
mos <- mosaic(r1, r2, fun=mean)
plot(mos)

### **10. Export images**

Export or write all your images and intermediate results as individual rasters. Load them afterwards in another software like QGIS, for visualization and comparison.  

# Export a RasterStack
writeRaster(rgbnSt1_crop, datatype="FLT4S", filename = "data\\results\\rgbnRaster.tif", format = "GTiff", overwrite=TRUE)
writeRaster(NIR_crop_ra, datatype="FLT4S", filename = "data\\results\\nirCropResamp.tif", format = "GTiff", overwrite=TRUE)
writeRaster(TIRS_crop, datatype="FLT4S", filename = "data\\results\\tirsCrop.tif", format = "GTiff", overwrite=TRUE)
writeRaster(panSharpen_ihs, datatype="FLT4S", filename = "data\\results\\panSharpen_ihs.tif", format = "GTiff", overwrite=TRUE)
writeRaster(panSharpen_pca, datatype="FLT4S", filename = "data\\results\\panSharpen_pca.tif", format = "GTiff", overwrite=TRUE)
# Export one single raster
writeRaster(rgbnSt1_crop[[1]], datatype="FLT4S", filename = "data\\results\\rgb_crop_B1.tif", format = "GTiff", overwrite=TRUE)

