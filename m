Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952C645B213
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 03:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhKXCjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 21:39:22 -0500
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:12769
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235796AbhKXCjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 21:39:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXmIS/cklhB/fxBH7YqNhi7mBRQnxJIGTRBCvN+xFozEZSYEo/9Vx6pQnsGB7N3h/du46/uaHaEICo1ttHbmrLvKrcVcAJepCetViDRMWA5W6iefh7GgqwU+mbpof8jrXPbdisnwfTlHmo8tBVv66A4g6H2WLHVrxJSDP48E9VNuKTfC+Cq3pv41xqDEO5/SqJOTw+dv5opjGGgzbsqzLvZ2w4PwYQHNFn1IiGjkNYvJfl0+JUAVWlvtikk/lS15act79jwjqMiBJ/0V/Mt94RnVxrIWkFq/B/kMazxxjC9uU4COOT8YaquLHC9T3Fb11Pbadpj1op11G7XoucXkmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6LweTtsqkjWPhN14UWIThnrAeuEiN7qSM6Q7MhUuH4=;
 b=jjpZHRoCSzWEm1T5ok2t1K7AYgxMJAm+vays3oLiPER/lQnoHJe6zk1xxRf2dKTKTAxmAZLbYziirW2xUBirp51BIMNRFV2xnXQZmOMVAb67Qv0hyRiS+qXR05Tt5qoKUNrzD8JwiNWRDT0sUbpePIy6VCy2wsJB7bAYlmSOpsm8wdAeckb+WEXc2kDteTeuwcaF6yserMeo4kIs9Kuvn0An9fpZlEuTT/7Zk9ngDPSbJ7Q+FlaT1D7Vi5IDG+bZ3H2v//wk867fmWkOH/W6yVv8vXbnpAEcoILjwlOBt05a5DJnunwurYCjtp9f7/9OdfiHSnOyEP5IbI3OvK7T7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6LweTtsqkjWPhN14UWIThnrAeuEiN7qSM6Q7MhUuH4=;
 b=fn6794qsHdYNgCQHcc4PG1y5AplKgTQUd8mLquW1b9NXA1Zxvf/KkWZ6VcGaD5f4TlygdYzt2d0qltmVty0RTgoiS51YjDzFQNUD8fERCTvB9O+p2gPtvJ1dOxYqP2qKXe7T+OpVu7BzvLfbEfiPxpv5RnXriPWopntxa02KXtI=
Received: from MWHPR12MB1631.namprd12.prod.outlook.com (2603:10b6:301:f::19)
 by MWHPR12MB1759.namprd12.prod.outlook.com (2603:10b6:300:113::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 24 Nov
 2021 02:36:07 +0000
Received: from MWHPR12MB1631.namprd12.prod.outlook.com
 ([fe80::48ee:f48:5a1:dcd8]) by MWHPR12MB1631.namprd12.prod.outlook.com
 ([fe80::48ee:f48:5a1:dcd8%8]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 02:36:07 +0000
From:   "Yuan, Perry" <Perry.Yuan@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Huang, Ray" <Ray.Huang@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] drm/amd/pm: add GFXCLK/SCLK clocks level
 print support for" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] drm/amd/pm: add GFXCLK/SCLK clocks level
 print support for" failed to apply to 5.15-stable tree
Thread-Index: AQHX4GECYk4Kw+dvKUuDn7RCdgKK9qwR9nGA
Date:   Wed, 24 Nov 2021 02:36:06 +0000
Message-ID: <MWHPR12MB1631E2FFDBA63707707DBC369C619@MWHPR12MB1631.namprd12.prod.outlook.com>
References: <16376685172321@kroah.com>
In-Reply-To: <16376685172321@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Enabled=true;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SetDate=2021-11-24T02:36:04Z;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Method=Standard;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_Name=AMD Official Use
 Only-AIP 2.0;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ActionId=6eccccca-94e0-4a28-83a2-47a17358db62;
 MSIP_Label_88914ebd-7e6c-4e12-a031-a9906be2db14_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5188e6a-8269-4935-15b2-08d9aef32b00
x-ms-traffictypediagnostic: MWHPR12MB1759:
x-microsoft-antispam-prvs: <MWHPR12MB1759FEAA4CA182F6E36F0E129C619@MWHPR12MB1759.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BmWi8aoWJ9NdShaE4T1xBk4D9sLgQmb/xqoA3cOTjoMN96zyObBKHp2ZVLsl7BYW0uV+FBkRk8fRl54Pz4V8aqvzXK+W0fqvowd584uzC2zOKW8upK0a3bAXiBrOIDhmg16XK+pJv+rvQs1rb4mB46LArPboWpN0JI8M5dyng9uxnNfBJpj4IPJuppd4bcB6MxsNfH1f8L1BUzOWrvF79UfWllDS45PnLZ5vKvUaQWCKGUtQRp+E/lTDZc1vUGjliOAdDy3wO4bGhKkv6ep+1fsYRx9TTh3SREfSTjM/wpjMPvaJoT+9dCz31xOUY5iAiCo9i4dnAkebGH6DldUGTssIcC6I8ZGGC+ASLrUEPpbZ96hrPKGLU1/0jRNOFyoIBcv/5MLbbapFniNipRaaDFDCI7PKRj8tJXQ+EniTJAcZj2mYa4PTsQvgCPEnPSn9ExQYxyHvHll/I+SAWSkW1y+yE0tZWsh3AxOA7Nh6iqN3nBwVuUWViHjKy9nVESQgbXy+WM6K3eQmfUI43alyPmqp7Fp9m3MHVmy0AzR7sQleVkMfTKwHCfvmb6WufGPZz3ml6eGDH6+liTYTRiJSdQJ4w9h5evv1lHd6iIK7LlIj7c/NESppNeSzrOWuv/lS/SA54Aau7IPjz5dyv0SRkrozifOzjr90820DAzpIY2B3yxR1ZyUpXUxpg10y0DD013QOKyrlMr46+E77E5/RpBrV4ZWjOTN+CzA+LJKckvTBBDZUn5VSaIaj/zuDBbqESwZXjVjq5Mby0kp4Wg2cj67ZTH6crj9jbVnwE3wyDtk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1631.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(8936002)(53546011)(76116006)(6506007)(66476007)(64756008)(66446008)(122000001)(66556008)(66946007)(4326008)(7696005)(71200400001)(55016003)(2906002)(9686003)(45080400002)(8676002)(508600001)(966005)(52536014)(5660300002)(316002)(26005)(33656002)(6636002)(38070700005)(110136005)(83380400001)(38100700002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FfMj0WXF+ViTEm8XcboAopm0N7sIdviEjHXS6uua7WANDl1kpqDRLzrxr1AS?=
 =?us-ascii?Q?FdBSiwUN1P7QVzUsRozUcCqiz4s8X+3MK9ghaSzaYWKWw9zQWOC+nkFrM1Ou?=
 =?us-ascii?Q?OVnEEJoEm0BkMHl9qlbeN/+TcMhVtgDUEl9M4lbSB+tP1kfbNjMmhpDL8r8o?=
 =?us-ascii?Q?wd1/IGjMf5iGNAIM+HoQQf4mSM6tDTkFr+E32BePN/+ZAgFEnMdf1an1WpDG?=
 =?us-ascii?Q?vXzTIVYlnZokG3qZQP9Bd6sDD7ANx93EvVz9vCc7DUKa9A2FgqiB8mJ6glhA?=
 =?us-ascii?Q?+qqW9o+z5k/MuWLx3XWKcH7j+l4IwNSRpxLB9HH6swapa4QJEI8aygAQuyW5?=
 =?us-ascii?Q?4fa18gQDs6TcMPmlHrBZDy2onELxUchyWJ5OreS1fcaAcEsg7n8Ae3VDByra?=
 =?us-ascii?Q?0S2Xpx+gCASPdg0ZV39WvEkXOZSLRxJuiWDRxcgMPUHzZvDg3HssqFNqoP77?=
 =?us-ascii?Q?hk+Y3BA/QVjzcRbRpCdZuKONlw7o0nKzMoS0uopj+KdasI2jLNRsuGIcN7KF?=
 =?us-ascii?Q?i5HhQ/+nPDvMDwrPNNxizPWzfa0bgXUxWuHYGhtJCImQeerVUMc9a4jn1osb?=
 =?us-ascii?Q?bMHRXAFk7jgYPuOrSOXvrVpvotOUXrp5sDHYodzZDOCe30Tyl3tcX5hdi1RL?=
 =?us-ascii?Q?oSE5PWRNDOfbjGdP01k7bBacXWPZTWUFhLwf8yR9FGBiUHmF7Kb19yr/apil?=
 =?us-ascii?Q?YM5JSQHLIsXiSAupV6PQIX2bSqzUOkuGKgISRP1TvKsfSPHu1qVbGsk9NRJ5?=
 =?us-ascii?Q?J3+3Q/jbjk+OdQec4BPibrgIbaNipy+WZghlpY6ZXPSBOM2Yz8geEOextNZ2?=
 =?us-ascii?Q?ejxAqp11KpVMB+eoKTuRfwEBh1zjhDue+EoELcasuLCS0BAUmakkRXopm9Ey?=
 =?us-ascii?Q?WU1bXedWBC6Euoqaspddq+F6hSx7FCGMzOUaLXN514aMUSP71qXCznUpLTpH?=
 =?us-ascii?Q?IPFNE+DTIqkWpqkHwsldbqkojYnjL+iQ0mFJJvQ4ifgy0CZddTyJCOC+IARm?=
 =?us-ascii?Q?N2u/p1ENvT6ETS68/964EViqSh3l+liodhx62rLkKTEU8gXH0gRrXftIio9T?=
 =?us-ascii?Q?fbzLQNdyhgBVUTnaoMMnQLG9J53U9blVob9aToHse5qJGBCWzgrLOhOmuu/X?=
 =?us-ascii?Q?bOIBNak1JWGfJ84/cIlD5eobxYXyHCO670aL36So32Hb1iF2kS9qUuuCYq7x?=
 =?us-ascii?Q?cDaJxOfSjmE4TSfLa5hcKOOYBzD06RwwbGGygTED0H8w+BOKOfy07XAtc/nq?=
 =?us-ascii?Q?m3aMrYoFxDy4UnZTaZShJTdZdXSqW8t6+oqz9vJSpR4HIy4VHPe6jAa83EHW?=
 =?us-ascii?Q?DznikBwmKb0U3s+oafFB+k3n7ctOmnpx+AiQIUOq2IBbsEG9awJoPwJOyt8m?=
 =?us-ascii?Q?Tqz4tEsNFiLsAWUzsf89PnMNS59IYivdIigohkdCZevLidfx5ArBnYGFwGMy?=
 =?us-ascii?Q?mPSimhGTnQiFOnD3U6FjrmsrcHYjudHEcPIinFeE6QXX37QWM0EomjC/0DCi?=
 =?us-ascii?Q?xLUZJrKmH6zXPsZpOP6MB12U/ZdaCXRDt+3RFd/i9ZlE5a5THNrEixIleZrh?=
 =?us-ascii?Q?KVTocOpHRl6ZqzcOrjjNJC7Zz8Kv7+2tLGzwdUCVUUkP3XYUJEMMbeH7H3QT?=
 =?us-ascii?Q?u+z72fFP2RpmAfis+9sVx3k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1631.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5188e6a-8269-4935-15b2-08d9aef32b00
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 02:36:06.9308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lfdZKrI9167PnBv3S9gC5Byoh5svbsTZuLxx+z59B7lhiSgCPiEO4S1h9EAhH2+3ZP6n6ubhJggVV44l7/aP0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1759
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only]

Hi Greg.
Thanks for your reminder.
I will check the failure with my team for the 5.15 stable tree.=20

Perry.

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Tuesday, November 23, 2021 7:55 PM
> To: Yuan, Perry <Perry.Yuan@amd.com>; Huang, Ray
> <Ray.Huang@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] drm/amd/pm: add GFXCLK/SCLK clocks level
> print support for" failed to apply to 5.15-stable tree
>=20
> [CAUTION: External Email]
>=20
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 3dac776e349a214c07fb2b0e5973947b0aade4f6 Mon Sep 17 00:00:00
> 2001
> From: Perry Yuan <Perry.Yuan@amd.com>
> Date: Thu, 28 Oct 2021 06:05:42 -0400
> Subject: [PATCH] drm/amd/pm: add GFXCLK/SCLK clocks level print support
> for  APUs
>=20
> add support that allow the userspace tool like RGP to get the GFX clock v=
alue
> at runtime, the fix follow the old way to show the min/current/max clocks
> level for compatible consideration.
>=20
> =3D=3D=3D Test =3D=3D=3D
> $ cat /sys/class/drm/card0/device/pp_dpm_sclk
> 0: 200Mhz *
> 1: 1100Mhz
> 2: 1600Mhz
>=20
> then run stress test on one APU system.
> $ cat /sys/class/drm/card0/device/pp_dpm_sclk
> 0: 200Mhz
> 1: 1040Mhz *
> 2: 1600Mhz
>=20
> The current GFXCLK value is updated at runtime.
>=20
> BugLink:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fmesa%2Fmesa%2F-
> %2Fissues%2F5260&amp;data=3D04%7C01%7CPerry.Yuan%40amd.com%7C3d
> 58c619845a45ed214908d9ae782402%7C3dd8961fe4884e608e11a82d994e18
> 3d%7C0%7C0%7C637732653292775514%7CUnknown%7CTWFpbGZsb3d8eyJ
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> 7C3000&amp;sdata=3DdA2FL16ep6Pchu%2BN6d7GgHl6NzolgEwaY4zCUnUuB6
> A%3D&amp;reserved=3D0
> Reviewed-by: Huang Ray <Ray.Huang@amd.com>
> Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
>=20
> diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/cyan_skillfish_ppt.c
> b/drivers/gpu/drm/amd/pm/swsmu/smu11/cyan_skillfish_ppt.c
> index cbc3f99e8573..2238ee19c222 100644
> --- a/drivers/gpu/drm/amd/pm/swsmu/smu11/cyan_skillfish_ppt.c
> +++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/cyan_skillfish_ppt.c
> @@ -309,6 +309,7 @@ static int cyan_skillfish_print_clk_levels(struct
> smu_context *smu,  {
>         int ret =3D 0, size =3D 0;
>         uint32_t cur_value =3D 0;
> +       int i;
>=20
>         smu_cmn_get_sysfs_buf(&buf, &size);
>=20
> @@ -334,8 +335,6 @@ static int cyan_skillfish_print_clk_levels(struct
> smu_context *smu,
>                 size +=3D sysfs_emit_at(buf, size, "VDDC: %7umV  %10umV\n=
",
>                                                 CYAN_SKILLFISH_VDDC_MIN,
> CYAN_SKILLFISH_VDDC_MAX);
>                 break;
> -       case SMU_GFXCLK:
> -       case SMU_SCLK:
>         case SMU_FCLK:
>         case SMU_MCLK:
>         case SMU_SOCCLK:
> @@ -346,6 +345,25 @@ static int cyan_skillfish_print_clk_levels(struct
> smu_context *smu,
>                         return ret;
>                 size +=3D sysfs_emit_at(buf, size, "0: %uMhz *\n", cur_va=
lue);
>                 break;
> +       case SMU_SCLK:
> +       case SMU_GFXCLK:
> +               ret =3D cyan_skillfish_get_current_clk_freq(smu, clk_type=
,
> &cur_value);
> +               if (ret)
> +                       return ret;
> +               if (cur_value  =3D=3D CYAN_SKILLFISH_SCLK_MAX)
> +                       i =3D 2;
> +               else if (cur_value =3D=3D CYAN_SKILLFISH_SCLK_MIN)
> +                       i =3D 0;
> +               else
> +                       i =3D 1;
> +               size +=3D sysfs_emit_at(buf, size, "0: %uMhz %s\n",
> CYAN_SKILLFISH_SCLK_MIN,
> +                               i =3D=3D 0 ? "*" : "");
> +               size +=3D sysfs_emit_at(buf, size, "1: %uMhz %s\n",
> +                               i =3D=3D 1 ? cur_value : cyan_skillfish_s=
clk_default,
> +                               i =3D=3D 1 ? "*" : "");
> +               size +=3D sysfs_emit_at(buf, size, "2: %uMhz %s\n",
> CYAN_SKILLFISH_SCLK_MAX,
> +                               i =3D=3D 2 ? "*" : "");
> +               break;
>         default:
>                 dev_warn(smu->adev->dev, "Unsupported clock type\n");
>                 return ret;
> diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
> b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
> index 421f38e8dada..c02ed65ffa38 100644
> --- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
> +++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
> @@ -683,6 +683,7 @@ static int vangogh_print_clk_levels(struct
> smu_context *smu,
>         int i, size =3D 0, ret =3D 0;
>         uint32_t cur_value =3D 0, value =3D 0, count =3D 0;
>         bool cur_value_match_level =3D false;
> +       uint32_t min, max;
>=20
>         memset(&metrics, 0, sizeof(metrics));
>=20
> @@ -743,6 +744,13 @@ static int vangogh_print_clk_levels(struct
> smu_context *smu,
>                 if (ret)
>                         return ret;
>                 break;
> +       case SMU_GFXCLK:
> +       case SMU_SCLK:
> +               ret =3D smu_cmn_send_smc_msg_with_param(smu,
> SMU_MSG_GetGfxclkFrequency, 0, &cur_value);
> +               if (ret) {
> +                       return ret;
> +               }
> +               break;
>         default:
>                 break;
>         }
> @@ -768,6 +776,24 @@ static int vangogh_print_clk_levels(struct
> smu_context *smu,
>                 if (!cur_value_match_level)
>                         size +=3D sysfs_emit_at(buf, size, "   %uMhz *\n"=
, cur_value);
>                 break;
> +       case SMU_GFXCLK:
> +       case SMU_SCLK:
> +               min =3D (smu->gfx_actual_hard_min_freq > 0) ? smu-
> >gfx_actual_hard_min_freq : smu->gfx_default_hard_min_freq;
> +               max =3D (smu->gfx_actual_soft_max_freq > 0) ? smu-
> >gfx_actual_soft_max_freq : smu->gfx_default_soft_max_freq;
> +               if (cur_value  =3D=3D max)
> +                       i =3D 2;
> +               else if (cur_value =3D=3D min)
> +                       i =3D 0;
> +               else
> +                       i =3D 1;
> +               size +=3D sysfs_emit_at(buf, size, "0: %uMhz %s\n", min,
> +                               i =3D=3D 0 ? "*" : "");
> +               size +=3D sysfs_emit_at(buf, size, "1: %uMhz %s\n",
> +                               i =3D=3D 1 ? cur_value :
> VANGOGH_UMD_PSTATE_STANDARD_GFXCLK,
> +                               i =3D=3D 1 ? "*" : "");
> +               size +=3D sysfs_emit_at(buf, size, "2: %uMhz %s\n", max,
> +                               i =3D=3D 2 ? "*" : "");
> +               break;
>         default:
>                 break;
>         }
> diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
> b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
> index 8215bbf5ed7c..caf1775d48ef 100644
> --- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
> +++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
> @@ -697,6 +697,11 @@ static int yellow_carp_get_current_clk_freq(struct
> smu_context *smu,
>         case SMU_FCLK:
>                 return smu_cmn_send_smc_msg_with_param(smu,
>                                 SMU_MSG_GetFclkFrequency, 0, value);
> +       case SMU_GFXCLK:
> +       case SMU_SCLK:
> +               return smu_cmn_send_smc_msg_with_param(smu,
> +                               SMU_MSG_GetGfxclkFrequency, 0, value);
> +               break;
>         default:
>                 return -EINVAL;
>         }
> @@ -967,6 +972,7 @@ static int yellow_carp_print_clk_levels(struct
> smu_context *smu,  {
>         int i, size =3D 0, ret =3D 0;
>         uint32_t cur_value =3D 0, value =3D 0, count =3D 0;
> +       uint32_t min, max;
>=20
>         smu_cmn_get_sysfs_buf(&buf, &size);
>=20
> @@ -1005,6 +1011,27 @@ static int yellow_carp_print_clk_levels(struct
> smu_context *smu,
>                                         cur_value =3D=3D value ? "*" : ""=
);
>                 }
>                 break;
> +       case SMU_GFXCLK:
> +       case SMU_SCLK:
> +               ret =3D yellow_carp_get_current_clk_freq(smu, clk_type,
> &cur_value);
> +               if (ret)
> +                       goto print_clk_out;
> +               min =3D (smu->gfx_actual_hard_min_freq > 0) ? smu-
> >gfx_actual_hard_min_freq : smu->gfx_default_hard_min_freq;
> +               max =3D (smu->gfx_actual_soft_max_freq > 0) ? smu-
> >gfx_actual_soft_max_freq : smu->gfx_default_soft_max_freq;
> +               if (cur_value  =3D=3D max)
> +                       i =3D 2;
> +               else if (cur_value =3D=3D min)
> +                       i =3D 0;
> +               else
> +                       i =3D 1;
> +               size +=3D sysfs_emit_at(buf, size, "0: %uMhz %s\n", min,
> +                               i =3D=3D 0 ? "*" : "");
> +               size +=3D sysfs_emit_at(buf, size, "1: %uMhz %s\n",
> +                               i =3D=3D 1 ? cur_value : YELLOW_CARP_UMD_=
PSTATE_GFXCLK,
> +                               i =3D=3D 1 ? "*" : "");
> +               size +=3D sysfs_emit_at(buf, size, "2: %uMhz %s\n", max,
> +                               i =3D=3D 2 ? "*" : "");
> +               break;
>         default:
>                 break;
>         }
> diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.h
> b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.h
> index b3ad8352c68a..a9205a8ea3ad 100644
> --- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.h
> +++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.h
> @@ -24,5 +24,6 @@
>  #define __YELLOW_CARP_PPT_H__
>=20
>  extern void yellow_carp_set_ppt_funcs(struct smu_context *smu);
> +#define YELLOW_CARP_UMD_PSTATE_GFXCLK       1100
>=20
>  #endif
