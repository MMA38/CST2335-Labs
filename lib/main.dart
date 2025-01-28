import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Recipe Categories')),
        body: RecipeCategoriesPage(),
      ),
    );
  }
}

class RecipeCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title Row
         const Text(
              'BROWSE CATEGORIES',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          // Row 1: "Not sure about exactly which recipe you're looking for?"
         Padding(padding: const EdgeInsets.all(50.0),
         child: Text(
              "Not sure about exactly which recipe you're looking for? Do a search, or dive into our most popular categories.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
    ),


          // Row 2: By Meat (center-aligned)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('BY MEAT', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ],
          ),

          // Row 3: Beef, Chicken, Pork, Seafood (Images in Stack)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
               alignment: AlignmentDirectional.center,
            children: [
              CircleAvatar(
                  backgroundImage: AssetImage('images/meet.jpg'), radius:80
              ),
              const Text("Beef",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.red),),
            ],),
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  CircleAvatar(
                  backgroundImage: AssetImage('images/chicken.jpg'), radius:80
                   ),
                  const Text("CHICKEN",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.red),),
                ],),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CircleAvatar(
                      backgroundImage: AssetImage('images/pork.jpg'), radius:80
                  ),
                  const Text("PORK",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.red),),
                ],),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CircleAvatar(
                      backgroundImage: AssetImage('images/seaFood.jpg'), radius:80
                  ),
                  const Text("SEAFOOD",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.red),),
                ],),

            ],
          ),

          // Row 4: By Course (Main dishes, Salad, Side dishes, Crockpot)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('BY COURSE', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              categoryWithTextOverImage('Main Dishes', 'images/mainDish.jpg'),
              categoryWithTextOverImage('Salad Recipes', 'images/salad.jpg'),
              categoryWithTextOverImage('Side Dishes', 'images/side dishes.jpg'),
              categoryWithTextOverImage('Crockpot', 'images/crockpot.jpg'),
            ],
          ),

          // Row 5: By Dessert (Ice Cream, Brownies, Pies, Cookies)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('BY DESSERT', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              categoryWithTextOverImage('Ice Cream', 'images/iceCream.jpg'),
              categoryWithTextOverImage('Brownies', 'images/brownies.jpg'),
              categoryWithTextOverImage('Pies', 'images/Pies.jpg'),
              categoryWithTextOverImage('Cookies', 'images/cookies.jpg'),
            ],
          ),
        ],
      ),
    );
  }


  Widget categoryWithTextOverImage(String label, String imagePath) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 80,
        ),
        Container(
          color: Colors.black54,
          padding: EdgeInsets.all(4.0),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
