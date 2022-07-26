import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restful_api/constant.dart';
import 'model_mahasiswa.dart';
import 'mahasiswa_update.dart';
import 'mahasiswa_upload_image.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String baseUrl = Constants.baseUrl;
  List<Mahasiswa> listMahasiswa = [];
  Future getData() async {
    listMahasiswa = [];
    String url = "$baseUrl/mahasiswa";
    var response = await http.get(Uri.parse(url));
    // await //menunggu
    print(response.body);
    final data = jsonDecode(response.body);
    for (Map i in data) {
      listMahasiswa.add(Mahasiswa.fromJson(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBar myAppBar = AppBar(
      title: const Text('Daftar Mahasiswa'),
      centerTitle: true,
      elevation: 0,
    );
    double heightBody = MediaQuery.of(context).size.height -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    double widthBody = MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'mahasiswa_tambah');
          },
          child: Icon(Icons.add),
        ),
        appBar: myAppBar,
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                padding: EdgeInsets.only(top: 20),
                child: ListView.builder(
                    itemCount: listMahasiswa.length,
                    itemBuilder: ((context, index) {
                      final mahasiswa = listMahasiswa[index];
                      if (listMahasiswa.length > 0) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Card(
                            child: ListTile(
                              // FOTO MAHASISWA
                              leading: CircleAvatar(
                                  // backgroundColor: Colors.blueAccent,
                                  backgroundImage: mahasiswa.foto == ''
                                      ? const AssetImage(
                                          'assets/images/no-image.jpg')
                                      : NetworkImage(
                                              "$baseUrl/${mahasiswa.foto}")
                                          as ImageProvider),
                              // NAMA MAHASISWA
                              title: Text(
                                mahasiswa.namaMahasiswa,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                children: [
                                  // NIM MAHASISWA
                                  Row(
                                    children: [
                                      Text("NIM : "),
                                      Text(mahasiswa.nim)
                                    ],
                                  ),
                                  // PROGRAM STUDI
                                  Row(
                                    children: [
                                      Text("Program Studi : "),
                                      Text(mahasiswa.programStudi)
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        loadUploadImage(mahasiswa);
                                      },
                                      icon: const Icon(
                                        Icons.upload,
                                        color:
                                            Color.fromARGB(255, 16, 143, 247),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        loadEdit(mahasiswa);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        confirmHapus(mahasiswa);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("Data tidak ditemukan"),
                        );
                      }
                    })),
              );
            }
          },
        ));
  }

  loadEdit(mahasiswa) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MahasiswaUpdate(
                  mahasiswa: mahasiswa,
                )));
  }

  bool _isShown = true;
  confirmHapus(mahasiswa) {
    print(mahasiswa.namaMahasiswa);
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: Text("Apakah Anda Yakin Menghapus " +
                mahasiswa.namaMahasiswa +
                " ?"),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    setState(() {
                      _isShown = false;
                    });
                    loadHapus(mahasiswa);
                    // Close the dialog
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: const Text('Ya')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tidak'))
            ],
          );
        });
  }

  loadHapus(mahasiswa) async {
    String url = Constants.baseUrl + '/mahasiswa/' + mahasiswa.nim;
    var response = await http.delete(Uri.parse(url));
    print(response.body);
    Map<String, dynamic> data =
        json.decode(response.body); //mengubah JSON menjadi MAP
    if (data['status'] == 200) {
      final snackBar = SnackBar(
        content: const Text('Data Berhasil Dihapus'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    }
  }

  loadUploadImage(mahasiswa) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MahasiswaUploadImage(
                  mahasiswa: mahasiswa,
                )));
  }
}
