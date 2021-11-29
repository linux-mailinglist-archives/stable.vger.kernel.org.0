Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D461460F66
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238615AbhK2Hh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:37:29 -0500
Received: from mail-bo1ind01olkn0176.outbound.protection.outlook.com ([104.47.101.176]:62080
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239512AbhK2Hf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:35:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIEP60Yzl0kieyRO2LBsaAAFQ0bjLpuC12ErV+n5dcMkjJrSijYCIQRD9R2bfZtyJ0anQcF3exAlOoLJCDw3K5pbx5B5eJdQZ2MaNocl67Tgi9gruvSER054yCmDEk1TZAX7kkmKdK6Y82A+PRiNre17QQLi2rrQdE9WqvRNgrzHz2Y5AO4DwN0iZ1kAjbJV+QG7y92XZvhWQr1+fOw7pOegMCjLVKS5o/S9QbCbIgXi5bDMy38jrF3rtbeu4ZDjtd4nWc6bFCn1l2riHR3I+0rColGHMdxczY03QweYW119ltwbMESrvjBApiEI4DJ/jhzTCe8mts4Wou1dTtek4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4GRXda5gS9x9VSAerCM/aPzhn9gOTctTYuZn80SFd7I=;
 b=BwdVxfCz7eDMx8qnQkMeTDhs04OnnY9KVzlZL2In06muWkA1eA305UH0AQZRvdtCPyfFJdcqzL3LCcedfdOQIqqmGSP5xbp0/gs9fxTbRzgOVlbKuve8RGMAC0oda3cgaXUbpZosMhWPfA3Nqp0CU9gWk9DxbdCqN3FbEczyZTtUdQgH4y6E9rrR8VLQ6wujf/8Di/T4TQSp6biK+TCUL6xeG2E0HPcuL/GG1MNdk2BNR1A7xvXZ/3b6wui8dW+PSQcrp4ZwajkyQSaGuJ+u0luWAVKkTjz3gzhdpvOOLWmzIgdZVset1p2pwiUPPRI6JEbKTsGVxuEWXwAwE5sK+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GRXda5gS9x9VSAerCM/aPzhn9gOTctTYuZn80SFd7I=;
 b=FfE66BpCabb1s7R0J3epeS8GzinziXWs4kwzPUR9o3q1II6nGzU7WBh2caruyC3/ajKqyuyXXvJPA/WUXN6bTMqMCq5n0AkcWppCJprscr7XNVpulZxgtZFOBcuf72gNyrrhMjsr0Sy6ZaJ4UEdrxusa37zQmIQG8h8LCD49D4Bthx6/n/w5FxiQKIThMcJkCbI8BLQBzMguZLP7i6Ulf/3naO0Q3nvYC3QgbnauC89+SdJWmkHGMiSactGedeZLuzCFFjpDFqpcgCVPeU5gSq3F8OTBmKxW5Uz4DSQjx9GIMX/2oCZaU3/0LuhK1dngcU0GXxXjG90Nlw7XwAYc/w==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1662.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:18::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 07:31:32 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:31:32 +0000
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
Subject: [PATCH 5/6] btbcm: disable read tx power for iMac 20,1 (Retina 5K,
 27-inch, 2020)
Thread-Topic: [PATCH 5/6] btbcm: disable read tx power for iMac 20,1 (Retina
 5K, 27-inch, 2020)
Thread-Index: AQHX5PMhn2Jf+xkhtEWseNDG5qLzhw==
Date:   Mon, 29 Nov 2021 07:31:32 +0000
Message-ID: <E9DE81E7-F408-414F-AB25-D71657E5177A@live.com>
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
 <A96508EB-55CB-4542-9274-301CE8E54510@live.com>
 <3E9D8424-A65C-4211-B5E4-B6D62400E711@live.com>
In-Reply-To: <3E9D8424-A65C-4211-B5E4-B6D62400E711@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [dq8NQswA5yhsmA8RcoJWFIfB6waO9bc3bYa33TYtdylq+ZBiw9/jmM0gPxfG+YrY]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0991816a-9158-4b8d-3e12-08d9b30a4427
x-ms-traffictypediagnostic: PN1PR0101MB1662:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ypvWmt9eE/qjU+vzSggUMu6f2/XyEkwFc/gZB87m22UcWMgcMXNr13Jix15VtR0Heq6K8Thhgmp/6cXHjDx+8F96787ZWnLtgyASetBKDa3JJZVKCJXmd0hDJSow/rM/ko4heuInkEvoDRqz9wu80wUrDI4nCUSy9kVDdKBNZbKRtuN4D4QToWXpciuO1M5YONz1HQwQivTJ2fgSoH3HgA0sFt7M66/lCaXmWu4lQ7R4TuMseqm8VEG0ydtVdCMNlhQ8CWmDSNIwmfwNLmBqBLIdvFgdMEoVfKFXhUoWUVFGgz0+ywV45hMfLVS5N8VJTxCpHyARhQcGSjQLCdfSAtTxaH4ZrtIrBS3JRi43dUsmR/0TOFSWkpESWyf2dQtfc/hU7WzLEHJ4o+CR2I0UPblOg2w+Tp4n4xtwF6EB0qKD7aSKP+glOSbxAQOz3KjqMuKKKqvN2uVIamRVW/q/ZJN30EX394odaKYv4zs+vICWUlQW7nTXgzCoHPqRy/dsh+brnUEk/CRppX900PwgWPe7HD6JV48mChBmzEKJFrE746JLXfscBWy3lzQHO2Fd3rfplb9GNgBOH/q9NQP7OQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: ER4o58k+YJuWdslJsRPN69LdlKyrBKgdQ+CQhP/iT0o/TlHRguENzueRV5ycWEOA4C0GmPkWxNONc0NNWOBsaexuO0RiwW18Hiu9zfiR+QzQPJuwBdI+Lo89NhzhMRPvtklpr75WsZpk2sDtmgoBfG1Plu2tOyyvkcv1u5xHsefI3vWxFtphf4sZ4gW5hr7SqNqsmtz96qXyR+OTp6GamFmMhmVSBc7Eat4ouQuQasJHSSClJ0+Dtz2GXiaum+pp5RrLCBoRHKXoWvPWJBJbv284uyu2uWyTxFRCosY88o+xYehUFmUBlUsQcPiPlo0R3AaKOUktYS2a1lOUdmUzZRBTt7OSHqggJUwimJ24WLhWAY6ikP22bC6zWTzPysiZIiHu2F9vgV2Hf9S1oLpNBBo5YssbKpde5PbeaygpmJsyksU6W7k/VxwQsL0/wMZ0J/8t6HV8DPy28hbJLYs95emaA8QBt5v7ft4Ttvf96U9otr2OfGhNJASme0TKLs436vfnIj6noQB71cZNUJbCj0JYTztqMPJw48VHppgYlk+qlENnNODUdKGBtI1uvEfXlgqpyZAPi4FPyswIop/m/P7QCb0P+QMZM398F82WU6CPOpqIgEmMBDLB3jL6lgfesgHGwTg9V1EWD3bsT5pAMDae5EuY376uUzzfgDWB6xcXOiKlu/ofGgb0qagcVa6dJG/kvWD8KNNv8JAOjOK1WEXLzYn9jg8rKBNTPDFWNCOnKZ6TFaV7j/GMoa5SJ17pGk3MEigyv5MEJeFlHoCeVg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <762A4BC8ABDACC41ABD77C7513037F90@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0991816a-9158-4b8d-3e12-08d9b30a4427
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:31:32.3296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1662
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Bluetooth on Apple iMac 20,1 is unable to start due to LE Min/Max Tx Power =
being queried on startup. Add a DMI based quirk so that it is disabled.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 drivers/bluetooth/btbcm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 88214b453b0ce..15c5be927c659 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -372,6 +372,15 @@ static const struct dmi_system_id disable_broken_read_=
transmit_power[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
 		},
 	},
+	{
+		/* Match for Apple iMac 20,1 which needs
+		 * Read LE Min/Max Tx Power to be disabled.
+		 */
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
+		},
+	},
 	{ }
 };
=20

