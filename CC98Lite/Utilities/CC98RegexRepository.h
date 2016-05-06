//
//  CC98RegexRepository.h
//  CC98Lite
//
//  Created by S on 15/6/8.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PARTITION_WRAPPER_REGEX @"<td class=\"tablebody1 td-border-1\"(.|\\r|\\n|\\t)*?</td>"
#define PARTITION_NAME_REGEX @"(?<=color: #000066;\">).*?(?=</span>)"
#define PARTITION_BOARDS_NUM_REGEX @"(?<=个下属论坛\">)\\d{1,3}(?=</span>)"
#define PARTITION_ID_REGEX @"(?<=<a href=\"list.asp\\?boardid=)[0-9]+(?=\">)"

#define BOARD_WRAPPER_REGEX @"<!--版面名字-->(.|\\r|\\n|\\t)*?</table>"
#define BOARD_NAME_REGEX @"(?<=color: #000066;\">).*?(?=</span>)"
#define BOARD_POSTS_NUM_REGEX @"(?<=color: #FF0000;\">)\\d{1,5}(?=</span>)"
#define BOARD_ID_REGEX @"(?<=<a href=\"list.asp\\?boardid=)[0-9]+(?=\">)"
#define BOARD_TOPICS_NUM_REGEX @"(?<=alt=\"主题\" border=\"0\" style=\"vertical-align: middle;\" />&nbsp;)\\d{1,10}\\s*(?=</td>)"
#define BOARD_TOPICS_NUM_REGEX_RAW @"alt=\"主题\" style=(.|\\r|\\n|\\t)*?</span>"
#define BOARD_TOPICS_NUM_REGEX_PERSONAL @"(?<=total-topic\">)\\d{1,10}(?=</span>)"

#define TOPIC_WRAPPER_REGEX @"(?<=<tr style=\"vertical-align: middle;\">).*?(?=</script>)"
#define TOPIC_TITLE_RAW_REGEX @"(?<=最后跟贴：\">).*?(?=</a>)"
#define TOPIC_TITLE_TEXT_REGEX @"(?<=>).*?(?=</span>)"
#define TOPIC_AUTHOR_RAW_REGEX @"(?<=<!-- 显示作者 -->).*?</td>"
#define TOPIC_AUTHOR_NAME_REGEX_1 @"(?<=target=\"_blank\">).*?(?=</a>)"
#define TOPIC_AUTHOR_NAME_REGEX_2 @"(?<=class=\"tablebody2\">).*?(?=</td>)"
#define TOPIC_READ_REPLY_NUM @"(?<=auto;\" class=\"tablebody1\">)\\d{1,6}/\\d{1,6}(?=</td>)"
#define TOPIC_ONLY_READ_NUM @"(?<=/)\\d{1,6}$"
#define TOPIC_ONLY_REPLY_NUM @"^\\d{1,6}(?=/)"
#define TOPIC_LATEST_REPLY_TIME @"(?<=#bottom\">).*?(?=</a>)"
#define TOPIC_ID_WRAPPER_REGEX @"dispbbs\\.asp\\?boardID=\\d{1,10}&ID=\\d{1,10}&page"
#define TOPIC_BOARD_ID_REGEX @"(?<=boardID=)\\d{1,10}(?=&ID=)"
#define TOPIC_ID_REGEX @"(?<=&ID=).*?(?=&page)"
#define TOPIC_ALL_POST_NUM @"(?<=本主题贴数 <b>)\\d{1,10}(?=</b>)"

#define HOT_TOPIC_WRAPPER_REGEX @"(<table cellspacing=0.*?(?=<table cellspacing=0))|(<table cellspacing=0.*?(?=<!--data update))"
#define HOT_TOPIC_TITLE_REGEX @"(?<=<font color=#000066>).*?(?=</font>)"
#define HOT_TOPIC_AUTHOR_RAW_REGEX @"((?<=作者：<a href=).*?</a></td>)|(作者：匿名)"
#define HOT_TOPIC_AUTHOR_NAME_REGEX @"((?<=target=\"_blank\">).*?(?=</a>))|((?<=作者：).*?$)"
#define HOT_TOPIC_LATEST_REPLY_TIME @"(?<=<span title=\")\\d{2,4}/\\d{1,2}/\\d{1,2} \\d{1,2}:\\d{1,2}:\\d{1,2}(?=\">)"
#define HOT_TOPIC_ADDRESS_REGEX @"(?<=<a href=\"dispbbs\\.asp\\?boardid=)\\d{1,4}&id=\\d{1,10}\""
#define HOT_TOPIC_BOARD_ID @"^\\d{1,4}(?=&id=)"
#define HOT_TOPIC_IDENTIFIER @"(?<=&id=)\\d{1,10}(?=\")"
#define HOT_TOPIC_RAW_BOARD_NAME @"版面：<a href=\"list.*?</a></td>"
#define HOT_TOPIC_BOARD_NAME @"(?<=target=\"_blank\">).*?(?=</a>)"


#define POST_WRAPPER_REGEX @"<table style=\"width: 100%;\" cellpadding=\"4\" cellspacing=\"0\">(.|\\r|\\n|\\t)*?<!-- 编辑,鸡蛋，鲜花，等 -->"
#define POST_TITLE_REGEX @"(?<=title=\"发贴心情\">&nbsp;<b>).*?(?=</b><br />)"
#define POST_CONTENT_REGEX @"(?<=</b><br /><br />)(.|\\r|\\n|\\t)*?</script>|<hr noshade=.*?(?=</td>)"
#define POST_TIME_REGEX @"(?<=\"></a>)[\\d\\s:/]*?(?=</td>)"
#define POST_USER_NAME @"(?<=<span style=\"color: #.{3,8};\"><b>).*?(?=</b></span>)"
#define POST_USER_GENDER @"(?<=\\.gif title=)帅哥|(?<=\\.gif title=)美女|(?<=\\.gif\" title=\")匿名帅哥|(?<=\\.gif\" title=\")匿名美女"
#define POST_USER_IMAGE @"(?<=\"><img src=\").*?(?=\" style=)|(?<=&nbsp;<img src=\").*?(?=\" style=\"border-style)"
#define POST_FLOOR_INFO @"((?<=/></a>&nbsp;)楼主(?=</td>))|((?<=第<font color=#FF0000>)\\d{1,7}(?=</font>楼&nbsp;))"
#define POST_QUOTE_ADDRESS @"reannounce.asp\\?BoardID=\\d{1,10}&replyID=\\d{1,10}&id=\\d{1,10}&star=\\d{1,10}&reply=true&bm=\\d{1,10}"


@interface CC98RegexRepository : NSObject

@end
