Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030D83D4D9F
	for <lists+stable@lfdr.de>; Sun, 25 Jul 2021 15:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGYMgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Jul 2021 08:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230411AbhGYMfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Jul 2021 08:35:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09F8C60551;
        Sun, 25 Jul 2021 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627218979;
        bh=fDJxp4gOlb2LjmfcMIMCMhOHrLRdqd7FmLcSJgitlzQ=;
        h=From:To:Cc:Subject:Date:From;
        b=PEUjaqFU1ryMG6Vb+jAFumFh3wBOqq3mY/hjzsD+pONvGGLFg3s3qqVvvLc2mFC0N
         fwVimz03dxUhG7CtzmoY0hCAxKdhv1t6X7SFt27g8n0QYat6Ypn+mb7vV9Nv9WexnY
         qSWsWdHb3IJeaysEu/buDCeEaYfjvE5PHv7iDX4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.53
Date:   Sun, 25 Jul 2021 15:16:13 +0200
Message-Id: <162721897310487@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.53 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |   11 -
 arch/arm/boot/dts/am335x-baltos.dtsi                       |    4 
 arch/arm/boot/dts/am335x-evmsk.dts                         |    2 
 arch/arm/boot/dts/am335x-moxa-uc-2100-common.dtsi          |    2 
 arch/arm/boot/dts/am335x-moxa-uc-8100-common.dtsi          |    2 
 arch/arm/boot/dts/am33xx-l4.dtsi                           |    2 
 arch/arm/boot/dts/am437x-gp-evm.dts                        |    5 
 arch/arm/boot/dts/am437x-l4.dtsi                           |    2 
 arch/arm/boot/dts/am57xx-cl-som-am57x.dts                  |   13 -
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts               |    5 
 arch/arm/boot/dts/aspeed-bmc-opp-tacoma.dts                |    6 
 arch/arm/boot/dts/bcm-cygnus.dtsi                          |    2 
 arch/arm/boot/dts/bcm-hr2.dtsi                             |    2 
 arch/arm/boot/dts/bcm-nsp.dtsi                             |    2 
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts                      |    4 
 arch/arm/boot/dts/bcm2711.dtsi                             |    2 
 arch/arm/boot/dts/bcm2835-rpi-a-plus.dts                   |    4 
 arch/arm/boot/dts/bcm2835-rpi-a.dts                        |    2 
 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts                   |    4 
 arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts                   |    2 
 arch/arm/boot/dts/bcm2835-rpi-b.dts                        |    2 
 arch/arm/boot/dts/bcm2835-rpi-cm1.dtsi                     |    2 
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts                   |    2 
 arch/arm/boot/dts/bcm2835-rpi-zero.dts                     |    2 
 arch/arm/boot/dts/bcm2835-rpi.dtsi                         |    2 
 arch/arm/boot/dts/bcm2836-rpi-2-b.dts                      |    4 
 arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts                 |    4 
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts                 |    4 
 arch/arm/boot/dts/bcm2837-rpi-3-b.dts                      |    2 
 arch/arm/boot/dts/bcm2837-rpi-cm3.dtsi                     |    2 
 arch/arm/boot/dts/bcm283x.dtsi                             |    2 
 arch/arm/boot/dts/bcm63138.dtsi                            |    2 
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts                 |    4 
 arch/arm/boot/dts/bcm7445.dtsi                             |    2 
 arch/arm/boot/dts/bcm911360_entphn.dts                     |    4 
 arch/arm/boot/dts/bcm958300k.dts                           |    4 
 arch/arm/boot/dts/bcm958305k.dts                           |    4 
 arch/arm/boot/dts/bcm958522er.dts                          |    4 
 arch/arm/boot/dts/bcm958525er.dts                          |    4 
 arch/arm/boot/dts/bcm958525xmc.dts                         |    4 
 arch/arm/boot/dts/bcm958622hr.dts                          |    4 
 arch/arm/boot/dts/bcm958623hr.dts                          |    4 
 arch/arm/boot/dts/bcm958625hr.dts                          |    4 
 arch/arm/boot/dts/bcm958625k.dts                           |    4 
 arch/arm/boot/dts/bcm963138dvt.dts                         |    4 
 arch/arm/boot/dts/bcm988312hr.dts                          |    4 
 arch/arm/boot/dts/dm816x.dtsi                              |    2 
 arch/arm/boot/dts/dra7-ipu-dsp-common.dtsi                 |    6 
 arch/arm/boot/dts/dra7-l4.dtsi                             |    4 
 arch/arm/boot/dts/dra72x.dtsi                              |    6 
 arch/arm/boot/dts/dra74-ipu-dsp-common.dtsi                |    2 
 arch/arm/boot/dts/dra74x.dtsi                              |    8 
 arch/arm/boot/dts/gemini-dlink-dns-313.dts                 |    2 
 arch/arm/boot/dts/gemini-nas4220b.dts                      |    2 
 arch/arm/boot/dts/gemini-rut1xx.dts                        |    2 
 arch/arm/boot/dts/gemini-wbd111.dts                        |    2 
 arch/arm/boot/dts/gemini-wbd222.dts                        |    2 
 arch/arm/boot/dts/gemini.dtsi                              |    1 
 arch/arm/boot/dts/imx6dl-riotboard.dts                     |    2 
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi               |    5 
 arch/arm/boot/dts/omap4-l4.dtsi                            |    4 
 arch/arm/boot/dts/omap5-l4.dtsi                            |    4 
 arch/arm/boot/dts/rk3036-kylin.dts                         |    2 
 arch/arm/boot/dts/rk3066a.dtsi                             |    6 
 arch/arm/boot/dts/rk3188.dtsi                              |   14 -
 arch/arm/boot/dts/rk322x.dtsi                              |   12 -
 arch/arm/boot/dts/rk3288-rock2-som.dtsi                    |    2 
 arch/arm/boot/dts/rk3288-vyasa.dts                         |    4 
 arch/arm/boot/dts/rk3288.dtsi                              |   14 -
 arch/arm/boot/dts/ste-ab8500.dtsi                          |   28 +--
 arch/arm/boot/dts/ste-ab8505.dtsi                          |   24 +-
 arch/arm/boot/dts/ste-href-ab8500.dtsi                     |    2 
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi              |    3 
 arch/arm/boot/dts/ste-href.dtsi                            |    2 
 arch/arm/boot/dts/ste-snowball.dts                         |    2 
 arch/arm/boot/dts/stm32429i-eval.dts                       |    8 
 arch/arm/boot/dts/stm32746g-eval.dts                       |    6 
 arch/arm/boot/dts/stm32f429-disco.dts                      |    6 
 arch/arm/boot/dts/stm32f429.dtsi                           |   10 -
 arch/arm/boot/dts/stm32f469-disco.dts                      |    6 
 arch/arm/boot/dts/stm32f746.dtsi                           |   12 -
 arch/arm/boot/dts/stm32f769-disco.dts                      |    6 
 arch/arm/boot/dts/stm32h743.dtsi                           |    4 
 arch/arm/boot/dts/stm32mp151.dtsi                          |   12 -
 arch/arm/boot/dts/stm32mp157a-stinger96.dtsi               |    7 
 arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi             |    7 
 arch/arm/boot/dts/stm32mp157c-odyssey.dts                  |    2 
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi              |    7 
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi               |    7 
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi               |    2 
 arch/arm/boot/dts/stm32mp15xx-osd32.dtsi                   |    7 
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts            |    2 
 arch/arm/boot/dts/tegra20-harmony.dts                      |    2 
 arch/arm/boot/dts/tegra20-medcom-wide.dts                  |    2 
 arch/arm/boot/dts/tegra20-plutux.dts                       |    2 
 arch/arm/boot/dts/tegra20-seaboard.dts                     |    2 
 arch/arm/boot/dts/tegra20-tec.dts                          |    2 
 arch/arm/boot/dts/tegra20-ventana.dts                      |    2 
 arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi |    2 
 arch/arm/boot/dts/tegra30-cardhu.dtsi                      |    2 
 arch/arm/mach-imx/suspend-imx53.S                          |    4 
 arch/arm/mach-omap2/pm33xx-core.c                          |   40 ++++
 arch/arm64/boot/dts/arm/juno-base.dtsi                     |    6 
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi             |    1 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                  |   16 +
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts     |    6 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi               |    8 
 arch/arm64/boot/dts/marvell/cn9130-db.dts                  |    2 
 arch/arm64/boot/dts/qcom/sc7180-idp.dts                    |    2 
 arch/arm64/boot/dts/rockchip/px30.dtsi                     |   16 -
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts             |    4 
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s.dts         |    4 
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts             |    4 
 arch/arm64/boot/dts/rockchip/rk3328.dtsi                   |    6 
 arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi       |    2 
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi               |    4 
 arch/arm64/boot/dts/rockchip/rk3399.dtsi                   |   42 ++---
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts             |    2 
 arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts      |    2 
 arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts      |    2 
 arch/ia64/include/asm/pgtable.h                            |    5 
 arch/ia64/mm/init.c                                        |    6 
 arch/s390/include/asm/stacktrace.h                         |   97 +++++++++++
 arch/s390/kernel/traps.c                                   |    2 
 arch/x86/events/intel/uncore_snbep.c                       |    6 
 arch/x86/net/bpf_jit_comp.c                                |    3 
 drivers/dma-buf/sync_file.c                                |   13 -
 drivers/firmware/Kconfig                                   |    2 
 drivers/firmware/arm_scmi/common.h                         |    2 
 drivers/firmware/arm_scmi/driver.c                         |    2 
 drivers/firmware/tegra/Makefile                            |    1 
 drivers/firmware/tegra/bpmp-private.h                      |    3 
 drivers/firmware/tegra/bpmp.c                              |    3 
 drivers/firmware/turris-mox-rwtm.c                         |    1 
 drivers/gpu/drm/panel/panel-novatek-nt35510.c              |    4 
 drivers/memory/tegra/tegra124-emc.c                        |    4 
 drivers/memory/tegra/tegra30-emc.c                         |    4 
 drivers/net/dsa/mv88e6xxx/chip.c                           |   12 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c             |   23 --
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c         |    6 
 drivers/net/ethernet/moxa/moxart_ether.c                   |    4 
 drivers/net/ethernet/qualcomm/emac/emac.c                  |    3 
 drivers/net/ethernet/ti/tlan.c                             |    3 
 drivers/net/fddi/defza.c                                   |    3 
 drivers/net/netdevsim/ipsec.c                              |    8 
 drivers/net/vmxnet3/vmxnet3_ethtool.c                      |   22 ++
 drivers/reset/reset-ti-syscon.c                            |    4 
 drivers/rtc/rtc-max77686.c                                 |    4 
 drivers/rtc/rtc-mxc_v2.c                                   |    1 
 drivers/scsi/aic7xxx/aic7xxx_core.c                        |    2 
 drivers/scsi/aic94xx/aic94xx_init.c                        |    1 
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c                     |    1 
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c                     |    1 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                     |    1 
 drivers/scsi/isci/init.c                                   |    1 
 drivers/scsi/libfc/fc_rport.c                              |   13 -
 drivers/scsi/libsas/sas_scsi_host.c                        |    9 +
 drivers/scsi/mvsas/mv_init.c                               |    1 
 drivers/scsi/pm8001/pm8001_init.c                          |    1 
 drivers/scsi/qedf/qedf_io.c                                |   22 ++
 drivers/soc/tegra/fuse/fuse-tegra30.c                      |    3 
 drivers/thermal/imx_sc_thermal.c                           |    3 
 drivers/thermal/rcar_gen3_thermal.c                        |    5 
 drivers/thermal/sprd_thermal.c                             |   15 +
 drivers/thermal/thermal_core.c                             |    2 
 drivers/thermal/thermal_of.c                               |    3 
 drivers/usb/cdns3/gadget.c                                 |    8 
 fs/cifs/cifs_dfs_ref.c                                     |    3 
 fs/f2fs/sysfs.c                                            |    4 
 include/linux/bpf.h                                        |    1 
 include/linux/huge_mm.h                                    |    2 
 include/linux/swap.h                                       |    9 -
 include/linux/swapops.h                                    |    2 
 include/net/dst_metadata.h                                 |    4 
 include/net/ip6_route.h                                    |    2 
 include/net/tcp.h                                          |    4 
 kernel/bpf/core.c                                          |    8 
 kernel/bpf/verifier.c                                      |   60 ++-----
 kernel/sched/fair.c                                        |    4 
 mm/huge_memory.c                                           |   36 ++--
 mm/memory.c                                                |   36 +---
 mm/page_alloc.c                                            |  106 ++++++++-----
 mm/shmem.c                                                 |   14 -
 net/bridge/br_if.c                                         |   17 +-
 net/dsa/switch.c                                           |    4 
 net/ipv4/ip_tunnel.c                                       |   18 +-
 net/ipv4/tcp.c                                             |    3 
 net/ipv4/tcp_input.c                                       |    2 
 net/ipv4/tcp_ipv4.c                                        |    4 
 net/ipv4/tcp_output.c                                      |    1 
 net/ipv4/udp.c                                             |    6 
 net/ipv6/tcp_ipv6.c                                        |   21 ++
 net/ipv6/udp.c                                             |    2 
 net/ipv6/xfrm6_output.c                                    |    2 
 net/netfilter/nf_conntrack_netlink.c                       |    3 
 net/sched/act_ct.c                                         |   14 +
 scripts/Kbuild.include                                     |    7 
 scripts/mkcompile_h                                        |   14 +
 tools/bpf/Makefile                                         |    7 
 tools/bpf/bpftool/jit_disasm.c                             |    6 
 tools/perf/tests/bpf.c                                     |    2 
 201 files changed, 834 insertions(+), 568 deletions(-)

Alexander Ovechkin (1):
      net: send SYNACK packet with accepted fwmark

Alexandre Torgue (6):
      ARM: dts: stm32: fix gpio-keys node on STM32 MCU boards
      ARM: dts: stm32: fix RCC node name on stm32f429 MCU
      ARM: dts: stm32: fix timer nodes on STM32 MCU to prevent warnings
      ARM: dts: stm32: fix i2c node name on stm32f746 to prevent warnings
      ARM: dts: stm32: move stmmac axi config in ethernet node on stm32mp15
      ARM: dts: stm32: fix stpmic node for stm32mp1 boards

Andrew Jeffery (1):
      ARM: dts: tacoma: Add phase corrections for eMMC

Benjamin Gaignard (1):
      ARM: dts: rockchip: Fix IOMMU nodes properties on rk322x

Bixuan Cui (1):
      rtc: mxc_v2: add missing MODULE_DEVICE_TABLE

Colin Ian King (1):
      scsi: aic7xxx: Fix unintentional sign extension issue on left shift of u8

Corentin Labbe (2):
      ARM: dts: gemini: rename mdio to the right name
      ARM: dts: gemini: add device_type on pci

Daniel Rosenberg (1):
      f2fs: Show casefolding support only when supported

Dmitry Osipenko (4):
      ARM: tegra: wm8903: Fix polarity of headphones-detection GPIO in device-trees
      ARM: tegra: nexus7: Correct 3v3 regulator GPIO of PM269 variant
      memory: tegra: Fix compilation warnings on 64bit platforms
      thermal/core/thermal_of: Stop zone device before unregistering it

Doug Berger (1):
      net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear

Elaine Zhang (6):
      ARM: dts: rockchip: Fix power-controller node names for rk3066a
      ARM: dts: rockchip: Fix power-controller node names for rk3188
      ARM: dts: rockchip: Fix power-controller node names for rk3288
      arm64: dts: rockchip: Fix power-controller node names for px30
      arm64: dts: rockchip: Fix power-controller node names for rk3328
      arm64: dts: rockchip: Fix power-controller node names for rk3399

Eric Dumazet (3):
      tcp: annotate data races around tp->mtu_info
      ipv6: tcp: drop silly ICMPv6 packet too big messages
      udp: annotate data races around unix_sk(sk)->gso_size

Etienne Carriere (1):
      firmware: arm_scmi: Add SMCCC discovery dependency in Kconfig

Ezequiel Garcia (2):
      ARM: dts: rockchip: Fix thermal sensor cells o rk322x
      ARM: dts: rockchip: Fix the timer clocks order

Florian Fainelli (1):
      net: bcmgenet: Ensure all TX/RX queues DMAs are disabled

Geert Uytterhoeven (1):
      thermal/drivers/rcar_gen3_thermal: Do not shadow rcar_gen3_ths_tj_1

Greg Kroah-Hartman (3):
      Revert "swap: fix do_swap_page() race with swapoff"
      Revert "mm/shmem: fix shmem_swapin() race with swapoff"
      Linux 5.10.53

Grygorii Strashko (4):
      ARM: dts: am57xx-cl-som-am57x: fix ti,no-reset-on-init flag for gpios
      ARM: dts: am437x-gp-evm: fix ti,no-reset-on-init flag for gpios
      ARM: dts: am335x: fix ti,no-reset-on-init flag for gpios
      arm64: dts: ti: k3-am654x/j721e/j7200-common-proc-board: Fix MCU_RGMII1_TXC direction

Grzegorz Szymaszek (2):
      ARM: dts: stm32: fix stm32mp157c-odyssey card detect pin
      ARM: dts: stm32: fix the Odyssey SoM eMMC VQMMC supply

Gu Shengxian (1):
      bpftool: Properly close va_list 'ap' by va_end() on error

Hangbin Liu (1):
      net: ip_tunnel: fix mtu calculation for ETHER tunnel devices

Heiko Carstens (1):
      s390: introduce proper type handling call_on_stack() macro

Ilya Leoshkevich (1):
      s390/traps: do not test MONITOR CALL without CONFIG_BUG

Jason Ekstrand (1):
      dma-buf/sync_file: Don't leak fences on merge failure

Javed Hasan (2):
      scsi: libfc: Fix array index out of bound exception
      scsi: qedf: Add check to synchronize abort and flush

Joel Stanley (1):
      ARM: dts: aspeed: Fix AST2600 machines line names

Johan Jonker (4):
      ARM: dts: rockchip: fix pinctrl sleep nodename for rk3036-kylin and rk3288
      arm64: dts: rockchip: fix pinctrl sleep nodename for rk3399.dtsi
      arm64: dts: rockchip: fix regulator-gpio states array
      ARM: dts: rockchip: fix supply properties in io-domains nodes

John Fastabend (1):
      bpf: Track subprog poke descriptors correctly and fix use-after-free

Jonathan Neuschäfer (1):
      ARM: imx: pm-imx5: Fix references to imx5_cpu_suspend_info

Kan Liang (1):
      perf/x86/intel/uncore: Clean up error handling path of iio mapping

Konstantin Porotchkin (1):
      arch/arm64/boot/dts/marvell: fix NAND partitioning scheme

Krzysztof Kozlowski (3):
      thermal/drivers/imx_sc: Add missing of_node_put for loop iteration
      thermal/drivers/sprd: Add missing of_node_put for loop iteration
      rtc: max77686: Do not enforce (incorrect) interrupt trigger type

Linus Walleij (2):
      ARM: dts: ux500: Fix orientation of accelerometer
      drm/panel: nt35510: Do not fail if DSI read fails

Louis Peens (1):
      net/sched: act_ct: remove and free nf_table callbacks

Lucas Stach (1):
      arm64: dts: imx8mq: assign PCIe clocks

Marek Behún (4):
      net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz
      net: dsa: mv88e6xxx: use correct .stats_set_histogram() on Topaz
      net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz
      net: dsa: mv88e6xxx: enable devlink ATU hash param for Topaz

Marek Vasut (4):
      ARM: dts: stm32: Remove extra size-cells on dhcom-pdk2
      ARM: dts: stm32: Fix touchscreen node on dhcom-pdk2
      ARM: dts: stm32: Drop unused linux,wakeup from touchscreen node on DHCOM SoM
      ARM: dts: stm32: Rename spi-flash/mx66l51235l@N to flash@N on DHCOM SoM

Masahiro Yamada (2):
      kbuild: sink stdout from cmd for silent build
      kbuild: do not suppress Kconfig prompts for silent build

Matthias Maennich (1):
      kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set

Mian Yousaf Kaukab (1):
      arm64: dts: ls208xa: remove bus-num from dspi node

Mike Rapoport (1):
      mm/page_alloc: fix memory map initialization for descending nodes

Nguyen Dinh Phi (1):
      tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized

Odin Ugedal (1):
      sched/fair: Fix CFS bandwidth hrtimer expiry type

Oleksij Rempel (1):
      ARM: dts: imx6dl-riotboard: configure PHY clock and set proper EEE value

Pali Rohár (2):
      firmware: turris-mox-rwtm: add marvell,armada-3700-rwtm-firmware compatible string
      arm64: dts: marvell: armada-37xx: move firmware node to generic dtsi file

Paolo Abeni (1):
      tcp: consistently disable header prediction for mptcp

Paulo Alcantara (1):
      cifs: prevent NULL deref in cifs_compose_mount_options()

Pavel Skripkin (4):
      net: moxa: fix UAF in moxart_mac_probe
      net: qcom/emac: fix UAF in emac_remove
      net: ti: fix UAF in tlan_remove_one
      net: fddi: fix UAF in fza_probe

Peter Xu (2):
      mm/thp: simplify copying of huge zero page pmd when fork
      mm/userfaultfd: fix uffd-wp special cases for fork()

Philipp Zabel (1):
      reset: ti-syscon: fix to_ti_syscon_reset_data macro

Primoz Fiser (1):
      ARM: dts: imx6: phyFLEX: Fix UART hardware flow control

Rafał Miłecki (5):
      ARM: brcmstb: dts: fix NAND nodes names
      ARM: Cygnus: dts: fix NAND nodes names
      ARM: NSP: dts: fix NAND nodes names
      ARM: dts: BCM63xx: Fix NAND nodes names
      ARM: dts: Hurricane 2: Fix NAND nodes names

Riccardo Mancini (1):
      perf test bpf: Free obj_buf

Ronak Doshi (1):
      vmxnet3: fix cksum offload issues for tunnels with non-default udp ports

Sanket Parmar (1):
      usb: cdns3: Enable TDL_CHK only for OUT ep

Sebastian Reichel (2):
      ARM: dts: ux500: Fix interrupt cells
      ARM: dts: ux500: Rename gpio-controller node

Stefan Wahren (2):
      ARM: dts: bcm283x: Fix up MMC node names
      ARM: dts: bcm283x: Fix up GPIO LED node names

Sudeep Holla (2):
      firmware: arm_scmi: Fix the build when CONFIG_MAILBOX is not selected
      arm64: dts: juno: Update SCPI nodes as per the YAML schema

Sujit Kautkar (1):
      arm64: dts: qcom: sc7180: Move rmtfs memory region

Suman Anna (1):
      ARM: dts: OMAP2+: Replace underscores in sub-mailbox node names

Taehee Yoo (2):
      net: netdevsim: use xso.real_dev instead of xso.dev in callback functions of struct xfrmdev_ops
      net: validate lwtstate->data before returning from skb_tunnel_info()

Talal Ahmad (1):
      tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy path

Thierry Reding (2):
      soc/tegra: fuse: Fix Tegra234-only builds
      firmware: tegra: bpmp: Fix Tegra234-only builds

Tony Lindgren (1):
      ARM: OMAP2+: Block suspend for am3 and am4 if PM is not configured

Vadim Fedorenko (1):
      net: ipv6: fix return value of ip6_skb_dst_mtu

Vasily Averin (1):
      netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo

Vladimir Oltean (1):
      net: dsa: properly check for the bridge_leave methods in dsa_switch_bridge_leave()

Wei Li (1):
      tools: bpf: Fix error in 'make -C tools/ bpf_install'

Wolfgang Bumiller (1):
      net: bridge: sync fdb to new unicast-filtering ports

Yang Yingliang (1):
      thermal/core: Correct function name thermal_zone_device_unregister()

Yufen Yu (1):
      scsi: libsas: Add LUN number check in .slave_alloc callback

wenxu (1):
      net/sched: act_ct: fix err check for nf_conntrack_confirm

