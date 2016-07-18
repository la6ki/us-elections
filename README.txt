###
After cloning the project for the first time:
1. Navigate to project's root directory with a command line tool.
2. Run the command `npm i` (this will install all node packages).
3. Run 'npm run build' (this will compile all .coffee files to .js files).
4. Edit the .env file in the root directory and enter proper values for the DB, python, and email constants.
5. Start the MongoDB server.
6. Run 'node populate_db' (this will populate all DB collections with the analysis results of all 2016 polls).

###
To start the server:
1. Start the MongoDB server.
2. Run 'node app' (with this the app will start listening to http requests at port 80).

The map and all election data should be available at http://localhost/map

###
To scrape and analyze send new polls and send all new data to DB:
1. Start the MongoDB server.
2. Run 'node run_daily_analysis'.