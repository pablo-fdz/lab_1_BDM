//check_proceeding_nodes

// Check what Proceeding nodes exist and what properties they have
MATCH (p:Proceeding)
RETURN p.id, p.proceeding_name, p.proceeding_type
LIMIT 20;