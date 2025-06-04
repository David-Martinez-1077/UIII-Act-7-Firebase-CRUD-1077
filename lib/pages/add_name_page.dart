import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';

class AddNamePage extends StatefulWidget {
  const AddNamePage({super.key});

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}




class _AddNamePageState extends State<AddNamePage> {
  TextEditingController nameController = TextEditingController(text: "");
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir nombre", style: TextStyle(color: Colors.white ),),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
        children:  [
           TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Ingrese el nuevo nombre"
            ),
          ),

          SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: () async {
            
            await addPeople(nameController.text).then((value) {
              Navigator.pop(context);
            });
            
            
          }, child: const Text('Guardar', style: TextStyle(color: Color.fromARGB(255, 30, 63, 120)),)
          
          )


        ],
      ),
      ) 
    );
  }
}