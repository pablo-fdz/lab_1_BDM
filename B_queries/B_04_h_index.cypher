// B_04_h-index

// 1. Get authors who have published papers
MATCH (a:Author)-[:WROTE]->(p:Paper)
WHERE EXISTS((p)-[:PUBLISHED_IN]->())

// 2. Calculate number of citations per paper and author
OPTIONAL MATCH (p)<-[:CITES]-(citing:Paper) // Optional match because some papers may not be cited
WHERE EXISTS((citing)-[:PUBLISHED_IN]->()) // Count only citations from other published papers
WITH a, p, COUNT(citing) AS numCites

// 3. Order papers by citation count (descending) and collect into a list
ORDER BY numCites DESC
WITH a, COLLECT(numCites) AS citationsList

// 4. Calculate the length of the citationsList
WITH a, citationsList, REDUCE(count = 0, x IN citationsList | count + 1) AS listLength

// 5. Create a range from 1 to the list length for potential h-index values
WITH a, citationsList, listLength, 
     CASE WHEN listLength > 0 THEN RANGE(1, listLength) ELSE [] END AS indices

// 6. Calculate possible h-indices
WITH a, citationsList, 
     [i IN indices WHERE i <= citationsList[i-1] | i] AS possibleHIndices

// 7. Calculate the length of possibleHIndices and find the max
WITH a, citationsList, possibleHIndices,
     REDUCE(count = 0, x IN possibleHIndices | count + 1) AS possibleHIndicesLength,
     REDUCE(maxVal = 0, x IN possibleHIndices | CASE WHEN x > maxVal THEN x ELSE maxVal END) AS maxHIndex

// 8. Return the final results
RETURN
  a.name AS author,
  citationsList,
  CASE
    WHEN possibleHIndicesLength > 0 THEN maxHIndex
    ELSE 0
  END AS h_index
ORDER BY h_index DESC