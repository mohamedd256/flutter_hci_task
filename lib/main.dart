import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

// ================= TEXT FIELD =================

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  bool obscure = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    ],
  );
}

// ================= LOGIN =================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  void _onLogin() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Task Manager",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            buildTextField(
              controller: _userCtrl,
              label: "Username",
              hint: "Enter username",
            ),
            const SizedBox(height: 16),

            buildTextField(
              controller: _passCtrl,
              label: "Password",
              hint: "••••••",
              obscure: true,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _onLogin,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= MODEL =================

class Task {
  final String title;
  final String category;
  final Color color;

  const Task(this.title, this.category, this.color);
}

const tasks = [
  Task("Study Flutter", "Study", Colors.blue),
  Task("Go to Gym", "Personal", Colors.orange),
  Task("Meeting", "Work", Colors.green),
  Task("Read Book", "Study", Colors.purple),
];

// ================= HOME =================

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _filter = "All";

  final filters = ["All", "Work", "Personal", "Study"];

  List<Task> get filtered => _filter == "All"
      ? tasks
      : tasks.where((t) => t.category == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const SizedBox(height: 40),

          // Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: filters.map((f) {
              return GestureDetector(
                onTap: () => setState(() => _filter = f),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _filter == f ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      color: _filter == f ? Colors.white : Colors.green,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final task = filtered[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          size: 40, color: task.color),
                      const SizedBox(height: 10),
                      Text(task.title),
                      Text(task.category,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}