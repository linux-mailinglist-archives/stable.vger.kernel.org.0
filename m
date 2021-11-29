Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB1B46107E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 09:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbhK2IxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 03:53:23 -0500
Received: from mail-bo1ind01olkn0161.outbound.protection.outlook.com ([104.47.101.161]:7184
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244543AbhK2IvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 03:51:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2PNyFSHFknT1bdWN7V+Xs8Au+r49FVQTgDhU6H3q1urRWc1mO0txQB5TFcMkNo64QM0A+9rxN5v7iK1Nba4fyKqVQL/ijWSIDOvBI1143ZI4dyrFJlaGY7sFVyb4MhuTqZtTLK5Dtr/7CB/itjZs8mtUjhZX4hxsf/mSk54Ni2DErj3a8gWapHntGfD/VfZwAfZsHyAzgSZbrliJEARPdHGeMieyld7rrAOtiulfwS0r3WCctWC+ntbqlm4obKiKJd35B3GGDYdXe6gQnQEegPhPzNvPMBH+XswIpPrccmiq87ruLEHddfAkKUylFomWOTgi2XifVhQv1SydRm1BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vEud8zuFRUmj8kSbT+RUarBiLPpItGOiCEfnOIpb0M=;
 b=ADDFAfz1EatXHi3300TE+vnaTSba9fb6ay8gKMYSAoVOYQy/1h8qcUQktSjAqheqZcwCRX8Y2fcGtHbu5smWe1qnmM1ty9uVI6TvhTWXVauexrlZoLjfsZIIcEOXRl69DbAVPwY7zgZ1ugcALtgtP2cee3VYayi726h0zQ25yrgi8H3WQ19vr7PihvBg+R3hgOdMsS6HPZFmk6viGyz+Dgv/Mde6I5h2IkAt6YSDGQ84j6ZHtCS8KvydgZ+sLzo+G20su7yJSd1v6wlQhM2XiP/JuuqAdS4z81k2jpX6u4VO2/AGjmG2LgJ2QsKdCX6ZMgaw8v546UES5gApdjlOhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vEud8zuFRUmj8kSbT+RUarBiLPpItGOiCEfnOIpb0M=;
 b=YcnvvylYjSdQZea+feQW6CyxGvCrhQruNKvuunSgmmBrWNKkwY3UwNG+sLs/1NhKd1+/j5Rz5kMMF7BuKjikbYGeBra3JZClsS9eiYUmR01d4fGqJbRo5ENaog0McBJ0WKoOMV/L8eRFXRfAdwUkV3X9opm7LAnpA5LUrutqe73fYXErks+/fpd4joxgdMVxGRScWWj/yNDpE5eHZGQZ8/vzIhkXC9AjiGsVykP8E1r+FpPrP1ElvAEfXSNcCUXgcK0DCx6Z9ISQ6y4jo5smfmjGxZ6rMhOz4C5ilV3vxQ8hfywwf7NLQAIP8qo5LQSRZO1vDWGWh//JLAJIDmHI3Q==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB5288.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:5c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Mon, 29 Nov
 2021 08:47:56 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 08:47:56 +0000
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
Subject: [PATCH v3 resend 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Topic: [PATCH v3 resend 1/2] Bluetooth: add quirk disabling LE Read
 Transmit Power
Thread-Index: AQHX5P3NVTKsUkd7SE2S0NWSKg8CeA==
Date:   Mon, 29 Nov 2021 08:47:56 +0000
Message-ID: <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
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
In-Reply-To: <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Ios6rTkf3ISP5Qm0/Z3xICyasrT2YoZdoJuUr+pQzHh3g0ABFXmMIMdMAawlsPqi]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6afde5c1-c5f7-4e45-b5ec-08d9b314f079
x-ms-traffictypediagnostic: PN2PR01MB5288:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cu+NsfRVjAHc02AuttabYkrmpqIZ/cA09zD1qdmbBU99jtMwQzwGZNsz8ENZej78vu6nPST8j277bexU5e+RFyPUQdIxXugfI/nC4IjCqexGAvkl6gbivhZQMoUchYmecHBIXnVp8DlRtqs7KTmgtrVauA9PqbrfJeULV2XjKWOwd3Itf092poWtdILzV8gUKbcPIou7JnoWpVOx+KKoEuUPjDZal/qugCZ4dLcsP5FE/IiGpvXPKEg7GPRh0H7avNocln9eNUgmGhV9iMzyE3avnImri0auFtv1Z7askFBnGrCGZl3RQozz8vvKVtbN1dJzapIRmy/eC3z0M8auc9hvtWS9z3DnMvD7eQAhoHav9pKXpXeWt9tJNi063uY57qy5AJGOhCejqXJh9hAajOQlkgI+4dU+5aqDAcDYr1IcCqDdws/2A0AtvfJ3rTEtiY53VveBnY4gxEsTPSfufiC/+4U1+gcfJtjuqLpUiEirNUKsnfZ1+tl3IvCXM35d/joU1Zg5zH/4xtNmkpyCrhpALbRNVyuI+6MBIgEsLqbUmbXsj0IaXebrUwNAfXc7WDcIbqLZfNCq6+fBNnhGJQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: AGGKcvduWmiqLwkddfbyL9Wlm1XxlRFdUIRrWUI7aavtnI7kmCml5uSBrTtllpmcrFNEO2BH5vKKQ/jPdIymQyiX4lB0wtTICov8oOR4FKzKzfon91cyYOrjqccL4HIDKu3FQrft7Z+no4QNf//uthGjamJtfV3NmGWvtrDKfLJfPWri4eJjDp0GH6c0l5TvGpimHZagX1SmJIJPt0pSled8GA6fyQK7AIEpah8dHneKBQdrcZl9BX1kijZpTweczb8G9BjgypuyeLTdhF52aj6p8Gkz7CxQq9k2y01GFil/OIR7l1kHAyP1pmFLvxn4A4ULmu+BY8oK4X7ddrE3y0cTKDjwwBMmb+IWuS+cVSIaDJa/9Q+ClZ1DRg4jWMmlaxoHVgukfwjRVyL03Mh9IsUeqrvMKhNXofRMAT2nRAaAZxk9gQaz1TGhgln+Uvrh9RIo29Q7Niy3M9V96jE6NeUgEfUZqOWYe6aYd0VQWi0/kAiWiC2iSKEUAvRLOEhYAr2XBPrK0LuGQNIdwQHmV+KWt4WZByKXADCZpQmUe/WRqS9qZLyQCPvKMZOQnOpmMbwaBcq+qpfX7Kq6OB9w1fFcJrZF6S1VEozS8Df4LakyntBXTB7Dg30PQ0KjHTeEjwoCSAcvdPfXI2jypcuCPvjaM/YpIt5dkB99fKR+KBM6NZ20V6HkcTBG97Z89RNqD7OidOZzthiHitrEeYBa+kcGkYpoY3P7yzKZ/pdjw9xTka1xRJS06HzdWgcwDrsyG6kkGbDboKf3a6EUjOmLdQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B2C72EF06BC21E46B5CEF89ED862924E@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afde5c1-c5f7-4e45-b5ec-08d9b314f079
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 08:47:56.1596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB5288
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Some devices have a bug causing them to not work if they query=20
LE tx power on startup. Thus we add a quirk in order to not query it=20
and default min/max tx power values to HCI_TX_POWER_INVALID.

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

/* HCI device flags */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8d33aa64846b1c..434c6878fe9640 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -619,7 +619,8 @@ static int hci_init3_req(struct hci_request *req, unsig=
ned long opt)
			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
		}

-		if (hdev->commands[38] & 0x80) {
+		if (hdev->commands[38] & 0x80 &&
+		!test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
			/* Read LE Min/Max Tx Power*/
			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
				    0, NULL);=
