// B_01_top3_papers_conference

// 1. Find the top 3 most cited papers of each conference.
MATCH (pe:ProceedingEdition)<-[:PUBLISHED_IN]-(p:Paper)<-[c:CITES]-()
WITH pe, p, count(c) AS num_citations
ORDER BY pe.id, num_citations DESC
WITH pe, collect({paper: p, citations: num_citations}) AS papers
RETURN pe.number AS conference_number, 
       [paper IN papers[..3] | {title: paper.paper.title, citations: paper.citations}] AS top_3_cited_papers;