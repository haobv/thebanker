import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models/player.dart';

class Live extends StatefulWidget {
  const Live({Key? key}) : super(key: key);

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  List<Player> leaderBoard = <Player>[];
  final _listDeviceId = [];
  final _listDeviceName = [];
  late DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref('864430F4-3EA5-4C3D-AB00-C377AD173C19');
  String title = 'LIVE';
  @override
  void initState() {
    // _getListDevice();
    _initLeaderBoard();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _initLeaderBoard() async {
    final lastUpdateGame =
        FirebaseDatabase.instance.ref('game').orderByChild('updateTime').limitToLast(1);
    //
    // var _deviceId = lastUpdateGame.get();
    // var _gameRef = ref.child(_deviceId);
    var _gameSubscription = lastUpdateGame.onValue.listen(
      (DatabaseEvent event) {
        // event.snapshot.children.first.children
        List<Player> newList = <Player>[];
        for (final player in event.snapshot.children.last.child('players').children) {
          newList.add(Player(
              player.key.toString(),
              player.child('name').value.toString(),
              int.parse(player.child('buyIn').value.toString()),
              int.parse(player.child('buyOut').value.toString()),
              int.parse(player.child('total').value.toString()),
              player.child('logo').value.toString()));
        }
        newList.removeWhere((a) => a.buyIn == 0);
        newList.sort((a, b) => b.buyIn.compareTo(a.buyIn));
        if (mounted) {
          setState(() {
            leaderBoard.clear();
            leaderBoard = newList;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              // height: 1.7,
            ),
          ),
          // actions: <Widget>[
          //   IconButton(
          //       onPressed: () {
          //         _getListDevice();
          //         _changeList(context);
          //       },
          //       icon: const Icon(
          //         Icons.change_circle,
          //         size: 30,
          //         color: Colors.white,
          //       ))
          // ]),
        ),
        body: Column(children: <Widget>[
          Expanded(
            // height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(3),
              scrollDirection: Axis.vertical,
              itemCount: leaderBoard.length,
              itemBuilder: (context, index) {
                int buyOut = leaderBoard[index].buyOut;
                int ranking = index + 1;
                String logo = 'assets/logo/' + leaderBoard[index].logo;
                return Card(
                  shape: const StadiumBorder(
                      side: BorderSide(
                    color: Colors.black26,
                    width: 1.0,
                  )),
                  elevation: 10,
                  child: ListTile(
                      leading: Text(
                        '#$ranking',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          // height: 1,
                        ),
                      ),
                      title: Row(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(logo),
                                backgroundColor: Colors.white,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  leaderBoard[index].name,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    // height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leaderBoard[index].buyIn.toString(),
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Tẩy',
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
        ]));
  }

  _changeList(BuildContext context) {
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
                    child: Text("Select Device",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _listDeviceId.length,
                      itemBuilder: (context, index) {
                        String deviceName = _listDeviceName[index];
                        String deviceID = _listDeviceId[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              title: Text('Device $index',
                                  style:
                                      const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              subtitle: Text(deviceName),
                              trailing: const Icon(Icons.check_circle, color: Colors.green),
                              onTap: () {
                                _dbRef = FirebaseDatabase.instance.ref(deviceID);
                                _initLeaderBoard();
                                setState(() {
                                  title = deviceName;
                                });
                                Navigator.pop(context);
                              }),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _getListDevice() async {
    // DatabaseReference dbRef = FirebaseDatabase.instance.ref('game').orderByChild('updateTime').ref;
    var dbRef = FirebaseDatabase.instance.ref('game').orderByChild('updateTime');
    final snapshot = await dbRef.get();
    if (snapshot.exists) {
      _listDeviceId.clear();
      _listDeviceName.clear();
      for (var element in snapshot.children) {
        _listDeviceId.add(element.key.toString());
        _listDeviceName.add(element.child('updateTime').exists
            ? _getDisplayTime(element.child('updateTime').value.toString())
            : element.key.toString());
      }
    }
  }

  _getDisplayTime(String epochTime) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(epochTime));
    return date.toString();
  }
}
