Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F224C102984
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 17:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfKSQiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 11:38:12 -0500
Received: from mail-eopbgr1410108.outbound.protection.outlook.com ([40.107.141.108]:47533
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727991AbfKSQiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 11:38:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMD+eYs2OhSlofTxDuX4O+hrIDaSZjPRJzah21pLc6fSCg7B2ziSZ2vXRMTYM8nQlBvl6RHyTmwb3VxlNSJVswJuGwVZANyJz8Crqx1XXLUJcN1aETrMY+xVsX/POX/j6DIAhXqOc72d03h/4ggn28rdVir5fleBZ1tB+wOZkfePlMXmJm0GSmJlNiINtOyRPSyJltjfhPbahnEn8m+VTqAAO6j/n5YzIhal0Rl6rFBvMFsfy0uTmyoQ9k/uFoCwA8dyAMyLSa2QIBzdaW7RopZuNzQk4ODDa4okh7tJ33PnLf/46mO6BTT27nEsPr+CKgjMOUBKQLgJX+g/VBl+Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PjOXXziMOEoJxoqkwu+GpTVrN6I0dwAqqpuzQsAaQgc=;
 b=jwXLIhDDcsEqMX8V/TAd7ZrtHnt8wORraKTP8BS1QrCB16r1VcZg1zC7b6YpMbJQUcNHWPjjbG3EMl6/5qICeWOTo+eDr9btCOGl7PyDLdQSaNWuyCOwJ0XGeMKpKYydUVTv4yxtdpvwPBITP9+QmaFzTuvl0jAC6AGqedQDo3TmVA2vJzfn3vJGvZ0twdpeUd7ea2/06pUX+yxlkFurKx3+JGe5IvuSqhMgzDtVZ44dUBB9Z9bOpTa/qUCHU2fVnYDcUHb57KnLNXJosImSklpexQNkCD8EFY7mevg09ZGMb6feygB0grLbGow2fgqknrw6e18vV+AsNFGnMihB8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PjOXXziMOEoJxoqkwu+GpTVrN6I0dwAqqpuzQsAaQgc=;
 b=ADQeBXalTlFdDYk5NuRbCfiSTpRD5p3gEtC6rdWWO8IuAafBak0quxw2B2kN6V06mA0sAouR0tULHWlKnlw5UfjD3Be10kHhEUBm3eDDhBkVAcemohka+4cDBjuKFuhTRkwnSnnjMP8zWlqfWg82/0Ts1EAHR4PtPIEu4vt3t74=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB3390.jpnprd01.prod.outlook.com (20.178.140.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Tue, 19 Nov 2019 16:38:07 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5b9:ce3e:e658:5b75]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5b9:ce3e:e658:5b75%7]) with mapi id 15.20.2451.031; Tue, 19 Nov 2019
 16:38:07 +0000
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
Thread-Index: AQHVnpmkB8jYWSq0hUGT+a8kwF1jMaeSLOoAgAA/xICAABmSgIAAHiuAgAANKBA=
Date:   Tue, 19 Nov 2019 16:38:06 +0000
Message-ID: <TYAPR01MB2285698B8E0F38B9EEF47128B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <TYAPR01MB22854E4F20C28F3A10DA65E3B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119122909.GC1913916@kroah.com>
 <TYAPR01MB228560FC98FFD1D449FA4EC2B74C0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191119154839.GB1982025@kroah.com>
In-Reply-To: <20191119154839.GB1982025@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7591ad84-3f49-4cc7-921f-08d76d0edb33
x-ms-traffictypediagnostic: TYAPR01MB3390:
x-ms-exchange-purlcount: 4
x-microsoft-antispam-prvs: <TYAPR01MB3390A8B187BCFDEB68D0BF85B74C0@TYAPR01MB3390.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(199004)(189003)(11346002)(6506007)(76176011)(4326008)(7696005)(26005)(478600001)(102836004)(66446008)(9686003)(5660300002)(6306002)(7416002)(186003)(25786009)(55016002)(14454004)(52536014)(76116006)(6436002)(486006)(7736002)(229853002)(86362001)(256004)(966005)(33656002)(66476007)(446003)(2906002)(6116002)(3846002)(476003)(81166006)(6916009)(8676002)(74316002)(81156014)(66066001)(66556008)(6246003)(99286004)(64756008)(66946007)(71200400001)(71190400001)(305945005)(8936002)(316002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3390;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rmb78PJrZAUI6xc8qZrvT94SdcbACNXcvssqunFrmULxyYiQudWxmFI/VhV3dDmvAe6Rh915LFrkH/2Rz1GxDFmGGZyGyc8lKg7qzg6UFVJXko+Lze2DO7izbGk4eOTAZBEX6YI2nviE4Dk1PQVrumAjkErw5Pa8eayCX/3hW8lV7+qCiCREIhdYTzf3wzGF9NRkAzff7Jz2WqRtqCSich4w6T/egbjMJlLXHW8NacemLr99ZAmzy0LhrmXdWIm50caVk6zMwWzOsN02PCrhcOF4U/y26hV6aFZn7YwF2HXI/xrozQR27E1OP4eIexFZk7uft1yrAupTj8tG6XovblEhSrC6ch/A+PUJad5fLsGw5NJAwsZlcGxjaAaFN9t6pdtGU2xM7jpkUn58qG0SdV0peBOXKOAaOAAOKYj7ggpciWxLNms3Ovgguz1ZCFcdXOciWyc3Dfye21d8lf9jgGnG0P1DT2A7BvLrUWbmOIw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7591ad84-3f49-4cc7-921f-08d76d0edb33
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 16:38:06.9015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ijsiyy37qE+s0FapHeVEbbxIlXgngZ+ru42jDj74nBZBA3+T4AQoGqfgLMZsfbDv3NDkcSPA/QkTfWDNdv/Ym7cid77g3DFXWiKUpU6huRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3390
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: 19 November 2019 15:49
>=20
> On Tue, Nov 19, 2019 at 02:44:12PM +0000, Chris Paterson wrote:
> > Hi Greg,
> >
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: 19 November 2019 12:29
> > >
> > > On Tue, Nov 19, 2019 at 08:54:25AM +0000, Chris Paterson wrote:
> > > > Hello Greg, all,
> > > >
> > > > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org>
> On
> > > > > Behalf Of Greg Kroah-Hartman
> > > > > Sent: 19 November 2019 05:13
> > > > >
> > > > > This is the start of the stable review cycle for the 4.19.85 rele=
ase.
> > > > > There are 422 patches in this series, all will be posted as a res=
ponse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > >
> > > > I'm seeing some build issues with module compilation with this rele=
ase
> > > (1b1960cc Linux 4.19.85-rc1), I also saw them with the previous two v=
ersions
> of
> > > Linux 4.19.85-rc1 (cd21ecdb and 1fd0ac64).
> > > >
> > > > Full log available on GitLab [0]. Build conf [1].
> > > > [0] https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/354=
591285
> > > > [1] https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> > > /jobs/354591285/artifacts/file/output/4.19.85-
> > > rc1_1b1960cc7/x86/siemens_iot2000.config/config/.config
> > > >
> > > > Main error below:
> > > >
> > > > 3907   CC [M]  drivers/net/ethernet/mellanox/mlx4/main.o
> > > > 3908   LD [M]  fs/ntfs/ntfs.o
> > > > 3909   CC [M]  drivers/net/ethernet/intel/i40evf/i40e_txrx.o
> > > > 3910   CC [M]  drivers/usb/musb/musb_core.o
> > > > 3911   CC [M]  drivers/net/ethernet/nvidia/forcedeth.o
> > > > 3912   CC [M]  fs/udf/balloc.o
> > > > 3913   CC [M]  drivers/net/ethernet/intel/fm10k/fm10k_debugfs.o
> > > > 3914   CC [M]  fs/udf/dir.o
> > > > 3915   CC [M]  drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.o
> > > > 3916   CC [M]  drivers/net/ethernet/intel/i40e/i40e_ptp.o
> > > > 3917 drivers/net/ethernet/mellanox/mlx4/main.c: In function
> 'mlx4_init_one':
> > > > 3918 drivers/net/ethernet/mellanox/mlx4/main.c:3985:2: error: impli=
cit
> > > declaration of function 'devlink_reload_enable'; did you mean
> > > 'devlink_region_create'? [-Werror=3Dimplicit-function-declaration]
> > > > 3919   devlink_reload_enable(devlink);
> > > > 3920   ^~~~~~~~~~~~~~~~~~~~~
> > > > 3921   devlink_region_create
> > > > 3922   CC [M]  drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.o
> > > > 3923 drivers/net/ethernet/mellanox/mlx4/main.c: In function
> > > 'mlx4_remove_one':
> > > > 3924 drivers/net/ethernet/mellanox/mlx4/main.c:4097:2: error: impli=
cit
> > > declaration of function 'devlink_reload_disable'; did you mean
> > > 'devlink_region_destroy'? [-Werror=3Dimplicit-function-declaration]
> > > > 3925   devlink_reload_disable(devlink);
> > > > 3926   ^~~~~~~~~~~~~~~~~~~~~~
> > > > 3927   devlink_region_destroy
> > > > 3928   CC [M]  drivers/net/ethernet/packetengines/hamachi.o
> > > > 3929   CC [M]  fs/udf/file.o
> > > > 3930   LD [M]  drivers/net/ethernet/intel/fm10k/fm10k.o
> > > >
> > > > I haven't tried to trace the issue further yet, sorry.
> > >
> > > Any chance you can bisect this?  I don't see any obvious reason why t=
his
> > > error should be happening, and it isn't showing up here :(
> >
> > Looking through the commit history, the issue seems to be related to:
> > 672cf82122be ("devlink: disallow reload operation during device cleanup=
")
> >
> > I've reverted this commit and Linux 4.19.85-rc2 (af1bb7db before revert=
) will
> build with the configuration I'm using [2].
> > I haven't looked further yet though, sorry.
> >
> > [2] https://gitlab.com/cip-project/cip-kernel/cip-kernel-
> config/raw/master/4.19.y-cip/x86/siemens_iot2000.config
>=20
> If you add:
> 	#include <net/devlink.h>
> to the top of drivers/net/ethernet/mellanox/mlx4/main.c, does it fix the
> issue for you?

This is already defined:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
tree/drivers/net/ethernet/mellanox/mlx4/main.c?h=3Dlinux-4.19.y#n47

Kind regards, Chris

>=20
> If so, I'll modify the file to have that, seems to be some sort of
> include file mess :(
>=20
> thanks,
>=20
> greg k-h
