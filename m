Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED4568462
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 09:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbfGOH1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 03:27:53 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:54366
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfGOH1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 03:27:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a44a1+j7gjZETpmj5fXu98/O97TrrJ7MTpMidrQwjk+XfAzA0WVluof7pPM+TP8JaCQ2kZVEzX04niMH/llNKczaVtElHGKsIK3LV73BUenE7aW3JMf2wdnvHLkAmCZC0kQcB/IxyONyM82WQtt9lrG4a4d9Ls7e+WrRCWh5Il/WXvpTge0b04cLsZviIOfzG/FSUWGs5VmXTKheb8uLwmj7ZbNS1V01r3WzYZXNfmL7bOxglVIPpq0jubKdyqu02Qf+tXcayBgTJqWDX5A8UyHKze3gl/luSTlDkfz80vfjY+hnonqVmoypqMYLvGTJtx+ujqjgO+TLmD31fHieMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wwGg6fZ7lyBlw1Tr3tETTaPUObcmmmYIE+KP3B1cgg=;
 b=KTKAdq2r1xT64ujCagsyko/b/WNdkYV4i2OF7YuHBgfkS9EUvdYuO5/xVcqxmV5goyEUPexjmGMhdK9JHUYxcgHqAgWwJ+e6pdISpxZkEvr36ybfeBr1jf1n+lwDU+16KW63V6cRx7qMKMvBGpiONcEEH4zqu29AdAr1hBKDxzEH7mHdk1fqWF++X2lVllSE2xg2iTPVGBUKHNWSNtiLmcYkrtnFrQXKXkJiVxcacjRMbeFYGGLPdHV8evIytBO/a9L1KGblmqBQX8WbnmJOZZj+u0xYSQhOnAXFZG6m6yt3conB4itDycyPxFVsMGV2ibaFYboFrNxPLdDlW1aIfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wwGg6fZ7lyBlw1Tr3tETTaPUObcmmmYIE+KP3B1cgg=;
 b=o78l5pBPKm86fVrKkUCbbAjYYHcgHT3nec1cYIHAyHJ2sqWlHCfb7howkFho7F05BeGaDDx1sHCKW2I8iU1rRxH0t7IxPe8edQQwEH3Io0ByobbgRzRTHZBJyJJJeHl15/gXlukhpT07WUOKTYSC1fZPvdrez70HPmOp32yALbA=
Received: from AM0PR04MB5779.eurprd04.prod.outlook.com (20.178.202.151) by
 AM0PR04MB4065.eurprd04.prod.outlook.com (52.134.90.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Mon, 15 Jul 2019 07:27:48 +0000
Received: from AM0PR04MB5779.eurprd04.prod.outlook.com
 ([fe80::a126:d121:200:367]) by AM0PR04MB5779.eurprd04.prod.outlook.com
 ([fe80::a126:d121:200:367%7]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 07:27:48 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Peng Fan <peng.fan@nxp.com>
CC:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Anson Huang <anson.huang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "van.freenix@gmail.com" <van.freenix@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] clk: imx: imx8mm: fix audio pll setting
Thread-Topic: [PATCH] clk: imx: imx8mm: fix audio pll setting
Thread-Index: AQHVOrjKqRILo4kj1ESmmUTSG4SPJabLSCeA
Date:   Mon, 15 Jul 2019 07:27:48 +0000
Message-ID: <20190715072747.2743qdbk2umcpzgq@fsr-ub1664-175>
References: <1563157783-31846-1-git-send-email-peng.fan@nxp.com>
In-Reply-To: <1563157783-31846-1-git-send-email-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=abel.vesa@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7ccfe50-32ca-4386-67e0-08d708f5f02e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4065;
x-ms-traffictypediagnostic: AM0PR04MB4065:
x-microsoft-antispam-prvs: <AM0PR04MB4065237A99D46EFD01EDD8C7F6CF0@AM0PR04MB4065.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(199004)(189003)(7736002)(5660300002)(229853002)(68736007)(4326008)(99286004)(66446008)(6636002)(64756008)(305945005)(66556008)(2906002)(316002)(86362001)(53936002)(53546011)(6246003)(6506007)(6862004)(76176011)(6116002)(1076003)(8936002)(8676002)(71190400001)(71200400001)(3846002)(478600001)(25786009)(66946007)(66476007)(76116006)(91956017)(14454004)(81156014)(81166006)(11346002)(446003)(186003)(7416002)(6486002)(26005)(54906003)(6436002)(33716001)(256004)(476003)(14444005)(102836004)(44832011)(66066001)(486006)(6512007)(9686003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4065;H:AM0PR04MB5779.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /BMCIRXGqa5wWmHO37ODdRVw3aiyKQS/gtAPsegfKA5wR4ti/rhghQegLj0b+C9P7gbvCTVEYdNWdCTQ4dhJEmpENqypKYGxB1vOLXEfpMZc9mh9epNFi9AxcuCXESmMAqFbO0iKsKovvrtzBxAumgYJ0S4DAyA5Bpu2QiUZoZbGIrsXaBpnvtC3EAT+6UwRljbhDZMzn5YR77nLm3OA3GFKZvWmCJ4B3fDU3YZYj//vXx9CoiXNtwnFHpAcVz3lhHhrSFHOTNqN8+nfYv5H83texr4EQZceMlVrYRXe2bfsKiV/3ddrAVWBjBvAg7xNNawECaLgMX2JwJf3Kf4RKbD3n427GhUgTn2G0ikQ/yDmJhe+vmwaALqcmmUawDd9z2SYJvfhlL0EQH2ejYIllBvFUc5k7z9tQBXum0p4jJE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F92EE601217D114A8D8E61B8B9DBA641@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ccfe50-32ca-4386-67e0-08d708f5f02e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 07:27:48.2978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: abel.vesa@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4065
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19-07-15 02:55:43, Peng Fan wrote:
> From: Peng Fan <peng.fan@nxp.com>
>=20
> The AUDIO PLL max support 650M, so the original clk settings violate
> spec. This patch makes the output 786432000 -> 393216000,
> and 722534400 -> 361267200 to aligned with NXP vendor kernel without any
> impact on audio functionality and go within 650MHz PLL limit.
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: ba5625c3e272 ("clk: imx: Add clock driver support for imx8mm")
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Acked-by: Abel Vesa <abel.vesa@nxp.com>

> ---
>  drivers/clk/imx/clk-imx8mm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/clk/imx/clk-imx8mm.c b/drivers/clk/imx/clk-imx8mm.c
> index 3a873e0e278f..b72bad064d8d 100644
> --- a/drivers/clk/imx/clk-imx8mm.c
> +++ b/drivers/clk/imx/clk-imx8mm.c
> @@ -55,8 +55,8 @@ static const struct imx_pll14xx_rate_table imx8mm_pll14=
16x_tbl[] =3D {
>  };
> =20
>  static const struct imx_pll14xx_rate_table imx8mm_audiopll_tbl[] =3D {
> -	PLL_1443X_RATE(786432000U, 655, 5, 2, 23593),
> -	PLL_1443X_RATE(722534400U, 301, 5, 1, 3670),
> +	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
> +	PLL_1443X_RATE(361267200U, 361, 3, 3, 17511),
>  };
> =20
>  static const struct imx_pll14xx_rate_table imx8mm_videopll_tbl[] =3D {
> --=20
> 2.16.4
> =
