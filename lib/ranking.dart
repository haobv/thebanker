import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/playerRanking.dart';

import 'models/player.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  List<PlayerRanking> _topOther = <PlayerRanking>[];
  late PlayerRanking _top1 = PlayerRanking(1, "Loading...", 0, "assets/logo/icon.png");
  late PlayerRanking _top2 = PlayerRanking(1, "Loading...", 0, "assets/logo/icon.png");
  late PlayerRanking _top3 = PlayerRanking(1, "Loading...", 0, "assets/logo/icon.png");

  @override
  void initState() {
    _getRanking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ranking',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                // height: 1.7,
              )),
        ),
        body: Container(
            color: Colors.white10,
            child: Column(children: <Widget>[
              Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height * 0.3,
                    child: Container(
                      // decoration: const BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage("assets/top.png"),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      color: Colors.white,
                      padding: const EdgeInsets.only(left: 15, top: 30, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "2",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'nd',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Material(
                                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                                  elevation: 30,
                                  child: Container(
                                    // margin: const EdgeInsets.all(2),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(width: 2, color: Colors.black)),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(_top2.logo),
                                      backgroundColor: Colors.white,
                                      minRadius: 30,
                                    ),
                                  )),
                              Text(
                                _top2.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 2,
                                ),
                              ),
                              Text(
                                _top2.total.toString(),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  // height: 2,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "1",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'st',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Material(
                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                  elevation: 30,
                                  child: Container(
                                    // margin: const EdgeInsets.all(2),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(width: 2, color: Colors.black)),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(_top1.logo),
                                      backgroundColor: Colors.white,
                                      minRadius: 50,
                                    ),
                                  )),
                              Text(
                                _top1.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 2,
                                ),
                              ),
                              Text(
                                _top1.total.toString(),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  // height: 2,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "3",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'th',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Material(
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  elevation: 30,
                                  child: Container(
                                    // margin: const EdgeInsets.all(2),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(width: 2, color: Colors.black)),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(_top3.logo),
                                      backgroundColor: Colors.white,
                                      minRadius: 30,
                                    ),
                                  )),
                              Text(
                                _top3.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 2,
                                ),
                              ),
                              Text(
                                _top3.total.toString(),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  // height: 2,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(30),
                  scrollDirection: Axis.vertical,
                  itemCount: _topOther.length,
                  itemBuilder: (context, index) {
                    int ranking = _topOther[index].rank;
                    int total = _topOther[index].total;
                    String logo = _topOther[index].logo;
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
                                    radius: 15,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Text(
                                      _topOther[index].name,
                                      style: const TextStyle(
                                        fontSize: 15,
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
                                total.toString(),
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: (_topOther[index].total > 0) ? Colors.green : Colors.red,
                                ),
                              ),
                              const Text(
                                'VND',
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
            ])));
  }

  void _getRanking() {
    var db =
        FirebaseDatabase.instance.ref('1Vam9ZOWq5f9pGIWXUBLa-KNLzWXxtC8_OTHnBsd-tLA').child('Sync');
    var _rankingSubscription = db.onValue.listen(
      (DatabaseEvent event) {
        setState(() {
          List<PlayerRanking> newList = <PlayerRanking>[];

          for (final player in event.snapshot.children) {
            var playerRank = PlayerRanking(
                int.parse(player.child('Id').value.toString()),
                player.child('Name').value.toString(),
                int.parse(player.child('Total').value.toString()),
                player.child('Logo').value.toString());
            switch (playerRank.rank) {
              case 1:
                _top1 = playerRank;
                break;
              case 2:
                _top2 = playerRank;
                break;
              case 3:
                _top3 = playerRank;
                break;
              default:
                newList.add(playerRank);
            }
          }
          _topOther = newList;
        });
      },
    );
  }
}
