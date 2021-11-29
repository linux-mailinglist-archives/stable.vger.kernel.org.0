Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297BF460F8F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbhK2Hvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:51:33 -0500
Received: from mail-ma1ind01olkn0183.outbound.protection.outlook.com ([104.47.100.183]:45067
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241208AbhK2Htc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:49:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQ0T8fijhHFqRrsf6+gB/BqQ9KBEnpX5CAProcyb8Sy+xLiIgzdnQun9jYo45mj+3h+PNFhO7uJrad8Cly3p2ARoN12vikDcROjp47oJvyggyfTJrzjyyDH7wqn5F1UfX4sOf0uNMcPIaLyAeMe8Z9Gb/BUgl6W4D1HNcidkSvH4PJ/gGMV18/wp4CCQkRVq7QOFpKShNDCxf8QstZQDDKmb8vqeNHBVKrtZZfXeHi5H2Qf3JEGcAIHBK2P3zYaRYwgmka1OJ9oF3dzvjdvU4+aMSrzOjDP9AxJZ3P1Xh86F/jcfn5vxO/KAxDK982x7LA25ovBu2Uw1+3Q08YP9yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtnrQ9+sBuX4m4+XIoltCPcUosCcNTFW8m43umLb05E=;
 b=VCOLDFgJTQeL5Y0W0jquYMFtlRVaeP/s6/qfdU1c2daaWLp4P/0e6bYBleh/YI9tKQuQZU0kfSK2GRWBn2fgmoKH2WspV4WgXr9GRG6HuawNeUsb47RhTx3N90IipsiUF3r3cO2S3YmfBA1XyLpvQ1GQsTVGS6UwpHLXG2BQ3OqySBWDXNkHcb7NB7wWYf5OXuVK+3skIq52kmBHS5uH/QKdSvcfC5xtB2DjG3rkGRtt2T47GEzoEuM5VuEsIMYT9n6h5NmubPsRqpBGW0Bkacrpshdcak8tpQIQpSCASvw1UPvt8Zeca0m2A2B6WDuuU363zON/Wqa2O48aYR96Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtnrQ9+sBuX4m4+XIoltCPcUosCcNTFW8m43umLb05E=;
 b=pZusEHCEcKxngLQ8TC3fgJce/6XbvEZR1QUaTLZ7h1skHCm/4prkg333RB3MKFst7N5XkZW+f/9GKD8H7nqUTawopJdt1ZBFqsA9KMklhY741aQ5/PhDXgwbCNGzh01pGgSCKGh1nGMF3ZwUKE8ZET/sJ3HWRuOl9fHu51ZIkvffkKkWXTcZ8qRP7Ea94vt0q5vlnm/jcOESXOSCRFsg+ioAQrvahLwKROrqJoVuii9NJKFi9MgBOKOH97rkKAkOhheC6w+ZrRb71iyYC13Wb4FKxMAVUjWOgu7/5uO7tBTco8F/ap+NhSdl4XYI33ePRfdopDuYudI/qYSv1Bh/6Q==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1821.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:12::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 07:45:38 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:45:38 +0000
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
Subject: [PATCH v2 3/6] btbcm: disable read tx power for MacBook Pro 16,2 (13
 inch - 4 Thunderbolt Ports, 2020)
Thread-Topic: [PATCH v2 3/6] btbcm: disable read tx power for MacBook Pro 16,2
 (13 inch - 4 Thunderbolt Ports, 2020)
Thread-Index: AQHX5PUa/z//CIHYdESpK5xBMpoj/w==
Date:   Mon, 29 Nov 2021 07:45:38 +0000
Message-ID: <8FE730BD-C120-494E-8B3C-B16B48D280BE@live.com>
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
In-Reply-To: <A96508EB-55CB-4542-9274-301CE8E54510@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [SVKyoKcIpKL5gKoBqaJm396nvJEfJqKR+AXHPDVQzfpam+U2C/+OUGzpIO7ZfOdo]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e6aa2cc-5e89-4526-0a1a-08d9b30c3c99
x-ms-traffictypediagnostic: PN1PR0101MB1821:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6FlEoAPIVcwTg/yQoafk5SbZFdgON7R2MScyOo2oOpZSn/fRi5qzLLMeEEdZrhdAvAzR4FkLzuKszOh/lByvVUFXjEhdMqJoqE7M0iQ6z8M/MMa6OC/kGa7h6sWXKi4C0Enmk/1l9/LrDv1MUHjO6GF5hKqfx/ThQLr6NdQoXGZJCRnTg8YKUwXdt3CBrnxOh8S/yoTXYR+HKjUR7g1xDf80M/5Ig0FodekHbcFDfG4RTURgmRJqRSfNyphYr3pk0kfThuoNX2LXslxby/lC+oAWPhTENS0HXisqxcWp26GJZEk7wCZA7afscKa4ljZTzbMipIxrURReEbDlyAEdbBLgQzYUBUfjCtUKuUpva5nfzDBt/5ZI5R3l8ea666h8xhN/twt75BCo1uzk390VvIm1mF6JnoxZLJ/yN+zXi2nTSGU6g/2WWG+08qw/tPJdcRwD8IWw8IgwbZSFKgoRfYVtKHlBVpKcEgvNn4vp5qJJPB1azDVXWdktuHVOgRco6uVXL9ppgAKo6O/q4nt1pqoNJDTHsCFSEq9Tsc0nxQv5+UtIe9T6+Zc1lk2321RDKuxN0KBHefb9zIm7CNmimA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: msbF5XmPEGZVXaCOJX5uQeJ2tGxGmit+n4gW0XGK6NG90QZY8456P7D9RXjzjBIVvBAkxUK0lLcTBjtB7zCckNdCPnEHtKSm3DA2DmcA3Pym/jTGw5UYNALJCELED17sfMVJuMPju/1fBA0GKDksVUMIAuZF/+IV//lsVHknoVO+QoKd3y66lORgBihNgA+R95IknMsSnmOTUeQ7IiZBH4kk3b1MASDcfKLvs+o4l3IcCPHKABqJqMKwqg9vx8fevypQvCOQMHmTsi0z9eUCpHYwUnyrlLCd/DULpDebFih5qjMnkuGzmDtXPSj1kTV/nIxO9Q2D10/NOryXI3t7NPgijL8NuU81B1Q/ZsK8lPx6PV0T30yddmCpWG8x2PsOj1d6YMQ3kijH0/4eiOirRwC3tWpJzlF2jqOr6BULUu/mDzQhqc1nOG1Jrm2jYhkko5CQEq0LUKDvyCuLJCOW7MwbaQl4YINlqlvZx7y0gxW+gBTFatrTh80fPlK6lHSEc12u1+r7ODKo1R+N6UDq8kbTCXu0Mr7BDRWNPmlw6Xb85AJkEUOj7g6pH5u/guJcl3eNynBawJ0kvAQLu2iCfNIzD32ez8+RyYGo91lbFeyHR4eUsNNTuqQCegffApMzK7kZTCpLJqn0/laNF84r0Rj7fWg+YFCYj2+J8fuMJxrasV+/nJJOo9WtOGtFVdM3ibwzLcYVaCmIGGBUI7e0PZw2iuDfpvcr7eJFR1T4ptCA0n2gnifCYJusLmFSWRHbOkNl9tc4uoqFD19KPwb5NA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C2AD29AD1A4CDA448F67F50C1E073261@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6aa2cc-5e89-4526-0a1a-08d9b30c3c99
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:45:38.6112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1821
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Bluetooth on Apple MacBook Pro 16,2 is unable to start due to LE Min/Max Tx=
 Power being queried on=20
startup. Add a DMI based quirk so that it is disabled.

v2: Wrap changelog in 72 columns

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

