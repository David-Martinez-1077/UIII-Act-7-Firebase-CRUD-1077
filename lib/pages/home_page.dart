import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart'
    show deleteCourse, getCourses;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestión de Cursos", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),

      body: FutureBuilder(
        future: getCourses(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direction) async {
                    await deleteCourse(snapshot.data?[index]['uid']);
                    snapshot.data?.removeAt(index);
                  },
                  confirmDismiss: (direction) async {
                    bool result = false;
                    result = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "¿Eliminar curso ${snapshot.data?[index]['title']}?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("Cancelar", style: TextStyle(color: Colors.red))),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Eliminar", style: TextStyle(color: Colors.blue))),
                          ],
                        );
                      },
                    );
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  direction: DismissDirection.endToStart,
                  key: Key(snapshot.data?[index]['uid']),
                  child: ListTile(
                    title: Text(snapshot.data?[index]['title']),
                    subtitle: Text(
                      "${snapshot.data?[index]['category']} - \$${snapshot.data?[index]['price']}",
                    ),
                    onTap: (() async {
                      await Navigator.pushNamed(
                        context,
                        "/edit",
                        arguments: snapshot.data?[index],
                      );
                      setState(() {});
                    }),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los cursos'));
          }
          return const Center(child: CircularProgressIndicator());
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}