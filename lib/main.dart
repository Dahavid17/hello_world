import 'package:flutter/material.dart';

// Perfil de usuario com foto, nome, email, numero, endereço e avaliação

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PerfilUsuario(),
    );
  }
}

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  int avaliacao = 0;

  Widget buildStar(int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          avaliacao = index;
        });
      },
      icon: Icon(
        index <= avaliacao ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,

      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/images/Design sem nome (4).png',
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Nome do Usuário',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 5),

              const Text(
                'Desenvolvedor JR',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 10),

              // 📧 Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.email, size: 18),
                  SizedBox(width: 5),
                  Text('Email do Usuário'),
                ],
              ),

              const SizedBox(height: 5),

              // 📞 Telefone
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.phone, size: 18),
                  SizedBox(width: 5),
                  Text('Número do Usuário'),
                ],
              ),

              const SizedBox(height: 5),

              // 📍 Endereço
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on, size: 18),
                  SizedBox(width: 5),
                  Text('Endereço do Usuário'),
                ],
              ),

              const SizedBox(height: 15),

              const Text('Avaliação do Usuário'),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildStar(1),
                  buildStar(2),
                  buildStar(3),
                  buildStar(4),
                  buildStar(5),
                ],
              ),

              const SizedBox(height: 15),

              // 🔘 Botão dentro do container
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print('Editar perfil clicado');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Editar Perfil',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
