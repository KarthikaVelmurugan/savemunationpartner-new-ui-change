import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:savemynationpartner/condata.dart';
import 'package:savemynationpartner/globals.dart';
import 'package:savemynationpartner/loading.dart';
import 'package:savemynationpartner/shared.dart';
import 'package:savemynationpartner/concernsbg.dart';
import 'package:savemynationpartner/view.dart';

class Grocery extends StatefulWidget {
  List grocery = [];
  Grocery({this.grocery});
  @override
  _Grocery createState() => _Grocery();
}

class _Grocery extends State<Grocery> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double ht, wt;
  void initState() {
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(seconds: 1),
    );

    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    ht = queryData.size.height;
    wt = queryData.size.width;

    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
      Background(
        child: loading ? Center(child: Loading()) : makebody1(),
      )
    ])));
  }

  Widget makeBody() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width / 25,
          horizontal: MediaQuery.of(context).size.width / 30),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.grocery.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(widget.grocery[index]);
      },
    );
  }

  Widget makeCard(ConData con) {
    return InkWell(
      child: Container(
          margin: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
          child: Card(
            elevation: 20,
            shadowColor: Colors.deepPurple[400],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: makeListTile1(con),
          )),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPage(
                    con.name,
                    con.mobile,
                    con.address,
                    con.district,
                    con.state,
                    con.type,
                    con.comments,
                    con.devicelatitude,
                    con.devicelongitude)));
      },
    );
  }

  Widget makeListTile1(ConData con) {
    return ListTile(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      SizedBox(
        width: 10,
      ),
      Image.asset('assets/icons/gro.jpg', height: 30, width: 30),

      /*  CircleAvatar(
        backgroundImage: AssetImage('assets/grocery.jpeg'),
        radius: 30,
        backgroundColor: Color.fromRGBO(0, 74, 173, 1),
      ),*/
      SizedBox(width: 8),
      Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                con.name,
                style:
                    TextStyle(fontSize: wt / 30, fontWeight: FontWeight.w900),
              ),
              Text(
                con.address + "," + con.district + ".",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: wt / 40),
              ),
            ]),
      ),
      InkWell(
        child:
            Image.asset('assets/icons/arrowright.png', height: 20, width: 20),
        onTap: () async {
          // _controller.forward();
          print("concerns latitude:${con.devicelatitude}");
          print("concerns longititude:${con.devicelongitude}");
          /*  Fluttertoast.showToast(
              msg: 'You can view ' + con.name + 'Location and Profile',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.blue,
              fontSize: wt / 28);*/

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewPage(
                      con.name,
                      con.mobile,
                      con.address,
                      con.district,
                      con.state,
                      con.type,
                      con.comments,
                      con.devicelatitude,
                      con.devicelongitude)));
        },
      )
    ]));
  }

  Widget makebody1() {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 20, top: 50, right: wt / 1.5),
        child: groceryText(wt),
      ),
      makeBody()
    ]);
  }

  Widget groceryText(double wt) {
    return /*Container(
        child: Positioned(
            top: 35,
            left: 20,
            bottom: ht / 2,
            right: wt / 1.75,
            child:*/
        Text(
      "Grocery",
      style: TextStyle(
          color: Color.fromRGBO(49, 39, 79, 1),
          fontWeight: FontWeight.w900,
          fontSize: wt / 20 //_large? 60 : (_medium? 50 : 40),
          ),
    );
  }
}
