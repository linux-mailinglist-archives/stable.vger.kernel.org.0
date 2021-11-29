Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D5846108E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 09:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhK2Izs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 03:55:48 -0500
Received: from mail-ma1ind01olkn0149.outbound.protection.outlook.com ([104.47.100.149]:48928
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241394AbhK2Ixp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 03:53:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ed8gBh9e4HOamyLxIRe0nbmCHbdYcjvBP0PxDnoP2rCVA6g43+/HU6lOAMFZhjkjCIH5S/YYuq2QJLE4gJ6v/WnuAMtuyrpuLvvoj9XfLBDgMhR2x8TSi6GJbPpILQLmWDLv21uH74EGu4MfNs2Do4Sp5uKKat0b1/FjprJVh/e/y5b6LsXRC0hH2S5XBN2pXk5t/dzLJYSkKVgH0yEILG911/8nbRwMjjMjCp3kaXpBNcr8uQxIUax8+/55lMUc9lfsl8xihPAmnHCPsqtqU1xAdvGH0iq0Z3qzjUkY4jcnxSZFwPrUd7j4CkFe3yAO3d6hQEQRXDmuMeN36jYAfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YP4I1MshdaBxLYbE5NiZlaTdflsUfoDDvLpilFxjQiw=;
 b=OEO4c5OZEnWgFJhHryGm7McfbOhVnmF8LShGsoy+UxKq24dVuMI0mwTj/yvhkv6o7k2muvreoFcVcmVTitETgd3sZfQoya3z3e+F8XJiGuBJqKPMDGGsW6XCvVY7KbxD9J1Cr2QRYWuYY3IQ1WPn2ZZi3oHNPJEvTJwqjML7Bqa9P51L79ZRrYs+TjxUU9Am/6phB3uDgnFRFhC0vvFUW70cxqqjJxOqGBwbhhSp7CFlO2xaQmsoRRByxIiH8gRwY8K0adXOy69ytoYnNfd9iwGQBnL/fHazfdB6AjEqsd8t059Pkh3pwXJ0qj4f4reh59CEd4fx+1LefssJtImrdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YP4I1MshdaBxLYbE5NiZlaTdflsUfoDDvLpilFxjQiw=;
 b=SeW0RITuDzViN+SYke58mfDk4VRSc8WUOXLo7vdihyXaQ9IHk/1m3H86U3K1oLai/ZUbJ1gCmGWVroDqOiUPPUX/6r0oeZpHbeK9ZustuKBazcJH3Dlf/F9DZXLpUvyrCpaw3uXm4RWLn4YwPNTXl9fiwP1BOOuLvwj6GLPQ+Jx4AWUk8EYGgvLgkeYoM+Z3t1AdK7ekxiBmyPeyPsZ1hy+IeZjXdKVNd8kF5tI/huISZrBi5K/GyMPu1SR04KUPnOjRrhd6MTP7Clzmk22O9uiDjzWughlXXeq6uBjkidfBqHmYvFRt9n3N179r8CaomcWLcdT4Ro2JbmcJl2s6uA==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4413.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Mon, 29 Nov
 2021 08:50:22 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 08:50:22 +0000
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
Subject: [PATCH v3 resend 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Thread-Topic: [PATCH v3 resend 2/2] btbcm: disable read tx power for affected
 Macs with the T2 Security chip
Thread-Index: AQHX5P4ln7vPo5AMzkubzmw9rh973A==
Date:   Mon, 29 Nov 2021 08:50:22 +0000
Message-ID: <6326984F-8428-4A3D-9734-1A408B9E82BB@live.com>
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
In-Reply-To: <A003A45E-EE35-43EC-879F-3395CCB5EF59@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [zLz356eAr5gwCPYCrh//D5F4/ORq/MiIGT2kslJiWSL7q7JAXzN4aolImWvkhUrB]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d2ea98e-4ddb-49e7-8fd9-08d9b31547c1
x-ms-traffictypediagnostic: PNZPR01MB4413:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mt2lqV8wpAWGz/EOia1ihYqdhd6cR6C7542BsH/YBrxHjfxkJ75xL47yGHUFsh6wsqvxcv/BiSMZpanY6T6caPr9kwWXuaazZWG5/22PZLeE1AHYRETJJoYImQ9cd02QauiQLT6bh62JGthJBKOC0+yAbPKrueA0eB33z0si9Mp7+Rw0T+ke+yP318SXlKXdlLGloOfz2mJqd40eoVV3kHKQyDMOIP3bedEAZDUe3a3hgCt5IqUWaXrzLfprDfKnhOClVajwid+t9kU58Ma3JWHHtaqkfmuTH+hm0aEb3IqUnxXzWK8LSbCgB/H2XFWlcwkc/FrC2ga12932rsxAf0jtxVC4zEbHvm6oJSsBz89jcq/6G+KHG32WDyTp/cOIT2QfcsPKRel1Jni/NHDJmEPnN4KHZpNjASETX9VNYPDv294Jj20iuoJMx3Rc7UfzV+v7y/GBErdRZK2G2Az2UyxxzO+KXwcdeNxXhDXfcUBmv9hbrFElcdnTbEzCiZgt/11QTonLGuyplfNagz+fUfd2j8n42AoFzAfi4lNMz+Fbh30gRJwA3RGY3rmsqT0HoOTR9FyORr7hgS3NjSiLiA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 2DACRqoWW7k7S9t104GkSN0fywpOkt1vpaTO67WVHGORy87nAy0T1lHQLII68ttvuEfzJWY0PhGPwwB/NCPdZ783vYYi544FoM/NOG+fqceENC7SW0o+/TUQFhxh+XFAXwQ4qcHp23Nk/KNrqINPqrnJH/S782HyIIIyVJezgA4NGY9wl74QH26EEMkrnLIqLoE2JOv6GCIVTOdRt0HN+rXWBv7GKeFcppqrxkDaPL5TmP0Wr7abJIf2PD2bK6JjROT4YnRAJVQ5yPet1I9CHHJ8Sdy8HW+EFKDHLjFYzR2heOySUoNyQd5EbKw26uexxJWBCcc6I6RH+6xn9XgCagf2Pd54/nETjoK2KcsHRxvF9lBxXwJ4QXS3wXMJlKgk6YhxaY4D6dJX3g/b9pNXG8vypTNpWoEAfgX+/pg6zFf/WD2KIM9V+/mtYrD9LEx/N11iqjn4qsezUGNHMupVvwOunDSRGyKRSedZf0EGtkX9CJz7bQqOEZhDkWdyeq5R3mhk8//4wMGVOKeBMMyQFUs3gi1fWm1CCVIJQ9l2S4pYF3X0YJdBMjL66ZjrR0xlyhW2FOgvm4Rb/fpPdbSLfD8sXM0E+cyL2g+rRcLlZXS0dExGOsJYVCyOkkwnUqPSH1pVYXnVbORFzJ8r2WXmRKWexYIDPRaGeddlYBJVMSreI5RwZzIzF7osPTNSvzLGtd4EydiQawY4ai6GeWpr5vwVtK9MDkLoNu52p2y7ye67uGAwGwnNuLcVv4DUmF/MKWmTRJMwxLnWttCQP+VMLg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26DA55524047DE4DAF51EC7DB17E3DCF@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d2ea98e-4ddb-49e7-8fd9-08d9b31547c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 08:50:22.7834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4413
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Some Macs with the T2 security chip had Bluetooth not working.
To fix it we add DMI based quirks to disable querying of LE Tx power.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
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
