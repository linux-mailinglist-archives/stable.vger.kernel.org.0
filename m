Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A6F6A7707
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCAWrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCAWrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:47:03 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679D51A65E
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:47:02 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321M08DJ013904;
        Wed, 1 Mar 2023 22:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=FHePMzyKQ1FMJnzl1j9sU7d4Gl5FcsEdj4yCerc52VE=;
 b=DmTEcKdMO7xLLwLuLcpPVvXRZkg3gbsz2Ajrmsfu3oYSHxg2xbRMJtXm8cjLdDJieKhh
 KPzAqcyEH9JfFfX5MqIAU38dZaCZlszwWhypCqcMTflGzpiawsV+RiBdydcAaNnAMNO8
 bmG9r6HLJkaQOlnd2q1z0daSP70riQuOQLRHFmXxrNKWkMemk1kxZux8EoiK7ctxjp/e
 2hG0KjeBH+7al2d1kb1m2grlbQc8IIqMhZSj/Iuo1FWhV0MWNFJ+nSLVyfaphcashLKB
 1Ebc5dgxnK/qFPOeVHC975sr3xJoASQ42ygZdwFBQVYxOeCc3ebVvocdtRYFmwmnsWxu Lw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nybmkct61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 22:46:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elQiiv7h+3fHT6HS1a4WjrowmhTpQaqmTQE5672o4kf/2otzYjBvBaJFkdkfbKjTYJWDCSto4UxxpKuDwzl2F12X8svfznlwQLPdr7D6EXEwKBbKlagvNtJPE+WG+nJOEVx8ogewv14rcP2SNOEPWAs7TSDLRPXZv0K7CgSX0h/HWtfWuFI8eCKQp/IVg9pn+OGnDiex3W6S6iisYcInTYcrYgj81crFODWV9paJEvSvqwr9AY664zk60/lzUZ/DEFArlxBXeo+BQPUWRZAMTyXRig902NEge+cS4SdbTMK44LgrIUDn3M/xG1hEY4yjZ97yUhyL5eF0VMujov2R8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHePMzyKQ1FMJnzl1j9sU7d4Gl5FcsEdj4yCerc52VE=;
 b=PftjxI8PvgCARulwNYspEj/R7u+xkYHhmtwqJk55cB9hD1GOx+V0Lx3mVi5maxRURwOF3T0jcU2oWTNhucNboNdkkvrXRl+uqsw/EV5uQBljLFohs6eTCTQCItH6CwIE11RiaNMwSBJi4w5UOifLnYfqbTzKy0IHBZ1j8kVJnzJIabBTULxrHMTKprFGWmqtXkaYSfPsos+huMB9LVYwIy+T2z1Us3E5UwcIMhv2tMWoFcTU08F+ABUBP4BXGU5F2zeJmY1a5j+o1ydAXgsJVcSRotDCbzpkAbWwer/WTAaR/Y/SrSXSbcMZYJcby1aCnz5CCILl0l8ayfjvdbG+Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by MN2PR11MB4760.namprd11.prod.outlook.com (2603:10b6:208:266::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 22:46:55 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:46:55 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.19 2/3] HID: asus: use spinlock to protect concurrent accesses
Date:   Thu,  2 Mar 2023 00:47:06 +0200
Message-Id: <20230301224707.29306-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230301224707.29306-1-stefan.ghinea@windriver.com>
References: <20230301224707.29306-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0059.eurprd09.prod.outlook.com
 (2603:10a6:802:28::27) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|MN2PR11MB4760:EE_
X-MS-Office365-Filtering-Correlation-Id: 2241315f-77d3-415a-8361-08db1aa6db49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vc+qUf9HrG2ofrfpks4llKM3De62ZLPN76dMw3NdB0fOqbZbq+8VhHaP8iQDs62VOJUUlju5BYwocxtmnL4VfRTPhP7vHgMu3grC41MchkxYe3/7Vi+wz+jyuhbcXUWzg13OEXHxwysbbEELO0gpdirNuYTKLOy/TVrUzGLKuVSThCxLhKY3Zt9djIr3BDtiHUAbnZjOwonGCMXNh4G/63pbg+Zve2yCa9IKf/CL08beKA21JEyO5eJlJb6iB2x2yBlepxgox4cEVTXr5q6XoijmOfN6BaHH7gYFgh14iBmggwRGfb6T97vAmxbWTeoKSzQu1qncut7aGpyGBM55p/tsNc7zxcioCW6zbzi1M4jOvF3PiB/Ir8Eh3EwTPLLXdHiFbnOIWhVGCZ+4Sqv13G19jhBCk3i5JNQ7fscQxVwbvwJGnGdmWMRuXt4rkxx375pvtn1tNtML8BVfN5Ct2x/DPU0rIfJOhlZ+wQqtIs8gtEsd/KaFwP7AitAigZNdZVjlpqLBw2bPi8mGHy73h69y1PUeFVuYoJtJHrn/mK4xZ+MY2GmycNqRclanDaI1rJ6cq24HlPlRR1lys5subMUWP6KWnyD7/pxSh555pvQ2TZxjUv+LKawOJ32hoYRmAXEFhrms+5XzkQPPGGssv5Yy0wKgDj4Iksrnjpi1nNxNcyDwzyyaD+ZFl5fGoaI3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39850400004)(376002)(346002)(136003)(396003)(366004)(451199018)(36756003)(66556008)(4326008)(86362001)(8676002)(66946007)(41300700001)(66476007)(2906002)(8936002)(6916009)(5660300002)(44832011)(6486002)(38350700002)(38100700002)(107886003)(966005)(316002)(478600001)(54906003)(6666004)(52116002)(83380400001)(26005)(2616005)(186003)(6512007)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?62ynYPcg+u+8X+wBlCavrO8bHRRIvofjgMpYWK255s8jEau1u0oJHPmavPYN?=
 =?us-ascii?Q?6FPp5K8/VyP+YjWPJPExjAGlnHrOWkut2cEqo+G8Gvg+Ii1b0BukIj4HntbQ?=
 =?us-ascii?Q?s1EvmGWwfo3Xul8cDqmoL8SQp5yonZ0qdLvjE7YxCq6wJA/BOGUx39D+UxLI?=
 =?us-ascii?Q?yggMm9h0DVnd2SHKUelk0yk+eGW8DPmUXx1hGSLyL+MAs3yf7pWcNH76Zbx9?=
 =?us-ascii?Q?ZVzCgyGH/Ek7gJs3PU7Wvt/rCAnvgI+W6j8WFBE22WS/pAy93TZWpsqXXySc?=
 =?us-ascii?Q?Gp6uG0rLnwH9nBlStY0pdAPKGgUvxnlaVyE4o4s0fecxeE4JE0MVRIk3CYXS?=
 =?us-ascii?Q?6x8TGs98dWVhWDLFg0yEr4sQFPgHaHM7iB4A6xobNllrOeD+UxK4A76ND5/v?=
 =?us-ascii?Q?UEhQagwZ2VrVRemYdd8pUFz5CymS9SlJH0eSsG0ID/9uFgWSf+1ZCW3PmaBf?=
 =?us-ascii?Q?Oq3qz0Vo5ijajD8kPnI3l+a6oLsaqUwnlurp6soa2hWEV6tPlEp7u3qggK6Z?=
 =?us-ascii?Q?SqPEzeW+jvnDZNFmsvJn1afb94+WtS7gGuVjRVzloQRbGM8Xbrz/Bt8NZLGl?=
 =?us-ascii?Q?5yEz5jmHZb4FSsajJeAfCf0uQv/PBleiO12zGf1MDCrBb/PMmByf0nGEs47U?=
 =?us-ascii?Q?syUd7JA0ebKuIi+HOfvc6OzVp2DOtl5p39eW9d7L72QCKD09jYUUU4Xsg4+F?=
 =?us-ascii?Q?72pPznT8Sjnfi5u8r9VThWiEmRVWwvAe7T3uhPDwQOOSclTaJrvG3JtA9EYO?=
 =?us-ascii?Q?mqcdTbxdFAarOjsJueQGoJQVwc5P+C206ygSBZEMI3zPAsDNKs9Saq1On5w5?=
 =?us-ascii?Q?NrNwFtqP3PUoDfvmDg7mDwxepQHWJxEIY9squu8DV2PIVkRd8TRGVUSxLioB?=
 =?us-ascii?Q?ULbsBtTqKI0llL68XRA1ihSMX6rbtoiEZ6OpqAA0JoiobhO9le52zHW7SqE1?=
 =?us-ascii?Q?8rgYld0W2yVtMGB80VRFK5THt4Sr2m+VcYFm5pxhc54QqyRL3+gfc3VQtW37?=
 =?us-ascii?Q?0W95pqjynxIwkQ/OIFUSRiDyp5BTYvbvsfiKGy17kOVhwOiXbrfgTBfU5Ah/?=
 =?us-ascii?Q?xUf57k51UjIG7BPAvPn/FuvOXkzHgRgOpcxQHgswBYHDUjx49poe8EOCfmfM?=
 =?us-ascii?Q?KYRdCQPKaj+UamaZa647QZnC6Q8oJWt94m5KYIyWKCRQNRbN0ngdJC0WbQE7?=
 =?us-ascii?Q?Yf0hoSJEYMwSWF6aDpXdYxi6K2GQYLi2d8jroNw9m4UWKv6w6AUCMcwZXJNI?=
 =?us-ascii?Q?6IAYE2AvF0wD5BnTmBoahb9vq1GGw8hyLM4cO19UQ5yrepXPd7SwA0zgZmLc?=
 =?us-ascii?Q?RQAIklIC761dkhK5kcaXfiAg3qF63wKtWYjMNzmr0W8X7wg3YJr8dPF4U5ob?=
 =?us-ascii?Q?izfSY+XwxvSuCJ7cmWcrndbWHg0zyoEO8GIevf+oGr94t4niVsPiFZp6l9fd?=
 =?us-ascii?Q?GVhAjVESu7DbXQq+aNIlnJrJ8WkDCwgodC+WtQykCzTe4b+x0p6zvsdlTCTI?=
 =?us-ascii?Q?qi4l1XRa3t2kQ7eofQeSTFz1pZulBLW+cXa9FSqkijJ1c7CEemhl/Qn1xbpr?=
 =?us-ascii?Q?NR7olKU5L5a8Xb2WN19yuyuCazHIjDyDTCVymuDT85/wRsCO9MaM5hw+do9A?=
 =?us-ascii?Q?+EcpzLgXMVMKP/a07fNZdcg=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2241315f-77d3-415a-8361-08db1aa6db49
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:46:55.0853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZqBbfQInNknY295zFXwtH2fYC76MslGO9gH8OOl3WT3wWGRf2Nc0Vw2lR/ejOSQGz+PiW4wW2wYXXU3cxscVtz63VJHlqaPE7d2wqwo9YU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4760
X-Proofpoint-GUID: I1HfgIQ6UACeXjwnJbcNCGHMz8klVDGW
X-Proofpoint-ORIG-GUID: I1HfgIQ6UACeXjwnJbcNCGHMz8klVDGW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303010181
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
index 9ae8e3d5edf1..f2fc67d57ba6 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -84,6 +84,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -318,7 +319,12 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
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
 
@@ -326,8 +332,14 @@ static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
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
@@ -335,11 +347,14 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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
@@ -380,6 +395,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -689,9 +705,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
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

