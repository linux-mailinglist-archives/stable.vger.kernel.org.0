Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B432461759
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 15:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240798AbhK2OFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 09:05:09 -0500
Received: from mail-bo1ind01olkn0186.outbound.protection.outlook.com ([104.47.101.186]:6422
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232243AbhK2ODJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 09:03:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwRFzGHnQ0Na6fwk22WefLrBRXAG7zH3ctcwuKkJcSlxJSbTn/K2PDOo3Jq8Ryo2dG21Fhw4VzQ+XQO+CD8aR61KnzkNloS2eo/0bWzEx0lJ4lHMxPz1h3oxBagZ0RJNvDSSbWihJrqkEBvNHV0Y6FdOjBN5SLH3rH+Euke6yPQoxWKQeWDgkZC5EP3JTAMcjEKkv97qe60nxzNpf7omolGaVKNXfn/q44pmbTRK/jOgMHitI8tfEKE0Zc2B38aWglbtLQ0fsIfc20irQNGB1MAYOzEVJ7ybM+4vCJBPIkHzPNDk6XrrQLLcCrQHDYfdSJaMpwMFq3/p64Lks/gHwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vz9M7n7yPp9Zm2m6cf/KIXl0WPchPJz6Ri5vJq+Qjrg=;
 b=crpFoxVTMDfZNoW/G1Qws53bqkFEPhd4SJHRHyj7bV74NI4moG3Hssw/5OJrlwHoMgWiWjUNci/2MmsUcoMGeBjxFynx9a0aE4M94Uu28NxsBX1x75vxmFNBvbA9WEhEYXm1+fT8Odx+WxHo6j7NCS3raskG1p4VhmWaLyZg++S1HhkVtQVdb4v4khL0TSVrQH5818fD4UxzOZHoAX+2rrfHnlrv3YqiPMuKDXi3pEOMoGy4AD91kJ2ZiK9PqIVSweh7E3Mgem4ZN2zNHidESzktHgHW71TqWQ1zVe4kNwR6K1yKA/rCuTwAjCNpCKanM/LLI1yuP/PEKhVdSM6YdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vz9M7n7yPp9Zm2m6cf/KIXl0WPchPJz6Ri5vJq+Qjrg=;
 b=QqQHIqOo589Y/95Bjy78eVBGIWXuT53IIb2jyNI75ysdKD1+MycgufPAemayZ4QBYGgc0eD2/HP9KKovSf8RaRIUG5b3SCkY1tCbpmvQ1peJSvhcOZ7xXNBiLPZZWSAOpDEA4uTkwoBXGCjBvf0v3MwrFiu8aQRPn3jFDD5UzN0hFAFrZm1zmLL3dR0IP8DwU6T56k8v+2/w8e9h9e6/ZCFy3yUVlchkrHbuMt4W927F88xBiWlhKEPjGVejhYqc8tOORvBw4J0tCkXw3nongvv7twiVhO7/9phcbrggUBrFBRMqf+uuqO3ZGeV0xNW0n6UnUO/NXkKCVhHSyEFt+A==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1743.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 13:59:45 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 13:59:45 +0000
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
Subject: [PATCH v6 1/2] Bluetooth: add quirk disabling LE Read Transmit Power
Thread-Topic: [PATCH v6 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5Sld0znbfNTuzU+VUpTtAk/vOQ==
Date:   Mon, 29 Nov 2021 13:59:45 +0000
Message-ID: <64E15BD0-665E-471F-94D9-991DFB87DEA0@live.com>
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
In-Reply-To: <9E6473A2-2ABE-4692-8DCF-D8F06BDEAE29@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [BqdQXUYYPyfuUkC91T0xYeKPfcXquypOQQpTc7iQl2kjKv2eqo2kp7R7LT7xgNv7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d671ad69-9df9-4fca-b680-08d9b3408006
x-ms-traffictypediagnostic: PN1PR0101MB1743:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LZQxYpwUiXDEjLVfAftLeQYsf8nVUnDUdSE3xkt7ENDUUGN4BVWOC3tVPX+eNPfAiw0/4xvh25UznbttIR32qCG3i/lHOu4XqhZhOGWEMG0YhcVtKtAB6KE9Yk7M+JRhXUnOZ2yYHMAj/brJUGFVXcFlmTNaHzFoy3mefXerDdjHXSUwplr5vtq9kUZ0mOP0n/GZFTtvDqKFhOoRgQHouHqza7hRg6O40tMxkgSbqJVY0q5qGCw1QMm54lY7vm9PLWVEjuLAYya8VpdQjq8QyvsNrmBewuu0wO3J+uqu/wKiR7002dyZax6ZejIF1I5BmQ7ZwlJA+5V/u6+bwlMyYsZx/mOzbVCRU7LY9JXSwIeUA4v6lMxRdRPMWZ2s/uE034sETHGJaGO/blenyu21v3ab+nRQ9T7fY5GpZpZBNz2uYKtxfavl9vGEg5JbPJ22XOzgExfUgQfZ+hxoSO/VcLx/9R7xB4XzcaQ/IkzIA8aBvtJ97voNmKzTsebiFRE/ksgxUgZkVnXCaS5KG/h15RRsjXjMVbKD/A1fSPhvqS6FCZAfcyjpncO6ulLW+iI1JwPwxikWZo8wFpeig8qWxeM19H8LBhbkPTvbG0AhoXP87EeGBsEE47Bb9N2p0eIK
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: gSE1QP5fPpKGmmS5DzXxWjLoOWJj4K1QMaVMu/ndlmydYLUgnI/3acRtrgjvExroW/3oQXRFfiI+8vZghMKwz9O9mWdThbziV4uBuzzMVAlX67IfMqXCLep8Pel0IHBew04vUlsntIXF3ISBaTv6fnt6X9S5FAFpz7fbAitY+JABwCB6Mcz0hjbeiRzFToIQ0cn3HVRp3Ui5FxYmU5OeXoRJA39+qxRJoyW1N19nkR+diAPUIS2ysbO24ZX7B6wZVugYEVIBVM6W/tSHYfYDhSfmVd/J2ei5z6+M7A2AJ+7ZQVzm78PsTBNW2KUee6ClYzxj9lv70moErXTK6TmAQUZl8W9Pc8i6tPsD7CDyrlU6/sr7H8Dx/AQ+f+w++Yv2eZoRZuqyKfotkYU6d2QpeEVXaJEoz/y5jwuRFZDBUITx0vBrgkkDjNtM7UDvM0Ha/TCI+dxcyYAykIFJD+FgVKl7sRcOuu6JuLsaQ3Ou6Sv3VuyssL3AAtg+XzGGdSLYrw/tner50kBg2kb/8noxXgQchIm/k3p6lyKTRp8BJcEY/EkBWHc3fGztvCOdygpcGmr/rh/QjXfX4Ejue5E3rErqyPrphyUyCpVjzXby+N3M3zlx3ej65zPCf6IjAl2qp5oTOxN0PwmMk2yhQLZ95c1rEXD+L7h2A6MpDpGztMWPADtVBhVKFvDDV/PPqNcZK6UwcVjbtuWrdbvVp4ZKlsA8/XRW8g3WV3cejNwJobm2/d4GvcBLdIQDYHTSbqVVkvU1bFbaxKrcf/z+3AbrhA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DCB386C667096748B06E33A5BA4ECF70@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d671ad69-9df9-4fca-b680-08d9b3408006
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 13:59:45.6021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1743
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
+		if ((hdev->commands[38] & 0x80) &&
+		!test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks)) {
 			/* Read LE Min/Max Tx Power*/
 			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
 				    0, NULL);

