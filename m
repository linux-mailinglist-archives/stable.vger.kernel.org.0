Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FC64663DC
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 13:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347288AbhLBMpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 07:45:30 -0500
Received: from mail-ma1ind01olkn0147.outbound.protection.outlook.com ([104.47.100.147]:54716
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347366AbhLBMp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Dec 2021 07:45:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFbSPacadEenCU+dlh+4sd/eTugb4OLg9xL8JpjKxclcKoRcDeiMoPfabhiDdcpzIBmhX92GhvE526pKsXnaBe7FDQrWqt5rqq2oxcsglDjose05mG82OYppGQgS0eSaejFzbSLX+a0ljhO5XxfmI4VrrL/3jGM0L8lLbhLv+3HKWJ8FuzO7SQ3yXIA4dclyjjpexcai2zLMIpP8DapcDQsnTd51I+KcSGVmmVOH3Xc0ZY+loK8fCMEPt3luNpsRxSXtm4nKMxrac2Y7b4TP1d+j0dzg35i7tqKMsF9TUldRJ05y+2MpYFLxtZxgXM/kQQmQLmrxTyz5SJKEWUt9sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1TG+yfe3IHLJToEDvzfhdSHy2Kzh5fGW/OyBNHEkN8=;
 b=Sd420j186KJLrVgp98Yd4a+DMAfOYhOMEHMfRaILyfB6Fhd0p/wb2MmAmXs6ZSboiNQvgrYLRgIsBmUzigPuD4y5VXkcT6Y7pztPIjLZ4j0xW0mRJmVcfSA7IUkLWkau6oWZTLLnlKnnqYmVWiqiHX30v3QZpqCkGA/T6eQvxCN/jc0p2E+lL6itBH5j0npoUA2UYBvTMIHc72/LkvB/EyYIjNZf14LWiqVlDeCoY8OQcNHwR1IheCUpDB/HP0+KsE4t60wVtWpAHZQzjopAp0Tt7goYkPQKyxTuPVLCjxvza7Xu1XLt9ix0ufv+ASW/Tqh2/gvxa3IlmhyFnqA36A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1TG+yfe3IHLJToEDvzfhdSHy2Kzh5fGW/OyBNHEkN8=;
 b=n1iFGCbJ7ph9ltGkrRfSQQ6fEsD/aibeubvwscZodLqJvUWi5aSo84vOTeaAXhFOL7RxmnGmQGu5vVdVoKYL2WVSO9o+JnkHMVgVSv693y9RGRqyL8MJnHzVh9pUEZYGls4i5vZfUgthdn7na8ITlZWDPzNGoI+SqZadbfER/U0uvic6thDpKxArUUiazazDSUKWZlaB+aKgBobZ2e/VZQm4XO/COD0HwGlwAsm4nBc1jbiwX4xtRIYlk1wOBchM6Is7gKA9OqtlToQry/AjFTu3h3KOiLOJzD6VrbPTrMaFk2CYcDsHejLL/leZGpXdLBA1Cq+lUFwGeZdrMkNIgg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4863.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:30::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.25; Thu, 2 Dec
 2021 12:41:59 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 12:41:59 +0000
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
Subject: [PATCH v10 1/2] Bluetooth: add quirk disabling LE Read Transmit Power
Thread-Topic: [PATCH v10 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX53n/zMAdaRsnZkmnOCQSSypCLw==
Date:   Thu, 2 Dec 2021 12:41:59 +0000
Message-ID: <DCEC0C45-D974-4DC7-9E86-8F2D3D8F7E1D@live.com>
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
 <CDAA8BE2-F2B0-4020-AEB3-5C9DD4A6E08C@live.com>
 <3F7CFEF0-10D6-4046-A3AE-33ECF81A2EB3@live.com>
In-Reply-To: <3F7CFEF0-10D6-4046-A3AE-33ECF81A2EB3@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [x7/d91r1w/lJkwWtjMtxFMWIqjChLK8ei1SZP9ZcECg6B/iDo0wmg6v6/ltOJCU0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e1e369d-0e80-46f0-1a51-08d9b5912231
x-ms-traffictypediagnostic: PNZPR01MB4863:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ef7Xo0EHqpaDMKbc3YeOjfhMwYT7ej5vvWjPkrClibDFZAodgR/EeDcpCscWHhIX2eSQd8xCJLdB3Ks056UtVRNb6VmdVOSkO7p7KXHIkviDSG5Y+jY5RzKt7PEuF+zNVv2S+YTF9IVZoQZbMACAIQuPAKtKmN9g9iyg6VXoz3qdgHIg504eWtH7TXCGsDqgZiH8OMOsN974dCfvtbQ/fqyNbaC/lM8Rn76QjLMeUOMi07+6AJOLjS2fN6mfnA11XICHan8zJvTRoR4rgFT42+jt7tzH11suFuv25NgfxVwAvCnNSlrlG+OfeZr/H8Aj4ig373nC1tNWRIN6HkQ3CYUCV5XShv0p41xFyQ4v7mRzSei1XKw+4ZcTlg3Y9lNSXcYIaF1dzcHi2bnN6uPGMmyPzQIP7S4yGajDozfWzPft2Z11e+VhIlolmGMRZjnlJ8gd8gy3UrlCFWS//qElsbM3+7INmpaEY3U5bIQNAFAfP1T2RIDPe1wdFA8Ehx42diZXD+B6pzjbhrlKwe6djIxbvSqdUJ70AFXAWTD81Jefal807S7JxciJMM9PPu4dhBzLPVyetxOpw3bk+LenHaLGbCXCL30RROfUzm2yTZo3Rjgz2eVhBOUcR5udE2KV
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XiQIf9zsIeWnItutRH8RVaEjkXYInBJce+aBYhyDXqDrRUc4YyzwUxJaxQ9g?=
 =?us-ascii?Q?3qQBLXoxkuTbJ4MQmX+kwjNhV0nafNbCXNZ6S5HZJot0FkNPMzHDBEUkayOa?=
 =?us-ascii?Q?KCPtHYj5MXhhAbRzoEzEZdHmVADv/ValP4xfyXTLRJf+FpXKSBQ8ZWOEuAe4?=
 =?us-ascii?Q?WD7Pme6m+7Ldc1DM7vvzVas84xe1ruEJfPA1zS8oT/tYRjvPB1Dt0grQ5DHo?=
 =?us-ascii?Q?0lTWWOpHxAahG4GzrGk4RPHUqmk/92l/U30lWFgWdvCMdtSOC8QKWKFGZsk5?=
 =?us-ascii?Q?OwcEv2s4f483Byl3c4FVhaigkKr9Z0ASI2trY1EN+BZjH/wMSl64OGXCUrbf?=
 =?us-ascii?Q?jESCbrHzPUB364wtV9FHX2rQn5D6gSAhvyTcdi1MdRH5nzR/TTQxcI7wYoyU?=
 =?us-ascii?Q?Jlkok/yfo9tBGrxNqfBYBM8PdEwL0id2zh0mjFhF0Mh8d9H4ywotwKrPmO3s?=
 =?us-ascii?Q?AcDGKqypnOVVjIHUi7vRsPz+A/pSLzC1TrP5ovLcU16v/sDzbvZLWFw19zOT?=
 =?us-ascii?Q?7qXthmO0ngQybMi8hpx5v1mO3f19yHqhiUKTAG+DsUBMwoCk8hZyP55p3ug6?=
 =?us-ascii?Q?yVyMQVjFz91zrhgh8BjyhayeCj9e2hx+Sc1GQAFOvFlRExACXRue5AXGmnwt?=
 =?us-ascii?Q?+pzvw2sIeoNL+x+U9jVsLlfkygNuUSbqnQSWpXgvVS4TPHTOnZ8RExsJvFlK?=
 =?us-ascii?Q?QgOfRxbE+wycCTLVCJihOniD/VdYkGZsl8X2/SWGIn00iQfFIQWutmjqN5NF?=
 =?us-ascii?Q?WQFh6hqRTWNJs4WpVKFA6cB1PoDXKDt8JR/sbmEA+ftg0PWnWbDKxOGdJQxB?=
 =?us-ascii?Q?w3w/19PKgZ4Xkd1ALfOJeg8tjDuRIF/vyqRpC4bxwGJjouYrbSL/nf0X5qD5?=
 =?us-ascii?Q?a4Z4FKv6qdnEmFEUMZ4ejKgb9nxS5hOMIcTh2NGY7LWrN+gmEWNrjNNH85eM?=
 =?us-ascii?Q?ONi5HLQMyT40aERZKoAZN+VwQNNtzxZLHyGQ9waLxHMzIok/V0Uki+wqarpH?=
 =?us-ascii?Q?54hah/TKc9S+S5/iEthyy8ym6w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F958D55D17CA3A48B85505BF0B3B0A3F@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e1e369d-0e80-46f0-1a51-08d9b5912231
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 12:41:59.7447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4863
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
v7 :- Added Tested-by.
v8 :- Fix checkpatch error.
v9 :- Remake patch for Bluetooth-next tree and add Cc: stable@vger.kernel.o=
rg
v10 :- Fix gitlint
 include/net/bluetooth/hci.h | 9 +++++++++
 net/bluetooth/hci_sync.c    | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 0d2a92168..c4959cf9a 100644
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
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index ad86caf41..52e6b5dae 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3283,7 +3283,8 @@ static int hci_le_read_adv_tx_power_sync(struct hci_d=
ev *hdev)
 /* Read LE Min/Max Tx Power*/
 static int hci_le_read_tx_power_sync(struct hci_dev *hdev)
 {
-	if (!(hdev->commands[38] & 0x80))
+	if (!(hdev->commands[38] & 0x80) ||
+	    test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks))
 		return 0;
=20
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_READ_TRANSMIT_POWER,
--=20
2.25.1


