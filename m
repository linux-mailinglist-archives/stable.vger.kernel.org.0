Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E337463350
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 12:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhK3Lwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 06:52:38 -0500
Received: from mail-bo1ind01olkn0148.outbound.protection.outlook.com ([104.47.101.148]:29968
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230124AbhK3Lw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 06:52:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayhtDeuhXP8t8hQQDct5y5HlA5WDLQxkG8C0+55hp0ZLiyCFzGLNXLMQlWrMeLtAj40qB+AQlJQHs06Mz0in+MsFLWEwtM8/gm9lNAHfohaUey7v67ZoFGP4e4PjDSZLKp7cBtG/yFLIAH0L+z2rRt0XdoqMU3NsXFXjXH+iVe65yoZG7fUvhMSAzbPcUKSwPz5pZi8ES3UhPpatROFPjsBNfjCv2uteyppjTBvYk66sJcnolozo4zsKNAboYZl273PirpgB/MDT/m5fnkUcRS4t8YrQkiPSoK4Rcl2o6LAth5DaXP6RGdTOgVFwQ5uoT5eyVFTUvyILvF/V2HIREA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vK+VwjTMEbqcZ5ld7pbmgMM7zlF0/HJ6/JL3hZRTScw=;
 b=i3zJLbHsWuRiEPoo+RPxN1evQ0iRW3+nJUbOo2lDhbgU3Ef66W1Ryq9ik9Ujnu8+Oxh4zpjoPXfjs+pD+XZ7jpiwJnwFnPYEEj+TOKcReblJAmsE+RC4BAy7BRqf6twIQL3ZLvIQatHtw4QYFju5ypDRoNmLnm1t0UqJSrmRvSWDpOcim1pCxTAYOPZKrVaYKstBecSpC3kzuO3eqDZq9tdAab1i/+edt/E+zvRp7OzeHK7dW0EafmloDnyukusqqT74GIJyZSFY5BIcPRzZmWtgu3hGG6AU7FovsVPHf+8De6g4hLd3AS1h7uoYC1u08iIcwkTM9M88fe+W01wGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vK+VwjTMEbqcZ5ld7pbmgMM7zlF0/HJ6/JL3hZRTScw=;
 b=kYSZOYuZshVCIqlcjHwETxw+2k8OvGDdb1TSpSA5fcseVw+cVeOn2m8X/IqfBZhH6Kwm6aD8mX0AdWOIeBZ/mkK6GO/AnAJo4p5CnuSK41kxPeG8qvX47IKErhN00CHBF9u6KwO8LDEfrYBKD2R7CqCpK71CtFr4xqHpkGnkqRYwj9++VnCa4nhEeGrvSCpjP/0FoH259V/5Xk/xpZDM9CZ1zLrKV/Klxyg/7Q+iWuHmzwl+m9VOPV+ctnA5qRAnyI2gJlh6zRbwlsO+B9YbUSjR0HwyFg618F2rbnFm12uGwotZCKt7wW1/m7eNzycSfyHGG/4EMeFt9tGPZPKaRg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4286.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 11:49:03 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 11:49:03 +0000
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
Subject: [PATCH v7 resend 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip 
Thread-Topic: [PATCH v7 resend 2/2] btbcm: disable read tx power for affected
 Macs with the T2 Security chip 
Thread-Index: AQHX5eBFWXqedS4gQUeMpgpniEB5PQ==
Date:   Tue, 30 Nov 2021 11:49:03 +0000
Message-ID: <DC48FC07-CA46-4043-BD27-6D9C756ED002@live.com>
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
In-Reply-To: <312202C7-C7BE-497D-8093-218C68176658@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [j86/WDsept2Fjzrbs/QlqFiaJk6aJ/MmUgmiQfD153aCedMMBOMR0YoE3mtA9eWq]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a4fe45a-69cc-4e0d-fe2f-08d9b3f7680d
x-ms-traffictypediagnostic: PNZPR01MB4286:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X2RIP1JDFMJSd8oTH6U2bDdoHIawrMdOIbq0TYMtTdW1bGSW5uiWm0KW+w+oihZmWJcxIDqw4yBt7fKKK/TgRohZE+o3Zkvz9shEmH3Sy12VdX+vgbZ+U6V6W1/TgU9fSqnCZiZY/AZE8hsEztyMxTeRqNVkUOPoBY+XY9HTsCF6sGrrFjYnp99HrcLSSMBMnz6LohhKbJtuDGSF4XFOdeKp0HO+RzZm7wuDylCkgY63rmt8uxeDxR+aIq3YUbEYQqLMnTK9leNn4euC6JZP6faA1TS9Sn76GgYD76jYd+CVnc3RB4q7CMyYBNfWt1+9oVq2DBSb1LFzlycH51418uVTXrIDZQfBC/WeflUbLchzVJZM5g1dJQ778cf6vi0eklx5JAIBLt4y6Y3LdHT+rCVeQFhiV0BuZzKCiFt59gnxJOggcTFYqmk0AyZQLapZTOD9X5kmf08f6Eai0LFDV0rGXIGsJLrIicXGgS2K0sIoHCu8pe132CA4c8ip8vq6PQivM22Yd6QGCbl4TMi/16RQmP/zMX8tlHTSeD3b3HNzZpcbKsGe9xpcAaeisB7w1wO3HK80QY/DiBF2A0ohW6aLxqHfBgITDjK/NU3uFuh/weVrZRqNA7X1SfP7PngN
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: wgPD12hsKgPgItO36wleH4OgbMnD+19EUMPChQiGdqe/X33RQ4nmURa7z0NTROy92HE4o60bAiN8+LzsHbnbKT3EfF/0aCdyiTR78Z6dRjg9gsKX6D62CdWrqYHiSjSIYa9B1BCk2+68zN2OnSLqZW6mckHA/4K0DapiQJjKaPTlJ2R6hrRMwtl9xDUH5fNxWbmg09PgNf1DwXP5I7F7GtrRKQHXSDq0FLilQeFliFbPONsc2GoS5n7YLiFtFU81hOQLZY6TJ608o6p6sC0AMnWegleMU1sOxpWtF117lI+flXwkzacginfH7MCraDCkMQFtdNhwkOyOLKb+YpC9pNo20dM5OME4iwPt7WQbknmDApCe2zFmmGqeUJgivxWOzgjHOrWoky3fk7cw9291/28CRGXhjy8ba3mu3OvZoEjDWQ+UYxrhF2T1h8HqQA9a5sziWCeKBH0Yhb6bk2AxfOZiTf1sfzTO+o8rNbx1QugjU02VSns9u0b8r8XyDhHkXPdvZrxPsDXHmLOl3zu3Z4OsD0YVx5FJfGnt9+aWX5afFgVTtyUjAdhepDwbMCPgjBmMRTLqPTHOixNm8Ngk3L9xfbMxhrmSsC+53LkG820oZH2q3Lyx4VyNvVYUof1W0EqiV61hXvlqF0uqS+YHORcAvbhK9wgvfk5piuXfEUGc3Nghk6rP/QQfulFDAEzqGCvrZWu0A2HzDdUSph2s45NQQZZHQt9QJodFzEBeSva54mE4i1lb+Ev0ZnCE0+HVOx9cGKnDY8SOMGQzGvz6PQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DF5225C2CED25844BB3E828280624508@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a4fe45a-69cc-4e0d-fe2f-08d9b3f7680d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 11:49:03.2243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4286
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

