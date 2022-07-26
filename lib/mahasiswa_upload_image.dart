import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'homepage.dart';
import 'model_mahasiswa.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:universal_io/io.dart';

class MahasiswaUploadImage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  const MahasiswaUploadImage({Key? key, required this.mahasiswa})
      : super(key: key);

  @override
  State<MahasiswaUploadImage> createState() => _MahasiswaUploadImageState();
}

enum ListJenisKelamin { L, P }

class _MahasiswaUploadImageState extends State<MahasiswaUploadImage> {
  var nimMahasiswa, namaMahasiswa, programStudi, alamatMahasiswa;
  ListJenisKelamin jenisKelaminMahasiswa = ListJenisKelamin.L;
  final formKey = GlobalKey<FormState>();
  //formKey : identifier untuk sebuah form yang nantinya dapat kita gunakan untuk validasi, dll.

  var nimMahasiswaController = TextEditingController();
  var namaMahasiswaController = TextEditingController();
  var programStudiController = TextEditingController();
  var alamatMahasiswaController = TextEditingController();

  File? selectedfile;
  String progress = '';

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
      title: const Text('Upload Foto Mahasiswa'),
      centerTitle: true,
      elevation: 0,
    );
    double heightBody = MediaQuery.of(context).size.height -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    double widthBody = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: myAppBar,
        body: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  //show file name here
                  child: progress == ''
                      ? Text("Progress: 0%")
                      : Text(
                          basename("Progress: $progress"),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                  //show progress status here
                ),

                Container(
                  margin: EdgeInsets.all(10),
                  //show file name here
                  child: selectedfile == null
                      ? Text("Silahkan Pilih Foto Terlebih Dahulu")
                      : Text(basename(selectedfile!.path)),
                  //basename is from path package, to get filename from path
                  //check if file is selected, if yes then show file name
                ),

                Container(
                  child: ElevatedButton(
                      onPressed: () {
                        selectFile();
                      },
                      child: Text('PILIH FOTO')),
                ),

                //if selectedfile is null then show empty container
                //if file is selected then show upload button
                selectedfile == null
                    ? Container()
                    : Container(
                        child: ElevatedButton(
                            onPressed: () {
                              // validasiForm();
                            },
                            child: Text('UPLOAD FOTO')),
                      )
              ],
            )));
  }

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      print(result);
      // File selectedfile = File(result.files.single.path);
    } else {
      // User canceled the picker
    }

    setState(() {}); //update the UI so that file name is shown
  }

  // void prosesSimpan() async {
  //   String url = Constants.baseUrl + '/mahasiswa/' + widget.mahasiswa.nim;
  //   var response = await http.put(Uri.parse(url), body: {
  //     "nim": nimMahasiswa,
  //     "nama_mahasiswa": namaMahasiswa,
  //     "program_studi": programStudi,
  //     "alamat": alamatMahasiswa,
  //     "jenis_kelamin":
  //         jenisKelaminMahasiswa.toString() == "L" ? "Laki-laki" : "Perempuan",
  //   });
  //   print(response.body);
  //   Map<String, dynamic> data =
  //       json.decode(response.body); //mengubah JSON menjadi MAP
  //   if (data['status'] == 200) {
  //     final snackBar = SnackBar(
  //       content: const Text('Data Berhasil Diubah'),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }
}
