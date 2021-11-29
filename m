Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021DE461119
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 10:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245446AbhK2Jbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 04:31:44 -0500
Received: from mail-bo1ind01olkn0146.outbound.protection.outlook.com ([104.47.101.146]:17517
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243817AbhK2J3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 04:29:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfO3B6Qscfcpfusy6FjwbppjwYwgY0VzCZjOjzd7yxngg2VczGWCcy31QrcC4GCNiffHtKHtvALJ9n3ftluD4r67GN8bYBorTJr95aPKhQKT0Cb3cin2vwEAKNoJ0EYxgWrQb7QMvXIAjNFPcApwEtPARFYKdMHZgvA3wx8Z4SQWSAGIk1ZT2MQ/KhQFvFv1kCz8+sI8QcQZtYOiFGXtIyk4i2zZNs3avUTglql7GWQFBbe9McHYjSV5ZCYEJOi9e+Rvy9dmFf0XgUd4lCaezEH/+FhFJRlzNeyaDpGC41C9a9uC1i8gVKSQqsNyi/TgGqqa9OagUbwygkMpT3xETg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5x5p6nRUXwp5Yw4ZOa530IAmoex3j79M9wC7R26R7HM=;
 b=Da/mO33+mvgBiK+PX1/xYAzNE8r8RIE9JwixrODs84r6RvMHLf7SkLP6pZZCxx9lR3B83vgHIFpL/KmNWv3pWJAn3XifX0XMR/Thr9zaMsf6jkhwV4z/V7FBThjZ4cY49l3lKS6N4dGu0ks9m1ctX9OnUbv7NF1wPOhC3HcQeYps6/x1q/Tpl9CqjVjXT7VrFAjcg9YLgctz0Rhh3TecBSzRxm9V0hO3SULrvwz0k6dkd/wm9oXTv8HPWmd941uCCe0EVR5yg3iugjPZ5lMvQlOPX9rp9Ih1XBYHNXzxQ3RUZY17HqHBDt1az2TKABWWWVkH5V2GkG7J46iUCI3r8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5x5p6nRUXwp5Yw4ZOa530IAmoex3j79M9wC7R26R7HM=;
 b=mRY0LvEMGHZAobud8nyK7i0sAWXI5ZQPW1kz4SXq7GHm05vJF33unT8ksjJajuEgIum2o/zGAn2YB92Ism1gzK18f1Q3cSZh/bDC1Ki5XIFjEDMApZeMAAWYE4n/gqkbIqfOZaMwQx/ge/0TOMDCyvzbn0SOLMDLGWvZkeiG23zez+wzpw+wkLgclpBehq2S0K4Ba2FF5P4IQl4aqiOgBcylzD6IantuB7/fBsTW7D1MKiysCmXmbwqnkflpeWHmXfxGV4O7WVgyp9zGo9sU1mINL3ltmBRCc/4t/kVM/xvg8xTBc0u5gqZ7Ro6idOETlI4oUoW6oMEGhR2vZvpz/Q==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB5269.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:5d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 09:25:49 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 09:25:49 +0000
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
Subject: [PATCH v5 2/2] btbcm: disable read tx power for affected Macs with
 the T2 Security chip
Thread-Topic: [PATCH v5 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Thread-Index: AQHX5QMYdnDWYBZS10KI1TQLMU/cyA==
Date:   Mon, 29 Nov 2021 09:25:49 +0000
Message-ID: <72F677FD-FBCD-448F-84A5-75F42052FF5C@live.com>
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
 <A003A45E-EE35-43EC-879F-3395CCB5EF59@live.com>
 <6326984F-8428-4A3D-9734-1A408B9E82BB@live.com>
 <3EA0850B-7D40-4B21-85A5-B42C4CE8A942@live.com>
In-Reply-To: <3EA0850B-7D40-4B21-85A5-B42C4CE8A942@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [iD2owS4PBmXARJZix0HMBae80BALj6+SXNNNO62SvoRwJsG+I3nmeaUeEmNi5ayq]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2e0510f-787d-4141-818c-08d9b31a3b53
x-ms-traffictypediagnostic: PN2PR01MB5269:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kU+yZuNZ0jXjZOy0QV5+jcz3hhFJ23OX/sI5JVFqjrJblrys6ZS3orMev3+3Av6GKl/jGzuihlifTeejAqSTynClCPG43fhAE7b7W1FnnrT1A7iZyTp5k9wF62LlBSBEl8Mpci+YQLkmOH30vGzA09FmnZPlSqcPCJ/t5u0pVQLLlBDutROtiFNus7nSxGTXtztN9/BThBt5kd39yxtsoFowGrNy0y6kMx00HFpWDYn2KDvrUlz1iD1K6mbOlGQk4gC/aA3UDSnxcfGQIr09+UMgzK1Cd6kKQJcDr9THfdNB+YeLio4rTTGXEntF3fIqLvwAX13mF84GEgc3XHuo/TB+hm2K3fD7mWrM9V0IP3wWgFV1mk1+F81JSLbOet95DADq9bILbpkJJlG3e7iavRmSX24KUcczDXDmBL5x4wWWbghwtfkkO8iL2qNQ9/9a4IdA3c5dKaPsRNGP+SgmvgYKTrIrwmbPY41Roopk2jrt5wm7KCWXuKyBhE2fUqwp8WaQfH1oXWeTbyddGVPZeEseM3iAXWl59Ral/WEShbWL8CE9Hl2NsGAhqHAtaJdnw/BZX8PDgrygj7/yq0aaaid2zvNvu5m+9Vkm0y6SawTSGw8OyOFM2zPgoRGixN8l
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: htJ/Pedx6TVGePF4q8e0rZLXFEi8VQJD0IEMXZ44wevVi1lrdboTjVPgiBr0Tj5LfH+Fi1sHT8FMUmXhgHV4EJQqacsXu6ORZT2mT3YV86AlMBl2dbv+/k+Kyj+l7hj+zWoq83wqmrg/po7hQKpn3wnW4Ry1znPssxBQj3OqfKYLL2+UaSXBnAQBTPrZDQmTeMTdpZEn/nCDK7gA+DUtejt5ptiPq8aoifYz2ZFbbfZ9uPjpbopeSSinFrmOTnDDWDUj+Fh0FWZzPDro6y/NaT9QDy/LAiquFD6QtQaNwBPMrgw3AxsN3ARCQpUV+dg2nQ2wF/7LUiegaW2T8bDR0rQ0NKNGgF4nq0rHSzYTogDR+h/0XJS8K9jn2AHgevwOR6KSI/47/sxu3q84aOW+8GCp5FZXUrTTEEJxAtmSpXvzVjOCLKIaEKswU6hFYvPLEQvPXETEg8mF5Q+tYVmw0Ppk7sx/OBYf6BtsmK1j0AuWjA8ZpqoTDETVRGsuAACF9t26UD32X67fDsiXVJ6SPx02jbulQoX9f4u9CP5TRQ5Lo1xluBrUA2l+Qo2SfEct81xc1K9dPhmas4loK/dqN6uCc++kYuUrfryC9aSRquELdd2oY+5OsLGDoNuXOZGBubQq+ebhSfz1oHBtXGpDyrFyYDg3yose7/zRw6e6TePTJDMssaUlMMi4NVqNrNQUN3HnvveziZ3VWRrePKfvNjDGrqn4Nn6kZXGjFvnX/P9G9G95fuDuy6t8vphZALttn0YAleZ7NKUire4G6WAewg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <77DAB2A863F03444B63FD57FFF72AD49@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e0510f-787d-4141-818c-08d9b31a3b53
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 09:25:49.4490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB5269
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Some Macs with the T2 security chip had Bluetooth not working.
To fix it we add DMI based quirks to disable querying of LE Tx power.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.c=
om
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
---
 drivers/bluetooth/btbcm.c | 40 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index e4182acee488c5..40f7c9c5cf0a5a 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -8,6 +8,7 @@
=20
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <linux/dmi.h>
 #include <asm/unaligned.h>
=20
 #include <net/bluetooth/bluetooth.h>
@@ -343,9 +344,44 @@ static struct sk_buff *btbcm_read_usb_product(struct h=
ci_dev *hdev)
 	return skb;
 }
=20
+static const struct dmi_system_id disable_broken_read_transmit_power[] =3D=
 {
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
+		},
+	},
+	{ }
+};
+
 static int btbcm_read_info(struct hci_dev *hdev)
 {
 	struct sk_buff *skb;
+	const struct dmi_system_id *dmi_id;
=20
 	/* Read Verbose Config Version Info */
 	skb =3D btbcm_read_verbose_config(hdev);
@@ -363,6 +399,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
 	kfree_skb(skb);
=20
+	/* Read DMI and disable broken Read LE Min/Max Tx Power */
+	if (dmi_first_match(disable_broken_read_transmit_power))
+		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
+
 	return 0;
 }
=20

