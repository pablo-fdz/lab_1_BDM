# lab_1_BDM

# A.1. Modeling

The graph schema (without data) can be checked out by running in Cypher after having loaded a database:

```cypher
CREATE (:Keyword {name: "string"})<-[:HAS_KEYWORD]-(n6:Paper {title: "string", abstract: "string", doi: "string"})<-[:ASSIGNED_REVIEWER]-(:Author {name: "string"})-[:WROTE {corresponding: "bool"}]->(n2:Paper {title: "string", abstract: "string", doi: "string"})-[:PUBLISHED_IN {date_accepted: "date"}]->(n4:ProceedingEdition {number: "integer", start_date: "date", end_date: "date"})-[:HELD_IN]->(:Venue {venue_name: "string"}),
(:Keyword {name: "string"})<-[:HAS_KEYWORD]-(n2)-[:CITES]->(n6)-[:HAS_KEYWORD]->(n8:Keyword {name: "string"}),(n2)-[:HAS_KEYWORD]->(n8), 
(:Journal {journal_name: "string"})-[:HAS_VOLUME]->(:JournalVolume {volume: "int", year: "int", issue: "int"})<-[:PUBLISHED_IN {accepted_date: "date", pages: "string"}]-(n6),
(n4)-[:_RELATED]->({type: "string", name: "string"})
```

The graph can then be visualized by running:

```cypher
MATCH (n)-[r]->(m) RETURN n, r, m
```

# A.2. Instantiation/loading

1. First of all, run the Jupyter Notebook `lab_1_gdb_A2_data_generation.ipynb`, which will create fake data (both nodes and edges) that fits the description in A.1. and save it in different `.csv` files, under the folder `data_lab1`.
2. Second, create a new local DBMS in Neo4j. Using the graphical interface of *Neo4j desktop*, this can be done by:
   - Entering into a project.
   - Click *Add* -> *Local DBMS*, and set a name and a password.
3. Once the local DBMS has been created, import the `.csv` by loading them into the *Import* folder of the DBMS. This can be done by:
   - Click *...* -> *Open folder* -> *Import*.
   - In the *Import* folder, copy the folder called `data_lab1`.
4. Start the DBMS and open it.
5. Import the `.cypher` queries in the folder `A2_queries` (e.g., by dragging the script into the *Neo4j browser* visual interface).
6. Execute them for creating the graph, populating it with data and visualizing the result. 