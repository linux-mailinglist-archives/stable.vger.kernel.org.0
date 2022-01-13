Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF8448D6F9
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 12:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiAML43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 06:56:29 -0500
Received: from mail-bo1ind01olkn0149.outbound.protection.outlook.com ([104.47.101.149]:39356
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231260AbiAML42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jan 2022 06:56:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLMilBE2RURXos65+SC2+CXOW7tMwqicONn2be4IeKCZwzbqHcSVBT2Th51ckiccikDWQCfzacFXAcLw6QOuZWeAYKfYJ7P7tyV39kNrPAx4aQO//juOgWC2WN3x2NkGt/NmAKg0+0Psf093MzIkt5BRRxRLWOhELxa7dEY/2VRV08EitwFGKWE4xOhoMdXCixGXUpcTQ9sS6qmFTpqmkC5JrHNaR6nbVI7cLt8782H514ivTOhXHCPLcfj5zOpwnMoAOIwelN4TfEu7cvg048N9DVY81yYsMBqeDk8mm1POZc/VnYYmp6UAbEPmKR6gNZ551ldotkn3QPuEUoDzEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DY0ZxhusX21liauug2tJ1c/r+Ut1Zpvg+uhR4T2OBXo=;
 b=HpHJ2T9crcZrMYTpQK7MzXX35cqyQRXKdPmDn/+6XG97zLfnwgeoFaPFoN2y2DbK+2nD55I+ka1Wo6AXZWGbGcfJIAtjgiK1ltJ8QnjTQQNlGHJxzvf3zWPkDx55TaO1iVDhcqLw+mXHpj3B3kqVe0FKpXaEeYsA3abLqCDUhRiOWoBTuUlNyS3G8OXCMlYM/n775FhPwGl8xKamCWNW8ClfVo97zsO3fvJ64CxYMyUWS5x+EccSq8xBz2FuTiaiUvmiSX7RZ3bOt1+1xRYBng/h94BxH5S/6zBzGaJpJqoNuxo5/HaTA8hFCAunl/OdwTOpTAoAV95vxwnxqL16yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DY0ZxhusX21liauug2tJ1c/r+Ut1Zpvg+uhR4T2OBXo=;
 b=lRjYeyJxif7F1v5gPce1gQLKpLBv8LORXfR91TaboSMPH4Xq/H8Dn2St2XNgriHiinHwf59RCd6ETqnXdUxWcD9aaDAcCZnuEujPEkum/Vc2v3ZvbypDxYmG62YkHs63BbQmDJzRoLpp1C9a1JJ5hLjiHjuA/ySfsoD63hChYPuKP11YEla/CIvLMuPmfIL1vO1lWhx1EmxrDreUmrRYN/UO+Z54hBgGpEkQpMl2l9fGrpkn9HNyCN7uvZDEyWVUmjkb9bvR8IfjpKZ2OFQl1H+qAwVyjaCX/Zd8ylQy9ynbp//6o8sHn5bTmFGsb7SEzmOIy1QldYDGxIhvvFOsBQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN3PR01MB7502.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 11:56:24 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 11:56:24 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: FAILED: patch "[PATCH] Bluetooth: btbcm: disable read tx power
 for some Macs with" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] Bluetooth: btbcm: disable read tx power
 for some Macs with" failed to apply to 5.15-stable tree
Thread-Index: AQHYCGr8d6dyw7RZYEubj9gBTQra56xg2FQA
Date:   Thu, 13 Jan 2022 11:56:24 +0000
Message-ID: <D9DBBB93-C43B-4062-A619-AFDB1DF8DD52@live.com>
References: <1642070843131209@kroah.com>
In-Reply-To: <1642070843131209@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [zz1RKs7EpCPyAI8IOLKZNHP73uvvZxAHVmiheCYYq8/dw+PxZ7xARsQKvMhI8MKp]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3eb22aff-d60c-4a31-617a-08d9d68bb93f
x-ms-traffictypediagnostic: PN3PR01MB7502:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qu+oHugqJ12v5DFBLx2Ni95oj7og1J2xq8t1rdehMV4nceqNqqCwjI0700431RafcJbJtT2ql/VD4hsq7fecFvoJ7XiDXG9R28MvtfSpp723Trir7kvGo4u9ZRUxX+jwQZmpGDRiipwj0UUxzLEjQm+ncjSQxMnuul6ysihhkjyn8ZQXfsaGdgUhFfm7Y6xcnUJLmGrCSoqVcpDHdcDow6FWaXkEheb/2XBXcHA8Y2bzp7NWDJnWHGta2pM6BqKfq40yYAjPGtOyzNNV109/LBSdmdAoaqJI3XTGQN5M7x15X2RPV1G8nzt9adbgtvPM/FlqkWyP5Y24E2IZ6pVaf1GLLDyTx3jJ73LFTJ0KOx1j/IumjOLs6k03cLfkqSl9h8rNxCCt0RZP50WZTLRi04EIOL3qaGUCaCnmlyIdf0lUE5vbmoY3TFxWEfjutBojU2UenweZgpUWoCpE88ZGz4FwScAWyLg75MAdbmSr/uoARHBJjaDrm+dTc4I0DvMiHuL/anC9KLAAXo5vRxQhqOZNbxNfgQjCgGOYfp7fhaFOZyhaFxYs6iMxZRLGv6uO0WgeT960jDXdh88rV+V4CuXQIEdERTBQUthHjb6GD53tPTa0Szz+Ub6z5OVaanVn
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qePvSZq7+lIIiwi+eSBIRZ89mth4EN1IuoeGsvG9dcQtp3hPI1hQBojt6yhm?=
 =?us-ascii?Q?PQo8+uam+J0hqXgRuitT4+Hx6I5jpFeSgvZJZnMEQuuESKRXwlIY6RLKKUX8?=
 =?us-ascii?Q?2qp+N+kaJXOKFuVz2MBDCys+PJY+8koX2Boylxx2WZiDXthRlvK9C+P6khin?=
 =?us-ascii?Q?XHk5z2QANLpFgAdpbFMNBvAlwoWqs+loV8P17s03dS91YJeIPu6mZf77hJza?=
 =?us-ascii?Q?BDRfzBTOd602xh4VReduqNqr42zZyW0kx60DkAvTahHqJ9RHKzoqgfHSl2mL?=
 =?us-ascii?Q?JwyWHTx7BFXHqjWem7DNpcDfYzhHpSbQBS3zdmzm4rIU8KZu5yinPooBdh4b?=
 =?us-ascii?Q?nbERWBT/GrhVLl1FcJexjrxrU5D3p90SwZmUrYBmI2cKQWmziUNPaJTGOEoS?=
 =?us-ascii?Q?WCAM9vjFzpkFuoXd7sozbSd1hK+YVOu2faHwZT0yLknVNhlb2VTEz4bOR73L?=
 =?us-ascii?Q?RVrb+Wa4vuA1RIfHBfuF16iJkT2tW+vStijxflWCXZ0DtfZQsJhJsZ6adpFd?=
 =?us-ascii?Q?SQSdlNeeW178xDQ9ue5ZMqzoVOajKHOjU9mFMJhWrZ4JuwzpXhxRh0MFt3Et?=
 =?us-ascii?Q?EWIVJWt9DoqO3r457ZEymO01ttnNq2L95Rx+ENlig7Cyw1mHPFb6cmGrIybK?=
 =?us-ascii?Q?KRJfEC3I10j8IjqFwz0HyD9EIBMlTT3T5iVqvDzAzJ8+QsFkIljhvkG5nT2z?=
 =?us-ascii?Q?5NI6+1v03nqRY94vtgrXJd9KfHsi+Uit+B08TRrdM2Qqje3tvH1MQ3+VGWLq?=
 =?us-ascii?Q?GGHwCaOfnAD/hMyWhigqmURuxEXYAUbQfKncn/xxJXqiWIx0u18qllRSPg0w?=
 =?us-ascii?Q?IEWGQVXaInMVE8LAHAQ6ku1WumZRI99hUbBh32iHoemFaS1BzdpH7dVKhmjb?=
 =?us-ascii?Q?H5Ki4uSlAOeou/PPRmY9R/uKUe8TqdUhqHJAVk4/wGFsCDLLHifWbjAbYytm?=
 =?us-ascii?Q?bcmKRfVkzK3b3Di2FmXtkKEfp4KWojlN8VWEZTmfHzr3p5/OsiEQM1dsVgbJ?=
 =?us-ascii?Q?PBLGCen2OEQ7S/lDp7wvKzZswQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31DB8A9C17CB1E44A03AE324D5227591@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb22aff-d60c-4a31-617a-08d9d68bb93f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 11:56:24.5645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB7502
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
> From 801b4c027b44a185292007d3cf7513999d644723 Mon Sep 17 00:00:00 2001
> From: Aditya Garg <gargaditya08@live.com>
> Date: Thu, 2 Dec 2021 12:42:59 +0000
> Subject: [PATCH] Bluetooth: btbcm: disable read tx power for some Macs wi=
th
> the T2 Security chip

From: Aditya Garg <gargaditya08@live.com>

Some Macs with the T2 security chip had Bluetooth not working.
To fix it we add DMI based quirks to disable querying of LE Tx power.

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
 drivers/bluetooth/btbcm.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index e4182acee..07fabaa5a 100644
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
@@ -343,6 +344,40 @@ static struct sk_buff *btbcm_read_usb_product(struct h=
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
@@ -363,6 +398,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
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
--=20
2.25.1


