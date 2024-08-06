import 'package:database_testing/db_control.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database Operation',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Database Testing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _namecontroller = TextEditingController();
  final _pricecontroller = TextEditingController();
  List<Map<String, dynamic>> datalist = [];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.title),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 200,
                  height: 100,
                  child: TextFormField(
                    controller: _namecontroller,
                    // keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter book name',
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 100,
                  child: TextFormField(
                    controller: _pricecontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter price',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final book_name = _namecontroller.text;
                    final price = int.tryParse(_pricecontroller.text) ?? 0;
                    await DatabaseHelper.instance.insert_record({
                      DatabaseHelper.columnTitle: book_name,
                      DatabaseHelper.columnPrice: price
                    });
                    showAlertDialog(context);
                    //to read data
                     var dbread = await DatabaseHelper.instance.readDatabase();
                     //to refresh data on new insertion
                    setState(() {
                      datalist = dbread;
                    });
                    
                  },
                  child: Text("save"),
                ),
                ElevatedButton(
                onPressed: () async {
                  var dbread = await DatabaseHelper.instance.readDatabase();
                  datalist = dbread;
                  setState(() {
                    
                  });
                print(datalist);
              },
              child: Text("read")),
              ],
            ),
          ),
          // ElevatedButton(
          //      onPressed: () async{
          //        await DatabaseHelper.instance.insert_record(
          //            {DatabaseHelper.columnTitle: "biography",
          //            DatabaseHelper.columnPrice: 30});
          //      },
          //      child: const Text("insert")),
         

          //SizedBox(height: 30,),


             Expanded(
              child: ListView.builder(
                  itemCount: datalist.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(datalist[index]['title']),
                      subtitle: Text('id: ${datalist[index]['id']}, price: ${datalist[index]['price']}'),
                    );
                  }),
            ),
          
        ],
      )),
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("data has been recorded."),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
