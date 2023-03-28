Sys.getenv("JAVA_HOME")

library(nlrx)


# Unix default NetLogo installation path (adjust to your needs!):
netlogopath <- file.path("/Users/hyesopshin/NetLogo 6.3.0")
modelpath <- file.path("/Users/hyesopshin/NetLogo 6.3.0/models/Sample Models/Biology/Wolf Sheep Predation.nlogo")
outpath <- file.path("/Users/hyesopshin/Downloads")

nl <- nl(nlversion = "6.3.0",
         nlpath = netlogopath,
         modelpath = modelpath,
         jvmmem = 1024)

nl@experiment <- experiment(expname="wolf-sheep",
                            outpath=outpath,
                            repetition=1,
                            tickmetrics="true",
                            idsetup="setup",
                            idgo="go",
                            runtime=10,
                            evalticks=seq(1,10),
                            metrics=c("count sheep", "count wolves", "count patches with [pcolor = green]"),
                            variables = list('initial-number-sheep' = list(min=50, max=150, qfun="qunif"),
                                             'initial-number-wolves' = list(min=50, max=150, qfun="qunif")),
                            constants = list("model-version" = "\"sheep-wolves-grass\"",
                                             "grass-regrowth-time" = 30,
                                             "sheep-gain-from-food" = 4,
                                             "wolf-gain-from-food" = 20,
                                             "sheep-reproduce" = 4,
                                             "wolf-reproduce" = 5,
                                             "show-energy?" = "false"))
nl@simdesign <- simdesign_lhs(nl=nl,
                              samples=100,
                              nseeds=3,
                              precision=3)


results <- run_nl_all(nl = nl)

# Attach results to nl object:
setsim(nl, "simoutput") <- results
# Write output to outpath of experiment within nl
write_simoutput(nl)
# Do further analysis:
analyze_nl(nl)