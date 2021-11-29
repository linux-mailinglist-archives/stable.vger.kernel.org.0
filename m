Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A42D460F5C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbhK2Hfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:35:48 -0500
Received: from mail-bo1ind01olkn0144.outbound.protection.outlook.com ([104.47.101.144]:31217
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239922AbhK2Hdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:33:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhONl4x9Y7Bkt0faYqGVTESLJ88pTp3FO5/0MKhoUtixswyxiS7MaLNU8xa0RksdR+SVB24Lne9VZrEKLvZ94EEoqKHu4pkxnOeqOGurUXA2FSf2pOZanjOuAMCzY3RN319pqMlAudGxcwrk6zJ7DU9xHIIHPv0suB1WCzo9h/2LlUjfFMS7KThlrXfWNP2S11BDveTIRJi4mu96qE2mNRlw4WdwJsTNTZgx1IsPfQ/GRUmyWswI9hJZ3fVxcv96XauaqvsYRTwnoWdRCuGpK4RneOF9wz3t93xT7/HRE6XkBQhe8putswA4/vZ/8BQ0/SvevtzapYV+mdTAxC9Gaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBOpIZQrppyIhhKD+IeNfX3v+GIOMzBax3GPQID51yU=;
 b=fdeKN42tJKIahHCWurYjFKvv5b8UisQoDtQDF7e9ll+wvkCxi7fGCp8VJRhnVEnGxjMHiHHW2VfKHli6751Z15hFo+xPWx72CQqN5YRpQ799xYbNGSRi/jlrmam4DNOYJ3lZGEIVEd1VJRCgLCgCIjtvc23n+VJxK0qkzXzvAi1+iqip+ygT8pa6588wd4/unjkagXt/vD6mFm2H6zIp8DosYj4SNNL9sDFS6hgAqAd9n0c9OaG1Z1z5wwi4l/dPmLq0cGTPX0aW+H0rjtIh4oDx260rA+arwbI5YBEkNZSc8sc6H+FB3sPOjsqbAx7JMqmjH8RYTjzDrtcQND7k6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBOpIZQrppyIhhKD+IeNfX3v+GIOMzBax3GPQID51yU=;
 b=MOGUL0G4Uied6c/c/ocynWt1KshtxqeBKNiao059H4XIwdQcTfhzEnvtPtPyKzbhhtBaOf0m0vgxDqH78sss8g5bHqwoMos91S6emrAxbYwZeHbDrwfu1vT/KG4nlbgWSc6PtyJJbI4PrGMf0rm7KtcK/7SBZWOEs1ko0ugbw+Hut5h7JBH0hbd0ejCX5ehK17WzXBjoB+VWejRyNaqcZMyyGL7z6bpipBI4Rh5W1S6sYkPXdRAHW1AIFlfiXC63UcDvX6eBbCDRcIK9jQ1AB8iY8g7bDO8I2P7gLu69d+qGvVz9nExLfkzSivhEEvs/baepJsK1+4hqiSsxKXIkHQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1662.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:18::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 07:30:24 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:30:24 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 4/6] btbcm: disable read tx power for MacBook Pro 16,4 (16
 inch, 2019)
Thread-Topic: [PATCH 4/6] btbcm: disable read tx power for MacBook Pro 16,4
 (16 inch, 2019)
Thread-Index: AQHX5PL5As0z3EQYbkmkPAL7i0mDog==
Date:   Mon, 29 Nov 2021 07:30:24 +0000
Message-ID: <3E9D8424-A65C-4211-B5E4-B6D62400E711@live.com>
References: <20211001083412.3078-1-redecorating@protonmail.com>
 <YYePw07y2DzEPSBR@kroah.com>
 <70a875d0-7162-d149-dbc1-c2f5e1a8e701@leemhuis.info>
 <20211116090128.17546-1-redecorating@protonmail.com>
 <e75bf933-9b93-89d2-d73f-f85af65093c8@leemhuis.info>
 <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com> <YZSuWHB6YCtGclLs@kroah.com>
 <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
 <5B9FF471-42DD-44DA-A9CE-0A83BA7A4212@live.com>
 <A96508EB-55CB-4542-9274-301CE8E54510@live.com>
In-Reply-To: <A96508EB-55CB-4542-9274-301CE8E54510@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [YHhy18QfjCXPvGQP/fh+3mJH5s5ipxTm0koxojFY5h7t2tbijOs1hNKJtOEO3xMn]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b588e600-c6b6-41f0-df08-08d9b30a1bbb
x-ms-traffictypediagnostic: PN1PR0101MB1662:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D/5CTJPPEJB2+G3XwbJ16wfxoK0iS+hPqTQeIkLdd2HFdV7MUOi8C6D/cN8YPN1Yzy3fVARGVFOk86KVxX7MJ036zqEwSx4+m6Q2/QCnrP8bdOV4rdE7xUYXIM+5nUK+/aPSPwCOd8N6UGzqiE+a0/dWdFvCHnidvcQL/ktO4zaQHi823mNbu/JRgtjbJwvqVBHxiqs9QjtPg1p+ASa9kN+Pa8Qdk5TrB3ARMb6WrOSHluAglklWjbhNvif1NZtjdjZ/BLIZfSSlsQq9/gHqf0MF/Z2rEVy+1z5jYx9v7TqwDswB5f1A0FgpZz+CFDV/uC2wO82JvmhjcggiOYpUU4gN0evjGfT4ZRykTRcxdsjXFjfMkIWoLjV7+g8oovxW50gNq+f9ddQ4newOJvgO2uP5gKGl6xmJOfWlnvydrbXlzyHgIQ6aYFNeSeYqYviH9fNpz8dKONO/Zhoy7vqERLOrzmgpwqLXMzmtaGFtlcztsma7pABcLRRhyHoaQV2avIPay/ftm8PjEPsaOoARqMVSfy+KJO971WMTID023Kt3ZqWHZJuLoyDy7n5BVEkh3Qmj1H7saHswAGuBPCpwmQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: R7QZAs6xOapVuVYneOFpY/ycXtT/zi9x6WVRdB4vNmoDPxVwLSx4kcKAw1vya1yMJ+k+GXACbE3nnG7ZamXZ4sd/e46w1ZAaj0blPTSe0Bx6+OdTH1vChnB+cLPVkZcepF7/H6Bcs5gV0GQZEc5AnBT+klxasvkwKb1U9i8sgCklIV9mOYcs2tgPT7xI/zhuL0UQdlPPVS6DoVYi38d9M48CuMbQQRj4HAbFSF75XqN8GNUP8nDklzKayZi+sIU5AxSbfOwb9dpKWeo0cE1xiAoZernTNPzDjk5HqqSG+5hO+tD2ZEJeCB7lAV8S0oPkiW+DcU4hgKnM1Tqz4plKhqCKnRyhTT+7pS4kZ6zrmDw5XnIr3mocdzqRk5szgckMmYkZKGK+zekZTh9ibMpwbFErk/0Wv0HMPScmLVOX18+reAdaf57fqZEOz+Uw5qlNYUecr8qzot01UeSmufh/Z9b4UAR3qWDySqDjSUK3poIu3sWge/3YTGQwEcIcHw3c8jDGnzvUYyfmynYIkCnLEFz1Pr8RGXmGSsvLgvTfwTg7cyG9YA9e+9vnnnvK+dE1v6UvNFV9vfM7y/EaFAY75g7lVHtM4uKGEp4LRJBnpu5LcZUN/fDa121pLL6lj0hLZSSuaqlayytTR0G5RlQowsdV3Yry4GnMCU6DXnaxYBNDawH0qdVVgPShXMJaRkIxeY4BaChehKGleLKX4esUu9onR9QFPItw8Slt2zS/51izjN43mHilbdF6eI0NWopeMdQGzjPN6aNby0Ta/dqZSw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A1E22499C796F54EB84B196C009450DF@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b588e600-c6b6-41f0-df08-08d9b30a1bbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:30:24.5619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1662
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Bluetooth on Apple MacBook Pro 16,4 is unable to start due to LE Min/Max Tx=
 Power being queried on startup. Add a DMI based quirk so that it is disabl=
ed.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 drivers/bluetooth/btbcm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 348a4afa0774e..88214b453b0ce 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -363,6 +363,15 @@ static const struct dmi_system_id disable_broken_read_=
transmit_power[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
 		},
 	},
+	{
+		/* Match for Apple MacBook Pro 16,4 which needs
+		 * Read LE Min/Max Tx Power to be disabled.
+		 */
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
+		},
+	},
 	{ }
 };
=20

