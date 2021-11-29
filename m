Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2226C461477
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 13:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243208AbhK2MGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 07:06:52 -0500
Received: from mail-ma1ind01olkn0159.outbound.protection.outlook.com ([104.47.100.159]:6175
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241757AbhK2MEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 07:04:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5u6TdDOLhvDsYE5D5cFmcx3NSwZHWLtXeKkEVq5W1iAxp8QUIVn330F8l4xepOxSdBCNnSdTH/cWJi1h+LkGmGKVU1M2nnOrrUzoN9O8apxCTtirgR1yzsFib0yZhrCH+PQR41e8akwQnUO1gko/4YdsXv9dlGhWUVy8RR2FyLClGPjZYieuFJDBe13EYp9oazxd3FC4iTLVQf7aWmgK0axyTvO5L7lQ8AB1uu70NcY1E1GNcumvB6waFROV3zjrE+JrBOvwPBX5mwq8wj3Rqc8+nLhR23jf6ixyeDMM7aYqc0xI9znfyql7/XkGJCeE3FdEiwazRovl5JjIICzUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yr1LjSRC8VSovI0UacescMkqqCm+3pJhj/FOlKDtdXA=;
 b=CzRYoXDi0xgVPNhaLW+CXgVFq36QhBBsIzq0vqHO6vNRrrXwJGaHvS6y/Gql9OQRgfAv6AagcLxcUmPYi3I8M8t+qZfc4U5l4MIerUiemBVo6QFiYCAJ70nFSp+kC544VRimcvJVCC5/ZOL/Bj3PbG+XLa4TaOennwJ//9E58ZffaUh0AxHcjinAfRcinOfgawYM8cUrnbxf51sn5hFeIMOQ6WiKzpg0KgENhmqkmsjEVOmySYBptW7VBs4ODP2PpTZbTaFuIjTRUqakIMUzUvl055eoFG+IkjvA/SDUypp/d9/gcYhj7DQ3YSAwqjcwZPnUElBPL4Zj7glDwk14EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yr1LjSRC8VSovI0UacescMkqqCm+3pJhj/FOlKDtdXA=;
 b=RcIOJfvbObEWtwvi2W8It6kWdjVRiPLPOGiO+9byL5kEHtLVawHDEpalVcDYud9mb9n49xmM354swNZSXDc/BRWagu48j18s8n8GaphxB4cxJ5ezm370ytOkC3hHpNdFIkW1C55fpLAmbKgK7kKJ3s3vGJ6SouIP/agKtJ5FXStYFI5LekUmkzAhhsY9V+gYPPLbGUqQ/rtmZMittRaevkMWWyl7kaoUwXqeh5XR33+Mj0HpZ54LAqu2vDcdwxHG5q4Bz5jSr9qhewba5IEGwPuEf3IsgaRDKrIH7XZSgH8hq0EIV2Xgn/maXun1QPlS8DsPm7pUbKdP2H07X1MRRQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4732.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Mon, 29 Nov
 2021 12:01:28 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 12:01:28 +0000
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
Subject: Re: [PATCH v3 resend 2/2] btbcm: disable read tx power for affected
 Macs with the T2 Security chip
Thread-Topic: [PATCH v3 resend 2/2] btbcm: disable read tx power for affected
 Macs with the T2 Security chip
Thread-Index: AQHX5P4lQ0eLsCW88EqYPNWFO97qlqwaV3yAgAAQMwA=
Date:   Mon, 29 Nov 2021 12:01:28 +0000
Message-ID: <749EAA1E-3207-4772-8781-4F245E126F21@live.com>
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
 <BEB98DAF-0AEE-4758-A6AC-33F23D11D91A@holtmann.org>
In-Reply-To: <BEB98DAF-0AEE-4758-A6AC-33F23D11D91A@holtmann.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [l/zD3thGNOSBqL7qv7uOThN1tqSLR5X6t4Ygre1Ok87CMFHirakedD3MQzy7kM6r]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fca301f-95b2-48cd-436e-08d9b32ff9e8
x-ms-traffictypediagnostic: PN2PR01MB4732:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lO3YQVPhTfIhfrcgNffyNHWAT9TYcm1gInteFDdvvxCMy7SZZle2DlbC/bYlYFfCBUv8nKiNhjHgwNsNSMUM45eMwsOm68yHzeChaKnncU5QgQ4F6MXeOB+egm4tp2QB5m3cwdGrG8n0feibMgaALBNIdIeow5eTVGrp5F9S9SIL4pNpfnoU5ScxXmf+NipNoqvE9iTV51I0dxhDwYprMTpV3q66QPoY5NWcrPFrAgdtBqE0RtQXCIDR4K69M1djfsuE/lUTh6elBcch2HGf70ydxysif9F9YuwJjW3QVph32wwNOQsOiJoUUZfC9sL8RiR/YlIdwFe6rG3xs53YnTw9LXeUXSJK3oOrzoo4b4Lw14vO6haPjNyBaVDnLHuQ1pyX5rayurgVLBVX4bJx4ckGrFt5sWOsjNz4HlcD7GeV1gAtJsMHxbt8N8Z/UQfBgyu6ksuB/Y+Uv3qowF3CM2p/UjEIozrvBG2R/ttW5JmFUGcJ49tWznYCJrWaU7f9OtX0RKuBOBOp+5fS/I4DMgh+0L4Qg0BOBPo2IC7g407xbTMemx2x94WSN5yBFwaFohklXi09CCu6ddzXNjXV+w==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: ogTctf2ArLLf2ST/O6J/buHGwEGg2/nSHobypEWdlutHhsdHubb/c+S33LpP796gJvmsjy9epB8HjUHbrf1nxNaEdmujr6DOJx/qQVdDb5nLh5Csns85VNo8KAk2nyMM0icynu3Ruu+sX2Pp8Zh9GJnZt4l7xSOh+2oRq+zDew16XyojaOUMziPBlLq/DImwcSI6meg1f9HmHwJ2xAx7daRhDiX7XuveOzS53rhtqo91ZhLLFxtQAPho/w67cB5M8HsaH64kXDuZw1q8fEDJwoipjuq+fNeZwkh9m5nnxrgkPIVGCS1ZItfBv7sgCkPScno7uKUL/tM7F40Bv8yv+su5Nmjj01JiuEyhuI18AbwsNhgOMKNURW+7vupxJPWrjRvPCJUjapCl6n1Ei7b/KMnliKHcYurJ6BSYMIqauhrXnthKjCDffzaZncRgqolC4F77UN/y+AyTQm4OuZnrfd6tWFrx1AFc2xAMQtIaWI8KvuRwkMcxl64mFX1XauycLA4wqLffcYEH5r7pTTy6xuxOPIhFQW+OId1Z8azWlMCcc1q+E91N2zXevGUOlW/TW1tJJEjoJ0cLugwW9p4WhuuwSCg88BlVT4wS3tscNZJpzjkHBcnkzdMcd0yx7v40rJW5pKY4oA9D9xd33oHksujFUeVlikCSvNzCpr1eywWs5PxODK3ELfKSdIun67jH13qDIw8EnHiLVUj/9IBUsBsLgi7yXoDyH5HbNMf9MwoYtCKSrSPlwVjXS2rPUobRU9/NQ+zzOHCzY1XprzG+lQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F6AE5562AED9244CBFE419D3CAB82B99@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fca301f-95b2-48cd-436e-08d9b32ff9e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 12:01:28.6452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB4732
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 29-Nov-2021, at 4:33 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
>=20
> Hi Aditya,
>=20
>> Some Macs with the T2 security chip had Bluetooth not working.
>> To fix it we add DMI based quirks to disable querying of LE Tx power.
>>=20
>> Signed-off-by: Aditya Garg <gargaditya08@live.com>
>> ---
>> drivers/bluetooth/btbcm.c | 40 +++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 40 insertions(+)
>>=20
>> diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
>> index e4182acee488c5..40f7c9c5cf0a5a 100644
>> --- a/drivers/bluetooth/btbcm.c
>> +++ b/drivers/bluetooth/btbcm.c
>> @@ -8,6 +8,7 @@
>>=20
>> #include <linux/module.h>
>> #include <linux/firmware.h>
>> +#include <linux/dmi.h>
>> #include <asm/unaligned.h>
>>=20
>> #include <net/bluetooth/bluetooth.h>
>> @@ -343,9 +344,44 @@ static struct sk_buff *btbcm_read_usb_product(struc=
t hci_dev *hdev)
>> 	return skb;
>> }
>>=20
>> +static const struct dmi_system_id disable_broken_read_transmit_power[] =
=3D {
>> +	{
>> +		 .matches =3D {
>> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
>> +		},
>> +	},
>> +	{
>> +		 .matches =3D {
>> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
>> +		},
>> +	},
>> +	{
>> +		 .matches =3D {
>> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
>> +		},
>> +	},
>> +	{
>> +		 .matches =3D {
>> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
>> +		},
>> +	},
>> +	{
>> +		 .matches =3D {
>> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
>> +		},
>> +	},
>> +	{ }
>> +};
>> +
>> static int btbcm_read_info(struct hci_dev *hdev)
>> {
>> 	struct sk_buff *skb;
>> +	const struct dmi_system_id *dmi_id;
>=20
> this variable is not needed.
You want me to replace const struct dmi_system_id *dmi_id; with const struc=
t dmi_system_id or remove it altogether.

>>=20
>> 	/* Read Verbose Config Version Info */
>> 	skb =3D btbcm_read_verbose_config(hdev);
>> @@ -363,6 +399,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
>> 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
>> 	kfree_skb(skb);
>>=20
>> +	/* Read DMI and disable broken Read LE Min/Max Tx Power */
>> +	if (dmi_first_match(disable_broken_read_transmit_power))
>> +		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
>> +
>> 	return 0;
>> }
>=20
> Regards
>=20
> Marcel
>=20

