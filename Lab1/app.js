const Mysql = require('sync-mysql');
const path = require('path');
const fs = require('fs');
const qs = require('querystring');
const http = require('http');

const connection = new Mysql({
    host: 'localhost',
    user: 'root',
    password: '2001',
    database: 'ElectricBank'
});

function handlePostRequest(request, response) {
    if (request.method === 'POST') {
        let body = '';

        request.on('data', chunk => {
            body += chunk.toString();
        });

        request.on('end', () => {
            const post = qs.parse(body);
            const sInsert = `INSERT INTO Individuals (borrowerId, firstName, lastName, middleName, passport, inn, snils, driversLicense, additionalDocuments, notes) 
                             VALUES (1, "${post['col1']}", "${post['col2']}", "${post['col3']}", "", "", "", "", "", "")`;
            connection.query(sInsert);
            console.log('Insert Query:', sInsert);
            response.writeHead(302, { 'Location': '/' });
            response.end();
        });
    }
}

function handleDeleteRequest(request, response) {
    const sDelete = `DELETE FROM Individuals ORDER BY id DESC LIMIT 10`;
    connection.query(sDelete);
    console.log('Delete Query:', sDelete);
    response.writeHead(302, { 'Location': '/' });
    response.end();
}

function renderTableRows(res) {
    const columns = connection.query('SHOW COLUMNS FROM Individuals');
    res.write('<tr>');
    columns.forEach(column => {
        res.write(`<th>${column.Field}</th>`);
    });
    res.write('</tr>');

    const data = connection.query('SELECT * FROM Individuals ORDER BY id DESC');
    data.forEach(row => {
        res.write('<tr>');
        Object.values(row).forEach(value => {
            res.write(`<td>${value || ''}</td>`);
        });
        res.write('</tr>');
    });
}

function renderVersion(res) {
    const results = connection.query('SELECT VERSION() AS ver');
    res.write(results[0].ver);
}

const server = http.createServer((req, res) => {
    if (req.method === 'POST') {
        handlePostRequest(req, res);
    } else if (req.method === 'GET' && req.url === '/delete') {
        handleDeleteRequest(req, res);
    } else {
        res.statusCode = 200;
        const filePath = path.join(__dirname, 'select.html');
        const content = fs.readFileSync(filePath, 'utf8');
        content.split("\n").forEach(line => {
            if (line.trim() !== '@tr' && line.trim() !== '@ver') {
                res.write(line);
            } else if (line.trim() === '@tr') {
                renderTableRows(res);
            } else if (line.trim() === '@ver') {
                renderVersion(res);
            }
        });
        res.end();
    }
});

const hostname = '127.0.0.1';
const port = 3000;
server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});