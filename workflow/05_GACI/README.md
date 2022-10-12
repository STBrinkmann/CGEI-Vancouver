05 - Greenspace Accessibility Exposure Index (GACI)
================
[Sebastian T. Brinkmann](https://orcid.org/0000-0001-9835-7347)
2022-09-29

In this study I have used the Greenspace Accessibility Exposure Index
(GACI) to measure the access to public parks. It has been computed
following a three-step method: First, access points to public parks have
been identified. Second, for the complete study area walking distance
has been calculated through network analysis, accounting not only for
the distance, but also the size of surrounding parks. Finally, all
values have been normalised to generate the GACI map.

<img src="A_GACI.svg" style="width:159mm" />

The network analysis has been conducted using a local instance of the
OSRM routing engine (Luxen and Vetter 2011). It is recommended to launch
a local instance of OSRM via Docker. Detailed instructions for
installing Docker ([here](https://docs.docker.com/engine/install/)) and
running a local instance of OSRM
([here](https://github.com/Project-OSRM/osrm-backend)) are provided
online.

### Bibliography

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-luxen-vetter-2011" class="csl-entry">

Luxen, Dennis, and Christian Vetter. 2011. “Real-Time Routing with
OpenStreetMap Data.” In *Proceedings of the 19th ACM SIGSPATIAL
International Conference on Advances in Geographic Information Systems*,
513–16. GIS ’11. New York, NY, USA: ACM.
<https://doi.org/10.1145/2093973.2094062>.

</div>

</div>
