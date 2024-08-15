import 'package:flutter/material.dart';

void main() {
  runApp(EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Clone',
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
        hintColor: Color.fromARGB(235, 40, 40, 40),
        scaffoldBackgroundColor: Color.fromARGB(255, 249, 248, 248),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: CategoryScreen(),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<Category> allCategories = [
    Category(name: 'Dress', icon: Icons.checkroom),
    Category(name: 'Kitchen Accessories', icon: Icons.kitchen),
    Category(name: 'Vegetables', icon: Icons.eco),
    Category(name: 'Fruits', icon: Icons.apple),
    Category(name: 'Toys', icon: Icons.toys),
  ];

  List<Category> displayedCategories = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedCategories = allCategories;
  }

  void _filterCategories(String query) {
    final filtered = allCategories
        .where((category) =>
            category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      displayedCategories = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterCategories('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Category Section')),
        backgroundColor: Colors.orangeAccent,
        elevation: 4.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCategories,
              decoration: InputDecoration(
                hintText: 'Search categories',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = (constraints.maxWidth / 200).floor();
                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: displayedCategories.length,
                  itemBuilder: (context, index) {
                    final category = displayedCategories[index];
                    return CategoryCard(category: category);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ItemListScreen(category: category),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                size: 50,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 10),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemListScreen extends StatelessWidget {
  final Category category;

  ItemListScreen({required this.category});

  final List<Item> allItems = [
    Item(
      name: 'Red Dress',
      price: 49.99,
      isAvailable: true,
      category: 'Dress',
      sizeQuantity: 'M',
      imageUrl: 'assets/images/dress.jpg',
    ),
    Item(
      name: 'Frying Pan',
      price: 19.99,
      isAvailable: false,
      category: 'Kitchen Accessories',
      sizeQuantity: 'Large',
      imageUrl: 'assets/images/frying_pan.jpg',
    ),
    // Add more items for other categories...
  ];

  @override
  Widget build(BuildContext context) {
    final List<Item> items =
        allItems.where((item) => item.category == category.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('${category.name} Items')),
        backgroundColor: Colors.orangeAccent,
        elevation: 4.0,
      ),
      body: items.isEmpty
          ? Center(child: Text('No items available'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: Image.asset(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \$${item.price}'),
                        Text('Available: ${item.isAvailable ? 'Yes' : 'No'}'),
                        Text('Size/Quantity: ${item.sizeQuantity}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class Item {
  final String name;
  final double price;
  final bool isAvailable;
  final String category;
  final String sizeQuantity;
  final String imageUrl;

  Item({
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.category,
    required this.sizeQuantity,
    required this.imageUrl,
  });
}
