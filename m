Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE533460F69
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbhK2Hhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:37:52 -0500
Received: from mail-bo1ind01olkn0144.outbound.protection.outlook.com ([104.47.101.144]:31217
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238618AbhK2Hft (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:35:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8FS8WQopda2xCZP5RJCGFGwxsr0TcH5hpqqKC7gwXYDFoY2/KAfYjrOYOnSe/yYMkoTxxIkAvX6/a/MIoB3ajOQoWoCYKzwGKppvsHP79KSXgXWVp5j24EB+otL8KdvsoWxzMkU1DMODRBE5PZ0CyR6vIXeLwXU0I5ehi2h5P55dw4qT8foaUuiorCZ+VvabxEwvI6GlyKe0Inn+1G/R2ShBPff/43IDU1KmHxrMqmXB2WgnXI/NbjEoVDK3v3rz8wlXu7T6wtWe/2fu5Z5bKf9S1wOhpPuidl/rlSruF4pWfk0bRjn8YdzrseTE5u+yixKluIoaa3E+TPCjnh5Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RkH27gCEV+OD6JJHa+O51Ed3T2E7qY5Sx4nj3Id7qb4=;
 b=l5dCHLHUaHXnO5cmqQRTw0toXoT8zIDhBF5H/d1ND/CEXb5xEiTbwIuGIOPE2gBmDtBoruPUUMQA2CC+asZQKtb6M1YwBTiSsigRoQozYWcCuPQ36IGNEKRv1DWB5E6AA2WXLgt09En/umG9fSiWtRQBMKt94lIqRfq3+w5ZV0WAQC7zFyCSfQI5PT7KAjUMVmJJ11raF6FOZ+iAb917aqskAW2OlYJdC8pxrHQf8pNi9/QeC83CtwPuqZjk/XAWbHvFavKeuZlqAgFp+oxLuNM4TGpT6HZMbpN56d8Yk9CzEJhlNWJx2ygivrY80ZbUYDhT0RKfQmSHVv3zGEfUag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkH27gCEV+OD6JJHa+O51Ed3T2E7qY5Sx4nj3Id7qb4=;
 b=gjB4z7xMU+P2V0JmAFGYBSnbA0yEbMBqU2BTy+Kf4yVt+LFN30I/ClQNQ8q1UEOE5t2CH5sLJt5zczoIh9ZWPkyYFNIUE7ozT1nphWDAZGMo+wI+eusemIJ2iNsPEibPF9eKwMugxsHP31m94e4aRNBM4DfC74Pk/cEt0G5TzVS+/JaJPPN9secfxF0cxX6cTLG0Ygki9O0xRneNrXc1VDVvuypyg+L6m9Vm5nXs2mwZ+yVbdhZ0ioqp6oBUVG/UBe8RGibYhjoRUoKH3WHBNXC2EZpa8FARrEcCtUSzj0kCPRf9tsC9K3RUNlcjZltmeKDLfpeTbFCD7ne3ULbgaw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1662.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:18::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 07:32:24 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:32:24 +0000
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
Subject: [PATCH 6/6] btbcm: disable read tx power for iMac 20,2 (Retina 5K,
 27-inch, 2020)
Thread-Topic: [PATCH 6/6] btbcm: disable read tx power for iMac 20,2 (Retina
 5K, 27-inch, 2020)
Thread-Index: AQHX5PNAeslAiRbqaEqN39DGKwYeHg==
Date:   Mon, 29 Nov 2021 07:32:24 +0000
Message-ID: <8E63B397-FADC-4FD2-9C90-B4F09C5498A1@live.com>
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
 <E9DE81E7-F408-414F-AB25-D71657E5177A@live.com>
In-Reply-To: <E9DE81E7-F408-414F-AB25-D71657E5177A@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [rbmKKae7n0rYxAWJMHFlc/KhwDJ5GSRzAQ/2/qUbk2lmr+g4v+cQ/EDoYQkrl/i9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49584d43-29e9-476f-436c-08d9b30a6313
x-ms-traffictypediagnostic: PN1PR0101MB1662:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mcdgbXAD2ZsKVmfdvCyMhpewSt1Q1568hl2i91G8MTQ9MVHyiHpGDASOnhZA5xo6HzxLKxGapBQQv4sfLViP8GcSMmGGRvGUbDVpRaocdnqJCwtSl3ia/3dUyyBG6axGvGFfkDxEHjM17HOOMMX0hpjSfA/2Un17w/1aWx13i4rJbpwxV6QayyB42FNUzEicPey9zlAfAcmf+O3uHF1Uy2x7TkB3fCygWIU8pvIi2SZBkvPHFw1Dlb7eDizfzo3uxFYv8nQwtrk2wcDP0aCmxzUxlLeUbBsbv7ivP7IPZSwPN6Z0BYf0XVsVlXhkZSg0chIWhuz2rO3H7h1EAJOLxoqX+rsMzSq/4OlTmGqDQm3niIewCFqaVZh9tHBiQjs+ySPgX06kKx5udia4fUwfbvF5FOrNI+r3Ufy5m7lGmOgRwZ4mkxSqq0xfHsVYVBMEaEkKqBz2Ca53dj59tJ+jKIBzwwHC6n7YDSO9W4pwTURzehsFO9IZVBoFdym0QaXJnG70ZvNh+XQcwecbTV5qLgcA70KK4coaggtA3L2tDuI5WWAjCp9ev+5IGtoS37j3RAtmuuaf/BFk3na8Ey/MXA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: LEWUmfdJOndhqsovCfECzViSn01v77GCoR5tAk7IK+aVms/BN0bzdfOuoUdVOdIU3JhmGrkeT3WhuUZY+NKWZtYiEGLYOmLIoRhNxsZMZ4SeES7y36hmTtYLSIOIjOkL076vWY8YoQXKWK4YS3aEtCxq8bjQ6ZLGJhx+Gsq+rWC1AY2TW1V289qcEJLPkgp5w5cEahahjrM6sE1mEVbjXGRW/d+teuGhrSnzKYkAHFbi4JIfHgTbxoR+GReEb1GmdkRAhKX56D93uuOo3fpPUBGOBihghlVVRR1WT9jlYahO3S0D4PVIOf2crmu4KNlABq8WjDHmLg4SXVtqTYUu39gz0/6/t0qwNxSl0w8EEww9NxXkkuDg+uvfBCCq9LCFDtjSUTbbom6Qx+8dF4uUlCCZb5gljl4XA8+UcWlUfZ/TD+g0jCjuZ4Pfk0aZOVhqCBavANVd7tOsa5PCVXlmOS/W1O09fmKr/EvtrwSVG1eh104MvKmVfOc9TRf5oJu1DBwmxAXFScjPLaH+mVcAOnrKlM2g4AF/rdxY5FFO5RIWpacYFF7p+ce+xxy0W6MjMOg4ZobuXfjivyQz+YGtapzNWtjt9ndcpxa5+/yG5hx9bF0ly+rrZzncI6q4aD/o4ZignYxfvswpfC8P5gA6gJB0v9Cayc/R143ogXVVUBE9bXF1mAjjpAwsFvKZ/YKt7ZtqCDHNhpxjpi0VNm2g6RVNrHX6gzEWkcEcqPOkph1M5ovQ1E8SPjga+7Xd8H8by41Q7hUja3oE2KhxJlI/sg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <78A1319314FF5D48B2BD956C0A1C1864@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 49584d43-29e9-476f-436c-08d9b30a6313
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:32:24.1782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1662
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Bluetooth on Apple iMac 20,2 is unable to start due to LE Min/Max Tx Power =
being queried on startup. Add a DMI based quirk so that it is disabled.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 drivers/bluetooth/btbcm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 15c5be927c659..601337b5a5130 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -381,6 +381,15 @@ static const struct dmi_system_id disable_broken_read_=
transmit_power[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
 		},
 	},
+	{
+		/* Match for Apple iMac 20,2 which needs
+		 * Read LE Min/Max Tx Power to be disabled.
+		 */
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
+		},
+	},
 	{ }
 };
=20

