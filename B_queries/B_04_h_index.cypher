// B_04_h-index

// 1. Get authors who have published papers
MATCH (a:Author)-[:WROTE]->(p:Paper)
WHERE EXISTS((p)-[:PUBLISHED_IN]->())

// 2. Calculate number of citations per paper and author
OPTIONAL MATCH (p)<-[:CITES]-(citing:Paper)  // Optional match befores some papers may not be cited
WHERE EXISTS((citing)-[:PUBLISHED_IN]->())  // Count only citations from other published papers
WITH a, p, COUNT(citing) AS numCites 

// 3. Order papers by citation count (descending) and collect into a list
ORDER BY numCites DESC
WITH a, COLLECT(numCites) AS citationsList

// 4. Calculate h-index using array operations
WITH a, citationsList,
     [i IN RANGE(1, SIZE(citationsList)) WHERE i <= citationsList[i-1] | i] AS possibleHIndices
RETURN
    a.name as author,
    citationsList,
    CASE
        WHEN SIZE(possibleHIndices) > 0 THEN MAX(possibleHIndices)
        ELSE 0
    END AS h_index
ORDER BY h_index DESC