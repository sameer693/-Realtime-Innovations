import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/employee_repository.dart';
import '../model/employee.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepository _repository = EmployeeRepository();

  EmployeeCubit() : super(EmployeeInitial());

  Future<void> loadEmployees() async {
    emit(EmployeeLoading());
    final employees = await _repository.fetchEmployees();
    //if employees has end date, then they are previous employees else current employees
    final curEmployees = employees.where((emp) => emp.endDate == null).toList();
    final prevEmployees = employees.where((emp) => emp.endDate != null).toList();
    emit(EmployeeLoaded(curEmployees, prevEmployees));
  }

  Future<void> addEmployee(Employee employee) async {
    await _repository.addEmployee(employee);
    loadEmployees();
  }

  Future<void> updateEmployee(Employee employee) async {
    await _repository.updateEmployee(employee);
    loadEmployees();
  }

  Future<void> deleteEmployee(int id) async {
    await _repository.deleteEmployee(id);
    loadEmployees();
  }
}
