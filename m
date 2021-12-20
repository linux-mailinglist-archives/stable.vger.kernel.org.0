Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C872747AC10
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbhLTOlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:41:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48880 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbhLTOkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:40:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E343BB80EE6;
        Mon, 20 Dec 2021 14:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC1FC36AE7;
        Mon, 20 Dec 2021 14:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011201;
        bh=8RFVIdDkGZlJzM7436ymwsk2qX1V+JODqlPghtETEGc=;
        h=From:To:Cc:Subject:Date:From;
        b=amMxw1cl0932PCE89sVONVmW/AacYHngFmAo++KBYmPJOziZtl8uOlPQOklW27TE/
         uVHqtOzfYBtMJVos+aQ7XfubTojqhtc1t4nLkPrGdh6YwU1earNERZOs0ynP5/8JCP
         2NSHEWJKK2vS7Yc5qQQZtrx3TjrfJSzaAOSYiJ+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/45] 4.14.259-rc1 review
Date:   Mon, 20 Dec 2021 15:33:55 +0100
Message-Id: <20211220143022.266532675@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.259-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.259-rc1
X-KernelTest-Deadline: 2021-12-22T14:30+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.259 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.259-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.259-rc1

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

George Kennedy <george.kennedy@oracle.com>
    scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: annotate lock in fuse_reverse_inval_entry()

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6ull-pinfunc: Fix CSI_DATA07__ESAI_TX0 pad name

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scpi: Fix string overflow in SCPI genpd driver

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: Add global locking for descriptor lifecycle

George Kennedy <george.kennedy@oracle.com>
    libata: if T_LENGTH is zero, dma direction should be DMA_NONE

Yu Liao <liaoyu15@huawei.com>
    timekeeping: Really make sure wall_to_monotonic isn't positive

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN990 compositions

Stefan Roese <sr@denx.de>
    PCI/MSI: Mask MSI-X vectors only on success

Thomas Gleixner <tglx@linutronix.de>
    PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: bRequestType is a bitfield, not a enum

Eric Dumazet <edumazet@google.com>
    sit: do not call ipip6_dev_free() from sit_init_net()

Willem de Bruijn <willemb@google.com>
    net/packet: rx_owner_map depends on pg_vec

Cyril Novikov <cnovikov@lynx.com>
    ixgbe: set X550 MDIO speed before talking to PHY

Letu Ren <fantasquex@gmail.com>
    igbvf: fix double free in `igbvf_probe`

Nathan Chancellor <nathan@kernel.org>
    soc/tegra: fuse: Fix bitwise vs. logical OR warning

Alyssa Ross <hi@alyssa.is>
    dmaengine: st_fdma: fix MODULE_ALIAS

Dinh Nguyen <dinguyen@kernel.org>
    ARM: socfpga: dts: fix qspi node compatible

Randy Dunlap <rdunlap@infradead.org>
    hv: utils: add PTP_1588_CLOCK to Kconfig to fix build

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

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix panic due to oob in bpf_prog_test_run_skb

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


-------------

Diffstat:

 Makefile                                           |   4 +-
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
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 +
 drivers/hv/Kconfig                                 |   1 +
 drivers/hwmon/dell-smm-hwmon.c                     |   7 +-
 drivers/i2c/busses/i2c-rk3x.c                      |   4 +-
 drivers/input/touchscreen/of_touchscreen.c         |  18 +--
 drivers/md/persistent-data/dm-btree-remove.c       |   2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   5 +
 drivers/net/ethernet/broadcom/bcmsysport.h         |   1 +
 drivers/net/ethernet/intel/igbvf/netdev.c          |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |   3 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   6 +-
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
 drivers/usb/gadget/composite.c                     |   6 +-
 drivers/usb/gadget/legacy/dbgp.c                   |   6 +-
 drivers/usb/gadget/legacy/inode.c                  |   6 +-
 drivers/usb/serial/option.c                        |   8 ++
 fs/fuse/dir.c                                      |   2 +-
 fs/nfsd/nfs4state.c                                |   9 +-
 kernel/audit.c                                     |  21 ++--
 kernel/time/timekeeping.c                          |   3 +-
 kernel/trace/tracing_map.c                         |   3 +
 lib/Kconfig.debug                                  |   6 +-
 net/bpf/test_run.c                                 |  17 ++-
 net/ipv6/sit.c                                     |   1 -
 net/mac80211/agg-tx.c                              |   2 +-
 net/netlink/af_netlink.c                           |   5 +
 net/nfc/netlink.c                                  |   6 +-
 net/packet/af_packet.c                             |   5 +-
 scripts/recordmcount.pl                            |   2 +-
 tools/testing/selftests/bpf/test_verifier.c        |  18 +++
 66 files changed, 577 insertions(+), 375 deletions(-)


