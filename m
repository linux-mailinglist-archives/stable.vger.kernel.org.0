Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDAB3B1B18
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 15:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhFWNbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 09:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhFWNbk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 09:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A869D60FEE;
        Wed, 23 Jun 2021 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624454962;
        bh=KUcTHJvM5KrEOW4TXgHuCfvQUTDDaKvtVTnLML9Vs3s=;
        h=From:To:Cc:Subject:Date:From;
        b=nBbKR5LHa1/CxCdkdNddm67O7MrDBe71CkDhZ2oiVh5yQYZMuXEu6A144jKHEuY4e
         3mFgET6ujA68vK13BGvvsAqHdWaQ1r4PeGLHBlI9kLi8LO0AiNNPRetlHndDLkpXZT
         JK1+9pv8Aq9+3WDtv1M6ynZRzFe5bBvWelnp3ZFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.128
Date:   Wed, 23 Jun 2021 15:29:18 +0200
Message-Id: <162445495872219@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.128 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/vm/slub.rst                                |   10 
 Makefile                                                 |    2 
 arch/arc/include/uapi/asm/sigcontext.h                   |    1 
 arch/arc/kernel/signal.c                                 |   43 +++
 arch/arm/boot/dts/dra7-l4.dtsi                           |    4 
 arch/arm/boot/dts/dra7.dtsi                              |   20 +
 arch/arm/mach-omap1/pm.c                                 |   13 -
 arch/arm/mach-omap1/time.c                               |   10 
 arch/arm/mach-omap1/timer32k.c                           |   10 
 arch/arm/mach-omap2/board-generic.c                      |    4 
 arch/arm/mach-omap2/timer.c                              |  181 ++++++++++-----
 arch/x86/include/asm/fpu/internal.h                      |   13 -
 arch/x86/kernel/fpu/signal.c                             |   26 +-
 arch/x86/kvm/lapic.c                                     |    3 
 arch/x86/kvm/x86.c                                       |    5 
 drivers/clk/ti/clk-7xx.c                                 |    1 
 drivers/dma/Kconfig                                      |    1 
 drivers/dma/pl330.c                                      |    6 
 drivers/dma/qcom/Kconfig                                 |    1 
 drivers/dma/ste_dma40.c                                  |    3 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                   |    6 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                    |    6 
 drivers/gpu/drm/radeon/radeon_uvd.c                      |    4 
 drivers/hwmon/scpi-hwmon.c                               |    9 
 drivers/net/can/usb/mcba_usb.c                           |   17 +
 drivers/net/ethernet/atheros/alx/main.c                  |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                |    6 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c        |    2 
 drivers/net/ethernet/ec_bhf.c                            |    4 
 drivers/net/ethernet/emulex/benet/be_main.c              |    1 
 drivers/net/ethernet/freescale/fec_ptp.c                 |    8 
 drivers/net/ethernet/lantiq_xrx200.c                     |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c        |    8 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c          |    2 
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c           |    3 
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c       |   30 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c     |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c         |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h          |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c    |    2 
 drivers/net/ethernet/xilinx/ll_temac_main.c              |    8 
 drivers/net/hamradio/mkiss.c                             |    1 
 drivers/net/usb/cdc_eem.c                                |    2 
 drivers/net/usb/cdc_ncm.c                                |    2 
 drivers/net/usb/smsc75xx.c                               |   10 
 drivers/net/vrf.c                                        |    6 
 drivers/pci/controller/pci-aardvark.c                    |   59 +++-
 drivers/pci/quirks.c                                     |   89 +++++++
 drivers/ptp/ptp_clock.c                                  |    6 
 drivers/spi/spi-stm32-qspi.c                             |    5 
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c          |    2 
 drivers/usb/core/hub.c                                   |    7 
 drivers/usb/dwc3/core.c                                  |    2 
 drivers/usb/dwc3/debug.h                                 |    3 
 drivers/usb/dwc3/debugfs.c                               |   21 -
 drivers/usb/dwc3/gadget.c                                |    3 
 fs/afs/main.c                                            |    4 
 include/linux/cpuhotplug.h                               |    1 
 include/linux/mfd/rohm-bd70528.h                         |    4 
 include/linux/mlx5/transobj.h                            |    1 
 include/linux/ptp_clock_kernel.h                         |    2 
 include/linux/socket.h                                   |    2 
 include/net/net_namespace.h                              |    7 
 include/uapi/linux/in.h                                  |    3 
 kernel/trace/trace.c                                     |   11 
 kernel/trace/trace_clock.c                               |    6 
 mm/memory-failure.c                                      |    7 
 mm/slab_common.c                                         |    3 
 mm/slub.c                                                |   23 +
 net/batman-adv/bat_iv_ogm.c                              |    4 
 net/bridge/br_private.h                                  |    4 
 net/bridge/br_vlan_tunnel.c                              |   38 +--
 net/can/bcm.c                                            |   62 ++++-
 net/can/j1939/transport.c                                |   54 +++-
 net/can/raw.c                                            |   62 +++--
 net/core/net_namespace.c                                 |   12 
 net/core/rtnetlink.c                                     |    8 
 net/ipv4/cipso_ipv4.c                                    |    1 
 net/ipv4/icmp.c                                          |    7 
 net/ipv4/igmp.c                                          |    1 
 net/ipv4/udp.c                                           |   10 
 net/ipv6/udp.c                                           |    3 
 net/netfilter/nf_synproxy_core.c                         |    5 
 net/qrtr/qrtr.c                                          |    2 
 net/rds/recv.c                                           |    2 
 net/sched/act_ct.c                                       |   21 +
 net/sched/sch_cake.c                                     |    6 
 net/socket.c                                             |   13 -
 net/unix/af_unix.c                                       |    7 
 net/wireless/Makefile                                    |    2 
 net/wireless/pmsr.c                                      |   16 +
 sound/soc/codecs/rt5659.c                                |   26 +-
 tools/include/uapi/linux/in.h                            |    3 
 virt/kvm/arm/vgic/vgic-kvm-device.c                      |    4 
 95 files changed, 839 insertions(+), 319 deletions(-)

Aleksander Jan Bajkowski (2):
      net: lantiq: disable interrupt before sheduling NAPI
      lantiq: net: fix duplicated skb in rx descriptor ring

Andrew Lunn (1):
      usb: core: hub: Disable autosuspend for Cypress CY7C65632

Andrew Morton (1):
      mm/slub.c: include swab.h

Antti Järvinen (1):
      PCI: Mark TI C667X to avoid bus reset

Arnaldo Carvalho de Melo (1):
      tools headers UAPI: Sync linux/in.h copy with the kernel sources

Avraham Stern (1):
      cfg80211: avoid double free of PMSR request

Axel Lin (1):
      regulator: bd70528: Fix off-by-one for buck123 .n_voltages setting

Aya Levin (1):
      net/mlx5e: Block offload of outer header csum for UDP tunnels

Bumyong Lee (1):
      dmaengine: pl330: fix wrong usage of spinlock flags in dma_cyclc

Changbin Du (1):
      net: make get_net_ns return error if NET_NS is disabled

Chen Li (1):
      radeon: use memcpy_to/fromio for UVD fw upload

Chengyang Fan (1):
      net: ipv4: fix memory leak in ip_mc_add1_src

Chiqijun (1):
      PCI: Work around Huawei Intelligent NIC VF FLR erratum

Christophe JAILLET (4):
      alx: Fix an error handling path in 'alx_probe()'
      qlcnic: Fix an error handling path in 'qlcnic_probe()'
      netxen_nic: Fix an error handling path in 'netxen_nic_probe()'
      be2net: Fix an error handling path in 'be_probe()'

Dan Carpenter (1):
      afs: Fix an IS_ERR() vs NULL check

Davide Caratti (1):
      net/mlx5e: allow TSO on VXLAN over VLAN topologies

Dima Chumak (1):
      net/mlx5e: Fix page reclaim for dead peer hairpin

Dongliang Mu (1):
      net: usb: fix possible use-after-free in smsc75xx_bind

Eric Auger (1):
      KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read

Eric Dumazet (1):
      net/af_unix: fix a data-race in unix_dgram_sendmsg / unix_release_sock

Esben Haabendal (2):
      net: ll_temac: Make sure to free skb when it is completely used
      net: ll_temac: Fix TX BD buffer overwrite

Fugang Duan (1):
      net: fec_ptp: add clock rate zero check

Greg Kroah-Hartman (1):
      Linux 5.4.128

Huy Nguyen (1):
      net/mlx5e: Remove dependency in IPsec initialization flows

Ido Schimmel (1):
      rtnetlink: Fix regression in bridge VLAN configuration

Jack Pham (1):
      usb: dwc3: debugfs: Add and remove endpoint dirs dynamically

Jack Yu (1):
      ASoC: rt5659: Fix the lost powers for the HDA header

Jakub Kicinski (1):
      ptp: improve max_adj check against unreasonable values

Jim Mattson (1):
      kvm: LAPIC: Restore guard to prevent illegal APIC register access

Jisheng Zhang (1):
      net: stmmac: dwmac1000: Fix extended MAC address registers definition

Joakim Zhang (2):
      net: fec_ptp: fix issue caused by refactor the fec_devtype
      net: stmmac: disable clocks in stmmac_remove_config_dt()

Johannes Berg (1):
      cfg80211: make certificate generation more robust

Kees Cook (2):
      mm/slub: clarify verification reporting
      mm/slub: fix redzoning for small allocations

Linyu Yuan (1):
      net: cdc_eem: fix tx fixup skb leak

Maciej Żenczykowski (1):
      net: cdc_ncm: switch to eth%d interface naming

Maor Gottlieb (1):
      net/mlx5: Consider RoCE cap before init RDMA resources

Marcelo Ricardo Leitner (1):
      net/sched: act_ct: handle DNAT tuple collision

Maxim Mikityanskiy (2):
      netfilter: synproxy: Fix out of bounds when parsing TCP options
      sch_cake: Fix out of bounds when parsing TCP options and header

Michael Chan (1):
      bnxt_en: Rediscover PHY capabilities after firmware reset

Nanyong Sun (1):
      net: ipv4: fix memory leak in netlbl_cipsov4_add_std

Nicolas Dichtel (1):
      vrf: fix maximum MTU

Nikolay Aleksandrov (2):
      net: bridge: fix vlan tunnel dst null pointer dereference
      net: bridge: fix vlan tunnel dst refcnt when egressing

Norbert Slusarek (1):
      can: bcm: fix infoleak in struct bcm_msg_head

Oleksij Rempel (1):
      can: j1939: fix Use-after-Free, hold skb ref while in use

Pali Rohár (1):
      PCI: aardvark: Fix kernel panic during PIO transfer

Paolo Abeni (1):
      udp: fix race between close() and udp_abort()

Patrice Chotard (1):
      spi: stm32-qspi: Always wait BUSY bit to be cleared in stm32_qspi_wait_cmd()

Pavel Machek (1):
      cxgb4: fix wrong shift.

Pavel Skripkin (5):
      net: rds: fix memory leak in rds_recvmsg
      net: qrtr: fix OOB Read in qrtr_endpoint_post
      net: hamradio: fix memory leak in mkiss_close
      net: ethernet: fix potential use-after-free in ec_bhf_remove
      can: mcba_usb: fix memory leak in mcba_usb

Peter Chen (1):
      usb: dwc3: core: fix kernel panic when do reboot

Randy Dunlap (2):
      dmaengine: ALTERA_MSGDMA depends on HAS_IOMEM
      dmaengine: QCOM_HIDMA_MGMT depends on HAS_IOMEM

Remi Pommarel (1):
      PCI: aardvark: Don't rely on jiffies while holding spinlock

Riwen Lu (1):
      hwmon: (scpi-hwmon) shows the negative temperature properly

Sean Christopherson (1):
      KVM: x86: Immediately reset the MMU context when the SMM flag is cleared

Sergio Paracuellos (1):
      pinctrl: ralink: rt2880: avoid to error in calls is pin is already enabled

Shanker Donthineni (1):
      PCI: Mark some NVIDIA GPUs to avoid bus reset

Somnath Kotur (1):
      bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path

Sriharsha Basavapatna (1):
      PCI: Add ACS quirk for Broadcom BCM57414 NIC

Steven Rostedt (VMware) (3):
      tracing: Do not stop recording cmdlines when tracing is off
      tracing: Do not stop recording comms if the trace file is being read
      tracing: Do no increment trace_clock_global() by one

Sven Eckelmann (1):
      batman-adv: Avoid WARN_ON timing related checks

Tetsuo Handa (1):
      can: bcm/raw/isotp: use per module netdevice notifier

Thomas Gleixner (3):
      x86/process: Check PF_KTHREAD and not current->mm for kernel threads
      x86/pkru: Write hardware init value to PKRU when xstate is init
      x86/fpu: Reset state for all signal restore failures

Toke Høiland-Jørgensen (1):
      icmp: don't send out ICMP messages with a source address of 0.0.0.0

Tony Lindgren (3):
      clocksource/drivers/timer-ti-dm: Add clockevent and clocksource support
      clocksource/drivers/timer-ti-dm: Prepare to handle dra7 timer wrap issue
      clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940

Vineet Gupta (1):
      ARCv2: save ABI registers across signal handling

Yang Yingliang (1):
      dmaengine: stedma40: add missing iounmap() on error in d40_probe()

Yifan Zhang (2):
      drm/amdgpu/gfx10: enlarge CP_MEC_DOORBELL_RANGE_UPPER to cover full doorbell.
      drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue.

afzal mohammed (1):
      ARM: OMAP: replace setup_irq() by request_irq()

yangerkun (1):
      mm/memory-failure: make sure wait for page writeback in memory_failure

