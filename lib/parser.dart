import 'dart:math';

Prescription? parser(String x){
  final List<String> tokens = List.from(["qt","rx","quantity","qty","take"],growable: false);
  final List<String> unitTokens = List.from(["pill","tablet","drop","daily","weekly","capsule","times"],growable: false);
  final List<String> numericTokens = List.from(["one","two","three","four","five","six","eight","nine","ten",
    "once","twice","thrice"],growable: false);
  List<String> matched = List.empty(growable: true);
  x = x.toLowerCase();
  String? name = null;
  var y = x.codeUnits;
  int i = 0;
  while(i < y.length){
    if(isLetter(y[i])) {
      int j = i;
      //find complete string for token
      while (i < y.length) {
        if (!isLetter(y[i])) {
          break;
        }
        i++;
      }
      String temp = x.substring(j, i);
      print(temp);
      //find token that this could possibly be
      int token = findToken(temp, tokens);
      //threshold for similarity of tokens is 33% different
      if (lev(temp, tokens[token]) <= temp.length ~/ 3) {
        int j = i;
        //while within 3 characters of token
        while (i < y.length && i - j < 3) {
          if (isDigit(y[i])) {
            break;
          }
          i++;
        }
        //flush if not within 3 characters
        if (i - j >= 3) {
          i = j;
          continue;
        }
        j = i;
        while (i < y.length && isDigit(y[i])) {
          i++;
        }
        String temp2 = x.substring(j, i);
        matched.addAll([tokens[token], temp2]);
        continue;
      }
      token = findToken(temp, numericTokens);
      if(lev(temp,numericTokens[token]) <= temp.length~/3){
        int j = i;
        //while within 3 characters of token
        while(i < y.length && i-j<3){
          if(isLetter(y[i])){
            break;
          }
          i++;
        }
        //flush if not within 3 characters
        if(i-j>=3){
          i = j;
          continue;
        }
        j = i;
        while(i<y.length && isLetter(y[i])){
          i++;
        }
        int t2 = findToken(x.substring(j,i), unitTokens);
        if(lev(x.substring(j,i),unitTokens[t2]) > (i-j)~/3){
          continue;
        }
        matched.addAll([numericTokens[token],unitTokens[t2]]);
        continue;
      }
      token = findToken(temp, unitTokens);
      if(lev(temp,unitTokens[token]) <= temp.length~/3){
        matched.insert(0, unitTokens[token]);
        continue;
      }

      j = i;
      //while within 5 characters of token
      while (i < y.length && i - j < 5) {
        if (isDigit(y[i])) {
          break;
        }
        i++;
      }
      if (i - j >= 5) {
        i = j;
        continue;
      }
      while (i < y.length && isDigit(y[i])) {
        i++;
      }

      j = i;
      while (i < y.length && i - j < 4) {
        if (isLetter(y[i])) {
          break;
        }
        i++;
      }
      if (i - j >= 4) {
        i = j;
        continue;
      }
      j=i;
      while (i < y.length && isLetter(y[i])) {
        i++;
      }
      if(lev(x.substring(j,i), "mg") < 2 || x.substring(j,i).contains("mg")){
        name = temp;
      }
    }
    if(i<y.length && isDigit(y[i])){
      int j = i;
      while(i < y.length){
        if(!isDigit(y[i])){
          break;
        }
        i++;
      }
      String temp = x.substring(j,i);

      j = i;
      //while within 3 characters of token
      while(i < y.length && i-j<3){
        if(isLetter(y[i])){
          break;
        }
        i++;
      }
      //flush if not within 3 characters
      if(i-j>=3){
        i = j;
        continue;
      }
      j = i;
      while(i<y.length && isLetter(y[i])){
        i++;
      }
      int token = findToken(x.substring(j,i), unitTokens);
      if(lev(x.substring(j,i),unitTokens[token]) > (i-j)~/3){
        continue;
      }
      matched.addAll([temp,unitTokens[token]]);
    }
    i++;
  }
  if(name == null || !matched.contains("rx")){
    return null;
  }else{
    PrescriptionBuilder pb = PrescriptionBuilder(name,matched[matched.indexOf("rx")+1]);
    i = 0;
    if("daily weekly".contains(matched[0])){
      pb.timeframe = matched[0];
      i = 1;
    }
    for(i; i<matched.length; i+=2){
      if(matched[i].compareTo("rx") == 0){
        continue;
      }
      if(tokens.contains(matched[i])){
        pb.qt = int.parse(matched[i+1]);
        continue;
      }
      if(numericTokens.contains(matched[i])){
        pb.amt = matched[i];
        pb.unit = matched[i+1];
      }
    }
    return pb.build();
  }

}


int findToken(String a, List<String> b){
  int result = -1;
  int dist = 100;
  for(int i =0; i<b.length; i++){
    int temp = lev(a,b[i]);
    if(temp<dist){
      dist = temp;
      result = i;
    }
  }
  return result;
}

//helper methods for determining if letter or digits
bool isLetter(int codeUnit) =>
    (codeUnit >= 65 && codeUnit <= 90) || (codeUnit >= 97 && codeUnit <= 122);

bool isDigit(int codeUnit) =>
    (codeUnit >= 48 && codeUnit <= 57);

//helper method to compute similarity between strings
//for usage in matching text read by OCR to tokens
int lev(String a, String b){
  if(a.length == 0){
    return b.length;
  }
  if(b.length == 0){
    return a.length;
  }
  if(a.codeUnitAt(0) == b.codeUnitAt(0)){
    return(lev(a.substring(1,a.length),b.substring(1,b.length)));
  }
  int c = lev(a.substring(1,a.length),b);
  c = min(lev(a,b.substring(1,b.length)),c);
  c = min(c,lev(a.substring(1,a.length),b.substring(1,b.length)));
  return (c+1);
}

//Prescription class to build Prescription object
//uses the PrescriptionBuilder to simplify
//uses Dart's Cascade notation of building objects
class Prescription {
  final String name;
  final String rx;
  final String? amt;
  final String? unit;
  final String? timeframe;
  final int? qt;

  Prescription._builder(PrescriptionBuilder builder):
        rx = builder.rx,
        amt = builder.amt,
        unit = builder.unit,
        timeframe = builder.timeframe,
        name = builder.name,
        qt = builder.qt;

}

//PrescriptionBuilder object to build Prescription objects
//setter methods can be declared as needed
//to use setter methods must call setter in build e.g.
//Prescription a = (PrescriptionBuilder(med_name,rx_num)
//                 ..setter_method_name(args)).build();
class PrescriptionBuilder {
  final String name;
  final String rx;
  String? amt;
  String? unit;
  String? timeframe;
  int? qt;

  PrescriptionBuilder(this.name, this.rx);
  //create special setter functions here if needed

  Prescription build(){
    return Prescription._builder(this);
  }
}