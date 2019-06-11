Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA30417DE
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 00:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407758AbfFKWEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 18:04:48 -0400
Received: from mail-eopbgr770120.outbound.protection.outlook.com ([40.107.77.120]:27206
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405561AbfFKWEr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 18:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYlqfgTDbNmEATouxYpaVla38xRVYG5Congtrf73+1o=;
 b=bSN5Qv5YSvd9+5EgL9ykIQUh0XEkVudovlLAWegWn8FiPwPdPTGX+YMxg67feOZjNK4tQhzVT2GgZ/Ms3GhVjv1AktIPSgUERg6IX4BvK15tD4oep2ozZFh9HGqECkjRenZUj38gP6O/Bz2rwdlDlleqJAGi6VAaypNeVUrqRXk=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1232.namprd22.prod.outlook.com (10.174.160.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 11 Jun 2019 22:04:43 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40%2]) with mapi id 15.20.1987.010; Tue, 11 Jun 2019
 22:04:43 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     Paul Cercueil <paul@crapouillou.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, "od@zcrc.me" <od@zcrc.me>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: lb60: Fix pin mappings
Thread-Topic: [PATCH] MIPS: lb60: Fix pin mappings
Thread-Index: AQHVGvNR1qZ4gQD8hE2mZTClh06Tw6aQxdgAgADKEACAADlIgIAFREAA
Date:   Tue, 11 Jun 2019 22:04:43 +0000
Message-ID: <20190611220441.2u4udxfmyjcdio65@pburton-laptop>
References: <20190604163311.19059-1-paul@crapouillou.net>
 <CACRpkdbKg22OyViYhXS=Vyps=2zQ_dmm23Xr8+dBp+uwwjheuQ@mail.gmail.com>
 <1559988846.1815.1@crapouillou.net>
 <CACRpkdbKWC7ULFjN1c5axg5FBeeWWXCsbbQi2ks4+5tg07Br-g@mail.gmail.com>
In-Reply-To: <CACRpkdbKWC7ULFjN1c5axg5FBeeWWXCsbbQi2ks4+5tg07Br-g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0040.namprd08.prod.outlook.com
 (2603:10b6:a03:117::17) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
user-agent: NeoMutt/20180716
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b14cf263-0b25-40c6-8647-08d6eeb8cec8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR2201MB1232;
x-ms-traffictypediagnostic: MWHPR2201MB1232:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MWHPR2201MB1232DC0383DEC206DADFA553C1ED0@MWHPR2201MB1232.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(39840400004)(366004)(136003)(396003)(376002)(189003)(199004)(2906002)(54906003)(6116002)(58126008)(229853002)(44832011)(256004)(33716001)(6486002)(316002)(3846002)(71190400001)(71200400001)(1076003)(6436002)(99286004)(478600001)(6506007)(386003)(66066001)(102836004)(486006)(4326008)(76176011)(6916009)(25786009)(6246003)(186003)(966005)(68736007)(81156014)(8676002)(81166006)(8936002)(5660300002)(26005)(9686003)(305945005)(14454004)(52116002)(446003)(7736002)(6306002)(11346002)(6512007)(73956011)(66556008)(66946007)(66446008)(66476007)(476003)(64756008)(42882007)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1232;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ex1oY5d4bn9ob86Bk/ikGdn2i4Fow9qCN3KbfemaFa7IQMfSFyN5aIJFMHUR/yLHVf8GDl/80AyFXpNLnqTH3eAGoh5nIWXJNBjC0yypP3gi6wwCL5shrRfOLPv6420BM+trItsYe/cK4OpaFf+g1QvuDZbjVzTUidZCibreA2Sty0YH3BrBkPFzKrc/WwS7FCkGDckkaHJ3GW094/Ga4DdQqRDGlPnKbTAeKU5CXjIhG55w3ZOGo+7gk1Mw2rgqC/56DoQyoJORNpeIaITO0K2EQCr7LuEoDOjNMOo3hsu7fUn45++JL6lM6xj6TKNo9n756jZcoNcWkgdv6gMb2Yk9cmcQ8Qk/5ao38qQy+Egpl/lYX340phVsCLYeln3ZmLeJR6JlElXB9/oRvlvVfMsXyXUugpnk/kWnLQFSGbI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <292DA4A93A9B544C8AA0339A409B757D@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14cf263-0b25-40c6-8647-08d6eeb8cec8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 22:04:43.5669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1232
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus / Paul,

On Sat, Jun 08, 2019 at 03:39:07PM +0200, Linus Walleij wrote:
> > Yes, that's definitely what's planned; right now the blockers are
> > patchsets [1] and [2]. [1] is ignored by everybody because there's no
> > maintainer for drivers/memory/. [2] is a year-long effort that still
> > doesn't show me the light at the end of the tunnel.
> >
> > [1] https://lkml.org/lkml/2019/6/4/743
> > [2] https://lkml.org/lkml/2019/5/21/679
>=20
> What? That's unacceptable, the last resort is usually to send the
> patches to Andrew Morton (whether fair or not) when nothing gets
> applied.
>=20
> In this case I would however encourage the MIPS maintainer to
> simply queue this stuff in the MIPS tree as blocking his arch work
> if not merged, Ralf would you consider just queueing this?
> I do not think the other Linus would mind.

I'd be happy to queue up [1] in mips-next, it looks pretty innocuous.

I can definitely feel Paul's pain on [2], but I see v12 is still getting
feedback so...

Thanks,
    Paul
