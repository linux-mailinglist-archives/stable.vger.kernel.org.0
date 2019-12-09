Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B2F1171E3
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 17:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfLIQet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 11:34:49 -0500
Received: from mail-eopbgr1400138.outbound.protection.outlook.com ([40.107.140.138]:1055
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbfLIQes (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 11:34:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqvlyKMHLREEQLEXZm/0xG7PXchCIdJUzQs7ZA8PkXkODD35XRK5y8zlFwiACi4wFXJH+8ZKr2C2tjNhXINg/l1s1Z/v2j1lqsCJ3513X6RVhOmRbEOMF6ZGzj6VvuD/CdqtKF2xp5YxOO906iAT6k8PmlZJKnbhsq7ROaURYOLZIlxJsmbrCFVTwTpXEPnqhnfAm5towkkDgNUcfCKXNtQrUwsUU0AS8adjiGrPJXtUnECw7jWtw/Wu9kJMKiZ4Zx0MLECf+JWeF9uIKpD9HRr5PWbRvoJaUE2UY5CUEpPL3FfpBf9aYV5cLu9UnYQLX+gP5NyOvCrbuuixdj+RcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hMfNGPF4+9viuzpl0N9VUz0bHM7osNZaKiw3qqUsFU=;
 b=bC3Fo8DTm24WRQNfSN+OuG/CGEiYp4GAD0m8tjVQkFevIiFzlc+sw5y3zykS51sy7Fk+cbzrEXnzo1/6mzp3H5nh7AlGZBMI1ICdmO27I4g1H+yTkGw4tdHdPnLxlNaLlr5p8tk+kPDbtAxKHcmwo+Ojyegqm8sVW+soBVVJioGDiJ3ed4n3txLg2WoG9YiOFdS6R0/8EguWhivHbBKGYG+UkOzWpM2mX8/cYgIAVPwbdhH7kAJxI9H4wJUO7HNIWlFkYHKdykixsKo+ytZp3VlQ4FXQPY+Ta/VtvU167RNUO5cKftXiCXJ42tXdGTzRttAhVC9rkVM/MwegMVaI8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hMfNGPF4+9viuzpl0N9VUz0bHM7osNZaKiw3qqUsFU=;
 b=X2fbfLW65p6PvxcoF/j7l5a6wZkRJRxTZdsfVN50DWPFeWnlJrONyL/iB7013qmrSRn6wrim4aKW/h9YmHLjVO8T5aw7HM3flf8YOrDXC6UWLJvWYEnNUs5X6295jHxvhEq0PcGCrGjZ8yyPTQZucUe3cz7R559VH05s4QYpL/Q=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB4574.jpnprd01.prod.outlook.com (20.179.174.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.16; Mon, 9 Dec 2019 16:34:45 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 16:34:45 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: RE: Linux 4.19.89-rc1 5944fcdd errors
Thread-Topic: Linux 4.19.89-rc1 5944fcdd errors
Thread-Index: AdWuq27YYqoiVr7aSmCEQeiV9xd6BQAAwtnA
Date:   Mon, 9 Dec 2019 16:34:45 +0000
Message-ID: <TYAPR01MB22851FBD29EBB28CDEA502CAB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 76ccee13-fe0c-484e-e047-08d77cc5b35c
x-ms-traffictypediagnostic: TYAPR01MB4574:
x-microsoft-antispam-prvs: <TYAPR01MB45742489FD45DB4E474F6D57B7580@TYAPR01MB4574.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(189003)(199004)(2940100002)(186003)(55016002)(8936002)(52536014)(4326008)(81156014)(81166006)(9686003)(26005)(8676002)(71190400001)(54906003)(7696005)(6506007)(33656002)(71200400001)(86362001)(66446008)(64756008)(66946007)(76116006)(66476007)(229853002)(6916009)(316002)(966005)(478600001)(2906002)(305945005)(66556008)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB4574;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iSswHnnFfazIX4mbyue668HsL+U661T921YgdO36VHs0A3IA73pUvexgUUf72FsLUJcF8IWnwVlNkOq/aEZvr87M+VdlaPWKJNlldU6HvDgTg+ikqS6k3uj0zo6LharnBI2fFuxnax0eL1F0VO74zDFpgpdNH+CO/b60XSAOksV9HzeZUyh4OsOqZzmbj8XwzErdClpetQ+TbzMFObaiQnuiXctA0WxQgIZX3JJbonCEEBaL9dzZA2Zr38Wk0b1yVkLKnpQNFNJXyS+pe9GTr9DH0kR/e7btVLwrxdB5JQquJdjJ6XWUBAOU+Sg4huFxU1vWys8MPD/d9gEwHaOXcuyjuLrShkbspZs9HiOIjnTreHVtzZ7FHT7na0etXBYKjHalt9/WXL+3bi2Hd7XozHb0RsuQSB4/y/2WmZpe511dzko2k3LNpa06hw3ERXxh2v+OM4dj5rLwocQjjLLHx+1F4QStNXC3NQLvYHb2zHc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ccee13-fe0c-484e-e047-08d77cc5b35c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 16:34:45.4335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F8dMGHXrnfIkgAsqILBzElH0QdrZ1lA4Kzs+VYmj2ioFNGBgTcScCMzDQowBweXPDwa/08fHkweI8nMaFFGU1uvKU/sA8cHzLLiLFuNV5RA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4574
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+cip-dev

Chris

> From: Chris Paterson
> Sent: 09 December 2019 16:29
>=20
> Hello Greg, all,
>=20
> I've seen a few errors with 4.19.89-rc1 (5944fcdd).
>=20
> 1)
> Config: arm64 defconfig
> Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> /jobs/373484093#L267
> Probable culprit: 227b635dcae6 ("bpf, arm64: fix getting subprog addr fro=
m
> aux for calls")
> Issue log:
> 267 arch/arm64/net/bpf_jit_comp.c: In function 'build_insn':
> 268 arch/arm64/net/bpf_jit_comp.c:633:9: error: implicit declaration of
> function 'bpf_jit_get_func_addr'; did you mean 'bpf_jit_binary_hdr'? [-
> Werror=3Dimplicit-function-declaration]
> 269    ret =3D bpf_jit_get_func_addr(ctx->prog, insn, extra_pass,
> 270          ^~~~~~~~~~~~~~~~~~~~~
> 271          bpf_jit_binary_hdr
>=20
>=20
> 2)
> Config: arm multi_v7_defconfig
> Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> /jobs/373484091#L2147
> Probable culprit: 192929fd944d ("dmaengine: xilinx_dma: Fix 64-bit simple
> CDMA transfer")
> Issue log:
> 2147 drivers/dma/xilinx/xilinx_dma.c: In function
> 'xilinx_cdma_start_transfer':
> 2148 drivers/dma/xilinx/xilinx_dma.c:1252:9: error: implicit declaration =
of
> function 'xilinx_prep_dma_addr_t'; did you mean 'xilinx_dma_start'? [-
> Werror=3Dimplicit-function-declaration]
> 2149          xilinx_prep_dma_addr_t(hw->src_addr));
> 2150          ^~~~~~~~~~~~~~~~~~~~~~
> 2151          xilinx_dma_start
>=20
>=20
> 3)
> Config: arm shmobile_defconfig
> Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> /jobs/373484089#L2249
> Probable culprit: 984d7a8bff57 ("pinctrl: sh-pfc: r8a7792: Fix VIN versio=
ned
> groups")
> Issue log:
> 2249 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro
> "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> 2250   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> 2251                                       ^
> 2252 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error:
> 'VIN_DATA_PIN_GROUP' undeclared here (not in a function); did you mean
> 'PIN_MAP_TYPE_MUX_GROUP'?
> 2253   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> 2254   ^~~~~~~~~~~~~~~~~~
> 2255   PIN_MAP_TYPE_MUX_GROUP
> 2256 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro
> "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> 2257   VIN_DATA_PIN_GROUP(vin1_data, 20, _b),
> 2258                                       ^
> 2259 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro
> "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> 2260   VIN_DATA_PIN_GROUP(vin1_data, 16, _b),
> 2261                                       ^
>=20
>=20
> Kind regards, Chris

