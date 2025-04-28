
import 'package:flutter/material.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'https://avatars.dzeninfra.ru/get-zen_doc/4404559/pub_604696cc58285736dd572b69_6047d7ec01026b450446f9ab/scale_1200',
      'https://avatars.dzeninfra.ru/get-zen_doc/4470750/pub_632893417878a6493a45e6cd_632893474871c446a8ac9a95/scale_1200',
      'https://editorial.uefa.com/resources/025d-0f4e7c96c709-753c8bbd042c-1000/real_madrid_v_stade_reims.jpeg',
      'https://avatars.dzeninfra.ru/get-zen_doc/271828/pub_67099491ca089528d8c196c9_670994a4ca089528d8c19980/scale_1200',
      'https://editorial.uefa.com/resources/0271-143b04c48dc5-a5989c04e47b-1000/sport_football.european_cup_final_in_brussels._real_madrid_2_v_partizan_belgrade_1._pic_12th_may_1966._real_madrid_s_francisco_gento_with_the_european_cup_after_the_victory..jpeg',
      'https://sun9-66.userapi.com/impg/hqPix3xNqw5L8dU9icUdCBiqXjLfg8tZXd_ZpA/Abhe_BhwwHg.jpg?size=1280x720&quality=95&sign=aa0d717d21d44c95706b338499331a63&c_uniq_tag=6taqvi9pO1PYaZ4ny78HrI489sWlJS0abbtc5j6oyZY&type=album',
      'https://avatars.mds.yandex.net/i?id=723e5538c479e590f6f201026a7b5fea_l-5750239-images-thumbs&n=13',
      'https://editorial.uefa.com/resources/025c-0f1c23766a69-0c6bdb7fcbca-1000/football._uefa_champions_league_final._paris_france._24th_may_2000._real_madrid_3_v_valencia_0._real_madrid_players_celebrate_in_a_group_with_the_trophy..jpeg',
      'https://avatars.dzeninfra.ru/get-zen_doc/1775615/pub_6237c7c3e3ff9f2dde008bb9_6238db8338ae474aef3376aa/scale_1200',
      'https://avatars.dzeninfra.ru/get-zen_doc/50840/pub_5b0c116157906a5b9d78a80f_5b0c2a444bf161dbb1ad436a/scale_1200',
      'https://avatars.mds.yandex.net/i?id=05ddc89033d9d29dd7fef49c6b27990e_l-5314878-images-thumbs&n=13',
      'https://cdnstatic.rg.ru/uploads/images/141/14/32/1_5f454086_1000.jpg',
      'https://cdnstatic.rg.ru/uploads/images/154/88/11/1_a8420ed6.jpg',
      'https://avatars.mds.yandex.net/i?id=edf740b10f3d225c9075d4e313161fd2_l-9303200-images-thumbs&n=13',
      'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/BB1nt14p.img',
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // Количество колонок
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}