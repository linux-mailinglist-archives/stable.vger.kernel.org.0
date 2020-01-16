Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B9013FDBB
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391154AbgAPX2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391156AbgAPX2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98CDE2072B;
        Thu, 16 Jan 2020 23:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217323;
        bh=npXGF/c9b9/4aVmaq/8IGza8U8TEbNRAiaNnOb+Ps+g=;
        h=From:To:Cc:Subject:Date:From;
        b=lBuHOMudGrIozqteDiFxrRT4gMWuWsToHpAu8pGRPhhzAHhnSD9PARCahURNi3bz+
         pz/sk7I2aGdFnsE+2g4a2ZrnU3n6phS9YsdM6PDjIwzIXnxJAGm4wFaa5OnvgnBJo9
         +r7H68erAlPL+zIpCQ5czz8HthGZjTye1K3rhJjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/84] 4.19.97-stable review
Date:   Fri, 17 Jan 2020 00:17:34 +0100
Message-Id: <20200116231713.087649517@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.97-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.97-rc1
X-KernelTest-Deadline: 2020-01-18T23:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.97 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.97-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.97-rc1

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

Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
    drm/arm/mali: make malidp_mw_connector_helper_funcs static

Jouni Hogander <jouni.hogander@unikie.com>
    MIPS: Prevent link failure with kcov instrumentation

Vladimir Kondratiev <vladimir.kondratiev@intel.com>
    mips: cacheinfo: report shared CPU map

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq/selftests: Turn off timeout setting

Shuah Khan <skhan@linuxfoundation.org>
    selftests: firmware: Fix it to do root uid check and skip

Varun Prakash <varun@chelsio.com>
    scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()

Johnson CH Chen (陳昭勳) <JohnsonCH.Chen@moxa.com>
    gpio: mpc8xxx: Add platform device to gpiochip->parent

Chuhong Yuan <hslester96@gmail.com>
    rtc: brcmstb-waketimer: add missed clk_disable_unprepare

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

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Correct the flush_iotlb_all callback

Seung-Woo Kim <sw0312.kim@samsung.com>
    media: exynos4-is: Fix recursive locking in isp_video_release()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: v4l: cadence: Fix how unsued lanes are handled in 'csi2rx_start()'

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: rcar-vin: Fix incorrect return statement in rvin_try_format()

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

Niklas Cassel <niklas.cassel@linaro.org>
    PCI: dwc: Fix find_next_bit() usage

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

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2: Fix a typo in encode_sattr()

Ard Biesheuvel <ardb@kernel.org>
    crypto: virtio - implement missing support for output IVs

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix completion wait during device removal

Hans de Goede <hdegoede@redhat.com>
    platform/x86: GPD pocket fan: Use default values when wrong modparams are given

Jian-Hong Pan <jian-hong@endlessm.com>
    platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: sd: Clear sdkp->protection_type if disk is reformatted without PI

James Bottomley <James.Bottomley@HansenPartnership.com>
    scsi: enclosure: Fix stale device oops with hot replug

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Report the SCSI residual to the initiator

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Return proper error value

Goldwyn Rodrigues <rgoldwyn@suse.com>
    btrfs: simplify inode locking for RWF_NOWAIT

Christian König <christian.koenig@amd.com>
    drm/ttm: fix incrementing the page pointer for huge pages

Christian König <christian.koenig@amd.com>
    drm/ttm: fix start page for huge page check in ttm_put_pages()

David Howells <dhowells@redhat.com>
    afs: Fix missing cell comparison in afs_test_super()

Nathan Chancellor <natechancellor@gmail.com>
    cifs: Adjust indentation in smb2_open_file

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: Fix vnicc_is_in_use if rx_bcast not set

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: fix false reporting of VNIC CHAR config failure

Taehee Yoo <ap420073@gmail.com>
    hsr: reset network header when supervision frame is created

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: Fix error message on out-of-range GPIO in lookup table

Jon Derrick <jonathan.derrick@intel.com>
    iommu: Remove device link to group on failure

Swapna Manupati <swapna.manupati@xilinx.com>
    gpio: zynq: Fix for bug in zynq_gpio_restore_context API

Peter Ujfalusi <peter.ujfalusi@ti.com>
    mtd: onenand: omap2: Pass correct flags for prep_dma_memcpy

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: spdifrx: fix race condition in irq handler

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: spdifrx: fix inconsistent lock state

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: soc-core: Set dpcm_playback / dpcm_capture

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix Send Work Entry state check while polling completions

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Avoid freeing MR resources if dereg fails

Ran Bi <ran.bi@mediatek.com>
    rtc: mt6397: fix alarm register overwrite

Tyler Hicks <tyhicks@canonical.com>
    drm/i915: Fix use-after-free when destroying GEM context

YueHaibing <yuehaibing@huawei.com>
    dccp: Fix memleak in __feat_register_sp

Navid Emamdoost <navid.emamdoost@gmail.com>
    RDMA: Fix goto target to release the allocated memory

Navid Emamdoost <navid.emamdoost@gmail.com>
    iwlwifi: pcie: fix memory leaks in iwl_pcie_ctxt_info_gen3_init

Navid Emamdoost <navid.emamdoost@gmail.com>
    iwlwifi: dbg_ini: fix memory leak in alloc_sgtable

Vandana BN <bnvandana@gmail.com>
    media: usb:zr364xx:Fix KASAN:null-ptr-deref Read in zr364xx_vidioc_querycap

Sheng Yong <shengyong1@huawei.com>
    f2fs: check if file namelen exceeds max value

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: check memory boundary by insane namelen

Ben Hutchings <ben.hutchings@codethink.co.uk>
    f2fs: Move err variable to function scope in f2fs_fill_dentries()

Jouni Malinen <jouni@codeaurora.org>
    mac80211: Do not send Layer 2 Update frame before authorization

Dedy Lansky <dlansky@codeaurora.org>
    cfg80211/mac80211: make ieee80211_send_layer2_update a public function

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
 drivers/crypto/virtio/virtio_crypto_algs.c         |   9 ++
 drivers/dma/ioat/dma.c                             |   3 +-
 drivers/dma/k3dma.c                                |  12 +-
 drivers/gpio/gpio-mpc8xxx.c                        |   1 +
 drivers/gpio/gpio-zynq.c                           |   8 +-
 drivers/gpio/gpiolib.c                             |   5 +-
 drivers/gpu/drm/arm/malidp_mw.c                    |   2 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |  13 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |   8 +-
 drivers/hid/hidraw.c                               |   7 +-
 drivers/hid/uhid.c                                 |   5 +-
 drivers/iio/imu/adis16480.c                        |   6 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   6 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  12 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  24 +++
 drivers/iommu/iommu.c                              |   1 +
 drivers/iommu/mtk_iommu.c                          |   2 +-
 drivers/media/i2c/ov6650.c                         |  72 ++++++---
 drivers/media/platform/cadence/cdns-csi2rx.c       |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   3 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   3 +-
 drivers/misc/enclosure.c                           |   3 +-
 drivers/mtd/nand/onenand/omap2.c                   |   3 +-
 drivers/mtd/spi-nor/spi-nor.c                      |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   1 +
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  36 +++--
 drivers/net/wireless/realtek/rtlwifi/regd.c        |   2 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |  11 +-
 drivers/pci/pcie/ptm.c                             |   2 +-
 drivers/pinctrl/intel/pinctrl-lewisburg.c          | 171 +++++++++++----------
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |   2 +-
 drivers/platform/x86/asus-wmi.c                    |   8 +-
 drivers/platform/x86/gpd-pocket-fan.c              |  25 ++-
 drivers/rtc/rtc-brcmstb-waketimer.c                |   1 +
 drivers/rtc/rtc-msm6242.c                          |   3 +-
 drivers/rtc/rtc-mt6397.c                           |  47 ++++--
 drivers/s390/net/qeth_l2_main.c                    |   4 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   3 +-
 drivers/scsi/sd.c                                  |  18 ++-
 drivers/spi/spi-atmel.c                            |  10 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/pch_uart.c                      |   5 +-
 fs/afs/super.c                                     |   1 +
 fs/btrfs/file.c                                    |   5 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/f2fs/data.c                                     |   2 +-
 fs/f2fs/dir.c                                      |  18 ++-
 fs/f2fs/file.c                                     |   2 +-
 fs/nfs/nfs2xdr.c                                   |   2 +-
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
 sound/soc/soc-core.c                               |   2 +
 sound/soc/stm/stm32_spdifrx.c                      |  36 +++--
 tools/testing/selftests/firmware/fw_lib.sh         |   6 +
 tools/testing/selftests/rseq/settings              |   1 +
 82 files changed, 603 insertions(+), 331 deletions(-)


