import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart'
    show deleteCourse, getCourses;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    setState(() {
      _coursesFuture = getCourses().catchError((error) {
        // Manejo explícito de errores
        debugPrint("Error cargando cursos: $error");
        return <Map>[]; // Retorna lista vacía en caso de error
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gestión de Cursos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<List>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          // Manejo seguro de estados
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final courses = snapshot.data ?? [];
          if (courses.isEmpty) {
            return const Center(child: Text('No hay cursos disponibles'));
          }

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Dismissible(
                key: ValueKey(course['uid']), // Mejor uso de Key
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text("¿Eliminar ${course['title']}?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                onDismissed: (direction) async {
                  try {
                    await deleteCourse(course['uid']);
                    // Actualización optimizada
                    if (mounted) {
                      _loadCourses();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al eliminar: ${e.toString()}'),
                        ),
                      );
                    }
                  }
                },
                background: Container(
                  color: Colors.red.withOpacity(0.7),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(course['title']),
                  subtitle: Text(
                    "${course['category']} - \$${course['price']}",
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      "/edit",
                      arguments: course,
                    );
                    if (mounted) _loadCourses();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          if (mounted) _loadCourses();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
