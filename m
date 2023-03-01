Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F556A76FB
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjCAWpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjCAWpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:45:39 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325911F5EC
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:45:33 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MafCh018135;
        Wed, 1 Mar 2023 22:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=S/W5H0ZXGKAib6tqHdICi2ZNRU8/wEOnTuHbP+0wwy4=;
 b=mdRGhO6ZOGELaUXcMZ8nic8uQzYMNKW3tWYmqVjcUO+f9PFd7UBj7+TPax7C6+PfPyci
 xSrR2jpdb3EFlnmYhaheewKeDqdK3407FeH2OnA+JOSw7IeeO69ao52P90qvPnrpBhR3
 Qd97lel0OK7T9ZvsOJTE+kDAuke3e3qqfsAqWE9DTJDQQI9wPPq0LJT49HvB1eKUw2cB
 HFjNjivYOJd2gRvO6lLwCjjv0igY+1ti2E+Gju809+IcySxAI/NXW/igDOtAbB4EY/iv
 nrQBXVv6hnLogqRvl/FaI7fMVyH3GDSH3NjZKjiBNruJUr9twxN6R+V7WMM7wUmljPAn Gg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nybmkct4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 22:45:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oyp49E9FoVuDdc19XCCrXr0ldmtwLKVfgSix+d9QbUloCJIb/D1VI3sJxyYSxtl0RkYg6wHG0/ZdJexgrn/kuT2SjLaNhm3OpRExZucFqIH99Ohy1wZqDxgzJ5LgPYTEv/8ATlIh/IjWr9lJc11ZbnZzm+3nAxh4RXNsZ5xPJ1SEpz0G11WsrhJRW8njPo9/maktygHW7qSFWKbFhWZCzMDMEkLJ3zVZMekPVSloQ5uHVelx9fO88c+cPBTAEQSOpJnfYOhfC7aTIQ0sFsQbuVmuwY4ycQj0oekOSc8lFwvBleO4jD4BwLGjon49s/hGHAoJ9lJzplv4kqrL/iyfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/W5H0ZXGKAib6tqHdICi2ZNRU8/wEOnTuHbP+0wwy4=;
 b=Skgt3xBGzQQJJjfGesiucTdWqdEwgr1ff7LouvQp63asDzlhhSXu9zOQRI/drkMVGWYF1XG3AMg0y7g/20PRtQSyC9cKzEjGihmxRsMl6hr0SzMKUkdVRmHeZuB7FwU6dyX96+sKDMHdTaj2ZNEtQ4VylpP264bcjfiTaxbQJM2xjD1IgI2QEcOh2Rz2QE9kIbpea8SmWOv+HG3em6xQmAhjLLo77Xn9i54lIcBdxnJoqMDTOchrM0XN75Iu22o1gYdKA96Qi7iD3I1WZgC22KsYSUiZhov7mutmtVBAQ2UqrKpCBudmsP9I37NegbLe4f7ReneBBWAySL93L59pkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by CY5PR11MB6535.namprd11.prod.outlook.com (2603:10b6:930:41::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 22:45:28 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:45:28 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.15 1/2] HID: asus: use spinlock to protect concurrent accesses
Date:   Thu,  2 Mar 2023 00:45:40 +0200
Message-Id: <20230301224541.29043-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0187.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::44) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|CY5PR11MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eb542c8-d388-4489-f698-08db1aa6a769
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5YfzqHRXphVvLx6Qf8GzLYW3M6ZqYj9CZaXMlUDkzT/BWMXT5TAwsOiEHZ0S3AVLtSpttaY+tS0UcTgGdkwSZMoZfM4TTN9985MI6ehY8W/M7OPufvqC5Pt58+7BLbRHBFESZuTb2EAjzDNFddjU0bmNFClzhBOGQ36FpTZocyCiqrwmbJjk5v7UUYeBV3DnWMaAb6gWj5kgTSogeSTGbu3v72Wo5R0WqByHWVlzRLGd7SlHR8+SSNVfuQNIUFYLEmq6kZmzmNNUwi+yJ+fXMcEn3CkqAvOooi405nltp+FkLrU8HoSPuRNkDuX+RNNB3XrbL5SZ5CCFp+qJAjp1hDl8DisvR+S7wEgUV4ZU3tqMet/yT5GRGpVdho4MwWLoOD4hKfOTvN7bAQT9rmnlnW4eOZimv9epVDxDxxhZQ9Dp2cbFnfC0AoMP4eheM8MMb0s2jIPwMK5q75eQdQwLpqKvMmhRS4+Xn6z4jphiyMWJCgdnIlERCsZYQhbJZAz4ksO0m04UrJricu4sZMmq4h2y/UQCJX9Pl90pQSGfVSolko8p7FA+sP9kaTy3dBmbUjZ4kBNu0vClJaDCNW+33pnazg10iZd7sxXEesFZLbwFprOLQlBTdFXY7x3/QiLpl1BSqxzpLgR6v/Dquub3G8WrPE/W18keRhyRdnf4wije78RxMN0wIqIxgoTOAXOI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39850400004)(366004)(451199018)(38350700002)(38100700002)(4326008)(36756003)(52116002)(86362001)(44832011)(2906002)(41300700001)(6916009)(66946007)(66556008)(66476007)(5660300002)(8936002)(8676002)(1076003)(6506007)(2616005)(6512007)(26005)(83380400001)(186003)(316002)(478600001)(54906003)(966005)(107886003)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MsAzWbF2pXj+OKhHEdN9MfOU+bzMLZRmKwM88l2LuuJDYGlAcbVY0f8b5jUI?=
 =?us-ascii?Q?ybXxAX6XBzhtM0RHcLbevj37UPyzwKP6ujwPRQFKvtT1Q1YabUk4sqQ6TeCg?=
 =?us-ascii?Q?NFA7L1jpBhMDeZyszwULwCj/vsst7uqeOCKmPRsUCTk53T+MBiXaYI73ikN1?=
 =?us-ascii?Q?Nv6V88t8/QRVe8O02qJ1s8p0bR1711DrQnTSY9xAK6dse6QYrJ5OHavuKWyO?=
 =?us-ascii?Q?qpyF9VbYrhRlgpjgIypws4CfAdjsU2nWeLADDXdZTbfrmhOl0ZHlYqHxf7VK?=
 =?us-ascii?Q?hpIKBbTSmnIVA0TSTx2W11kLh67iXI5FblqA3nw02VbJBzkl9hXBFlYFDGGT?=
 =?us-ascii?Q?xBr2+Mx1D3fVVLpRB7zsHmclqMmLbUXWdsN2yFZOsjGk+K1BN076RpmKaYOy?=
 =?us-ascii?Q?bW2sh0gvhXKUwQaFv2FCbl0RUq+3UicpSXAkMvqejxBhVC+w+v3+n5J/DAxz?=
 =?us-ascii?Q?03t0L5Oj5SlZaW4Nnx7OPUXbOovHlNDLGION/ddLbqov2+AX5mlajPgZArcR?=
 =?us-ascii?Q?JTfzkQ2XVuY12k0ohMtxqrwfB379E1JqBMucC9lwX2bF8SVrdVVjKYa+En2c?=
 =?us-ascii?Q?xAgr8WE1IUKvRO1w8m1Ih6XGw6HZ0P939d5FsgefFQVFbxirtnVi0lXnIoyM?=
 =?us-ascii?Q?4B442xN0M15r3z14bzXyDpz7lClW4yyF6JBoOeLL1AySnZ+d+41JFL18YIWw?=
 =?us-ascii?Q?8mY1EfEp8lnm0IwR8NAny63J2u9yTQAWI3aTI1TVcqJzrLaCYoR5AMJsGheM?=
 =?us-ascii?Q?y3onbf8NrJThbDh77Ww3iZ8bz3yBVV6dloJ/k9QykG2VWS6cYFtubWW0jhv2?=
 =?us-ascii?Q?Y7MZCr7XVZ1vjOHPiRpIS4gtzDdu6WFpOM3CWXREoChicV6MaeUqSzzXCafv?=
 =?us-ascii?Q?3wi5RzmqNBtbfwZbFiP4wGsmrCpCm2yhtOIuJSHBPhMA5/zMWIJRDLOfq5xm?=
 =?us-ascii?Q?YVIFQ+f3oYTlancpL8I2YMeIuNLu2KaqYeLZbM2DGJTBxh9ONkfqEMS1Pcs2?=
 =?us-ascii?Q?Nk7Jt6BvGOEAWwpP7TD/RjSBEShzYkuXDJc5XMOFcIEiWw5Ky0B7xuBa98fO?=
 =?us-ascii?Q?5kxkvJ4+mvN9aUDFIQ0l50rLl1NBKIRMOSGGO1fglqb+T4HKLFYrTKj45yWC?=
 =?us-ascii?Q?F4oabALds39gL197UYrS+hnCX7fVwengkETuJPN1Oi7y4ozM0mB8n22GuFcF?=
 =?us-ascii?Q?7/vfKz/E5t1VMuSAMrgFO2n2YBZa3UKf+9NjH6pKJBr+AgZZVwS18dZFFaQu?=
 =?us-ascii?Q?2AnreG6bNWRa2NfgClJELV+fUDxKqjZ+1uYy/JyBbhAKArPp9GqwMRUtSl69?=
 =?us-ascii?Q?uU4gnVFqjGk00yfns4J96ed21SrrilZfCwQQr8I/tu41SlEBd/B6nFgEScS0?=
 =?us-ascii?Q?byEFyUaIVfN8MwgTg5JTsWZGlItBh5u7oK6b+pe/zotEQPGxvVIXOO5RtwMT?=
 =?us-ascii?Q?TvdwrlMam4k3nDDpaQbODv17A6xLoB9eCcxA5Mn3y/E16BpWV3jgaZYIITqM?=
 =?us-ascii?Q?4gzN8GGP5r4arhdkMNc8fuaYA+QAyQW4znlbWDNyywNlGBz1guP1dYuoQxCU?=
 =?us-ascii?Q?2kgqt9CfTni69XLYdpVKxoILPtbsZBGRHDvLhbTVF7SwcoTkc4z57PBwYmFj?=
 =?us-ascii?Q?6cZyXhngpqPHUtXADjpD3II=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb542c8-d388-4489-f698-08db1aa6a769
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:45:28.1501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VamITwyW/afQ4cUqf+3WoKoxywKWVqvgjEcJe75y9wzUzfifWZn6FzwSO182iv9gljOvwPBOzEuBro2ND2RPPrx9FptTkfPXHpOxZR9ownY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6535
X-Proofpoint-GUID: wF2rVRLz4ZObBA1u3hbcFt2RhF6z6Woa
X-Proofpoint-ORIG-GUID: wF2rVRLz4ZObBA1u3hbcFt2RhF6z6Woa
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
index b59c3dafa6a4..37500b645ec4 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -98,6 +98,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -497,7 +498,12 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
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
 
@@ -505,8 +511,14 @@ static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
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
@@ -514,11 +526,14 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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
@@ -586,6 +601,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -1121,9 +1137,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
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

