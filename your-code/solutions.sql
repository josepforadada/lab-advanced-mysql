# 1 - Calculate the royalty of each sale for each author.

SELECT 
publications.titles.title_id as 'Title Id',
publications.titleauthor.au_id as 'Author ID',
concat_ws(' ', publications.authors.au_fname, publications.authors.au_lname) as 'Author',
round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100,2) as 'Sales per royalty per author'
FROM publications.titles
JOIN publications.titleauthor
ON publications.titles.title_id=publications.titleauthor.title_id
JOIN publications.sales
ON publications.titles.title_id=publications.sales.title_id
JOIN publications.authors
ON publications.titleauthor.au_id=publications.authors.au_id;

# Table reduction names

SELECT 
T.title_id as 'Title Id',
TA.au_id as 'Author ID',
concat_ws(' ', A.au_fname, A.au_lname) as 'Author', # concat_ws allows() to add spaces between strings
round(price * S.qty * T.royalty / 100 * TA.royaltyper / 100,2) as 'Sales per royalty per author'
FROM publications.titles as T
JOIN publications.titleauthor as TA
ON T.title_id = TA.title_id
JOIN publications.sales as S
ON T.title_id = S.title_id
JOIN publications.authors as A
ON TA.au_id = A.au_id;

# 2 - Using the output from Step 1 as a temp table, aggregate the total royalties for each title for each author.

SELECT 
T.title_id as 'Title Id',
TA.au_id as 'Author ID',
concat_ws(' ', A.au_fname, A.au_lname) as 'Author',
sum(round(T.price * S.qty * T.royalty / 100 * TA.royaltyper / 100,2)) as Sales_Royalty, # don't use 'Sales Royalty' because cannot be sortered
FROM publications.titles as T
JOIN publications.titleauthor as TA
ON T.title_id = TA.title_id
JOIN publications.sales as S
ON T.title_id = S.title_id
JOIN publications.authors as A
ON TA.au_id = A.au_id
GROUP BY TA.au_id, T.title_id
ORDER BY Sales_Royalty DESC; # Cannot order by using it if declared as 'Sales_Royalty'

# 3 - Using the output from Step 2 as a temp table, calculate the total profits of each author by aggregating the advances and total royalties of each title.

SELECT 
T.title_id as 'Title Id',
TA.au_id as 'Author ID',
concat_ws(' ', A.au_fname, A.au_lname) as 'Author',
sum(round(T.price * S.qty * T.royalty / 100 * TA.royaltyper / 100,2)) as Sales_Royalty, # don't use 'Sales Royalty' because cannot be sortered
T.advance*(royaltyper/100) as Total
FROM publications.titles as T
JOIN publications.titleauthor as TA
ON T.title_id = TA.title_id
JOIN publications.sales as S
ON T.title_id = S.title_id
JOIN publications.authors as A
ON TA.au_id = A.au_id
GROUP BY TA.au_id, T.title_id
ORDER BY Sales_Royalty DESC; # Cannot order by using it if declared as 'Sales_Royalty'
