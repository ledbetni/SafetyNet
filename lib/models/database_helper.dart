import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,
        version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const contactIntegerType = 'INTEGER';

    await db.execute('''
  CREATE TABLE contacts (
    id $idType,
    name $textType,
    number $textType
  )
    ''');

    await db.execute('''
CREATE TABLE messages (
  id $idType,
  content $textType,
  timestamp $textType,
  senderID $integerType,
  receiverID $integerType,
  FOREIGN KEY (senderID) REFERENCES contacts (id),
  FOREIGN KEY (receiverID) REFERENCES contacts (id)
)
''');

    await db.execute('''
    CREATE TABLE savedMessageList (
    id $idType,
    content $textType,
    contactID $contactIntegerType,
    FOREIGN KEY (contactID) REFERENCES contacts (id)
  )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER';
    if (oldVersion < 2) {
      await db.execute('''
    CREATE TABLE savedMessageList (
    id $idType,
    content $textType,
    contactID $integerType,
    FOREIGN KEY (contactID) REFERENCES contacts (id)
  )
    ''');
    }
  }

  Future<int> addContact(String name, String number) async {
    final db = await instance.database;
    final id = await db.insert('contacts', {'name': name, 'number': number});
    return id;
  }

  Future<int> addMessage(
      String content, String timestamp, int senderId, int receiverId) async {
    final db = await instance.database;
    final id = await db.insert('messages', {
      'content': content,
      'timestamp': timestamp,
      'senderID': senderId,
      'receiverID': receiverId
    });
    return id;
  }

  Future<int> addSavedMessageList(String content, int? contactId) async {
    final db = await instance.database;
    final id = await db.insert(
        'savedMessageList', {'content': content, 'contactID': contactId});
    return id;
  }

  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete('contacts', where: 'id=?', whereArgs: [id]);
  }

  Future<int> deleteMessage(int id) async {
    final db = await instance.database;
    return await db.delete('messages', where: 'id=?', whereArgs: [id]);
  }

  Future<int> deleteSavedMessageList(int id) async {
    final db = await instance.database;
    return await db.delete('savedMessageList', where: 'id=?', whereArgs: [id]);
  }

  Future<int> deleteAllMessagesForContact(int contactId) async {
    final db = await instance.database;
    final count = await db
        .delete('messages', where: 'receiverID=?', whereArgs: [contactId]);
    return count;
  }

  Future<int> updateSavedMessageContact(int messageId, int contactId) async {
    final db = await instance.database;
    return await db.update(
      'savedMessageList',
      {'contactID': contactId},
      where: 'id=?',
      whereArgs: [messageId],
    );
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await instance.database;
    return await db.query('contacts');
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await instance.database;
    return await db.query('messages');
  }

  Future<List<Map<String, dynamic>>> getSavedMessageList() async {
    final db = await instance.database;
    return await db.query('savedMessageList');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
