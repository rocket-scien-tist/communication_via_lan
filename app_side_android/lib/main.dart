import 'package:communication_between_apps_without_internet/client.dart';
import 'package:communication_between_apps_without_internet/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scafoldKey = GlobalKey<ScaffoldState>();
  ClientController clientController = Get.put(ClientController());
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientController>(
      builder: (controller) {
        return Scaffold(
          key: _scafoldKey,
          appBar: AppBar(
            title: const Text('Server'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    children: [
                      if (controller.clientModel == null ||
                          !controller.clientModel!.isConnected)
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await controller.clientModel!.connect();
                                final info = await deviceInfo.androidInfo;
                                controller.sendMessage(
                                    "Connected to ${info.brand} ${info.device}");
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (controller.address == null)
                                        const Text('No Device found')
                                      else
                                        Column(
                                          children: [
                                            const Text(
                                              "Desktop",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              controller.address?.ip ??
                                                  'address is null',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                            'Connected to ${controller.clientModel!.hostName}'),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.lightBlue),
                              ),
                            ),
                            const SizedBox(width: 20),
                            TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue[400])),
                              onPressed: controller.getIpAddress,
                              icon: const Icon(Icons.search),
                              label: const Text(
                                'Search',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (controller.clientModel == null)
                        const Text('No Server Found')
                      else
                        TextButton(
                            onPressed: () async {
                              debugPrint(
                                  'is connected is: ${controller.clientModel!.isConnected}');
                              final info = await deviceInfo.androidInfo;
                              if (controller.clientModel!.isConnected) {
                                debugPrint('Disconnecting...');
                                controller.clientModel!.disconnect(info);
                              } else {
                                controller.clientModel!.connect();
                              }
                              setState(() {});
                              controller.update();
                            },
                            child: Text(controller.clientModel!.isConnected
                                ? 'Disconnnect from server'
                                : 'Connect to server')),
                      SizedBox(height: 20),
                      const Divider(
                          height: 30, thickness: 1, color: Colors.black12),
                      Expanded(
                        child: ListView(
                          children:
                              controller.logs.map((e) => Text(e)).toList(),
                        ),
                      ),
                      Container(
                        color: Colors.grey[100],
                        height: 80,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Send Message :',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: textController,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  MaterialButton(
                                    onPressed: () {
                                      controller
                                          .sendMessage(textController.text);
                                      textController.clear();
                                      setState(() {});
                                    },
                                    minWidth: 30,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: const Icon(Icons.send),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
