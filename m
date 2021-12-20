Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D8847AC67
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhLTOnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:43:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50620 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbhLTOmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:42:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88216B80EDA;
        Mon, 20 Dec 2021 14:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9060CC36AE7;
        Mon, 20 Dec 2021 14:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011330;
        bh=P1Zt/H9wNXwzoFqdqw7G2+zU227RPtV/ddVDNtrLQJc=;
        h=From:To:Cc:Subject:Date:From;
        b=abUXvyDgoarCLjB36b3L3vIcbqhuRpPFssGGxvt8xJ5kin5M0O5INXNNXsKyWTUCn
         /5fLDrW80PwGtEzpl8ixkmk05INQZmTwAuyiufw2kkvrnVzaEeIUI/r5mwmkCAYpqu
         ZlIBueNdKG+RGBUppUpkh9L6GH7MUMDETzB6n0yE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/56] 4.19.222-rc1 review
Date:   Mon, 20 Dec 2021 15:33:53 +0100
Message-Id: <20211220143023.451982183@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.222-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.222-rc1
X-KernelTest-Deadline: 2021-12-22T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.222 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.222-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.222-rc1

Juergen Gross <jgross@suse.com>
    xen/netback: don't queue unlimited number of packages

Juergen Gross <jgross@suse.com>
    xen/netback: fix rx queue stall detection

Juergen Gross <jgross@suse.com>
    xen/console: harden hvc_xen against event channel storms

Juergen Gross <jgross@suse.com>
    xen/netfront: harden netfront against event channel storms

Juergen Gross <jgross@suse.com>
    xen/blkfront: harden blkfront against event channel storms

George Kennedy <george.kennedy@oracle.com>
    scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix warning in ovl_create_real()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: annotate lock in fuse_reverse_inval_entry()

Pavel Skripkin <paskripkin@gmail.com>
    media: mxl111sf: change mutex_init() location

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6ull-pinfunc: Fix CSI_DATA07__ESAI_TX0 pad name

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scpi: Fix string overflow in SCPI genpd driver

Nathan Chancellor <nathan@kernel.org>
    Input: touchscreen - avoid bitwise vs logical OR warning

Stefan Agner <stefan@agner.ch>
    ARM: 8800/1: use choice for kernel unwinders

Nathan Chancellor <natechancellor@gmail.com>
    mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO

Nicolas Pitre <nicolas.pitre@linaro.org>
    ARM: 8805/2: remove unneeded naked function usage

Nathan Chancellor <natechancellor@gmail.com>
    net: lan78xx: Avoid unnecessary self assignment

Johannes Berg <johannes.berg@intel.com>
    mac80211: validate extended element ID is present

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: Add global locking for descriptor lifecycle

Le Ma <le.ma@amd.com>
    drm/amdgpu: correct register access for RLC_JUMP_TABLE_RESTORE

George Kennedy <george.kennedy@oracle.com>
    libata: if T_LENGTH is zero, dma direction should be DMA_NONE

Yu Liao <liaoyu15@huawei.com>
    timekeeping: Really make sure wall_to_monotonic isn't positive

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN990 compositions

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: fix CP2105 GPIO registration

Stefan Roese <sr@denx.de>
    PCI/MSI: Mask MSI-X vectors only on success

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error

Jimmy Wang <wangjm221@gmail.com>
    USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: bRequestType is a bitfield, not a enum

Eric Dumazet <edumazet@google.com>
    sit: do not call ipip6_dev_free() from sit_init_net()

Willem de Bruijn <willemb@google.com>
    net/packet: rx_owner_map depends on pg_vec

Haimin Zhang <tcs.kernel@gmail.com>
    netdevsim: Zero-initialize memory for new map's value in function nsim_bpf_map_alloc

Cyril Novikov <cnovikov@lynx.com>
    ixgbe: set X550 MDIO speed before talking to PHY

Letu Ren <fantasquex@gmail.com>
    igbvf: fix double free in `igbvf_probe`

Karen Sornek <karen.sornek@intel.com>
    igb: Fix removal of unicast MAC filters of VFs

Nathan Chancellor <nathan@kernel.org>
    soc/tegra: fuse: Fix bitwise vs. logical OR warning

Hangyu Hua <hbh25y@gmail.com>
    rds: memory leak in __rds_conn_create()

Alyssa Ross <hi@alyssa.is>
    dmaengine: st_fdma: fix MODULE_ALIAS

Eric Dumazet <edumazet@google.com>
    sch_cake: do not call cake_destroy() from cake_init()

Dinh Nguyen <dinguyen@kernel.org>
    ARM: socfpga: dts: fix qspi node compatible

Randy Dunlap <rdunlap@infradead.org>
    hv: utils: add PTP_1588_CLOCK to Kconfig to fix build

Johannes Berg <johannes.berg@intel.com>
    mac80211: track only QoS data frames for admission control

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sme: Explicitly map new EFI memmap table as encrypted

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    x86: Make ARCH_USE_MEMREMAP_PROT a generic Kconfig symbol

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix use-after-free due to delegation race

Paul Moore <paul@paul-moore.com>
    audit: improve robustness of the audit queue handling

Joe Thornber <ejt@redhat.com>
    dm btree remove: fix use after free in rebalance_children()

Jerome Marchand <jmarchan@redhat.com>
    recordmcount.pl: look for jgnop instruction as well as bcrl on s390

Felix Fietkau <nbd@nbd.name>
    mac80211: send ADDBA requests using the tid/queue of the aggregation session

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Fix warning on /proc/i8k creation error

Chen Jun <chenjun102@huawei.com>
    tracing: Fix a kmemleak false positive in tracing_map

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    net: netlink: af_netlink: Prevent empty skb by adding a check on len.

Ondrej Jirman <megous@megous.com>
    i2c: rk3x: Handle a spurious start completion interrupt flag

Helge Deller <deller@gmx.de>
    parisc/agp: Annotate parisc agp init functions with __init

Erik Ekman <erik@kryo.se>
    net/mlx4_en: Update reported link modes for 1/10G

Philip Chen <philipchen@chromium.org>
    drm/msm/dsi: set default num_data_lanes

Tadeusz Struk <tadeusz.struk@linaro.org>
    nfc: fix segfault in nfc_genl_dump_devices_done

Sasha Levin <sashal@kernel.org>
    stable: clamp SUBLEVEL in 4.19


-------------

Diffstat:

 Makefile                                           |   6 +-
 arch/Kconfig                                       |   3 +
 arch/arm/Kconfig.debug                             |  44 +++++---
 arch/arm/boot/dts/imx6ull-pinfunc.h                |   2 +-
 arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts   |   2 +-
 arch/arm/boot/dts/socfpga_arria5_socdk.dts         |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts       |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts      |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts    |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_sodia.dts       |   2 +-
 arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts |   4 +-
 arch/arm/mm/copypage-fa.c                          |  35 +++---
 arch/arm/mm/copypage-feroceon.c                    |  98 ++++++++--------
 arch/arm/mm/copypage-v4mc.c                        |  19 ++--
 arch/arm/mm/copypage-v4wb.c                        |  41 ++++---
 arch/arm/mm/copypage-v4wt.c                        |  37 +++---
 arch/arm/mm/copypage-xsc3.c                        |  71 +++++-------
 arch/arm/mm/copypage-xscale.c                      |  71 ++++++------
 arch/x86/Kconfig                                   |   6 +-
 arch/x86/mm/ioremap.c                              |   4 +-
 arch/x86/platform/efi/quirks.c                     |   3 +-
 drivers/ata/libata-scsi.c                          |  15 ++-
 drivers/block/xen-blkfront.c                       |  15 ++-
 drivers/char/agp/parisc-agp.c                      |   6 +-
 drivers/dma/st_fdma.c                              |   2 +-
 drivers/firmware/scpi_pm_domain.c                  |  10 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 +
 drivers/hv/Kconfig                                 |   1 +
 drivers/hwmon/dell-smm-hwmon.c                     |   7 +-
 drivers/i2c/busses/i2c-rk3x.c                      |   4 +-
 drivers/input/touchscreen/of_touchscreen.c         |  18 +--
 drivers/md/persistent-data/dm-btree-remove.c       |   2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |  16 ++-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   5 +
 drivers/net/ethernet/broadcom/bcmsysport.h         |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  28 ++---
 drivers/net/ethernet/intel/igbvf/netdev.c          |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |   3 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   6 +-
 drivers/net/netdevsim/bpf.c                        |   1 +
 drivers/net/usb/lan78xx.c                          |   6 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   8 +-
 drivers/net/xen-netback/common.h                   |   1 +
 drivers/net/xen-netback/rx.c                       |  77 ++++++++-----
 drivers/net/xen-netfront.c                         | 125 ++++++++++++++++-----
 drivers/pci/msi.c                                  |  15 ++-
 drivers/scsi/scsi_debug.c                          |   4 +-
 drivers/soc/tegra/fuse/fuse-tegra.c                |   2 +-
 drivers/soc/tegra/fuse/fuse.h                      |   2 +-
 drivers/tty/hvc/hvc_xen.c                          |  30 ++++-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/composite.c                     |   6 +-
 drivers/usb/gadget/legacy/dbgp.c                   |   6 +-
 drivers/usb/gadget/legacy/inode.c                  |   6 +-
 drivers/usb/serial/cp210x.c                        |   6 +-
 drivers/usb/serial/option.c                        |   8 ++
 fs/fuse/dir.c                                      |   2 +-
 fs/nfsd/nfs4state.c                                |   9 +-
 fs/overlayfs/dir.c                                 |   3 +-
 fs/overlayfs/overlayfs.h                           |   1 +
 fs/overlayfs/super.c                               |  12 +-
 kernel/audit.c                                     |  21 ++--
 kernel/time/timekeeping.c                          |   3 +-
 kernel/trace/tracing_map.c                         |   3 +
 lib/Kconfig.debug                                  |   6 +-
 net/ipv6/sit.c                                     |   1 -
 net/mac80211/agg-tx.c                              |   2 +-
 net/mac80211/mlme.c                                |  13 ++-
 net/mac80211/util.c                                |   2 +
 net/netlink/af_netlink.c                           |   5 +
 net/nfc/netlink.c                                  |   6 +-
 net/packet/af_packet.c                             |   5 +-
 net/rds/connection.c                               |   1 +
 net/sched/sch_cake.c                               |   6 +-
 scripts/recordmcount.pl                            |   2 +-
 77 files changed, 608 insertions(+), 407 deletions(-)


