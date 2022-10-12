04 - Greenspace Visibility Exposure Index (VGVI)
================
[Sebastian T. Brinkmann](https://orcid.org/0000-0001-9835-7347)
2022-09-29

In this study, I implemented the Greenspace Visibility Exposure Index
(VGVI) (Labib, Huck, and Lindley 2021) to represent eye-level visibility
of greenspaces. The VGVI expresses the ratio of visible greenspace to
the total visible area an observer can see at a specific location. For
that a viewshed analysis is conducted to estimate dichotomous visibility
(e.g. visible, not visible). Visible areas are intersected with the LULC
derived binary greenness raster (e.g. green, no-green), to calculate the
proportion of visible greenspace to overall visible area. Finally, all
values within the raster are summarised using a distance decay function
to account for the reduced visual prominence of an object in space with
increasing distance from the observer.

Elevation data has been used in the viewshed analysis and the VGVI has
been calculated for the complete study area on a regular point-based
grid with 5 m intervals, except for when the point represents buildings
or water (n = 16,243,938). After computation, the point grid has been
aggregated to a continuous raster with 10 m spatial resolution using an
Inverse Distance Weighting (IDW) interpolation algorithm. VGVI and the
IDW interpolation were computed using the `GVI` R package (Brinkmann and
Labib 2022). Total computation time with 22 CPU cores was 213 minutes,
with an average of 17.3 milliseconds per point.

<img src="A_VGVI.svg" style="width:159mm" />

### Bibliography

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-brinkmann2022_GVI" class="csl-entry">

Brinkmann, Sebastian T., and S. M. Labib. 2022. *GVI: Greenness
Visibility Index r Package*. Zenodo.
<https://doi.org/10.5281/ZENODO.7057132>.

</div>

<div id="ref-labib2021a_visibility" class="csl-entry">

Labib, S. M., Jonny J. Huck, and Sarah Lindley. 2021. “Modelling and
Mapping Eye-Level Greenness Visibility Exposure Using Multi-Source Data
at High Spatial Resolutions.” *Science of The Total Environment* 755
(February): 143050. <https://doi.org/10.1016/j.scitotenv.2020.143050>.

</div>

</div>
