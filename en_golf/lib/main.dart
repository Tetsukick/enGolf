import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

import 'package:provider/provider.dart';

import 'utils.dart';
import 'widgets.dart';
import 'olympic_bloc.dart';
import 'olympic_screen.dart';
import 'constants.dart' as Constants;

void main() => runApp(new HomeScreen());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MultiProvider(
        providers: [
          Provider<OlympicBloc>(
            create: (context) => OlympicBloc(),
            dispose: (context, bloc) => bloc.dispose(),
          ),
        ],
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            bottomNavigationBar: TabBar(
              controller: tabController,
              labelColor: Colors.lightGreen,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                  color: Colors.grey
              ),
              indicatorColor: Colors.white,
              tabs: <Widget>[
                new Tab(
                  icon: Icon(Icons.monetization_on),
                  text: "Calculator",
                ),
                new Tab(
                  icon: Icon(Icons.casino),
                  text: "Dice",
                ),
              ],
            ),
            body: SafeArea(
              child: TabBarView(
                controller: tabController,
                children: <Widget> [
                  olympic_screen(),
                  olympic_screen(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
