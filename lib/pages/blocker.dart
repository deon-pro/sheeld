import 'package:flutter/material.dart';
class MyBlocker extends StatefulWidget {
  const MyBlocker({super.key});

  @override
  State<MyBlocker> createState() => _MyBlockerState();
}

class _MyBlockerState extends State<MyBlocker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: Icon(Icons.block_outlined),
  leadingWidth: 100, 
        title: Text("BLOCK ILLEGAL SITES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        
        

      ),
    );
  }
}