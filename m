Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8023D2F7B91
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbhAOND3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732842AbhAOMbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2985B23356;
        Fri, 15 Jan 2021 12:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713896;
        bh=D5XbfI0t8dUm3Yj7auA0lMrHULcoGxJfZ+/81CAvcaU=;
        h=From:To:Cc:Subject:Date:From;
        b=olR4muukfhrc4597KzeXqLAFpkOXZiRrN9wWa29Pz515diPDYMIRgHnbLgkuzCGjw
         xp8vT78gGh/vOlssmK7zMKZ0miMx756vhk+LwN1tzYu51PfFL+OatkpQus/KTakWC2
         1zxsIxpk8ZNEwy94IcL6Jj5F1eGPDAngZ6pU4A7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.14 00/28] 4.14.216-rc1 review
Date:   Fri, 15 Jan 2021 13:27:37 +0100
Message-Id: <20210115121956.731354372@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.216-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.216-rc1
X-KernelTest-Deadline: 2021-01-17T12:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.216 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.216-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.216-rc1

Vasily Averin <vvs@virtuozzo.com>
    net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

Ming Lei <ming.lei@redhat.com>
    block: fix use-after-free in disk_part_iter_next

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't access PMCR_EL0 when no PMU is available

Arnd Bergmann <arnd@arndb.de>
    wan: ds26522: select CONFIG_BITREVERSE

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net/mlx5e: Fix two double free cases

Dinghao Liu <dinghao.liu@zju.edu.cn>
    net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iommu/intel: Fix memleak in intel_irq_remapping_alloc

Arnd Bergmann <arnd@arndb.de>
    block: rsxx: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    wil6210: select CONFIG_CRC32

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: fix mixed_enum_type coverity warning

Shravya Kumbham <shravya.kumbham@xilinx.com>
    dmaengine: xilinx_dma: check dma_async_device_register return value

Roman Guskov <rguskov@dh-electronics.com>
    spi: stm32: FIFO threshold level - fix align packet size

Colin Ian King <colin.king@canonical.com>
    cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

Chunyan Zhang <chunyan.zhang@unisoc.com>
    i2c: sprd: use a specific timeout to avoid system hang up issue

Andreas Kemnade <andreas@kemnade.info>
    ARM: OMAP2+: omap_device: fix idling of devices during probe

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: fix edge-trigger interrupts

Sean Nyekjaer <sean@geanix.com>
    iio: imu: st_lsm6dsx: flip irq return logic

Lukas Wunner <lukas@wunner.de>
    spi: pxa2xx: Fix use-after-free on unbind

Richard Weinberger <richard@nod.at>
    ubifs: wbuf: Don't leak kernel memory to flash

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix mismatch between misplaced vma check and vma insert

Nick Desaulniers <ndesaulniers@google.com>
    vmlinux.lds.h: Add PGO and AutoFDO input sections

Fenghua Yu <fenghua.yu@intel.com>
    x86/resctrl: Don't move a task to the same resource group

Fenghua Yu <fenghua.yu@intel.com>
    x86/resctrl: Use an IPI instead of task_work_add() to update PQR_ASSOC MSR

Florian Westphal <fw@strlen.de>
    net: fix pmtu check in nopmtudisc mode

Florian Westphal <fw@strlen.de>
    net: ip: always refragment ip defragmented packets

Jakub Kicinski <kuba@kernel.org>
    net: vlan: avoid leaks on register_vlan_dev() failures

Jouni K. Seppänen <jks@iki.fi>
    net: cdc_ncm: correct overhead in delayed_ndp_size

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm/mach-omap2/omap_device.c               |   8 +-
 arch/arm64/kvm/sys_regs.c                       |   4 +
 arch/powerpc/include/asm/book3s/32/pgtable.h    |   4 +-
 arch/powerpc/include/asm/nohash/pgtable.h       |   4 +-
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c        | 110 +++++++++++-------------
 block/genhd.c                                   |   9 +-
 drivers/block/Kconfig                           |   1 +
 drivers/cpufreq/powernow-k8.c                   |   9 +-
 drivers/dma/xilinx/xilinx_dma.c                 |   8 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c      |   2 +-
 drivers/i2c/busses/i2c-sprd.c                   |   8 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c  |  26 ++++--
 drivers/iommu/intel_irq_remapping.c             |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c |   3 +
 drivers/net/usb/cdc_ncm.c                       |   8 +-
 drivers/net/wan/Kconfig                         |   1 +
 drivers/net/wireless/ath/wil6210/Kconfig        |   1 +
 drivers/spi/spi-pxa2xx.c                        |   3 +-
 drivers/spi/spi-stm32.c                         |   4 +-
 fs/ubifs/io.c                                   |  13 ++-
 include/asm-generic/vmlinux.lds.h               |   5 +-
 net/8021q/vlan.c                                |   3 +-
 net/core/skbuff.c                               |   6 ++
 net/ipv4/ip_output.c                            |   2 +-
 net/ipv4/ip_tunnel.c                            |  10 +--
 26 files changed, 153 insertions(+), 105 deletions(-)


