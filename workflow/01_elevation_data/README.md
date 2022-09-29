01_Elevation
================
[Sebastian T. Brinkmann](https://orcid.org/0000-0001-9835-7347)
2022-09-29

I used various environmental datasets in my bachelor thesis. For the
analysis of visible greenspace I used a LiDAR derived Digital Surface
Model (DSM) and Digital Terrain Model (DTM) at 1 m resolution for its
proven ability to represent the above-ground elements and its accuracy
in estimating surface visibility (Van Berkel et al. 2018). The DSM has
been used to account for ground surface objects like trees or buildings,
and the DTM to represent the ground terrain. Both elevation models are
publicly available (Natural Resources Canada 2019).

I have used elevation data from the “[High Resolution Digital Elevation
Model (HRDEM) - CanElevation
Series](https://open.canada.ca/data/en/dataset/957782bf-847c-4644-a757-e383c0057995)”
product, which is derived from airborne LiDAR data for Vancouver. The
data was first downloaded for all sub-regions (i.e. Vancouver, Burnaby,
and Surrey) from a [FTP
server](https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/).
The DSM was than cleaned using a focal algortihm. Finally, all data has
been merged to one raster image and cropped and masked to the study
area.

The final DSM and DTM are provided on Zenodo and is reccomended to
locate both images in the following folder
*“data/01_Elevation/02_processed/”*

### Bibliography

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-natCan201" class="csl-entry">

Natural Resources Canada. 2019. “Igh Resolution Digital Elevation Model
(HRDEM) - CanElevation Serie.”

</div>

<div id="ref-vanberkel2018" class="csl-entry">

Van Berkel, Derek B., Payam Tabrizian, Monica A. Dorning, Lindsey Smart,
Doug Newcomb, Megan Mehaffey, Anne Neale, and Ross K. Meentemeyer. 2018.
“Quantifying the Visual-Sensory Landscape Qualities That Contribute to
Cultural Ecosystem Services Using Social Media and LiDAR.” *Ecosystem
Services* 31 (June): 326–35.
<https://doi.org/10.1016/j.ecoser.2018.03.022>.

</div>

</div>
