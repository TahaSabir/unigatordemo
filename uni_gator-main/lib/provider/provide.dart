import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:uni_gator/provider/forget_password_provider.dart';
import 'package:uni_gator/provider/signup_provider.dart';

import 'sign_in_provider.dart';

List<SingleChildWidget> providersConst = [
  // AUTH VIEW MODEL
  ChangeNotifierProvider(
    create: (context) => SignUpProvider(),
  ),

  ChangeNotifierProvider(
    create: (context) => SignInProvider(),
  ),

  ChangeNotifierProvider(
    create: (context) => ForgetPasswordProvider(),
  ),
];
