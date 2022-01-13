Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3EB48D6F0
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 12:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiAMLxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 06:53:01 -0500
Received: from mail-bo1ind01olkn0188.outbound.protection.outlook.com ([104.47.101.188]:31859
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231868AbiAMLxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 06:53:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oB8Yquo46kTOKslpPiJ/a0svWN7KdOPCGfvv0dcNvPmtw+xzVCezb7Mg3LtN5xg5HUAoxmfck7ItaU8aF5gjgzQZnZNxoM/Yn+nXUfYOnfrDz4k5V3qGrRCprMcL8JUDQ0nvefT/rlnvWw+X92G2O3pfSrSxWMOTT68PJwxrW385mBFxiDbtWaQt3Pyzl8h9QNjt5Kjhp3bp3cO/MT5humJTLFtZP99R6xDIRrklVl381sz07izKnvC6dsgjgmpv/TydljhboRNxQu6fLoRGjZTSl/pb3QW1oRmXbICblQriADYvaaDtPELZimNZUehZ8yZO89WQF1No51Ilfnk3gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=guajfRJ3JSdJi3viKOq8cjMnuy7Vjt8TNYQXLJ5vgno=;
 b=Sjbcbdns6JeZbB/0m8hKnaxVMqhnC62N3q80VxWD3jeHm3zp0q6XmICS3XuO8iQTrpJFPwg7nhSDOQPWkpjQoUsY/TiWRV67DeRRyr63qr7upl2SZn5sAEmyUvw1n0noJpag1E4I8a+D6xEv39R8hWIVFtnhxt7zfUrtlIeA1TtCk+aOok9xsNdqJMGzvnr+Lci5E6wStoRoZvd7maH7vpq9oQcBDWcQyPw3Gom2bM3lO6yUAdQxj/QE5zKJbEe8ZGtzWmgAYnhJS72ni79geG/HCE17FLbHR+WIfJPGncfLFafEfPgGVn2H186d6wy3K34lQ1RZSz5Ej9388WiIAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guajfRJ3JSdJi3viKOq8cjMnuy7Vjt8TNYQXLJ5vgno=;
 b=RvDyNKOffU9BV/aRBkARaHraucMEouesh3UzyARc6CeXs5Fl4zuDLTymDW3UQwpQZK3nym9Z8sjceTW6hxsgqia6miZVzY2shn/Jta22K44od7gQ7n96MBl8maZ4D2G5hrhJ7scP/JlxbSLblGp8HhAgzG/kzduY1F07jnJ+2GlABOHLnSQZJj8/32dSzrrBm0SmyiPw3yjNkZCk1YaXppMzlsJwwWjeVNE4cBYbCRn2/sv0gVKOMXSPyNp+fIW8KwnjLnfhJdsWCTsfJYIJfGZ2oCWbkhRYb6jHnzIuRdD6f0yq/NLYsRRRIaawsm2ev09aYaQBLOzRRs3dtvjLuQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB2000.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:17::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 11:52:57 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 11:52:57 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: FAILED: patch "[PATCH] Bluetooth: add quirk disabling LE Read
 Transmit Power" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] Bluetooth: add quirk disabling LE Read
 Transmit Power" failed to apply to 5.15-stable tree
Thread-Index: AQHYCGrxIB0LJlv490+SzyfO7bcOv6xg112A
Date:   Thu, 13 Jan 2022 11:52:57 +0000
Message-ID: <E77EE3F7-D9BD-47DD-B8C8-8C5CA412E657@live.com>
References: <164207083253148@kroah.com>
In-Reply-To: <164207083253148@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [fS5b8bFKPt7EfX8UA255Y5R7DrAm+ObnFsPze0VLcvKu6nQaIk53p8dwuxBgATuw]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52fca5fe-c58f-4198-a512-08d9d68b3dc1
x-ms-traffictypediagnostic: PN1PR0101MB2000:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iTEQaarQ5ZBjDDSE9uWgG17kxUBYWB3mIgeyd+B/Wsv27YD14SKFIbayim79YnuTJ6hfLgC24pPe/ZdeenCPewRq3CIixpvN6t+voj6lhOAFvPg+hCudhyUw/lsEP0qY4FNIC9IBfsncvBMegMLc64335jU6Q78vVgasXke87IlbiLJMOuFZ6vtCe7JCB4vm5fD9FCTLzhLtOccLctbC/cYbLFD/kzfu5tkCxXLfsnIC3l2hEDFayKoPVwSqnZS88yDWHB8YmKwC2Yg629m+4RBkrtpvM1F33gPuJyipgJS+ShkduJaRaX8pKiXOYpb05+K1ubD9PrODYPNMRZGwJAEEtfl6rE162XtlAri5boN7wF65qX9mJSMOktvofBUifap1g3u9KIWg9bA9xKQCz22h3uaMAX57re8+m4H5lEOdASekJz7o8UMWpDhehLaLJPNbHVvTd7Epkp/TbfqODjrFa9+8zH4/2DeMkg81uTe/EK/FzhKYJQFdUd/oW66P0lK1RxfaI/TNftT/sjHeBvNs/1kNOP7LgcjBvkrR0kl/O0dJsACKZYK0UHsKyIVkPp/Zrmq62MA9f22U9Kq20yCi3A7w2vWEHPppil50J8EPrJTs+oN+htunJpqrIGmI
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mjk7bp5l5dXixTghFeapJ0PiNqzqX4rRsd8L5kQPCrxSxzWUe6i7DMmJt++T?=
 =?us-ascii?Q?l9Ye/T6RNI7p3tDaoRukn2DO8Z/ViEmKM25N85zhqVZGLGWhD9XVI48U8ErJ?=
 =?us-ascii?Q?mYIhaXLBvx8GrDPtLV5yxPliYx43uYIjnM7skwm12nJAb8R5XFTvWDJdbD8O?=
 =?us-ascii?Q?FzvqH6oDezcBJxguURTy12TwsfJxGRFVv85mgt+TqaCjJyOBPCVJ09pOCLKr?=
 =?us-ascii?Q?nNpmX53FdledxIB8XdRypm6f23mj9FoqyvWeesjAg4qcvj40+uasvU4rSYvT?=
 =?us-ascii?Q?OrRCiN22CthPXzGS2YcsRTMxHG7GX87JUVF72Yvq25qcYVOF9IRqge2kypwy?=
 =?us-ascii?Q?blELuk0lwBqKFTuTvxW8xrB5XYqFgPNgm+BzSqqlmoFkPyBKCRkTVhkgwEmJ?=
 =?us-ascii?Q?O0a0r5Q0+pYfjKO6bKt9eScJAOFXi05WsGJBdD4Ij0BOdtIWFecbvaRGlrz6?=
 =?us-ascii?Q?3w4COEJZwmOvUJKPv4mIakUahXqNpHb3OMAeapLZWu2txVhXydoU//pajMVy?=
 =?us-ascii?Q?mO4rGupFaCzoHJDsdTHpSaqDy1r6hKOASftNqFwA2zXtyxBA+TD0SBQKmyaj?=
 =?us-ascii?Q?ueVlaetfqgLI89PGIJ54fNQ9HU8HeoIi/0eKLcGoVtxL5sHb4evqModeNPqj?=
 =?us-ascii?Q?qNF6BQEZgEQFcTqECubXUoklWZfrajNCoJW+GuCp0Dom+a0V+PTTJkG47VVB?=
 =?us-ascii?Q?gIR399feVSqIS2an82InOySiKoSNQr5WxyjLUUdJ4V6DPqT62L4eqRcb7zts?=
 =?us-ascii?Q?dkIVjGOuexpfmhfj9+NemGKVAO++amtf9BVynckeRbZhuDK7bBHEmVFDLNYy?=
 =?us-ascii?Q?L1Yn2XJ+h+gy3+knIHgEriXtWD5g3px2D2scb5+c6kf+roLFyEWPSAVndGwz?=
 =?us-ascii?Q?7Blv77DzWTqMWIaTJ5heM7mj5spDHXDKkQ94EYxlYdYI32rvIjSgw2ofoHdX?=
 =?us-ascii?Q?JPV8FhO/CHbvJ3yCXEA0WguHh+xUFhdnbKa9GM3O9KyEgqNgaInHg1y7K28k?=
 =?us-ascii?Q?DpYRJeexUAjIyac6IYsUfaCF5w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7A71C13E1A95A40A1E623C8EB7C393E@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 52fca5fe-c58f-4198-a512-08d9d68b3dc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 11:52:57.3469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB2000
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 13-Jan-2022, at 4:17 PM, gregkh@linuxfoundation.org wrote:
>=20
>=20
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From d2f8114f9574509580a8506d2ef72e7e43d1a5bd Mon Sep 17 00:00:00 2001
> From: Aditya Garg <gargaditya08@live.com>
> Date: Thu, 2 Dec 2021 12:41:59 +0000
> Subject: [PATCH] Bluetooth: add quirk disabling LE Read Transmit Power

From: Aditya Garg <gargaditya08@live.com>

Some devices have a bug causing them to not work if they query
LE tx power on startup. Thus we add a quirk in order to not query it
and default min/max tx power values to HCI_TX_POWER_INVALID.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.c=
om
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

---
 include/net/bluetooth/hci.h | 9 +++++++++
 net/bluetooth/hci_core.c    | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index b80415011..9ce46cb85 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -246,6 +246,15 @@ enum {
 	 * HCI after resume.
 	 */
 	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
+
+	/*
+	 * When this quirk is set, LE tx power is not queried on startup
+	 * and the min/max tx power values default to HCI_TX_POWER_INVALID.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER,
 };
=20
 /* HCI device flags */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8a47a3017..325db9c4c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -742,7 +742,8 @@ static int hci_init3_req(struct hci_request *req, unsig=
ned long opt)
 			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
 		}
=20
-		if (hdev->commands[38] & 0x80) {
+		if ((hdev->commands[38] & 0x80) &&
+		    !test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
 			/* Read LE Min/Max Tx Power*/
 			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
 				    0, NULL);
--=20
2.25.1


