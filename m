Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730E7102D22
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 21:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKSUBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 15:01:09 -0500
Received: from mail-eopbgr1410104.outbound.protection.outlook.com ([40.107.141.104]:9024
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726711AbfKSUBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 15:01:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S550J9t0+qXU16zPcF7EKIeo89UHr0G2060QCbJfXxCtr/MelJEKa65OwMdtK1gjC8OZ1135TUfWIn6oKAQloOq6q3iT4KSiGxIGAGApxTV/tsIqFnpwrvGzJLuxh4y8bZpZzBmRfthglIS9WGWrwZF8DB0qPpM8noERfFRDdVfdaWCawnx0AIo3niqefeN8+vBzkGzDT/CQcKQDxZRTZiRs0lLwo2ge+huxGSQlf5GShlF90rWjfQ1+MdmTWgGgu7UM6lbm2eFe1Mm/58MFPr8WgZxg3E6NxjyZe2Qp3oDrOi7B2xQjxbJV3pqdLC+u+hZP5g3TASYQDK0XSZdyZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6V6CU8qX5gHwBYk9DotYCQf4V1KlLmLTD4OFjGE2jE=;
 b=FI2qRiOWrcKoGAoMk/bQZuE47PzmHvy/JKBVA0jmSLLaqcgaalzvg9iwNeYpFoQaIeoa71Fm/EtzeYRlke1T1JkB2RXjHoC/0MZb5ZR0PEm1Ss2yKA6g96WUPEV3GBWIxyVJsuIn1f+v7SJpsAbv90gVrxwwo7gJeWdVjksSbtWvgEkXw29QiCFMdfDrNCxmEOZoYs2BDL3kleqwJCBKEGcNoIDEPHofaq6iIENZe76rUQEO8EoqUrU6fdA+mmvDJN7juQkugJF1uEQXAv5h2KSIhgNZFDGtNFOgHNWdfXej8B5zJ5sJ/lgzAT2UsZ8CamAg4VaLg4WS3wuRZNgshg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6V6CU8qX5gHwBYk9DotYCQf4V1KlLmLTD4OFjGE2jE=;
 b=dfL2Bgc3j/fioQBpppiax1FRURm4UxXtbWQu/1Ng4xOYLh1Qo6/ReiVPwG3SSi2rpbJLboX9WAorW0yBMlMBcA5i4GJz0LKjgYEP9DQPbxSUNUyLVcNtU23SHXD8YIqJqbn9GhQzRFM35jO55mK59VHZP8haNduAkcam5t1pluc=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB3695.jpnprd01.prod.outlook.com (20.178.136.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Tue, 19 Nov 2019 20:01:00 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5b9:ce3e:e658:5b75]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5b9:ce3e:e658:5b75%7]) with mapi id 15.20.2451.031; Tue, 19 Nov 2019
 20:00:59 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 4.19 000/422] 4.19.85-stable review
Thread-Topic: [PATCH 4.19 000/422] 4.19.85-stable review
Thread-Index: AQHVnpmkB8jYWSq0hUGT+a8kwF1jMaeSLOoAgAA/xICAABmSgIAAHiuAgAANKBCAAASUgIAAEvoAgAAEjICAAByioA==
Date:   Tue, 19 Nov 2019 20:00:59 +0000
Message-ID: <TYAPR01MB22851F2F6D26C0971588DD92B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <TYAPR01MB22854E4F20C28F3A10DA65E3B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119122909.GC1913916@kroah.com>
 <TYAPR01MB228560FC98FFD1D449FA4EC2B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119154839.GB1982025@kroah.com>
 <TYAPR01MB2285698B8E0F38B9EEF47128B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119165207.GA2071545@kroah.com> <20191119180002.GA17608@roeck-us.net>
 <20191119181619.GB2283647@kroah.com>
In-Reply-To: <20191119181619.GB2283647@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea81c119-30d7-4a95-97b0-08d76d2b32c4
x-ms-traffictypediagnostic: TYAPR01MB3695:
x-microsoft-antispam-prvs: <TYAPR01MB369591B2EF9D29F8EC949BA7B74C0@TYAPR01MB3695.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(199004)(189003)(446003)(25786009)(76176011)(8676002)(52536014)(966005)(81156014)(5660300002)(6436002)(99286004)(102836004)(66446008)(4326008)(66476007)(76116006)(66066001)(66556008)(33656002)(6116002)(14454004)(3846002)(6506007)(66946007)(26005)(316002)(8936002)(110136005)(54906003)(186003)(86362001)(7736002)(6246003)(305945005)(229853002)(74316002)(81166006)(7416002)(11346002)(7696005)(9686003)(55016002)(486006)(71190400001)(476003)(256004)(71200400001)(478600001)(64756008)(2906002)(6306002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3695;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YOwPFg9+8LdKFzR55BX5Z7epFt1DKyswUwkUv1QfWplWInquapKhhAJ351NPVKH3+6puXsv901FFw5/Yp/vkQaOpE/Fqs5XPUmyf/Uy+Vp3f93TaBt4AK3iiZQcxFMUeGHIo8PKuAo7NVZIMyXDbSPzV+DxsIuCdQmXYKwddrXrnw3EaJcQ/toQsgXiNVdF/z7eJmX44KplB+6Ub08GJBrgl75B4Lf8LTeN5iRM+s6U6Pe2WTzo56eNNvChkxuOl4mx3vylndtiR4Q8gNxJDRWyeR9aegkdBIaBCz+e3uX66+wBvtpBk3T1mQNayGexmw3VQd9or6luj6c84Q9u6VQlhtaY2BAd/mqUyjLi35ZP0y03FHzE88jsurpr9rElkykH12ZUX5OGObvmsIeJnQlhVxYhaEfyRT5x9O8KtI+Hj6gNqMHBzKxvg8R3tF0WN
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea81c119-30d7-4a95-97b0-08d76d2b32c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 20:00:59.7761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fstuStiu/nHU6k0IOF/16QPeu6KnrKrmHov7glP9w33IIgn5SEHNMBctCJHST0kvsOx+FBr99WIUd8sHPvuL5WwXI+NBmbMzcUC2Xr3oRqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3695
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 19 November 2019 18:16
>=20
> On Tue, Nov 19, 2019 at 10:00:02AM -0800, Guenter Roeck wrote:
> > On Tue, Nov 19, 2019 at 05:52:07PM +0100, Greg Kroah-Hartman wrote:
> > > On Tue, Nov 19, 2019 at 04:38:06PM +0000, Chris Paterson wrote:
> > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Sent: 19 November 2019 15:49
> > > > >
> > > > > On Tue, Nov 19, 2019 at 02:44:12PM +0000, Chris Paterson wrote:
> > > > > > Hi Greg,
> > > > > >
> > > > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > > Sent: 19 November 2019 12:29
> > > > > > >
> > > > > > > On Tue, Nov 19, 2019 at 08:54:25AM +0000, Chris Paterson wrot=
e:
> > > > > > > > Hello Greg, all,
> > > > > > > >
> > > > > > > > > From: stable-owner@vger.kernel.org <stable-
> owner@vger.kernel.org>
> > > > > On
> > > > > > > > > Behalf Of Greg Kroah-Hartman
> > > > > > > > > Sent: 19 November 2019 05:13
> > > > > > > > >
> > > > > > > > > This is the start of the stable review cycle for the 4.19=
.85 release.
> > > > > > > > > There are 422 patches in this series, all will be posted =
as a
> response
> > > > > > > > > to this one.  If anyone has any issues with these being a=
pplied,
> please
> > > > > > > > > let me know.
> > > > > > > >
> > > > > > > > I'm seeing some build issues with module compilation with t=
his
> release
> > > > > > > (1b1960cc Linux 4.19.85-rc1), I also saw them with the previo=
us two
> versions
> > > > > of
> > > > > > > Linux 4.19.85-rc1 (cd21ecdb and 1fd0ac64).
> > > > > > > >
> > > > > > > > Full log available on GitLab [0]. Build conf [1].
> > > > > > > > [0] https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> /jobs/354591285
> > > > > > > > [1] https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> > > > > > > /jobs/354591285/artifacts/file/output/4.19.85-
> > > > > > > rc1_1b1960cc7/x86/siemens_iot2000.config/config/.config
> > > > > > > >
> > > > > > > > Main error below:
> > > > > > > >
> > > > > > > > 3907   CC [M]  drivers/net/ethernet/mellanox/mlx4/main.o
> > > > > > > > 3908   LD [M]  fs/ntfs/ntfs.o
> > > > > > > > 3909   CC [M]  drivers/net/ethernet/intel/i40evf/i40e_txrx.=
o
> > > > > > > > 3910   CC [M]  drivers/usb/musb/musb_core.o
> > > > > > > > 3911   CC [M]  drivers/net/ethernet/nvidia/forcedeth.o
> > > > > > > > 3912   CC [M]  fs/udf/balloc.o
> > > > > > > > 3913   CC [M]  drivers/net/ethernet/intel/fm10k/fm10k_debug=
fs.o
> > > > > > > > 3914   CC [M]  fs/udf/dir.o
> > > > > > > > 3915   CC [M]  drivers/net/ethernet/broadcom/bnx2x/bnx2x_vf=
pf.o
> > > > > > > > 3916   CC [M]  drivers/net/ethernet/intel/i40e/i40e_ptp.o
> > > > > > > > 3917 drivers/net/ethernet/mellanox/mlx4/main.c: In function
> > > > > 'mlx4_init_one':
> > > > > > > > 3918 drivers/net/ethernet/mellanox/mlx4/main.c:3985:2: erro=
r:
> implicit
> > > > > > > declaration of function 'devlink_reload_enable'; did you mean
> > > > > > > 'devlink_region_create'? [-Werror=3Dimplicit-function-declara=
tion]
> > > > > > > > 3919   devlink_reload_enable(devlink);
> > > > > > > > 3920   ^~~~~~~~~~~~~~~~~~~~~
> > > > > > > > 3921   devlink_region_create
> > > > > > > > 3922   CC [M]  drivers/net/ethernet/chelsio/cxgb4/cxgb4_cud=
bg.o
> > > > > > > > 3923 drivers/net/ethernet/mellanox/mlx4/main.c: In function
> > > > > > > 'mlx4_remove_one':
> > > > > > > > 3924 drivers/net/ethernet/mellanox/mlx4/main.c:4097:2: erro=
r:
> implicit
> > > > > > > declaration of function 'devlink_reload_disable'; did you mea=
n
> > > > > > > 'devlink_region_destroy'? [-Werror=3Dimplicit-function-declar=
ation]
> > > > > > > > 3925   devlink_reload_disable(devlink);
> > > > > > > > 3926   ^~~~~~~~~~~~~~~~~~~~~~
> > > > > > > > 3927   devlink_region_destroy
> > > > > > > > 3928   CC [M]  drivers/net/ethernet/packetengines/hamachi.o
> > > > > > > > 3929   CC [M]  fs/udf/file.o
> > > > > > > > 3930   LD [M]  drivers/net/ethernet/intel/fm10k/fm10k.o
> > > > > > > >
> > > > > > > > I haven't tried to trace the issue further yet, sorry.
> > > > > > >
> > > > > > > Any chance you can bisect this?  I don't see any obvious reas=
on why
> this
> > > > > > > error should be happening, and it isn't showing up here :(
> > > > > >
> > > > > > Looking through the commit history, the issue seems to be relat=
ed to:
> > > > > > 672cf82122be ("devlink: disallow reload operation during device
> cleanup")
> > > > > >
> > > > > > I've reverted this commit and Linux 4.19.85-rc2 (af1bb7db befor=
e
> revert) will
> > > > > build with the configuration I'm using [2].
> > > > > > I haven't looked further yet though, sorry.
> > > > > >
> > > > > > [2] https://gitlab.com/cip-project/cip-kernel/cip-kernel-
> > > > > config/raw/master/4.19.y-cip/x86/siemens_iot2000.config
> > > > >
> > > > > If you add:
> > > > > 	#include <net/devlink.h>
> > > > > to the top of drivers/net/ethernet/mellanox/mlx4/main.c, does it =
fix the
> > > > > issue for you?
> > > >
> > > > This is already defined:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-
> rc.git/tree/drivers/net/ethernet/mellanox/mlx4/main.c?h=3Dlinux-4.19.y#n4=
7
> > >
> > > Ah, ok, the issue is that CONFIG_NET_DEVLINK is not enabled, the driv=
er
> > > now requires this.  This was resolved by adding the dependancy to the
> > > driver itself, and then just punting and always enabling it over time=
.
> > >
> > > We can backport part of f6b19b354d50 ("net: devlink: select NET_DEVLI=
NK
> > > from drivers") if you want, but that feels messy.
> > >
> > > For now, if you enable that option, does it build for you?
> > >
> >
> > Selecting NET_DEVLINK manually fixes the problem, but at least for my p=
art
> > I was unable to find a means to define the dependency in the Kconfig fi=
le.
> > I either get a recursive dependency or unmet direct dependencies.
> >
> > FWIW, reverting the devlink patch fixes the compile problem.
>=20
> Ok, I've now done just that, and pushed out a -rc4.

Thanks Greg.

Linux 4.19.85-rc4 (824c9ada & d0112da1) works for me.

Kind regards, Chris

>=20
> thanks,
>=20
> greg k-h
