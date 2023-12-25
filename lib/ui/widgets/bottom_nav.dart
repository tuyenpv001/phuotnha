part of 'widgets.dart';

class BottomNavigation extends StatelessWidget {

  final int index;
  final bool isReel;

  const BottomNavigation({Key? key, required this.index, this.isReel = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: isReel ? Colors.black : Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 9, spreadRadius: -4)
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ItemButtom(
            i: 1,
            index: index,
            icon: Icons.home_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const HomePage()), (_) => false),
          ),
          _ItemButtom(
            i: 2,
            index: index,
            icon:  Icons.pin_drop_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const TripPage()), (_) => false),
          ),
          _ItemButtom(
            i: 3,
            index: index,
            icon: Icons.schedule_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const TripSchedulePage()), (_) => false),
          ),
          _ItemButtom(
            i: 4,
            index: index,
            icon: Icons.search,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const SearchPage()), (_) => false),
          ),
          // _ItemButtom(
          //   i: 4,
          //   index: index,
          //   icon: Icons.movie_outlined,
          //   onPressed: () => Navigator.push(context, routeSlide(page: const ReelHomeScreen())),
          // ),
          _ItemButtom(
            i: 5,
            index: index,
            icon: Icons.bookmark_outline,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(context, routeSlide(page: const SavePage()), (_) => false),
          ),
          _ItemButtom(
            i: 6,
            index: index,
            icon: Icons.person_2_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page:const ProfilePage()), (_) => false),
          ),

        ],
      ),
    );
  }
}


class _ItemButtom extends StatelessWidget {

  final int i;
  final int index;
  final bool isIcon;
  final IconData? icon;
  final String? iconString;
  final Function() onPressed;
  final bool isReel;

  const _ItemButtom({
    Key? key,
    required this.i,
    required this.index,
    required this.onPressed,
    this.icon,
    this.iconString,
    this.isIcon = true,
    this.isReel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: ( isIcon ) 
          ? Icon(icon, color: ( i == index ) ? ColorsCustom.primary : isReel ?Colors.white : Colors.black87 , size: 28)
          : SvgPicture.asset(iconString!, height: 25),
      ),
    );
  }
}