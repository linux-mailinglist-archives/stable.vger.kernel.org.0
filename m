Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F645BD611
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 23:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiISVET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 17:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiISVER (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 17:04:17 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08904BD00
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 14:04:16 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28JIU8qm023572;
        Mon, 19 Sep 2022 21:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=KsFtA2qIWe1sfE2HXFuazsAi58lb+/W4s1nPPB3eLG8=;
 b=oS1aWsOdLgjcP65YSnByXXZUXdIwxnNYX/xuNriTOWi2XCCWUzL5Fl9fPDHixENzp6F+
 oOmNtWDbxlCRoE5R2GuKTiImosXJUc8e8qUiehrQsZb2juF0ObTB/RCtPOuXC8u7Yny4
 2jMhvphudll5zlDiuSPbIRdK8CFDGKpIIGpwYfADFkTFJEqb3K4CZOYZ5x+HTwa7vI2C
 P3TRZXjqUs/8/iH1+3000vmGrK3Jl0oZymRH6TpUxBiiJ1dCJQ1vNQKRZTWLrkewt1uO
 O5+6RJOVjZW6DQJeDWZluYQqIG+uO9hcXmEvOBCeW5kCvUb5Zxr+h83JOcOsYBj1sSBi Ag== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jn3f1a1gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 21:04:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgnyjY7B3LAB+kF1TOIRMwIKxAgr3QYiptF+4pJ6SQw0lSsPt+gspBuHMxgMiEw7hLanksTGnG2d0FgHBrvLKs5OYMFzR1MIr9coZMyOgY8V7NEf/7OYSA6AJBJ/Pqy1XG358g/o9T0LqFFOA8tvk9W3MwgDNbWRTI8Wflssgl9olzsrxvutH1mIJkhktpHgNfCslQbniCTtvcKs/FP9EddWmxX5yAOWNo6hDe1sinmRol/RQlDZfYv2XXGe4yVI8dGQfka7cyWHbmCn4145v/0RxGBtX27dAm4aVXtkNMSsyfPHEsbRqEKjBA/t1y2aBwL/bP8ZbymZFKtwtP49iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsFtA2qIWe1sfE2HXFuazsAi58lb+/W4s1nPPB3eLG8=;
 b=QTHlbatY3hMiiKWo1PIFJDOBupih+6LjcPEd6VNh4E44ohoc/GdYi7ivNF8Qfqyw+Xm86QYYVvVW+aJZnVp6Iza4ykxtZB1rRMydWOCqKFfFcFAs8PWN3vivXzwgxsgmNhdQuME5hByl4Jzb2Yrm2jaROHVsNzKw8n87S8IUEgT5LULq7IePY0HSKlGUKZkVWFV181rNB6AfVyHvSRGuujOgX9kt4NovKLrHxMepGkhLXesL0elP2uYQ0pKoTE/lQneCLOwYJqiWDtN1dka/FUVTrABwVz4jy7Pm8BCg36gPC7OUD69cwPWs7n+mYhOA+hlqjib+J3+CLaYKWYG/aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DM6PR11MB4515.namprd11.prod.outlook.com (2603:10b6:5:2a9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 21:04:08 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::b1f3:22ad:609f:35ea]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::b1f3:22ad:609f:35ea%9]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 21:04:08 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Helge Deller <deller@gmx.de>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.15 1/1] video: fbdev: i740fb: Error out if 'pixclock' equals zero
Date:   Tue, 20 Sep 2022 00:03:53 +0300
Message-Id: <20220919210353.29973-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0042.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::8) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|DM6PR11MB4515:EE_
X-MS-Office365-Filtering-Correlation-Id: b097268d-ba0b-41f3-38fb-08da9a827e84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BvG5yXV5IcWreqUVxuUW1Kje/s3ARZfm2rg3sJt1HNc9UG18xt1kOAL4G3KfM1dlc1Dd+Z8glTmo92j3qshnBjHaaZuMdgydBv0oQ6+flvjnD2UxoE7AJIiGFMPw6mLdR4q6Uf6h/Zm7LlIj9HB+HghF++NjPUUPK5VnsIqjIi4o7VedixMyF+glRQUmiPcX1w1vo7Gq40pw2XvOHzFhEdimkPbQAnQy8vXWBIXwlLKv/eGqxdweVv6xfh5q7a5aMOr/WP22Wa0id4Zvy47nVk8LG/i+41ag/2Vw1i4G9bP2ciMuowDlKVMvFtr1TbRb8dssSVnOjm+b4D2T7uuJ75KjpfWq2JL8WYaWW7z2oG40Bpf5qxj1WLKXdvtWUVriOYRFa4MjcnOE2jy2NmNf0W7bAnOdgKLqi391vZPpveX4BxrOW2V98mP/Km7Dobe4zFbvR6/J0kaQhM/0rFA3N0PVbicmw6DnJpZeRxcZkeaNySHKnY0zsaSAubNGJDmY4RUT2O43ff0Bam4T5KNagOYhoOmGveFspeCiRO6kR19cTvPFF3yAwI57N0nN/U55iAeMNXlj5tVNALRl2hs0JGxkRq+uysNCFv8qrq/rC17wKm1JBvlBkGksHLm5kj7bzEPU2S1KZ+vZR3heC8LWjxgADy5A4qVbaCmAdhsMgaB19gI0n+XLgavC6ftz1xtNnOshBaBBFcoqk33a7WainiVXdeRFIihkpXxhaP/xQb5090aCeqIz+rcU9f1p+JZklHGny+F3VqRtg7gRIn3pC9AHX1QYkGmFkY6g9oRhNa+gW3am22Ea5au7lfVfksUK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39850400004)(136003)(366004)(451199015)(44832011)(36756003)(2906002)(316002)(38350700002)(38100700002)(8676002)(5660300002)(4326008)(66476007)(66556008)(66946007)(6916009)(54906003)(8936002)(86362001)(1076003)(186003)(478600001)(2616005)(6512007)(26005)(83380400001)(6506007)(6666004)(6486002)(41300700001)(52116002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+wLsbgy8X1tpiJrOW8eFrbW2RD6lE0ZDzka2t2DwWq5FiOtfrw5UuTyDw8Bt?=
 =?us-ascii?Q?k27OomjyMNHvBFwx5VPrEhv0GPoAt1AuYpSAA5t6MAhucVr0tXpzQSWLBO10?=
 =?us-ascii?Q?PSgS1Gwj4gid098YvKxaiE/2LahWMXOnzzZmSYbkq0Lzcs/Zo0NSRx0ujge7?=
 =?us-ascii?Q?GcgvxXvM86H0EPN9F7EECWkZG1vyG/ebGxBIJSIn6FKK+W0NaM3TxJhUoQy0?=
 =?us-ascii?Q?NQDHWRG768gge0KPxkLWnaly4rj6luxlp8VHP0BUj9KAJcL03qCCr1+48LT+?=
 =?us-ascii?Q?fkeZkPX+pHBBP7S+HUAWrqWzrUBb3F1ykQ5BFet0Qb57Ha58it5X/wzek2aj?=
 =?us-ascii?Q?aF9IU1kRlj5xMFMhxCrd7S66pvWp4Ond8dDDo6Cx1v+7K20hrIhNwRjySJs4?=
 =?us-ascii?Q?6u8ph4dsNIFeRvuv6PZUOhF60um25+mIjcBf50aujMbHCJoSNIAWTG5Ob3Cj?=
 =?us-ascii?Q?f8B5/1Oz0wRzWpj0ljVQnzYGhI09ugV9uKFt9CdZ7mK0RSUQtEkef+AlQeT3?=
 =?us-ascii?Q?N/HQE0j0v69hntYJEFp5HFPxgyCmKHcUnz4G0OD/UC152sBz9NU8Nr9VPZfJ?=
 =?us-ascii?Q?8FE+IXXH+w2gPvdDAd2b4tc8upkGc8hMAT/ovgvKKGsRGc7+SzapCUQ+aydU?=
 =?us-ascii?Q?tfmxMAC51hw2/TUyI0441DVGYuAUawJS/0yONs4AhwDCYrA/L+bQT/5enp59?=
 =?us-ascii?Q?OeJuR36ZqqJEYP5dkD/rSvCBQ06UXQ762p3EQGAmlJ6VwbTPWUFqigIsTckp?=
 =?us-ascii?Q?NE+7luHcrvnvqlXAcrX6QA7Qi1bijJU6oYv1T5EtplhQ9I0Q5Rh1kcN0OjoX?=
 =?us-ascii?Q?hi2dfjCVzg5TIJD9VJ0k9agVI6pIjbLb80eVmT6ouKCnu7CEkXcm7OmsxMxI?=
 =?us-ascii?Q?Hbl5Fnjie1q64zorAbA1sZc03jrJ9F8FO60N7CLSqw6brWSmsWojlmCVJKE5?=
 =?us-ascii?Q?lyY/VNpZVkI55zgVEiit7IAyNNRY1lBMz+a1m5mjpjCE8vOLQiklepvUF4uf?=
 =?us-ascii?Q?kOJW6ftp0efcMQzAorlWUifJARt8vA9qh+1LVldzedEL8Hpycb7ghFbIzvtV?=
 =?us-ascii?Q?pkGknr4nKuOMsnrjRQ2Fj+kvsfvZ5FKOaN3J2/JMY/aDF7OS1o57C0GMKYno?=
 =?us-ascii?Q?7g9L6b9N80uJycee5EWXiLTzim+R/auGAcGtfI2k9/NTWKjI7RBSy3Iyrqfk?=
 =?us-ascii?Q?nYMAdzPex+PEFmFimIGy/5TYg/lUUxAGh6G5CC2rxXpUYZx6hGu5/Bpacx5o?=
 =?us-ascii?Q?JBg/yv8EIQ0HQ6f+Ucf2PguHzBB1CVRJ+uVk0ZY0w/iIfNt9eOysN8fCeKfx?=
 =?us-ascii?Q?J009JWzBeBdKYCJjCIJjG4ZUfaVcmcv5+51PahbItqCd9NslLMEDUxEzmX4g?=
 =?us-ascii?Q?RzQStBapnsdioLZdAJ0RJIdgwmY2k4Av0Cis9O77QT4A5Hl4zkH5dFGQxp4F?=
 =?us-ascii?Q?gefWyZToqzORKSIsnkXhBP6lK1u1KQqfptRGG83N5YikDdfz95+emFiBMjX/?=
 =?us-ascii?Q?F47LMp1zdJoBYKFlGe/jU8DdcBljjrJYUbYwY4I/ScDc395mod6bIpuDi/Zl?=
 =?us-ascii?Q?m9bkxcswEFQITQjjl+/Y/d00a9WaV+K/AihN/bJzFUMzD8jNth18a2T8SJ12?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b097268d-ba0b-41f3-38fb-08da9a827e84
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 21:04:08.7241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vLZAXkt211R6UwbxwW+bdK4n/L0duXlO64+UK9k/IIpEtVXjTW4UB0+5kCW40o+bCoiABkTVjiFEDSKcXVw3MKwSp5nJXtF5AQGJWcxJ0o0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4515
X-Proofpoint-ORIG-GUID: 6hz40LVD_WX8T9fZOPif3p63LFfggcuc
X-Proofpoint-GUID: 6hz40LVD_WX8T9fZOPif3p63LFfggcuc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_05,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209190141
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

commit 15cf0b82271b1823fb02ab8c377badba614d95d5 upstream

The userspace program could pass any values to the driver through
ioctl() interface. If the driver doesn't check the value of 'pixclock',
it may cause divide error.

Fix this by checking whether 'pixclock' is zero in the function
i740fb_check_var().

The following log reveals it:

divide error: 0000 [#1] PREEMPT SMP KASAN PTI
RIP: 0010:i740fb_decode_var drivers/video/fbdev/i740fb.c:444 [inline]
RIP: 0010:i740fb_set_par+0x272f/0x3bb0 drivers/video/fbdev/i740fb.c:739
Call Trace:
    fb_set_var+0x604/0xeb0 drivers/video/fbdev/core/fbmem.c:1036
    do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1112
    fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1191
    vfs_ioctl fs/ioctl.c:51 [inline]
    __do_sys_ioctl fs/ioctl.c:874 [inline]

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 drivers/video/fbdev/i740fb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/i740fb.c b/drivers/video/fbdev/i740fb.c
index ad5ced4ef972..8fb4e01e1943 100644
--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -662,6 +662,9 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
 
 static int i740fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	switch (var->bits_per_pixel) {
 	case 8:
 		var->red.offset	= var->green.offset = var->blue.offset = 0;
-- 
2.37.3

