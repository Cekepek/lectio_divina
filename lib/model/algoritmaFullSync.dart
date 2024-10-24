// Future<void> loadLd() async {
//     int id = globals.userLogin.id;
//     print(globals.userLogin.id);

//     final prefs = await SharedPreferences.getInstance();
//     final String ldsstring =
//         await prefs.getString('lds_data_${globals.userLogin.id}') ?? "";
//     final body = jsonEncode({"id_user": id});
//     final response = await api.connectApi('/sinkronasi', 'post', body);
//     if (response.status == 200) {
//       print("MASUK");
//       print(response.data);
//       if (response.message == 'berhasil') {
//         if (ldsstring != "") {
//           print(ldsstring);
//           final List<LD> ldList = LD.decode(ldsstring);
//           ldList.sort((a, b) => a.tanggal.compareTo(b.tanggal));
//           Map<String, dynamic> tanggalSinkron = {
//             "tanggalAwalDb": DateFormat("yyyy-MM-dd HH:mm:ss")
//                 .format(DateTime.parse(response.data[0]["first_date"])),
//             "tanggalAkhirDb": DateFormat("yyyy-MM-dd HH:mm:ss")
//                 .format(DateTime.parse(response.data[0]["last_date"])),
//             "tanggalAwalApp":
//                 DateFormat("yyyy-MM-dd HH:mm:ss").format(ldList.last.tanggal),
//             "tanggalAkhirApp":
//                 DateFormat("yyyy-MM-dd HH:mm:ss").format(ldList.first.tanggal)
//           };
//           print(tanggalSinkron);
//           DateTime tanggalAwal = DateTime.parse(tanggalSinkron["tanggalAwalDb"])
//                   .isAfter(DateTime.parse(tanggalSinkron["tanggalAwalApp"]))
//               ? DateTime.parse(tanggalSinkron["tanggalAwalDb"])
//               : DateTime.parse(tanggalSinkron["tanggalAwalApp"]);
//           DateTime tanggalAkhir =
//               DateTime.parse(tanggalSinkron["tanggalAkhirDb"]).isBefore(
//                       DateTime.parse(tanggalSinkron["tanggalAkhirApp"]))
//                   ? DateTime.parse(tanggalSinkron["tanggalAkhirDb"])
//                   : DateTime.parse(tanggalSinkron["tanggalAkhirApp"]);
//           debugPrint("tanggal Awal $tanggalAwal");
//           debugPrint("tanggal Akhir $tanggalAkhir");
//           final body = jsonEncode({
//             'tanggal_awal': tanggalAwal.toString(),
//             'tanggal_akhir': tanggalAkhir.toString(),
//             'id_user': globals.userLogin.id.toString()
//           });
//           final response2 = await api.connectApi(
//               '/lectio_divina/$tanggalAwal/$tanggalAkhir/$id', 'get', null);
//           final List<LD> listLDDB = LD.decode(LD.encode(response2.data));
//           for (LD ld in listLDDB) {
//             for (LD ld2 in ldList) {}
//           }
//           print(response2.data);

//           setState(() {
//             globals.MyLd = ldList;
//           });
//         } else {
//           print("Gagal");
//         }
//       } else {
//         throw Exception('Failed to read API');
//       }
//     }
//   }