import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Exemplo Row"),
        ),
        body: Center( // <- tirei o const aqui
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home,size: 20),

              SizedBox(width: 40), // <- adicionei um SizedBox para dar um espaçamento entre os itens

              Icon(Icons.favorite,size: 20),

              SizedBox(width: 40), // <- adicionei um SizedBox para dar um espaçamento entre os itens

              Icon(Icons.settings,size: 20),
            ],
          ),
        ),
      ),
    );
  }
}