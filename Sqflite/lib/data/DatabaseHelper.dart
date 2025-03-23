import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/MedicalRecord.dart';
import '../models/Patient.dart';
import '../models/User.dart';

class DatabaseHelper {
  static Database? _database; // Change: Make _database nullable
  static const String dbName = 'patients.db';
  static const String patientTable = 'patients';
  static const String medicalRecordTable = 'medical_records';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Future<Map<String, List<Map<String, dynamic>>>> getAllData() async {
  //   Database db = await instance.database;

  //   List<Map<String, dynamic>> patients = await db.query(patientTable);
  //   List<Map<String, dynamic>> medicalRecords =
  //       await db.query(medicalRecordTable);
  //   List<Map<String, dynamic>> users = await db.query('users');

  //   return {
  //     'patients': patients,
  //     'medical_records': medicalRecords,
  //     'users': users,
  //   };
  // }
  Future<Map<String, dynamic>> getAllData() async {
    String dbPath = join(await getDatabasesPath(), 'patients.db'); // เพิ่ม path
    Database db = await instance.database;

    List<Map<String, dynamic>> patients = await db.query(patientTable);
    List<Map<String, dynamic>> medicalRecords =
        await db.query(medicalRecordTable);
    List<Map<String, dynamic>> users = await db.query('users');

    return {
      'db_path': dbPath, // เพิ่ม path เข้าไปในข้อมูลที่ return
      'patients': patients,
      'medical_records': medicalRecords,
      'users': users,
    };
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $patientTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        gender TEXT,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $medicalRecordTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        diagnosis TEXT,
        patientId INTEGER,
        FOREIGN KEY (patientId) REFERENCES $patientTable(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT,
      password TEXT
    )
  ''');
  }

  Future<int> insertPatient(Patient patient) async {
    Database db = await instance.database;
    return await db.insert(patientTable, patient.toMap());
  }

  Future<List<Patient>> getAllPatients() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(patientTable);
    return List.generate(maps.length, (i) {
      return Patient.fromMap(maps[i]);
    });
  }

  Future<int> updatePatient(Patient patient) async {
    Database db = await instance.database;
    return await db.update(
      patientTable,
      patient.toMap(),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  Future<int> deletePatient(int id) async {
    Database db = await instance.database;
    return await db.delete(
      patientTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertMedicalRecord(MedicalRecord record) async {
    Database db = await instance.database;
    return await db.insert(medicalRecordTable, record.toMap());
  }

  Future<List<MedicalRecord>> getMedicalRecordsForPatient(int patientId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      medicalRecordTable,
      where: 'patientId = ?',
      whereArgs: [patientId],
    );
    return List.generate(maps.length, (i) {
      return MedicalRecord.fromMap(maps[i]);
    });
  }

  Future<int> updateMedicalRecord(MedicalRecord record) async {
    Database db = await instance.database;
    return await db.update(
      medicalRecordTable,
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<List<MedicalRecord>> getAllMedicalRecords() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(medicalRecordTable);
    return List.generate(maps.length, (i) {
      return MedicalRecord.fromMap(maps[i]);
    });
  }

  Future<int> deleteMedicalRecord(int id) async {
    Database db = await instance.database;
    return await db.delete(
      medicalRecordTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<int> registerUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> loginUser(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Future<Map<String, dynamic>?> loginUserWithDetails(
  //     String username, String password) async {
  //   Database db = await instance.database;
  //   List<Map<String, dynamic>> result = await db.query(
  //     'users',
  //     where: 'username = ? AND password = ?',
  //     whereArgs: [username, password],
  //   );

  //   if (result.isNotEmpty) {
  //     Map<String, dynamic> user = result.first;
  //     int userId = user['id']; // สมมติว่ามี `id` ของ user

  //     List<Map<String, dynamic>> patients = await db.query(
  //       patientTable,
  //       where: 'id = ?',
  //       whereArgs: [userId],
  //     );

  //     List<Map<String, dynamic>> medicalRecords = await db.query(
  //       medicalRecordTable,
  //       where: 'patientId = ?',
  //       whereArgs: [userId],
  //     );

  //     return {
  //       'user': user,
  //       'patients': patients,
  //       'medical_records': medicalRecords,
  //     };
  //   } else {
  //     return null;
  //   }
  // }

  Future<Map<String, dynamic>?> loginUserWithDetails(
      String username, String password) async {
    String dbPath = join(await getDatabasesPath(), 'patients.db'); // เพิ่ม path
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      Map<String, dynamic> user = result.first;
      int userId = user['id'];

      List<Map<String, dynamic>> patients = await db.query(
        patientTable,
        where: 'id = ?',
        whereArgs: [userId],
      );

      List<Map<String, dynamic>> medicalRecords = await db.query(
        medicalRecordTable,
        where: 'patientId = ?',
        whereArgs: [userId],
      );

      return {
        'db_path': dbPath, // เพิ่ม path เข้าไปในข้อมูลที่ return
        'user': user,
        'patients': patients,
        'medical_records': medicalRecords,
      };
    } else {
      return null;
    }
  }
}
