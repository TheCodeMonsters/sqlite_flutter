import 'package:flutter/material.dart';
import 'package:sqlite_flutter/model/user.dart';
import 'package:sqlite_flutter/services/database_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter SQL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      await this.addUsers();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: FutureBuilder(
        future: this.handler.retrieveUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await this.handler.deleteUser(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                      child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].age.toString()),
                  )),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<int> addUsers() async {
    User firstUser = User(name: "peter", age: 24, country: "Lebanon");
    User secondUser = User(name: "Messi", age: 31, country: "United Kingdom");
    User thirdUser = User(name: "john", age: 31, country: "United Kingdom");
    User forUser = User(name: "CR7", age: 31, country: "United Kingdom");
    User fiveUser = User(name: "Neymar", age: 31, country: "United Kingdom");
    User sixUser = User(name: "Verrati", age: 31, country: "United Kingdom");
    User sevenUser = User(name: "Cavani", age: 31, country: "United Kingdom");
    User eightUser = User(name: "Miguel", age: 31, country: "United Kingdom");
    User nineUser = User(name: "Juan", age: 31, country: "United Kingdom");
    User tenUser = User(name: "Pedro", age: 31, country: "United Kingdom");
    User elevenUser = User(name: "Fati", age: 31, country: "United Kingdom");
    List<User> listOfUsers = [firstUser, secondUser];
    return await this.handler.insertUser(listOfUsers);
  }
}
