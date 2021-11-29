Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB08460F8C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbhK2Htt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:49:49 -0500
Received: from mail-ma1ind01olkn0165.outbound.protection.outlook.com ([104.47.100.165]:6119
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240392AbhK2Hrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:47:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxcud/2/9L5BiiOm5Sbfccuh4USgR7Q8TFgepUuzYXhiR1naUjcI63WLlf1bCgCrePgGfblyknSIyJ32gsgnKgwLRTYAX3ZodZl8FQqpnP37X8UePJCFsFm4Eig3UTqq+2+xy/KPC4d87K+dnTGFUkhreSrOZ5h609yeRaS0DFp4Zqg+llm8dax1l+1CHQDb4QKwz1grx3FffeSBDuLYWRxbetcfmb6iMH33JF8crakpzDtE2rPnjyJudPT/v2YOaZphBNvaWqu3GBGL8AOmfd304RPnYrHcW0TxLGKrgmXCEgtwys46h7aj6EAOxl3OtTZSxWM0WGx7yZ9NNPztXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxZC/nJsNKS/bzRhaUJAnJVf5ypYfM0K9cnI4ezD9cM=;
 b=h15a7OcdY795ao1MDvuTHMPdQ1z59go1n7CaTCffWHJblYXjja9cKJ4Srn/aL+buZwoW/iRf4auIpn9o250xS3svmwuiFkTb8kzP3QLsA15e+2P5PH9xsDmDwqMyqeYsGHsPjgA6TLl0GRsAvkABh1RbITeU24hV4unxif6/Zayql0+tdqoVPoZkJncqQb8+2UB9JkYV/Tt/xZO2Ps4SH9/a7yYfP29327/85XyIycxQpG18cZ2Uvd/7maeznobnCJBb42TSVo9zAc1s7lNfvlK5HlcgIEOtNCZsi8wQgiuSS/6bGdm8lgeTyMG3UQWysyCVg/VuyWCcUfqSsiNaDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxZC/nJsNKS/bzRhaUJAnJVf5ypYfM0K9cnI4ezD9cM=;
 b=hjNK6ZBLOq3ChRbzAzHpa0En8GCvpX5Wcyn6EvWp2Y7Kt2+WZvcSMBS/WO+cbKxAF73CPx8i5v4xQY4Q6qJFUFhz5Y/1bsPrCnAIsu5PKRXiHxkaJ+iN1A9+CkXcdtQrorveKnDOit10QTw0TygGLJ3yoDyda0LhegpiyF1FyfzY5JnR/84JfBEyb1QJtBHJkzgO2SzWyOQbd0lTv2V3VKSy3QCqRmjbzQcmMT5o5u1mvYl87BWclJq4AxbUdJv2drJPo6DtK85+zgTrSe5Rg9ISYckk2XWnB3zwMgTERZfj8xVxSlzkMvu8a9Iy+X+6srauTaYGP95YAOFGABqnzQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1821.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:12::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 07:44:21 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:44:21 +0000
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
Subject: [PATCH v2 2/6] btbcm: disable read tx power for MacBook Pro 16,1 (16
 inch, 2019)
Thread-Topic: [PATCH v2 2/6] btbcm: disable read tx power for MacBook Pro 16,1
 (16 inch, 2019)
Thread-Index: AQHX5PTr/Pd+XRBzLUamLbooOejRdg==
Date:   Mon, 29 Nov 2021 07:44:21 +0000
Message-ID: <6AA7A457-3978-4426-A975-0CFEDFE66CFC@live.com>
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
In-Reply-To: <5B9FF471-42DD-44DA-A9CE-0A83BA7A4212@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [ArM5Rfz2zH/E32Mf3OQQdWUQ7GLS7AxXTcRWae/4oBCglnDnS3VrDsGt5eY+vd4p]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c739b2d-f54a-402f-9b76-08d9b30c0e56
x-ms-traffictypediagnostic: PN1PR0101MB1821:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v/WngLnhoXmRe5on1+My/M5vPi3ensT0EcTkGB/9dRNf3wdAWzYKA+BEXugBQR4N2jFVormB+7jwSrTR4PkjP8htLIEnQNSKZey+z+12oCSsAgevaBV/xw7+7L9oIS/OHUZADzv6u8I/mbPRa0UMAAwb5EoFlcNSnbV1Tyb4QHmN/F81DcllAK/OfTSCDhpEfsGvdKidjnjXfIVjVpzsz0vX1z0OFqgyZgE9AWw4k1O6In2xKSUj7vMPrjZJ0IpoTe6ZAwkYDDOctLwmJ6S6LAndDOYw9CYo/97lWpKKZJn3lWJzBNMeB2/HRJfYYaO3YgXzfzNFm9k5G0xsGmPdW0ZMfoPg7ygD+1Cz0TilknS2vmRbbm2nCKfndnKRj2GDLYdBLfZe8/DIEsR2fP4Q8E+pTZsrcTvjvQ/MgMx8kn76NQ5DUiAHJWXsr0O88Nf4+QFHu0nSWSTtjudvg2/kRRzmJge/bIcl+wkYEDj0QbcG5paJxON1xMGi/tDd9piAeuZxtl/mwcxmnHvQ7qQVt4xu0vRtNMWnq9t68frEHFGXHNpfPO77OSnebE3xIntJTyH5ppzJ+iDUtUxkconHzw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: tyTAJZLMLn+o66I6jqE6B/ikNmyrNOfgPhiywBE3wuT1nc5SufUluNz1A2WgBuppnqyZWD4ncCDKrlw8OrRjm/2Z05KyoaQxUu5MfBH/VhcvIqdvZLh3bgakS8ieRH54EkjxI0jNWCJDjkWJt4HimlMgIu0IOgxHVT/V6MJMuLOiSWjpv8IqAhWEnbjovgthfKJIW7BGSfmy6Dzz36JmaAhNB4c+HOsPAh8k/FPATq1jamohx/POOcG6Maj0GLYjWpAXpCZeXr9s4DrXT7nY8x66oQj0E+dWMdyjwvZnLDQXXM5yR3kgdXyTOAdvYBh1xZDBYXh3rYbzqR7fCxWGfHg1DRNDb9FQc2OhTFi/GDOdBR3gDS7yoHyL+veItxstiUGnTM5zikayxE8NgU+vM5xruRZI+6MqXGyGojNTDvfXJybbH8ABdMvF2h68I9Y2LuqNSHvhjOBYtyIfPSK4LVbz2UK70jsNtFUHTAehp6EqvRvLoBwANZWZU5C+c7c+2RCucFX52vuM1+uTrVVJnqOL9+gBPyZg3Bt+BLplrWGKsdkMp1bpC6UbFcoPYzhd7dYbamISNAWlg9SMHAhL9yGW6mLrx6rhs+sgRQ/xT3SMUHxUj7VzeSmvbiVrSdyar3kD5EudXqAG4aKFRQYE+7IZH3DXaUfEJCeJmubGGv/hRH/SAWvPCTL74MG08HgfqtDzK1fLvhwdHN57efqvoe0wazagcEzhjqAORlX2gAYsM6rUMW363OzMpSK+o52obqDYisLT7DLvl9Medkiz/Q==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F21B303A49BF9841BB43AB4C8A637EC6@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c739b2d-f54a-402f-9b76-08d9b30c0e56
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:44:21.0126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1821
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Bluetooth on Apple MacBook Pro 16,1 is unable to start due to LE Min/Max Tx=
 Power being queried on=20
startup. Add a DMI based quirk so that it is disabled.

v2: Wrap the changeling at 72 columns and remove tested by.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 drivers/bluetooth/btbcm.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index e4182acee488c5..c1b0ca63880a68 100644
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
@@ -343,9 +344,23 @@ static struct sk_buff *btbcm_read_usb_product(struct h=
ci_dev *hdev)
 	return skb;
 }
=20
+static const struct dmi_system_id disable_broken_read_transmit_power[] =3D=
 {
+	{
+		/* Match for Apple MacBook Pro 16,1 which needs
+		 * Read LE Min/Max Tx Power to be disabled.
+		 */
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
+		},
+	},
+	{ }
+};
+
 static int btbcm_read_info(struct hci_dev *hdev)
 {
 	struct sk_buff *skb;
+	const struct dmi_system_id *dmi_id;
=20
 	/* Read Verbose Config Version Info */
 	skb =3D btbcm_read_verbose_config(hdev);
@@ -362,6 +377,11 @@ static int btbcm_read_info(struct hci_dev *hdev)
=20
 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
 	kfree_skb(skb);
+
+	/* Read DMI and disable broken Read LE Min/Max Tx Power */
+	dmi_id =3D dmi_first_match(disable_broken_read_transmit_power);
+	if (dmi_id)
+		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
=20
 	return 0;
 }

