# 1. Data sources

Data downloaded from DBLP: https://dblp.org/faq/How+can+I+download+the+whole+dblp+dataset.html

Additional data has been created using the `Faker` library in Python.

# 2. Loading the data into Neo4j

## 2.1. Parsing the XML files

Steps used to convert the DBLP XML file to CSV format (see https://github.com/ThomHurks/dblp-to-csv):

1. **Install the `lxml` library into a virtual environment with Python 3.7+**:
   
   ```bash
   pip install lxml
   ```

2. **Open a terminal in the directory** where you have the extracted `dblp.xml` dataset and which also contains the `dblp.dtd` file (downloaded from [here](https://dblp.org/faq/How+can+I+download+the+whole+dblp+dataset.html)) and the script `XMLToCSV.py` (downloaded [here](https://github.com/ThomHurks/dblp-to-csv)), and **activate the environment** where you have installed `lxml`.
   
3. **Convert the Python script to an executable file**. The code below implements it in Linux:
   
   ```bash
   chmod +x XMLToCSV.py
   ```

4. **Parse the XML file into a CSV** (example):
   
   ```bash
   python XMLToCSV.py --annotate --neo4j dblp.xml dblp.dtd output.csv --relations author:authored_by journal:published_in publisher:published_by school:submitted_at editor:edited_by cite:has_citation series:is_part_of
   ```
   
   Options that can be specified (taken from the GitHub repo):

   ```plain text
   usage: XMLToCSV.py [-h] [--annotate] [--neo4j]
                   [--relations RELATIONS [RELATIONS ...]]
                   xml_filename dtd_filename outputfile
   
   Parse the DBLP XML file and convert it to CSV
   
   positional arguments:
   xml_filename          The XML file that will be parsed
   dtd_filename          The DTD file used to parse the XML file
   outputfile            The output CSV file
   
   optional arguments:
   -h, --help            show this help message and exit
   --annotate            Write a separate annotated header with type
                           information
   --neo4j               Headers become more Neo4J-specific and a neo4j-import
                           shell script is generated for easy importing. Implies
                           --annotate.
   --relations RELATIONS [RELATIONS ...]
                           The element attributes that will be treated as
                           elements, and for which a relation to the parent
                           element will be created. For example, in order to turn
                           the author attribute of the article element into an
                           element with a relation, use "author:authors". The
                           part after the colon is used as the name of the
                           relation.
   ```

   - Specifying `--annotate --neo4j` makes the output more compatible with Neo4j.
   - The different `relations` included in the XML file can be found [here](https://dblp.org/faq/16154937.html).

5. **The `.csv` files will be created in the same directory where the script and the data is contained and under the pattern `output_relation`**. Executing the example above takes approximately 7 minutes. The resulting folder structure will be as follows:
   
   ```bash
   ├── dblp.dtd
   ├── dblp.xml
   ├── dblp.xml.gz
   ├── neo4j_import.sh
   ├── output_article.csv
   ├── output_article_header.csv
   ├── output_author_authored_by.csv
   ├── output_author.csv
   ├── output_book.csv
   ├── output_book_header.csv
   ├── output_cite.csv
   ├── output_cite_has_citation.csv
   ├── output_data.csv
   ├── output_data_header.csv
   ├── output_editor.csv
   ├── output_editor_edited_by.csv
   ├── output_incollection.csv
   ├── output_incollection_header.csv
   ├── output_inproceedings.csv
   ├── output_inproceedings_header.csv
   ├── output_journal.csv
   ├── output_journal_published_in.csv
   ├── output_mastersthesis.csv
   ├── output_mastersthesis_header.csv
   ├── output_phdthesis.csv
   ├── output_phdthesis_header.csv
   ├── output_proceedings.csv
   ├── output_proceedings_header.csv
   ├── output_publisher.csv
   ├── output_publisher_published_by.csv
   ├── output_school.csv
   ├── output_school_submitted_at.csv
   ├── output_series.csv
   ├── output_series_is_part_of.csv
   ├── output_www.csv
   ├── output_www_header.csv
   ├── README.txt
   └── XMLToCSV.py
   ```

6. **The files follow this pattern**:
   
   - `output_[entity].csv` - Contains the entity data (nodes).
   - `output_[entity]_header.csv` - Contains headers for the entity files.
   - `output_[entity]_[relationship].csv` - Contains relationship data between entities (edges).
   - Note also that the script also generates a shell script called `neo4j_import.sh` that can be run to import the generated CSV files into a Neo4j graph database using the `neo4j-admin import` bulk importer tool.

## 2.2. Loading the data into Neo4j

As a reference, see: https://neo4j.com/docs/cypher-manual/current/clauses/load-csv/#_import_csv_data_into_neo4j. For more efficient imports, check out the use of `neo4j-admin database import`: https://neo4j.com/docs/operations-manual/current/import/