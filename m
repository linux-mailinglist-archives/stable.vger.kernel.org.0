Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2F5460F54
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbhK2Hcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:32:53 -0500
Received: from mail-ma1ind01olkn0161.outbound.protection.outlook.com ([104.47.100.161]:39472
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231967AbhK2Hav (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:30:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmOx1WrpWq2VmD529wy1wfD4fTR6ctKVDFGAFOP1rOdRZWeHq65DtE+cQNiVh9KDdHu8e4QGszSbnEa2cxkR+ntVQtMW8d59kvbMYSHqEIbOpgBC9UulHYlfoXl/qXcZc+fKCe8/WoL/1PREwhRdfTkKQYVIyIVaOPNTdSeDKZL2tkXs5bYCCEZBsIIqJbOgt5M5jJt84BJcwkkquPgBvwDQfoSUBFNO0i0tT4Mxw2dEsz5FZtA6+qHr/UjpsL3uZXIyr7K9//dVg+pDswnwc1ZomcUzd4luHJlsw0aO/e97I7gPDnaZgtzt5W1wgen/cReIvl2LYBOZRyYZdy7b2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezaD05mN2CAN+de0npTH+mEkoByuVYhbgVzuxiWVpuA=;
 b=Tr9iHTgpLVwyj54ph61XHcIc9BW2uxi6voZKbvnqc7S2aojRigFbqKrdmJAijgANfI5hRdc9HACJi5e4hKB+ewnBZKMfAYH11oZzRGD299XyYJ1sBAk6fCjJKyy/KGW2sJ8yLjCaH/cN2t3t1FkxomkZLv/sE6IB3ZgkGwnw3ux7+UvtHW1t8f24LvY98PK23zFO9DEMst9ZN7T9Z5ehqzEnqN30g7H7uR87zQHThXIOTk8wi7rb3X8kO6iUe3/cDoXZfYBuaxiwJxl5jSUEAj7sCdLut6a6pBwxk1bw/YJKyaVRSqDyXxAIdeCHv3kxaVPjgrUnigs+JqEwpEiR5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezaD05mN2CAN+de0npTH+mEkoByuVYhbgVzuxiWVpuA=;
 b=uaZbGQmC6EPuvzf50ieTlkgbfsTpQyR/VtxP+ZdKupcEbmmJp9qnBVfEpZJeD4TYa0aSLsyMhyoLfP+HtK6xGoNV/1LdGwCvHRPBmKuRFoDlkCjGoiwFDrzZ0gY53oshzrEzMr6ybuO9JNmym+emSlnOHWLmDPY9k81lHHdswTah1Nqm+3xIGiajGmh51RPJ06upPq8cSVaMzRU26bZtmUPJYT4iKcnQ4BEKmo/jsm+vOn6+UbRXzq/W0y3t5k57SijyQ7ggdRehNfjHnKreJfirabOa/TZgOnvvKYoQPM7BbRh5gCjAAr6ZFCw0IK2CzA60QfAH9070CZScLX7qmw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB5261.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:3f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 07:27:28 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:27:28 +0000
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
Subject: [PATCH 2/6] btbcm: disable read tx power for MacBook Pro 16,1 (16
 inch, 2019)
Thread-Topic: [PATCH 2/6] btbcm: disable read tx power for MacBook Pro 16,1
 (16 inch, 2019)
Thread-Index: AQHX5PKQ779Jt2FqjECoFOtr+7YrOA==
Date:   Mon, 29 Nov 2021 07:27:28 +0000
Message-ID: <5B9FF471-42DD-44DA-A9CE-0A83BA7A4212@live.com>
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
In-Reply-To: <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [4P0Q6Gbsj2O8DBiibN+tlVQWUPcOp2UyxPY6nfhoH0aHmXuolZbSqORFHA0mlItf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b610a320-e3d2-4c5e-4a02-08d9b309b2f6
x-ms-traffictypediagnostic: PNZPR01MB5261:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 15U7wnQAUaC4hfOMlL/NXjBEMDWx1exmNeTgbglOcMLHx9aRkXbhNW+wmt03ldEFUX+8FFptUXcIlybOQ2pX7mPQ6Nu0rCSE98no+yJE85kZZxsNPuAIh6hj0YXSDFHS9fkHgjw3JpD1RHoK3Lyd2wRcwp1EeQ+aM1CCSXfGrJQzEpjjMsK3FlZC4mCcj06OoKE5t1P2mdtQY12m6krJfSawDxqZKKmHWi5+/J/lqOtnTm8JF6HF5LyQ/O74/yx1Gy93G9dX/DUd7Vjd398bzIcILTtsVnxhVDB03kt6sfxCrW/e5xPIgwcXtJynydZ8pKqD6QoM/ocNGetkLSVZCg5/x0OrKI086J1KbWJwbZkLj9mUM9cUgsojryM7k5l2M1nB3Ll0NBlc6JF4mA9E1E9EDFmTkEoY0R/HOS8cV92KrFMBrHmYW6jhpouRVKDZThp5lQbObp9/KQKRR8/vuJatTtxBdrvR02/z+RND01H486Vc2d+9UU9cYIVLyDfZ/qtsAEDLdNcwsAkl+i7/hwnYnHFCT24kEVwUl1R4u2Ux/RxBPqFHSdeYnNdbXfRUH4tnbPcc+MSHusuq6FgRCg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: mm2WhZWCBhVTRed0nmnLG2hEJdKiZ+XRgvPIhNwaVYZxfRkq4GKN5UFlLGdnW0vf0Q+L4iDilSg3hTe5Wlc0bYqt5YoyAYbQFE0+5XBXcW8P+I+qhPLFcJQBqkcNB3/MV1zwVgSsFXU4bRKTbVfBhXlfchpvWVrT50BxFGAwfQcu9ndR78Bx0pFrQg8eUQBmHOrjtViMrkmpIEmWzW6JxZhfP2Mrq8Tgq5h0/S7pWdPgNerD5IGBcSzGQUkrELeCbf0qcb1O/b+4lwuqjbRPTorLWmFfshyw2kTqGESsv61VJOL44hN8rYw+GmWQY+p8TwpMXOVSSicM8kXTNTrDa3aE5nTvqJv9tMV8BEHanpSdu7PjYYwShtFLM5qfEJ2oarJAZdXaQznKyXAn329y9yjCFh+t2Ql4Y/pBYjeSjFIi9YnWQQbVuqQ8MO4K1SQOFmtH9IYdFYuXXl1klFvAUpaan/DwFQCstjeq5leAHsdhNOudEEl1cYbtp2Ahx+vWZJo8TmDVK302SbfSxoRsYkGL6G/FxJGb8oNVCpveHvdd4SwH6A7ILiXdy7c4pYayyP44k/4LG5rvNR+gJs5HnBrFd8SE9HEHkdw33Ha5WeNBvJeqBga6V37eWGlbljaB7ze+NxEP/sjwNd2gDMn2JM1WugUGdYwag7cFrCjQCmMzKT365wo0n6ETFlW08TFPmGy9c6k6uimeComGmhIVDsJB9B3p4peoW64TredTHGyyqqQGVAGSwszDH5dnLkBPjdAJEfyP+vqQeyZrYUoBPg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E28D2B5EF3C91C459619E8B65FE60103@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b610a320-e3d2-4c5e-4a02-08d9b309b2f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:27:28.7919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB5261
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Bluetooth on Apple MacBook Pro 16,1 is unable to start due to LE Min/Max Tx=
 Power being queried on startup. Add a DMI based quirk so that it is disabl=
ed.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Tested-by: Aditya Garg <gargaditya08@live.com>
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

