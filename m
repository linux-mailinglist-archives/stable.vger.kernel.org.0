Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434E61CD872
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 13:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgEKLaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 07:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729648AbgEKL3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 07:29:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9106A20708;
        Mon, 11 May 2020 11:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589196584;
        bh=Q9xHi3IZWNV8RkXL7DDfpC0Se/2OmDQ7vNNOknM9p3Y=;
        h=Subject:To:Cc:From:Date:From;
        b=ZzPc4f6+IvlDVIiP/LMWQ2Y0OqSDL5K3Wy6J9p2uMIJvSVdk8uY6aDF3lYEPedZLu
         42wzPkJfUbbw3SBPl2JQEOoSVAoQIWUNByLM3mPg3sMhZA2MLiQxSzi5gtKMMUUbwl
         RgIVdoMxX/OG9NevkHlQ7nYZ/8SKIw4qA88Eekaw=
Subject: Linux 4.4.223
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon, 11 May 2020 13:28:08 +0200
Message-ID: <1589196488107170@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.223 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/alpha/kernel/pci-sysfs.c                            |    4 
 arch/arm/boot/dts/Makefile                               |    1 
 arch/arm/boot/dts/kirkwood-ds112.dts                     |    2 
 arch/arm/boot/dts/kirkwood-lswvl.dts                     |   25 +-
 arch/arm/boot/dts/kirkwood-lswxl.dts                     |   31 +-
 arch/arm/boot/dts/orion5x-linkstation-lswtgl.dts         |   39 ++-
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts            |    2 
 arch/arm/mach-imx/Kconfig                                |    1 
 arch/arm/mach-omap2/omap_hwmod.c                         |   12 -
 arch/arm64/net/bpf_jit_comp.c                            |    1 
 arch/mips/boot/dts/brcm/bcm7435.dtsi                     |    2 
 arch/mips/cavium-octeon/octeon-irq.c                     |    2 
 arch/mips/cavium-octeon/setup.c                          |   14 +
 arch/mips/cavium-octeon/smp.c                            |    1 
 arch/mips/include/asm/elf.h                              |    1 
 arch/mips/include/asm/kexec.h                            |    1 
 arch/mips/include/asm/r4kcache.h                         |    4 
 arch/mips/include/asm/smp.h                              |    2 
 arch/mips/include/uapi/asm/auxvec.h                      |    2 
 arch/mips/kernel/bmips_vec.S                             |    9 
 arch/mips/kernel/branch.c                                |   18 -
 arch/mips/kernel/cps-vec.S                               |    1 
 arch/mips/kernel/cpu-probe.c                             |    5 
 arch/mips/kernel/crash.c                                 |   18 +
 arch/mips/kernel/machine_kexec.c                         |    1 
 arch/mips/kernel/perf_event_mipsxx.c                     |   60 ++++-
 arch/mips/kernel/ptrace.c                                |    3 
 arch/mips/kernel/scall32-o32.S                           |   11 
 arch/mips/kernel/scall64-64.S                            |    3 
 arch/mips/kernel/scall64-n32.S                           |   14 -
 arch/mips/kernel/scall64-o32.S                           |   14 -
 arch/mips/kernel/setup.c                                 |    2 
 arch/mips/kernel/smp-bmips.c                             |    1 
 arch/mips/kernel/smp-cps.c                               |    1 
 arch/mips/kernel/smp.c                                   |    2 
 arch/mips/kvm/dyntrans.c                                 |    2 
 arch/mips/loongson64/loongson-3/smp.c                    |    1 
 arch/mips/math-emu/cp1emu.c                              |   11 
 arch/mips/mm/c-r4k.c                                     |   13 -
 arch/mips/mm/sc-rm7k.c                                   |    2 
 arch/mips/mm/tlbex.c                                     |    4 
 arch/mips/net/bpf_jit.c                                  |    2 
 arch/powerpc/kernel/mce.c                                |    3 
 arch/powerpc/kernel/pci_of_scan.c                        |   12 -
 arch/powerpc/kernel/tm.S                                 |    3 
 arch/powerpc/platforms/powernv/opal.c                    |    1 
 arch/x86/kernel/apic/x2apic_uv_x.c                       |    4 
 arch/x86/kernel/cpu/perf_event.c                         |   11 
 arch/x86/kernel/process_64.c                             |    2 
 block/blk-mq.c                                           |    2 
 drivers/acpi/acpi_lpss.c                                 |    8 
 drivers/ata/sata_dwc_460ex.c                             |    4 
 drivers/base/firmware_class.c                            |    8 
 drivers/base/isa.c                                       |    2 
 drivers/bluetooth/btmrvl_sdio.c                          |    3 
 drivers/char/hw_random/exynos-rng.c                      |    9 
 drivers/clk/clk-gpio.c                                   |    6 
 drivers/clk/clk-multiplier.c                             |   20 +
 drivers/clk/clk-xgene.c                                  |   10 
 drivers/clk/imx/clk-pllv3.c                              |    8 
 drivers/clk/rockchip/clk-mmc-phase.c                     |   11 
 drivers/clk/st/clkgen-fsyn.c                             |   17 -
 drivers/clk/ti/dpll3xxx.c                                |    3 
 drivers/cpufreq/cpufreq.c                                |    5 
 drivers/dma/edma.c                                       |    6 
 drivers/gpu/drm/qxl/qxl_cmd.c                            |    5 
 drivers/gpu/drm/qxl/qxl_display.c                        |    6 
 drivers/gpu/drm/qxl/qxl_draw.c                           |   13 -
 drivers/gpu/drm/qxl/qxl_ioctl.c                          |    5 
 drivers/hv/hv_utils_transport.c                          |    9 
 drivers/iio/adc/ad7793.c                                 |    2 
 drivers/infiniband/hw/cxgb3/cxio_hal.c                   |    2 
 drivers/infiniband/hw/mlx4/ah.c                          |    1 
 drivers/infiniband/hw/mlx5/main.c                        |    2 
 drivers/infiniband/hw/mlx5/qp.c                          |   12 -
 drivers/input/keyboard/gpio_keys.c                       |   29 +-
 drivers/input/touchscreen/edt-ft5x06.c                   |   18 +
 drivers/iommu/dma-iommu.c                                |   11 
 drivers/md/dm.c                                          |    2 
 drivers/media/pci/cx23885/cx23885-av.c                   |    2 
 drivers/media/platform/am437x/am437x-vpfe.c              |    2 
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c    |   65 +----
 drivers/media/rc/rc-main.c                               |    2 
 drivers/memory/tegra/tegra124.c                          |    1 
 drivers/mfd/lp8788-irq.c                                 |    2 
 drivers/misc/cxl/fault.c                                 |    2 
 drivers/mmc/card/block.c                                 |    4 
 drivers/mmc/core/debugfs.c                               |    2 
 drivers/mmc/core/sd.c                                    |   20 +
 drivers/mmc/host/dw_mmc-rockchip.c                       |   64 +++++
 drivers/mmc/host/moxart-mmc.c                            |    5 
 drivers/mmc/host/sdhci-pxav3.c                           |   22 +
 drivers/mmc/host/sdhci.c                                 |   44 ++-
 drivers/mmc/host/sdhci.h                                 |    4 
 drivers/mtd/nand/denali.c                                |   11 
 drivers/net/bonding/bond_3ad.c                           |   11 
 drivers/net/bonding/bond_alb.c                           |    7 
 drivers/net/bonding/bond_netlink.c                       |    3 
 drivers/net/dsa/mv88e6xxx.c                              |    9 
 drivers/net/ethernet/agere/et131x.c                      |    2 
 drivers/net/ethernet/broadcom/bcmsysport.c               |    5 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                |    6 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c           |   11 
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c          |    7 
 drivers/net/ethernet/cadence/macb.c                      |    4 
 drivers/net/ethernet/chelsio/cxgb4/sge.c                 |    2 
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c               |    2 
 drivers/net/ethernet/cirrus/ep93xx_eth.c                 |    4 
 drivers/net/ethernet/emulex/benet/be.h                   |    1 
 drivers/net/ethernet/emulex/benet/be_main.c              |    4 
 drivers/net/ethernet/ethoc.c                             |   10 
 drivers/net/ethernet/hisilicon/hns/hnae.c                |    8 
 drivers/net/ethernet/ibm/ehea/ehea_main.c                |    9 
 drivers/net/ethernet/intel/i40e/i40e_hmc.c               |    2 
 drivers/net/ethernet/marvell/mv643xx_eth.c               |    4 
 drivers/net/ethernet/marvell/mvneta.c                    |   11 
 drivers/net/ethernet/marvell/mvpp2.c                     |    2 
 drivers/net/ethernet/mellanox/mlx4/catas.c               |   11 
 drivers/net/ethernet/mellanox/mlx4/cmd.c                 |    9 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c           |   28 +-
 drivers/net/ethernet/mellanox/mlx4/en_port.c             |    4 
 drivers/net/ethernet/mellanox/mlx4/fw.c                  |    5 
 drivers/net/ethernet/mellanox/mlx4/fw.h                  |    2 
 drivers/net/ethernet/mellanox/mlx4/intf.c                |    3 
 drivers/net/ethernet/mellanox/mlx4/main.c                |   39 ++-
 drivers/net/ethernet/mellanox/mlx4/mcg.c                 |   11 
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                |    5 
 drivers/net/ethernet/mellanox/mlx4/port.c                |   13 -
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c    |   10 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c            |  117 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/en.h             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c     |    8 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c          |    7 
 drivers/net/ethernet/mellanox/mlx5/core/health.c         |   11 
 drivers/net/ethernet/mellanox/mlx5/core/main.c           |   84 +++----
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c      |   26 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/wq.c             |   15 -
 drivers/net/ethernet/mellanox/mlxsw/pci.c                |    2 
 drivers/net/ethernet/mellanox/mlxsw/port.h               |    2 
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c           |   11 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c |    4 
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c           |    3 
 drivers/net/ethernet/micrel/ks8842.c                     |   10 
 drivers/net/ethernet/moxa/moxart_ether.c                 |    4 
 drivers/net/ethernet/qlogic/qede/qede_main.c             |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c           |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c     |    8 
 drivers/net/ethernet/renesas/ravb_main.c                 |    2 
 drivers/net/ethernet/sfc/ef10.c                          |    3 
 drivers/net/ethernet/sfc/efx.c                           |    3 
 drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c      |   12 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c           |   11 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c          |   11 
 drivers/net/ethernet/ti/cpsw-phy-sel.c                   |    3 
 drivers/net/ethernet/ti/cpsw.c                           |   14 -
 drivers/net/ethernet/ti/davinci_emac.c                   |    7 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c        |    4 
 drivers/net/geneve.c                                     |   14 -
 drivers/net/macvlan.c                                    |   10 
 drivers/net/macvtap.c                                    |    2 
 drivers/net/phy/at803x.c                                 |    6 
 drivers/net/phy/bcm7xxx.c                                |    2 
 drivers/net/phy/mdio-sun4i.c                             |    4 
 drivers/net/phy/micrel.c                                 |   12 -
 drivers/net/phy/phy.c                                    |   46 ++-
 drivers/net/phy/phy_device.c                             |    2 
 drivers/net/vrf.c                                        |  177 +--------------
 drivers/net/vxlan.c                                      |   62 +++--
 drivers/net/wimax/i2400m/usb-fw.c                        |    1 
 drivers/net/wireless/ath/ath10k/core.c                   |    2 
 drivers/net/wireless/ath/ath9k/htc_hst.c                 |    2 
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c       |   16 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c       |   22 +
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c         |    2 
 drivers/net/wireless/iwlwifi/iwl-7000.c                  |    2 
 drivers/net/wireless/mwifiex/pcie.h                      |    9 
 drivers/net/wireless/mwifiex/sta_event.c                 |   10 
 drivers/net/wireless/mwifiex/wmm.c                       |    6 
 drivers/of/of_mdio.c                                     |    5 
 drivers/pci/pci-sysfs.c                                  |    7 
 drivers/pinctrl/bcm/pinctrl-bcm2835.c                    |    2 
 drivers/pinctrl/pinctrl-tegra.c                          |    2 
 drivers/power/bq27xxx_battery.c                          |   20 +
 drivers/power/ipaq_micro_battery.c                       |    2 
 drivers/power/test_power.c                               |    2 
 drivers/power/tps65217_charger.c                         |    6 
 drivers/regulator/core.c                                 |   29 +-
 drivers/scsi/cxgbi/libcxgbi.c                            |    1 
 drivers/staging/media/lirc/lirc_imon.c                   |    2 
 drivers/staging/rtl8192u/r8192U_core.c                   |    4 
 drivers/target/target_core_configfs.c                    |    6 
 drivers/tty/serial/msm_serial.c                          |   99 +++++---
 drivers/tty/serial/samsung.c                             |    4 
 drivers/usb/gadget/function/f_acm.c                      |    4 
 drivers/usb/gadget/udc/pch_udc.c                         |   30 --
 drivers/usb/gadget/udc/udc-core.c                        |    2 
 drivers/vfio/pci/vfio_pci_config.c                       |    3 
 drivers/vfio/platform/reset/vfio_platform_amdxgbe.c      |    2 
 fs/btrfs/disk-io.c                                       |    2 
 fs/btrfs/extent-tree.c                                   |    2 
 fs/cifs/connect.c                                        |    2 
 fs/gfs2/file.c                                           |    5 
 fs/nfs/nfs4proc.c                                        |    4 
 include/asm-generic/preempt.h                            |    4 
 include/linux/cpufreq.h                                  |    4 
 include/linux/ieee80211.h                                |    9 
 include/linux/mlx5/driver.h                              |    3 
 include/linux/mlx5/qp.h                                  |    1 
 include/linux/mtd/nand.h                                 |    4 
 include/linux/netdevice.h                                |    5 
 include/linux/sunrpc/msg_prot.h                          |    4 
 include/net/bonding.h                                    |    7 
 include/net/ip6_fib.h                                    |    2 
 include/net/ip6_route.h                                  |    3 
 include/net/ip_fib.h                                     |    3 
 include/net/route.h                                      |    3 
 include/net/sch_generic.h                                |    5 
 include/net/sock.h                                       |   18 +
 include/net/xfrm.h                                       |    4 
 kernel/bpf/syscall.c                                     |    4 
 kernel/sched/fair.c                                      |   27 --
 kernel/trace/bpf_trace.c                                 |    4 
 lib/mpi/longlong.h                                       |   34 +-
 net/batman-adv/main.c                                    |    2 
 net/batman-adv/translation-table.c                       |    6 
 net/bridge/br_fdb.c                                      |   52 ++--
 net/bridge/br_input.c                                    |    7 
 net/core/dev.c                                           |    1 
 net/core/flow_dissector.c                                |   17 -
 net/core/rtnetlink.c                                     |    1 
 net/core/skbuff.c                                        |   10 
 net/core/sock.c                                          |    7 
 net/dccp/ipv4.c                                          |    2 
 net/dccp/ipv6.c                                          |    2 
 net/dsa/slave.c                                          |    7 
 net/ipv4/devinet.c                                       |   12 -
 net/ipv4/fib_frontend.c                                  |    3 
 net/ipv4/fib_semantics.c                                 |    8 
 net/ipv4/fib_trie.c                                      |    4 
 net/ipv4/fou.c                                           |    6 
 net/ipv4/gre_offload.c                                   |    8 
 net/ipv4/icmp.c                                          |    4 
 net/ipv4/ip_gre.c                                        |   46 ++-
 net/ipv4/ip_sockglue.c                                   |    7 
 net/ipv4/netfilter/nft_dup_ipv4.c                        |    6 
 net/ipv4/route.c                                         |   17 +
 net/ipv4/tcp_input.c                                     |    5 
 net/ipv4/udp.c                                           |   13 -
 net/ipv6/addrconf.c                                      |   21 +
 net/ipv6/icmp.c                                          |    5 
 net/ipv6/ip6_checksum.c                                  |    7 
 net/ipv6/ip6_vti.c                                       |    4 
 net/ipv6/ip6mr.c                                         |   13 -
 net/ipv6/netfilter/nft_dup_ipv6.c                        |    6 
 net/ipv6/route.c                                         |   75 ++++--
 net/ipv6/tcp_ipv6.c                                      |    7 
 net/ipv6/udp.c                                           |    6 
 net/ipv6/xfrm6_input.c                                   |   15 -
 net/ipv6/xfrm6_tunnel.c                                  |    2 
 net/irda/af_irda.c                                       |    5 
 net/l2tp/l2tp_core.c                                     |    3 
 net/mac80211/ieee80211_i.h                               |    4 
 net/mac80211/mlme.c                                      |    2 
 net/mac80211/offchannel.c                                |    5 
 net/mac80211/rx.c                                        |    8 
 net/mac80211/status.c                                    |    5 
 net/mac80211/tdls.c                                      |   43 ++-
 net/mac80211/tx.c                                        |    2 
 net/mac80211/vht.c                                       |   30 ++
 net/netfilter/nf_tables_api.c                            |    4 
 net/netfilter/nf_tables_core.c                           |    2 
 net/netfilter/nfnetlink.c                                |    6 
 net/netfilter/nft_dynset.c                               |    3 
 net/nfc/nci/core.c                                       |    6 
 net/openvswitch/actions.c                                |   20 +
 net/rds/tcp.c                                            |    2 
 net/rds/tcp_listen.c                                     |   40 ++-
 net/sched/cls_bpf.c                                      |   13 -
 net/sched/cls_flower.c                                   |   28 +-
 net/sched/sch_drr.c                                      |    4 
 net/sched/sch_fq.c                                       |   32 +-
 net/sched/sch_fq_codel.c                                 |    2 
 net/sched/sch_generic.c                                  |   11 
 net/sched/sch_hfsc.c                                     |   12 -
 net/sched/sch_prio.c                                     |    4 
 net/sched/sch_qfq.c                                      |    3 
 net/sched/sch_sfb.c                                      |    3 
 net/sched/sch_tbf.c                                      |    4 
 net/sctp/associola.c                                     |    2 
 net/sctp/sm_make_chunk.c                                 |    6 
 net/sctp/transport.c                                     |    2 
 net/sunrpc/xprtrdma/backchannel.c                        |   22 -
 net/sunrpc/xprtrdma/transport.c                          |    3 
 net/sunrpc/xprtrdma/verbs.c                              |   41 +--
 net/sunrpc/xprtrdma/xprt_rdma.h                          |    2 
 net/tipc/udp_media.c                                     |    5 
 net/xfrm/xfrm_input.c                                    |   14 -
 net/xfrm/xfrm_state.c                                    |    1 
 net/xfrm/xfrm_user.c                                     |   15 -
 scripts/config                                           |    5 
 sound/pci/fm801.c                                        |   71 +++---
 sound/pci/hda/hda_intel.c                                |    9 
 sound/soc/fsl/fsl_ssi.c                                  |    8 
 sound/soc/intel/atom/sst/sst_stream.c                    |    2 
 sound/soc/tegra/tegra_alc5632.c                          |   12 -
 tools/perf/util/perf_regs.c                              |    8 
 tools/testing/selftests/ipc/msgque.c                     |    2 
 309 files changed, 2004 insertions(+), 1278 deletions(-)

Adrian Hunter (1):
      mmc: sdhci: Fix regression setting power on Trats2 board

Alex Vesker (1):
      net/mlx4_core: Check device state before unregistering it

Alex Williamson (1):
      vfio/pci: Allow VPD short read

Alexander Duyck (3):
      GRE: Disable segmentation offloads w/ CSUM and we are encapsulated via FOU
      ipv4: Fix memory leak in exception case for splitting tries
      flow_dissector: Check for IP fragmentation even if not using IPv4 address

Alexei Starovoitov (1):
      bpf, trace: check event type in bpf_perf_event_read

Alexey Kardashevskiy (1):
      powerpc/pci/of: Parse unassigned resources

Alexey Khoroshilov (1):
      lirc_imon: do not leave imon_probe() with mutex held

Alexey Kodanev (1):
      net/xfrm_input: fix possible NULL deref of tunnel.ip6->parms.i_key

Amitkumar Karwar (2):
      mwifiex: fix PCIe register information for 8997 chipset
      mwifiex: add missing check for PCIe8997 chipset

Andrew Lunn (1):
      net: ethernet: mvneta: Remove IFF_UNICAST_FLT which is not implemented

Andrew Rybchenko (1):
      sfc: fix potential stack corruption from running past stat bitmask

Andy Shevchenko (6):
      usb: gadged: pch_udc: get rid of redundant assignments
      ALSA: fm801: explicitly free IRQ line
      ALSA: fm801: propagate TUNER_ONLY bit when autodetected
      ALSA: fm801: detect FM-only card earlier
      Revert "ACPI / LPSS: allow to use specific PM domain during ->probe()"
      ALSA: fm801: Initialize chip after IRQ handler is registered

Aneesh Kumar K.V (1):
      cxl: Fix DAR check & use REGION_ID instead of opencoding

Arend Van Spriel (1):
      brcmfmac: restore stopping netdev queue when bus clogs up

Arik Nemtsov (2):
      mac80211: TDLS: always downgrade invalid chandefs
      mac80211: TDLS: change BW calculation for WIDER_BW peers

Arnd Bergmann (3):
      ARM: imx: select SRC for i.MX7
      clk: st: avoid uninitialized variable use
      mvpp2: use correct size for memset

Bart Van Assche (1):
      target: Fix a memory leak in target_dev_lba_map_store()

Bartlomiej Zolnierkiewicz (1):
      blk-mq: fix undefined behaviour in order_to_size()

Ben Hutchings (1):
      staging: rtl8192u: Fix crash due to pointers being "confusing"

Bert Kenward (1):
      sfc: clear napi_hash state when copying channels

Bjorn Helgaas (2):
      PCI: Supply CPU physical address (not bus address) to iomem_is_exclusive()
      alpha/PCI: Call iomem_is_exclusive() for IORESOURCE_MEM, but not IORESOURCE_IO

Boris Brezillon (2):
      mtd: nand: fix ONFI parameter page layout
      mtd: nand: denali: add missing nand_release() call in denali_remove()

Brian Norris (2):
      firmware: actually return NULL on failed request_firmware_nowait()
      clk: gpio: handle error codes for of_clk_get_parent_count()

Charles Keepax (1):
      regulator: core: Rely on regulator_dev_release to free constraints

Chin-Ran Lo (1):
      Bluetooth: btmrvl: fix hung task warning dump

Chuanxiao Dong (1):
      mmc: debugfs: correct wrong voltage value

Chuck Lever (6):
      xprtrdma: Fix additional uses of spin_lock_irqsave(rb_lock)
      xprtrdma: xprt_rdma_free() must not release backchannel reqs
      xprtrdma: rpcrdma_bc_receive_call() should init rq_private_buf.len
      NFS: Fix an LOCK/OPEN race when unlinking an open file
      sunrpc: Update RPCBIND_MAXNETIDLEN
      xprtrdma: Fix backchannel allocation of extra rpcrdma_reps

Cyrille Pitchen (1):
      net: macb: replace macb_writel() call by queue_writel() to update queue ISR

Dan Carpenter (20):
      MIPS: Octeon: Off by one in octeon_irq_gpio_map()
      MIPS: RM7000: Double locking bug in rm7k_tc_disable()
      x86/apic/uv: Silence a shift wrapping warning
      xprtrdma: checking for NULL instead of IS_ERR()
      Btrfs: clean up an error code in btrfs_init_space_info()
      ASoC: Intel: pass correct parameter in sst_alloc_stream_mrfld()
      NFC: nci: memory leak in nci_core_conn_create()
      mdio-sun4i: oops in error handling in probe
      am437x-vpfe: fix an uninitialized variable bug
      cx23885: uninitialized variable in cx23885_av_work_handler()
      ath9k_htc: check for underflow in ath9k_htc_rx_msg()
      VFIO: platform: reset: fix a warning message condition
      net: moxa: fix an error code
      mfd: lp8788-irq: Uninitialized variable in irq handler
      ethernet: micrel: fix some error codes
      power: ipaq-micro-battery: freeing the wrong variable
      i40e: fix an uninitialized variable bug
      qede: uninitialized variable in qede_start_xmit()
      qlcnic: potential NULL dereference in qlcnic_83xx_get_minidump_template()
      qlcnic: use the correct ring in qlcnic_83xx_process_rcv_ring_diag()

Daniel Borkmann (3):
      bpf, mips: fix off-by-one in ctx offset allocation
      cls_bpf: reset class and reuse major in da
      bpf: fix map not being uncharged during map creation failure

Daniel Jurgens (3):
      net/mlx4_core: Do not BUG_ON during reset when PCI is offline
      net/mlx4_core: Implement pci_resume callback
      net/mlx5: Fix wait_vital for VFs and remove fixed sleep

David Ahern (7):
      net: ipv6: tcp reset, icmp need to consider L3 domain
      net: vrf: Fix dev refcnt leak due to IPv6 prefix route
      net: ipv6: Fix processing of RAs in presence of VRF
      net: vrf: Fix dst reference counting
      ipv4: Fix table id reference in fib_sync_down_addr
      net: icmp6_send should use dst dev to determine L3 domain
      net: icmp_route_lookup should use rt dev to determine L3 domain

David Rivshin (1):
      drivers: net: cpsw: don't ignore phy-mode if phy-handle is used

Dmitry Torokhov (1):
      Input: gpio-keys - fix check for disabling unsupported keys

Dong Aisheng (1):
      clk: imx: clk-pllv3: fix incorrect handle of enet powerdown bit

Doug Berger (2):
      net: bcmgenet: suppress warnings on failed Rx SKB allocations
      net: systemport: suppress warnings on failed Rx SKB allocations

Douglas Anderson (2):
      clk: rockchip: Revert "clk: rockchip: reset init state before mmc card initialization"
      mmc: dw_mmc: rockchip: Set the drive phase properly

Douglas Miller (1):
      be2net: Don't leak iomapped memory on removal.

Elad Raz (1):
      mlxsw: switchx2: Fix ethernet port initialization

Eli Cohen (1):
      net/mlx5e: Fix blue flame quota logic

Emmanuel Grumbach (1):
      iwlwifi: set max firmware version of 7265 to 17

Eran Ben Elisha (2):
      IB/mlx5: Fix FW version diaplay in sysfs
      net/mlx4_core: Fix potential corruption in counters database

Erez Shitrit (1):
      net/mlx4_en: Process all completions in RX rings after port goes up

Eric Dumazet (13):
      bonding: prevent out of bound accesses
      tcp: do not set rtt_min to 1
      net: get rid of an signed integer overflow in ip_idents_reserve()
      ipv4: do not abuse GFP_ATOMIC in inet_netconf_notify_devconf()
      ipv4: accept u8 in IP_TOS ancillary data
      ipv6: do not abuse GFP_ATOMIC in inet6_netconf_notify_devconf()
      pkt_sched: fq: use proper locking in fq_dump_stats()
      mlx4: do not call napi_schedule() without care
      net: bcmgenet: device stats are unsigned long
      macvtap: segmented packet is consumed
      fq_codel: return non zero qlen in class dumps
      bnxt: add a missing rcu synchronization
      qdisc: fix a module refcount leak in qdisc_create_dflt()

Felipe Balbi (1):
      usb: gadget: udc: core: don't starve DMA resources

Florian Fainelli (14):
      MIPS: BMIPS: Fix PRID_IMP_BMIPS5000 masking for BMIPS5200
      MIPS: BMIPS: BMIPS5000 has I cache filing from D cache
      MIPS: BMIPS: Clear MIPS_CACHE_ALIASES earlier
      MIPS: BMIPS: local_r4k___flush_cache_all needs to blast S-cache
      MIPS: BMIPS: Pretty print BMIPS5200 processor name
      MIPS: BMIPS: Adjust mips-hpt-frequency for BCM7435
      net: phy: Avoid polling PHY with PHY_IGNORE_INTERRUPTS
      net: phy: Fix phy_mac_interrupt()
      net: phy: bcm7xxx: Fix shadow mode 2 disabling
      net: bcmsysport: Device stats are unsigned long
      et131x: Fix logical vs bitwise check in et131x_tx_timeout()
      bnxt_en: Remove locking around txr->dev_state
      net: ethoc: Fix early error paths
      net: ep93xx_eth: Do not crash unloading module

Franky Lin (1):
      brcmfmac: add eth_type_trans back for PCIe full dongle

Geert Uytterhoeven (2):
      ARM: dts: armadillo800eva Correct extal1 frequency to 24 MHz
      ravb: Add missing free_irq() call to ravb_close()

Greg Kroah-Hartman (1):
      Linux 4.4.223

H. Nikolaus Schaller (2):
      power: bq27xxx: fix reading for bq27000 and bq27010
      power: bq27xxx: fix register numbers of bq27500

Hadar Hen Zion (1):
      net_sched: flower: Avoid dissection of unmasked keys

Hannes Frederic Sowa (2):
      ipv4: fix checksum annotation in udp4_csum_init
      ipv6: fix checksum annotation in udp6_csum_init

Hariprasad Shenai (1):
      cxgb4/cxgb4vf: Fixes regression in perf when tx vlan offload is disabled

Heinrich Schuchardt (2):
      ARM: dts: kirkwood: use unique machine name for ds112
      ARM: dts: kirkwood: add kirkwood-ds112.dtb to Makefile

Herbert Xu (1):
      macvlan: Fix potential use-after free for broadcasts

Hidehiro Kawai (1):
      mips/panic: replace smp_send_stop() with kdump friendly version in panic path

Honggang Li (1):
      RDMA/cxgb3: device driver frees DMA memory with different size

Iago Abal (1):
      usb: gadget: pch_udc: reorder spin_[un]lock to avoid deadlock

Ido Schimmel (5):
      mlxsw: pci: Correctly determine if descriptor queue is full
      mlxsw: Treat local port 64 as valid
      mlxsw: spectrum: Don't forward packets when STP state is DISABLED
      mlxsw: spectrum: Disable learning according to STP state
      mlxsw: spectrum: Indicate support for autonegotiation

Ilan Peer (1):
      mac80211: Fix BW upgrade for TDLS peers

Ilan Tayari (1):
      xfrm: Fix memory leak of aead algorithm name

Ivan Vecera (1):
      bna: add missing per queue ethtool stat

Jaap Jan Meijer (1):
      brcmfmac: add fallback for devices that do not report per-chain values

Jack Morgenstein (4):
      net/mlx4_core: Fix the resource-type enum in res tracker to conform to FW spec
      net/mlx4_core: Do not access comm channel if it has not yet been initialized
      net/mlx4_en: Fix potential deadlock in port statistics flow
      net/mlx4: Fix uninitialized fields in rule when adding promiscuous mode to device managed flow steering

Jaedon Shin (1):
      MIPS: Fix macro typo

James Hogan (7):
      MIPS: ptrace: Drop cp0_tcstatus from regoffset_table[]
      MIPS: Fix HTW config on XPA kernel without LPA enabled
      MIPS: perf: Fix I6400 event numbers
      MIPS: KVM: Fix translation of MFC0 ErrCtl
      MIPS: SMP: Update cpu_foreign_map on CPU disable
      MIPS: c-r4k: Fix protected_writeback_scache_line for EVA
      MIPS: Define AT_VECTOR_SIZE_ARCH for ARCH_DLINFO

Jan Beulich (1):
      x86/LDT: Print the real LDT base address

Jere Leppänen (1):
      sctp: Fix SHUTDOWN CTSN Ack in the peer restart case

Jeremie Francois (on alpha) (1):
      scripts/config: allow colons in option strings for sed

Jiri Benc (4):
      gre: do not assign header_ops in collect metadata mode
      gre: build header correctly for collect metadata tunnels
      gre: reject GUE and FOU in collect metadata mode
      cxgbi: fix uninitialized flowi6

Jiri Kosina (1):
      btrfs: cleaner_kthread() doesn't need explicit freeze

Jisheng Zhang (2):
      mmc: sdhci: restore behavior when setting VDD via external regulator
      net: mvneta: fix trivial cut-off issue in mvneta_ethtool_update_stats

Johan Hovold (9):
      phy: fix device reference leaks
      of_mdio: fix node leak in of_phy_register_fixed_link error path
      net: dsa: slave: fix of-node leak and phy priority
      net: ethernet: stmmac: dwmac-sti: fix probe error path
      net: ethernet: stmmac: dwmac-rk: fix probe error path
      net: ethernet: stmmac: dwmac-generic: fix probe error path
      net: ethernet: ti: cpsw: fix device and of_node leaks
      net: ethernet: ti: cpsw: fix secondary-emac probe error path
      net: hns: fix device reference leaks

Johannes Berg (1):
      mac80211: fix mgmt-tx abort cookie and leak

Johannes Weiner (1):
      net: tcp_memcontrol: properly detect ancestor socket pressure

Junxiao Bi (1):
      gfs2: fix flock panic issue

Kamal Heib (1):
      net/mlx4_en: Fix the return value of a failure in VLAN VID add/kill

Krzysztof Kozlowski (2):
      serial: samsung: Fix possible out of bounds access on non-DT platform
      hwrng: exynos - Disable runtime PM on driver unbind

Krzysztof Opasiak (1):
      usb: gadget: f_acm: Fix configfs attr name

Laura Abbott (1):
      clk: xgene: Don't call __pa on ioremaped address

Laxman Dewangan (1):
      pinctrl: tegra: Correctly check the supported configuration

Leon Romanovsky (1):
      IB/mlx5: Fix RC transport send queue overhead computation

Liping Zhang (4):
      netfilter: nf_tables: fix a wrong check to skip the inactive rules
      netfilter: nft_dynset: fix panic if NFT_SET_HASH is not enabled
      netfilter: nf_tables: destroy the set if fail to add transaction
      netfilter: nft_dup: do not use sreg_dev if the user doesn't specify it

Liu Xiang (1):
      power: bq27xxx_battery: Fix bq27541 AveragePower register address

Maciej S. Szmigiero (1):
      ASoC: fsl_ssi: mark SACNT register volatile

Mahesh Salgaonkar (1):
      powerpc/book3s: Fix MCE console messages for unrecoverable MCE.

Majd Dibbiny (2):
      net/mlx5: Fix the size of modify QP mailbox
      net/mlx5: Fix masking of reserved bits in XRCD number

Mans Rullgard (1):
      ata: sata_dwc_460ex: remove incorrect locking

Marcin Niestroj (1):
      power_supply: tps65217-charger: Fix NULL deref during property export

Marcin Nowakowski (1):
      MIPS: perf: Remove incorrect odd/even counter handling for I6400

Mark Tomlinson (1):
      net: Don't delete routes in different VRFs

Matan Barak (1):
      IB/mlx4: Initialize hop_limit when creating address handle

Mathias Krause (2):
      xfrm_user: propagate sec ctx allocation errors
      rtnl: reset calcit fptr in rtnl_unregister()

Matt Redfearn (1):
      MIPS: scall: Handle seccomp filters which redirect syscalls

Matthew Finlay (1):
      net/mlx5e: Copy all L2 headers into inline segment

Maxime Ripard (1):
      clk: multiplier: Prevent the multiplier from under / over flowing

Michael Neuling (1):
      powerpc/tm: Fix stack pointer corruption in __tm_recheckpoint()

Mohamad Haj Yahia (4):
      net/mlx5: Avoid calling sleeping function by the health poll thread
      net/mlx5: Fix potential deadlock in command mode change
      net/mlx5: Add timeout handle to commands with callback
      net/mlx5: Fix pci error recovery flow

Moshe Shemesh (1):
      net/mlx4_core: Fix QUERY FUNC CAP flags

Nathan Chancellor (1):
      lib/mpi: Fix building for powerpc with clang

Naveen N. Rao (1):
      perf tools: Fix perf regs mask generation

Neil Armstrong (2):
      net: ethernet: davinci_emac: Fix devioctl while in fixed link
      net: ethernet: davinci_emac: Fix platform_data overwrite

Nicholas Mc Guire (1):
      mmc: moxart: fix wait_for_completion_interruptible_timeout return variable type

Nicolas Dichtel (6):
      ovs/gre,geneve: fix error path when creating an iface
      ipv6: add missing netconf notif when 'all' is updated
      vti6: fix input path
      ovs/gre: fix rtnl notifications on iface deletion
      ovs/geneve: fix rtnl notifications on iface deletion
      ovs/vxlan: fix rtnl notifications on iface deletion

Nicolas Schichan (1):
      net: mv643xx_eth: fix packet corruption with TSO and tiny unaligned packets.

Nikolay Aleksandrov (1):
      net: bridge: don't increment tx_dropped in br_do_proxy_arp

Noa Osherovich (1):
      net/mlx5: Avoid passing dma address 0 to firmware

Nogah Frankel (1):
      mlxsw: spectrum: Don't count internal TX header bytes to stats

Olaf Hering (1):
      Drivers: hv: utils: use memdup_user in hvt_op_write

Olof Johansson (1):
      mmc: block: return error on failed mmc_blk_get()

Or Gerlitz (1):
      net/mlx5: Make command timeout way shorter

Pablo Neira (1):
      udp: restore UDPlite many-cast delivery

Pablo Neira Ayuso (1):
      netfilter: nfnetlink: use original skbuff when acking batches

Paul Burton (3):
      MIPS: smp-cps: Stop printing EJTAG exceptions to UART
      MIPS: math-emu: Fix BC1{EQ,NE}Z emulation
      MIPS: Fix BC1{EQ,NE}Z return offset calculation

Peter Griffin (1):
      c8sectpfe: Rework firmware loading mechanism

Peter Ujfalusi (1):
      dmaengine: edma: Add probe callback to edma_tptc_driver

Peter Zijlstra (2):
      sched/fair: Fix calc_cfs_shares() fixed point arithmetics width confusion
      sched/preempt: Fix preempt_count manipulations

Petri Gynther (1):
      net: bcmgenet: fix skb_len in bcmgenet_xmit_single()

Philipp Zabel (1):
      Input: edt-ft5x06 - fix setting gain, offset, and threshold via device tree

Raja Mani (1):
      ath10k: free cached fw bin contents when get board id fails

Rana Shahout (1):
      net/mlx5e: Fix MLX5E_100BASE_T define

Robin Murphy (1):
      iommu/dma: Respect IOMMU aperture when allocating

Roger Shimizu (6):
      ARM: dts: kirkwood: gpio pin fixes for linkstation ls-wxl/wsxl
      ARM: dts: kirkwood: gpio pin fixes for linkstation ls-wvl/vl
      ARM: dts: kirkwood: gpio-leds fixes for linkstation ls-wxl/wsxl
      ARM: dts: kirkwood: gpio-leds fixes for linkstation ls-wvl/vl
      ARM: dts: orion5x: gpio pin fixes for linkstation lswtgl
      ARM: dts: orion5x: fix the missing mtd flash on linkstation lswtgl

Ronnie Sahlberg (1):
      cifs: protect updating server->dstaddr with a spinlock

Roosen Henri (1):
      phy: micrel: Fix finding PHY properties in MAC node for KSZ9031.

Russell King (2):
      mmc: sd: limit SD card power limit according to cards capabilities
      rc: allow rc modules to be loaded if rc-main is not a module

Sabrina Dubroca (1):
      l2tp: fix use-after-free during module unload

Sasha Levin (1):
      power: test_power: correctly handle empty writes

Sergei Shtylyov (1):
      at803x: fix reset handling

Shmulik Ladkani (1):
      net: skbuff: Remove errornous length validation in skb_vlan_pop()

Simon Horman (1):
      openvswitch: update checksum in {push,pop}_mpls

Simon Wunderlich (1):
      batman-adv: replace WARN with rate limited output on non-existing VLAN

Sowmini Varadhan (1):
      RDS:TCP: Synchronize rds_tcp_accept_one with rds_send_xmit when resetting t_sock

Stefan Wahren (1):
      pinctrl: bcm2835: Fix memory leak in error path

Stephane Eranian (1):
      perf/x86: Fix filter_events() bug with event mappings

Stephen Boyd (1):
      tty: serial: msm: Support more bauds

Sudip Mukherjee (1):
      ASoC: tegra_alc5632: check return value

Suman Anna (1):
      ARM: OMAP2+: hwmod: fix _idle() hwmod state sanity check sequence

Sven Eckelmann (1):
      batman-adv: Fix lockdep annotation of batadv_tlv_container_remove

Tahsin Erdogan (1):
      dm: fix second blk_delay_queue() parameter to be in msec units not jiffies

Takashi Iwai (1):
      ALSA: hda: Match both PCI ID and SSID for driver blacklist

Tariq Toukan (1):
      net/mlx4_core: Fix access to uninitialized index

Tero Kristo (1):
      clk: ti: omap3+: dpll: use non-locking version of clk_get_rate

Thomas Pedersen (1):
      mac80211: add ieee80211_is_any_nullfunc()

Tobias Jungel (1):
      bonding: fix length of actor system

Toshiaki Makita (1):
      bridge: Fix problems around fdb entries pointing to the bridge device

Tyler Hicks (1):
      selftests/ipc: Fix test failure seen after initial test run

Vasily Averin (2):
      drm/qxl: qxl_release use after free
      drm/qxl: qxl_release leak in qxl_draw_dirty_fb()

Vegard Nossum (1):
      xfrm: fix crash in XFRM_MSG_GETSA netlink handler

Vince Hsu (1):
      memory/tegra: Add number of TLB lines for Tegra124

Viresh Kumar (1):
      Revert "cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT"

Vivien Didelot (3):
      net: dsa: mv88e6xxx: unlock DSA and CPU ports
      net: dsa: mv88e6xxx: enable SA learning on DSA ports
      net: dsa: mv88e6xxx: fix port VLAN maps

WANG Cong (7):
      net_sched: keep backlog updated with qlen
      sch_drr: update backlog as well
      sch_hfsc: always keep backlog updated
      sch_prio: update backlog as well
      sch_qfq: keep backlog updated with qlen
      sch_sfb: keep backlog updated with qlen
      sch_tbf: update backlog as well

Wang Sheng-Hui (1):
      net/mlx5: use mlx5_buf_alloc_node instead of mlx5_buf_alloc in mlx5_wq_ll_create

Wei Yongjun (3):
      net: macb: add missing free_netdev() on error in macb_probe()
      tipc: fix the error handling in tipc_udp_enable()
      net: axienet: Fix return value check in axienet_probe()

Willem de Bruijn (1):
      dccp: limit sk_filter trim to payload

William Breathitt Gray (1):
      isa: Call isa_bus_init before dependent ISA bus drivers register

Xin Long (1):
      sctp: fix the transports round robin issue when init is retransmitted

Xiyu Yang (1):
      wimax/i2400m: Fix potential urb refcnt leak

Yotam Gigi (2):
      mlxsw: spectrum: Fix misuse of hard_header_len
      mlxsw: switchx2: Fix misuse of hard_header_len

YueHaibing (1):
      iio:ad7797: Use correct attribute_group

Zi Shen Lim (1):
      arm64: bpf: jit JMP_JSET_{X,K}

chunfan chen (1):
      mwifiex: fix IBSS data path issue.

phil.turnbull@oracle.com (1):
      irda: Free skb on irda_accept error path.

pravin shelar (1):
      net: vxlan: lwt: Fix vxlan local traffic.

xypron.glpk@gmx.de (1):
      net: ehea: avoid null pointer dereference

