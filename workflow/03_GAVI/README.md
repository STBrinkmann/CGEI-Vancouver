03 - Greenspace Availability Exposure Index (GAVI)
================
[Sebastian T. Brinkmann](https://orcid.org/0000-0001-9835-7347)
2022-09-29

In this study I have used the Greenspace Availability Exposure Index
(GAVI) to measure the availability of greenspace. The GAVI combines
three commonly used greenspace metrics (i.e. NDVI, LAI, and LULC) at
five spatial scales (i.e., 50, 100, 200, 300, and 400 m buffer distance)
as a multi-scale, multi-metric map. The three greenspace metrics
represent different characteristics of photosynthetically active
vegetation. Multiple spatial scales have been used as they (i) represent
different ecosystem functions, and (ii) account for scale dependent
statistical inference. The latter is also described as the Modifiable
Areal Unit Problem (MAUP) (Openshaw 1984; Fotheringham and Wong 1991).

To account for the MAUP Labib, Lindley, and Huck (2020) suggest
calculating *lacunarity* at multiple spatial scales and using the
scale-specific lacunatiry values as weigths, to account for the reducing
variance with increasing level of aggregation. Lacunarity has been
calculated using the `SpatLac` R package (Brinkmann 2021) that can be
installed from [GitHub](https://github.com/STBrinkmann/spatLac). The
final GAVI map has been reclassified into 9 classes using the Jenks
algortihm (Jenks 1977) from the `classInt` R package.

<img src="A_GAVI.svg" style="width:159mm" />

### Bibliography

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-brinkmann2021" class="csl-entry">

Brinkmann, Sebastian T. 2021. *spatLac: Spatial Lacunarity*. Zenodo.
<https://doi.org/10.5281/ZENODO.5786547>.

</div>

<div id="ref-fotheringham1991" class="csl-entry">

Fotheringham, A S, and D W S Wong. 1991. “The Modifiable Areal Unit
Problem in Multivariate Statistical Analysis.” *Environment and Planning
A: Economy and Space* 23 (7): 1025–44.
<https://doi.org/10.1068/a231025>.

</div>

<div id="ref-jenks1977optimal" class="csl-entry">

Jenks, George F. 1977. “Optimal Data Classification for Choropleth
Maps.” *Department of Geographiy, University of Kansas Occasional
Paper*.

</div>

<div id="ref-labib2020a_lacunarity" class="csl-entry">

Labib, S. M., Sarah Lindley, and Jonny J. Huck. 2020. “Scale Effects in
Remotely Sensed Greenspace Metrics and How to Mitigate Them for
Environmental Health Exposure Assessment.” *Computers, Environment and
Urban Systems* 82 (July): 101501.
<https://doi.org/10.1016/j.compenvurbsys.2020.101501>.

</div>

<div id="ref-openshaw1984" class="csl-entry">

Openshaw, S. 1984. “The Modifiable Areal Unit Problem.” *CATMOG* 38.

</div>

</div>
