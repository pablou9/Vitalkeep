import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() {
  runApp(const MyApp());
  // Llamar a la inicialización del servicio en segundo plano al inicio de la app
  _initializeBackgroundService();
}

void _initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  // Configuración del servicio en segundo plano para Android e iOS
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart:
          onStart, // La función onStart debe aceptar un parámetro ServiceInstance
      isForegroundMode: true, // Ejecutar el servicio en primer plano
      initialNotificationContent: 'Preparing', // Notificación inicial
      initialNotificationTitle: 'Background Service',
    ),
    iosConfiguration: IosConfiguration(
      onForeground:
          onStart, // Configuración para iOS (cuando la app está en primer plano)
      onBackground:
          onBackground, // Función que se ejecuta cuando la app está en segundo plano en iOS
    ),
  );

  // Iniciar el servicio en segundo plano
  service.invoke('startService');
}

// Función que se ejecuta cuando el servicio comienza
void onStart(ServiceInstance service) {
  // Aquí puedes interactuar con el servicio en segundo plano

  // Enviar datos al servicio
  service.sendData({"message": "Service started"});

  // Escuchar los datos recibidos desde el servicio
  service.onDataReceived.listen((event) {
    print("Data received in background: $event");
  });

  // Si necesitas hacer algo al iniciar el servicio, lo puedes colocar aquí
  print("Background service started.");
}

extension on ServiceInstance {
  get onDataReceived => null;

  void sendData(Map<String, String> map) {}
}

// Función que se ejecuta cuando la app se pone en segundo plano (solo en iOS)
Future<bool> onBackground(ServiceInstance service) async {
  print("App moved to background on iOS");
  return Future.value(true); // Debe devolver un Future<bool>
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter',
                style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
}
