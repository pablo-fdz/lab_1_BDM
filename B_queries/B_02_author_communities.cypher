// B_02_author_communities

// First, match all of the proceedings which are conferences, and go back to the Author node
MATCH (pr:Proceeding {proceeding_type: 'Conference'})-[:HAS_EDITION]->(pe:ProceedingEdition)<-[:PUBLISHED_IN]-(p:Paper)<-[:WROTE]-(a:Author)
// Count distinct editions in which the author has published
WITH pr, a, COUNT(DISTINCT pe) AS editionsCount
// Keep only the authors who have published in 4 or more editions for each proceeding
WHERE editionsCount >= 4
// Return author communities, conference and count of editions
RETURN 
  pr.proceeding_name AS conferenceName,
  editionsCount,
  COLLECT(a.name) AS communityAuthors
ORDER BY editionsCount DESC; 