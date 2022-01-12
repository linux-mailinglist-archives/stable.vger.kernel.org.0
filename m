Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9629F48C2B5
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 12:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbiALLBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 06:01:09 -0500
Received: from mail-bo1ind01olkn0176.outbound.protection.outlook.com ([104.47.101.176]:55766
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238836AbiALLBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jan 2022 06:01:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMHsi5NZIcdKnPyRQ+9vSt8ad6vOxprI4gRQaX7FEJvXbyu4LeRhmQia7JcXJ/VOcgufNn4b+1XXMCxAZOqb0pLWp9ebNq3FdGLC/4Dr3pOIToIRoJhPO5TqmWjMywBtMDOb1VZIGWQ/SCzxmQTGOFoyKpxMZHm4GrURpMRE8f9zkeQAOMSqxeIoCNAba8aFENm0GBJVi+72Gn8WHXOpBLVTPbbYxKcCT4dooJMeH0QYlrAXGl1c8lKSo9cnGvKFNcOMrkVuCELAqOwr+T+FlTsiQOrDfVj1M+hjWFWEp+LPkM6cYIC9YHqB8B0NiBfD0YKLbpqx+Gmd/8sGjWAOaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=566XAWTAEntx2rFCyIpDFcPZ7bPgZhtmUpPVgx+j2W4=;
 b=AMw24OTTkz4ftauaHG3B/98RiW0om2wyB3N1wT4sWZ3wYqramFsDJ3TrZRvYj/dpVYDH5l8SHT7A4gEURTSwzuJRK2mAafRKYUl7Qr5DMRNNviUdakIgS3p6xJJkULfSOMlnVpPZEvc9QJ/lkciO0VhlZFKgwMKN0g3qetOfKzvhPUGjjFYugy7DriUSrkfInjIzToT4OByFB8ehCigi09BFdLBPOwIKwEDBIQJHqM5nh2FWHfmJY1lvtIy/95Vkm0akAnsAOGo18XTel2Y3Y8VkYLF9wvErfnUHk6kay6H+vUeCFE3aclfILCA9N3c25qrP0Om/+NB2N+Kuloby6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=566XAWTAEntx2rFCyIpDFcPZ7bPgZhtmUpPVgx+j2W4=;
 b=bkl/Y5RJFrZuJ91fc+OZHePokNgnq1oG2UKQVXo2xU5uw/FNQymSnlxGEi+3u3bjkQ6Fxmq6OMIamHY8VCXE9/MWQVZzrIF9haKuwJtiCda6HsfcIXbX4Jx8R3CdAeHqeQWaiiBa7OGIRy/map+rTfXb2g31JLi+XX3uJ85x8gNCFIaHPQ+iiLfZyQR642qMmdapP96fA7YbkdStmxvid9iG7rp476nzWN1go7TAkDkQkiRhf/W6baX2BoVhV9mPsQIc4D8XQi0oCJGQKnAezoBZWpKA9MB6Y8Es1f1hdDvEH+TMJfHcrbhfFVOmEVwPope4sK6+ehp80gJVYaZsOQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4809.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 11:01:01 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 11:01:01 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: Re: [PATCH] efi: runtime: avoid EFIv2 runtime services on Apple x86
 machines
Thread-Topic: [PATCH] efi: runtime: avoid EFIv2 runtime services on Apple x86
 machines
Thread-Index: AQHYB50ylhurY5X5s0m/eR0FtoJLiaxfOCAA
Date:   Wed, 12 Jan 2022 11:01:01 +0000
Message-ID: <63283A73-29BB-489C-AA17-479687C1AD5F@live.com>
References: <20220112101413.188234-1-ardb@kernel.org>
In-Reply-To: <20220112101413.188234-1-ardb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [nXNm7YdjHm1LcuISh+uE4VgHHnTOvk9TJU5wXO6dHReZVJljYWjztMk8o9jtp+AV]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 46d2ef20-21c6-4215-b2b6-08d9d5bad200
x-ms-traffictypediagnostic: PN2PR01MB4809:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4+sjvhqAQlp0ER5/8RK94xXEeR2IGkns5SGYLMk8P0YbK+o0MCOTQpU4A5G/afDXLCUBwu4eSbHHrJIrVwqX96KSD9ZlGpudDpaqdaC0JExZpc2kf/ZzKEyk7AfRxY1nALHvkaJRFKstgmuXZAsSvVFJhpq4zRWhJZBI5va79rsvn97RNgOAF8V8k7gaSCpKYlD6aBukmY4mFkwWyD4lZkLZf+mWbvBDE0za4tQnYxvhzQSSiTjZ/x+tDKjBLEOpJkLdbaZ97rESXbzMmDXGYJ0BnGFROyNNxXkZEiKtrAn6jcB5jHH++gsScoR+LyAmQs1jF7WTEblF3PWxX3QL+h9VpF6CKKFcLjru89NGEl4MxFPMxG9n4aFk3ht0CpESO1lOzPh9F8d2vZvyGUyxeXbcPQ0VGFC5BMJs9ZmfAWyuDZHTo+0twQit4bvUNPP9yItvMeNMxHbox22ngli4jjp91sx5bJnEqcCAQar6VtKFfeADo1fNgTm1kqB1AfuNSxKUSLKSU/UUg8bgUPlva0+FG4abmZi+qSwhs+iYLzNBsv3eWhF1MIEQDTWw0rc1bVBU23jv+zQEexJ879BM97y6w0IsF4KpOGBW8EYwgo68qxtp3Qczcl6l+ogEtBFs
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VPmgicJdx817vyMlWfv+2Bzq+6XXkM0At5LTc7ilNRFkWGt++R6PZM/B3BtN?=
 =?us-ascii?Q?MO89GP1JMAfVGLEVLYQ7rT2XIXRwvaLG3nK/AXHiZpgocCfWwzH14Mo6ea3C?=
 =?us-ascii?Q?tin6oIpMm5jjvbsMvNoRu7xvHSq9kKvJXA2P0POf108/LYFnuWbGIgibMeus?=
 =?us-ascii?Q?Mqwl1RMF5CG+oAYvdmKimSCwuc88c0b3e3Yu/Iax4NcgvvPUm3yCglm1M3nI?=
 =?us-ascii?Q?TdCq5tgrSKEWDLpoO4Zklx/GUYV0T1IDs+WmMkK4pNdZ+87YG0o2bKpgXQIF?=
 =?us-ascii?Q?Gt5z1qc/IAXTRWBsUev1OK3tBjfYuTilNSozFrz2HWCCVVjRRtq84HaA/KGl?=
 =?us-ascii?Q?4o38aovDdFoqRUKPTwdNxC4ilHB4D2hEfTV2BteTvRi/v4Ap3dyGbWHYo5FC?=
 =?us-ascii?Q?lnwyD4QocNda2l10XV0gFA6cvS0HkANBZitYIfr+0n+17IeNjtrhd68fhShg?=
 =?us-ascii?Q?QpwMhv0+VAvyJewPhu+L+PeUiKr3bmq6bg0XnQV1DGMjho9GotOq5rkqAu7h?=
 =?us-ascii?Q?2sizQQWu0mLtFWhnwlvM5z/lbW49ZPoHdGU9wmIkRUNvMMRaLCWKA5V7Zrdv?=
 =?us-ascii?Q?A6sdQI5twx0WXZvxyp321rYkVUjkwYOPPqoMuG3V+FQTKUaXy6QWMgtEXbgl?=
 =?us-ascii?Q?apfl7CMXXBcyGPLm2KAHRyQmkywJeXhWYyoj1GO+eOjlvpp/1w+pjpboeFTJ?=
 =?us-ascii?Q?/KgP5VehM9MUR67KEPM9Oc9tpvCg9uIHNcguTZKuA759f8T2tohzpqV/mb1x?=
 =?us-ascii?Q?00nKj7B7rEX9+R1w1dfgwR2wUUwgFDzEjCpugSe6C4yeCo6qLfuCnaKrtxFz?=
 =?us-ascii?Q?OUWkD7jKtZYQ1ObKNzzXlmChJJnHqMkRro67dWWtxYQiEMZDBM3KJja1K4/2?=
 =?us-ascii?Q?SFUhUYdv2EWWGm2SJMdajK8Rj+RHELF7sRMFMZoV2KF+EWo0QTY03lYoBnAH?=
 =?us-ascii?Q?ABvgvt1K1FLkGIfOnb10da5CNEC8yak+n4webZvckGXgVHWpQ6Lkmg4kgOrW?=
 =?us-ascii?Q?iDF2V6ggjOQ400ep8pOPPlRsqw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <077698D441FF5841852E922444D0969B@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d2ef20-21c6-4215-b2b6-08d9d5bad200
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 11:01:01.2703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB4809
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On 12-Jan-2022, at 3:44 PM, Ard Biesheuvel <ardb@kernel.org> wrote:
>=20
> Aditya reports [0] that his recent MacbookPro crashes in the firmware
> when using the variable services at runtime. The culprit appears to be a
> call to QueryVariableInfo(), which we did not use to call on Apple x86
> machines in the past as they only upgraded from EFI v1.10 to EFI v2.40
> firmware fairly recently, and QueryVariableInfo() (along with
> UpdateCapsule() et al) was added in EFI v2.00.
>=20
> The only runtime service introduced in EFI v2.00 that we actually use in
> Linux is QueryVariableInfo(), as the capsule based ones are optional,
> generally not used at runtime (all the LVFS/fwupd firmware update
> infrastructure uses helper EFI programs that invoke capsule update at
> boot time, not runtime), and not implemented by Apple machines in the
> first place. QueryVariableInfo() is used to 'safely' set variables,
> i.e., only when there is enough space. This prevents machines with buggy
> firmwares from corrupting their NVRAMs when they run out of space.
>=20
> Given that Apple machines have been using EFI v1.10 services only for
> the longest time (the EFI v2.0 spec was released in 2006, and Linux
> support for the newly introduced runtime services was added in 2011, but
> the MacbookPro12,1 released in 2015 still claims to be EFI v1.10 only),
> let's avoid the EFI v2.0 ones on all Apple x86 machines.
>=20
> [0] https://lore.kernel.org/all/6D757C75-65B1-468B-842D-10410081A8E4@live=
.com/
>=20
> Cc: <stable@vger.kernel.org>
> Cc: Jeremy Kerr <jk@ozlabs.org>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Reported-by: Aditya Garg <gargaditya08@live.com>
> Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> drivers/firmware/efi/efi.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index ae79c3300129..7de3f5b6e8d0 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -722,6 +722,13 @@ void __init efi_systab_report_header(const efi_table=
_hdr_t *systab_hdr,
> 		systab_hdr->revision >> 16,
> 		systab_hdr->revision & 0xffff,
> 		vendor);
> +
> +	if (IS_ENABLED(CONFIG_X86_64) &&
> +	    systab_hdr->revision > EFI_1_10_SYSTEM_TABLE_REVISION &&
> +	    !strcmp(vendor, "Apple")) {
> +		pr_info("Apple Mac detected, using EFI v1.10 runtime services only\n")=
;
> +		efi.runtime_version =3D EFI_1_10_SYSTEM_TABLE_REVISION;
> +	}
> }
>=20
> static __initdata char memory_type_name[][13] =3D {
> --=20
> 2.30.2
>=20
Hi Ard

Patch works for me. Thanks for investing time to fix the issue :)

Tested-by: Aditya Garg <gargaditya08@live.com>

You may also add the link of the Bug report

Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D215277

Regards
Aditya=
