//A2_03_create_edges
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/citations.csv' AS row
MATCH (source:Paper {id: toInteger(row.source_paper)}), (target:Paper {id: toInteger(row.target_paper)})
CREATE (source)-[:CITES]->(target);

// WROTE relationships (Author -> Paper)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/wrote.csv' AS row
MATCH (a:Author {id: toInteger(row.author_id)}), (p:Paper {id: toInteger(row.paper_id)})
CREATE (a)-[:WROTE {corresponding: toBoolean(row.corresponding)}]->(p);

// HAS_KEYWORD relationships (Paper -> Keyword)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/has_keyword.csv' AS row
MATCH (p:Paper {id: toInteger(row.paper_id)}), (k:Keyword {id: toInteger(row.keyword_id)})
CREATE (p)-[:HAS_KEYWORD]->(k);

// PUBLISHED_IN relationships (Paper -> ProceedingEdition or JournalVolume)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/published_in.csv' AS row
MATCH (p:Paper {id: toInteger(row.paper_id)})
OPTIONAL MATCH (pe:ProceedingEdition {id: toInteger(row.proceeding_id)})
OPTIONAL MATCH (jv:JournalVolume {id: toInteger(row.journal_volume_id)})
FOREACH (_ IN CASE WHEN pe IS NOT NULL THEN [1] ELSE [] END |
  CREATE (p)-[:PUBLISHED_IN {accepted_date: date(row.date_accepted), pages: row.pages}]->(pe)
)
FOREACH (_ IN CASE WHEN jv IS NOT NULL THEN [1] ELSE [] END |
  CREATE (p)-[:PUBLISHED_IN {accepted_date: date(row.date_accepted), pages: row.pages}]->(jv)
);

// HELD_IN relationships (ProceedingEdition -> Venue)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/held_in.csv' AS row
MATCH (proceeding:ProceedingEdition {id: toInteger(row.proceeding_id)}), (venue:Venue {id: toInteger(row.venue_id)})
CREATE (proceeding)-[:HELD_IN]->(venue);

// _RELATED relationships (ProceedingEdition -> Virtual node)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/related.csv' AS row
MATCH (proceeding:ProceedingEdition {id: toInteger(row.proceeding_id)})
CREATE (proceeding)-[:_RELATED]->(:Related {type: row.type, name: row.name});