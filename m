Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B78D3B66C3
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 18:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhF1QcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 12:32:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:36022 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233450AbhF1QcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 12:32:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="187676655"
X-IronPort-AV: E=Sophos;i="5.83,306,1616482800"; 
   d="scan'208";a="187676655"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 09:29:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,306,1616482800"; 
   d="scan'208";a="640969072"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jun 2021 09:29:38 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 09:29:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 28 Jun 2021 09:29:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 28 Jun 2021 09:29:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO4KeQeX53B41L4EhsJhfkpysfaoca2zjwCDIFtgww+0818YASAyq+RdBXhEsSPCV5te8OwlH4kl5e5OqABcVm1fM4DUAxnPRL/raJD8pm8XYurJBE+TVJg9ogMlmP/rN3sgr8u7moxHIeOJoZq3pZfscfECmKovpEAjxejualLauGn3eufqhAB6+mDQhMF9+Ky1d4/h9PfiO0zpo/hivLZsmJ5L8/S7Z4wPNqNp33sbv9rEjkZomxQ3Ue9ps5fFQcUe6rXdTmbzj4+ahb7UKhkroJqb7XfdhJceLIXepClMQwrXCD3FvT9og5umoskBpo/3Qt8fZ2zhMGPP8Ok/WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WrQsoCLVXvV2DIIDuWmqIaqAuzCXSLC3X17mMycZSA=;
 b=Cq1KZHMOiw0IRmrqZi7aTp77HKkPrinwDGa5FisXsP7z28QYtxOmwj4JtUOs/R15yyqQ/Tpp0RJnYLwNodF1TCtf340RUUL3RMMFXZlJ7gICjAiNfvM8MVfi1iIlr5wA9W11kQrh2ZcEX3PDibn/92jsLS6+mk2MUwxrD3Wt4OeAWhMHlkPIPOQirPFLdAX/KNkTWoJKpimF73zxgLA/Ei4OsCPBGz+tcoAXpDuvicUZNXl+SxpNX1RpQpGry2uc2SgqZ/1v/SkMPnJI/4n0PyLi5jvetfcXVT4pvE8Kyp3rVdG2H69FG5SzJqsYj7BRktpSNS9rjbMPYWeg19U1BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WrQsoCLVXvV2DIIDuWmqIaqAuzCXSLC3X17mMycZSA=;
 b=uAsm3FklyvFDORnKwi0Z3zZTNAPbP3Xa7DBx5rdIN6SqupxSxnchUVPYzOHtLr3nUxhW8eBsC4e0qgPK9oBDujEaHwvDPLgEN/2/MXe7/W9sn/nlS79D/mDeZi4WxN0iOn//PczD9wU4lfR3OzV80RiFID5ZysRfgZnvu7IAILE=
Received: from BY5PR11MB4182.namprd11.prod.outlook.com (2603:10b6:a03:183::10)
 by SJ0PR11MB5005.namprd11.prod.outlook.com (2603:10b6:a03:2d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Mon, 28 Jun
 2021 16:29:37 +0000
Received: from BY5PR11MB4182.namprd11.prod.outlook.com
 ([fe80::c9de:2018:5e7c:87c9]) by BY5PR11MB4182.namprd11.prod.outlook.com
 ([fe80::c9de:2018:5e7c:87c9%7]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 16:29:37 +0000
From:   "Chrisanthus, Anitha" <anitha.chrisanthus@intel.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: RE: [PATCH 5.12 019/110] drm/kmb: Fix error return code in
 kmb_hw_init()
Thread-Topic: [PATCH 5.12 019/110] drm/kmb: Fix error return code in
 kmb_hw_init()
Thread-Index: AQHXbCiO5NNGuFG7IEKifxAIWui3IKspnNXQ
Date:   Mon, 28 Jun 2021 16:29:37 +0000
Message-ID: <BY5PR11MB418269C8584FC8AAD088CA9C8C039@BY5PR11MB4182.namprd11.prod.outlook.com>
References: <20210628141828.31757-1-sashal@kernel.org>
 <20210628141828.31757-20-sashal@kernel.org>
In-Reply-To: <20210628141828.31757-20-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.41.68.160]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c40edb3a-9008-43c8-a502-08d93a51ebe0
x-ms-traffictypediagnostic: SJ0PR11MB5005:
x-microsoft-antispam-prvs: <SJ0PR11MB5005583379CEDC49690A02C98C039@SJ0PR11MB5005.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VqCpDMSUEtGXV0oa0Epp+RDJ0mQYSuSzgRshgBm48+o2WlfDWqxc/qJt2JERZkZMBI4+xveIDYICe6xttAkwUzhtSr6Ib717KGUSm4YNBYMBRHkdWbEdTPhmlwH4EmgWx2TDBCU2Dolto9olp9aQvlb2fM4tR7R9ew4uJG6Kof0TvfK8JkUOf5nJjuT1cwPy+DGDFEdnZWBEBijpF5Q6+f1kd3lirXKuff4Ho7SecMU6ImTBv5FlNvVcK1MYLVPBenG46sb8JOS33BxwZ4pGMvsR2C+qAGtYMcPwYNGCovcqg+z1F8fSxGN1+F+8+yANQLnwnVnWPy9OIt0xFSA1Tg5TAQAk+wRRwPpj27Sjhns6tuZWp4ueDzL7epoJrKTUo2TflUznXR3+Tws2wioRBFiPKxMqJENPq/trUkwVdfi1KSNvxufSimuHaJc8iQRUrhFSALh9zhiDZn/PPG9fTw9VQl5rWEl2n1o572KmT36GJDYLrK+rkFkK82KNsU6RSsmYJR/NJZMOkxxAAhPplFjPFGA5imnvr9Y7i4yMnzGdJI7U9lp4C6ovDZODrk8Zt5CuIexiRVmSzHdwRzYGtEDCNmSSHLIJz7kcuZhQVGm/jn0XBHafRKye2aVODTPXnnzUkzBsll1L/lJF4PEuC0eXi2aKz2eTvdITmeRj9EYc7NGH2bgfGKqYxNWuY6V9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4182.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(83380400001)(55016002)(8676002)(9686003)(33656002)(86362001)(8936002)(66946007)(110136005)(66476007)(76116006)(122000001)(71200400001)(54906003)(316002)(26005)(52536014)(186003)(7696005)(66446008)(64756008)(4326008)(5660300002)(478600001)(966005)(6506007)(53546011)(38100700002)(2906002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u7tJg3pT/O2KzYCKidUs8m6UlFPWBqWiZAFxiR/A+2kMVX1Mhwl32PWEx9GS?=
 =?us-ascii?Q?GkUPklIDZSnbo1izXn1lUlW6NuoaWTyRfjAuiBfGjg/AWeyjAD7cbZFQ4H2y?=
 =?us-ascii?Q?APgbtkf8POEsV1ZPL8cmKFIc2IoITCsTdeyVjjg6ZLKZRFumCakc6Oi272Iq?=
 =?us-ascii?Q?v/7MkO6iTzxgIoyKTo4ALRxmyh8exeyD7fonie5s+5whymo75MfVTpEMRtBo?=
 =?us-ascii?Q?YVQ1FATbKYWGaA+NHTCHmTc6mgcDBYRxazEyjjJ102QUPEE30w+q7LZORAN3?=
 =?us-ascii?Q?GAzzYrSfrmd86yJt5UwbOju/Q+JYziFGf/dt0uOGnJ09XSE3IUkLotxTvSBg?=
 =?us-ascii?Q?Fn2o9kz59c6L1dvZrIvn1/ciBCgDHvc/MnqqrrtEhkp7XhbdImvsE70vVjtk?=
 =?us-ascii?Q?IPWk6Sk6Cx3dxhMJ8p4gmXY+o67DHsQz6JDJeNHA6dYy5hwxQW+NW3tX8o6j?=
 =?us-ascii?Q?aI/78mPE+fgbsRyuGf+E/djs7uE/KiGl238JOICPOwRq8eZgQ880HD8ylzub?=
 =?us-ascii?Q?vFsV2bGnV1L/NqMpYtE7uH48k7EOLsT9O6/45Vh7YEpRjp4TTfccFzaXzZnt?=
 =?us-ascii?Q?N3TIHDE++k3rlQWgnarYN5rlIJVGjzukhIecrhzOwUFj349o9uhJP1zXHs3J?=
 =?us-ascii?Q?ylluU5mp2gL2V3n5r90fw8vinFuyshsWWAORai4JX4DxRp4+crB9QUCF6UUg?=
 =?us-ascii?Q?eAIiaJbkwZQsrld9tCW+MIk6TlyQ2yM77VtXVy2/XA7WhHar9J2mbl72oAnE?=
 =?us-ascii?Q?8AGyq/Kf9SziUFohGtLznMjHHITe8koDVQTV6jWfBH13N3+a0ogvSVxDgcQJ?=
 =?us-ascii?Q?Co6lhJ+ugP22BKcBDw2tNvt1NUk9L5eDfC9HrbY01F8XHTcEt7OWJfzgNu5m?=
 =?us-ascii?Q?U15YFDImdepOkYb/0PxELMvaBgNYaveb+SFcjhACTSOQYz62se/R4VylAL5b?=
 =?us-ascii?Q?DJ14GPf+msvnwJ0boj0vnM7lsfmuuOgltXgpPxkctghQH+Wys3DCiWDHENqa?=
 =?us-ascii?Q?tnoe6Jb0w5v4LyPrzZOcIrZhJvaYTzLqF/vrb17WLfonsbSkkJ+pQwZvDz2g?=
 =?us-ascii?Q?dH18fjmoaCOS2dDAFEMpljneGhlkgmI3j6GLuwCCZibQlGtt/J2ncksrClrw?=
 =?us-ascii?Q?biN6oC/1JxzOQtF4q6qEjkbn7F4qJc4CtNh4J7sFWWmUlgoA6/dtqoRUtV6C?=
 =?us-ascii?Q?nwspPpPNkKC2g38unYn6ug5X6yslzasOBviGR27WaX9GSeW7AhcCFBKVI7R9?=
 =?us-ascii?Q?L8LLC4c9eP+hLi7MuMdAkMTWUnr7sIjRI8JrA/i9OTnydRKacQj95UVNPkuo?=
 =?us-ascii?Q?OGk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4182.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40edb3a-9008-43c8-a502-08d93a51ebe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 16:29:37.2816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 706XFFAuqWNVpXKBfEMvopT6Mm2wzhNCvpvQ2QKSKtXcjGHGMSABTPQnOfkPrJo2MeuvI/4xeMQb/sEdQQeNAUpwbK+uFxu9MVtB/2fuOpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5005
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is already pushed to drm-misc-fixes. Please check for existing p=
atches in the dri-devel mail list before sending patches.

Thanks,
Anitha

> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Monday, June 28, 2021 7:17 AM
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Zhen Lei <thunder.leizhen@huawei.com>; Hulk Robot
> <hulkci@huawei.com>; Chrisanthus, Anitha <anitha.chrisanthus@intel.com>;
> Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 5.12 019/110] drm/kmb: Fix error return code in
> kmb_hw_init()
>=20
> From: Zhen Lei <thunder.leizhen@huawei.com>
>=20
> [ Upstream commit 6fd8f323b3e4e5290d02174559308669507c00dd ]
>=20
> When the call to platform_get_irq() to obtain the IRQ of the lcd fails, t=
he
> returned error code should be propagated. However, we currently do not
> explicitly assign this error code to 'ret'. As a result, 0 was incorrectl=
y
> returned.
>=20
> Fixes: 7f7b96a8a0a1 ("drm/kmb: Add support for KeemBay Display")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20210513134639.6541-
> 1-thunder.leizhen@huawei.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/kmb/kmb_drv.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/gpu/drm/kmb/kmb_drv.c
> b/drivers/gpu/drm/kmb/kmb_drv.c
> index f64e06e1067d..96ea1a2c11dd 100644
> --- a/drivers/gpu/drm/kmb/kmb_drv.c
> +++ b/drivers/gpu/drm/kmb/kmb_drv.c
> @@ -137,6 +137,7 @@ static int kmb_hw_init(struct drm_device *drm,
> unsigned long flags)
>  	/* Allocate LCD interrupt resources */
>  	irq_lcd =3D platform_get_irq(pdev, 0);
>  	if (irq_lcd < 0) {
> +		ret =3D irq_lcd;
>  		drm_err(&kmb->drm, "irq_lcd not found");
>  		goto setup_fail;
>  	}
> --
> 2.30.2

