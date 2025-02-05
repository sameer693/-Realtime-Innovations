import '../core/database_helper.dart';
import '../model/employee.dart';


class EmployeeRepository {
  final DBHelper _dbHelper = DBHelper.instance;

  Future<int> addEmployee(Employee employee) async {
    final db = await _dbHelper.database;
    return await db.insert('employees', employee.toJson());
  }

  Future<List<Employee>> fetchEmployees() async {
    final db = await _dbHelper.database;
    final result = await db.query('employees');
    return result.map((map) => Employee.fromJson(map)).toList();
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await _dbHelper.database;
    return await db.update(
      'employees',
      employee.toJson(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}