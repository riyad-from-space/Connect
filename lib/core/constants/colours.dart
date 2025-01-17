import 'package:flutter/material.dart';

class KColor extends ChangeNotifier {

  /// const color
  static const Color buttonBackgroundConst =
  Color(0xFF586ED1) /* Color(0xFF01bb7f) */;
  static const Color backgrounforGoogle=Color(0xff18436E);
  static const Color backgrounforEmail=Color(0xffE23F36);
  static const Color ash=Color(0xff5C5D67);
  static const Color black=Color(0xff17131B);
  static const Color whiteConst = Colors.white;
  static const Color appThemeColorConst = Color(0xFF586ED1);
  static const Color blackConst = Colors.black;
  static const Color black38Const = Colors.black38;
  static const Color black87Const = Colors.black87;
  static const Color black54Const = Colors.black54;
  static const Color white54Const = Colors.white54;
  static const Color white70Const = Colors.white70;
  static const Color white38Const = Colors.white38;
  static const Color white24Const = Colors.white24;
  static const Color white12Const = Colors.white10;
  static const Color greyconst = Colors.grey;
  static const Color amberConst = Colors.amber;
  static Color? grey900const = Colors.grey[900];
  static Color? grey850const = Colors.grey[850];
  static Color? grey800const = Colors.grey[800];
  static Color? grey600const = Colors.grey[600];
  static Color? grey350const = Colors.grey[350];
  static Color? grey300const = Colors.grey[300];
  static Color? grey200const = Colors.grey[200];
  static Color? grey100const = Colors.grey[100];
  static Color greyShade400const = Colors.grey.shade400;
  static Color spaceCadetBlueConst = const Color(0xFF292D55);
  static Color athensGrayConst = const Color(0xFFF4F4F8);
  static Color chineseBlackConst = const Color(0xFF151812);
  static Color americanBronzeConst = const Color(0xFF312000);
  static Color vodkaConst = const Color(0xFFB5B4F8);

  //login screen colors
  static Color japanesesIndigo = const Color(0xFF2D3748);
  static const darkGunmetal = Color(0xff1A202C);
  static Color dimGray = const Color(0xff4a5568);
  static const graniteGray = Color(0xff616161);
  static Color border = const Color(0xffE8E8E8);
  static const darkGray = Color(0xff9E9E9E);
  static Color cupertinoLoading = const Color(0xffE8E8E8);

  /*
  primary theme color
  */
  static Color primary = const Color(
      0xFF586ED1) /* AppMode.CONNECTIVER ? Color(0xFF01bb7f) : Color(0xFF34465d) */;
  static Color secondary = Colors.white;
  static Color appBarBackground = KColor.vodka;

  /*
  app background color
  */
  static Color appBackground = const Color(0xFFFAFAFF);
  static Color appThemeColor = primary;
  static Color navBarIconColor = Colors.white;
  static Color textBackground = Colors.white;
  static Color darkAppBackground = KColor.black;
  static Color whiteLilac = const Color(0xFFEDEFF9);
  static Color paleLilac = const Color(0xFFE2D0FC);
  static Color eerieBlack = const Color(0xFF130F26);
  static Color cornflowerBlue = const Color(0xFF7186EB);
  static Color vistaBlue = const Color(0xFF8B99DF);
  static Color spaceCadetBlue = const Color(0xFF292D55);
  static Color titanWhite = const Color(0xFFFCFCFF);
  static Color santasGray = const Color(0xFF9C9EA9);
  static Color snuffGray = const Color(0xFFDBDFEE);
  static Color athensGray = const Color(0xFFF4F4F8);
  static Color chineseBlack = const Color(0xFF151812);
  static Color lavender = const Color(0xFFE3E7F8);
  static Color vodkaViolet = const Color(0xFFB8C3EB);
  static Color americanBronze = const Color(0xFF312000);
  static Color platinum = const Color(0xFFE5E5E5);
  static Color royalBlue = const Color(0xFF526EE9);
  static Color jordyBlue = const Color(0xFF94A9F9);
  static Color brightGray = const Color(0xFFEEEEEE);
  static Color vodka = const Color(0xFFB5B4F8);
  static Color paleLavender = const Color(0xFFEAFCD0);
  static Color carolinaBlue = const Color(0xFF85B3FE);
  static Color chetwodeBlue = const Color(0xFF7B8DDB);
  static Color blurShadow = Colors.white;
  static Color gunpowderGrey = const Color(0xFF414451);
  static Color lavenderWeb = const Color(0xFFF0E1FF);
  static Color purpleNavy = const Color(0xFF44518A);
  static Color fireOpal = const Color(0xFFEA5252);
  static Color palatinateBlue = const Color(0xFF2C4EE5);
  static Color limeGreen = const Color(0xFF43CC3F);
  static Color green700 = Colors.green[700]!;
  static Color carribeanGreen = const Color(0xFF00CB7B);

  /*
  app bar bg, title text color
  */
  static Color appBarTitle = Colors.black;

  /*
  error red text color
  */
  static Color errorRedText = const Color(0xFFEF6061);

  /*
  time grey text color
  */
  static Color timeGreyText = const Color(0xFFA1A6AB);

  /*
  button banckground color e10600
  */
  static Color buttonBackground = primary /* Color(0xFF01bb7f) */;

  /*
  app shadows color
  */
  static Color shadowColor = const Color.fromRGBO(0, 0, 0, 0.04);
  static Color facebookLogoColor = const Color.fromRGBO(59, 87, 157, 1);
  static Color twitterLogoColor = const Color.fromRGBO(85, 172, 238, 1);
  static Color youtubeLogoColor = const Color.fromRGBO(230, 33, 23, 1);
  static Color instagramLogoColor = const Color.fromRGBO(63, 114, 155, 1);
  static Color linkedinLogoColor = const Color.fromRGBO(26, 132, 188, 1);
  static Color adobeLogoColor = const Color(0xFFF40F02);
  static Color progressBlue = const Color(0xFF2d8cf0);
  static Color seenGreen = const Color(0xFF5FCF7F);
  static Color closeText = Colors.white60;
  static Color menuTitle = const Color(0x0091959b);
  static Color feedActionButton = const Color(0xFF65676b);
  static Color reactionBlue = const Color(0xff3b5998);
  static Color reactionYellow = const Color(0xffDAA520);
  static Color reactionOrange = const Color(0XFFed5168);
  static Color royalAzure = const Color(0XFF013CA9);
  static Color orangeWeb = const Color(0XFFFFA500);

  /*
  normal color
  */


  static Color black87 = Colors.black87;
  static Color black38 = Colors.black38;
  static Color black26 = Colors.black26;
  static Color black45 = Colors.black45;
  static Color black54 = Colors.black54;
  static Color white = Colors.white;
  static Color white54 = Colors.white54;
  static Color white70 = Colors.white70;
  static Color grey = Colors.grey;
  static Color? grey50 = Colors.grey[50];
  static Color? grey100 = Colors.grey[100];
  static Color? grey200 = Colors.grey[200];
  static Color? grey350 = Colors.grey[350];
  static Color? grey300 = Colors.grey[300];
  static Color? grey400 = Colors.grey[400];
  static Color? grey600 = Colors.grey[600];
  static Color? grey700 = Colors.grey[700];
  static Color? grey800 = Colors.grey[800];
  static Color? grey850 = Colors.grey[850];
  static Color? grey900 = Colors.grey[900];
  static Color? blueGrey800 = Colors.blueGrey.shade800;
  static Color? blue = Colors.blue;
  static Color? blueAccent = Colors.blueAccent;
  static Color? blue800 = Colors.blue[800];
  static Color? blue900 = Colors.blue[900];
  static Color? green = Colors.green;
  static Color? red = Colors.red;
  static Color? red900 = Colors.red[900];
  static Color? transparent = Colors.transparent;
  static Color? cyan = Colors.cyan;
  static Color? pink = Colors.pink;
  static Color? orange = Colors.orange;
  static Color? purple = Colors.purple;
  static Color? yellow = Colors.yellow;
  static Color? indigo = Colors.indigo;
  static Color? linkColor = Colors.blueAccent;

  static Color sectionTitleColor = Colors.grey.shade200;

  static List gradientsColor = const [
    // use  index 0 for design , this one is fake data
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFFFFFFF),
      ],
    ),
    // use  index 1 for white color
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFFFFFFF),
      ],
    ),
    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [
        Color(0xFFff00ea),
        Color(0xFFff7300),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(-135),
      colors: [
        Color.fromRGBO(72, 229, 169, 1),
        Color.fromRGBO(143, 199, 173, 1),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(116, 167, 126, 1),
        Color.fromRGBO(24, 175, 78, 1),
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFff7f11),
        Color(0xFFff7f11),
      ],
    ),

    LinearGradient(
      begin: Alignment(-1.0, 0.0),
      end: Alignment(1.0, 0.0),
      transform: GradientRotation(90),
      colors: [
        Color(0xFF00ffe1),
        Color(0xFFe9ff42),
      ],
    )
  ];

  static List feedBackGroundGradientColors = [
    "{\"backgroundImage\":\"linear-gradient(45deg, rgb(255, 115, 0) 0%, rgb(255, 0, 234) 100%)\"}",
    "{\"backgroundImage\":\"linear-gradient(135deg, rgb(143, 199, 173), rgb(72, 229, 169))\"}",
    "{\"backgroundImage\":\"linear-gradient(135deg, rgb(116, 167, 126), rgb(24, 175, 78))\"}",
    "{\"backgroundImage\":\"linear-gradient(45deg, rgb(255, 127, 17) 0%, rgb(255, 127, 17) 100%)\"}",
    "{\"backgroundImage\":\"linear-gradient(45deg, rgb(233, 255, 66) 0%, rgb(0, 255, 225) 100%)\"}",
  ];
}
