import 'dart:io';

import 'package:flutter_sqlite/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class NoteProvider {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, "notes.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          """CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)""");
    });
  }

  // CREATE
  Future<int> addNote(Note note) async {
    final db = await init();

    return db.insert("notes", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // READ
  Future<List<Note>> getNotes() async {
    final db = await init();
    final notes = await db.query("notes");

    return List.generate(
      notes.length,
      (index) => Note(
        id: notes[index]['id'] as int,
        title: notes[index]['title'] as String,
        content: notes[index]['content'] as String,
      ),
    );
  }

  // UPDATE
  Future<int> updateNote(Note note) async {
    final db = await init();

    return await db.update(
      "notes",
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  // DELETE
  Future<int> deleteNote(int id) async {
    final db = await init();

    return await db.delete(
      "notes",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
