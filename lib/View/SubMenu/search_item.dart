import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmhfoodrecipe/Provider/history_provider.dart';
import 'package:pmhfoodrecipe/View/SubMenu/detail_page.dart';
class SearchItem extends StatefulWidget {
  const SearchItem({super.key});

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = HistoryProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
        title: Text("Tìm kiếm món ăn"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(50)
              ),
              prefixIcon: Container(
                alignment: Alignment.center,
                height: 20,
                width: 20,
                child: Icon(Icons.search,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
              suffixIcon: TextButton(
                onPressed: (){
                  searchController.clear();
                },
                child: Icon(Icons.clear,
                  color: Colors.grey,
                  size: 20
                ),
              ),
              labelText: "Tìm kiếm",
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50)
              ),
          ),
          onChanged: (val){
            setState(() {
              searchQuery = val;
            });
          },
        ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (searchQuery.isNotEmpty)
                    ? FirebaseFirestore.instance
                    .collection('food_recipe')
                    .orderBy('title')
                    .startAt([searchQuery]).endAt([searchQuery + "\uf8ff"])
                    .snapshots()
                    : FirebaseFirestore.instance.collection('food_recipe').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (!snapshot.hasData){
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: 44),
                          Image.asset("assets/images/no_result.png",
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(height: 20),
                          Text("Không có dữ liệu",
                            style: TextStyle(
                              color: Colors.black,
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
                  else {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot foods = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: (){
                            provider.toggleView(foods);
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DetailPage(
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
                              width: 150,
                              height: 200,
                              child: Column(
                                children: [
                                  Hero(
                                    tag: foods['imageURL'],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 120,
                                        child: Image.network(foods['imageURL'], fit: BoxFit.cover,),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(foods['title'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text("Thể loại: ${foods['tag']}",
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
            )
          ],
        ),
      ),
    );
  }
}
