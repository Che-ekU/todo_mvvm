import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_mvvm/app_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(primaryColor: Colors.blueGrey),
        home: TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<TodoViewModel>(
                builder: (context, viewModel, child) {
                  return ListView.builder(
                    itemCount: viewModel.todos.length,
                    itemBuilder: (context, index) {
                      final todo = viewModel.todos[index];
                      return ListTile(
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration:
                                todo.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEditTodoDialog(
                                    context, viewModel, index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => viewModel.deleteTodo(index),
                              ),
                            ],
                          ),
                        ),
                        onTap: () => viewModel.toggleTodoState(index),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(labelText: 'Add Todo'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final title = _textEditingController.text;
                      if (title.isNotEmpty) {
                        Provider.of<TodoViewModel>(context, listen: false)
                            .addTodo(title);
                        _textEditingController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTodoDialog(
      BuildContext context, TodoViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController editTextController =
            TextEditingController(text: viewModel.todos[index].title);

        return AlertDialog(
          title: const Text('Edit Todo'),
          content: TextField(
            controller: editTextController,
            decoration: const InputDecoration(labelText: 'New Title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                viewModel.editTodo(index, editTextController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
