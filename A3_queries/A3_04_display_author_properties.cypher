// A3_04_display_author_properties

// Display 5 Author nodes with the new 'affiliation' property
MATCH (a:Author)
RETURN a.id, a.name, a.affiliation
LIMIT 5;