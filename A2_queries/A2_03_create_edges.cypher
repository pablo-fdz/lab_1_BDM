//A2_03_create_edges

// CITES relationships (Paper -> Paper)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/cites.csv' AS row
MATCH (source:Paper {id: toInteger(row.source_paper)}), (target:Paper {id: toInteger(row.target_paper)})
CREATE (source)-[:CITES]->(target);

// WROTE relationships (Author -> Paper)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/wrote.csv' AS row
MATCH (a:Author {id: toInteger(row.author_id)}), (p:Paper {id: toInteger(row.paper_id)})
CREATE (a)-[:WROTE {corresponding: toBoolean(row.corresponding)}]->(p);

// REVIEWED relationships (Author -> Paper)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/reviewed.csv' AS row
MATCH (a:Author {id: toInteger(row.author_id)}), (p:Paper {id: toInteger(row.paper_id)})
CREATE (a)-[:REVIEWED {review_date: date(row.review_date)}]->(p);

// HAS_KEYWORD relationships (Paper -> Keyword)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/has_keyword.csv' AS row
MATCH (p:Paper {id: toInteger(row.paper_id)}), (k:Keyword {id: toInteger(row.keyword_id)})
CREATE (p)-[:HAS_KEYWORD]->(k);

// PUBLISHED_IN relationships (Paper -> ProceedingEdition or JournalVolume)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/published_in.csv' AS row
MATCH (p:Paper {id: toInteger(row.paper_id)})
OPTIONAL MATCH (pe:ProceedingEdition {id: toInteger(row.proceeding_edition_id)})
OPTIONAL MATCH (jv:JournalVolume {id: toInteger(row.journal_volume_id)})
FOREACH (_ IN CASE WHEN pe IS NOT NULL THEN [1] ELSE [] END |
  CREATE (p)-[:PUBLISHED_IN {accepted_date: date(row.date_accepted), pages: row.pages}]->(pe)
)
FOREACH (_ IN CASE WHEN jv IS NOT NULL THEN [1] ELSE [] END |
  CREATE (p)-[:PUBLISHED_IN {accepted_date: date(row.date_accepted), pages: row.pages}]->(jv)
);

// HAS_VOLUME relationships (Journal -> JournalVolume)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/has_volume.csv' AS row
MATCH (journal:Journal {id: toInteger(row.journal_id)}), (volume:JournalVolume {id: toInteger(row.volume_id)})
CREATE (journal)-[:HAS_VOLUME]->(volume);

// HAS_EDITION relationships (Proceeding -> ProceedingEdition)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/has_edition.csv' AS row
MATCH (proceeding:Proceeding {id: toInteger(row.proceeding_id)}), (edition:ProceedingEdition {id: toInteger(row.edition_id)})
CREATE (proceeding)-[:HAS_EDITION]->(edition);

// HELD_IN relationships (ProceedingEdition -> Venue)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/held_in.csv' AS row
MATCH (proceeding:ProceedingEdition {id: toInteger(row.proceeding_id)}), (venue:Venue {id: toInteger(row.venue_id)})
CREATE (proceeding)-[:HELD_IN]->(venue);