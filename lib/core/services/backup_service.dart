import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BackupService {
  static Future<String?> exportDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final dbFile = File(join(dbPath, 'mywork_ledger.db'));
      
      if (await dbFile.exists()) {
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final backupPath = join(directory.path, 'mywork_backup_ledger.db');
          await dbFile.copy(backupPath);
          return backupPath;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<bool> importDatabase(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final dbFile = File(join(dbPath, 'mywork_ledger.db'));
      
      final backupFile = File(filePath);
      if (await backupFile.exists()) {
        await backupFile.copy(dbFile.path);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
