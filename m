Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824D81A6CB6
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 21:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388023AbgDMTmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 15:42:45 -0400
Received: from mail-eopbgr1400112.outbound.protection.outlook.com ([40.107.140.112]:14831
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387935AbgDMTmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 15:42:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiZR6wCHnQyapTgx64QivYFZMogh7SX7ge2L/j3WfQQD8rGvhVhdaX/MwsBuRq3dZF5SIdEu9eu+UxgpsUQu8OejwiSjRlCFOyB8WffvIwMKeVv07dJpdD82IWG3+aISs5bIlLglUuSQh1me40xnOZY+xuhq/NXDRUpda2XzgRtjl0Aaqh/A/3qqsAg76S0ESVbrjH51l6LMjjmsA1KFhB31L0/5l5ImX+qLt02jS/gnjYX55tgebNTCx7qVoZHP2Cej1u2MGzbY3Pvi53h2skTLjD8RB7IRcFuwgDDB3aevB/7tayO9asxN3r8VZ46BNk1Rvsn7s52FWS4gQCdkJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8d/qDNBXx27wDPM50zzUCw5UCflRoo24cm0ab1nHWhc=;
 b=H1jab2qk42/RDQAIuNBJCz/r3WF60c+8P8QQMsEPopWnCW977ea/BTxUVqybjlHsiF82qCe3Z/nywDaCJOV3O1yqoeiwfwOAz6oju1LxrJXMYMailAYB0aKPZMygVVtMQSb5u1yq/b5IyyoWbwdOmUOSkLbyNCttYlZFQYnjAQsnJEJiWyxu1p7y5W2YExw6VkWcgbzkT/jBbBkw5FuWkkpjfqoHBh/iNfyByumYsHjZCbls5/kRSw/feTMOod4ZScRarNTrpLZZQIifWXdjKiXUfCDTOFRKAWG16n8Leya/1LneJQ4mnQe6tM/+YgKnf1J9GUMd6WM6uqRQstdlhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8d/qDNBXx27wDPM50zzUCw5UCflRoo24cm0ab1nHWhc=;
 b=pfImb7BsCbxQGhQNuU74JjQzGtmartzGRtrh3xXxr1BgC36GOOAmgYT24cDbcElW3luS1ZxjRjCIONPLQG5CAZbaqSTNsA5KKVODPcTnCxDKO6f/I0m4ahlsTsfQySkVvqHi18WRXdl0y72876I0ejFO45xwLARtQvIDGU5ZAvk=
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com (52.134.243.13) by
 OSBPR01MB2551.jpnprd01.prod.outlook.com (52.134.254.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Mon, 13 Apr 2020 19:42:38 +0000
Received: from OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::c9a6:9735:12fc:ae04]) by OSBPR01MB2280.jpnprd01.prod.outlook.com
 ([fe80::c9a6:9735:12fc:ae04%2]) with mapi id 15.20.2878.027; Mon, 13 Apr 2020
 19:42:38 +0000
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
Subject: RE: [PATCH 4.19 00/54] 4.19.115-rc1 review
Thread-Topic: [PATCH 4.19 00/54] 4.19.115-rc1 review
Thread-Index: AQHWD/rfo6q+WbUQYUK0medF5I+TG6h3dpcA
Date:   Mon, 13 Apr 2020 19:42:37 +0000
Message-ID: <OSBPR01MB228027C12DBA445E6AFF69F3B7DD0@OSBPR01MB2280.jpnprd01.prod.outlook.com>
References: <20200411115508.284500414@linuxfoundation.org>
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [151.224.220.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7f7c966b-0cd3-4f3e-702a-08d7dfe2d27b
x-ms-traffictypediagnostic: OSBPR01MB2551:
x-microsoft-antispam-prvs: <OSBPR01MB255126C8A4882FE3D3E05FB8B7DD0@OSBPR01MB2551.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2280.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(478600001)(66446008)(64756008)(5660300002)(4326008)(966005)(186003)(66556008)(71200400001)(55016002)(26005)(66476007)(2906002)(9686003)(33656002)(52536014)(110136005)(8936002)(76116006)(66946007)(86362001)(81156014)(316002)(6506007)(54906003)(7696005)(7416002)(8676002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hwj0Q/Txxcr774B7RiQSc6oJYcnjWyEu5MQ+TJBUGBiHue8xHx2p74qNkUpK7a/rWoW/x5Op56Dzp8b3tTMuG5qUFA2HSPgM5MEnw0hAj/4f+/XTZyoWvOiBWGLaw+N3muex9dzoAmsxLCZvNHzTdM3UrAbpgHMFDpgj6m7pvtrKtwHfJAZ7++68SiLofRKpOsceczl606sNwKTPxX7duQ7fxhH/5esia44OjGvPkw532Sd0YSNozLImtxCfbBfir5vf+4N0MUm89VgPlfcI/BanE6otNVr1r+HbhnpyQHSxOKuAz2V0Pi/5xXF2OwDG60hyIqsp2LpfhLHastUir9iAqhQXk1zyc3qMhNdc31Js8G6zTw+oGDJGLVjwhbQBlaiCk4Ib2TKj5CeXQUxsAU4TAbrt6KDe+AzaJt9x8RcKxJJ7FqublhcmMp+A8NyFl8yqPeWREA3maja1Gg0JUiAVgf4AX0FStaE3YQl4gMSttnbpVDoL77jk/SIb9oinjNDY3ywsLSGI1DHTDkZjIQ==
x-ms-exchange-antispam-messagedata: FlMNG1ziqhbleHrFAMEofypntMMUmaCp8E8/GvfefBiLWnfSXostOMCZnKyDXUFX18Hpeuh6yACsuVhHwVJdBCUp0L/v3Lix69fh8/Ryapry0Xncwm1pRAu8yK1azAzKkIeHBkM3/AUVAZzFEVGFig==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7c966b-0cd3-4f3e-702a-08d7dfe2d27b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 19:42:37.9814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 151FssXSdB8weDSSmFkP4/5KbwdIwn1K1erpwUXvuxoPwcqzx3Q9SLJHYl+qsyWL43bVeDsTRRD0VW8nxxGAnt/KP9W3jUxRk60xeps93NE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2551
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Greg Kroah-Hartman
> Sent: 11 April 2020 13:09
>=20
> This is the start of the stable review cycle for the 4.19.115 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.

No build/boot issues seen for CIP configs for Linux 4.19.115-rc1 (3b903e5af=
fcf).

Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/linux-=
stable-rc-ci/pipelines/134988024
GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip-pi=
pelines/-/blob/master/trees/linux-4.19.y.yml

Kind regards, Chris

>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-
> 4.19.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-4.19.y
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
>     Linux 4.19.115-rc1
>=20
> Hans Verkuil <hans.verkuil@cisco.com>
>     drm_dp_mst_topology: fix broken
> drm_dp_sideband_parse_remote_dpcd_read()
>=20
> Roger Quadros <rogerq@ti.com>
>     usb: dwc3: don't set gadget->is_otg flag
>=20
> Chris Lew <clew@codeaurora.org>
>     rpmsg: glink: Remove chunk size word align warning
>=20
> Arun KS <arunks@codeaurora.org>
>     arm64: Fix size of __early_cpu_boot_status
>=20
> Rob Clark <robdclark@chromium.org>
>     drm/msm: stop abusing dma_map/unmap for cache
>=20
> Taniya Das <tdas@codeaurora.org>
>     clk: qcom: rcg: Return failure for RCG update
>=20
> Qiujun Huang <hqjagain@gmail.com>
>     fbcon: fix null-ptr-deref in fbcon_switch
>=20
> Avihai Horon <avihaih@mellanox.com>
>     RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow
>=20
> Qiujun Huang <hqjagain@gmail.com>
>     Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     RDMA/cma: Teach lockdep about the order of rtnl and lock
>=20
> Jason Gunthorpe <jgg@ziepe.ca>
>     RDMA/ucma: Put a lock around every call to the rdma_cm layer
>=20
> Ilya Dryomov <idryomov@gmail.com>
>     ceph: canonicalize server path in place
>=20
> Xiubo Li <xiubli@redhat.com>
>     ceph: remove the extra slashes in the server path
>=20
> Kaike Wan <kaike.wan@intel.com>
>     IB/hfi1: Fix memory leaks in sysfs registration and unregistration
>=20
> Kaike Wan <kaike.wan@intel.com>
>     IB/hfi1: Call kobject_put() when kobject_init_and_add() fails
>=20
> Paul Cercueil <paul@crapouillou.net>
>     ASoC: jz4740-i2s: Fix divider written at incorrect offset in register
>=20
> Martin Kaiser <martin@kaiser.cx>
>     hwrng: imx-rngc - fix an error path
>=20
> David Ahern <dsahern@kernel.org>
>     tools/accounting/getdelays.c: fix netlink attribute length
>=20
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: dwc3: gadget: Wrap around when skip TRBs
>=20
> Jason A. Donenfeld <Jason@zx2c4.com>
>     random: always use batched entropy for get_random_u{32,64}
>=20
> Petr Machata <petrm@mellanox.com>
>     mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE
>=20
> Richard Palethorpe <rpalethorpe@suse.com>
>     slcan: Don't transmit uninitialized stack data in padding
>=20
> Jisheng Zhang <Jisheng.Zhang@synaptics.com>
>     net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting
>=20
> Oleksij Rempel <o.rempel@pengutronix.de>
>     net: phy: micrel: kszphy_resume(): add delay after genphy_resume() be=
fore
> accessing PHY registers
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: dsa: bcm_sf2: Ensure correct sub-node is parsed
>=20
> Florian Fainelli <f.fainelli@gmail.com>
>     net: dsa: bcm_sf2: Do not register slave MDIO bus with OF
>=20
> Jarod Wilson <jarod@redhat.com>
>     ipv6: don't auto-add link-local address to lag ports
>=20
> Randy Dunlap <rdunlap@infradead.org>
>     mm: mempolicy: require at least one nodeid for MPOL_PREFERRED
>=20
> Sam Protsenko <semen.protsenko@linaro.org>
>     include/linux/notifier.h: SRCU: fix ctags
>=20
> Miklos Szeredi <mszeredi@redhat.com>
>     bitops: protect variables in set_mask_bits() macro
>=20
> Daniel Jordan <daniel.m.jordan@oracle.com>
>     padata: always acquire cpu_hotplug_lock before pinst->lock
>=20
> Amritha Nambiar <amritha.nambiar@intel.com>
>     net: Fix Tx hash bound checking
>=20
> David Howells <dhowells@redhat.com>
>     rxrpc: Fix sendmsg(MSG_WAITALL) handling
>=20
> Geoffrey Allott <geoffrey@allott.email>
>     ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on E=
VGA
> X99 Classified motherboard
>=20
> Hans de Goede <hdegoede@redhat.com>
>     power: supply: axp288_charger: Add special handling for HP Pavilion x=
2 10
>=20
> Hans de Goede <hdegoede@redhat.com>
>     extcon: axp288: Add wakeup support
>=20
> Alexander Usyskin <alexander.usyskin@intel.com>
>     mei: me: add cedar fork device ids
>=20
> Eugene Syromiatnikov <esyr@redhat.com>
>     coresight: do not use the BIT() macro in the UAPI header
>=20
> Kishon Vijay Abraham I <kishon@ti.com>
>     misc: pci_endpoint_test: Avoid using module parameter to determine ir=
qtype
>=20
> Kishon Vijay Abraham I <kishon@ti.com>
>     misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test device=
s
>=20
> YueHaibing <yuehaibing@huawei.com>
>     misc: rtsx: set correct pcr_ops for rts522A
>=20
> Sean Young <sean@mess.org>
>     media: rc: IR signal for Panasonic air conditioner too long
>=20
> Lucas Stach <l.stach@pengutronix.de>
>     drm/etnaviv: replace MMU flush marker with flush sequence
>=20
> Len Brown <len.brown@intel.com>
>     tools/power turbostat: Fix missing SYS_LPI counter on some Chromebook=
s
>=20
> Len Brown <len.brown@intel.com>
>     tools/power turbostat: Fix gcc build warnings
>=20
> James Zhu <James.Zhu@amd.com>
>     drm/amdgpu: fix typo for vcn1 idle check
>=20
> Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
>     initramfs: restore default compression behavior
>=20
> Gerd Hoffmann <kraxel@redhat.com>
>     drm/bochs: downgrade pci_request_region failure from error to warning
>=20
> Mario Kleiner <mario.kleiner.de@gmail.com>
>     drm/amd/display: Add link_rate quirk for Apple 15" MBP 2017
>=20
> Prabhath Sajeepa <psajeepa@purestorage.com>
>     nvme-rdma: Avoid double freeing of async event data
>=20
> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>     sctp: fix possibly using a bad saddr with a given dst
>=20
> Qiujun Huang <hqjagain@gmail.com>
>     sctp: fix refcount bug in sctp_wfree
>=20
> William Dauchy <w.dauchy@criteo.com>
>     net, ip_tunnel: fix interface lookup with no key
>=20
> Qian Cai <cai@lca.pw>
>     ipv4: fix a RCU-list lock in fib_triestat_seq_show
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                                           |  4 +-
>  arch/arm64/kernel/head.S                           |  2 +-
>  drivers/char/hw_random/imx-rngc.c                  |  4 +-
>  drivers/char/random.c                              | 20 ++------
>  drivers/clk/qcom/clk-rcg2.c                        |  2 +-
>  drivers/extcon/extcon-axp288.c                     | 32 ++++++++++++
>  drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |  2 +-
>  drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   | 11 +++++
>  drivers/gpu/drm/bochs/bochs_hw.c                   |  6 +--
>  drivers/gpu/drm/drm_dp_mst_topology.c              |  1 +
>  drivers/gpu/drm/etnaviv/etnaviv_buffer.c           | 10 ++--
>  drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |  1 +
>  drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |  6 +--
>  drivers/gpu/drm/etnaviv/etnaviv_mmu.h              |  2 +-
>  drivers/gpu/drm/msm/msm_gem.c                      |  4 +-
>  drivers/infiniband/core/cma.c                      | 14 ++++++
>  drivers/infiniband/core/ucma.c                     | 49 ++++++++++++++++=
++-
>  drivers/infiniband/hw/hfi1/sysfs.c                 | 26 +++++++---
>  drivers/media/rc/lirc_dev.c                        |  2 +-
>  drivers/misc/cardreader/rts5227.c                  |  1 +
>  drivers/misc/mei/hw-me-regs.h                      |  2 +
>  drivers/misc/mei/pci-me.c                          |  2 +
>  drivers/misc/pci_endpoint_test.c                   | 14 ++++--
>  drivers/net/can/slcan.c                            |  4 +-
>  drivers/net/dsa/bcm_sf2.c                          |  9 +++-
>  .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  8 +--
>  .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |  2 +-
>  drivers/net/phy/micrel.c                           |  7 +++
>  drivers/nvme/host/rdma.c                           |  8 +--
>  drivers/power/supply/axp288_charger.c              | 57 ++++++++++++++++=
+++++-
>  drivers/rpmsg/qcom_glink_native.c                  |  3 --
>  drivers/usb/dwc3/gadget.c                          |  3 +-
>  drivers/video/fbdev/core/fbcon.c                   |  3 ++
>  fs/ceph/super.c                                    | 56 +++++++++++++---=
-----
>  fs/ceph/super.h                                    |  2 +-
>  include/linux/bitops.h                             | 14 +++---
>  include/linux/notifier.h                           |  3 +-
>  include/uapi/linux/coresight-stm.h                 |  6 ++-
>  kernel/padata.c                                    |  4 +-
>  mm/mempolicy.c                                     |  6 ++-
>  net/bluetooth/rfcomm/tty.c                         |  4 +-
>  net/core/dev.c                                     |  2 +
>  net/ipv4/fib_trie.c                                |  3 ++
>  net/ipv4/ip_tunnel.c                               |  6 +--
>  net/ipv6/addrconf.c                                |  4 ++
>  net/rxrpc/sendmsg.c                                |  4 +-
>  net/sctp/ipv6.c                                    | 20 +++++---
>  net/sctp/protocol.c                                | 28 +++++++----
>  net/sctp/socket.c                                  | 31 +++++++++---
>  sound/pci/hda/patch_ca0132.c                       |  1 +
>  sound/soc/jz4740/jz4740-i2s.c                      |  2 +-
>  tools/accounting/getdelays.c                       |  2 +-
>  tools/power/x86/turbostat/turbostat.c              | 27 +++++-----
>  usr/Kconfig                                        | 22 ++++-----
>  54 files changed, 409 insertions(+), 159 deletions(-)
>=20

