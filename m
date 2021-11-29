Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2795B461036
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 09:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhK2Ihe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 03:37:34 -0500
Received: from mail-bo1ind01olkn0149.outbound.protection.outlook.com ([104.47.101.149]:40256
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241227AbhK2Ifb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 03:35:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqlgY8SuL33S9rk2/sYLM0tCU65tzmGElaqaR7kfN45o9p0W1h3zRN1haULFhjUbsNeWIqy/rSxdJ57wUWbEh+rWCQlHdJgPkpLkOBcn3dbp8yFZizkVEeMvfnno+rncvdii1ZOc0bgih+nyFsFgXMACAsE5Wpnse5XwDOxgcsz8YyfojqAZoGiKJNiVwJj1z6LfvteM7dfwJ68NYhR1He2vOFlpwtJ7yNSzs5VbWHX6wrrtfXLmygv2JBl7vZeO6huUeARKUwxRGWNQ8WC39DcKKfPuznMyQQuvI02KKriYCdiYcrLh60HVUttFqeKtVlJwd79kpe1oEMTl+R4oZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGB0lcJyQ9u9FWfMzKsvxxIunmpFYHgFOhC0y8QGweY=;
 b=MSZHUlRkOsHzJAT/erbyBaivckIl+MuQ1orjIUcaNPYItX8HGW9SNmNZoAKBVgsF0CSgw3ZE5SzmeQVrle64ylgLwAyQEbcKU9yNh5rta9sdFHd9AsOwOHEKh1cBaYywr0YZhnI8qDyt/pbdApynXEkSgBQ+I31oH0xme7aCxtPF3v2aK1mqQ9vgZm4U85Ww1YkoPS/uBglkA8E07OGYZp/2EpH4hQApOBi3Tjqmm82ZNhXOEq6YGJu6VHQvG3bGRjRS2s9kwrwHXpTOt9xZYxL9DBe4mATnGhwP1Rsnz90Vi9qnZqHJNKt7YuNNXm6egEAvqOILnSm9/q0XRb7NJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGB0lcJyQ9u9FWfMzKsvxxIunmpFYHgFOhC0y8QGweY=;
 b=Cc5NxydEfTLczFpNV2rcafZkq49V0h+9GhNXBUSGRLTsg4qGntj5n0jLHokSFtebeWUJG5cWQk3ObZo9Dl1nEA14EUZD+CD2pDpnzD5OA+9vQl2PMnWPyS7m9IQ3FLMyVie8sl9fjrGwR3z0TkEPjVc9QuBIS1SLkBczzbS1qiLFOHpeDTSH27XARiyiTkvydEAkPcjCTqBGDJkju6j89La4QOUcQV8uzDEcPjwdiOAZT+CRBxm+LQtf8bXKKuuJl0ceGa+U6Y0j9sXHv+NpGY7slo/YwJ75R+j6++R/NVhv57obdwKUi0N3aleobnsoZQW/hRe3G1vQO1oFArAA5A==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN3PR01MB6292.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:83::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Mon, 29 Nov
 2021 08:32:09 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 08:32:08 +0000
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
Subject: Re: [PATCH v3 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Topic: [PATCH v3 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5PuZJ/xlhSKqi0a5kIOZbkn1+Q==
Date:   Mon, 29 Nov 2021 08:32:08 +0000
Message-ID: <6ABF3770-A9E8-4DAF-A22D-DA7113F444F3@live.com>
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
In-Reply-To: <42E2EC08-1D09-4DDE-B8B8-7855379C23C5@holtmann.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [7w1csIECePVyTaA6F+v5wLwhWgtepmkNfDRnMA0R/Ydb33oZi+R2kgOH2ZnfbpAq]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01b49145-91e8-4db6-66df-08d9b312bbb3
x-ms-traffictypediagnostic: PN3PR01MB6292:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b8qivTdx8fC9gZlKNXvRp5uZuY6iyxfb9NchpFQ0wt7JLAn/+N9Owa6T8a5swMWVlOeLnNrq86Jqf/m37bjh6oQW6zaSMFdKtceohXcbjm6rz5FKogYOG6dwxHX5Ik7l7bT3OToKRBINUSF8nhi8jsq6vgI46kcltOFNCGvs2bXZXkYcwOlqqPjLfx9QUgIJaf0wjgkPDeEE9gBSnjXVRHtWPTJi7fUO82qfXUNhnyO1OpnT7Q3gHEcOAzLpZBLJoH5zAUPFQj+/pFk+tWjaMLOP4Y75PSwm0Vv7xI+oSY6YDt3Qlfnpu8IvBjgYp36Opp0tzlvnynmYx9vuTgx80neVplAsiBTauLr2h0uoSlI4D30XVOU0KA60kD95WUNis5dKv3YgXKpRMvyCO/IC7HpywoDaUOkmABwbZ8UkACRvewSzwpNIXqQ499L58QVN6gBWxnVRJzl7K9Nz9ZWeV8kpgP0W9jZrIrdTwqoP2vlTYoTIu1e884kAwn6eKpi/hQ4mw2AYZCnW6g0+JmEapJDzN0C5sNYjG1biPB7QW/S41bBdmEfdG2n9+M+wZ6LmnhoaDn4brBUz54Wl6xi/hg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: bxp8N70HY8xZcaouN7+4YrWt0tcNUQOTpD4C6iAFWsQ2YcyxeKEa21oogOd/dbVkCrYN2E8luix1/qdwuvRRAM+Egwm1bzw4lAXTnhmiSNGgvtS8/rXBKhisT+iiN7NZLpglGaRqdN8Lm5KfxRfXnEXysCuHGp8wFMeRHSWLylMOurLqj/7SPd4+nfuyLqB1bCyDcLVENBsbDHa1zo4N7sqda7PistgRqKb7IhGl7YtaVeUnNuaG/jeWG/4/SwZ0c06nKudqJF9Scf2DOre9Zw5fHM4T7qUmx8MJ3b/vjMp7X9kg38SvPgO7C4e+stxIIrlme00h0I5K7uoHyAPpHaqSVUg+HjxV1JgMQKEWwdLm+EGtM91rq7fwtNSbdFBYMSOSwAqaERdFtc0/MmG2Azdc69TA6ICBeaI9mJGVirwpQBseuDCCkKzxJ4rjDdC9o/SPm17Tgp+gBpVi3jCC6ExvZaFMIhxsy5NI1SzyAVCYx6sq6VGrOL9vRXq48c0fmHcSNRKNcjuU3PFYbqb+t90tdtZaNtX6l/n5DQy+sJUKkzjhFhj/CI8NZoREv40REitA1frBLkoaWJD7ie3yBQgmehBAoar1uxqc/Zhy8USMbksUM/0XhUNmfKlnQsEdWEj6YaD/OipPeXe9LLWYbTwVwgwZaSZ4Fj06v//hsSgNH8CljTDgUcdSOvTzYoULGF+hynEcDam26/JXw6NQwqNKB2WxT9r5HaxI1CoXAJRwXVTKf9ugsxtYOHt/PugP6vFDC7L5h9gj2kByr7W4Ew==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8054C82A233885438486732F63284536@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b49145-91e8-4db6-66df-08d9b312bbb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 08:32:08.8998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB6292
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

