Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D382F92A7
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbhAQNl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729124AbhAQNkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:40:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABCD92075E;
        Sun, 17 Jan 2021 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610890756;
        bh=fXin2qYRY2O3SXcegXZVACGq6rB1AlM/DZTqL2PUYxM=;
        h=From:To:Cc:Subject:Date:From;
        b=2H3eQG6x6vuS07ufAjh8Q44SOiQx0M3mT7rhqNVV3Ld+Ae6wxxI9zo2RdaIUNcMjJ
         HTXipSCduu/xZ0ZTHIGaF8J7WOsRel9QKjkPCtptnGgkitBgdZSFWhYIHa9V7zff8B
         po2Lu7NczUsqywHEjbEbAF1CHrlza21rAzzFmCxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.8
Date:   Sun, 17 Jan 2021 14:39:07 +0100
Message-Id: <1610890747175113@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.8 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/Kconfig                                                |    6 
 arch/arm/mach-omap2/omap_device.c                           |    8 
 arch/arm64/include/asm/processor.h                          |    3 
 arch/arm64/kernel/cpufeature.c                              |    2 
 arch/arm64/kvm/sys_regs.c                                   |    4 
 arch/arm64/mm/init.c                                        |    2 
 arch/powerpc/kernel/head_book3s_32.S                        |    9 
 arch/x86/Kconfig                                            |    1 
 block/genhd.c                                               |    9 
 drivers/base/regmap/regmap-debugfs.c                        |    9 
 drivers/block/Kconfig                                       |    1 
 drivers/block/rnbd/rnbd-clt.c                               |    3 
 drivers/cpufreq/powernow-k8.c                               |    9 
 drivers/dma/dw-edma/dw-edma-core.c                          |    4 
 drivers/dma/mediatek/mtk-hsdma.c                            |    1 
 drivers/dma/milbeaut-xdmac.c                                |    4 
 drivers/dma/xilinx/xilinx_dma.c                             |   11 -
 drivers/gpu/drm/i915/display/intel_display_types.h          |    3 
 drivers/gpu/drm/i915/display/intel_dp.c                     |    8 
 drivers/gpu/drm/i915/i915_drv.c                             |    5 
 drivers/gpu/drm/i915/i915_drv.h                             |    3 
 drivers/gpu/drm/panfrost/panfrost_job.c                     |   13 -
 drivers/hid/wacom_sys.c                                     |   35 ++-
 drivers/i2c/busses/i2c-i801.c                               |    2 
 drivers/i2c/busses/i2c-mt65xx.c                             |   27 ++
 drivers/i2c/busses/i2c-sprd.c                               |    8 
 drivers/infiniband/hw/hns/hns_roce_ah.c                     |   11 -
 drivers/interconnect/imx/imx.c                              |    1 
 drivers/interconnect/qcom/Kconfig                           |   23 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c                  |    2 
 drivers/iommu/intel/dmar.c                                  |    4 
 drivers/iommu/intel/irq_remapping.c                         |    2 
 drivers/lightnvm/Kconfig                                    |    1 
 drivers/md/bcache/super.c                                   |   15 +
 drivers/net/bareudp.c                                       |   22 +-
 drivers/net/can/Kconfig                                     |    1 
 drivers/net/can/m_can/m_can.c                               |    2 
 drivers/net/can/m_can/tcan4x5x.c                            |   26 --
 drivers/net/dsa/lantiq_gswip.c                              |    7 
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c |   71 ++----
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h             |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c     |    9 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h     |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c   |    9 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h   |    2 
 drivers/net/ethernet/marvell/mvneta.c                       |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c             |   14 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c             |   14 +
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c         |    5 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c        |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c             |    3 
 drivers/net/ethernet/mellanox/mlx5/core/lag.c               |   11 -
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c              |    2 
 drivers/net/ethernet/natsemi/macsonic.c                     |   12 -
 drivers/net/ethernet/natsemi/xtsonic.c                      |    7 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c             |   12 -
 drivers/net/ethernet/qlogic/Kconfig                         |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c           |  129 +++++++-----
 drivers/net/usb/cdc_ncm.c                                   |    8 
 drivers/net/wan/Kconfig                                     |    1 
 drivers/net/wireless/ath/wil6210/Kconfig                    |    1 
 drivers/nvme/host/tcp.c                                     |   12 +
 drivers/ptp/Kconfig                                         |    2 
 drivers/regulator/qcom-rpmh-regulator.c                     |    2 
 drivers/s390/net/qeth_core.h                                |    3 
 drivers/s390/net/qeth_core_main.c                           |   38 ++-
 drivers/s390/net/qeth_l2_main.c                             |    2 
 drivers/s390/net/qeth_l3_main.c                             |    4 
 drivers/scsi/lpfc/lpfc_sli.c                                |    2 
 drivers/scsi/ufs/ufshcd.c                                   |    2 
 drivers/spi/spi-geni-qcom.c                                 |   73 ++++++
 drivers/spi/spi-stm32.c                                     |    4 
 fs/btrfs/btrfs_inode.h                                      |   16 +
 fs/btrfs/ctree.h                                            |    3 
 fs/btrfs/dev-replace.c                                      |    2 
 fs/btrfs/inode.c                                            |   69 ++++--
 fs/btrfs/ioctl.c                                            |    2 
 fs/btrfs/reflink.c                                          |   15 +
 fs/btrfs/space-info.c                                       |    4 
 fs/btrfs/tree-log.c                                         |    8 
 fs/btrfs/xattr.c                                            |    4 
 fs/io_uring.c                                               |  100 +++++----
 fs/notify/fanotify/fanotify_user.c                          |   17 -
 fs/zonefs/Kconfig                                           |    1 
 include/linux/syscalls.h                                    |   24 ++
 include/net/xdp_sock.h                                      |    4 
 include/net/xsk_buff_pool.h                                 |    5 
 net/8021q/vlan.c                                            |    3 
 net/can/isotp.c                                             |    1 
 net/core/skbuff.c                                           |    6 
 net/ipv4/ip_output.c                                        |    2 
 net/ipv4/ip_tunnel.c                                        |   11 -
 net/ipv4/nexthop.c                                          |    6 
 net/ipv6/ip6_fib.c                                          |    5 
 net/xdp/xsk.c                                               |   12 -
 net/xdp/xsk_buff_pool.c                                     |    1 
 net/xdp/xsk_queue.h                                         |    5 
 tools/bpf/bpftool/net.c                                     |    1 
 tools/include/uapi/linux/fscrypt.h                          |    5 
 tools/testing/selftests/bpf/Makefile                        |    3 
 tools/testing/selftests/net/fib_nexthops.sh                 |    2 
 tools/testing/selftests/net/pmtu.sh                         |   71 ++++++
 103 files changed, 829 insertions(+), 375 deletions(-)

Alan Maguire (1):
      bpftool: Fix compilation failure for net.o with older glibc

Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: Exclude RMII from modes that report 1 GbE

Andreas Kemnade (1):
      ARM: OMAP2+: omap_device: fix idling of devices during probe

Arnaldo Carvalho de Melo (1):
      tools headers UAPI: Sync linux/fscrypt.h with the kernel sources

Arnd Bergmann (10):
      scsi: ufs: Fix -Wsometimes-uninitialized warning
      can: kvaser_pciefd: select CONFIG_CRC32
      interconnect: qcom: fix rpmh link failures
      qed: select CONFIG_CRC32
      phy: dp83640: select CONFIG_CRC32
      wil6210: select CONFIG_CRC32
      block: rsxx: select CONFIG_CRC32
      lightnvm: select CONFIG_CRC32
      zonefs: select CONFIG_CRC32
      wan: ds26522: select CONFIG_BITREVERSE

Aya Levin (1):
      net/mlx5e: ethtool, Fix restriction of autoneg with 56G

Ayush Sawal (7):
      chtls: Fix hardware tid leak
      chtls: Remove invalid set_tcb call
      chtls: Fix panic when route to peer not configured
      chtls: Avoid unnecessary freeing of oreq pointer
      chtls: Replace skb_dequeue with skb_peek
      chtls: Added a check to avoid NULL pointer dereference
      chtls: Fix chtls resources release sequence

Bjorn Andersson (1):
      iommu/arm-smmu-qcom: Initialize SCTLR of the bypass context

Boris Brezillon (1):
      drm/panfrost: Remove unused variables in panfrost_job_close()

Brian Gerst (1):
      fanotify: Fix sys_fanotify_mark() on native x86-32

Chris Wilson (1):
      drm/i915/dp: Track pm_qos per connector

Christophe JAILLET (4):
      net/sonic: Fix some resource leaks in error handling paths
      interconnect: imx: Add a missing of_node_put after of_device_is_available
      dmaengine: mediatek: mtk-hsdma: Fix a resource leak in the error handling path of the probe function
      dmaengine: milbeaut-xdmac: Fix a resource leak in the error handling path of the probe function

Christophe Leroy (1):
      powerpc/32s: Fix RTAS machine check with VMAP stack

Chunyan Zhang (1):
      i2c: sprd: use a specific timeout to avoid system hang up issue

Colin Ian King (2):
      octeontx2-af: fix memory leak of lmac and lmac->name
      cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

Coly Li (1):
      bcache: set bcache device into read-only mode for BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET

Dan Carpenter (2):
      dmaengine: dw-edma: Fix use after free in dw_edma_alloc_chunk()
      regmap: debugfs: Fix a reversed if statement in regmap_debugfs_init()

Dinghao Liu (3):
      iommu/intel: Fix memleak in intel_irq_remapping_alloc
      net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
      net/mlx5e: Fix two double free cases

Dmitry Baryshkov (1):
      regulator: qcom-rpmh-regulator: correct hfsmps515 definition

Douglas Anderson (2):
      spi: spi-geni-qcom: Fail new xfers if xfer/cancel/abort pending
      spi: spi-geni-qcom: Fix geni_spi_isr() NULL dereference in timeout case

Filipe Manana (2):
      btrfs: skip unnecessary searches for xattrs when logging an inode
      btrfs: fix deadlock when cloning inline extent and low on free metadata space

Florian Westphal (2):
      net: fix pmtu check in nopmtudisc mode
      net: ip: always refragment ip defragmented packets

Greg Kroah-Hartman (1):
      Linux 5.10.8

Hans de Goede (1):
      i2c: i801: Fix the i2c-mux gpiod_lookup_table not being properly terminated

Ido Schimmel (3):
      nexthop: Fix off-by-one error in error path
      nexthop: Unlink nexthop group entry in error path
      selftests: fib_nexthops: Fix wrong mausezahn invocation

Jack Wang (1):
      block/rnbd-clt: avoid module unload race with close confirmation

Jakub Kicinski (2):
      net: vlan: avoid leaks on register_vlan_dev() failures
      net: bareudp: add missing error handling for bareudp_link_config()

James Smart (1):
      scsi: lpfc: Fix variable 'vport' set but not used in lpfc_sli4_abts_err_handler()

Jian Shen (1):
      net: hns3: fix incorrect handling of sctp6 rss tuple

Josef Bacik (1):
      btrfs: shrink delalloc pages instead of full inodes

Jouni K. Seppänen (1):
      net: cdc_ncm: correct overhead in delayed_ndp_size

Julian Wiedmann (3):
      s390/qeth: fix deadlock during recovery
      s390/qeth: fix locking for discipline setup / removal
      s390/qeth: fix L2 header access in qeth_l3_osa_features_check()

Kamal Mostafa (1):
      selftests/bpf: Clarify build error if no vmlinux

Lu Baolu (1):
      iommu/vt-d: Fix misuse of ALIGN in qi_flush_piotlb()

Magnus Karlsson (2):
      xsk: Fix race in SKB mode transmit with shared cq
      xsk: Rollback reservation at NETDEV_TX_BUSY

Maor Dickman (1):
      net/mlx5e: In skb build skip setting mark in switchdev mode

Marc Kleine-Budde (2):
      can: tcan4x5x: fix bittiming const, use common bittiming from m_can driver
      can: m_can: m_can_class_unregister(): remove erroneous m_can_clk_stop()

Marc Zyngier (1):
      KVM: arm64: Don't access PMCR_EL0 when no PMU is available

Marek Behún (1):
      net: mvneta: fix error message when MTU too large for XDP

Mark Zhang (2):
      net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address
      net/mlx5: Check if lag is supported before creating one

Matthew Wilcox (Oracle) (1):
      io_uring: Fix return value from alloc_fixed_file_ref_node

Ming Lei (1):
      block: fix use-after-free in disk_part_iter_next

Nicolas Saenz Julienne (1):
      arm64: mm: Fix ARCH_LOW_ADDRESS_LIMIT when !CONFIG_ZONE_DMA

Oliver Hartkopp (1):
      can: isotp: isotp_getname(): fix kernel information leak

Pavel Begunkov (3):
      io_uring: synchronise IOPOLL on task_submit fail
      io_uring: limit {io|sq}poll submit locking scope
      io_uring: patch up IOPOLL overflow_flush sync

Petr Machata (1):
      nexthop: Bounce NHA_GATEWAY in FDB nexthop groups

Ping Cheng (1):
      HID: wacom: Fix memory leakage caused by kfifo_alloc

Qii Wang (1):
      i2c: mediatek: Fix apdma and i2c hand-shake timeout

Randy Dunlap (1):
      ptp: ptp_ines: prevent build when HAS_IOMEM is not set

Roman Guskov (1):
      spi: stm32: FIFO threshold level - fix align packet size

Sagi Grimberg (1):
      nvme-tcp: Fix possible race of io_work and direct send

Samuel Holland (4):
      net: stmmac: dwmac-sun8i: Fix probe error handling
      net: stmmac: dwmac-sun8i: Balance internal PHY resource references
      net: stmmac: dwmac-sun8i: Balance internal PHY power
      net: stmmac: dwmac-sun8i: Balance syscon (de)initialization

Sean Tranchetti (2):
      net: ipv6: fib: flush exceptions when purging route
      tools: selftests: add test for changing routes with PTMU exceptions

Shannon Nelson (1):
      ionic: start queues before announcing link up

Shannon Zhao (1):
      arm64: cpufeature: remove non-exist CONFIG_KVM_ARM_HOST

Shravya Kumbham (3):
      dmaengine: xilinx_dma: check dma_async_device_register return value
      dmaengine: xilinx_dma: fix incompatible param warning in _child_probe()
      dmaengine: xilinx_dma: fix mixed_enum_type coverity warning

Stefan Chulski (1):
      net: mvpp2: disable force link UP during port init procedure

Steven Price (1):
      drm/panfrost: Don't corrupt the queue mutex on open/close

Vasily Averin (1):
      net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

Weihang Li (1):
      RDMA/hns: Avoid filling sl in high 3 bits of vlan_id

Xiaolei Wang (1):
      regmap: debugfs: Fix a memory leak when calling regmap_attach_dev

Yonglong Liu (1):
      net: hns3: fix a phy loopback fail issue

Yufeng Mo (1):
      net: hns3: fix the number of queues actually used by ARQ

