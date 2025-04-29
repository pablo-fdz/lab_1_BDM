CALL gds.graph.project(
  'paperCitationGraph',          // Nombre interno que le damos al subgrafo
  'Paper',                       // Nodo de tipo Paper
  {
    CITES: {                     // Solo usamos las relaciones de tipo CITES
      orientation: 'NATURAL'      // Mantener la dirección original (paper que cita -> paper citado)
    }
  }
);
CALL gds.pageRank.stream('paperCitationGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).title AS paperTitle, 
       score
ORDER BY score DESC
LIMIT 10;