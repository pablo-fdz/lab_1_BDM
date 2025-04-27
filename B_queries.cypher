---------------- Part B Querying--------------------
// 1. Find the top 3 most cited papers of each conference.
MATCH (pe:ProceedingEdition)<-[:PUBLISHED_IN]-(p:Paper)<-[c:CITES]-()
WITH pe, p, count(c) AS num_citations
ORDER BY pe.id, num_citations DESC
WITH pe, collect({paper: p, citations: num_citations}) AS papers
RETURN pe.number AS conference_number, 
       [paper IN papers[..3] | {title: paper.paper.title, citations: paper.citations}] AS top_3_cited_papers;


// 3. Impact Factor query:
WITH 2024 AS targetYear  //can adjust the target year as needed
MATCH (j:Journal)-[:HAS_VOLUME]->(jv:JournalVolume)<-[:PUBLISHED_IN]-(p:Paper)
WHERE jv.year IN [targetYear-1, targetYear-2]  // Papers published in Y-1 and Y-2

// Find citations to these papers
OPTIONAL MATCH (citing:Paper)-[:CITES]->(p)
WHERE citing.id IS NOT NULL  // ensure citing paper exists (should be always true)

// Now, group by journal
WITH j.journal_name AS journal, count(DISTINCT citing) AS total_citations, count(DISTINCT p) AS total_papers

RETURN journal,
       total_citations,
       total_papers,
       CASE 
         WHEN total_papers = 0 THEN 0 
         ELSE toFloat(total_citations) / total_papers 
       END AS impact_factor
ORDER BY impact_factor DESC;