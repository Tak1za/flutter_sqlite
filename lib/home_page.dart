import 'package:flutter/material.dart';
import 'package:flutter_sqlite/add_note_page.dart';
import 'package:flutter_sqlite/edit_note_page.dart';
import 'package:flutter_sqlite/models/note.dart';
import 'package:flutter_sqlite/providers/note_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NoteProvider noteHandler;
  late Future<List<Note>> allNotes;

  Future addDummyNotes() async {
    Note note1 = Note(id: 1, title: "title 1", content: "content 1");
    Note note2 = Note(id: 2, title: "title 2", content: "content 2");
    Note note3 = Note(id: 3, title: "title 3", content: "content 3");
    Note note4 = Note(id: 4, title: "title 4", content: "content 4");

    List<Note> dummyNotes = [
      note1,
      note2,
      note3,
      note4,
    ];
    for (var element in dummyNotes) {
      await noteHandler.addNote(element);
    }
  }

  @override
  void initState() {
    super.initState();
    noteHandler = NoteProvider();
    allNotes = noteHandler.getNotes();
    noteHandler.init().whenComplete(() async {
      await addDummyNotes();
      allNotes = noteHandler.getNotes();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          GestureDetector(
            child: const Icon(Icons.add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNotePage(),
                ),
              ).then((value) => {
                    setState(() {
                      allNotes = noteHandler.getNotes();
                    })
                  });
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: allNotes,
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(snapshot.data![index].title.toString()),
                    subtitle: Text(snapshot.data![index].content.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditeNotePage(
                                          note: snapshot.data![index],
                                        ))).then((value) => {
                                  setState(() {
                                    allNotes = noteHandler.getNotes();
                                  })
                                });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.teal,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteFormDialog(
                                context, snapshot.data![index].id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  _deleteFormDialog(BuildContext context, noteId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are You Sure to Delete',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  await noteHandler.deleteNote(noteId);
                  setState(() {
                    allNotes = noteHandler.getNotes();
                    Navigator.pop(context);
                  });
                },
                child: const Text('Delete'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )
            ],
          );
        });
  }
}
