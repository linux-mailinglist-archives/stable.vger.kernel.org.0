Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC88637980A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 21:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhEJT5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 15:57:44 -0400
Received: from mail-bn1nam07on2071.outbound.protection.outlook.com ([40.107.212.71]:13038
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230342AbhEJT5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 15:57:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4GOtoc0Qs3clZ+3gJMFf2UGesk4gEYrz50aPIebbZTwBAKKOC2K31Jc8U4FXIut/gFtkgCjb05g2HKExzeotC8CwddQkSWONkP70jz2ElPufCrCsPjjyth9XEIosWAEp2sgauLQhUH5XdBJifsCZdTRht2BOz6Cu/VzfKjdTgNtBKcCxpp0bja15/w2T7PPw9r72IDM2zSahk/7QHi0+vE8aigDc4ar3HGURR8lypghQ/4JEsGzW8GVPIj43QZBwQmbDX7UBz0XE5ZG52L9aTS1Crn+lpydvr7VprkLHGA3oH8c5UQnlCZpFr5j8+6KSvqm+mvAtR1W8XEjFBIUsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWTGuTpvPfdFFqK7q2unYlO5NAiviKwOwQk5DiQ0BR8=;
 b=BhdboBstwh6MEf8ZmZKuSNRKO7o++u4igmiPSNGqQ+/3/VVLt2ro1ZqcDl0jBovXF/jpMnDPtrJkWkjqkBdExKyQd91CMiszlbJ2NfCLVS7QJxuzP22tScRXcuuFDeUHGY68oi8TNbfjSGOH3+pSzRbyTDa0l6FdK/ON1lNLbXPItJeBJ2uXjyGlYqexYoskjWVBy1H2B36W6XVq15BmMqPV63twpUjNYPstuqlUzUfbR0aF11GtF9Je9AnQA3+bTZN43wHoEWYcOXDZNZJy0SIEJukovFPjsoUKi7qfyBEED/m8irE4rHm0uk/SjXE7esxk7BRD3G6+E+kzg1JwrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWTGuTpvPfdFFqK7q2unYlO5NAiviKwOwQk5DiQ0BR8=;
 b=meLTPkgzSrCVsF0jb/KfE8cjPTlEV2qpgtw6xdxbipg8e4lDbSmO3oyk0K8C/90bGLUt7+gIs3YseLGjAFZ3MbjzZ4KOsLz+BlG35vih6WUiUZhwt3mCt4s8eWPY0+0GHxKS7+b2bR2D1LtRV/LOuTm7veh594rYxfl/S1KWx6Q=
Received: from MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19)
 by MN2PR12MB4064.namprd12.prod.outlook.com (2603:10b6:208:1d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Mon, 10 May
 2021 19:56:30 +0000
Received: from MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::3d98:cefb:476c:c36e]) by MN2PR12MB4488.namprd12.prod.outlook.com
 ([fe80::3d98:cefb:476c:c36e%8]) with mapi id 15.20.4108.032; Mon, 10 May 2021
 19:56:30 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Holger Kiehl <Holger.Kiehl@dwd.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.12 195/384] drm/amdgpu: Fix memory leak
Thread-Topic: [PATCH 5.12 195/384] drm/amdgpu: Fix memory leak
Thread-Index: AQHXRYyQ3IvyfO4HNkqAU5WaPOlEEqrdB1kAgAAZggA=
Date:   Mon, 10 May 2021 19:56:30 +0000
Message-ID: <MN2PR12MB4488A0EC34EBCE766199AB3DF7549@MN2PR12MB4488.namprd12.prod.outlook.com>
References: <20210510102014.849075526@linuxfoundation.org>
 <20210510102021.305484238@linuxfoundation.org>
 <8681a9f2-62e6-3aa-d169-653db617f60@diagnostix.dwd.de>
In-Reply-To: <8681a9f2-62e6-3aa-d169-653db617f60@diagnostix.dwd.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-05-10T19:56:27Z;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=d177f55a-d1cc-4df6-8b81-4b43a29de620;
 MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=1
authentication-results: dwd.de; dkim=none (message not signed)
 header.d=none;dwd.de; dmarc=none action=none header.from=amd.com;
x-originating-ip: [165.204.54.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3279b52b-b8af-4481-5d16-08d913edb465
x-ms-traffictypediagnostic: MN2PR12MB4064:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB4064EF3C01713F5545E93F45F7549@MN2PR12MB4064.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BwtqHnk7UPqFqQfWZjze6lAYT6OUs2Y0xXeUXkv5bf2vwTWUoK9r0JQfNnmyoNLRQlhccL7542y6HOBQmXKlDIBTRUg1mVEbXBY6Uf3VNwLasar2ClS8Kzh1uJDW+SSnzv2UWh6TLJCeEEYpqfxQlTRzbyzxUF0nWFE+PoY8ZPoLusTL5LbZVP3cYbf9Kczmfzs/mTQiidVMTMLGXnEeyq+VbkI4tqd5BElDQ2ExtdDiFDN8nAmLRET4Okd2GUG3SRrIM5t7iuOLvk5PXiMjsw9f2vpvk6jkW+KK4mPNfaNdmP7Hs6mttJVG+Oq7DRLxFRDIXllJoyZctGlek6BmLMVXpNpR7lu+S1cEz/wrTGA/gwQArQC1hLSNxbpifOkC9PkRc9Pv+vT7Un1QPna+1RmQRDyVbjPPVe34gPkJSP+rsAnkm895wlg/sWNnlKZVyQrd1PMBeP7lC77CwK0OC0nPNIWJn24ud4ATHfe2kk1pAUVQK0QFALOQoP7FtJFBpkmnGd0x/CXS52bHYptn0QBDAXjxQzYUJl5Aj20C0RRjqutgY8gWFtAicfbchlwiam+o6qaLhm1YpK3+4apdTJp4KPzszCLPsL1w/qCpIAg/sVhMFMr99yr1QRTseDLMkJf6gKOzpibtZpnsKtqRhbV8tpMnLR+YqpM4HYWf2rs/QAIS9AVsjB16GkmT7DQ0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4488.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(71200400001)(66476007)(110136005)(66946007)(66556008)(66446008)(64756008)(76116006)(54906003)(8936002)(83380400001)(4326008)(33656002)(8676002)(316002)(52536014)(966005)(53546011)(55016002)(38100700002)(186003)(26005)(45080400002)(478600001)(86362001)(7696005)(9686003)(122000001)(5660300002)(2906002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nznsivtdYPbFeE+pMpVJd47Cn1v5NoE1NdLzNB/7aXPGPyTGxsxTMPAu3aLr?=
 =?us-ascii?Q?tlKQh58Et/tmUFL0p/QCFngZizeXx5mOjsOvKLgLOeTdjJ5gGe8vdrSaJqay?=
 =?us-ascii?Q?ugwoyRC0ZwiU7BhOZIvmZrkJA9BF06nzaEtCk8Hb2C0iOujBW0c28KRWn2rk?=
 =?us-ascii?Q?lKXnt+R2NmEuOAAbfhggMQooCSD23Y7dsZ67nyivUi3HzhyqrAsgEgZCJd2O?=
 =?us-ascii?Q?hJ2jylSJuTTCWP5HpCvslsp3GXZ6xVpX89W5mVz/LgHtarxjE5O6jtS6umOV?=
 =?us-ascii?Q?peszH3K7Yu3yplVOVxMCVQHghqPAwbhJblZKS9eoQ3swyeHBSC/RLsZBqdYh?=
 =?us-ascii?Q?sXmdNnB7SB0jjO3glNMKjdeSXeTzvr1SiWx6m7ZzLOIRf/b0kB7bQ120hhLu?=
 =?us-ascii?Q?yJI/87cjDlb70Mybh+3oxyJXHu/roFx0nfpJzjowpTg3UMQam4Vme4Yosh2r?=
 =?us-ascii?Q?N/SVQ+RmCPfpsLchMBlVlqTozgK0CaV/g5cHBtKnc6HrOJpOuU6i1nw/oPyg?=
 =?us-ascii?Q?6IgmEj+ObpP5EabAx2zZqD3v5svW4PzHhj4ZoK1uF+xx7NvfmYq+zsRCMA18?=
 =?us-ascii?Q?nqVa6rQ7Vi29z0m2Epv8WN4hBBBNA9szUvp74yJiw8kX9mq3Wl1pUA8VYiLZ?=
 =?us-ascii?Q?6u4VrkORObhOm6NdaD+5MzWn8qsOVxhbsHfXllpAi/SWFUtmjC8/0p6IQ/Da?=
 =?us-ascii?Q?6Dy0oKIP9OIUTbDXY6rXF5m8aYCYDvp9f1todBr2jTn0U+JhhEhDxqXXuKu1?=
 =?us-ascii?Q?XuG8gqFVAUNKRiXH9clNPZd0i3FBbBmSZPZIjoYpFYeWrtfgSq9jIzPN7mA4?=
 =?us-ascii?Q?j3dftZlMDC3VtmipP7raEVkNcSqa5z9p2SamnVR+3TNSd9rW6hDj9T5GNAry?=
 =?us-ascii?Q?ctH6/nktmDBU5bFVNdqtjdkPvm0WErwGCg1KTIOK3cI106b9Kcr8rHdcCra6?=
 =?us-ascii?Q?CisQaPHKDH1lra2KobQyt4wyK/qBzRvGBrVgHD1BMkaMZzK6QMqbEs9LmwIe?=
 =?us-ascii?Q?ad6HKXypcFmakR+B4MSqw6MTMtHnVzETQkly0v/FU1YH0ColGEgkw3c2Effv?=
 =?us-ascii?Q?MiMXqVKO5EXb+6fxrEF2ABgv4mFwpI7MWqXWlIAU03dcNvdfPIDgD98oeQoq?=
 =?us-ascii?Q?AEf8qHFTkb2Kgkake2lynJPxd6jgw8XSVmv7HLYeTqpG9tLwozG+s7UE6R+b?=
 =?us-ascii?Q?giuS3tC6hGthuSIbI3D3PgtGUmiruY0e9mlN4wFvkTdisDZsyVAeeWCSwo26?=
 =?us-ascii?Q?I9+wOb/nFLqEKO+ca1dmLrxZTOfrvqUsYNGUS61VcdbmgtWa+/dTbnfh1ySS?=
 =?us-ascii?Q?YCOhkfcgW6PbW9OWvGm1IBLy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4488.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3279b52b-b8af-4481-5d16-08d913edb465
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2021 19:56:30.2920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ppw/gS0Iax6NEFyikM5dnV1U4XzQuH8u23e2dzJCKl07OvfRMRfv4ZwHXxm6dQZaPCMPe5jy0nn6wW7xsW8/4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4064
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> -----Original Message-----
> From: Holger Kiehl <Holger.Kiehl@dwd.de>
> Sent: Monday, May 10, 2021 2:21 PM
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Pan, Xinhui
> <Xinhui.Pan@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> Subject: Re: [PATCH 5.12 195/384] drm/amdgpu: Fix memory leak
>=20
> On Mon, 10 May 2021, Greg Kroah-Hartman wrote:
>=20
> > From: xinhui pan <xinhui.pan@amd.com>
> >
> > [ Upstream commit 79fcd446e7e182c52c2c808c76f8de3eb6714349 ]
> >
> > drm_gem_object_put() should be paired with drm_gem_object_lookup().
> >
> > All gem objs are saved in fb->base.obj[]. Need put the old first
> > before assign a new obj.
> >
> > Trigger VRAM leak by running command below $ service gdm restart
> >
> > Signed-off-by: xinhui pan <xinhui.pan@amd.com>
> > Acked-by: Alex Deucher <alexander.deucher@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> > b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> > index f753e04fee99..cbe050436c7b 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> > @@ -910,8 +910,9 @@ int amdgpu_display_framebuffer_init(struct
> drm_device *dev,
> >  	}
> >
> >  	for (i =3D 1; i < rfb->base.format->num_planes; ++i) {
> > +		drm_gem_object_get(rfb->base.obj[0]);
> > +		drm_gem_object_put(rfb->base.obj[i]);
> >  		rfb->base.obj[i] =3D rfb->base.obj[0];
> > -		drm_gem_object_get(rfb->base.obj[i]);
> >  	}
> >
> >  	return 0;
> > @@ -960,6 +961,7 @@ amdgpu_display_user_framebuffer_create(struct
> drm_device *dev,
> >  		return ERR_PTR(ret);
> >  	}
> >
> > +	drm_gem_object_put(obj);
> >  	return &amdgpu_fb->base;
> >  }
> >
> > --
> > 2.30.2
> >
> This causes the following error on a AMD APU Ryzen 7 4750G:
>=20
>    May 10 19:29:50 bb8 kernel: [    2.730473] [drm] Initialized amdgpu 3.=
40.0
> 20150101 for 0000:04:00.0 on minor 0
>    May 10 19:29:50 bb8 kernel: [    2.748000] ------------[ cut here ]---=
---------
>    May 10 19:29:50 bb8 kernel: [    2.748003] refcount_t: underflow; use-=
after-
> free.
>    May 10 19:29:50 bb8 kernel: [    2.748008] WARNING: CPU: 10 PID: 513 a=
t
> lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0
>    May 10 19:29:50 bb8 kernel: [    2.748014] Modules linked in: amdgpu r=
aid1
> raid0 md_mod drm_ttm_helper ttm mfd_core iommu_v2 gpu_sched
> i2c_algo_bit crct10dif_pclmul crc32_pclmul crc32c_intel drm_kms_helper
> syscopyarea sysfillrect sysimgblt fb_sys_fops cec ghash_clmulni_intel drm
> r8169 ccp realtek pinctrl_amd fuse ecryptfs
>    May 10 19:29:50 bb8 kernel: [    2.748029] CPU: 10 PID: 513 Comm:
> plymouthd Not tainted 5.12.3 #1
>    May 10 19:29:50 bb8 kernel: [    2.748031] Hardware name: To Be Filled=
 By
> O.E.M. To Be Filled By O.E.M./X300M-STX, BIOS P1.60 04/29/2021
>    May 10 19:29:50 bb8 kernel: [    2.748032] RIP:
> 0010:refcount_warn_saturate+0xa6/0xf0
>    May 10 19:29:50 bb8 kernel: [    2.748034] Code: 05 79 34 17 01 01 e8 =
cd 51 4a
> 00 0f 0b c3 80 3d 67 34 17 01 00 75 95 48 c7 c7 a0 90 13 99 c6 05 57 34 1=
7 01 01 e8
> ae 51 4a 00 <0f> 0b c3 80 3d 46 34 17 01 00 0f 85 72 ff ff ff 48 c7 c7 f8=
 90 13
>    May 10 19:29:50 bb8 kernel: [    2.748036] RSP: 0018:ffffb2ccc07f7d58
> EFLAGS: 00010292
>    May 10 19:29:50 bb8 kernel: [    2.748038] RAX: 0000000000000026 RBX:
> ffff90d28d313000 RCX: 0000000000000027
>    May 10 19:29:50 bb8 kernel: [    2.748039] RDX: ffff90e081c975c8 RSI:
> 0000000000000001 RDI: ffff90e081c975c0
>    May 10 19:29:50 bb8 kernel: [    2.748040] RBP: ffff90d290b1b458 R08:
> 0000000000000000 R09: ffffb2ccc07f7b98
>    May 10 19:29:50 bb8 kernel: [    2.748040] R10: 0000000000000001 R11:
> 0000000000000001 R12: ffff90d28d313000
>    May 10 19:29:50 bb8 kernel: [    2.748041] R13: ffff90d28d313128 R14:
> ffff90d28d313050 R15: ffff90d28d313000
>    May 10 19:29:50 bb8 kernel: [    2.748042] FS:  00007fa31f454800(0000)
> GS:ffff90e081c80000(0000) knlGS:0000000000000000
>    May 10 19:29:50 bb8 kernel: [    2.748043] CS:  0010 DS: 0000 ES: 0000=
 CR0:
> 0000000080050033
>    May 10 19:29:50 bb8 kernel: [    2.748044] CR2: 00007fa31f42e000 CR3:
> 000000010e1d2000 CR4: 0000000000350ee0
>    May 10 19:29:50 bb8 kernel: [    2.748046] Call Trace:
>    May 10 19:29:50 bb8 kernel: [    2.748049]
> drm_gem_object_release_handle+0x6b/0x80 [drm]
>    May 10 19:29:50 bb8 kernel: [    2.748068]  ?
> drm_mode_destroy_dumb+0x40/0x40 [drm]
>    May 10 19:29:50 bb8 kernel: [    2.748086]
> drm_gem_handle_delete+0x4f/0x80 [drm]
>    May 10 19:29:50 bb8 kernel: [    2.748101]  ?
> drm_mode_destroy_dumb+0x40/0x40 [drm]
>    May 10 19:29:50 bb8 kernel: [    2.748117]  drm_ioctl_kernel+0x87/0xd0
> [drm]
>    May 10 19:29:50 bb8 kernel: [    2.748133]  drm_ioctl+0x205/0x3a0 [drm=
]
>    May 10 19:29:50 bb8 kernel: [    2.748149]  ?
> drm_mode_destroy_dumb+0x40/0x40 [drm]
>    May 10 19:29:50 bb8 kernel: [    2.748164]  amdgpu_drm_ioctl+0x49/0x80
> [amdgpu]
>    May 10 19:29:50 bb8 kernel: [    2.748263]  __x64_sys_ioctl+0x82/0xb0
>    May 10 19:29:50 bb8 kernel: [    2.748266]  do_syscall_64+0x33/0x40
>    May 10 19:29:50 bb8 kernel: [    2.748269]
> entry_SYSCALL_64_after_hwframe+0x44/0xae
>    May 10 19:29:50 bb8 kernel: [    2.748271] RIP: 0033:0x7fa31f7d30ab
>    May 10 19:29:50 bb8 kernel: [    2.748273] Code: ff ff ff 85 c0 79 9b =
49 c7 c4 ff
> ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b=
8 10 00 00 00
> 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 bd 0c 00 f7 d8 64 89 01 48
>    May 10 19:29:50 bb8 kernel: [    2.748274] RSP: 002b:00007ffe145fb638
> EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>    May 10 19:29:50 bb8 kernel: [    2.748275] RAX: ffffffffffffffda RBX:
> 00007ffe145fb67c RCX: 00007fa31f7d30ab
>    May 10 19:29:50 bb8 kernel: [    2.748276] RDX: 00007ffe145fb67c RSI:
> 00000000c00464b4 RDI: 000000000000000a
>    May 10 19:29:50 bb8 kernel: [    2.748277] RBP: 00000000c00464b4 R08:
> 00005620f7832c40 R09: 0000000000000007
>    May 10 19:29:50 bb8 kernel: [    2.748278] R10: 00005620f7832c40 R11:
> 0000000000000246 R12: 0000000000000001
>    May 10 19:29:50 bb8 kernel: [    2.748278] R13: 000000000000000a R14:
> 000000000000000b R15: 00007fa31f8c6e20
>    May 10 19:29:50 bb8 kernel: [    2.748280] ---[ end trace 57825da3e46e=
bfc7 ]-
> --
>=20
> On another system with a Ryzen 5 3400G a reboot will hang.
>=20
> If I remove this patch the system boots fine and there is no error messag=
e.

This patch is a fix specifically for:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Df258907fdd835e1aed6d666b00cdd0f186676b7c
It does not make sense on it's own.

Alex
