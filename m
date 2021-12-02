Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EC64663E1
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 13:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347374AbhLBMq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 07:46:28 -0500
Received: from mail-ma1ind01olkn0149.outbound.protection.outlook.com ([104.47.100.149]:38737
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347366AbhLBMq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Dec 2021 07:46:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZyAsb8v0+zW2qI9psr2hWMAw67zFT9kGa2onjdscv1QlXM2rpooS7uOkxtvkYTjuK0ABAjd+DQwSWpO98OsoZlkapqMNZvdJpDDl+whI7TUpZlYrhT0mNPkyMboYU9tSOgKhilQ69Nl8bROBRpAsVTb3ExBP1MBLo3zEbkikvVcD+84l2oDQvwPV85pdO2MEwf0Jm+FasLIvwKMTEFBLUe1Bhnu1tdrjA3gU3c3uqfhbwLkn6IZoGSVJ2vIkZV/iCxYET2ehGEuC1NSDCelay3rJEuja4BkXDtchOP3zyV4oyFlvB70V1l9TsWiXtivOuyyUAx8fSZUj5GL6B1zmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CurmLMtdep8Sgx0U6hEeRSbC+6xXna+b9UKj5lW+MMY=;
 b=X7TO20esnJ0SIiLjTvIY/cq0D4+d97JP2+0PTLBjbzKF1tcl/JS4vdSFB5qRTHyWwIYFdt5idFkMeXryFRo4DfBTVmSvG6jTpFW3R7sw3+oJ+7vIgh2YLhaq9FHsrc9Qx25+k8d0c4dNlxanAvCYJ+N1xpzJN+sMUfsIcboB/FwVqijk13uujqJziJRXnDOyxhn/uB4ndTVPzRW3hwHa2v+kyuih9mcZfeY1fEwcKbQZeZjuOZQCdE06f1cptagKOfLglYZPSPChb47vQKM6v4+tNFqvvNvd+UWOWCbBvG55GQSFLWRHmVyrTjEqKWOLgF5Z0PnVPj4pldaPR5w07w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CurmLMtdep8Sgx0U6hEeRSbC+6xXna+b9UKj5lW+MMY=;
 b=vQqn+gHiU+vHeQOmcNWa4s2v/ZBc+avZQOnEA8BFprY+r5j6aiNqPiHt2fTj5HSUDpBcxKCa0EWYs1aZeZvM0Xf9CsdUM2isA7aTVhXn6zVvIpVyBz+U/QnqSRbPpJ49+SyglCqPbkERvfKN+RnPdHe6k4i3OqvgeP01hKsgGEL1uv+XpERr6/6gyE+1b+A40gNuuSAvKPj2BhcnvGtLw+fXMejxMApeUSLcyt+qa2ZWX8ql1Im34NF3ZN/ljI4KMpKEMzDjtrqX4fINA1qLHedKyR5REgMpMkbQDZIPmFhA1UgKctOwOZMVrUGjpdL/xW/QjHBnRG4sQLSQhuaQ/A==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4367.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 12:42:59 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 12:42:59 +0000
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
Subject: [PATCH v10 2/2] btbcm: disable read tx power for some Macs with the
 T2 Security chip
Thread-Topic: [PATCH v10 2/2] btbcm: disable read tx power for some Macs with
 the T2 Security chip
Thread-Index: AQHX53ojFguO88MtgkqVQrkhWHQhZQ==
Date:   Thu, 2 Dec 2021 12:42:59 +0000
Message-ID: <51575680-E9C3-4962-A3C4-ADCBD6DBCA00@live.com>
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
 <3F7CFEF0-10D6-4046-A3AE-33ECF81A2EB3@live.com>
 <DCEC0C45-D974-4DC7-9E86-8F2D3D8F7E1D@live.com>
In-Reply-To: <DCEC0C45-D974-4DC7-9E86-8F2D3D8F7E1D@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [EW08O/OjF+/aJL0hcJkr7y0iyzJQu3f0DotngA2t61SfE8SxZwLo3phypNYyMxya]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c8cb9ef-ee1a-4227-8436-08d9b59145b7
x-ms-traffictypediagnostic: PNZPR01MB4367:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YGujWoOl5+t7/KiZPxvonN4GT6+NyN6XpmDTrLypMnOAgvvvsfPq6Pw9PWOi0f4RHsLw7CHyPGfD/pow+JEmqTLQr1RrBP9YvYxx8KrB7zLG9F5LM+W2yDquWqHWNRnLdxaqyaNNflx17jqMplwKQNnat0tMORGfeC872Uv03B8dj9HeyeG/itO2/y1Ax69y6bKlN1DIbR3vUenps0qjmGnrUYR8UvBIHpKoAsvgx7ePhuL80b/B0TWOATwQNGx1v8SGdZAXSoi1WK19qpD5HWsxmfPO3KzSQ+p3NZ/3l9MN/UpTCuskD4AaZUnBqiAZA+NkaV3aiS/PYQ8Z3G304y5DpbrgsjmkOBXdkRzMO4GHxcpaxzz2AuGvqy5CrQJC7rNf+fbXHdqgKIfxonGhjXixVo5NVw2onVMcKq3VSBGL1F31id475UZISMukQOxMmTdsvf9se71AVyH+My1CrMAyVjOg2tdDWZGqWNMzp8xUfMIcGpWF0b3ptM6tzbM/QFUWQLWUDN8OrQlzlgMvpONi++zyvZXfD5h47KJi24luqK8T3VZbVs8kvQiHBVrnC2MzMUkW19MAIWRJWlAa9gfQe5A4GOSChUeK6X+4sXrDWQ0FC/sG7ul956RT6kkL
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+LYkSCcDPT2wvsCe+WgDM7disRPCRb2fQOdZE8bnsnaazCENtnfddDsqN4qj?=
 =?us-ascii?Q?MFq2tEj0G2qvREXk5nK98FeB/U5h9sDTa7USTwk8U6iWx2JNWKPF5+qpoSiV?=
 =?us-ascii?Q?FDY/tB/9MeBQVmp2/lKkPyHOQumqp7ac6tlF1B9E17dmjGCIfB+JiBNZGmNx?=
 =?us-ascii?Q?TBThfYJ+BfSL10eJdGqv0IUu55yAVXJf+dDsnc0W6+pXEpFRZ5xnv3j6+NpR?=
 =?us-ascii?Q?+13YAF5ZbYJBMt0LxySx+nbXeZxCnpLpiVPczYaTLWqKiHuth+Cbyy4NfAzs?=
 =?us-ascii?Q?iRtO+OwPNp8BT58/Eugnj0vGhafw+Rx7gqwuDPRhlIKtpXdzWVbYoMnwlMiI?=
 =?us-ascii?Q?I9USfD/zj2Me5YizOhlIQKtT1EeUt1+eQvrVpqDF+iILV9I3Q88e0bv1uNQ/?=
 =?us-ascii?Q?hSe++ixRbnwdByErFB7CTtDXiNWLNYlzdyfDx6KHskAH4abBz9Cm2dfDkza0?=
 =?us-ascii?Q?Q2jENN+CFXfPLRaaJjhyLSgi05BX6JZTBQQwMthwAFM2vaR0SMS9Akp19JXB?=
 =?us-ascii?Q?As0x6Hw2rlINctFnxbdtDUITg0/JEM3+BLBvNGg6vn/jT3BLoj3o/MvZhQWc?=
 =?us-ascii?Q?vX8nkWtY96ds3S/kJP+HGp1+UsJ9TnhFwms+lzW0GXv/BsDV7Xwibs7lxgtU?=
 =?us-ascii?Q?5Cv+6lvo+EguSwQ04CnFgFC1RrFeV0KuYv1Z8auGZHv/DZGWfYKDbvN6VE2K?=
 =?us-ascii?Q?WYEvjfZjtbpPVg7/bBwgQHoPART4Itt8KmIY9lPLFQINaj6eYwtccCetpZrz?=
 =?us-ascii?Q?pdH+3RBUZlKyv3SfgnyA2VA6GocvB76fwAI5QL8henW2Yt7eKwRTzl6zzlm2?=
 =?us-ascii?Q?hFT/AQud8d3U71O7Jyg+47O0s5wPpa2Ex0S1WbXlx4Mpd3X1zNdMkGqXmIj6?=
 =?us-ascii?Q?gnCC6lqPVkvTwJeKeCYxgj/J6y3GuVlwD8l3rKz9XgwpzSz7nVcx5L7lE8Vw?=
 =?us-ascii?Q?M+wIIlfRcvCk6J8k6AsHA3qwlbMRlowbEhXw7033dp13e496MOXrzyC8bYwD?=
 =?us-ascii?Q?khjBCvS6Vrlbz9WJuwYNjuZcvg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7CEB99E57544F24298210BECE2329AFE@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8cb9ef-ee1a-4227-8436-08d9b59145b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 12:42:59.3080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4367
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Some Macs with the T2 security chip had Bluetooth not working.
To fix it we add DMI based quirks to disable querying of LE Tx power.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.c=
om
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
Cc: stable@vger.kernel.org
---
v7 :- Removed unused variable and added Tested-by.
v8 :- No change.
v9 :- Add Cc: stable@vger.kernel.org
v10 :- Fix gitlint
 drivers/bluetooth/btbcm.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index e4182acee488c5..07fabaa5aa2979 100644
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
@@ -343,6 +344,40 @@ static struct sk_buff *btbcm_read_usb_product(struct h=
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
@@ -363,6 +398,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
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

