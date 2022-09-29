02 - Remote Sensing
================
[Sebastian T. Brinkmann](https://orcid.org/0000-0001-9835-7347)
2022-09-29

In this study I have used three different greenspace metrics that are
commonly used in the existing literature, (i) Normalised Difference
Vegetation Index (NDVI), (ii) Leaf Area Index (LAI), and (iii) Land Use
Land Cover (LULC) (Markevych et al. 2017; Labib, Lindley, and Huck
2020).

The final NDVI, LAI, and LULC maps are provided on Zenodo and is
reccomended to locate all images in the following folder
*“data/02_RemoteSensing/02_processed/”.*

## NDVI and LAI

Both NDVI and LAI were derived from a cloud-free Sentinel-2 L1C
satellite image (04.10.2015) which has been acquired through the [EO
Browser](https://apps.sentinel-hub.com/eo-browser/) platform.
Preprocessing to L2A-Level has been conducted using the Sen2Cor
processor algorithm (Main-Knorn et al. 2017). NDVI was calculated at 10
m spatial resolution using the standard equation

![NDVI = \frac{NIR-RED}{NIR+RED}](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;NDVI%20%3D%20%5Cfrac%7BNIR-RED%7D%7BNIR%2BRED%7D "NDVI = \frac{NIR-RED}{NIR+RED}")

where
![NIR](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;NIR "NIR")
refers to the near-infrared band and
![RED](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;RED "RED")
refers to the visible red wavelengths (Drusch et al. 2012). The LAI has
been calculated at 10 m spatial resolution using the biophysical
processor algorithm (Weiss, Baret, and Jay 2020).

## LULC

LULC data from 2014 has been acquired by Metro Vancouver (2019) at 2 m
resolution and was reclassified to a binary greenspace raster, where
tree canopy, shrub and grass represent green (value of 1) and other
classes - including non-photosynthetic vegetation - indicate not-green
(value of 0). Furthermore, a water mask has been derived from the LULC
data to remove bluespaces like lakes, rivers or the sea from all
greenspace metrics. Below I have listed the class values of the LULC
data:

<table style="width:90%; font-family: &quot;Arial Narrow&quot;, &quot;Source Sans Pro&quot;, sans-serif; width: auto !important; margin-left: auto; margin-right: auto;" class=" lightable-classic lightable-striped">
<thead>
<tr>
<th style="text-align:left;font-weight: bold;">
Value
</th>
<th style="text-align:center;font-weight: bold;">
Level 1
</th>
<th style="text-align:center;font-weight: bold;">
Level 2
</th>
<th style="text-align:center;font-weight: bold;">
Level 3
</th>
<th style="text-align:left;font-weight: bold;">
Criteria
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
1
</td>
<td style="text-align:center;">
Built-up
</td>
<td style="text-align:center;">
Buildings
</td>
<td style="text-align:center;">
</td>
<td style="text-align:left;">
Identified using shape/size, shadow cast, height, relative canopy
height, texture.
</td>
</tr>
<tr>
<td style="text-align:left;">
2
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
Paved
</td>
<td style="text-align:center;">
</td>
<td style="text-align:left;">
Everything from sidewalks and alleys to highways.
</td>
</tr>
<tr>
<td style="text-align:left;">
3
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
Other Built
</td>
<td style="text-align:center;">
</td>
<td style="text-align:left;">
Not concrete/asphalt built surfaces or building roofs. Sports surfaces
(artificial turf and running tacks), possibly transit or rail areas,
other impervious surfaces, etc.
</td>
</tr>
<tr>
<td style="text-align:left;">
4
</td>
<td style="text-align:center;">
Bare
</td>
<td style="text-align:center;">
Barren
</td>
<td style="text-align:center;">
</td>
<td style="text-align:left;">
Beaches, alpine rock, shoreline rock, etc. Lack of vegetation. Likely
not soil (colour/context suggests no organic matter and/or
imperviousness). Also quarries, gravel pits, dirt roads.
</td>
</tr>
<tr>
<td style="text-align:left;">
5
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
Soil
</td>
<td style="text-align:center;">
</td>
<td style="text-align:left;">
Agricultural soils (could be light or dark), cleared/open areas where
darker colours indicate organic matter present (as compared to,
e.g. sand), potentially riverine/alluvial deposits.
</td>
</tr>
<tr>
<td style="text-align:left;">
6
</td>
<td style="text-align:center;">
Vegetation
</td>
<td style="text-align:center;">
Tree canopy
</td>
<td style="text-align:center;">
Coniferous
</td>
<td style="text-align:left;">
Predominantly coniferous (\>75%)
</td>
</tr>
<tr>
<td style="text-align:left;">
7
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
Deciduous
</td>
<td style="text-align:left;">
Predominantly deciduous (\>75%)
</td>
</tr>
<tr>
<td style="text-align:left;">
8
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
Shrub
</td>
<td style="text-align:left;">
Woody, leafy, and generally rough-textured vegetation shorter than trees
(approx. \<3-4m), taller than grass.
</td>
</tr>
<tr>
<td style="text-align:left;">
9
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
Grass-herb
</td>
<td style="text-align:center;">
Modified Grass-herb
</td>
<td style="text-align:left;">
Crops, golf course greens, city park grass, lawns, etc.
</td>
</tr>
<tr>
<td style="text-align:left;">
10
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
Natural Grass-herb
</td>
<td style="text-align:left;">
Alpine meadows, near-shore grass areas, bog/wetland areas.
</td>
</tr>
<tr>
<td style="text-align:left;">
11
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
Non-photosynthetic vegetation
</td>
<td style="text-align:center;">
</td>
<td style="text-align:left;">
Dead grass, drought stressed vegetation, could include log
</td>
</tr>
<tr>
<td style="text-align:left;">
12
</td>
<td style="text-align:center;">
Water
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:left;">
Lakes, rivers, inlets, irrigation channels, retention ponds, pools, etc.
</td>
</tr>
<tr>
<td style="text-align:left;">
13
</td>
<td style="text-align:center;">
Shadow
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:left;">
Dark pixels with low reflectance values. Image features not easily
visible. Compare RapidEye image for shadow
</td>
</tr>
<tr>
<td style="text-align:left;">
14
</td>
<td style="text-align:center;">
Clouds/Ice
</td>
<td style="text-align:center;">
</td>
<td style="text-align:center;">
</td>
<td style="text-align:left;">
Very bright pixels, that are not high-reflectance features from built-up
areas.
</td>
</tr>
</tbody>
</table>

### Bibliography

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-drusch2012" class="csl-entry">

Drusch, M., U. Del Bello, S. Carlier, O. Colin, V. Fernandez, F. Gascon,
B. Hoersch, et al. 2012. “Sentinel-2: ESA’s Optical High-Resolution
Mission for GMES Operational Services.” *Remote Sensing of Environment*
120 (May): 25–36. <https://doi.org/10.1016/j.rse.2011.11.026>.

</div>

<div id="ref-labib2020_review" class="csl-entry">

Labib, S. M., Sarah Lindley, and Jonny J. Huck. 2020. “Spatial
Dimensions of the Influence of Urban Green-Blue Spaces on Human Health:
A Systematic Review.” *Environmental Research* 180 (January): 108869.
<https://doi.org/10.1016/j.envres.2019.108869>.

</div>

<div id="ref-main-knorn2017" class="csl-entry">

Main-Knorn, Magdalena, Bringfried Pflug, Jerome Louis, Vincent
Debaecker, Uwe Müller-Wilm, and Ferran Gascon. 2017. “Sen2Cor for
Sentinel-2.” Edited by Lorenzo Bruzzone, Francesca Bovolo, and Jon Atli
Benediktsson. *Image and Signal Processing for Remote Sensing XXIII*,
October. <https://doi.org/10.1117/12.2278218>.

</div>

<div id="ref-markevych2017" class="csl-entry">

Markevych, Iana, Julia Schoierer, Terry Hartig, Alexandra Chudnovsky,
Perry Hystad, Angel M. Dzhambov, Sjerp de Vries, et al. 2017. “Exploring
Pathways Linking Greenspace to Health: Theoretical and Methodological
Guidance.” *Environmental Research* 158 (October): 301–17.
<https://doi.org/10.1016/j.envres.2017.06.028>.

</div>

<div id="ref-metro2014" class="csl-entry">

Metro Vancouver. 2019. “Land Cover Classification 2014 - 2m LiDAR
(Raster).”

</div>

<div id="ref-weiss2020" class="csl-entry">

Weiss, Marie, Frederic Baret, and Sylvain Jay. 2020. “S2ToolBox Level 2
Products LAI, FAPAR, FCOVER.” Research Report. EMMAH-CAPTE, INRAe
Avignon. <https://hal.inrae.fr/hal-03584016>.

</div>

</div>
