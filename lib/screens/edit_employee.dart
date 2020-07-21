import 'dart:io';
import 'package:emp_image_db/models/employee.dart';
import 'package:emp_image_db/services/emp_operations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditEmployee extends StatefulWidget {
  final Employee emp;

  EditEmployee({this.emp});

  @override
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  Employee employee;
  final TextEditingController nameController = TextEditingController();

  final TextEditingController postController = TextEditingController();

  final TextEditingController salaryController = TextEditingController();

  File imageFile;

  @override
  void initState() {
    super.initState();
    employee = widget.emp;

    nameController.text = widget.emp.name;
    postController.text = widget.emp.post;
    salaryController.text = widget.emp.salary.toString();

    if (employee.image != null) {
      imageFile = File(employee.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: imageFile == null
                  ? Center(
                      child: Text('select image'),
                    )
                  : Image.file(imageFile),
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
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Salary',
              ),
            ),
            SizedBox(height: 8),
            RaisedButton(
              child: Text('Edit employee'),
              onPressed: () {
                editEmployeeToTable();
              },
            )
          ],
        ),
      ),
    );
  }

  void editEmployeeToTable() async {
    String n = nameController.text;
    String p = postController.text;
    int s = int.parse(salaryController.text);

    String image;

    if (imageFile != null) {
      image = imageFile.path;
    }

    Employee e =
        Employee(id: employee.id, name: n, post: p, salary: s, image: image);

    await EmpOperations.instance.editEmployee(e);
    Navigator.pop(context);
  }

  void captureImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
