Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AD86A7701
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCAWqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjCAWqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:46:30 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E381A65E
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:46:30 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MHOCl007223;
        Wed, 1 Mar 2023 14:46:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=tBrlWJMAkR3Lgumn2TulEo7OAPan6dvSXo1T24CgcBQ=;
 b=NWUJ/rN4gaBkIVWgfPICjV0sSZ2B18SpUYjQQ1hofj5xc6wwgXfEsm9QplpL0rtOz64E
 +9ooFWYmRLUoAJXfFlvsaK19BSz3LdYz9Y+94uXSpuOdS9ObDBI0CKxDHkMYvKCc2a/M
 Rr+IB0dgMAIQ3zUey389Dg86sn+t9z8duL53obptTmGlriAjx9DrtCi+jgCwLwMgNGLJ
 WZchbGW0AwP5p8uIufKgICPLjKNNg9ZOiKryBs636iAE04VhlgNOhguVqWufYqRAUAih
 jx+LCy1FMxFMWuygSbaRcgG4vFsA/ap4CKr7e/BhQ9j8s+e16XP0nroWblbXUxT+GRlt XA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyeg8cqef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:46:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wa7AfedyD+6WYCPhyZHld5RhT03TgcbCA5Y89qQ/TxkN3NHff+9xQou+e9a3IfGouR7Om/mwqxRruIY1n7mm/ljXyuCG5+K9fe6lVFrevHboXZ/wFMcO3Jn2WjTpyT2YMEAoYQoaqWNQRr+i6zqcgukyLTcXDb7M3oR5iexN8ATtQOHU/WzhSxXJGCFnf2///4h/kUzx+nVb3B8LDbtpo6LUC2qtXADBgNVARtyC1xYbW8sBv5sITdu2g4ZJ5betMcXs+b5XCknxV+pv2LIqLZiUmPrtp5XaSVWdjQ+y9CDa8jNEaGlRZTHl5/uWbGFylZYrL50gr76nKBxrkuxbyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBrlWJMAkR3Lgumn2TulEo7OAPan6dvSXo1T24CgcBQ=;
 b=Yes6nNtAG9m7oK/wvS/YOU0lB+TQI7gawy1E9hVoIZX60RzuqcKfi++PloZR1s1Be5h/zbgaeiEpZKdtyUGP+pQ3lAJ7Kaq4iwn27UT8j3nnvcOSvhw32hwtNNmbozx+P1ddAHVLfn8PGETuIOjacVlA6E4lb8Y6XrYc97S3+dXkLvUL62pchgYZKLjZyb/7RLadWv2ZAaFRRokTk9glnO7BxhCym86bA5DYw48VZHXDTLjk5+hdqKT3lY/dbI4IHd1Sn/1DYcWI9Vtylq2rOKhcBH6AbkME05QWf1OYkzo343tvthIO0MBiPicQG3sermZWsX5IslE5sr9qP6JV/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DS0PR11MB7285.namprd11.prod.outlook.com (2603:10b6:8:13d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Wed, 1 Mar
 2023 22:46:23 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:46:23 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     "Luke D. Jones" <luke@ljones.dev>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.4 1/3] HID: asus: Remove check for same LED brightness on set
Date:   Thu,  2 Mar 2023 00:46:36 +0200
Message-Id: <20230301224638.29187-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0104.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::30) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|DS0PR11MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fe1b35b-5ffe-4906-564a-08db1aa6c85f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDvy2o+TnJTgOyt1eJlpHSB3ZYbnFYYuI2vQHtZMMkRuQjrfIypBVhSDEBpQY15Ea4iDgFgmdWnLb8tMmjnguPizpOmEZ0OSsQq7BWhcnJzdU2tcu4bH7U7g9TMZkFhV30asmm2++OlFooE8HaY0EUZjdw2Af9GW+sMZIey35/nOvia3uLsALW4DtfHdXa06WGl+hJKooNBn3J2buPDsoBZqNdstFD+UIojb1sXe1PGni2yL9Y1njlV1m204Bkd0E/SOav16As9aexYP2ZPm80hsvt9Hex/yyFASSR2UTO5EW2kdSMg0FqoC58oYct2R3HpOEwFlGh894Of3pu8m47l8417TpfhkeJmpn08Bw5qbbzS9bWZxEzMGhLTOJzuTIQ3mum+cMBv0MS1Zfq9sGXrtnVL/Dnau4/aHGQg7NUhAsuitvCfMVokzU+tasuV7ys2HdhuV3qAIjB8XSepYCkzSDthwlh+qxmZ/pfJsF/F+W8s1ekvIbFBsoYefWSF3qMNbpl00vaAftsmeagTU20GWR7vRI7DnJJzb+EEJ0xjYFhMHQU6VyNGR4IxxCcRS91zLKNd2ZuNfVzi0ByNEZaVCTResxzR0ctGZsu5dbHjlHzf/kAI7SL3rlnVSYRSnUfuSgfyWlbf2VeoJSLMm6v8+Iwy+skap67oos2g6N1vph2sWVIH4mqqXKoKYZuBBnarMyKFx/fQe5ekdTXz8Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39850400004)(396003)(136003)(376002)(451199018)(26005)(54906003)(36756003)(83380400001)(316002)(86362001)(6486002)(2906002)(4326008)(44832011)(8676002)(6512007)(186003)(52116002)(107886003)(8936002)(66946007)(41300700001)(6916009)(66476007)(66556008)(5660300002)(6506007)(6666004)(478600001)(2616005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GIv9elyiKKPAqq5AZwol/to30E5Ex80KHtZp+8VQfqE8tynK+pCgcifzha3w?=
 =?us-ascii?Q?1DA5B7TFfQswaF3UxP6uQvN2ETB/uwDqa01PhV6X14u4zYvVe/woTrAvlR4o?=
 =?us-ascii?Q?D8IORtqOuLSA4JsVFPjSnuxH0T5IMlFcklesc/z+ES9SI0Ix6GOov6gGeIrp?=
 =?us-ascii?Q?78qlYrZHYzoYdQy2rKaUnTi4eFFtJSy6ypO1+HeNsG9jG+/yxhyvSLRuIUul?=
 =?us-ascii?Q?G5hEkU5OXARBnhaKYWhRwWtQoUdxbnAVREXl3F+IVaaSRAl/qEQXUrliGXLh?=
 =?us-ascii?Q?IIzzu3weh4XioG2iMOX4IDesu4xJKEQTthVRLBeAPZODGisXXS4czUCeFvXN?=
 =?us-ascii?Q?+6cBczBVmNaKOWIk2KtkugHnnEU/3LPPQ1jZze/99Eyxt0QRNdlpj4Dxe2B5?=
 =?us-ascii?Q?ztmGMRuSIZftkGkAeN6REMvi3aZTfLsAjECGp+qUQonHWO0FtJwD/6+XCPUw?=
 =?us-ascii?Q?Uf6o+EUWEdrRWy86U7RNM5nmEmVm+IpIFth++BMO0e4x+mx2nes9HepqsvZC?=
 =?us-ascii?Q?7Ol69J8L9ANW3Sn2TNrCfWdxdAZdjQpVMotYZ3sKo8IiuAniN+dj5ZgazOdJ?=
 =?us-ascii?Q?eyvYIPsgM/v2PM/cJSIe2CaJtGuqrooAspwF4e1RRNeak6mEvoR6+UecZJTI?=
 =?us-ascii?Q?2x5rqNEPwTeDUIkR8K7BXfuOgD0YDs6ZlC3nXPLIX9RUvkdle7Ebnu/0MyLj?=
 =?us-ascii?Q?Zw8y+pUGQBSjW1aHMtmODh+8qqpfqoTkM0Fkq2/TwzLSiPsbseSFE4ne9y0Q?=
 =?us-ascii?Q?EdNdoHlbEGv456TBn0Xp6IPag5cXk+ft7Vze0C3QzA8HkEWlBZH6o+YLpL9R?=
 =?us-ascii?Q?Hc/PVzjKryPTqziFRIGWS8upKacpoQmptwu6vYeQq4QEcdADiczYCcJWr2H+?=
 =?us-ascii?Q?7t8Xj9i0s6D7Sib1s8sLeAFCWf0/Efkg3Om2AwpOLyJmSSyQv3Gh/hfHXDJS?=
 =?us-ascii?Q?D283BCr8Tggi2U+gTzOjn6hFjdtjxqP/eg9tWWXf4LjK9dGaTojXUpxyDvyu?=
 =?us-ascii?Q?1UcV9T8a+XzNsHpQIJreuEUTCWJDUF8LZcwk0px6hZNU3TH8jJxL2plzAn61?=
 =?us-ascii?Q?LonVTNBph/jH97TQy0o6Oj7T9QmcQGvnf+t1HaHSd1A6DGMno9NDUT2/h35g?=
 =?us-ascii?Q?pvTk2cBwHD/X0YH1LyFpcEqxOngRzbjrfai3mfCrWuQV+59Xo9tUWV39YZ2P?=
 =?us-ascii?Q?sBasbgOgsOc2Sgiuj2sLUn0r1GAWTT7A8QF121O8VnM1l2Gm8Vl0nv/mcOvA?=
 =?us-ascii?Q?OOzgE42E6VWNh1gAgiGvib0a5Uvh6NbOTAFYSY9ONnwonFCibRbQ9HoOBHA/?=
 =?us-ascii?Q?8NpQtFRH88e+p8i0lqp+aqG97eolskC48bket9P1sAnPRnuAj4rtfy2xv8gM?=
 =?us-ascii?Q?zMwWOniUNXiI5TXM+l1Ct1e0Bl7Uw3DOpIx+w0AxZRjdGGT/iQUuTHK0ifCx?=
 =?us-ascii?Q?opVoD/fyFRUjE5o6KyUCQVI7UZWOKIKpGqRS0O+FXFXoqszKRp75tjuLrvx8?=
 =?us-ascii?Q?VhzCdPLjI8lL2DeILYY0NbQcDQ4lQfUmoMclAk5WJEXHwc1bHS0ra69etkoK?=
 =?us-ascii?Q?2XKW3GY6fP9ieQFrDzHnEob7Npxl+qBpxdfiCdcZQFOJxGG14H6RKfmJvPEK?=
 =?us-ascii?Q?2wv9JaaP7LsGH2BcVjmVzrA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe1b35b-5ffe-4906-564a-08db1aa6c85f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:46:23.5097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUPwqOLu4aAJCIw0wqzIQKLu0na95KcI2f9GvFZINYPzP/xCFV2Z11Y7GTUt0t2CG7d5IZsQwoFlQthGkTej3Yl8SHSsDvNO1gCYo60xLMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7285
X-Proofpoint-GUID: Oh6c_ps9Y1bvnQwY3ni6nQjnyrEx-R6f
X-Proofpoint-ORIG-GUID: Oh6c_ps9Y1bvnQwY3ni6nQjnyrEx-R6f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0 mlxlogscore=932
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303010183
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
index 7f84ed0afdfe..d3aca8f80de4 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -351,9 +351,6 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
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

