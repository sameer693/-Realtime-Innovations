part of 'employee_cubit.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> curEmployees;
  final List<Employee> prevEmployees;
  EmployeeLoaded(this.curEmployees,this.prevEmployees);
}
