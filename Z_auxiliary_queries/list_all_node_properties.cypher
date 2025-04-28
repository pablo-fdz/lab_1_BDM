//list_all_node_properties

// Get all properties for each node label
CALL db.schema.nodeTypeProperties() 
YIELD nodeType, propertyName
RETURN nodeType, collect(propertyName) AS properties
ORDER BY nodeType;