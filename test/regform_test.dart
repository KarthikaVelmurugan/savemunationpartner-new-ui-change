import 'package:flutter_test/flutter_test.dart';
import 'package:savemynationpartner/formreg.dart';
import 'package:savemynationpartner/loginui.dart';

void main() {
  test('Validation of form1', () {
    String name = "Karthika";
    String mob = "9080517780";
    String address = "newstreet";
    String state = "Tamilnadu";
    String district = "Thanjavur";
    String resname = checkname(name);

    expect(resname, 'Karthika');
    String resmob = checkmob(mob);
    expect(resmob, '9080517780');
    String resadd = checkadd(address);
    expect(resadd, 'newstreet');
    String resstate = checkstate(state);
    expect(resstate, 'Tamilnadu');
    String resdis = checkdistrict(district);
    expect(resdis, 'Thanjavur');
  });
  test('Validation of USer signin or not', () {
    int res = checkauth();
    if (res == 1) {
      print("user not login ");
    } else {
      print("user login successfully");
    }
    expect(res, 0);
  });
}
