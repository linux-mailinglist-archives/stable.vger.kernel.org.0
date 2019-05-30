Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9A2EFC5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731650AbfE3DSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731627AbfE3DSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 127B22474A;
        Thu, 30 May 2019 03:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186320;
        bh=3EDwIPuxrYxI0VvToVVlOLo4mVycvJYauFwzUuASvss=;
        h=From:To:Cc:Subject:Date:From;
        b=IX6we60mFo/UrTHXtTW2tVO6UykgCVtWvEjl2Kb6/07MjHA9zqcnJ8FApRbestjRD
         X09shV3jS20yf5PNk0k4y0+3jwDD1rUZ1Vnji/jq89UHP5vi9D+AB5jjEoeC2kBWLa
         sfzpUn5Wo9zRFw4mj8+e97KV3fHyYBnEkg0Y+f40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/193] 4.14.123-stable review
Date:   Wed, 29 May 2019 20:04:14 -0700
Message-Id: <20190530030446.953835040@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.123-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.123-rc1
X-KernelTest-Deadline: 2019-06-01T03:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.123 release.
There are 193 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 01 Jun 2019 03:02:04 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.123-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.123-rc1

Benjamin Coddington <bcodding@redhat.com>
    NFS: Fix a double unlock from nfs_match,get_client

Farhan Ali <alifm@linux.ibm.com>
    vfio-ccw: Prevent quiesce function going into an infinite loop

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Wake up next in drm_read() chain if we are forced to putback the event

Noralf Trønnes <noralf@tronnes.org>
    drm/drv: Hold ref on parent device during drm_device lifetime

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
    scsi: lpfc: Fix fc4type information for FDMI

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix FDMI manufacturer attribute value

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vimc: zero the media_device on probe

Arnd Bergmann <arnd@arndb.de>
    media: go7007: avoid clang frame overflow warning with KASAN

Helen Fornazier <helen.koike@collabora.com>
    media: vimc: stream: fix thread state before sleep

James Hutchinson <jahutchinson99@googlemail.com>
    media: m88ds3103: serialize reset messages in m88ds3103_set_frontend

Aditya Pakki <pakki001@umn.edu>
    thunderbolt: Fix to check for kmemdup failure

Rouven Czerwinski <r.czerwinski@pengutronix.de>
    hwrng: omap - Set default quality

Sameer Pujar <spujar@nvidia.com>
    dmaengine: tegra210-adma: use devm_clk_*() helpers

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: allow updating DAT entry timeouts on incoming ARP Replies

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

Chad Dupuis <cdupuis@marvell.com>
    scsi: qedf: Add missing return in qedf_post_io_req() in the fcport offload check

Dan Carpenter <dan.carpenter@oracle.com>
    media: wl128x: prevent two potential buffer overflows

Kangjie Lu <kjlu@umn.edu>
    media: video-mux: fix null pointer dereferences

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    kobject: Don't trigger kobject_uevent(KOBJ_REMOVE) twice.

Sowjanya Komatineni <skomatineni@nvidia.com>
    spi: tegra114: reset controller on probe

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-hidpp: change low battery level threshold from 31 to 30 percent

Gustavo A. R. Silva <gustavo@embeddedor.com>
    cxgb3/l2t: Fix undefined behaviour

Wen Yang <wen.yang99@zte.com.cn>
    ASoC: fsl_utils: fix a leaked reference by adding missing of_node_put

Wen Yang <wen.yang99@zte.com.cn>
    ASoC: eukrea-tlv320: fix a leaked reference by adding missing of_node_put

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    HID: core: move Usage Page concatenation to Main item

Leon Romanovsky <leonro@mellanox.com>
    RDMA/hns: Fix bad endianess of port_pd variable

Chengguang Xu <cgxu519@gmx.com>
    chardev: add additional check for minor range overlap

Peter Zijlstra <peterz@infradead.org>
    x86/ia32: Fix ia32_restore_sigcontext() AC leak

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, signal: Fix AC=1 bloat

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP

Wen Yang <wen.yang99@zte.com.cn>
    arm64: cpu_ops: fix a leaked reference by adding missing of_node_put

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Avoid configuring regulator with undefined voltage range

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix regulator load and icc-level configuration

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: fix potential NULL pointer dereference

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: xgene: fix possible race condition

Piotr Figiel <p.figiel@camlintechnologies.com>
    brcmfmac: fix Oops when bringing up interface during USB disconnect

Piotr Figiel <p.figiel@camlintechnologies.com>
    brcmfmac: fix race during disconnect when USB completion is in progress

Piotr Figiel <p.figiel@camlintechnologies.com>
    brcmfmac: fix WARNING during USB disconnect in case of unempty psq

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

David Kozub <zub@linux.fjfi.cvut.cz>
    block: sed-opal: fix IOC_OPAL_ENABLE_DISABLE_MBR

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: kirkwood: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: pmac32: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq/pasemi: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: ppc_cbe: fix possible object reference leak

Arnd Bergmann <arnd@arndb.de>
    s390: cio: fix cio_irb declaration

Borislav Petkov <bp@suse.de>
    x86/microcode: Fix the ancient deprecated microcode loading method

Arnd Bergmann <arnd@arndb.de>
    s390: zcrypt: initialize variables before_use

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: Make rkpwm a critical clock on rk3288

Charles Keepax <ckeepax@opensource.cirrus.com>
    extcon: arizona: Disable mic detect if running when driver is removed

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: Fix video codec clocks on rk3288

Ulf Hansson <ulf.hansson@linaro.org>
    PM / core: Propagate dev->power.wakeup_path when no callbacks

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix old fence check in amdgpu_fence_emit

Yinbo Zhu <yinbo.zhu@nxp.com>
    mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A-008358 support

Yinbo Zhu <yinbo.zhu@nxp.com>
    mmc: sdhci-of-esdhc: add erratum A-009204 support

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

Adam Ludkiewicz <adam.ludkiewicz@intel.com>
    i40e: Able to add up to 16 MAC filters on an untrusted VF

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    phy: sun4i-usb: Make sure to disable PHY0 passby for peripheral mode

Thomas Gleixner <tglx@linutronix.de>
    x86/irq/64: Limit IST stack overflow check to #DB stack

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't unbind interfaces following device reset failure

Wen Yang <wen.yang99@zte.com.cn>
    drm/msm: a5xx: fix possible object reference leak

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    sched/core: Handle overflow in cpu_shares_write_u64

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    sched/rt: Check integer overflow at usec to nsec conversion

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    sched/core: Check quota and period overflow at usec to nsec conversion

Roman Gushchin <guro@fb.com>
    cgroup: protect cgroup->nr_(dying_)descendants by css_set_lock

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    random: add a spinlock_t to struct batched_entropy

Russell Currey <ruscur@russell.cc>
    powerpc/64: Fix booting large kernels with STRICT_KERNEL_RWX

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/numa: improve control of topology updates

Dan Carpenter <dan.carpenter@oracle.com>
    media: pvrusb2: Prevent a buffer overflow

Shuah Khan <shuah@kernel.org>
    media: au0828: Fix NULL pointer dereference in au0828_analog_stream_enable()

Hugues Fruchet <hugues.fruchet@st.com>
    media: stm32-dcmi: fix crash when subdev do not expose any formats

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

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: undo several noc and special clocks as critical on rk3288

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: samsung: fix leaked of_node references

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

Farhan Ali <alifm@linux.ibm.com>
    vfio-ccw: Release any channel program when releasing/removing vfio-ccw mdev

Farhan Ali <alifm@linux.ibm.com>
    vfio-ccw: Do not call flush_workqueue while holding the spinlock

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

Daniel T. Lee <danieltimlee@gmail.com>
    libbpf: fix samples/bpf build failure due to undefined UINT32_MAX

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    mac80211/cfg80211: update bss channel on channel switch

Sugar Zhang <sugar.zhang@rock-chips.com>
    dmaengine: pl330: _stop: clear interrupt status

Mariusz Bialonczyk <manio@skyboo.net>
    w1: fix the resume command API

Manish Rangankar <mrangankar@marvell.com>
    scsi: qedi: Abort ep termination if offload not scheduled

Sven Van Asbroeck <thesven73@gmail.com>
    rtc: 88pm860x: prevent use-after-free on device remove

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: don't crash on invalid RX interrupt

Qu Wenruo <wqu@suse.com>
    btrfs: Don't panic when we can't find a root key

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix panic during relocation after ENOSPC before writeback happens

Robbie Ko <robbieko@synology.com>
    Btrfs: fix data bytes_may_use underflow with fallocate due to failed quota reserve

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Avoid that lockdep complains about unsafe locking in tcm_qla2xxx_close_session()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix abort handling in tcm_qla2xxx_write_pending()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix a qla24xx_enable_msix() error path

Viresh Kumar <viresh.kumar@linaro.org>
    sched/cpufreq: Fix kobject memleak

Qian Cai <cai@lca.pw>
    arm64: Fix compiler warning from pte_unmap() with -Wunused-but-set-variable

Marc Zyngier <marc.zyngier@arm.com>
    ARM: vdso: Remove dependency with the arch_timer driver internals

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ACPI / property: fix handling of data_nodes in acpi_get_next_subnode()

Dan Carpenter <dan.carpenter@oracle.com>
    brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcmd_handler()

Flavio Suligoi <f.suligoi@asem.it>
    spi: pxa2xx: fix SCR (divisor) calculation

Arnd Bergmann <arnd@arndb.de>
    ASoC: imx: fix fiq dependencies

Bo YU <tsu.yubo@gmail.com>
    powerpc/boot: Fix missing check of lseek() return value

Anju T Sudhakar <anju@linux.vnet.ibm.com>
    powerpc/perf: Return accordingly on invalid chip-id in

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: hdmi-codec: unlock the device on startup errors

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: zte: fix leaked of_node references

Sameeh Jubran <sameehj@amazon.com>
    net: ena: gcc 8: fix compilation warning

Sameer Pujar <spujar@nvidia.com>
    dmaengine: tegra210-dma: free dma controller in remove()

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    tools/bpf: fix perf build error with uClibc (seen on ARC)

Raul E Rangel <rrangel@chromium.org>
    mmc: core: Verify SD bus width

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix occasional glock use-after-free

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Fix WQ_MEM_RECLAIM warning

Roberto Bergantinos Corpas <rbergant@redhat.com>
    NFS: make nfs_match_client killable

YueHaibing <yuehaibing@huawei.com>
    cxgb4: Fix error path in cxgb4_init_module

Ross Lagerwall <ross.lagerwall@citrix.com>
    gfs2: Fix lru_count going negative

David Sterba <dsterba@suse.com>
    Revert "btrfs: Honour FITRIM range constraints during free space trim"

William Tu <u9012063@gmail.com>
    net: erspan: fix use-after-free

YueHaibing <yuehaibing@huawei.com>
    at76c50x-usb: Don't register led_trigger if usb_register_driver failed

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix multicast tt/tvlv worker locking

Eric Dumazet <edumazet@google.com>
    bpf: devmap: fix use-after-free Read in __dev_map_entry_free

YueHaibing <yuehaibing@huawei.com>
    ssb: Fix possible NULL pointer dereference in ssb_host_pcmcia_exit

Alexander Potapenko <glider@google.com>
    media: vivid: use vfree() instead of kfree() for dev->bitmap_cap

YueHaibing <yuehaibing@huawei.com>
    media: serial_ir: Fix use-after-free in serial_ir_init_module

YueHaibing <yuehaibing@huawei.com>
    media: cpia2: Fix use-after-free in cpia2_exit

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    fbdev: fix WARNING in __alloc_pages_nodemask bug

Josef Bacik <josef@toxicpanda.com>
    btrfs: honor path->skip_locking in backref code

Arend van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: add subtype check for event handling in data path

Arend van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: assure SSID length from firmware is limited

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: use same fault hash key for shared and private mappings

Shile Zhang <shile.zhang@linux.alibaba.com>
    fbdev: fix divide error in fb_var_to_videomode

Tobin C. Harding <tobin@kernel.org>
    btrfs: sysfs: don't leak memory when failing add fsid

Tobin C. Harding <tobin@kernel.org>
    btrfs: sysfs: Fix error path kobject memory leak

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between ranged fsync and writeback of adjacent ranges

Filipe Manana <fdmanana@suse.com>
    Btrfs: avoid fallback to transaction commit during fsync of files with holes

Filipe Manana <fdmanana@suse.com>
    Btrfs: do not abort transaction at btrfs_update_root() after failure to COW path

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix sign extension bug in gfs2_update_stats

Christoph Hellwig <hch@lst.de>
    arm64/iommu: handle non-remapped addresses in ->mmap and ->get_sgtable

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/namespace: Fix label tracking error

Dan Williams <dan.j.williams@intel.com>
    libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead

Suthikulpanit, Suravee <Suravee.Suthikulpanit@amd.com>
    kvm: svm/avic: fix off-by-one in checking host APIC ID

Trac Hoang <trac.hoang@broadcom.com>
    mmc: sdhci-iproc: Set NO_HISPD bit to fix HS50 data hold time problem

Trac Hoang <trac.hoang@broadcom.com>
    mmc: sdhci-iproc: cygnus: Set NO_HISPD bit to fix HS50 data hold time problem

Daniel Axtens <dja@axtens.net>
    crypto: vmx - CTR: always increment IV as quadword

Martin K. Petersen <martin.petersen@oracle.com>
    Revert "scsi: sd: Keep disk read-only when re-reading partition"

Andrea Parri <andrea.parri@amarulasolutions.com>
    sbitmap: fix improper use of smp_mb__before_atomic()

Andrea Parri <andrea.parri@amarulasolutions.com>
    bio: fix improper use of smp_mb__before_atomic()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix return value for reserved EFER

Damien Le Moal <damien.lemoal@wdc.com>
    f2fs: Fix use of number of devices

Jan Kara <jack@suse.cz>
    ext4: do not delete unlinked inode from orphan list on failed truncate

Steven Rostedt (VMware) <rostedt@goodmis.org>
    x86: Hide the int3_emulate_call/jmp functions from UML


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
 arch/arm64/kernel/vdso/gettimeofday.S              |  7 ++-
 arch/arm64/mm/dma-mapping.c                        | 10 +++++
 arch/powerpc/boot/addnote.c                        |  6 ++-
 arch/powerpc/kernel/head_64.S                      |  4 +-
 arch/powerpc/mm/numa.c                             | 18 +++++---
 arch/powerpc/perf/imc-pmu.c                        |  5 +++
 arch/x86/Makefile                                  |  2 +-
 arch/x86/ia32/ia32_signal.c                        | 29 +++++++-----
 arch/x86/include/asm/text-patching.h               |  4 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   | 44 +++++++++++++++---
 arch/x86/kernel/cpu/microcode/core.c               |  3 +-
 arch/x86/kernel/irq_64.c                           | 19 +++++---
 arch/x86/kernel/signal.c                           | 29 +++++++-----
 arch/x86/kernel/vmlinux.lds.S                      |  6 +--
 arch/x86/kvm/svm.c                                 |  6 ++-
 arch/x86/kvm/x86.c                                 |  2 +-
 arch/x86/mm/fault.c                                |  2 -
 block/sed-opal.c                                   |  9 ++--
 drivers/acpi/property.c                            |  8 ++++
 drivers/base/power/main.c                          |  4 ++
 drivers/char/hw_random/omap-rng.c                  |  1 +
 drivers/char/random.c                              | 52 +++++++++++-----------
 drivers/char/virtio_console.c                      |  3 +-
 drivers/clk/rockchip/clk-rk3288.c                  | 21 ++++-----
 drivers/cpufreq/cpufreq.c                          |  1 +
 drivers/cpufreq/cpufreq_governor.c                 |  2 +
 drivers/cpufreq/kirkwood-cpufreq.c                 | 19 ++++----
 drivers/cpufreq/pasemi-cpufreq.c                   |  1 +
 drivers/cpufreq/pmac32-cpufreq.c                   |  2 +
 drivers/cpufreq/ppc_cbe_cpufreq.c                  |  1 +
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |  5 ++-
 drivers/crypto/vmx/aesp8-ppc.pl                    |  2 +-
 drivers/dma/at_xdmac.c                             |  6 ++-
 drivers/dma/pl330.c                                | 10 +++--
 drivers/dma/tegra210-adma.c                        | 28 ++++++------
 drivers/extcon/extcon-arizona.c                    | 10 +++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          | 24 +++++++---
 drivers/gpu/drm/drm_drv.c                          |  5 ++-
 drivers/gpu/drm/drm_file.c                         |  1 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              | 10 +++--
 drivers/hid/hid-core.c                             | 36 ++++++++++-----
 drivers/hid/hid-logitech-hidpp.c                   | 23 +++++++---
 drivers/hwmon/f71805f.c                            | 15 +++++--
 drivers/hwmon/pc87427.c                            | 14 +++++-
 drivers/hwmon/smsc47b397.c                         | 13 +++++-
 drivers/hwmon/smsc47m1.c                           | 28 ++++++++----
 drivers/hwmon/vt1211.c                             | 15 +++++--
 drivers/iio/adc/ad_sigma_delta.c                   | 16 ++++---
 drivers/iio/common/ssp_sensors/ssp_iio.c           |  2 +-
 drivers/iio/magnetometer/hmc5843_i2c.c             |  7 ++-
 drivers/iio/magnetometer/hmc5843_spi.c             |  7 ++-
 drivers/infiniband/hw/cxgb4/cm.c                   |  2 +
 drivers/infiniband/hw/hfi1/init.c                  |  3 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |  2 +-
 drivers/md/bcache/alloc.c                          |  5 ++-
 drivers/md/bcache/journal.c                        | 26 +++++++++--
 drivers/md/bcache/super.c                          | 17 ++++---
 drivers/media/dvb-frontends/m88ds3103.c            |  9 ++--
 drivers/media/i2c/ov2659.c                         |  6 ++-
 drivers/media/i2c/ov6650.c                         | 25 ++++++-----
 drivers/media/pci/saa7146/hexium_gemini.c          |  5 +--
 drivers/media/pci/saa7146/hexium_orion.c           |  5 +--
 drivers/media/platform/coda/coda-bit.c             |  3 ++
 drivers/media/platform/stm32/stm32-dcmi.c          |  6 +++
 drivers/media/platform/video-mux.c                 |  5 +++
 drivers/media/platform/vimc/vimc-core.c            |  2 +
 drivers/media/platform/vimc/vimc-streamer.c        |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |  2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |  7 ++-
 drivers/media/rc/serial_ir.c                       |  9 +---
 drivers/media/usb/au0828/au0828-video.c            | 16 ++++---
 drivers/media/usb/cpia2/cpia2_v4l.c                |  3 +-
 drivers/media/usb/go7007/go7007-fw.c               |  4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  2 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h            |  1 +
 drivers/mmc/core/pwrseq_emmc.c                     | 38 ++++++++--------
 drivers/mmc/core/sd.c                              |  8 ++++
 drivers/mmc/host/mmc_spi.c                         |  4 ++
 drivers/mmc/host/sdhci-iproc.c                     |  6 ++-
 drivers/mmc/host/sdhci-of-esdhc.c                  |  8 ++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.h           |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 15 +++++--
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  8 ++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  6 ++-
 drivers/net/wireless/atmel/at76c50x-usb.c          |  4 +-
 drivers/net/wireless/broadcom/b43/phy_lp.c         |  6 +--
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  6 +++
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 15 ++++---
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    | 16 +++++--
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 42 +++++++++--------
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 27 ++++++-----
 .../wireless/broadcom/brcm80211/brcmfmac/vendor.c  |  5 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  7 ++-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  6 ++-
 drivers/net/wireless/marvell/mwifiex/cfp.c         |  3 ++
 drivers/net/wireless/realtek/rtlwifi/base.c        |  5 +++
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |  2 +
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  |  2 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  2 +
 .../net/wireless/realtek/rtlwifi/rtl8723ae/fw.c    |  2 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  2 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  4 ++
 drivers/net/wireless/st/cw1200/main.c              |  5 +++
 drivers/nvdimm/label.c                             | 29 ++++++------
 drivers/nvdimm/namespace_devs.c                    | 15 +++++++
 drivers/nvdimm/nd.h                                |  4 ++
 drivers/nvdimm/pmem.c                              |  8 +++-
 drivers/phy/allwinner/phy-sun4i-usb.c              |  4 ++
 drivers/pinctrl/pinctrl-pistachio.c                |  2 +
 drivers/pinctrl/samsung/pinctrl-exynos-arm.c       |  1 +
 drivers/pinctrl/zte/pinctrl-zx.c                   |  1 +
 drivers/rtc/rtc-88pm860x.c                         |  2 +-
 drivers/rtc/rtc-xgene.c                            | 18 +++++---
 drivers/s390/cio/cio.h                             |  2 +-
 drivers/s390/cio/vfio_ccw_drv.c                    | 32 +++++++------
 drivers/s390/cio/vfio_ccw_ops.c                    | 11 ++++-
 drivers/s390/crypto/zcrypt_api.c                   |  4 ++
 drivers/scsi/libsas/sas_expander.c                 |  5 +++
 drivers/scsi/lpfc/lpfc_ct.c                        | 20 ++++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c                   | 11 ++++-
 drivers/scsi/qedf/qedf_io.c                        |  1 +
 drivers/scsi/qedi/qedi_iscsi.c                     |  3 ++
 drivers/scsi/qla2xxx/qla_isr.c                     |  6 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  5 ++-
 drivers/scsi/qla4xxx/ql4_os.c                      |  2 +-
 drivers/scsi/sd.c                                  |  3 +-
 drivers/scsi/ufs/ufshcd.c                          | 28 ++++++++----
 drivers/spi/spi-pxa2xx.c                           |  8 +++-
 drivers/spi/spi-rspi.c                             |  9 ++--
 drivers/spi/spi-tegra114.c                         | 32 +++++++------
 drivers/spi/spi-topcliff-pch.c                     | 15 ++++++-
 drivers/spi/spi.c                                  |  2 +
 drivers/ssb/bridge_pcmcia_80211.c                  |  9 +++-
 drivers/thunderbolt/switch.c                       | 22 ++++++---
 drivers/tty/ipwireless/main.c                      |  8 ++++
 drivers/usb/core/hcd.c                             |  3 ++
 drivers/usb/core/hub.c                             |  5 ++-
 drivers/video/fbdev/core/fbcmap.c                  |  2 +
 drivers/video/fbdev/core/modedb.c                  |  3 ++
 drivers/w1/w1_io.c                                 |  3 +-
 fs/btrfs/backref.c                                 | 17 ++++---
 fs/btrfs/extent-tree.c                             | 28 +++---------
 fs/btrfs/file.c                                    | 15 ++++++-
 fs/btrfs/relocation.c                              | 31 ++++++++-----
 fs/btrfs/root-tree.c                               | 17 +++----
 fs/btrfs/sysfs.c                                   |  7 ++-
 fs/btrfs/tree-log.c                                |  1 +
 fs/char_dev.c                                      |  6 +++
 fs/ext4/inode.c                                    |  2 +-
 fs/f2fs/data.c                                     | 17 ++++---
 fs/f2fs/f2fs.h                                     | 11 +++++
 fs/f2fs/file.c                                     |  2 +-
 fs/f2fs/gc.c                                       |  2 +-
 fs/f2fs/segment.c                                  |  6 +--
 fs/gfs2/glock.c                                    | 23 ++++++----
 fs/gfs2/lock_dlm.c                                 |  9 ++--
 fs/gfs2/log.c                                      |  3 +-
 fs/gfs2/lops.c                                     |  6 ++-
 fs/hugetlbfs/inode.c                               |  8 +---
 fs/nfs/client.c                                    |  7 ++-
 include/linux/bio.h                                |  2 +-
 include/linux/cgroup-defs.h                        |  5 +++
 include/linux/hid.h                                |  1 +
 include/linux/hugetlb.h                            |  4 +-
 include/linux/iio/adc/ad_sigma_delta.h             |  1 +
 include/linux/smpboot.h                            |  2 +-
 kernel/auditfilter.c                               | 12 ++---
 kernel/bpf/devmap.c                                |  3 ++
 kernel/cgroup/cgroup.c                             |  6 +++
 kernel/rcu/rcuperf.c                               |  5 +++
 kernel/rcu/rcutorture.c                            |  5 +++
 kernel/sched/core.c                                |  9 +++-
 kernel/sched/rt.c                                  |  5 +++
 kernel/trace/trace_branch.c                        |  4 ++
 lib/kobject_uevent.c                               | 11 +++--
 lib/sbitmap.c                                      |  2 +-
 lib/strncpy_from_user.c                            |  5 ++-
 lib/strnlen_user.c                                 |  4 +-
 mm/hugetlb.c                                       | 23 +++-------
 mm/userfaultfd.c                                   |  3 +-
 net/batman-adv/distributed-arp-table.c             |  4 +-
 net/batman-adv/main.c                              |  1 +
 net/batman-adv/multicast.c                         | 11 ++---
 net/batman-adv/types.h                             |  2 +
 net/ipv4/ip_gre.c                                  |  2 +-
 net/mac80211/mlme.c                                |  3 --
 net/wireless/nl80211.c                             |  5 +++
 sound/soc/codecs/hdmi-codec.c                      |  6 ++-
 sound/soc/davinci/davinci-mcasp.c                  |  2 +
 sound/soc/fsl/Kconfig                              |  9 ++--
 sound/soc/fsl/eukrea-tlv320.c                      |  4 +-
 sound/soc/fsl/fsl_sai.c                            |  2 +
 sound/soc/fsl/fsl_utils.c                          |  1 +
 tools/lib/bpf/bpf.c                                |  2 +
 tools/lib/bpf/bpf.h                                |  1 +
 205 files changed, 1216 insertions(+), 552 deletions(-)


