using Pkg
Pkg.activate("OEMC-S4T/bin/julia/")

using YAXArrays
using DimensionalData
using Zarr
using YAXArraysToolbox
using TickTock

using Distributed

addprocs(10)

@everywhere begin
        using Pkg
        Pkg.activate("OEMC-S4T/bin/julia/")
        using YAXArrays
        using DimensionalData
        using Zarr
        using YAXArraysToolbox
        using TickTock
end


#### Africa-Europe run ####


lst_africa_europe = open_dataset("OEMC-S4T/data/LST_cube_africa_europe_2019-08_v2.zarr")

lst_africa_europe = Cube(lst_africa_europe)

lcc_africa_europe = open_dataset("OEMC-S4T/data/ESA_CCI_PFTs/ESACCI-LC-L4-PFT-Map-0d05-P1Y-2019-v2.0.8_africa_europe_mod.zarr")

lcc_africa_europe = Cube(lcc_africa_europe)

### runing space4time analysis

classes = collect(lcc_africa_europe.variable)


results_space4time = space4time_proc(lst_africa_europe, lcc_africa_europe, time_axis_name = nothing, lon_axis_name = :lon, lat_axis_name = :lat, classes_var_name = :variable, classes_vec = classes, winsize = 7, minDiffPxlspercentage = 40, max_value = 100, minpxl = 49, showprog = true)

savedataset(results_space4time; path = "/eos/jeodpp/data/projects/OEMC-S4T/results/first_tests/Space4Time_result_Europe_Africa_2018_08_composite_15min.zarr", overwrite =true)




