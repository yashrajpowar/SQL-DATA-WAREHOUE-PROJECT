/*
-- SEE USAGE PATTERN INDEXING --###############

Analyze the following SQL queries and generate a report on table and column usage
statistics. For each table, provide:
- The total number of times the table is used across all queries.
- A breakdown of each column in the table, showing:
- The number of times each column appears.
The primary purpose of the column's usage (e.g., filtering, joining, grouping, aggregating).
Sort the tables in descending order based on their total usage. 



You are a senior SQL expert, and I am a data analyst working on an SQL project using SQL Server.

Explain the concept of SQL Window Functions and do the following:

		- Explain each Window Function and show the Syntax.
		- Describe why they are important and when to use them.
		- List the top 3 use cases.

The tone should be conversational and direct, as if you're speaking to me one-on-one.



solve an SQL task ###########

[ PROMPT ... ]

In my SQL Server database, we have two tables:
The first table is 'orders` with the following columns: order_id, sales, customer_id, product_id.
The second table is 'customers` with the following columns: customer_id, first_name, last_name, country.

Do the following:

		Write a query to rank customers based on their sales.
		The result should include the customer's customer_id, full name, country, total sales, and their rank.
		Include comments but avoid commenting on obvious parts.
		Write three different versions of the query to achieve this task.
		Evaluate and explain which version is best in terms of readability and performance




############ 2 

[ PROMPT ... ]

The following SQL Server query is long and hard to understand.

Do the following:

		Improve its readability.
		Remove any redundancy in the query and consolidate it.
		Include comments but avoid commenting on obvious parts.
		Explain each improvement to understand the reasoning behind it.

[ SQL Query GOES HERE ]


############# 3

#3 Optimize the Performance Query

PROMPT ... ]

The following SQL Server query is slow.

Do the following:

		Propose optimizations to improve its performance.
		Provide the improved SQL query.
		Explain each improvement to understand the reasoning behind it.

[ SOL Ouerv GOES HERE 1



##################### 4
#4 Optimize Execution Plan

[ PROMPT ... ]

The image is the execution plan of SQL Server query.

Do the following:

		Describe the execution plan step by step.
		Identify performance bottlenecks and issues.
		Suggest ways to improve performance and optimize the execution plan.

[SOL Query GOES HERE ]

############### 5

#5 Debugging

[PROMPT ... ]

The following SQL Server Query causing this error: [Error Message GOES HERE]

Do the following:

		Explain the error massage.
		Find the root cause of the issue.
		Suggest how to fix it.

[ SQL Query GOES HERE ]


##################### 6 

#6 Explain the Result

[ PROMPT ... ]

I didn't understand the result of the following SQL Server query.

Do the following:

		Break down how SQL processes the following query step by step.
		Explaining each stage and how the result is formed.

[ SQL Query GOES HERE ]


###################  8 


#8 Documentations & Comments

[PROMPT ... ]

The following SQL Server query lacks comments and documentation.

Do the following:

		Insert a leading comment at the start of the query describing its overall purpose.
		Add comments only where clarification is necessary, avoiding obvious statements.
		Create a separate document explaining the business rules implemented by the query.
		Create another separate document describing how the query works.


##############  9

#9 Improve Database DDL

[ PROMPT ... ]

The following SQL Server DDL Script has to be optimized.

Do the following:

		Naming: Check the consistency of table/column names, prefixes, standards
		Data Types: Ensure data types are appropriate and optimized.
		Integrity: Verify the integrity of primary keys and foreign keys.
		Indexes: Check that indexes are sufficient and avoid redundancy.

Normalization: Ensure proper normalization and avoid redundancy.


############ 10

#10 Generate Test Dataset

[ PROMPT ... ]

I need dataset for testing for the following SQL Server DDL

Do the following:

	Generate test dataset as Insert statements.
	Dataset should be realstic.
	Keep the dataset small.
	Ensure all primary/foreign key relationships are valid (use matching IDs).
	Don introduce any Null values



################# 11

#11 Create SQL Course

[PROMPT ... ]

Create a comprehensive SQL course with a detailed roadmap and agenda.

Do the following:

		Start with SQL fundamentals and advance to complex topics.
		Make it beginner-friendly.
		Include topics relevant to data analytics.
		Focus on real-world data analytics use cases and scenarios.

################# 12

#12 Understand SQL Concept

PROMPT ... ]

want detailed explanation about SQL Window Functions.

Do the following:

		Explain what Window Functions are.
		Give an analogy.
		Describe why we need them and when to use them.
		Explain the syntax.
		Provide simple examples.
		List the top 3 use cases.

###################
#14 Practice SQL

PROMPT ...

Act as an SQL trainer and help me practice SQL Window Functions.

Do the following:

		Make it interactive Practicing, you provide task and give solution.
		Provide a sample dataset.
		Give SQL tasks that gradually increase in difficulty.
		Act as an SQL Server and show the results of my queries.
		Review my queries, provide feedback, and suggest improvements.

