//A2_02_create_nodes
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/authors.csv' AS row
CREATE (:Author {id: toInteger(row.id), name: row.name});

// Keywords
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/keywords.csv' AS row
CREATE (:Keyword {id: toInteger(row.id), name: row.name});

// Papers
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/papers.csv' AS row
CREATE (:Paper {id: toInteger(row.id), title: row.title, abstract: row.abstract, doi: row.doi});

// Proceedings (conference editions)
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/proceedings.csv' AS row
CREATE (:ProceedingEdition {id: toInteger(row.id), number: toInteger(row.number), start_date: date(row.start_date), end_date: date(row.end_date)});

// Venues
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/venues.csv' AS row
CREATE (:Venue {id: toInteger(row.id), venue_name: row.venue_name});

// Journals
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/journals.csv' AS row
CREATE (:Journal {id: toInteger(row.id), journal_name: row.journal_name});

// Journal Volumes
LOAD CSV WITH HEADERS FROM 'file:///data_lab1/journal_volumes.csv' AS row
CREATE (:JournalVolume {id: toInteger(row.id), volume: toInteger(row.volume), year: toInteger(row.year), issue: toInteger(row.issue)});