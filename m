Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7282F92A2
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbhAQNlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:41:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729122AbhAQNk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:40:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EB4220720;
        Sun, 17 Jan 2021 13:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610890749;
        bh=2OLfybMMTFpTWZ6tinyHUGz9h0zAtGT/ZW8IuHRC/WA=;
        h=From:To:Cc:Subject:Date:From;
        b=L+hTbA1pzWEqiYFm+i9jJweUSqWyKjU2X0cKPvLd/Jirq+9Q+teFM3vSodE447rOE
         B5nrqHhkhePB8BwLlmqFLcFS567gerWXlzI1K0CJlpzV9ZnJ9ww/Z0CPbq1a6TJRLH
         Npwy1Zyhh2KTCQm3KdjVcb+GXbRtnmx4FVfnWhac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.90
Date:   Sun, 17 Jan 2021 14:39:01 +0100
Message-Id: <161089074149244@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.90 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/mach-omap2/omap_device.c                       |    8 -
 arch/arm64/kvm/sys_regs.c                               |    4 
 arch/x86/entry/entry_32.S                               |    3 
 arch/x86/kernel/acpi/wakeup_32.S                        |    7 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                  |  113 ++++++----------
 arch/x86/kernel/ftrace_32.S                             |    3 
 arch/x86/kernel/head_32.S                               |    3 
 arch/x86/power/hibernate_asm_32.S                       |    6 
 arch/x86/realmode/rm/trampoline_32.S                    |    6 
 arch/x86/xen/xen-asm_32.S                               |    7 
 block/genhd.c                                           |    9 -
 drivers/base/regmap/regmap-debugfs.c                    |    9 -
 drivers/block/Kconfig                                   |    1 
 drivers/cpufreq/powernow-k8.c                           |    9 -
 drivers/crypto/chelsio/chtls/chtls_cm.c                 |   68 +++------
 drivers/dma/dw-edma/dw-edma-core.c                      |    4 
 drivers/dma/mediatek/mtk-hsdma.c                        |    1 
 drivers/dma/xilinx/xilinx_dma.c                         |   11 +
 drivers/hid/wacom_sys.c                                 |   35 ++++
 drivers/i2c/busses/i2c-i801.c                           |    2 
 drivers/i2c/busses/i2c-sprd.c                           |    8 -
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c          |   26 ++-
 drivers/iommu/intel_irq_remapping.c                     |    2 
 drivers/lightnvm/Kconfig                                |    1 
 drivers/net/can/Kconfig                                 |    1 
 drivers/net/can/m_can/m_can.c                           |    2 
 drivers/net/can/m_can/tcan4x5x.c                        |   26 ---
 drivers/net/dsa/lantiq_gswip.c                          |    7 
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h         |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |    3 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c         |   14 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c         |   14 +
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c    |   24 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c         |    3 
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c          |    2 
 drivers/net/ethernet/natsemi/macsonic.c                 |   12 +
 drivers/net/ethernet/natsemi/xtsonic.c                  |    7 
 drivers/net/ethernet/qlogic/Kconfig                     |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c       |   58 ++++++--
 drivers/net/usb/cdc_ncm.c                               |    8 -
 drivers/net/wan/Kconfig                                 |    1 
 drivers/net/wireless/ath/wil6210/Kconfig                |    1 
 drivers/regulator/qcom-rpmh-regulator.c                 |    2 
 drivers/s390/net/qeth_l3_main.c                         |    2 
 drivers/spi/spi-stm32.c                                 |    4 
 drivers/staging/exfat/exfat_super.c                     |    2 
 drivers/vfio/vfio_iommu_type1.c                         |   22 +++
 include/asm-generic/vmlinux.lds.h                       |    5 
 include/uapi/linux/vfio.h                               |   15 ++
 net/8021q/vlan.c                                        |    3 
 net/core/skbuff.c                                       |    6 
 net/ipv4/ip_output.c                                    |    2 
 net/ipv4/ip_tunnel.c                                    |   11 -
 net/ipv4/nexthop.c                                      |    4 
 net/ipv6/ip6_fib.c                                      |    5 
 tools/bpf/bpftool/net.c                                 |    1 
 tools/testing/selftests/net/pmtu.sh                     |   71 +++++++++-
 58 files changed, 453 insertions(+), 238 deletions(-)

Alan Maguire (1):
      bpftool: Fix compilation failure for net.o with older glibc

Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: Exclude RMII from modes that report 1 GbE

Andreas Kemnade (1):
      ARM: OMAP2+: omap_device: fix idling of devices during probe

Arnd Bergmann (6):
      can: kvaser_pciefd: select CONFIG_CRC32
      qed: select CONFIG_CRC32
      wil6210: select CONFIG_CRC32
      block: rsxx: select CONFIG_CRC32
      lightnvm: select CONFIG_CRC32
      wan: ds26522: select CONFIG_BITREVERSE

Aya Levin (1):
      net/mlx5e: ethtool, Fix restriction of autoneg with 56G

Ayush Sawal (6):
      chtls: Fix hardware tid leak
      chtls: Remove invalid set_tcb call
      chtls: Fix panic when route to peer not configured
      chtls: Replace skb_dequeue with skb_peek
      chtls: Added a check to avoid NULL pointer dereference
      chtls: Fix chtls resources release sequence

Christophe JAILLET (2):
      net/sonic: Fix some resource leaks in error handling paths
      dmaengine: mediatek: mtk-hsdma: Fix a resource leak in the error handling path of the probe function

Chunyan Zhang (1):
      i2c: sprd: use a specific timeout to avoid system hang up issue

Colin Ian King (2):
      octeontx2-af: fix memory leak of lmac and lmac->name
      cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

Dan Carpenter (2):
      dmaengine: dw-edma: Fix use after free in dw_edma_alloc_chunk()
      regmap: debugfs: Fix a reversed if statement in regmap_debugfs_init()

Dinghao Liu (3):
      iommu/intel: Fix memleak in intel_irq_remapping_alloc
      net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
      net/mlx5e: Fix two double free cases

Dmitry Baryshkov (1):
      regulator: qcom-rpmh-regulator: correct hfsmps515 definition

Fenghua Yu (2):
      x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR
      x86/resctrl: Don't move a task to the same resource group

Florian Westphal (2):
      net: fix pmtu check in nopmtudisc mode
      net: ip: always refragment ip defragmented packets

Greg Kroah-Hartman (1):
      Linux 5.4.90

Hans de Goede (1):
      i2c: i801: Fix the i2c-mux gpiod_lookup_table not being properly terminated

Ido Schimmel (2):
      nexthop: Fix off-by-one error in error path
      nexthop: Unlink nexthop group entry in error path

Jakub Kicinski (1):
      net: vlan: avoid leaks on register_vlan_dev() failures

Jiri Slaby (1):
      x86/asm/32: Add ENDs to some functions and relabel with SYM_CODE_*

Jouni K. Seppänen (1):
      net: cdc_ncm: correct overhead in delayed_ndp_size

Julian Wiedmann (1):
      s390/qeth: fix L2 header access in qeth_l3_osa_features_check()

Lorenzo Bianconi (1):
      iio: imu: st_lsm6dsx: fix edge-trigger interrupts

Marc Kleine-Budde (2):
      can: tcan4x5x: fix bittiming const, use common bittiming from m_can driver
      can: m_can: m_can_class_unregister(): remove erroneous m_can_clk_stop()

Marc Zyngier (1):
      KVM: arm64: Don't access PMCR_EL0 when no PMU is available

Mark Zhang (1):
      net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address

Matthew Rosato (1):
      vfio iommu: Add dma available capability

Ming Lei (1):
      block: fix use-after-free in disk_part_iter_next

Nick Desaulniers (1):
      vmlinux.lds.h: Add PGO and AutoFDO input sections

Ping Cheng (1):
      HID: wacom: Fix memory leakage caused by kfifo_alloc

Roman Guskov (1):
      spi: stm32: FIFO threshold level - fix align packet size

Samuel Holland (2):
      net: stmmac: dwmac-sun8i: Balance internal PHY resource references
      net: stmmac: dwmac-sun8i: Balance internal PHY power

Sean Tranchetti (2):
      net: ipv6: fib: flush exceptions when purging route
      tools: selftests: add test for changing routes with PTMU exceptions

Shravya Kumbham (3):
      dmaengine: xilinx_dma: check dma_async_device_register return value
      dmaengine: xilinx_dma: fix incompatible param warning in _child_probe()
      dmaengine: xilinx_dma: fix mixed_enum_type coverity warning

Stefan Chulski (1):
      net: mvpp2: disable force link UP during port init procedure

Valdis Kletnieks (1):
      exfat: Month timestamp metadata accidentally incremented

Vasily Averin (1):
      net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

Xiaolei Wang (1):
      regmap: debugfs: Fix a memory leak when calling regmap_attach_dev

Yonglong Liu (1):
      net: hns3: fix a phy loopback fail issue

Yufeng Mo (1):
      net: hns3: fix the number of queues actually used by ARQ

