import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenuRoutesProcess extends StatelessWidget {
  int routeSelected = 0;
  List<int> sourceCategoryItemLength;
  Function navigateToSecondScreenA;
  Function navigateToSecondScreenB;

  MenuRoutesProcess(
      {super.key,
      required this.routeSelected,
      required this.navigateToSecondScreenA,
      required this.navigateToSecondScreenB,
      required this.sourceCategoryItemLength});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FSL Dictionary',
      home: DictionaryPage(
        navigateToSecondScreenA: navigateToSecondScreenA,
        sourceCategoryItemLength: sourceCategoryItemLength,
      ), // Pass callback function to DictionaryPage
    );
  }
}

List<String> categoryTitle = [
  "Pangngalan (Noun)",
  "Pandiwa (Verb)",
  "Pang-abay (Adverb)",
  "Pang-uri (Adjective)",
  "Mga Parilala (Phrases)"
];

List<AssetImage> categoryBanner = [
  const AssetImage(
      "assets/images/categoryBanner/categoryBanner_Pangngalan.png"),
  const AssetImage("assets/images/categoryBanner/categoryBanner_Pandiwa.png"),
  const AssetImage("assets/images/categoryBanner/categoryBanner_Pang-abay.png"),
  const AssetImage("assets/images/categoryBanner/categoryBanner_Pang-uri.png"),
  const AssetImage("assets/images/categoryBanner/categoryBanner_Parirala.png"),
];

int indexItemSelectedGlobal = 0;

class DictionaryPage extends StatefulWidget {
  final Function navigateToSecondScreenA;
  List<int> sourceCategoryItemLength; // Define callback function
  DictionaryPage(
      {super.key,
      required this.navigateToSecondScreenA,
      required this.sourceCategoryItemLength}); // Accept callback function as parameter

  @override
  DictionaryPageState createState() =>
      DictionaryPageState(sourceCategoryItemLength: sourceCategoryItemLength);
}

class DictionaryPageState extends State<DictionaryPage> {
  List<int> sourceCategoryItemLength;
  DictionaryPageState({required this.sourceCategoryItemLength});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dictionary",
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            widget.navigateToSecondScreenA(0);
          },
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(76, 255, 255, 255),
      ),
      backgroundColor: Colors.red, // Make the scaffold background transparent
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/defaultscreen_background_1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            indexItemSelectedGlobal = index;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: categoryBanner[index], fit: BoxFit.cover),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text('${categoryTitle[index]}',
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                    subtitle: Text('${sourceCategoryItemLength[index]} Words',
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                    onTap: () {
                      widget.navigateToSecondScreenA(index + 1);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
