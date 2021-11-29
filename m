Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EBA461763
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 15:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhK2OGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 09:06:07 -0500
Received: from mail-ma1ind01olkn0144.outbound.protection.outlook.com ([104.47.100.144]:14906
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232888AbhK2OEH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 09:04:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f98hANfAp9CVBHlm30af6yntoeglznhxz6ultiFj/gNJJ0VStrrtDPh2j1uJEsOkgDBM3gCs857lkmxVyLOs0eYpxKoZP8uzVwUnVuPUiuNIyn5SvzfMl9Rs7Q0gB0Tun9pOGvm8bU5TFSGxw4ugnWHgtr5LfF+LVhxx4BE4xcBi/veBYJtF7X/W9f24K+2kGLXw9MNx+OknA/46LXmB34WJs+KlpQtKPwEtVePBvkPuNCkDHRFw/0VGF7BWxbPAaUkrW/FYpEAPFBhC269IYakp7BwOQcPYP4fLv1nAUTuibHoMtEMaHNE9NE4t76uQyspwc7yW/lWQuyh/ACnVjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyDYQR9UGjdDqEa6N9XCo4E2GiX5+OlNQtn+IvEBl5c=;
 b=iRSOVV2XSnkIZl5xGfSKESJNwIeS5QgSWkYzbVBe5nOVlSShss1X3D2ljZz84RucEI9tn7XNTjinCsxre3gb6f1JEa8UkiZuSXyqTOuMq5anIrd6V1TNbi4mLpiNONZxqAN97w7C4DT8SjXLDO/TCduYtqifn+T9HYB1K4q/LBB2JG0o8QBtheb5cuzz/TjYyqi/VrAFvZoLC0aUPmoK7UWH6M04XH0TlxsO8U05Ttu6W4pS0Y9iNF5iHO7iS05EGqTqAyFJxwrKCtAUaFdLmJL4qINe4jAcQuNodJP7SsI542AFo7v2tQKMck3Wcr0+Ssa87UfQxrcNx2ErORQ1ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyDYQR9UGjdDqEa6N9XCo4E2GiX5+OlNQtn+IvEBl5c=;
 b=QFfiGrNyZ8QS61aEL2EABWzVaSdequPPVXDhrCCkj6TjfudFitchYCewSfP2Xupij3xbs0Pr/0Dkq1MebMpxaoW+ZchJjBLNr79Gmq695MRTeITGwbxVdPkEJ0Uz5pPAtV32ya5Ff4Soyc5xj48iir35gAfq1GSsCNHlU5TXB1mFJvTWuF30KZvZamjyTx77AlMGAynSuYxznx8Bu66WBmDCiGdexNK3Zxa7oiKIRVYQnmYHvaXChibV5reNIys/9RGnRhpIqf9JAEC4JxuisUkkRJhqk9nUwlHJ9fQCOgBenTscZYV5Iw5NbZ8xH1jj0ViO1mZ41Y7pk6yxLEKFhA==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN3PR01MB6375.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:86::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Mon, 29 Nov
 2021 14:00:44 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 14:00:44 +0000
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
Subject: [PATCH v6 2/2] btbcm: disable read tx power for affected Macs with
 the T2 Security chip
Thread-Topic: [PATCH v6 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Thread-Index: AQHX5SmAYMFMhf9XKkiO+6jCBJfLBg==
Date:   Mon, 29 Nov 2021 14:00:43 +0000
Message-ID: <75EC7983-3043-41E7-BBC6-BAB56C16E298@live.com>
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
In-Reply-To: <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [cRRiHsncjf/0hKBcjlGwQZ90Zh15IJu7IpXgSdoAYfZ6tay2n0Af0I19Bq93prAQ]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 367d24d2-7363-4066-f22c-08d9b340a2d7
x-ms-traffictypediagnostic: PN3PR01MB6375:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K1Y7vFtamhdqZIcntXkmNGA1M6WJo8erANzcbm9x3Fc2x5YVGOM+9WZFCpuBQZ7vx0j8i/edC6CzHj3eV8mGlg1sJRUhwaoImZ7/g1MQCU6vej1siuozKvrpTBWDVbmGbxvlocwptl9ZAdps5o+iMofNunUma53wvkK8+5mk+OrTASa6v/pjLQyjxXM1WIaF8fo01g3y6B7OruQJFxfs4+YdbrdmBabTz8qYRqcWite+9NB/p+OZ0EUc+3a0rVdZEIShvbQValLBMW9FCVeIQZZpnVionBfSwF0fZr+q6CweldNPR+y7XQGKMJlC5UWb0wuW371ytBzhJVoGUiCH1DY2017ddol+5zQWe5Qm7l5HCCA2ZnbSeaoMemS9qFgKxNToH0prTF/p0YEOxH9OfpAMJogki+GvKFu0zd/7xw0MbctNVZtgjBZkZE2ZBiKMiZh4tcLeJj258xBLSaZNgA5r/QiEgr1dIzBV4GgpjENujmr+x1tHl3UlWjU/G+CAK7LFpZsyEV/1WGSA9h3aD79Q6nqQATSPhj5FvSzikUnz1aAK2v/JKrlKVXjwRPEQmwSVMvCQq5RE5SLobo2rIoCk58z37e4WqK4ROQmydJp7EQbLqTZHfovrpn4TIk+8
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: FH+loWdWWi1qF0wyc703sIeRzwO8rmiTqn+ilqgQ0HWl5stgftp079o8JhkB7zN2jxz7dmo17lAnP77u3NFsh1DGvYJCYLdBARPm+U+xzEwMTSNmraEp4XlLP1cloEkqBr8eL2ns7DVDH1xukCpNUxK4ZTjbqNG8W7VtBmHDSVIp0mmYssB1QaHlrca+u2reL+uN4YX7yEe3ivLCtkKJ+gMpA7KnMHmyoj7g2/WF4Tsc4432lvjZKLM6JrJiPtla23cyeCM7TAVxQk4upb/S86r00V0G58WqapHePMaIJqP09kzp2Aa8xNdOFxlO68S0o6nU8ry7TaOGc2j8A2dCztpl+zze/Wi7ap1Fw0SeR6NmL0mr8qu81YuTzVd1+BsBahb380CnjVrAWeU5sAfxN5qfA/8ky8NmUkpeohUaL7ZAHG3TwFirUHKaFrNnbo6KDojCKfc1Wjth4bUTZfYa+m4d9maYcFV7uA4Bui4WNFuRLE2fdGAbwsWS7r66YxCgog1rB7tuD20pCTNV/NbX9hdqYVqXeRmcglyTaFKhzJQxBA6kywrEB9Eq6Xlhvo8blVA4Zpld31qIJHoh6vRjeDcqdQi/4mr+T1CDnaTWfH0X0+2aF6KjQwO0fIJUlhSJe6Fo6ULsqeFM2vh+FNgqhgIYPdei+0XqjvMlHCG31ZS4y7e65IK772H7SPD5BjSV0vZYQuuGZwcTco1PPZ9rtpNpFBNcY0+9U2rDmep7QbUVIpYQ3DaHZhMxEjhslT1ghLZgU1EJF6EAqwqKcrjwPg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2B92184E0FB1B94EB0F47661231FB1AC@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 367d24d2-7363-4066-f22c-08d9b340a2d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 14:00:43.9860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB6375
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
=20
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <linux/dmi.h>
 #include <asm/unaligned.h>
=20
 #include <net/bluetooth/bluetooth.h>
@@ -343,9 +344,44 @@ static struct sk_buff *btbcm_read_usb_product(struct h=
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
+	const struct dmi_system_id;
=20
 	/* Read Verbose Config Version Info */
 	skb =3D btbcm_read_verbose_config(hdev);
@@ -363,6 +399,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
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

