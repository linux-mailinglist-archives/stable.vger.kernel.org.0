Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D062F7A37
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbhAOMrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388018AbhAOMhj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A9A12256F;
        Fri, 15 Jan 2021 12:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714218;
        bh=VJXbaVBq0P4wFh+tydFrZ9ym4Vy7JY2//hhMI/2mKS8=;
        h=From:To:Cc:Subject:Date:From;
        b=bnOM2O/QNISz5IoLwSWsutrDbGrfwEZLwR/mUiNXPGFfdEYnAfaFgtHFodqed/G4I
         rolPWjmd2U43v4JKoMAXWEQ6bxI5sHZ2S4iMEZOfmQmDbwuNecA+sthZLrXr2ZVG1V
         eA/RaYi/j4lMkWjVwky9fk4uydH9rOSgOLOixsnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.10 000/103] 5.10.8-rc1 review
Date:   Fri, 15 Jan 2021 13:26:53 +0100
Message-Id: <20210115122006.047132306@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.8-rc1
X-KernelTest-Deadline: 2021-01-17T12:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.8 release.
There are 103 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.8-rc1

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools headers UAPI: Sync linux/fscrypt.h with the kernel sources

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Remove unused variables in panfrost_job_close()

Dan Carpenter <dan.carpenter@oracle.com>
    regmap: debugfs: Fix a reversed if statement in regmap_debugfs_init()

Vasily Averin <vvs@virtuozzo.com>
    net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

Ming Lei <ming.lei@redhat.com>
    block: fix use-after-free in disk_part_iter_next

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: isotp_getname(): fix kernel information leak

Jack Wang <jinpu.wang@cloud.ionos.com>
    block/rnbd-clt: avoid module unload race with close confirmation

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Rollback reservation at NETDEV_TX_BUSY

Magnus Karlsson <magnus.karlsson@intel.com>
    xsk: Fix race in SKB mode transmit with shared cq

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't access PMCR_EL0 when no PMU is available

Ido Schimmel <idosch@nvidia.com>
    selftests: fib_nexthops: Fix wrong mausezahn invocation

Marek Behún <kabel@kernel.org>
    net: mvneta: fix error message when MTU too large for XDP

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/dp: Track pm_qos per connector

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: disable force link UP during port init procedure

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    regulator: qcom-rpmh-regulator: correct hfsmps515 definition

Shannon Zhao <shannon.zhao@linux.alibaba.com>
    arm64: cpufeature: remove non-exist CONFIG_KVM_ARM_HOST

Arnd Bergmann <arnd@arndb.de>
    wan: ds26522: select CONFIG_BITREVERSE

Xiaolei Wang <xiaolei.wang@windriver.com>
    regmap: debugfs: Fix a memory leak when calling regmap_attach_dev

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net/mlx5e: Fix two double free cases

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: Fix possible race of io_work and direct send

Alan Maguire <alan.maguire@oracle.com>
    bpftool: Fix compilation failure for net.o with older glibc

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iommu/intel: Fix memleak in intel_irq_remapping_alloc

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix misuse of ALIGN in qi_flush_piotlb()

Arnd Bergmann <arnd@arndb.de>
    zonefs: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    lightnvm: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    block: rsxx: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    wil6210: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    phy: dp83640: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    qed: select CONFIG_CRC32

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    arm64: mm: Fix ARCH_LOW_ADDRESS_LIMIT when !CONFIG_ZONE_DMA

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: fix mixed_enum_type coverity warning

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: fix incompatible param warning in _child_probe()

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: check dma_async_device_register return value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: milbeaut-xdmac: Fix a resource leak in the error handling path of the probe function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: mediatek: mtk-hsdma: Fix a resource leak in the error handling path of the probe function

Arnd Bergmann <arnd@arndb.de>
    interconnect: qcom: fix rpmh link failures

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    interconnect: imx: Add a missing of_node_put after of_device_is_available

Coly Li <colyli@suse.de>
    bcache: set bcache device into read-only mode for BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET

Qii Wang <qii.wang@mediatek.com>
    i2c: mediatek: Fix apdma and i2c hand-shake timeout

Hans de Goede <hdegoede@redhat.com>
    i2c: i801: Fix the i2c-mux gpiod_lookup_table not being properly terminated

Roman Guskov <rguskov@dh-electronics.com>
    spi: stm32: FIFO threshold level - fix align packet size

Douglas Anderson <dianders@chromium.org>
    spi: spi-geni-qcom: Fix geni_spi_isr() NULL dereference in timeout case

Colin Ian King <colin.king@canonical.com>
    cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

Douglas Anderson <dianders@chromium.org>
    spi: spi-geni-qcom: Fail new xfers if xfer/cancel/abort pending

Arnd Bergmann <arnd@arndb.de>
    can: kvaser_pciefd: select CONFIG_CRC32

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_class_unregister(): remove erroneous m_can_clk_stop()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: tcan4x5x: fix bittiming const, use common bittiming from m_can driver

Kamal Mostafa <kamal@canonical.com>
    selftests/bpf: Clarify build error if no vmlinux

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: dw-edma: Fix use after free in dw_edma_alloc_chunk()

Chunyan Zhang <chunyan.zhang@unisoc.com>
    i2c: sprd: use a specific timeout to avoid system hang up issue

Andreas Kemnade <andreas@kemnade.info>
    ARM: OMAP2+: omap_device: fix idling of devices during probe

Brian Gerst <brgerst@gmail.com>
    fanotify: Fix sys_fanotify_mark() on native x86-32

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: Fix memory leakage caused by kfifo_alloc

Shannon Nelson <snelson@pensando.io>
    ionic: start queues before announcing link up

James Smart <james.smart@broadcom.com>
    scsi: lpfc: Fix variable 'vport' set but not used in lpfc_sli4_abts_err_handler()

Mark Zhang <markzhang@nvidia.com>
    net/mlx5: Check if lag is supported before creating one

Maor Dickman <maord@nvidia.com>
    net/mlx5e: In skb build skip setting mark in switchdev mode

Aya Levin <ayal@nvidia.com>
    net/mlx5e: ethtool, Fix restriction of autoneg with 56G

Mark Zhang <markzhang@nvidia.com>
    net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: dsa: lantiq_gswip: Exclude RMII from modes that report 1 GbE

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix L2 header access in qeth_l3_osa_features_check()

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix locking for discipline setup / removal

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix deadlock during recovery

Petr Machata <petrm@nvidia.com>
    nexthop: Bounce NHA_GATEWAY in FDB nexthop groups

Ido Schimmel <idosch@nvidia.com>
    nexthop: Unlink nexthop group entry in error path

Ido Schimmel <idosch@nvidia.com>
    nexthop: Fix off-by-one error in error path

Colin Ian King <colin.king@canonical.com>
    octeontx2-af: fix memory leak of lmac and lmac->name

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Fix chtls resources release sequence

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Added a check to avoid NULL pointer dereference

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Replace skb_dequeue with skb_peek

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Avoid unnecessary freeing of oreq pointer

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Fix panic when route to peer not configured

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Remove invalid set_tcb call

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Fix hardware tid leak

Florian Westphal <fw@strlen.de>
    net: ip: always refragment ip defragmented packets

Florian Westphal <fw@strlen.de>
    net: fix pmtu check in nopmtudisc mode

Sean Tranchetti <stranche@codeaurora.org>
    tools: selftests: add test for changing routes with PTMU exceptions

Sean Tranchetti <stranche@codeaurora.org>
    net: ipv6: fib: flush exceptions when purging route

Randy Dunlap <rdunlap@infradead.org>
    ptp: ptp_ines: prevent build when HAS_IOMEM is not set

Jakub Kicinski <kuba@kernel.org>
    net: bareudp: add missing error handling for bareudp_link_config()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net/sonic: Fix some resource leaks in error handling paths

Jakub Kicinski <kuba@kernel.org>
    net: vlan: avoid leaks on register_vlan_dev() failures

Samuel Holland <samuel@sholland.org>
    net: stmmac: dwmac-sun8i: Balance syscon (de)initialization

Samuel Holland <samuel@sholland.org>
    net: stmmac: dwmac-sun8i: Balance internal PHY power

Samuel Holland <samuel@sholland.org>
    net: stmmac: dwmac-sun8i: Balance internal PHY resource references

Samuel Holland <samuel@sholland.org>
    net: stmmac: dwmac-sun8i: Fix probe error handling

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix a phy loopback fail issue

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix the number of queues actually used by ARQ

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix incorrect handling of sctp6 rss tuple

Jouni K. Seppänen <jks@iki.fi>
    net: cdc_ncm: correct overhead in delayed_ndp_size

Josef Bacik <josef@toxicpanda.com>
    btrfs: shrink delalloc pages instead of full inodes

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock when cloning inline extent and low on free metadata space

Filipe Manana <fdmanana@suse.com>
    btrfs: skip unnecessary searches for xattrs when logging an inode

Arnd Bergmann <arnd@arndb.de>
    scsi: ufs: Fix -Wsometimes-uninitialized warning

Matthew Wilcox (Oracle) <willy@infradead.org>
    io_uring: Fix return value from alloc_fixed_file_ref_node

Steven Price <steven.price@arm.com>
    drm/panfrost: Don't corrupt the queue mutex on open/close

Bjorn Andersson <bjorn.andersson@linaro.org>
    iommu/arm-smmu-qcom: Initialize SCTLR of the bypass context

Weihang Li <liweihang@huawei.com>
    RDMA/hns: Avoid filling sl in high 3 bits of vlan_id

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: patch up IOPOLL overflow_flush sync

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: limit {io|sq}poll submit locking scope

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: synchronise IOPOLL on task_submit fail

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Fix RTAS machine check with VMAP stack


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/Kconfig                                       |   6 +
 arch/arm/mach-omap2/omap_device.c                  |   8 +-
 arch/arm64/include/asm/processor.h                 |   3 +-
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kvm/sys_regs.c                          |   4 +
 arch/arm64/mm/init.c                               |   2 +-
 arch/powerpc/kernel/head_book3s_32.S               |   9 ++
 arch/x86/Kconfig                                   |   1 +
 block/genhd.c                                      |   9 +-
 drivers/base/regmap/regmap-debugfs.c               |   9 +-
 drivers/block/Kconfig                              |   1 +
 drivers/block/rnbd/rnbd-clt.c                      |   3 +-
 drivers/cpufreq/powernow-k8.c                      |   9 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |   4 +-
 drivers/dma/mediatek/mtk-hsdma.c                   |   1 +
 drivers/dma/milbeaut-xdmac.c                       |   4 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  11 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   3 +
 drivers/gpu/drm/i915/display/intel_dp.c            |   8 +-
 drivers/gpu/drm/i915/i915_drv.c                    |   5 -
 drivers/gpu/drm/i915/i915_drv.h                    |   3 -
 drivers/gpu/drm/panfrost/panfrost_job.c            |  13 +--
 drivers/hid/wacom_sys.c                            |  35 +++++-
 drivers/i2c/busses/i2c-i801.c                      |   2 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |  27 ++++-
 drivers/i2c/busses/i2c-sprd.c                      |   8 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |  11 +-
 drivers/interconnect/imx/imx.c                     |   1 +
 drivers/interconnect/qcom/Kconfig                  |  23 ++--
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   2 +
 drivers/iommu/intel/dmar.c                         |   4 +-
 drivers/iommu/intel/irq_remapping.c                |   2 +
 drivers/lightnvm/Kconfig                           |   1 +
 drivers/md/bcache/super.c                          |  15 +++
 drivers/net/bareudp.c                              |  22 ++--
 drivers/net/can/Kconfig                            |   1 +
 drivers/net/can/m_can/m_can.c                      |   2 -
 drivers/net/can/m_can/tcan4x5x.c                   |  26 -----
 drivers/net/dsa/lantiq_gswip.c                     |   7 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |  71 ++++--------
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   9 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   2 +
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  14 ++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  14 ++-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  24 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |   2 +-
 drivers/net/ethernet/natsemi/macsonic.c            |  12 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |   7 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  12 +-
 drivers/net/ethernet/qlogic/Kconfig                |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  | 129 +++++++++++++--------
 drivers/net/usb/cdc_ncm.c                          |   8 +-
 drivers/net/wan/Kconfig                            |   1 +
 drivers/net/wireless/ath/wil6210/Kconfig           |   1 +
 drivers/nvme/host/tcp.c                            |  12 +-
 drivers/ptp/Kconfig                                |   2 +
 drivers/regulator/qcom-rpmh-regulator.c            |   2 +-
 drivers/s390/net/qeth_core.h                       |   3 +-
 drivers/s390/net/qeth_core_main.c                  |  38 +++---
 drivers/s390/net/qeth_l2_main.c                    |   2 +-
 drivers/s390/net/qeth_l3_main.c                    |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   2 -
 drivers/scsi/ufs/ufshcd.c                          |   2 +-
 drivers/spi/spi-geni-qcom.c                        |  73 +++++++++++-
 drivers/spi/spi-stm32.c                            |   4 +-
 fs/btrfs/btrfs_inode.h                             |  16 +++
 fs/btrfs/ctree.h                                   |   3 +-
 fs/btrfs/dev-replace.c                             |   2 +-
 fs/btrfs/inode.c                                   |  69 ++++++++---
 fs/btrfs/ioctl.c                                   |   2 +-
 fs/btrfs/reflink.c                                 |  15 +++
 fs/btrfs/space-info.c                              |   4 +-
 fs/btrfs/tree-log.c                                |   8 ++
 fs/btrfs/xattr.c                                   |   4 +-
 fs/io_uring.c                                      | 100 ++++++++--------
 fs/notify/fanotify/fanotify_user.c                 |  17 ++-
 fs/zonefs/Kconfig                                  |   1 +
 include/linux/syscalls.h                           |  24 ++++
 include/net/xdp_sock.h                             |   4 -
 include/net/xsk_buff_pool.h                        |   5 +
 net/8021q/vlan.c                                   |   3 +-
 net/can/isotp.c                                    |   1 +
 net/core/skbuff.c                                  |   6 +
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/ip_tunnel.c                               |  11 +-
 net/ipv4/nexthop.c                                 |   6 +-
 net/ipv6/ip6_fib.c                                 |   5 +-
 net/xdp/xsk.c                                      |  12 +-
 net/xdp/xsk_buff_pool.c                            |   1 +
 net/xdp/xsk_queue.h                                |   5 +
 tools/bpf/bpftool/net.c                            |   1 -
 tools/include/uapi/linux/fscrypt.h                 |   5 +-
 tools/testing/selftests/bpf/Makefile               |   3 +
 tools/testing/selftests/net/fib_nexthops.sh        |   2 +-
 tools/testing/selftests/net/pmtu.sh                |  71 +++++++++++-
 103 files changed, 830 insertions(+), 376 deletions(-)


