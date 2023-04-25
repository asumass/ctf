const express = require('express');
const app = express();
const sha256 = require('sha256');


const port = 80;

app.use('/public', express.static(__dirname + '/public', { 
    setHeaders: (res, path, stat) => {
      if (path.endsWith('.css')) {
        res.setHeader('Content-Type', 'text/css');
      }
    }
}));

app.use(express.json());


users = [
  {"name":"16a41d9ce114db967b4e44f50c00a889c51d835a51bedd2aacbc8dc6b4d12182","password":"5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"},
  {"name":"a56963ae01b6c38192e7b232f195c38fee3e760bb2b739a6d539b5a9d247d332","password":"0c0f5565ab10230a0b14ef1649c5c645a86295095486cc9041ab4acc01746ca4"}
]
users_passwords_map = {}
users.forEach(user=>users_passwords_map[user.name]=user.password)


app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});
  

app.post('/login', (req, res) => {
    const username = req.body.username;
    const password = req.body.password;

    // Check if username and password are valid
    if (users_passwords_map[sha256(username)]==sha256(password)) {
        res.statusCode = 200;
        res.setHeader('Content-Type', 'text/html');
        res.end('<h1>Login successful</h1>');
      } else {
        res.statusCode = 401;
        res.setHeader('Content-Type', 'text/html');
        res.end('<h1>Invalid username or password</h1>');
      }
});

app.get('/userssha256',(req,res)=>{
    res.statusCode = 200;
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(users));
});
  
app.listen(port, () => {
    console.log(`Server is listening on port ${port}`);
});