import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:server_side_desktop/controller.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Server'),
      ),
      body: GetBuilder<ServerController>(
        init: ServerController(),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Server',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: controller.server!.running
                                    ? Colors.green[400]
                                    : Colors.red[400]),
                            child: Text(
                              controller.server!.running ? 'ON' : 'OFF',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      TextButton(
                          onPressed: () async {
                            await controller.startOrStopServer();
                          },
                          child: Text(controller.server!.running
                              ? 'Stop server'
                              : 'Start server')),
                      const Divider(
                        height: 30,
                        thickness: 1,
                      ),
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return Text(controller.serverLogs[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              itemCount: controller.serverLogs.length))
                    ],
                  ),
                ),
              ),
              Container(
                height: 80,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        decoration:
                            const InputDecoration(labelText: 'Enter Message'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          controller.messageController.clear();
                        },
                        icon: const Icon(Icons.clear)),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: controller.handleMessage,
                        icon: const Icon(Icons.send)),
                  ],
                ),
              )
            ],
          );
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
