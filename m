Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1649E48D6F2
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 12:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiAMLxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 06:53:55 -0500
Received: from mail-bo1ind01olkn0144.outbound.protection.outlook.com ([104.47.101.144]:18800
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231868AbiAMLxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 06:53:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCu4mWSLIHrgKV3otso+xTtAMeLkYZUffNkMN4Bmw+RqH7StOjhfa4qvGSkMZf/1ZOAoVhu39DuMcgxrcnKMGzWThAD9kxeqdeSt1D9NdNqEUOSCUxdXX8xnMn86uyIDL9agf1PQCwiqVB1OZ3seWOzXfWPLXoDPg1H/QMN6LHx/m8Xj3yiD3WWQti6XMql/TepaVU5HZE+OT+tBjk14Dc1EAVEl7VkB8wsJXjTlqysASe8Ro/Ge3HPs1QJtOpRJQoZxDSEx06RzjLVwmCt08IibfhGbKxiLE9CNvWdiEC7W3/k8TxbosIetiLCpHL7l34ctTnz+LJpjjiGm9J1rsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yVSR2pxuV9PB/yJgTpD5VfImXLu9Z9dvjNl3mUluWE=;
 b=nWOt5oZ4VxUHrEdJVjNRG8apx4pNk8mckOM9jNHqaPzL+U1xcuvySLRgbDEAoQj7ljDEgNZcRHJ3UyM/egTnEW4O5YvPj69buTx/G68BfXfOcHLiM7zgXxKOKZvjpi2Pgj5C5WWsJ9hLNXqCsUCwJScXFeGSwxT6f0Qcpv9AyaPcfJMEJaJaJaN6q8le9p2D4Tk6x13I6KcncsFwxz6T/3/jbdO4JAjci3SrVS1tLtUzAWJVsF8JscoKeyAKcOZfgCZuk6mJbJM4xmLU4LpXrbpPM/51TacwYokhzJYRKJLTmI4cIP6LcJ7DyrPSE7/MPQ2Sn3Tt6o3FVCuB4pcJ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yVSR2pxuV9PB/yJgTpD5VfImXLu9Z9dvjNl3mUluWE=;
 b=QVAOfcVqT+DCQ/PdJLuRkQ/qmrbCgl1oP2RVAXhLg8dI5Dsn6wS+uQXjbcWqz4tZ5p87ogiq93RPz3N1JEJuAZMUnoFMsgMa7GsMYC5AVoYJ15ZHnSRGXqH5qzriwu262povOzB9ljKzUTTtoIeazdTwlLiSZ92EMkwkDVTbxiYtePWq6QdCbE24gU1i93Lo1U+wHz6x+zIljGGTr1XTmn5R/tN0Q6WRFc/e/BOq/9QFTfTaltYJUKcorND9OHKx0GTbbfLMsdMB+iV3GfDVh1gemd3TYG4g/KX9EtSSaJnLZXsCy3NysR2Sl18I/OWcMdl4tWjgQLm/3u/ZYESs9w==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1216.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:18::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 11:53:50 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 11:53:50 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: FAILED: patch "[PATCH] Bluetooth: add quirk disabling LE Read
 Transmit Power" failed to apply to 5.16-stable tree
Thread-Topic: FAILED: patch "[PATCH] Bluetooth: add quirk disabling LE Read
 Transmit Power" failed to apply to 5.16-stable tree
Thread-Index: AQHYCGr1QUOgM3qM/EOIMtkyF5Nj+axg156A
Date:   Thu, 13 Jan 2022 11:53:50 +0000
Message-ID: <C77BF2E3-DB98-4610-99C5-B46A2578585F@live.com>
References: <164207083324474@kroah.com>
In-Reply-To: <164207083324474@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [hCFBLx7cWrhcJRZyf1COowIGF/Vnc9PT6ulfe+PRr/GYJXimYuIVpqt+A0ukslH2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b59bd5d9-6362-450a-82d7-08d9d68b5d80
x-ms-traffictypediagnostic: PN1PR0101MB1216:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ox+hR0SBBHs6fihEMY10E7NDM3Sutt2hvIHaVR/ZpIzkzVdgRuekXXO7xJVfdNa6VzqSgJRR9MHHhiuShKBPRxwocyFXCIAZDHgREYI71KrRw8FrJ82u92+8hNW2bkDFP7SHdjg4t/NqVXqJtkA7smj30P0QjHZ2KIrL+Kgu+Avl4IA5HEQpUeUzIUGJjyXIgqw/EZ5XKtbrMFNnZJGen5AlBhuZxy1EkL2G3RHn9uHvXPBU4fBJbvnKofQLHgLBQksDHpfaDxKE1hU0099CP7wUMhjlON88Hks41h7NGsan1hXbIKWEsnw43i3J7TjB15bD8SyRFoyw4pUFFDGHDxJ2/SBAd8Ne+CBFLYOzrH8C1Vd62k/VW02YlF1XzsJp+3f5vtSBCyZ4MK97k5XHNUoXnclv4InUw8msYmUVfVboZ8PGpHJecAMhrCOH1GdsvDceVO4AaAd0xLeAscgJeUjgmo+XcK0YA2d+la7Nv3gw1w2FjJF/uJS46Yu7Q5x5fkMp5LqJdW6YRRxX0EfVNmyefRb1loP8Eo3cCRchHepkXChmW+fQiTpE+/bUhrZqDUMVkaE0JeEyzhv4O2he7KDFG/0bMFvlB+FvTUN1G+GLZg9+XTA1MIcqcypxtpaT
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X1XFVUqouUxE2GhN7HjyZ0lO1W6O1DmLia0ZRnKDPh1meHqa4S3vK8dWX98q?=
 =?us-ascii?Q?DvhiflNui/P9wXv2vgbWzW1FJCz7WAWW2Q56AOnRiQgV8F2YN8PFZJKop3SQ?=
 =?us-ascii?Q?TR8xt5+ib7NXfIwZlba/6kjxohaVzj1fAsfVY4LJl6hW0yieVvMXzt914Y1L?=
 =?us-ascii?Q?k1/Fw46Bfc26oOamsaCLCurfiyhQssEbN72DD9OcyOsa/dqu2YovFhit5r15?=
 =?us-ascii?Q?reYe/BkDwDM/KJnlPTZP4OjbVud5c//p+2aFMIthbQBZQGPH8UmG/si8bEkn?=
 =?us-ascii?Q?NEdtLKj1gu3pHgDJ3U2+7sfY6VwcFrF2oq79bnWfCd5AVJKTLv5C23dogaCt?=
 =?us-ascii?Q?yUWutCLmOJyIWLR94TFlR9ZshNlrjx5lA77ro0PAWR8zkYzWQxEaHs+njkyv?=
 =?us-ascii?Q?weR+7JlE4VTqTGl6C0Cq7tDdskp3V6qXDNWoq5Ln6M76So/5yfgKbWa6MXv6?=
 =?us-ascii?Q?jiiSITjd/Qu4B7ibgNXi1bSjpJ8kaiZm7RJu5jXQRz6TM/QeQrpTzCZIhyZG?=
 =?us-ascii?Q?8zgAyv6aJTCSbo84VXEXALxZ7wJdr0Z44rEJzOPvXLf+1fHJJW5k9tsMA/V0?=
 =?us-ascii?Q?KKu7a1hmvYgGJitqS1++MgGMQIyiaRL198tXYTeJZsgQzIcMG96lTGUhjukW?=
 =?us-ascii?Q?Riube90k56VxmygWJxIKv0dJxqA6Vd7ttS34N0XBUDdMfft3zDsoaPk/jnVT?=
 =?us-ascii?Q?eO8rugZ4tRxJOWYks2wMTll8xIeuqiChuUh+tHiwes68R4o4vmeQkNgQPGtN?=
 =?us-ascii?Q?Vnoh79HMiMv+MRMAzGr9wthyv+sTQIkAouqU5vBnkK5luLdkCMqMSoysGdq3?=
 =?us-ascii?Q?yTrFEPP1KOqJuatmxVly3pg56lau7HakH4unq50/DaU/hGf3BVRGhIUKZFPS?=
 =?us-ascii?Q?uXjNBYpm/K4rJZVniLpkkrNnlUxMEalGdQQa88Q5CX1FhFE+aIfmxuOFsg9p?=
 =?us-ascii?Q?zlWrgq36PwJ7ah8XqkB4gm0occYlYey/ECLGD6JMvmvmSTF7mg9rIFDpt2KN?=
 =?us-ascii?Q?gt8Fgj/EyJbUjVzu/AwBtl2mTg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2A5E24865EEA354580780B195972A9CB@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b59bd5d9-6362-450a-82d7-08d9d68b5d80
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 11:53:50.3772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1216
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 13-Jan-2022, at 4:17 PM, gregkh@linuxfoundation.org wrote:
>=20
>=20
> The patch below does not apply to the 5.16-stable tree.
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
index 63065bc01..383342efc 100644
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
index 8d33aa648..2cf77d76c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -619,7 +619,8 @@ static int hci_init3_req(struct hci_request *req, unsig=
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


