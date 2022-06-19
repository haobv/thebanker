import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/live.dart';
import 'package:my_app/ranking.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_options.dart';
import 'models/player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'The Banker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<RoundedLoadingButtonController> _btnControllers = <RoundedLoadingButtonController>[];
  List<TextEditingController> _controllers = <TextEditingController>[];
  TextEditingController _addController = TextEditingController();
  List<Player> listPlayer = <Player>[];
  int totalBuyIn = 0;
  int totalBuyOut = 0;
  late DatabaseReference _gameRef;
  late DatabaseReference _deviceRef;
  late StreamSubscription<DatabaseEvent> _gameSubscription;
  String deviceId = "xxxxx";
  bool displayResult = false;
  int buyInPrice = 200;
  var date = "";
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                // height: 1.7,
              ),
            ),
            Text(
              totalBuyIn > 0 ? '   (+ $totalBuyIn   - $totalBuyOut)' : '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                height: 1.7,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
        // actions: <Widget>[
        //   PopupMenuButton(
        //       onSelected: (value) {
        //         switch (value) {
        //           case 1:
        //             {
        //               // Reset game
        //               showDialog<String>(
        //                 context: context,
        //                 builder: (BuildContext context) => AlertDialog(
        //                   title: const Text('Chắc chưa Bro ?'),
        //                   // content: const Text('AlertDialog description'),
        //                   actions: <Widget>[
        //                     TextButton(
        //                       onPressed: () => Navigator.pop(context, 'Cancel'),
        //                       child: const Text('Cancel'),
        //                     ),
        //                     TextButton(
        //                       onPressed: () {
        //                         _reset();
        //                         Navigator.of(context).pop();
        //                       },
        //                       child: const Text('OK'),
        //                     ),
        //                   ],
        //                 ),
        //               );
        //             }
        //             break;
        //
        //           case 2:
        //             {
        //               // Add player
        //               _showAddDialog(context);
        //             }
        //             break;
        //           case 3:
        //             {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(builder: (context) => const LeaderBoard()),
        //               );
        //             }
        //             break;
        //           case 4:
        //             {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(builder: (context) => const Ranking()),
        //               );
        //             }
        //             break;
        //           case 5:
        //             {
        //               _showUpdatePriceDialog(context);
        //             }
        //             break;
        //           default:
        //             {
        //               //statements;
        //             }
        //             break;
        //         }
        //       },
        //       itemBuilder: (context) => [
        //             const PopupMenuItem(
        //               child: ListTile(
        //                 leading: Icon(Icons.refresh_sharp),
        //                 title: Text("Reset"),
        //               ),
        //               value: 1,
        //             ),
        //             const PopupMenuItem(
        //               child: ListTile(
        //                 leading: Icon(Icons.add),
        //                 title: Text("Add Player"),
        //               ),
        //               value: 2,
        //             ),
        //             const PopupMenuItem(
        //               child: ListTile(
        //                 leading: Icon(Icons.list),
        //                 title: Text("Live"),
        //               ),
        //               value: 3,
        //             ),
        //             const PopupMenuItem(
        //               child: ListTile(
        //                 leading: Icon(Icons.military_tech),
        //                 title: Text("Ranking"),
        //               ),
        //               value: 4,
        //             ),
        //             const PopupMenuItem(
        //               child: ListTile(
        //                 leading: Icon(Icons.monetization_on_rounded),
        //                 title: Text("Price"),
        //               ),
        //               value: 5,
        //             )
        //           ])
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              // height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.vertical,
                itemCount: listPlayer.length,
                itemBuilder: (context, index) {
                  double elevation;
                  int buyIn = listPlayer[index].buyIn;
                  int buyOut = listPlayer[index].buyOut;
                  String logo = 'assets/logo/' + listPlayer[index].logo;
                  double borderWidth = 1;
                  Color borderColor = Colors.black26;

                  _btnControllers.add(RoundedLoadingButtonController());
                  switch (index) {
                    case 0:
                      elevation = 30;
                      borderColor = Colors.red;
                      borderWidth = 3;
                      break;
                    case 1:
                      elevation = 15;
                      borderColor = Colors.red;
                      borderWidth = 2;
                      break;
                    case 2:
                      elevation = 5;
                      borderColor = Colors.red;
                      borderWidth = 1;
                      break;
                    default:
                      elevation = 3;
                      borderColor = Colors.black26;
                      borderWidth = 1;
                  }
                  return SizedBox(
                    // height: 70,
                    child: Card(
                      shape: StadiumBorder(
                          side: BorderSide(
                        color: borderColor,
                        width: borderWidth,
                      )),
                      // color: Colors.green.shade100,
                      elevation: elevation,
                      // shadowColor: index < 3 ? Colors.red : Colors.ư,
                      // margin: EdgeInsets.all(5),
                      child: ListTile(
                        // leading: AvatarGlow(
                        //   endRadius: 30.0,
                        //   glowColor: buyIn > 3 ? Colors.red : Colors.white,
                        //   duration: Duration(milliseconds: _getAvatarDuration(buyIn)),
                        //   repeat: true,
                        //   repeatPauseDuration: const Duration(milliseconds: 100),
                        //   // showTwoGlows: true,
                        //   child: Material(
                        //     elevation: 8.0,
                        //     shape: const CircleBorder(),
                        //     child: CircleAvatar(
                        //       backgroundColor: Colors.white,
                        //       backgroundImage: AssetImage(logo),
                        //       radius: 20.0,
                        //     ),
                        //   ),
                        // ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(logo),
                          radius: 20.0,
                        ),
                        title: Text(
                          listPlayer[index].name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            // backgroundColor:
                            // height: 1,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Text(
                                '+ ' + listPlayer[index].buyIn.toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                ((buyOut > 0) && displayResult) ? "-\$" + buyOut.toString() : "",
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Text(
                              ((listPlayer[index].total != 0) && displayResult)
                                  ? "\$" + listPlayer[index].total.toString()
                                  : "",
                              style: TextStyle(
                                fontSize: 17,
                                color: (listPlayer[index].total > 0) ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: RoundedLoadingButton(
                              color: Colors.green,
                              successColor: Colors.red,
                              child: const Icon(
                                Icons.plus_one_rounded,
                                color: Colors.white,
                              ),
                              controller: _btnControllers[index],
                              onPressed: () {
                                _doBuyIn(index, listPlayer[index].id);
                                setState(() {
                                  displayResult = false;
                                });
                              }),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
          key: fabKey,
          fabOpenIcon: const Icon(Icons.menu, color: Colors.white),
          fabCloseIcon: const Icon(Icons.close, color: Colors.white),
          ringDiameter: 350.0,
          ringWidth: 80.0,
          fabMargin: const EdgeInsets.all(15.0),
          // ringColor: Colors.green.shade400,
          ringColor: Colors.green.withAlpha(200),
          // alignment: Alignment.bottomCenter,
          children: <Widget>[
            IconButton(
                icon: const Icon(Icons.arrow_circle_right, color: Colors.white),
                onPressed: () async {
                  _controllers = [];
                  for (var element in listPlayer) {
                    TextEditingController tpm = TextEditingController();
                    tpm.text = element.buyOut != 0 ? element.buyOut.toString() : "";

                    _controllers.add(tpm);
                  }
                  _showBuyOutDialog(context);
                }),
            IconButton(
                icon: const Icon(Icons.live_tv_sharp, color: Colors.white),
                onPressed: () {
                  fabKey.currentState?.close();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Live()));
                }),
            IconButton(
                icon: const Icon(Icons.leaderboard_outlined, color: Colors.white),
                onPressed: () {
                  fabKey.currentState?.close();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Ranking()));
                }),
            IconButton(
                icon: const Icon(Icons.monetization_on_outlined, color: Colors.white),
                onPressed: () {
                  _showUpdatePriceDialog(context);
                }),
            IconButton(
                icon: const Icon(Icons.person_add_outlined, color: Colors.white),
                onPressed: () {
                  _showAddDialog(context);
                }),
            IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () async {
                  fabKey.currentState?.close();
                  final Uri _url = Uri.parse('https://haobv.github.io/hbu-cv/');
                  await launchUrl(_url, mode: LaunchMode.inAppWebView);
                }),
            IconButton(
                icon: const Icon(Icons.refresh_outlined, color: Colors.white),
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Chắc chưa Bro ?'),
                            // content: const Text('AlertDialog description'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  fabKey.currentState?.close();
                                  Navigator.pop(context, 'Cancel');
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  fabKey.currentState?.close();
                                  _reset();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ));
                })
          ]),
      // bottomNavigationBar: CurvedNavigationBar(
      //   key: _bottomNavigationKey,
      //   index: 0,
      //   height: 60.0,
      //   items: <Widget>[
      //     FabCircularMenu(
      //         key: fabKey,
      //         fabOpenIcon: const Icon(Icons.menu, color: Colors.white),
      //         fabCloseIcon: const Icon(Icons.close, color: Colors.white),
      //         ringDiameter: 350.0,
      //         ringWidth: 80.0,
      //         fabMargin: const EdgeInsets.all(15.0),
      //         // ringColor: Colors.green.shade400,
      //         ringColor: Colors.green.withAlpha(200),
      //         alignment: Alignment.bottomCenter,
      //         children: <Widget>[
      //           IconButton(
      //               icon: const Icon(Icons.calculate_rounded, color: Colors.white),
      //               onPressed: () async {
      //                 _controllers = [];
      //                 for (var element in listPlayer) {
      //                   TextEditingController tpm = TextEditingController();
      //                   tpm.text = element.buyOut != 0 ? element.buyOut.toString() : "";
      //
      //                   _controllers.add(tpm);
      //                 }
      //                 _showBuyOutDialog(context);
      //               }),
      //           IconButton(
      //               icon: const Icon(Icons.military_tech, color: Colors.white),
      //               onPressed: () {
      //                 fabKey.currentState?.close();
      //                 Navigator.push(
      //                     context, MaterialPageRoute(builder: (context) => const LeaderBoard()));
      //               }),
      //           IconButton(
      //               icon: const Icon(Icons.list, color: Colors.white),
      //               onPressed: () {
      //                 fabKey.currentState?.close();
      //                 Navigator.push(
      //                     context, MaterialPageRoute(builder: (context) => const Ranking()));
      //               }),
      //           IconButton(
      //               icon: const Icon(Icons.monetization_on_outlined, color: Colors.white),
      //               onPressed: () {
      //                 _showUpdatePriceDialog(context);
      //               }),
      //           IconButton(
      //               icon: const Icon(Icons.add, color: Colors.white),
      //               onPressed: () {
      //                 _showAddDialog(context);
      //               }),
      //           IconButton(
      //               icon: const Icon(Icons.refresh_outlined, color: Colors.white),
      //               onPressed: () {
      //                 showDialog<String>(
      //                     context: context,
      //                     builder: (BuildContext context) => AlertDialog(
      //                           title: const Text('Chắc chưa Bro ?'),
      //                           // content: const Text('AlertDialog description'),
      //                           actions: <Widget>[
      //                             TextButton(
      //                               onPressed: () {
      //                                 fabKey.currentState?.close();
      //                                 Navigator.pop(context, 'Cancel');
      //                               },
      //                               child: const Text('Cancel'),
      //                             ),
      //                             TextButton(
      //                               onPressed: () {
      //                                 fabKey.currentState?.close();
      //                                 _reset();
      //                                 Navigator.of(context).pop();
      //                               },
      //                               child: const Text('OK'),
      //                             ),
      //                           ],
      //                         ));
      //               })
      //         ]),
      //   ],
      //   color: Colors.green,
      //   buttonBackgroundColor: Colors.green,
      //   backgroundColor: Colors.white.withAlpha(20),
      //   animationCurve: Curves.easeInOut,
      //   animationDuration: const Duration(milliseconds: 300),
      //   letIndexChange: (index) => true,
      // ),
    );
  }

  Future<void> init() async {
    deviceId = await _getDeviceUniqueId();
    _deviceRef = FirebaseDatabase.instance.ref('game/$deviceId');
    _gameRef = _deviceRef.child('players');
    _gameSubscription = _gameRef.onValue.listen(
      (DatabaseEvent event) {
        List<Player> newListPlayer = <Player>[];
        for (final player in event.snapshot.children) {
          newListPlayer.add(Player(
              player.key.toString(),
              player.child('name').value.toString(),
              int.parse(player.child('buyIn').value.toString()),
              int.parse(player.child('buyOut').value.toString()),
              int.parse(player.child('total').value.toString()),
              player.child('logo').value.toString()));
        }

        setState(() {
          // Tính tổng bill
          totalBuyOut = 0;
          totalBuyIn = 0;
          for (var element in newListPlayer) {
            totalBuyIn += element.buyIn * buyInPrice;
            totalBuyOut += element.buyOut;
          }
          DatabaseReference _gameRef = _deviceRef.child('config');
          _gameRef.update({
            'totalBuyIn': totalBuyIn,
            'totalBuyOut': totalBuyOut,
          });
          listPlayer.clear();
          listPlayer = newListPlayer;

          listPlayer.sort((a, b) => b.buyIn.compareTo(a.buyIn));
        });
      },
    );
  }

  Future<String> _getDeviceUniqueId() async {
    var deviceIdentifier = 'unknown';
    var deviceInfo = DeviceInfoPlugin();
    var iosInfo = await deviceInfo.iosInfo;
    deviceIdentifier = iosInfo.identifierForVendor!;

    return deviceIdentifier;
  }

  void _doBuyIn(int index, String id) async {
    Timer(const Duration(milliseconds: 100), () {
      _btnControllers[index].success();
    });
    Timer(const Duration(milliseconds: 500), () {
      _btnControllers[index].reset();
    });

    Timer(const Duration(milliseconds: 500), () {
      DatabaseReference _playerRef = _deviceRef.child('players/$id');
      _playerRef.update({'buyIn': listPlayer[index].buyIn += 1});

      //Update time
      _deviceRef.update({'updateTime': DateTime.now().millisecondsSinceEpoch});
    });
  }

  void _reset() {
    setState(() {
      DateTime now = DateTime.now();
      date = now.day.toString() + "/" + now.month.toString();
    });
    listPlayer = [
      Player('', 'Việt Đú', 0, 0, 0, 'viet.png'),
      Player('', 'Khang Đú ', 0, 0, 0, 'vn.png'),
      Player('', 'Hảo Đú', 0, 0, 0, 'sup.png'),
      Player('', 'Khôi Đú', 0, 0, 0, 'khoi.png'),
      Player('', 'Trung Đú', 0, 0, 0, 'wh.png'),
      Player('', 'Phồn Đú', 0, 0, 0, 'phonnt1.png'),
      Player('', 'Lộc Đú', 0, 0, 0, 'les.png'),
      // Player('', 'Khoa Đú', 0, 0, 0, 'icon.png'),
      Player('', 'Tuấn Đú 25', 0, 0, 0, 'tuan25.png'),
      Player('', 'Hưng Đú', 0, 0, 0, 'ars.png'),
      Player('', 'Trường Đú', 0, 0, 0, 'ace.png'),
      // Player('', 'Thắng Đú', 0, 0, 0, 'icon.png'),
      // Player('', 'Tuấn Đú 44', 0, 0, 0, 'icon.png'),
      // Player('', 'Kuminhdey', 0, 0, 0, 'minh.png'),
    ];
    totalBuyIn = 0;
    totalBuyOut = 0;
    _controllers = <TextEditingController>[];

    _deviceRef.child("players").remove();
    // _deviceRef.child("config").remove();
    int i = 0;
    for (var element in listPlayer) {
      DatabaseReference ref = _deviceRef.child("players").push();
      ref.set({
        "name": element.name,
        "buyIn": element.buyIn,
        "buyOut": element.buyOut,
        "total": element.total,
        "logo": element.logo
      });
      i += 1;
    }
    DatabaseReference ref = _deviceRef.child("config");
    ref.update({"total": i});
    ref.update({"totalBuyIn": 0});
    ref.update({"totalBuyOut": 0});
  }

  void _showBuyOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: 500,
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("BUY OUT",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listPlayer.length,
                      itemBuilder: (context, index) {
                        _controllers.add(TextEditingController());
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _controllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: listPlayer[index].name,
                              prefixIcon: const Icon(
                                Icons.monetization_on_rounded,
                                color: Colors.green,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28.0),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28.0),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              hintText: "Tiền trả lại bank",
                            ),
                            onChanged: (text) {
                              String id = listPlayer[index].id;
                              DatabaseReference _playerRef = _deviceRef.child('players/$id');
                              _playerRef
                                  .update({'buyOut': listPlayer[index].buyOut = int.parse(text)});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    children: [
                      RaisedButton(
                        child: const Text("OK"),
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () {
                          // Tính tiền total
                          for (var i = 0; i < listPlayer.length; i++) {
                            String id = listPlayer[i].id;
                            DatabaseReference _playerRef = _deviceRef.child('players/$id');
                            _playerRef.update({
                              'total': (listPlayer[i].buyOut) - (listPlayer[i].buyIn * buyInPrice)
                            });
                          }

                          setState(() {
                            displayResult = true;
                          });
                          fabKey.currentState?.close();
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showAddDialog(BuildContext context) {
    _addController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: 200,
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Add Player",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _addController,
                      decoration: InputDecoration(
                        // labelText: '',
                        // prefixIcon: const Icon(
                        //   Icons.monetization_on_rounded,
                        //   color: Colors.blue,
                        // ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        hintText: "Player Name",
                      ),
                      // onChanged: (text) {
                      //   setState(() {
                      //     listPlayer[index].buyOut = int.parse(text);
                      //   });
                      // },
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    children: [
                      RaisedButton(
                        child: const Text("OK"),
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () {
                          DatabaseReference ref = _deviceRef.child("players").push();
                          ref.set({
                            "name": _addController.text,
                            "buyIn": 0,
                            "buyOut": 0,
                            "total": 0,
                            "logo": 'icon.png'
                          });

                          DatabaseReference configRef = _deviceRef.child("config");
                          configRef.update({"total": listPlayer.length + 1});
                          fabKey.currentState?.close();
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showUpdatePriceDialog(BuildContext context) {
    TextEditingController _updatePriceController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: 200,
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Update Giá Tẩy",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _updatePriceController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        hintText: "1 tẩy =",
                      ),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    children: [
                      RaisedButton(
                        child: const Text("OK"),
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () {
                          fabKey.currentState?.close();
                          setState(() {
                            buyInPrice = int.parse(_updatePriceController.text);
                          });
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
