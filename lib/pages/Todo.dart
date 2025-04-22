import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  String Activity_Title = '';

  createTodos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Activities').doc(Activity_Title);

    Map<String, String> todos = {'Activity Title': Activity_Title};

    documentReference.set(todos).whenComplete(() {
      print('$Activity_Title created');
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Activities').doc(item);

    documentReference.delete().whenComplete(() {
      print('Deleted');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text('TO-DO LIST'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: (() => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Todo'),
                  content: Container(
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (String inputItem) {
                            Activity_Title = inputItem;
                          },
                        ),
                        TextField(
                          onChanged: (String inputItem) {
                            Activity_Title = inputItem;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          createTodos();

                          Navigator.of(context).pop();
                        },
                        child: Text('Add')),
                  ],
                );
              })),
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Activities').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];
                    return Dismissible(
                      onDismissed: (direction) {
                        deleteTodos(documentSnapshot['Activity Title']);
                      },
                      key: Key(documentSnapshot['Activity Title']),
                      child: Card(
                        elevation: 16,
                        margin: EdgeInsets.all(6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(documentSnapshot['Activity Title']),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  deleteTodos(
                                      documentSnapshot['Activity Title']);
                                });
                                ;
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ),
                      ),
                    );
                  });
            }));
  }
}
