Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D2F3F942C
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 08:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhH0GFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 02:05:00 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:29624 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhH0GE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 02:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630044251; x=1661580251;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=S5gDZVkl7DqbiTC3VNHUGFMnMm7nOxcSwN8+S6FJ+4U=;
  b=EhwQXEy6w/0rEESXpmnO1EivaTAjhN7fM4zaskLTE1rijxd9EJth6adj
   6kgxYN19rAdusUD3BW2SyX5+OqhFZs1X7BRFlC7vYL7rETdzoHFEpgVO1
   bALtw4quZGZf0omjsi69QwCWV2B6tbeWoLBgpeB45Sf1sBP5DjbaKQQMO
   9VW4Ux3YdGI5Hwfu6YrpQ3OtJWEfKuaC0OZKgSKEo2S/Zh1HX4zK3A3pg
   M5fiVO79UoNg+Ou6bykeEjJtop5un2yPoK4EknjeqVsCtQcS9zSEk4FnL
   yTHShtv3gbzq8d3Ky1WA6Tk88CUUjNH8LiTBFq799Jyuv2+hNG0YLqf6m
   g==;
X-IronPort-AV: E=Sophos;i="5.84,355,1620662400"; 
   d="scan'208";a="177669035"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2021 14:04:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nto2/tV1/rc8O5oqEXisE6+wCx0FQ5ENjKz3BKLwBJL+cO27Wm4jl1aHamC8h+CMZ2x7zEO/azI4ISbCdl9kqvkSS1PYFKgyuleA71u3znOBYbRMdtfOOandYIs6+1W/DJ+eopEjiq6TJJUCdBfGC52SMHDakaCQxnyGVJKLQa2sJ1jyLWUnxmSPeEDvf5F2pQB0F0N30h5No9l8urpbBE5EWQMNmxczrvRrasw6KWK/DG1Edm5vSV+G7euYbvlJeVnszVdRBrNR9jpH+iKy6l9ABIO98BmJI3MvYT/7IJRxofoNuZ0b0LcwLMwRpNincqCBaIiMRGUTIakgqcgf7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3F55jW6Idacds+kXWaSvMPp5tMkxl3eFJbWYO0klgU=;
 b=TABHBfXiqL2uyZ5AtgU77SAjl16GDTImzWXpo0nVyXv0O1A/T1x7AldTu+0YsizNJ/YOHQc1OYGzc1ujALOYcyGKXMbosNuVCsdyVvh+gmPpFscswD6cqtXyQFzg3e8FsOdSIjTkrqPSMqMyb4nanZNJMI7POGHImvXXetXQtw3AT5h01EshvNm1XgIEcsRIZY/RWsZTjiT7mhmgb/s8twRwguN6BezWWow0o1mVw07J9bwvlZf/JivbO9544vfmteD8tE4EV/LwHBWQUUTxSh3OZ1gms0BXzcC2p71MfQNKDEQMl+wblIjh1wNtw4TpREZ83uYHJqv2vnN0z4XqEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3F55jW6Idacds+kXWaSvMPp5tMkxl3eFJbWYO0klgU=;
 b=YC+/0wdOlJxzN1txZmjE1njiiXRauVc2JQ0KkMg8IZCvJCBckb7e8odqSZEEHT/6RIBSMC4tsmaomKyLgwfD4LVhJ0so/A0ASfU+utM9Dfo5Y1a8rSQlT2wsz0refrN03932TN1WenBf+NwqMbrAlZNsv1HOSMqst0O3G5qzvj8=
Received: from CH2PR04MB7078.namprd04.prod.outlook.com (2603:10b6:610:98::9)
 by CH2PR04MB7029.namprd04.prod.outlook.com (2603:10b6:610:96::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Fri, 27 Aug
 2021 06:04:09 +0000
Received: from CH2PR04MB7078.namprd04.prod.outlook.com
 ([fe80::db:f463:b03c:b3d5]) by CH2PR04MB7078.namprd04.prod.outlook.com
 ([fe80::db:f463:b03c:b3d5%7]) with mapi id 15.20.4457.017; Fri, 27 Aug 2021
 06:04:09 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kate Hsuan <hpa@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Hans de Goede <hdegoede@redhat.com>
CC:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/1] libata: libata: add ATA_HORKAGE_NO_NCQ_TRIM for
 Samsung 860 and 870 SSDs
Thread-Topic: [PATCH v2 1/1] libata: libata: add ATA_HORKAGE_NO_NCQ_TRIM for
 Samsung 860 and 870 SSDs
Thread-Index: AQHXmwUrRbSqgVxmMUOflXxx+Wt7Kw==
Date:   Fri, 27 Aug 2021 06:04:09 +0000
Message-ID: <CH2PR04MB70784A9A507CD9F3EA07986BE7C89@CH2PR04MB7078.namprd04.prod.outlook.com>
References: <20210827053344.15087-1-hpa@redhat.com>
 <20210827053344.15087-2-hpa@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a1fea5c-d311-4c2e-1955-08d969207c36
x-ms-traffictypediagnostic: CH2PR04MB7029:
x-microsoft-antispam-prvs: <CH2PR04MB70295C57F0B136CE9E5152CCE7C89@CH2PR04MB7029.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: la17F1e8neok49gyNocIaJRImfeZkqgy/IXO32YHPuC6PqLi6n143KOkLwMnnOQGgW2/stOltHfuVbV2wV96xX4hRczVeOQm5vM9eSWywV0LL8tA88xolXOCGFZsYE+/sQp3uHlCBbe8GsRjLdyufHiYaW8sNhHQUZk9ul2tzlzn7+C4R4hlZEmhJhpvwyl22WONK4N1nRtbSMqZHpYNldpaxQJtCymnqFVyaUf9Rg6sfSD7/ZBOVlIJAwEO058RPWQi/2cH9LFeMO+bvy+nmIEzpPht0rUjwY4yWbsCqcG3J02hRQsEDu0KSMdvmkHYzumeK/h/j4X0hiKfTZW5ybCCGH3R8t95KAxJuDlKJOBQan2Vitzwq8FDuQBLDYRBZz9Z9HjhTYZJHdoOxwE9WlqFpylnbskm2ukohNZ5D2GdTz/598Visy2lbtuHnyalVMav5o22ZUr/E63qeni9Q2BHXNLFL61MScBoTOGJ2cR6UP2kSRKYblhnTPQrsTjrSN0FJKk82/kslSUuB8OzEPEgvZjf5p/lf+A2zihWpp22kCa89qJpkHPfAdYd9RA9KNwbjXwv2NME3a16uqJXHVCQGFWhIm6myFF7TcoSF53VQwttFirKl5bPgECO5X1XW7K4VKFx2WOnicy5K9W42Hgv6LmripRGsKTAGxrim9vTt82nmqulUCKfslduWmH5+cUK/hbcGn14OrK/vtLK0ojN1dvupXV9e+Ip5uW/3opcBgCqX82ykFDnayJ7UjxJES2CHysGm4DuMBJblD5l6013SXFs7jDfSHTxtzpPE3Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB7078.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(52536014)(122000001)(110136005)(83380400001)(316002)(186003)(71200400001)(5660300002)(38070700005)(4326008)(38100700002)(8936002)(54906003)(66946007)(2906002)(66446008)(8676002)(66476007)(66556008)(64756008)(76116006)(966005)(6506007)(9686003)(53546011)(7696005)(33656002)(91956017)(478600001)(86362001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9FK5jc0mBTFSXEcs3pfPrAXK7MpSHLRFqTZDWjmFC8c9Xusk5XU59IX+Rti/?=
 =?us-ascii?Q?w1mp2ofH6DK7UadPdiD8mjxwMUh7/s7tEgkuIOnhKQErEvivCG3ytWbJ37Ui?=
 =?us-ascii?Q?+kPLX/9drOKPygI1Ss1ncN5h1+NkmRJirtrg2U7EPhiot0v12HGP29KFvr5V?=
 =?us-ascii?Q?SGlSRwWtIgYzeYyj/NuLi4Ng1S0bKLgIvkwKt95UD+9GLcIxjZIiDWGyARD3?=
 =?us-ascii?Q?LA/Z9m8VEKWAG98IkIGiohZE4bDcK40JdK9CF+GscgUyKWUFpdEsvFHaPQKW?=
 =?us-ascii?Q?fJScaxYu5tYPMj7uNYJ9iXzhNb/+wRX1LyJBMWJJ58CEtvxmkoVC451Uc6Ks?=
 =?us-ascii?Q?191B1RulOBFeJqiDiDSkvnlNnV2MhPL+6yDiGUNPWCA9Gv+JyLUiDKPkW5BK?=
 =?us-ascii?Q?Syde0poB3ntQd70fwO6V1lJxyzktWz3pQNaKDQlsE+I5zl0CD50oFtfmBp11?=
 =?us-ascii?Q?05bnVx6mCE/NChUutomc9i+cFa1G4TRMs5DtbzDOWvdWBF1F6F1itgcrGGhM?=
 =?us-ascii?Q?pHZWmzKhgjOIx/WKsrA9Qs4IVPD1S0NJW8rM+pjb2Q7L101tZGCtBay0wcg0?=
 =?us-ascii?Q?ifMddu2nfZ0lX1hqxQ5ofmLq0izUX6uGL4xWpHna2id3ImjPnIKBpHZIE0SZ?=
 =?us-ascii?Q?GaCUVXvzCiIp4GjUvyfAUMU+zVv6N6QKFSy3UGhB7PdmvAQWRkSsIu36tRGZ?=
 =?us-ascii?Q?Er3OiGJ4jO5An+aiho1gwOA7C7MwFj3S2Z+82DDJn40XHWHpqjuDF67i5WPv?=
 =?us-ascii?Q?w+aAWrFIXy4NW7ZFD5kSseQpCfqzSoW7KQMm9Pk5kCNih2amxQ0I6ZSW8GTN?=
 =?us-ascii?Q?yRKhlCg2A3jlb+cUUMUOIbiIGmoVq4A3tRPYyLUWDlJ+eqSW7WctGkLKIMdN?=
 =?us-ascii?Q?ik246xYpDo5DWm6hrEn0gg4qjuz3bCBJ1RhawQiAcRhYtiXu0mOsMwuXN+5N?=
 =?us-ascii?Q?nH8FHcQk5SRuvmb8gbttSmwBeMsmxBn8faglWtQUEnlEz6+GWKVc4KVW42Ii?=
 =?us-ascii?Q?/AEyjdafGSZ+02JNVY6YH2eqaawUBoIvLVTBiO5p09XoyHr9+0XxgtFDPm2Z?=
 =?us-ascii?Q?m4TFWRXI7eZbHfRvmo47HaudB1hxOb5dLRhlh3wxp+Ux4Hq1gGDSbERzvwfd?=
 =?us-ascii?Q?UcWz/8RtUw3z3sFklx3W162j6cCfzD0YiDSdrVXo2QfMr7eribMAE+yroA3j?=
 =?us-ascii?Q?9r72e0QwNAER0QBLtbxJknyNjcvbtd07gtrfZMqhqBl9xlW5cSZtul52uM2P?=
 =?us-ascii?Q?BCL+RlSEUY1U/e4XecHAYm36KI6MkQl05hEOxGNd3eBs119oCR+mBnXLH4Pi?=
 =?us-ascii?Q?nALqkIz14IkMQFdDDPj/HK9Mg6mku+2x5E6/yqY6O6lTNVYvv/lWpe89CMMa?=
 =?us-ascii?Q?Z8VJaa6aJDUJQz7pl2hqMeqzHOKbnmExxlQh89ogEsSq/XqtOg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB7078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1fea5c-d311-4c2e-1955-08d969207c36
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 06:04:09.2629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aH/nX256XY9nLLeLYDu6cX2q2SbQkoTGlfC1Fxq5KjvkEgDNuObu7rE30P2VoSIeoJuVPB1DcfKo6AIeuXCyIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7029
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/08/27 14:34, Kate Hsuan wrote:=0A=
> A flag ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL is added to disable NCQ=
=0A=
> on AMD/MAREL/ASMEDIA chipsets.=0A=
> =0A=
> Samsung 860/870 SSD are disabled to use NCQ trim functions but it will=0A=
> lead to performace drop. From the bugzilla, we could realize the issues=
=0A=
> only appears on those chipset mentioned above. So this flag could be=0A=
> used to only disable NCQ on specific chipsets.=0A=
> =0A=
> Fixes: ca6bfcb2f6d9 ("libata: Enable queued TRIM for Samsung SSD 860")=0A=
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D203475=0A=
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>=0A=
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>=0A=
=0A=
Since this is a v2, you should not keep the review tag here.=0A=
=0A=
> Signed-off-by: Kate Hsuan <hpa@redhat.com>=0A=
> ---=0A=
=0A=
This is a v2 patch, so please add the changelog from v1 here.=0A=
=0A=
But I think that v1 introduced ATA_HORKAGE_NO_NCQ_TRIM. Yet, here you intro=
duce=0A=
a completely different flag on top of the patch that introduced=0A=
ATA_HORKAGE_NO_NCQ_TRIM. So this patch is not version 2 of the previous one=
. It=0A=
is a completely different patch. Unless I missed v1 on the list...=0A=
=0A=
=0A=
>  drivers/ata/libata-core.c | 37 ++++++++++++++++++++++++++++++++-----=0A=
>  include/linux/libata.h    |  3 +++=0A=
>  2 files changed, 35 insertions(+), 5 deletions(-)=0A=
> =0A=
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c=0A=
> index cc459ce90018..50f635669dd4 100644=0A=
> --- a/drivers/ata/libata-core.c=0A=
> +++ b/drivers/ata/libata-core.c=0A=
> @@ -2119,6 +2119,8 @@ static inline u8 ata_dev_knobble(struct ata_device =
*dev)=0A=
>  static void ata_dev_config_ncq_send_recv(struct ata_device *dev)=0A=
>  {=0A=
>  	struct ata_port *ap =3D dev->link->ap;=0A=
> +	struct device *parent =3D NULL;=0A=
> +	struct pci_dev *pcidev =3D NULL;=0A=
>  	unsigned int err_mask;=0A=
>  =0A=
>  	if (!ata_log_supported(dev, ATA_LOG_NCQ_SEND_RECV)) {=0A=
> @@ -2138,9 +2140,32 @@ static void ata_dev_config_ncq_send_recv(struct at=
a_device *dev)=0A=
>  		memcpy(cmds, ap->sector_buf, ATA_LOG_NCQ_SEND_RECV_SIZE);=0A=
>  =0A=
>  		if (dev->horkage & ATA_HORKAGE_NO_NCQ_TRIM) {=0A=
> -			ata_dev_dbg(dev, "disabling queued TRIM support\n");=0A=
> -			cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=3D=0A=
> -				~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;=0A=
> +			if (dev->horkage & ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL)=0A=
> +			{=0A=
=0A=
Please follow the kernel coding style: do not break line before "{". This=
=0A=
comment applies to all your modifications below too.=0A=
=0A=
> +				// get parent device for the controller vendor ID=0A=
> +				for(parent =3D dev->tdev.parent; parent !=3D NULL; parent =3D parent=
->parent)=0A=
> +				{=0A=
> +					if(dev_is_pci(parent))=0A=
> +					{=0A=
> +						pcidev =3D to_pci_dev(parent);=0A=
> +						if (pcidev->vendor =3D=3D PCI_VENDOR_ID_MARVELL ||=0A=
> +							pcidev->vendor =3D=3D PCI_VENDOR_ID_AMD 	||=0A=
> +							pcidev->vendor =3D=3D PCI_VENDOR_ID_ASMEDIA )=0A=
=0A=
Please align the conditions.=0A=
=0A=
> +						{=0A=
> +							ata_dev_dbg(dev, "Disable NCQ -> vendor ID %x product ID %x\n", =
=0A=
> +												pcidev->vendor, pcidev->device);=0A=
=0A=
Weird alignment here too. Move the arguments aligned with "dev" at the begi=
nning=0A=
of the line.=0A=
=0A=
> +							cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=3D=0A=
> +								~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;=0A=
> +						}=0A=
> +						break;=0A=
> +					}=0A=
> +				}=0A=
> +			}else=0A=
> +			{=0A=
> +				ata_dev_dbg(dev, "disabling queued TRIM support\n");=0A=
> +				cmds[ATA_LOG_NCQ_SEND_RECV_DSM_OFFSET] &=3D=0A=
> +					~ATA_LOG_NCQ_SEND_RECV_DSM_TRIM;=0A=
> +			}=0A=
>  		}=0A=
>  	}=0A=
>  }=0A=
> @@ -3951,9 +3976,11 @@ static const struct ata_blacklist_entry ata_device=
_blacklist [] =3D {=0A=
>  	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |=0A=
>  						ATA_HORKAGE_ZERO_AFTER_TRIM, },=0A=
>  	{ "Samsung SSD 860*",           NULL,   ATA_HORKAGE_NO_NCQ_TRIM |=0A=
> -						ATA_HORKAGE_ZERO_AFTER_TRIM, },=0A=
> +						ATA_HORKAGE_ZERO_AFTER_TRIM |=0A=
> +						ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL, },=0A=
=0A=
You named your flag ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL but you are=0A=
applying it to a Samsung device. This is rather confusing. I do not think y=
ou=0A=
need to have the vendor in the flag name, e.g. ATA_HORKAGE_NO_NCQ. Whatever=
=0A=
device in ata_device_blacklist has the flag will have NCQ disabled.=0A=
=0A=
>  	{ "Samsung SSD 870*",           NULL,   ATA_HORKAGE_NO_NCQ_TRIM |=0A=
> -						ATA_HORKAGE_ZERO_AFTER_TRIM, },=0A=
> +						ATA_HORKAGE_ZERO_AFTER_TRIM |=0A=
> +						ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL, },=0A=
=0A=
If you disable NCQ entirely for this device, then what is the point of keep=
ing=0A=
ATA_HORKAGE_NO_NCQ_TRIM ? TRIM commands will not be NCQ anymore, similarly =
to=0A=
all other commands.=0A=
=0A=
>  	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |=0A=
>  						ATA_HORKAGE_ZERO_AFTER_TRIM, },=0A=
>  =0A=
> diff --git a/include/linux/libata.h b/include/linux/libata.h=0A=
> index 3fcd24236793..ec17f1f3fbf6 100644=0A=
> --- a/include/linux/libata.h=0A=
> +++ b/include/linux/libata.h=0A=
> @@ -422,6 +422,9 @@ enum {=0A=
>  	ATA_HORKAGE_NOTRIM	=3D (1 << 24),	/* don't use TRIM */=0A=
>  	ATA_HORKAGE_MAX_SEC_1024 =3D (1 << 25),	/* Limit max sects to 1024 */=
=0A=
>  	ATA_HORKAGE_MAX_TRIM_128M =3D (1 << 26),	/* Limit max trim size to 128M=
 */=0A=
> +	ATA_HORKAGE_NONCQ_ON_ASMEDIA_AMD_MARVELL =3D (1 << 27), /*Disable NCQ o=
nly on =0A=
> +							ASMeida, AMD, and Marvell =0A=
> +							Chipset*/=0A=
=0A=
See above. You do not need to have the vendor name in the flag name.=0A=
=0A=
>  =0A=
>  	 /* DMA mask for user DMA control: User visible values; DO NOT=0A=
>  	    renumber */=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
