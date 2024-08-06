import 'package:flutter/material.dart';
import 'product_database.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductDetailsPage(),
    );
  }
}




class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    var productMaps = await ProductDatabase.instance.readDatabase();
    setState(() {
      products = productMaps;
    });
  }

  Future<void> _insertProduct() async {
    await ProductDatabase.instance.insertRecord({
      ProductDatabase.columnName: "orange",
      ProductDatabase.columnPrice: 70,
      ProductDatabase.columnIsAvailability: 1,
      ProductDatabase.columnCategory: "fruits",
      ProductDatabase.columnSizeQuantity: 50,
      ProductDatabase.columnItemImageUrl: "assets/orange.jpg"
    });
    showAlertDialog(context);
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 2 / 3,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {

            return  Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      //'assets/jeans.jpg',
                      products[index]['item_image_url'],
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8),
                    Text(
                      products[index]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${products[index]['price']}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Quantity: ${products[index]['size_quantity']}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      products[index]['is_availability'] != 0 ? 'Available' : 'Out of stock',
                      style: TextStyle(
                        color: products[index]['is_availability'] != 0 ? Colors.blue : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Category: ${products[index]['category']}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );

          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _insertProduct,
        child: Icon(Icons.add),
        tooltip: 'Insert Item',
      ),
    );
  }
}



showAlertDialog(BuildContext context) {
  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text("Data has been recorded."),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
