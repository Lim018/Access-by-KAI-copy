import 'package:flutter/material.dart';
import 'app.dart';
import 'package:appwrite/appwrite.dart';

Client client = Client();
client
    .setEndpoint('http://localhost:3309/v1')
    .setProject('681cf430000b8a0e6999')
    .setSelfSigned(status: true); // For self signed certificates, only use for development;
  
void main() {
  runApp(const MyApp());
}