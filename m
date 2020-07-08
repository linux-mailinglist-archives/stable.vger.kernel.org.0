Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7734218526
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 12:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgGHKkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 06:40:43 -0400
Received: from mail-eopbgr1410123.outbound.protection.outlook.com ([40.107.141.123]:55392
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728239AbgGHKkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 06:40:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1KJGlPXPPFOhP2lY6LF4W62uNM9xEsKi75HWpk1yO/4fvX/IgZ05GtyV5yCFmuQzI1BW06jLQDECLp/CXkLnvjgdzZZGrtTJsrrb4Wjyx3D6EydjFd5BWvGVm1ZoOH4/Lbg1KIVcZp0DVZM18kECmh5Xeq1fhmXKbNya5B7wC3qSRvn23r8IX+IE+XWPCHz2U5dV5HhUWbXm77NcHXFx7BdOlu7piK2ixF9z1eYsMvh8z2AppNwXPUtlA8qTxaE6nPHQ787cGfFntrtX7EOO1qYWMdYKD0LMw9jVKGnkVuuyMLLRlObOrzEDxnasWJfUTYbJde2L3hlLm2pKWXQKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCBXcS1ozvGLd50jTHOnRJ5IsxesFiQOxapmCSdr8n4=;
 b=VP4iay/EzEx3GJeI8dzOjTltC/GRTJOV8dr4bIugEWw9i/LeeQZM57ox18tgRKTxwoDDCdiWcfy4Se2zvwKtcoIjpuGVey7aSclEAe5ZaFUqa0PPYWGVjgiZ8mdSZS2ngcuTq6fRCt40o5uNBuMGS5WKUnHQ8kOl0gmDf2BZglOEx4tgsBYK0AM5xX1XK9Gub/UDRcZOcDFwF1UBGLaqk6mOP8AP8X1V9ITE+hv9DIO7dmjdQnHhqCZQVNRkkdyOC0wbemxdXiUIygMyqHw+OuXLCnnRgkWGvksOoJLbGZXmYtyAgVDcCF334Oum5W8l3NwYrScsuUpLBv+4+iQVKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCBXcS1ozvGLd50jTHOnRJ5IsxesFiQOxapmCSdr8n4=;
 b=al59kzpdREHNGEJgxNLJ1TUyLYyMa6Fy6JPWFZdvU8uAE3P4coAuGeu0tPeth7FaNXpLHW+9ShRj4Vw+Be6vqfo+l53DPoL++4ES7qBmG+WOqwLhHFiMiYUw5yBjCn4lPHYjEAuypgj1OPHioWicK0GUyWuZi1oht28U6ZXUIWc=
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com (2603:1096:603:37::20)
 by OSBPR01MB1750.jpnprd01.prod.outlook.com (2603:1096:603:8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.29; Wed, 8 Jul
 2020 10:40:37 +0000
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::c44c:5473:6b95:d9fd]) by OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::c44c:5473:6b95:d9fd%6]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 10:40:37 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 4.4 00/19] 4.4.230-rc1 review
Thread-Topic: [PATCH 4.4 00/19] 4.4.230-rc1 review
Thread-Index: AQHWVHDtLrvaTUhmS0W6WiMYCY/J1Kj9fuHA
Date:   Wed, 8 Jul 2020 10:40:37 +0000
Message-ID: <OSAPR01MB2385B29E646DF2E6CA438570B7670@OSAPR01MB2385.jpnprd01.prod.outlook.com>
References: <20200707145747.493710555@linuxfoundation.org>
In-Reply-To: <20200707145747.493710555@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=renesas.com;
x-originating-ip: [5.68.48.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8fcb24b8-6a3a-4350-a740-08d8232b5a53
x-ms-traffictypediagnostic: OSBPR01MB1750:
x-microsoft-antispam-prvs: <OSBPR01MB1750A6F124E26C97261ADB56B7670@OSBPR01MB1750.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JNZ8WtkHCGm3ljreuT4LBGNjr5KsbEMdRJfZGJBQ7T7opJscqFq0kFTjFcCiDEnpWA2Day4vrRu9e0bGQFv/h3jNN73miBaU1BFNE8kK6ETemudm0YvUh+mGJP/3HQMDnSy/81KZGDVnzizNxwFP1R8c+d8ooHNrmFi/JsjZzmxSOAE4NVikw6hIMY2/cLvh4EHnWq5cNGjBB/7ul1qVLPzi3YFPndjr945HbaC0DSF4bgeTbYc9g2ypD97ucV3cY0Nopaius/c94uusI8irFjeO8/uCbRXTS18fRL6kn7N4C9Bl7HMwCuh6dl8SsPwaOjice4SKxIHXMYGOD+gOu98Mlus13mnsIh9rt5OHTO0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB2385.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(53546011)(6506007)(7416002)(26005)(52536014)(55236004)(55016002)(186003)(71200400001)(66556008)(66946007)(76116006)(86362001)(83380400001)(64756008)(66476007)(66446008)(966005)(5660300002)(8936002)(4326008)(478600001)(8676002)(110136005)(7696005)(33656002)(316002)(9686003)(2906002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DrjDQUHhTtfM4E+Ptp992XDHbzpXh8APKvJ/UugTNoZaTxWWne2QroPZBOaTZMkyWqAYDUd7FpfsVPf5u0FFvgpu2NfsWowdaEsJQHN2G15MUbXaT45+bp/sf6r6769w0ca40Q9gd12mV0utJznOfdGug+oTjdN0PvUDNv6k9TIYnGgfhKU40ejn73WOas/S8zW5yl76vwLskL2T07OMmTY7rRcsyXCoLYy0Udw6MrR2MXsrgYgwm2bL4s1DtnDEIS9xmB8Dm1fVYz9tZNm4v4OKx2ZEJLJ7eLdbQPt89zdjtDAjy3d0Qxi1Y3fbH5qAMdg6OwPc6sOKrMa0lrNLPcr2nopieRCredqhoRI+sS0pOfwWF6A+CpxaBalqHmL5jDsi5cDGeX/TIzVKLyWwexgqLA3fw3G2LD3Mn4BCoa8J9/bp5sxfVub4h7R2LJ1Ztqg2ZE2Zme7CfnlODH39uP9FxmHoofXt0NAvToGlc30=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB2385.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fcb24b8-6a3a-4350-a740-08d8232b5a53
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 10:40:37.7600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dEPoJDe2gr+wcDFVyV+J7mgyQ3aT45YrLfkxKtAsApTfISrOJzScV412o9CiC+oyFCyr7jUlw+Jcq3O4VQDAuNGzmjOE3LoxIkREPohpRjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1750
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Kind regards, Chris

> -----Original Message-----
> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 07 July 2020 16:10
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; torvalds@linux-
> foundation.org; akpm@linux-foundation.org; linux@roeck-us.net;
> shuah@kernel.org; patches@kernelci.org; ben.hutchings@codethink.co.uk;
> lkft-triage@lists.linaro.org; stable@vger.kernel.org
> Subject: [PATCH 4.4 00/19] 4.4.230-rc1 review
>=20
> This is the start of the stable review cycle for the 4.4.230 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.

No build/boot issues seen for CIP configs with Linux 4.4.230-rc1 (c19eba6b3=
434).

Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-=
stable-rc-ci/-/pipelines/164002925
GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.4.y.yml
Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=3D=
25&search=3Dc19eba#table

Kind regards, Chris

>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-
> review/patch-4.4.230-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> rc.git linux-4.4.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.4.230-rc1
>=20
> Vasily Averin <vvs@virtuozzo.com>
>     netfilter: nf_conntrack_h323: lost .data_len definition for Q.931/ipv=
6
>=20
> Hauke Mehrtens <hauke@hauke-m.de>
>     MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>     cifs: Fix the target file was deleted when rename failed.
>=20
> Paul Aurich <paul@darkrain42.org>
>     SMB3: Honor persistent/resilient handle flags for multiuser mounts
>=20
> Paul Aurich <paul@darkrain42.org>
>     SMB3: Honor 'seal' flag for multiuser mounts
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Revert "ALSA: usb-audio: Improve frames size computation"
>=20
> Chris Packham <chris.packham@alliedtelesis.co.nz>
>     i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665
>=20
> Hou Tao <houtao1@huawei.com>
>     virtio-blk: free vblk-vqs in error path of virtblk_probe()
>=20
> Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>     hwmon: (acpi_power_meter) Fix potential memory leak in
> acpi_power_meter_add()
>=20
> Chu Lin <linchuyuan@google.com>
>     hwmon: (max6697) Make sure the OVERT mask is set correctly
>=20
> Shile Zhang <shile.zhang@nokia.com>
>     sched/rt: Show the 'sched_rr_timeslice' SCHED_RR timeslice tuning kno=
b in
> milliseconds
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock=
_sock()
>=20
> Douglas Anderson <dianders@chromium.org>
>     kgdb: Avoid suspicious RCU usage warning
>=20
> Zqiang <qiang.zhang@windriver.com>
>     usb: usbtest: fix missing kfree(dev->buf) in usbtest_disconnect
>=20
> Qian Cai <cai@lca.pw>
>     mm/slub: fix stack overruns with SLUB_STATS
>=20
> Borislav Petkov <bp@suse.de>
>     EDAC/amd64: Read back the scrub rate PCI register on F15h
>=20
> Hugh Dickins <hughd@google.com>
>     mm: fix swap cache node allocation mask
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix data block group relocation failure due to concurrent scru=
b
>=20
> Anand Jain <Anand.Jain@oracle.com>
>     btrfs: cow_file_range() num_bytes and disk_num_bytes are same
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                               |  4 ++--
>  arch/mips/kernel/traps.c               |  1 +
>  crypto/af_alg.c                        | 26 +++++++++-----------
>  crypto/algif_aead.c                    |  9 +++----
>  crypto/algif_hash.c                    |  9 +++----
>  crypto/algif_skcipher.c                |  9 +++----
>  drivers/block/virtio_blk.c             |  1 +
>  drivers/edac/amd64_edac.c              |  2 ++
>  drivers/hwmon/acpi_power_meter.c       |  4 +++-
>  drivers/hwmon/max6697.c                |  7 +++---
>  drivers/i2c/algos/i2c-algo-pca.c       |  3 ++-
>  drivers/usb/misc/usbtest.c             |  1 +
>  fs/btrfs/inode.c                       | 36 ++++++++++++++++++++--------
>  fs/cifs/connect.c                      |  3 +++
>  fs/cifs/inode.c                        | 10 ++++++--
>  include/crypto/if_alg.h                |  4 ++--
>  include/linux/sched/sysctl.h           |  1 +
>  kernel/debug/debug_core.c              |  4 ++++
>  kernel/sched/core.c                    |  5 ++--
>  kernel/sched/rt.c                      |  1 +
>  kernel/sysctl.c                        |  2 +-
>  mm/slub.c                              |  3 ++-
>  mm/swap_state.c                        |  3 ++-
>  net/netfilter/nf_conntrack_h323_main.c |  1 +
>  sound/usb/card.h                       |  4 ----
>  sound/usb/endpoint.c                   | 43 ++++------------------------=
------
>  sound/usb/endpoint.h                   |  1 -
>  sound/usb/pcm.c                        |  2 --
>  28 files changed, 95 insertions(+), 104 deletions(-)
>=20

