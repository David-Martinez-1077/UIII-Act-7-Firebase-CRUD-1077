import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';

class EditCurso extends StatefulWidget {
  const EditCurso({super.key});

  @override
  State<EditCurso> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCurso> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _instructorIdController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late String _uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    // Inicializar controladores con los valores actuales
    _titleController = TextEditingController(text: arguments['title'] ?? '');
    _descriptionController = TextEditingController(
      text: arguments['description'] ?? '',
    );
    _instructorIdController = TextEditingController(
      text: arguments['instructor_id'] ?? '',
    );
    _priceController = TextEditingController(
      text: arguments['price']?.toString() ?? '0.0',
    );
    _categoryController = TextEditingController(
      text: arguments['category'] ?? '',
    );
    _uid = arguments['uid'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Editar Curso",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título del curso',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _instructorIdController,
                  decoration: InputDecoration(
                    labelText: 'ID del Instructor',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await updateCourse(
                        _uid,
                        _titleController.text,
                        _descriptionController.text,
                        _instructorIdController.text,
                        double.parse(_priceController.text),
                        _categoryController.text,
                      ).then((_) {
                        Navigator.pop(context);
                      });
                    }
                  },

                  child: const Text(
                    'Actualizar Curso',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructorIdController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}
