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

4. **Parse the XML file into a CSV**:
   
   ```bash
   python XMLToCSV.py --annotate --neo4j dblp.xml dblp.dtd output.csv --relations author:authored_by journal:published_in cite:has_citation
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

As a reference, see: https://neo4j.com/docs/cypher-manual/current/clauses/load-csv/#_import_csv_data_into_neo4j. For more efficient imports, check out the use of `neo4j-admin database import`: 

- Basic tutorial: https://neo4j.com/docs/operations-manual/current/tutorial/neo4j-admin-import/
- Documentation: https://neo4j.com/docs/operations-manual/current/import/.



Steps that I have followed:

1. Updating the file `neo4j_import.sh` to the current syntax (check out the documentation above for more information).

   Before:

   ``` bash
   #!/bin/bash
   neo4j-admin import --mode=csv --database=dblp.db --delimiter ";" --array-delimiter "|" --id-type INTEGER --nodes:incollection "output_incollection_header.csv,output_incollection.csv" --nodes:mastersthesis "output_mastersthesis_header.csv,output_mastersthesis.csv" --nodes:data "output_data_header.csv,output_data.csv" --nodes:proceedings "output_proceedings_header.csv,output_proceedings.csv" --nodes:inproceedings "output_inproceedings_header.csv,output_inproceedings.csv" --nodes:phdthesis "output_phdthesis_header.csv,output_phdthesis.csv" --nodes:book "output_book_header.csv,output_book.csv" --nodes:article "output_article_header.csv,output_article.csv" --nodes:www "output_www_header.csv,output_www.csv" --nodes:cite "output_cite.csv" --relationships:has_citation "output_cite_has_citation.csv" --nodes:journal "output_journal.csv" --relationships:published_in "output_journal_published_in.csv" --nodes:author "output_author.csv" --relationships:authored_by "output_author_authored_by.csv"
   ```

   After:

   ```bash
   #!/bin/bash
   
   # Create a database named 'dblp' with all the data from the CSV files
   sudo -u neo4j neo4j-admin database import full \
     --nodes=incollection="output_incollection_header.csv,output_incollection.csv" \
     --nodes=mastersthesis="output_mastersthesis_header.csv,output_mastersthesis.csv" \
     --nodes=data="output_data_header.csv,output_data.csv" \
     --nodes=proceedings="output_proceedings_header.csv,output_proceedings.csv" \
     --nodes=inproceedings="output_inproceedings_header.csv,output_inproceedings.csv" \
     --nodes=phdthesis="output_phdthesis_header.csv,output_phdthesis.csv" \
     --nodes=book="output_book_header.csv,output_book.csv" \
     --nodes=article="output_article_header.csv,output_article.csv" \
     --nodes=www="output_www_header.csv,output_www.csv" \
     --nodes=cite="output_cite.csv" \
     --relationships=has_citation="output_cite_has_citation.csv" \
     --nodes=journal="output_journal.csv" \
     --relationships=published_in="output_journal_published_in.csv" \
     --nodes=author="output_author.csv" \
     --relationships=authored_by="output_author_authored_by.csv" \
     --delimiter=";" \
     --array-delimiter="|" \
     --id-type=INTEGER \
     --skip-bad-relationships=true \
     --skip-duplicate-nodes=true \
     dblp
   ```

2. Copy the output files into the `import` directory of Neo4j (the command below is being executed in the directory where the outputs are stored):

   ```bash
   sudo cp output_*.csv /var/lib/neo4j/import/
   ```

3. Changing the working directory to the `import` directory of Neo4j:

   ```bash
   cd /var/lib/neo4j/import/
   ```

4. Paste the updated commands for creating the database in the terminal, and execute them. This returns (if successfully executed - only part of the output is displayed below):

   ```
   Starting to import, output will be saved to: /var/log/neo4j/neo4j-admin-import-2025-04-26.19.09.52.log
   Neo4j version: 2025.03.0
   Importing the contents of these files into /var/lib/neo4j/data/databases/dblp:
   ...
   IMPORT DONE in 25s 122ms. 
   Imported:
     15492465 nodes
     33886108 relationships
     117279448 properties
   Peak memory usage: 1.171GiB
   ```

   Through this method, the database will be stored in the `/var/lib/neo4j/data/databases/dblp` folder.

5. Remove the imported files in the directory in which they have been copied:

   ```bash
   sudo rm /var/lib/neo4j/import/output_*.csv
   ```

6. Check out the Neo4j databases:

   ```bash
   ls -la /var/lib/neo4j/data/databases/ 
   ```

   Which shows:

   ```
   total 12
   drwxr-xr-x 3 neo4j adm   4096 Apr 26 19:00 .
   drwxr-xr-x 6 neo4j adm   4096 Apr 16 19:20 ..
   drwxrwxr-x 3 neo4j neo4j 4096 Apr 26 19:10 dblp
   ```

7. Ensure Neo4j has permissions to access the database:

   ```bash
   sudo chown -R neo4j:neo4j /var/lib/neo4j/data/databases/dblp
   ```

To be explored more in depth: https://community.neo4j.com/t/how-can-i-use-a-database-created-with-neo4j-admin-import-in-neo4j-desktop/40594; see also https://neo4j.com/docs/operations-manual/current/backup-restore/offline-backup/#offline-backup-example