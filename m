Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA382F7AE7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbhAOMeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:34:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731804AbhAOMeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:34:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCA64224F9;
        Fri, 15 Jan 2021 12:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714039;
        bh=wRyi8idpXA5DZOMC6w5FLOMbZLjDPNGEs2P2GC7DF8s=;
        h=From:To:Cc:Subject:Date:From;
        b=lRm7omxeKq/08/TZlM1CP3xnBFZI6jn48bjuvBu9VuOBg4HWblKLzwNadrb8onese
         HEhDIRGHcFwrDUhQ8MqIODmrJcmd9UI+S9uons3LhcRUrjmJ2sBwLBRHIEvSi0oAcN
         451J/i2JsJgRRY26LlyCglmMi4ObBztsowcJk2FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/62] 5.4.90-rc1 review
Date:   Fri, 15 Jan 2021 13:27:22 +0100
Message-Id: <20210115121958.391610178@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.90-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.90-rc1
X-KernelTest-Deadline: 2021-01-17T12:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.90 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.90-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.90-rc1

Dan Carpenter <dan.carpenter@oracle.com>
    regmap: debugfs: Fix a reversed if statement in regmap_debugfs_init()

Vasily Averin <vvs@virtuozzo.com>
    net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

Ming Lei <ming.lei@redhat.com>
    block: fix use-after-free in disk_part_iter_next

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't access PMCR_EL0 when no PMU is available

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: disable force link UP during port init procedure

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    regulator: qcom-rpmh-regulator: correct hfsmps515 definition

Arnd Bergmann <arnd@arndb.de>
    wan: ds26522: select CONFIG_BITREVERSE

Xiaolei Wang <xiaolei.wang@windriver.com>
    regmap: debugfs: Fix a memory leak when calling regmap_attach_dev

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net/mlx5e: Fix two double free cases

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups

Alan Maguire <alan.maguire@oracle.com>
    bpftool: Fix compilation failure for net.o with older glibc

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iommu/intel: Fix memleak in intel_irq_remapping_alloc

Arnd Bergmann <arnd@arndb.de>
    lightnvm: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    block: rsxx: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    wil6210: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    qed: select CONFIG_CRC32

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: fix mixed_enum_type coverity warning

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: fix incompatible param warning in _child_probe()

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: check dma_async_device_register return value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: mediatek: mtk-hsdma: Fix a resource leak in the error handling path of the probe function

Hans de Goede <hdegoede@redhat.com>
    i2c: i801: Fix the i2c-mux gpiod_lookup_table not being properly terminated

Roman Guskov <rguskov@dh-electronics.com>
    spi: stm32: FIFO threshold level - fix align packet size

Douglas Anderson <dianders@chromium.org>
    spi: spi-geni-qcom: Fix geni_spi_isr() NULL dereference in timeout case

Colin Ian King <colin.king@canonical.com>
    cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

Arnd Bergmann <arnd@arndb.de>
    can: kvaser_pciefd: select CONFIG_CRC32

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_class_unregister(): remove erroneous m_can_clk_stop()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: tcan4x5x: fix bittiming const, use common bittiming from m_can driver

Dan Carpenter <dan.carpenter@oracle.com>
    dmaengine: dw-edma: Fix use after free in dw_edma_alloc_chunk()

Chunyan Zhang <chunyan.zhang@unisoc.com>
    i2c: sprd: use a specific timeout to avoid system hang up issue

Andreas Kemnade <andreas@kemnade.info>
    ARM: OMAP2+: omap_device: fix idling of devices during probe

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: Fix memory leakage caused by kfifo_alloc

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: fix edge-trigger interrupts

Nick Desaulniers <ndesaulniers@google.com>
    vmlinux.lds.h: Add PGO and AutoFDO input sections

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    exfat: Month timestamp metadata accidentally incremented

Fenghua Yu <fenghua.yu@intel.com>
    x86/resctrl: Don't move a task to the same resource group

Fenghua Yu <fenghua.yu@intel.com>
    x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Fix chtls resources release sequence

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Added a check to avoid NULL pointer dereference

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Replace skb_dequeue with skb_peek

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Fix panic when route to peer not configured

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Remove invalid set_tcb call

Ayush Sawal <ayush.sawal@chelsio.com>
    chtls: Fix hardware tid leak

Aya Levin <ayal@nvidia.com>
    net/mlx5e: ethtool, Fix restriction of autoneg with 56G

Mark Zhang <markzhang@nvidia.com>
    net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: dsa: lantiq_gswip: Exclude RMII from modes that report 1 GbE

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix L2 header access in qeth_l3_osa_features_check()

Ido Schimmel <idosch@nvidia.com>
    nexthop: Unlink nexthop group entry in error path

Ido Schimmel <idosch@nvidia.com>
    nexthop: Fix off-by-one error in error path

Colin Ian King <colin.king@canonical.com>
    octeontx2-af: fix memory leak of lmac and lmac->name

Florian Westphal <fw@strlen.de>
    net: ip: always refragment ip defragmented packets

Florian Westphal <fw@strlen.de>
    net: fix pmtu check in nopmtudisc mode

Sean Tranchetti <stranche@codeaurora.org>
    tools: selftests: add test for changing routes with PTMU exceptions

Sean Tranchetti <stranche@codeaurora.org>
    net: ipv6: fib: flush exceptions when purging route

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net/sonic: Fix some resource leaks in error handling paths

Jakub Kicinski <kuba@kernel.org>
    net: vlan: avoid leaks on register_vlan_dev() failures

Samuel Holland <samuel@sholland.org>
    net: stmmac: dwmac-sun8i: Balance internal PHY power

Samuel Holland <samuel@sholland.org>
    net: stmmac: dwmac-sun8i: Balance internal PHY resource references

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix a phy loopback fail issue

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix the number of queues actually used by ARQ

Jouni K. Seppänen <jks@iki.fi>
    net: cdc_ncm: correct overhead in delayed_ndp_size

Matthew Rosato <mjrosato@linux.ibm.com>
    vfio iommu: Add dma available capability

Jiri Slaby <jslaby@suse.cz>
    x86/asm/32: Add ENDs to some functions and relabel with SYM_CODE_*


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-omap2/omap_device.c                  |   8 +-
 arch/arm64/kvm/sys_regs.c                          |   4 +
 arch/x86/entry/entry_32.S                          |   3 +-
 arch/x86/kernel/acpi/wakeup_32.S                   |   7 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             | 113 +++++++++------------
 arch/x86/kernel/ftrace_32.S                        |   3 +-
 arch/x86/kernel/head_32.S                          |   3 +-
 arch/x86/power/hibernate_asm_32.S                  |   6 +-
 arch/x86/realmode/rm/trampoline_32.S               |   6 +-
 arch/x86/xen/xen-asm_32.S                          |   7 +-
 block/genhd.c                                      |   9 +-
 drivers/base/regmap/regmap-debugfs.c               |   9 +-
 drivers/block/Kconfig                              |   1 +
 drivers/cpufreq/powernow-k8.c                      |   9 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c            |  68 +++++--------
 drivers/dma/dw-edma/dw-edma-core.c                 |   4 +-
 drivers/dma/mediatek/mtk-hsdma.c                   |   1 +
 drivers/dma/xilinx/xilinx_dma.c                    |  11 +-
 drivers/hid/wacom_sys.c                            |  35 ++++++-
 drivers/i2c/busses/i2c-i801.c                      |   2 +-
 drivers/i2c/busses/i2c-sprd.c                      |   8 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |  26 ++++-
 drivers/iommu/intel_irq_remapping.c                |   2 +
 drivers/lightnvm/Kconfig                           |   1 +
 drivers/net/can/Kconfig                            |   1 +
 drivers/net/can/m_can/m_can.c                      |   2 -
 drivers/net/can/m_can/tcan4x5x.c                   |  26 -----
 drivers/net/dsa/lantiq_gswip.c                     |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  14 ++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  14 ++-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  24 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |   2 +-
 drivers/net/ethernet/natsemi/macsonic.c            |  12 ++-
 drivers/net/ethernet/natsemi/xtsonic.c             |   7 +-
 drivers/net/ethernet/qlogic/Kconfig                |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  58 ++++++++---
 drivers/net/usb/cdc_ncm.c                          |   8 +-
 drivers/net/wan/Kconfig                            |   1 +
 drivers/net/wireless/ath/wil6210/Kconfig           |   1 +
 drivers/regulator/qcom-rpmh-regulator.c            |   2 +-
 drivers/s390/net/qeth_l3_main.c                    |   2 +-
 drivers/spi/spi-geni-qcom.c                        |  14 +++
 drivers/spi/spi-stm32.c                            |   4 +-
 drivers/staging/exfat/exfat_super.c                |   2 +-
 drivers/vfio/vfio_iommu_type1.c                    |  22 ++++
 include/asm-generic/vmlinux.lds.h                  |   5 +-
 include/uapi/linux/vfio.h                          |  15 +++
 net/8021q/vlan.c                                   |   3 +-
 net/core/skbuff.c                                  |   6 ++
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/ip_tunnel.c                               |  11 +-
 net/ipv4/nexthop.c                                 |   4 +-
 net/ipv6/ip6_fib.c                                 |   5 +-
 tools/bpf/bpftool/net.c                            |   1 -
 tools/testing/selftests/net/pmtu.sh                |  71 ++++++++++++-
 59 files changed, 468 insertions(+), 239 deletions(-)


