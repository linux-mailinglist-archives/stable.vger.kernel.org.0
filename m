Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8981461A45
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 15:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbhK2OwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 09:52:11 -0500
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:54753
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232392AbhK2OuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 09:50:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHXWRhf4uymd55XFE8GAE2oFVYbYLaofJPm1TDVV0C5Y6vaj9ZdemTQ58MrCJeUW+VzUjQKxCwt+GC5r8nmMK9jqeDsnfeeqENlPQTv917940IcQheiW8ADccIkMccw3bk2MFvd+WFG0KniZTLf24ZzgIfa/DkTay+jEdX/fbAcuTab0HM8W6Sv8w4GG7XM9ktUvQTI3JKpFBOK3Zt/xtK9qEw2HcYIXwvpuQsJB9QjAh0JBt5wzkGHdhfLcNbwiAZI2USN0/isGjM4j0Zpn1uAjoyEW6TI9895vqpq7qi8DWBFCuHnveC22ZD6A0CEqPDeGbolIEsG7yW7yEqyidA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRib5jpSsoCobK/75WZgBuY4dzgHbBccLeJr/rOVogw=;
 b=GEmI44R/CSUvtqbikUaGbw8l4fU9JLxoAfbCW4YoSGSpi6eve3vyNqQj5JGSPyFENwUvdvheJsLRWug/fT6P5x5VmN8vvWATFzmdNIT//HaV/55tux+hWCgC52KHWbP3ETqGMeLjqi6Q7x0sJg3+RVZ83GKmOViRdOfne2gZu8TTNepNiQbBBAqpeIIXnj7UnP8U2Ej3cOa/+As9vH79D2hIWD3jYhdDfeT6Tv0XH7QQ+9c6oDnqoq6JAt7yw1bVcrsqsztVWXFqRNKamGWtdZYnPZUxBSO7rk4ANXaAZmOF4f46aCMrRqNVUBgznQn5OLtgQiMbtKtM/uX3Qxjfuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRib5jpSsoCobK/75WZgBuY4dzgHbBccLeJr/rOVogw=;
 b=ARLfGxMdzf1LFcmzf3UMo9WJsULVOZX9mW8y8n1DXRs0BrkrPzbR3t77w0pdnagRfRiORoZaL7xH+y2l0cKiJb1ZXhHWB5ME+zqu2nzxYqn3HzlpSvfu8a4qMfJqXYbkLFRIFj7Sq8o4rjgJpDVCcLkqgcCI91T3CVoD5EkTM5Y=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 14:46:17 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 14:46:17 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Shah, Nehal-bakulchandra" <Nehal-bakulchandra.Shah@amd.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.15 27/39] ata: ahci: Add Green Sardine vendor ID
 as board_ahci_mobile
Thread-Topic: [PATCH AUTOSEL 5.15 27/39] ata: ahci: Add Green Sardine vendor
 ID as board_ahci_mobile
Thread-Index: AQHX4m3uPxsKKauYfUq7c8cFdZeHxqwamtfQ
Date:   Mon, 29 Nov 2021 14:46:17 +0000
Message-ID: <SA0PR12MB4510887B220088ACAED885B3E2669@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <20211126023156.441292-1-sashal@kernel.org>
 <20211126023156.441292-27-sashal@kernel.org>
In-Reply-To: <20211126023156.441292-27-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 484f77fb-8de2-442f-a06a-08d9b347000a
x-ms-traffictypediagnostic: SN6PR12MB2717:
x-microsoft-antispam-prvs: <SN6PR12MB27178E9636C36B29824F2C5CE2669@SN6PR12MB2717.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l9BSTdg6EMDA97rPyNARiugOOl4ZghUldgOKwGvn1WMfBTNHA59NxqWhbUOMza0KKxsdwJNtMX6PM2WRNmPvmMKhTTBKkj3V3rTXBXFox9uafS0SekxYrhSLT4IJ6ybUWUMcmX9ST6Qz8jwE5XFHDdYuiL6fIus0DLEZC8dazkH/e90n1lAZ23FMuCK9ZnbDr7l5V0luEYD6IJoyqSBiMe/WDg0V870ozOvMWxvWC3wOTgAHonWmnBcr9lMS6+vVR95gx0I3BMGDS8VvwBXpWbU69Z1THG08BDBsQmdY/JkkDUBzabUqY3pBVMfbsdlE1dAbr69sYBP7XPRu+4++/da2LIS4c/MhC4bj10hvWxzDUSJVb7ruQL2s1a+TqRcmL9aprHAsCiWJCgi4NqI23al43QU2CT4HM+w05KygufOOGWX5kHfD7dJ5bsy/1/RX0GdUCmIpEnP5HzZ15Du7L8f1rIPqq/TV5gvw+UN/0X840jNQmiDB0npA9LXxR5lAJec0uhuZ/WgjRx7+UeBDLmhpeLs3jBa0fh+KlSnpN6yVQc61kBOAKxW5bdviKyW23ditnirIX5khjzkZ6DxKu1IJDKbbb7chIZGoC7R4d+Z/PQ3sTxSL2PpQWTm6ufJQIwAv0KcKdi3V8MKrpneZ4iS2FNQZfyTH5JiBH7ecM+21LK8mIm5JwkvxN/OdgqTApIr0iYgYClxCQy4qWr61lDOFZVmHoZn8FByc3kApvOI5B3I2USPdbm9VfekEszNXVWWlN3UmsEm/PVyw1MUCvDbfl556NtO9TZIpbEdQuv8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66476007)(52536014)(66946007)(76116006)(26005)(66556008)(9686003)(2906002)(45080400002)(33656002)(186003)(38070700005)(55016003)(7696005)(66446008)(64756008)(6506007)(53546011)(38100700002)(122000001)(4326008)(71200400001)(508600001)(316002)(86362001)(110136005)(8936002)(54906003)(8676002)(966005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NgMs0G89Hy/XW7wYxq+jAZ8/tpOojGZ3v9zj7ez8RNbxV2oHWnFbP0Fi86p8?=
 =?us-ascii?Q?MXK5ZGzzsfEPl5YN1WZfkkhpqDnMQSp6caA8whXZASKcSOb1e7BDWqBcOSZj?=
 =?us-ascii?Q?js8/mZalUPK0gNNCUkkC3V0MD5L3gThsk8NxK1QakHehk1m34DJSn2l3B/+P?=
 =?us-ascii?Q?gqXGYWZykcmOdt+MMTnsRInfSNskyc8AuPLVCePnJtbzlQpyUY9jXRRlhF8N?=
 =?us-ascii?Q?3wiFJ4YXvCjM92ngq36Adi7kxI+sLEUqw5TJ0o1Gvzkz3Wo5g1biS4etNyMY?=
 =?us-ascii?Q?pVYpkMjjwLnaLk23Nb5Fusqx6mSSuBIx/cqAX4K2+oZZdVDjpPaQCcCGsciy?=
 =?us-ascii?Q?h0T9p7br7MCOIL+PNFVrNr9VojErkbhmu9lUGr7Qi5GWk/JFXngIEtdTJLW3?=
 =?us-ascii?Q?8a2/YvWi6r5VnJ/woyDu4cEytK5ojdoE+J6rlveulhe2kxaUoTfd6I9Wa1Sk?=
 =?us-ascii?Q?YcE2keScXCC25CC7SoZnkG7KhLbDllZDSeX1BEmeR+XW6ZjGVp3y3dwmnMIN?=
 =?us-ascii?Q?Onmz71zTC4usrWsmnDY31QOWZ7u4c3pCFItuEnt6MNHbBurcQDV1mSVUGD1c?=
 =?us-ascii?Q?87SY8Ph8FIYJW4oDJep6SUFMj4iFrOeimnCVqkeE8wB/lXi7Tf8F8I9ZAe6b?=
 =?us-ascii?Q?h4VlGShZJe+jdc5iaQJpoU5X0rryL01CrKBLPwZwF7aHNJWi5m+cpPHC/FhF?=
 =?us-ascii?Q?yEmXbKgwe8CC/C4Yskvk3GKMyAiHAwZlbYpDrOkhsNCcIOmaqWL8hxSbv7zL?=
 =?us-ascii?Q?xr0o2nHvbVQKphEZgn+iHVkGngP7+PxL5VfVoMaIv+aB5HfCcrJ9Ze5NyGe3?=
 =?us-ascii?Q?741cVTNCPv+DrF9GIV90UyzE2X+PEa1S9x+C/m5DO6UtInEkylpQTcQS2YgZ?=
 =?us-ascii?Q?LOMeO6eJil6ZRIF4tghGyRdi2EuT6iMpcBiuw17Bb1grCt5q63Fz3jwDZ0WS?=
 =?us-ascii?Q?gt01KCG3RxVMINkbJXXEah+Cymz4VFURjCtzGILppmYESwOwJF1Oca1FjGKz?=
 =?us-ascii?Q?KIqAE2kxmAdpL8ZVtPSkGoIGuUcycL3RbHsnp25PThrmybbWTDLS8P0NkWtU?=
 =?us-ascii?Q?ak+dtSDlhY12zZlfl8Lt+4+Ob/D4/Winjj9oyQS1Sx92t6hjb5oOUpJFx/4u?=
 =?us-ascii?Q?5/K647xU/x7l2Cnw8H9IO5eoMZMLmwHhSaFQBDPoeZ71iSmD64Y/DQIOdMOW?=
 =?us-ascii?Q?UcMJ1Pntspu85EA4PHqlQo8o594gzJxWGrRJHhCmVDJX8GuTAstYMZNgwdDv?=
 =?us-ascii?Q?UrCmQa7ID4Cd4xWNhP4dKR+smgJh9cgV8lkL4g9Rv68nFSy735imcSEch7Ks?=
 =?us-ascii?Q?xoIdidapgGNA3PrrDH0VIoY0IfNVepBGeON8weGm6I5Pkl+vrM6jvoPND+zS?=
 =?us-ascii?Q?GZ1boX8zfN1Ptzh6Rwz/LB+EWO3UzivK1HdFapnmtt/ry/LAlXQYuTGV+w1O?=
 =?us-ascii?Q?5KAQtUBxsT+s3EyI3zpl/HBbnQf8AbzRL14rT4LvE+BZK58UVVmK8G9BhDTd?=
 =?us-ascii?Q?Ay1WAeDUy0Rui0nZgbJDVZQ9V0AwQu/qf1ebfWIA08XvDCmD/z47ovjv1YnB?=
 =?us-ascii?Q?u9LF/V0tMBMoyAlcD20z9HgRk7lyHcE61iDBUrtzuE8odvX0OGRie9sG7NwP?=
 =?us-ascii?Q?rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 484f77fb-8de2-442f-a06a-08d9b347000a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 14:46:17.3406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RayBZCbSBILS9VmJ/KzD2xQ6v7CsNKxQ06lMx+Bk/osEBvb5ViVrc2AK3t/MDk07LA4RcTVJ2rOqrN+x+4yEYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Thursday, November 25, 2021 20:32
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Limonciello, Mario <Mario.Limonciello@amd.com>; Shah, Nehal-
> bakulchandra <Nehal-bakulchandra.Shah@amd.com>; Damien Le Moal
> <damien.lemoal@opensource.wdc.com>; Sasha Levin <sashal@kernel.org>;
> linux-ide@vger.kernel.org
> Subject: [PATCH AUTOSEL 5.15 27/39] ata: ahci: Add Green Sardine vendor I=
D
> as board_ahci_mobile
>=20
> From: Mario Limonciello <mario.limonciello@amd.com>
>=20
> [ Upstream commit 1527f69204fe35f341cb599f1cb01bd02daf4374 ]
>=20
> AMD requires that the SATA controller be configured for devsleep in order
> for S0i3 entry to work properly.
>=20
> commit b1a9585cc396 ("ata: ahci: Enable DEVSLP by default on x86 with
> SLP_S0") sets up a kernel policy to enable devsleep on Intel mobile
> platforms that are using s0ix.  Add the PCI ID for the SATA controller in
> Green Sardine platforms to extend this policy by default for AMD based
> systems using s0i3 as well.
>=20
> Cc: Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>
> BugLink:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbugz
> illa.kernel.org%2Fshow_bug.cgi%3Fid%3D214091&amp;data=3D04%7C01%7Cm
> ario.limonciello%40amd.com%7C2f6ff36f5cec496bfa3608d9b0850ebb%7C3dd
> 8961fe4884e608e11a82d994e183d%7C0%7C0%7C637734907817024215%7CUn
> known%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6
> Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3D6eKGOqpi4UfLNb4Q4mmb
> qaMxxoB5wP3A9BSIXiBTRAk%3D&amp;reserved=3D0
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/ata/ahci.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 186cbf90c8ead..812731e80f8e0 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -442,6 +442,7 @@ static const struct pci_device_id ahci_pci_tbl[] =3D =
{
>  	/* AMD */
>  	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
>  	{ PCI_VDEVICE(AMD, 0x7900), board_ahci }, /* AMD CZ */
> +	{ PCI_VDEVICE(AMD, 0x7901), board_ahci_mobile }, /* AMD Green
> Sardine */
>  	/* AMD is using RAID class only for ahci controllers */
>  	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>  	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
> --
> 2.33.0

Sasha,

No concerns for me to 5.15 or any of the earlier kernels the autosel picked=
, but would you mind also sending this to 5.14.y too?

Thanks,
