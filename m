Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709B34A9FD5
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 20:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbiBDTPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 14:15:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:60994 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231728AbiBDTPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Feb 2022 14:15:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644002108; x=1675538108;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4t3sdyKmiBLiue2jMrvUYIDpzGeh+w/39ToOcaWV3M4=;
  b=j5N4tsRBk/1c2ZYyAp67Z3YDtfMybPGA1xbBji9BeD5lfD1BrfysiAe+
   nrFAa+IiQ0EVBfTNZjzKE32sQBavmAoQi8MLhmV0KsSK5GscY7CM6yvY1
   sRxEnDciZdKCv22DnClJtx9/7NKidiCZ2X9Fxp+2K15NPgkcbzmPZZDh/
   DHektrugxxo3MHNEB55OA/Bu78l+61nOUeaKv5vnQRd02v2/tjIk5+4AE
   GjiUNeDyUaPAPYYhiLyigkctLSdtkzofS2QgUawocfNdOi1JL/hmuQx6J
   x3RqxCQgl5I+daoN33/pt2CpNH6DUNVucniHHjKKphXT17UqF+VsonFQY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="246016728"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="246016728"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 11:15:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="483708061"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga006.jf.intel.com with ESMTP; 04 Feb 2022 11:15:08 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 4 Feb 2022 11:15:08 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 4 Feb 2022 11:15:07 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 4 Feb 2022 11:15:07 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 4 Feb 2022 11:15:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro5gmoPT0abDf7+HwlNnFQfnvit0OXRYnHRH9ljujjWmjJEPS4pDW0VsX9uoNdz9vChYTzu+vnhIPtAbBTkKE71rvPSJPPDTHE5cO/JWqWNAMN0J3fWYormF10JWgHUGmwHLi5W0s7fsAD/ZLVZJtM/Nwgx/q0hCm3xBDiL0Vp/xPM6074LHWhSoZb+9EdfMpyYHtlfEiRuVdQffp6bl89zaNcCIthc8mlcVxs2TEaVFWXMB5NKkN5to9k/o+fpCaHm6NEcG/54NdFUAVZIOuhr8HiLCokZIHkb0zwPqYZrdmT3oExmjCbkrSnoye5t6pwei39B6m+iFmx7qzzPb/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgG7zcMYwJAYOTr5f91+C+mEKLsEXlS4Dfx8diNfG8I=;
 b=A964P4APEnzzwYolWcb2CLKTkn7yholLXhXZJfCGdDjlMuRpTxNCZ0x1m/gw7gsndyES+OJKhxARC4JjRFFAL3S+9h9tk/Oh2B/W47o7C2fWwDGtMQVAWiGSl1NPAwSAa8HXJxDqLWfchB9QuF+aCR4xF8TMuASJBgpNXxbhza4euQQsPWQ3jcZDHtNuzH3+B8b4Ou+e40t//pgl3JGosoZ0fDySyOVWCDMoFe84tFVZoa5EyhNxcSGmUrFIIM4amgmZ8GUXV0yvjyiT0Zu9vTdEpdILPT7QUhS2WLXk/le72TLpzjDt3oFQXenglrNqw9Iu6z06LnlGWDKApEmDVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from CY4PR1101MB2184.namprd11.prod.outlook.com
 (2603:10b6:910:24::20) by CH0PR11MB5756.namprd11.prod.outlook.com
 (2603:10b6:610:104::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 4 Feb
 2022 19:15:05 +0000
Received: from CY4PR1101MB2184.namprd11.prod.outlook.com
 ([fe80::4826:ba22:57d8:dd71]) by CY4PR1101MB2184.namprd11.prod.outlook.com
 ([fe80::4826:ba22:57d8:dd71%9]) with mapi id 15.20.4930.023; Fri, 4 Feb 2022
 19:15:05 +0000
From:   "Pawnikar, Sumeet R" <sumeet.r.pawnikar@intel.com>
To:     "5 . 14+" <stable@vger.kernel.org>
CC:     "Pawnikar, Sumeet R" <sumeet.r.pawnikar@intel.com>
Subject: RE: [PATCH 4/4 4/4] thermal/drivers/int340x: Fix RFIM mailbox write
 commands
Thread-Topic: [PATCH 4/4 4/4] thermal/drivers/int340x: Fix RFIM mailbox write
 commands
Thread-Index: AQHYGfTgA29qekR4bk+wOyGLeTecLayDwrZA
Date:   Fri, 4 Feb 2022 19:15:05 +0000
Message-ID: <CY4PR1101MB21844357582EF8FBBF45E734BB299@CY4PR1101MB2184.namprd11.prod.outlook.com>
References: <20220204184652.8731-1-sumeet.r.pawnikar@intel.com>
 <20220204184652.8731-4-sumeet.r.pawnikar@intel.com>
In-Reply-To: <20220204184652.8731-4-sumeet.r.pawnikar@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e27aaca0-08ec-4c21-20c3-08d9e812a6f1
x-ms-traffictypediagnostic: CH0PR11MB5756:EE_
x-microsoft-antispam-prvs: <CH0PR11MB5756C4583E7C5DB21551E2EFBB299@CH0PR11MB5756.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wRGogxlsymnaPkLJ87HTwkkRGaMas0g90ba2AFTRYgJq3pkTDiCC3aRFDUZjZyXsq4sZPHKAO1+j+Rv4weDFbGMHgrbsmm3uIn4HCPtQ5zOitMdQLvCMzmilv/81bXMCer7LCx9fvBqMVfKBJvtKXSSXKyMYme5JHPZgouJ+GPMYtNCB6J2Wo+ABaobX3abFlkoAqbOSJLnHBfFZZGzM8KfG5VuyPjKem9+Zo6wAlOUivVT2Y4x6Yl5R+FlS59O6nv4Cjy0s0HuaF+x1dFb+OjrUsq/jiZO8kZ8iZb1o4fjabS9q5XmES08sVlo6QzVP+NdxJNm9ncMj8T5aIj0gkCEPCYsFNokMutjzGQ+S5oe+QfczzHJeqViJgCYVkyRhq1MyxMRdkuR5x7nQyVchQAeGFsoT61/Oa8O10kZWJHYnsWI+CJS2HHwKn/dg7XXamsR+k3/8STM3OIrV+lfuhw60kNS7BTyqnNOi+UVPl/a5clhqJjSyLYWRk6iRYqoYxWUwHdscQ19Hm3hVTWQlxYAxlYw+SZhegScF68wrrQ97FTlAgRJoYsRcyyCQr7zE/4/qQU+BMfdgllZH6EJC+bDvGgXRe55JQMAf70yTMBm5zNVXh0OIo4EXyLqDPYAe0Thi5RGEgGQ6C3KI72oLjTEdqkrQDni3/GYBtOcaYHfBvTCJHw8SSD+9KfHi0LNkRWA0sG4mIZ5nqeS99Tx+ZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(38070700005)(122000001)(52536014)(5660300002)(38100700002)(6916009)(316002)(64756008)(508600001)(76116006)(4326008)(66946007)(33656002)(107886003)(8676002)(2906002)(186003)(86362001)(7696005)(82960400001)(9686003)(83380400001)(66476007)(26005)(66446008)(55016003)(15650500001)(66556008)(6506007)(30864003)(53546011)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?67hrqJXWWLUsoZNQmpfI5WyEtIwOkLcZlYSxeC/ldRMbKU+RP8GJ1vYCOcGv?=
 =?us-ascii?Q?IQo9Z1StTWO7p5sA6nVor514oXDzCEQsms+jxE6Kocl8moOcQmY9KWBx+O/O?=
 =?us-ascii?Q?r4K4mzxKK1UbEx8x/FDyKMN62Oh1mjoMB9NZU1BnwKf7jcL+bL7/bkByIu8C?=
 =?us-ascii?Q?e1ZDpqgXWwEPpdfYP2/sPiCis9Rzo6DTVOfaYLfF2Hw0/zdmucsoGmeJA82M?=
 =?us-ascii?Q?JkUgQ2N0caH4edjYExkycxGrIKRhGYN+IuG1P8jDXsNFmwooO50zv99nkqX0?=
 =?us-ascii?Q?rRsipJpr05Aa0NnaFoA6gWDfVKNu5wS1e/SwPqI0egXnG851MoRrQP5kyZH3?=
 =?us-ascii?Q?kVucomYIY5Py0IeDRcOBPhdeQ5SLatXLBxgWBg1rHuKh8ZKdINW8PEEfGbKH?=
 =?us-ascii?Q?pA37Wn1iEeeBJUfVDD1iET8KipG7eH82fqQLFW/vDh2zD0ewvjCVnuYVOCge?=
 =?us-ascii?Q?AQwq8v+aqnwJdfusDDhbZ24KwKnmiZ/WhWXIyr3QitxYq7MlkSeacuLfhO9C?=
 =?us-ascii?Q?IIp0mnHQk58MzVXXezktnhzyVB7r4aOrOHtyl5oKkuqZ5839twSPrA4ivZrA?=
 =?us-ascii?Q?PprpAbrjs1UJPJWNLas7tFqdffAeaDlfEQGq//Do56hBnJeK5NqavFpQgFVx?=
 =?us-ascii?Q?ys7tjf5sDu2RBAcx8c4O1V6lvHSFNcf09kRlQ77DMYIbGkp2YtRLwEzIoQcd?=
 =?us-ascii?Q?DwAQ+RAinVDdeRljt85/dBU/R7K/ZZbyvjVGgB5CQkITOXjRLGSVveLK1MS7?=
 =?us-ascii?Q?LE7f06yJWir7lxFPYliESnOd7exorTdZ5SckO37k3a00iKS8y8C16ABPSYov?=
 =?us-ascii?Q?5/x2M5IxA/CPQRLei2nUJc6Qe6ZPNkouZrEo8FIXdOjlWeFMdTos8GFKZw2Y?=
 =?us-ascii?Q?BB32FgPJZWFilS7uwH7QcQZrxUlrAPPGjB2u3lOSQki2JKeRRL15uNksvdZg?=
 =?us-ascii?Q?wJrs32rzuDKfpGbaP4D3tZBd48argsXTQO2P8tIRfdsB3xq0ViCSnYifrOHW?=
 =?us-ascii?Q?XyQAd/T89V/xcdG1jDQiOCGm8HXcdlQqk/HfQCuGcDihoHdOh6wEjfUJ+a91?=
 =?us-ascii?Q?opdLGdHOSHBxtVubwLaEwN+pn7pih/LA6Dmo3ihPOiwSgO1oeQgg+pFruupc?=
 =?us-ascii?Q?/ZO4p7JcHpNjEFUHsJJ5M/2s9/Voem+RuByPFKESsGhMCgmVBqoZ1Qr98jyd?=
 =?us-ascii?Q?K49cvKm4qb2UToDHnVOIBa3vflaT56MvUPFOaGCOvWVZyuk59zVUIgjT+E/4?=
 =?us-ascii?Q?CAHHanSLPGgXZxJZEBFVvsjiTmNRoXT4/JpwZrbigqFJrWns2LZvJDNJ6OqZ?=
 =?us-ascii?Q?bU4K+7zBqQZqBtV0T14mUl6UsUIrgz2FsHB5tJES9XodJY97eY/RGYPHexIT?=
 =?us-ascii?Q?hL4UxZAxiEU9Mqc2nugahugamzDyATC4vbNWc7I9ynhCU9I3VVpPpdlTs8mU?=
 =?us-ascii?Q?i5xTIocxwV5U1H2f/wxbo9iMe5um+cBfFkB6tO7Oh8Uvz5leMB7Z7KOJXx7m?=
 =?us-ascii?Q?CM9R75ePAL1NeTHtsiATvC0u0wkxPYjQEwB9ocvDOkxdiQeEU7/8hpsseYyi?=
 =?us-ascii?Q?2jv7YsH487q+MbIsDFwS5gVUCEu9mhhmrOStogfFbDmYAsYj2sv90BJMMJ+Z?=
 =?us-ascii?Q?CPv6orLvQcYKSCPVhIxZ/zT9azuUa0y6GD7eL4pz0fK6BP7bgoaXC647POXF?=
 =?us-ascii?Q?7yPbnw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e27aaca0-08ec-4c21-20c3-08d9e812a6f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 19:15:05.6261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l4doN/J51N3xOYXEdFks+7/alnLgG5MbpfzH1mUAwgbfrLBzPjPTDPLaiINhlyOCncDIvo7fM+geCkraJ4G12LPnJBLXiEJ/bUkCn8EbByI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5756
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Pawnikar, Sumeet R <sumeet.r.pawnikar@intel.com>
> Sent: Saturday, February 5, 2022 12:17 AM
> To: Pawnikar, Sumeet R <sumeet.r.pawnikar@intel.com>
> Cc: 5 . 14+ <stable@vger.kernel.org>
> Subject: [PATCH 4/4 4/4] thermal/drivers/int340x: Fix RFIM mailbox write
> commands
>=20
> The existing mail mechanism only supports writing of workload types.
>=20

Please, disregard this patch. It was mistakenly sent before sending other
 dependent patches. Sorry for the inconvenience.

Regards,
Sumeet.=20

> However, mailbox command for RFIM (cmd =3D 0x08) also requires write
> operation which is ignored. This results in failing to store RFI restrict=
ion.
>=20
> Fixint this requires enhancing mailbox writes for non workload commands
> too, so remove the check for MBOX_CMD_WORKLOAD_TYPE_WRITE in
> mailbox write to allow this other write commands to be supoorted.
>=20
> At the same time, however, we have to make sure that there is no impact o=
n
> read commands, by avoiding to write anything into the mailbox data regist=
er.
>=20
> To properly implement that, add two separate functions for mbox read and
> write commands for the processor thermal workload command type.
> This helps to distinguish the read and write workload command types from
> each other while sending mbox commands.
>=20
> Fixes: 5d6fbc96bd36 ("thermal/drivers/int340x: processor_thermal: Export
> additional attributes")
> Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
> Cc: 5.14+ <stable@vger.kernel.org> # 5.14+
> Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> [ rjw: Changelog edits ]
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  .../processor_thermal_device.h                |   3 +-
>  .../int340x_thermal/processor_thermal_mbox.c  | 100 +++++++++++-------
> .../int340x_thermal/processor_thermal_rfim.c  |  23 ++--
>  3 files changed, 73 insertions(+), 53 deletions(-)
>=20
> diff --git
> a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
> b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
> index be27f633e40a..9b2a64ef55d0 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
> @@ -80,7 +80,8 @@ void proc_thermal_rfim_remove(struct pci_dev *pdev);
> int proc_thermal_mbox_add(struct pci_dev *pdev, struct
> proc_thermal_device *proc_priv);  void proc_thermal_mbox_remove(struct
> pci_dev *pdev);
>=20
> -int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id,
> u32 cmd_data, u64 *cmd_resp);
> +int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id,
> +u64 *resp); int processor_thermal_send_mbox_write_cmd(struct pci_dev
> +*pdev, u16 id, u32 data);
>  int proc_thermal_add(struct device *dev, struct proc_thermal_device *pri=
v);
> void proc_thermal_remove(struct proc_thermal_device *proc_priv);  int
> proc_thermal_suspend(struct device *dev); diff --git
> a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
> b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
> index 01008ae00e7f..0b89a4340ff4 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
> @@ -24,19 +24,15 @@
>=20
>  static DEFINE_MUTEX(mbox_lock);
>=20
> -static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data,
> u64 *cmd_resp)
> +static int wait_for_mbox_ready(struct proc_thermal_device *proc_priv)
>  {
> -	struct proc_thermal_device *proc_priv;
>  	u32 retries, data;
>  	int ret;
>=20
> -	mutex_lock(&mbox_lock);
> -	proc_priv =3D pci_get_drvdata(pdev);
> -
>  	/* Poll for rb bit =3D=3D 0 */
>  	retries =3D MBOX_RETRY_COUNT;
>  	do {
> -		data =3D readl((void __iomem *) (proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE));
> +		data =3D readl(proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE);
>  		if (data & BIT_ULL(MBOX_BUSY_BIT)) {
>  			ret =3D -EBUSY;
>  			continue;
> @@ -45,53 +41,78 @@ static int send_mbox_cmd(struct pci_dev *pdev, u16
> cmd_id, u32 cmd_data, u64 *cm
>  		break;
>  	} while (--retries);
>=20
> +	return ret;
> +}
> +
> +static int send_mbox_write_cmd(struct pci_dev *pdev, u16 id, u32 data)
> +{
> +	struct proc_thermal_device *proc_priv;
> +	u32 reg_data;
> +	int ret;
> +
> +	proc_priv =3D pci_get_drvdata(pdev);
> +
> +	mutex_lock(&mbox_lock);
> +
> +	ret =3D wait_for_mbox_ready(proc_priv);
>  	if (ret)
>  		goto unlock_mbox;
>=20
> -	if (cmd_id =3D=3D MBOX_CMD_WORKLOAD_TYPE_WRITE)
> -		writel(cmd_data, (void __iomem *) ((proc_priv->mmio_base
> + MBOX_OFFSET_DATA)));
> -
> +	writel(data, (proc_priv->mmio_base + MBOX_OFFSET_DATA));
>  	/* Write command register */
> -	data =3D BIT_ULL(MBOX_BUSY_BIT) | cmd_id;
> -	writel(data, (void __iomem *) ((proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE)));
> +	reg_data =3D BIT_ULL(MBOX_BUSY_BIT) | id;
> +	writel(reg_data, (proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE));
>=20
> -	/* Poll for rb bit =3D=3D 0 */
> -	retries =3D MBOX_RETRY_COUNT;
> -	do {
> -		data =3D readl((void __iomem *) (proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE));
> -		if (data & BIT_ULL(MBOX_BUSY_BIT)) {
> -			ret =3D -EBUSY;
> -			continue;
> -		}
> +	ret =3D wait_for_mbox_ready(proc_priv);
>=20
> -		if (data) {
> -			ret =3D -ENXIO;
> -			goto unlock_mbox;
> -		}
> +unlock_mbox:
> +	mutex_unlock(&mbox_lock);
> +	return ret;
> +}
>=20
> -		ret =3D 0;
> +static int send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u64 *resp)
> +{
> +	struct proc_thermal_device *proc_priv;
> +	u32 reg_data;
> +	int ret;
>=20
> -		if (!cmd_resp)
> -			break;
> +	proc_priv =3D pci_get_drvdata(pdev);
>=20
> -		if (cmd_id =3D=3D MBOX_CMD_WORKLOAD_TYPE_READ)
> -			*cmd_resp =3D readl((void __iomem *) (proc_priv-
> >mmio_base + MBOX_OFFSET_DATA));
> -		else
> -			*cmd_resp =3D readq((void __iomem *) (proc_priv-
> >mmio_base + MBOX_OFFSET_DATA));
> +	mutex_lock(&mbox_lock);
>=20
> -		break;
> -	} while (--retries);
> +	ret =3D wait_for_mbox_ready(proc_priv);
> +	if (ret)
> +		goto unlock_mbox;
> +
> +	/* Write command register */
> +	reg_data =3D BIT_ULL(MBOX_BUSY_BIT) | id;
> +	writel(reg_data, (proc_priv->mmio_base +
> MBOX_OFFSET_INTERFACE));
> +
> +	ret =3D wait_for_mbox_ready(proc_priv);
> +	if (ret)
> +		goto unlock_mbox;
> +
> +	if (id =3D=3D MBOX_CMD_WORKLOAD_TYPE_READ)
> +		*resp =3D readl(proc_priv->mmio_base +
> MBOX_OFFSET_DATA);
> +	else
> +		*resp =3D readq(proc_priv->mmio_base +
> MBOX_OFFSET_DATA);
>=20
>  unlock_mbox:
>  	mutex_unlock(&mbox_lock);
>  	return ret;
>  }
>=20
> -int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id,
> u32 cmd_data, u64 *cmd_resp)
> +int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id,
> +u64 *resp)
>  {
> -	return send_mbox_cmd(pdev, cmd_id, cmd_data, cmd_resp);
> +	return send_mbox_read_cmd(pdev, id, resp);
>  }
> -EXPORT_SYMBOL_GPL(processor_thermal_send_mbox_cmd);
> +EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_read_cmd,
> +INT340X_THERMAL);
> +
> +int processor_thermal_send_mbox_write_cmd(struct pci_dev *pdev, u16
> id,
> +u32 data) {
> +	return send_mbox_write_cmd(pdev, id, data); }
> +EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_write_cmd,
> +INT340X_THERMAL);
>=20
>  /* List of workload types */
>  static const char * const workload_types[] =3D { @@ -104,7 +125,6 @@ sta=
tic
> const char * const workload_types[] =3D {
>  	NULL
>  };
>=20
> -
>  static ssize_t workload_available_types_show(struct device *dev,
>  					       struct device_attribute *attr,
>  					       char *buf)
> @@ -146,7 +166,7 @@ static ssize_t workload_type_store(struct device
> *dev,
>=20
>  	data |=3D ret;
>=20
> -	ret =3D send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_WRITE,
> data, NULL);
> +	ret =3D send_mbox_write_cmd(pdev,
> MBOX_CMD_WORKLOAD_TYPE_WRITE, data);
>  	if (ret)
>  		return false;
>=20
> @@ -161,7 +181,7 @@ static ssize_t workload_type_show(struct device
> *dev,
>  	u64 cmd_resp;
>  	int ret;
>=20
> -	ret =3D send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ,
> 0, &cmd_resp);
> +	ret =3D send_mbox_read_cmd(pdev,
> MBOX_CMD_WORKLOAD_TYPE_READ,
> +&cmd_resp);
>  	if (ret)
>  		return false;
>=20
> @@ -186,8 +206,6 @@ static const struct attribute_group
> workload_req_attribute_group =3D {
>  	.name =3D "workload_request"
>  };
>=20
> -
> -
>  static bool workload_req_created;
>=20
>  int proc_thermal_mbox_add(struct pci_dev *pdev, struct
> proc_thermal_device *proc_priv) @@ -196,7 +214,7 @@ int
> proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device
> *proc
>  	int ret;
>=20
>  	/* Check if there is a mailbox support, if fails return success */
> -	ret =3D send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ,
> 0, &cmd_resp);
> +	ret =3D send_mbox_read_cmd(pdev,
> MBOX_CMD_WORKLOAD_TYPE_READ,
> +&cmd_resp);
>  	if (ret)
>  		return 0;
>=20
> diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim=
.c
> b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> index e693ec8234fb..8c42e7662033 100644
> --- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> +++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
> @@ -9,6 +9,8 @@
>  #include <linux/pci.h>
>  #include "processor_thermal_device.h"
>=20
> +MODULE_IMPORT_NS(INT340X_THERMAL);
> +
>  struct mmio_reg {
>  	int read_only;
>  	u32 offset;
> @@ -194,8 +196,7 @@ static ssize_t rfi_restriction_store(struct device *d=
ev,
>  				     struct device_attribute *attr,
>  				     const char *buf, size_t count)  {
> -	u16 cmd_id =3D 0x0008;
> -	u64 cmd_resp;
> +	u16 id =3D 0x0008;
>  	u32 input;
>  	int ret;
>=20
> @@ -203,7 +204,7 @@ static ssize_t rfi_restriction_store(struct device *d=
ev,
>  	if (ret)
>  		return ret;
>=20
> -	ret =3D processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id,
> input, &cmd_resp);
> +	ret =3D processor_thermal_send_mbox_write_cmd(to_pci_dev(dev),
> id,
> +input);
>  	if (ret)
>  		return ret;
>=20
> @@ -214,30 +215,30 @@ static ssize_t rfi_restriction_show(struct device
> *dev,
>  				    struct device_attribute *attr,
>  				    char *buf)
>  {
> -	u16 cmd_id =3D 0x0007;
> -	u64 cmd_resp;
> +	u16 id =3D 0x0007;
> +	u64 resp;
>  	int ret;
>=20
> -	ret =3D processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id,
> 0, &cmd_resp);
> +	ret =3D processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id,
> +&resp);
>  	if (ret)
>  		return ret;
>=20
> -	return sprintf(buf, "%llu\n", cmd_resp);
> +	return sprintf(buf, "%llu\n", resp);
>  }
>=20
>  static ssize_t ddr_data_rate_show(struct device *dev,
>  				  struct device_attribute *attr,
>  				  char *buf)
>  {
> -	u16 cmd_id =3D 0x0107;
> -	u64 cmd_resp;
> +	u16 id =3D 0x0107;
> +	u64 resp;
>  	int ret;
>=20
> -	ret =3D processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id,
> 0, &cmd_resp);
> +	ret =3D processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id,
> +&resp);
>  	if (ret)
>  		return ret;
>=20
> -	return sprintf(buf, "%llu\n", cmd_resp);
> +	return sprintf(buf, "%llu\n", resp);
>  }
>=20
>  static DEVICE_ATTR_RW(rfi_restriction);
> --
> 2.17.1

