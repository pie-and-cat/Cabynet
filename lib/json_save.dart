import 'package:cabynet/parser.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  JsonLoad jl = JsonLoad();
  var sched = jl.load();
  print(sched);
  print(sched.runtimeType);
  print(sched[0].rx);
  //print(s.save());
  //print(Directory.current.path);
}

class JsonSave {
  List<Prescription> scriptList = List.empty(growable: true);
  JsonSave() {
    JsonLoad l = new JsonLoad();
    scriptList = l.load();
  }

  addPrescription(Prescription p) {
    //  Saves parsed prescriptions into a .JSON file saved locally
    scriptList.add(p);
  }

  save() {
    // Map<int, String> list = {};
    // int i = 0;
    // for (Prescription p in scriptList) {
    //   list[i] = json.encode(p.toJson());
    //   i++;
    // }

    // Oh this is STUPID stupid
    String sprawl = "";
    for (Prescription p in scriptList) {
      sprawl += (json.encode(p.toJson()) + "\n");
    }

    final File f = File(Directory.current.path + "/lib/scripts.txt");
    f.writeAsString(sprawl);
    return sprawl;
  }
}

class JsonLoad {
  List<Prescription> scriptList = List.empty(growable: true);
  JsonLoad();

  List<Prescription> load() {
    var path = Directory.current.path + "/lib/scripts.txt";
    List<dynamic> parseList = List.empty(growable: true);
    //new File(path)
    //    .openRead()
    //    .transform(utf8.decoder)
    //    .transform(new LineSplitter())
    //    .forEach((l) => parseList.add(l));
    //print(parseList);
    File f = File(path);
    for (String s in f.readAsLinesSync()) {
      scriptList.add(_unroll(json.decode(s)));
    }
    return scriptList;
  }

  Prescription _unroll(Map l) {
    PrescriptionBuilder pb = PrescriptionBuilder(l['name'], l['rx']);
    pb.amt = l['amt'].toString();
    pb.timeframe = l['timeframe'];
    pb.qt = l['qt'];
    pb.unit = l['unit'];
    return pb.build();
  }
}
