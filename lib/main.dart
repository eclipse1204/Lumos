// import 'package:finale/util/background_tasks/background_task_manager.dart'
//     as background_task_manager;
//import 'package:finale/util/constants.dart';
//import 'package:finale/util/external_actions/notifications.dart'
//   as notifications;
// import 'package:finale/util/external_actions/quick_actions_manager.dart'
//     as quick_actions_manager;
// import 'package:finale/util/image_id_cache.dart';
import 'package:finale/util/preference.dart';
import 'package:finale/util/preferences.dart';
import 'package:finale/util/theme.dart';
import 'package:finale/widgets/entity/lastfm/profile_stack.dart';
import 'package:finale/widgets/main/login_view.dart';
import 'package:finale/widgets/main/main_view.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preference.setup();

  runApp(ProfileStack(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final name = Preferences.name.value;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finale',
      home: LoginView(),
    );
  }
}
