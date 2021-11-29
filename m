Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01E0460F49
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbhK2H1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:27:52 -0500
Received: from mail-ma1ind01olkn0188.outbound.protection.outlook.com ([104.47.100.188]:61622
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231732AbhK2HZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 02:25:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nK7kfsiVAuZmMeOn1oAldYo4G24GN7Y2Pwj7WMEKICSLK6UZOC8Ue3evbpvjVhFxQbgZ0mA/6Eontjeb6sMWEHEY+CJSRdGP5qxua4gAJYEFwqZt4kBTkDRTa1RqlC+HKnPzjE5W47kceiL7npANBVzXzl/PKOo8GEIDADmtkCI0bTW68BngnyL01Cdd/38U1X6h5mL8iQ3vTY08BFBq0Kk3jHz01ZYFoivRWZXNVsqOo8fzQXCKbnnLuqjgC+2EViy2Cwf6CHjhDpFkeO0Hv5e0U+WPiYXC4arwi1Sm8xu0Sn3TaMW+W+lRr+IEk6RwthWVZXE/DUbG4A7+NJ8EuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KDekUeYhlnHAZ0XcwiJX3Q70EYZRW5X3JVk+42N1x5g=;
 b=mtui7ZLVyPAuCzDyRqzbNGq2bcAdR2dQrSy9WqrnMEMQj8Q7i67vF7ApnblkhQ2Ry3Gdwzgsg9Kq5nBFB0QLHOkiL9E01HD1sNsSHc+FYlJ8/TtSexyhbH9uScljx+8QH6UntHXkXKLjY1Ow57K4YTGNdf6wN4Gv0tOZ7HFl/halYXhtv/C1WB4zV7ggdr3DnHNRF+2Z4gYTZKAuiKi76Cjo+k0NGBoHzekMHci0DjvfBE1uhDx9+keVeVLfjUHUvAooXS0GVtnEUEjOH0/VC8qeDZAd1/4Mq3SUapz3+wq65XEEnZqyqK5Fw3Xrtr4lP3l2HTCdUi4byU21hWGolw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDekUeYhlnHAZ0XcwiJX3Q70EYZRW5X3JVk+42N1x5g=;
 b=oIqTsG23xUuX3FEnez1Y4eMeUyvLq3AO1BptHukWTicAt+u8BJcFioPhjZ9NPFk8/x7G8qp9itBbV97sl2SypgcZfivjCLrQlHSHnAuqMedsSkNWu9Hw3XeFtkQzQpKU0mYGScdIajgh5H0VkGBoMFAHvn4CB0MT+z8BrpHOEm2qpXZH29IgZsbPVdJYNM28XWKHORBzvxmhupAbKNHFPcovxtWe8rvNWBsUlLtGMM8cw/WMO/t0HcMedO70AYu5LX/VSspRnkPMraON6AweIN2jRGPVgYLVM51EapB6hnbv+7y7LGFc97WBPuT5KUzUbMVenIWrxUUdGbYlfSw0Jg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4494.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 07:22:28 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 07:22:28 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 1/6] Bluetooth: add quirk disabling LE Read Transmit Power
Thread-Topic: [PATCH 1/6] Bluetooth: add quirk disabling LE Read Transmit
 Power
Thread-Index: AQHX5PHdg9R7tTuOZUGKQm9G6AVEOA==
Date:   Mon, 29 Nov 2021 07:22:27 +0000
Message-ID: <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
References: <20211001083412.3078-1-redecorating@protonmail.com>
 <YYePw07y2DzEPSBR@kroah.com>
 <70a875d0-7162-d149-dbc1-c2f5e1a8e701@leemhuis.info>
 <20211116090128.17546-1-redecorating@protonmail.com>
 <e75bf933-9b93-89d2-d73f-f85af65093c8@leemhuis.info>
 <3B8E16FA-97BF-40E5-9149-BBC3E2A245FE@live.com> <YZSuWHB6YCtGclLs@kroah.com>
 <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
In-Reply-To: <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [YYJnhi6fM2c3u0nOMpD1D4ZXGHeABSQzq2bOXc4+TLTlDhjwXx6l1e7ZotEQM/YN]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b50db91-93ba-4369-78c6-08d9b308ffb7
x-ms-traffictypediagnostic: PNZPR01MB4494:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: diiWJqbTEfMP8/rbq3MYNNqs7WAokn6+7Q+Q7MABUAWViAIljL1Fqxn5WvOGMp713NGCHGWuNVw2uHQLTjS2KQfFx/LjgisXDAM+x8iKvb3uFsVgpNz21mwyxS7JRfn+Dv3zRm8x2f0Yp5Dypx+yJDQRh9MMHZlHQJ4cUgjPoBjXxIlbNbksSrc/f86fByoTjUed5EfGwdCqgJLO1ObMFWjspPCxVatRDbPWuF6heFN7zNm2tIH5lL0NitqNU+V15IvWNmABeMCzSGCDaOSMqxptJ+H8U9ttu41rfGZlet2IxzH+yx9/9H5dUwG06wKxwZkGOOOQ+lYAaazfgcs/tUry8BwG1z7tRWXlj6GBBulBeBO5I63/3NfwsPw6CPnRW29K4a0Qf3upJApjyRBLbsHgyfiDHdRiubyU7soTCTUCn1gXKcJu2xbTwvyqcPIcfSeSyPYtVqbqF8wLeJVDgmRMyyGjDdgtTb83eACe7qTvfBKhJB85lx/BYxXS7Y+8RVAjdi28fy+lwHpQ+FNEnPELwCuRE/KbANB4LsrVjjMixrY19NHzwj2Ua6nEIGuRGt3pK33wYLqsMM6+yG+K4A==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: D7NSkNTOEEhC1SvmZht5XyyQfos2lbusGqS5lDMS/4fFq5ApQkmeHa5wG56UhWO6+bYXu7n1454uCFVYeSCyUjfEG3bLxtXcFtoq+iJmXjnlw6oWgndJRkKBOpececLxilpVXFAiZMLpy9u2wtydISNwEUI6uO/TSrqt5FybeZAwT6tSXtd8ov/MIJi33XrD0SIz6XKjxz8cnhkhmh4zmLYB7L2iH1Yr63BjaNuupfYG16I5qHfDzEOamtVdvyt9CCf6mJvsQaeAcx+08NgtnaA47kQdXy4FZ0KR1Eit54LTqtu/RKMHlg6GT8jhLuLXjS7Ifev0bd5j1mz6mTIaU4JjEGk8NrrlaXxu9AG6RWrWrPHTqsfTPL0Cm3mBVrPJR3alYzd8I8uXtv58vsOpXpT7gPI6gaPtJh/oFBqUMKvzjPuFURL+NerjB0OwW9VrugH1oWgrowE86stLMxU27GnZNhv8xYi+7q5omBBIsnYdQiBaTqqkRk5w9HfxD013qk5KbWZdQiKdnZsEWTg7uu0ycQ4eASyn1MvxQuC19bgZhxUcKUvlcnKbOTlpMtrDCBkz3EwKsfbvFbAz0/bs+ebqDgXAxtqVc65Nbz+aT+CoLcDvs3YYsQGS5N2pZPJffKyuUL+xRWWTPabPd00tJFQwuVzqyCc1yFFI+d5AA+d0CB0RZf/10VSxozBHrUXLl2/+yJOxC2t/8Oh72kgf5xmFgr0AFQYarG3IFTgAvjGsiMyJEFq0YsP8TDWvi91Q5L7YKvNzEPqtn2fMhzfjFw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6BE5728506AFB46B47747E3B7901F1F@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b50db91-93ba-4369-78c6-08d9b308ffb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 07:22:27.8212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4494
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <redecorating@protonmail.com>

Some devices have a bug causing them to not work if they query LE tx power =
on startup. Thus we add a quirk in order to not query it and default min/ma=
x tx power values to HCI_TX_POWER_INVALID.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Tested-by: Aditya Garg <gargaditya08@live.com>
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

