Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4DF640223
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 09:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiLBIb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 03:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbiLBI3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 03:29:46 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2044.outbound.protection.outlook.com [40.92.52.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F101B9DD;
        Fri,  2 Dec 2022 00:29:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h45j8ak8pCMvptvI54apD+z4bL7vyr+EAoJkHF83PIGWhLI9KY5h5XNSGynQXkctg8S9GQhUyix9FhtK/BGOQzJbYi8Qy1Zjijw+VrO6vDdPtQGBvKFZRWRVYGDYRmY/asRA4fj5LUh8P0pfrnBVH4fkT6H8Kvww2SCLYWaufVQffyAUSs6Ef+y8mcEyy6uHefEfskGSX08lqqrY7rOKY/hGCezDXDRDk1seZoQ/5h2JWn2k/bgCH22uQbebembjDcYJaETt3PfvBd3ygRMtP/bw5kxjuu2LsqeqJMHfElQRxYL7VOSnvpopz4fzMbktRvOxYylPF3c6w0fFktnpcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HcybZ2vfQ+EwoEYW4hg8k8tIiUXVbxURLLrGUvdwNY=;
 b=GTnOYSgYTJ5v8XBOar5pgpBASuBLVthYlsGapl+gwcLixGbiJD0d42dP47aDHkePYWntrpkzYFLFFFe7Jz0Si8gf7x2/ISLTyxJFe7ohuwLf9HLdOBma2hd6yClzV+44YaubHlqLo4kxiWVaaMxLxzSanqfsoMUL/I2A8oYz2IeS4pe8mD3Z0b/MkW/8i8yafkJ/UA4TkBkQaKWXaW16fsBX22cGiVmeQZNP1q7fDMBqppWp2gngy/ox1u0rjA9+UcYYqdKQ1eI3wrldF0jPfv1rURDZROHylfV7931Xo1wU5wrqvbtYQjKc/1ckox/KW+Hhjokoyj62PTouS84ghw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HcybZ2vfQ+EwoEYW4hg8k8tIiUXVbxURLLrGUvdwNY=;
 b=YZrgIQq+1c4SDuGhqzajKt+DeA52mJuGAd8IGQIaZMqMSrARIh7lXJw4BPDmmsmcmS1cFVNu5V0fMK9OtDrxDZ/h2r04uA8znXkzeqqhILI3bjav7XYRpNm19e3bwwJzpGsTX8hsjE8YUm2E1q9HGGO0+9WhUJysGPI/FqhPWtcT2bnzUAHWNjEYrWY+nqHHwaH+qDPFWcrlwRaKdZ95zq34WkDzDSp0xQguS8bpPzivJhVP6J/i/0/OrMbjcXNY773vpQJ0tdKav+moRJGnYZhH05n7O0m76+eAPPOv1UvwRGXLXBp4nQZt2Krux9adHeT8s4eWyINkk1l4SOTr2Q==
Received: from SG2PR02MB5878.apcprd02.prod.outlook.com (2603:1096:4:1d2::9) by
 SI2PR02MB4522.apcprd02.prod.outlook.com (2603:1096:4:109::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.21; Fri, 2 Dec 2022 08:29:29 +0000
Received: from SG2PR02MB5878.apcprd02.prod.outlook.com
 ([fe80::2c81:c803:d49b:eebb]) by SG2PR02MB5878.apcprd02.prod.outlook.com
 ([fe80::2c81:c803:d49b:eebb%4]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 08:29:28 +0000
From:   Dicheng Wang <wangdicheng123@hotmail.com>
To:     perex@perex.cz, tiwai@suse.com, sdoregor@sdore.me,
        john-linux@pelago.org.uk, hahnjo@hahnjo.de, wangdicheng@kylinos.cn,
        connerknoxpublic@gmail.com
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -next] The USB audio driver does not contain the VID and PID of this sound card, so the driver is not loaded.
Date:   Fri,  2 Dec 2022 16:29:08 +0800
Message-ID: <SG2PR02MB5878D3E800F2D571A7C2234F8A179@SG2PR02MB5878.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [456Z0W/WKjSUg/mAEv8OI1fVDlW5lOi65hvD1mi52zI=]
X-ClientProxiedBy: SI2PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:195::6) To SG2PR02MB5878.apcprd02.prod.outlook.com
 (2603:1096:4:1d2::9)
X-Microsoft-Original-Message-ID: <20221202082908.290632-1-wangdicheng123@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR02MB5878:EE_|SI2PR02MB4522:EE_
X-MS-Office365-Filtering-Correlation-Id: e9c38405-167d-4915-c8e0-08dad43f5427
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2vEaOTpHPClu+fGxcvAMh2DUqh/pddLKzjOb9LJg8Qhgq1r9yMhrGdmKMbhLnQutCBl7YZCQO/cvPWU7cmE0zdg7FFHpe4hS569FKUQBKcrhUpiw18f1WwKsjnaXCUbHnYBD3k+Dl/xGYyAxum750XfrYmhglb7YWjzpEQ7Wm+yjbb9Sj3RB2WSlDn2CbzF4foXkRMw5ztA8dOeS/3mwPrcxI22CX1gdUYxcK7Q0Ffdt95OHDJMNCkxEOFCzgaTP5WhStT/q8XkAlHGCBGl1cARJIvfekPKzaf8no7KMYpthdrx0UtC2m0mTZqIiOcUVHrqDkQdbQunZBW5TnLY5bycWoq6OeEaeT330JGMyzEtd+i7bThdJk/meiIcpZqAiyTi3j04KwFgCtCglfgQUzi+78Wo2tvqPpisFRlWgJhY4gJvv6rdJdxYSS5g+mEQtVfRQlClP62h+stay/0dFkkxcRkBGHkXDdc8SPlfpJaN64aLcDlFoXv2iQTmKcoqdfyZCaTepqqof3HHAnE2wV5z/mHoBBEmuLa+6PLnq2H0fEjX77u9eRZWxtyn7+NM5QOdj4wANLBTXdQ3SBjDz8p+R+PDuDR+b0ykbTDTt4j8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VUOn0T5R7Z76wQE/lCxtAexn31SPkWYwCW/LbYJEHlW+jAW7umvlumvyA138?=
 =?us-ascii?Q?AWsCZjq816U2jnGH3GUvpif8eU+0U+9BYiViE3irlKk6zXRyuSTdm3PDkO2I?=
 =?us-ascii?Q?djl4PrYlW0ApOms48gXL/FgcBhrrvhgmXEL6F67KBfGmPT1yOcNJnI9JQiBo?=
 =?us-ascii?Q?BhouX9eYEm9cFAF66eMKS14t2AFzZwAh2TUOVowvjkVPuQlKGVsEUJFPagdC?=
 =?us-ascii?Q?CR+Hb6N/+ObsEHln5ttcdCHdcOGmzG2BHbkOfBYr8HDqK+KnXcpkc1CCiecz?=
 =?us-ascii?Q?Nn/mEQznbUApYcjOLsjv+jRJfNS+e7UBQ62edAGe3FmXs10PcMg/hdSfA0nX?=
 =?us-ascii?Q?zykUqMmEkCYBiWbcCZxEN5z6s4a8//Bq/VdbjpdOb5BOpGDi/PJ6sSnv8GHU?=
 =?us-ascii?Q?xS0ZqXZLwau2GDUHOJYWoZcjzYQofiKfK44joRi7CfMvigLgdLYR16f8oOM4?=
 =?us-ascii?Q?do5M5K5phJGnq0i9gqQX8Zbprus/lghhZ/3eMsGQHjFEq6P6ZStmN7AOiTC8?=
 =?us-ascii?Q?QR+jNVVClGpjHkz6iYVs+tkbAyVdX730G2plVJrnXD0nQp2k9MQMOAdueEPB?=
 =?us-ascii?Q?+5EZpAnZRk/EupzlkQr/B1TYMS/4E0DJzLIeTKVynMzZDv5emtmDIwa8mj/2?=
 =?us-ascii?Q?iacozFTIWDSV1uOnLS3bCn4yr1gxDNy7DmyWPUdWkFvSWaJgecUgNMhBC18S?=
 =?us-ascii?Q?uPotbN+W9cKUU52sEm54wnXftgSoEBMazAxfK+93cyy9CWvnEWZ1lQkHoWxk?=
 =?us-ascii?Q?RIvdreoiFHvQMekQRIqlZtLbHhKCZmpqlHy8zzqfycosmQ04e2BBDqnzNjV4?=
 =?us-ascii?Q?yFGqcl5KfWlJr8pSTEBdjCAhZUlQXBFLA+cgAZAkeP285HprDz4VRPaA3voW?=
 =?us-ascii?Q?NmH0236gwYkmv0pKG7wdFbgc+9ssfIyfinsoo11xY4baTYa2NbHnGOihNOb7?=
 =?us-ascii?Q?yrbfl61f3KnhDCpkLE+VSq7i6Au22zsEfBuLurl+umfSxfE+yHYrLjVXjae5?=
 =?us-ascii?Q?uJcPvXmw8Zp5JJRCoflQuVxkgCM0/CwsCae9WB/Lled6biBuHpOaCWkUAGmx?=
 =?us-ascii?Q?rw01uO1FPltRnN8AEvhGBQgLD/YNq0QEjhtzm8L3USE9T8YNNIs9A8KgwQOJ?=
 =?us-ascii?Q?BOZIe6WOic/tv0I3diUM6tjQzrf576POo0Clmukk53iQiQ3R7B2QGKJlQoUX?=
 =?us-ascii?Q?ih0f75RJqb5dLg4dztPbL52hu3m1gHnMoWO/jM2kI0McHrUJordo73lxFK2L?=
 =?us-ascii?Q?A9OoHjUFgsoEm/pMe/Tvb/BxIuoPirhEylJWGoZi9+3VPWHebHO/JXQpPdG2?=
 =?us-ascii?Q?KJc=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-20e34.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c38405-167d-4915-c8e0-08dad43f5427
X-MS-Exchange-CrossTenant-AuthSource: SG2PR02MB5878.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:29:28.9236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR02MB4522
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wangdicheng <wangdicheng@kylinos.cn>

Add relevant information to the quirks-table.h file.
The test passes and the sound source file plays normally.

Cc: stable@vger.kernel.org
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
---
 sound/usb/quirks-table.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 874fcf245747..1fb183895da0 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2802,6 +2802,13 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	.idProduct = 0x1020,
 },
 
+/* Ktmicro Usb_audio device */
+{
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor = 0x31b2,
+	.idProduct = 0x0011,
+},
+
 /* QinHeng devices */
 {
 	USB_DEVICE(0x1a86, 0x752d),
-- 
2.25.1

