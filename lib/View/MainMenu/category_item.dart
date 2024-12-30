import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmhfoodrecipe/Provider/history_provider.dart';
import 'package:pmhfoodrecipe/View/MainMenu/notification_item.dart';
import 'package:pmhfoodrecipe/View/SubMenu/detail_page.dart';
import 'package:pmhfoodrecipe/View/SubMenu/search_item.dart';
class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  final CollectionReference categoryCollection =
  FirebaseFirestore.instance.collection("category");
  String selectCategory = "Tất cả";
  Query get filterRecipes => FirebaseFirestore.instance.collection("food_recipe")
      .where("tag", isEqualTo: selectCategory);
  Query get allRecipes => FirebaseFirestore.instance.collection("food_recipe");
  Query get selectedRecipes => selectCategory == "Tất cả" ? allRecipes : filterRecipes;

  @override
  Widget build(BuildContext context) {
    final historyprovider = HistoryProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        leading: Image.asset("assets/images/FoodDesign.png",
          height: 40,
          fit: BoxFit.cover,
        ),
        title: Text("PMH Food Recipe",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationItem())
              );
            },
            icon: Icon(Icons.notifications,
              color: Colors.white,
              size: 20,
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchItem())
                );
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search,
                  size: 20,
                  color: Colors.grey,
                ),
                hintText: "Tìm kiếm",
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)
                )
              ),
            ),
            SizedBox(height: 15),
            Text("Phổ biến",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 15),
            StreamBuilder(
              stream: categoryCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (!snapshot.hasData){
                  return Center(child: CircularProgressIndicator());
                }else{
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                        List.generate(
                          snapshot.data!.docs.length,
                            (index) => GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectCategory = snapshot.data!.docs[index]["tag"];
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: selectCategory == snapshot.data!.docs[index]["tag"]
                                    ? Colors.green.shade400 : Colors.white
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10
                                ),
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                  snapshot.data!.docs[index]["tag"],
                                  style: TextStyle(
                                    color: selectCategory == snapshot.data!.docs[index]["tag"]
                                        ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
                              ),
                            ),
                        ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: selectedRecipes.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (!snapshot.hasData){
                    return Center(
                      child: Column(
                        children: [
                          Icon(Icons.error_outline_rounded,
                            size: 50,
                            color: Colors.black,
                          ),
                          SizedBox(height: 20),
                          Text("Lỗi khi tải",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  else if (snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else{
                    var doc = snapshot.data!.docs;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78
                      ),
                      itemCount: doc.length,
                      itemBuilder: (context, index){
                        DocumentSnapshot foods = doc[index];
                        return GestureDetector(
                          onTap: (){
                            historyprovider.toggleView(foods);
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(
                                          foods: foods,
                                          id: foods.id,
                                          likeList: List<Map<String, dynamic>>.from(foods['likes'] ?? []),
                                        ))
                            );
                          },
                          child: Card(
                            color: Colors.white.withOpacity(0.25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              height: 200,
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: foods['imageURL'],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        height: 120,
                                        width: double.infinity,
                                        child: Image.network(foods['imageURL'], fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    foods['title'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Thể loại: ${foods['tag']}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
