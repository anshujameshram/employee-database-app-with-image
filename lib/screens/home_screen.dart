import 'dart:io';
import 'package:emp_image_db/models/employee.dart';
import 'package:emp_image_db/screens/add_employee.dart';
import 'package:emp_image_db/screens/edit_employee.dart';
import 'package:emp_image_db/services/emp_operations.dart';
import 'package:emp_image_db/services/jump_to_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Employee> employeeList = [];

  void getEmployees() async {
    List<Employee> employee = await EmpOperations.instance.getAllEmployees();

    setState(() {
      employeeList = employee;
    });
  }

  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Demo'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await JumpToPage.push(context, AddEmployee());
          getEmployees();
        },
      ),
      body: employeeList.length == 0
          ? NoData()
          : ShowData(
              employeeList: employeeList,
            ),
    );
  }
}

class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('No Data to display'),
        CircularProgressIndicator(),
      ],
    ));
  }
}

class ShowData extends StatefulWidget {
  List<Employee> employeeList;

  ShowData({this.employeeList});

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.employeeList.length,
      itemBuilder: (BuildContext context, int index) {
        Employee emp = widget.employeeList[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            isThreeLine: true,
            leading: emp.image == null ? getText(emp) : getImage(emp),
            title: Text(emp.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(emp.post),
                Text('\u20B9${emp.salary.toString()}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await EmpOperations.instance.deleteEmployee(emp);
                List<Employee> temp =
                    await EmpOperations.instance.getAllEmployees();

                setState(() {
                  widget.employeeList = temp;
                });
              },
            ),
            onTap: () async {
              await JumpToPage.push(context, EditEmployee(emp: emp));

              List<Employee> temp =
                  await EmpOperations.instance.getAllEmployees();

              setState(() {
                widget.employeeList = temp;
              });
            },
          ),
        );
      },
    );
  }

  Widget getText(Employee emp) {
    return CircleAvatar(
      child: Text(emp.name[0]),
    );
  }

  Widget getImage(Employee employee) {
    return CircleAvatar(
      backgroundImage: FileImage(File(employee.image)),
    );
  }
}
