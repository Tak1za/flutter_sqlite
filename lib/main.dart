import 'package:flutter/material.dart';
import 'package:flutter_sqlite/home_page.dart';
import 'package:flutter_sqlite/models/note.dart';
import 'package:flutter_sqlite/providers/note_provider.dart';

void main() async {
  // runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  var noteDB = NoteProvider();

  final note = Note(
    1,
    'Title 1',
    'Note 1',
  );

  await noteDB.addNote(note);
  var notes = await noteDB.getNotes();
  print(notes[0].title); //Title 1

  final newNote = Note(
    note.id,
    'Title 1 changed',
    note.content,
  );

  await noteDB.updateNote(note.id, newNote);
  var updatedNotes = await noteDB.getNotes();
  print(updatedNotes[0].title); //Title 1 changed

  await noteDB.deleteNote(note.id);
  print(await noteDB.getNotes()); //[]
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
