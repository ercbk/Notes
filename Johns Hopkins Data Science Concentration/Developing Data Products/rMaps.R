# rMaps






library(devtools);
require(devtools)
install_github('ramnathv/rCharts@dev')
install_github('ramnathv/rMaps')


library(rjson); library(rMaps)
crosslet(
 x = "country",
 y = c("web_index", "universal_access", "impact_empowerment", "freedom_openness"),
 data = web_index
)
