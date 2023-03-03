Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7162A6AA072
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 21:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCCUEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 15:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjCCUEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 15:04:04 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447E160D67
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 12:03:24 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 323Jx05A030841;
        Fri, 3 Mar 2023 12:02:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=OpBjqM2auNYRotwvNBdiKpKIRS+vYdaQX91tR6J61U8=;
 b=cTn62I1n9omPznso8v1upnnZF5+OfYO6OzCE39/LF4Gl2M2npe9uS/fcNozI9dQQkjDe
 UXBuopJwF2qGIJXfeK+yrKdwkBiSn4hpAlRTj4LZpQq4TTNWFFSS7DdhdU4J+lE7IeVo
 eO6vLMFTNvLE8ZHgnpx+paCNUFhEDDqmuQUlKp6WZ9EHqhN0HKWa4jikHnDJD1H7sbTH
 dqrVLCrRwk7hGxHINCoqIMcD8pIiUVMMjAZjDs3s1+WTv4MtZGuMLoYLijIGfwqhVlfN
 TZFBzfC/wsXXsW1J3AvreXnQ4bg654Er5RlP3Oc//+jR9jUymAFMuUCEZNkXOiHUzKVK 5A== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrf439-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 12:02:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lg1CdltsZSexk7X12E+shnxj7jinrAENpnG/NhaykSDS0II0WFBUi/8HMV/4Jg+xg/CMEv58O0BysyW4vFJSh+kDwXiIBHkSwl/WzpMNsAvW6UQGqA/h2iPjzUxhnj7mCSGjyuEwZzxbiJff7gjvherQfPagsSBQmkJVQQNa8++3OFuWNRsrNDVYfpVVgZZ2nggytmswj0woOx0caHn5mT5VMKWOh1uBpn11gS8sQPRnG2LqWMsAQ4NoQtcvvq6gmyq17NRp5AXBfkW+D/+fzO6qojYMoNo80Zcx9eKkmHa+cD29097h7CQBCFPjz485pDC2/N4g2D03g7OnaM1z/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpBjqM2auNYRotwvNBdiKpKIRS+vYdaQX91tR6J61U8=;
 b=cwH5th7HnZsjYKmtTxiIhkpuEt8TNrBt/kEmuvLybWB1j14qt9A1dOmfLIr/MUWp4aoRLaTIUJQlOahuqSGmp+A/rUo9httDBhR2pf5AFjBbIZJNGlVngKcxGE0Qja1qS653jADmZaYMWQSxlNA4jwSc/1Dn0QdPXgWO83K2FYZt56+Btqvn5ijqlV+QbDbvCglVWbKo4divfEXN6XRzMKG/mFeIrnGgC9iiyoP1DqMYgDebOgerbbcRx1bMJhwEDriQ5oSUstl0jTN6TOKKF6MIa1JRZkYbRBQrvDAHEvoafelgGjdRGK0RHykZ77VCYOtGQeowJWOit/NgcrLmoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BN9PR11MB5417.namprd11.prod.outlook.com (2603:10b6:408:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Fri, 3 Mar
 2023 20:02:19 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%6]) with mapi id 15.20.6156.019; Fri, 3 Mar 2023
 20:02:19 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 6.2 1/2] HID: asus: use spinlock to protect concurrent accesses
Date:   Fri,  3 Mar 2023 22:02:31 +0200
Message-Id: <20230303200232.24355-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0029.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::42) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|BN9PR11MB5417:EE_
X-MS-Office365-Filtering-Correlation-Id: 287620be-c65f-40c2-0c9b-08db1c2231c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q9LDa7tMnnlhRZ5C/lbOAT8E83q11NUF0YIqf9Tg0jOpyiYT0qqpbB8q4BCgG8YhWdSuzvwPZMAO38zeuGOYwPRAbhqOWR2aS0d4WiC++PS6Y7xNE2z0bi08I4XD6b50BOjtxajZIQumg21v2xWTPcvRfzhbaXaT9F5hAt9/ylWy/AamJdtYI9PctXtZKd4kqq/n8lw4niq0hu3ItO9jfH9UPm9EJFmhFxgulhQbwGc9kOuFEM2I/1ZZzdkvXH27dZijDYsvDILL8XXWzfIoKD6PNOi8dVdQRBAdxbPjp8l8hpdPchzN5DK4CAMjy9jPqeMi0Sn2kvcMHI5KoYO9kb8qVvH9OkxLbaDz6XxC4Cebl52FTCjsUoJ1c96We9TorxN5/0MbyGFbcL8XHSMm1nt/A/W0FRJ+LNdWYNyfiE8LsZ1inOCtyScmUMI0FwyQ+jBdH6VuDlnvkvXgozfCDgXSvKDNBU5vjFoUbgSHw94yLSG8ZhGu4Kn9E2StIu4GENjXQlVRZjjpp240eC7aFmL5sc880/aLo3tFVoUQmRd74ieHAFk3rt+QLz6HaVMQ4PTkhF2mzkGsEoLEKuIfrCCiSmHSBKTllJ2eB4OlzgW01UeMBhYPXxRMccdWhLnkw7VJwYUImhThlLN97IIgwDccKYTyzRUX/0hyokzcy58v+P+l47KW76iNZmdjp0wy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(396003)(366004)(346002)(376002)(136003)(451199018)(44832011)(2906002)(38100700002)(38350700002)(86362001)(6486002)(966005)(52116002)(186003)(6512007)(26005)(6506007)(36756003)(66946007)(478600001)(66476007)(4326008)(8676002)(6916009)(83380400001)(54906003)(66556008)(107886003)(41300700001)(6666004)(1076003)(2616005)(5660300002)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EE8orDWvws/K62fzeJ84x41al2drCeXjB8BCPmY18Wgt+M1PRsvUvAplRruZ?=
 =?us-ascii?Q?fmwIlI2Et7Q6ydkIFnIWcF/KaBUn595+flLTuKdZwBRo5ebRMj5g4VFLmbQR?=
 =?us-ascii?Q?/6QLXD5HdtFjwjaB/ETUYXql7vSxiinfBMZqNm12ukMZOmGgNPR8ofanVCrq?=
 =?us-ascii?Q?bMq6eVV9PdxaDC604tSlecl7g04rYBsGloa/54o/bMTS/+fV6ZYQxRVEiZlu?=
 =?us-ascii?Q?GtpINioc85YpjF6QX5kwe/A0htLrCiExpRi7lw5jcWjg/NIK/5RxZt4Ksr+6?=
 =?us-ascii?Q?VnRmbwqQq0kl8bOYQPCIhAd7hdIpgFfRlK22e4BMtOgOTCzjUPHjU/NhPQn1?=
 =?us-ascii?Q?8gvwHMPyQonoD5nDMWMUTPSR3anCwmAZAWhC9pV8r28jrxfKnKSRWOP0ejms?=
 =?us-ascii?Q?1nVvYTBrQV8n9/0+H5DUtaFKkVNaYTaAkvHTWWCPkKcXKJQ/5XSkMR0K/J3u?=
 =?us-ascii?Q?UNrnAHsa7Q3Ib9MptdRl4/UHQqackfaRp9Hntt71aT5LG8WvpUioF5hpkgMA?=
 =?us-ascii?Q?rlZDLiz4Cj/sgrlh327L9kbbRu/UD/2T0v5uyLGdWMvXah9hpQrOprs3S6pk?=
 =?us-ascii?Q?nAf41bLDJxYGSPIHYo6jGBU3GTGWDHQug501+p6tHzTtQuhZJwn4kUjOpupt?=
 =?us-ascii?Q?TIQIzzV9OdnMajRWpnmbocUKOf88Dr14jPRX13kS8w0j+jd7ObjOjP9lD/6X?=
 =?us-ascii?Q?joBWy67+PmgKPp6TTWJ7p1hf2V36e2ReERCWVuNLbxNk5Dln0rGhFU7o031k?=
 =?us-ascii?Q?c/FuVps4hAYuwVQ1X354jKlQZJYW9BIkNBImnGvZ0hhg9n8rqtZ4tSgIjQry?=
 =?us-ascii?Q?opsZ+81DRd4Htabp+gg/cxRJA1gsx8yP/uM2Z21ABcBmUBAQzmOX4lUhB8Oi?=
 =?us-ascii?Q?xrFKM9exs635VqxU1FXLwEv9vo7NWRv3m+WOjH679JukiQ6k6rX5vN8gtZNu?=
 =?us-ascii?Q?6yokSmVWoWLZK69Yq74XBMCXedfYsvUdgDRsAKlze+bld29xXBKQo/3i2iqZ?=
 =?us-ascii?Q?nMLtRHqwCbmTjtz1Dr3fJg6fIHh/qrPWxAe9XaIzWr2KYhtZKh+Ohpso66gx?=
 =?us-ascii?Q?kSQZtzUYK8oFo6ivgQERhxSUcK2qls+ukfsUyNBJ40+hLAVPT5EmXWfj7CGX?=
 =?us-ascii?Q?wgn/YVsWabHpknSanw4nXLFQ10eVIJqMmsLWPiDZxKyyk318HQwIcHikWVnx?=
 =?us-ascii?Q?HgQ1liNIJhieGuWTMJfAi3Qy842E3JEIpg1RcqBK0CHqrr5cCbKad68KQ5r/?=
 =?us-ascii?Q?/kFE6rjKz+eH825MqNasBUnOicpHZp4nzPKHQqggptRBhdij8O55bGexN4uu?=
 =?us-ascii?Q?dDLiA2EMA0uP3kVTR053H7T35g4Zr0oTx/d75KPGCjRoTt/MTZ8cmN01Cw2c?=
 =?us-ascii?Q?Lyzmd4u20/1mPcFgNRPwT3c1k0ZQL8lYE6TkBBt7ukqdCvj4+a7ftK+hZZKv?=
 =?us-ascii?Q?9iTpG9eXEQ3gBC1sL8fM2CBf1YjeCoEBz4c/wUFQio58cvzcsIuyMDCiU7JC?=
 =?us-ascii?Q?kl66YopnOQkTOfLvaB4t5x9acyBac4q+sLQ2jzi3N8KVo8JKDrIfHRF+181O?=
 =?us-ascii?Q?YiR0y+HDl9km8RIXZZGV5CqA6Qd3sLvo26jouk2UJifT/18DAzNt7I0VBxeW?=
 =?us-ascii?Q?vQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 287620be-c65f-40c2-0c9b-08db1c2231c1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 20:02:19.4601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghOPewX69/j81VzDGfS/Wzx+cwsSzptV5KeIXeDmJgzaG4xBQCSk2m+faK8GvLMFivifOAzP2crKaTPuIkKM2A/jh36cZFXebcRwASAx3cM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5417
X-Proofpoint-GUID: FVgj-AmXfRgrrpolJeG7O1RsIWVMaypg
X-Proofpoint-ORIG-GUID: FVgj-AmXfRgrrpolJeG7O1RsIWVMaypg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_05,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303030170
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

