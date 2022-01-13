Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941C848D707
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 12:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiAML6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 06:58:45 -0500
Received: from mail-ma1ind01olkn0156.outbound.protection.outlook.com ([104.47.100.156]:28352
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232725AbiAML6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 06:58:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zg7UxpPOvQgwRCpYrmf0lHAkz+07c/fGi5VZCV2dJd2l4a2ZCOiYUdJor2UM8G8H79NZLQBP8c+wrGgkEqyW3CZXtqYnhuT3nhDq1aCbG7mP+AlDts6kN+CN3SC1PNk6D1afSiy3ZTuDaX3OVv/B5QJcrxeRDNkSNMVKuMFI3nRIGtELaAUvRUv8Um6I2pDLl1THmpb9tuZ8aNEVp7WiE2m6NxVLuX/8U+U4xMhhBHM2cW4oT/m9OzKLpY4GAHlAUgq30bp4RzXuYirL3uQ7QVCezTLcuw0KeTOI8vX2SzLJnVTqLkcC+wXt2/4YiB4zqWD8kfyachfUKqK5Mv5l+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OWBWLC8TVSyiMSFaxUD4odgacXWM4VcVOtsa38yeNc=;
 b=lCar+Hn00XxBaP/80WXgArWVICvmLm3SPGGERq7Rax0QvmKsl72Wa2gkM8B/rW0p/YU89k1j6i8pXYd8TFe3mfYnylOoqHperpjuAFI90rBQh8xMHlgjdm8JfEz8RT6mSHgFKgjtmBsmfZiSShLe0hSZ+ZEHHFRD4H6mDUPmzMmQH9NNVXG2Leyniw8M8oHu7SihWVle8RcRkpyT3nd4ZnqGoA/z8WWmjKk1I22wHlSRs2xUhvZJ2hF7R/zGjg8ugXXghosfUvvKC8YMqkZVWpuioR26V8zmYtAB3bP5gjhZVKLnVt8xdKdqf+7qEcFG2+SbHEMBa/91P50BRizzJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OWBWLC8TVSyiMSFaxUD4odgacXWM4VcVOtsa38yeNc=;
 b=s2GzKR1aGz4k7ivYTJhkPAw6jOxTy+G6VG30wIkOpYppeZ/u40oQCvXUnQxJiTJOSk5f65NT3DAtgPtAT6ImcqWo+iCFqbHmgZgoD+Xn+oi2hH54UsG5gtQ/HFaCiuGc8JBQMZD6myXgzMFjKKaCy4/eP11NntHgneU4T4O+9eixu6lpG0pzSMnlIHceQ6CEb7nWDIWXXEQ2kagcv72Y7kz9ozicIwBZKkgFbbhsn8CCpM/5jT9file3ZiIGDAeSsLNFdGILQ7oMiPZV9T3wyOM0/2s75u9gnzcrX9YV4J/zilvJDGgXpztTRcJjlFu/+So0Uoy6cgB4ID0BPyuqKg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4815.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Thu, 13 Jan
 2022 11:58:42 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 11:58:42 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Marcel Holtmann <marcel@holtmann.org>
Subject: Re: FAILED: patch "[PATCH] Bluetooth: btbcm: disable read tx power
 for MacBook Air 8,1" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] Bluetooth: btbcm: disable read tx power
 for MacBook Air 8,1" failed to apply to 5.15-stable tree
Thread-Index: AQHYCGsBzkCikz4UyUex6E9pcAA66axg2PqA
Date:   Thu, 13 Jan 2022 11:58:42 +0000
Message-ID: <4D447315-5A77-4577-98E6-F5B6AF53F40D@live.com>
References: <16420708528155@kroah.com>
In-Reply-To: <16420708528155@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [zXXQlCvJKbjw0PE7Wi0KdiqZTUp4yS/qSkSYVkNaUGHtk9wwAl5lamj1iw6jxLYm]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6fde2df-9b5e-456b-cf09-08d9d68c0b32
x-ms-traffictypediagnostic: PNZPR01MB4815:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F+v/b09kawR0ASVpjKTCSfgoesMl5w86NaAoi8Up2hF9erlq2yGBZE0mRKMAJNNqFdxGSH3jxWQQ00dBI/MuPl/vwvnHn9RT3Xns7pxe23SDWUy7VIEsseASpFi/MZ0/8Arj8CUVNPDGu/noQge1kMZHBX6w6ULgwcA7Z8fIWvZBO61xOfulek4E7orcqA/10f1/XuxILTzT+1DUfgQ1wynoQdltlU1FdRWTpBZocNl4aD7hrDPgd7ZAYjo1oyLbP67OaymKuKWDmt10Vn0DcODnGnTTg/ffSWCa7wY47fSfqGMQ7X/nS1SbA/NunLKS9f/YvCtfW4LCLWyLYhduGp/DdSOqrLRt59nHQmmY9M7kXiIkGo7RYrZgzFIzjYG4w/4hxpfqwGhcw37JrhcPKS+NFF2H48NUf/scpAZDtDJK9Nmrxxd3QMopdJ02QaHplKWG97E7++wcuKbysqmYcG7tfPGOzBc8uDVL2koWi1E4dOV6fE+42ZySrFJB0vbabxFC6ogTu9YFYlDpTTFEXP5lYQ4Pxgo9JWeGqT1Yu6bNxCGfI7eXdy5whKX8LBynmKwm7aLP3rV6FT86npv6nw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QMhCAz6oMB0Pso1vYgdaYT9/+xCBZWs1rhFjHC4zvCC/MJPHA9WZGxMaL7PB?=
 =?us-ascii?Q?kFmjOAwLOxXbx8ZQSK4xppOddj1bcU4/xlTd1vCARlox1BOOm8LRm9fJ2S9T?=
 =?us-ascii?Q?yIB1Kd1NQINKjWJ1D1Ap/wCBPq66U149tHFYp5HdhDazEauctCWmHWs7W56D?=
 =?us-ascii?Q?Zth8lxgyYxVNbbolbEypsZUjEA/IyIXoPWtfN3f1q01e/ZWYaVmPfmLtVq0z?=
 =?us-ascii?Q?IbyT8CD89mYHBDJfG69QO+B7uZzEMm6MtCakNFUNZ51SkQFL09BZmpUrrsfZ?=
 =?us-ascii?Q?CR6LEKBLdH8oQY1sdlGOUdxPVG3JnP/xH+4kFPyukBS/89LnFShV3b422ONB?=
 =?us-ascii?Q?CV7gS6vAq66m3GtvEUIxhoR2OsXway4T4IVbPd/wkdODWVBwiDNfW/teejGK?=
 =?us-ascii?Q?RlDAhOqJ5cqXkLnqwjI9+X66bTPF0p0JFEqNmGOXyF9JbRLHwxioFYDDM7lt?=
 =?us-ascii?Q?VAK36N/3gvwpoNfJf1LFJQ+FXKZnLRxaz+D45YeunCYey94p548/2DzDQOQ/?=
 =?us-ascii?Q?Y90gfqxUtwTOpAi5lg8vjCAnQ7gp7pjUVSMW4JEhFpTmfNVa9ZVILbsMAx+d?=
 =?us-ascii?Q?nqY7mIXUJDx2+qKIjDktSFf9q4V6gj1ugxRsL87sun4N1N4k8wOz11jUQmup?=
 =?us-ascii?Q?7LidGMRFhZIaVKdUXIs5P6rzWTF0UrqWEFzUDwW86Eh72JyWoEpOGz/Pl5cJ?=
 =?us-ascii?Q?DD1TBXAqt87xmV4JVFdFuLgFK4brKesng7P9rIeUNgHnjXNx5BcV6efyuXFh?=
 =?us-ascii?Q?HmvUcWM5hGoc6+UVme7Ng5qCZLElMpTc2ZEm2z9gjgDN0w5Jq/tH6m7uVu/4?=
 =?us-ascii?Q?SuGl135LQzT3hKVGfQGAkB1Ha7CeWp7rJwB2P84XlAazBn8mnfNcG6Ivvlx2?=
 =?us-ascii?Q?R/LMreZ3XCYYHFp5RgL2sY85zIEy4Jc1wyTYU+gVPNA/uhMqm9Fn+eudvzmg?=
 =?us-ascii?Q?qzXEKhaMyar4jH6yDNVqWAyfr8xfBP4B9f3gS8z6trWgqiEq75zYOeSkBVfD?=
 =?us-ascii?Q?cFpI4ew+Zye6kRVE5dn/x8Peig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E1868CC70DF5D3488AACD2E8CDC7EE5B@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fde2df-9b5e-456b-cf09-08d9d68c0b32
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 11:58:42.0583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4815
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



