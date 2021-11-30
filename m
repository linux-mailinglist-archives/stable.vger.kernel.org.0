Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0118D463281
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 12:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240821AbhK3LmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 06:42:25 -0500
Received: from mail-ma1ind01olkn0180.outbound.protection.outlook.com ([104.47.100.180]:59986
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240807AbhK3LmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 06:42:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1PPgfQubM9WTI+taEKbDcAuOsdUGyOJb56dvdh6+dNMxxgVBxpjd0HLC7KaNlHHCTn4Nl+vrY7QKF/haOohTsS28p2OtKAEoUnA2jIn6t4kICWu0z9gHokjePolkNCimGFzwj0vIHodzEfvUmY2/G6JMWPuVNmBdlryK6F3/WWXFrDD5bH6A8qOadVwGjN1hp/XYdve5nAuT4GbN1KcEqUM2ZXmgnclYgaGhxMh1KTukOZO62EN42tzWi2AU2UVukEpP6oNBltGu6u0Ufwrn+Ij1sEAQEhyMSDtWCL/fIPPWX6BDTj1F5nKFHJEpk/Qkfctfmx2jdOIo/u6O4mArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkJHDi7nLC/KsDru/+pcC7FMb0EnENPZsFVS1Yni2Bk=;
 b=idYeRZkbD9Sj05yK3ZdVhAXt0vAVrnEbJiuCydL6U+UGd6Xpz2lKSXp5vPzUvw2ngxYZCwi/yCC7+eWmhigHq8vPyrURJXOAc8lDg/yGuBgGG4JhIjAnkXebvFC2r9bR6KmaihcVfgCJatrpRzxZ/wbOPaEmCFk6+teqK3lKvzrKLA3ZZjUr3ZdP2josMwxzKRHulB7Mz6VLGG9nn08Db9fZOep25hnbRRiL+u/a+AD4zjH1MyMddWwmzUAkPd99o4VnL7c4oKRQU72AiGYOfY9o4lqBng/IFS1ZQ101Ne3Jx/VcYzWMhSZLwznF9jnehDSrMWpDpiBkD0O2mSBD4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkJHDi7nLC/KsDru/+pcC7FMb0EnENPZsFVS1Yni2Bk=;
 b=Xw+b0RUQLtrtmKtAhDgcPnnj9pnMNMCy6r4WndySSBIRWQ/1Dj+4IgRNQadx6PJbsyXJSU1Z1yHNfsTh097s3EFW3YSgibTNIdnerKOeuxY25PV87j5VUkPxIeNrclThnT0C8+OJOdlGDj+NxRUeW1ky+L63wIrnVCstj0lywSvl42xotWAikD/Z+HlwmzWrXboqErecI64Owh98CVRUcuNAKApAvF/Vdd03JJECOm+8vOkinOG8tetIlaYDMu9QkS8ELX327geajCBE73QmQ6NFLFB/tHuSLDVtQs7f9t8dRoQsgQR9jSb4D+5q8KfXcvUA1U3xiVvu/PvJhiiplQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1744.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:17::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 11:38:58 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 11:38:58 +0000
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
Subject: [PATCH v7 1/2] Bluetooth: add quirk disabling LE Read Transmit Power
Thread-Topic: [PATCH v7 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5d7dRY/8j5N7QE+mqt3gN1ljIA==
Date:   Tue, 30 Nov 2021 11:38:58 +0000
Message-ID: <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
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
In-Reply-To: <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [iO4pVQxG4ua4BJdjdWJ5Q+n2zOFZC52KHOHEl7BRUosWJAvP83CLUf0raYnE+mx/]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a721eff-951a-451f-4b34-08d9b3f5ff94
x-ms-traffictypediagnostic: PN1PR0101MB1744:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eUei0G7i4Fa8Llxmpk7aJajHUfoMnakoOB+c3mXUoYmNr3Dht09X6dLh13tSgj1KorF4DN6NrJD09eNDcwjiFmdca+KDhiJNBsBlQM3x5GDVdqdmB2F3Vi7f6fOtbhf10ukNsA/oIk00rwuE6Py7Cokta8FGEhyn/chEOqSLlEU1G6INtgvoiQVeeM602pUe0Mca1d9EyCsdI+iozodQCTD9mIgleUoAHzDJYzwM1p7CLASE5xbQW7YRA075SN/5J1hJXeA48M42jxjrVW3xIsH9mw2/OEkCKuTlk5YafnTGLBpXL4caVscoM42IoMIOxq6r/qC0Yhz037N595a4UaBNJ2Xm/oULXcUI8aI52hrai6cys+sZxYR8ftkOxQYgvonYewj6GOjkRXNou6if5e0lpXP1JIwaoz0GoRssE0WEtDkQmCjvX5vw6XgsbN+gOCw6S6C0to8g5QYDDeGVjWJVmrOI88uFh6cTItj8VTgFwXVwi2DIdL3Uz5s6U3nnMNxGrX0tQ9e2bnzK9L3CJxY+bF/6fSNJG2N1DFINapxFWcb8e5wnCEFHcfDuekfGj8MXL0TgP8pO7dHYGe5ssd4X8PQncfM3/qbexZl31ddOfNzxHZiFN+ubPiGUZtbU
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: Mekx45aB8OiP71CIoRdWs62Tp1z69OoiPJ6F4sca/MBvzWlV0gD/WEL7udLWU4fqM6Y46BHmy5VloDgxy3IIaPLEcoff0XWL5CQ9UgHydMAs7LXai15PWYvHRPHyG/HNXJglFn31UhnnJ/dPlzbOyYPJH/MRWn/wquFannQwXu2hlfXlN+65lbw1oc1NssrpaBdQiH48nEc0Me+7WmP1k0gdQMmF5aGJhyxRLRGtJ606PU4TooSxRQDZDPO2y/DFH+v/sci9R/wpcFoUQPzU9KIbOeuCdCs/BHRGqpCwQG3qqnf97e12WVKdZtOfKVY7RGtiNlddStfi8SK3O2mW2h3M7oIXaeKzmay08vjXM+rZ4VOnOoA3IX/jdWc9PVi6pJ8qjlfU+GTolDcnBi8W8mUSQj515d75pU2MXm7xpUweilBYAVm6i2FZ+Os7u5dqlVdwKAnu0/1Vk48klV5hrpSbE9BTfsPJHqnxnIhS1kXG8o/gsJUoZDsjD2Vz9MqU3PwZIIYHh7pn1xxfhKKlT7Z+tstmVcSWZbr2iP4Rhwj9usyKIu8PfCa6kMk9czfsHiTMy0h/wnvaSU4eYskVEZJri9DWxt1ZsJNWa8hwsW+EkbRATqEFODbbxnujuuzTNY1G0cnXEKnhSQO+WmO74P/RKbbYTMsfD3W6iPCCTuDQabWRbiKxM5wG6JCPOniRB25G2Ycj4lxeqIFUQTl/iChrxHDplxqfSU2SU7UtH8PFEbevNOnvNMIvXDeWMnshoGI5offYiJSxElEbxXvd5A==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7B9F84F64BD1F44BA6C891128277F591@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a721eff-951a-451f-4b34-08d9b3f5ff94
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 11:38:58.4709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1744
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
+		!test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
 			/* Read LE Min/Max Tx Power*/
 			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
 				    0, NULL);

