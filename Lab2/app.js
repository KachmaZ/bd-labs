const Mysql = require('sync-mysql');
const connection = new Mysql({
    host: 'localhost',
    user: 'root',
    password: '2001', // Убедитесь, что пароль верен
    database: 'Observatory'
});

const path = require('path');
const fs = require('fs');
const qs = require('querystring');
const http = require('http');

function reqPost(request, response) {
    if (request.method == 'POST') {
        let body = '';

        request.on('data', function (data) {
            body += data;
        });

        request.on('end', function () {
            const post = qs.parse(body);
            const sInsert = `INSERT INTO Sector (coordinates, light_intensity, foreign_objects, star_objects_count, unknown_objects_count, defined_objects_count, notes) 
                            VALUES ("${post['col1']}", 3.4, 5, 30, 2, 28, "Новый сектор")`;
            const results = connection.query(sInsert);
            console.log('Done. Hint: ' + sInsert);
        });
    }
}

function ViewSelect(res) {
    const query = 'SELECT * FROM Sector';
    const results = connection.query(query);

    res.write('<tr>');
    for (let key in results[0]) {
        res.write('<th>' + key + '</th>');
    }
    res.write('</tr>');

    for (let row of results) {
        res.write('<tr>');
        for (let key in row) {
            res.write('<td>' + row[key] + '</td>');
        }
        res.write('</tr>');
    }
}

function ViewVer(res) {
    const results = connection.query('SELECT VERSION() AS ver');
    res.write(results[0].ver);
}

const server = http.createServer((req, res) => {
    reqPost(req, res);
    console.log('Loading...');

    res.statusCode = 200;

    const filePath = path.join(__dirname, 'select.html');
    const array = fs.readFileSync(filePath).toString().split("\n");
    console.log(filePath);
    for (let i in array) {
        if ((array[i].trim() != '@tr') && (array[i].trim() != '@ver')) res.write(array[i]);
        if (array[i].trim() == '@tr') ViewSelect(res);
        if (array[i].trim() == '@ver') ViewVer(res);
    }
    res.end();
    console.log('1 User Done.');
});

const hostname = '127.0.0.1';
const port = 3000;
server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});