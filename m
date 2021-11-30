Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D29462EC4
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 09:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbhK3ItJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:49:09 -0500
Received: from mail-ma1ind01olkn0183.outbound.protection.outlook.com ([104.47.100.183]:36416
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234320AbhK3ItJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 03:49:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPWhVFOKdJKWgZ7NeAqJktoEDXqqEVImzNDsmN4cq+JHtuJnWc8y0KYpklKxBklFshr4WhpFdHfxuCfXzwuUEF+VMnpsJLDqXRq3Nxxb3N4sRMKZPBvOEoJRMjI1TyBoSVHbVw4HOgSqQWZpif+LE3U2QhIo0V01h41P2bgRXDvFMYMKn8NcIuoNOmf6BYpnIJ+phI8rkxmcReGGw3quoqAFWfPFctaxrf969UFf62Cdw2vEGuKx1xHaiDcQq6ArNQ2Q4LS0WzAHpA6VrS5V0X/oBjRcg7XA6khfU2sa07yrSXEIsy3btsvZJ/7ra/Ey9UwfuGWd+b2L9KxeXwupRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A57IResl8mC2kO1DnaSYlabXCUw3vWFloeZX/B3CFCQ=;
 b=GDsLlpwoXypZv0qpZUn2gvImiq0FOKSwhgmvJwSNG6LZuitbrrIgt69tImm63zyrW+9qaTJmLgJrM8oRhCuh+hcYVzuj5Yybu3vK7DHKSQzAbjoEqHiIo9UEQMfXj4uvFSKVFwBt5mIgMY2NY/itHwM7RDykYLqe5Kb7SqhOwIIdVUp0E3SusUWj1PVrlGKFioDPP+GslNvdwpxm7qPqGwcL2mBqHfGr0TXaKHOi9DqPzOgpFxG7DmPd70Pet7rFqK62bUWxQWQLn49hX6ZkXnt3VmejZLX94D+8skE9Eris6nSgGXRBo4WNDNPJFULd5Tttm/nmRJQt+Tux9cM2pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A57IResl8mC2kO1DnaSYlabXCUw3vWFloeZX/B3CFCQ=;
 b=R2Vqt4tmCx653x+AW9DreqChNOE1UYDHNpbsJsWlyhynbgmFUx/pdIFDdz4PWjSejG/eqQ1QHImh7zDyAHSqxVb8fR9RZNHsc1T86kXjrI1bjZg8b9/AlD5gPTMCfnzj5S1Nz3AKcw7VAN4bD7Sx/DObO669KQrEVC9p2VaESaUO14Beysxdbqs/MZmCMxj5HlTktXU3DEL4/0+iTAHuzXzN0FMAU1QXqfrPUDqqKWdxT0NfEf5oZRF3hFqWBGn/JpvYiBxNgOzXoG/UwWPkIqET9jTDw3D2eUGX/MBVPREYeorPtDytJ8trzQ2QxVvOAzFLEuxu9OS7ymmybCu3hg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PNZPR01MB4336.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 08:45:44 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%5]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 08:45:44 +0000
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
Subject: Re: [PATCH v6 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Thread-Topic: [PATCH v6 2/2] btbcm: disable read tx power for affected Macs
 with the T2 Security chip
Thread-Index: AQHX5SmAzZ+x4ZZz8USx8gB+oemfXKwbwv0A
Date:   Tue, 30 Nov 2021 08:45:44 +0000
Message-ID: <087A6F82-BC44-41DE-9FE9-05B5932A2911@live.com>
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
 <75EC7983-3043-41E7-BBC6-BAB56C16E298@live.com>
In-Reply-To: <75EC7983-3043-41E7-BBC6-BAB56C16E298@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [GsOPWDi2qFYZbf14dmc5Y4YrKuKCQ6oGcMypPM3y84C38Cdvm4EX3bCLrOBjLWrN]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e67706b7-e0fd-4538-5c38-08d9b3ddcc55
x-ms-traffictypediagnostic: PNZPR01MB4336:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HvH59m0emLhqs2B5h0n4oRqrZhJf1hSPYJX5D5R0IwtqXJo3yMtzUa5Za3HS1ZCDLPTwD3NZCsWr+97uCdcNSUba+RAzmm3UTphNc7X6HHzzBlz8ucMarVFpQUFUPmPmSwrIWR9NKR9ChIhx/lP66LV/S4/uym4AyIsD6Elys2mui185cnXWZofmq+90fXGFIrmaFqfZzsj77HBw8904h5VC+xBntmxBqrWf1t+vKuUii08zQg3HYHiYgbTN4FGxb345++AojCnwUyP8hnAJ2M8nj6doE4AkC4OXBbJmqO5V+GfPEfySvFql3HQ2JFIirfx/poOLQ4HozaaM9JZRtXtS2bI6doFkmfka10+S6HzMXSL9x4O2IE3vgWjf1Z2kHMBqJ18+g5lcGXZk6/AqmNz3phWnT675kxrLAG12jXP3nLOZ3OFamOg8WvDYkVeNvCABTkg+r7twEflg1Ssr1D38g/RQtC/527p+dB2wHOX5O7Ry3S7oiemhs9NqqZu0lXXB+p6KIV7hRuaFYW9PJYXREFlZps1jp+aXCp68fWWTKj7WJiJEWB4T+ZziUH9MqsNLVbkAOrmMmN1GpRgumEmKmDkApbWtZsMfr+kGk8ObbW++oJ9Eagtmwf9+CwuP
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: Sre7rId3iSKv7dJMkDbTSu8rA4ItxVSRRdxL1ME/+A0wH6s6zE9JNUCWsAU9zpkOR9IYO2oMpTueNixHBMqnH6iAfEI9dZQME3R7WT+GJQb97BqMdvH1tLUYebE2majnggKGha2fXD4V1RMGidufVlqu/zFj6duBfelJVW8/WyUqszrgQbNPfbE+8/wJzkgMKAZeVOr+MEQEUll4QaiLPiYoy5otWmRFb6HEA/vwOlpKREDgmPMlzRATUUzeKJJWVb0YmAW6ydXUdPBYzvWkazGsHfCd7mqx6BcawsV0JYxkb52tUJMDqNvZ5IkGZ9zIVkaPmEZ8zl+sYUvJ6oxuRueEWulbIEDXCMnWVF2Z2skTv/dFZAOzjiIsmmc1dYfgpUUeVLjmQ7QsmgWgyUuWZnaG++VO9s9SOQZ2F6CK4uTDUbSpRxseEbiPW088SmIT0i/hhTgE71xFYeOcuVL9+t11zyHZF461RLmjwJDjSwzz7Z7m8VXpn8AT0H5FFhUKfCAuBL+qSPV4557+eh1kpSh125KPUpKyWCTM+bUaac6sHkrpa8itomt2xx7GV02cDFmAGAcBC+8jjB5Stfs+gVxa+SdXqwKCjEGD37fH7dSZcQ/+hZYmo9jpac/dAbLGFK/ty8V8LzqYS2itwYwQk18nQWmEmCJOhj7C2uX4O8U8OfCDRSUtmiW4Lzp2rWkH+AA3YS+rRUhFrcgdjaqpB2m0hM4Ek6gCYohqAS/rFALr6n9yz3u1bBh/gXdB06BGoMK+uk5669jpzhTcme3TJA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C04D3BF4E1DD646AD8D1B56A54DBCB7@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-3174-20-msonline-outlook-a1a1a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e67706b7-e0fd-4538-5c38-08d9b3ddcc55
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 08:45:44.6209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PNZPR01MB4336
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 29-Nov-2021, at 7:30 PM, Aditya Garg <gargaditya08@live.com> wrote:
>=20
> From: Aditya Garg <gargaditya08@live.com>
>=20
> Some Macs with the T2 security chip had Bluetooth not working.
> To fix it we add DMI based quirks to disable querying of LE Tx power.
>=20
> Signed-off-by: Aditya Garg <gargaditya08@live.com>
> Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
> Link:
> https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail=
.com
> Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
> ---
> drivers/bluetooth/btbcm.c | 40 +++++++++++++++++++++++++++++++++++++++
> 1 file changed, 40 insertions(+)
>=20
> diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
> index e4182acee488c5..40f7c9c5cf0a5a 100644
> --- a/drivers/bluetooth/btbcm.c
> +++ b/drivers/bluetooth/btbcm.c
> @@ -8,6 +8,7 @@
>=20
> #include <linux/module.h>
> #include <linux/firmware.h>
> +#include <linux/dmi.h>
> #include <asm/unaligned.h>
>=20
> #include <net/bluetooth/bluetooth.h>
> @@ -343,9 +344,44 @@ static struct sk_buff *btbcm_read_usb_product(struct=
 hci_dev *hdev)
> 	return skb;
> }
>=20
> +static const struct dmi_system_id disable_broken_read_transmit_power[] =
=3D {
> +	{
> +		 .matches =3D {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
> +		},
> +	},
> +	{
> +		 .matches =3D {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
> +		},
> +	},
> +	{
> +		 .matches =3D {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
> +		},
> +	},
> +	{
> +		 .matches =3D {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
> +		},
> +	},
> +	{
> +		 .matches =3D {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
> +		},
> +	},
> +	{ }
> +};
> +
> static int btbcm_read_info(struct hci_dev *hdev)
> {
> 	struct sk_buff *skb;
> +	const struct dmi_system_id;
>=20
> 	/* Read Verbose Config Version Info */
> 	skb =3D btbcm_read_verbose_config(hdev);
> @@ -363,6 +399,10 @@ static int btbcm_read_info(struct hci_dev *hdev)
> 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
> 	kfree_skb(skb);
>=20
> +	/* Read DMI and disable broken Read LE Min/Max Tx Power */
> +	if (dmi_first_match(disable_broken_read_transmit_power))
> +		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
> +
> 	return 0;
> }
>=20
May I know whether this is fine or not.
>=20

