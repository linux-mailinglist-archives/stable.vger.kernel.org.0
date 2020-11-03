Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100652A5A45
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgKCWsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:48:33 -0500
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:21476
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729575AbgKCWsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 17:48:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6JFx7bsQoVAp4xnM3QwhsVTHsoSvXn0BuT6/ynGaDWRo3Ksti82yXxScMm3GLa/jfALXRbz6UsRfVeiyl/vY8RDiAZUKEt+umkZGprmXVxLB4i6Oo7OHGykMDlS69dJUatOXTLbKhXWJDmdGFCpicT9WdkPI2XpzKbb8aFAh4cXJJWoL+Dy1eokBy6X9Y2iU0Z6IoH4a72l8twpbBff4+hw6kMHezSMk5c89vk50ak/Z4YsFt7TIXp98AIV5Fo7v/dqdfUouxYUcREIhxxwyEah+h99GO7bCRERc88lZCwUCduSHjCOsqPkrAvVwdGzTa74aA4yAtu16RuQvNqp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6DGObiAsVjGIIuVX7JDTE6b7UTLP37cJQv/J8ajf3M=;
 b=CVssQ9f09ASwaILqiJpMX5wt7aFDdafwG9d7doWVBHA6SQlSdhoBptF9UkVcOmlgu8Ue1fAba1STKPtqSF65FhxXXcunbnPalNoooFWhCb9nI6SSEDBz1uvdl1MBDtdkV90RxK+aWoDawbUN/39l2rSVfxc13dDbUkOhZHDXrw52+ia7e/fwCpBiPMbDg0+GMvakHy+z6Y+XTigZSQKqm568B5eWLLiuYiMw9bO3FUJkz1nnEH52k02LUVrlJ2H01HYn6CC/OkP8b6Jo18d0wcWBPb46gJVISaQK6cud9TOLx60xMFvaaWTBTT85IUKFVqTgRhQVQjHpScjb7ow0aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6DGObiAsVjGIIuVX7JDTE6b7UTLP37cJQv/J8ajf3M=;
 b=YLpG7g0XkReU++QfOzMEN+oKY5eabw8P+J5adW3tUPn+42suNJ8DYcD++qz1zjeW2ugLkwBrtoFepLgQJbQR5dJsVwhZo4nihgPxGeqLa/2o9GPEEsGJPPKFuHKClhZU+6VO8l6+TADVM5oeetqawbwZUdxT0ukV48rukSOKcGY=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 22:48:26 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 22:48:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Andy Duan <fugang.duan@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: LS1021A has a
 FIFO size of 16 words," failed to apply to 5.4-stable tree
Thread-Topic: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: LS1021A has a
 FIFO size of 16 words," failed to apply to 5.4-stable tree
Thread-Index: AQHWsezEOoIzEfoLKkKJJMHVEvkOMqm3AwaA
Date:   Tue, 3 Nov 2020 22:48:26 +0000
Message-ID: <20201103224825.gxvly2qijdr2hmsk@skbuf>
References: <160441340011200@kroah.com>
In-Reply-To: <160441340011200@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cbb6a4a5-1ce0-40fc-bf02-08d8804a93cf
x-ms-traffictypediagnostic: VI1PR04MB4688:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4688CF46470325AEFCC7CCCEE0110@VI1PR04MB4688.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U5PQZQAT8Aqt3KhepgCXeffz7IWNJFSw81mMfGoeXRtLJs+QVilVMaArTibKJ/E2n8TuU87EgSN/VtLg6Y0ioxQHz0ocbVM0A1hds+gB/2itOFRIG2TU8ISaMs19JXd3ATUyQFaXiFAKISvh6VuSQyo8Uf0RWsG64aEmd67wGF1Y8q36CdKoBuif5CfVdpEbZ128seZk2ku0gRqmou+rpRF1ehtNgtHv8eOA0moUIlJYroduB8TV5aTjr4yE8kKj7uMCAPYwfvZCLfuADMuIqbBFiZGnnd8Aj38FIZudPVJNhU+Gl77bPehaReSvX/XxukF4a9k1UptSu81CTnj1B4mejquVLuQ1GctzqCFk2u3BQ/c1w1yw16ErZFxZIVSikZmCTA0yXIvDlt4BhGmoeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(33716001)(8936002)(26005)(54906003)(44832011)(186003)(71200400001)(9686003)(4326008)(6512007)(316002)(6506007)(6916009)(2906002)(478600001)(1076003)(66476007)(66446008)(91956017)(64756008)(66556008)(66946007)(8676002)(6486002)(5660300002)(86362001)(76116006)(473944003)(414714003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: T2pUFr0vp8EqnMFyddnCPtWAI5faMWWVwSeqdrLHTlQXEf7l1fhFRCAYHQ3H55A7hTS0t4PZ4M8evCnXrRLgfzPzjc7KzU9W11+h0gL4mQn/yzSC3Ng42es4pl7xLQw4TOJYL0IPsKi783Q2blwmvp99fPC7ImHATc6WabzpaVXWQI4IoqDVgFnKyx+v3oBiU9Kk2GUI54yealIp8yFNFeLF1UdcwmyTw6iX/CO1P5Im3ktd0lKgwYodeTWwvPUYerWdJ0Mt6+p77oftIb+kQBjmpi4jxsaEU2eLVe1TpBDE63FT3j+Vv+a1FQrHt/raZlsds2d+YYDeFEn6MgudEd1NOwUe/o1CI5QAS/JL2rNuvgOnhuUFMION0DH5AR+ZRy2RUI3nDvvVz3IUC99Ee1Q4jZHiUtMCTXAS7BmDMO2HhEldFvpKxd1D1RLNOVVkgWjDBAKPnC26bIDVKQ5aXbWNxCvwM+8eAEjMudfGp6IHYFp3eczv/Ga/G/SVp+IBewunGBk8Lz1HgwG22nKjmw2cs6jHlkfkScWkqnahgo5/v9aGyByX94/U6vVljHdOpcBa+gk01IpAn7DFNOEUZeNjqoqKb2gwnLSVFsfwFlrznqUB9fgNVD2NH923SAetomktqCRWf9jw2ZRQIwCxxg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1FACBE8AB867E84F890C5D32713988F3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb6a4a5-1ce0-40fc-bf02-08d8804a93cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 22:48:26.7716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: baPdfSVMHPCf848BcOcc7mGitN9kSgk9uyXTVsJajceGqOCiywLuNgnBekH+2cMwxJKWmXrgj8sx7YKuzOx1Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4688
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 03:23:20PM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Greg,

For linux-5.4.y, could you please do the following so that I don't need
to explicitly resend these to linux-stable?

# tty: serial: fsl_lpuart: add LS1028A support
git cherry-pick -xs c2f448cff22a7ed09281f02bde084b0ce3bc61ed # this is depe=
ndency
# tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like LS1028=
A
git cherry-pick -xs c97f2a6fb3dfbfbbc88edc8ea62ef2b944e18849 # this is the =
one that failed

Both sha1sums can be found in Linus' tree.

I have tested these 2 cherry-picks on top of linux-5.4.y on my board,
and it works just fine.

I was a bit concerned about backporting the LS1028A patch as a
dependency for my fix, but I have consulted
Documentation/process/stable-kernel-rules.rst and it says:

 - New device IDs and quirks are also accepted.

That patch also satisfies the following:

 - It must be obviously correct and tested. <- check
 - It cannot be bigger than 100 lines, with context. <- check

The patch does not apply because the fixes were discovered backwards.
LS1021A and LS1028A should be compatible with one another. However
when bringing up the LS1028A, Michael found the LPUART to be broken,
thought the LS1021A was working, and added the FIFO size quirk as a
LS1028A 'feature'.

Thanks,
-Vladimir=
