Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC4E6A7704
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCAWqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCAWqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:46:33 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FC91D901
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:46:32 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MV0i3008026;
        Wed, 1 Mar 2023 14:46:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=IkV856WIXNSwOt1jsBDLOjzYV5JIVzl8J3trTZhPfWE=;
 b=Nhx35VIP0CF+RHh/poRezLN0Hs3s59uYpiu2TbAkPe/AwjF8FMd+oT8XcNhLjHt49CvN
 bs9/ZPSDG5RKKQHLDkEiDuEetPmVTHOh4G+S5t4DO1uoiqH8YbsoIO73yY8i3omDwmkU
 UUt/hgS/7KIjb/xLzc/W8/2eB/Pv5x1ZSC/hLyDCaYKFoWUc++3zPOGd/Blw0phlaDis
 ubuC/3e9Z0+naWaAbG+YjCzQj/o9fyaWyDwLOTa7jwCAEugvf27LzvDgRj7dKVJ4fKqm
 kKbvmQx/FjCM+/C4l0naTX62bmgqgxPAY8+DWoW8vJGRDrUz2a9dQTxF75yl0kSCtqzK PQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrchtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:46:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1r3LqC2Fw7bFf1sgmKqJktZ1M5/oUSgDsRcbwZ7M0SaPtve6yaPyxt4MK0nuwNb8YkMmSHaf5VSjdiFnLu2M9/ye7o7T58RkxZbPLYbSVOsGW6L4ZIc1uvxONLh5HJJyZf5V4e9f1y/1m3zdrm8bixnkLH65hE/zzjJK0+j963jDZZd7okXtMdE4XkXPpIEeZ1x/KEq4TYwCwgUt/osdfAAfxQbEU1dqieLHbWGF1OZj6WkJWZ9MwKBcuOmgwomDbUwwDiMgjW+zuFJGXhtq6m+taI3yccD2gHFkg4louImapx7vdW0Q4qHVluuAg1T3v8NCmkW2v2gNmOTEpKTEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IkV856WIXNSwOt1jsBDLOjzYV5JIVzl8J3trTZhPfWE=;
 b=eRtEoE06Xj/nwQIxYLo4u6HoZ0Bd2QfmPRwSlRfCxYPdS24JUmkXhTCPp+RbT22l+AsRhs+zR+AAizrg32K0U9vt3atwvbcFP8rY3eIpUi5HJPf/pM+/RyD15oxQp614Jg2Ekj/BcT5ywwcb2js/t2s90ORQ3HbkYIvqBOWG+Gr/P5vs6o79ZCPHhsOYMEyWdRXYywhw04XAuzyFTg+O+19QIbrpn2cC2Upe0c5kIVgv0+JvHwEGnhiaf2kTx4z0K2nmkyurhKhtuCl43Jo3IfOcKEPwec+sl2A+VKvhf6O658mG0g94884YShSYcNmev4dFVROlUak9bkDf+8EdlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DS0PR11MB7285.namprd11.prod.outlook.com (2603:10b6:8:13d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Wed, 1 Mar
 2023 22:46:27 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:46:27 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.4 3/3] HID: asus: use spinlock to safely schedule workers
Date:   Thu,  2 Mar 2023 00:46:38 +0200
Message-Id: <20230301224638.29187-3-stefan.ghinea@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: f3884195-c679-465a-2c66-08db1aa6ca8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4FS+bOaWPklqEjjXvcV3vL1Svde/8gCOmfp2ZEj8CP7C8c+Na2YEvCFuNKewILXyNOMBYAsLBitdHhi8DKyyR1aXiWy1+/5Utgya7z2IFDAC+AcJgiabOclTV0OlkxgLuaSClE9IrdUZOrfVX79Ngs92qKpXNucr/9y3ZX/OcBJpcS3/Ir9PStHhMT4s14HmlKPvm8PFT+Tl8NzLYa0GJFxxYnzaEyz/hLkXhdwMNmRL9Zy+kBcbFSk1HHQZFzZ1uWmyMc+Awss964LuuNYrF7sTtoQLn4zz5UGt3zhB7ueQ2ahdLGc2AEWcQc0od03Ql0XajC1NQ4EtNHQf6Q0nS6FIp0JspbJb7sGscn1L80LqwY3428OvBsGhAg9Aw80PDUqnON1AhX8ZlHP1xS5A7884qWF51Izq9QodyzYoVB+1h/+75jEfyVJRM6llD0CAC8llorJX5ih8iwHvw4y7T8Wlhq1U6se9f2Gglm89z10Fr4G2nXeMquMbsyYbhigKN+AjlkKz91lffzY1aRczOMiwTyZ7x3ZrItjHSgS/rQ0BJ/wxOM6ieMlVi3NItJNR3MmAhqwkR+Ll3vG4uQd/FhRERth9JJ0+s31vxyGzB3oVcts9dBGGui3ZaKTSqtEquDczTBiB1peeaSu1x5CaZPG3IY53yUEHTx1+S17zOGEn75dP5tuKP1Cnn48YX0f8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39850400004)(396003)(136003)(376002)(451199018)(26005)(54906003)(36756003)(66899018)(83380400001)(316002)(86362001)(6486002)(966005)(2906002)(4326008)(44832011)(8676002)(6512007)(186003)(52116002)(107886003)(8936002)(66946007)(41300700001)(6916009)(66476007)(66556008)(5660300002)(6506007)(6666004)(478600001)(2616005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A+IV6OLPqPG0L8m5Q58rvNCoky+TS453lKiHKUjuxhbNj89JZ+uQUkMD15Rs?=
 =?us-ascii?Q?YJgW7vqNTHlBDelsjsFnnJEaj9/Ev4CHsXb2zNq+nYmtqF+3K91/RZ5tUpmQ?=
 =?us-ascii?Q?XwkOqjBM6+8m17xRJQAdBzhYY9fPfignx/Wt7w7ZNCqTmhNAeQshlub/ckM0?=
 =?us-ascii?Q?Rt3HVzTZVj3mOAGr/XXx4EXoKpvc4r1xMaoHhtLddyNEkQrjYKyQnvTJFGlf?=
 =?us-ascii?Q?nb2o01lO93FbLqdK/haxOWEGBjrCVHsqA3D5G3kvLd8tiK/tfkDjsu+K6bAS?=
 =?us-ascii?Q?5ge7okLtfUIN0Su+Xf5cbrr0zV9pbkVqEf4MN/UQRZZqUeBqR+5JIJid/VwF?=
 =?us-ascii?Q?B7nYIi3hCPONA4W1FnP/I2USQr2XRC/WfXl0k1aRLX8zX4YcuaYNNSzkc3+I?=
 =?us-ascii?Q?h4qT+ZFSpO4anNXVCmQVHg52pPGi2TyY2SYKGGWinrSBziiv4Y7mQdPEa1GM?=
 =?us-ascii?Q?9TqC7qz2Qt8H7SCEzbnNpgx0cRR0a0vlb6wuQEH+wKbvncBgkv8H1NXbArNT?=
 =?us-ascii?Q?+qz2X9ctrzn6ked1A1FwJ6p4qBqEg5lJ03bPKi2Ubl7yrvV0gq0VLboUcKK+?=
 =?us-ascii?Q?vxYPE6fVQocrU0+0uIwlvyBnYONtiQvIHt1FdfmW6T157XvMB4rQxCBNnUDC?=
 =?us-ascii?Q?WNoWM9qmy5O9jmV6V3+et8ONlBgRy9tG0tsnuIIuBz6tf7FignfarD+WZfuG?=
 =?us-ascii?Q?PrZM1DuXIUfX/OeLwhVc9IPa8soo6HH7J1dgzvrIo+uEo4aaTOiqeuDYbnXX?=
 =?us-ascii?Q?bCPZYWjoDT+l3NyJPs0HsAVw3TwJ+nDbUW8px6gaheYbVUZrUnT+NFV0iuPp?=
 =?us-ascii?Q?eN+EwgOB5HhPMvPuHIKG7VfAexdvLDOmIVOmyODpEm7RLum7ySZWidaqc3c2?=
 =?us-ascii?Q?/de6o9K2rQ3WhfOoJ0k4zqU0onyfhqMUbaU255++trb1I6px58Q0scmXrWbF?=
 =?us-ascii?Q?55D75Pgow11GbuwHcpJNzH566s+nTYU507q3WxRjLE2yOMBphB0EZCgryyLF?=
 =?us-ascii?Q?pNOOvpNYsiMVQXwMNWtSG4PIwcdDxdR5wrseL3Jjag3NOAn/eet0EpCgdO8T?=
 =?us-ascii?Q?iHp89ebQxyieKWhHW12IaFU1XAs42pl05g40UXhSKEXaNe+tFTXwLGqZRf7+?=
 =?us-ascii?Q?b8c3NnAfjVmh/D4N5ew75Tf/idpVwJDxAUQSN4VK9wC7lhzLFSfh2W3TXD/n?=
 =?us-ascii?Q?7YBYiPj5V5HuseexrHQuUUlBR41qoZrjLqqvJyB1sAGxoiXKyoGYagCI+nqj?=
 =?us-ascii?Q?HYBzrXdzvXMDJqkf2NyRDDjCZda7ddj+4+Glj/mZ9x+1lrlyzGsJv36jLYmS?=
 =?us-ascii?Q?pylhnpJNoT1Ngt5kdN/eTBTwB9FSyrQPwTM2W/NTp6P/dk4dQkS2wmNOj+t2?=
 =?us-ascii?Q?PG63OYcigMT5SblVza07JRgoKJI6eFkaFiEf141P7J8PZs+2TDXW/2HRc8be?=
 =?us-ascii?Q?fk8iDyBeb7UqI4jufUjmvMRRuB7SxYVNX1+WylLFGTwnUJyseho754ZWQx4e?=
 =?us-ascii?Q?oxJM6mYy4Us1ZZxbsPSJrNbaXytt43leOnFXahjD7wvHF+6SyBf8+RmbS3+i?=
 =?us-ascii?Q?fbGMvDvxzetP1bXnNIEjWWAzlAXsZmt8w0sXCFJ8XHTgPmXLLsM5bg3yWkNp?=
 =?us-ascii?Q?U3GjBKzCeWPd28AUG9XzPlU=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3884195-c679-465a-2c66-08db1aa6ca8a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:46:27.0971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dM2VgemaG8VuoWr5xTFjL5vm6fBcL5HIrR2lz6/959+z7QwDk2EjLbjfDhJ5dx3bPxGCfv5U2Ft5r2tESh09cBkcwap8vu7ZNNVEt2fPE+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7285
X-Proofpoint-GUID: q0xnIz3zmmQNn3jhHRZnSW0_H5cgCgNH
X-Proofpoint-ORIG-GUID: q0xnIz3zmmQNn3jhHRZnSW0_H5cgCgNH
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
index 695151522e39..e1e27d87c86b 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -347,6 +347,16 @@ static int asus_kbd_get_functions(struct hid_device *hdev,
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
@@ -358,7 +368,7 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 	led->brightness = brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
 
-	schedule_work(&led->work);
+	asus_schedule_work(led);
 }
 
 static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
@@ -382,9 +392,6 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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

