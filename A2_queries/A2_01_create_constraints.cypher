//A2_01_create_constraints
CREATE CONSTRAINT author_id_unique IF NOT EXISTS FOR (a:Author) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT paper_id_unique IF NOT EXISTS FOR (p:Paper) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT keyword_id_unique IF NOT EXISTS FOR (k:Keyword) REQUIRE k.id IS UNIQUE;
CREATE CONSTRAINT proceeding_id_unique IF NOT EXISTS FOR (pr:Proceeding) REQUIRE pr.id IS UNIQUE;
CREATE CONSTRAINT venue_id_unique IF NOT EXISTS FOR (v:Venue) REQUIRE v.id IS UNIQUE;
CREATE CONSTRAINT journal_id_unique IF NOT EXISTS FOR (j:Journal) REQUIRE j.id IS UNIQUE;