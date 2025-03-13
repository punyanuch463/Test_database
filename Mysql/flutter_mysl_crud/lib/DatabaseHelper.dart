import 'package:mysql_client/mysql_client.dart';

class DatabaseHelper {
  static Future<MySQLConnection> _connectToDatabase() async {
    final conn = await MySQLConnection.createConnection(
      host: "192.168.1.131",
      port: 3306,
      userName: "root",
      password: "20032546",
      databaseName: "testmysqlflutter",
    );
    await conn.connect();
    return conn;
  }

  static Future<void> insertUser(
    String username,
    String email,
    String age,
  ) async {
    final conn = await _connectToDatabase();
    await conn.execute(
      "INSERT INTO user (username, email, age) VALUES (:username, :email, :age)",
      {'username': username, 'email': email, 'age': age},
    );
    await conn.close();
  }

  static Future<bool> updateUser(
    String username,
    String email,
    String age,
  ) async {
    final conn = await _connectToDatabase();
    var result = await conn.execute(
      "UPDATE user SET email = :email, age = :age WHERE username = :username",
      {'username': username, 'email': email, 'age': age},
    );
    await conn.close();

    if (result.affectedRows.toInt() > 0) {
      print("✅ User updated successfully");
      return true; // อัปเดตสำเร็จ
    } else {
      print("⚠️ Update failed: No user found with username $username");
      return false; // ไม่มีการเปลี่ยนแปลงข้อมูล
    }
  }

  static Future<void> deleteUser(String username) async {
    final conn = await _connectToDatabase();
    await conn.execute("DELETE FROM user WHERE username = :username", {
      'username': username,
    });
    await conn.close();
  }

  static Future<List<Map<String, String>>> fetchUsers() async {
    final conn = await _connectToDatabase();
    var results = await conn.execute('SELECT * FROM user');

    List<Map<String, String>> users =
        results.rows.map((row) {
          return row.assoc().map(
            (key, value) => MapEntry(key, value ?? ''),
          ); // แปลง null เป็น string ว่าง
        }).toList();

    await conn.close();
    return users;
  }
}
