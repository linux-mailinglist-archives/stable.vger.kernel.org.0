Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B70A309B9
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 09:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfEaH45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 03:56:57 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:4199
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725963AbfEaH44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 03:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUNanSQS9LC1pT5UQhboECcs+Q/6GY5ZrtjTwqLVF3A=;
 b=pUsQFbpODN6tiKhXTPPX0HwyO+t8/cV21mpAuNFMfxOIVDdUFfRa3bGacLty6cuHXysXshv0Ew1ADwoEAbHwwN6rcuzWcDjjPVsc4XTOC8iFQZ6yA5gY5gZOMDBesMrnuX0A8OTs4ALPq77vSSbf0+n0dwYyQR9gKWyq+iRM938=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB5041.eurprd04.prod.outlook.com (20.176.214.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.19; Fri, 31 May 2019 07:56:51 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::3173:24:d401:2378%6]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 07:56:51 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>
CC:     Stephen Boyd <sboyd@kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
 audio_pll2_out
Thread-Topic: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
 audio_pll2_out
Thread-Index: AQHVED6JGbhPMl1ASUycBcbN9uhZiqZ4tK8AgAoZTgCAAB1qcIAB/gsAgAACfsA=
Date:   Fri, 31 May 2019 07:56:51 +0000
Message-ID: <AM0PR04MB4481853F9CF85F6B5CB7FA7088190@AM0PR04MB4481.eurprd04.prod.outlook.com>
References: <20190522014832.29485-1-peng.fan@nxp.com>
 <20190523132235.GZ9261@dragon> <20190529233547.B7F6F2435D@mail.kernel.org>
 <AM0PR04MB4481A7FF28A9AB9A1584423888180@AM0PR04MB4481.eurprd04.prod.outlook.com>
 <20190531074633.GF23453@dragon>
In-Reply-To: <20190531074633.GF23453@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1753ada6-17d6-4672-d178-08d6e59d8a86
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB5041;
x-ms-traffictypediagnostic: AM0PR04MB5041:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM0PR04MB5041B57F9555945D443FF69588190@AM0PR04MB5041.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(366004)(376002)(189003)(199004)(66556008)(73956011)(66476007)(66946007)(86362001)(7416002)(4326008)(64756008)(966005)(14454004)(76116006)(186003)(3846002)(6116002)(45080400002)(478600001)(8676002)(81156014)(66446008)(81166006)(476003)(8936002)(11346002)(446003)(7736002)(33656002)(44832011)(2906002)(6246003)(305945005)(74316002)(52536014)(486006)(54906003)(5660300002)(229853002)(6506007)(99286004)(6306002)(6916009)(76176011)(7696005)(102836004)(55016002)(26005)(71190400001)(9686003)(68736007)(316002)(6436002)(66066001)(71200400001)(25786009)(53936002)(256004)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5041;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +l2I7DAVaF5+LpP3NTIlJ2kWQlFOpzn6QSKe+V7v8uTZ4oOqedoDhXax1ZvlZLQlnz2sMd3HAk+8OV3Da7adVkizqhp8M07nokwYXJVA/xLfgZAeGKuaLG6QhEiXRHCtzXR7F1RH6ZJnyjXf7IN9xWLmUcqozrOiUmrPBDzEMJDjH5lYg7vTLsFvKwv63QVOTg7Ik3bWIQHCR9RCPIotcetm03PbD0fI9PzLqaF27NcGGQ9NgMlQ7ZdUVAswovVC/gDPtl16GzHK/zSN28a2uV/JOf3ooSw9AFe3UBBNHx+xaHogXCGqSMB67HudMV61n0gUO/1m+Bt2dGcymtkr3cO3DaDekOEtqqiXiCAdpRSGw0soz3CzxeqSHD2DpSbnVXSDP1abkmr8+L4NkySXn2U169tOn2vY659bRrf8wHc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1753ada6-17d6-4672-d178-08d6e59d8a86
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 07:56:51.5341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: peng.fan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5041
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shawn,

> Subject: Re: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
> audio_pll2_out
>=20
> On Thu, May 30, 2019 at 01:22:57AM +0000, Peng Fan wrote:
> > Hi Stephen,
> >
> > > Subject: Re: [PATCH] clk: imx: imx8mm: correct audio_pll2_clk to
> > > audio_pll2_out
> > >
> > > Quoting Shawn Guo (2019-05-23 06:22:36)
> > > > On Wed, May 22, 2019 at 01:34:46AM +0000, Peng Fan wrote:
> > > > > There is no audio_pll2_clk registered, it should be audio_pll2_ou=
t.
> > > > >
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Fixes: ba5625c3e27 ("clk: imx: Add clock driver support for
> > > > > imx8mm")
> > > > > Signed-off-by: Peng Fan <peng.fan@nxp.com>
> > > >
> > > > Stephen,
> > > >
> > > > I leave this to you, since it's a fix.
> > > >
> > >
> > > Is it a critical fix? Or is it an annoyance that can wait in -next
> > > until the next merge window?
> >
> > I did not run into issue without this fix currently, so it should be
> > fine to wait in -next until the next merge window.
>=20
> I was trying to pick up the patch, but the base64 Content-Transfer-Encodi=
ng
> make the applying difficult.  Please talk to NXP colleague Anson Huang
> <Anson.Huang@nxp.com> to find out how to fix it.

This patch was sent out before we find workaround in our IT.
Sorry for inconvenience. Patch was resent just now,
https://patchwork.kernel.org/patch/10969743/

Thanks,
Peng.

>=20
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatch
> work.kernel.org%2Fpatch%2F10944169%2F%2322656941&amp;data=3D02%7C
> 01%7Cpeng.fan%40nxp.com%7Ca54e9a2a6ebf4411be7808d6e59c4c2e%7C6
> 86ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C636948856849287143&
> amp;sdata=3D9ONV36WZT2owv07e%2Faf2IzQU5KzRE3S111joTBzsXJQ%3D&a
> mp;reserved=3D0
>=20
> Shawn
