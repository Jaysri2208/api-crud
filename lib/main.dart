import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";
  String responseMessage = '';

  final TextEditingController idController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  Future<void> getData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        responseMessage = response.body;
      });
    } else {
      setState(() {
        responseMessage = 'Failed to load data';
      });
    }
  }

  Future<void> postData() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": titleController.text,
        "body": bodyController.text,
        "userId": 1
      }),
    );
    if (response.statusCode == 201) {
      setState(() {
        responseMessage = response.body;
      });
    } else {
      setState(() {
        responseMessage = 'Failed to post data';
      });
    }
  }

  Future<void> updateData() async {
    final response = await http.put(
      Uri.parse('$apiUrl/${idController.text}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": int.tryParse(idController.text) ?? 0,
        "title": titleController.text,
        "body": bodyController.text,
        "userId": 1
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        responseMessage = response.body;
      });
    } else {
      setState(() {
        responseMessage = 'Failed to update data';
      });
    }
  }

  Future<void> deleteData() async {
    final response = await http.delete(Uri.parse('$apiUrl/${idController.text}'));
    if (response.statusCode == 200) {
      setState(() {
        responseMessage = 'Deleted successfully';
      });
    } else {
      setState(() {
        responseMessage = 'Failed to delete data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter HTTP Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            ElevatedButton(
              onPressed: getData,
              child: Text('GET Data'),
            ),
            ElevatedButton(
              onPressed: postData,
              child: Text('POST Data'),
            ),
            ElevatedButton(
              onPressed: updateData,
              child: Text('PUT Data'),
            ),
            ElevatedButton(
              onPressed: deleteData,
              child: Text('DELETE Data'),
            ),
            SizedBox(height: 20),
            Text('Response:'),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(responseMessage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
