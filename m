Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCC51ECF47
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 14:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgFCMCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 08:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgFCMCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 08:02:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E302F20738;
        Wed,  3 Jun 2020 12:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591185738;
        bh=bO58SMB1LzQOyXiL2sLw/Za72Wlu+k5XyMTXeWhSOME=;
        h=From:To:Cc:Subject:Date:From;
        b=LQUS283Y4JVcEr+kDQiT/noySfp4KzARokUQnT01JTGyARrbjLOHnU5MCosY8edHh
         4rKq3te8/tZcuzSMmWXI9pfavpPJqytChrCUwxkQ+qBUCjJNzcP/c0wRQQbaS8CURW
         AAVxFwgryqiua1vB+dNrYKtjM9N+vHbBCZQ1sCG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.183
Date:   Wed,  3 Jun 2020 14:02:14 +0200
Message-Id: <1591185734156106@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.183 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts            |    2 
 arch/arm/boot/dts/imx6q-b450v3.dts                  |    7 -
 arch/arm/boot/dts/imx6q-b650v3.dts                  |    7 -
 arch/arm/boot/dts/imx6q-b850v3.dts                  |   11 -
 arch/arm/boot/dts/imx6q-bx50v3.dtsi                 |   77 +++++++++++++
 arch/arm/boot/dts/rk3228-evb.dts                    |    2 
 arch/arm/boot/dts/rk322x.dtsi                       |    4 
 arch/arm/include/asm/assembler.h                    |   83 --------------
 arch/arm/include/asm/uaccess-asm.h                  |  117 ++++++++++++++++++++
 arch/arm/include/asm/vfpmacros.h                    |    8 -
 arch/arm/kernel/entry-armv.S                        |   11 -
 arch/arm/kernel/entry-header.S                      |    9 -
 arch/arm/lib/bitops.h                               |    8 -
 arch/arm64/boot/dts/rockchip/rk3399.dtsi            |    8 -
 arch/parisc/mm/init.c                               |    2 
 arch/x86/include/asm/dma.h                          |    2 
 arch/x86/kernel/fpu/xstate.c                        |   86 ++++++++------
 arch/x86/kvm/vmx.c                                  |    7 -
 drivers/gpio/gpio-exar.c                            |    7 -
 drivers/gpio/gpio-tegra.c                           |    1 
 drivers/infiniband/hw/qib/qib_sysfs.c               |    9 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c      |    2 
 drivers/input/evdev.c                               |   19 ---
 drivers/input/joystick/xpad.c                       |   12 ++
 drivers/input/keyboard/dlink-dir685-touchkeys.c     |    2 
 drivers/input/rmi4/rmi_driver.c                     |    5 
 drivers/input/serio/i8042-x86ia64io.h               |    7 +
 drivers/input/touchscreen/usbtouchscreen.c          |    1 
 drivers/iommu/iommu.c                               |    2 
 drivers/mmc/core/block.c                            |    2 
 drivers/net/bonding/bond_sysfs_slave.c              |    4 
 drivers/net/ethernet/freescale/Kconfig              |    2 
 drivers/net/ethernet/freescale/dpaa/Kconfig         |    1 
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c  |    5 
 drivers/net/ethernet/mellanox/mlx4/fw.c             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c       |   14 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c     |    6 -
 drivers/net/ethernet/microchip/encx24j600.c         |    5 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c |    4 
 drivers/net/ethernet/sun/cassini.c                  |    3 
 drivers/net/usb/cdc_ether.c                         |   11 +
 drivers/net/usb/r8152.c                             |    1 
 drivers/s390/scsi/zfcp_fsf.c                        |   10 +
 drivers/tty/serial/sc16is7xx.c                      |    2 
 drivers/usb/gadget/legacy/inode.c                   |    3 
 fs/binfmt_elf.c                                     |    2 
 fs/cachefiles/rdwr.c                                |    2 
 fs/cifs/file.c                                      |    2 
 fs/gfs2/quota.c                                     |    3 
 fs/gfs2/quota.h                                     |    3 
 include/asm-generic/topology.h                      |    2 
 include/linux/mlx5/driver.h                         |    1 
 include/linux/mm.h                                  |   15 ++
 include/linux/netfilter/nf_conntrack_pptp.h         |    2 
 include/net/act_api.h                               |    3 
 include/uapi/linux/xfrm.h                           |    2 
 kernel/irq/migration.c                              |   26 +++-
 mm/vmalloc.c                                        |    2 
 net/ax25/af_ax25.c                                  |    6 -
 net/bridge/netfilter/nft_reject_bridge.c            |    6 +
 net/ceph/osd_client.c                               |    4 
 net/ipv4/ip_vti.c                                   |   75 ++++++------
 net/ipv4/ipip.c                                     |    2 
 net/ipv4/netfilter/nf_nat_pptp.c                    |    7 -
 net/ipv4/route.c                                    |   14 +-
 net/ipv6/esp6_offload.c                             |    9 +
 net/mac80211/mesh_hwmp.c                            |    7 +
 net/netfilter/ipset/ip_set_list_set.c               |    2 
 net/netfilter/nf_conntrack_pptp.c                   |   62 +++++-----
 net/netfilter/nfnetlink_cthelper.c                  |    3 
 net/qrtr/qrtr.c                                     |    2 
 net/rxrpc/local_object.c                            |   23 ++-
 net/sctp/sm_statefuns.c                             |    9 -
 net/xfrm/xfrm_input.c                               |    2 
 net/xfrm/xfrm_output.c                              |   15 +-
 net/xfrm/xfrm_policy.c                              |    7 -
 samples/bpf/lwt_len_hist_user.c                     |    2 
 security/commoncap.c                                |    1 
 sound/core/hwdep.c                                  |    4 
 sound/pci/hda/patch_realtek.c                       |    3 
 sound/usb/mixer.c                                   |    8 +
 82 files changed, 580 insertions(+), 353 deletions(-)

Al Viro (1):
      copy_xstate_to_kernel(): don't leave parts of destination uninitialized

Alexander Dahl (1):
      x86/dma: Fix max PFN arithmetic overflow on 32 bit systems

Alexander Potapenko (1):
      fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

Antony Antony (1):
      xfrm: fix error in comment

Arnd Bergmann (2):
      net: freescale: select CONFIG_FIXED_PHY where needed
      include/asm-generic/topology.h: guard cpumask_of_node() macro argument

Benjamin Block (1):
      scsi: zfcp: fix request object use-after-free in send path causing wrong traces

Bob Peterson (1):
      gfs2: move privileged user check to gfs2_quota_lock_check

Brendan Shanks (1):
      Input: evdev - call input_flush_device() on release(), not flush()

Changming Liu (1):
      ALSA: hwdep: fix a left shifting 1 by 31 UB bug

Chris Chiu (1):
      ALSA: usb-audio: mixer: volume quirk for ESS Technology Asus USB DAC

Christophe JAILLET (1):
      Input: dlink-dir685-touchkeys - fix a typo in driver name

Chuhong Yuan (1):
      net: microchip: encx24j600: add missed kthread_stop

Colin Ian King (1):
      net: hns: fix unsigned comparison to less than zero

David Howells (1):
      rxrpc: Fix transport sockopts to get IPv4 errors on an IPv6 socket

Eric Dumazet (1):
      ax25: fix setsockopt(SO_BINDTODEVICE)

Eric W. Biederman (1):
      exec: Always set cap_ambient in cap_bprm_set_creds

Evan Green (1):
      Input: synaptics-rmi4 - really fix attn_data use-after-free

Greg Kroah-Hartman (1):
      Linux 4.14.183

Guoqing Jiang (1):
      sc16is7xx: move label 'err_spi' to correct section

Helge Deller (1):
      parisc: Fix kernel panic in mem_init()

James Hilliard (1):
      Input: usbtouchscreen - add support for BonXeon TP

Jere Leppänen (1):
      sctp: Start shutdown on association restart if in SHUTDOWN-SENT state and socket is closed

Jeremy Sowden (1):
      vti4: eliminated some duplicate code.

Jerry Lee (1):
      libceph: ignore pool overlay and cache logic on redirects

Johan Jonker (3):
      ARM: dts: rockchip: fix phy nodename for rk3228-evb
      arm64: dts: rockchip: swap interrupts interrupt-names rk3399 gpu node
      ARM: dts: rockchip: fix pinctrl sub nodename for spi in rk322x.dtsi

Kaike Wan (1):
      IB/qib: Call kobject_put() when kobject_init_and_add() fails

Kailang Yang (1):
      ALSA: hda/realtek - Add new codec supported for ALC287

Kevin Locke (1):
      Input: i8042 - add ThinkPad S230u to i8042 reset list

Konstantin Khlebnikov (1):
      mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

Lei Xue (1):
      cachefiles: Fix race between read_waiter and read_copier involving op->to_do

Linus Lüssing (1):
      mac80211: mesh: fix discovery timer re-arming issue / crash

Liviu Dudau (1):
      mm/vmalloc.c: don't dereference possible NULL pointer in __vunmap()

Manivannan Sadhasivam (1):
      net: qrtr: Fix passing invalid reference to qrtr_local_enqueue()

Marc Payne (1):
      r8152: support additional Microsoft Surface Ethernet Adapter variant

Masahiro Yamada (1):
      usb: gadget: legacy: fix redundant initialization warnings

Matteo Croce (1):
      samples: bpf: Fix build error

Michael Braun (1):
      netfilter: nft_reject_bridge: enable reject with bridge vlan

Moshe Shemesh (2):
      net/mlx5: Add command entry handling completion
      net/mlx5e: Update netdev txq on completions during closure

Pablo Neira Ayuso (3):
      netfilter: nfnetlink_cthelper: unbreak userspace helper support
      netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code
      netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build

Peng Hao (1):
      mmc: block: Fix use-after-free issue for rpmb

Phil Sutter (1):
      netfilter: ipset: Fix subcounter update skip

Qiushi Wu (6):
      net: sun: fix missing release regions in cas_init_one().
      net/mlx4_core: fix a memory leak bug.
      RDMA/pvrdma: Fix missing pci disable in pvrdma_pci_probe()
      iommu: Fix reference count leak in iommu_group_alloc.
      qlcnic: fix missing release in qlcnic_83xx_interrupt_test.
      bonding: Fix reference count leak in bond_sysfs_slave_add.

Robert Beckett (1):
      ARM: dts/imx6q-bx50v3: Set display interface clock parents

Roman Mashak (1):
      net sched: fix reporting the first-time use timestamp

Russell King (3):
      ARM: uaccess: consolidate uaccess asm to asm/uaccess-asm.h
      ARM: uaccess: integrate uaccess_save and uaccess_restore
      ARM: uaccess: fix DACR mismatch with nested exceptions

Salil Mehta (1):
      net: hns: Fixes the missing put_device in positive leg for roce reset

Sean Christopherson (1):
      KVM: VMX: check for existence of secondary exec controls before accessing

Sebastian Reichel (1):
      ARM: dts: imx6q-bx50v3: Add internal switch

Stefan Agner (1):
      ARM: 8843/1: use unified assembler in headers

Stephen Warren (1):
      gpio: tegra: mask GPIO IRQs during IRQ shutdown

Steve French (1):
      cifs: Fix null pointer check in cifs_read

Takashi Iwai (1):
      gpio: exar: Fix bad handling for ida_simple_get error path

Thomas Gleixner (1):
      genirq/generic_pending: Do not lose pending affinity update

Vadim Fedorenko (1):
      net: ipip: fix wrong address family in init error path

Vincent Stehlé (1):
      ARM: dts: bcm2835-rpi-zero-w: Fix led polarity

Wei Yongjun (1):
      Input: synaptics-rmi4 - fix error return code in rmi_driver_probe()

Xin Long (6):
      xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
      xfrm: call xfrm_output_gso when inner_protocol is set in xfrm_output
      xfrm: fix a warning in xfrm_policy_insert_list
      xfrm: fix a NULL-ptr deref in xfrm_local_error
      ip_vti: receive ipip packet by calling ip_tunnel_rcv
      esp6: get the right proto for transport mode in esp6_gso_encap

Yuqi Jin (1):
      net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"

Łukasz Patron (1):
      Input: xpad - add custom init packet for Xbox One S controllers

