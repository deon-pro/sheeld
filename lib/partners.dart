import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  // Save accountability partner to Firestore
  Future<void> saveAccountabilityPartner() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must be logged in to save an accountability partner.', textAlign: TextAlign.center,),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a name and email address', textAlign: TextAlign.center,),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }
    if (!emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address', textAlign: TextAlign.center,),
          backgroundColor: Colors.blue,
        ),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('partners')
          .add({
            'name': nameController.text,
            'email': emailController.text,
            'userId': user.uid,
          });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Accountability partner saved', textAlign: TextAlign.center,),
          backgroundColor: Colors.blue,
        ),
      );
      // clear the text fields after successful save
      nameController.clear();
      emailController.clear();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving accountability partner,', textAlign: TextAlign.center,),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Partners',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
    color: Colors.white,
  ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
  controller: nameController,
  textAlign: TextAlign.center,
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.blue),
  decoration: InputDecoration(
    labelText: 'Accountability Partner Name',
    labelStyle: TextStyle(color: Colors.black),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  },
),
SizedBox(height: 25.0),
TextFormField(
  controller: emailController,
  textAlign: TextAlign.center,
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.blue),
  decoration: InputDecoration(
    labelText: 'Accountability Partner Email',
    labelStyle: TextStyle(color: Colors.black),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    return null;
  },
),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: saveAccountabilityPartner,
                       style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                      child: Text('Save'),
                      
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
