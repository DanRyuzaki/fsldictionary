import 'dart:async';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fsldictionary/loginpage_process.dart';
import 'package:fsldictionary/main.dart';
import 'package:fsldictionary/menuroutes_screen.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:translator/translator.dart';
import 'package:internet_popup/internet_popup.dart';

List<String> searchDictionaryItems_global = [];

List<String> searchDictionaryItems_cat0 = [];

List<String> searchDictionaryItems_cat1 = [];

List<String> searchDictionaryItems_cat2 = [];

List<String> searchDictionaryItems_cat3 = [];

List<String> searchDictionaryItems_cat4 = [];

List<String> searchDictionaryItems_cat5 = [];

List<String> searchDictionaryItems_likes = [];

int wordListPageStateGlobal = 0;
int english_tl = 0;
List<String> currentWord = [
  "Waiting...",
  "Waiting...",
  "Waiting...",
  "https://firebasestorage.googleapis.com/v0/b/fsl-3d-dictionary.appspot.com/o/default_bg.mp4?alt=media&token=b5ffd3a4-c57e-483a-9693-ae8f5663c204"
];

String videoState = "play";

List<String> currentWordEn = [
  "Loading...",
  "Loading...",
  "Loading...",
];
List<String> currentWordSelected = [
  "Waiting...",
  "Waiting...",
  "Waiting...",
  "https://firebasestorage.googleapis.com/v0/b/fsl-3d-dictionary.appspot.com/o/default_bg.mp4?alt=media&token=b5ffd3a4-c57e-483a-9693-ae8f5663c204"
];
double _playbackSpeed = 1.0;
List<String> currentWordSelectedDescription = [];

class HomePageProcess extends StatelessWidget {
  String useremail;
  String userdisplayphoto;
  String userdisplayname;
  int wordListPageState;
  HomePageProcess(
      {super.key,
      required this.useremail,
      required this.userdisplayphoto,
      required this.userdisplayname,
      required this.wordListPageState});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FSL Dictionary',
      routes: {
        '/': (context) => SplashScreen(
            useremail: useremail,
            userdisplayphoto: userdisplayphoto,
            userdisplayname: userdisplayname,
            wordListPageState: wordListPageState),
        '/second': (context) => SecondScreen(
            useremail: useremail,
            userdisplayphoto: userdisplayphoto,
            userdisplayname: userdisplayname,
            wordListPageState: wordListPageState),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  String useremail;
  String userdisplayphoto;
  String userdisplayname;
  int wordListPageState;
  SplashScreen(
      {super.key,
      required this.useremail,
      required this.userdisplayphoto,
      required this.userdisplayname,
      required this.wordListPageState});
  @override
  _SplashScreenState createState() => _SplashScreenState(
      useremail: useremail,
      userdisplayphoto: userdisplayphoto,
      userdisplayname: userdisplayname,
      wordListPageState: wordListPageState);
}

class _SplashScreenState extends State<SplashScreen> {
  String useremail;
  String userdisplayphoto;
  String userdisplayname;
  int wordListPageState;
  _SplashScreenState(
      {required this.useremail,
      required this.userdisplayphoto,
      required this.userdisplayname,
      required this.wordListPageState});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    InternetPopup().initialize(context: context);
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
        currentWord = currentWordSelected;
      });
    });

    collectDocumentNames();
    if (wordListPageState == 0) {
      searchDictionaryItems_global = searchDictionaryItems_cat0;
    } else if (wordListPageState == 1) {
      searchDictionaryItems_global = searchDictionaryItems_cat1;
    } else if (wordListPageState == 2) {
      searchDictionaryItems_global = searchDictionaryItems_cat2;
    } else if (wordListPageState == 3) {
      searchDictionaryItems_global = searchDictionaryItems_cat3;
    } else if (wordListPageState == 4) {
      searchDictionaryItems_global = searchDictionaryItems_cat4;
    } else if (wordListPageState == 5) {
      searchDictionaryItems_global = searchDictionaryItems_cat5;
    }
    Fluttertoast.showToast(
        msg: 'Welcome back, $useremail!', // Customize the toast message
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1, // Optional for specific platforms
        backgroundColor: const Color.fromARGB(255, 255, 239, 239),
        textColor: const Color.fromARGB(255, 0, 0, 0),
        fontSize: 16.0);

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushNamed(
          context, '/second'); // Replace with your target screen
    });
  }

  Future<void> collectDocumentNames() async {
    CollectionReference dictionary_noun =
        FirebaseFirestore.instance.collection('dictionary_noun');
    CollectionReference dictionary_verb =
        FirebaseFirestore.instance.collection('dictionary_verb');
    CollectionReference dictionary_adverb =
        FirebaseFirestore.instance.collection('dictionary_adverb');
    CollectionReference dictionary_adjective =
        FirebaseFirestore.instance.collection('dictionary_adjective');
    CollectionReference dictionary_phrases =
        FirebaseFirestore.instance.collection('dictionary_phrases');
    CollectionReference dictionary_likes = FirebaseFirestore.instance
        .collection('dictionary_favorites_$useremail');
    CollectionReference addFavoriteRef = FirebaseFirestore.instance
        .collection('dictionary_favorites_$useremail');
    QuerySnapshot favoriteWordIndicator =
        await addFavoriteRef.where('Word', isEqualTo: currentWord[0]).get();
    if (favoriteWordIndicator.docs.isEmpty) {
      setState(() {
        modalIcons[0] = Icons.favorite_border;
      });
    } else {
      setState(() {
        modalIcons[0] = Icons.favorite;
      });
    }
    dictionary_noun.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        searchDictionaryItems_cat1.add(
            "${doc.get('Word')} || Category || ${doc.get('Description')} || ${doc.get('animURL')}");
        searchDictionaryItems_cat0.add(
            "${doc.get('Word')} || ${doc.get('Category')} || ${doc.get('Description')} || ${doc.get('animURL')}");
      });
    });
    dictionary_verb.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        searchDictionaryItems_cat2.add(
            "${doc.get('Word')} || Category || ${doc.get('Description')} || ${doc.get('animURL')}");
        searchDictionaryItems_cat0.add(
            "${doc.get('Word')} || ${doc.get('Category')} || ${doc.get('Description')} || ${doc.get('animURL')}");
      });
    });
    dictionary_adverb.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        searchDictionaryItems_cat3.add(
            "${doc.get('Word')} || Category || ${doc.get('Description')} || ${doc.get('animURL')}");
        searchDictionaryItems_cat0.add(
            "${doc.get('Word')} || ${doc.get('Category')} || ${doc.get('Description')} || ${doc.get('animURL')}");
      });
    });
    dictionary_adjective.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        searchDictionaryItems_cat4.add(
            "${doc.get('Word')} || Category || ${doc.get('Description')} || ${doc.get('animURL')}");
        searchDictionaryItems_cat0.add(
            "${doc.get('Word')} || ${doc.get('Category')} || ${doc.get('Description')} || ${doc.get('animURL')}");
      });
    });
    dictionary_phrases.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        searchDictionaryItems_cat5.add(
            "${doc.get('Word')} || Category || ${doc.get('Description')} || ${doc.get('animURL')}");
        searchDictionaryItems_cat0.add(
            "${doc.get('Word')} || ${doc.get('Category')} || ${doc.get('Description')} || ${doc.get('animURL')}");
      });
    });
    dictionary_likes.get().then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((doc) {
        searchDictionaryItems_likes.add(
            "${doc.get('Word')} || ${doc.get('Category')} || ${doc.get('Description')} || ${doc.get('animURL')}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/defaultscreen_background_0.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

List<IconData> modalIcons = [
  Icons.favorite_border,
  Icons.share,
  Icons.play_arrow,
  Icons.speed,
  Icons.translate
];

class SecondScreen extends StatefulWidget {
  String useremail;
  String userdisplayphoto;
  String userdisplayname;
  int wordListPageState;
  SecondScreen(
      {super.key,
      required this.useremail,
      required this.userdisplayphoto,
      required this.userdisplayname,
      required this.wordListPageState});
  @override
  _SecondScreenState createState() => _SecondScreenState(
      useremail: useremail,
      userdisplayphoto: userdisplayphoto,
      userdisplayname: userdisplayname,
      wordListPageState: wordListPageState);
}

bool isSwitched_AccountSettings = false;

class _SecondScreenState extends State<SecondScreen> {
  String termsandconditions = "";
  String aboutusinfo = "";
  String useremail;
  String userdisplayphoto;
  String userdisplayname;
  int wordListPageState;
  _SecondScreenState(
      {required this.useremail,
      required this.userdisplayphoto,
      required this.userdisplayname,
      required this.wordListPageState});

  TextEditingController _controller = TextEditingController();

  void loadAsset() async {
    termsandconditions =
        await rootBundle.loadString('assets/termsandconditions.text');
    aboutusinfo = await rootBundle.loadString('assets/aboutus.text');
  }

  @override
  void initState() {
    super.initState();
    InternetPopup().initialize(context: context);

    loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    int warning = 0;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      endDrawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/defaultscreen_background_1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(userdisplayphoto),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            userdisplayname + "\n" + useremail,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Kollektif',
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0),
                          )),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        String.fromCharCode(Icons.settings.codePoint),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          fontFamily: Icons.settings.fontFamily,
                        ),
                      ),
                    ),
                    const Text(
                      'Settings & Configuration',
                      style: TextStyle(
                        fontFamily: 'Kollektif',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                            title: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Settings",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "Unchanged settings will be unacknowledged.",
                                  style: TextStyle(
                                      fontFamily: 'Kollektif', fontSize: 11),
                                ),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15.0),
                                SignInButton(Buttons.google,
                                    text: " Sign out your account",
                                    onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  setState(() {
                                    searchDictionaryItems_global = [];
                                  });
                                  Fluttertoast.showToast(
                                      msg:
                                          '$useremail signed out.', // Customize the toast message
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb:
                                          1, // Optional for specific platforms
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 239, 239),
                                      textColor:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16.0);
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp()),
                                    (Route<dynamic> route) => false,
                                  );
                                }),
                                const SizedBox(height: 15.0),
                                SignInButton(Buttons.google,
                                    text: " Delete your account",
                                    onPressed: () async {
                                  warning = warning + 1;
                                  switch (warning) {
                                    case 0:
                                      warning = warning + 1;
                                    case 1:
                                      Fluttertoast.showToast(
                                          msg:
                                              'Are you sure about this action?',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb:
                                              1, // Optional for specific platforms
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 239, 239),
                                          textColor:
                                              Color.fromARGB(255, 255, 0, 0),
                                          fontSize: 16.0);
                                      warning = warning + 1;
                                    case 3:
                                      await FirebaseAuth.instance.signOut();
                                      setState(() {
                                        searchDictionaryItems_global = [];
                                      });
                                      Fluttertoast.showToast(
                                          msg:
                                              'Account \'$useremail\' deleted.',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb:
                                              1, // Optional for specific platforms
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 239, 239),
                                          textColor:
                                              Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 16.0);
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyApp()),
                                        (Route<dynamic> route) => false,
                                      );
                                      warning = 0;
                                      break;
                                  }
                                }),
                                const SizedBox(height: 35.0),
                              ],
                            ),
                          ));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        String.fromCharCode(Icons.menu_book.codePoint),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          fontFamily: Icons.menu_book.fontFamily,
                        ),
                      ),
                    ),
                    const Text(
                      'Dictionary',
                      style: TextStyle(
                        fontFamily: 'Kollektif',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuRoutesProcess(
                        routeSelected: 1,
                        sourceCategoryItemLength: [
                          searchDictionaryItems_cat1.length,
                          searchDictionaryItems_cat2.length,
                          searchDictionaryItems_cat3.length,
                          searchDictionaryItems_cat4.length,
                          searchDictionaryItems_cat5.length
                        ],
                        navigateToSecondScreenA: (int wordListPageState) async {
                          wordListPageStateGlobal = wordListPageState;
                          Navigator.popUntil(
                              context, ModalRoute.withName('/second'));
                          if (wordListPageState == 0) {
                            searchDictionaryItems_global =
                                searchDictionaryItems_cat0;
                          } else if (wordListPageState == 1) {
                            searchDictionaryItems_global =
                                searchDictionaryItems_cat1;
                            final currentWordSelectedProcess =
                                await showSearch<String>(
                              context: context,
                              delegate: CustomSearchDelagate(),
                            );
                            setState(() {
                              String categorySelect = "Loading...";
                              String descriptionSelect = "Loading...";
                              switch (wordListPageStateGlobal) {
                                case 1:
                                  categorySelect = "Pangngalan (noun)";
                                case 2:
                                  categorySelect = "Pandiwa (verb)";
                                case 3:
                                  categorySelect = "Pang-abay (adverb)";
                                case 4:
                                  categorySelect = "Pang-uri (adjective)";
                                case 5:
                                  categorySelect = "Mga Parirala (phrases)";
                              }
                              String currentWordSelectedProcessW =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[0];
                              String currentWordSelectedProcessD =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[2];
                              String currentWordSelectedProcessA =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[3];
                              descriptionSelect = currentWordSelectedProcessD;
                              currentWordSelected = [
                                currentWordSelectedProcessW,
                                categorySelect,
                                descriptionSelect,
                                currentWordSelectedProcessA
                              ];
                              currentWord = currentWordSelected;
                            });
                          } else if (wordListPageState == 2) {
                            searchDictionaryItems_global =
                                searchDictionaryItems_cat2;
                            final currentWordSelectedProcess =
                                await showSearch<String>(
                              context: context,
                              delegate: CustomSearchDelagate(),
                            );
                            setState(() {
                              String categorySelect = "Loading...";
                              String descriptionSelect = "Loading...";
                              switch (wordListPageStateGlobal) {
                                case 1:
                                  categorySelect = "Pangngalan (noun)";
                                case 2:
                                  categorySelect = "Pandiwa (verb)";
                                case 3:
                                  categorySelect = "Pang-abay (adverb)";
                                case 4:
                                  categorySelect = "Pang-uri (adjective)";
                                case 5:
                                  categorySelect = "Mga Parirala (phrases)";
                              }
                              String currentWordSelectedProcessW =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[0];
                              String currentWordSelectedProcessD =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[2];
                              String currentWordSelectedProcessA =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[3];
                              descriptionSelect = currentWordSelectedProcessD;
                              currentWordSelected = [
                                currentWordSelectedProcessW,
                                categorySelect,
                                descriptionSelect,
                                currentWordSelectedProcessA
                              ];
                              currentWord = currentWordSelected;
                            });
                          } else if (wordListPageState == 3) {
                            searchDictionaryItems_global =
                                searchDictionaryItems_cat3;
                            final currentWordSelectedProcess =
                                await showSearch<String>(
                              context: context,
                              delegate: CustomSearchDelagate(),
                            );
                            setState(() {
                              String categorySelect = "Loading...";
                              String descriptionSelect = "Loading...";
                              switch (wordListPageStateGlobal) {
                                case 1:
                                  categorySelect = "Pangngalan (noun)";
                                case 2:
                                  categorySelect = "Pandiwa (verb)";
                                case 3:
                                  categorySelect = "Pang-abay (adverb)";
                                case 4:
                                  categorySelect = "Pang-uri (adjective)";
                                case 5:
                                  categorySelect = "Mga Parirala (phrases)";
                              }
                              String currentWordSelectedProcessW =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[0];
                              String currentWordSelectedProcessD =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[2];
                              String currentWordSelectedProcessA =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[3];
                              descriptionSelect = currentWordSelectedProcessD;
                              currentWordSelected = [
                                currentWordSelectedProcessW,
                                categorySelect,
                                descriptionSelect,
                                currentWordSelectedProcessA
                              ];
                              currentWord = currentWordSelected;
                            });
                          } else if (wordListPageState == 4) {
                            searchDictionaryItems_global =
                                searchDictionaryItems_cat4;
                            final currentWordSelectedProcess =
                                await showSearch<String>(
                              context: context,
                              delegate: CustomSearchDelagate(),
                            );
                            setState(() {
                              String categorySelect = "Loading...";
                              String descriptionSelect = "Loading...";
                              switch (wordListPageStateGlobal) {
                                case 1:
                                  categorySelect = "Pangngalan (noun)";
                                case 2:
                                  categorySelect = "Pandiwa (verb)";
                                case 3:
                                  categorySelect = "Pang-abay (adverb)";
                                case 4:
                                  categorySelect = "Pang-uri (adjective)";
                                case 5:
                                  categorySelect = "Mga Parirala (phrases)";
                              }
                              String currentWordSelectedProcessW =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[0];
                              String currentWordSelectedProcessD =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[2];
                              String currentWordSelectedProcessA =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[3];
                              descriptionSelect = currentWordSelectedProcessD;
                              currentWordSelected = [
                                currentWordSelectedProcessW,
                                categorySelect,
                                descriptionSelect,
                                currentWordSelectedProcessA
                              ];
                              currentWord = currentWordSelected;
                            });
                          } else if (wordListPageState == 5) {
                            searchDictionaryItems_global =
                                searchDictionaryItems_cat5;
                            final currentWordSelectedProcess =
                                await showSearch<String>(
                              context: context,
                              delegate: CustomSearchDelagate(),
                            );
                            setState(() {
                              String categorySelect = "Loading...";
                              String descriptionSelect = "Loading...";
                              switch (wordListPageStateGlobal) {
                                case 1:
                                  categorySelect = "Pangngalan (noun)";
                                case 2:
                                  categorySelect = "Pandiwa (verb)";
                                case 3:
                                  categorySelect = "Pang-abay (adverb)";
                                case 4:
                                  categorySelect = "Pang-uri (adjective)";
                                case 5:
                                  categorySelect = "Mga Parirala (phrases)";
                              }
                              String currentWordSelectedProcessW =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[0];
                              String currentWordSelectedProcessD =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[2];
                              String currentWordSelectedProcessA =
                                  currentWordSelectedProcess
                                      .toString()
                                      .split(" || ")[3];
                              descriptionSelect = currentWordSelectedProcessD;
                              currentWordSelected = [
                                currentWordSelectedProcessW,
                                categorySelect,
                                descriptionSelect,
                                currentWordSelectedProcessA
                              ];
                              currentWord = currentWordSelected;
                            });
                          }
                        },
                        navigateToSecondScreenB: () {},
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        String.fromCharCode(Icons.favorite.codePoint),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 30,
                          fontWeight: FontWeight.w100,
                          fontFamily: Icons.favorite.fontFamily,
                        ),
                      ),
                    ),
                    const Text(
                      'Likes',
                      style: TextStyle(
                        fontFamily: 'Kollektif',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  setState(() {
                    searchDictionaryItems_global = searchDictionaryItems_likes;
                  });
                  final currentWordSelectedProcess = await showSearch<String>(
                    context: context,
                    delegate: CustomSearchDelagate(),
                  );
                  String currentWordSelectedProcessW =
                      currentWordSelectedProcess.toString().split(" || ")[0];
                  String currentWordSelectedProcessC =
                      currentWordSelectedProcess.toString().split(" || ")[1];
                  String currentWordSelectedProcessD =
                      currentWordSelectedProcess.toString().split(" || ")[2];
                  String currentWordSelectedProcessA =
                      currentWordSelectedProcess.toString().split(" || ")[3];
                  currentWordSelected = [
                    currentWordSelectedProcessW,
                    currentWordSelectedProcessC,
                    currentWordSelectedProcessD,
                    currentWordSelectedProcessA
                  ];
                  setState(() {
                    currentWord = currentWordSelected;
                    searchDictionaryItems_global = searchDictionaryItems_likes;
                  });
                  Navigator.popUntil(context, ModalRoute.withName('/second'));
                  CollectionReference addFavoriteRef = FirebaseFirestore
                      .instance
                      .collection('dictionary_favorites_$useremail');
                  QuerySnapshot favoriteWordIndicator = await addFavoriteRef
                      .where('Word', isEqualTo: currentWord[0])
                      .get();
                  if (favoriteWordIndicator.docs.isEmpty) {
                    setState(() {
                      modalIcons[0] = Icons.favorite_border;
                    });
                  } else {
                    setState(() {
                      modalIcons[0] = Icons.favorite;
                    });
                  }
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        String.fromCharCode(Icons.policy.codePoint),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 30,
                          fontWeight: FontWeight.w200,
                          fontFamily: Icons.policy.fontFamily,
                        ),
                      ),
                    ),
                    const Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontFamily: 'Kollektif',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                            title: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Terms & Conditions",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                            content: SingleChildScrollView(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  termsandconditions,
                                  style: const TextStyle(
                                      fontFamily: 'Kollektif', fontSize: 11),
                                ),
                              ],
                            )),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('I understand'),
                              ),
                            ],
                          ));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        String.fromCharCode(Icons.info_outline.codePoint),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 30,
                          fontWeight: FontWeight.w200,
                          fontFamily: Icons.info_outline.fontFamily,
                        ),
                      ),
                    ),
                    const Text(
                      'About Us',
                      style: TextStyle(
                        fontFamily: 'Kollektif',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                          title: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "About Us",
                                style: TextStyle(
                                    fontFamily: 'Kollektif',
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          content: Column(children: [
                            Card(
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ClipRRect(
                                // ClipRRect to clip rounded corners
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  'assets/images/about_us_banner.jpg',
                                  fit: BoxFit
                                      .cover, // Ensure image covers the container
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                                child: Text(aboutusinfo,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Kollektif',
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12)))
                          ])));
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(97, 255, 255, 255),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: GestureDetector(
            onTap: () async {
              String currentWordSelectedProcessW = "Loading...";
              String currentWordSelectedProcessC = "Loading...";
              String currentWordSelectedProcessD = "Loading...";
              String currentWordSelectedProcessA = "Loading...";
              final currentWordSelectedProcess = await showSearch<String>(
                context: context,
                delegate: CustomSearchDelagate(),
              );
              setState(() async {
                searchDictionaryItems_global = searchDictionaryItems_cat0;
                currentWordSelectedProcessW =
                    currentWordSelectedProcess.toString().split(" || ")[0];
                currentWordSelectedProcessC =
                    currentWordSelectedProcess.toString().split(" || ")[1];
                currentWordSelectedProcessD =
                    currentWordSelectedProcess.toString().split(" || ")[2];
                currentWordSelectedProcessA =
                    currentWordSelectedProcess.toString().split(" || ")[3];
                currentWordSelected = [
                  currentWordSelectedProcessW,
                  currentWordSelectedProcessC,
                  currentWordSelectedProcessD,
                  currentWordSelectedProcessA
                ];
                currentWord = currentWordSelected;
                CollectionReference addFavoriteRef = FirebaseFirestore.instance
                    .collection('dictionary_favorites_$useremail');
                QuerySnapshot favoriteWordIndicator = await addFavoriteRef
                    .where('Word', isEqualTo: currentWord[0])
                    .get();
                if (favoriteWordIndicator.docs.isEmpty) {
                  setState(() {
                    modalIcons[0] = Icons.favorite_border;
                  });
                } else {
                  setState(() {
                    modalIcons[0] = Icons.favorite;
                  });
                }
                currentWord[3] = currentWordSelectedProcessA;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3F8CAF),
                    Color(0xFF708D35),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                border: Border.all(color: Colors.transparent),
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
              child: Row(
                children: [
                  IconButton(
                    alignment: Alignment.topLeft,
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      String currentWordSelectedProcessW = "Loading...";
                      String currentWordSelectedProcessC = "Loading...";
                      String currentWordSelectedProcessD = "Loading...";
                      String currentWordSelectedProcessA = "Loading...";
                      final currentWordSelectedProcess =
                          await showSearch<String>(
                        context: context,
                        delegate: CustomSearchDelagate(),
                      );
                      CollectionReference addFavoriteRef = FirebaseFirestore
                          .instance
                          .collection('dictionary_favorites_$useremail');
                      QuerySnapshot favoriteWordIndicator = await addFavoriteRef
                          .where('Word', isEqualTo: currentWord[0])
                          .get();
                      if (favoriteWordIndicator.docs.isEmpty) {
                        setState(() {
                          modalIcons[0] = Icons.favorite_border;
                        });
                      } else {
                        setState(() {
                          modalIcons[0] = Icons.favorite;
                        });
                      }
                      setState(() async {
                        searchDictionaryItems_global =
                            searchDictionaryItems_cat0;
                        currentWordSelectedProcessW = currentWordSelectedProcess
                            .toString()
                            .split(" || ")[0];
                        currentWordSelectedProcessC = currentWordSelectedProcess
                            .toString()
                            .split(" || ")[1];
                        currentWordSelectedProcessD = currentWordSelectedProcess
                            .toString()
                            .split(" || ")[2];
                        currentWordSelectedProcessA = currentWordSelectedProcess
                            .toString()
                            .split(" || ")[3];
                        currentWordSelected = [
                          currentWordSelectedProcessW,
                          currentWordSelectedProcessC,
                          currentWordSelectedProcessD,
                          currentWordSelectedProcessA
                        ];
                        currentWord = currentWordSelected;
                        CollectionReference addFavoriteRef = FirebaseFirestore
                            .instance
                            .collection('dictionary_favorites_$useremail');
                        QuerySnapshot favoriteWordIndicator =
                            await addFavoriteRef
                                .where('Word', isEqualTo: currentWord[0])
                                .get();
                        if (favoriteWordIndicator.docs.toString() == "[]") {
                          setState(() {
                            modalIcons[0] = Icons.favorite_border;
                          });
                        } else {
                          setState(() {
                            modalIcons[0] = Icons.favorite;
                          });
                        }
                      });
                    },
                  ),
                  const Text(
                    "Search",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Kollektif',
                        fontSize: 15.0),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    String.fromCharCode(Icons.menu.codePoint),
                    style: TextStyle(
                      inherit: false,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      fontFamily: Icons.space_dashboard_outlined.fontFamily,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: VideoBackground(
        videoPath: currentWord[3],
        videoState: videoState,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: _nottomNavModalDialog(),
            )
          ],
        ),
      ),
    );
  }

  Widget _nottomNavModalDialog() {
    return Container(
      height: 195,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3F8CAF),
            Color(0xFF708D35),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(42),
          topRight: Radius.circular(42),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(55),
              blurRadius: 20,
              spreadRadius: 10),
        ],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
              child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 10, bottom: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  currentWord[0],
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 29,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  currentWord[1],
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  currentWord[2],
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ])),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: (modalIcons.map((icon) {
              return GestureDetector(
                  onTap: () async {
                    if (icon == Icons.favorite_border) {
                      CollectionReference addFavoriteRef = FirebaseFirestore
                          .instance
                          .collection('dictionary_favorites_$useremail');
                      addFavoriteRef.add({
                        'Word': currentWord[0],
                        'Category': currentWord[1],
                        'Description': currentWord[2],
                        'animURL': currentWord[3]
                      });
                      Fluttertoast.showToast(
                          msg:
                              'added to favorites', // Customize the toast message
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb:
                              1, // Optional for specific platforms
                          backgroundColor:
                              const Color.fromARGB(255, 255, 239, 239),
                          textColor: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16.0);
                      setState(() {
                        modalIcons[0] = Icons.favorite;
                      });
                    } else if (icon == Icons.favorite) {
                      CollectionReference delFavoriteRef = FirebaseFirestore
                          .instance
                          .collection('dictionary_favorites_$useremail');
                      QuerySnapshot querySnapshot = await delFavoriteRef
                          .where('Word', isEqualTo: currentWord[0])
                          .get();
                      querySnapshot.docs.forEach((doc) {
                        // Get reference to each document and delete it
                        delFavoriteRef.doc(doc.id).delete().then((_) {
                          Fluttertoast.showToast(
                              msg:
                                  'removed from favorites', // Customize the toast message
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb:
                                  1, // Optional for specific platforms
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 239, 239),
                              textColor: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16.0);
                        }).catchError((error) {
                          Fluttertoast.showToast(
                              msg:
                                  'error: $error', // Customize the toast message
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb:
                                  1, // Optional for specific platforms
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 239, 239),
                              textColor: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16.0);
                        });
                      });
                      Fluttertoast.showToast(
                          msg:
                              'remove from favorites', // Customize the toast message
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb:
                              1, // Optional for specific platforms
                          backgroundColor:
                              const Color.fromARGB(255, 255, 239, 239),
                          textColor: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16.0);
                      setState(() {
                        modalIcons[0] = Icons.favorite_border;
                      });
                    } else if (icon == Icons.share) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                  "Clipboard",
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w700),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "You are about to copy the following details for the word \"${currentWord[0]}\"...\n",
                                      style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "Word: ${currentWord[0]}\nCategory: ${currentWord[1]}\nDescription: ${currentWord[2]}\n Animation Video: ${currentWord[3]}",
                                      style: const TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(
                                            msg:
                                                'Details copied', // Customize the toast message
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb:
                                                1, // Optional for specific platforms
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 255, 239, 239),
                                            textColor: const Color.fromARGB(
                                                255, 0, 0, 0),
                                            fontSize: 16.0);
                                        Clipboard.setData(ClipboardData(
                                            text:
                                                "Word: ${currentWord[0]}\nCategory: ${currentWord[1]}\nDescription: ${currentWord[2]}\n Animation Video: ${currentWord[3]}"));
                                      },
                                      child: const Text("Copy"))
                                ],
                              ));
                    } else if (icon == Icons.play_arrow) {
                      setState(() {
                        videoState = "pause";
                        modalIcons[2] = Icons.pause;
                      });
                    } else if (icon == Icons.pause) {
                      setState(() {
                        videoState = "pause";
                        modalIcons[2] = Icons.play_arrow;
                      });
                    } else if (icon == Icons.speed) {
                      setState(() {
                        videoState = "play";
                        switch (_playbackSpeed) {
                          case 1.0:
                            _playbackSpeed = 2.0;
                            Fluttertoast.showToast(
                                msg:
                                    'Playback Speed set to 2.0x', // Customize the toast message
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb:
                                    1, // Optional for specific platforms
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 239, 239),
                                textColor: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16.0);
                          case 2.0:
                            _playbackSpeed = 0.5;
                            Fluttertoast.showToast(
                                msg:
                                    'Playback Speed set to 0.5x', // Customize the toast message
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb:
                                    1, // Optional for specific platforms
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 239, 239),
                                textColor: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16.0);
                          case 0.5:
                            _playbackSpeed = 1.0;
                            Fluttertoast.showToast(
                                msg:
                                    'Playback Speed set to normal speed.', // Customize the toast message
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb:
                                    1, // Optional for specific platforms
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 239, 239),
                                textColor: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16.0);
                            break;
                          default:
                        }
                      });
                    } else if (icon == Icons.translate) {
                      if (english_tl == 1) {
                        await GoogleTranslator()
                            .translate(currentWord[0], to: 'en')
                            .then((value) => setState(() {
                                  currentWord[0] = value.toString();
                                }));

                        await GoogleTranslator()
                            .translate(currentWord[2], to: 'en')
                            .then((value) => setState(() {
                                  currentWord[1] = currentWord[1];
                                  currentWord[2] = value.toString();
                                }));

                        Fluttertoast.showToast(
                            msg:
                                'Translated to English (En).', // Customize the toast message
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb:
                                1, // Optional for specific platforms
                            backgroundColor:
                                const Color.fromARGB(255, 255, 239, 239),
                            textColor: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 16.0);
                        setState(() {
                          english_tl = 2;
                        });
                      } else if (english_tl == 2) {
                        await GoogleTranslator()
                            .translate(currentWord[0], to: 'tl')
                            .then((value) => setState(() {
                                  currentWord[0] = value.toString();
                                }));

                        await GoogleTranslator()
                            .translate(currentWord[2], to: 'tl')
                            .then((value) => setState(() {
                                  currentWord[1] = currentWord[1];
                                  currentWord[2] = value.toString();
                                }));
                        Fluttertoast.showToast(
                            msg:
                                'Translated to Tagalog (tl).', // Customize the toast message
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb:
                                1, // Optional for specific platforms
                            backgroundColor:
                                const Color.fromARGB(255, 255, 239, 239),
                            textColor: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 16.0);
                        setState(() {
                          english_tl = 1;
                        });
                      }
                    }
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                            top: 20,
                            left: 15,
                            right: 15,
                          ),
                          child: Icon(icon, color: Colors.white, size: 30),
                        ),
                      ],
                    ),
                  ));
            }).toList()),
          ),
        ],
      ),
    );
  }
}

class CustomSearchDelagate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty) {
          close(context, "");
        } else {
          query = '';
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var items in searchDictionaryItems_global) {
      if (items.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(items);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index].split(" || ");
        return ListTile(
          title: Text(result[0]),
          onTap: () {
            Fluttertoast.showToast(
                msg: 'Buffering...', // Customize the toast message
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1, // Optional for specific platforms
                backgroundColor: const Color.fromARGB(255, 255, 239, 239),
                textColor: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16.0);
            close(context,
                "${result[0]} || ${result[1]} || ${result[2]} || ${result[3]}");
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var items in searchDictionaryItems_global) {
      if (items.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(items);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index].split(" || ");
        return ListTile(
          title: Text(result[0]),
          onTap: () {
            Fluttertoast.showToast(
                msg: 'Buffering...', // Customize the toast message
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1, // Optional for specific platforms
                backgroundColor: const Color.fromARGB(255, 255, 239, 239),
                textColor: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 16.0);
            close(context,
                "${result[0]} || ${result[1]} || ${result[2]} || ${result[3]}");
          },
        );
      },
    );
  }
}

class VideoBackground extends StatefulWidget {
  String videoPath;
  String videoState;
  final Widget child;

  VideoBackground(
      {required this.videoPath, required this.child, required this.videoState});

  @override
  _VideoBackgroundState createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void didUpdateWidget(covariant VideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoState == "pause") {
      toggleVideoPlayback();
    }

    if (oldWidget.videoPath != widget.videoPath) {
      _controller.dispose();
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
            ..initialize().then((_) {
              setState(() {
                english_tl = 1;
              });
            });
      _controller.setLooping(true);
      _controller.setPlaybackSpeed(_playbackSpeed);
      _controller.play();
    } else {
      _controller.setPlaybackSpeed(_playbackSpeed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size?.width ?? 0,
                height: _controller.value.size?.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Center(
            child: widget.child,
          ),
        ],
      ),
    );
  }

  void toggleVideoPlayback() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
