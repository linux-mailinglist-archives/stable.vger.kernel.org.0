Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DDD466148
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 11:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbhLBKS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 05:18:58 -0500
Received: from mail-ma1ind01olkn0180.outbound.protection.outlook.com ([104.47.100.180]:20232
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241111AbhLBKS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Dec 2021 05:18:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njPK3cM+Bqo3k/BPbqiiiOby5tgawaPeci9irkaJ9qcY5x5aust593Daox+3VDyXxy9n8B/8R5gMivbvSBC1wkz5e08qGf5eqHOJOkZ+1G4fhT4xR6NyZ1p602BGUBn5QMakBTWcf1SrIv7hRosM5MKAEsEzH8G9iG5gnQ1RI1wqNMRyKDnNGJlVARUktukMXSzYBcvJmcWGIg0kOAqbK6C8FEb6AynCwq/Ah8pz4iqwO4P7lXLxzzB6bed3GJdk0mrbDuJwrulRUn6DXf7XOwxXJ8kvZy+XCzIyxCaAcRajeuDXrne/YCYtLXq79+VQJTAVxxzatWsaV0fmppNphw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3B6TzIvIjKMTGpzOQ0AQSWXhakfO8+cpKsGXejYKWpk=;
 b=dXGXV4Exn7x6b+JOL26l2dQerqtmNov7k7xsMY9sNQ3gvrEVQ34Pa1HeajEiy8/g1ftb5J5yPxLhkigj75V0apiOzz6nGwEb/DEysdNA5GDYMX/RFS2qcTYc1oA7ay4isMtxF+LTyQkzr57mkXUTG+wv9JJzWZ6jr63sQ4fQ2RuIcQvMNR9kWfxE7210xwAt6IdS3fSwYDxCRXoOAwpUdAG4zTOoIQtyAy7kErGxZQQUSjK2Joh4522CBnBA5T9YO+k991XtKLn+fZ80QR3rdDlthWX2wN7+PTjpH/GLzlorWskntsCy12mF30SZ+V8hYqLfQWht2sZ206G4An1PCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3B6TzIvIjKMTGpzOQ0AQSWXhakfO8+cpKsGXejYKWpk=;
 b=CtykQ23q1jOA5m2Xdpq8mu3ggkg5g3W40qP5JBZizJsbQp9MJoJKfq7OUPe8kD/Wt9N9408rtSs034CkmLO67tiYF7TFW6Zr3fFIV5ytTEyORs+kBEXmR1w6bkQv5Hpt31Pufc05ECkD59P+txzKE2H+0LNowF3s0HWRNnKCQG++hxKa/+3beuEznZTl6qsd/q5wRbPeH5/ui1DVMtf0bR/zJ2iAGjyjyg8BSdIxeo/9A3MUm/gqH5CXXFDVNrPXMooaT6YbGG9iizy3RgKJM7IzlUOpSLrTWgiS8KDg0GzDIYj8RJP5oPwP3FGj6nggfvzRWoOpLWeG6aecbOzA5A==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNXPR01MB6867.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:bb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 10:15:29 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 10:15:29 +0000
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
Subject: [PATCH v9 1/2] Bluetooth: add quirk disabling LE Read Transmit Power
Thread-Topic: [PATCH v9 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX52WIYd+d2eqFyUic9u53pxvoVQ==
Date:   Thu, 2 Dec 2021 10:15:29 +0000
Message-ID: <3F7CFEF0-10D6-4046-A3AE-33ECF81A2EB3@live.com>
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
In-Reply-To: <CDAA8BE2-F2B0-4020-AEB3-5C9DD4A6E08C@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [HVuCTyOnzS0yPcTCQGvT45Iq1AiEjZqIRxYsGGUy0jVCrWZ4B/XKN2Ggz+87e344]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 481f5670-f07c-41e8-1975-08d9b57caa9b
x-ms-traffictypediagnostic: PNXPR01MB6867:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iYH8TFsVq9AIsw8kjOz7FKfTvhZCkrNvlPVdXU4NRqLN6tdwlkl9wjrx/6LpqieHpkN3Lq+rVivPl/mcCS5uEhKwSb5zauCSZQoMbvWnCEPWWvepXLz7xfOrkS98vc2nBzzi0s4aP4Mrrep7NOv9WwTDmlADtBaVZFaoYm2KEks9ZaKqjdHmKQBpvyBEriRtQvAM2KODKkn6oHxCZGeWiu3Yewm4a470J5AcwR2NwqFHaHdKJFJgiF/N3LVK+oMGaJ3g8Xi+Q5YSwkjjDfpdM0+eOr6e7BvaIaZPaEzj4Q3RwiolNGzdLGTReKxOaYBMXuXSHz7MBZbUGcT6gNHVjVxXuwyA2f+DCGylY7wCSCJ5dMxDGN7t/K043q7Os0kxCM8B3i/d4iuGQHUeVeCzNAjaMlXSteKlirYlNGJg7t4sGqBuHksXLHKcb5bHjLRBoFZ1Kp5bhbDogaQMX01z6ayxS7NULXQSENT8Xt0lW037yk5jm7qH2KVl85Rcyl+Y49AqBGbO2sSV1aBAi9ddzQzjORr+i+a/pxSmLfkIQb23NxKfhbAKe2A8DRVBKH20myosAkptWknV/ixSpkv5Xtdw5yK2U7POMjaQ0HkbaQ1PJ3rlSicI1e5+qYiC1Rog
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oGFnobzVZpvsr7jtkhK27jNGYLY/zYtUsgBKmIDvbNUsEiPWvNduy/TPVzcx?=
 =?us-ascii?Q?NmWp/du+H1bt2fxD6/GVLUhmmMxp/MyGiA3kVAL8zg3YHxh0BncsgLdkBLKl?=
 =?us-ascii?Q?cYaUmXV37JFmF3WMwMNDbGiwkbY6DhyScVrCdiXxF5mesIE7RJp+M1jgcyw/?=
 =?us-ascii?Q?2dOiJZN1JK5AkLdzXfOpIFQXMv6zF+DglRYu+Yx3a8kqG5zh6CcU+mGV7tXU?=
 =?us-ascii?Q?vXN5LfHuXMSBjEqTVX0ptyy1k8MV+xVycL4QpMw0MQ60P3oCuJCqx2enu/Am?=
 =?us-ascii?Q?mtwvBMMhBQeoAwGnx0eSKuQ0SVzLNZi32FH+3rcHGQ0FwFCm54xdlJCsgFwy?=
 =?us-ascii?Q?vjWvNMHgsO89tDvUzyiWRgGEAXGYbUivJxZF3RJTg3/4gKIPfh+DZ2g288wA?=
 =?us-ascii?Q?97ZISZv6jUGVigByYSCf+O/3fJOt5OhccfwwKPDnrFMzVGKDtIsRICYcFbV4?=
 =?us-ascii?Q?jHiGnb1TEUgJjYa9d/yZByHLj829BvPOz9AjHDThecIB60OxDSiI1xk4CP11?=
 =?us-ascii?Q?7JigBdCVd5kRdf2d9McLSHUKJTBoPBVmV61CSTccx+p0u1Vl0U73vmBOzV5k?=
 =?us-ascii?Q?crNckJdCErLgGdac8taNRf3qvYboq6gXPtKOVDyvDu+gKkjwB2my2SMvvODb?=
 =?us-ascii?Q?PRNzwy+tlh8j2KCF2cMOtI2dhrvJ28MOnBAJcoXnWKubXxCp0H/aaBI3WSf1?=
 =?us-ascii?Q?HeyAjkTixXTkCnSGSJVDRkbxYtdH45PHZOyJgxOORu/cXV8dGVPOAr43bz1z?=
 =?us-ascii?Q?KM2htwZPUvGTZcf6x0lsobUptNEHpcJkCeFcKsZEPvZjKm4u0QDpBSObewdG?=
 =?us-ascii?Q?WHLwS+mXtSlWKWpFODpwcEXglSHixkfPm0n/4NtLdq5nJo5dcxrufBrTQODW?=
 =?us-ascii?Q?QUYtO7YbO96300neo3Cm6gzqqo9IZ353evWvdtZ3d0Ni0N5c+SiXdxrfCR23?=
 =?us-ascii?Q?ITCqeo3woy2QwMWQ3wHlFJ1rGTFdN0jXu7OAPK2DI0nj2RDVR4raXZInihl7?=
 =?us-ascii?Q?aj2z27HLEzBJ9jYUt0jLtm6kAw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1764C2822C0BD14EBC9918702FB868F5@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 481f5670-f07c-41e8-1975-08d9b57caa9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 10:15:29.1872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNXPR01MB6867
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
Cc: stable@vger.kernel.org
---
v7 :- Added Tested-by.
v8 :- Fix checkpatch error.
v9 :- Remake patch for Bluetooth-next tree and add Cc: stable@vger.kernel.o=
rg
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


