import 'package:emp_image_db/models/employee.dart';
import 'package:emp_image_db/services/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class EmpOperations {
  EmpOperations._();

  static final EmpOperations instance = EmpOperations._();

  Future<int> addEmployee(Employee employee) async {
    Database db = await DBHelper.instance.database;
    return await db.insert('employees', employee.toMap());
  }

  Future<int> deleteEmployee(Employee employee) async {
    Database db = await DBHelper.instance.database;
    return await db
        .delete('employees', where: 'id=?', whereArgs: [employee.id]);
  }

  Future<int> editEmployee(Employee employee) async {
    Database db = await DBHelper.instance.database;
    return await db.update('employees', employee.toMap(),
        where: 'id=?', whereArgs: [employee.id]);
  }

  Future<List<Employee>> getAllEmployees() async{
    Database db=await DBHelper.instance.database;
    List<Map> maps=await db.query('employees');
    
    List<Employee> employee=[];

    for(int i=0;i<maps.length;i++)
    {
      employee.add(Employee.fromMap(maps[i]));
    }
    return employee;
  }
}
