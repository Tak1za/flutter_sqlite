import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/note.dart';
import 'package:flutter_sqlite/providers/note_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> allNotes = [];

  @override
  void initState() {
    var noteDB = NoteProvider();
    setState(() async {
      allNotes = await noteDB.getNotes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: allNotes
              .map(
                (e) => Text(e.title!),
              )
              .toList(),
        ),
      ),
    );
  }
}
