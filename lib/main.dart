import 'package:flutter/material.dart';
import 'package:oria/widgets/story_form.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './providers/user_provider.dart';
import './providers/place_provider.dart';
import './providers/feed_provider.dart';
import './providers/comment_provider.dart';
import './providers/follow_provider.dart';
import './providers/contact_provider.dart';
import './providers/message_provider.dart';
import './providers/message_request_provider.dart';
import './providers/story_provider.dart';

import './screens/splash_screen.dart';
import './screens/tab_screen.dart';
import './screens/guest_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/place_list_screen.dart';
import './screens/place_detail_screen.dart';
import './screens/feed_detail_screen.dart';
import './screens/user_profile_screen.dart';
import './screens/profile_edit_screen.dart';
import './screens/feed_form_screen.dart';
import './screens/place_form_screen.dart';
import './screens/comment_screen.dart';
import './screens/follow_screen.dart';
import './screens/message_screen.dart';
import './screens/chat_screen.dart';
import './screens/story_form_screen.dart';


void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: UserProvider()),
        ChangeNotifierProxyProvider<UserProvider,PlaceProvider>(update: (ctx,user,previousPlaceProvider) => PlaceProvider()),
        ChangeNotifierProxyProvider<UserProvider,FeedProvider>(update: (ctx,user,_) => FeedProvider()),
        ChangeNotifierProxyProvider<UserProvider,CommentProvider>(update: (ctx,user,_) => CommentProvider()),
        ChangeNotifierProxyProvider<UserProvider,FollowProvider>(update: (ctx,user,_) => FollowProvider(),),
        ChangeNotifierProxyProvider<UserProvider,MessageProvider>(update: (ctx,user,_) => MessageProvider(),),
        ChangeNotifierProxyProvider<UserProvider,ContactProvider>(update: (ctx,user,_) => ContactProvider(),),
        ChangeNotifierProxyProvider<UserProvider,MessageRequestProvider>(update: (ctx,user,_) => MessageRequestProvider(),),
        ChangeNotifierProxyProvider<UserProvider,StoryProvider>(update: (ctx, user, _) => StoryProvider(),)
      ],
      child: MaterialApp(
          title: 'Oria',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Color.fromRGBO(51, 229, 232, 1),
            accentColor: Colors.white,
            buttonTheme: ButtonThemeData(
              buttonColor: Color.fromRGBO(51, 229, 232, 1),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (ctx, authStreamSnapshot) {
              if (authStreamSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return SplashScreen();
              }
              if (authStreamSnapshot.hasData) {
                return TabScreen();
              }
              return LoginScreen();
            },
          ),
          //   auth.isAuth ? TabScreen(userId: auth.userId) : FutureBuilder(
          //   future: auth.tryAutoLogin(),
          //   builder: (ctx, authResultSnapshot) {
          //     return authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : GuestScreen();
          //   },
          // ),
          routes: {
            GuestScreen.routeName: (ctx) => GuestScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            SignupScreen.routeName: (ctx) => SignupScreen(),
            PlaceListScreen.routeName: (ctx) => PlaceListScreen(),
            PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
            FeedDetailScreen.routeName: (ctx) => FeedDetailScreen(),
            UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
            ProfileEditScreen.routeName: (ctx) => ProfileEditScreen(),
            FeedFormScreen.routeName: (ctx) => FeedFormScreen(),
            PlaceFormScreen.routeName: (ctx) => PlaceFormScreen(),
            CommentScreen.routeName: (ctx) => CommentScreen(),
            FollowScreen.routeName: (ctx) => FollowScreen(),
            MessageScreen.routeName: (ctx) => MessageScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),
            StoryFormScreen.routeName: (ctx) => StoryFormScreen(),
          },
        ),
     
    );
  }
}
