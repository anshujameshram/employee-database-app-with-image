import 'dart:io';

import 'package:emp_image_db/models/employee.dart';
import 'package:emp_image_db/services/emp_operations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

  File imagefile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Employee')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: imagefile == null
                  ? Center(
                      child: Text('select image'),
                    )
                  : Image.file(
                      imagefile,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 8),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                captureImage();
              },
            ),
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: postController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Post',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: salaryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Salary',
              ),
            ),
            SizedBox(height: 8),
            RaisedButton(
              child: Text('add employee'),
              onPressed: () {
                addEmployeeToTable();
              },
            )
          ],
        ),
      ),
    );
  }
  void captureImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagefile = File(pickedFile.path);
      });
    }
  }

  void addEmployeeToTable() async {
    String n = nameController.text;
    String p = postController.text;
    int s = int.parse(salaryController.text);

    String imagePath;

   if(imagefile!=null) {
      imagePath = imagefile.path;
    }

    Employee e = Employee(name: n, post: p, salary: s, image: imagePath);

    await EmpOperations.instance.addEmployee(e);

    Navigator.pop(context);
  }

  
}
