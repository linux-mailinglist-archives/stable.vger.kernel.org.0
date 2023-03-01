Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A426A76E0
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjCAWiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCAWix (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:38:53 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF75868B
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:38:51 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MV0hs008026;
        Wed, 1 Mar 2023 14:38:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=OpBjqM2auNYRotwvNBdiKpKIRS+vYdaQX91tR6J61U8=;
 b=EeoowBzi90Kvw5wLKLE4sT53680AX82eTHnEzystZMKvKWad4/V5KNLSjIgu4FF89NFB
 bcuYfXAplGfpcByL0r2Z169kLe3bHWSb+j3urNICx2oSt6ePZ7KCeG0Tpvjgc/WXVmRn
 OaXiXiWqh3LQ3YwbscF7BGVEAmI2Gip4vPqDAHQeLitvucD/4/jcQHdqpplaPMznQSpK
 3VNQRkPqsfmmj9XISB8SUPIVfEaeXamUYdoUP29OaACuo05aF03GMd4ttSk3Fsn8sGsV
 lONvKHB2c6pxWBAeQSXUtuVHUfnBhNPQFogiI6jWOCjk9haYXcs3lYsvWQXvlLSQDANR PA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrchnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:38:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8Ji7J4wMOsymH5dpFe22Gp3SRHdZv0hr2mYv30rS7MuHOvKe5oLnMT8+SRIoZhuQpMgwQ+iXRTNaHhHWPKIYSEWPAISWlYEQOQL6W8VvYnIkKn5xtAA7bkoQ4T9N5jOMhnJowGGKnhJO/JYeIA+dF2SmDMerjeqexTLH9ZHFhDmWcNJF2KbKx40HAxdWs9l4Gl8MtJ2SgABo5ZBlggrkZi7M8DYmKbn/O5W53xmBQlq0RQCWsJ3HgTRgGrGDH4//vTj4NQfOxaRmPCIHePJctnXseWVluUehjVcuXj47wAdYQyDEzuXLEwRKTpD4cvA10yuPeZ6RHvvmLWc6Oq8PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpBjqM2auNYRotwvNBdiKpKIRS+vYdaQX91tR6J61U8=;
 b=c/dz9W35bQAfEHFY/BHYy+/PvFgrOwAx5nONFSXaKlhiTYNX3/Vwtyosp3bE6aGDYHDl4La0SPzx2NiGpcAjY/sTI46ylXfoDvuVma9971/7YG3+wiopC87gJlUVhqF0B/0oer6bz0juonrOKFDMwxaqYkw3EaUh6jWTXVPYAh44S/5Zig86ixo1R39TAAp/EBz3+leSwoprDYVpGXLNjaXmVCMvTr1kvg6T9zrRTH9h29ypZmodDdnzpiEUk7ND+rB+Lq7Bi7Inch1ckziIekmA7J1bV2FjJHAyuLCRFfldIctPQwdB48iNd2TnViG6dQ7xXznmjUYBv8B1o9pI4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BL1PR11MB5526.namprd11.prod.outlook.com (2603:10b6:208:31d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 22:38:42 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:38:42 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 6.1 1/2] HID: asus: use spinlock to protect concurrent accesses
Date:   Thu,  2 Mar 2023 00:38:52 +0200
Message-Id: <20230301223853.28466-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0091.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::20) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|BL1PR11MB5526:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e34d17a-da61-4cea-fac8-08db1aa5b4f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0oseTOm3ZbeUWkBTNPmP5yj4nFvbdQqcdG+d11amZmS5yXXlbpI+JMWG2TrxlrgOLOFrgWNG2Pd+IKKzGLP9GtN7ceaGItx/juMzd/qmJu9S1Pa2PVPwlhXq3sLLgseQLcIKr9FlrNx0/HSF23UUhxXrSoX2kmLTrYvNR8vFLzJ2pArGxUP4kDug0N8bHz90cgkg3CdzG1AkWOJM7i1swGUtStgInbnf6hxcJcKac6pUirBGnagCliWLHWJf+CiKIYygMUG3TnJRqxm4gP/BWJM/mGpBER9S+SFF8CjZq1b5Rssq7N/p3g5KjHm/MeUwsqZFmBgvx2DuLsrU1xeNFDjHwGGGu6xKm80Y67twWyAyj6AAMMdOLbPza+v5cnnIlUNQUbcPr472Q+/8KtJlzBeYXoB0OHDRdMQ/zW2Hj8IlXU6oxtLFJywy5cuQGFV1AEuzuOX3N/zZNqlGiwU5GDFS+BVyOwegk5YbTPMArE5Omf0AWo6IIRjd6xDB0iktBkqn+FaS/MP3wKGBRvQDJz9rwwiBa8ZkcZpT8sYJvON753Ok9q1t1p7aALD0pPFl7dicICHqkhnVfOQUuPCg2CYzOYjozRz02Wl5bKRcz4VxR+zypIYY19DLiumgMt1p4158XmW8QA8kNHQ5MeLc0bzMXTyPxkXqqRoQp5ZRP/LKsvi4s3Sf0vv5Lj3dopDC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39850400004)(366004)(396003)(346002)(376002)(136003)(451199018)(38100700002)(38350700002)(6916009)(86362001)(36756003)(6666004)(2906002)(5660300002)(8936002)(66476007)(66946007)(41300700001)(66556008)(8676002)(4326008)(44832011)(2616005)(1076003)(6512007)(26005)(6506007)(186003)(83380400001)(478600001)(316002)(52116002)(107886003)(966005)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1OeL30dY4uw14XMz9J4DqcH0lFAlDSalTmUdwme854rUDIvXVr7fyIpsT7J0?=
 =?us-ascii?Q?p/gZ45w6odV/uBL+JF9ZJfKcr65f0CxWJK3y7Rw3rkLn2fedtDIm5hkhOVDK?=
 =?us-ascii?Q?Qw+UUNGsqa3ybh63n4qWck81n6mahutkJ+uxXd1YD46D+s//FmlMWSkTZ+qB?=
 =?us-ascii?Q?v9DkKtQZob0w4RJVCd5GYbtg1b5dz4sDW6KvMgdwrBCpNWtxtho7XuirvSbI?=
 =?us-ascii?Q?KNJxEYIvKhuOKNoJJgNm9B/YucAZPsapM6zRxbbo6vczh4yHtr5VEo8j0+jt?=
 =?us-ascii?Q?IzpuIownIv8CoyN2ZJTp3Y1ut1Z2VfP1CWvEaz5YmddaOHmr/E15I/WjNb6A?=
 =?us-ascii?Q?k9nDaDchcw0Ljd3fyQ3YeXTwgP2mBJq2Leje7azJYwgSFvY36Fmdwpf1GqZk?=
 =?us-ascii?Q?GM+2MBiHwQeogv6kUtW9ozM9/i84i5sX1RfzqBkjvmLvSSKc+8tACAJJUUzK?=
 =?us-ascii?Q?El3yj8j1895+C6AnmN8Mk0Rraq5bEThs5yVDGIfNhHQjjQcJpF+Kt3Fn8E5L?=
 =?us-ascii?Q?BJCouQfM1ITrQJncsIVWVo1dZ6HO4L+xHTiHa48nkJaSPZWtRbYmSX6V+rtV?=
 =?us-ascii?Q?z0y6TrGr/EEtfx0XhwYRtMECGXCPzNZY1SQTh/aRR6hwBofB7GJpqON2JZOR?=
 =?us-ascii?Q?3+wpcA2fou9QIpdA3jTUifgMXoTC0EHr1aAjLUthoMpTiT3+Z6Mlzgb6QIo2?=
 =?us-ascii?Q?922TrcZbkBP5ozf6BZTZj9ewjVvgIcZvwOc+WtNkRZ44B8WtIuNnr29nSMkM?=
 =?us-ascii?Q?KCnQcajKdPHkvF7/N9cCcZge3ahoQ0Kb1vIqZBjAe+3A+huug9fedY8XQoUn?=
 =?us-ascii?Q?Ao/TwElv8D6WLzknDY4DWP0CYE5xw/Rx5OcTQoNEznCc37cMdmNdolV86log?=
 =?us-ascii?Q?kaocyjdEIkqwliDT2AYHPUeETwHBMEIPLlG5A4Mnreco16ze/Y552yHQD4j9?=
 =?us-ascii?Q?iaCT7D2o7ds/JrmLkKXtE++0wV64KmhorqR2jagAkJhxmEkA7UWXtKfykNCS?=
 =?us-ascii?Q?1eHrw0DnO2TdwcdCLE6BoP5JLNOU+H181za/xhJ1xBIbsdsXC++Io/5ra6Cs?=
 =?us-ascii?Q?2A2nAlHRik0sDxPzoGLchew2RJS14esg6YExeOoUwz1yITg6R+zEOVW3R+S9?=
 =?us-ascii?Q?UGejC8DmBDwc/BfVVcF5JIxiKJsKfABRTKklgXtdJ0AOPMtM+1bUrwLDEGn7?=
 =?us-ascii?Q?acZQaFrYnS7U5INa/c34QWewIuOzTth2c9aSY35QAqN+Zd57DdBgppXVeFxt?=
 =?us-ascii?Q?aRDcU3+XESPTMxLLDZYabL2A4pIfNjgRlZjMBi+4/Ph7Fl5NNbv9V9U5JE8A?=
 =?us-ascii?Q?AIGY5FaV6nCBEZ6i1dgpLa8KwfCI4+4NCdK+F+tS5sJz5maOfgacpHM5BeoR?=
 =?us-ascii?Q?akT/0XrC2zgqsCr4PrkkZJKgJkNSTzriGFnhHq527MNcjUoMo9ePkSVur21H?=
 =?us-ascii?Q?/pAZEQFR7iIRvUrP2eeHPXQTUpy80eWNS9+BlDV6jAfm9xZd2snwxRfjksMa?=
 =?us-ascii?Q?bXcLSMbJiCFPWKd/WmZ7njzLGB+Q8mztFPsXdiY1RV2UHbvl7ejjjG4bo+H7?=
 =?us-ascii?Q?s7mqOD6eiK860JG81Y4FqrRUFtS6nBgWu7JW8bdYJVZD2XUNPv83fMgYhDpK?=
 =?us-ascii?Q?0ykUTEm/b03XuFHw8QuHOLA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e34d17a-da61-4cea-fac8-08db1aa5b4f8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:38:41.9791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9hf3nQQMvdWDD+ZJZ9OjaKen0CM1U8P2PL4oV2HqZsCcnLkfPoaLaTa6+Zc82tHWCpkBoNiF5OutZLN+EE7sBbKH0npNGDE23uL1TnANEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5526
X-Proofpoint-GUID: dQyuS8AzsDOWxlj1ildUnQU50ANIjR9c
X-Proofpoint-ORIG-GUID: dQyuS8AzsDOWxlj1ildUnQU50ANIjR9c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303010181
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

commit 315c537068a13f0b5681d33dd045a912f4bece6f upstream

asus driver has a worker that may access data concurrently.
Proct the accesses using a spinlock.

Fixes: af22a610bc38 ("HID: asus: support backlight on USB keyboards")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230125-hid-unregister-leds-v4-4-7860c5763c38@diag.uniroma1.it
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 drivers/hid/hid-asus.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index f99752b998f3..9f767baf39fb 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -98,6 +98,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -495,7 +496,12 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 {
 	struct asus_kbd_leds *led = container_of(led_cdev, struct asus_kbd_leds,
 						 cdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&led->lock, flags);
 	led->brightness = brightness;
+	spin_unlock_irqrestore(&led->lock, flags);
+
 	schedule_work(&led->work);
 }
 
@@ -503,8 +509,14 @@ static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
 {
 	struct asus_kbd_leds *led = container_of(led_cdev, struct asus_kbd_leds,
 						 cdev);
+	enum led_brightness brightness;
+	unsigned long flags;
 
-	return led->brightness;
+	spin_lock_irqsave(&led->lock, flags);
+	brightness = led->brightness;
+	spin_unlock_irqrestore(&led->lock, flags);
+
+	return brightness;
 }
 
 static void asus_kbd_backlight_work(struct work_struct *work)
@@ -512,11 +524,14 @@ static void asus_kbd_backlight_work(struct work_struct *work)
 	struct asus_kbd_leds *led = container_of(work, struct asus_kbd_leds, work);
 	u8 buf[] = { FEATURE_KBD_REPORT_ID, 0xba, 0xc5, 0xc4, 0x00 };
 	int ret;
+	unsigned long flags;
 
 	if (led->removed)
 		return;
 
+	spin_lock_irqsave(&led->lock, flags);
 	buf[4] = led->brightness;
+	spin_unlock_irqrestore(&led->lock, flags);
 
 	ret = asus_kbd_set_report(led->hdev, buf, sizeof(buf));
 	if (ret < 0)
@@ -584,6 +599,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -1119,9 +1135,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
 static void asus_remove(struct hid_device *hdev)
 {
 	struct asus_drvdata *drvdata = hid_get_drvdata(hdev);
+	unsigned long flags;
 
 	if (drvdata->kbd_backlight) {
+		spin_lock_irqsave(&drvdata->kbd_backlight->lock, flags);
 		drvdata->kbd_backlight->removed = true;
+		spin_unlock_irqrestore(&drvdata->kbd_backlight->lock, flags);
+
 		cancel_work_sync(&drvdata->kbd_backlight->work);
 	}
 
-- 
2.39.1

