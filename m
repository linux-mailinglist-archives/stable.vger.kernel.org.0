Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BE9406627
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 05:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhIJDbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 23:31:43 -0400
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:2432
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229929AbhIJDbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 23:31:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOD+2IyJefK0HcwCl0KhHlO4hq7ZJEbG7u5Q8zlUI4zmd31xIN93Ikv7tYgpNP1YFqrgr9PMpMk9h3P6P7WBgt9Yxxpoijfh1wjWG5PP8icvmnP4wNo5XwxcbTXT7q4Ufko/EwlRatj1FB7Okx5492r2sh/7P9eHySMyvHGM2UjWvbXWri/FYbR2VHiEz00fivfwSnVE+oOlfCYtxXOdQ15jUh7XYoGolG2GaxVTHe1QMmuNDD+OxmWS9y+UFKkLgd0qi92/q4juv8QTILRQEkGZnj48JNvKn4oc1tUaU2dg/dOHtp6CwJkhi/qRvXdRvPYPcPrmvKQw0vePYPJxlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xA/WU93xrfMs9lHATSEskRf9EXYoenE7/UQW0OWXFTI=;
 b=mhXWjuqKKb3Ou6YlLSXUuQ3L9XhX1XTD7fm3eAEaMq1Tx3JyXJ218VE1wnWedE0dgxApoQ6h+qoFfWqMiubEr4j0oiSGkn9VIDIspF+aAHqjeBmMIq6447G2fosG/17Me7J4h4NbDJ9onM5HxNxGeuF1p3H5bzq5E9Vyas6gazt6lsuF32QN1LUnarsZCx266S83pS5+1zfQTXcmwxnAsJt+ENZdL8x/edXLVIQda54oj/T7VEs0fhZ4qZN/DPFXipEzBeEl4nqHuagt/A+HitorrIvHsbWXltkHY3AIa5BK2OO5oAfCRKxhGUx6ehGvC2ASuWwVxSTmAVMpsN8Pbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xA/WU93xrfMs9lHATSEskRf9EXYoenE7/UQW0OWXFTI=;
 b=FAj6EZ9xHhILHnrqkGCA0mT7NBV6YnULj2aUoQ7cdO8VBNRnftYjiQyE9RIxnAs40K1ucSJ9m/iEfkB3Bq1zRaAkUdpFhYYDmvF6aFTY5KkoBHBqJOEPBmFG3gytZi437FV+YJBKFnDN3O2vm9sASlXds1QzYqf1TyHP5sijmpc=
Received: from VE1PR04MB6688.eurprd04.prod.outlook.com (2603:10a6:803:127::25)
 by VI1PR04MB5951.eurprd04.prod.outlook.com (2603:10a6:803:d5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 03:30:27 +0000
Received: from VE1PR04MB6688.eurprd04.prod.outlook.com
 ([fe80::5901:3a55:84d6:d0fb]) by VE1PR04MB6688.eurprd04.prod.outlook.com
 ([fe80::5901:3a55:84d6:d0fb%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 03:30:27 +0000
From:   Robin Gong <yibin.gong@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>
CC:     Sasha Levin <sashal@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH AUTOSEL 5.14 058/252] spi: imx: fix ERR009165
Thread-Topic: [PATCH AUTOSEL 5.14 058/252] spi: imx: fix ERR009165
Thread-Index: AQHXpW/CnW7hBPbyOESaynmh5wkPyqub6FqAgAAB6ICAALLxsA==
Date:   Fri, 10 Sep 2021 03:30:27 +0000
Message-ID: <VE1PR04MB6688DC0E216F0EA6E1A4349E89D69@VE1PR04MB6688.eurprd04.prod.outlook.com>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-58-sashal@kernel.org>
 <500c68753cac86d9b3021ddf1e8580779e685332.camel@pengutronix.de>
 <CAOMZO5D6pbTG3O14OtZRUCa5DPcG0seUzot4gX4Y=hQOpxRfdQ@mail.gmail.com>
In-Reply-To: <CAOMZO5D6pbTG3O14OtZRUCa5DPcG0seUzot4gX4Y=hQOpxRfdQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 700d6e14-f56c-42e9-99f2-08d9740b5533
x-ms-traffictypediagnostic: VI1PR04MB5951:
x-microsoft-antispam-prvs: <VI1PR04MB5951FBA551D43BA8ED8B6A5289D69@VI1PR04MB5951.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: knqFdEafDsgiT33Q7x/PyGFSkB5zLpGNvgSD24/s8Yt7ARPpjj4PwMlFwC44b98eHbO1YOH/FtjruyvcywMTuc4JQYVeN6IZ2eQzMiFxNUxDeKQbAmfYqv6hy+tvmwrQUa4zCR2nT1jeiKEmiTQj4aoXYAjlYYidLHHbAXXq6Q7F9aU9RDjxbOlJ/GPmF0V18CBVemRACoR0/OF31pE1ceKV5Eb+K4y07kGCdz4Wgf8BajzZszEd2Ey/OSDjaJquNHKCPjQ1ckU62LH7NnEZtC6zLH3Sqsx3ikhJzoVdKe3bMahsBign1twPWbO6DK1ieSdE88LJ4um0ydn6Lcr3cKcF5seb5gwvUi5NiZ07Y9BoVbAKWwCrayPa/H0chD+Qi9J5NsJomgnR1g4BXZYUG/WNM974LuOudqBcyoq8iZs9DJ6NnKffblovPwVkrU5KRuH8AYd2l/PvS73hgPURDiTKUeFwttVMJFbtcWx05UZAbBGW9kPW7iHkDm02Q6TV50LKwovFpLSisoabT4QlBAJzmEg1f6M9jBqVJhckW8AelYJu7r7OFvE+0ujSWJzi/DxAJaruDeTN2mldmNugfjr2WvG34pPz+TTvBpQj/oxqzZGEdUME/wQlw+fzN8znwYdvX0RsWAelGXA2MrSrx5AOq2i6Nj23QDfaBL4bDySUgFd6Ezy3FP1JAuOGtnz958GrPcTHCNVI9uRo35HHeXkjtKP1pdayK305UJgnBXLr9ti4CG/mO7txZsIiUFwS8xnp5B/HUwQn53kSHU8JTCU8/uUHXoh68x+66HRWU5k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(52536014)(53546011)(9686003)(6506007)(71200400001)(110136005)(7696005)(4326008)(5660300002)(2906002)(8936002)(316002)(66946007)(478600001)(38070700005)(76116006)(66556008)(26005)(66476007)(64756008)(66446008)(86362001)(8676002)(33656002)(966005)(45080400002)(186003)(54906003)(55016002)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Am5Oy4dTKrTRdxBeTwyhfNAASp1yEmw6Bhkpz+ZYAVVEvnxyweVA6Uq2Fk3N?=
 =?us-ascii?Q?W/HPN+KN59CQejZP8Uig3dxVhi0KN3UDrxLlngpTZ+UqT0BAhvNff2Vn4wn9?=
 =?us-ascii?Q?8THtCo7KZ0H2Z9r+Y7aunNhNZZo8YdggLtw26i5lX5wyUSyVh9Ia8AiNaSUc?=
 =?us-ascii?Q?PaT63DYPMHSnzhGcS4wxIGIFniRv4OR1upYJ/p3OiTKwe1SxKn5jnnZZVYE1?=
 =?us-ascii?Q?HkV2vMkyQeryezl0rn4NWh7mqt9BWGO8jklBEYz+gi0WtG91FNRf4xiAvO5e?=
 =?us-ascii?Q?+p2A63cO6yUJf2o6dFsZAfvt3Dyt+asxaQg3FvejyClghurTXxBZFihi9NzF?=
 =?us-ascii?Q?/pBsosYbN9QB+uz28RWWd/4ms0xnm1bpFSgCEqtP0WzvL90UEDpHv8/uE2nD?=
 =?us-ascii?Q?lronaYhq3hZiaMdtR6BUGCk/bxtlzhX8YfBM5PiKtKcveFmYmHlL05GwJpZf?=
 =?us-ascii?Q?Yj/+PVcd5AvJFiHXO3dAGT2bzetTY1PxfhB8Ure91623WF/9eRR8rEAN5F4M?=
 =?us-ascii?Q?yqyXGEV9s/pBLojtp7DPPna9fFHgEoREP9+FxURHhvFaQ9rXzsTMcO86QTXA?=
 =?us-ascii?Q?pYfCKV/C81juZxj9VoTVsG3sGIiDlWOQggonlZ/EMw6vfrBaKABxIqmzKXf3?=
 =?us-ascii?Q?ZHbTdPshcRwfrvSxDkOGpEKQH3qiQeUQL52RoWYtT+2EGZuf6I/XJI+ApxY2?=
 =?us-ascii?Q?m/bkWUrwXzEVqIC4I/lZ6WoUcKq5oC7TaJE5BXIO9a13M9HidOCcozh0KMwP?=
 =?us-ascii?Q?us3E9pcMuUC8QS7+3zD5WXG3yd5KHlAGHcrb1nSAypSk4Cz7WZyIPazhZ1dq?=
 =?us-ascii?Q?0v/cKZwK8vZTzQIHWNF/QnCyBOaAOIQhcc6W8EsVbXq0NQKsQG/JSFPjNJrs?=
 =?us-ascii?Q?8qsNWM78TrObCWB+jGDQluxPZTgaj6eUqWglHWyrlYyztVQT5MLuoew0Z2gD?=
 =?us-ascii?Q?8PL/rrafLQxjcFJPibuGGmheGsRNF8ODqDFgnuh/yCmgb3mCASGt0O/f0X3s?=
 =?us-ascii?Q?SQta3gpVWRCyIJ/iZ5rRFZGdvm/hhN8sOu3dIHQwlD926vLvCP+vVmHvDFQX?=
 =?us-ascii?Q?4P4grn3c5H28yhrqkizS/uSA5qdGCW3D7EQu3P2mXWGZMdizf+SuYzTuktyK?=
 =?us-ascii?Q?uWy5i6itFlHpYr7vy43EdeVzNywxD9kuSsC0fTycAoeZwiP8Dq2yijUapG/j?=
 =?us-ascii?Q?hr3qxg+AFuVWHPFY9xAt7b9taZh8p1etix8ojRPBPvrb21u9mLggJi3CABq1?=
 =?us-ascii?Q?lQv1nB5RhF4ErvDunHS0aQO4UVyYw2xbiHqpZ8FsliKQpKhKVIeEmAd5cUhR?=
 =?us-ascii?Q?dmmQr04JuvtOmeVNL2MXs5Gd?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 700d6e14-f56c-42e9-99f2-08d9740b5533
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2021 03:30:27.1693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fPzbj751qGY0sSUK1BlACu0aSN02jOxwc1Ccoa01bZJLf2pje+9mpn5fn+9q1z7gfA0WZUzz3uXsydrGyTFtBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5951
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Hi Lucas,
>=20
> On Thu, Sep 9, 2021 at 1:43 PM Lucas Stach <l.stach@pengutronix.de> wrote=
:
> >
> > Hi Sasha,
> >
> > Am Donnerstag, dem 09.09.2021 um 07:37 -0400 schrieb Sasha Levin:
> > > From: Robin Gong <yibin.gong@nxp.com>
> > >
> > > [ Upstream commit 980f884866eed4dda2a18de888c5a67dde67d640 ]
> > >
> > > Change to XCH  mode even in dma mode, please refer to the below
> > > errata:
> > > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fw=
w
> > >
> w.nxp.com%2Fdocs%2Fen%2Ferrata%2FIMX6DQCE.pdf&amp;data=3D04%7C01
> %7Cyib
> > >
> in.gong%40nxp.com%7C39f3117d59434df46fc108d973b1bb3e%7C686ea1d3
> bc2b4
> > >
> c6fa92cd99c5c301635%7C0%7C1%7C637668029454898655%7CUnknown%7
> CTWFpbGZ
> > >
> sb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn
> 0
> > > %3D%7C1000&amp;sdata=3DNxCByvu4qCGniWnXccSxLNy9ilvQhFpid7O9Ag
> 1HloI%3D&
> > > amp;reserved=3D0
> > >
> >
> > This patch is part of a quite extensive series touching multiple
> > drivers and devicetree descriptions and will do more harm than good if
> > backported without the rest of the series. The options here are:
> > a) backport the entire series (this will most likely not match the
> > stable criteria)
> > b) drop the patch from the stable queue
>=20
> Yes, I agree. I prefer going with option b).
Agree, vote for option b.

