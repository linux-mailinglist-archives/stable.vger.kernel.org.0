Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A364634E0
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 13:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbhK3M6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 07:58:31 -0500
Received: from mail-bo1ind01olkn0171.outbound.protection.outlook.com ([104.47.101.171]:51866
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229572AbhK3M6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 07:58:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJhv5ONOyiDAUpoL24B6ijulTVoeaCfFHuUPhGzQCbKTDfTx4GYt/KsTY+WT1zkrJnSypMpKpGFrf+5WfurqyoROUKk5VeIWbjZzTxXH1AvFEH6YqzZywRQE8XOhSKPmEtZj4xEex63rt2LcqVJc5QUZb09lcfO6uAftTc2mJ2tCS8g/lI8A/1hQAAnEyLVyIBSwLfiB0DVNwYMicrsbtU6ly3EfmvYgvk+LtOrbqPFvbw6tZLlSufyUdTokGXQ2RKMwCEFgV7w2786/btRtH5bKyZz+PRHSBamzVkei4fwGhFkf6xEnT+S2zo8OReoRdnUpmynj83s8Tn5GXEML0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pz0p8LLfQr6v958JajpVhHxG5s51yct4J06YNTgYADU=;
 b=OpaZOv6ww9Sd/HUtN4INVWlRc/U/+wG/yjyuCJFz5q1ANJm/mb7ZzFNCk7pef0V1LpgqQmyOhIGD/x+Yb+l0xubaGTWI9PFC7skg8nFQUBgLM7W9y/pXKS1er3lsCisS+LHoD6Bom1Pn60dq3zpdfEue2+1hXQDWpJdFscZmFACE0wOiwGtkC+9DuFCc5F1cEyNoiFHjQ4Cvun+zvOGmDDwZP5r5kwaOhmtvuuwwSS8ZviJnusshRQ5PCYP0/CHOeeVA1xk5StIGewLp/ssKs1Pl2PgYqdAc9C5XA+GQv1xgW3NCSySO1XYqwOQg6SV30QVJwhIqBZ9GDWTiKwILPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pz0p8LLfQr6v958JajpVhHxG5s51yct4J06YNTgYADU=;
 b=PoXHdO3708w8AZHKU0/N4nuREhu+7Kv86mxBpsl+Ey38BCtwEGEB+L6KqktrD1OdBbQPO6V4aTN1HpIO1YZMWnrKPi8QcQ2wdrkGHYH0Fnr0qWbLt3Zib2m6pd+Yf43XsalVha82PI04Q7kohVaiOgsN2BLblaOs+wI0fodLtXmZAq8v+8wWbKIOMQeQpVef8f16MrKZLTIHuwMEdk5IcxrN5PARa1bmyYEBEKJMPN0947c32Si/U7lyfIbeu7xdSZ7/93dahhVb/7RR83uBXvwCrGSPrLWtDsqBlLnp2eerTRDVeWCAPZu6/rPcoUYedYt/qGTBvLrs/UnPY49Hcw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4669.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 12:54:56 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 12:54:56 +0000
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
Subject: [PATCH v8 2/2] btbcm: disable read tx power for affected Macs with
 the T2 Security chip 
Thread-Topic: [PATCH v8 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip 
Thread-Index: AQHX5el5+zXbGbWre0aNpmpcG4Bq8g==
Date:   Tue, 30 Nov 2021 12:54:56 +0000
Message-ID: <74BC7DFC-6B8E-4697-83E4-FBFCFB1C96D5@live.com>
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
 <312202C7-C7BE-497D-8093-218C68176658@live.com>
 <CDAA8BE2-F2B0-4020-AEB3-5C9DD4A6E08C@live.com>
In-Reply-To: <CDAA8BE2-F2B0-4020-AEB3-5C9DD4A6E08C@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [aM4K+W+9cpx0XyBidhCISBwuaqm2LjsYm/ga01LTzVvBNu2MZE2cS+WN5HyuHKUt]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 550e3ce6-1b6e-42c9-71e0-08d9b4009c56
x-ms-traffictypediagnostic: PNZPR01MB4669:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SumpRN/Xnov0WcVsO25mGpaI9Mco0wtYOz92vIVCD2rIZ8jtEUb2fDW+dmnA0RBpCZ4mR6WkN27b6BA9vBOpKmOwWAla7lGa8O/wchCy8kkA7n6NkO5j7xkohykiyvgZVjjwAvwDC48fyd4fHHx2/kJo1TTvSTedAskQ3hj8OSdjaNjoRqgNnmdtQy3uBi7ag+5N0sxHeYfUVuzSe7rfRcryxIgT3rHCWO/nv3DSLlIkL1h1UoIt4BXhOZsHHaDa82pmWG8WNbjRLk7Od8f6ze5yPYTt4E/daOqhcE8X6BqMK+AJphDdldPaLUQenAjBlZF1rURsaL0hMVAhb2PHOH3pLTBvNRKccHE30Iq6YyLObGRl/6uPFxQQC/XWTdZb2tcD3RTLgp1Vlpnfl9nxNjAxgu1aK5Jg5SqZQs+++91FVLpP0FZkKT/JLv5pRyg0dqNGwxjMjvKNd78eUWx2XmFvYqRm01Rpy3S2IgANp+LBM1auWk5t/2EVpXFZluS3DEJ2kRwrIpoEitInMcXa0KcMM8XjmL5MK4DxpZ1QFssyYN6OpNQWsNv73C9DaDuTbJARcVGL8YT/oxMLE65BeobqRYisr8FQPfmrF8unJ62BGoja0/53elzMCK42YeUV
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: F2mohjQ79acgSv5WWlefOy/6HYnOZ3CiwQ7Ijw9BzvFz7jjmTlwOCeeL8yJ5nmOnaa7XBoz0TK+1eR+IEpA/jJIhD0E1a1nn/4uhD05D6L8uvqmjfUmASG2PSdq7hXClszj6ZyoW0DMPUzO6qxToH9v7Tc8gGedZrj4Ifkg/2DjBcoo2LjDdf0e8uO8mjl2Y3nRjf1aF1bXiac+3tdU5iqc1ITrzjBLmUYnfxfd1BfMlH8Pd1xBg+870gjku1mLD5ncrTiWzyVW650Ms8IbbOaVLEdGaASqPca2BZHIDoHDqMTOQqAGD8zYYPPRVJ7btRuqvALtRyHD6HI/0Lfy72rqxd/gT5VVVY7uZ7mPNWiy9EvPWeWjfKJtoLKoPqAy7WVH64wMuO6gZzob7Kv6UoPhRSGYu2WTHGZRUBQxflLTphiU9eP850rXcKekQxN+n9eExPryV3e6VoGHfnZzDPZ1sONojCTSQWfMVtx0lJBzJ3WAtn2XQQhvRROoO/X1rPTH1+dAFQXLGfqyyO3acsAEiRdB1UFlgN6OpE0y714z7NIMiAURWVKmAG5ShxH44ErSqdvSV/IUa08jyZ0zvhiXpR1607LIZnuuRVOB5HIwbjU6nPGw3/yfWhAyTZ8didp8EMkRQI8VoVyh97SqPe3a8V2JpW5KutczwGnltb6sQvEa8yDFfRKo2yZL1FbP9/X8rTvuAWOR+LRA7URMyUdpZ3zmPHDkIjkDd9emE+/5rZPjqSBZ0HqKX1BXeCPXy2aVgrBbZikkmz3sLgnN3Hw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DB8EAEB7A5870C4D8684DF2D5F8077E4@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 550e3ce6-1b6e-42c9-71e0-08d9b4009c56
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 12:54:56.5217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4669
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
v8 :- No change.
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

