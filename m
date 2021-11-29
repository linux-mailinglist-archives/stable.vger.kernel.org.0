Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1D2460F93
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhK2Hww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:52:52 -0500
Received: from mail-ma1ind01olkn0165.outbound.protection.outlook.com ([104.47.100.165]:12505
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240682AbhK2Huw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:50:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHX8soBSoUpdyyyCY3Q5/35pv+JS35abCeaUI4r2o5qE3TYOcfI//1Q1/Clmw5evR/voMHZrs0ZJ87bP4w9wXezeTvP5o5Lf/3URSdQlrBWoRAivmPsg2pu/3kcp+edInrtkbxzuE3zsoFdn2S0cILll9RdZzkIMBnjAws+6TH+NBHu1PtptkaDZLVogQL8UdqA2vGNCryJCZVSDlXBBqgTzvPZFLCrdOFR/O4ClQr8ivn6ePf2zIl9IOYFns0V95ZLkkeKjZtGhMCgSy4j11pBbGSqPlIbxnfhUHmjRYRnNYs4gQYaGB/MeoHhFDYEqNKuC2k8tKgIErcaAQaabyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcn6AEJqdxNrb1xzl5phb0wl3o54k+0AiKOtnXkV5sQ=;
 b=EebNH12hk+mw70cTQNzqsWEymrWcQ+EQ4UxKQ74MAWXLU/g/UsNinRWe3Ptk+oXt8Lpdhhdt+LISRAP3CFctCx1ScKXKZVFEigKr4+8Cd7s1Q/d2IiHZYGVc3bMkOe7ptHfOrUh7a4dckVU3AZ2phPKTADo8OaxRSKEvfE4efoLvfO7MX94zMPTrqgMV5WU6TBmAgJpgkSLgU2ec46DxELZOf4upON5/tfMaZVZi8EfSSYWxXnPL4DHBfTVty5OjbxNkjD8bVTkXLVZQXbiBoi/81k1YkSK4W+3wqxteuKdiD8pdrANRhI/ZkHXJvrtNmYHCNVJYDb2tB1IYalI4kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcn6AEJqdxNrb1xzl5phb0wl3o54k+0AiKOtnXkV5sQ=;
 b=V0of70KEGbrXPaDKmxXnRn5KI84fql0Vg+EXEPT7EvTAWwasu6H8AmAAcBgNnNz6i4pvaHO4aujqM2KKxXKlyCYv8T1LMUs6fXamzl9BfdhcWygBxOYVr9Tmf1+HkrxKkftKUhncQ/6ZJJVc0tLPxoVM4cGI1Ckdfv3fRw5XeNCO3GUgC3TfnBZxRXEI+tBedBON90UOwRU6gI/TGhNn8ln04+wqq+rWDzU/Yr+Q2ZhrKcrPstm0JYHgBEXFiyi5hpnizWVC18OUv5lq3YdP/sHc+Fmfhve/NyROscZ6m5xfZ8B6j3GlU3NzksMLuXVTwwCEJd4ZDlE0HAlxQszL5w==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1821.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:12::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 07:46:58 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:46:58 +0000
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
Subject: [PATCH v2 4/6] btbcm: disable read tx power for MacBook Pro 16,4 (16
 inch, 2019)
Thread-Topic: [PATCH v2 4/6] btbcm: disable read tx power for MacBook Pro 16,4
 (16 inch, 2019)
Thread-Index: AQHX5PVJoLWkBlTKpU+l39Xu6TbfRQ==
Date:   Mon, 29 Nov 2021 07:46:58 +0000
Message-ID: <BA809367-3953-4313-8183-1EF31FD44D2C@live.com>
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
x-tmn:  [8n+phNukq0G0peGoM6l0wAcUTVWH2RnFOywJsQwU/pY6+ljZfcCqnvuex0HjejoE]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d58cd5d6-2744-4f53-d0a3-08d9b30c6c3e
x-ms-traffictypediagnostic: PN1PR0101MB1821:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FB2vOWdLfr4x55L7hedhXvDd4Pd0xBCr7FJAYFLEOeI0PIPCfwHBK456C/j2BcgyDswKCB1MCIpDumjL9ofc/TFIhXaKZUsONDEqhx1g3LgpclPZuNymN2xSadxsk7QlMyUVu6IZuei+jo/pCjcVRSATNLiRpf6a6RFZFftnfm//ik9eRudibdUl/a2spAYB9moZE31rNrDEqUlLYMLXVSCevD5muE1Zda19yE2hMwO6Moa2XD7auBaApRCAyRk17zzHZIDVH3id94uuaVOf+OWTjbY2/nDmaCw6vJ2uIicwxv4GIllvR5poxBtH289TcLT0Ku0V6/6ezgpMUlruT9oMAAnoMXD3KANRn6T9q4L5zLmDr5q/vMnXYcNjSR6aPVDM91HPm1TftfGsr5a+Cwz+iSfPXxgqETgZRE4EidkzGD4ZbloL1C1AS+jHqYg7UgEG1lHeHVaJfFL4Yt9n9M5FlyNdS7N4pLD4xNuBaxXQk9RIDKaBc4O7k1iF1ejqsPmAUz8apTkm/B7p1qL2DKPZSWZ8PLQp6OLMi4aZi/isMPKomS76Lwz294IMeMNEiKtztziK7LAGWP04/mjAYA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: wU1HQn98HQYvNrqM3uXA0y7kccTJMB+7iCVZY8Gb6pzq09uLCIR604lpesPI1ZPXRsFDv8gqw/oy13cdmrEEFDAQ4DmoABqEd7ts3odQmtyTOFSQF3gAA0roInxn3E12xg66tFdXDS3/8fFt4R2Hon3eCiksuDiGQQNVY/MRx4FksQQau99Fb69aIVZuTzR56ACiPVQ41nMh7CbgYQAQ0aHvLhJRAhGrQqUNN+joRda2ex31e3/CarcYlUA8nJUMTN+jnqSV97nUmwVeVwsvJBtCKIxd4sGJAYM9H5MSyO1g89ufioIhDXkep6seBKTiBiGvDWgGhQLu2DmhiVhWpT15t1lhSPR6o0zbihodP8uU/LKjvFTvALoNrMTk7hNuw4H5/5IdaiTnKPWvqEtuPiiXASZpk9uVwGpw9ntgjOuKDQnuE6FOR6SOMrrmrLW7AVOJ6INyU4VNlnJP9FPDmTyhpP/50IDMVaDquU9ubzbfuvkGB/HZlrhnK6wEKjsnk8udCK6ZDcxqUR6bxfdYUj/Q04BXetllqphB2LIFII996cOXmllDqA1UUQgz3wa+4Y3MSq6IIBspDGYZ9vL2OXMEqcOag7QUPQB2FfikAcgbtOdpQ2BDIB1Yci1IhtD5J4aqT6rSB7OAVmgnE34PDGucZIOHEhPixBC/Wj7YTzJD/RQux9u+Jruf24349Ac7VrRCO8KGwhB0LdW8De8UKrYmlbbzdtRDcvHGEXff1XXvX1RK7slQ6Lefjkqge2RcTMhJHnkZDmMOV4lPhAd5xw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5DDA3E338FBE3043B6280C80BA330D2E@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d58cd5d6-2744-4f53-d0a3-08d9b30c6c3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:46:58.5805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1821
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Bluetooth on Apple MacBook Pro 16,4 is unable to start due to LE Min/Max Tx=
 Power being queried on=20
startup. Add a DMI based quirk so that it is disabled.

v2: Wrap changelog in 72 columns.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 drivers/bluetooth/btbcm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 348a4afa0774e..88214b453b0ce 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -363,6 +363,15 @@ static const struct dmi_system_id disable_broken_read_=
transmit_power[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
 		},
 	},
+	{
+		/* Match for Apple MacBook Pro 16,4 which needs
+		 * Read LE Min/Max Tx Power to be disabled.
+		 */
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
+		},
+	},
 	{ }
 };
=20

