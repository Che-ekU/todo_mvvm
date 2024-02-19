import 'package:flutter/material.dart';
import 'package:todo_mvvm/models.dart';

class TodoViewModel extends ChangeNotifier {
  List<Todo> todos = [];

  void addTodo(String title) {
    todos.add(Todo(title: title));
    notifyListeners();
  }

  void editTodo(int index, String newTitle) {
    todos[index].title = newTitle;
    notifyListeners();
  }

  void deleteTodo(int index) {
    todos.removeAt(index);
    notifyListeners();
  }

  void toggleTodoState(int index) {
    todos[index].isDone = !todos[index].isDone;
    notifyListeners();
  }
}
