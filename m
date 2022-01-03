Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB22483159
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 14:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiACN0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 08:26:24 -0500
Received: from mail-bo1ind01olkn0171.outbound.protection.outlook.com ([104.47.101.171]:14784
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230230AbiACN0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jan 2022 08:26:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbCU24P/dhVDC5h40RP8BAc/pnSQYYj7fyyRoAnngAnP1GzbWhPhMnnT/pt4fvaCYCiB4VDSAnMryx2AQq3TdKZh0datgEUztfJX3wXSYCxu3ll/UpuAxZZOZZZv/0sH2BrlZ3dDi/pbmXD7hFsUfNL53qlcb6skMRtn1gMUksJoZ5IcV8b0Dzah9JM8Tlvsbz9RskG3gyhvtzWhFbSW/2l2Jx4rx/zqIWTziVWxYNFYG0bCP6ADjgEnD2STdPO/zN/pIBbywUQwLqyD/fySI2jVXApI/07faH47q7xPp4FhqA77aPftnmPLctU2RRIpDJOaPwE66sivhf9ab7PicA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z40+vDX2Cs58W1x+IcixaKMPZ4JhEQ073XnlDkOaL9Q=;
 b=kkYQwd+kSCOE0BDTe0Qi/PeA6Z87IODmAs9gVD9T/xWIbR63AB/86DF3sQ5BVfH5b5rs28e9yQtU6Cwcn0zCekEUjoV0DMr+avBGyhTmtJvNKyipe7G6wMchl41dv8JuPNPJCXBm01pu/w4TRzgGG6jB9KF3UaxCc7WKVwyDxSWVXzNLpdUjYUdLpfJna+rNfkODPN/68P3pTRLtcNFmhHPrfus4JU64MXTMEF8kCDVDd9zs57cnVat6hsWJT/3NnlMHSm4l9bQsB393ifRYFCEk4riPNW4PNINn5Iv7+yzXTcSetbruOwR01/2mCGFjOGHu17EtHIhpEGC3hzKxcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z40+vDX2Cs58W1x+IcixaKMPZ4JhEQ073XnlDkOaL9Q=;
 b=SidqJDs0CtRk4OMRh0OxSb0eawvlDOae19I1tPftsb8qUFw2fi7w0+FuyoIwb7NT1zcXYfbLaaQouk1n7O+4Y5sz69pbm0Wfor9uAdIDbheNyEY1JaAgwG1ZDChOoOf7Pvq39/mURB79jf/W8Myx9nvk1qDVJMzitqRcFE/UAl1fZtlvgCrPB1O6e7ZCt7mIYTWyK5xbjH/Pe+XopGjhMfDkOsYy2dBj7/F56J8Larxba0SD6yx6A5XZdQUUFZiSIRx6Fifbrfqk3lLzY0WwEqQ7lkeuk4LQuvgG7EY6mOtZrVV1E5VT92XKfO4I83bpFLH3N840CYaj13u0+FdzUg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4826.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 13:26:18 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4823.025; Mon, 3 Jan 2022
 13:26:19 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@intel.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: btbcm: disable read tx power for MacBook Air 8,1 and 8,2
Thread-Topic: btbcm: disable read tx power for MacBook Air 8,1 and 8,2
Thread-Index: AQHYAKV9NQEPrSHJ/02HiOL1BnmTVQ==
Date:   Mon, 3 Jan 2022 13:26:18 +0000
Message-ID: <C6E4D546-6D9F-4A2A-AE8C-887D06621B49@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [XHwMp4ljXfZCxN4/lH1uV+Ol4lpoAMmY43QNewJS+av7FfYMvKm2ZBldSi5FOA30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12f80124-cc5f-4750-7d04-08d9cebca07b
x-ms-traffictypediagnostic: PN2PR01MB4826:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I2nLXLeRV2YA/7q/dVzPW4BwCYLxUNvEwtHG71jdd04TqCFpj5+ZRdfxwNT7nwY6pPIims6DNC6OVVADALE06+pJQT1bZsuHFsEIMDEdk+wN5PmQGH0lWmz+N6d2Q8cQ4PxQ8TrapaXc2YRhsMVyr6HkLY2s4NqZ2lzxUUo9YOsLn24HXNxBeB0AGFEpjIB/AmC/7MO2K6ggOqX/paBhyPj5/dJAJUPHZU/48R28EG0CS1r7n6QuJpu6Nl+beXPpoCPS2le9pra+XpInMRdX82/Ssc0vMAf4c8egmPqhXFJmaZL8+jZqNNRaJWgJZRoHvf7QWgm/nlMzVI6vwoKXLvEUNm1aka1eFPgaZZpITxPdtakdZLMhdaKDU9Fxu+5haNa73smeOZVgWZGUTktFFWvDDlEWQvpc7u/q74bBRJplBMTXNkcbbJPvQjw8ugZ/On1hvXE/Mt9Hc2PVk87irEeiI4jLJjVFVL1gZeAUEUmnIiuuXeBxb3To4PawvLwUDYe+RPI8WCpcX5/0/pANgcWTD3u+PfE+YkzCZsnQ/R49XNmL0mWh41kni8ZMdSDb1BmmsECYHelZBKpD3mADjQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jqMTr4AIgrnBIpyyNtFpmw5qv+6puHGhnqtWyhLhW2Ar0j6mLco4rd22BbRQ?=
 =?us-ascii?Q?XZT1mEeB8CrRt/Wo+QWhWWovLUi9Tmyv26ptSVPwx98VfODvc3OYTuM56CJv?=
 =?us-ascii?Q?PTnkgn0ISgvPJzNXULAQ9GHOMXQV4UPXso4dPDbqkdlZsT4gzqZC1OzrCsy9?=
 =?us-ascii?Q?E+E8Z1hlbsXUnIlfCFms4mmwmLYjjBXK4LWDGF1OlYSLoQDmH0jROGa+w9Sf?=
 =?us-ascii?Q?ZzJzB/yXOSdA4Rsa91saoYIDrydYyrzXUiailBEF+Xlvq7BytBp0273izt+P?=
 =?us-ascii?Q?W5IwD/hmyS37LLQq6cHRS8/XHYn7a5Jt3iX2+1YYunieGB9PilNUCw3x03vR?=
 =?us-ascii?Q?OG5jhqrky/2vJRUwoltJtqejIZxjTsTIGc0AfFIRn2xYIPbouFjDOzNynyLC?=
 =?us-ascii?Q?amKEIvNqbB/Ku6AmjtgUOVtAgMG9kgJfFvP9CfQD0njCb0Xy8x8YA/SoKkIc?=
 =?us-ascii?Q?h6zQccQaMwxSCJmjV45Uo0JZMsR4IKNUErkOxA3OJt7TUGUpvhCJ0efxDj6T?=
 =?us-ascii?Q?uwa8Qw5xpF60+Oo/gwTVyq7rA6gk70KEgQ5Jc3HEKttI7HblIw/mGKngdX1o?=
 =?us-ascii?Q?uYURgP5E9m0C5KzLGhI9yCZ2fP+wdYeckKA9CUX2xFqE6/ik0lCvZeqXLoGW?=
 =?us-ascii?Q?B2Ns8R+McZ5TawgsKDtdIScVleqzM/Vso7JNwH8VIOwmGCFV0+/gPhZm4sdv?=
 =?us-ascii?Q?pTMD4ia/uzKd2EzHTJnmVqS3PRnElbCw4822T10ZOc9GBX7SkiIHNnC1F3Bu?=
 =?us-ascii?Q?OI7uQws4Kyrn2WxgU8QMN/hiQ1YuTJP5xp23l7mGH8qiFYwM48Hn6CKUfJQH?=
 =?us-ascii?Q?YFqC5ohBhkx9xtOTwhzykuEZKCqIPPeCK0NecxSxt6K13Dg1wWHZ49GlMl/w?=
 =?us-ascii?Q?6Xx3+5lWySLivWd9Kwo/8r4ZRJRmaUMZBKcZp/ysu049o5xYZEuEOyWcMdfa?=
 =?us-ascii?Q?hHqq5qe9P7DxllYSmc1+810zakGEzVFpSTNb2QFF0FHIBgDQxqMoqRvot/vC?=
 =?us-ascii?Q?guThmb5MAyvBXYd/zZWwTnRTsw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0A4D24AB096F8C4D964E6EECDE2DE4A2@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f80124-cc5f-4750-7d04-08d9cebca07b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 13:26:19.0022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB4826
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

The MacBook Air 8,1 and 8,2 also need querying of LE Tx power
to be disabled for Bluetooth to work.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Cc: stable@vger.kernel.org
---
 drivers/bluetooth/btbcm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 07fabaa5a..d9ceca7a7 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -363,6 +363,18 @@ static const struct dmi_system_id disable_broken_read_=
transmit_power[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
 		},
 	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,2"),
+		},
+	},
 	{
 		 .matches =3D {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
--=20
2.25.1


