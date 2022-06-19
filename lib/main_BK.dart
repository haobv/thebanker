// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'The Banker'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final List<RoundedLoadingButtonController> _btnControllers =
//       <RoundedLoadingButtonController>[];
//   List<TextEditingController> _controllers = <TextEditingController>[];
//   TextEditingController _addController = TextEditingController();
//   List<Player> listPlayer = <Player>[];
//   int totalBuyIn = 0;
//   int totalBuyOut = 0;
//
//   void _doBuyIn(int index) async {
//     Timer(const Duration(milliseconds: 100), () {
//       _btnControllers[index].success();
//     });
//     Timer(const Duration(milliseconds: 500), () {
//       _btnControllers[index].reset();
//     });
//
//     Timer(const Duration(milliseconds: 500), () {
//       setState(() {
//         listPlayer[index].buyIn += 1;
//         listPlayer.sort((a, b) => b.buyIn.compareTo(a.buyIn));
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   void _init() {
//     listPlayer = [
//       Player('Hưng Đú', 0, 0, 0, 'ars.png'),
//       Player('Việt Đú', 0, 0, 0, 'viet.png'),
//       Player('Trường Đú', 0, 0, 0, 'ace.png'),
//       Player('Khang Đú ', 0, 0, 0, 'vn.png'),
//       Player('Hảo Đú', 0, 0, 0, 'sup.png'),
//       Player('Phồn Đú', 0, 0, 0, 'icon.png'),
//       Player('Khôi Đú', 0, 0, 0, 'icon.png'),
//       Player('Trung Đú', 0, 0, 0, 'wh.png'),
//       Player('Lộc Đú', 0, 0, 0, 'les.png'),
//       Player('Khoa Đú', 0, 0, 0, 'icon.png'),
//       Player('Tuấn Đú 25', 0, 0, 0, 'tuan25.png'),
//       Player('Thắng Đú', 0, 0, 0, 'icon.png'),
//       Player('Tuấn Đú 44', 0, 0, 0, 'icon.png'),
//       Player('Kuminhdey', 0, 0, 0, 'minh.png'),
//     ];
//     totalBuyIn = 0;
//     totalBuyOut = 0;
//     _controllers = <TextEditingController>[];
//   }
//
//   void _showDialog(BuildContext context) {
//     showDialog(
//         // lis.removeWhere((item) => item % 2 == 0);
//         // barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             child: SizedBox(
//               height: 500,
//               child: Column(
//                 children: <Widget>[
//                   const Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: Text("BUY OUT",
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.blue,
//                           fontWeight: FontWeight.w600,
//                         )),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: listPlayer.length,
//                       itemBuilder: (context, index) {
//                         _controllers.add(TextEditingController());
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             controller: _controllers[index],
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               labelText: listPlayer[index].name,
//                               prefixIcon: const Icon(
//                                 Icons.monetization_on_rounded,
//                                 color: Colors.blue,
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(28.0),
//                                 borderSide: const BorderSide(
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(28.0),
//                                 borderSide: const BorderSide(
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               hintText: "Tiền trả lại bank",
//                             ),
//                             onChanged: (text) {
//                               setState(() {
//                                 listPlayer[index].buyOut = int.parse(text);
//                               });
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   ButtonBar(
//                     alignment: MainAxisAlignment.center,
//                     buttonPadding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 10),
//                     children: [
//                       RaisedButton(
//                         child: const Text("OK"),
//                         textColor: Colors.white,
//                         color: Colors.blue,
//                         onPressed: () {
//                           setState(() {
//                             for (var i = 0; i < listPlayer.length; i++) {
//                               listPlayer[i].total = (listPlayer[i].buyOut) -
//                                   (listPlayer[i].buyIn * 200);
//                             }
//                             // listPlayer
//                             //     .sort((a, b) => (b.buyIn.compareTo(a.buyIn)));
//                             // // listPlayer.sort((a, b) => (b.buyIn));
//
//                             totalBuyOut = 0;
//                             totalBuyIn = 0;
//                             for (var element in listPlayer) {
//                               totalBuyIn += element.buyIn * 200;
//                               totalBuyOut += element.buyOut;
//                             }
//                           });
//                           Navigator.pop(context, true);
//                         },
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   void _showAddDialog(BuildContext context) {
//     _addController = TextEditingController();
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             child: SizedBox(
//               height: 200,
//               child: Column(
//                 children: <Widget>[
//                   const Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: Text("Add Player",
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.blue,
//                           fontWeight: FontWeight.w600,
//                         )),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _addController,
//                       decoration: InputDecoration(
//                         // labelText: '',
//                         // prefixIcon: const Icon(
//                         //   Icons.monetization_on_rounded,
//                         //   color: Colors.blue,
//                         // ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(28.0),
//                           borderSide: const BorderSide(
//                             color: Colors.blue,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(28.0),
//                           borderSide: const BorderSide(
//                             color: Colors.blue,
//                           ),
//                         ),
//                         hintText: "Player Name",
//                       ),
//                       // onChanged: (text) {
//                       //   setState(() {
//                       //     listPlayer[index].buyOut = int.parse(text);
//                       //   });
//                       // },
//                     ),
//                   ),
//                   ButtonBar(
//                     alignment: MainAxisAlignment.center,
//                     buttonPadding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 10),
//                     children: [
//                       RaisedButton(
//                         child: const Text("OK"),
//                         textColor: Colors.white,
//                         color: Colors.blue,
//                         onPressed: () {
//                           setState(() {
//                             listPlayer.add(Player(
//                                 _addController.text, 0, 0, 0, 'icon.png'));
//                           });
//                           Navigator.pop(context, true);
//                         },
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.add),
//           onPressed: () {
//             // listPlayer.removeWhere((element) => element.total <= 0);
//             _showAddDialog(context);
//           },
//         ),
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Column(
//           children: [
//             Text(widget.title),
//             Text(
//               totalBuyOut > 0 ? '(+ $totalBuyIn   - $totalBuyOut)' : '',
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 height: 1.7,
//               ),
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.refresh_sharp),
//             onPressed: () => showDialog<String>(
//               context: context,
//               builder: (BuildContext context) => AlertDialog(
//                 title: const Text('Chắc chưa Bro ?'),
//                 // content: const Text('AlertDialog description'),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, 'Cancel'),
//                     child: const Text('Cancel'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _init();
//                       });
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('OK'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Expanded(
//               // height: MediaQuery.of(context).size.height,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.all(3),
//                 scrollDirection: Axis.vertical,
//                 itemCount: listPlayer.length,
//                 itemBuilder: (context, index) {
//                   int buyOut = listPlayer[index].buyOut;
//                   String logo = 'assets/logo/' + listPlayer[index].logo;
//                   _btnControllers.add(RoundedLoadingButtonController());
//                   return SizedBox(
//                     // height: 70,
//                     child: Card(
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage: AssetImage(logo),
//                           backgroundColor: Colors.white,
//                         ),
//                         title: Text(
//                           listPlayer[index].name,
//                           style: const TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.bold,
//                             // height: 1,
//                           ),
//                         ),
//                         subtitle: Row(
//                           children: [
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.15,
//                               child: Text(
//                                 '+ ' + listPlayer[index].buyIn.toString(),
//                                 style: const TextStyle(
//                                   fontSize: 17,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.2,
//                               child: Text(
//                                 (buyOut > 0) ? "-\$" + buyOut.toString() : "",
//                                 style: const TextStyle(
//                                   fontSize: 17,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               (listPlayer[index].total != 0)
//                                   ? "\$" + listPlayer[index].total.toString()
//                                   : "",
//                               style: TextStyle(
//                                 fontSize: 17,
//                                 color: (listPlayer[index].total > 0)
//                                     ? Colors.green
//                                     : Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing: SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.05,
//                           width: MediaQuery.of(context).size.width * 0.15,
//                           child: RoundedLoadingButton(
//                             child: const Icon(
//                               Icons.plus_one_rounded,
//                               color: Colors.white,
//                             ),
//                             controller: _btnControllers[index],
//                             onPressed: () => _doBuyIn(index),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // listPlayer.removeWhere((element) => element.total <= 0);
//           _controllers = [];
//           for (var element in listPlayer) {
//             TextEditingController tpm = TextEditingController();
//             tpm.text = element.buyOut != 0 ? element.buyOut.toString() : "";
//
//             _controllers.add(tpm);
//           }
//           _showDialog(context);
//         },
//         child: const Icon(Icons.calculate_rounded),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
//
// class Player {
//   String name;
//   int buyIn;
//   int buyOut;
//   int total;
//   String logo;
//
//   Player(this.name, this.buyIn, this.buyOut, this.total, this.logo);
//
//   @override
//   String toString() {
//     return '{ ${this.name}, ${this.total} }';
//   }
// }
