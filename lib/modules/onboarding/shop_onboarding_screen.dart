import 'package:flutter/material.dart';
import 'package:shop_app/modules/shop_login/shoplogin_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardModel {
  final String title;
  final String bodytitle;
  final String image;

  BoardModel(
      {@required this.title, @required this.bodytitle, @required this.image});
}

class ShopOnBoardingScreen extends StatefulWidget {
  @override
  _ShopOnBoardingScreenState createState() => _ShopOnBoardingScreenState();
}

class _ShopOnBoardingScreenState extends State<ShopOnBoardingScreen> {
  var pageController = PageController();

  List<BoardModel> boardingList = [
    BoardModel(
        image: 'assets/images/shoponboard.png',
        title: 'On Board title 1',
        bodytitle: 'On Board 1 Body Title'),
    BoardModel(
        image: 'assets/images/shoponboard.png',
        title: 'On Board title 2',
        bodytitle: 'On Board 2 Body Title'),
    BoardModel(
        image: 'assets/images/shoponboard.png',
        title: 'On Board title 3',
        bodytitle: 'On Board 3 Body Title'),
  ];
  bool isLast = false;
  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if(value) navigateAndFinish(context ,ShopLoginScreen());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [defaultTextButton(function : (){
        setState(() {
          submit();
        });
      }, text: 'skip')],),
      body: PageView.builder(
        onPageChanged: (int index){
          setState(() {
            if(index == boardingList.length - 1){
              isLast = true;
            }
            else{
              isLast = false;
            }
          });

        },
        itemBuilder: (context, index) => onboardItem(context,boardingList[index] ),
        physics: BouncingScrollPhysics(),
        controller: pageController,
        itemCount: 3,
      ),
    );
  }

  Widget onboardItem(BuildContext context, BoardModel model) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Image.asset('${model.image}')),
          Text(
            '${model.title}',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            '${model.bodytitle}',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 60.0,
          ),
          Row(
            children: [
              SmoothPageIndicator(
                controller: pageController,
                count: boardingList.length,
                effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.deepOrange,
                    dotHeight: 10.0,
                    dotWidth: 10.0,
                    radius: 10.0,
                    spacing: 5.0,
                    expansionFactor: 4),
              ),
              Spacer(),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    if(isLast){
                      submit();

                    }else{
                      pageController.nextPage(duration: Duration(milliseconds: 760), curve: Curves.fastLinearToSlowEaseIn);
                    }
                  });
                },
                child: Icon(Icons.arrow_forward_ios),
              ),
            ],
          )
        ],
      ),
    );
  }
}
