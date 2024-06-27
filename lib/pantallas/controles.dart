import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:gato/config/config.dart';
import 'package:gato/widget/celda.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gato/config/config.dart';
import 'package:gato/widget/celda.dart';

class Control extends StatefulWidget {
  final Function(int, int, int) actualizarContadores;
  const Control({required this.actualizarContadores, Key? key}) : super(key: key);

  @override
  ControlState createState() => ControlState();
}

class ControlState extends State<Control> {
  estados inicial = estados.cruz;
  int contador = 0;
  int victoriasX = 0;
  int victoriasO = 0;
  int empates = 0;
  List<estados> tablero = List.filled(9, estados.vacio);

  void reiniciarTablero() {
    setState(() {
      inicial = estados.cruz;
      victoriasX = 0;
      victoriasO = 0;
      empates = 0;
      contador = 0;
      tablero = List.filled(9, estados.vacio);
    });
  }

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;

    return SizedBox(
      width: ancho,
      height: ancho,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Celda(inicial: tablero[0], alto: ancho / 3, ancho: ancho / 3, press: () => pressi(0)),
                Celda(inicial: tablero[1], alto: ancho / 3, ancho: ancho / 3, press: () => pressi(1)),
                Celda(inicial: tablero[2], alto: ancho / 3, ancho: ancho / 3, press: () => pressi(2))
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Celda(inicial: tablero[3], alto: ancho / 3, ancho: ancho / 3, press: () => pressi(3)),
                Celda(inicial: tablero[4], alto: ancho / 3, ancho: ancho / 3, press: () => pressi(4)),
                Celda(inicial: tablero[5], alto: ancho / 3, ancho: ancho / 3, press: () => pressi(5))
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Celda(inicial: tablero[6], alto: ancho / 3, ancho: ancho / 3, press: () => pressi(6)),
                Celda(inicial: tablero[7], alto: ancho / 3, ancho: ancho / 3, press: () => pressi(7)),
                Celda(inicial: tablero[8], alto: ancho / 3, ancho: ancho / 3, press: () => pressi(8))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void pressi(int index) {
    debugPrint("Presionado");
    if (tablero[index] == estados.vacio) {
      setState(() {
        tablero[index] = inicial;
        inicial = inicial == estados.cruz ? estados.circulo : estados.cruz;
        contador++;
      });
      if (contador >= 5) {
        if (checkGanador()) {
          mostrarGanador();
        } else if (contador == 9) {
          mostrarEmpate();
        }
      }
    }
  }

  bool checkGanador() {
    for (int i = 0; i < 3; i++) {
      // Verificar filas
      if (tablero[i * 3] != estados.vacio &&
          tablero[i * 3] == tablero[i * 3 + 1] &&
          tablero[i * 3 + 1] == tablero[i * 3 + 2]) {
        resultados[tablero[i * 3]] = true;
        return true;
      }
      // Verificar columnas
      if (tablero[i] != estados.vacio &&
          tablero[i] == tablero[i + 3] &&
          tablero[i] == tablero[i + 6]) {
        resultados[tablero[i]] = true;
        return true;
      }
    }
    // Verificar diagonales
    if (tablero[0] != estados.vacio &&
        tablero[0] == tablero[4] &&
        tablero[0] == tablero[8]) {
      resultados[tablero[0]] = true;
      return true;
    }
    if (tablero[2] != estados.vacio &&
        tablero[2] == tablero[4] &&
        tablero[2] == tablero[6]) {
      resultados[tablero[2]] = true;
      return true;
    }
    return false;
  }

  void mostrarGanador() {
    String ganador = resultados[estados.cruz] == true ? "X" : "O";
    if (ganador == "X") {
      victoriasX++;
    } else {
      victoriasO++;
    }
    widget.actualizarContadores(victoriasX, victoriasO, empates);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Tenemos un ganador!"),
          content: Text("El ganador es: $ganador"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  reiniciarJuego();
                });
                Navigator.of(context).pop();
              },
              child: Text("¿Continuar?"),
            ),
            TextButton(
              onPressed: () {
                salirApp();
              },
              child: Text("Salir"),
            ),
          ],
        );
      },
    );
  }

  void mostrarEmpate() {
    empates++;
    widget.actualizarContadores(victoriasX, victoriasO, empates);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Empate!"),
          content: Text("El juego ha terminado en empate."),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  reiniciarJuego();
                });
                Navigator.of(context).pop();
              },
              child: Text("¿Continuar?"),
            ),
            TextButton(
              onPressed: () {
                salirApp();
              },
              child: Text("Salir"),
            ),
          ],
        );
      },
    );
  }



  void salirApp() {
    SystemNavigator.pop();
  }
  void reiniciarJuego() {
    setState(() {
      inicial = estados.cruz;
      contador = 0;
      tablero = List.filled(9, estados.vacio);
      resultados = {
        estados.cruz: false,
        estados.circulo: false,
      };
    });
  }
}