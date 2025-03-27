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
  static const String countryKey = 'country';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  String countryEmoji = ""; // Correção: Variável para armazenar o emoji do país

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações do Usuário")),
      body: _buildUserSettingsScreenBody(),
    );
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString(userNameKey) ?? "";
      _ageController.text = prefs.getInt(userAgeKey)?.toString() ?? "";
      _countryController.text = prefs.getString(countryKey) ?? "";
      countryEmoji = _getCountryFlagEmoji(_countryController.text);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dados Carregados!')),
    );
  }

  Future<void> _saveUserData() async {
    String user = _nameController.text;
    int age = int.tryParse(_ageController.text) ?? 0;
    String country = _countryController.text;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(userNameKey, user);
    await preferences.setInt(userAgeKey, age);
    await preferences.setString(countryKey, country);
  }

  String _getCountryFlagEmoji(String countryCode) {
    if (countryCode.length != 2) return "";
    return String.fromCharCodes([
      countryCode.codeUnitAt(0) + 0x1F1E6 - 65,
      countryCode.codeUnitAt(1) + 0x1F1E6 - 65
    ]);
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
          TextField(
            controller: _countryController,
            decoration: InputDecoration(
              labelText: 'País',
              suffixIcon: countryEmoji.isNotEmpty
                  ? Text(countryEmoji, style: TextStyle(fontSize: 24))
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                countryEmoji = _getCountryFlagEmoji(value.toUpperCase());
              });
            },
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
