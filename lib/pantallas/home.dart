import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gato/pantallas/controles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int victoriasX = 0;
  int victoriasO = 0;
  int empates = 0;

  final GlobalKey<ControlState> _controlKey = GlobalKey<ControlState>();

  void actualizarContadores(int x, int o, int e) {
    setState(() {
      victoriasX = x;
      victoriasO = o;
      empates = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('Tres en Raya'),
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: "nuevo_juego",
                  child: Text("Nuevo Juego"),
                ),
                const PopupMenuItem(
                  value: "reiniciar",
                  child: Text("Reiniciar"),
                ),
                const PopupMenuItem(
                  value: "salir",
                  child: Text("Salir"),
                ),
              ],
              onSelected: (value) {
                confirmarAccion(value);
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Victorias X: $victoriasX'),
              Text('Victorias O: $victoriasO'),
              Text('Empates: $empates'),
              Stack(
                children: [
                  Image.asset("imagenes/board.png"),
                  Control(key: _controlKey, actualizarContadores: actualizarContadores),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  confirmarAccion("reiniciar");
                },
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  confirmarAccion("salir");
                },
                color: Colors.white,
              ),
            ],
          ),
        ));
  }

  void confirmarAccion(String accion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmación"),
          content: Text("¿Está seguro que desea $accion el juego?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo de confirmación
                if (accion == "nuevo_juego") {
                  nuevoJuego();
                } else if (accion == "reiniciar") {
                  reiniciarelJuego();
                } else if (accion == "salir") {
                  salirApp();
                }
              },
              child: const Text("Confirmar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo de confirmación
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void nuevoJuego() {
    setState(() {
      victoriasX = 0;
      victoriasO = 0;
      empates = 0;
    });
    _controlKey.currentState?.reiniciarJuego();
  }

  void reiniciarelJuego() {
    _controlKey.currentState?.reiniciarTablero();
  }

  void salirApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmación"),
          content: const Text("¿Está seguro que desea salir de la aplicación?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo de confirmación
                SystemNavigator.pop(); // Salir de la aplicación
              },
              child: const Text("Confirmar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo de confirmación
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}
