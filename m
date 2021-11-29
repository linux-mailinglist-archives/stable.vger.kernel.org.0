Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983ED460F59
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238691AbhK2Heq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:34:46 -0500
Received: from mail-ma1ind01olkn0174.outbound.protection.outlook.com ([104.47.100.174]:4648
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238658AbhK2Hcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:32:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y67lBZKFiSmSyr//suhJiPug5JNgeoFSVXVxJ2ENKg1I9BlxXVA/326IKp2Wn7s2OB7oH7HSYzdqonU3UG17LPPBdxO3L7jA7D5/cUQdwHRPv/RKlpKaHVJFeq3go3MGC4/bT981GjbdjgSkiA/gI+UJmyfu/U7C+oG9LI1EuFSehSRJtOXG8Qzs0M1cJgl1pN8Rjc+Mzo2jKdi2KdaEHrfB1IXPApYfHtVRYfUX83iOf3M/e2ZRbJrUa+D1WsA45bpCgVEkf0N5xPyw95DQ+z98Qk5GTb2DFMllctmWtC7tIFGZC7q4e3IhH7E5onZefThwlyhcnMjks6uUr0H//g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yN+NVdkGOJSqAiMljlZFWIObQ1UxQmA6f1g58EDayyE=;
 b=iZEJzZV2Uf06aAT9s1JDdifr66qsO25ZCumx+LImSH+Hegc1rA6oxGEl8BiOvyt9NwFyJ7WPW3JNvhVIbZ3Ge/Es5lfTbDAM+sue/M5IgFjE4Ip90SPEa/kC07BQYM5r33WItXFT2k4fhRkXh6Wxm5nTfeeNhsjjC4eWyu4/u56kuOibK7DlSUOjOTcOELW+jEz16xGsnlKenJvjaJ8+OLxmXtNdgx8d+GfnFSfgZ8KhwjQWZr6ivHWChqYHfg8Md//LZXeqzg6FE9tvgjngz82ScptTMqAa8l7dW/LM0Uoe7LCAHSnyUfsw58cNddd7ljhMKgytSYxyGzqbx+MUmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN+NVdkGOJSqAiMljlZFWIObQ1UxQmA6f1g58EDayyE=;
 b=ArEoT9rCkGUotztlIAYyKt2evDmeEY+sRtRSOcbR4ibM86hiEYT/1eDgqtsMh310n5ro08YowarIq6QBYHYfvAUqMDsxbLCviyVla5ugTmkqJ3xQgLGNkiirCIjWL9/FsGwZ/o/HQfP9tEFB74It0FYOQo5sL7V0yZrJrIULZ5O2jONBwlzK+2UiiBU/i08+NWIOyN4y7liRPeqjIa6S3y65a0CV/BGueQE5LqaBhnnJKz+IPgJn0jT0OyVagTCF3mypSGxJ3TK9iRfolQksMs51fPAeawT0Jmx9zRyp5DwKNe1XxoKwgYPKe6eH5eYAqphb5SofwHEr3vN6313mrA==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB5261.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:3f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 07:28:51 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:28:51 +0000
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
Subject: [PATCH 3/6] btbcm: disable read tx power for MacBook Pro 16,2 (13
 inch - 4 Thunderbolt Ports, 2020)
Thread-Topic: [PATCH 3/6] btbcm: disable read tx power for MacBook Pro 16,2
 (13 inch - 4 Thunderbolt Ports, 2020)
Thread-Index: AQHX5PLBYsQtZJ2TqU6r9zLT6x9Z6g==
Date:   Mon, 29 Nov 2021 07:28:51 +0000
Message-ID: <A96508EB-55CB-4542-9274-301CE8E54510@live.com>
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
In-Reply-To: <5B9FF471-42DD-44DA-A9CE-0A83BA7A4212@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [96xXC0t0p2tQiDKnts2RHxWM8WHfrfm/PnAgKxo3SpW2N9ahmCQDsgAS1a7tecE5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbb20366-43ae-408c-2ee7-08d9b309e46c
x-ms-traffictypediagnostic: PNZPR01MB5261:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s3RpPAJQiUYs4BwNa6rppvycBVz4e2ClBQ2aZHDP7CFqxAruWhONuCQ7G/x8iZ70I822vuGFfWljq96IQFfA279kTXD/ZAxFNDNEfOUFhcLYzjyB0ffXSwXGv2h2RUMCG9+Sr5UUCwQMn69rEYULLZT+T1yworh1TJeXHfUdWZiUWq/d0xtlmP7kEzrWPB/d/4sFcIBVSVVd4wnnXgvN48JgIrhwDhrhBvh4bXDEOquvkbY0PrG/Tx5ZVomw1UvAcUR6BQGjLujtkfV7InlYf6Es67mF8cwtD25w1TYsQ9nSHxF/RSh/eprxYB/0DeQYy86mgKpN7UHdh0DGuo39VF/9i3/kY0+03mDoZD1tDpgGEwebm39t+fyDf5gGqoTcbJUqZnPebpugsu9vBN02hU9dxu7M5yEzZjZYTyoXGdHQdVUmZnHZlCSrwoZ52HIM3l8rVidSYoFWLDtK8aBeXFu16Bx+e6N0JxExRgZbl6otR7aFiHHSSrE7Oq2XDeJihnHgLqk1tHdH4edc2XJXAAjb4ftjkIAm0+bqULIavm5Sn9YymO3dQsNpwUWNs5BxgxpmE/dlVPKd9/GjBRSOAA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: GUttjJzpzLEpd9+hJOvAjcUbGefmba3Lb4+MFuv+Pfw592cOVhpieVe9FwatwAmIfXKAgY5fe326i0aRF23Y/JdjD7RyfNRRv+jvS6J2dhy9k4lb5J0aTulDCmr2c0QA7HL7SDk+et4T/CqaiIXHIvFnoEIISH7JJy3u0YE7oD+KQQZyjBywC4AzYsWQj0vU6nvq671FbzYedZvd9LNnNUYdbBq2xW2bzA7giHIhyYBUjeIR2xEMw9Cz767fkfC/tr0eg7qyGNlJHpqxCyfcNuLjyCbQlbVe6Bzctu2ay7PwPRv8edvUbVfD88z5rUdqjmlM9SYtTN39X9m+xPFo9VbirfdGcRiVVBO9tHo/NRuJfcAvTRcf6RT5HWVFaLQDlIzWlIBMExEvXLs7gBnUsTpmmoTPSGS4LJU2Q29krW/4OR2r3hQbILOlFrc0+EyaeJ5uhUB7LDt+hWphqY00PIMMrC+afhk4p/snrQBUUM3c8eDMWmGrTVqRiuJhQhIbnHIpAVdqJwpuesUuPd97Bsktdv0lHU2p0w71stuN4D6N9OI78lCQfLNwOQB30NtEWNVxjPh2/sbjh0ZrXiRL3liD4Xg0vzAc0dbZ9CGHp6Ndq4+iU35Bq8p4fCjGzhblB5mRMkuYKoWXciGG6t975WXK2Gb7jroJMcr/7Mw5B7/PRyfx6eNjujVqk1ZNjqYeiydA7IRkadDxFLRqdxPcKmNPhBs8ZKBHXwPVSXfw2fibQdUNMFUcUGIsw3SKj1fIFVjM5nGy20KMosZUe7n9Ww==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DA6B940F1FD9DA4BAC484BF5CD198354@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb20366-43ae-408c-2ee7-08d9b309e46c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:28:51.7610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB5261
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Bluetooth on Apple MacBook Pro 16,2 is unable to start due to LE Min/Max Tx=
 Power being queried on startup. Add a DMI based quirk so that it is disabl=
ed.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 drivers/bluetooth/btbcm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index c1b0ca63880a6..ab7b754855d8a 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -354,6 +354,15 @@ static const struct dmi_system_id disable_broken_read_=
transmit_power[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
 		},
 	},
+	{
+		/* Match for Apple MacBook Pro 16,2 which needs
+		 * Read LE Min/Max Tx Power to be disabled.
+		 */
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
+		},
+	},
 	{ }
 };
=20

