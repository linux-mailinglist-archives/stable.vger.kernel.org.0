Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A684636AEB8
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhDZHqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234097AbhDZHos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73461611BD;
        Mon, 26 Apr 2021 07:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422887;
        bh=19IAVKKuRyuE+573HqP1bWsRruxYkv86mi9yRDMDzBA=;
        h=From:To:Cc:Subject:Date:From;
        b=0FjaJ7WnUQavZyWVkrTHgLQfxwI3GGULKc5sfhCLSXe7YnBSC46W1NrT8ONVrAmzk
         jn3pg1vsQJOK7B2vxSpITGfSLm6iBXJ8Cs62X+lxlffYSiA/2JIYa+lxIWTvfWGANo
         6yIai7uiGnnSuEpQPEYLQkJfmznp3qyvqG8oa97o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 00/41] 5.11.17-rc1 review
Date:   Mon, 26 Apr 2021 09:29:47 +0200
Message-Id: <20210426072819.666570770@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.17-rc1
X-KernelTest-Deadline: 2021-04-28T07:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.17 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.17-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.17-rc1

Mike Galbraith <efault@gmx.de>
    x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
    ia64: tools: remove duplicate definition of ia64_mf() on ia64

Randy Dunlap <rdunlap@infradead.org>
    ia64: fix discontig.c section mismatches

Randy Dunlap <rdunlap@infradead.org>
    csky: change a Kconfig symbol name to fix e1000 build error

Wan Jiabing <wanjiabing@vivo.com>
    cavium/liquidio: Fix duplicate argument

Michael Brown <mbrown@fensystems.co.uk>
    xen-netback: Check for hotplug-status existence before watching

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    arm64: kprobes: Restore local irqflag if kprobes is cancelled

Vasily Gorbik <gor@linux.ibm.com>
    s390/entry: save the caller of psw_idle

Dinghao Liu <dinghao.liu@zju.edu.cn>
    dmaengine: tegra20: Fix runtime PM imbalance on error

Phillip Potter <phil@philpotter.co.uk>
    net: geneve: check skb is large enough for IPv4/IPv6 header

Angelo Dureghello <angelo@kernel-space.org>
    m68k: fix flatmem memory model setup

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix swapped mmc order for omap3

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    dmaengine: xilinx: dpdma: Fix race condition in done IRQ

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    dmaengine: xilinx: dpdma: Fix descriptor issuing on video group

Shawn Guo <shawn.guo@linaro.org>
    soc: qcom: geni: shield geni_icc_get() for ACPI boot

Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
    HID: wacom: Assign boolean values to a bool variable

Douglas Gilbert <dgilbert@interlog.com>
    HID cp2112: fix support for multiple gpiochips

Jia-Ju Bai <baijiaju1990@gmail.com>
    HID: alps: fix error return code in alps_input_configured()

Luke D Jones <luke@ljones.dev>
    HID: asus: Add support for 2021 ASUS N-Key keyboard

Shou-Chieh Hsu <shouchieh@chromium.org>
    HID: google: add don USB id

Zhen Lei <thunder.leizhen@huawei.com>
    perf map: Fix error return code in maps__clone()

Leo Yan <leo.yan@linaro.org>
    perf auxtrace: Fix potential NULL pointer dereference

Jim Mattson <jmattson@google.com>
    perf/x86/kvm: Fix Broadwell Xeon stepping in isolation_ucodes[]

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3

Ali Saidi <alisaidi@amazon.com>
    locking/qrwlock: Fix ordering in queued_write_lock_slowpath()

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Tighten speculative pointer arithmetic mask

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Refactor and streamline bounds check into helper

Andrei Matei <andreimatei1@gmail.com>
    bpf: Allow variable-offset stack access

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: Revert SD card CD GPIO for Pine64-LTS

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: core: Show pin numbers for the controllers with base = 0

Christoph Hellwig <hch@lst.de>
    block: return -EBUSY when there are open partitions in blkdev_reread_part

Yuanyuan Zhong <yzhong@purestorage.com>
    pinctrl: lewisburg: Update number of pins in community

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails

James Bottomley <James.Bottomley@HansenPartnership.com>
    KEYS: trusted: Fix TPM reservation for seal/unseal

Tony Lindgren <tony@atomide.com>
    gpio: omap: Save and restore sysconfig

Jiansong Chen <Jiansong.Chen@amd.com>
    drm/amdgpu: fix GCR_GENERAL_CNTL offset for dimgrey_cavefish

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: reserve fence slot to update page table

Simon Ser <contact@emersion.fr>
    amd/display: allow non-linear multi-planar formats

Christian König <christian.koenig@amd.com>
    coda: fix reference counting in coda_file_mmap error path

Christian König <christian.koenig@amd.com>
    ovl: fix reference counting in ovl_mmap error path

Xie Yongji <xieyongji@bytedance.com>
    vhost-vdpa: protect concurrent access to vhost device iotlb


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/omap3.dtsi                       |   3 +
 .../boot/dts/allwinner/sun50i-a64-pine64-lts.dts   |   2 +-
 arch/arm64/kernel/probes/kprobes.c                 |   6 +-
 arch/csky/Kconfig                                  |   2 +-
 arch/csky/include/asm/page.h                       |   2 +-
 arch/ia64/mm/discontig.c                           |   6 +-
 arch/m68k/include/asm/page_mm.h                    |   2 +-
 arch/s390/kernel/entry.S                           |   1 +
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/events/intel/uncore_snbep.c               |  61 +-
 arch/x86/kernel/crash.c                            |   2 +-
 block/ioctl.c                                      |   2 +
 drivers/dma/tegra20-apb-dma.c                      |   4 +-
 drivers/dma/xilinx/xilinx_dpdma.c                  |  31 +-
 drivers/gpio/gpio-omap.c                           |   9 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  10 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  11 +-
 drivers/hid/hid-alps.c                             |   1 +
 drivers/hid/hid-asus.c                             |   3 +
 drivers/hid/hid-cp2112.c                           |  22 +-
 drivers/hid/hid-google-hammer.c                    |   2 +
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/wacom_wac.c                            |   2 +-
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h |   2 +-
 drivers/net/geneve.c                               |   6 +
 drivers/net/xen-netback/xenbus.c                   |  12 +-
 drivers/pinctrl/core.c                             |  14 +-
 drivers/pinctrl/intel/pinctrl-lewisburg.c          |   6 +-
 drivers/soc/qcom/qcom-geni-se.c                    |   3 +
 drivers/vdpa/mlx5/core/mr.c                        |   4 +-
 drivers/vhost/vdpa.c                               |   6 +-
 fs/coda/file.c                                     |   6 +-
 fs/overlayfs/file.c                                |  11 +-
 include/linux/bpf.h                                |   5 +
 include/linux/bpf_verifier.h                       |   3 +-
 include/linux/platform_data/gpio-omap.h            |   3 +
 kernel/bpf/verifier.c                              | 771 ++++++++++++++++-----
 kernel/locking/qrwlock.c                           |   7 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   2 +-
 tools/arch/ia64/include/asm/barrier.h              |   3 -
 tools/perf/util/auxtrace.c                         |   2 +-
 tools/perf/util/map.c                              |   7 +-
 44 files changed, 756 insertions(+), 311 deletions(-)


