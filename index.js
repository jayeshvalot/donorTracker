var express = require('express');
var app = express.Router();
var db = require('./database');

/* GET home page. */
app.get('/getAllUser', function(req, res, next) {
  db.query('select * from users;', function (error, results, fields) {
    if (error) res.send({"error": error});
    res.send(results);
  });
});

app.post('/createUser', function(req, res, next) {
  db.query(`insert into users (name, blood_group, email, contact, password) values ("${req.body['name']}", "${req.body['blood_group']}", "${req.body['email']}", "${req.body['contact']}", "${req.body['password']}");`, function (error, results, fields) {
    if (error) res.send({"error": error});
    res.send({"status": "success"});
  });
});

app.put('/updateUser', function(req, res, next) {
  db.query(`update users set name = "${req.body['name']}", blood_group = "${req.body['blood_group']}", contact = "${req.body['contact']}" where email = "${req.body['email']}";`, function (error, results, fields) {
    if (error) res.send({"error": error});
    res.send({"status": "success"});
  });
});

app.put('/updateLocation', function(req, res, next) {
  db.query(`update users set latitude = ${req.body['latitude']}, longitude = ${req.body['longitude']} where email = "${req.body['email']}";`, function (error, results, fields) {
    if (error) res.send({"error": error});
    res.send({"status": "success"});
  });
});

app.post('/changePassword', function(req, res, next) {
  db.query(`update users set password = "${req.body['new_password']}" where email = "${req.body['email']}" and password = "${req.body['password']}";`, function (error, results, fields) {
    if (error) res.send({"error": error});
    
    if(results['affectedRows'] === 1)
    res.send({"status": "success"});
    
    if(results['affectedRows'] === 0)
    res.send({"status": "Incorrect Password!!!"});
  });
});


app.post('/login', function(req, res, next) {
  db.query(`select password = "${req.body['password']}" as isEqual, name, blood_group, email, contact from users where email = "${req.body['email']}";`, function (error, results, fields) {
    if (error) res.send({"error": error});
    
    if(results.length === 0)
    res.send({"status": "Email Not Exist!!!"});
    
    if(results[0]['isEqual'] === 0)
    res.send({"status": "Incorrect Password!!!"});
    
    if(results[0]['isEqual'] === 1)
    res.send({"status": "success",
    "data": results[0]
    });
  });
});

module.exports = app;
