Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41153D8C01
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 12:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhG1KjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 06:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232514AbhG1KjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 06:39:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BA7C60C3F;
        Wed, 28 Jul 2021 10:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627468738;
        bh=gPDeIvHPJ8eH5JJbqZl4/8dOs7KM/rcyo324ShSe724=;
        h=From:To:Cc:Subject:Date:From;
        b=DFUNI+nAW3X9qES5zE5p2ugYAP+P6VndjRG94dzye0iYJUH2AoIlu9Nt32DlKSPMT
         m+FqY0jr+Zd6BHHiNJyj7KGB3tb2e8v8clw+beBTuftNWaKevz1d+oAj5y9exPStfe
         pGNxom8OTJb2MAxh8qq0CKgmfhuMN275IybxfM7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.241
Date:   Wed, 28 Jul 2021 12:38:55 +0200
Message-Id: <16274687349916@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.241 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/boot/dts/bcm-cygnus.dtsi                       |    2 
 arch/arm/boot/dts/bcm-nsp.dtsi                          |    2 
 arch/arm/boot/dts/bcm63138.dtsi                         |    2 
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts              |    4 
 arch/arm/boot/dts/bcm7445.dtsi                          |    2 
 arch/arm/boot/dts/bcm911360_entphn.dts                  |    4 
 arch/arm/boot/dts/bcm958300k.dts                        |    4 
 arch/arm/boot/dts/bcm958305k.dts                        |    4 
 arch/arm/boot/dts/bcm958522er.dts                       |    4 
 arch/arm/boot/dts/bcm958525er.dts                       |    4 
 arch/arm/boot/dts/bcm958525xmc.dts                      |    4 
 arch/arm/boot/dts/bcm958622hr.dts                       |    4 
 arch/arm/boot/dts/bcm958623hr.dts                       |    4 
 arch/arm/boot/dts/bcm958625hr.dts                       |    4 
 arch/arm/boot/dts/bcm958625k.dts                        |    4 
 arch/arm/boot/dts/bcm963138dvt.dts                      |    4 
 arch/arm/boot/dts/bcm988312hr.dts                       |    4 
 arch/arm/boot/dts/gemini.dtsi                           |    1 
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi            |    5 
 arch/arm/boot/dts/rk3036-kylin.dts                      |    2 
 arch/arm/boot/dts/rk3188.dtsi                           |    8 -
 arch/arm/boot/dts/rk3288.dtsi                           |   14 +-
 arch/arm/boot/dts/stm32f429.dtsi                        |    2 
 arch/arm/mach-imx/suspend-imx53.S                       |    4 
 arch/arm64/boot/dts/arm/juno-base.dtsi                  |    6 -
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi          |    1 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi                |    6 -
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                |    2 
 arch/mips/include/asm/pgalloc.h                         |   10 -
 arch/powerpc/kvm/book3s_rtas.c                          |   25 +++-
 arch/s390/include/asm/ftrace.h                          |    1 
 arch/s390/kernel/ftrace.c                               |    2 
 arch/s390/kernel/mcount.S                               |    4 
 arch/s390/net/bpf_jit_comp.c                            |    2 
 drivers/dma-buf/sync_file.c                             |   13 +-
 drivers/gpu/drm/drm_ioctl.c                             |    3 
 drivers/iio/accel/bma180.c                              |   75 ++++++++-----
 drivers/media/pci/ngene/ngene-core.c                    |    2 
 drivers/media/pci/ngene/ngene.h                         |   14 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c          |   22 +--
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c      |    6 -
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c              |    1 
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c            |    1 
 drivers/net/ethernet/intel/i40evf/i40evf_main.c         |    1 
 drivers/net/ethernet/intel/igb/igb_main.c               |   12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c           |    4 
 drivers/net/ethernet/moxa/moxart_ether.c                |    4 
 drivers/net/ethernet/qualcomm/emac/emac.c               |    3 
 drivers/net/ethernet/ti/tlan.c                          |    3 
 drivers/reset/reset-ti-syscon.c                         |    4 
 drivers/rtc/rtc-max77686.c                              |    4 
 drivers/scsi/aic7xxx/aic7xxx_core.c                     |    2 
 drivers/scsi/libfc/fc_rport.c                           |   13 +-
 drivers/scsi/scsi_transport_iscsi.c                     |   90 ++++++----------
 drivers/spi/spi-cadence.c                               |   14 +-
 drivers/spi/spi-fsl-dspi.c                              |    4 
 drivers/spi/spi-mt65xx.c                                |   16 ++
 drivers/target/target_core_sbc.c                        |   35 +++---
 drivers/thermal/thermal_core.c                          |    2 
 drivers/usb/core/hub.c                                  |   68 +++++++++---
 drivers/usb/core/quirks.c                               |    4 
 drivers/usb/dwc2/gadget.c                               |   10 +
 drivers/usb/host/max3421-hcd.c                          |   44 ++-----
 drivers/usb/host/xhci-hub.c                             |    3 
 drivers/usb/host/xhci-ring.c                            |   58 ++++++++--
 drivers/usb/host/xhci.h                                 |    3 
 drivers/usb/renesas_usbhs/fifo.c                        |    7 +
 drivers/usb/serial/cp210x.c                             |    5 
 drivers/usb/serial/option.c                             |    3 
 drivers/usb/storage/unusual_uas.h                       |    7 +
 fs/btrfs/inode.c                                        |    2 
 fs/proc/base.c                                          |    2 
 include/drm/drm_ioctl.h                                 |    1 
 include/net/dst_metadata.h                              |    4 
 include/net/ip6_route.h                                 |    2 
 kernel/sched/fair.c                                     |    4 
 kernel/trace/ring_buffer.c                              |   28 ++++
 net/bridge/br_if.c                                      |   17 ++-
 net/caif/caif_socket.c                                  |    3 
 net/decnet/af_decnet.c                                  |   27 ++--
 net/ipv4/tcp_ipv4.c                                     |    4 
 net/ipv4/tcp_output.c                                   |    1 
 net/ipv6/tcp_ipv6.c                                     |   22 +++
 net/ipv6/xfrm6_output.c                                 |    2 
 net/netfilter/nf_conntrack_netlink.c                    |    3 
 net/netrom/nr_timer.c                                   |   20 +--
 scripts/mkcompile_h                                     |   14 +-
 sound/isa/sb/sb16_csp.c                                 |    4 
 tools/perf/tests/bpf.c                                  |    2 
 tools/perf/util/lzma.c                                  |    8 -
 tools/perf/util/map.c                                   |    2 
 tools/perf/util/probe-event.c                           |    4 
 tools/perf/util/probe-file.c                            |    4 
 tools/testing/selftests/vm/userfaultfd.c                |    6 -
 96 files changed, 554 insertions(+), 351 deletions(-)

Aleksandr Loktionov (1):
      igb: Check if num of q_vectors is smaller than max before array access

Alexander Ovechkin (1):
      net: send SYNACK packet with accepted fwmark

Alexandre Torgue (1):
      ARM: dts: stm32: fix RCC node name on stm32f429 MCU

Charles Baylis (1):
      drm: Return -ENOTTY for non-drm ioctls

Christophe JAILLET (6):
      ixgbe: Fix an error handling path in 'ixgbe_probe()'
      igb: Fix an error handling path in 'igb_probe()'
      fm10k: Fix an error handling path in 'fm10k_probe()'
      e1000e: Fix an error handling path in 'e1000_probe()'
      iavf: Fix an error handling path in 'iavf_probe()'
      spi: spi-fsl-dspi: Fix a resource leak in an error handling path

Colin Ian King (3):
      scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8
      liquidio: Fix unintentional sign extension issue on left shift of u16
      s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]

Corentin Labbe (1):
      ARM: dts: gemini: add device_type on pci

David Sterba (1):
      btrfs: compression: don't try to compress if we don't have enough pages

Dmitry Bogdanov (1):
      scsi: target: Fix protect handling in WRITE SAME(32)

Doug Berger (1):
      net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear

Elaine Zhang (2):
      ARM: dts: rockchip: Fix power-controller node names for rk3288
      arm64: dts: rockchip: Fix power-controller node names for rk3328

Eric Dumazet (2):
      tcp: annotate data races around tp->mtu_info
      ipv6: tcp: drop silly ICMPv6 packet too big messages

Ezequiel Garcia (1):
      ARM: dts: rockchip: Fix the timer clocks order

Florian Fainelli (1):
      net: bcmgenet: Ensure all TX/RX queues DMAs are disabled

Greg Kroah-Hartman (1):
      Linux 4.14.241

Gustavo A. R. Silva (1):
      media: ngene: Fix out-of-bounds bug in ngene_command_config_free_buf()

Haoran Luo (1):
      tracing: Fix bug in rb_per_cpu_empty() that might cause deadloop.

Huang Pei (1):
      Revert "MIPS: add PMD table accounting into MIPS'pmd_alloc_one"

Ian Ray (1):
      USB: serial: cp210x: fix comments for GE CS1000

Jason Ekstrand (1):
      dma-buf/sync_file: Don't leak fences on merge failure

Javed Hasan (1):
      scsi: libfc: Fix array index out of bound exception

Johan Jonker (2):
      ARM: dts: rockchip: fix pinctrl sleep nodename for rk3036-kylin and rk3288
      arm64: dts: rockchip: fix pinctrl sleep nodename for rk3399.dtsi

John Keeping (1):
      USB: serial: cp210x: add ID for CEL EM3588 USB ZigBee stick

Jonathan Neuschäfer (1):
      ARM: imx: pm-imx5: Fix references to imx5_cpu_suspend_info

Julian Sikorski (1):
      USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS

Krzysztof Kozlowski (1):
      rtc: max77686: Do not enforce (incorrect) interrupt trigger type

Linus Walleij (1):
      iio: accel: bma180: Use explicit member assignment

Marcelo Henrique Cerri (1):
      proc: Avoid mixing integer types in mem_rw()

Marco De Marco (1):
      USB: serial: option: add support for u-blox LARA-R6 family

Marek Vasut (1):
      spi: cadence: Correct initialisation of runtime PM again

Mark Tomlinson (1):
      usb: max-3421: Prevent corruption of freed memory

Markus Boehme (1):
      ixgbe: Fix packet corruption due to missing DMA sync

Mathias Nyman (3):
      xhci: Fix lost USB 2 remote wake
      usb: hub: Disable USB 3 device initiated lpm if exit latency is too high
      xhci: add xhci_get_virt_ep() helper

Matthias Maennich (1):
      kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set

Mian Yousaf Kaukab (1):
      arm64: dts: ls208xa: remove bus-num from dspi node

Mike Christie (1):
      scsi: iscsi: Fix iface sysfs attr detection

Minas Harutyunyan (1):
      usb: dwc2: gadget: Fix sending zero length packet in DDMA mode.

Nguyen Dinh Phi (1):
      netrom: Decrease sock refcount when sock timers expire

Nicholas Piggin (1):
      KVM: PPC: Book3S: Fix H_RTAS rets buffer overflow

Odin Ugedal (1):
      sched/fair: Fix CFS bandwidth hrtimer expiry type

Pavel Skripkin (3):
      net: moxa: fix UAF in moxart_mac_probe
      net: qcom/emac: fix UAF in emac_remove
      net: ti: fix UAF in tlan_remove_one

Peter Collingbourne (1):
      selftest: use mmap instead of posix_memalign to allocate memory

Peter Hess (1):
      spi: mediatek: fix fifo rx mode

Philipp Zabel (1):
      reset: ti-syscon: fix to_ti_syscon_reset_data macro

Primoz Fiser (1):
      ARM: dts: imx6: phyFLEX: Fix UART hardware flow control

Rafał Miłecki (4):
      ARM: brcmstb: dts: fix NAND nodes names
      ARM: Cygnus: dts: fix NAND nodes names
      ARM: NSP: dts: fix NAND nodes names
      ARM: dts: BCM63xx: Fix NAND nodes names

Riccardo Mancini (5):
      perf map: Fix dso->nsinfo refcounting
      perf probe: Fix dso->nsinfo refcounting
      perf lzma: Close lzma stream on exit
      perf test bpf: Free obj_buf
      perf probe-file: Delete namelist in del_events() on the error path

Stephan Gerhold (1):
      iio: accel: bma180: Fix BMA25x bandwidth register values

Sudeep Holla (1):
      arm64: dts: juno: Update SCPI nodes as per the YAML schema

Taehee Yoo (1):
      net: validate lwtstate->data before returning from skb_tunnel_info()

Takashi Iwai (1):
      ALSA: sb: Fix potential ABBA deadlock in CSP driver

Vadim Fedorenko (1):
      net: ipv6: fix return value of ip6_skb_dst_mtu

Vasily Averin (1):
      netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo

Vasily Gorbik (1):
      s390/ftrace: fix ftrace_update_ftrace_func implementation

Vincent Palatin (1):
      Revert "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem"

Vinicius Costa Gomes (1):
      igb: Fix use-after-free error during reset

Wolfgang Bumiller (1):
      net: bridge: sync fdb to new unicast-filtering ports

Yajun Deng (1):
      net: decnet: Fix sleeping inside in af_decnet

Yang Yingliang (1):
      thermal/core: Correct function name thermal_zone_device_unregister()

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Fix superfluous irqs happen after usb_pkt_pop()

Ziyang Xuan (1):
      net: fix uninit-value in caif_seqpkt_sendmsg

