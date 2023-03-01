Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7BB6A7702
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjCAWqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCAWqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:46:31 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF991D901
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:46:30 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MdtjJ028283;
        Wed, 1 Mar 2023 14:46:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=P/NUZBtk6rgqmBYxnjqpgRqRN/axAYNhCTmkukX4afQ=;
 b=BMFNKN4+ieu/qxZTFrQHvL6YRFxqueZc0XPQbvHbJudYpoouJS0/Cr7yVauOZWicnANP
 7bHr0FO+ePKWBgrpnYU5IEiECU9zsdKsYvyrouVlW7PhjcM09xGjlJ0Ib6/nBhmd4LHJ
 xuZ4CoEmbeWF4uSIo1/tAZhN/xsPDi0t6DM9FSw+MyLcsn5AsKpAjzk883WiF8mDudK7
 s0RfIqTEFaWJpnvDEX+AdRZIvykRnkKIJEmCKEi0+PQ+pnz4tSTuiqmdhqH6Sc8mtaUb
 vgYlsX9LUOJJxfoV86sACBaLjjkdW4XNxLwnd/f59s9v2CxKchfC1uqYb+qjdM3xUo73 mA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrchtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:46:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeH7BNUAcIH8rLyoWi0eyReJcVj4qLdAZmZvx5+PF56Q0rfxw4igWIpHBX+YouDhD+DUj7JLP3ycd5lnVxJVXpTnaYy0ZMCpIv1ZltiUdoGUo3fbxKugp7A+dfQ8gcpiZ4WsSNjEVw2P1B+rKUsxNsY7GTTMCWcx3poehrkwBkpaRmwY6m5WFRaMl+fIfrZRxNE3dzgahY/m940fLSZWEhdPbwFYPEAqOhJ8UCbrKqCr1OkCFt9w1vqDJjN4I00HOYUQScFrQx3SU1mdZxiYSeRBK6esMUxvI1J2eeTw43sntAvdcAwRejyBPCMxgADILhNi5vM8uadAv+yg0H0x0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/NUZBtk6rgqmBYxnjqpgRqRN/axAYNhCTmkukX4afQ=;
 b=GjmLPuP3IMCgvlRGdWXwLJNdoMVKOi3LLuO1lmVpDWW8O33nnxrIuMJjdSjjvuge04lXs15QCS+tqt8O3SRCYVcb4cuyxKWY3NnXTsaJXtEywA10EorBmMTuJOCmBU5DibmmNPh5GWR+mJA95RGaY9FH9gxSIeBMdwej1l+D2FOPwmOSPU2FGpcgzTVhd0oNaeJCmWf+0B6CZyP5j6sgLL+MAzqquNXXJOtjevaweC0+3VRiWa9XrEpQeQ0ErdXmRJ/xy0/x7QRnGrp/U4tCPxUdgEfYLg/ij1Y9N5WwW0hWQEMYv2xXNwL54U/VZtjXWLXtF6BvRMRQbP7ELFHk2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DS0PR11MB7285.namprd11.prod.outlook.com (2603:10b6:8:13d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Wed, 1 Mar
 2023 22:46:25 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:46:25 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.4 2/3] HID: asus: use spinlock to protect concurrent accesses
Date:   Thu,  2 Mar 2023 00:46:37 +0200
Message-Id: <20230301224638.29187-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230301224638.29187-1-stefan.ghinea@windriver.com>
References: <20230301224638.29187-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0104.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::30) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|DS0PR11MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bea46b5-22d9-4e1a-0da6-08db1aa6c980
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RsU1Dulleuf4nIUvUVCOyiq+7DYFe2ld6Qgb7uENofPNbDFP0Ne2IYROx1toyRS0L2oROH9R0igPq1rS/zewEVpCoFp4eTOhWZ1hqmqasDf17HAg2/ZHNAz/ZwTj3M4EqMha5vLDW/o1WhAr+t2f9YfQ12vj1uv4bq6xDIY26lfkK8JmTu9WJaOZx+oWgw4FG3Eg0CMtTaPJpPL5ykwO7SiaXo0YYWcJ1XTbs+ryrx0vawY9nsZTtKLGyjdmIta+0Eoxp+WojuGt3PgwWRE58QM6wMhp/1/t9dJGIeQ2gZVAppXqEnjZ7RYrr3FOagOV6O5spXZ0CLQugHWvZGOYObHkK9I/G+kvaFOvDP5gYrxomw2E8QiwfOS7brKXg4ONGvFvN+0gEw5eN3lX2DlOpgx+V558y5bVlEb+cSoXSbXD5/DdWyhYTeyivF9gssB2iR+MTtBjhVgc+EE+yylMJYN+MgxYY5SFFtwW7noB5WPH2vLDmlPBtyDkYCZphtelOnelKqHzr08Ds1Q8/gwLFXGZh+xyS4X0UczzdSputQdnBpHW/GkcJ3T8bwT+ASL2rHqzWkGwcW5BFmuO0mATxTR/kKWsHf4Uj5s17sOyknxLS7AtrclQpsCIJ0X7ez/gSie1DBoEBGAqmQiLYHOgbLxWPUnU/qT7OPw7emEuftDRXUQANzZumJMZ88RCWolT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39850400004)(396003)(136003)(376002)(451199018)(26005)(54906003)(36756003)(83380400001)(316002)(86362001)(6486002)(966005)(2906002)(4326008)(44832011)(8676002)(6512007)(186003)(52116002)(107886003)(8936002)(66946007)(41300700001)(6916009)(66476007)(66556008)(5660300002)(6506007)(6666004)(478600001)(2616005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lXYVprWgHny5+BfFHGZBFE4s1X0YcY7svlnUj0aeZ5OGzaN4cCbQnfqiSnqZ?=
 =?us-ascii?Q?BdlxV8T5YPzWWlq35wa31UjKYYTm3QlF6kNWF8TdHtYkBHvAyu8Jk+wbIze0?=
 =?us-ascii?Q?L98KINSmrhqLlLLWtZQpoRBJxOKB1UO+R0vijxs0B/WQMNrAhRudAGLP7F/m?=
 =?us-ascii?Q?yz0RtzMH20xwXWpvrbFHfcscHwknQCLWUX7hR/iLC3x4Lqxa+dsCs8ffVqjz?=
 =?us-ascii?Q?CpLZMnJ/MwU6dLCGIGXYbeiROUTpxis9Nj9qruW64RtF7A6kTf2VcuT9ALMX?=
 =?us-ascii?Q?Lzoa5VzMKmOJ4zi39FE7iqjb/PQOScrSX0YP3cB/PEb8CJflErpZRGiZ3ma5?=
 =?us-ascii?Q?vlstE0Wb0DknYIzX44P4o44Edkv6yF9ufn3b4CD0pMZ+4oHd6aJaP160+Kg/?=
 =?us-ascii?Q?i50bOh/cRhF0Z+zr8KQrLLgWPji0/UThBbLH3aii0BwPltLfUvEbe5xElYLO?=
 =?us-ascii?Q?2UA/sDYfjlclqojroQeroftA/LLw+98AcXU1MeIKayfVeXP0UnT0j8zYMHkt?=
 =?us-ascii?Q?T7kQ46ipbGnhWLKe293vf0gfKtfeVvwLGDtPH1yOw/8dSXIA78sP5d+BnKhs?=
 =?us-ascii?Q?FzuIYEbTdOkbK+RyTMOefBBdGM6Uy6Bg7zo+SpqttvkudgHCVCdjgwmu0R5z?=
 =?us-ascii?Q?eWEWfxp5E8cBp4d4A6jgx+dh9esD0a6ZZ992nRmWBxy006mjEKkZPbebCcmZ?=
 =?us-ascii?Q?0sY0crf7TA3N4NDP7cIZ6oKakOcM1wFr9nowt0NzHSORd0Nkg60pOoc49i2x?=
 =?us-ascii?Q?mXMhvm5+cLBJsQhRWkGM/Vj13m7nhpWJOb0/8HCyZ0a35tqu/ikU/nANohgD?=
 =?us-ascii?Q?++hqvnRcpHRkXVeSE15CVqC8CkBcdu3K1JhCGSnVrJdHedYNKuNleqqwlwvo?=
 =?us-ascii?Q?ls5CQn/f51qI8fBn3BICA6jTjQByXwsn/RR4gDJU5I7dTXcxc0uH+Kj6OgVX?=
 =?us-ascii?Q?rwiu3M49f5GMFpBiYzR+6Z98puwsbvVYx+Mise36V69HRFLfxO500HsTIjJl?=
 =?us-ascii?Q?lc+cSDAHj7lHPyPHzFkIEgHdPyqXpd3D2Zq2GWDZfd3Wh8KGJ0tC9trxGcJk?=
 =?us-ascii?Q?0pr/4L7rGZwqYvxxlGZlz1okZSBbT6tO/19/ikODPfb5xgdLCprg18vlYccU?=
 =?us-ascii?Q?o/V9gqRZKM1lCAS8J8Tefi2awJPHqjt6kui9J+C8tBQKFzXAh39QpxsvwEQp?=
 =?us-ascii?Q?dfFdMn2euK01cg1UhacQKpnnXWo3QbFsq/TJACVRwHYc/z13UroBrGYnE3VL?=
 =?us-ascii?Q?gP5Y0jbQN183n20uxidrgkpY8gGZtabnzBfxpRWBmYPHrWvxijOcKemNpusQ?=
 =?us-ascii?Q?qk4psf7m8tsBbHN+SRMU/Yt9nilQhgIG/b5IEXoM1b/tI9pvlWv9n/fjQAwo?=
 =?us-ascii?Q?Dz1BOhKiYUd270kQEgtfTnEbC6hflS6VxJNAzctN9fFSqxHOatDORljQ60Sg?=
 =?us-ascii?Q?KidqCvhDGfZtvdudpANPl3FCNMUg9n4lBJ+0dlZYyZpaAu7Vg+eVVVMc5s3B?=
 =?us-ascii?Q?o6gfcbWyyw7keG93RI81U1Bed3CvpGHtAQ5do3QXhIOp6R7TpnRjZhiBDJWN?=
 =?us-ascii?Q?fl3TYKfT59VIUkdwU6+HWujJNlc5G8TgemWemIpEXIK/niXP/sp2cKp7fsvu?=
 =?us-ascii?Q?VsebovMCSoRcUZ/hRLVJFDw=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bea46b5-22d9-4e1a-0da6-08db1aa6c980
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:46:25.2437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgSjA9CaWeIvlg0mQf3D2fV2MaZi08wWoO1Q42JmKn3TNf5/s0q+Wcc0Cb1ZMlhiuVu6m/6nY71ReFftra9Nb7MA0atMmTHKjwQy/DWZrGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7285
X-Proofpoint-GUID: CteQpur7wexdK8gJzKByK6QLL3pn3nDR
X-Proofpoint-ORIG-GUID: CteQpur7wexdK8gJzKByK6QLL3pn3nDR
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
index d3aca8f80de4..695151522e39 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -92,6 +92,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -351,7 +352,12 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
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
 
@@ -359,8 +365,14 @@ static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
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
@@ -368,11 +380,14 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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
@@ -434,6 +449,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -932,9 +948,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
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

