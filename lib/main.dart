import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Distância até minha casa',
      home: const LocalizacaoPage(),
    );
  }
}

class LocalizacaoPage extends StatefulWidget {
  const LocalizacaoPage({super.key});

  @override
  State<LocalizacaoPage> createState() => _LocalizacaoPageState();
}

class _LocalizacaoPageState extends State<LocalizacaoPage> {
  // 1. Substitua estas coordenadas pelas da sua casa real
  final double casaLatitude = -21.3568364608751;
  final double casaLongitude = -46.93302746441793;

  String resultadoTexto = 'Clique no botão para calcular a distância.';

  Future<void> calcularDistancia() async {
    // Checagem e solicitação de permissões
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      return;
    }

    // Obtém a posição atual do GPS (Escola)
    Position posicaoAtual = await Geolocator.getCurrentPosition();

    // 2. Calcula a distância entre a localização atual e a casa (em metros)
    double distanciaEmMetros = Geolocator.distanceBetween(
      posicaoAtual.latitude,
      posicaoAtual.longitude,
      casaLatitude,
      casaLongitude,
    );

    // 3. Formata e atualiza a mensagem na tela
    setState(() {
      if (distanciaEmMetros >= 1000) {
        double km = distanciaEmMetros / 1000;
        resultadoTexto = 'Distância: ${km.toStringAsFixed(2)} km';
      } else {
        resultadoTexto = 'Distância: ${distanciaEmMetros.toStringAsFixed(0)} metros';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distância até minha casa'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ícone da casa
              const Icon(
                Icons.home,
                size: 80,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              // Título principal
              const Text(
                'Distância entre a escola e minha casa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Exibição da instrução ou do resultado
              Text(
                resultadoTexto,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 30),

              // Botão para disparar a ação
              ElevatedButton(
                onPressed: calcularDistancia,
                child: const Text('Calcular distância'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}