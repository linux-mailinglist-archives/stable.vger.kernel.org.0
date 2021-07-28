Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB8E3D89D2
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 10:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhG1Ie0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 04:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235033AbhG1Ie0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 04:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7965260FDA;
        Wed, 28 Jul 2021 08:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627461264;
        bh=BWdaAmMapOYQMF8ZIvZYIL7hIZhg0M6FuqgPptMJbjQ=;
        h=From:To:Cc:Subject:Date:From;
        b=k/asz/7pHGNWvg3m8UyrfBUhbDlyZAuYpm3A7PVQUU7TMdCGzQqdiTUefSWKgUe2p
         3rEjfd8lhPAZouLqH62kb6qZERvlmyEokY7pbiybqSsuLfhKfdYWYx0zd2rT+/GpkK
         Cdv6ptGAcgCHsJZ+ISoJWMkIH8V4ehvKI6BcVKeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.277
Date:   Wed, 28 Jul 2021 10:34:19 +0200
Message-Id: <162746125964102@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.277 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/boot/dts/bcm63138.dtsi                    |    2 
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts         |    4 
 arch/arm/boot/dts/bcm7445.dtsi                     |    2 
 arch/arm/boot/dts/bcm963138dvt.dts                 |    4 
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |    5 -
 arch/arm/boot/dts/rk3036-kylin.dts                 |    2 
 arch/arm/boot/dts/rk3288.dtsi                      |   10 +-
 arch/arm/boot/dts/stm32f429.dtsi                   |    2 
 arch/arm/mach-imx/suspend-imx53.S                  |    4 
 arch/arm64/boot/dts/arm/juno-base.dtsi             |    6 -
 arch/mips/include/asm/pgalloc.h                    |   10 --
 arch/powerpc/kvm/book3s_rtas.c                     |   25 +++++
 arch/s390/include/asm/ftrace.h                     |    1 
 arch/s390/kernel/ftrace.c                          |    2 
 arch/s390/kernel/mcount.S                          |    4 
 arch/s390/net/bpf_jit_comp.c                       |    2 
 drivers/iio/accel/bma180.c                         |   75 +++++++++++------
 drivers/media/pci/ngene/ngene-core.c               |    2 
 drivers/media/pci/ngene/ngene.h                    |   14 +--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   21 +---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    6 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |    1 
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |    1 
 drivers/net/ethernet/intel/i40evf/i40evf_main.c    |    1 
 drivers/net/ethernet/intel/igb/igb_main.c          |   10 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    1 
 drivers/net/ethernet/moxa/moxart_ether.c           |    4 
 drivers/net/ethernet/qualcomm/emac/emac.c          |    3 
 drivers/net/ethernet/ti/tlan.c                     |    3 
 drivers/reset/reset-ti-syscon.c                    |    4 
 drivers/rtc/rtc-max77686.c                         |    4 
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 
 drivers/scsi/scsi_transport_iscsi.c                |   90 +++++++--------------
 drivers/spi/spi-mt65xx.c                           |   16 +++
 drivers/target/target_core_sbc.c                   |   35 +++-----
 drivers/thermal/thermal_core.c                     |    2 
 drivers/usb/core/hub.c                             |   68 +++++++++++++--
 drivers/usb/core/quirks.c                          |    4 
 drivers/usb/host/max3421-hcd.c                     |   44 +++-------
 drivers/usb/host/xhci-hub.c                        |    3 
 drivers/usb/renesas_usbhs/fifo.c                   |    7 +
 drivers/usb/serial/cp210x.c                        |    5 -
 drivers/usb/serial/option.c                        |    3 
 drivers/usb/storage/unusual_uas.h                  |    7 +
 fs/btrfs/inode.c                                   |    2 
 fs/proc/base.c                                     |    2 
 include/net/dst_metadata.h                         |    4 
 include/net/ip6_route.h                            |    2 
 kernel/sched/fair.c                                |    4 
 kernel/trace/ring_buffer.c                         |   28 +++++-
 net/bridge/br_if.c                                 |   17 +++
 net/caif/caif_socket.c                             |    3 
 net/decnet/af_decnet.c                             |   27 ++----
 net/ipv4/tcp_ipv4.c                                |    4 
 net/ipv4/tcp_output.c                              |    1 
 net/ipv6/tcp_ipv6.c                                |   19 +++-
 net/ipv6/xfrm6_output.c                            |    2 
 net/netrom/nr_timer.c                              |   20 ++--
 scripts/mkcompile_h                                |   14 ++-
 sound/isa/sb/sb16_csp.c                            |    4 
 tools/perf/tests/bpf.c                             |    2 
 tools/perf/util/lzma.c                             |    8 +
 tools/perf/util/probe-file.c                       |    4 
 64 files changed, 415 insertions(+), 275 deletions(-)

Aleksandr Loktionov (1):
      igb: Check if num of q_vectors is smaller than max before array access

Alexandre Torgue (1):
      ARM: dts: stm32: fix RCC node name on stm32f429 MCU

Christophe JAILLET (5):
      ixgbe: Fix an error handling path in 'ixgbe_probe()'
      igb: Fix an error handling path in 'igb_probe()'
      fm10k: Fix an error handling path in 'fm10k_probe()'
      e1000e: Fix an error handling path in 'e1000_probe()'
      iavf: Fix an error handling path in 'iavf_probe()'

Colin Ian King (2):
      scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8
      s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]

David Sterba (1):
      btrfs: compression: don't try to compress if we don't have enough pages

Dmitry Bogdanov (1):
      scsi: target: Fix protect handling in WRITE SAME(32)

Doug Berger (1):
      net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear

Elaine Zhang (1):
      ARM: dts: rockchip: Fix power-controller node names for rk3288

Eric Dumazet (2):
      tcp: annotate data races around tp->mtu_info
      ipv6: tcp: drop silly ICMPv6 packet too big messages

Florian Fainelli (1):
      net: bcmgenet: Ensure all TX/RX queues DMAs are disabled

Greg Kroah-Hartman (1):
      Linux 4.9.277

Gustavo A. R. Silva (1):
      media: ngene: Fix out-of-bounds bug in ngene_command_config_free_buf()

Haoran Luo (1):
      tracing: Fix bug in rb_per_cpu_empty() that might cause deadloop.

Huang Pei (1):
      Revert "MIPS: add PMD table accounting into MIPS'pmd_alloc_one"

Ian Ray (1):
      USB: serial: cp210x: fix comments for GE CS1000

Johan Jonker (1):
      ARM: dts: rockchip: fix pinctrl sleep nodename for rk3036-kylin and rk3288

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

Mark Tomlinson (1):
      usb: max-3421: Prevent corruption of freed memory

Mathias Nyman (2):
      xhci: Fix lost USB 2 remote wake
      usb: hub: Disable USB 3 device initiated lpm if exit latency is too high

Matthias Maennich (1):
      kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set

Mike Christie (1):
      scsi: iscsi: Fix iface sysfs attr detection

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

Peter Hess (1):
      spi: mediatek: fix fifo rx mode

Philipp Zabel (1):
      reset: ti-syscon: fix to_ti_syscon_reset_data macro

Primoz Fiser (1):
      ARM: dts: imx6: phyFLEX: Fix UART hardware flow control

Rafał Miłecki (2):
      ARM: brcmstb: dts: fix NAND nodes names
      ARM: dts: BCM63xx: Fix NAND nodes names

Riccardo Mancini (3):
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

Vasily Gorbik (1):
      s390/ftrace: fix ftrace_update_ftrace_func implementation

Vincent Palatin (1):
      Revert "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem"

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

