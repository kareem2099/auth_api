import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

import '../bloc/auth_bloc.dart';
import '../component/decodeJwt.dart';

class GetUserDataScreen extends StatefulWidget {
  static const String routeName = '/getuserdata';

  const GetUserDataScreen({super.key});

  @override
  State<GetUserDataScreen> createState() => _GetUserDataScreenState();
}

class _GetUserDataScreenState extends State<GetUserDataScreen> {
  String? userId;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userProfilePic;
  String? userLocation;
  String? createdAt;

  @override
  void initState() {
    super.initState();
    _decodeToken();
  }

  Future<void> _decodeToken() async {
    const storage = FlutterSecureStorage();
    try {
      final token = await storage.read(key: 'token');
      if (token != null) {
        final decoded = decodeJwt(token);
        setState(() {
          userId = decoded['id'];
          userName = decoded['name'];
          userEmail = decoded['email'];
          userPhone = decoded['phone'];
          createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateTime.fromMillisecondsSinceEpoch(decoded['iat'] * 1000),
          );
        });
        _loadUserData(decoded['id']);
      }
    } catch (e) {}
  }

  Future<void> _loadUserData(String userId) async {
    BlocProvider.of<AuthenticationBloc>(context)
        .add(GetUserEvent(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get User Data')),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is GetUserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is GetUserSuccess) {
            setState(() {
              userId = state.userData['_id'];
              userName = state.userData['name'];
              userEmail = state.userData['email'];
              userPhone = state.userData['phone'];
              userProfilePic = state.userData['profilePic'];
              userLocation =
                  state.userData['location']['coordinates'].toString();
              createdAt = state.userData['createdAt'];
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (userProfilePic != null)
                  Image.network(
                    userProfilePic!,
                    height: 100,
                    width: 100,
                  ),
                const SizedBox(height: 20),
                _buildReadOnlyTextField('User ID', userId),
                const SizedBox(height: 20),
                _buildReadOnlyTextField('Name', userName),
                const SizedBox(height: 20),
                _buildReadOnlyTextField('Email', userEmail),
                const SizedBox(height: 20),
                _buildReadOnlyTextField('Phone', userPhone),
                const SizedBox(height: 20),
                _buildReadOnlyTextField('Location', userLocation),
                const SizedBox(height: 20),
                _buildReadOnlyTextField('Created At', createdAt),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyTextField(String label, String? value) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: value),
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value ?? ''));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label copied to clipboard')),
            );
          },
        ),
      ],
    );
  }
}
