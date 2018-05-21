// From https://github.com/edx/devstack/blob/9a97d85643efe0237c42b12aea62f2b6a68ddced/mongo-provision.js

conn = new Mongo();

users = [
    {
        'user': 'admin',
        'pwd': 'password',
        'roles': ['root'],
        'database': 'admin'
    },
    {
        'user': 'cs_comments_service',
        'pwd': 'password',
        'roles': ['readWrite'],
        'database': 'cs_comments_service'
    },
    {
        'user': 'edxapp',
        'pwd': 'password',
        'roles': ['readWrite'],
        'database': 'edxapp'
    }
];

for (var i = 0; i < users.length; i++) {
    var user = users[i];
    var username = user.user;
    var db = conn.getDB(user.database);
    delete user.database;

    if (db.getUser(username) == null) {
        db.createUser(user);
    } else {
        delete user.user;
        db.updateUser(username, user);
    }
}
