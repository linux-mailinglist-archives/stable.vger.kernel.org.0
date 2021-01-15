Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BD52F7B56
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbhAONBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:01:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731753AbhAOMdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D5D9235F8;
        Fri, 15 Jan 2021 12:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713973;
        bh=KYree/LgwYY4RFsCVxoyGUV/aV4V+PpJEMT6mOHst1U=;
        h=From:To:Cc:Subject:Date:From;
        b=B8tTzQ3PfjHbQagjmBPCnor/5OsbfOJsGpl8t/qmnZJnDDtz99W6BLgpT90n62HAE
         etppKN+0LmEkQQ8rNx5f4WIR+MKwvfilDOI4Xd5GpUJ53q9mAAxKIpZzgr5Wq0ry5h
         +0nkaBMLnW9Kp5U5kkBPVW9N+sY2DzKFAjIT2rCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 00/43] 4.19.168-rc1 review
Date:   Fri, 15 Jan 2021 13:27:30 +0100
Message-Id: <20210115121957.037407908@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.168-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.168-rc1
X-KernelTest-Deadline: 2021-01-17T12:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.168 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.168-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.168-rc1

Dan Carpenter <dan.carpenter@oracle.com>
    regmap: debugfs: Fix a reversed if statement in regmap_debugfs_init()

Vasily Averin <vvs@virtuozzo.com>
    net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

Ming Lei <ming.lei@redhat.com>
    block: fix use-after-free in disk_part_iter_next

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't access PMCR_EL0 when no PMU is available

Arnd Bergmann <arnd@arndb.de>
    wan: ds26522: select CONFIG_BITREVERSE

Xiaolei Wang <xiaolei.wang@windriver.com>
    regmap: debugfs: Fix a memory leak when calling regmap_attach_dev

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net/mlx5e: Fix two double free cases

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iommu/intel: Fix memleak in intel_irq_remapping_alloc

Arnd Bergmann <arnd@arndb.de>
    lightnvm: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    block: rsxx: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    wil6210: select CONFIG_CRC32

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: fix mixed_enum_type coverity warning

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: fix incompatible param warning in _child_probe()

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: check dma_async_device_register return value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: mediatek: mtk-hsdma: Fix a resource leak in the error handling path of the probe function

Roman Guskov <rguskov@dh-electronics.com>
    spi: stm32: FIFO threshold level - fix align packet size

Colin Ian King <colin.king@canonical.com>
    cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

Chunyan Zhang <chunyan.zhang@unisoc.com>
    i2c: sprd: use a specific timeout to avoid system hang up issue

Andreas Kemnade <andreas@kemnade.info>
    ARM: OMAP2+: omap_device: fix idling of devices during probe

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: Fix memory leakage caused by kfifo_alloc

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: fix edge-trigger interrupts

Sean Nyekjaer <sean@geanix.com>
    iio: imu: st_lsm6dsx: flip irq return logic

Lukas Wunner <lukas@wunner.de>
    spi: pxa2xx: Fix use-after-free on unbind

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix mismatch between misplaced vma check and vma insert

Nick Desaulniers <ndesaulniers@google.com>
    vmlinux.lds.h: Add PGO and AutoFDO input sections

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

Sean Tranchetti <stranche@codeaurora.org>
    net: ipv6: fib: flush exceptions when purging route

Florian Westphal <fw@strlen.de>
    net: fix pmtu check in nopmtudisc mode

Florian Westphal <fw@strlen.de>
    net: ip: always refragment ip defragmented packets

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net/sonic: Fix some resource leaks in error handling paths

Jakub Kicinski <kuba@kernel.org>
    net: vlan: avoid leaks on register_vlan_dev() failures

Samuel Holland <samuel@sholland.org>
    net: stmmac: dwmac-sun8i: Balance internal PHY power

Samuel Holland <samuel@sholland.org>
    net: stmmac: dwmac-sun8i: Balance internal PHY resource references

Yufeng Mo <moyufeng@huawei.com>
    net: hns3: fix the number of queues actually used by ARQ

Jouni K. Seppänen <jks@iki.fi>
    net: cdc_ncm: correct overhead in delayed_ndp_size


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/mach-omap2/omap_device.c                 |   8 +-
 arch/arm64/kvm/sys_regs.c                         |   4 +
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c          | 113 ++++++++++------------
 block/genhd.c                                     |   9 +-
 drivers/base/regmap/regmap-debugfs.c              |   9 +-
 drivers/block/Kconfig                             |   1 +
 drivers/cpufreq/powernow-k8.c                     |   9 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c           |  68 +++++--------
 drivers/dma/mediatek/mtk-hsdma.c                  |   1 +
 drivers/dma/xilinx/xilinx_dma.c                   |  11 ++-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c        |   2 +-
 drivers/hid/wacom_sys.c                           |  35 ++++++-
 drivers/i2c/busses/i2c-sprd.c                     |   8 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c    |  26 ++++-
 drivers/iommu/intel_irq_remapping.c               |   2 +
 drivers/lightnvm/Kconfig                          |   1 +
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c   |   3 +
 drivers/net/ethernet/natsemi/macsonic.c           |  12 ++-
 drivers/net/ethernet/natsemi/xtsonic.c            |   7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  58 ++++++++---
 drivers/net/usb/cdc_ncm.c                         |   8 +-
 drivers/net/wan/Kconfig                           |   1 +
 drivers/net/wireless/ath/wil6210/Kconfig          |   1 +
 drivers/spi/spi-pxa2xx.c                          |   3 +-
 drivers/spi/spi-stm32.c                           |   4 +-
 include/asm-generic/vmlinux.lds.h                 |   5 +-
 net/8021q/vlan.c                                  |   3 +-
 net/core/skbuff.c                                 |   6 ++
 net/ipv4/ip_output.c                              |   2 +-
 net/ipv4/ip_tunnel.c                              |  10 +-
 net/ipv6/ip6_fib.c                                |   5 +-
 33 files changed, 268 insertions(+), 175 deletions(-)


