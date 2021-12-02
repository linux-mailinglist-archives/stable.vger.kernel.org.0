Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C81246614D
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 11:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356826AbhLBKTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 05:19:48 -0500
Received: from mail-bo1ind01olkn0154.outbound.protection.outlook.com ([104.47.101.154]:6277
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241111AbhLBKTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Dec 2021 05:19:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iT7cotlheToow4bKM71KAbqPZ7rWCa8adadWHYG1V0ZGs/3q91tLLZlhf0CseJOUtFh8VRMcu+Gc4oZxx4ta5h10YxkkduraF5uE1wqXS23bkV7ZuLRYbQA4qvjLFv3c9V3dEfF3iVLwkKWC8n05qAAAMTPYIJQ56IPmtz2YKTf8ks2Ab1nN2xxARP/bdYXweaKEy5EAe47yk/Jva7wfzCjkC7S81+4Fe+3UXSMQb37Rqc0CZrgtlt5QbQHGtwus5kiCMHAXMr7opqebOrPy+rVt9yb/bTJrjwaV9xSHoWTVIUMdeDKLxFnhn/jOoYUjvhuIcZcO7OdxecRHnF+qAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WPBse4vbSTSZodgL0E3baNv70mXnK7Qm9BcUOJ6cFB0=;
 b=LXs/93EL/pWpFtVh/0KORJmQCmaiHXhtUdUxmbPIQFQ0lwF4OalXUFVQHiN4dB8cA5/ye4netYbawERKg9sK6i7rF03QScEb31w2vIV+kPcsoHnqUodyEqvCYTB6akOK4cEaMr69+V0w7n64lLln0KPYRVKAeckeCxogKA4zFK2j6B/vAOYBWXGzJoOsSNtWARDwqooOqgh/xgDnCS1bRfdKRPqri3W3ikQ4ugqfdAp2ptlAvqXX6Un2ISs6uU7FPPG7icrY9vO08Tl6dOouyS2pJOkhh5xzJtB/5FjZHzYcLwPyc6BF3gEsF4EDflCrKkb57gHMTPQNLEdOkfeZug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPBse4vbSTSZodgL0E3baNv70mXnK7Qm9BcUOJ6cFB0=;
 b=aZaaitnquFS09p63K1NpoZV6pXjUeGJYrVFZZ8TTKkIBU9K1KjKY23472OSPEgOGZy4R3ktlsnNMQaB5BtY4n57KnevRSxZM+kU8Y2QeV2Pf2Jkl/4StUMgyHv3mPyYYN+hcehZtRTrjrz9wyC8qhOJ++FWS2a0lGIazmILbYLBqQkij+2+2YZksOgJ5SxvRKyraSdaj0xm2+iolPpvIdnd4rtOYfxvzDy+ZDHmDBCyLXJSOyaFrIHG2GsTutCBHBrT9NfEuE5J+KKTVf9nnBxY/HxLcS14niZqzeB8SG1HI/PQUMjK7yro+zsmUwZEiikNM9AdzqHJfudtM4ls0Lg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4649.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 10:16:19 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 10:16:19 +0000
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
Subject: [PATCH v9 2/2] btbcm: disable read tx power for affected Macs with
 the T2 Security chip
Thread-Topic: [PATCH v9 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Thread-Index: AQHX52WmfMB59oaYaUK5Y3YtP+CNZQ==
Date:   Thu, 2 Dec 2021 10:16:19 +0000
Message-ID: <367A0877-455C-44CF-BA4B-AC07CD17F333@live.com>
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
 <3F7CFEF0-10D6-4046-A3AE-33ECF81A2EB3@live.com>
In-Reply-To: <3F7CFEF0-10D6-4046-A3AE-33ECF81A2EB3@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [EjmazMkJ4QH1Sg4p9yQBoUQ87nh4ZxYdCgAuHXrqvxrWg4EW2cA9Y3/nN/WWQJ8h]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 773fffb0-ddba-41e5-44dd-08d9b57cc8ad
x-ms-traffictypediagnostic: PN2PR01MB4649:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HdkW3+4Qh00sZbO3Q/xwYggtW9BKxv6CuAmOCast6s0JLZbsc+QCL7jFyq3h1x+lwo9qA0Ps8G92/MEtF92+FUGyyt15ReSlbm6pxKkeGUPPX6TP/+G3UNmwG9VPD9J2Dvhcko/tFYMi62CWqdS0utYVNCF+skeUV1FeqPMMnFWxtL0GFWRkWsLMSrHSH38jEa2xK1mjvE68ZG1fmIARw9T6vmZuCL376Hq7TK+Q8J26qzB/sZ5d9QoQzgzCYFLgEQSPZ9lc6GB8MyCXWNx/IZszktnzWuByQ/HVs7LlCpBCLIy1jvz+eJLGhoIUte7BfOVRe4LMiiRUw+YjQeV7w+92PxtVVFYfLLo3QJX8G4VhMstHX9O3bx30oO65hu0gxyAvOwbje4CdTucePRNv+NSwQgsRG7zqQdOiGyQv711mZ1ez8Da+swiVYOCHge5XAduDKsPjz/q8Oa2vQsD2GuKPF3EOT5/hn0iG3CPcEcOiSwQaKEvTvV7baLXuWLW2SCtRiKxbUtMrS/KmwYy7K7M2vUM++b5TgJxjHkf0UtF6XoPUn+DCAa7ALMAKkla5iBTZAMDvOR+V3MwvIDuGJtPebtpAHF20ezKcBEc6ChQ/Bn04qLXwc3ayW8u+UacE
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0+n9e/2oT6tTLNQQIq5dSpB5cgRZ0ZQLV4m27JOdFt3lVLXqMmjEFu/DnVTc?=
 =?us-ascii?Q?qnPbtI339if+UaYaPQCMXXhO7y/cr5U1uTeB0lPA+7nSOk2vW5nESMuSLWe8?=
 =?us-ascii?Q?+dKSb1Hju8uJS4KQQX2HtuL7QEhn+btqMo7wDKdDIyyt4bMmYiLhyqQLKDWT?=
 =?us-ascii?Q?2BSE4F4puJ5UQzk0EnO/jvAwmxsSFOedJuBbnd/a7iDSqbeu3uf/R24c8L0i?=
 =?us-ascii?Q?jKyqIPVXSjLoRnGKT/h5WwOse8+sjg/7G0iGTxqzvIKxJp19ljbe2Q/G7j1v?=
 =?us-ascii?Q?3IgM0aDYTXLMAw7FGlBX6+bg8KejgjVWAZAXoHdCjgWLJy2fk/XdzRzmWUQv?=
 =?us-ascii?Q?zezyq6qE1J9TbPSUpHqwL914CzQKVVxTrm1OVLeW/HxB6dXpfRjQU+iXYJ89?=
 =?us-ascii?Q?gQASrU9ZZta9OH64Nc+m1D4bpjgCmIaoU2wo+CtFHx1EFMhmNMtUhXo7FxSX?=
 =?us-ascii?Q?3GZzeFdO6Wd2UQuIJbIQDNd9RLgibHJq7otcAXsLoTmN+XmghFbWC43s0Tic?=
 =?us-ascii?Q?HUbyySqINaoAc/oVjdqbZ9EIWtMq4V/P8Ra2kcMumuaesfIV66+UVV2zahAG?=
 =?us-ascii?Q?FD9cpOZHVKbpNj46w0Z/BEHIGljELniI7YJ5g3ETUj4uMMPmHUHes9+KM39v?=
 =?us-ascii?Q?W4OTP/Lswcmaj7UdTflC7S9iUs++dhRZN7Gj4jO+LJZApdYo3sRab4942Jn5?=
 =?us-ascii?Q?oQSpHqhZpwujFQFFF3EGD2VB6Xt+3nneL5XUvRN7rDjYM8n8qcvFgpxLA0qS?=
 =?us-ascii?Q?bU+1hBxSbPmj91FLaAO6RVrnfTmnj2sz/gesE1Tbjg11rLgXs0iLIYzmfSWO?=
 =?us-ascii?Q?03PhBjZaIxSs23nDvmxFwRWCN0tlfOXb1TtAETx/o4ApDoEm0I+6eHI21Jy6?=
 =?us-ascii?Q?5OKinmOgHfZ3H3cth5YKgVjeiPi3//GZ7Kt5glpBnXzWn5x+cdySykFWwJ0X?=
 =?us-ascii?Q?H4bgjnDiNgDXBijf9vdLUZiUWm3N2OrJG+7gkR0Xp8vVhU8RC6nxi6X9iimQ?=
 =?us-ascii?Q?Xb6SHbCpjhU/H7C1Tw7vMbg9AA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C2F205B6AF46F64783237559274872B0@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 773fffb0-ddba-41e5-44dd-08d9b57cc8ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 10:16:19.6349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB4649
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
Cc: stable@vger.kernel.org
---
v7 :- Removed unused variable and added Tested-by.
v8 :- No change.
v9 :- Add Cc: stable@vger.kernel.org
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

