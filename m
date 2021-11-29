Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFD34610D1
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 10:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243032AbhK2JLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 04:11:01 -0500
Received: from mail-ma1ind01olkn0146.outbound.protection.outlook.com ([104.47.100.146]:6371
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241070AbhK2JJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 04:09:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmvlkHYDIDPVD2a/PO9UkZaAPmfW/tG7R2Q0Kc17EbLO8QhpAqiT91m7cUEquDZp0u56wF2zCggV1FWwlNzR5+ZC4wnHwTicupV0pie5UzhpJwuMhJEoJf6c7lXAq7Ql4nipFzF9wHDSia5pw3da2JHwaYI5vOgTWk6IPyunHhJFw0l0/vkA6uGhxxfqEC02e2PZCQjuiMoPXVD7na4O7bxEnKL8SKQVwM7+KHLzBjrnhsZ4SUU1/FlcC7ccAZE3XUg2R8DZzY2gjuexO4rhsaO2Phi/ACKl1q0tPmxzGr3ToLnzTonEV1JERsrVdz2F/y4IktP+vrfWCzKXKwLeAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yXrJyNtiDcy/cJvDLC2DrBzU6GcLXoroBbdHjk4gHgU=;
 b=ONJEkEIciZgD07SkQpCpxTc609zIoMJAYkDed0kwmp3PJEXt94T6pKSjxxjwNAdJWbiiJPmWn/qwotn8ZuUWl8HQk+8+1C6OhWlB4WI+3oREO97h1NXDiCTczo3KJaJSuNh5zp9+AAtVw6y1qTpBG0Xk/z98ArLFwa7m3lQ9sKM8ANyYtJCYCCrSJk4+tyVW3pyRLbXHHcCwSVNM2/oEHJqgiUyvGVks0Y5M/ZG4F+bmskYJAQd0467kVxpOPkyLK7LSAMO8+TIg/HSVYfEuNPhmAQHDyA1CdAd2/SX2hX5x45thXt2R/jHRPrdpRsfQy0FasniHW9B1+gs050NgVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXrJyNtiDcy/cJvDLC2DrBzU6GcLXoroBbdHjk4gHgU=;
 b=gQBBMBar7G9lTuWSNlBIobO8zPl+s161cWphAWb29JrYlF6bofrNn6Ob/FacpreFJg75HoXYf8L62Co2F7IiPelUV6t1ab552ON+CJ98N0JR6f30k31w5PcnHZ9oX7RQPalBtbCWLQIx/J78E56b3uGizD8dwASrKFF59RR/zC9MAF6WOjaPby83prSAT3lPasxTIvqWr9QOPkBZTCpDRgC1OgfigIP355hjszprAU+A4rBxyJSKxHxROH0mHX8SFBZVnA5hsQdt5kSMLbbHcBGNMgXCfrbLFj7A1hTJKN0v7KA/d6Y0rRLrlotqcndnJXYUSIN6pjqlN82E++mOUQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN3PR01MB7822.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:9c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 09:05:03 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 09:05:03 +0000
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
Subject: [PATCH v4 2/2] btbcm: disable read tx power for affected Macs with
 the T2 Security chip
Thread-Topic: [PATCH v4 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Thread-Index: AQHX5QAxoEYALVxXVEOSEdj7Vglnwg==
Date:   Mon, 29 Nov 2021 09:05:02 +0000
Message-ID: <3EA0850B-7D40-4B21-85A5-B42C4CE8A942@live.com>
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
 <A003A45E-EE35-43EC-879F-3395CCB5EF59@live.com>
 <6326984F-8428-4A3D-9734-1A408B9E82BB@live.com>
In-Reply-To: <6326984F-8428-4A3D-9734-1A408B9E82BB@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [IrC6vBjd1lUrYiE+VR/J/RB5z8zWWF4cHKlgUzz0n5VrhF4gKK4LJm/BSo+ajXv+]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0694153-d0a6-4ed7-e68f-08d9b3175463
x-ms-traffictypediagnostic: PN3PR01MB7822:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TiV6sXXMrhBhglwy76I9T7oc8TA99eJBqyKfuSYb7YkvKeI0JfXtkM8TfjauRAnga5A0RaiApNJfiwQR9IOeLjeJuemfTEbuB7cCQm4+h11Tm4LdU8QSJREb0ZSGd657352MwmLyZoDH/n4NxAhm7compIzIYI6HG5tCYldUmGetfKA9jTv6OHDwCjP1FP5n1xx+b3bvHbTVFuKyFQROon+snxLsQ0eAoVHCke3jpTq0Z+SyT/wY+o2xkYF9UnY3/hJ+j3hp5t7UTH8gyirNvbawts9cS59Eu1AyNAq4OD9d6wWfhMr6igZ7cMEJy0lQ7BT2Vk6BO5VqEjT5iEyasED48x6pO45rcSEUGyGOhnPDksVyiQTuH5LtonV8wl/FsUlWxkeBN6fpapuJquZ3GS7CDs2J7cXoIkIs0IktSTNp8RFvC29x0AACiyBFW0vpelP9IzZuAXpHgou4XEyRls5Aqr35JzKgeGuIbkzhYmOpMOKxQBkWTasqYOcX67gkvSJf/La+HCMX/h9PGJpr6yT8gJ9oI6so/jwvntYdHtXXZMrMGZKWnzAgpbXrHPLqs19NYwkBswZ7jAwzHDqRgfg0MfuoFuM+ABsWu7X0yOYsrTN/UKebl29ngyyjfjc1
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: FQHlw/zVztPi/qSlQvvXHrqRIMW6emeSbl1l9rFtJGFswysqsx/icr/v22M5QqQZ+uhyRmV/HZjQb1fLvx3EoqREMGRzYEEdbwYkN3pgJXZJY/FvArzzuJJWZCytc68Z8aCWnltWYM2+pQyrMAk2JBo1Wb74eCa+Dp48WR4rJiS4X7Jqr0bDDbKZ+dOlkMxYq90/iE84BsQWef+2zLsdjmi8ySEPeRaamV8d0ovR8xGDCJo3uR8WqzTPELttvHPDpDsZFgjiwXFo8SFfe5RQzLJ74p9GiK/bsbw21wgbZReqIzAYQ/V3WJMtXHgP61LpeDk9xo6+5G67+VyvWs5UqC68PpxspoHMNf2ocyKdGCo1dU4EM+vtBe+ZmWGZ5r8vTmVjEg/pLGzncuaodapDezP+3mMztOCr6b0Gu20ggN29cBu2PWoeHxCVXd7LTAj+IoGFZGCTrk6AlMDna9Xld6a1q+x0qhPd7sW+wIxGprUh7cubV1pkDetzt1xEZ6CeaAWFE3IecFmSHc61BG1NnEvDd+lKx26qOTFw3K6Ep5jFdwUFg45GpPACz9wSrcOlTUkouzeVmWPzewh32L6sLia7XQyEM4U9Vjd+cAKIUAEc00h7R4fDa3MSpfVN7PD4YB9WqFWZCHGmvuleuNSN53s7KJyy1NgH6r1SUCaxZkCCctFPVkf87k2Q1oADQSfh88HDxvmv828oKfzYDRo4ilW/pplJ2a7PyOxVsaFDLH5offAT35hFrVOnPbmgVC6MW+tp9FgA/yzptmclzYr1yA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19AAC14BF22538458AC73444F1429249@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c0694153-d0a6-4ed7-e68f-08d9b3175463
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 09:05:02.9993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB7822
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Some Macs with the T2 security chip had Bluetooth not working.
To fix it we add DMI based quirks to disable querying of LE Tx power.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.c=
om
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
---
drivers/bluetooth/btbcm.c | 40 +++++++++++++++++++++++++++++++++++++++
1 file changed, 40 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index e4182acee488c5..40f7c9c5cf0a5a 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -8,6 +8,7 @@

#include <linux/module.h>
#include <linux/firmware.h>
+#include <linux/dmi.h>
#include <asm/unaligned.h>

#include <net/bluetooth/bluetooth.h>
@@ -343,9 +344,44 @@ static struct sk_buff *btbcm_read_usb_product(struct h=
ci_dev *hdev)
	return skb;
}

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
+	const struct dmi_system_id *dmi_id;

	/* Read Verbose Config Version Info */
	skb =3D btbcm_read_verbose_config(hdev);
@@ -363,6 +399,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
	kfree_skb(skb);

+	/* Read DMI and disable broken Read LE Min/Max Tx Power */
+	if (dmi_first_match(disable_broken_read_transmit_power))
+		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
+
	return 0;
}=
