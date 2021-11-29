Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D00461044
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 09:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244697AbhK2IlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 03:41:04 -0500
Received: from mail-bo1ind01olkn0161.outbound.protection.outlook.com ([104.47.101.161]:27089
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241932AbhK2IjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 03:39:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsvHImaLGeBhcGO9aFHhJYFzyEaAXRKxE+ct4sHeg0xF/RJRxPwbgJHuo/axcVMUe28P7G5beDqGq409bPBGYW9CLSGFLw9mTITvqOAiuFP5tCva/GBFEGUxDDjPOZyUkSZyAEcQl0dxs8QXYmay6kjgGxq+8hHCJiGhU0OpGxInsKqvmwLxcGexMOB4eFgmwxddOSESb2IcL8VSLavDdIktutB5fm82fB9hKVJ4eY1vV9WmLNRf/OmQPC+tzA1Khwj5DFDr+VWtbu5lNMCQsIBBgxfKs8L/nwz7SKy2QHfQDZ+5BdkB/Squ9tTBKw/w0NIi/11LRIshkWBX2hneqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/AzklFNleSJ6KsUFuUXWiQXk06n4LZdr/C9035iqHc=;
 b=MUn0wvRXfYLp1I/lOYJ+AJZbdeIPwaay7UKLuOeW/pQBbaDsOG53DsUwI98fomX3LLU6fszaN6uCPijcn4Zue7+MfWaa+3KzBE4VrmjCI1VC8bGjaRge/1ajBalq4zG+g8Htl8EMASsPaROCgQY5a/GvmpCZmPBgVBN9wHwiE1HpCTJszX8EvO8e9JrMCKVhJEF9fcfzEHMn/P9Cv1WpOjA7/OXHlrGqQkjZzcCgsNxG16Y1jTGRvsaxORJ4PRA532mxMB8cnGDPK019CCXJ/a0bg/eyXDlhBIXkBrKzzCr1sMQjok5NmlJ0WkW3bi2lUh72dQqYZLet7bFr1fhj1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/AzklFNleSJ6KsUFuUXWiQXk06n4LZdr/C9035iqHc=;
 b=NH/ifsw2Tk1naGdilIyej+fyjqTMy02bAV4usHznKvNEf/RmgSFGCZogRpyrF5FNOA8V+6GqWhTp1tP+vrX0dOOpeNcLbnVy1FPhjq/nlsGC3U6eZZXuUPJThiFm2BorxbBnoojfIX2N7yn80nOsXtMhQABTAryCYBcHl/Grg5uo/2aozZ1+6nQmOWAk4D8S/gxCHa5n1EpECSVM3xpkH3D7B+giMvj6Mnzl/z9p5zCGba8hED0gTpu//z0eWvXfq/yNdBIfDvc/LkP9Q94GUkg4xSwYnk16b2JuqdvQc9+yf4cXsMa5w4W3KORUK2fMzQIuWcKf8MT6AJaGORPU6Q==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1213.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 08:35:41 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 08:35:41 +0000
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
Subject: [PATCH v3 2/2] btbcm: disable read tx power for affected Macs with
 the T2 Security chip
Thread-Topic: [PATCH v3 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Thread-Index: AQHX5PwXwFu1lZi0X0uC2tbwaInMKQ==
Date:   Mon, 29 Nov 2021 08:35:40 +0000
Message-ID: <A003A45E-EE35-43EC-879F-3395CCB5EF59@live.com>
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
In-Reply-To: <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [NtXbDud2jeDBM2Yte33i+YDrXEnBSsI7AizX821aRpZ9Bvmw1bHQ2L3nYY2Z0KHs]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eac1e624-39bd-46f8-fb12-08d9b3133a1a
x-ms-traffictypediagnostic: PN1PR0101MB1213:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NUPVQDzPBTvKCsRkGUdC0C2dBnyJ/LncTUq1YunOAMp2DU6pXGlbFxZgA0b6dAEwBoGAlKsSQYCjH95K112mfinAUYtFMGSS6Z959txj9FyNCjGSULsUHnZ4aKu4HXIvT8Eyx9KH7K8viI2QoLmTs8QU/gZnPKGvx6eYi0SEF1i/L0fOPzCwnpJEPtzlEWKll5L/kUslahJbeVLUea1F2Pj67c0ymNGMJZDCN8LUZvDmXv0quRUWqOEAGrQFv8pkNmklWq2NfOMVFiKp0RRhzH0dJRpNrvt+pxFetkRBLdbEJ3zxsJrRfxbVV0l+2ZP2CtS+dh7MZ1as/En1SefwUvMA1LEJrTTn9bEWYiE0JiKJftc3Zq0bvocnlZJBogSr6gJ7lkHqfVI6kKwWXr3IzKkh9Wf54i4KczE4rTVnvUXcD2mkO4muXVp1FDu81BBncVbz4aUu28c62+oV6prvfanfS2kBJ5q1ZGdy63IOM5uNzfWoKVMrACYjEAd65GQCWK/OVmi+q8KpK8FBo44ZJ1PkQpotrgG1m63L6J1rHFpCI2TlXDSlWhT6YGzioL7PbJ1hzyAfx9hpPjoByOT7kQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 1sEtQcUkaSSjck3p9UYGfvWCXwG6uaBZ49BdWt3YYHvKz9kAYG1udDRlW9LEVT/tHR4HUzkxhBVE5aVg9bwWQ8SWjHeI1L7qOGJctnMS3DfBnhBs2LHfjoA7b91H7V3L3H0LqKgrm693/Gkp9vEOgjfgH2btSSzwc+ld7AHQmZQxhfz/QcmuyNltZDLZnD4C7UbenORjp7kpXoAtUB7Fd5ziLE0EzDEaKZMLuCZhPu4JjQ9V4qo8YJ1K3fThnZWImSSMA4+p9H80Wpp6A7up42A5M6GpIKkmXqalzZZT7KOqTOKch5nwq7R+htbI9ZU08RcOvf6jw3frxqoK1zG0KbWqiuuuGzYYLwXkzVUnlD4ugAxB1NvJJLRT4IQUWIoKd0ZmaoaJipAJXsC00BkrAhwIJaaX7WE5V+h08nAhV3DmDWwwoRiiqQIr/lnRVZ5cPiuy9heCOvL0cFAvEm9umVsOHU9XMrzrCDmuCS/WvJUgQd3TP5pkzcZMf0KJi0NFbi9ETCztR7qJOv5g5hmBD93hnj5TAtIqpRp41n3EOZRF0YTmuBCv8xG3Ooqu6kTorQiqqAe9HghPDX5r5QaVnjiJoAffht/EFFJZj2kTNTa8wwKp1iNPtUR5mhMjvBDnU4ZygRbYfH2OoOBGywK4zrOwfvdFG6qzXtxSB+gSQoCGXi9x1BIo75S27zFd/uVrp6YErv1BGJvhWS7XyD6cj/MvQU6nhQPhQDc1rQLGjVCn/16ZqCQW7CcTWNbEdCN2Z/wETcEDPlbcwUytb1Lkpg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B9DC0BDF8683C84DA0EF0749146C4527@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: eac1e624-39bd-46f8-fb12-08d9b3133a1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 08:35:40.9735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1213
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
+	const struct dmi_system_id *dmi_id;
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

