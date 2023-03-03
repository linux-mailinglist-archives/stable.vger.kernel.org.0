Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1DB6AA071
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 21:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjCCUD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 15:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCCUD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 15:03:58 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E64234C3
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 12:03:18 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 323Jx05B030841;
        Fri, 3 Mar 2023 12:02:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=GEdTJBzsnLwgk6kDXjwQYbccUao4mWFwQzSE+ECdt1o=;
 b=O2GaQbMpx6X6FoXkf1ZPNIXbSbGFZXXcCnFb8+wS1V0p/VElaiQZ51CSzzi8CxLTK0k9
 /oJ+O1MY2NB7cww9xmQTx60QTK7Mtoy8i0AAmc0xqZXXkKtwM5gPjAxfBm4UkEumAVLT
 qsNg9LR1gF4qMrEQW9N+nhnUN5GuYXXZ0NCIRr2WyGRpwbdDnGLc37WcW4unXvkIUw0C
 NfrWfeBkbPgp7Zo80Pk64dGUG23vg/yhpASBXaNMQC9hwu405Mj3PCjwM5hVVtVjQYKj
 nniSDT6xXv8rUQRq1Rpv0ylPPNnmV6UhipHZjop64UCglF5VKevjGPIOUsDctzFcm8Rj ow== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrf439-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 12:02:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4c6jprX8eARI09r918gNER4fyVRzzrj8ywV1LJxBU8pw2TG+4R4mlAlF+Xxq0NWe4OPT5aM0/Qdx2gOyeZtqSqXr6VNJFl9CtpfqSsproOqLSy3HNxS7rNnuKmjMZ16hCODpxe6sA/4OAldgBEnSWjIekqs53c1tkfXAiIeQ4LPosMAhpbXPKHqQ33cbGKjfhSsvuUHP2Db2Yq3vq9frNwh30E77avIlFpwuiWwwnf6qX+oMXcfdcjz7/X64L0FHd3pu4ukf67p+QqHiloI9Ufy3qcM1RQzmogeeLAmeyGoRvViaWi81nGvPR4/PHgIheEkzmhTj8iOocg3NRV6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEdTJBzsnLwgk6kDXjwQYbccUao4mWFwQzSE+ECdt1o=;
 b=Z32X74O52g9tiMYQoG3VyjfimY0aITfJERdjUQpz1sSEu8CnN9bGT7qJN3+rFoMtNIVUrEB62UsBRCP6VHW8O4nHMZb0oZZsUGnC4TjWOlzNtxCIujXf/6jXjgXKtxAmE4jwP+A3EPnniBB4j/VCkVK8DGIdib8TcFxSnozh13OtED9GneuKVSMfJXzr8AUiBbmG85ETxbEM39pGozAisc80FPJurq4+0SKsrW3Nxi55tzPPXxhpy9SNvcjM7oM2NGmdiruNvXvCM6N/Si8Ynvh4ARHCBDd+8Vs2pyXxEGsVzTlyEkF6taRobJj0SeNPsvhd+i2xffDs0jwglSnHbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BN9PR11MB5417.namprd11.prod.outlook.com (2603:10b6:408:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Fri, 3 Mar
 2023 20:02:21 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%6]) with mapi id 15.20.6156.019; Fri, 3 Mar 2023
 20:02:21 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 6.2 2/2] HID: asus: use spinlock to safely schedule workers
Date:   Fri,  3 Mar 2023 22:02:32 +0200
Message-Id: <20230303200232.24355-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230303200232.24355-1-stefan.ghinea@windriver.com>
References: <20230303200232.24355-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0029.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::42) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|BN9PR11MB5417:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fc26a54-7979-4627-cce2-08db1c2232d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/8D3n7TaGXFxKBIckLzhZEMo9sySY8QF4/WNp5pR8TuNLOuGovEfn5F95N38zneUeJHrY2gCH598KHl7OrexA4uugIfkMNZFz2B2/HKdKRqMlpdLANK43uSbNI5NYd6O/YXkG/ebrX/5N1sGOOqPyuS+xKewdNjdlK5lzbayEW2gjulh8RxkMNBD7FscankR19R48S6pZxsg1+36ITTonwR0SnycNAu6J6KnSFXsMQdFSLV9bCmqJdQhPFXTF6EDNOspcvE9BL1FVcdWSnAujD0egqsZ5pZV+9iVgKZ+Fcwc2AUKr+Ss7YMYyoGwLL3Si/U4UkSCAx0ccu/kkAm3fpPCvEoL5AoDTHNoPP86Omh5fNS0/V9R/LSxtiGqGy7eHi1O/VAaHMFDMRmX+sumL1CUTDGfcW9QFoRoXiZ/sl+XaGN+QTZed5wGGcyMBPM4vGD8555ZvSVxwid1CHr0qKgtbFaYWTa3E+NOZW1fec7macs2+qeUBKufrYC3PqwkJn2XgQufwc2LrfUYDh+BoC6+9YMKT5yRu54uKToA3y/bei+9ZBu5b/mncNY0Y6VqNcfSq5Six0faNl9146+7mO+ER3TUoihGqaXJtMuhHRp0d36+1sDvW+etdF8FS4kcTbzHpqJUsdJ3CYOmPsvt5QZ2h4czsjrNzrj+q6yBqWmTTcsHx9HyT1ho4znax5L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(396003)(366004)(346002)(376002)(136003)(451199018)(66899018)(44832011)(2906002)(38100700002)(38350700002)(86362001)(6486002)(966005)(52116002)(186003)(6512007)(26005)(6506007)(36756003)(66946007)(478600001)(66476007)(4326008)(8676002)(6916009)(83380400001)(54906003)(66556008)(107886003)(41300700001)(6666004)(1076003)(2616005)(5660300002)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eMlUseSt92pwYXXId7PH4SwBP/61V7k8attkPXmIQsh58sSQu4BpsQNhmrQ2?=
 =?us-ascii?Q?JELhavhMg2k1XL7Odxtf5WPJO01rbJyPnbgDQPAqq6GDbwmHTr49T+AvmvYy?=
 =?us-ascii?Q?OjM2nQyy4Htzye4nsXk5HNYdtpt15J0PVwMD7EMVkRx0xEq/7jJ1AHbGZ+yM?=
 =?us-ascii?Q?HqZ4qxqnN2YMm20vt8780odoPeD2t2d2smpmds+hgUbZ2IET8F9MJANosilS?=
 =?us-ascii?Q?L5awL0Ypl21aDCbmUAxDWmtv7BcXXUVd19qA9SF9O62wt3MYH26MtKVjiPDH?=
 =?us-ascii?Q?KqaakOS4h2kpjKzkOenI922JqvKlMiyz1aFeDorLY4VkxLJjJgu+yASzJIoc?=
 =?us-ascii?Q?OQeky0lh0WbeibMx413508bi1PMsxamztXNj898xb2+ncDUtkZYbkd5uyUEz?=
 =?us-ascii?Q?6N+g0H4moyiu1fDeNZNkErzMre9mjLt/h5RKCjh23KwwgICazmT7tHTClwk3?=
 =?us-ascii?Q?KZyVL8+9JU0Qkdnryha9xUXQTClSRHnK1bsN0oqGFe9PjuCO4UNDa6ZPJ+fF?=
 =?us-ascii?Q?y1Df9xFOyw1eGvcMgT8/ts33kX3KyAMslmtMRw33cbrHRzLW57Uh+F185PWs?=
 =?us-ascii?Q?MSw7wrV/3tC5JXoiDoy8ac3sZ4G/b1ef02pkBqFByWRXSAkRcpMsysQRLAyb?=
 =?us-ascii?Q?k/MsXU3uHYOI2lRXfJ9hovwULViVSygIA+F1W5Sidy+5xr0orSMakw7rATYT?=
 =?us-ascii?Q?L2NrizBuM4z7etv05Z+kHRm1SIjH8MsfhALf9VoRRAAl1abEusUf61XY+b91?=
 =?us-ascii?Q?SbEwTuCX/iDfnrIqrqzPKz/3qADERZflkj0h+9m1/upktKtdlOgPuAIScf2t?=
 =?us-ascii?Q?x5czXDo8gfHxID88DU9+g+Et3tqu5/XHjCKglJAiGymWvwMpjmg98+ZwMYPN?=
 =?us-ascii?Q?nUUNyKZ25pdeGunfVCtQb8OresdrveR/8AOwYMFZruWjCPhkbORbIzInjPH1?=
 =?us-ascii?Q?lpU9bTMAO3BSQ5aFYd5DgweIcHregMjzOoab1d6NLmqe4JJjiEeeqKTMazqZ?=
 =?us-ascii?Q?ObCxF5n0HDZok0fPaxtcT3JrrQGar3wQSzhkXDJ1SteUySaAgrtNzAc1Iny8?=
 =?us-ascii?Q?ebAdlU+EQ+gBD2VB5jXwj5/GXSzQ4yQ+eJ3KksM9oFHBCEaUgH6K4ZTFxbrL?=
 =?us-ascii?Q?HDpGe7wcKlY+L6YJqpHJYn31ezCNiq72hybo1sXqTtxExpCbR4RSMkgVwUm+?=
 =?us-ascii?Q?FMF6kyv1u/s43wdsA8uqTSkKfVnJ8iWBQoQpNax/X6l8kucS5SGQFXnzadhf?=
 =?us-ascii?Q?nYHT1UT+ZmV1Q6nwRwHJCsNIlHF4a/FLHyjrmX64LIF9+Kr9ZOFrJVwj2FVp?=
 =?us-ascii?Q?/UhBFmY54BSqA0fG9QQmDls+z8SCswhFrt03gzQXjpgD0QOiplmpAUAJVth+?=
 =?us-ascii?Q?JRW9eNjHUey0i2W4qN5X+GDiK7liGOm2tJETurMzDSgNTZUquXPhmXiHQxks?=
 =?us-ascii?Q?ERRwxS+G8FFqlMU9qOG4dGaRxUUj/2vDQyWERKPbHwYhCRGHBF2/kW/ij5Cz?=
 =?us-ascii?Q?GINo4ZnSlhqEpBkkyg/ilxtFStAC5tA2qJVBJUQgU96E9/PlVuBbNED7KBch?=
 =?us-ascii?Q?q7y5p5it2t0Tx2Mms+cTg/jZ/r9vn2Kmi3gYMyxdAhJ/f2MB+h/hgJ9ys9Hc?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc26a54-7979-4627-cce2-08db1c2232d5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 20:02:21.2894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRvQ7Tcsqlryb6SGoTb2ilhchG02GF28Qf+SG0Mx6YJM1tMeM9L46awpkPSWLT3bO6ILRfkUsjo1w6OuYMp2G1jI4wu4W+j9e3zdXY7AFM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5417
X-Proofpoint-GUID: PGXWKi0DqzS-sjTkVwawk5AkqN6M6vsi
X-Proofpoint-ORIG-GUID: PGXWKi0DqzS-sjTkVwawk5AkqN6M6vsi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_05,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=997 mlxscore=0
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
index 9f767baf39fb..d1094bb1aa42 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -491,6 +491,16 @@ static int rog_nkey_led_init(struct hid_device *hdev)
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
@@ -502,7 +512,7 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 	led->brightness = brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
 
-	schedule_work(&led->work);
+	asus_schedule_work(led);
 }
 
 static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
@@ -526,9 +536,6 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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

