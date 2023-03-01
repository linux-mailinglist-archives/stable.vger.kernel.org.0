Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111026A76FE
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjCAWqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjCAWqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:46:11 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D871A65E
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:46:09 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MVT2E009691;
        Wed, 1 Mar 2023 22:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=x/U8MGh7JNezor0upDzI6cXmg64wLH/iqkYDjwtLk2s=;
 b=VmZ9G0PfwP7uppqMZnVX9l7iX0PkqgLL746RX3MSQKvZkHgAuWGqQ798PxSSAbxofRXG
 YYgEas+Z2vvqeL+uwsMQbyUaLTAqn8g88xdufKmxxXWq9EtvjhMtKk4wANGgLBD/ce9z
 hbQKr8mRNEHAfQEduCnraA3a0noYHKh8RHzcQKaDFL9PCypGQnoiwN6QWhDVuCN8gyPQ
 Q/LPkMQEHTSkEcTUdWoySwJrhhmgHgB2Qb4GMFkwLBHM56kJ7t+9Y6l8+SGvYzzCG9ti
 T6ti2z205Pq2Nh/BS/7+8rWhKeX0u3uMRmUcz6K/C7CmZkG5+nB+Jin8AsJNxuHU5Xie hA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nybmkct54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 22:46:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2ASdNYibM31g5r+YewlwijQeJN5DM2TCpkm05Dh6ZdGQRp/uBqCy0dF3szuefFBCGWrhi8t5aoUBxuPM99hPxuLace6q/TH2WKFL2vY/FS0ZzPBqxnSyLsgEeYnQqyLz7V+v2uYemupA8Z6v7Df5l0JlUTeUcDG/BP/M7rksdXMyVGV+K3gCFn3LfJpeHr8+fcJlhA281oj9dWTgwCJOyMHc/VlKVqS3ziLmhAKIpp7Op4sgJZmX1IN0YGPohl6qVe5AlDdr9K1+IqBBKLOcfVK5BwpHdqBtVTFLb6WNCD13zXl106mG5k2tCgY+R5EfZcMB8LsGWuk46AVExOv2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/U8MGh7JNezor0upDzI6cXmg64wLH/iqkYDjwtLk2s=;
 b=NIBoxq2G6jPXFnyxUTZryWF6zawDx0tLl3BGJMv8mH16Zz7Y5Q5GGUUbXzmiAexYwfG8Pyr1TQk0r5R9YVnH7yyZs/UhphtmrO6cXmD0XsZhNijdiBgLhVL+U6tH5IMKSBYraTtX8nAW+ViMPIKyjXoIC2qLmxA2U0VC+xANPCaSCXvWG+OSRWCaAWSPTTkRM0XmvgNPeiQxv+7bwXZOmT0pGhQiX9jbA95Zy0JKwXtPba0lfQCM8BdBf39BJkxSaHBHFqhb1Lj+0XeVgIJCub92kukBy0pIru164t4zuXkB654cd+hBdamJE/hRyVy8e2/nsIsP65BdwlW69jx0/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by CY5PR11MB6535.namprd11.prod.outlook.com (2603:10b6:930:41::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 22:46:02 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:46:02 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 3/3] HID: asus: use spinlock to safely schedule workers
Date:   Thu,  2 Mar 2023 00:46:06 +0200
Message-Id: <20230301224606.29116-3-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230301224606.29116-1-stefan.ghinea@windriver.com>
References: <20230301224606.29116-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0056.eurprd02.prod.outlook.com
 (2603:10a6:802:14::27) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|CY5PR11MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d461fe8-5850-4ef0-b129-08db1aa6bbd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZlG0HVuk7nHBIADJXD5xFH4PqZ0MNgg8/fGx3AdDE6nfiQpiOsON5l2thfiMmXSKk/NiH3sTQrIQjk/vQpi47h6UgV8y/kck0okY2EFwrBL1EalTbmJulxlDBmW2iVWmsmfiLGUNlQawqfidKeaSHfByi+XL1fOKEhV6hu2LhpztC1dAkurcd1Cbnn2buIaH79v1fhyTPCsH8lwv1h4C9sdv6mEvVmZK8V4sBZqTs3h+TDGh6/zlPUt4XPK7v0osE2rMqSYYD7fTPBcW2tMPXs/JGWCi7znkbBsV72vdzvfBpclpHwOS4VqgMXgRqT3NxpS/8IdLVlADmOK7XlemjKK6VYCd78YH/Ilo9vvUVN0fQfxoBzqTR2MQH6J+8efLD29MUI0otXbZ5LaBtqsxqUQ6OtQQVYFLJJm7jHSTvC0n6kVhpxLLJOfwucwnDGRsUizRijdd/97CNKxV1oSz6cd9QGK9eVZU4fhdIFGdG6ReEIOWaGnd8ymnmMTt+yrPWn4yZzucXvutFcaRFzkZxcSDlYHjY00UUWvgmqRVqsPVh8x2lOA58/LnJq5WTT/VfCIvSjJUa8BfJR/SB+IVn072BTc6ztzkSwrmgv5t9nitUyfBZelfrZlQ2yuvuueKfENL7bDc0G0PiGX6z/8ossOJELlWP68h8fqwIU6yHZnBEeWrxkQefClx3UqX96Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39850400004)(366004)(451199018)(38350700002)(38100700002)(4326008)(36756003)(52116002)(86362001)(44832011)(2906002)(41300700001)(6916009)(66946007)(66556008)(66476007)(5660300002)(8936002)(8676002)(1076003)(6506007)(2616005)(6512007)(26005)(83380400001)(186003)(316002)(478600001)(54906003)(966005)(107886003)(6486002)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ozi7lZpFIMOO475inVFfyNq1Ar5M1/TzLJxeTm4dntnJyXo++0wV5sSWMxap?=
 =?us-ascii?Q?2JGJmn5sfzuhUfr5kwOUVd3dUcSCXccpWgsOGNnjy6tXVJMhoz/PD+TBbXX7?=
 =?us-ascii?Q?DI8vfj9Lee9j3AcmenEfZv0XiHfaodbQmwJkrsm8gmaaUMd3tZKPB48OFGse?=
 =?us-ascii?Q?UOSMQ7zNhevFrNnZvYBwh6iA0or1nfMrPwaXJ9+MgngDy2K8yD2jJfZ4qyF4?=
 =?us-ascii?Q?NnZ4dok3l/fqJ5ftuct1h93vdFExsOgeOvpoax4cDd7WBshTLDwKXPfm+L9F?=
 =?us-ascii?Q?WABeUKBMoaitsbghXOsGQFAN1MbVv5wKs4ao5VLLb3ZYqgpqrOVvcJAFxM3P?=
 =?us-ascii?Q?oEWZ4eUch/3dRPPb/c7Ku7/rRhzXKOERIRft9RXgM7vT1yb01+IYvF7z5rWy?=
 =?us-ascii?Q?+m13lkiUEJtsM+kn1880M9Tbs56C3ti3QUjBmHSkyhrOLccCU6xvOh7WjG8O?=
 =?us-ascii?Q?c9oVKK2LA61BR80XUXSXc4ljlarti9OQtl4Oh6iV45XlP7wYrLFWfPu6REzi?=
 =?us-ascii?Q?n3KbJHfQuIAjSxMjvJ1oM+CNo4F1x3tTsHD34SRHz8HIc4ivhEWrX7PRxXFl?=
 =?us-ascii?Q?uNjOvGzrXLt1/et4g5w95BFAO4l8hf2I5xrzvCqVQ8p7rWXWPaM5G+pGpdW6?=
 =?us-ascii?Q?g4e0jLJytMCO9/XzHyg0Vb7iV9jLX5Af+1vK8ybheehpGRUjgnk/dSpV/Vwu?=
 =?us-ascii?Q?obVGXmruQVuBK6W6ezDWOjtBRkFaCpE6cFanCdbhGI8PofKK10jCqxrnM1Ke?=
 =?us-ascii?Q?TYRgMGjNcOqhqet0CowBJfnwHojtofU98DS2h06fAUjupSFJboautUA7t1sk?=
 =?us-ascii?Q?FzSwAusa+qQrsPGD5AQoEgDiENBLZ9rszA12xtgpU7G6blZoiQZuLtDkzLHT?=
 =?us-ascii?Q?l9JfAEeht7nhgBbpT8iaJdOly3gNAvL0R9SSElmAgQrc60AJOKoVmySBX3C8?=
 =?us-ascii?Q?9NXK0u9oMppEpDnPNT5geivdzLTQu/wkPr8Yn5rA2mMP/o88WeFS2OubhqwI?=
 =?us-ascii?Q?4YZPRmo4dKLPCgmJOqCA79SqQqQVINUj8jHHwmh/IS5Gcjf8MJtYk3P52W08?=
 =?us-ascii?Q?xFk4XjcZPgBlzBLKkEojp03L+LjvokCxsDdy72iGVZgzRM2AicyAzwMX03ef?=
 =?us-ascii?Q?G8TGxWO2UGjFV5Mw5UU7bnmur5Bcjv9wRLN6Eq0KV58qvRCe/aYx0No/jTrw?=
 =?us-ascii?Q?Cc1nConZFJze2XbmqPj5DeZ2RZZfywChTARFka2rCPvB8Mqd8kKupp6ffxVk?=
 =?us-ascii?Q?gap/osGoshdo1OrpAIxc1/KT4OGyVrIWfuXOdW/fO4N9pIaTh08/BdXnaQJN?=
 =?us-ascii?Q?FcyTKO0XM7GbmDzmIrFUHpfTIiorUbzEMp4tt2aZZo0Uqk/KNNXjHKKIzszO?=
 =?us-ascii?Q?oNMBvgEVi1BYcATHN0rHCvKRsLiWCM1CpFnGdguHCcoHUhBFDFYl2sBbN5L7?=
 =?us-ascii?Q?YTdXUznydONG95nlYt8+p9bR+0IhKo5PilkMPMaxRFG4Xw7e7gv1BDSVZpe+?=
 =?us-ascii?Q?tCqWHWG7IFBcWiB4tgWYNYmLsB7u4w7kVKkRNeZa4vQ/rk0lPHS2OynR1Gfj?=
 =?us-ascii?Q?U1seh17uMf2CRR5mfPJajSe5ovWt1+TYu8ll499Oi1wwCMavuSd31dp13wnX?=
 =?us-ascii?Q?MqpF1z5HMj2hB+L5a69ef6k=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d461fe8-5850-4ef0-b129-08db1aa6bbd5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:46:02.3149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z7zT5xu9Plzc/J6vH0W1OlE10WQIWGELr5mhWjRd7VGPwPcflZtq7s11eWWRKRzXkR0MnDePqPo6YrwaEh4jc+l1bawA1ZFp9JA6Oax4GMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6535
X-Proofpoint-GUID: ZVUpIMjXguYL8wqyaaR1kdmG0rfzrC0W
X-Proofpoint-ORIG-GUID: ZVUpIMjXguYL8wqyaaR1kdmG0rfzrC0W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=891 clxscore=1015 bulkscore=0
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

commit 4ab3a086d10eeec1424f2e8a968827a6336203df upstream

Use spinlocks to deal with workers introducing a wrapper
asus_schedule_work(), and several spinlock checks.
Otherwise, asus_kbd_backlight_set() may schedule led->work after the
structure has been freed, causing a use-after-free.

Fixes: af22a610bc38 ("HID: asus: support backlight on USB keyboards")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230125-hid-unregister-leds-v4-5-7860c5763c38@diag.uniroma1.it
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 drivers/hid/hid-asus.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 112c0c25a77f..6865cab33cf8 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -398,6 +398,16 @@ static int asus_kbd_get_functions(struct hid_device *hdev,
 	return ret;
 }
 
+static void asus_schedule_work(struct asus_kbd_leds *led)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&led->lock, flags);
+	if (!led->removed)
+		schedule_work(&led->work);
+	spin_unlock_irqrestore(&led->lock, flags);
+}
+
 static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
 {
@@ -409,7 +419,7 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 	led->brightness = brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
 
-	schedule_work(&led->work);
+	asus_schedule_work(led);
 }
 
 static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
@@ -433,9 +443,6 @@ static void asus_kbd_backlight_work(struct work_struct *work)
 	int ret;
 	unsigned long flags;
 
-	if (led->removed)
-		return;
-
 	spin_lock_irqsave(&led->lock, flags);
 	buf[4] = led->brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
-- 
2.39.1

