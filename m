Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4066146110D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 10:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242965AbhK2JaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 04:30:11 -0500
Received: from mail-bo1ind01olkn0163.outbound.protection.outlook.com ([104.47.101.163]:58336
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244138AbhK2J2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 04:28:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4TSLt5EqxWxsIUXRrudXOoi9OqlzAkd/wwAhCwIutAgDzwIIaYPvKqvGNpJXGKLN5XmWI7+84xWvRVnS3C5l4gk1jA8jwouPehvhmcHsIx7R5TyuE4R5uymWc3MWUOKH3d2gTEellMgVuPMYrlaajaGxdxYYX8H0DfVuIwjEJI37Xz+CRypYS/Bi7zl+5CXWOiPUOiEaBuoMopFt/4Q86Xq8jeTOJb4xUlflZ8pNDbW5Cd0Darb3f9SBS99lwgmaQuE/zB5c9p1yVaPTHiS+4TAKP6rbHfG4gsLthTRVvMG6+sdQgVzQ8x5r4b9jrZeUoJMyAfIAiaH1vKKCeKzIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEEP8BQoktdGcx/DITBPaqzNWzlczigimy0ShP+Q0Bg=;
 b=neoAckiQ674XYTBcpF+/gblQFCPgh1D5n42KlhKoGgvsPpiVnenBC9fuFzkzVX/hpZGO9WAZm2D4as1jjO9JVq6CX43/04ucRXwrA5ICrnH+B9ypF50y42MQ5Ahisur8TTF7Yfzk2c7k4AqqoEK8VyJ1XFBqMNflsfGMr0KqNVD5+l7PTOI/mUKFrECq5yZKPPmPRSnU6SBjhSGFpPuBfeT5F/JAYa7x8uHHTn9ej7K0YFnNVR46xO5KH4VNz0hnjeQSnrsWLZbfIuhhAgXp1Uxinqg5TAf9lEmANid4E/zsSzR6vqZ5budJtISR0RS+yEtrZT5IU4vRerF3qa4lwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEEP8BQoktdGcx/DITBPaqzNWzlczigimy0ShP+Q0Bg=;
 b=sUEHHNapLr8omiA3AI7rx9jZ3dNkPZ2NjtEukdwqPgrb8j5ByWNzZ0KZv9U85x2NLqkR2fCLcqDGs93SsjMIHSQcuS+iIdoK1siUakKlCR4nQQqeQN6sfKdcUCnqxs+OlcNxONONVk5/PA9KsQjZ9pxmWRCBoZVt1DUrjkop5oHCr6t/Q5ZoGSzqLmHGf8vAV79ohQWwIWzVL6r1d3oyRnTYEioOCi3buBFS5seIU2omyw0ccDAeUa1IsvOajgLz1Jd6z5qPpdNJos20LbAJwMPyDNfLMM4bea+ZAj01NREASJa84DFVxFLYm2sORYeOvU+265LMMdAqgS1yTJfrGg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB5269.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:5d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 09:24:48 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 09:24:48 +0000
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
Subject: [PATCH v5 1/2] Bluetooth: add quirk disabling LE Read Transmit Power
Thread-Topic: [PATCH v5 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5QL0cVooi0jFE02YxHgHvyrC8w==
Date:   Mon, 29 Nov 2021 09:24:47 +0000
Message-ID: <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
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
In-Reply-To: <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [82GAiLRYMA4npadPOJdllMk2AK/Q7bXdEEfouCmevGNWm9HLBJ3OV/ZvDH36Lsi4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 046ce9df-7b54-4baf-cc1f-08d9b31a16a9
x-ms-traffictypediagnostic: PN2PR01MB5269:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8dd0juoN7ASKj2xpLbmUmHBfiY6lk8iCP+QZ2ru4LBnbUdsE8MRkdhEO4mgikzhLX2YiCocT3MTpk4FessPVbtrKt3PL0iiqLrYphMIO+T4ANfR8oPpNLPRPlUtbBqQHTPfPpu5DLs6ERVu+iVVV5iuT10jk8Ystqojjn9sCdYnmq5iotdDz/kklP41NoBDGEXY1ZG+KGDg0r5dCxHm5lWntP7uKfPsixMTqZu5PmSW4048myh8BKrAX8b5rKVejs8Wyv2pieBt3ZlCMAncrK7rQ5asEI0bcBouPtHbwQZiWTubdwcjdYybyQag3/4J2fn9KMAb9aSjlqpGaOtLlX1Htg3i5XIHrqe3bwuGoUa8RfoH2w7ELcq0mbMIBAZwzXJejKrxFpfDoZuuVlXahS5fTpRExXg7dRcD6aMQXa/X1elXMgNhgb92lqA2LzbWNjnHCogQ6eUKOm2rufHNtp6uxyIHNPNAKYxVOkCITHr4HE2QUOzbD3XOJ2XW69D3eWXQ+N8qX7tKKPwoD4aCyFiXkdEgdxEPe4MharfMh5OzGItalFhMTEobAS6xkvXgC32jDvwGX7HdwEpYHdnCSx1bzfGM0x7Nqj3tMoU/YJSitEm07ThZ8nQgr/mrwl7hc
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: jsE0mHDCPOmhyCngyGLjzLe8iO7QfpDritSvYbhpoqiSQG/7KyiPrZN81z2bbj/QIj5NMcpxXuHLJ1UowLmPbRXm0a/3xT7BnbZGu0oL1LvP0EyI+8Vo9HDjek+AYo0zmlqM4ygFhOMR3HdUMSjL5lTlsb35BOXGLcKbCh71ajWx1xOdeslwoOX3zN0I9S17bbBUYzi5htHiX073/eDQU4SmIrSeGib6phVoOq9xlUCFL7J+7ow/F+2kNad29HqzkjhE7FARN2Qx7cVUlNXAns/QhufcVcZ9208GxQD918XtAQM1TUjcKNVGnyTI9U9eTwIG5pqOS8zeBbhHB2HfP5mEJs+OIr27RlXwldfVHKJ8Cv8M4z2l8ZBlCHlXae4QKg/EnCLqfeXG52B69DziXdBlSyNd03oqKhaSiRcKZQz2jaN4F/m5lURA+UlrP40R+36iLXDpPgTcoRR/JNWeYWA96Y/cTzF3LtZU6QgL57LyG1N+I9GHhS3qvat4UDTjWfqGdgZzE0aChDi1VnKWOFJWYH7Ys5mj7in1tJ04H1XjqA8piaOIcNFpHYzJiDRCeVut/haIwNQPnt0yv71SeIZbYV3lGzEMSfcQ68YDRC+uAlYilVkPxta3yHUDEbrOzymC889dI/548J5nuSL7SGnln9kheNY8d13yOJz1m7C6Sx+fClLkrwu4/jLjynRfSoptKwtBUNoq9Gu7blXWuI0Mq7c4ygil1Ni19M1tVM2mPkDwoU8JpyKIvoFvTrC7+76Cny72RnI5XacSmxpw1g==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F4A9BA69CF5F2428BAA0985B81DAC44@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 046ce9df-7b54-4baf-cc1f-08d9b31a16a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 09:24:47.9985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB5269
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Some devices have a bug causing them to not work if they query=20
LE tx power on startup. Thus we add a quirk in order to not query it=20
and default min/max tx power values to HCI_TX_POWER_INVALID.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.c=
om
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
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

