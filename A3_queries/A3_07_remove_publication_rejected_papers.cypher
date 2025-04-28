// A3_07_remove_publication_rejected_papers 
// We remove the PUBLISHED_IN edge of papers which the majority want to reject 

// Step 1: Find papers where the majority of reviewers suggested not to accept
MATCH (p:Paper)
WITH p, COUNT{(p)<-[:REVIEWED]-()} AS total_reviews,
     COUNT{(p)<-[:REVIEWED {suggested_acceptance: false}]-()} AS negative_reviews
WHERE total_reviews > 0 AND negative_reviews / total_reviews > 0.5  // Majority check (> 50%)

// Step 2: For these papers, delete the PUBLISHED_IN relationships
MATCH (p)-[r:PUBLISHED_IN]->()
DELETE r
RETURN count(r) AS removed_relationships;

// Note that, with the fake data that we have created, the number that is returned does not necessarily match with the number of papers for which a majority of reviews suggest their rejection (query A3_06)