//list_all_edge_properties

// Get all properties for each relationship type
CALL db.schema.relTypeProperties()
YIELD relType, propertyName
RETURN relType, collect(propertyName) AS properties
ORDER BY relType;