import 'package:db_tutorial/note_database.dart';
import 'package:flutter/material.dart';

import 'note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // notes db
  final noteDatabase = NoteDatabase();

  // text controller
  final noteController = TextEditingController();

  // create new note
  void _addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Note'),
        content: TextField(
          controller: noteController,
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text('cancel'),
          ),

          // save button
          TextButton(
            onPressed: () {
              final newNote = Note(content: noteController.text);
              noteDatabase.createNote(newNote);

              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text('save'),
          ),
        ],
      ),
    );
  }

  // update a note
  void _updateNote(Note note) {
    noteController.text = note.content;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: noteController,
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text('cancel'),
          ),

          // save button
          TextButton(
            onPressed: () {
              noteDatabase.updateNote(note, noteController.text);

              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text('save'),
          ),
        ],
      ),
    );
  }

  // delete a note
  void _deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text(note.content),
        actions: [
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('cancel'),
          ),

          // save button
          TextButton(
            onPressed: () {
              noteDatabase.deleteNote(note);

              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text('delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: noteDatabase.stream,
        builder: (context, snapshot) {
          // loading
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          // loaded
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.content),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _updateNote(note),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => _deleteNote(note),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
