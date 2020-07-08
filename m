Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56BA21852D
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 12:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgGHKlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 06:41:39 -0400
Received: from mail-eopbgr1410092.outbound.protection.outlook.com ([40.107.141.92]:3616
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728346AbgGHKlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 06:41:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2XUlpHXKROb/ifSHE3Gw8x3/T9ah30xMz7LqurV/BHTw1h3VU1Zu392+VpiTKo4BvS68vvK/XMOacYozBQmng068ZISsv3D5rv7ySsEaSG7ibxBJNDXSFPymoPt7jfMAPQUHzCx/ucBaK8kKT1SPg1YvaTTUZGmMkKB5jGOdAZnx5ZMbdsx0Or6on3hGqSGHGq6yc6ANSjNGzjLIycHEvb/XZfWWZzffmU/xZP0qbXenV+52F9lgXYMKlzF0Whl4Cn5DZmmR5TKEglcoV9owmi1iZwApxvLSE9OtppAOsArZH6Yfu0paAorUOExacG8WUE8qO/VkZCs5WqmfJaWBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVSfXzLIZ+N0xxOLE5bbxUF5+co/YUJHkEGkSUopIVU=;
 b=hi0LWfoYk9C5ZrvOHY6ddW2st0YaaKQIHrYOyFiHpSjmxjjxX4od6z+QSior1H4zKCGeVOfy4WlAxd4GJZPXuGkeXALGJYVnpK99z2ixV4tauREyP54GL1/JF7tJQ32gNYdQqmqzBHqV6lS05Lg/Jjj69NsmPI6jAv4kbaOSAXEdMxbPvWiUFxMZbUOqQxc0rE8qQ1kt1McYTOO6Wp+LhNeYHutyU+YqomZ9XI9gCcctK3s7xyp4eiSRBtz5AsgFcpFez2EuN7+XrFH22VdowzAIf8U1XJH6Jl3Lyg8PCKqj35zeYFmiI4kGK7ijvlQ/60hf2D2cclMyme+NrNNYoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVSfXzLIZ+N0xxOLE5bbxUF5+co/YUJHkEGkSUopIVU=;
 b=jJ/rnnMucHP/c/lCyst0MS8PAe3d3wCW4TpSiPjqNXPyaXQocgfdBXlQ+gelxiT2GKl8DezYAWUXoVL+1M7IELwKYaP9Eu7x3+WACYtek544KBoxRRx7IUWsM6wMYU5DhphtsTxoPnlCtgD2CXeSfo9Ci7/doARv7UuFSJ4gxRA=
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com (2603:1096:603:37::20)
 by OSBPR01MB1750.jpnprd01.prod.outlook.com (2603:1096:603:8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.29; Wed, 8 Jul
 2020 10:41:35 +0000
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::c44c:5473:6b95:d9fd]) by OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::c44c:5473:6b95:d9fd%6]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 10:41:35 +0000
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
Subject: RE: [PATCH 4.19 00/36] 4.19.132-rc1 review
Thread-Topic: [PATCH 4.19 00/36] 4.19.132-rc1 review
Thread-Index: AQHWVHHiWyG8AtL2Nkaj1mj/4h8uAaj9fuVA
Date:   Wed, 8 Jul 2020 10:41:35 +0000
Message-ID: <OSAPR01MB238589153016EE2B686404A9B7670@OSAPR01MB2385.jpnprd01.prod.outlook.com>
References: <20200707145749.130272978@linuxfoundation.org>
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
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
x-ms-office365-filtering-correlation-id: 206044da-cd43-4691-54a0-08d8232b7c87
x-ms-traffictypediagnostic: OSBPR01MB1750:
x-microsoft-antispam-prvs: <OSBPR01MB1750FA3DA110E91D83824F33B7670@OSBPR01MB1750.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cbmDncMvjXT37nuMSV3lpd82ulGkjsKIk78PUbq4LyHZpWPydr61JxCEEAuBOuZ9SKWe2jn++dGNT/qLQ3JQgZh3rkhkZzoJu3e8SwKvJP9qVIWcLfSqX9S5v6+oOAIwYnRYArtVYGaKfxtGnbvF8seG009kJOdYqUlR1kFe/ASzPnO6jkWsjD2TuDMpCAjQlWyJa5mPo/pYyrLiAWMY3PBZ/9LJwq2Q4V12WtR6FIosrTpNw9a4V/AuV3mTtrnp9HtmGX9nOb1g48dgEjW0B3jICSOmHHhnBquTYXWIhWXgmrqmkn4TVdqPss3Dvoe58SaiQDesDKcHHLD50m9HLj+XXVURZl9B/02TtkyOMi4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB2385.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(6506007)(7416002)(26005)(52536014)(55236004)(55016002)(186003)(71200400001)(66556008)(66946007)(76116006)(86362001)(83380400001)(64756008)(66476007)(66446008)(966005)(5660300002)(8936002)(4326008)(478600001)(8676002)(110136005)(7696005)(33656002)(316002)(9686003)(2906002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: B2EgREOnbyEqPyUq4Jp4CtMOvfvrGXgRxze0qdbvyZiXuHBDg/HRUfPzXYqsJ/+tLbx+aMrqGc9jUuS2wCICQ1VyUh7tfqWngkqg86Ydu9IDLVhrBWI5dHO8EdbC8EKywqkr8vRvfsDIw/+Hre6fOxUDG1UQV02PyYqvMGlReuQViDjs+nG+p0rTBYTyxelk6zVXBms1la2Rs4WXu23EqIedtNbDrEhR/fvy/ylQIxBN+vI0VefNMXQzMUgjujEoKGTn2kLSvKppmMNfZWUxmWnCpUj+WzSHhAJVK2tRt9HDvVnCIQRLw3PtemgLnAqdDcHSvAsZMFeJpHshKEFpvgp49SDSvx/AnzK9U58dmuA4UebNCEv+8ZY7nv6Mr2QUQELEBhN5thkuzMdgA4jG0gbfUEcTbBD6fMHcY0Wip+S6/pdpd7a9sVbPIvpblU1ZTjCEf1ZNtas5f3DEz9JgchS++1oRYJ3koFbSo8h1LqI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB2385.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206044da-cd43-4691-54a0-08d8232b7c87
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 10:41:35.0953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q3gDxVuJLfFEN4MPpG1i2TSaxLKjuBP2xHA4Z/QomOGA7PW9WkLmZVBJBEpUe/aEStf2HgkapIXcodmQ8K8M1x+vl0Az1+cpgUKLMd0k/xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1750
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 07 July 2020 16:17
>=20
> This is the start of the stable review cycle for the 4.19.132 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.

No build/boot issues seen for CIP configs with Linux 4.19.132-rc1 (168e2945=
aaf5).

Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-=
stable-rc-ci/-/pipelines/164002971
GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.19.y.yml
Relevant LAVA jobs: https://lava.ciplatform.org/scheduler/alljobs?length=3D=
25&search=3D168e29#table

Kind regards, Chris

>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-
> review/patch-4.19.132-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> rc.git linux-4.19.y
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
>     Linux 4.19.132-rc1
>=20
> Peter Jones <pjones@redhat.com>
>     efi: Make it possible to disable efivar_ssdt entirely
>=20
> Hou Tao <houtao1@huawei.com>
>     dm zoned: assign max_io_len correctly
>=20
> Marc Zyngier <maz@kernel.org>
>     irqchip/gic: Atomically update affinity
>=20
> Hauke Mehrtens <hauke@hauke-m.de>
>     MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen
>=20
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>     cifs: Fix the target file was deleted when rename failed.
>=20
> Paul Aurich <paul@darkrain42.org>
>     SMB3: Honor lease disabling for multiuser mounts
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
> J. Bruce Fields <bfields@redhat.com>
>     nfsd: apply umask on fs without ACL support
>=20
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>     i2c: mlxcpld: check correct size of maximum RECV_LEN packet
>=20
> Chris Packham <chris.packham@alliedtelesis.co.nz>
>     i2c: algo-pca: Add 0x78 as SCL stuck low status for PCA9665
>=20
> Christoph Hellwig <hch@lst.de>
>     nvme: fix a crash in nvme_mpath_add_disk
>=20
> Paul Aurich <paul@darkrain42.org>
>     SMB3: Honor 'posix' flag for multiuser mounts
>=20
> Hou Tao <houtao1@huawei.com>
>     virtio-blk: free vblk-vqs in error path of virtblk_probe()
>=20
> Chen-Yu Tsai <wens@csie.org>
>     drm: sun4i: hdmi: Remove extra HPD polling
>=20
> Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>     hwmon: (acpi_power_meter) Fix potential memory leak in
> acpi_power_meter_add()
>=20
> Chu Lin <linchuyuan@google.com>
>     hwmon: (max6697) Make sure the OVERT mask is set correctly
>=20
> Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
>     cxgb4: fix SGE queue dump destination buffer context
>=20
> Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
>     cxgb4: use correct type for all-mask IP address comparison
>=20
> Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
>     cxgb4: parse TC-U32 key values and masks natively
>=20
> Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
>     cxgb4: use unaligned conversion for fetching timestamp
>=20
> Chen Tao <chentao107@huawei.com>
>     drm/msm/dpu: fix error return code in dpu_encoder_init
>=20
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock=
_sock()
>=20
> Douglas Anderson <dianders@chromium.org>
>     kgdb: Avoid suspicious RCU usage warning
>=20
> Anton Eidelman <anton@lightbitslabs.com>
>     nvme-multipath: fix deadlock between ana_work and scan_work
>=20
> Sagi Grimberg <sagi@grimberg.me>
>     nvme: fix possible deadlock when I/O is blocked
>=20
> Keith Busch <kbusch@kernel.org>
>     nvme-multipath: set bdi capabilities once
>=20
> Christian Borntraeger <borntraeger@de.ibm.com>
>     s390/debug: avoid kernel warning on too large number of pages
>=20
> Zqiang <qiang.zhang@windriver.com>
>     usb: usbtest: fix missing kfree(dev->buf) in usbtest_disconnect
>=20
> Qian Cai <cai@lca.pw>
>     mm/slub: fix stack overruns with SLUB_STATS
>=20
> Dongli Zhang <dongli.zhang@oracle.com>
>     mm/slub.c: fix corrupted freechain in deactivate_slab()
>=20
> Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
>     usbnet: smsc95xx: Fix use-after-free after removal
>=20
> Borislav Petkov <bp@suse.de>
>     EDAC/amd64: Read back the scrub rate PCI register on F15h
>=20
> Hugh Dickins <hughd@google.com>
>     mm: fix swap cache node allocation mask
>=20
> Filipe Manana <fdmanana@suse.com>
>     btrfs: fix a block group ref counter leak after failure to remove blo=
ck group
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                                           |   4 +-
>  arch/mips/kernel/traps.c                           |   1 +
>  arch/s390/kernel/debug.c                           |   3 +-
>  crypto/af_alg.c                                    |  26 ++---
>  crypto/algif_aead.c                                |   9 +-
>  crypto/algif_hash.c                                |   9 +-
>  crypto/algif_skcipher.c                            |   9 +-
>  drivers/block/virtio_blk.c                         |   1 +
>  drivers/edac/amd64_edac.c                          |   2 +
>  drivers/firmware/efi/Kconfig                       |  11 ++
>  drivers/firmware/efi/efi.c                         |   2 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   2 +-
>  drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |   5 +-
>  drivers/hwmon/acpi_power_meter.c                   |   4 +-
>  drivers/hwmon/max6697.c                            |   7 +-
>  drivers/i2c/algos/i2c-algo-pca.c                   |   3 +-
>  drivers/i2c/busses/i2c-mlxcpld.c                   |   4 +-
>  drivers/irqchip/irq-gic.c                          |  14 +--
>  drivers/md/dm-zoned-target.c                       |   2 +-
>  drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |   6 +-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  10 +-
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c  |  18 +--
>  .../ethernet/chelsio/cxgb4/cxgb4_tc_u32_parse.h    | 122
> ++++++++++++++-------
>  drivers/net/ethernet/chelsio/cxgb4/sge.c           |   2 +-
>  drivers/net/usb/smsc95xx.c                         |   2 +-
>  drivers/nvme/host/core.c                           |   1 -
>  drivers/nvme/host/multipath.c                      |  33 ++++--
>  drivers/usb/misc/usbtest.c                         |   1 +
>  fs/btrfs/extent-tree.c                             |  19 ++--
>  fs/cifs/connect.c                                  |   9 +-
>  fs/cifs/inode.c                                    |  10 +-
>  fs/nfsd/vfs.c                                      |   6 +
>  include/crypto/if_alg.h                            |   4 +-
>  kernel/debug/debug_core.c                          |   4 +
>  mm/slub.c                                          |  30 ++++-
>  mm/swap_state.c                                    |   3 +-
>  sound/usb/card.h                                   |   4 -
>  sound/usb/endpoint.c                               |  43 +-------
>  sound/usb/endpoint.h                               |   1 -
>  sound/usb/pcm.c                                    |   2 -
>  40 files changed, 256 insertions(+), 192 deletions(-)
>=20

