import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:savemynationpartner/fadeanim.dart';
import 'package:savemynationpartner/shared.dart';

class DashBoardPage extends StatefulWidget {
  int grocery, food, medicine;

  DashBoardPage({this.grocery, this.food, this.medicine});
  @override
  _DashBoardPage createState() => _DashBoardPage();
}

class _DashBoardPage extends State<DashBoardPage> {
  double height, width;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: height / 1.75,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: height / 1.75,
                    width: width,
                    child: FadeAnimation(
                        1,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background.png'),
                                  fit: BoxFit.fill)),
                        )),
                  ),
                  Positioned(
                    height: height / 1.75,
                    width: width + 20,
                    child: FadeAnimation(
                        1.3,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background-2.png'),
                                  fit: BoxFit.fill)),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      Text(
                        "DashBoard",
                        style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 1),
                            fontWeight: FontWeight.w900,
                            fontSize: width / 20),
                      )),
                  SizedBox(height: 4),
                  FadeAnimation(
                      1.7,
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: <Widget>[
                            _cardConcern('Grocery', widget.grocery / 100),
                            _cardConcern('Food', widget.food / 100),
                            _cardConcern('Medicine', widget.medicine / 100)
                          ])))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _cardConcern(String st, double p) {
    return Container(
        width: width / 3.5,
        height: height / 5,
        child: Card(
          shadowColor: Colors.purple[200],
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(st,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: width / 30,
                            fontWeight: FontWeight.w600))),
                Padding(
                    padding: EdgeInsets.all(2),
                    child: CircularPercentIndicator(
                      radius: 40.0,
                      lineWidth: 4.0,
                      percent: p,
                      center: new Text((p * 100).toString(),
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: width / 40,
                              fontWeight: FontWeight.w600)),
                      progressColor: color,
                    ))
              ]),
        ));
  }
}
