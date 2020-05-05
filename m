Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A0E1C4F5B
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 09:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgEEHnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 03:43:39 -0400
Received: from mail-eopbgr1410092.outbound.protection.outlook.com ([40.107.141.92]:15392
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728180AbgEEHni (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 03:43:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7Lus/H2KBJumRPVyaKERhzNKlr/v7AO6NDD7Fm/DN1kIHjs3sLiWx5UXcVsct4XYJQWNTHQYfThDWK4KiW14BG4tt0QTu2yS0koB/Vv3Kn8CF3Xi74PYIvcELPX+d4uiUDyRyx+KJ+MOOuDTikqfeoBEbx+6bg6eVTYCpBP2cB23787Oinb+0zfJ5lppqzwusd9QBLKbxDLEAvUvzsA0YcukkFHDK6RUbB6xeBEENFKni39Ws23baFS6JSRADOZHDYTueLXsLsboRHBy12S2uRsnnZZSFuTF8+uYaDQlSX43BhNeJ1b6QByzrGhXmI8BjPxDB5DCBKnsc0FnHkc3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rY39J9Ff9wePdlJ4GHmmD0rAbmsNE57YOGy890L9AI=;
 b=YJAFJseDZGZ5Nxy4n1fRJZOASnfLITAq4wSA/vQsytNeLnsYewHWQ5VzYXzCfqScAXqv+ajuSPzmXuOVAEkgi/2jyjzVq/4v4W0FP2Fx3FFIAhXRxNF4prtBzfbU2b8hqajwFh/Br+TNh3H6n8c/zznbYe5VgqrmSrdRNtSEdasJAUAVc7WufzozkTsAFpeazb6XSJUrY+VNBszI2LONPLqbRX5JC/Gq2guCsfmLyUrtQAtxbP68anb9ExqGbM8ZRcTOKs8vMmF2FqnfhWvFZ1auqI5nzUzABV/REkKfDyNC2JFlaHQONn7/StfuOCSceLZPIH71bIUUWzPvjGWawA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rY39J9Ff9wePdlJ4GHmmD0rAbmsNE57YOGy890L9AI=;
 b=pMZjqwoxVYY/1peiFD9KMfen6XbMhXV9/2As3PuDb61EYsX7S/nZjtoi7gtnWUdPxJ8COcyL535HbfbF6qTVs1mORAJBsYWY0luA1FqEyULD/CAVRfHO4lKN4xpxbkJ8EX11MtycEdvp7YERGjiCwTL+E0xq1bCoT2ZCcdeysPE=
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com (52.134.245.84) by
 OSAPR01MB4628.jpnprd01.prod.outlook.com (20.179.177.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Tue, 5 May 2020 07:43:34 +0000
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::2f:ca16:fa59:a37f]) by OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::2f:ca16:fa59:a37f%7]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 07:43:34 +0000
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
Subject: RE: [PATCH 4.4 00/18] 4.4.222-rc1 review
Thread-Topic: [PATCH 4.4 00/18] 4.4.222-rc1 review
Thread-Index: AQHWIkAco1fOGo7DzUifeVM/eZZh9qiZHOww
Date:   Tue, 5 May 2020 07:43:34 +0000
Message-ID: <OSAPR01MB238507AC7A6369701E00FC16B7A70@OSAPR01MB2385.jpnprd01.prod.outlook.com>
References: <20200504165441.533160703@linuxfoundation.org>
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=renesas.com;
x-originating-ip: [151.224.220.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 82ee4139-2e71-4bb6-f822-08d7f0c80400
x-ms-traffictypediagnostic: OSAPR01MB4628:
x-microsoft-antispam-prvs: <OSAPR01MB46288AC802022A5AB7BD3CC1B7A70@OSAPR01MB4628.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0394259C80
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uPAYuZPjJu25GA8ZIUgsbJQgmfAcqbi80l9C2ojFvrgeETiAHdPxnH5NuUo5FyhzuyG2xBGRwmfIS6aHqWBtGPXXn2Lqa5i8rGC2QJPOQUMFN1HpLgEx7Dg/nNAAVVpVxgiwjFpbZfGropAZ65+0Ep+hLXCf6PITWLHXIxj9Ocwmxw2D3ThP3acE6JEZ9+MsN6LMKSbmu+DjHBGxXUsrDpWoRuWpxYOX82VIJPK3v/tcwcga2UPULgySxHj8qGTwZAHv7fYAq1blMllLiFuMYAtIjhC5up44iXUlwJM1SuGOWY3+22/I0RiuftqP+Awz2asHPTNrWElJgUtIlOpbq1kMKrCbzi7yBo94Sx0wuWi4MWh/1MZYeOeViEAyk3rkKbGcg66Z8ter++7LMhG1KlnMW1Ulk+TUIl2+5quD4MVIt9pMyf5FdMzx9Df+lF0zAxT2WGwY0GI022SAbeAIhauiUNDAU5l5oQQHycALPtogj40nmP9k5+leVBGqscTO5sMG9B9xqCRRGpXxiCvJirldZ8Dvcrb9FJw2NLaYtd/hzDf5XrcRyxBDOdYYa6GEhFQ/cN/HuLWeOzkO3BqsB8s69d1HI7qMgPKcbgPE5uE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB2385.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(33430700001)(478600001)(966005)(54906003)(2906002)(110136005)(316002)(71200400001)(7696005)(7416002)(86362001)(52536014)(4326008)(5660300002)(8936002)(8676002)(186003)(26005)(66946007)(66476007)(6506007)(64756008)(66556008)(33656002)(55016002)(33440700001)(66446008)(76116006)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 71f/7jT/DZTGpqy9L7zAKcw4ku5xc1C5k7iA6ox2yV1dMQ71FM0Gp15nnz5QFxeEkPNtUpkmjaYFEE/dAvyKU50OhgSSAbAdt6r3d9WqUSvLr+hq730JL3sn0OJggx3Fs2QhgrDk65UBenZ+PrRzEibVFYN+0uZY9DtdNR1AlMbbw4LRDFoIwUWw4vhG0KUzXsC+sQTXpg7ERluv0vfwczcO8HAHowJOw+9Qx6dbJVQ8iBEE3cFo+/dxGykziAFhqOJZ5QLd9oswoaaNyi82Kg5XoAzmRayrKyPC4q1PZdPVX1cqtQOaoy9lk2/Nwl1FLNi7gMUUYo79ofSivOfRJ7sCpBv4bNM3FA+CC4dJpmSiGQ7EpKxHtTx1hvgtBNEVpgj5UeFmv/o/yJ+6YbDQZcFLizZ48PtYRsMXZTu9RQ9PCFmkA/4j7n1RSFUhPS5P/VjYB0Yz6NM6O1kPPHnXUJCGhhNKP0yGoUGm4FZzHT/IKVQ9LMTuA1OATxPOoksgdT5jG1zdPIa7ajLSgcNffKKx6an8RSV8cfbQyzqr0GWAFeRSXizWTdvpU2J4iO7PKTXowycBHvTpZMEI+B3xEqOcBkCKajsApdVEYDYOW6lvVWVcUED1ZMr+NQDpbhV6IjD0KvwNlZAThB7X7HR/fMy8Uy6KoCg08FP6RfWH2NYsctS0vvMKPEHZ9GUDS8KxKMaWlqRY881xvhp2TT17ftPLuZEr7oOdekVp2F+BRXgfInODtlOuilBn2fweqRR9QWXd6isO2Ui3AFkBFps0o9/czphZVCdrOVe+9Ha6k4U=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ee4139-2e71-4bb6-f822-08d7f0c80400
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2020 07:43:34.6093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SoZqJ69GzRHalfz44tAlsExKQsLbu2i40qX1klvSGehtO73Jdj82yojdTrYWOMuQPiRGtIKiN6hp0Jxrw4In59l9DFUmWwgP9dVdSQcRIwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4628
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 04 May 2020 18:57
>=20
> This is the start of the stable review cycle for the 4.4.222 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No build/boot issues seen for CIP configs for Linux 4.4.222-rc1 (2f51492532=
81).

Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-=
stable-rc-ci/pipelines/142506721
GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.4.y.yml
Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=3D=
25&search=3D2f5149#table

Kind regards, Chris

>=20
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-
> 4.4.222-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-4.4.y
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
>     Linux 4.4.222-rc1
>=20
> Paul Moore <paul@paul-moore.com>
>     selinux: properly handle multiple messages in selinux_netlink_send()
>=20
> Olivier Matz <olivier.matz@6wind.com>
>     ipv6: use READ_ONCE() for inet->hdrincl as in ipv4
>=20
> Lars-Peter Clausen <lars@metafoo.de>
>     ASoC: imx-spdif: Fix crash on suspend
>=20
> Stuart Henderson <stuart.henderson@cirrus.com>
>     ASoC: wm8960: Fix WM8960_SYSCLK_PLL mode
>=20
> Rasmus Villemoes <linux@rasmusvillemoes.dk>
>     exynos4-is: fix a format string bug
>=20
> Peter Zijlstra <peterz@infradead.org>
>     perf/x86: Fix uninitialized value usage
>=20
> Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
>     powerpc/perf: Remove PPMU_HAS_SSLOT flag for Power8
>=20
> Jiri Olsa <jolsa@kernel.org>
>     perf hists: Fix HISTC_MEM_DCACHELINE width setting
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     i2c: designware-pci: use IRQF_COND_SUSPEND flag
>=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     dmaengine: dmatest: Fix iteration non-stop logic
>=20
> Andreas Gruenbacher <agruenba@redhat.com>
>     nfs: Fix potential posix_acl refcnt leak in nfs3_set_acl
>=20
> Arnd Bergmann <arnd@arndb.de>
>     ALSA: opti9xx: shut up gcc-10 range warning
>=20
> Sean Christopherson <sean.j.christopherson@intel.com>
>     vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()
>=20
> Alaa Hleihel <alaa@mellanox.com>
>     RDMA/mlx4: Initialize ib_spec on the stack
>=20
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     PM: ACPI: Output correct message on target power state
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: pcm: oss: Place the plugin buffer overflow checks correctly
>=20
> Vasily Averin <vvs@virtuozzo.com>
>     drm/qxl: qxl_release leak in qxl_hw_surface_alloc()
>=20
> Theodore Ts'o <tytso@mit.edu>
>     ext4: fix special inode number checks in __ext4_iget()
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                                           |  4 +-
>  arch/powerpc/perf/power8-pmu.c                     |  2 +-
>  arch/x86/kernel/cpu/perf_event_intel.c             |  3 +-
>  drivers/acpi/device_pm.c                           |  4 +-
>  drivers/dma/dmatest.c                              |  4 +-
>  drivers/gpu/drm/qxl/qxl_cmd.c                      |  5 +-
>  drivers/i2c/busses/i2c-designware-core.c           |  3 +-
>  drivers/infiniband/hw/mlx4/main.c                  |  3 +-
>  drivers/media/platform/exynos4-is/fimc-isp-video.c |  4 +-
>  drivers/vfio/vfio_iommu_type1.c                    |  4 +-
>  fs/ext4/inode.c                                    |  2 +-
>  fs/nfs/nfs3acl.c                                   | 22 ++++---
>  net/ipv6/raw.c                                     | 12 +++-
>  security/selinux/hooks.c                           | 69 ++++++++++++++--=
------
>  sound/core/oss/pcm_plugin.c                        | 20 ++++---
>  sound/isa/opti9xx/miro.c                           |  9 ++-
>  sound/isa/opti9xx/opti92x-ad1848.c                 |  9 ++-
>  sound/soc/codecs/wm8960.c                          | 32 +++++-----
>  sound/soc/fsl/imx-spdif.c                          |  2 -
>  tools/perf/util/hist.c                             |  2 +
>  20 files changed, 134 insertions(+), 81 deletions(-)
>=20

