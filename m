Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D331D6A7700
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjCAWqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjCAWqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:46:16 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBED1A65E
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:46:14 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321LCjco017728;
        Wed, 1 Mar 2023 14:46:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=S8il7IBCavBJ0wivTelDk+JzTPmuP751twI2f6vUkYY=;
 b=ipYf1d8hPdiSYxGyfuA4VL1wbo+ZbNdC3HHatAH289s18DpYF5wu8ELVvhVW8pZQ1o8k
 bhQOLKPOCRc7rR0uT7EI34QhnJIoIQs/x9aMPdLe/jCai0q89DOOwbTFS5ltxcSYhSOD
 syzcSWBISqr10QH8SOyfraOIMHjPgrTllyod2E32m163Jzsfjpl0EmLx/BVRvNG+cj1D
 6Xb1TC667PVP6orFWGjvyG2G+y9G74kfhcOGKyOkVL/fRZ3OA2rTXWILT2aiQRwF/QSY
 3/0NL79uCsxvZtD8jFktVWpr8Z5Y0wBE0QH8nZvyM/IZur4huDEFTvFRcg92rgHy7xT0 MQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyeg8cqe9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:46:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bN4FnKSW8j3yEJQjxDguwvoqC9Dm5+S/gZHx0HrDah2ZrSpaVngpAIDH1GUzt8VeoQOFgLUZMpsU2BnwjO4lstLTwZD2UevLhVIe+hY//LXEHHg/dBDJDBT+pZc2bgKyT6rrFYc3856i6/63ZxzOAjLfArMGItkEr5AdqWYJ5bukaSl80xJ8mbWjHysVIgXFGjgxWLlTqvt4PEj8E5H/kQDhWd7W8Q9lA+eZMtXs9I2whTHARApNCvrl7bkMZ11OSpMIqJq9qTRTxt339rD8kjjEjai5wcnlvJ3He6yZdfqJQqEKBSkIjqbmt8fyVrhl1CIA4eDTGUt0CGRFwN1UTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8il7IBCavBJ0wivTelDk+JzTPmuP751twI2f6vUkYY=;
 b=jHW/tjcWX3bswUB6BM8B+OOGrl7fwZuqg4TApKsLywfSsGVRmr6lviMyuKXoINioO5gCVf0VSIMBy/YBQ8cNV/stelmeB8TTjD7VM6pMfOLvMDXHSGnNZIpWUenLyYAckQVQGtzfypk9aUVYa/ERUGb66O39WwWGqUgkS6lIqePsjq1blR10SRhCIfAs3xqCSHstWf7bIU56f9YHJk0bvjHDiXRN5SGQww7dSOOisyEOOCtl/FB7hIHB9/yybBh/bhQ9MoLx/WejU0Q0g6TCYzFxryVaMldzaw29BnTqfcSBlNR4goxBIidresXLSYYeu8D5Ak5g5vxCUUw24MB00Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DS0PR11MB7285.namprd11.prod.outlook.com (2603:10b6:8:13d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Wed, 1 Mar
 2023 22:46:00 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:46:00 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 2/3] HID: asus: use spinlock to protect concurrent accesses
Date:   Thu,  2 Mar 2023 00:46:05 +0200
Message-Id: <20230301224606.29116-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230301224606.29116-1-stefan.ghinea@windriver.com>
References: <20230301224606.29116-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0056.eurprd02.prod.outlook.com
 (2603:10a6:802:14::27) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|DS0PR11MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: c1b7aa22-6048-434d-9d64-08db1aa6ba9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zicbyVaFmhPRkxm6vztIDPKcNSVj25pg3gMBDj/4jMcJFos3R5RRKL9aMDAoJi5qyL29VZcGHSoNiuqq6TpyG6H1wJnphThY6AFbrTXf6PrBBshL/2Io4pC2ZY8eJ1ePNLcGTHxlLGbbGNC5dY7F/Npv2euCw+3+lNRe4NjV8uTEIvzIVSmQ7YsFCCMYTR86tP5MDPMepgj0RJz97hpCubEPDBk/AXCvL5uTdnnLfiYUXB/OUZsXLymdFNsyWYEPpW2NOMhBLBw2CpCjC1M9vT42+QohsljaOiG0ZJIwXDnCP8fauJyc71kv8AdOrCqLrjIGGLeSm9cZmjCfW6zxgXOfqtG7rgK1ulnJXUnIQfu8kNwrAYK9ae5asJm7hiOvMf+U3PKZSrrd/DP0piBtI2klMYkVe8RQTLEFhzLKdEWLpvDEwR3/9+soPUyPmqdjwLw5IQIHvAFpnu4gURW1dXx3h9EdmJsr+KmzGpACxRNPoHdxGtfKNVy2I7d+CZrXt4OAeuPDz8dhPa2ak1XU7+D2sYjEtBdF4xSj2lUyU3BxJQs3AtXmiDkZJgHE6J36k+jmWilHq+4YYf/ecnw3QK0yCAPQkAG/7KEHTvqZ0YQ/LQiyXUrkOTOZ/CqQ4FOXChsRePYhL0B+TahK/Af055gj7uLhEQRW5wp+ARiH7MDRh8UgxN/EQBqfxwyV1+iI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39850400004)(396003)(136003)(376002)(451199018)(26005)(54906003)(36756003)(83380400001)(316002)(86362001)(6486002)(966005)(2906002)(4326008)(44832011)(8676002)(6512007)(186003)(52116002)(107886003)(8936002)(66946007)(41300700001)(6916009)(66476007)(66556008)(5660300002)(6506007)(478600001)(2616005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BACXaeZuUGlLq7YK63F8Hh56mYREeMzqdr5ikaYUcHOdeZIp54PigUs4Moyo?=
 =?us-ascii?Q?blo8bF7tlrCvu/jIK3dOb6r8eoGqEslxKEdGKUcKQsHd4Du3ygS7VkKu5eK7?=
 =?us-ascii?Q?rdtqVU3mclXb+GX+7Bz76hY1CZqkYSN8vamhWK6D8dk1ohmbMXlfLSz5OlA1?=
 =?us-ascii?Q?Cf1uKe3ypfpfQZE4v3R5QZYh8eSJTAwFyyPL0j9dkzq7RD5vGcwdgfVOjnSi?=
 =?us-ascii?Q?CMLuc7DsWdv0NGDKEHk05lw/8r7BFOt5Ug7SI5gabXm9HR9ZmpsEulW9WS/T?=
 =?us-ascii?Q?8kKHLphsIOmkXX9Mpr9JgROXGr6DSCTMq3dTh5V4Zmlo/tGqv9kkkdbvlhhQ?=
 =?us-ascii?Q?388iwjz626GOpL3mfAWqFjvt5Bxk/B39PyCbMdCl0fkBsXXayDaPqTNLTlnP?=
 =?us-ascii?Q?xeQetypKCceGr/ykgs8AlCvjSKqk4LYMWt3TEQMdIu/LUzd5p+8pXBdhZHYd?=
 =?us-ascii?Q?3Bqp8P+Y/1fXT46W5YV2GZde4YhUy5gi+/nMYvGy13OWPWpm5b5lbWJTyKVI?=
 =?us-ascii?Q?uF/FYyig39QGPmB7hGseLrCqymyrLNsXzKrKgui/hNjuwWtzd4daU4pZqVEj?=
 =?us-ascii?Q?Zs0z5JlCzLxdVPRNHmCLbU8+JuUoezRPWj1eMLWQWFNXB5X58NcCX6LfoQRT?=
 =?us-ascii?Q?pam4XeJsLWUUmt7fDRM8eTvLxepscmRfb7HVAW0iO8DHjJZQb0VuM3yOqSMg?=
 =?us-ascii?Q?v4VUPHlWeBIbUvKTVdUnEERkXH4mgo6d5mIAtxTeUdntOwWIgI91N93wWUwl?=
 =?us-ascii?Q?n7IbHa96YQrVJw9wSWK9UU0ZkAz4H61AdJRszZc2llcapXAr8b20LekdOKDt?=
 =?us-ascii?Q?708zqKye21STswvhkcjqmhzjvpExI6mAxAo6/gfbf7bVf4Ijs1slyw+2OXhh?=
 =?us-ascii?Q?0mzzugMLnmgAvqnuTgTg8pyIxt+XPoOcJCW2iUGX+/ybtxvDCZ53IYFA9XYn?=
 =?us-ascii?Q?xaH8BCq6TcPqQBAsdy96BrI1BiLlpkHqpGFxQ1I4NAIGDIziakUUXDhIwIXP?=
 =?us-ascii?Q?ohcAF3oyitePqZjPya1o52ydRdV73ZXXEERTjIlA42HjcMS5h7YDuIvraj3y?=
 =?us-ascii?Q?POgGVe7A5LsjXQXG9SFt7FAF/MqtNKSeV0smeg9YoEZYSlgpGgCX56dgxsAM?=
 =?us-ascii?Q?+f3LXKZ3abdJW9jvqlIlIOQPW+NI6DnFqYmzHKz7dkxAoOziq+CPyEbjHNEr?=
 =?us-ascii?Q?82kHPvX8QI5g43CxBqYLaEF4R42pz8IuTNwIgQIlw6yIu9I0jPQVHq8JbF9L?=
 =?us-ascii?Q?AQbmMPbT2yfUBNHYiXKyG7QLcgWrZgCgpvAppJLPbFG8pTajD4YZYQBCDqbK?=
 =?us-ascii?Q?cC4Ya1Hd1I+KyCI3KSzOdg7EHKXZNCg7T+AA/pEowsagXyTtlfKVviJ76ZzG?=
 =?us-ascii?Q?jGoT4OtcyMAXPNZy54Kpd7yclfiJI5W//6OYVNPwUSSXk88d3B+yonjFfepK?=
 =?us-ascii?Q?g25cHxpMj/BaSU2E9DZZMEtskttY3P9kF9kEYsN6IYg6nvY7ulIhk6gMVG9Y?=
 =?us-ascii?Q?K7YepunBoWcpDU91iftDcj9eab5QxM3t9QW/vpmA+vF9ulj0n4SgaWpDkEI+?=
 =?us-ascii?Q?oka9szawMknpTws0370Q4y3bREjl97vXwCPSMIBsQZRgod06vOcnWLJhX7L9?=
 =?us-ascii?Q?WgnxdDQbBIL0VFYLytiHVN0=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1b7aa22-6048-434d-9d64-08db1aa6ba9a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:46:00.6113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gASSsJcWZaLvnVeng/A1rof/3K1JQtAEKDHe0MOuipt+1ZxCeueXN9fWDe4ItOLLARDO0Pai9lQCiJRBx2oaq618Dz9Z3Uei7h37jEXI5R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7285
X-Proofpoint-GUID: OsBHOBVWgztGby9vRG8YmnLBybcnTkPj
X-Proofpoint-ORIG-GUID: OsBHOBVWgztGby9vRG8YmnLBybcnTkPj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
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
index 9a6b63828634..112c0c25a77f 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -95,6 +95,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -402,7 +403,12 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
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
 
@@ -410,8 +416,14 @@ static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
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
@@ -419,11 +431,14 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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
@@ -485,6 +500,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -1013,9 +1029,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
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

