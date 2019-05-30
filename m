Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F7B2EC6A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732300AbfE3DUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732286AbfE3DUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:41 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0594248FC;
        Thu, 30 May 2019 03:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186440;
        bh=dif0gm2K31Zv2AceBP2r9J+xYQRqzyhlGdw8MrdJBnw=;
        h=From:To:Cc:Subject:Date:From;
        b=nkb5qm4xCLxiRo/CpU6TqcXvo1Slo9r6kMuD3O/OVx6P0z3QcUJfWzweLUvhI1dEK
         e7Tqgxm9ZkRJAvhg919r67ylFH1BZLyJ/EmgsOw0hFosjuvhBUFZtUipqfPD7gamAq
         0n0HFAAVwEZHEXysnsoNRTtqbfpQ7gzeq7u4uEcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/128] 4.9.180-stable review
Date:   Wed, 29 May 2019 20:05:32 -0700
Message-Id: <20190530030432.977908967@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.180-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.180-rc1
X-KernelTest-Deadline: 2019-06-01T03:04+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.180 release.
There are 128 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 01 Jun 2019 03:02:06 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.180-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.180-rc1

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Wake up next in drm_read() chain if we are forced to putback the event

Arnd Bergmann <arnd@arndb.de>
    ASoC: davinci-mcasp: Fix clang warning without CONFIG_PM

Chris Lesiak <chris.lesiak@licor.com>
    spi: Fix zero length xfer bug

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: rspi: Fix sequencer reset during initialization

Aditya Pakki <pakki001@umn.edu>
    spi : spi-topcliff-pch: Fix to handle empty DMA buffers

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices

Arnd Bergmann <arnd@arndb.de>
    media: saa7146: avoid high stack usage with clang

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix FDMI manufacturer attribute value

Arnd Bergmann <arnd@arndb.de>
    media: go7007: avoid clang frame overflow warning with KASAN

James Hutchinson <jahutchinson99@googlemail.com>
    media: m88ds3103: serialize reset messages in m88ds3103_set_frontend

Sameer Pujar <spujar@nvidia.com>
    dmaengine: tegra210-adma: use devm_clk_*() helpers

Arnd Bergmann <arnd@arndb.de>
    scsi: qla4xxx: avoid freeing unallocated dma memory

Tony Lindgren <tony@atomide.com>
    usb: core: Add PM runtime calls to usb_hcd_platform_shutdown

Paul E. McKenney <paulmck@linux.ibm.com>
    rcuperf: Fix cleanup path for invalid perf_type strings

Paul E. McKenney <paulmck@linux.ibm.com>
    rcutorture: Fix cleanup path for invalid torture_type strings

Tony Luck <tony.luck@intel.com>
    x86/mce: Fix machine_check_poll() tests for error types

Kangjie Lu <kjlu@umn.edu>
    tty: ipwireless: fix missing checks for ioremap

Pankaj Gupta <pagupta@redhat.com>
    virtio_console: initialize vtermno value for ports

Dan Carpenter <dan.carpenter@oracle.com>
    media: wl128x: prevent two potential buffer overflows

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: reset controller on probe

Gustavo A. R. Silva <gustavo@embeddedor.com>
    cxgb3/l2t: Fix undefined behaviour

Wen Yang <wen.yang99@zte.com.cn>
    ASoC: fsl_utils: fix a leaked reference by adding missing of_node_put

Wen Yang <wen.yang99@zte.com.cn>
    ASoC: eukrea-tlv320: fix a leaked reference by adding missing of_node_put

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    HID: core: move Usage Page concatenation to Main item

Chengguang Xu <cgxu519@gmx.com>
    chardev: add additional check for minor range overlap

Peter Zijlstra <peterz@infradead.org>
    x86/ia32: Fix ia32_restore_sigcontext() AC leak

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, signal: Fix AC=1 bloat

Wen Yang <wen.yang99@zte.com.cn>
    arm64: cpu_ops: fix a leaked reference by adding missing of_node_put

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Avoid configuring regulator with undefined voltage range

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix regulator load and icc-level configuration

Piotr Figiel <p.figiel@camlintechnologies.com>
    brcmfmac: fix Oops when bringing up interface during USB disconnect

Piotr Figiel <p.figiel@camlintechnologies.com>
    brcmfmac: fix race during disconnect when USB completion is in progress

Piotr Figiel <p.figiel@camlintechnologies.com>
    brcmfmac: convert dev_init_lock mutex to completion

Arnd Bergmann <arnd@arndb.de>
    b43: shut up clang -Wuninitialized variable warning

Kangjie Lu <kjlu@umn.edu>
    brcmfmac: fix missing checks for kmemdup

YueHaibing <yuehaibing@huawei.com>
    mwifiex: Fix mem leak in mwifiex_tm_cmd

Kangjie Lu <kjlu@umn.edu>
    rtlwifi: fix a potential NULL pointer dereference

Nathan Chancellor <natechancellor@gmail.com>
    iio: common: ssp_sensors: Initialize calculated_time in ssp_common_process_data

Kangjie Lu <kjlu@umn.edu>
    iio: hmc5843: fix potential NULL pointer dereferences

Lars-Peter Clausen <lars@metafoo.de>
    iio: ad_sigma_delta: Properly handle SPI bus locking vs CS assertion

Kees Cook <keescook@chromium.org>
    x86/build: Keep local relocations with ld.lld

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: pmac32: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq/pasemi: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: ppc_cbe: fix possible object reference leak

Arnd Bergmann <arnd@arndb.de>
    s390: cio: fix cio_irb declaration

Charles Keepax <ckeepax@opensource.cirrus.com>
    extcon: arizona: Disable mic detect if running when driver is removed

Ulf Hansson <ulf.hansson@linaro.org>
    PM / core: Propagate dev->power.wakeup_path when no callbacks

Yinbo Zhu <yinbo.zhu@nxp.com>
    mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A-008358 support

Yinbo Zhu <yinbo.zhu@nxp.com>
    mmc: sdhci-of-esdhc: add erratum eSDHC5 support

Kangjie Lu <kjlu@umn.edu>
    mmc_spi: add a status check for spi_sync_locked

Andrea Merello <andrea.merello@gmail.com>
    mmc: core: make pwrseq_emmc (partially) support sleepy GPIO controllers

John Garry <john.garry@huawei.com>
    scsi: libsas: Do discovery on empty PHY to update PHY info

Guenter Roeck <linux@roeck-us.net>
    hwmon: (f71805f) Use request_muxed_region for Super-IO accesses

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pc87427) Use request_muxed_region for Super-IO accesses

Guenter Roeck <linux@roeck-us.net>
    hwmon: (smsc47b397) Use request_muxed_region for Super-IO accesses

Guenter Roeck <linux@roeck-us.net>
    hwmon: (smsc47m1) Use request_muxed_region for Super-IO accesses

Guenter Roeck <linux@roeck-us.net>
    hwmon: (vt1211) Use request_muxed_region for Super-IO accesses

Colin Ian King <colin.king@canonical.com>
    RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: vdso: Fix clock_getres() for CLOCK_REALTIME

Nicholas Nunley <nicholas.d.nunley@intel.com>
    i40e: don't allow changes to HW VLAN stripping on active port VLANs

Thomas Gleixner <tglx@linutronix.de>
    x86/irq/64: Limit IST stack overflow check to #DB stack

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't unbind interfaces following device reset failure

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    sched/core: Handle overflow in cpu_shares_write_u64

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    sched/core: Check quota and period overflow at usec to nsec conversion

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/numa: improve control of topology updates

Dan Carpenter <dan.carpenter@oracle.com>
    media: pvrusb2: Prevent a buffer overflow

Shuah Khan <shuah@kernel.org>
    media: au0828: Fix NULL pointer dereference in au0828_analog_stream_enable()

Wenwen Wang <wang6495@umn.edu>
    audit: fix a memory leak bug

Akinobu Mita <akinobu.mita@gmail.com>
    media: ov2659: make S_FMT succeed even if requested format doesn't match

Hans Verkuil <hverkuil@xs4all.nl>
    media: au0828: stop video streaming only when last user stops

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: clear error return value before picture run

Nicolas Ferre <nicolas.ferre@microchip.com>
    dmaengine: at_xdmac: remove BUG_ON macro in tasklet

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: pistachio: fix leaked of_node references

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-hidpp: use RAP instead of FAP to get the protocol version

Peter Zijlstra <peterz@infradead.org>
    mm/uaccess: Use 'unsigned long' to placate UBSAN warnings on older GCC versions

Jiri Kosina <jkosina@suse.cz>
    x86/mm: Remove in_nmi() warning from 64-bit implementation of vmalloc_fault()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    smpboot: Place the __percpu annotation correctly

Kees Cook <keescook@chromium.org>
    x86/build: Move _etext to actual end of .text

Arnd Bergmann <arnd@arndb.de>
    bcache: avoid clang -Wunintialized warning

Coly Li <colyli@suse.de>
    bcache: add failure check to run_cache_set() for journal replay

Tang Junhui <tang.junhui.linux@gmail.com>
    bcache: fix failure in journal relplay

Coly Li <colyli@suse.de>
    bcache: return error immediately in bch_journal_replay()

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun4i-ss - Fix invalid calculation of hash end

Kangjie Lu <kjlu@umn.edu>
    net: cw1200: fix a NULL pointer dereference

Dan Carpenter <dan.carpenter@oracle.com>
    mwifiex: prevent an array overflow

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: fsl_sai: Update is_slave_mode with correct value

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    mac80211/cfg80211: update bss channel on channel switch

Sugar Zhang <sugar.zhang@rock-chips.com>
    dmaengine: pl330: _stop: clear interrupt status

Mariusz Bialonczyk <manio@skyboo.net>
    w1: fix the resume command API

Sven Van Asbroeck <thesven73@gmail.com>
    rtc: 88pm860x: prevent use-after-free on device remove

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: don't crash on invalid RX interrupt

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix a qla24xx_enable_msix() error path

Viresh Kumar <viresh.kumar@linaro.org>
    sched/cpufreq: Fix kobject memleak

Qian Cai <cai@lca.pw>
    arm64: Fix compiler warning from pte_unmap() with -Wunused-but-set-variable

Marc Zyngier <marc.zyngier@arm.com>
    ARM: vdso: Remove dependency with the arch_timer driver internals

Dan Carpenter <dan.carpenter@oracle.com>
    brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcmd_handler()

Flavio Suligoi <f.suligoi@asem.it>
    spi: pxa2xx: fix SCR (divisor) calculation

Arnd Bergmann <arnd@arndb.de>
    ASoC: imx: fix fiq dependencies

Bo YU <tsu.yubo@gmail.com>
    powerpc/boot: Fix missing check of lseek() return value

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: hdmi-codec: unlock the device on startup errors

Sameeh Jubran <sameehj@amazon.com>
    net: ena: gcc 8: fix compilation warning

Sameer Pujar <spujar@nvidia.com>
    dmaengine: tegra210-dma: free dma controller in remove()

Raul E Rangel <rrangel@chromium.org>
    mmc: core: Verify SD bus width

YueHaibing <yuehaibing@huawei.com>
    cxgb4: Fix error path in cxgb4_init_module

Ross Lagerwall <ross.lagerwall@citrix.com>
    gfs2: Fix lru_count going negative

David Sterba <dsterba@suse.com>
    Revert "btrfs: Honour FITRIM range constraints during free space trim"

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools include: Adopt linux/bits.h

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: No need to include bitops.h in util.h

YueHaibing <yuehaibing@huawei.com>
    at76c50x-usb: Don't register led_trigger if usb_register_driver failed

YueHaibing <yuehaibing@huawei.com>
    ssb: Fix possible NULL pointer dereference in ssb_host_pcmcia_exit

Alexander Potapenko <glider@google.com>
    media: vivid: use vfree() instead of kfree() for dev->bitmap_cap

YueHaibing <yuehaibing@huawei.com>
    media: cpia2: Fix use-after-free in cpia2_exit

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    fbdev: fix WARNING in __alloc_pages_nodemask bug

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: use same fault hash key for shared and private mappings

Shile Zhang <shile.zhang@linux.alibaba.com>
    fbdev: fix divide error in fb_var_to_videomode

Tobin C. Harding <tobin@kernel.org>
    btrfs: sysfs: don't leak memory when failing add fsid

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between ranged fsync and writeback of adjacent ranges

Filipe Manana <fdmanana@suse.com>
    Btrfs: do not abort transaction at btrfs_update_root() after failure to COW path

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix sign extension bug in gfs2_update_stats

Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
    arm64: Save and restore OSDLR_EL1 across suspend/resume

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/namespace: Fix label tracking error

Suthikulpanit, Suravee <Suravee.Suthikulpanit@amd.com>
    kvm: svm/avic: fix off-by-one in checking host APIC ID

Daniel Axtens <dja@axtens.net>
    crypto: vmx - CTR: always increment IV as quadword

Martin K. Petersen <martin.petersen@oracle.com>
    Revert "scsi: sd: Keep disk read-only when re-reading partition"

Andrea Parri <andrea.parri@amarulasolutions.com>
    bio: fix improper use of smp_mb__before_atomic()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix return value for reserved EFER

Jan Kara <jack@suse.cz>
    ext4: do not delete unlinked inode from orphan list on failed truncate


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/include/asm/cp15.h                        |  2 +
 arch/arm/vdso/vgettimeofday.c                      |  5 ++-
 arch/arm64/include/asm/pgtable.h                   |  3 +-
 arch/arm64/include/asm/vdso_datapage.h             |  1 +
 arch/arm64/kernel/asm-offsets.c                    |  2 +-
 arch/arm64/kernel/cpu_ops.c                        |  1 +
 arch/arm64/kernel/vdso.c                           |  3 ++
 arch/arm64/kernel/vdso/gettimeofday.S              |  7 ++--
 arch/arm64/mm/proc.S                               | 26 +++++++------
 arch/powerpc/boot/addnote.c                        |  6 ++-
 arch/powerpc/mm/numa.c                             | 18 ++++++---
 arch/x86/Makefile                                  |  2 +-
 arch/x86/ia32/ia32_signal.c                        | 29 ++++++++------
 arch/x86/kernel/cpu/mcheck/mce.c                   | 44 ++++++++++++++++++----
 arch/x86/kernel/irq_64.c                           | 19 +++++++---
 arch/x86/kernel/signal.c                           | 29 ++++++++------
 arch/x86/kernel/vmlinux.lds.S                      |  6 +--
 arch/x86/kvm/svm.c                                 |  6 ++-
 arch/x86/kvm/x86.c                                 |  2 +-
 arch/x86/mm/fault.c                                |  2 -
 drivers/base/power/main.c                          |  4 ++
 drivers/char/virtio_console.c                      |  3 +-
 drivers/cpufreq/cpufreq.c                          |  1 +
 drivers/cpufreq/cpufreq_governor.c                 |  2 +
 drivers/cpufreq/pasemi-cpufreq.c                   |  1 +
 drivers/cpufreq/pmac32-cpufreq.c                   |  2 +
 drivers/cpufreq/ppc_cbe_cpufreq.c                  |  1 +
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |  5 ++-
 drivers/crypto/vmx/aesp8-ppc.pl                    |  2 +-
 drivers/dma/at_xdmac.c                             |  6 ++-
 drivers/dma/pl330.c                                | 10 +++--
 drivers/dma/tegra210-adma.c                        | 28 +++++++-------
 drivers/extcon/extcon-arizona.c                    | 10 +++++
 drivers/gpu/drm/drm_fops.c                         |  1 +
 drivers/hid/hid-core.c                             | 36 ++++++++++++------
 drivers/hid/hid-logitech-hidpp.c                   | 17 +++++++--
 drivers/hwmon/f71805f.c                            | 15 ++++++--
 drivers/hwmon/pc87427.c                            | 14 ++++++-
 drivers/hwmon/smsc47b397.c                         | 13 ++++++-
 drivers/hwmon/smsc47m1.c                           | 28 +++++++++-----
 drivers/hwmon/vt1211.c                             | 15 ++++++--
 drivers/iio/adc/ad_sigma_delta.c                   | 16 +++++---
 drivers/iio/common/ssp_sensors/ssp_iio.c           |  2 +-
 drivers/iio/magnetometer/hmc5843_i2c.c             |  7 +++-
 drivers/iio/magnetometer/hmc5843_spi.c             |  7 +++-
 drivers/infiniband/hw/cxgb4/cm.c                   |  2 +
 drivers/md/bcache/alloc.c                          |  5 ++-
 drivers/md/bcache/journal.c                        | 26 +++++++++++--
 drivers/md/bcache/super.c                          | 17 ++++++---
 drivers/media/dvb-frontends/m88ds3103.c            |  9 ++---
 drivers/media/i2c/ov2659.c                         |  6 ++-
 drivers/media/i2c/soc_camera/ov6650.c              | 25 ++++++------
 drivers/media/pci/saa7146/hexium_gemini.c          |  5 +--
 drivers/media/pci/saa7146/hexium_orion.c           |  5 +--
 drivers/media/platform/coda/coda-bit.c             |  3 ++
 drivers/media/platform/vivid/vivid-vid-cap.c       |  2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |  7 +++-
 drivers/media/usb/au0828/au0828-video.c            | 16 +++++---
 drivers/media/usb/cpia2/cpia2_v4l.c                |  3 +-
 drivers/media/usb/go7007/go7007-fw.c               |  4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  2 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h            |  1 +
 drivers/mmc/core/pwrseq_emmc.c                     | 38 ++++++++++---------
 drivers/mmc/core/sd.c                              |  8 ++++
 drivers/mmc/host/mmc_spi.c                         |  4 ++
 drivers/mmc/host/sdhci-of-esdhc.c                  |  5 +++
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.h           |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 15 ++++++--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  8 ++++
 drivers/net/wireless/atmel/at76c50x-usb.c          |  4 +-
 drivers/net/wireless/broadcom/b43/phy_lp.c         |  6 +--
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  4 ++
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 10 +++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 27 +++++++------
 .../wireless/broadcom/brcm80211/brcmfmac/vendor.c  |  5 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  7 +++-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  6 ++-
 drivers/net/wireless/marvell/mwifiex/cfp.c         |  3 ++
 drivers/net/wireless/realtek/rtlwifi/base.c        |  5 +++
 drivers/net/wireless/st/cw1200/main.c              |  5 +++
 drivers/nvdimm/label.c                             | 29 +++++++-------
 drivers/nvdimm/namespace_devs.c                    | 15 ++++++++
 drivers/nvdimm/nd.h                                |  4 ++
 drivers/pinctrl/pinctrl-pistachio.c                |  2 +
 drivers/rtc/rtc-88pm860x.c                         |  2 +-
 drivers/s390/cio/cio.h                             |  2 +-
 drivers/scsi/libsas/sas_expander.c                 |  5 +++
 drivers/scsi/lpfc/lpfc_ct.c                        |  3 ++
 drivers/scsi/lpfc/lpfc_hbadisc.c                   | 11 +++++-
 drivers/scsi/qla2xxx/qla_isr.c                     |  6 ++-
 drivers/scsi/qla4xxx/ql4_os.c                      |  2 +-
 drivers/scsi/sd.c                                  |  3 +-
 drivers/scsi/ufs/ufshcd.c                          | 28 ++++++++++----
 drivers/spi/spi-pxa2xx.c                           |  8 +++-
 drivers/spi/spi-rspi.c                             |  9 +++--
 drivers/spi/spi-tegra114.c                         | 32 +++++++++-------
 drivers/spi/spi-topcliff-pch.c                     | 15 +++++++-
 drivers/spi/spi.c                                  |  2 +
 drivers/ssb/bridge_pcmcia_80211.c                  |  9 ++++-
 drivers/tty/ipwireless/main.c                      |  8 ++++
 drivers/usb/core/hcd.c                             |  3 ++
 drivers/usb/core/hub.c                             |  5 ++-
 drivers/video/fbdev/core/fbcmap.c                  |  2 +
 drivers/video/fbdev/core/modedb.c                  |  3 ++
 drivers/w1/w1_io.c                                 |  3 +-
 fs/btrfs/extent-tree.c                             | 25 +++---------
 fs/btrfs/file.c                                    | 12 ++++++
 fs/btrfs/root-tree.c                               |  4 +-
 fs/btrfs/sysfs.c                                   |  7 +++-
 fs/char_dev.c                                      |  6 +++
 fs/ext4/inode.c                                    |  2 +-
 fs/gfs2/glock.c                                    | 22 ++++++-----
 fs/gfs2/lock_dlm.c                                 |  9 +++--
 fs/hugetlbfs/inode.c                               |  8 +---
 include/linux/bio.h                                |  2 +-
 include/linux/hid.h                                |  1 +
 include/linux/hugetlb.h                            |  4 +-
 include/linux/iio/adc/ad_sigma_delta.h             |  1 +
 include/linux/smpboot.h                            |  2 +-
 kernel/auditfilter.c                               | 12 +++---
 kernel/rcu/rcuperf.c                               |  5 +++
 kernel/rcu/rcutorture.c                            |  5 +++
 kernel/sched/core.c                                |  9 ++++-
 lib/strncpy_from_user.c                            |  5 ++-
 lib/strnlen_user.c                                 |  4 +-
 mm/hugetlb.c                                       | 19 +++-------
 net/mac80211/mlme.c                                |  3 --
 net/wireless/nl80211.c                             |  5 +++
 sound/soc/codecs/hdmi-codec.c                      |  6 ++-
 sound/soc/davinci/davinci-mcasp.c                  |  2 +
 sound/soc/fsl/Kconfig                              |  9 +++--
 sound/soc/fsl/eukrea-tlv320.c                      |  4 +-
 sound/soc/fsl/fsl_sai.c                            |  2 +
 sound/soc/fsl/fsl_utils.c                          |  1 +
 tools/include/linux/bitops.h                       |  7 +---
 tools/include/linux/bits.h                         | 26 +++++++++++++
 tools/perf/check-headers.sh                        |  1 +
 tools/perf/util/util.h                             |  1 -
 140 files changed, 836 insertions(+), 371 deletions(-)


