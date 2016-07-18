exports.insertDB = (db, data, collection, cb) ->
  delete data._id if data._id?
  db[collection].insert data, (err) ->
    return cb err if err