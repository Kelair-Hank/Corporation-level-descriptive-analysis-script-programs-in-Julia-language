# Corporation-level-descriptive-analysis-script-programs-in-Julia-language

<b>Introduction:</b><br />
Corporation level descriptive analysis script programs written in Julia language. They are able to do complex tabular data cleaning together with descriptive statistics. The output is a corporation level formally formatted result table (Data Frame). <br />

<b>Features:</b><br />
GroupedCategoricalStats.jl contains functions used to do descriptive analysis on multiple categorical variables (columns) in a tabular data frame grouped into several sub data frames by another categorical variable. <br />
GroupedContinuousStats.jl contains functions used to do descriptive analysis on multiple continuous variables (columns) in a tabular data frame grouped into several sub data frames by another categorical variable. <br />
ExtractVariablesForTFL.jl contains functions used to combine results from the previous 2 programs into a corporation level formally formatted result table (Data frame). <br />
Please look into the comments in each script program to see details about how to use them. <br />
The final result table will be like the following:<br />
<br />
Variables                             categories	                       all
ContinuousVariable1	                      n	                             449
	                                    Mean (SD)	                         11.08 (14.42)
	                                    Median (Min; Max)	                 5.0 (1.0; 72.0)
	                                    25th and 75th Percentile	         2.0 : 12.0
	                                    Number (%) of missing values	     0 (0.0%)
		
CategoricalVariable1	                0	                                 305 (67.9%)
	                                    1	                                 76 (16.9%)
	                                    2	                                 35 (7.8%)
	                                    3	                                 18 (4.0%)
	                                    4	                                 5 (1.1%)
	                                    5	                                 5 (1.1%)
	                                    >5	                               5 (1.1%)
	                                    Total	                             449



<b>Implementation:</b><br />
include("GroupedCategoricalStats.jl")<br />
include("GroupedContinuousStats.jl")<br />
include("ExtractVariablesForTFL.jl")<br />

df_con=GroupedContinuousStats(df1::DataFrame,GroupingVars::Vector{Symbol},InterestedCols::Vector{Symbol})<br />
df_cate=grouped_categorical_stats(df1::DataFrame,grouping_vars::Vector{Symbol},categorical_vars::Vector{Symbol})<br />
final_result=GenerateTFL_Table(df_con::DataFrame,df_cate::DataFrame,vars1::Vector,cate_grouping_var::Symbol)<br />

