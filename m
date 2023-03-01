Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6788D6A770E
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCAWr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCAWr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:47:28 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52321D901
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:47:27 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MkPWv011336;
        Wed, 1 Mar 2023 14:47:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=JEmniTj5YadpwZIQEpxLKwP0CoqX1AbuuKBoPd4P0TU=;
 b=IN3qXpv33D7PXxefBdEONM5zG5n7QKI0CX9QkwFK1qNbTwvC8GXUIivs7pXIaCLFkOme
 Aj6yRGK3UP5ItvyAOKhMTe4JFFxbVJD77I/RpYvhC+1S05M/64sYnceNmECFtRCzeA+o
 sJjY5d952TZdWqV4gwDwB6myJ7YHU6z6DSNLffYk/mWJ3sV1fAbx1Ws+8AaDdbfzUnvA
 A4fkt846u3NB/rDMuUEV/cDCcnpp5wPA4fBPVdA/EhsTIyE4cmkN/0V7EbUwksNqWJDZ
 NGOP8lNoUOPlBj5hUkwLWkPjcWpetIDYcSlK0FxbhlMF7PWlgcvRYdRbGOCxVwdQgYh/ 6Q== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrchu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:47:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKqI6KohD2/W3yASxXiq+yvuX06BAgo4uY+ReKAh8ZErbir88JjKA/cYnCelGPapMB8q92Pw5u341xbIs/tQzu19Xc0HCTG9ADj+x6j3+ICqwoMrlByzdLvjpYNmGvRkIca0ML7X1j2vex/viWxZy/bOQHweh/gogA/MWEnXy1bY5tc5klx7f5DBUZaiucy3xypvD2Ala68N2frOrHM3/UnkaYP1vZxGgwZuaHeFH+SCS+Lq8F3j2eS3K6kyj68D6uIVNIRyhiQnkt1N84dtRwlv/8JSXqJrl40fMQMEB28mCSVTV+/4AnwVYOVkQTKOvbtPJAItmNl1mhPwhx+1vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEmniTj5YadpwZIQEpxLKwP0CoqX1AbuuKBoPd4P0TU=;
 b=RYgouFwtMwnTsEoUkaqN63FDn+QK2sMgNzJ0+dFtZAHVwQNYPjjW315VdXRy9imC6bMxF6GAjviEgQrKpYlzt1M9uHHOnK+GvYiQtAFeOngeaXojlDPE0fNW9auGPCfe7MmmF1koZkmBnM9lbM7vK8riSIoRkvC5gxKPT/lYrVedeyEZ6JCj31X+jb5LyCOu5lOJx6Mgv1syN6C5tRFhgm6LVL63h3jhb+1gM1IMmTJ9YOzWeLIaMTou5lLEQXYJ29MPCWRuyXTOqsp2WfLJNcIEsKpnlLpq8fYhOh9V1SZwky1kWVIS1EwqSI9Kb2bABzO1c2HdINC+1tuwQQ8Bkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by PH0PR11MB4935.namprd11.prod.outlook.com (2603:10b6:510:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Wed, 1 Mar
 2023 22:47:20 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:47:20 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     "Luke D. Jones" <luke@ljones.dev>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.14 1/3] HID: asus: Remove check for same LED brightness on set
Date:   Thu,  2 Mar 2023 00:47:32 +0200
Message-Id: <20230301224734.29357-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0162.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::16) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|PH0PR11MB4935:EE_
X-MS-Office365-Filtering-Correlation-Id: 75822413-f31f-44c3-67c9-08db1aa6ea63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yD6dklCfkN+8n6Bhsq3DvXC6fkrKYoWYXOdMeDEa06BVkk0REu7rRi/GNjbIe1CILx+Xai19IatFTLdL4mDLmFAkQlvylP7DpB0Wh49DR8zkiqrm+Ev+ITveme/0/Fq22Z9KDBJgpc1gvh4SoxzJ8IDa4Ykq75yj2Y9Zqs5msuidTpsjcZRHaIaSnZiIzBefpisczPUPm8ULNoOKwsv9pik1JnYlvRmuV4rez097dp+gAs9qJdJHCEaKMhMvZU6Wb2VmIHJXJ/MFNNTN9hpXqL0FKwSkQFXCCZWU9ltGCgKyDkMFATawMgAgY3qNchKX0/8FsinOBJgFxxT1nwg+znIUu76W0BTrMN4M3N0RzsdU8ezcrwyu1LDbKosRw5ApnffWOtZoHniZYsi8Rw75e+lJ/VwgnaBF/ozOzTVSNREQD3oIFl6nY7VtFWbjfjhAxfDXQchSor/JKJgng7aYF/Si9vzllqozum4/OAfYhF55SAiYS4U1TeNpJBHTq63jBQYr/as8gdCPuJN6lc6SBwIV1H2je6HwU6f9m+Xn6gsN9Rx8LAshxg2Wy1R+Lrxo0armr1R6ESUab2sDb5CH0rT7G2n9D1MvYx5ysCms6oGLnm3s/TXaE2e00TLMROS/Lc0GLGamnMyAKTdXDL1xWN1zDyPnNvkrzthmIm2NEHl5No3bRxA7PwerQ+Qtonyrh1/GPsB/gs3PMCMd8ijvpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(451199018)(83380400001)(107886003)(6666004)(36756003)(38350700002)(38100700002)(8936002)(5660300002)(478600001)(66946007)(86362001)(2616005)(186003)(26005)(1076003)(6512007)(6486002)(6506007)(66476007)(66556008)(2906002)(8676002)(44832011)(52116002)(316002)(6916009)(4326008)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?emultT0qvVtfmwibeMmy980Ck2kbKyYcCkHyQGoDsMry6fC2gSntWNGuyxvP?=
 =?us-ascii?Q?sl+PtxqD9DD3E/LY65Grs8CUhP1CnWDkq3jBoqSN9oq1Fs1kLJnR7XkHOxfz?=
 =?us-ascii?Q?KMMieLNy2wwOOqPCCNZ8u9zLu6CMvDGtxfcFUWKtUvVmtUeXEu89uY56WhUV?=
 =?us-ascii?Q?7AXizHMsD2JijJQtUxif6gK6bP1yrfUoh6ld/fcjB6tl9ipczNL8XaUFf+wt?=
 =?us-ascii?Q?CCUzIF96zAMlOiYQYQWy9Yif5ZcDeSiaY8xVTDPiOlClA46iTOr2u7s/DuYV?=
 =?us-ascii?Q?YHyO1EZ0HIsLDQG9TKTTLT8wDkxpF57YI4i6VS/ZUD5viTZxNuI9UWsbC3G7?=
 =?us-ascii?Q?CY8MxT6IwYhg0Hv+NE+qdmvuc2kzXJ/oxz7sHoPlYsrj/jE5Gx7UmC0gUHYK?=
 =?us-ascii?Q?8WCQ6z7C35ct2RHjC//LooM22nxDaXpxfnwyUMoQXOfPFxv4THLZrhPR3Ei7?=
 =?us-ascii?Q?ZZKkQ9LTQMfaoioVhrzZwG3UHoUQOzj4tZKfhkcO7KSiEFxlAZIMiUrVY+NQ?=
 =?us-ascii?Q?iVvlA2LWXrr09qaiztjZWaHkDRPheyQzRHB9G68bUONlWUA1pO57QDu4O7at?=
 =?us-ascii?Q?fbDIbJPM0gG/DoS3MLTjF+GUEloCRE+7kq05+k5LNYELVn1S1TOCj9IRe7/b?=
 =?us-ascii?Q?nGU3pTIY9DHR27rQ2oJOFyDmZULVvXKObttF5wP6wR7AKdnXN23htonSNZWA?=
 =?us-ascii?Q?4uPyfBBlXffw0PzwWl7yU82alEaRdIO4bSGyCJY4wX70dFgVFP2/FlGUl48q?=
 =?us-ascii?Q?Dn4c4Re5uFIHMeeZriKiUARJLJNJevOnkUgvAZbyiq/h5/9ynj70CZatsdVa?=
 =?us-ascii?Q?5owXHkGRDGXNzD40V1J2iKbOATfgaoaZdIXxYw/Q7PkyCyyXSZqt03ttg4Pq?=
 =?us-ascii?Q?9DkBwbeskE1rjZxPiX3pJhfIhfxP+kFZ/mRhNOsgqQ2BVUnKxmn1DCcGMCrR?=
 =?us-ascii?Q?SNTK8r8rbsLcSVHUheXvmomAA30weDj+wlcqHtI6sgikNqLOoZA1QMyCjbu4?=
 =?us-ascii?Q?5m3DKwvARyeNL15frQz8cHkNmwviM8NiQTytYSAhqmiGsPfPcC/16W643ziR?=
 =?us-ascii?Q?MIz10hqUnDCJ38M/pWUcyYweGjeLZMoTltADxgYScJTRKJ9NLq59M4MaTNig?=
 =?us-ascii?Q?7EM2pzyqXqW+lvjZpmLes5xgXHD0ut5xj0Fsr/aK3A9iIN0kYAJgzbFfHXoT?=
 =?us-ascii?Q?O0gOYVsT7o8kJRDwjlnWWi79XA0EqQtgD+0nmE+5ECevuvS9lR1fTS3bu1o2?=
 =?us-ascii?Q?oaKU3OgTcMY8YeU0X9HdDPAopzUGu6DrK1UubSsVhVkAaaVPtaFuuJDSlVmW?=
 =?us-ascii?Q?MidsTkxPPBbvoRu37++EM0sxWFph3zMqi6+ZDOHGATcNO/VvBF7+zFejUWQk?=
 =?us-ascii?Q?0xfPmqO6G8aFkUyswsVLh7oq+OM3xrEy2gs+rOWlAZvwUBPRA109fYp4fBQH?=
 =?us-ascii?Q?EkJBU8hMhUyYs1WJPJkzfHbXkpPuXe7GbHqSarvumFaXbIZMBIzXCSiq8qYs?=
 =?us-ascii?Q?Y1lzrDMZKbHOigKJaxuN3ybTLEag8xM+UAH3619iJaYwBqk1oSQQqn+Blm9G?=
 =?us-ascii?Q?i1Tn1jlxBKnR9gRg4RaoK9VGg6orSRQUIJeGyn8s2l2h6o5r8HTi/+wbnrZg?=
 =?us-ascii?Q?KU86zhuG2gNlEZRWk1JPpe8=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75822413-f31f-44c3-67c9-08db1aa6ea63
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:47:20.5614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F3WdCXE0mJkMVo1PpMIcG+KNS7loJhAB0GdKUiFVSn9DfNCJx6MzjOLapUflzYqVPfhZuNQr39pM9hiDCY+guij5zcGFdtx6j3TORlXq4wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4935
X-Proofpoint-GUID: fF-CzHdR2OX89fPaoc9b-MM4sNOjTSab
X-Proofpoint-ORIG-GUID: fF-CzHdR2OX89fPaoc9b-MM4sNOjTSab
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=932 mlxscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303010183
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Luke D. Jones" <luke@ljones.dev>

commit 3fdcf7cdfc229346d028242e73562704ad644dd0 upstream

Remove the early return on LED brightness set so that any controller
application, daemon, or desktop may set the same brightness at any stage.

This is required because many ASUS ROG keyboards will default to max
brightness on laptop resume if the LEDs were set to off before sleep.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 drivers/hid/hid-asus.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index a7a63abdea86..c7ae4b6d9fd3 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -298,9 +298,6 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 {
 	struct asus_kbd_leds *led = container_of(led_cdev, struct asus_kbd_leds,
 						 cdev);
-	if (led->brightness == brightness)
-		return;
-
 	led->brightness = brightness;
 	schedule_work(&led->work);
 }
-- 
2.39.1

