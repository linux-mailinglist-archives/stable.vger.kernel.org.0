Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E52148315F
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 14:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiACN2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 08:28:50 -0500
Received: from mail-bo1ind01olkn0168.outbound.protection.outlook.com ([104.47.101.168]:34256
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230389AbiACN2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jan 2022 08:28:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j08jy22FjYOQog6dmkXRLCp9hs9qwZ4ttsxYcWte1j4mDllCO0jG8EPZH7ohrA6dYPT4tuOJYOeUUpUh4V++r6quCntsaxjw2rYvC/doeQZbqhsKrOOd5D8KoVegcwwMQvJg0iXLZHqe+sCzNJmsYvjr5ORrjxn6n6HOrDHnzz4Lb4//8twZbCR0+sN2IKCftjWoN4pLLRWX47Ijz5BfB7xoW4KE4Ms5Ymw/EHIdQNEGqAbAABPfI5Tgofw1awY4OM5Lx+mNKVYzL71LDf6ZDbD/K/UBIwhHftMcJ5lDrtIU3/1/Vnv8dT27Vb1Rvpq/aHhHwWExe7ed9+dekUtm3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z40+vDX2Cs58W1x+IcixaKMPZ4JhEQ073XnlDkOaL9Q=;
 b=HrDJnzMZ/YOYiZNNREeOUUdxBqcth2vJgX80PvFaur6ZFk7x6PljgNbFzbxqiio7xwP6Ktcy7g+rKEQ+5S3BkUsuI8yff0dnPuq5fcbl15f4tQu9vhwIsgS6VUAZV9OtX162wK59ryjaN3N7DijyW4Nl4k/WEWLX7RQuO/K3biN1qMTcR7JTNEWfldCaSpHI0uqtC21c1EMnMIBXruXXcaByG1PmHEa5bV9QfIi9pn87vFFueHarEdm81BGeQX1e7wPM65fbJbFagnJITr3H3NUGDMcZUOTffk0Ioir9LPEwncl5PTacbJzbuzMNvKQL0aTulUaGBtqJn5UoYv38vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z40+vDX2Cs58W1x+IcixaKMPZ4JhEQ073XnlDkOaL9Q=;
 b=TBPALQNyZtc5gBpDMztTfWOieEpPNGG7Z8JKLWUt9vhAp+YO7LEu8SpBfiLZDgLqFUJHxtean/J1Cg2cYJhQiFSgV3+fskg0ZIlaxMknWl0if7nUX7oUPmYwUyvUohFxYtnP3SznuJFUnATzyr35s7eyLO8ntxeIF+18PoGLoiKeptDXn8593F8BSWvsMj2S8j2ZBqB6omWvY4I26HKqDLtvmyjxgKvhZR/GNLEyY8disjl+E/AnEWJl0YdSbpW+eDBhWvvNVEadWpPBwanGiWy2sQDLZVfDOw4dNzN+n76oIyxh+P90+NY+GYUUnC+Oo8m6Zh6ICYVnrZ62XISEYA==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4826.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 13:28:42 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4823.025; Mon, 3 Jan 2022
 13:28:42 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@intel.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] btbcm: disable read tx power for MacBook Air 8,1 and 8,2
Thread-Topic: [PATCH] btbcm: disable read tx power for MacBook Air 8,1 and 8,2
Thread-Index: AQHYAKXTLbGnc8V7AEC+/ZbSLCtpHA==
Date:   Mon, 3 Jan 2022 13:28:42 +0000
Message-ID: <29D6266D-7470-4423-B37C-B702C8E85546@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [TTQrP+YjlmS2EsnVm/oSnOTA11EaK8oQhD1MGokvCT5AWhDL1RSu96KG0IqU11Zg]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e54909b2-28a4-49d2-6e0d-08d9cebcf617
x-ms-traffictypediagnostic: PN2PR01MB4826:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lGAzgl87/uSjBorJl36NwNYag6EvvMYn2cflbLABxZt3YzDSKHPvXexcWfc2G3y3I/46JhDrgYkvtDENbmBNGYCZP8rT5tStbe1MRpPKOwHJ1Uhh0QVsvY5hpkvEsObE5RhUt0MNxj2pT8SxPqYwHNsCxu+ME2M7HM0rIqgc5V7mEJgRk2VH208dZx34n6TV/ovFD0YYcP3pTUy9TBFi4yG1TYXkZPQDtoXKmLaIa9aktaSHpnHr0c6Mlpf/S5sosv/spN8NYhcMp8pu7vR0JKTUrHA7mEm2x9yHxMB/AZMRk00jo3D6ZE9BdPwzlLXLqG/l0xj9m5c8B6vFTN4C3SKIRjA7JrMtW2LxI6obpvV+0ztA855ezPgOo6Ldd4VHBSpPHAv8bksnoLKG9jLzeh4bv1hNXcjXdjniNRtNbNjq4VQOpQJUjUbnMCTK0LlIHuR2Bfvwx5sarz/cNVZxwTeZYqB3P82P7e38v+WhokMZINAHMb5Hp2HNNG0ZCboOhlKEsJBhPb+ZBaKZbe1gDcwiF14e4WpdzYvJSloIAHCOvLdReNLRzCj/0doye5uIoQzMGdKZv6GShVnbgkK3tg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AIgfU2OZCIsVVtmi5BvFwGHBWXWS0JbVyIlTIc624n95NeSYh2rJbURyKrKs?=
 =?us-ascii?Q?sRrGXjgBRAjx4FdJuTTcZqPFtyo88JOcF5Sffujb1MSoIfqcZXnCF9iMsX3B?=
 =?us-ascii?Q?RIbyHqBIvkZIpB98XexTXGj7Bolc28UILxRlPCNekHiaplK6mT8BeWwfLz9/?=
 =?us-ascii?Q?eUVdOiW2HZ95poW6vsYMEvoRfHgm2P9w1bhQINyecOjgJHWOyqMCqCc/gi8Z?=
 =?us-ascii?Q?jMYGL/biDrxP4hFx+dyNI2mjUZCET4Dmywv7w5XG3t0KIng0cxtBclAVso8A?=
 =?us-ascii?Q?30zo22pW0Z0iQjlZADB1ZNe4n1l1J6/vLv8+uYhFrEuL9df3Tt34mfdAlZCy?=
 =?us-ascii?Q?9VQL0i6G+lIWcdtd9Pd6k9tinp1STnHT+z7tucI3iXOIbQ5I4Pgk69S0gNff?=
 =?us-ascii?Q?jYY8uhr81QkNlaOHI5Vk2gXD66Ir4TtZFaGElJKB+TTdX4YDVmsjzSYes4nV?=
 =?us-ascii?Q?YkvKSYeGzxcO+CE1JmLyO29GdUWoc8RKtVnrCDTiyuQfqwfCV213+F8J3RVx?=
 =?us-ascii?Q?3+VPjB93rMGiUTgU0EVEYxXqt3UQ/QDbaPsjJlSH21IELX/x5+WSLN5Glqkr?=
 =?us-ascii?Q?egmilCea8qpUC7ousriIoUq0lrRauF0+Qog+NFXyTMtlnCf155r7Sz4eiY5V?=
 =?us-ascii?Q?g8tnG9vxR0AcSI50kkyo9n7y/PRNfdWCrqfeLSJ3/dhtJcrANw+v926AvpL+?=
 =?us-ascii?Q?d596jHa1+QHwH8fpn9/S+BoHZz8DqUyt8v9dFeNgSMy4BuesO/KXHOzZNDhf?=
 =?us-ascii?Q?rJ5RL/DCJb77g8k3omSbRC/8pbFAqTs2O6VrNkFoBuGgE7hXm764fI+NROIv?=
 =?us-ascii?Q?4nZ0QvCN8wMAZHIs8ZwgJ+mbeCgfgJggllXKdMqz266Sv/PzO4EombijQUos?=
 =?us-ascii?Q?YpeI36HaXeidDSLcZYiEUT3GmPM5ewhe+Fyzkl5J9+nywCdzWfwLiYAu43fv?=
 =?us-ascii?Q?9vHrk18ylTdJpYW/h76zER3CJaMHwtd7rfXYUBFTXCrkMhOPneZo47YZxpZq?=
 =?us-ascii?Q?m3fKd6RQdF/fQRlCLmDYdQuwhQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <410A5E6C7C16194AAA6E8FBB0CA95101@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e54909b2-28a4-49d2-6e0d-08d9cebcf617
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 13:28:42.7221
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


