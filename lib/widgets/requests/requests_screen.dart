import 'package:flutter/material.dart';

class RequestsScreenWidget extends StatefulWidget {
  static String routeName = "/requests_screen";

  const RequestsScreenWidget({Key? key}) : super(key: key);

  @override
  _RequestsScreenWidgetState createState() => _RequestsScreenWidgetState();
}

class _RequestsScreenWidgetState extends State<RequestsScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'As Driver'),
              Tab(text: 'As Rider'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Nested tabs for 'As Driver'
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Waiting for your response'),
                      Tab(text: 'Waiting'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(child: Text('Driver - Waiting for your response')),
                        Center(child: Text('Driver - Waiting')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Nested tabs for 'As Rider'
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Waiting for your response'),
                      Tab(text: 'Waiting'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(child: Text('Rider - Waiting for your response')),
                        Center(child: Text('Rider - Waiting')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
