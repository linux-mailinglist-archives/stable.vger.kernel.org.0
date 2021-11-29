Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9054610C9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 10:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241433AbhK2JJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 04:09:10 -0500
Received: from mail-ma1ind01olkn0178.outbound.protection.outlook.com ([104.47.100.178]:6420
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229623AbhK2JHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 04:07:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6+33RNm96jqr2vRACCnilcNPSbOJkRfikgPOmJM2PLnbDF0T9kDTYi2XHucH7A6IxsPTl1cN1euhn/e/E2dXteRAXgBZJbGyr3G7rPpq6lIzW2KsjEe6Sah1Yv3A10abFwi1vsX9kAbQZ6bRRuiM9L1VllWQBQcmTXpfxWV7uVQWxapE2kn8gvUNcwIr8cW+m/eAo8E1pDLYfPdgTF+PoqU0N6JhaBrtNq0pRSL0EdpRK9GEGIE2F2LwMJB0+siD8O2Sin5BzQsBS5B8H60J2/ZIeU3atmttCsO5xu4YV7HcDqwOQL6l47gxZZtM60s0EcLlhSJFRhvN6d1oA26Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INe/n2TSGHAyRzBKhcO8JDJ6hop1vwyutLXaYcikLOs=;
 b=NMnmToX5SCEkrIPmpI2J70PgaM0LfS0dYCJruhDFEyOay1YXwLT//0yQ4IYfRCVRMmLWUO35sn19XUTWnfutD+tHCH1tnxs6J5SSdue3Oq7HaaDs/lEcAx6ZyLbWWYdQ1wQVqmC1/CACoe+Nk0nYf7xTAAg/F012cg9hSNSCjsZ6QTPt5jbesowekQevtHMIReu0ucHwYmoCdexbFnDr64p8SrGYF5B22jO5Yw5MzXodVlqonoeITou42wrkagdpHYc8k93+BQbI3sa/7AbSBStND2IQEAH84boCYGVfGGtRHN20eQeGvzR390LxURjhZ0brlh1N5Kz436NW61jmXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INe/n2TSGHAyRzBKhcO8JDJ6hop1vwyutLXaYcikLOs=;
 b=pwrYe/thRP0bz4+KLQDPZQEe8aeRARTPSElxXYiNYG0MdgkeLqnd/oW8ywhAubEiS6eQZVr8mzwZkvwH6kpWcg/10FyyvqAfSayC/NGOFQ38TqInOjKRt9P59JbhVxuS/FwKwU0WZ6EIJ5/alwepVU39YtKeO26yK78PxNvMF3CuNVJ2TNiwye+q+tof/qWSv7YpzQkzGXDv5EAz9wBSlYeQKqywLAMGfN5VJHIQDNybqEdbGuXNaK7hi6/UjL6YiPbe0LCliEtd8JBc0u6NXtFqFjWKYtHLXcvhp4d/LRUaok6KRphmDaRpI9njPR9oEG0r1TYg2FzMjbU4Nn2Gvw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN3PR01MB7822.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:9c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 09:03:47 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 09:03:47 +0000
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
Subject: [PATCH v4 1/2] Bluetooth: add quirk disabling LE Read Transmit Power
Thread-Topic: [PATCH v4 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5QAEWEYmO8SHbE+v8nkj0KbAsQ==
Date:   Mon, 29 Nov 2021 09:03:47 +0000
Message-ID: <3716D644-CD1B-4A5C-BC96-A51FF360E31D@live.com>
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
In-Reply-To: <92FBACD6-F4F2-4DE8-9000-2D30852770FC@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Fc7pBybBruEGNdoiRY6DeE4kBohtXgvg7CrkZHbyEYHswYIb541ak/4lcWUjBaAe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 548347f1-b2e4-4ce8-d1ee-08d9b3172759
x-ms-traffictypediagnostic: PN3PR01MB7822:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jX9DyUgqNgPqNdHT7A70RcbfV4lq4XmkLWaPR4JTG3lL+CRVdR4+dEMxmoTPAOF/r6mbuuo6A5stM4qigxWmIE6jSSEEHdbi4z3ZQOOJFVbB6SM9d1zgPf9FFzUl06FQg7C7fY70uMK/E1vlqVHiK/suU+m4/n0Rz3Cw5mJq+aptTYedTHTPgr+eB9IxL+zCgrrVD9qLgV18crFuBYa9Fnw7hKq4zPTs40cYWYg9TzDNcL7dRPNC+Pn0K4Zc+VtIilO9yHG/i+H25glvmsq5shzRJ2rLGn4fttXwI8dwN+olAtYxUjymGsK0eB78kJVd5VE7kAlhqyHonTtPfj8Rbm4Bzc7lVS0Aa5ieRY5oMmEjzvLE7uMjb4MgLr3wjTklTxr7LOTIeRwQKS6jx2oz1c2/nxxFe5QzjJl/71C7hP3wbV6aXlivAxoJlnvraaSq638jElDknJ6nmZQ05isiipubFPves4XYmj4Qocv/GpAI4EBnzCzNxxQUb98pqZjvBmokNV2x6KlnHCsmDWbga96xnXuNrE4dhRhjG2V8vQrhctB1C/rfw9+yjcuzg4kHnTXSq2wpnqoGazB7inIX1Pshfu4IqEog0ruR94IiTPW68m6rij7npFmMh7KeDBjJ
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 5+wnL1TWsVsWbpoYYHvr6XVlMH6YFH7CebvquLKJo2yceLTRJ5CxvgYgxos3ArDK0KD0D+5+TWhWQ4ELy7yUFK98o1Rpvmon9P9dmWREqoqneUtJueG1lclMGC3cmxmdFMl4qxJ9FwNXwaggHVi/+qgUNMmJfWLv85uDIWNgWe9bP+E+Wlc4EYzD85Dz2P4mcP6yXNKtZrhYhhGXZs42WTRMGz7I70oi84/zJpk3S6aBjht+Gkr0zJ9kuMmXi1le5O7dzAIvp358E0AxH/Cb4XVbJcNf8RE4TbJBJvDqXyKA6m+Dvc81JaLLBYcJp/9gEuGE92buE/LiVDyZHO6lfuN1R0bogBTJvUW37fXf7z4q0VSSRWuRCeagcUSYLEvPR7pgFg+Ygnx3urSHAiQWt7CXzB8YWdrWktm91pk6nThYf5wdxQHwTRB/lzENBBmFBvaPIOzX28olYefz4sjYC3UCM1JwbjlZbbKNNdGny0UKZknWe6qBSLepHOJqy6d48frx2oFr3KlP/ENkeRmBb/GOIwAna1SSdCna+i7GvKAhHireYqbGBhsWUH+izqclalLTTlAIJuFBuK+u7WoxlyVv/BzU5ww1hk7otMkNIg6SuxQ4aCx+d2LJeCK000bielBMHx5pRGN2ECR+HRTqbv/GzI566SkJZNws4z5kdxVw4TTMpxZveSTiI6lDCvoN6AciHit4a2Lay6xuIQtv8pkjRMPqHdn1LfaZDmYGT0IrYgedbDou2egvK4PtEZ2fB6cnUwxRjJw1yYAt1MTVpA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AAA212C48C64F4583282F62ABB9F62A@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 548347f1-b2e4-4ce8-d1ee-08d9b3172759
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 09:03:47.4935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB7822
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
