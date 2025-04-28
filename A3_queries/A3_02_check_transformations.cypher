//A3_02_check_transformations
MATCH (a:Author)
RETURN a.id, a.name, a.affiliation
LIMIT 10;

// Check if all REVIEWED relationships have the new properties
MATCH (a:Author)-[r:REVIEWED]->(p:Paper)
RETURN a.name, p.title, r.review_date, r.description, r.suggested_acceptance
LIMIT 10;