using DataFrames, XLSX, Statistics, StatsBase, FreqTables, Pipe
category_names(v1)=@pipe freqtable(v1) |> names(_)[1]
freqtable_skipmissing(x)=freqtable(x,skipmissing=true)
proptable_skipmissing(x)=proptable(x,skipmissing=true)
category_names2(v1)=@pipe freqtable(v1,skipmissing=true) |> names(_)[1]

# The following function does descriptive statistics on designated categorical variables from a data frame group grouped by a given grouping variable.
function grouped_categorical_stats(df1::DataFrame,grouping_vars::Vector{Symbol},categorical_vars::Vector{Symbol})
    gdf1=groupby(df1,grouping_vars)

    df2=DataFrame()
    df3=DataFrame()
    @simd for i=categorical_vars
        result1=combine(gdf1,i=>category_names=>:categories,i=>freqtable=>:frequencies,i=>proptable=>:percentages)
        result2=combine(gdf1,i=>category_names2=>:categories,i=>freqtable_skipmissing=>:frequencies,i=>proptable_skipmissing=>:percentages)
        var_names=repeat([string(i),],nrow(result1))
        var_names2=repeat([string(i),],nrow(result2))
        insertcols!(result1,length(grouping_vars)+1,:Variables=>var_names)
        insertcols!(result2,length(grouping_vars)+1,:Variables=>var_names2)
        df2=[df2;result1]
        df3=[df3;result2]
    end
    if nrow(df2)==0
        df2.categories=Any[];df2.frequencies=Int64[];df2.percentages=Any[];df2."Frequency (%)"=String[]
    else
        df2.percentages=round.(df2.percentages .* 100,digits=1)
        df2."Frequency (%)"=string.(df2.frequencies," (",df2.percentages,"%)")
        df2=coalesce.(df2,"Number (%) of missing values")
        filter!(row->row.categories=="Number (%) of missing values",df2)
    end
    if nrow(df3)==0
        df3.categories=Any[];df3.frequencies=Int64[];df3.percentages=Any[];df3."Frequency (%)"=String[]
    else
        df3.percentages=round.(df3.percentages .* 100,digits=1)
        df3."Frequency (%)"=string.(df3.frequencies," (",df3.percentages,"%)")
    end
    gdf3=groupby(df3,[grouping_vars;:Variables])
    df_total=combine(gdf3,:frequencies=>sum=>:frequencies)
    if nrow(df_total)==0
        df_total=unique(df2,[grouping_vars;:Variables])
        df_total=df_total[:,[grouping_vars;:Variables]]
        df_total[:,:frequencies] .= 0
    end
    df_total[:,:percentages] .= ""
    df_total."Frequency (%)"=string.(df_total.frequencies)
    insertcols!(df_total,4,:categories=>"Total")
    df3=[df3;df2;df_total]
    sort!(df3,[grouping_vars;:Variables])
    return df3
end
