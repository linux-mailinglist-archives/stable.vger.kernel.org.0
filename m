Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C9148D6FC
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 12:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiAML5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 06:57:34 -0500
Received: from mail-ma1ind01olkn0155.outbound.protection.outlook.com ([104.47.100.155]:12292
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232245AbiAML5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 06:57:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9cURbOmMoQTz7gQHDosrNSWPCocaUq1uX9R6vF7K+SvBGaHFotFdmF/J55k7aqt0SmXyap/9G+T3ZGhacC0hgEi0CmMKhmEhhzwLLfOUOJyD9qVLxVxM1Wg/FeZBicBoM5gNWQvJWWnFG1ryecE1bo1WxUNpX8+kTKY87TDC8liKoAHiOzlmR1zY+10MHeZ7llDKmmaL/td7F3p08D3iREO7eazTAkaY5BUORXHVW9Is8Azd9Yv3vjKA0+XZZSr9u+AeIFp/T5CGeYVLKXLyigiL1i1kOkzg5BW+0sizf8dIa0p2oucpGT4Wp0VtOWPh64Wy89dHreHnlRwehR5yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oc/Tr2CQRRwPhdMJBI63KK7uhjiVihSoyEVkexnwfxM=;
 b=ldrNE89f+3kOXb3UMXpLgw9Ay1GwDU4HI7JNtLPrFzV8wq99EhyKXiVHl1HBJDsE+PjuNMPjBBNNOu6haFUsZUAzCIq9xNWLTl2Rr48PewZ/A9YD4ZDg7fLN46vQs9D2C/lfw800ifhzZOLkYCSUiLLivjNhRKO+DiS56eRCq6pKgto7RGcisW0iMGmeyY0YtB79VzHQUCUAmjuNL3VbVc4WlQtRENADm7nlplyOHhDUVV4zHlhQFuOtPmMRWsJnVA/5gueD4jjvZ7mcGTbT6jaXmQ50Zp/1k6Uh1+ME+hTzTSJk5VuNPMX8x486EGEUyQW67TXH4WWGIT6iErAF3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oc/Tr2CQRRwPhdMJBI63KK7uhjiVihSoyEVkexnwfxM=;
 b=j8NjQId0lQU85VCTM9zxwfomu0gteeA7ZqGTTNNTfmcYS0XxJwWnira26sCmTGb7mq9EmRvU2ovw4tj/GlTmN1CGciTQqWSqjhQ7yPIwvAsRa5FmzFm2O7dh8D52/zIgHiiXReWIk5gkxW0QoB6qKZmrLKy04pQGFMipnvthXUsXAxCiE2z1SvtkQUNudjUDZ98oHQp5j9AHvJkw39H0opK43tzo/80gTZkLX3p1ZJFtJSgu0JrB+SLug43zgWOFfgamjXBBIb0iZhZeImnbEXhk0DTnvQo1faQILsfUjlL55hqGZ2ZSOPYf+4Wyzb6v7gCq9xlMlhTrVdmPblE87w==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4815.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Thu, 13 Jan
 2022 11:57:26 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 11:57:26 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: FAILED: patch "[PATCH] Bluetooth: btbcm: disable read tx power
 for some Macs with" failed to apply to 5.16-stable tree
Thread-Topic: FAILED: patch "[PATCH] Bluetooth: btbcm: disable read tx power
 for some Macs with" failed to apply to 5.16-stable tree
Thread-Index: AQHYCGr8NSEl1UECm0GD52IQdpWIZaxg2J+A
Date:   Thu, 13 Jan 2022 11:57:26 +0000
Message-ID: <1DB980CD-C24C-457D-8557-73618007AA4A@live.com>
References: <164207084357101@kroah.com>
In-Reply-To: <164207084357101@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [11o3P26iiIDPapzSDV7grpYQC/WI7WPsdCY25bRiCY2kFqtKy+H8AgLtTYaKD6w4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6049166b-d094-4e20-8912-08d9d68bde38
x-ms-traffictypediagnostic: PNZPR01MB4815:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zmt1djSYInVZyBz7sjnEP8KIFt3x7OFi2vjt32890niedxOQSvfaz8NAJuwiDStl9YF7Mk8dmnFsiQT/vz52Dpuwb8CgYFrC2crR2yszfgsqsUbv/TPGDGRK/C2H3mw3LNIGicKi4S1sI4LpBGAwsTWM4R2KxJ0jx07ih2fkhZDV4Iuw+wxhhsyzO/+u2iQtpGWxnZqNC9yjs3m3r7YioHS40eXKNP4IZDI+vOjcgLCEuJUnLwL1GXaMO//R2Jz7UazYVYb4r5ZKTNsNoNWy4U17IU0xBneWeTav1WWA1vbvNW2nkPxtWWhXTsKZFemF7syIgn960Hhw5Vy9BfnoIitMvNErN6IZwjDcbwngkKnnjjM4dAFvQhKyNHH7wUFrM9cH0ucQV8yrUy0/Gku55t+LwMQWC24obWSb8gYqbMm6FayzHsd287lnuez83wHPfXUXzYLHEYcF2zcoepxfuui5taYXbDQx9ulmwpeKOGvzFlCNjGSPO/B4kIo+Zjp1qU9hqKob5F51HhiumMJ9INF8lv00SEMEPJnYxkymjAUaqcxjP1tLUnZH/QPQFQAqb2UBUEMKqKpQErJkecHphy5YjsUa8hbFWBUq8SHWT6WJIQbeP+bxtLy/1NX/c2aa
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Goq5fpJNKZEFfdfMKBD9gz9O8Pr8s0S7PGP9GchvGjfDedZWk1FnA5GkFbis?=
 =?us-ascii?Q?MFnCfZgSBBuJZL0UAKjT09TCQZU4KnwOZOJC56T21JPYi4bmqKMC1GJZIWHH?=
 =?us-ascii?Q?paa4sdIL3Sx8gSOeoqOgyct8+vllHUFv8h0SrdgrVxTJaO0WT8PbVCevrqh6?=
 =?us-ascii?Q?GLUGwcIziXTbI4753yW2qNCnpspuCknpzfgpq19DfvGMCHsmA/PR+IWWciqq?=
 =?us-ascii?Q?k2QeXWbcFt7mEXGpW1oFh+ANqbJPuLeft9ScdsqVJcSxLda0CYTmEwgbyWGz?=
 =?us-ascii?Q?50RQ6VS6EK09dzqAITc7T3RZ77mHytgG0D94yQ3yHaodLcY2uuNje7DOubwW?=
 =?us-ascii?Q?nP0qzb40/4/HnIklWzxgsVtZfZits95DMXMlojyfn32hV6mE/5yebdHP2jmb?=
 =?us-ascii?Q?DJPjXm6H6XqLGOpChIKGTd8F4E60xNy3vhsGAfLIRWkzP8+L2W6QfYOLEiao?=
 =?us-ascii?Q?S+bKj5QX3H8TuMo6cvEd2SUjDiQRWAOxThuNIveWgRIFRiiH/IGZ37eB6gyd?=
 =?us-ascii?Q?Rl2tERJusVsUT/oRroNNyUOxWBednq4YatSsSySIaaF1kFhYEJggxXLP/GIX?=
 =?us-ascii?Q?qEiv9Jl8kgSE1xE/w84QIJxbozYt9IVGNXKH/k9zwt3MKT631LxhJmmnNLlR?=
 =?us-ascii?Q?v7GTxxlILTW8U7aMfphYZRV29CoxfUkzcg2HvvecnuNiYMWCZ0sibUi44es9?=
 =?us-ascii?Q?OAAqB/fl3GH5PbfE+6vWLOwAqkJNtmKrwLMH7ApDDHCGN3Wl+x2wqan2KHXJ?=
 =?us-ascii?Q?3ARJLL3V06KEumIhpMjfTwghaOrQSwijre/t5XXUCmAQk4n6CG9kUadYyF3W?=
 =?us-ascii?Q?1Ur5R+1eoKKNrWk6bVWoBH1utFA6zt1KBia9lkBztTHJS7EHwNe2Ghzr37Jz?=
 =?us-ascii?Q?zgLw73CpNfIWPGQnNgfsTdVQsKjM++WkOjMtPo0HnqVmY3rzWPron/sO36Sl?=
 =?us-ascii?Q?sp8a+txszdW2urrcuSlPoNkV2SHFzRNXwd/QZytzl92eccjmsP7yFBE+SWQB?=
 =?us-ascii?Q?PTtWPWQPz2/6ccsxuWkEw3x39Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <982EB28F120B0546BE34AB49E77E0725@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6049166b-d094-4e20-8912-08d9d68bde38
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 11:57:26.5984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4815
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 13-Jan-2022, at 4:17 PM, gregkh@linuxfoundation.org wrote:
>=20
>=20
> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 801b4c027b44a185292007d3cf7513999d644723 Mon Sep 17 00:00:00 2001
> From: Aditya Garg <gargaditya08@live.com>
> Date: Thu, 2 Dec 2021 12:42:59 +0000
> Subject: [PATCH] Bluetooth: btbcm: disable read tx power for some Macs wi=
th
> the T2 Security chip

From: Aditya Garg <gargaditya08@live.com>

Some Macs with the T2 security chip had Bluetooth not working.
To fix it we add DMI based quirks to disable querying of LE Tx power.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.c=
om
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 drivers/bluetooth/btbcm.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index e4182acee..07fabaa5a 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -8,6 +8,7 @@
=20
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <linux/dmi.h>
 #include <asm/unaligned.h>
=20
 #include <net/bluetooth/bluetooth.h>
@@ -343,6 +344,40 @@ static struct sk_buff *btbcm_read_usb_product(struct h=
ci_dev *hdev)
 	return skb;
 }
=20
+static const struct dmi_system_id disable_broken_read_transmit_power[] =3D=
 {
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
+		},
+	},
+	{ }
+};
+
 static int btbcm_read_info(struct hci_dev *hdev)
 {
 	struct sk_buff *skb;
@@ -363,6 +398,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
 	kfree_skb(skb);
=20
+	/* Read DMI and disable broken Read LE Min/Max Tx Power */
+	if (dmi_first_match(disable_broken_read_transmit_power))
+		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
+
 	return 0;
 }
=20
--=20
2.25.1


