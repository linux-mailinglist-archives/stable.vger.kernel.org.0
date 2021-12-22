Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4769047CEAD
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 10:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbhLVJDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 04:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243704AbhLVJD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 04:03:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CEAC061759;
        Wed, 22 Dec 2021 01:03:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1727B817BF;
        Wed, 22 Dec 2021 09:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D557C36AE5;
        Wed, 22 Dec 2021 09:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640163791;
        bh=5+acmeukActVDuxz+sIO0oELpyLS63FtTE1JWqf2Qxc=;
        h=From:To:Cc:Subject:Date:From;
        b=hJMd4KzFOuZWyXzFUj0dBLu13MX5LiRqabC33e5vvA/2yEFGGDG1jQysIJnZmQ7M7
         yGsfOfFlJrqITh8iv+UwZiLmtGV9DvD3ZsB9GQWLzEIHlBUen2ZF6ZP4DP4xrYIDqh
         ukLAmV9AmqupS1Z8r7ZEJ0WxSi+QnMZRDuDv/nk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.168
Date:   Wed, 22 Dec 2021 10:03:01 +0100
Message-Id: <164016378295219@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.168 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                        |    2 
 arch/arm/boot/dts/imx6ull-pinfunc.h                             |    2 
 arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts                |    2 
 arch/arm/boot/dts/socfpga_arria5_socdk.dts                      |    2 
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts                    |    2 
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts                   |    2 
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts                 |    2 
 arch/arm/boot/dts/socfpga_cyclone5_sodia.dts                    |    2 
 arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts              |    4 
 arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi            |    1 
 arch/arm64/boot/dts/rockchip/rk3399-leez-p710.dts               |    2 
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dts               |    2 
 arch/s390/kernel/machine_kexec_file.c                           |    7 
 drivers/ata/libata-scsi.c                                       |   15 +
 drivers/block/xen-blkfront.c                                    |   15 -
 drivers/clk/clk.c                                               |   15 -
 drivers/dma/st_fdma.c                                           |    2 
 drivers/firmware/scpi_pm_domain.c                               |   10 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                           |    4 
 drivers/iio/adc/stm32-adc.c                                     |    1 
 drivers/input/touchscreen/of_touchscreen.c                      |   18 -
 drivers/md/persistent-data/dm-btree-remove.c                    |    2 
 drivers/media/usb/dvb-usb-v2/mxl111sf.c                         |   16 +
 drivers/net/ethernet/broadcom/bcmsysport.c                      |    5 
 drivers/net/ethernet/broadcom/bcmsysport.h                      |    1 
 drivers/net/ethernet/intel/igb/igb_main.c                       |   28 +-
 drivers/net/ethernet/intel/igbvf/netdev.c                       |    1 
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c                   |    3 
 drivers/net/netdevsim/bpf.c                                     |    1 
 drivers/net/wireless/marvell/mwifiex/cmdevt.c                   |    4 
 drivers/net/wireless/marvell/mwifiex/fw.h                       |    8 
 drivers/net/xen-netback/common.h                                |    1 
 drivers/net/xen-netback/rx.c                                    |   77 +++---
 drivers/net/xen-netfront.c                                      |  125 +++++++---
 drivers/pci/msi.c                                               |   15 -
 drivers/scsi/scsi_debug.c                                       |    4 
 drivers/soc/tegra/fuse/fuse-tegra.c                             |    2 
 drivers/soc/tegra/fuse/fuse.h                                   |    2 
 drivers/tty/hvc/hvc_xen.c                                       |   30 ++
 drivers/usb/core/quirks.c                                       |    3 
 drivers/usb/gadget/composite.c                                  |    6 
 drivers/usb/gadget/legacy/dbgp.c                                |    6 
 drivers/usb/gadget/legacy/inode.c                               |    6 
 drivers/usb/host/xhci-pci.c                                     |    6 
 drivers/usb/serial/cp210x.c                                     |    6 
 drivers/usb/serial/option.c                                     |    8 
 drivers/virtio/virtio_ring.c                                    |    2 
 fs/fuse/dir.c                                                   |    2 
 fs/nfsd/nfs4state.c                                             |    9 
 fs/overlayfs/dir.c                                              |    3 
 fs/overlayfs/overlayfs.h                                        |    1 
 fs/overlayfs/super.c                                            |   12 
 include/net/tc_act/tc_tunnel_key.h                              |    7 
 kernel/audit.c                                                  |   21 -
 kernel/rcu/tree.c                                               |   10 
 kernel/time/timekeeping.c                                       |    3 
 net/core/skbuff.c                                               |    2 
 net/ipv4/inet_diag.c                                            |   19 -
 net/ipv6/sit.c                                                  |    1 
 net/mac80211/agg-rx.c                                           |    8 
 net/mac80211/agg-tx.c                                           |   80 +++---
 net/mac80211/driver-ops.h                                       |    5 
 net/mac80211/mlme.c                                             |   13 -
 net/mac80211/sta_info.h                                         |    1 
 net/mac80211/util.c                                             |    2 
 net/packet/af_packet.c                                          |    5 
 net/rds/connection.c                                            |    1 
 net/sched/act_sample.c                                          |    2 
 net/sched/cls_api.c                                             |   18 -
 net/sched/sch_cake.c                                            |    6 
 net/smc/af_smc.c                                                |    4 
 scripts/recordmcount.pl                                         |    2 
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c              |   30 ++
 tools/testing/selftests/net/fcnal-test.sh                       |   23 +
 tools/testing/selftests/net/forwarding/forwarding.config.sample |    2 
 75 files changed, 523 insertions(+), 249 deletions(-)

Alex Bee (1):
      arm64: dts: rockchip: fix audio-supply for Rock Pi 4

Alyssa Ross (1):
      dmaengine: st_fdma: fix MODULE_ALIAS

Artem Lapkin (1):
      arm64: dts: rockchip: remove mmc-hs400-enhanced-strobe from rk3399-khadas-edge

Baowen Zheng (1):
      flow_offload: return EOPNOTSUPP for the unsupported mpls action type

Cyril Novikov (1):
      ixgbe: set X550 MDIO speed before talking to PHY

D. Wythe (1):
      net/smc: Prevent smc_release() from long blocking

Daniele Palmas (1):
      USB: serial: option: add Telit FN990 compositions

David Ahern (2):
      selftests: Fix raw socket bind tests with VRF
      selftests: Fix IPv6 address bind tests

Dinh Nguyen (1):
      ARM: socfpga: dts: fix qspi node compatible

Eric Dumazet (4):
      sch_cake: do not call cake_destroy() from cake_init()
      inet_diag: use jiffies_delta_to_msecs()
      inet_diag: fix kernel-infoleak for UDP sockets
      sit: do not call ipip6_dev_free() from sit_init_net()

Fabio Estevam (1):
      ARM: dts: imx6ull-pinfunc: Fix CSI_DATA07__ESAI_TX0 pad name

Fabrice Gasnier (1):
      iio: adc: stm32: fix a current leak by resetting pcsel before disabling vdda

Felix Fietkau (2):
      mac80211: send ADDBA requests using the tid/queue of the aggregation session
      mac80211: fix regression in SSN handling of addba tx

Florian Fainelli (1):
      net: systemport: Add global locking for descriptor lifecycle

Gal Pressman (1):
      net: Fix double 0x prefix print in SKB dump

George Kennedy (2):
      libata: if T_LENGTH is zero, dma direction should be DMA_NONE
      scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()

Greg Kroah-Hartman (2):
      USB: gadget: bRequestType is a bitfield, not a enum
      Linux 5.4.168

Haimin Zhang (1):
      netdevsim: Zero-initialize memory for new map's value in function nsim_bpf_map_alloc

Hangbin Liu (1):
      selftest/net/forwarding: declare NETIFS p9 p10

Hangyu Hua (1):
      rds: memory leak in __rds_conn_create()

J. Bruce Fields (1):
      nfsd: fix use-after-free due to delegation race

Jerome Marchand (1):
      recordmcount.pl: look for jgnop instruction as well as bcrl on s390

Jie2x Zhou (1):
      selftests: net: Correct ping6 expected rc from 2 to 1

Jimmy Wang (1):
      USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)

Joe Thornber (1):
      dm btree remove: fix use after free in rebalance_children()

Johan Hovold (1):
      USB: serial: cp210x: fix CP2105 GPIO registration

Johannes Berg (6):
      mac80211: mark TX-during-stop for TX in in_reconfig
      mac80211: track only QoS data frames for admission control
      mac80211: agg-tx: don't schedule_and_wake_txq() under sta->lock
      mac80211: accept aggregation sessions on 6 GHz
      mac80211: fix lookup when adding AddBA extension element
      mac80211: validate extended element ID is present

John Keeping (1):
      arm64: dts: rockchip: fix rk3399-leez-p710 vcc3v3-lan supply

Juergen Gross (5):
      xen/blkfront: harden blkfront against event channel storms
      xen/netfront: harden netfront against event channel storms
      xen/console: harden hvc_xen against event channel storms
      xen/netback: fix rx queue stall detection
      xen/netback: don't queue unlimited number of packages

Karen Sornek (1):
      igb: Fix removal of unicast MAC filters of VFs

Le Ma (1):
      drm/amdgpu: correct register access for RLC_JUMP_TABLE_RESTORE

Leon Romanovsky (1):
      net: sched: Fix suspicious RCU usage while accessing tcf_tunnel_info

Letu Ren (1):
      igbvf: fix double free in `igbvf_probe`

Magnus Karlsson (2):
      xsk: Do not sleep in poll() when need_wakeup set
      Revert "xsk: Do not sleep in poll() when need_wakeup set"

Mike Tipton (1):
      clk: Don't parent clks until the parent is fully registered

Miklos Szeredi (2):
      fuse: annotate lock in fuse_reverse_inval_entry()
      ovl: fix warning in ovl_create_real()

Mordechay Goodstein (1):
      mac80211: agg-tx: refactor sending addba

Nathan Chancellor (3):
      soc/tegra: fuse: Fix bitwise vs. logical OR warning
      mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO
      Input: touchscreen - avoid bitwise vs logical OR warning

Nehal Bakulchandra Shah (1):
      usb: xhci: Extend support for runtime power management for AMD's Yellow carp.

Paul E. McKenney (1):
      rcu: Mark accesses to rcu_state.n_force_qs

Paul Moore (1):
      audit: improve robustness of the audit queue handling

Pavel Skripkin (1):
      media: mxl111sf: change mutex_init() location

Philipp Rudo (1):
      s390/kexec_file: fix error handling when applying relocations

Stefan Roese (1):
      PCI/MSI: Mask MSI-X vectors only on success

Sudeep Holla (1):
      firmware: arm_scpi: Fix string overflow in SCPI genpd driver

Thomas Gleixner (1):
      PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error

Vitaly Kuznetsov (1):
      KVM: selftests: Make sure kvm_create_max_vcpus test won't hit RLIMIT_NOFILE

Vlad Buslov (1):
      net: sched: lock action when translating it to flow_action infra

Will Deacon (1):
      virtio_ring: Fix querying of maximum DMA mapping size for virtio device

Willem de Bruijn (1):
      net/packet: rx_owner_map depends on pg_vec

Yu Liao (1):
      timekeeping: Really make sure wall_to_monotonic isn't positive

