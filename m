Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41BF6A7708
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCAWrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCAWrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:47:04 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A420C19F13
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:47:03 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321LoCV8024370;
        Wed, 1 Mar 2023 14:46:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=dzXXl6lSAx8Ryxz+DInRu/q6cDPx3yowA4+31tuKN1A=;
 b=TahwD8ptXaOn73SNcC0+QRa6Rx4fUAQxnFhZA9hLv2omfiQGve2H2dw+Lzb2ASJ/ZoDz
 uRUA/uSnEwQFVhC6orixwyMUvXBIr3PhEBPWgMfDEQ/UqE10MBs8znqilv2VTx/4q9ur
 pGsuiOjVXLnZU7q3mkvGYSVo2ibOiufDRX5aH17XHSpkXUWHm4zSTsjjDJ8Qu5xPyW9N
 QPbm74KDwiSQGKSHMtctD/4O1WPq71xs2zrM9/SmD2QF3vtstb3Zo/D8kBZ0rYdV9Izg
 HMvB71kfKg4TGLP8fFqtOORogADr/I5M3rZOhYK3xIO06WhkzNKLkljBH4LUN8Re5Ims sw== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrchtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:46:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVVFSUkQrpmOZuF8dNb9vK1nJd95e68KgUZ7qZml5Q5QbGwMK0pLhKzRdu7/HehtyoxxJ/93BaAAkkkuMuckdbhFigipz3Tc6FVkUGyW1vCO800lms+UY6nTXWirvsXAN3GBpRJeL1ZdNvOuoZ2I4xUzpUH/8oeWIwibJoZ57VZfbCs7OEO74b2m96AQ/3sMf1lVDn+wm8wgdW0muPk4qYp4fO57dFse/lASKNdKu/lPntki6VWqeWxOyHiOLnI9NhiPqtDK8Qmy/8iUg5JJVdHep+xUoX/O8oITQgraYDA7x0SwUbrad7XfQiTb+F3MnFC3pJKV4U1kPCF9SStd0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzXXl6lSAx8Ryxz+DInRu/q6cDPx3yowA4+31tuKN1A=;
 b=Ox56e4f7DIy9KXBDqjn6ZJm+Yda6zbk/sXoHYp4S5mqqVhrDytuxfgb2YQCAV6WFyqiS8JbTEm8/72HKnxHeM8wEBWKnvb0ppaUZgIFhtqagedPI9+zdNwIQa2iSqEO6fMerMFKkYYVhRLleEdJ+h9h9EQF61zYbqKTMBZkk+bSlFK4uEsnYPc2FpFLn+KhgCHGHIbrUPXVX8VZZ5ibNjtA45pGg5Ty+Vn3+W52megxJTqDJdSkFisT7u36e99mSv0bZyiE1ed5sFi4LcXRkdsQHPvq/nvWRni2CiORPnQjzadtU3PQYkEJ1IObU1v5CTM6y8PwXpztxgKwVwIM01Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by PH0PR11MB4935.namprd11.prod.outlook.com (2603:10b6:510:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Wed, 1 Mar
 2023 22:46:57 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:46:57 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.19 3/3] HID: asus: use spinlock to safely schedule workers
Date:   Thu,  2 Mar 2023 00:47:07 +0200
Message-Id: <20230301224707.29306-3-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230301224707.29306-1-stefan.ghinea@windriver.com>
References: <20230301224707.29306-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0059.eurprd09.prod.outlook.com
 (2603:10a6:802:28::27) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|PH0PR11MB4935:EE_
X-MS-Office365-Filtering-Correlation-Id: 90364f31-cfd7-49f0-12ec-08db1aa6dc57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EbVq91iONVUlPxdFwbYuSNPqeAMe3GpiGEl/DmdlURSMN6kbXW2aYgVaDo4yogFT7EwxNXzt3T3xe4Sl+gvZWBr7GF7od/3rDFFgmJiEPAV1FbYy2+YGqnG9xsgSryAQUpublVKkaI0OXh5dBZU+I7Sw+98tsqAAMq7facnj8reXiKFwldIIBFZO6TY6FMm8o8SmX0b1DAU07xLX13LNknYZdLh/C9x5VWYC/1O4EeOjpEfaLk7DrVjqxMXG6pm5BFdP6ZCQDpTH5MxCK7qgwRivUrumvlHfK7PZ4ns9dpkUhx9QieKi9VBlVLnQQa97R2NCoz5d9tKV1b3h8h3cVDA8kJMkWk0tEVhfkqY4DqoKhzlpE7+z9Y0qzgZxNgbq8mv0fg3UKnCVM60Y5DgBVUHCSUSsa5QmQYeihNe7JgeTjyUDMV1RToPfsjocgZVW0z69FNtdTp3rsyuPXQgZlJXgyUdw1cnrHQTRofVELRDgkChr1Om3hyK263MIPi1CIGO4tt6o6HiZJut1ZfuzTSWay7bZ50mXFWWos5U1frQjolHJFcOx2SczobpgmLffWPYvP7vNNm2+gFdxP1//FzSBFKijqp5B1ZZws8+i7ELlVzcmws/5+3Hw4npEhrEovxKdTYxH98nJx5VRT1m1/orMvyAXL3KHWMVyqrpYINNhQxM41myVLGdb2jyeTlZm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(451199018)(83380400001)(66899018)(107886003)(6666004)(36756003)(38350700002)(38100700002)(8936002)(5660300002)(478600001)(66946007)(86362001)(2616005)(186003)(26005)(1076003)(6512007)(6486002)(6506007)(966005)(66476007)(66556008)(2906002)(8676002)(44832011)(52116002)(316002)(6916009)(4326008)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mk6O+Q8ZmXrbcdHW+o/MYOkY/Rd6//qIHxY9tp/cmc1NSwDDr0D7LoRw2WbS?=
 =?us-ascii?Q?kp+RpcpVUoix7pg5hJq7VwYXYDcfpxxFm6cirG1DQ9oeuR5EtDf8CcDMH+Jx?=
 =?us-ascii?Q?FMoAVqEbM6WdzQ5qv/rUpb6zRhQZtB6new9Ft8otWaCiuIjpOlmlH72WIeds?=
 =?us-ascii?Q?7wYif0mvZhyWi7cIOaCAqrts63x9u/b1IeEwVJEhWAGFYOd8L/6MgIKay0El?=
 =?us-ascii?Q?U/rGLKzXl/iQav/p0pEgIZRnlcs/vxGj97NxHesalVzbTy1F3LAYL8PSdcj6?=
 =?us-ascii?Q?yQKJNXrFOlDtOjTHRsZ3O/jLIKfnFEaLhiuUPOJFkD+N9I65aqUCEpcAoeIR?=
 =?us-ascii?Q?88jE+jTMzM7najb1msFp3m/O40L704PliPxFpA6Gp1YtvwNSdcAdlsQSKsLG?=
 =?us-ascii?Q?4OXTZfrbUM78MoRaO/MAjFIgbKgoKrOmCdeWzq2lHYof410LBIg3bxhgoPTF?=
 =?us-ascii?Q?FL3cBjImQpxu/cRl8v9B1LshLT/hzOghmEtga5hsPp5sPIofId+/+J9ci5NT?=
 =?us-ascii?Q?nd3ku9CHl2bx4ccN/BkCZx1x0gEWA6f8PNBdu5q+Nc/sVdmEJ03HNoI3XGVI?=
 =?us-ascii?Q?Co7L5cvHuWdKRhJsrXlCzB1PhcSl7frPWpd7YZTG5bdkhwjpX54W6eFt7pMQ?=
 =?us-ascii?Q?oGBMgRlqbrjTKFuE4Oin539eOUn4j37NMi2Ff9yWzYMvIpJC0yU0UHTHmkgF?=
 =?us-ascii?Q?O+Ui1xjtmK989tjXnCECEMwA8rOVyu3T4McySjogvBXdtEo78d2itBdJAC5J?=
 =?us-ascii?Q?oJVGBzoeScv6wMphXCNKtgpGPrV3//Pc/zXdF8NLj86nLDovbLQipVp1xmVP?=
 =?us-ascii?Q?H8uMWCqVKkZLa8jCQCYf5OHEmS+pEB+QfieNAkCF5qI19A0RVr5r3Q7d4pq6?=
 =?us-ascii?Q?xWYf2AIDMeR8Kx8ywZZQq3+R1KDRzdSC80K3PaisU6GkrUdqkdPYtR0qSE3f?=
 =?us-ascii?Q?q9fHEhPXR8PctPw73VbTq2N42s6cAc+sm2JWGV8AmCuR+jSfnvot5W9m3NMp?=
 =?us-ascii?Q?3AyBahLOammdlHlftK8C4luxRrK1I5WaFnGh0DCrd89V2qBjihWBxBYbDlSU?=
 =?us-ascii?Q?TWJr0JruAwvX19J6l5YJFHxEaMkVLVPmRbW9makM+jX3l1zU2qcHR5gAcwkz?=
 =?us-ascii?Q?tnHrlc3sMEPkOqZyZFav7/Dd0KZCIEAU6/siDT0qFylEPQfel886Jx7IvB2Q?=
 =?us-ascii?Q?MfiFhW+SB4yjlPWeOTX23btlrAnt+PgotOYvMgTlkh0jos5qHeHOmF0wr/+F?=
 =?us-ascii?Q?DOgtKUvXi7lYqT/AnztyCFanJbLqyNqk8ZXEKsilPqcMoeAVOd0o+9kt10zV?=
 =?us-ascii?Q?pt/KxhNtGw77v5XbU1bKCWc7ce/eh2hQ/ns+I+wTdcky7v7U3tZhaKAqyXiv?=
 =?us-ascii?Q?jx0Nnf4nFtd7fMReDYmzM/ssbanRzp0w4BhOlKuS2imHSnUevB/hOLmFSZJ1?=
 =?us-ascii?Q?1UQF9uWRNzhasHw9khBbvgALbNCoCnyk1shTMiRutt5pqUqKY+bqoueTlVa/?=
 =?us-ascii?Q?HnyOZUKPHaJjOzViee4BT7HDioKSqvOlT4qLskckj7X0cbhnqQ5Qjsor2bJV?=
 =?us-ascii?Q?T3AGF1MBn4AhiGvCAQyloJyFV4iHtRFRZEpI0mTsHxN46vIyPMXreegPC+if?=
 =?us-ascii?Q?sDN7d2e3MvYyCqRQoTCs4Mk=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90364f31-cfd7-49f0-12ec-08db1aa6dc57
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:46:56.9612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Es9BmvTqc+Zh0NIcy79hetnivJo9p1zHTdw779ZnKqK+nSTdXFXS7KJ4ura876ipz5d6ALwTyS/9uvZM9FAcIfEsoFfgvjLSiVNgPHumtV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4935
X-Proofpoint-GUID: pG--dT3eX7r-3Zh1ID_6axTzmVvghFQc
X-Proofpoint-ORIG-GUID: pG--dT3eX7r-3Zh1ID_6axTzmVvghFQc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=891 mlxscore=0
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
index f2fc67d57ba6..4dddf3ce32d7 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -314,6 +314,16 @@ static int asus_kbd_get_functions(struct hid_device *hdev,
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
@@ -325,7 +335,7 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 	led->brightness = brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
 
-	schedule_work(&led->work);
+	asus_schedule_work(led);
 }
 
 static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
@@ -349,9 +359,6 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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

