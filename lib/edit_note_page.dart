import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/note.dart';
import 'package:flutter_sqlite/providers/note_provider.dart';

class EditeNotePage extends StatefulWidget {
  final Note note;
  const EditeNotePage({super.key, required this.note});

  @override
  State<EditeNotePage> createState() => _EditeNotePageState();
}

class _EditeNotePageState extends State<EditeNotePage> {
  final _noteTitleController = TextEditingController();
  final _noteContentController = TextEditingController();
  final _noteHandler = NoteProvider();

  @override
  void initState() {
    setState(() {
      _noteTitleController.text = widget.note.title ?? '';
      _noteContentController.text = widget.note.content ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Note',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _noteTitleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Title',
                    labelText: 'Title',
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _noteContentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Content',
                    labelText: 'Content',
                  )),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () async {
                        var note = Note(
                          id: widget.note.id,
                          title: _noteTitleController.text,
                          content: _noteContentController.text,
                        );
                        var result = await _noteHandler.updateNote(
                          note,
                        );
                        setState(() {
                          Navigator.pop(context, result);
                        });
                      },
                      child: const Text('Save Note')),
                  const SizedBox(
                    width: 10.0,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
