Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3E8460F84
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbhK2HsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:48:03 -0500
Received: from mail-bo1ind01olkn0174.outbound.protection.outlook.com ([104.47.101.174]:25427
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234304AbhK2HqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:46:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cebFkRyh/tt32KzArHC+FCnuLuUxc2D9KeFTsqeZ+Dk8jk0qsUQRC3lCMWEsGIFBtqa1RX0TL+FjpOOjI496Z9/UhmZFZq7spIm7z8Om+HoVTwvP5m0LuOaWJX2+KBa9I7U9JDVBq+iZYo65BKC1PXApI0AH4ChEK0wdT1261zoavukUJXb8kR4clTli8lKFcc7ahf/Ik+ikVQTtl8l1aSuX41PDVRsJB7QlMIpE9ooIEMcZS8TRXJDBZew6RhFBrRKy9P5N1hD1Qaw8K7kOmizDlU77LqFJgWaU17ytEp18ei9h4Bz+b/eujysExnBGLf7RN34w7zfNH3HmBEeSBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oxh/rvNG4sehM3bA7kaCMbA3xm1iubuLc0xhZep49no=;
 b=Vu8VkdHxbrolw3yvLW4rgxfO6iRAj0XhDoXcizUMqYKa2Rzb3mQcJQ3y5VM07Smjj1LPAp+UGn4KvfqsUT+p+swtepCJgj+ugJXNbppLVDV3pbwzE7p0FIIfGholpFWydHKb+9WDjB7yVk3kmJeZ7ZJGrcMaOiLkhRRY+qz4GGaWT1T8etzFNuVJmo5HDy4bdlMD/tIJEzO0SCHXv+aTMcUeMNt1aPG43nU0PE8khE7qCd6GsP4hLlVF5kJ98H3NzsyQnBwxjSwEE8Ejhc3hhsdp/3vsFIroNRubJLm6JGrJmGm6g6zfaM1UAfmp6PibfrxIU/TIWVymeLwpmgWLRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oxh/rvNG4sehM3bA7kaCMbA3xm1iubuLc0xhZep49no=;
 b=ibdA6n/NwQF8eQYyfF0vqrMMIkKKD42guAzFn5bpSnsdBfXgukU9BB3VvkvM2gIWcnVevDd2LeHM1ior6/55geMbcdKwk4qGN1oOgDvsEpHDyXE15LcaDWJDcvSDPl+sAdBDsnCDK1pqRvt3W+gM5c7wKtLzShLeQmc1Vl7Ve2MFxqL/pYyIvfdDr2Tuj4/yoBd9733W+rsYx1mbog3ivyC2ov+gQzHYSUHSlxKFUijcPlUyjOVoLyAJ2px84mqOGt0cHeYNfVBa6rt+CzW6htu3oZBozvsAhkxjXYE6UJkyjFfWqPhSDZnSZLe9uGc5NjZql2y3cunbF+5PffKARw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4731.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.20; Mon, 29 Nov
 2021 07:42:39 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:42:39 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 1/6] Bluetooth: add quirk disabling LE Read Transmit Power
Thread-Topic: [PATCH v2 1/6] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5PSv0tXgTRZYHkSr0erQLuJrfw==
Date:   Mon, 29 Nov 2021 07:42:39 +0000
Message-ID: <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
References: <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com>
 <YZSuWHB6YCtGclLs@kroah.com> <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com> <YaSCJg+Xkyx8w2M1@kroah.com>
In-Reply-To: <YaSCJg+Xkyx8w2M1@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [U0X4rCZC7Jg9cB5hfNKIm2d9xe14ppSKtnQTKFhu/yIVbHe5UjJkcKi7assnX0Nh]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 574cb641-1ab7-419d-09e1-08d9b30bd1fc
x-ms-traffictypediagnostic: PN2PR01MB4731:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uBuOcnlrOIYtmjFhmoOzkdDR9/hcIlmWM+7uybPRKds59VI3KxFVd0SC9GCRbibrACphyCtRCrn/1NCCs+iCHcBW/Vq28paYD2OsVphTHqrbj2ca2Ghuhyt8VR2lx6LKTGZq2HDEgPW0ajNR4buQtDGRDPRv7BkR53237JOVo0VKMwdkh6bS/2490yqPzpN60B0JUVS1pERMXoOQUWCkgMY32oLQnYD1D4iWh43VVCo5zAgKTS7dXXHPFbZr6ganMAHXBcCYHHjdSZT9347eGkwWS8UL7GsAR0eNpQj6MZKWdvTz7GeoK4g7kEWM40W3+tK2Dlcf3iZWS8aQCseUBDE0BlWdqcUXBNFy57njfbMpmmBvIVwvxcK831KrjGyDqCEwtfCy7CPym4TgkNPeuc5HtKO+dRIF1gR17UYjwXCH3liMJIRUpRW/hkCP0XIWUwHhVXP0chJ7xuxZ76hnxLBRJmZLOY9pdMqzwGqVrTMkz+cFWyb0L7vEdykdUDbegxd+fupID5nDOn8XO+0f0JWFC6iuqAx/51A7W3Qe8pPrtHsTwbmT9Zl3+3PNV9BdE7ELDwvRkQgKD5Bc/qWH9w==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: IKifBegIMQdgme2Vz02fe6tCGncYhlfNHnsYo6CjLYMR7orKy+pyp7WQ7YXlctWjtmKhoo81lisa+9WYm9h3o6IAjgRU0CCWyA9tUh9Jo5cHm1/rF9nGPsca2KqtGFJOfqJkPFxF9q4V907dqt2CMEgACXpBp2+d2vFrKEUg+GheYlScFqZ4f0EsvdjO9JrcqI6/BkaquDit0HdZ9OO1fDf+dF2frbvqahWmfLCtKFXOE8/0VC4re5YqEa3cphnPOLALNmO15DOi1TjQiUAuJ7sOa/f6eU7A42yPL/LZNrMhN2NdAd2qaBkDjArbZ35TBypWF5TdbMPaxRlZ9RpUe+0IN9fBhj/jiI0QA3ms6KDbPzOQJ7y4RGnLqdJQ9EaNtZEYpz1E3ZNWhn85aKQmOwEnoqQikdlxLMXwbrwY9NeeibdPfu53/pu+Oz7B6nDtN2EmXTuW3nGF0zMh5jOvul6p+OJGKzS/2W5b2k3JPoUgB9EEknrP1Zjwq4nbJ4Vv9Ln4RlbIwFs0LYBjRaW39icvZLGv4JeK+tNx6gPfLexWWfOstpLN+vKkJlpT41SwzTC0x72ANHbGRBdn1saZ6srF4Skzkncr8h+och02XgYvMjXTBg8lF0I4u5cFbm4+b6EV1Y7ceYjHvA4jwUjGVgUPQOI2RRQCDr5Y/R/kcz+mcxSFOqps4zXnQbuutdvF2+nK7vFNIlwsdPdAD0Qk6Vn4PAbQsZy4jlFSEeTWamSVt1Nc42WPY5Wrg68LUUkVJhPQAaS3ttUXOx4iJ/+5cA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7470254E2DE8549A3237B39727B7D4B@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 574cb641-1ab7-419d-09e1-08d9b30bd1fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:42:39.7578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB4731
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Some devices have a bug causing them to not work if they query LE tx power =
on startup. Thus we add a=20
quirk in order to not query it and default min/max tx power values to HCI_T=
X_POWER_INVALID.

v2: Wrap the changeling at 72 columns, correct email and remove tested by.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
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
+		if (hdev->commands[38] & 0x80 &&
+		!test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
 			/* Read LE Min/Max Tx Power*/
 			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
 				    0, NULL);

