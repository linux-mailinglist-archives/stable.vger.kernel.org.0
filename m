Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCA03D4D9C
	for <lists+stable@lfdr.de>; Sun, 25 Jul 2021 15:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhGYMfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Jul 2021 08:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhGYMfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Jul 2021 08:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8F08608FB;
        Sun, 25 Jul 2021 13:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627218971;
        bh=2T4FIquSajRnJRDeBWK34KBHxO6JnFcinrM2a+g92yo=;
        h=From:To:Cc:Subject:Date:From;
        b=qyJmDsJrVzVBjScSk8YuvOOX+eXYgkj9uNenfBPCZSgt9J0KRVQQ0nWJqTkXYkxkj
         Zmd5tsRHuZupSGbM4QjHxwjzPXc1DB8khkeO/KzgMrRVP+yeb6qF1MKTZLij9ZS22Q
         k1wFBgJb5XZIJjjHE3O/8y/2jLRfyObn6E7ZyWNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.135
Date:   Sun, 25 Jul 2021 15:16:07 +0200
Message-Id: <16272189679463@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.135 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/arm/boot/dts/am437x-gp-evm.dts                    |    5 
 arch/arm/boot/dts/am437x-l4.dtsi                       |    2 
 arch/arm/boot/dts/am57xx-cl-som-am57x.dts              |    5 
 arch/arm/boot/dts/bcm-cygnus.dtsi                      |    2 
 arch/arm/boot/dts/bcm-hr2.dtsi                         |    2 
 arch/arm/boot/dts/bcm-nsp.dtsi                         |    2 
 arch/arm/boot/dts/bcm63138.dtsi                        |    2 
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts             |    4 
 arch/arm/boot/dts/bcm7445.dtsi                         |    2 
 arch/arm/boot/dts/bcm911360_entphn.dts                 |    4 
 arch/arm/boot/dts/bcm958300k.dts                       |    4 
 arch/arm/boot/dts/bcm958305k.dts                       |    4 
 arch/arm/boot/dts/bcm958522er.dts                      |    4 
 arch/arm/boot/dts/bcm958525er.dts                      |    4 
 arch/arm/boot/dts/bcm958525xmc.dts                     |    4 
 arch/arm/boot/dts/bcm958622hr.dts                      |    4 
 arch/arm/boot/dts/bcm958623hr.dts                      |    4 
 arch/arm/boot/dts/bcm958625hr.dts                      |    4 
 arch/arm/boot/dts/bcm958625k.dts                       |    4 
 arch/arm/boot/dts/bcm963138dvt.dts                     |    4 
 arch/arm/boot/dts/bcm988312hr.dts                      |    4 
 arch/arm/boot/dts/dra7-l4.dtsi                         |    4 
 arch/arm/boot/dts/gemini-dlink-dns-313.dts             |    2 
 arch/arm/boot/dts/gemini-nas4220b.dts                  |    2 
 arch/arm/boot/dts/gemini-rut1xx.dts                    |    2 
 arch/arm/boot/dts/gemini-wbd111.dts                    |    2 
 arch/arm/boot/dts/gemini-wbd222.dts                    |    2 
 arch/arm/boot/dts/gemini.dtsi                          |    1 
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi           |    5 
 arch/arm/boot/dts/rk3036-kylin.dts                     |    2 
 arch/arm/boot/dts/rk3066a.dtsi                         |    6 -
 arch/arm/boot/dts/rk3188.dtsi                          |   14 +-
 arch/arm/boot/dts/rk322x.dtsi                          |   10 -
 arch/arm/boot/dts/rk3288-rock2-som.dtsi                |    2 
 arch/arm/boot/dts/rk3288-vyasa.dts                     |    4 
 arch/arm/boot/dts/rk3288.dtsi                          |   14 +-
 arch/arm/boot/dts/stm32429i-eval.dts                   |    8 -
 arch/arm/boot/dts/stm32746g-eval.dts                   |    6 -
 arch/arm/boot/dts/stm32f429-disco.dts                  |    6 -
 arch/arm/boot/dts/stm32f429.dtsi                       |   10 -
 arch/arm/boot/dts/stm32f469-disco.dts                  |    6 -
 arch/arm/boot/dts/stm32f746.dtsi                       |   12 --
 arch/arm/boot/dts/stm32f769-disco.dts                  |    6 -
 arch/arm/boot/dts/stm32h743.dtsi                       |    4 
 arch/arm/boot/dts/stm32mp157c.dtsi                     |   12 +-
 arch/arm/mach-imx/suspend-imx53.S                      |    4 
 arch/arm64/boot/dts/arm/juno-base.dtsi                 |    6 -
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi         |    1 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi              |   16 ++
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts |    6 +
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi           |    8 +
 arch/arm64/boot/dts/rockchip/px30.dtsi                 |   16 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi               |    6 -
 arch/arm64/boot/dts/rockchip/rk3399.dtsi               |    2 
 arch/s390/include/asm/stacktrace.h                     |   97 +++++++++++++++++
 drivers/dma-buf/sync_file.c                            |   13 +-
 drivers/firmware/tegra/Makefile                        |    1 
 drivers/firmware/tegra/bpmp-private.h                  |    3 
 drivers/firmware/tegra/bpmp.c                          |    3 
 drivers/firmware/turris-mox-rwtm.c                     |    1 
 drivers/md/dm-writecache.c                             |   32 ++---
 drivers/net/dsa/mv88e6xxx/chip.c                       |    4 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c         |    6 +
 drivers/net/ethernet/moxa/moxart_ether.c               |    4 
 drivers/net/ethernet/qualcomm/emac/emac.c              |    3 
 drivers/net/ethernet/ti/tlan.c                         |    3 
 drivers/net/fddi/defza.c                               |    3 
 drivers/reset/reset-ti-syscon.c                        |    4 
 drivers/rtc/rtc-max77686.c                             |    4 
 drivers/rtc/rtc-mxc_v2.c                               |    1 
 drivers/scsi/aic7xxx/aic7xxx_core.c                    |    2 
 drivers/scsi/aic94xx/aic94xx_init.c                    |    1 
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c                 |    1 
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c                 |    1 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                 |    1 
 drivers/scsi/isci/init.c                               |    1 
 drivers/scsi/libfc/fc_rport.c                          |   13 +-
 drivers/scsi/libsas/sas_scsi_host.c                    |    9 +
 drivers/scsi/mvsas/mv_init.c                           |    1 
 drivers/scsi/pm8001/pm8001_init.c                      |    1 
 drivers/scsi/qedf/qedf_io.c                            |   22 +++
 drivers/soc/tegra/fuse/fuse-tegra30.c                  |    3 
 drivers/thermal/thermal_core.c                         |    2 
 drivers/usb/cdns3/gadget.c                             |    8 -
 fs/cifs/cifs_dfs_ref.c                                 |    3 
 fs/f2fs/sysfs.c                                        |    4 
 include/net/dst_metadata.h                             |    4 
 include/net/ip6_route.h                                |    2 
 kernel/sched/fair.c                                    |    4 
 mm/slab_common.c                                       |   18 +--
 net/bridge/br_if.c                                     |   17 ++
 net/ipv4/ip_tunnel.c                                   |   18 ++-
 net/ipv4/tcp_ipv4.c                                    |    4 
 net/ipv4/tcp_output.c                                  |    1 
 net/ipv4/udp.c                                         |    6 -
 net/ipv6/tcp_ipv6.c                                    |   23 +++-
 net/ipv6/udp.c                                         |    2 
 net/ipv6/xfrm6_output.c                                |    2 
 net/netfilter/nf_conntrack_netlink.c                   |    3 
 net/sched/act_ct.c                                     |    3 
 scripts/Kbuild.include                                 |    7 +
 scripts/mkcompile_h                                    |   14 +-
 tools/bpf/bpftool/jit_disasm.c                         |    6 -
 tools/perf/tests/bpf.c                                 |    2 
 105 files changed, 448 insertions(+), 226 deletions(-)

Alexander Ovechkin (1):
      net: send SYNACK packet with accepted fwmark

Alexandre Torgue (5):
      ARM: dts: stm32: fix gpio-keys node on STM32 MCU boards
      ARM: dts: stm32: fix RCC node name on stm32f429 MCU
      ARM: dts: stm32: fix timer nodes on STM32 MCU to prevent warnings
      ARM: dts: stm32: fix i2c node name on stm32f746 to prevent warnings
      ARM: dts: stm32: move stmmac axi config in ethernet node on stm32mp15

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

Elaine Zhang (5):
      ARM: dts: rockchip: Fix power-controller node names for rk3066a
      ARM: dts: rockchip: Fix power-controller node names for rk3188
      ARM: dts: rockchip: Fix power-controller node names for rk3288
      arm64: dts: rockchip: Fix power-controller node names for px30
      arm64: dts: rockchip: Fix power-controller node names for rk3328

Eric Dumazet (3):
      tcp: annotate data races around tp->mtu_info
      ipv6: tcp: drop silly ICMPv6 packet too big messages
      udp: annotate data races around unix_sk(sk)->gso_size

Ezequiel Garcia (1):
      ARM: dts: rockchip: Fix the timer clocks order

Florian Fainelli (1):
      net: bcmgenet: Ensure all TX/RX queues DMAs are disabled

Greg Kroah-Hartman (1):
      Linux 5.4.135

Grygorii Strashko (2):
      ARM: dts: am57xx-cl-som-am57x: fix ti,no-reset-on-init flag for gpios
      ARM: dts: am437x-gp-evm: fix ti,no-reset-on-init flag for gpios

Gu Shengxian (1):
      bpftool: Properly close va_list 'ap' by va_end() on error

Hangbin Liu (1):
      net: ip_tunnel: fix mtu calculation for ETHER tunnel devices

Heiko Carstens (1):
      s390: introduce proper type handling call_on_stack() macro

Jason Ekstrand (1):
      dma-buf/sync_file: Don't leak fences on merge failure

Javed Hasan (2):
      scsi: libfc: Fix array index out of bound exception
      scsi: qedf: Add check to synchronize abort and flush

Johan Jonker (3):
      ARM: dts: rockchip: fix pinctrl sleep nodename for rk3036-kylin and rk3288
      arm64: dts: rockchip: fix pinctrl sleep nodename for rk3399.dtsi
      ARM: dts: rockchip: fix supply properties in io-domains nodes

Jonathan Neuschäfer (1):
      ARM: imx: pm-imx5: Fix references to imx5_cpu_suspend_info

Krzysztof Kozlowski (1):
      rtc: max77686: Do not enforce (incorrect) interrupt trigger type

Lucas Stach (1):
      arm64: dts: imx8mq: assign PCIe clocks

Marek Behún (3):
      arm64: dts: armada-3720-turris-mox: add firmware node
      net: dsa: mv88e6xxx: enable .port_set_policy() on Topaz
      net: dsa: mv88e6xxx: enable .rmu_disable() on Topaz

Masahiro Yamada (1):
      kbuild: sink stdout from cmd for silent build

Matthias Maennich (1):
      kbuild: mkcompile_h: consider timestamp if KBUILD_BUILD_TIMESTAMP is set

Mian Yousaf Kaukab (1):
      arm64: dts: ls208xa: remove bus-num from dspi node

Mikulas Patocka (1):
      dm writecache: return the exact table values that were set

Nanyong Sun (1):
      mm: slab: fix kmem_cache_create failed when sysfs node not destroyed

Odin Ugedal (1):
      sched/fair: Fix CFS bandwidth hrtimer expiry type

Pali Rohár (2):
      firmware: turris-mox-rwtm: add marvell,armada-3700-rwtm-firmware compatible string
      arm64: dts: marvell: armada-37xx: move firmware node to generic dtsi file

Paulo Alcantara (1):
      cifs: prevent NULL deref in cifs_compose_mount_options()

Pavel Skripkin (4):
      net: moxa: fix UAF in moxart_mac_probe
      net: qcom/emac: fix UAF in emac_remove
      net: ti: fix UAF in tlan_remove_one
      net: fddi: fix UAF in fza_probe

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

Sanket Parmar (1):
      usb: cdns3: Enable TDL_CHK only for OUT ep

Sudeep Holla (1):
      arm64: dts: juno: Update SCPI nodes as per the YAML schema

Taehee Yoo (1):
      net: validate lwtstate->data before returning from skb_tunnel_info()

Thierry Reding (2):
      soc/tegra: fuse: Fix Tegra234-only builds
      firmware: tegra: bpmp: Fix Tegra234-only builds

Vadim Fedorenko (1):
      net: ipv6: fix return value of ip6_skb_dst_mtu

Vasily Averin (1):
      netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo

Wolfgang Bumiller (1):
      net: bridge: sync fdb to new unicast-filtering ports

Yang Yingliang (1):
      thermal/core: Correct function name thermal_zone_device_unregister()

Yufen Yu (1):
      scsi: libsas: Add LUN number check in .slave_alloc callback

wenxu (1):
      net/sched: act_ct: fix err check for nf_conntrack_confirm

