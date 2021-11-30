Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA62463296
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 12:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhK3Lnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 06:43:35 -0500
Received: from mail-bo1ind01olkn0162.outbound.protection.outlook.com ([104.47.101.162]:35184
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234242AbhK3Lne (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 06:43:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8nBBJekrtacK+mbmoJdUSOyB+5WHfU4u5Bp+87zDe2ki9MiRgcw/Aj6tPTexjUYGd4F1Tiw1rVlgvd6yl8G6cb0xrS9MZwcPFTv9yJzq9x0sSLteCDiOBzT95VOvlc34xnH/2nu5yfLNPKLplGjGU28mVL2vLHsO2BfOneObjY/Ejv1okp+SDtgds5uCsH5svCL12vXtJyHOnZK8R1hCXWATJ+g3nqYVz6N6bwdascAwPCUFaJX5YoqbN6jCuKYgXXafTqCIysma2YtHoXmy9sCcmhndAYX+QEvBvv/Iie1YbvMbzY1p6/swtDmLtUB5jUj9/sOWIx//u9hkDvrVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vK+VwjTMEbqcZ5ld7pbmgMM7zlF0/HJ6/JL3hZRTScw=;
 b=cO7kh0DdrYy3iCLp1tYIJ+GQnwpTXzWi2JCIF06zfo2W4QO38ehD6pIQYnaxL2S4vqqudQ9t/SdKfmo35EnxX1JFewDh8SHi5dv1M63FiCrzrrmBEzNBIgoY6cQuuK4HowFRyZ2Ci3TNSof+4hjLaiojeq3GVZtPMWK1oXouDzma/SAqN7imKA1x9f7UwV5gVB+2XWVxHPFB0p1JKFTPLheglmtlp1y93YtFV3McM4y8Lf5DLvSzO0Egcfb71kN8v2Ef0U0xlvMcpZ0L6JPae71lpvNLshz1epcDlp5qfl+hTXsglwZ7DXKJgIgOqwTuCMtlqX9mWyWaFLaOAKrJhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vK+VwjTMEbqcZ5ld7pbmgMM7zlF0/HJ6/JL3hZRTScw=;
 b=hH9Pc0DlituPD2X048Rlz0hK16U5hYcKOAFWrEovR2KCieGnKZnal0X22+S6wFZEECDZH8pFtzNsE175hbDDVeVfO3SQqVQd3vlM3vRyi200CPiU4jRi59w4SEIK+O8pjmd6k3FlSErt9Id9PVm9iXVDiEd0cxU8c6mcX2YTrEUdVzlmkcDmTOVECUJlphIbWhoA7wSEXgfvkK5+AYDrdzjssMFeNiN0OPW+ckfFD9mC5JY8TWnMD01eA7dNnyxidPlHSKM+CBsLPJev7HnK88rbRTYuDQj6vhfm15FA3JgVXaMTYNUu247E2PmbVmsxtzWi0Ve+cheoWWgrPtnWXQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNXPR01MB7092.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:c7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 11:40:09 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 11:40:09 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Marcel Holtmann <marcel@holtmann.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v7 2/2] btbcm: disable read tx power for affected Macs with
 the T2 Security chip
Thread-Topic: [PATCH v7 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Thread-Index: AQHX5d8HYZ7MtLFF3keeGj/PgDdb4Q==
Date:   Tue, 30 Nov 2021 11:40:09 +0000
Message-ID: <83D9E5B4-980D-4F1C-B1B8-78E9E7E1095A@live.com>
References: <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com>
 <YZSuWHB6YCtGclLs@kroah.com> <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com> <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
 <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org>
 <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
 <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
 <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
 <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
 <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
 <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
In-Reply-To: <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [u9E76kECZrl/eFG+kx5dS4MqQuCwopRGIbrm1EXrkvE9RpaYzVTiDyDVnLhTu+j8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd8d96d7-b10e-405a-0d12-08d9b3f629cd
x-ms-traffictypediagnostic: PNXPR01MB7092:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a2znqPu6RYpFQqXom/7JOEt5mTRa75aoKYYfzRjAFQK6YKEEUiCoOE7rUiuKlFWOBBFDzZ7jWwGh+WtQxMT8WVBqwJARveAfmIQ1Nlqn4C8eFBnk9Gi01DLMX9iXUixAuln1gFu0pWcVOQWo2MxeYGwaP6dx0oYnWa7THUG8ZU9Oo9SLsRFyt/0FAeAOzcJqKogkeliQvf0oRfX6qk9PTAIlm0K7dBpnqrP/c3xP57OrHxyHFd+sM9GNqTxx1HxJ4L38iAa05ey8lmPXQqm5MikQ63TGb2Pp5+1wdidDgmILqEQMoloaWUeOxXFe3kk8714zrzE5kJ2D+R3lQOdWdYnWmYjI6hboEvubjtL6FFcmd7L3SW78ld3roEe7ILVJiyVttK9ix3UhQR31hiZia4/893mN+H5bd/UmdZYRuNNZ4Us+R4CZRL92xvz8+opKMf/B95Hyy3b1VkjReGYg6UCQy1z38kj7lM4+9L3YuyfZ93V6j37/HHRhp3QTfpUlna3KJ0xZswHzqPG7ayZtGb4UTEy3kUpoX9MgWJK/8XbkiueHk0npNP1ajQ2kFQNHiTJBrvEHu5gn9Df/X8hy3WK1Kge2iNCLnJq05m9xglBNXAJxlIKsMZOY4NLDIH/2
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 3PjU5xwS8BaN+qhigKe7SVQwjmq1UVyVcCHp/N2ML79eu11Gl8xyKgaxKXq1Z85q/m+4NPkxNRwNb1tOpvvvZhWXHMdcu47oY+uddD1FT+cRrtMJNPQwFpV7+7zub8GNAPc7KOt9rtM6vlp3iPHGEEpkL+c6HfUB/WhclURlXktsCzFA42zSaMF4s3Ak1MbAOWsVRDVGsHDQhH6mnzu3gNTUz6EgNO3omGjSXp5Sg0lJ6KKXWjQclTssVSpKNOgvWCnqdYN1oBDxbykFMA+YCkybDrKZoRNlaXmrRraVeAhKYP6LX54eBhVwijJhZsPLfMcJqU6nuXO/HVhgjyGQmKmVXxPfRmLalGT5QrSS13F2fEU67t6RGJByvDynwD0oZVoliyOqKKW27HnjQ88mzlO/0bvzvOJY6wPPG4yCNwPp5aR2KO9wc+/KiBNitopvIZcuwX2v2nEjmPqG+DzhtPJdNbV2//JkdedY7UeNax1GUso0zkd6FlkYjAkn66zpfofOyGrM0vev130RZ17+5iDbh2qLYdjf7T4dj6FjFz//+SgrneII8DKUkAeo+1pM8ykKxIGrYnEX/zmQ6IPPl3oNXTWYZeC794GBddaLbCLvEgMEofm+Nylrp9y94hPERMcX6F9YzRSuFR7f1rt9zH8uiR3q/p/9BgEd7jQQ0SlN0Wb2Da9nmSDgOml6VJHXOSlym8hhu8L65tSgXpVlT1ka0Fi3YTSXz8aoswgOVO4LMSkEcRo3JAkfMsxVRWDU+od9NJKsILR8DXV/od3exA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <364D2BC9EC01CB4DAC1D449431619DEE@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: bd8d96d7-b10e-405a-0d12-08d9b3f629cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 11:40:09.0841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNXPR01MB7092
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
v7 :- Removed unused variable and added Tested-by.
 drivers/bluetooth/btbcm.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index e4182acee488c5..07fabaa5aa2979 100644
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

