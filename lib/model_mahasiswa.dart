// To parse this JSON data, do
//
//     final mahasiswa = mahasiswaFromJson(jsonString);

import 'dart:convert';

List<Mahasiswa> mahasiswaFromJson(String str) =>
    List<Mahasiswa>.from(json.decode(str).map((x) => Mahasiswa.fromJson(x)));

String mahasiswaToJson(List<Mahasiswa> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mahasiswa {
  Mahasiswa({
    required this.nim,
    required this.namaMahasiswa,
    required this.jenisKelamin,
    required this.programStudi,
    required this.alamat,
    required this.foto,
    required this.createdAt,
  });

  String nim;
  String namaMahasiswa;
  String jenisKelamin;
  String programStudi;
  String alamat;
  String foto;
  DateTime createdAt;

  factory Mahasiswa.fromJson(Map<dynamic, dynamic> json) => Mahasiswa(
        nim: json["nim"],
        namaMahasiswa: json["nama_mahasiswa"],
        jenisKelamin: json["jenis_kelamin"],
        programStudi: json["program_studi"],
        alamat: json["alamat"],
        foto: json["foto"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "nim": nim,
        "nama_mahasiswa": namaMahasiswa,
        "jenis_kelamin": jenisKelamin,
        "program_studi": programStudi,
        "alamat": alamat,
        "foto": foto,
        "created_at": createdAt.toIso8601String(),
      };
}
