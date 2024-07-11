import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

getTouch(t) {
  if (kDebugMode) {
    print('Anda Mengeklik $t');
  }
}

Future changeColorStatusBar() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.indigoAccent.withOpacity(0.7),
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light),
  );
}

Future hidestatusbar() async {
  return SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
}

Future showstatusbar() async {
  changeColorStatusBar();
  return SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(key: UniqueKey()),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    hidestatusbar();
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/image/bg_splash.jpg'), // Ganti dengan path gambar latar belakang Anda
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Image.asset('assets/image/logo.png',
                  width: 200, height: 200, key: UniqueKey())
              .animate()
              .fadeIn(duration: 1000.ms)
              .scale()
              .scaleXY(
                  end: 10,
                  duration: 1000.ms,
                  delay: 5.seconds), // Ganti dengan path gambar Anda
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Created By: CODE NINJAS',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.7), // Teks tembus pandang
                decoration:
                    TextDecoration.none, // Tidak ada garis di bawah teks
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _getUser = TextEditingController();
  final TextEditingController _getPassword = TextEditingController();
  final String _username = "17230448";
  final String _password = '123456789';

  _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nim_mahasiswa', _getUser.text);
    prefs.setString('pass_mahasiswa', _getPassword.text);
  }

  check(u, p) {
    if (u == _username && p == _password) {
      _saveUserData();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(nim: _getUser.text)));
    } else {
      if (kDebugMode) {
        print('nim $u & pass $p');
      }
    }
  }

  Future<String> getNim() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getnim = prefs.getString('nim_mahasiswa') ?? '';
    return getnim;
  }

  Future<String> getPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getpass = prefs.getString('pass_mahasiswa') ?? '';
    return getpass;
  }

  void check2() async {
    String u = await getNim();
    String p = await getPass();
    if (u == _username && p == _password) {
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(nim: _getUser.text)));
    }
  }

  @override
  void dispose() {
    _getUser.dispose();
    _getPassword.dispose();
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  Future _DisplayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.6),
      isDismissible: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // ignore: sized_box_for_whitespace
        return Container(
          height: 310,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Login / Masuk',
                  style: TextStyle(
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _getUser,
                  showCursor: true,
                  cursorColor: Colors.indigoAccent,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  autocorrect: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Image(
                      height: 5,
                      width: 5,
                      image: AssetImage('assets/icon/graduating-student.png'),
                    ),
                    hintText: 'Masukkan NIM Disini!',
                    labelText: 'NIM',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _getPassword,
                  showCursor: true,
                  cursorColor: Colors.indigoAccent,
                  textAlignVertical: TextAlignVertical.center,
                  autocorrect: true,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Image(
                      image: AssetImage('assets/icon/key.png'),
                    ),
                    hintText: 'Masukkan Password Disini!',
                    labelText: 'PASSWORD',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStatePropertyAll(
                              Colors.white.withOpacity(0.5)),
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.indigo),
                        ),
                        onPressed: () {
                          getTouch('Get Login');
                          check(_getUser.text, _getPassword.text);
                        },
                        child: Text(
                          "SUBMIT".toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    check2();
    showstatusbar();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.indigoAccent,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
                image: const AssetImage('assets/image/2466249.png'),
                height: MediaQuery.of(context).size.height * 0.65),
            Column(
              children: [
                const Text("Selamat Datang Sobat BSI!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 30)),
                Text(
                    "Sebelum mulai silahkan masuk terlebih dahulu dengan menekan tombol login di bawah",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(
                          Colors.white.withOpacity(0.5)),
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.indigo),
                    ),
                    onPressed: () {
                      getTouch('Login');
                      _DisplayBottomSheet(context);
                    },
                    child: Text(
                      "LOGIN / MASUK".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String nim});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

//jadwal kuliah list
  List jadwal = [
    "Mata Pelajaran",
    "Kuliah Pengganti",
    "Absensi",
    "Online",
    "Materi",
    "Tugas",
    "Kuis",
  ];

  List<Color> jadwalColor = [
    Colors.pinkAccent,
    Colors.cyan,
    Colors.blueAccent,
    Colors.lime,
    Colors.green,
    Colors.teal,
    Colors.orange
  ];

  List<ImageIcon> jadwalIcon = [
    const ImageIcon(
      Svg('assets/icon/book.svg'),
      color: Colors.white,
      size: 50,
    ),
    const ImageIcon(
      Svg('assets/icon/calendar-time.svg'),
      color: Colors.white,
      size: 45,
    ),
    const ImageIcon(
      Svg('assets/icon/student-person.svg'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      Svg('assets/icon/video.svg'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      Svg('assets/icon/file.svg'),
      color: Colors.white,
      size: 25,
    ),
    const ImageIcon(
      Svg('assets/icon/pen-line.svg'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      Svg('assets/icon/quizduel.svg'),
      color: Colors.white,
      size: 35,
    ),
  ];

// Payment list
  List payment = [
    "Biaya Kuliah",
    "Cuti",
    "Mutasi",
    "Kegiatan",
    "Seminar",
    "Bootcamp",
    "HER",
    "TA / Skripsi",
    "TA Perbaikan",
    "Wisuda",
    "Admin / Jaket",
    "TOEFL",
  ];

  List<Color> paymentColor = [
    Colors.brown,
    Colors.amber,
    Colors.blueGrey,
    Colors.cyan,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.green,
    Colors.grey,
    Colors.indigo,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.yellow,
  ];

  List<ImageIcon> paymentIcon = [
    const ImageIcon(
      AssetImage('assets/icon/give-money.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/car-svgrepo-com.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/arrow.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/badge.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/medal.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/trophy.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/exam.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/microscope.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/wrench.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/graduation.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/jacket.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/edit.png'),
      color: Colors.white,
      size: 35,
    ),
  ];

// Ruang siswa list
  List siswa = [
    "Info Akademik",
    "Kalender Akademik",
    "Hasil Studi",
    "Konserling",
    "Pengaduan & Saran",
    "Pengajuan Surat",
    "Jadwal Dosen",
  ];

  List<Color> siswaColor = [
    Colors.black45,
    Colors.amber,
    Colors.blueGrey,
    Colors.deepOrange,
    Colors.deepPurpleAccent,
    Colors.red,
    Colors.grey,
  ];

  List<ImageIcon> siswaIcon = [
    const ImageIcon(
      Svg('assets/icon/info-square.svg'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      Svg('assets/icon/calendar-lines-pen.svg'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      Svg('assets/icon/chart-user-square.svg'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/person-talk.png'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      Svg('assets/icon/complain-user-ui.svg'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      Svg('assets/icon/letter-opened.svg'),
      color: Colors.white,
      size: 35,
    ),
    const ImageIcon(
      AssetImage('assets/icon/work.png'),
      color: Colors.white,
      size: 35,
    ),
  ];

  get prettyQrView => null;

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('pass_mahasiswa');
    await prefs.remove('nim_mahasiswa');
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void genQr(String datas) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        // ignore: sized_box_for_whitespace
        child: Container(
          height: MediaQuery.of(context).size.height * 0.50,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PRESENSI',
                    style: TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=$datas',
                    height: 300,
                    width: 300,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    showstatusbar();
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.cyan.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/image/profile.jpg'),
                    radius: 50.0,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Adimas Prakoso',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'adimas.prakoso2@gmail.com',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              onTap: () {
                getTouch('Home');
              },
              leading: const Icon(Icons.home),
              title: const Text('Home'),
            ),
            ListTile(
              onTap: () {
                getTouch('Profile');
              },
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('Profile'),
            ),
            ListTile(
              onTap: () {
                getTouch('Mail');
              },
              leading: const Icon(Icons.mail),
              title: const Text('Mail'),
            ),
            ListTile(
              onTap: () {
                getTouch('Notification');
              },
              leading: const Icon(Icons.notifications),
              title: const Text('Notification'),
            ),
            ListTile(
              onTap: () {
                getTouch('Payment History');
              },
              leading: const Icon(Icons.history),
              title: const Text('Payment History'),
            ),
            ListTile(
              onTap: () {
                getTouch('Settings');
              },
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              onTap: () {
                getTouch('Log Out');
                logout();
              },
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
            ),
            const Spacer(),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: const Text(
                  'Created By: CODE NINJAS',
                  style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 15),
                ),
              ),
            ),
          ]),
        ),
      ),
      child: Scaffold(
        body: Container(
          color: Colors.indigoAccent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // ignore: sized_box_for_whitespace
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 15,
                        right: 15,
                        bottom: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: IconButton(
                              onPressed: _handleMenuButtonPressed,
                              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                                valueListenable: _advancedDrawerController,
                                builder: (_, value, __) {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    child: Icon(
                                      value.visible ? Icons.close : Icons.menu,
                                      key: ValueKey<bool>(value.visible),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8.0, // jarak antar icon
                            children: [
                              // ignore: sized_box_for_whitespace
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: IconButton(
                                  onPressed: () {
                                    getTouch('Mail');
                                  },
                                  icon: const Icon(Icons.mail),
                                ),
                              ),
                              // ignore: avoid_unnecessary_containers
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: IconButton(
                                  onPressed: () {
                                    getTouch('notification');
                                  },
                                  icon: const Icon(Icons.notifications),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    right: 10,
                                    left: 10,
                                    bottom: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Hi, ',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.black38,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Text(
                                        'Adimas',
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Container(
                                            child: Lottie.asset(
                                          'assets/lottie/wave.json',
                                          width: 22,
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Container(
                                        width: 100,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.6),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '17.1A.37',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.black38),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/image/profile.jpg'),
                                radius: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 15,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 85,
                            decoration: const BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: const Center(
                                        child: Text(
                                          'IPK',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      '3.58',
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 15,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 85,
                            decoration: const BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: const Center(
                                        child: Text(
                                          'NILAI RATA-RATA',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      '85',
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.7,
                maxChildSize: 1.0,
                minChildSize: 0.7,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10,
                      ),
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 15,
                            ),
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.indigoAccent,
                                    Colors.blueAccent,
                                    Colors.blue,
                                    Colors.cyan
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Program Studi',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          'Sarjana (S1) Teknologi Informasi',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Semester',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          '1',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Kelas',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          '17.1A.37',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Satuan Kredit Semester',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontSize: 12),
                                        ),
                                        Text(
                                          'Tahun Masuk',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '18',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          '2023-2',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              getTouch('Presensi');
                              genQr(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.');
                            },
                            hoverColor: Colors.white38,
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.indigoAccent,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image:
                                          AssetImage('assets/icon/qr-scan.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Presensi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            'Ketuk Untuk Membuka!',
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15,
                              bottom: 25,
                              left: 10,
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Jadwal Kuliah',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 28,
                                          fontFamily: 'LettersforLearners'),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Image(
                                        height: 25,
                                        width: 25,
                                        image: AssetImage(
                                            'assets/icon/calendar.png'))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 0.7),
                                  itemCount: jadwal.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        getTouch(jadwal[index]);
                                        if (jadwal[index] == "Mata Pelajaran") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const JadwalScreen()));
                                        }
                                        if (jadwal[index] ==
                                            "Kuliah Pengganti") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PenggantiScreen()));
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 75,
                                            width: 75,
                                            decoration: BoxDecoration(
                                              color: jadwalColor[index],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: jadwalIcon[index],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(jadwal[index],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900
                                                  //fontFamily: 'LettersforLearners',
                                                  ))
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              bottom: 25,
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Ruang Siswa',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 28,
                                          fontFamily: 'LettersforLearners'),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Image(
                                        height: 28,
                                        width: 28,
                                        image: AssetImage(
                                            'assets/icon/student.png'))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 0.7),
                                  itemCount: siswa.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        getTouch(siswa[index]);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 75,
                                            width: 75,
                                            decoration: BoxDecoration(
                                              color: siswaColor[index],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: siswaIcon[index],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(siswa[index],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900
                                                  //fontFamily: 'LettersforLearners',
                                                  ))
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              bottom: 25,
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'Pembayaran',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 28,
                                          fontFamily: 'LettersforLearners'),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Image(
                                        height: 28,
                                        width: 28,
                                        image: AssetImage(
                                            'assets/icon/payment.png'))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 0.7),
                                  itemCount: payment.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        getTouch(payment[index]);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 75,
                                            width: 75,
                                            decoration: BoxDecoration(
                                              color: paymentColor[index],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: paymentIcon[index],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(payment[index],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900
                                                  //fontFamily: 'LettersforLearners',
                                                  ))
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  String jsonData = '''
  {
    "data": [
      {
        "jurusan": "PENGANTAR TEKNOLOGI INFORMASI DAN KOMUNIKASI",
        "nama": "Bima Muhamad Esa",
        "kode": "BME",
        "mtk": "111",
        "sks": "3",
        "ruang": "17",
        "kode": "KG.111.17.AB",
        "hari": "Senin - 07.30-09.00"
      },
      {
        "jurusan": "DASAR PEMROGRAMAN",
        "nama": "Tono Eko Suprotmo",
        "kode": "TES",
        "mtk": "132",
        "sks": "3",
        "ruang": "11",
        "kode": "KP.132.11.AB",
        "hari": "Senin - 12.30-15.00"
      },
      {
        "jurusan": "ENTERPRENUERSHIP",
        "nama": "Haji Esa Hendar",
        "kode": "HEH",
        "mtk": "148",
        "sks": "2",
        "ruang": "27",
        "kode": "KE.148.27.AB",
        "hari": "Slasa - 07.30-09.00"
      },
      {
        "jurusan": "PENDIDIKAN PANCASILA",
        "nama": "Herman Eka Pertiwi",
        "kode": "HEP",
        "mtk": "156",
        "sks": "3",
        "ruang": "21",
        "kode": "KR.156.21.AB",
        "hari": "Selasa - 14.30-16.00"
      },
      {
        "jurusan": "LOGIKA & ALGORITMA",
        "nama": "Kedir Drajat Ilham",
        "kode": "KDI",
        "mtk": "167",
        "sks": "2",
        "ruang": "18",
        "kode": "KA.167.18.AB",
        "hari": "Rabu - 07.30-09.00"
      },
      {
        "jurusan": "BAHASA INGGRIS",
        "nama": "Kazuya Orang Ilang",
        "kode": "KOI",
        "mtk": "170",
        "sks": "3",
        "ruang": "23",
        "kode": "KU.170.23.AB",
        "hari": "Kamis - 12.30-15.00"
      }
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    List data = jsonDecode(jsonData)['data'];
    return Scaffold(
      body: Container(
        color: Colors.indigoAccent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                left: 15,
                right: 15,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Text(
                    'Mata Pelajaran',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 15,
                        ),
                        child: Container(
                          height: 75,
                          width: 75,
                          decoration: const BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.13,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.7),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data[index]["jurusan"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          data[index]["hari"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Image(
                                          image: AssetImage(
                                              'assets/icon/programmer.png'),
                                          width: 30,
                                          height: 30,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Kode Dosen :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['nama'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.book),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Kode MTK :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['mtk'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.timer),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'SKS :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['sks'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.compare_arrows),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'No Ruang :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['ruang'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Icon(Icons.home),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Kel Praktek :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.key),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Kode Gabung :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['kode'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PenggantiScreen extends StatefulWidget {
  const PenggantiScreen({super.key});

  @override
  State<PenggantiScreen> createState() => _PenggantiScreenState();
}

class _PenggantiScreenState extends State<PenggantiScreen> {
  String jsonData = '''
  {
    "data": [
      {
        "jurusan": "ENTERPRENUERSHIP",
        "nama": "Haji Esa Hendar",
        "kode": "HEH",
        "mtk": "148",
        "sks": "2",
        "ruang": "27",
        "kode": "KE.148.27.AB",
        "hari": "Jumat - 08.30-10.00"
      },
      {
        "jurusan": "LOGIKA & ALGORITMA",
        "nama": "Kedir Drajat Ilham",
        "kode": "KDI",
        "mtk": "167",
        "sks": "2",
        "ruang": "18",
        "kode": "KA.167.18.AB",
        "hari": "Sabtu - 07.30-09.00"
      }
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    List data = jsonDecode(jsonData)['data'];
    return Scaffold(
      body: Container(
        color: Colors.indigoAccent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                left: 15,
                right: 15,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Text(
                    'Kuliah Pengganti',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.17,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 15,
                        ),
                        child: Container(
                          height: 75,
                          width: 75,
                          decoration: const BoxDecoration(
                            color: Colors.indigoAccent,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.13,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.7),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data[index]["jurusan"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          data[index]["hari"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const ImageIcon(
                                            Svg('assets/icon/id-card.svg')),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Nama Dosen :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['nama'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.code),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Kode Dosen :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['kode'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.book),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Kode MTK :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['mtk'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.timer),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'SKS :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['sks'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.compare_arrows),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'No Ruang :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['ruang'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Icon(Icons.home),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Kel Praktek :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.key),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Kode Gabung :',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          data[index]['kode'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
