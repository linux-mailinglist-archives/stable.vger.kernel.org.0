Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510C046334A
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 12:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhK3Lv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 06:51:58 -0500
Received: from mail-ma1ind01olkn0177.outbound.protection.outlook.com ([104.47.100.177]:22528
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236623AbhK3Lvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 06:51:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsMAyf6KLEyeK3koK8Ivf8Ws9u4qR8ORj+VD+5ApM4GNCKi8ULxJ3/q5JX69LkhY1C2PVo2MNAUaMVoHkQYJe3WmGPfNyn/qHVHxx6NMaQcMqVIL6uT6R076TvDXlY6Aiit1uZdKLlDbY0Bz0UUB+cy+B6qHny11LR7hY1C2U1U3TRqwKMj+Xu12a5mKqbL+uzx43lgh+uY/O4FI42NXdalu8tQFdoS2mTcjYmiUSKFEKobZDqS/h5CRdQdBdUAYwbKZqey9GKxwgSObuN6m+8/McppmoXupZIJ3I/Yelrw7szDsDppLUfZOid1ccXkPCLD7wYMsLoCjP18pvtu3WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkJHDi7nLC/KsDru/+pcC7FMb0EnENPZsFVS1Yni2Bk=;
 b=Ubb2rm7X+ZyZcn5WiBEMlhO7O/kwm4hnyvajre+3wNhVaUUKwD0ot6E7Cy0CiGb6vuwHaafn3bf+s4nrg9g/BxGonLNXtBryavlXKElelyOFMhbl2pXHCzMq6vLu5wKGCeSn77kqaNmoTGR21Kw8+j/SLLhpIWvFx7J62Zfz0P0gHZwewmF2sAC57QcpPwI8yQJU4/JQHe7Q9wux8hWxLd+aWn8q6wioidbnLlyXrYFJRKDo5YC0h67kiofiWYoOuLHbqpLLDE33H9kG8XZFI36b0qXH9ZwjfVhzAnO+AGu0FxTu5eg0ZtOCoaC347iL2Vf4Uw1DWMp0QG3XajCiwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkJHDi7nLC/KsDru/+pcC7FMb0EnENPZsFVS1Yni2Bk=;
 b=sKHfAoIc9/9pWq9HCD0JTbTkkYtGqdT1HiJgHUl2Pf7ZVMx7AyVebkxznnnuHINPn1k+LNKA6Wh2wFDjb+/ng4AvBGay0WqrNkf25RJc1DRo77VG1RPdEZtyKbhNqGfQRWMuWLGSlrYU9kIDVarU+oFu5fvDf5zwMLKPLV5I0/6X1fWXOS6kDc0M5NtOE3ELpHkB1dbiHEIagVVsC3L/ca9te6BHOfOqS/O01Sl89rENOewd+dUtvUAkks1npVNSOEQ8hqV07zfaU+ga0zH40UxnSN1JnWYXJev/ACFf46bluUUASjxVzo2w1tWDEoP8ZlQe6dbNitDPE6GI/soWfQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4286.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 11:48:25 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 11:48:25 +0000
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
Subject: [PATCH v7 resend 1/2] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Topic: [PATCH v7 resend 1/2] Bluetooth: add quirk disabling LE Read
 Transmit Power
Thread-Index: AQHX5eAufml6VMnYEkSqbdrb67pBiw==
Date:   Tue, 30 Nov 2021 11:48:25 +0000
Message-ID: <312202C7-C7BE-497D-8093-218C68176658@live.com>
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
In-Reply-To: <A6DD9616-E669-4382-95A0-B9DBAF46712D@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [UrXlc18aHztjttVrWKai8Dv58Y8XSAGLfgW6OnYA7Noua3pnIGVfy/IdIy7UOePs]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db3de10c-9883-4111-fd27-08d9b3f75185
x-ms-traffictypediagnostic: PNZPR01MB4286:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5TjO+5dMUyEbXqZ34UVdmNaV4qqizLxI0Z9TZah8UcpXiio8VF4D494CACkAF1HykBK/WLj5+EEZu7sv2nJTyfpOViFMXLn9MUqCQtu1XU7UiJIgAP8KmqGCLCFbF3m4f0wjx0pc3QYvqTEQNBzMrSzVf6SVJe+wQC3dvND65eAzXpkmtc9sOM+fVNNIN/FkvCxIWVUoSnUrvhyGaS1kO+vldPt3xUYSNtq+HiP+9mKZfLn4Z5fSm0QJZbJQDBz1Dx0O44QlmS+ujS9YZztWKGi8N+VyiVvpCLO2MNoAs2N5A5kYoqBeMCVUFQTq6n1GUwJAcE1niVjvlUMxqejWf12KjEKXkxOU3dY557MCgZZn5Ap0yfYnL1ieoqPRO+abM7bT4BFy0aiaLAEKOCKS5FDHklkeBqI0oabkLB4vfd387OryKo20OusZTv4EFbGQk9lw3bijo8L1bjYcT90Vf6QscPB6/hdYl2Z1aW0XKucZmB2J9Oav4ptg6jGOaHdtzrZo4dFdU/SvA0QmaW5rq2uS63tPWzt7LlnLOpcxnKtpfBk2p93/Iidg16pJFbCKxk4zb8gXDwh5V57DAMTKSPTuezFzE87uyHDSMx7ZKtG42agWto4iZuHkMo4RT1vC
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: BmY1ZK/CG0YlAS9Kh3KQQcAgHedIE7OVzsEUXHaHC5PW53/14JKL+h778MWI8cVp8/NOmT679vRwhRLYq5wxaw9FyO92ZWSHOxDhflIHEepVMqcYQTjkEltgXQa6pIjRfrAHHXEXSznhOSNrn9jzbX0mPPHJk8i82S23rLOxtnsZa60WLeIYTpRps7gWrU23hyVGsx4Vgp783D/GxJ/lwduHYJ0Rcr2j1TEX4ayx44u+/O0TWqVA4WThF/+h9w4kp/2eTzP6QEyJsHJs8hN7+swfcG89lKRQ22yi+KkouvhVs/Z05F4dqV2QdeFTKuevJBLXcjeIAQbk2bYoHS7grEQz0rdtPx798RR+8y5ctbMZm8ypeWs5F/BPDLjo8qhPlJWdPdQJZcIO5LCw8AEaf4HDGbgo4zbRbTX4Cq92SwakB3pwABChRWXCYsJlTle2QETvUU2TY2AfjoYT1X1UmyFx+zLvneuM4MEmHDY8cgESWguZVpQtLwNYCDo2pOCN+j3Hu6liA/gmQRcgP0vrwtPxNDoBYMD0QKqU1DezU9UV7wJV9tQYw3kj+mfjXxweg2eLMeo9RcCUKH/Z/5jAs3Me3/KqvHRvA/zBB7ysF/27YDMK4XuFWXVsV9WeARlsjWX7/VFZG6qim4mVUm15vukR3bwlRjoxKdrRyXFuk3OR5FPt69ThaQfRyR1ZcefpNlawxIam46HQ3YpMNXyowSuxCznyvewRpaLJNWGnHoPPx7/EaKaf2IWn8bz6gprd8ZVyg3L0M2VatHmOocp5dA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01DA3761CE47EF479B09DC1EC252F90A@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: db3de10c-9883-4111-fd27-08d9b3f75185
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 11:48:25.4679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4286
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

