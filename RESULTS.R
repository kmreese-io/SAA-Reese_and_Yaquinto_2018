## MIND THE GAP: THE MESA VERDE NORTH ESCARPMENT
## KELSEY M. REESE AND BRIAN YAQUINTO
## SOCIETY FOR AMERICAN ARCHAEOLOGY ANNUAL MEETING 
## Mesa Verde Ancestral Pueblo Villages: Recent Research
## Poster Session Chair: Donna M. Glowacki
## Washington, D.C. 2018

## RESULTS ##

## Export results
results <- cbind(modeling.phase,
                 start.years,
                 end.years,
                 midpoint,
                 total.years,
                 use.life,
                 total.known.sites,
                 total.predicted.sites,
                 total.known.households,
                 total.predicted.households,
                 momentized.households)
write.csv(results,'./ANALYSIS/RESULTS/RESULTS.csv')
