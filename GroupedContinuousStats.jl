using DataFrames, XLSX, StatsBase, Statistics, CSV
round2(x)=round.(x,digits=2)

# The following function does descriptive statistics on designated continuous variables from a data frame group grouped by a given grouping variable.
function GroupedContinuousStats(df1::DataFrame,GroupingVars::Vector{Symbol},InterestedCols::Vector{Symbol})
    gdf1=groupby(df1,GroupingVars)
    dgdf1=combine(gdf->describe(gdf,:mean,:std,:q25,:median,:q75,:max,:min,:nmissing,cols=InterestedCols),gdf1)
    dgdf1.nmissing=recode(dgdf1.nmissing,nothing=>0)
    m1=Matrix{Union{Missing,String,Float64,Int64,Nothing,Symbol}}(dgdf1);recode!(m1,nothing=>missing);dgdf1=DataFrame(m1,propertynames(dgdf1))
    df2=dgdf1[:,[GroupingVars;:variable]];df3=select(dgdf1,:nmissing)
    dgdf1=combine(dgdf1,Symbol[:mean,:std,:q25,:median,:q75,:max,:min] .=> round2 .=> Symbol[:mean,:std,:q25,:median,:q75,:max,:min])
    dgdf1=[df2 dgdf1 df3]
    dgdf2=combine(gdf1,nrow)
    dgdf1=leftjoin(dgdf1,dgdf2,on=GroupingVars)
    sort!(dgdf1,:variable);rename!(dgdf1,:nrow=>:n)
    dgdf1."Mean (SD)"=string.(dgdf1.mean," (",dgdf1.std,")")
    dgdf1."Median (Min; Max)"=string.(dgdf1.median," (",dgdf1.min,"; ",dgdf1.max,")")
    dgdf1."25th and 75th Percentile"=string.(dgdf1.q25," : ",dgdf1.q75)
    dgdf1."Number (%) of missing values"=string.(dgdf1.nmissing," (",round.(dgdf1.nmissing ./ dgdf1.n .* 100,digits=1),"%)")
    dgdf1.n=dgdf1.n .- dgdf1.nmissing
    sort!(dgdf1,[GroupingVars;:variable])
    col1=names(dgdf1)
    m1=Matrix{Union{Missing,String,Float64,Int64,Symbol}}(dgdf1)
    recode!(m1,"missing (missing)"=>"NA","missing (missing; missing)"=>"NA","missing : missing"=>"NA")
    dgdf1=[col1 permutedims(m1)] |> DataFrame
    return dgdf1
end
