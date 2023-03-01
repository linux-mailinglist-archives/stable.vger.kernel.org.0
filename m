Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFE96A770D
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCAWr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCAWr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:47:27 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4D61A65E
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:47:26 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MkPWw011336;
        Wed, 1 Mar 2023 14:47:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=5LxfchuP2Tu7p6S7kMWiiqK9BCJriKb3lCcwZsDuMeI=;
 b=k+wTxRtgov4D8Vf+LpSG8BZGiQqdwJzamZEryJ87+c2l+CKoyuJZkRjvhQjrtffLDQe9
 whxOco+WyiuilcaqYUIpI/3mgpGa5eFiBthwu9buiE0ifNaTHPe3QeP85WMkRNqleM4a
 gPKprlwzikW16Z8wz07YiltqSO2VExEw19n+kwX8yeM9f7pACIwVDUKRo3xtk8bPxKVA
 Lsou/PvExLSOkKjFu/9bbvM4lyDSX9R0YiNTwygkA4ISRtHlnBb0GwTvceHi6v0KIwEl
 ptQZn/TcZphjLb6qH27L1xYNuS4UXG8Aq1MNVJJZQMHrFJ+xpW6DHKxmAB9YjPrgNdWf Vg== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrchu4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:47:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8JdDSFIpaArvDWSPMouJO18m40Z5SeEO8TQAhfimJqnSgVSQU48LB9VCuMjd7S0v5te8R5MC0LVTvTUCBI19Zuoc9t0OCroxtuwQ5wxUrfZuyYDAIhPHKMF0bf5DUi6BFj6Aj/g2u9+p/NsYFXH00OLYJ8ugiEuNSaRtrDiA//30KJSOJRgz8K0k/J9cDSbtHzSnVjtwXnhr6VmxBfBHGUGknz5cPyhvgCskoiYpmFgfMr7injiOkVutzmqplZjDl4KmvT0pANsSul54NXsZU31pLe4XYVubws/iZ19imLizlTqKS6Vnqq2IR96c15QOUUtKaU7oFmcvSZJRQX4XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LxfchuP2Tu7p6S7kMWiiqK9BCJriKb3lCcwZsDuMeI=;
 b=OgPpCq6PgszIhlPEYzkAYaQJHLSaHu4gzhSHEc1dQucSA2P/TOrYGUPxOSDmVjT/vjHuWfmJ5CIBpQMsA6Iula5l/KBMnL1TXEJGURBkS4FHeeeex615nji58tAV0014isopBSkYZWXlLB2+ZyuJrSBbYiB7mXSepOUpLwoL4U+pcboi20BgcGTeMGLMK14SwLNaSzVlLuEjjajdvaZ8ix+sGKXMbyX8t/+sdIFl896lkZQ7Cm2Cnyb6g1QwFxB2EDy8w+TFxRONb8ExIxm1/J5zBN/TL9zH9cvm+6OvuBZMNjMXGQOaL+zKOXkJoQiOj7fKdZBHeIzhYMjeNOqESQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by PH0PR11MB4935.namprd11.prod.outlook.com (2603:10b6:510:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Wed, 1 Mar
 2023 22:47:22 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:47:22 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.14 2/3] HID: asus: use spinlock to protect concurrent accesses
Date:   Thu,  2 Mar 2023 00:47:33 +0200
Message-Id: <20230301224734.29357-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230301224734.29357-1-stefan.ghinea@windriver.com>
References: <20230301224734.29357-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0162.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::16) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|PH0PR11MB4935:EE_
X-MS-Office365-Filtering-Correlation-Id: 0926e38b-08a6-435d-45e0-08db1aa6eb7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zRyQUa8CS47zruqmvxgtm3/7y1dkrTMW8tRuNky5e/0YKM0S8d1lC7O4rkk7u/JR6pOmlSm8C71kQh3VD1HFkb63Qe6VaWJHxZZotypBoPmc2VA/w5ybsM9T6ruHuffXVE1atP8OWHD2+kg44qnrw5LcN+wnYDg9ECtiPPOjU7ZLZfT6iYrmIh4MMFNh8j8HFweKihMMTgFjtZ6nH0wtia0EpvqHpuaUFcelFcVn+uvIvF+j6drWYi3bv5y6mqR7+F2/T87vC187A0Re8ZC+A/1Mn5mv8fvCq+UUSiv4/VolJHmRA63BzuSOisIwcy4Mx1L6VXh3N/PeJfuqGCVVGLVCEUP5cdLXDXDdAAmqnBGwMUKA83gLWZ9/ggwkKrU2rnxdtlb0DlNP+a79x8+bgnO/GCYX9iaXSOJi0mXHg+uAb8osijaEpaJEK+5Anifh+JrJ9ZtVd4YKg1EXh9kAMHpqsEz1qjFRFFoiN4o6GfT5x9ODV9dKmFQ/+nAocyvZ/b3Kxeg0zMT1ZatSwh32r3L/LV8o6uibeU+kt/2ciaf9OJN1UwbacQ8JM26HMS4pzmF4elYEqb6veEvsPXwZtLczPhIhBN6Twnq1wOFoIM8B7Rwy9R16lEIQ+3euqsJT6y6rfeOQUkgwds2AruarIwPsfyB4bqFvP7h+kXRnMa8RziHLwReh+I/5LdOSSGfY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(451199018)(83380400001)(107886003)(6666004)(36756003)(38350700002)(38100700002)(8936002)(5660300002)(478600001)(66946007)(86362001)(2616005)(186003)(26005)(1076003)(6512007)(6486002)(6506007)(966005)(66476007)(66556008)(2906002)(8676002)(44832011)(52116002)(316002)(6916009)(4326008)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hBZpNZMNDzcLTxKxT+u9JxkSdQy0+HgLlkyiH4pm7pOTuKB7speMfuBZ5xDQ?=
 =?us-ascii?Q?IM63OtsCTWw8WgovUQUjD062UmqqSFNX5ZG+lHJmiKbr3DIBh1of5N0p378+?=
 =?us-ascii?Q?1s4cMaOVK6mym/Pvr9Ih/kE+nT7m8Dlwzd+jY1ruCJJ6Nf44uJ6z9563GNdn?=
 =?us-ascii?Q?E7jP40T9g9J3CifGbxcCDYklfX4KrYQeNkDqhhUl18xqyV0Rl3rEtxPMheKo?=
 =?us-ascii?Q?Gu/msBOwUopfxrbUDnrLtv12KHq1TJY3SCk+1bV4MaCCj8RnnOLoRXvcFw8y?=
 =?us-ascii?Q?nnfo4ilKGrjaBhWeQKoVgBWsakgH/xnGTMGAEmsBj0T20UvdkkbMEzcDYFHE?=
 =?us-ascii?Q?iWY8OnKzySpiG96w76BAHNu5zDvQ8Zkjwxhnghfa+/VxDQFg6yPX44gQk1+x?=
 =?us-ascii?Q?Ryoeq2YSYUoGKMx4VyGR3V85feHhW/1z1rBkYTWsEsb7cv5+12E+eFOc/rS/?=
 =?us-ascii?Q?ayvARUqQI/kZmOKCLpd4vo4ngOA5mIMb/tzr44lVSGN/0+dxQ9AF+uzpCdQz?=
 =?us-ascii?Q?RECl0OQ+2L5DADsiZlXzDlG/vYejUiuL37MkAU4+bv4TsZl+r/X/6gj6TSDb?=
 =?us-ascii?Q?36EzHlV5ryIyDeffdGaBQjGTZ8uZoic7shHNHVUq2JK0PXSQ7vcOQExtJwhc?=
 =?us-ascii?Q?kO1UJ8cYcrnk3/G2dSqLp3USoNUE1bqslQnJNR1VDvBomj82cz6h0ATfnKp1?=
 =?us-ascii?Q?H77mZEHfURKT5ao1HrBD8Dud4lqFiEh5RBA0sohRDufGl88YKP6qux97qo0Q?=
 =?us-ascii?Q?fuFBgGLff/8Z85RRGPizHU0ywZe6gG/304zYIAPBnQkHGoAyjdcOpjROtt2X?=
 =?us-ascii?Q?txr3ToZ4bfsMXRcbSHbYO/lxLWUcHfhDajkH/WespjFQmXxnTRQG77UhHqHj?=
 =?us-ascii?Q?psrtWQZM7g2f850522i4Zac51mNQMbTT2uWHvHLw0+VEEUsdMwWl+5q1CztP?=
 =?us-ascii?Q?pwFB45eGqGf8jewYSzmKMU6vQWvE+3O4JZi6mQDGzgAAIvOgb7Zk959pW1E2?=
 =?us-ascii?Q?pXtJ+UpdmJnuo76SwHx2y8PRe7B7CTx+VVDnPDbmjjdrUtCY5jkQtH8SgR6x?=
 =?us-ascii?Q?NG7L+SI3OutoUsnf7fbwluQRbzjL9tWRFBV57aCdVueZrVijv6N4t2QlwIKZ?=
 =?us-ascii?Q?+671/tRso4Gi1tgarMQI4sy9hRIsvr66KhgjQdgGq7OQcCQGLjpPBiE+jgzk?=
 =?us-ascii?Q?CUBBnxmW8F/eaW2cZCcwxVZQEOZ1nYbUy37v9eVPCDCxT5RKUVsYNqzq7ZbN?=
 =?us-ascii?Q?WuE84/dpgdCxWLePTyM5fW/5gQz9lZYrucJnFOyzrB4M/jA24/mzX9UQkDV2?=
 =?us-ascii?Q?EJwwYxDmxqFwD211rp1fDEG3Fkvx9zg/Qo7z3oasrx4UDiEFunHsYmIffwc/?=
 =?us-ascii?Q?MonvqCXpL0LKkROlIM30SwsKey9lShCcB5EKpM0Ur9d02FbDD/bfv2DjMnui?=
 =?us-ascii?Q?xR/PpzcYScutZ3a0mThBiSuZBkiQfJ2XKK4+WzCtNL5s5RAeg7SvE7b2Do9u?=
 =?us-ascii?Q?Cu5BUtF4FI0LnMTGu/5+yCSV0OiEgXw1T27XvBLpveXHaGG876hlms3UJ4Pa?=
 =?us-ascii?Q?KrS0FUmAbeRJj47yx3wlj4OPYQWx20CkZ/gL1/7nbmgDFo7bydFrzvHKaer7?=
 =?us-ascii?Q?meaIp1MCYslPbiOVXQXxJGQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0926e38b-08a6-435d-45e0-08db1aa6eb7d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:47:22.2837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: psYvI+/RPiqKfC2RtSBwzUlnUBYqfepfRqKWmhK8h/Qs7fOMJdSGW3JKoUTVJWDtba0rB7H4cTFoJ47lbHHH6vV1xF0CSSyLTbm42hMy4R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4935
X-Proofpoint-GUID: Oi887x7DCxrPL1cgudXqxe4rbZngeWYh
X-Proofpoint-ORIG-GUID: Oi887x7DCxrPL1cgudXqxe4rbZngeWYh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
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
index c7ae4b6d9fd3..a4bcf18ab18a 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -82,6 +82,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -298,7 +299,12 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
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
 
@@ -306,8 +312,14 @@ static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
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
@@ -315,11 +327,14 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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
@@ -360,6 +375,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -658,9 +674,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
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

