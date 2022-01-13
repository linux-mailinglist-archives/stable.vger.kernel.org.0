Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1848448D709
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 12:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiAML7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 06:59:36 -0500
Received: from mail-ma1ind01olkn0165.outbound.protection.outlook.com ([104.47.100.165]:6172
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232725AbiAML7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 06:59:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7wh4//vaxkrcjLbZapNdrR/urk/81Hd/Y+r1iw96JQWoSPZipNirWFFsaXFfvKq/sdhijVEuBblwLtDykDTLx7rrldJHpBVvwuODmzzw3bve6z+cHb7DdAozPsjLwGchuQKRFxXzZw0ptDAFOSEwcP0ytzh4PlPKQpg7+sO/OMQqMiy95u/0c4GEuhTmA6vJ8NKK44BLq+LOd8hx1OqTVI/w0JHZXkEHhCLJ094LQ0QYui8ErvAfpke6vxhiS6ohQdJF7JXSbZk3ptUXTlEjkPJ2dwK6fKkx2Gs+3fBh+O+guIR4GCWlkwKKpSVp/2QpF/3lC8yBGYyhO98YlIwqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhaeUJEZPOnMZgWP2Kbo57HkWZg02Tgw/TrkOdQ5Qek=;
 b=M676HpFu5Voy4FOHWsp12azmfaOJJ5YNF7magtvaOcuUMzegDtORi4IXOpDp4tiQqqi5PQHyhdG95312dZtY7jUJg4LGdYTqQRsj8lDBNhU9AAxuUzBfpMYGcFQVv68AuXRkWCzvlMSDHyzb15AI6K7MNbTpZpaRf/NOQLtb/n1rqHeCst4a+5W6MzODB2TJmVIcOO36C/Lwz5GQcRkxyRv8jvE/GRhEgNb3L74ssPI5ziYD6Ck7J4WDCjaZvZSfgVkhTC8DJ9+Kd4wUufxEdcRHSSNO1wG/xAr5MfUPPOofbjLjITeyObqhlckrBRBfqXOIrovTjsiJCyzx18eg9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LhaeUJEZPOnMZgWP2Kbo57HkWZg02Tgw/TrkOdQ5Qek=;
 b=VtiMkWnuStw2wRwhkCVd/5cE9Qo/bupHBmG52Scg5YCMGlE8C3Txljeq/cQ2ywti1nKQWOg+qNXq0vVKW0P1dmbb5LfRGfYIXRrW316E+O1ZYCUpYR7Al2bE/vsTw7RXu0h8njukP7AxBO6+Z4QWLS1XfxYjW8sp/5JI6755JxI5ChgfST8PZN89SMrULYpzLqTU2ioR6vF+tl8tuOAJcNDWoWcmuwK5ANKKxl8iTcoJHT/P8Tyj5kf1kTvKpBSuxEqmXDt9bOQTx/gzdnOdAdjQK2EN/demJghn0AqJtrKJAdmyb/sskZ3FQohjAgLwANc78gSHNv7fnuFlyDSDqg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNXPR01MB7449.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:a4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 11:59:31 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 11:59:31 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Marcel Holtmann <marcel@holtmann.org>
Subject: Re: FAILED: patch "[PATCH] Bluetooth: btbcm: disable read tx power
 for MacBook Air 8,1" failed to apply to 5.16-stable tree
Thread-Topic: FAILED: patch "[PATCH] Bluetooth: btbcm: disable read tx power
 for MacBook Air 8,1" failed to apply to 5.16-stable tree
Thread-Index: AQHYCGsAeYyCdtcORki+dYZaPqDqU6xg2TQA
Date:   Thu, 13 Jan 2022 11:59:31 +0000
Message-ID: <5D26855D-F876-45EE-A31C-1CF9BBD62781@live.com>
References: <16420708527812@kroah.com>
In-Reply-To: <16420708527812@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [1mefUEsUbPzJRxDxBR9W/ISY67WcEmQe+i+PysB206Tfe5c2CRkzef0J3c0pmrv/]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 523c4a5d-a4b7-4315-1c5d-08d9d68c28a2
x-ms-traffictypediagnostic: PNXPR01MB7449:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dAGqXOZID8P1kYiMkbdisDerZB7qhyM6bmIsNSrAEtiKelvZGqn6bfPWQfPzUWlz91ZpDadbBn4jVFAWeThJyvqtKGNm5PnjByNvuvVVIOtprOJOOJhdm814NkIv6nhaF9fMbzMZMdqhUbKpMa45aCCq2t9srpQ2aRcfCAuCThzoTRVjqOVJhc8ZIYvLZuf6XB/VDmVbSx9etEDZZ5RiWZZeDXGdTr9ZQME9ucCy/203dmeFhUvjP8aisF7aRrTW/u0HpHOuiIc5PHpFZfy47WRiFq9h8jkRq2ZzA0B2oD0CSM22WCsDilP6B0HB/JgmKi9W5JpiEjih7R5OeF89Yk+UasJpjn9RZwB1IE8mtqLnxyxe4ji7rNgWAxvv3Mw7dQFdnjwySKwETgAXS6dpdF1JrDRdrSc5XHeUOsoMVruG6AT3w0+9dvqj2JB9lEhpUCNDjrwyyLaiNipgQyGgDALlAcKyZI01vsGJ5OoaS3De/+M4PLuukXTOQpdQ01UHdE3yicjAYdmTn+LOO7cn7B4HFkGIikN7WTxLLz1IluS+UhQfEsQMLKyGYWwLHbynRNzp2ogY6rmf+mtfttSU+A==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OJPStpi+6ijTSouubp5+C/KcUl5ylKXOTEq9wRPuvjlWNMq5Hyh1aPt3S8Bl?=
 =?us-ascii?Q?h/UVmmI8dSkVyMYq6QevUuebZ36PzpmDdrnMXolNb90D6aW8MUpN2kafx+4T?=
 =?us-ascii?Q?DW1o8LUFu9TQUPBX+v0/5FCZpetapQ/QPDo7parhOjTvcsD/jZtFFPkeXzmf?=
 =?us-ascii?Q?gQjYDEGpKryAoLkCgIE9HYMzR+wI5a+3z2fxpWhUFisPrDRksKg9tOvuRxFH?=
 =?us-ascii?Q?F42XdMe0dIXRIVDcXbIUcKIefULyxqTN8pPApf0beoVJKYLLA14lpJO74CCD?=
 =?us-ascii?Q?nxA5S7QDu2pNr9yzeHHoiibIBPSCqOaL4tM0/1K5wz9gd4/h3/BtoKWUv2Jf?=
 =?us-ascii?Q?hw3+59C6RYC/kTifHpk+Mzph+89Zlm+I/06osuSWWdCL1p//98kutRIkR3Ue?=
 =?us-ascii?Q?ncvbruvGNW6FfioZoBrdSq2H36J8jh/xPvB+qwvYpaYpAiaZd3mF68SePIyl?=
 =?us-ascii?Q?t4+BC6m1n+bok+bkWOFl9ht5a+y+lOLYusLFTBaKhRDUg82FSwPAzEGbyM/G?=
 =?us-ascii?Q?XkSi0AjTCWyt5xV/yZJ1H2LpCwcjvj50sJr612VKHMhoEnunkHEg4GG2LHY7?=
 =?us-ascii?Q?mpe0yOOi6M7AieRZ5TYt/b2uxFW+Yy7RbdCxqGwdgK/R1SfPLHWiTm1twBgR?=
 =?us-ascii?Q?WvxhwggsbbYgNU09gUZVIW7a1dD8kAq0p9eoZGzBszIKkmkUlRo3lJ15OPpI?=
 =?us-ascii?Q?oDdZNQtA8eeFLSq1WNfMgY9LyOr11sumvcs2xq9rcM+GT8aw0+enVoL2U87l?=
 =?us-ascii?Q?QOkhHcQPa5R3UX/BCKRn85JJTZBCVJ+IfGJZfUjAfmmkw5jayy+g9UYvPaqP?=
 =?us-ascii?Q?3ZBkmjIiCipTUjMo9RtdIaqKNsicgXsqTUMAT7CoSvP0qUVaUfkzGP77Y7FL?=
 =?us-ascii?Q?i9yIXECWAeeZsiC79FKd2RlhFNEElE9kK4Zz0AXZYYW+NkyyNqX/ZG+b5zmO?=
 =?us-ascii?Q?uBDsZtDnLxmlR0GEg3ukUkW2dDXMj014YgLaZhurRsVPgSrtzNPxks56CJFu?=
 =?us-ascii?Q?scgTBm4Grdgv82eYFSBtIeU2UQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F1D46D6AFF7B0E41A215DA12BE266127@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 523c4a5d-a4b7-4315-1c5d-08d9d68c28a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 11:59:31.4277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNXPR01MB7449
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
> From 3318ae23bbcb14b7f68e9006756ba6d970955635 Mon Sep 17 00:00:00 2001
> From: Aditya Garg <gargaditya08@live.com>
> Date: Mon, 3 Jan 2022 13:28:42 +0000
> Subject: [PATCH] Bluetooth: btbcm: disable read tx power for MacBook Air =
8,1
> and 8,2

The MacBook Air 8,1 and 8,2 also need querying of LE Tx power
to be disabled for Bluetooth to work.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org
---
 drivers/bluetooth/btbcm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 07fabaa5a..d9ceca7a7 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -363,6 +363,18 @@ static const struct dmi_system_id disable_broken_read_=
transmit_power[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
 		},
 	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,2"),
+		},
+	},
 	{
 		 .matches =3D {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
--=20
2.25.1

