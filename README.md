# Corporation-level-descriptive-analysis-script-programs-in-Julia-language

<b>Introduction:</b><br />
Corporation level descriptive analysis script programs written in Julia language. They are able to do complex tabular data cleaning together with descriptive statistics. The output is a corporation level formally formatted result table (Data Frame). <br />

<b>Features:</b><br />
GroupedCategoricalStats.jl contains functions used to do descriptive analysis on multiple categorical variables (columns) in a tabular data frame grouped into several sub data frames by another categorical variable. <br />
GroupedContinuousStats.jl contains functions used to do descriptive analysis on multiple continuous variables (columns) in a tabular data frame grouped into several sub data frames by another categorical variable. <br />
ExtractVariablesForTFL.jl contains functions used to combine results from the previous 2 programs into a corporation level formally formatted result table (Data frame). <br />
Please look into the comments in each script program to see details about how to use them. <br />

<b>Implementation:</b><br />
include("GroupedCategoricalStats.jl")<br />
include("GroupedContinuousStats.jl")<br />
include("ExtractVariablesForTFL.jl")<br />

df_con=GroupedContinuousStats(df1::DataFrame,GroupingVars::Vector{Symbol},InterestedCols::Vector{Symbol})<br />
df_cate=grouped_categorical_stats(df1::DataFrame,grouping_vars::Vector{Symbol},categorical_vars::Vector{Symbol})<br />
final_result=GenerateTFL_Table(df_con::DataFrame,df_cate::DataFrame,vars1::Vector,cate_grouping_var::Symbol)<br />

