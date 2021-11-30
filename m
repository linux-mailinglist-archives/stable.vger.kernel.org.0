Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5799F4634DA
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 13:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhK3M5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 07:57:23 -0500
Received: from mail-ma1ind01olkn0162.outbound.protection.outlook.com ([104.47.100.162]:35808
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230368AbhK3M5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 07:57:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKk6vVlCD3fkwER5Nq5umFXk2R9EY2L+bLI7WTQ/4nHwnweHCle5/QGiIsequtqUZYe80CMbN/FxPG9GKpZe3gPx0ZhApF8nsWK0oQgfNV3U0b6MRfuH5nKmqEd7w4Z0AoJJnQS1bf1hpyAodyy/evO1/EJIhuH86zIIYrqakdPBKZTNSbLUBpRHJoNqPWO1N2BtlCA733wBZ0oFcoKfvXZxkRXaxVc0uUz9kxi/bOG5Fqnnu3owo32HDF4uAeiAikFInwBtdhsAURnVFO91sr86dw3jm4sZ9ndbdUI+jEf3+ldQiDRv0BI2dz4y/bl01EAkd+ptCzyFJbWUmZgXqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEJgM+K0EF7ooTE4Luqr8Tv9GNXuzYBbuSQbGc5QC2Q=;
 b=GTUOMgIfS0ME7QkICGziD0pjrersbNLptNDGhiB319zfAGNvPp2ZoLnRbTXPlftFR8EEACyvnxNLwAxI7QDvVBM2dsP95aRmEoVzrro1/t2XmG0Yh0TteaEJ5GqMlvaxHjSHjXxe0QVOkbWMsh1Vf9Qdm3yVSNbrg3Rt6h+iyKlGf6oQE2VzHmOjpoEo0G7Jv/9OU+PLSWI64k2Rv6XiQoAc4FD/oz1jd1ZlMtd5cQ/wN3dgyS7OWnNoo9aLYcq27Ewj/8tHminwNnlCWrpZkHgWkT82xVBacGWaSvaEaFFFyUjDILnnB5GqMqAELT+yDrqmbT5Mto+av0h5dA1vTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEJgM+K0EF7ooTE4Luqr8Tv9GNXuzYBbuSQbGc5QC2Q=;
 b=bQ455G/hxdqGJFYDOz8nln0qQClUsaRnnnMuDBGGuk4clhM2t4aooFpctf9S1xEMLoFlREt2IkzL4PNwB920+wpwjt6uE5OLp5BoeCInem/R+yXBS/MyTIkWoYESZHXogB6/V1Jc5EiwcCp8eKd1geiZRIvAHAgjny8N6Gd3+TfDl1axAOaAixiyOkugBMc8LCMHtBEXuvo2z8rdvvr4XEF0QtziOv4jXLBWPe9si5Ce4R8kUCer7pO7q67+K6RlAzmk1NLDBoCWa6xhtwM58E6cxbOaiA9gKbXJa5CEnvtQ4VEL8NkhwmFftQsr3xTKTP+bnqpZCIeIIjetrPnR/g==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB5358.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:30::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 12:53:57 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 12:53:57 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Marcel Holtmann <marcel@holtmann.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v8 1/2] Bluetooth: add quirk disabling LE Read Transmit Power
Thread-Topic: [PATCH v8 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5elWPQrFIb/eW0qM7ecaQUrXIQ==
Date:   Tue, 30 Nov 2021 12:53:57 +0000
Message-ID: <CDAA8BE2-F2B0-4020-AEB3-5C9DD4A6E08C@live.com>
References: <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com>
 <YZSuWHB6YCtGclLs@kroah.com> <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com> <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
 <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org>
 <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
 <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
 <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
 <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
 <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
 <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
 <312202C7-C7BE-497D-8093-218C68176658@live.com>
In-Reply-To: <312202C7-C7BE-497D-8093-218C68176658@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [oBeaBDJTD3wxlOLxu99T7M3XluIUSmLseznJP3KvfjFe54S83gYTBW9B0IfFxMx1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edcc66c8-779e-4cd3-ccf2-08d9b400790d
x-ms-traffictypediagnostic: PNZPR01MB5358:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xa7ro2aZrciF+aCuRE/xq0ZJvlNsCS3LpbD4b8jJBkfYLgdV+0k5hh9Q3ynxQJdiunKuJFjRvXBs07NqrhLLRykYYMJVZOV7DPTEdLm9AJLIbT1ldSEoLrHArexPxS3WtXiHosdCj/31cIgWMVbIFWQ5HiTSBOnESs+5KQPgs/EnR0KdNhmdTKsMeKL/ou9IzFhYhKABvlk0v8kmKdoKouWWQI94V5+/eLvC82dTJERGlACJmWem2zKd1SXf3BCTfTKyUh944+PUnyfd1ZEa/EVf817ZcQ8FkTMFOmJInLVXgZqv288j3ueGzwL9kh6nFjOsWclSSK/dUa1xtW/WClFmUvsYClhj1724lORpghGOe/1TWPQXcGNRi9fUc5WLYpbG0G3F9QRcAOMB3P0b9FHVUaf2JvnULd+4+bflpbZd9FZO7bTcujBEMcTeoPTMjUtOuX50h9o7yilDwhH2j463lLiQVhJfpIOb59Km1G5Ivq0QrXKsUOMVxMMyYnEefJ1UsdawT3W67p8Gxcv9GJdjpLccRR2pPJRVoxcqFBc0flUGSfzv6gl0W/jvms84O0XyogWhjmRgIVltqZ6XvkMUbcG1go9+gYSx8tSxujuLlV7GDskhQIku9V36UgIv
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: Erq0kBGRXeD6+cM7Zfsirj/K8ljvt47+N/1xqgH4/qRU5rSB9FViPwDFR2Bn0ZbMofpt08fwEROdHlEZX2rP+ZAqfLlAnXL1BaxETOY88b4O0LjJYdkhhi5eiyh3sYlFSX3wFGda8Wx/PWiSJ0DFQrcaJWUiHMxMLadxLlt7dy2F+K5SNcRefAh+fVINlb3FqJV2aLd/dYOptBNA6ECnh+DLtTwVaFqbi/VlgHfGxH9e829G1QP9k14WYyeAEhjUghPGc1KfZ+ge2jcA3wPQIHVaFan3/H1nbSmegt165pffrBbxtVM3/V6Mhld+dTjQXc6kR21G6PJsFcCsfO/7PLmPq3VDGsfHmgFPHXnFRlo9c1y1g1WqjPjY7M/F6Js2J0nAT+5j/IrOiKGVP0pFpQjcwpLrDnCALZrMZ0daJ8TeiPOCxwsN4SK74Hvy0zFteK84AYuWCKiA9BJ6qzQT3l2ino2YrIZSvhDQI5Ay5ns8PD3UEqk6KhuNxOIqzTuGJbPitaP+Uu/bfzZKPgUI/qcRibpJMkDSRK49BGuxjwjfRbw8Ksj9VX96sBuS/BYIe1gXOeXJbaOuowehXlUTZl+5ZuW2c7fWpVbdFWUatOp3uQFjkVuFImyofnGbyBe72PdqzgrFlg2B2ltI7hchsPff+htgwk8HbW5GyZaxXXrpptuQElklsncDe1MaU7Km7ONVRLu4lZdLKcNB+o2EfudNJ5TSze+Kz6lqRTlUXdHTukd91Pr12c3hJ+ZRb4CkZjm8s20ew1Ymd5TVdf5flQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF40CFE5C9CB894A9B9595294DBC40D4@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: edcc66c8-779e-4cd3-ccf2-08d9b400790d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 12:53:57.3115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB5358
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Some devices have a bug causing them to not work if they query=20
LE tx power on startup. Thus we add a quirk in order to not query it=20
and default min/max tx power values to HCI_TX_POWER_INVALID.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.c=
om
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
---
v7 :- Added Tested-by.
v8 :- Fix checkpatch error.
 include/net/bluetooth/hci.h | 9 +++++++++
 net/bluetooth/hci_core.c    | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 63065bc01b766c..383342efcdc464 100644
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
index 8d33aa64846b1c..434c6878fe9640 100644
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

