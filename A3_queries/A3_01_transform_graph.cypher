//A3_01_transform_graph

// 1. We add an organization property to the "Author" nodes
MATCH (a:Author)
SET a.affiliation = "Unknown Organization";

// 2. We add "description" and "suggested acceptance" properties to the REVIEWED edge
MATCH ()-[r:REVIEWED]->()
SET r.description = "No description provided",
    r.suggested_acceptance = false;