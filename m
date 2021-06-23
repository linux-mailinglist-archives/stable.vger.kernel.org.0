Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213743B1B1B
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 15:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFWNbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 09:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhFWNbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 09:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25F9561003;
        Wed, 23 Jun 2021 13:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624454969;
        bh=A0cks2LYJyHlD2XMX8c81gdsoGVtyM40sx/K8RKU9o0=;
        h=From:To:Cc:Subject:Date:From;
        b=YnQhEM8URundif9qJPJ1CTNFAv5xqQzPKmLeCMm04nrvft9uKcdLjGVa34u9nm3wH
         QgPCvuQeW7ZlW1HK/Qnb4QGa0loOPEW1tG9licyjlQ9OnjwbXBo1u0VNNjVni/acqW
         1+lQ1J5YwJ+Kam48t8cr9b95JaYPJttqMWlIYsng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.46
Date:   Wed, 23 Jun 2021 15:29:23 +0200
Message-Id: <162445496319698@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.46 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/vm/slub.rst                                    |   10 -
 Makefile                                                     |    2 
 arch/arc/include/uapi/asm/sigcontext.h                       |    1 
 arch/arc/kernel/signal.c                                     |   43 +++++
 arch/s390/kernel/entry.S                                     |    2 
 arch/x86/include/asm/fpu/internal.h                          |   13 +
 arch/x86/kernel/fpu/signal.c                                 |   54 ++++--
 arch/x86/kvm/lapic.c                                         |    3 
 arch/x86/kvm/mmu/mmu.c                                       |   26 +++
 arch/x86/kvm/x86.c                                           |    6 
 arch/x86/mm/ioremap.c                                        |    4 
 arch/x86/mm/numa.c                                           |    8 
 drivers/dma/Kconfig                                          |    1 
 drivers/dma/fsl-dpaa2-qdma/dpaa2-qdma.c                      |    3 
 drivers/dma/idxd/init.c                                      |    1 
 drivers/dma/pl330.c                                          |    6 
 drivers/dma/qcom/Kconfig                                     |    1 
 drivers/dma/sf-pdma/Kconfig                                  |    1 
 drivers/dma/ste_dma40.c                                      |    3 
 drivers/dma/xilinx/xilinx_dpdma.c                            |   24 ++
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                        |    6 
 drivers/gpu/drm/radeon/radeon_uvd.c                          |    4 
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c                        |   31 +++
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h                        |    5 
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c                       |   41 ++++-
 drivers/hwmon/scpi-hwmon.c                                   |    9 +
 drivers/irqchip/irq-gic-v3.c                                 |   36 ++++
 drivers/net/can/usb/mcba_usb.c                               |   17 +-
 drivers/net/ethernet/atheros/alx/main.c                      |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                    |    8 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c           |   48 ++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c            |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c              |    2 
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                   |   46 +++--
 drivers/net/ethernet/ec_bhf.c                                |    4 
 drivers/net/ethernet/emulex/benet/be_main.c                  |    1 
 drivers/net/ethernet/freescale/fec_ptp.c                     |    8 
 drivers/net/ethernet/intel/ice/ice_lib.c                     |   18 +-
 drivers/net/ethernet/intel/ice/ice_main.c                    |   15 +
 drivers/net/ethernet/lantiq_xrx200.c                         |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c     |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c            |   10 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c            |    6 
 drivers/net/ethernet/mellanox/mlx5/core/mr.c                 |    2 
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c               |    3 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c    |   17 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c |   17 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h  |    6 
 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h    |    6 
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c           |   30 ++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c              |    2 
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c           |    6 
 drivers/net/ethernet/mellanox/mlxsw/reg.h                    |    2 
 drivers/net/ethernet/mscc/ocelot.c                           |    5 
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c         |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c             |    1 
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c           |   15 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h           |    2 
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c              |   89 +++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h              |    3 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h              |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c        |    2 
 drivers/net/ethernet/xilinx/ll_temac_main.c                  |    8 
 drivers/net/hamradio/mkiss.c                                 |    1 
 drivers/net/usb/cdc_eem.c                                    |    2 
 drivers/net/usb/cdc_ncm.c                                    |    2 
 drivers/net/usb/smsc75xx.c                                   |   10 -
 drivers/net/vrf.c                                            |    6 
 drivers/pci/controller/pci-aardvark.c                        |   49 ++++--
 drivers/pci/quirks.c                                         |   89 +++++++++++
 drivers/phy/mediatek/phy-mtk-tphy.c                          |    2 
 drivers/platform/x86/thinkpad_acpi.c                         |    1 
 drivers/ptp/ptp_clock.c                                      |    6 
 drivers/regulator/cros-ec-regulator.c                        |    3 
 drivers/regulator/rt4801-regulator.c                         |    4 
 drivers/regulator/rtmv20-regulator.c                         |    2 
 drivers/s390/crypto/ap_queue.c                               |   11 +
 drivers/spi/spi-stm32-qspi.c                                 |    5 
 drivers/spi/spi-zynq-qspi.c                                  |    7 
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c              |    2 
 drivers/usb/chipidea/usbmisc_imx.c                           |   16 +
 drivers/usb/core/hub.c                                       |    7 
 drivers/usb/dwc3/core.c                                      |    2 
 drivers/usb/dwc3/debug.h                                     |    3 
 drivers/usb/dwc3/debugfs.c                                   |   21 --
 drivers/usb/dwc3/gadget.c                                    |    3 
 fs/afs/main.c                                                |    4 
 fs/notify/fanotify/fanotify_user.c                           |    4 
 include/linux/mfd/rohm-bd70528.h                             |    4 
 include/linux/mlx5/transobj.h                                |    1 
 include/linux/mm_types.h                                     |   27 ++-
 include/linux/ptp_clock_kernel.h                             |    2 
 include/linux/socket.h                                       |    2 
 include/linux/swapops.h                                      |   15 +
 include/net/mac80211.h                                       |    7 
 include/net/net_namespace.h                                  |    7 
 include/uapi/linux/in.h                                      |    3 
 kernel/bpf/verifier.c                                        |   68 +++++++-
 kernel/crash_core.c                                          |    1 
 kernel/sched/fair.c                                          |   10 -
 kernel/trace/trace.c                                         |   11 -
 kernel/trace/trace_clock.c                                   |    6 
 mm/memory-failure.c                                          |    7 
 mm/slab_common.c                                             |    3 
 mm/slub.c                                                    |   37 +---
 mm/swapfile.c                                                |    2 
 net/batman-adv/bat_iv_ogm.c                                  |    4 
 net/bridge/br_private.h                                      |    4 
 net/bridge/br_vlan_tunnel.c                                  |   38 ++--
 net/can/bcm.c                                                |   62 ++++++-
 net/can/isotp.c                                              |   61 +++++--
 net/can/j1939/transport.c                                    |   54 ++++--
 net/can/raw.c                                                |   62 +++++--
 net/core/net_namespace.c                                     |   12 +
 net/core/rtnetlink.c                                         |    8 
 net/ethtool/strset.c                                         |    2 
 net/ipv4/cipso_ipv4.c                                        |    1 
 net/ipv4/icmp.c                                              |    7 
 net/ipv4/igmp.c                                              |    1 
 net/ipv4/route.c                                             |   15 +
 net/ipv4/udp.c                                               |   10 +
 net/ipv6/netfilter/nft_fib_ipv6.c                            |   22 ++
 net/ipv6/udp.c                                               |    3 
 net/mac80211/scan.c                                          |   21 +-
 net/mac80211/tx.c                                            |   52 ++++--
 net/mptcp/options.c                                          |    2 
 net/mptcp/protocol.c                                         |   10 -
 net/mptcp/subflow.c                                          |   10 -
 net/netfilter/nf_synproxy_core.c                             |    5 
 net/qrtr/qrtr.c                                              |    2 
 net/rds/recv.c                                               |    2 
 net/sched/act_ct.c                                           |   21 +-
 net/sched/sch_cake.c                                         |    6 
 net/socket.c                                                 |   13 -
 net/unix/af_unix.c                                           |    7 
 net/wireless/Makefile                                        |    2 
 net/wireless/pmsr.c                                          |   16 +
 sound/soc/codecs/rt5659.c                                    |   26 ++-
 sound/soc/codecs/rt5682-sdw.c                                |    3 
 sound/soc/codecs/tas2562.h                                   |   14 -
 sound/soc/fsl/fsl-asoc-card.c                                |    1 
 sound/soc/qcom/lpass-cpu.c                                   |   79 +++++++++
 sound/soc/qcom/lpass.h                                       |    4 
 tools/include/uapi/linux/in.h                                |    3 
 tools/lib/bpf/xsk.c                                          |    2 
 tools/perf/trace/beauty/include/linux/socket.h               |    2 
 tools/testing/selftests/net/fib_tests.sh                     |   25 +++
 tools/testing/selftests/net/mptcp/mptcp_connect.sh           |   11 -
 150 files changed, 1512 insertions(+), 440 deletions(-)

Aleksander Jan Bajkowski (2):
      net: lantiq: disable interrupt before sheduling NAPI
      lantiq: net: fix duplicated skb in rx descriptor ring

Alex Elder (1):
      net: qualcomm: rmnet: don't over-count statistics

Alexander Gordeev (1):
      s390/mcck: fix calculation of SIE critical section size

Andrew Lunn (1):
      usb: core: hub: Disable autosuspend for Cypress CY7C65632

Andrew Morton (1):
      mm/slub.c: include swab.h

Andy Lutomirski (1):
      x86/fpu: Invalidate FPU state after a failed XRSTOR from a user buffer

Antti Järvinen (1):
      PCI: Mark TI C667X to avoid bus reset

Arnaldo Carvalho de Melo (2):
      tools headers UAPI: Sync linux/in.h copy with the kernel sources
      perf beauty: Update copy of linux/socket.h with the kernel sources

Avraham Stern (1):
      cfg80211: avoid double free of PMSR request

Axel Lin (3):
      regulator: cros-ec: Fix error code in dev_err message
      regulator: bd70528: Fix off-by-one for buck123 .n_voltages setting
      regulator: rt4801: Fix NULL pointer dereference if priv->enable_gpios is NULL

Aya Levin (2):
      net/mlx5e: Block offload of outer header csum for UDP tunnels
      net/mlx5: Reset mkey index on creation

Breno Lima (1):
      usb: chipidea: imx: Fix Battery Charger 1.2 CDP detection

Bumyong Lee (1):
      dmaengine: pl330: fix wrong usage of spinlock flags in dma_cyclc

Changbin Du (1):
      net: make get_net_ns return error if NET_NS is disabled

Chen Li (1):
      radeon: use memcpy_to/fromio for UVD fw upload

Chengyang Fan (1):
      net: ipv4: fix memory leak in ip_mc_add1_src

ChiYuan Huang (1):
      regulator: rtmv20: Fix to make regcache value first reading back from HW

Chiqijun (1):
      PCI: Work around Huawei Intelligent NIC VF FLR erratum

Christophe JAILLET (4):
      alx: Fix an error handling path in 'alx_probe()'
      qlcnic: Fix an error handling path in 'qlcnic_probe()'
      netxen_nic: Fix an error handling path in 'netxen_nic_probe()'
      be2net: Fix an error handling path in 'be_probe()'

Dan Carpenter (1):
      afs: Fix an IS_ERR() vs NULL check

Daniel Borkmann (3):
      bpf: Fix leakage under speculation on mispredicted branches
      bpf: Inherit expanded/patched seen count from old aux data
      bpf: Do not mark insn as seen under speculative path verification

Dave Jiang (1):
      dmaengine: idxd: add missing dsa driver unregister

David Ahern (1):
      ipv4: Fix device used for dst_alloc with local routes

Dima Chumak (1):
      net/mlx5e: Fix page reclaim for dead peer hairpin

Dongliang Mu (1):
      net: usb: fix possible use-after-free in smsc75xx_bind

Du Cheng (1):
      mac80211: fix skb length check in ieee80211_scan_rx()

Eric Dumazet (1):
      net/af_unix: fix a data-race in unix_dgram_sendmsg / unix_release_sock

Esben Haabendal (2):
      net: ll_temac: Make sure to free skb when it is completely used
      net: ll_temac: Fix TX BD buffer overwrite

Fan Du (1):
      x86/mm: Avoid truncating memblocks for SGX memory

Feng Tang (1):
      mm: relocate 'write_protect_seq' in struct mm_struct

Florian Westphal (1):
      netfilter: nft_fib_ipv6: skip ipv6 packets from any to link-local

Fugang Duan (1):
      net: fec_ptp: add clock rate zero check

Greg Kroah-Hartman (1):
      Linux 5.10.46

Harald Freudenberger (1):
      s390/ap: Fix hanging ioctl caused by wrong msg counter

Huy Nguyen (1):
      net/mlx5e: Remove dependency in IPsec initialization flows

Ido Schimmel (1):
      rtnetlink: Fix regression in bridge VLAN configuration

Jack Pham (1):
      usb: dwc3: debugfs: Add and remove endpoint dirs dynamically

Jack Yu (1):
      ASoC: rt5659: Fix the lost powers for the HDA header

Jakub Kicinski (2):
      ethtool: strset: fix message length calculation
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

Kees Cook (3):
      mm/slub: clarify verification reporting
      mm/slub: fix redzoning for small allocations
      mm/slub: actually fix freelist pointer vs redzoning

Kev Jackson (1):
      libbpf: Fixes incorrect rx_ring_setup_done

Linyu Yuan (1):
      net: cdc_eem: fix tx fixup skb leak

Maciej Fijalkowski (2):
      ice: add ndo_bpf callback for safe mode netdev ops
      ice: parameterize functions responsible for Tx ring management

Maciej Żenczykowski (1):
      net: cdc_ncm: switch to eth%d interface naming

Maor Gottlieb (2):
      net/mlx5: Consider RoCE cap before init RDMA resources
      net/mlx5: DR, Don't use SW steering when RoCE is not supported

Marc Zyngier (1):
      irqchip/gic-v3: Workaround inconsistent PMR setting on NMI entry

Marcelo Ricardo Leitner (1):
      net/sched: act_ct: handle DNAT tuple collision

Mathy Vanhoef (1):
      mac80211: Fix NULL ptr deref for injected rate info

Matthew Bobrowski (1):
      fanotify: fix copy_event_to_user() fid error clean up

Maxim Mikityanskiy (3):
      netfilter: synproxy: Fix out of bounds when parsing TCP options
      mptcp: Fix out of bounds when parsing TCP options
      sch_cake: Fix out of bounds when parsing TCP options and header

Michael Chan (1):
      bnxt_en: Rediscover PHY capabilities after firmware reset

Mykola Kostenok (1):
      mlxsw: core: Set thermal zone polling delay argument to real value at init

Nanyong Sun (1):
      net: ipv4: fix memory leak in netlbl_cipsov4_add_std

Nicolas Cavallari (1):
      ASoC: fsl-asoc-card: Set .owner attribute when registering card.

Nicolas Dichtel (1):
      vrf: fix maximum MTU

Nikolay Aleksandrov (2):
      net: bridge: fix vlan tunnel dst null pointer dereference
      net: bridge: fix vlan tunnel dst refcnt when egressing

Norbert Slusarek (1):
      can: bcm: fix infoleak in struct bcm_msg_head

Oder Chiou (1):
      ASoC: rt5682: Fix the fast discharge for headset unplugging in soundwire mode

Oleksij Rempel (1):
      can: j1939: fix Use-after-Free, hold skb ref while in use

Pali Rohár (1):
      PCI: aardvark: Fix kernel panic during PIO transfer

Paolo Abeni (4):
      udp: fix race between close() and udp_abort()
      mptcp: try harder to borrow memory from subflow under pressure
      mptcp: do not warn on bad input from the network
      selftests: mptcp: enable syncookie only in absence of reorders

Parav Pandit (2):
      net/mlx5: E-Switch, Read PF mac address
      net/mlx5: E-Switch, Allow setting GUID for host PF vport

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

Peter Xu (1):
      mm/swap: fix pte_same_as_swp() not removing uffd-wp bit when compare

Petr Machata (1):
      mlxsw: reg: Spectrum-3: Enforce lowest max-shaper burst size of 11

Pingfan Liu (1):
      crash_core, vmcoreinfo: append 'SECTION_SIZE_BITS' to vmcoreinfo

Quanyang Wang (1):
      dmaengine: xilinx: dpdma: initialize registers before request_irq

Rahul Lakkireddy (4):
      cxgb4: fix endianness when flashing boot image
      cxgb4: fix sleep in atomic when flashing PHY firmware
      cxgb4: halt chip before flashing PHY firmware image
      cxgb4: fix wrong ethtool n-tuple rule lookup

Randy Dunlap (3):
      dmaengine: ALTERA_MSGDMA depends on HAS_IOMEM
      dmaengine: QCOM_HIDMA_MGMT depends on HAS_IOMEM
      dmaengine: SF_PDMA depends on HAS_IOMEM

Richard Weinberger (1):
      ASoC: tas2562: Fix TDM_CFG0_SAMPRATE values

Riwen Lu (1):
      hwmon: (scpi-hwmon) shows the negative temperature properly

Rukhsana Ansari (1):
      bnxt_en: Fix TQM fastpath ring backing store computation

Saravana Kannan (1):
      drm/sun4i: dw-hdmi: Make HDMI PHY into a platform device

Sean Christopherson (2):
      KVM: x86: Immediately reset the MMU context when the SMM flag is cleared
      KVM: x86/mmu: Calculate and check "full" mmu_role for nested MMU

Sergio Paracuellos (1):
      pinctrl: ralink: rt2880: avoid to error in calls is pin is already enabled

Shanker Donthineni (1):
      PCI: Mark some NVIDIA GPUs to avoid bus reset

Somnath Kotur (1):
      bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path

Sriharsha Basavapatna (1):
      PCI: Add ACS quirk for Broadcom BCM57414 NIC

Srinivasa Rao Mandadapu (1):
      ASoC: qcom: lpass-cpu: Fix pop noise during audio capture begin

Steven Rostedt (VMware) (3):
      tracing: Do not stop recording cmdlines when tracing is off
      tracing: Do not stop recording comms if the trace file is being read
      tracing: Do no increment trace_clock_global() by one

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Update rmnet device MTU based on real device

Sven Eckelmann (1):
      batman-adv: Avoid WARN_ON timing related checks

Tetsuo Handa (1):
      can: bcm/raw/isotp: use per module netdevice notifier

Thomas Gleixner (4):
      x86/process: Check PF_KTHREAD and not current->mm for kernel threads
      x86/pkru: Write hardware init value to PKRU when xstate is init
      x86/fpu: Prevent state corruption in __fpu__restore_sig()
      x86/fpu: Reset state for all signal restore failures

Tiezhu Yang (1):
      phy: phy-mtk-tphy: Fix some resource leaks in mtk_phy_init()

Til Jasper Ullrich (1):
      platform/x86: thinkpad_acpi: Add X1 Carbon Gen 9 second fan support

Toke Høiland-Jørgensen (1):
      icmp: don't send out ICMP messages with a source address of 0.0.0.0

Tom Lendacky (1):
      x86/ioremap: Map EFI-reserved memory as encrypted for SEV

Vincent Guittot (1):
      sched/pelt: Ensure that *_sum is always synced with *_avg

Vineet Gupta (1):
      ARCv2: save ABI registers across signal handling

Vladimir Oltean (1):
      net: dsa: felix: re-enable TX flow control in ocelot_port_flush()

Wanpeng Li (1):
      KVM: X86: Fix x86_emulator slab cache leak

Yang Yingliang (1):
      dmaengine: stedma40: add missing iounmap() on error in d40_probe()

Yevgeny Kliteynik (1):
      net/mlx5: DR, Allow SW steering for sw_owner_v2 devices

Yifan Zhang (2):
      drm/amdgpu/gfx10: enlarge CP_MEC_DOORBELL_RANGE_UPPER to cover full doorbell.
      drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue.

Zhen Lei (1):
      dmaengine: fsl-dpaa2-qdma: Fix error return code in two functions

yangerkun (1):
      mm/memory-failure: make sure wait for page writeback in memory_failure

zpershuai (1):
      spi: spi-zynq-qspi: Fix some wrong goto jumps & missing error code

