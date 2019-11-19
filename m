Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DA6102728
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 15:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfKSOoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 09:44:18 -0500
Received: from mail-eopbgr1400117.outbound.protection.outlook.com ([40.107.140.117]:2266
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbfKSOoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 09:44:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LM4cpdckePYjpw3QlPctEjQRQjrpJlbZKhmTDmM44+6KBBC6o81ddhdT7wrQzIAFO8Ml43ne6NeBkC4DNCXwF8DxPpQXtyIHygTL6Rv5kYcrkuLwVM4NQWAE1R5wu+hV/vCoMpu5YbfbarjEFZA2ZJpBYP2kgjAyfQTgVWiSTS2gbZ9mgM0EkEk5tmKEBRv/RQrCIwPC+cFr+CsmR1krhO3E2A0zzOQFxz0rx1qAcWYtAz98fA3+XjMEr0CNp0bw+F8rr5iUGvzKq35JetMpyLE778dLT2blUzLIHPSYtuBIakRPExkitNprqqxmI76KKa480qz9XNr6rfoqVuYS4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FTq80Y8mYoX1R+ga0fOw33+kMMMtDIKnlE0uNc1+4k=;
 b=iPUyrCWPVouGJgaplbPKUFgw3ei5sqrgG0GRVP4IiBVxlbenmL7jO1ts9Ff46T+I2wPiT4l8Na5tY3ZkO8AHagHsXjXRM2HvXA6jkmDD9Cw5wbiiaaUMOU2OHphmbhKqO8EHvF1X3hpxsLd26uywA5E8LHhhd87ZpwEr8B2BCL4FRha6OxXsc64Ll1YrAAeIH9ITmNoZo5EtjuLgWynM1CtvM1xAVF1taf1Wg7aLL2VEUcgYM5diIX1VAO24NOAdcc8x9WM3A1jySeyuUZ+F/jeM939cwpQrQqtA39lEYFjKkjYX81ccmFoeEDhUMzALjc8NrfJMETVFUdTDhBePdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FTq80Y8mYoX1R+ga0fOw33+kMMMtDIKnlE0uNc1+4k=;
 b=GcHGz8VbecEnaLPDrI04yd4SR2Wua4cs4uY/lDBSkUOlooUoAMbb1iuQVKNXzUJpsDPzDVxhVevOrPqeSzmGb4EdnC+djRzHl6D1zgFdutcYCWN0ejH3KV/w3+0/7l2uV8g6/gTWmXNrjittlCt1QH4xsWoU0PefD6PJBnLV9BY=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB4317.jpnprd01.prod.outlook.com (20.179.173.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 19 Nov 2019 14:44:13 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5b9:ce3e:e658:5b75]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5b9:ce3e:e658:5b75%7]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 14:44:13 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 4.19 000/422] 4.19.85-stable review
Thread-Topic: [PATCH 4.19 000/422] 4.19.85-stable review
Thread-Index: AQHVnpmkB8jYWSq0hUGT+a8kwF1jMaeSLOoAgAA/xICAABmSgA==
Date:   Tue, 19 Nov 2019 14:44:12 +0000
Message-ID: <TYAPR01MB228560FC98FFD1D449FA4EC2B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <TYAPR01MB22854E4F20C28F3A10DA65E3B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119122909.GC1913916@kroah.com>
In-Reply-To: <20191119122909.GC1913916@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: db3e5c5e-7001-4acd-2e97-08d76cfef1cd
x-ms-traffictypediagnostic: TYAPR01MB4317:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <TYAPR01MB4317B8635B2C6A7BDC2039F7B74C0@TYAPR01MB4317.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(189003)(199004)(99286004)(3846002)(6116002)(7736002)(305945005)(76116006)(74316002)(6916009)(71200400001)(66066001)(316002)(54906003)(7416002)(86362001)(52536014)(14454004)(26005)(25786009)(6246003)(478600001)(486006)(966005)(33656002)(256004)(229853002)(4326008)(8936002)(81166006)(66476007)(66556008)(6306002)(66446008)(64756008)(66946007)(71190400001)(81156014)(6436002)(476003)(7696005)(11346002)(5660300002)(8676002)(55016002)(446003)(6506007)(2906002)(186003)(9686003)(102836004)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB4317;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7bPtI2xceE0zLge1jtoMIf7CQ6pJwVL0tWGs2UM1Y8NYjMVK5ZEA9u4tAoqsPV+V9gChyeWrUT0yE0++otYr2dj+rumas6sESfmaPHfRpcdBjIoZ82z4zh3PEHLCXbEKC1Cc+RkRO6XA4x9rzYcvKsXyHkD9Jx1QoOpLQ9ZCCwjiCkb/uANP8TsA/APvvI2Xf/4/FDQS3Gdbih4NpFjlm7ztYZfo5By0XcW2Q+/gnPKCRno/tD7Qp15hQE4T6zQVDCIlPjJpkXh7uBc3wLbndD9ZM3k+T+rhtC/XPDtBzSz8neFaQgtW+KPJuy8K+BAteHTexATXmEeNR763+4/AmtYC3DNJ4AgnIWrm9Gz6QROWe8THZXZ3iuO6GwxA1Uox+clEUM86SVZbUsWB+zII+Adk4gWktp7alkKqziM6MGwdjSP9yIxax3x7ulv4IhvO5sdNCJXHgttcJhknrWm+3n3+vU5IIauzN/iGrHYKvnc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3e5c5e-7001-4acd-2e97-08d76cfef1cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 14:44:12.8674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W4xYcYD8gBCFFinlmM/Kbf2+6uOk6c7KjXnr6bifL+FUKILTMOW/hLOXVv+oX+XdWOUbXtfj7rN3G++d2e17TOsXD/lV+Jp5Un46157SVhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4317
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 19 November 2019 12:29
>=20
> On Tue, Nov 19, 2019 at 08:54:25AM +0000, Chris Paterson wrote:
> > Hello Greg, all,
> >
> > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > > Behalf Of Greg Kroah-Hartman
> > > Sent: 19 November 2019 05:13
> > >
> > > This is the start of the stable review cycle for the 4.19.85 release.
> > > There are 422 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >
> > I'm seeing some build issues with module compilation with this release
> (1b1960cc Linux 4.19.85-rc1), I also saw them with the previous two versi=
ons of
> Linux 4.19.85-rc1 (cd21ecdb and 1fd0ac64).
> >
> > Full log available on GitLab [0]. Build conf [1].
> > [0] https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/3545912=
85
> > [1] https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> /jobs/354591285/artifacts/file/output/4.19.85-
> rc1_1b1960cc7/x86/siemens_iot2000.config/config/.config
> >
> > Main error below:
> >
> > 3907   CC [M]  drivers/net/ethernet/mellanox/mlx4/main.o
> > 3908   LD [M]  fs/ntfs/ntfs.o
> > 3909   CC [M]  drivers/net/ethernet/intel/i40evf/i40e_txrx.o
> > 3910   CC [M]  drivers/usb/musb/musb_core.o
> > 3911   CC [M]  drivers/net/ethernet/nvidia/forcedeth.o
> > 3912   CC [M]  fs/udf/balloc.o
> > 3913   CC [M]  drivers/net/ethernet/intel/fm10k/fm10k_debugfs.o
> > 3914   CC [M]  fs/udf/dir.o
> > 3915   CC [M]  drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.o
> > 3916   CC [M]  drivers/net/ethernet/intel/i40e/i40e_ptp.o
> > 3917 drivers/net/ethernet/mellanox/mlx4/main.c: In function 'mlx4_init_=
one':
> > 3918 drivers/net/ethernet/mellanox/mlx4/main.c:3985:2: error: implicit
> declaration of function 'devlink_reload_enable'; did you mean
> 'devlink_region_create'? [-Werror=3Dimplicit-function-declaration]
> > 3919   devlink_reload_enable(devlink);
> > 3920   ^~~~~~~~~~~~~~~~~~~~~
> > 3921   devlink_region_create
> > 3922   CC [M]  drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.o
> > 3923 drivers/net/ethernet/mellanox/mlx4/main.c: In function
> 'mlx4_remove_one':
> > 3924 drivers/net/ethernet/mellanox/mlx4/main.c:4097:2: error: implicit
> declaration of function 'devlink_reload_disable'; did you mean
> 'devlink_region_destroy'? [-Werror=3Dimplicit-function-declaration]
> > 3925   devlink_reload_disable(devlink);
> > 3926   ^~~~~~~~~~~~~~~~~~~~~~
> > 3927   devlink_region_destroy
> > 3928   CC [M]  drivers/net/ethernet/packetengines/hamachi.o
> > 3929   CC [M]  fs/udf/file.o
> > 3930   LD [M]  drivers/net/ethernet/intel/fm10k/fm10k.o
> >
> > I haven't tried to trace the issue further yet, sorry.
>=20
> Any chance you can bisect this?  I don't see any obvious reason why this
> error should be happening, and it isn't showing up here :(

Looking through the commit history, the issue seems to be related to:
672cf82122be ("devlink: disallow reload operation during device cleanup")

I've reverted this commit and Linux 4.19.85-rc2 (af1bb7db before revert) wi=
ll build with the configuration I'm using [2].
I haven't looked further yet though, sorry.

[2] https://gitlab.com/cip-project/cip-kernel/cip-kernel-config/raw/master/=
4.19.y-cip/x86/siemens_iot2000.config

Kind regards, Chris

>=20
> thanks,
>=20
> greg k-h
