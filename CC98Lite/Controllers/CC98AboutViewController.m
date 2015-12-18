//
//  CC98AboutViewController.m
//  CC98Lite
//
//  Created by S on 15/7/16.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98AboutViewController.h"

@interface CC98AboutViewController ()

@property (weak, nonatomic) IBOutlet UITextView *aboutText;
@property (strong, nonatomic) NSString *content;

@end

@implementation CC98AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIFont *contentFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    contentFont = [contentFont fontWithSize:14];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.1f;
    
    NSDictionary *textAttributes = @{NSFontAttributeName:contentFont,
                                     NSParagraphStyleAttributeName:paragraphStyle};
    self.aboutText.attributedText = [[NSAttributedString alloc] initWithString:self.content
                                                                    attributes:textAttributes];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.aboutText setContentOffset:CGPointMake(0, 0)];
}

- (NSString *)aboutContent {
    NSString *mainContent = @"◎ 软件作者：小林 @CC98\n\n◎ 当前版本号：V1.0.0\n\n◎ 特别感谢以下朋友的帮助：\n•  科洛丝公主 @CC98\n•  Auser @CC98\n•  ytfhqqu @CC98\n•  欧阳 @CC98\n•  DJ @CC98\n\n◎ 软件中所有iOS 7 Style图标（Icon）均来源于Subway图标集，按license的要求提供授权条款链接：http://creativecommons.org/licenses/by/4.0/\n\n◎ 软件使用了以下开源组件，向组件作者表示衷心感谢：\n•  AFNetworking\n•  MBProgressHUD\n•  MWPhotoBrowser\n•  SDWebImage\n•  Reachability\n•  STKeychain\n•  RNGridMenu\n\n\n◎ 开源组件许可：\n";
    
    NSString *afnContent = @"•  AFNetworking: \nCopyright (c) 2011–2015 Alamofire Software Foundation (http://alamofire.org/)\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n";
    
    NSString *hudContent = @"•  MBProgressHUD: \nCopyright (c) 2009-2015 Matej Bukovinski\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n";
    
    NSString *mwpContent = @"•  MWPhotoBrowser: \nCopyright (c) 2010 Michael Waterfall <michaelwaterfall@gmail.com>\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n";
    
    NSString *sdwContent = @"•  SDWebImage: \nCopyright (c) 2009 Olivier Poitrey <rs@dailymotion.com>\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n";
    
    NSString *reaContent = @"•  Reachability: \nThis Apple software is supplied to you by Apple Inc. (\"Apple\") in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this Apple software constitutes acceptance of these terms.  If you do not agree with these terms, please do not use, install, modify or redistribute this Apple software.\nIn consideration of your agreement to abide by the following terms, and subject to these terms, Apple grants you a personal, non-exclusive license, under Apple's copyrights in this original Apple software (the \"Apple Software\"), to use, reproduce, modify and redistribute the Apple Software, with or without modifications, in source and/or binary forms; provided that if you redistribute the Apple Software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the Apple Software. Neither the name, trademarks, service marks or logos of Apple Inc. may be used to endorse or promote products derived from the Apple Software without specific prior written permission from Apple.  Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Apple herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the Apple Software may be incorporated.\nThe Apple Software is provided by Apple on an \"AS IS\" basis.  APPLE MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.\nIN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n\n";
    
    NSString *stkContent = @"•  STKeychain: \nCopyright 2011 System of Touch. All rights reserved.\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n";
    
    NSString *rngContent = @"•  RNGridMenu: \nCopyright (c) 2013 Ryan Nystrom (http://whoisryannystrom.com)\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
    
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", mainContent, afnContent, hudContent, mwpContent, sdwContent, reaContent, stkContent, rngContent];
}

- (NSString *)noticeContent {
    return @"1.本服务条款是用户（您）与浙江大学CC98学生网络协会（下称CC98）之间的协议。CC98网站由CC98或其关联组织所运行的各个网站和网页（合称CC98网站）构成。\n1.1 重要须知： CC98在此特别提醒，用户（您）欲访问和使用CC98网站，必须事先认真阅读本服务条款中各条款， 包括免除或者限制CC98责任的免责条款及对用户的权利限制。请您审阅并接受或不接受本服务条款（未成年人审阅时应得到法定监护人的陪同）。如您不同意本服务条款及/或随时对其的修改，您应不使用或主动取消CC98提供的服务。您的使用行为将被视为您对本服务条款全部的完全接受，包括接受CC98对服务条款随时所做的任何修改。\n1.2 这些条款可由CC98随时更新，且毋须另行通知。CC98网站服务条款（以下简称“服务条款”）一旦发生变更，CC98将在网页上公布修改内容。修改后的服务一旦在网页上公布即有效代替原来的服务条款。您可随时登陆CC98网查阅最新版服务条款。\n1.3 CC98目前经由其产品服务组合，向用户提供丰富的网上及线下资源及诸多产品与服务，包括但不限于各种网上论坛、线上游戏、网络存储、资源下载服务等（以下简称“服务”或“本服务”）。本服务条款适用于CC98提供的各种服务，但当您使用CC98某一特定服务时，如该服务另有单独的服务条款、指引或规则，您应遵守本服务条款及CC98随时公布的与该服务相关的服务条款、指引或规则等。前述所有的指引和规则，均构成本服务条款的一部分。除非本服务条款另有其他明示规定，新推出的产品或服务、增加或强化目前本服务的任何新功能，均受到本服务条款之规范。\n\n2 用户使用规则：\n2.1 用户必须自行配备上网和使用电信增值业务所需的设备，自行负担个人上网或第三方（包括但不限于电信或移动通信提供商）收取的通讯费、信息费等有关费用。如涉及电信增值服务的，我们建议您与您的电信增值服务提供商确认相关的费用问题。\n2.2 除您与CC98另有约定外，您同意本服务仅供个人使用且非商业性质的使用，您不可对本服务任何部分或本服务之使用或获得，进行复制、拷贝、出售、或利用本服务进行调查、广告、或用于其他商业目的，其中，您不得将任何广告信函与信息、促销资料、垃圾邮件与信息、滥发邮件与信息、直销及传销邮件与信息以短信、即时通信或以其他方式传送，但CC98对特定服务另有适用指引或规则的除外。\n2.3 不得发送任何妨碍社会治安或非法、虚假、骚扰性、侮辱性、恐吓性、伤害性、破坏性、挑衅性、淫秽色情性等内容的信息。\n2.4 保证自己在使用各服务时用户身份的真实性和正确性及完整性，如果资料发生变化，您应及时更改。在安全完成本服务的登记程序并收到一个密码及帐号后，您应维持密码及帐号的机密安全。您应对任何人利用您的密码及帐号所进行的活动负完全的责任，CC98无法对非法或未经您授权使用您帐号及密码的行为作出甄别，因此CC98不承担任何责任。在此，您同意并承诺做到∶\n2.4.1 当您的密码或帐号遭到未获授权的使用，或者发生其他任何安全问题时，您会立即有效通知到CC98；且\n2.4.2 当您每次上网或使用其他服务完毕后，会将有关帐号，例如CCID等安全退出。\n2.5 用户同意接受CC98通过电子邮件、网页或其他合法方式向用户发送通知通告、活动举办、商品促销或其他相关信息。\n2.6 关于在CC98张贴的公开信息：\n2.6.1 您同意您在本服务公开使用区域或服务项目内张贴之内容，包括但不限于照片、图形或影音资料等内容，授予CC98全球性、免许可费、非独家、可完全转授权、及永久有效的使用权利，CC98可以为了展示、散布及推广张贴前述内容之特定目的，将前述内容复制、修改、改写、改编或出版及可供CC98转载使用。\n2.6.2 对您张贴的内容，您保证已经拥有必要权利或授权以进行该内容提供、张贴、上载、提交等行为。\n2.6.3 若您违反有关法律法规及本服务条款的规定了，须自行承担完全的法律责任，并承担因此给CC98造成的损失的法律责任。\n2.7 依本服务条款所取得的服务权利不可转让。\n2.8 遵守国家的有关法律、法规和行政规章制度，遵守浙江大学的有关条例和行政规章制度。\n2.9 如用户违反国家法律法规、浙江大学规章制度或本服务条款，本协会和合作伙伴将有权停止向用户提供服务而不需承担任何责任，如导致CC98或合作伙伴遭受任何损害或遭受任何来自第三方的纠纷、诉讼、索赔要求等，用户须向本协会或合作伙伴赔偿相应的损失，用户并需对其违反服务条款所产生的一切后果负全部法律责任。\n\n3 服务风险及免责声明\n3.1 用户须明白，本服务仅依其当前所呈现的状况提供，本服务涉及到互联网及移动通讯等服务，可能会受到各个环节不稳定因素的影响。因此服务存在因上述不可抗力、计算机病毒或黑客攻击、系统不稳定、用户所在位置、用户关机、GSM/CDMA/3G网络、互联网络、通信线路原因等造成的服务中断或不能满足用户要求的风险。开通服务的用户须承担以上风险，本协会和合作伙伴对服务之及时性、安全性、准确性不作担保，对因此导致用户不能发送和接受阅读消息、或传递错误，个人设定之时效、未予储存或其他问题不承担任何责任。\n3.2 如本协会的系统发生故障影响到本服务的正常运行，本协会承诺在第一时间内与相关单位配合，及时处理进行修复。但用户因此而产生的经济损失，本协会和合作伙伴不承担责任。此外，CC98保留不经事先通知为维修保养、升级或其他目的暂停本服务任何部分的权利。\n3.3 CC98在此郑重提请您注意，任何经由本服务以上载、张贴、发送即时信息、电子邮件或任何其他方式传送的资讯、资料、文字、软件、音乐、音讯、照片、图形、视讯、信息、用户的登记资料或其他资料（以下简称“内容”），无论系公开还是私下传送，均由内容提供者承担责任。CC98无法控制经由本服务传送之内容，也无法对用户的使用行为进行全面控制，因此不保证内容的合法性、正确性、完整性、真实性或品质；您已预知使用本服务时，可能会接触到令人不快、不适当或令人厌恶之内容，并同意将自行加以判断并承担所有风险，而不依赖于CC98。但在任何情况下，CC98有权依法停止传输任何前述内容并采取相应行动，包括但不限于暂停用户使用本服务的全部或部分，保存有关记录，并向有关机关报告。但CC98有权（但无义务）依其自行之考量，拒绝和删除可经由本服务提供之违反本条款的或其他引起CC98或其他用户反感的任何内容。\n3.4 关于使用及储存之一般措施：您承认关于本服务的使用CC98有权制订一般措施及限制，包含但不限于本服务将保留用户信息、电子邮件信息、所张贴内容或其他上载内容之最长期间、本服务一个帐号当中可收发短信讯息等的最大数量、本服务一个帐号当中可收发的单个信息或文件的大小、CC98服务器为您分配的最大使用空间，以及一定期间内您使用本服务之次数上限（及每次使用时间之上限）。通过本服务存储或传送之任何信息、通讯资料和其他内容，如被删除或未予储存，您同意CC98毋须承担任何责任。您亦同意，长时间未使用的帐号，CC98有权关闭并收回帐号。您也同意，CC98有权依其自行之考量，不论通知与否，随时变更这些一般措施及限制。\n3.5 与广告商进行之交易：您通过本服务与广告商进行任何形式的通讯或商业往来，或参与促销活动，包含相关商品或服务之付款及交付，以及达成的其他任何相关条款、条件、保证或声明，完全为您与广告商之间之行为。除有关法律有明文规定要求CC98承担责任以外，您因前述任何交易或前述广告商而遭受的任何性质的损失或损害，CC98均不予负责。\n3.6 链接及搜索引擎服务：本服务或第三人可提供与其他国际互联网上之网站或资源之链接。由于CC98无法控制这些网站及资源，您了解并同意：无论此类网站或资源是否可供利用，CC98不予负责；CC98亦对存在或源于此类网站或资源之任何内容、广告、产品或其他资料不予保证或负责。因您使用或依赖任何此类网站或资源发布的或经由此类网站或资源获得的任何内容、商品或服务所产生的任何损害或损失，CC98不负任何直接或间接之责任。若您认为该链接所载的内容或搜索引擎所提供之链接的内容侵犯您的权利，CC98声明与上述内容无关，不承担任何责任。CC98建议您与该网站或法律部门联系，寻求法律保护；若您需要更多了解CC98之搜索服务，请参见CC98关于搜索引擎服务的相关说明。\n3.7若在本网站的信息存储服务、搜索服务、链接服务中涉及的信息内容存在侵犯第三人著作权的可能，请与我们取得联系。\n\n4 服务变更、中断或终止及服务条款的修改\n4.1 本服务的所有权和运作权、一切解释权归CC98。CC98提供的服务将按照其发布的章程、服务条款和操作规则严格执行。\n4.2 本协会有权在必要时修改服务条款，服务条款一旦发生变动，将会在相关页面上公布修改后的服务条款。如果不同意所改动的内容，用户应主动取消此项服务。如果用户继续使用服务，则视为接受服务条款的变动。\n4.3 本协会和合作伙伴有权按需要修改或变更所提供的服务条款。　但CC98和合作伙伴将尽最大努力通过电邮或其他有效方式通知用户有关的修改或变更。\n4.4 本协会特别提请用户注意，本协会为了保障协会业务发展和调整的自主权，本协会拥有经或未经事先通知而修改服务内容、中断或中止部分或全部服务的权利，修改会公布于CC98网站相关页面上，一经公布视为通知。 CC98行使修改或中断服务的权利而造成损失的，CC98不需对用户或任何第三方负责。\n4.5 如发生下列任何一种情形，本协会有权随时中断或终止向用户提供服务而无需通知用户：\n4.5.1 用户提供的个人资料不真实；\n4.5.2 用户违反本服务条款的规定；\n4.5.3 按照主管部门的要求；\n4.5.4 其他本协会认为是符合整体服务需求的特殊情形。\n\n5 隐私权保护：\n5.1 CC98重视对用户隐私的保护，保护隐私是CC98的一项基本政策。您提供的登记资料及CC98保留的有关您的若干其他个人资料将受到中国有关隐私的法律保护。\n5.2 您使用CC98服务时，CC98有权用数字代码、通用唯一标识符、Cookies或其他技术确定进入服务的计算机。CC98有可能利用所得信息对服务的使用进行总体性及匿名的数据统计及分析，　所得数据可供CC98或其合作伙伴使用。计算机识别技术也会用于执行相关的服务条款。\n5.3 CC98可能会与第三方合作向用户提供相关的服务，如该第三方为合法经营的协会且提供同等的用户隐私保护，CC98有权将用户的注册资料等提供给该第三方。\n\n6 CC98标识信息\n6.1 CC98、CC98 Logo等，以及其他CC98标志及产品、服务名称，均为CC98之标识。未经CC98事先书面同意，您不得将CC98标记以任何方式展示或使用或作其他处理，也不得向他人表明您有权展示、使用、或其他有权处理CC98标识的行为。\n\n7 信息内容的所有权\n7.1 本协会定义的信息内容包括：文字、软件、声音、相片、录像、图表；网页；广告中全部内容；本协会为用户提供的商业信息。所有这些内容受版权、商标权、和其它知识产权和所有权法律的保护。所以，用户只能在本协会和相关权利人授权下才能使用这些内容，而不能擅自使用、抄袭、复制、修改、编撰这些内容、或创造与内容有关的衍生产品。\n7.2 关于CC98提供的软件：您了解并同意，本服务及本服务所使用或提供之相关软件（以下简称“软件”）（但不包括两用户之间直接传递的资料）是由CC98拥有所有相关知识产权及其他法律保护之专有之知识产权（包括但不限于版权、商标权、专利权、及商业秘密）资料。若就某一具体软件存在单独的最终用户软件授权协议，您除应遵守本协议有关规定外，亦应遵守该软件授权协议。除非您亦同意该软件授权协议，否则您不得安装或使用该软件。对于未提供单独的软件授权协议的软件，除您应遵守本服务协议外，CC98或所有权人仅将为您个人提供可取消、不可转让、非专属的软件授权许可，并仅为访问或使用本服务之目的而使用该软件。此外，在任何情况下，未经CC98明示授权，您均不得修改、出租、出借、出售、散布本软件之任何部份或全部，或据以制作衍生著作，或使用擅自修改后的软件，或进行还原工程、反向编译，或以其他方式发现原始编码，包括但不限于为了未经授权而使用本服务之目的。您同意将通过由CC98所提供的界面而非任何其他途径使用本服务。\n7.3 CC98对其发行的或与合作伙伴共同发行的包括但不限于产品或服务的全部内容及CC98网站上的材料拥有版权等知识产权，受法律保护。未经本协会书面许可，任何单位及个人不得以任何方式或理由对上述产品、服务、信息、材料的任何部分进行使用、复制、修改、抄录、传播或与其它产品捆绑使用、销售。凡侵犯本协会版权等知识产权的，本协会必依法追究其法律责任。\n\n8 法律\n8.1 本服务条款要与国家相关法律、法规一致，如发生服务条款与相关法律、法规条款有相抵触的内容，抵触部分以法律、法规条款为准。\n\n9 保障\n9.1 用户同意保障和维护本协会全体成员的利益，负责支付由用户使用超出服务范围引起的一切费用（包括但不限于：律师费用、违反服务条款的损害补偿费用以及其它第三人使用用户的电脑、帐号和其它知识产权的追索费）。\n9.2 用户须对违反国家法律规定及本服务条款所产生的一切后果承担法律责任。\n\n10 其它\n10.1 本协会的住所地为浙江省杭州市西湖区，如果用户与本协会发生争议，用户同意将争议提交至本协会住所地浙江省杭州市有管辖权的人民法院通过诉讼的方式解决。\n10.2 如本服务条款中的任何条款无论因何种原因完全或部分无效或不具有执行力，本服务条款的其余条款仍应有效且具有约束力，并且努力使该规定反映之意向具备效力。\n10.3 本服务条款构成您与CC98之全部协议，规范您对本服务之使用，并取代您先前与CC98达成的全部协议。但在您使用相关服务、或使用第三方提供的内容或软件时，亦应遵从所适用之附加条款及权利。\n10.4 每项服务的内容及服务条款应以最后发布的通知为准。\n10.5 用户对服务之任何部分或本服务条款的任何部分之意见及建议可通过客户服务部门与CC98联系。\n\nCC98保留本服务条款之解释权。";
}

- (void)displayAboutContent {
    self.content = [self aboutContent];
    self.navigationItem.title = @"关于";
}

- (void)displayNoticeContent {
    self.content = [self noticeContent];
    self.navigationItem.title = @"服务条款";
}

- (NSString *)name {
    return self.navigationItem.title;
}

- (NSString *)info {
    return @"";
}

- (UIImage *)icon {
    return [UIImage imageNamed:@"about"];
}

@end
