import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  static const String userNameKey = 'username';
  static const String userAgeKey = 'user_age';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações do user")),
      body: _buildUserSettingsScreenBody(),
    );
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString(userNameKey) ?? "";
      _ageController.text = prefs.getInt('user_age')?.toString() ?? "";
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Dados Carregados!')));
  }

  Future<void> _saveUserData() async {
    String user = _nameController.text;
    int age = int.tryParse(_ageController.text) ?? 0;

    // "FUTURE"

    final preferences = await SharedPreferences.getInstance();

    await preferences.setInt(userAgeKey, age);
    await preferences.setString(userNameKey, user);
  }

  _buildUserSettingsScreenBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nome'),
          ),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Idade'),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _saveUserData,
                child: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF000080),
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: _loadUserData,
                child: Text('Carregar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF000080),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
