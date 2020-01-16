Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E023F13FE07
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404179AbgAPXcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:32:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404170AbgAPXcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC94F20748;
        Thu, 16 Jan 2020 23:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217519;
        bh=cYWwDF7dBLiHZgLHs3YuWip0DQaIQ1SstguXpuyGjjI=;
        h=From:To:Cc:Subject:Date:From;
        b=0HUnPifl855s3cj8nZp1OgbxSvwoj7WOW1lJPFpNOHobX2wqxEEh+7AamdCYX5VUO
         rfhv9Wbela/iylLInm4CnYVSxr+OnzfKSdbUaRG7QJjk1bQ4jaX2/GdUfXFAURkS3+
         VChDos0hIVuYq6CJjl6dmK1pU19++IlGkFJKr3tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/71] 4.14.166-stable review
Date:   Fri, 17 Jan 2020 00:17:58 +0100
Message-Id: <20200116231709.377772748@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.166-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.166-rc1
X-KernelTest-Deadline: 2020-01-18T23:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.166 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.166-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.166-rc1

Kai Li <li.kai4@h3c.com>
    ocfs2: call journal flush to mark journal as empty after journal recovery when mount

Nick Desaulniers <ndesaulniers@google.com>
    hexagon: work around compiler crash

Nick Desaulniers <ndesaulniers@google.com>
    hexagon: parenthesize registers in asm predicates

Alexander.Barabash@dell.com <Alexander.Barabash@dell.com>
    ioat: ioat_alloc_ring() failure handling.

John Stultz <john.stultz@linaro.org>
    dmaengine: k3dma: Avoid null pointer traversal

Jouni Hogander <jouni.hogander@unikie.com>
    MIPS: Prevent link failure with kcov instrumentation

Vladimir Kondratiev <vladimir.kondratiev@intel.com>
    mips: cacheinfo: report shared CPU map

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq/selftests: Turn off timeout setting

Varun Prakash <varun@chelsio.com>
    scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()

Johnson CH Chen (陳昭勳) <JohnsonCH.Chen@moxa.com>
    gpio: mpc8xxx: Add platform device to gpiochip->parent

Kars de Jong <jongk@linux-m68k.org>
    rtc: msm6242: Fix reading of 10-hour digit

Chao Yu <yuchao0@huawei.com>
    f2fs: fix potential overflow

Nathan Chancellor <natechancellor@gmail.com>
    rtlwifi: Remove unnecessary NULL check in rtl_regd_init

Mans Rullgard <mans@mansr.com>
    spi: atmel: fix handling of cs_change set on non-last xfer

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    mtd: spi-nor: fix silent truncation in spi_nor_read_raw()

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    mtd: spi-nor: fix silent truncation in spi_nor_read()

Seung-Woo Kim <sw0312.kim@samsung.com>
    media: exynos4-is: Fix recursive locking in isp_video_release()

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix some format attributes not under control

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix incorrect use of JPEG colorspace

Peng Fan <peng.fan@nxp.com>
    tty: serial: pch_uart: correct usage of dma_unmap_sg

Peng Fan <peng.fan@nxp.com>
    tty: serial: imx: use the sg count from dma_map_sg

Oliver O'Halloran <oohall@gmail.com>
    powerpc/powernv: Disable native PCIe port management

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PTM: Remove spurious "d" from granularity message

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: handle SIOCOUTQNSD

Arnd Bergmann <arnd@arndb.de>
    af_unix: add compat_ioctl support

Loic Poulain <loic.poulain@linaro.org>
    arm64: dts: apq8096-db820c: Increase load on l21 for SDCARD

Arnd Bergmann <arnd@arndb.de>
    scsi: sd: enable compat ioctls for sed-opal

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: lewisburg: Update pin list according to v1.1v6

Colin Ian King <colin.king@canonical.com>
    pinctl: ti: iodelay: fix error checking on pinctrl_count_index_with_args call

Marian Mihailescu <mihailescu2m@gmail.com>
    clk: samsung: exynos5420: Preserve CPU clocks configuration during suspend/resume

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: fix modalias documentation

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: imu: adis16480: assign bias value only if operation succeeded

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.x: Drop the slot if nfs4_delegreturn_prepare waits for layoutreturn

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix completion wait during device removal

Jian-Hong Pan <jian-hong@endlessm.com>
    platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: sd: Clear sdkp->protection_type if disk is reformatted without PI

James Bottomley <James.Bottomley@HansenPartnership.com>
    scsi: enclosure: Fix stale device oops with hot replug

Dirk Mueller <dmueller@suse.com>
    arm64: Check for errata before evaluating cpu features

Mark Rutland <mark.rutland@arm.com>
    arm64: add sentinel to kpti_safe_list

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Report the SCSI residual to the initiator

Leon Romanovsky <leonro@mellanox.com>
    RDMA/mlx5: Return proper error value

Goldwyn Rodrigues <rgoldwyn@suse.com>
    btrfs: simplify inode locking for RWF_NOWAIT

Nathan Chancellor <natechancellor@gmail.com>
    cifs: Adjust indentation in smb2_open_file

Taehee Yoo <ap420073@gmail.com>
    hsr: reset network header when supervision frame is created

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: Fix error message on out-of-range GPIO in lookup table

Jon Derrick <jonathan.derrick@intel.com>
    iommu: Remove device link to group on failure

Swapna Manupati <swapna.manupati@xilinx.com>
    gpio: zynq: Fix for bug in zynq_gpio_restore_context API

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: spdifrx: fix race condition in irq handler

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: spdifrx: fix inconsistent lock state

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix Send Work Entry state check while polling completions

Ran Bi <ran.bi@mediatek.com>
    rtc: mt6397: fix alarm register overwrite

Tyler Hicks <tyhicks@canonical.com>
    drm/i915: Fix use-after-free when destroying GEM context

YueHaibing <yuehaibing@huawei.com>
    dccp: Fix memleak in __feat_register_sp

Navid Emamdoost <navid.emamdoost@gmail.com>
    iwlwifi: dbg_ini: fix memory leak in alloc_sgtable

Navid Emamdoost <navid.emamdoost@gmail.com>
    wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Navid Emamdoost <navid.emamdoost@gmail.com>
    wimax: i2400: fix memory leak

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix lease buffer length error

Vandana BN <bnvandana@gmail.com>
    media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_querycap

Jouni Malinen <jouni@codeaurora.org>
    mac80211: Do not send Layer 2 Update frame before authorization

Dedy Lansky <dlansky@codeaurora.org>
    cfg80211/mac80211: make ieee80211_send_layer2_update a public function

Laura Abbott <labbott@redhat.com>
    arm64: Make sure permission updates happen for pmd/pud

Will Deacon <will.deacon@arm.com>
    arm64: Enforce BBM for huge IO/VMAP mappings

Ben Hutchings <ben.hutchings@codethink.co.uk>
    arm64: mm: Change page table pointer name in p[md]_set_huge()

Kristina Martsenko <kristina.martsenko@arm.com>
    arm64: don't open code page table entry creation

Sanjay Konduri <sanjay.konduri@redpinesignals.com>
    rsi: add fix for crash during assertions

Arnd Bergmann <arnd@arndb.de>
    fs/select: avoid clang stack usage warning

Arnd Bergmann <arnd@arndb.de>
    ethtool: reduce stack usage with clang

Jiri Kosina <jkosina@suse.cz>
    HID: hidraw, uhid: Always report EPOLLOUT

Marcel Holtmann <marcel@holtmann.org>
    HID: hidraw: Fix returning EPOLLOUT from hidraw_poll

Fabian Henneke <fabian.henneke@gmail.com>
    hidraw: Return EPOLLOUT from hidraw_poll


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-mei            |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi       |   2 +
 arch/arm64/include/asm/kvm_mmu.h                   |   5 +
 arch/arm64/include/asm/pgtable.h                   |   1 +
 arch/arm64/kernel/cpufeature.c                     |   5 +-
 arch/arm64/kernel/hibernate.c                      |   3 +-
 arch/arm64/mm/mmu.c                                |  32 +++-
 arch/hexagon/include/asm/atomic.h                  |   8 +-
 arch/hexagon/include/asm/bitops.h                  |   8 +-
 arch/hexagon/include/asm/cmpxchg.h                 |   2 +-
 arch/hexagon/include/asm/futex.h                   |   6 +-
 arch/hexagon/include/asm/spinlock.h                |  20 +--
 arch/hexagon/kernel/stacktrace.c                   |   4 +-
 arch/hexagon/kernel/vm_entry.S                     |   2 +-
 arch/mips/boot/compressed/Makefile                 |   3 +
 arch/mips/kernel/cacheinfo.c                       |  27 +++-
 arch/powerpc/platforms/powernv/pci.c               |  17 ++
 drivers/clk/samsung/clk-exynos5420.c               |   2 +
 drivers/dma/ioat/dma.c                             |   3 +-
 drivers/dma/k3dma.c                                |  12 +-
 drivers/gpio/gpio-mpc8xxx.c                        |   1 +
 drivers/gpio/gpio-zynq.c                           |   8 +-
 drivers/gpio/gpiolib.c                             |   5 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |  13 +-
 drivers/hid/hidraw.c                               |   7 +-
 drivers/hid/uhid.c                                 |   5 +-
 drivers/iio/imu/adis16480.c                        |   6 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  12 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  24 +++
 drivers/iommu/iommu.c                              |   1 +
 drivers/media/i2c/ov6650.c                         |  72 ++++++---
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   2 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   3 +-
 drivers/misc/enclosure.c                           |   3 +-
 drivers/mtd/spi-nor/spi-nor.c                      |   4 +-
 drivers/net/wimax/i2400m/op-rfkill.c               |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   1 +
 drivers/net/wireless/realtek/rtlwifi/regd.c        |   2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   1 +
 drivers/pci/pcie/ptm.c                             |   2 +-
 drivers/pinctrl/intel/pinctrl-lewisburg.c          | 171 +++++++++++----------
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |   2 +-
 drivers/platform/x86/asus-wmi.c                    |   8 +-
 drivers/rtc/rtc-msm6242.c                          |   3 +-
 drivers/rtc/rtc-mt6397.c                           |  47 ++++--
 drivers/scsi/cxgbi/libcxgbi.c                      |   3 +-
 drivers/scsi/sd.c                                  |  18 ++-
 drivers/spi/spi-atmel.c                            |  10 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/pch_uart.c                      |   5 +-
 fs/btrfs/file.c                                    |   5 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/cifs/smb2pdu.c                                  |   1 +
 fs/f2fs/data.c                                     |   2 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/nfs/nfs4proc.c                                  |   4 +-
 fs/ocfs2/journal.c                                 |   8 +
 include/linux/poll.h                               |   4 +
 include/net/cfg80211.h                             |  11 ++
 net/core/ethtool.c                                 |  16 +-
 net/dccp/feat.c                                    |   7 +-
 net/hsr/hsr_device.c                               |   2 +
 net/mac80211/cfg.c                                 |  58 +------
 net/mac80211/sta_info.c                            |   4 +
 net/socket.c                                       |   1 +
 net/sunrpc/xprtrdma/verbs.c                        |   2 +-
 net/unix/af_unix.c                                 |  19 +++
 net/wireless/util.c                                |  45 ++++++
 sound/soc/stm/stm32_spdifrx.c                      |  36 +++--
 tools/testing/selftests/rseq/settings              |   1 +
 72 files changed, 540 insertions(+), 302 deletions(-)


