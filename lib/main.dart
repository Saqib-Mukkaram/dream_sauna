import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dream_sauna/auth/splash.dart';

import 'package:dream_sauna/utils/theme_style.dart';


void main() {
  runApp( GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeStyle().themedata,
    home: splachScreen(),
  ));
}






// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//
//     Future<UserModel> getUserData () => UserPreferences().getUser();
//
//     return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(
//               create: (context) => AuthProvider(),
//           ),
//           ChangeNotifierProvider(
//               create: (context) => DashboardProvider(),
//           ),
//           ChangeNotifierProvider(
//               create: (context) => StatementProvider(),
//           ),
//           ChangeNotifierProvider(
//               create: (context) => BookingProvider(),
//           ),
//           ChangeNotifierProvider(
//               create: (context) => PakageProvider(),
//           ),
//         ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeStyle().themedata,
//         home: FutureBuilder(
//             future: getUserData(),
//             builder: (context, snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.none:
//                 case ConnectionState.waiting:
//                   return CircularProgressIndicator();
//                 default:
//                   if (snapshot.hasError)
//                     return Text('Error: ${snapshot.error}');
//                   else if (snapshot.data.api_token == null)
//                     return LogInScreeen();
//                   else
//                     // Provider.of<AuthProvider>(context).setUser(snapshot.data);
//                   return HomeScreen(index: 1,);
//
//               }
//             }),
//         routes: {
//           '/': (context) => splachScreen(),
//           '/login' : (context) => LogInScreeen(),
//           '/forget-password': (context) => ForgetPassword(),
//           '/verify-otp' : (context) => VerifyOtp(email: null,),
//           '/profile' : (context) => ProfilePage(),
//           'edit-profile' : (context) => EditProfilePage(),
//           '/home' : (context) => HomeScreen(index: 1)
//
//         },
//       ),
//     );
//   }
// }



//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => AuthProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => HomeScreen(),
//         ),
//         // ChangeNotifierProvider(
//         //   create: (context) => WishlistProvider(),
//         // ),
//         // ChangeNotifierProvider(
//         //   create: (context) => CartProvider(),
//         // ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeStyle().themedata,
//         routes: {
//           '/': (context) => splachScreen(),
//           // '/home': (context) => HomeScreen(index: 0, userData: _data["data"],),
//           // '/sign-up': (context) => SignUpPage(),
//           // '/home': (context) => MainPage(),
//           // '/detail-chat': (context) => DetailChatPage(),
//           // '/edit-profile': (context) => EditProfilePage(),
//           // '/cart': (context) => CartPage(),
//           // '/checkout': (context) => CheckoutPage(),
//           // '/checkout-success': (context) => CheckoutSuccessPage(),
//         },
//       ),
//     );
//   }
// }
