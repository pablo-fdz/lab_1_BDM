//A3_03_instantiate_data

// Update property of affiliation of Authors with new csv
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/authors_additional_properties.csv' AS row
MATCH (a:Author {id: toInteger(row.author_id)})
SET a.affiliation = row.affiliation;

// Update properties of REVIEWED edges
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/reviewed_additional_properties.csv' AS row
MATCH (a:Author {id: toInteger(row.author_id)})-[r:REVIEWED]->(p:Paper {id: toInteger(row.paper_id)})
SET r.description = row.description,
    r.suggested_acceptance = toBoolean(row.suggested_acceptance);