Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BB7283AE2
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgJEPiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727348AbgJEPbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:31:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D949F20E65;
        Mon,  5 Oct 2020 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911873;
        bh=3oCTWDpKgJaIwKhFGxwQcMS1I5DFeWqfFmv5G1az2CM=;
        h=From:To:Cc:Subject:Date:From;
        b=ZgGNxoDuhpONxiPx52bZeHUqJWLRke5h6B2eP9eJ4rCfbb2KADg/42LUBirh2ojT3
         S1xLJXB26eWm0SjwyIilkIr4Umfc4N9+zmucpNlOq2MxGuW6f7P/Unh0AUw+BZS7WB
         uTscsh+8GPq6O2J+MPBkgi+8MT+4gqYnA6eg8mCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.8 00/85] 5.8.14-rc1 review
Date:   Mon,  5 Oct 2020 17:25:56 +0200
Message-Id: <20201005142114.732094228@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.14-rc1
X-KernelTest-Deadline: 2020-10-07T14:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.14 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.14-rc1

Al Viro <viro@zeniv.linux.org.uk>
    ep_create_wakeup_source(): dentry name can change under you...

Al Viro <viro@zeniv.linux.org.uk>
    epoll: EPOLL_CTL_ADD: close the race in decision to take fast path

Al Viro <viro@zeniv.linux.org.uk>
    epoll: replace ->visited/visited_list with generation count

Al Viro <viro@zeniv.linux.org.uk>
    epoll: do not insert into poll queues until all sanity checks are done

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: sd: sd_zbc: Fix ZBC disk initialization

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: sd: sd_zbc: Fix handling of host-aware ZBC disks

Zhenyu Wang <zhenyuw@linux.intel.com>
    drm/i915/gvt: Fix port number for BDW on EDID region setup

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: Fix line event handling in syscall compatible mode

Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
    random32: Restore __latent_entropy attribute on net_rand_state

Linus Torvalds <torvalds@linux-foundation.org>
    pipe: remove pipe_wait() and fix wakeup race with splice

Adrian Huang <ahuang12@lenovo.com>
    iommu/amd: Fix the overwritten field in IVMD header

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Correctly initialize registers 6 and 7 for PCA957x

Hanks Chen <hanks.chen@mediatek.com>
    pinctrl: mediatek: check mtk_is_virt_gpio input parameter

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    pinctrl: qcom: sm8250: correct sdc2_clk

Linus Torvalds <torvalds@linux-foundation.org>
    autofs: use __kernel_write() for the autofs pipe writing

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    scripts/dtc: only append to HOST_EXTRACFLAGS instead of overwriting

yangerkun <yangerkun@huawei.com>
    blk-mq: call commit_rqs while list empty but error happen

Vincent Huang <vincent.huang@tw.synaptics.com>
    Input: trackpoint - enable Synaptics trackpoints

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm7xx: Clear LAST bit after a failed transaction.

Nicolas VINCENT <nicolas.vincent@vossloh.com>
    i2c: cpm: Fix i2c_ram structure

Tao Ren <rentao.bupt@gmail.com>
    gpio: aspeed: fix ast2600 bank properties

Jeremy Kerr <jk@codeconstruct.com.au>
    gpio/aspeed-sgpio: don't enable all interrupts by default

Jeremy Kerr <jk@codeconstruct.com.au>
    gpio/aspeed-sgpio: enable access to all 80 input & output sgpios

Ye Li <ye.li@nxp.com>
    gpio: pca953x: Fix uninitialized pending variable

Yu Kuai <yukuai3@huawei.com>
    iommu/exynos: add missing put_device() call in exynos_iommu_of_xlate()

Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
    scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos4: mark 'chipid' clock as CLK_IGNORE_UNUSED

Vladimir Murzin <vladimir.murzin@arm.com>
    dmaengine: dmatest: Prevent to run on misconfigured channel

Thierry Reding <treding@nvidia.com>
    clk: tegra: Fix missing prototype for tegra210_clk_register_emc()

Thierry Reding <treding@nvidia.com>
    clk: tegra: Always program PLL_E when enabled

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/flexfiles: Ensure we initialise the mirror bsizes correctly on read

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2: fix client's attribute cache management for copy_file_range

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    nfs: Fix security label length not being reset

Chris Packham <chris.packham@alliedtelesis.co.nz>
    pinctrl: mvebu: Fix i2c sda definition for 98DX3236

Dan Carpenter <dan.carpenter@oracle.com>
    phy: ti: am654: Fix a leak in serdes_am654_probe()

Taiping Lai <taiping.lai@unisoc.com>
    gpio: sprd: Clear interrupt when setting the type as edge

Masahiro Yamada <masahiroy@kernel.org>
    scripts/kallsyms: skip ppc compiler stub *.long_branch.* / *.plt_branch.*

James Smart <james.smart@broadcom.com>
    nvme-fc: fail new connections to a deleted host or remote port

Xianting Tian <tian.xianting@h3c.com>
    nvme-pci: fix NULL req in completion handler

Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
    net: dsa: felix: fix some key offsets for IP4_TCP_UDP VCAP IS2 entries

Chris Packham <chris.packham@alliedtelesis.co.nz>
    spi: fsl-espi: Only process interrupts for expected events

Ulf Hansson <ulf.hansson@linaro.org>
    cpuidle: psci: Fix suspicious RCU usage

Jens Axboe <axboe@kernel.dk>
    io_uring: mark statx/files_update/epoll_ctl as non-SQPOLL

Douglas Gilbert <dgilbert@interlog.com>
    tools/io_uring: fix compile breakage

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    tracing: Make the space reserved for the pid wider

Felix Fietkau <nbd@nbd.name>
    mac80211: do not allow bigger VHT MPDUs than the hardware supports

Aloka Dixit <alokad@codeaurora.org>
    mac80211: Fix radiotap header channel flag for 6GHz band

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc: Set skb->protocol before transmitting

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Make skb->protocol consistent with the header

Al Viro <viro@zeniv.linux.org.uk>
    fuse: fix the ->direct_IO() treatment of iov_iter

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvme-core: get/put ctrl and transport module in nvme_dev_open/release()

David Milburn <dmilburn@redhat.com>
    nvme-pci: disable the write zeros command for Intel 600P/P3100

Olympia Giannou <ogiannou@gmail.com>
    rndis_host: increase sleep time in the query-response loop

Lucy Yan <lucyyan@google.com>
    net: dec: de2104x: Increase receive ring size for Tulip

Dexuan Cui <decui@microsoft.com>
    hv_netvsc: Cache the current data path to avoid duplicate call and message

Martin Cerveny <m.cerveny@computer.org>
    drm/sun4i: mixer: Extend regmap max_register

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver"

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_fr: Add needed_headroom for PVC devices

Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
    libbpf: Remove arch-specific include path in Makefile

Felix Fietkau <nbd@nbd.name>
    mt76: mt7915: use ieee80211_free_txskb to free tx skbs

Hans de Goede <hdegoede@redhat.com>
    vboxsf: Fix the check for the old binary mount-arguments struct

Guo Ren <guoren@linux.alibaba.com>
    clocksource/drivers/timer-gx6605s: Fixup counter reload

Juergen Gross <jgross@suse.com>
    xen/events: don't use chip_data for legacy IRQs

Jean Delvare <jdelvare@suse.de>
    drm/amdgpu: restore proper ref count in amdgpu_display_crtc_set_config

Kai-Heng Feng <kai.heng.feng@canonical.com>
    memstick: Skip allocating card when removing host

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Fix trace_find_next_entry() accounting of temp buffer size

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Move RCU is watching check after recursion check

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    iio: adc: qcom-spmi-adc5: fix driver name

Jiri Kosina <jkosina@suse.cz>
    Input: i8042 - add nopnp quirk for Acer Aspire 5 A515

Jean Delvare <jdelvare@suse.de>
    i2c: i801: Exclude device from suspend direct complete optimization

Mark Mielke <mark.mielke@gmail.com>
    scsi: iscsi: iscsi_tcp: Avoid holding spinlock while calling getpeername()

Dinh Nguyen <dinguyen@kernel.org>
    clk: socfpga: stratix10: fix the divider for the emac_ptp_free_clk

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: Keep top BPLL mux on Exynos542x enabled

Ed Wildgoose <lists@wildgooses.com>
    gpio: amd-fch: correct logic of GPIO_LINE_DIRECTION

dillon min <dillon.minfei@gmail.com>
    gpio: tc35894: fix up tc35894 interrupt configuration

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpio: mockup: fix resource leak in error path

Ahmad Fatoum <a.fatoum@pengutronix.de>
    gpio: siox: explicitly support only threaded irqs

M. Vefa Bicakci <m.v.b@runbox.com>
    usbcore/driver: Accommodate usbip

M. Vefa Bicakci <m.v.b@runbox.com>
    usbcore/driver: Fix incorrect downcast

M. Vefa Bicakci <m.v.b@runbox.com>
    usbcore/driver: Fix specific driver selection

M. Vefa Bicakci <m.v.b@runbox.com>
    Revert "usbip: Implement a match function to fix usbip"

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    USB: gadget: f_ncm: Fix NDP16 datagram validation

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci: Workaround broken command queuing on Intel GLK based IRBIS models

Filipe Manana <fdmanana@suse.com>
    btrfs: fix filesystem corruption after a device replace

Jens Axboe <axboe@kernel.dk>
    io_uring: always delete double poll wait entry on match


-------------

Diffstat:

 .../devicetree/bindings/gpio/sgpio-aspeed.txt      |   5 +-
 Makefile                                           |   4 +-
 block/blk-mq.c                                     |  18 +--
 block/blk-settings.c                               |  46 +++++++
 drivers/clk/samsung/clk-exynos4.c                  |   4 +-
 drivers/clk/samsung/clk-exynos5420.c               |   5 +
 drivers/clk/socfpga/clk-s10.c                      |   2 +-
 drivers/clk/tegra/clk-pll.c                        |   3 -
 drivers/clk/tegra/clk-tegra210-emc.c               |   2 +
 drivers/clocksource/timer-gx6605s.c                |   1 +
 drivers/cpuidle/cpuidle-psci.c                     |   4 +-
 drivers/dma/dmatest.c                              |  26 +++-
 drivers/gpio/gpio-amd-fch.c                        |   2 +-
 drivers/gpio/gpio-aspeed-sgpio.c                   | 134 +++++++++++++--------
 drivers/gpio/gpio-aspeed.c                         |   4 +-
 drivers/gpio/gpio-mockup.c                         |   2 +
 drivers/gpio/gpio-pca953x.c                        |   7 +-
 drivers/gpio/gpio-siox.c                           |   1 +
 drivers/gpio/gpio-sprd.c                           |   3 +
 drivers/gpio/gpio-tc3589x.c                        |   2 +-
 drivers/gpio/gpiolib.c                             |  34 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   2 +-
 drivers/gpu/drm/i915/gvt/vgpu.c                    |   6 +-
 drivers/gpu/drm/sun4i/sun8i_mixer.c                |   2 +-
 drivers/i2c/busses/i2c-cpm.c                       |   3 +
 drivers/i2c/busses/i2c-i801.c                      |   1 +
 drivers/i2c/busses/i2c-npcm7xx.c                   |   9 ++
 drivers/iio/adc/qcom-spmi-adc5.c                   |   2 +-
 drivers/input/mouse/trackpoint.c                   |   2 +
 drivers/input/serio/i8042-x86ia64io.h              |   7 ++
 drivers/iommu/amd/init.c                           |  56 ++-------
 drivers/iommu/exynos-iommu.c                       |   8 +-
 drivers/memstick/core/memstick.c                   |   4 +
 drivers/mmc/host/sdhci-pci-core.c                  |   3 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  16 +--
 drivers/net/ethernet/dec/tulip/de2104x.c           |   2 +-
 drivers/net/hyperv/hyperv_net.h                    |   3 +
 drivers/net/hyperv/netvsc_drv.c                    |  21 +++-
 drivers/net/usb/rndis_host.c                       |   2 +-
 drivers/net/wan/hdlc_cisco.c                       |   1 +
 drivers/net/wan/hdlc_fr.c                          |   6 +-
 drivers/net/wan/hdlc_ppp.c                         |   1 +
 drivers/net/wan/lapbether.c                        |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   2 +-
 drivers/net/wireless/ti/wlcore/cmd.h               |   1 -
 drivers/net/wireless/ti/wlcore/main.c              |   4 -
 drivers/nvme/host/core.c                           |  15 +++
 drivers/nvme/host/fc.c                             |   6 +-
 drivers/nvme/host/pci.c                            |  17 +--
 drivers/phy/ti/phy-am654-serdes.c                  |   6 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |   4 +
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c          |   2 +-
 drivers/pinctrl/qcom/pinctrl-sm8250.c              |   2 +-
 drivers/scsi/iscsi_tcp.c                           |  22 ++--
 drivers/scsi/sd.c                                  |  34 +++---
 drivers/scsi/sd.h                                  |  14 +--
 drivers/scsi/sd_zbc.c                              | 131 +++++++++++---------
 drivers/spi/spi-fsl-espi.c                         |   5 +-
 drivers/target/target_core_transport.c             |   3 +-
 drivers/usb/core/driver.c                          |  50 +++++---
 drivers/usb/gadget/function/f_ncm.c                |  30 +----
 drivers/usb/usbip/stub_dev.c                       |   6 -
 drivers/xen/events/events_base.c                   |  29 +++--
 fs/autofs/waitq.c                                  |   2 +-
 fs/btrfs/dev-replace.c                             |  40 +++++-
 fs/eventpoll.c                                     |  72 +++++------
 fs/fuse/file.c                                     |  25 ++--
 fs/io_uring.c                                      |   8 +-
 fs/nfs/dir.c                                       |   3 +
 fs/nfs/flexfilelayout/flexfilelayout.c             |  11 +-
 fs/nfs/nfs42proc.c                                 |  10 +-
 fs/pipe.c                                          |  62 ++++++----
 fs/read_write.c                                    |   8 ++
 fs/splice.c                                        |   8 +-
 fs/vboxsf/super.c                                  |   2 +-
 include/linux/blkdev.h                             |   2 +
 include/linux/memstick.h                           |   1 +
 include/linux/pipe_fs_i.h                          |   5 +-
 kernel/trace/ftrace.c                              |   6 +-
 kernel/trace/trace.c                               |  48 ++++----
 kernel/trace/trace_output.c                        |  12 +-
 lib/random32.c                                     |   2 +-
 net/mac80211/rx.c                                  |   3 +-
 net/mac80211/vht.c                                 |   8 +-
 scripts/dtc/Makefile                               |   2 +-
 scripts/kallsyms.c                                 |  16 ++-
 tools/io_uring/io_uring-bench.c                    |   4 +-
 tools/lib/bpf/Makefile                             |   2 +-
 89 files changed, 761 insertions(+), 462 deletions(-)


