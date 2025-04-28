// A3_05_display_reviewed_properties

// Display 5 REVIEWED relationships with the new properties
MATCH (a:Author)-[r:REVIEWED]->(p:Paper)
RETURN a.id, a.name, 
       p.id, p.title, 
       r.review_date,
       r.description, 
       r.suggested_acceptance
LIMIT 5;