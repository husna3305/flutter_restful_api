import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'homepage.dart';
import 'model_mahasiswa.dart';

class MahasiswaUpdate extends StatefulWidget {
  final Mahasiswa mahasiswa;
  const MahasiswaUpdate({Key? key, required this.mahasiswa}) : super(key: key);

  @override
  State<MahasiswaUpdate> createState() => _MahasiswaUpdateState();
}

enum ListJenisKelamin { L, P }

class _MahasiswaUpdateState extends State<MahasiswaUpdate> {
  var nimMahasiswa, namaMahasiswa, programStudi, alamatMahasiswa;
  ListJenisKelamin jenisKelaminMahasiswa = ListJenisKelamin.L;
  final formKey = GlobalKey<FormState>();
  //formKey : identifier untuk sebuah form yang nantinya dapat kita gunakan untuk validasi, dll.

  var nimMahasiswaController = TextEditingController();
  var namaMahasiswaController = TextEditingController();
  var programStudiController = TextEditingController();
  var alamatMahasiswaController = TextEditingController();

  @override
  void initState() {
    setState(() {
      print(widget.mahasiswa);
      nimMahasiswaController.text = widget.mahasiswa.nim;
      namaMahasiswaController.text = widget.mahasiswa.namaMahasiswa;
      programStudiController.text = widget.mahasiswa.programStudi;
      alamatMahasiswaController.text = widget.mahasiswa.alamat;
      jenisKelaminMahasiswa = widget.mahasiswa.jenisKelamin == 'Laki-laki'
          ? ListJenisKelamin.L
          : ListJenisKelamin.P;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar myAppBar = AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // onPressed: () => Navigator.of(context).pop(),
          onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                ),
              }),
      title: const Text('Update Data Mahasiswa'),
      centerTitle: true,
      elevation: 0,
    );
    double heightBody = MediaQuery.of(context).size.height -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    double widthBody = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: myAppBar,
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: nimMahasiswaController,
                decoration: new InputDecoration(
                  hintText: "Masukkan NIM Mahasiswa",
                  labelText: "NIM Mahasiswa",
                  icon: Icon(Icons.people),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'NIM tidak boleh kosong';
                  }
                },
                onSaved: (value) => nimMahasiswa = value,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: namaMahasiswaController,
                decoration: new InputDecoration(
                  hintText: "Masukkan Nama Mahasiswa",
                  labelText: "Nama Mahasiswa",
                  icon: Icon(Icons.people),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                },
                onSaved: (value) => namaMahasiswa = value,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Align(
                    alignment: Alignment.topLeft, child: Text("Jenis Kelamin")),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<ListJenisKelamin>(
                      title: const Text('Laki-laki'),
                      value: ListJenisKelamin.L,
                      groupValue: jenisKelaminMahasiswa,
                      onChanged: (ListJenisKelamin? value) {
                        setState(() {
                          jenisKelaminMahasiswa = value!;
                        });
                      },
                    ), // <-- Wrapped in Expanded.
                  ),
                  Expanded(
                    child: RadioListTile<ListJenisKelamin>(
                      title: const Text('Perempuan'),
                      value: ListJenisKelamin.P,
                      groupValue: jenisKelaminMahasiswa,
                      onChanged: (ListJenisKelamin? value) {
                        setState(() {
                          jenisKelaminMahasiswa = value!;
                        });
                      },
                    ), // <-- Wrapped in Expanded.
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: programStudiController,
                decoration: new InputDecoration(
                  hintText: "Masukkan Program Studi Mahasiswa",
                  labelText: "Program Studi Mahasiswa",
                  icon: Icon(Icons.people),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Program studi tidak boleh kosong';
                  }
                },
                onSaved: (value) => programStudi = value,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: alamatMahasiswaController,
                decoration: new InputDecoration(
                  hintText: "Masukkan Alamat Mahasiswa",
                  labelText: "Alamat Mahasiswa",
                  icon: Icon(Icons.people),
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                },
                onSaved: (value) => alamatMahasiswa = value,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    validasiForm();
                  },
                  child: Text('UPDATE DATA')),
            ],
          ),
        ),
      ),
    );
  }

  validasiForm() {
    final currentForm = formKey.currentState;
    if (currentForm!.validate()) {
      currentForm.save();
      // print("$email, $password");
      prosesSimpan();
    }
  }

  void prosesSimpan() async {
    String url = Constants.baseUrl + '/mahasiswa/' + widget.mahasiswa.nim;
    var response = await http.put(Uri.parse(url), body: {
      "nim": nimMahasiswa,
      "nama_mahasiswa": namaMahasiswa,
      "program_studi": programStudi,
      "alamat": alamatMahasiswa,
      "jenis_kelamin": jenisKelaminMahasiswa == ListJenisKelamin.L
          ? "Laki-laki"
          : "Perempuan",
    });
    print(response.body);
    Map<String, dynamic> data =
        json.decode(response.body); //mengubah JSON menjadi MAP
    if (data['status'] == 200) {
      final snackBar = SnackBar(
        content: const Text('Data Berhasil Diubah'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
