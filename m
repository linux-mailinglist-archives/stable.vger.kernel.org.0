Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D800C2F427
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfE3Efn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbfE3DNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:08 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 380F224534;
        Thu, 30 May 2019 03:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185984;
        bh=5Hsd0NCCTbMOa5qYasAzDg2wzWxnm3y5D/T9hi+msHk=;
        h=From:To:Cc:Subject:Date:From;
        b=owLda+qwb6zZUfAVLtlyALY1dBUBi0hRjLsKqTWymgJ7CaYrcQsEO9lRM1P4wraDA
         J/qwbyCxQE0aeDp+gVh/QAKBqVXFHapsDBcOreHYiE6J0sDOenvYUW04fbExP8Nt7I
         5yn0nq+PSzTgvLg+/KzwCaqaEYrGbBhV0asnnX+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.0 000/346] 5.0.20-stable review
Date:   Wed, 29 May 2019 20:01:13 -0700
Message-Id: <20190530030540.363386121@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.0.20-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.0.20-rc1
X-KernelTest-Deadline: 2019-06-01T03:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.0.20 release.
There are 346 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 01 Jun 2019 03:02:10 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.20-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.0.20-rc1

Benjamin Coddington <bcodding@redhat.com>
    NFS: Fix a double unlock from nfs_match,get_client

Maxime Ripard <maxime.ripard@bootlin.com>
    drm/sun4i: dsi: Enforce boundaries on the start delay

Brett Creeley <brett.creeley@intel.com>
    ice: Put __ICE_PREPARED_FOR_RESET check in ice_prepare_for_reset

Farhan Ali <alifm@linux.ibm.com>
    vfio-ccw: Prevent quiesce function going into an infinite loop

Maxime Ripard <maxime.ripard@bootlin.com>
    drm/sun4i: dsi: Change the start delay calculation

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Wake up next in drm_read() chain if we are forced to putback the event

Noralf Trønnes <noralf@tronnes.org>
    drm/drv: Hold ref on parent device during drm_device lifetime

Eric Anholt <eric@anholt.net>
    drm/v3d: Handle errors from IRQ setup.

Arnd Bergmann <arnd@arndb.de>
    ASoC: ti: fix davinci_mcasp_probe dependencies

Arnd Bergmann <arnd@arndb.de>
    ASoC: davinci-mcasp: Fix clang warning without CONFIG_PM

Chris Lesiak <chris.lesiak@licor.com>
    spi: Fix zero length xfer bug

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: da9055: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: da9062: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: pv88090: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: wm831x: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: pv88080: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: da9063: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: da9211: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: lp8755: Fix notifier mutex lock warning

Trent Piepho <tpiepho@impinj.com>
    spi: imx: stop buffer overflow in RX FIFO flush

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: pv88060: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: ltc3589: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: ltc3676: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: wm831x isink: Fix notifier mutex lock warning

Steve Twiss <stwiss.opensource@diasemi.com>
    regulator: wm831x ldo: Fix notifier mutex lock warning

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: rspi: Fix sequencer reset during initialization

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm/omap: Notify all devices in the pipeline of output disconnection

Tony Lindgren <tony@atomide.com>
    drm/omap: dsi: Fix PM for display blank with paired dss_pll calls

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: writeback: Fix leak of writeback job

Aditya Pakki <pakki001@umn.edu>
    spi : spi-topcliff-pch: Fix to handle empty DMA buffers

Li RongQing <lirongqing@baidu.com>
    audit: fix a memleak caused by auditing load module

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix use-after-free mailbox cmd completion

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix SLI3 commands being issued on SLI4 devices

Arnd Bergmann <arnd@arndb.de>
    media: saa7146: avoid high stack usage with clang

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix fc4type information for FDMI

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix FDMI manufacturer attribute value

Jernej Skrabec <jernej.skrabec@siol.net>
    media: cedrus: Add a quirk for not setting DMA offset

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vim2m: replace devm_kzalloc by kzalloc

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vimc: zero the media_device on probe

Arnd Bergmann <arnd@arndb.de>
    media: go7007: avoid clang frame overflow warning with KASAN

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca: do not resubmit URBs when streaming has stopped

Helen Fornazier <helen.koike@collabora.com>
    media: vimc: stream: fix thread state before sleep

Kangjie Lu <kjlu@umn.edu>
    scsi: ufs: fix a missing check of devm_reset_control_get

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Set stream->mode_changed when connectors change

Murton Liu <murton.liu@amd.com>
    drm/amd/display: Fix Divide by 0 in memory calculations

Arnd Bergmann <arnd@arndb.de>
    media: staging: davinci_vpfe: disallow building with COMPILE_TEST

Wenjing Liu <Wenjing.Liu@amd.com>
    drm/amd/display: add pipe lock during stream update

James Hutchinson <jahutchinson99@googlemail.com>
    media: m88ds3103: serialize reset messages in m88ds3103_set_frontend

Stefan Brüns <stefan.bruens@rwth-aachen.de>
    media: dvbsky: Avoid leaking dvb frontend

Kangjie Lu <kjlu@umn.edu>
    media: si2165: fix a missing check of return value

Kai-Heng Feng <kai.heng.feng@canonical.com>
    igb: Exclude device from suspend direct complete optimization

Noralf Trønnes <noralf@tronnes.org>
    tinydrm/mipi-dbi: Use dma-safe buffers for all SPI transfers

Kai-Heng Feng <kai.heng.feng@canonical.com>
    e1000e: Disable runtime PM on CNP+

Arnd Bergmann <arnd@arndb.de>
    media: staging/intel-ipu3: mark PM function as __maybe_unused

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l2-fwnode: The first default data lane is 0 on C-PHY

Kangjie Lu <kjlu@umn.edu>
    thunderbolt: property: Fix a NULL pointer dereference

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Reset alpha state for planes to the correct values

Samson Tam <Samson.Tam@amd.com>
    drm/amd/display: Link train only when link is DP and backend is enabled

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix releasing planes when exiting odm

Aditya Pakki <pakki001@umn.edu>
    thunderbolt: Fix to check for kmemdup failure

Aditya Pakki <pakki001@umn.edu>
    thunderbolt: Fix to check return value of ida_simple_get

Rouven Czerwinski <r.czerwinski@pengutronix.de>
    hwrng: omap - Set default quality

George Hilliard <thirtythreeforty@gmail.com>
    staging: mt7621-mmc: Check for nonzero number of scatterlist entries

Pu Wen <puwen@hygon.cn>
    x86/CPU/hygon: Fix phys_proc_id calculation logic for multi-die processors

Sameer Pujar <spujar@nvidia.com>
    dmaengine: tegra210-adma: use devm_clk_*() helpers

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: allow updating DAT entry timeouts on incoming ARP Replies

Arnd Bergmann <arnd@arndb.de>
    selinux: avoid uninitialized variable warning

Dave Ertman <david.m.ertman@intel.com>
    ice: Prevent unintended multiple chain resets

Arnd Bergmann <arnd@arndb.de>
    scsi: lpfc: avoid uninitialized variable warning

Arnd Bergmann <arnd@arndb.de>
    scsi: qla4xxx: avoid freeing unallocated dma memory

Tony Lindgren <tony@atomide.com>
    usb: core: Add PM runtime calls to usb_hcd_platform_shutdown

Ludovic Barre <ludovic.barre@st.com>
    spi: stm32-qspi: add spi_master_put in release function

Neeraj Upadhyay <neeraju@codeaurora.org>
    rcu: Do a single rhp->func read in rcu_head_after_call_rcu()

Paul E. McKenney <paulmck@linux.ibm.com>
    rcuperf: Fix cleanup path for invalid perf_type strings

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce: Handle varying MCA bank counts

Paul E. McKenney <paulmck@linux.ibm.com>
    rcutorture: Fix cleanup path for invalid torture_type strings

Tony Luck <tony.luck@intel.com>
    x86/mce: Fix machine_check_poll() tests for error types

Leon Romanovsky <leon@kernel.org>
    overflow: Fix -Wtype-limits compilation warnings

George Hilliard <thirtythreeforty@gmail.com>
    staging: mt7621-mmc: Initialize completions a single time during probe

Kangjie Lu <kjlu@umn.edu>
    tty: ipwireless: fix missing checks for ioremap

Pankaj Gupta <pagupta@redhat.com>
    virtio_console: initialize vtermno value for ports

Chad Dupuis <cdupuis@marvell.com>
    scsi: qedf: Add missing return in qedf_post_io_req() in the fcport offload check

Thomas Gleixner <tglx@linutronix.de>
    timekeeping: Force upper bound for setting CLOCK_REALTIME

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: rcar-du: lvds: Set LVEN and LVRES bits together on D3

Aditya Pakki <pakki001@umn.edu>
    thunderbolt: Fix to check the return value of kmemdup

Kangjie Lu <kjlu@umn.edu>
    thunderbolt: property: Fix a missing check of kzalloc

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    efifb: Omit memory map check on legacy boot

Ezequiel Garcia <ezequiel@collabora.com>
    media: gspca: Kill URBs on USB device disconnect

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

Takeshi Kihara <takeshi.kihara.df@renesas.com>
    clk: renesas: rcar-gen3: Correct parent clock of Audio-DMAC

Ming Lei <ming.lei@redhat.com>
    block: pass page to xen_biovec_phys_mergeable

Takeshi Kihara <takeshi.kihara.df@renesas.com>
    clk: renesas: rcar-gen3: Correct parent clock of SYS-DMAC

Gustavo A. R. Silva <gustavo@embeddedor.com>
    cxgb3/l2t: Fix undefined behaviour

Wen Yang <wen.yang99@zte.com.cn>
    ASoC: fsl_utils: fix a leaked reference by adding missing of_node_put

Wen Yang <wen.yang99@zte.com.cn>
    ASoC: eukrea-tlv320: fix a leaked reference by adding missing of_node_put

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    HID: core: move Usage Page concatenation to Main item

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: sh7786: Add explicit I/O cast to sh7786_mm_sel()

Leon Romanovsky <leon@kernel.org>
    RDMA/hns: Fix bad endianess of port_pd variable

Chengguang Xu <cgxu519@gmx.com>
    chardev: add additional check for minor range overlap

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess: Fix up the fixup

Peter Zijlstra <peterz@infradead.org>
    x86/ia32: Fix ia32_restore_sigcontext() AC leak

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, signal: Fix AC=1 bloat

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess, ftrace: Fix ftrace_likely_update() vs. SMAP

Lior David <liord@codeaurora.org>
    wil6210: fix return code of wmi_mgmt_tx and wmi_mgmt_tx_ext

Peter Zijlstra <peterz@infradead.org>
    locking/static_key: Fix false positive warnings on concurrent dec/inc

Wen Yang <wen.yang99@zte.com.cn>
    arm64: cpu_ops: fix a leaked reference by adding missing of_node_put

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Prevent cursor hotspot overflow for RV overlay planes

Yannick Fertré <yannick.fertre@st.com>
    drm/panel: otm8009a: Add delay at the end of initialization

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

Daniel T. Lee <danieltimlee@gmail.com>
    selftests/bpf: ksym_search won't check symbols exists

Jian Shen <shenjian15@huawei.com>
    net: hns3: add protect when handling mac addr list

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: check resetting status in hns3_get_stats()

Justin Chen <justinpopo6@gmail.com>
    iio: adc: ti-ads7950: Fix improper use of mlock

Nathan Chancellor <natechancellor@gmail.com>
    iio: common: ssp_sensors: Initialize calculated_time in ssp_common_process_data

Kangjie Lu <kjlu@umn.edu>
    iio: hmc5843: fix potential NULL pointer dereferences

Lars-Peter Clausen <lars@metafoo.de>
    iio: ad_sigma_delta: Properly handle SPI bus locking vs CS assertion

Wen Yang <wen.yang99@zte.com.cn>
    drm/pl111: fix possible object reference leak

Charles Keepax <ckeepax@opensource.cirrus.com>
    regulator: core: Avoid potential deadlock on regulator_unregister

Kees Cook <keescook@chromium.org>
    x86/build: Keep local relocations with ld.lld

Alexei Starovoitov <ast@kernel.org>
    samples/bpf: fix build with new clang

David Kozub <zub@linux.fjfi.cvut.cz>
    block: sed-opal: fix IOC_OPAL_ENABLE_DISABLE_MBR

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: imx6q: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: kirkwood: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: pmac32: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq/pasemi: fix possible object reference leak

Wen Yang <wen.yang99@zte.com.cn>
    cpufreq: ppc_cbe: fix possible object reference leak

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: add error handler for initializing command queue

Kristian Evensen <kristian.evensen@gmail.com>
    qmi_wwan: Add quirk for Quectel dynamic config

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: fix keep_alive_timer not stop problem

Roman Gushchin <guro@fb.com>
    selftests: cgroup: fix cleanup path in test_memcg_subtree_control()

Arnd Bergmann <arnd@arndb.de>
    s390: cio: fix cio_irb declaration

Thomas Huth <thuth@redhat.com>
    s390/mm: silence compiler warning when compiling without CONFIG_PGSTE

Borislav Petkov <bp@suse.de>
    x86/microcode: Fix the ancient deprecated microcode loading method

Arnd Bergmann <arnd@arndb.de>
    s390: zcrypt: initialize variables before_use

Michael Tretter <m.tretter@pengutronix.de>
    clk: zynqmp: fix check for fractional clock

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

Peng Li <lipeng321@huawei.com>
    net: hns3: free the pending skb when clean RX ring

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

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    PM / devfreq: Fix static checker warning in try_then_request_governor

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/cstate: Add Icelake support

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/rapl: Add Icelake support

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/msr: Add Icelake support

Colin Ian King <colin.king@canonical.com>
    RDMA/cxgb4: Fix null pointer dereference on alloc_skb failure

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: vdso: Fix clock_getres() for CLOCK_REALTIME

Kefeng Wang <wangkefeng.wang@huawei.com>
    ACPI/IORT: Reject platform device creation on NUMA node mapping failure

Nicholas Nunley <nicholas.d.nunley@intel.com>
    i40e: don't allow changes to HW VLAN stripping on active port VLANs

Adam Ludkiewicz <adam.ludkiewicz@intel.com>
    i40e: Able to add up to 16 MAC filters on an untrusted VF

Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
    dpaa2-eth: Fix Rx classification status

Arnd Bergmann <arnd@arndb.de>
    phy: mapphone-mdm6600: add gpiolib dependency

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    phy: sun4i-usb: Make sure to disable PHY0 passby for peripheral mode

Evan Green <evgreen@chromium.org>
    dt-bindings: phy-qcom-qmp: Add UFS PHY reset

Russell King <rmk+kernel@armlinux.org.uk>
    drm: etnaviv: avoid DMA API warning when importing buffers

Thomas Gleixner <tglx@linutronix.de>
    x86/irq/64: Limit IST stack overflow check to #DB stack

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't unbind interfaces following device reset failure

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: handle error from qeth_update_from_chp_desc()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Take domain lock in switch sysfs attribute callbacks

Nicholas Piggin <npiggin@gmail.com>
    irq_work: Do not raise an IPI when queueing work on the local CPU

Luca Weiss <luca@z3ntu.xyz>
    drm/msm: Fix NULL pointer dereference

Sean Paul <seanpaul@chromium.org>
    drm/msm: dpu: Don't set frame_busy_mask for async updates

Wen Yang <wen.yang99@zte.com.cn>
    drm/msm: a5xx: fix possible object reference leak

Jeykumar Sankaran <jsanka@codeaurora.org>
    drm/msm/dpu: release resources on modeset failure

Nicholas Mc Guire <hofrat@osadl.org>
    staging: vc04_services: handle kzalloc failure

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

Jon DeVree <nuxi@vault24.org>
    random: fix CRNG initialization when random.trust_cpu=1

Russell Currey <ruscur@russell.cc>
    powerpc/64: Fix booting large kernels with STRICT_KERNEL_RWX

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/numa: improve control of topology updates

Yufen Yu <yuyufen@huawei.com>
    block: fix use-after-free on gendisk

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-dfsdm: fix unmet direct dependencies detected

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

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cci: Remove broken race mitigation

Douglas Anderson <dianders@chromium.org>
    clk: rockchip: undo several noc and special clocks as critical on rk3288

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: samsung: fix leaked of_node references

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: st: fix leaked of_node references

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: pistachio: fix leaked of_node references

Hans de Goede <hdegoede@redhat.com>
    HID: logitech-hidpp: use RAP instead of FAP to get the protocol version

Ferry Toth <ftoth@exalondelft.nl>
    Bluetooth: btbcm: Add default address for BCM43341B

Balakrishna Godavarthi <bgodavar@codeaurora.org>
    Bluetooth: hci_qca: Give enough time to ROME controller to bootup.

Peter Zijlstra <peterz@infradead.org>
    mm/uaccess: Use 'unsigned long' to placate UBSAN warnings on older GCC versions

Jiri Kosina <jkosina@suse.cz>
    x86/mm: Remove in_nmi() warning from 64-bit implementation of vmalloc_fault()

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess: Dont leak the AC flag into __put_user() argument evaluation

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    smpboot: Place the __percpu annotation correctly

Kees Cook <keescook@chromium.org>
    x86/build: Move _etext to actual end of .text

Farhan Ali <alifm@linux.ibm.com>
    vfio-ccw: Release any channel program when releasing/removing vfio-ccw mdev

Farhan Ali <alifm@linux.ibm.com>
    vfio-ccw: Do not call flush_workqueue while holding the spinlock

Parav Pandit <parav@mellanox.com>
    RDMA/cma: Consider scope_id while binding to ipv6 ll address

Arnd Bergmann <arnd@arndb.de>
    bcache: avoid clang -Wunintialized warning

Coly Li <colyli@suse.de>
    bcache: add failure check to run_cache_set() for journal replay

Tang Junhui <tang.junhui.linux@gmail.com>
    bcache: fix failure in journal relplay

Coly Li <colyli@suse.de>
    bcache: return error immediately in bch_journal_replay()

Shenghui Wang <shhuiw@foxmail.com>
    bcache: avoid potential memleak of list of journal_replay(s) in the CACHE_SYNC branch of run_cache_set

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun4i-ss - Fix invalid calculation of hash end

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix a NULL deref when an admin connect times out

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix a NULL deref when an admin connect times out

Sagi Grimberg <sagi@grimberg.me>
    nvme: set 0 capacity if namespace block size exceeds PAGE_SIZE

Kangjie Lu <kjlu@umn.edu>
    net: cw1200: fix a NULL pointer dereference

Aditya Pakki <pakki001@umn.edu>
    rsi: Fix NULL pointer dereference in kmalloc

Dan Carpenter <dan.carpenter@oracle.com>
    mwifiex: prevent an array overflow

Xiaoli Feng <fengxiaoli0714@gmail.com>
    Fix nfs4.2 return -EINVAL when do dedupe operation

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: fsl_sai: Update is_slave_mode with correct value

Kangjie Lu <kjlu@umn.edu>
    slimbus: fix a potential NULL pointer dereference in of_qcom_slim_ngd_register

Daniel T. Lee <danieltimlee@gmail.com>
    libbpf: fix samples/bpf build failure due to undefined UINT32_MAX

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
    mac80211/cfg80211: update bss channel on channel switch

Sugar Zhang <sugar.zhang@rock-chips.com>
    dmaengine: pl330: _stop: clear interrupt status

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: use atomic_t replace u32 for arq's count

Arnd Bergmann <arnd@arndb.de>
    s390: qeth: address type mismatch warning

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: improve genphy_soft_reset

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: fix for TX clean num when cleaning TX BD

Mariusz Bialonczyk <manio@skyboo.net>
    w1: fix the resume command API

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw: fix allmulti cfg in dual_mac mode

Nicholas Piggin <npiggin@gmail.com>
    sched/nohz: Run NOHZ idle load balancer on HK_FLAG_MISC CPUs

Bard liao <yung-chuan.liao@linux.intel.com>
    ALSA: hda: fix unregister device twice on ASoC driver

Philipp Rudo <prudo@linux.ibm.com>
    s390/kexec_file: Fix detection of text segment in ELF loader

Manish Rangankar <mrangankar@marvell.com>
    scsi: qedi: Abort ep termination if offload not scheduled

Fabien Dessenne <fabien.dessenne@st.com>
    rtc: stm32: manage the get_irq probe defer case

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

Nadav Amit <namit@vmware.com>
    x86/modules: Avoid breaking W^X while loading modules

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix hardirq-unsafe locking

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Avoid that lockdep complains about unsafe locking in tcm_qla2xxx_close_session()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix abort handling in tcm_qla2xxx_write_pending()

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix a qla24xx_enable_msix() error path

Viresh Kumar <viresh.kumar@linaro.org>
    sched/cpufreq: Fix kobject memleak

Nicholas Piggin <npiggin@gmail.com>
    powerpc/watchdog: Use hrtimers for per-CPU heartbeat

Nadav Amit <namit@vmware.com>
    x86/ftrace: Set trampoline pages as executable

Qian Cai <cai@lca.pw>
    arm64: Fix compiler warning from pte_unmap() with -Wunused-but-set-variable

Marc Zyngier <marc.zyngier@arm.com>
    ARM: vdso: Remove dependency with the arch_timer driver internals

Fabien Dessenne <fabien.dessenne@st.com>
    media: stm32-dcmi: return appropriate error codes during probe

Jon Derrick <jonathan.derrick@intel.com>
    drm/nouveau/bar/nv50: ensure BAR is mapped

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ACPI / property: fix handling of data_nodes in acpi_get_next_subnode()

Dan Carpenter <dan.carpenter@oracle.com>
    brcm80211: potential NULL dereference in brcmf_cfg80211_vndr_cmds_dcmd_handler()

Flavio Suligoi <f.suligoi@asem.it>
    spi: pxa2xx: fix SCR (divisor) calculation

Arnd Bergmann <arnd@arndb.de>
    ASoC: imx: fix fiq dependencies

Claudiu Beznea <claudiu.beznea@microchip.com>
    spi: atmel-quadspi: fix crash while suspending

Anju T Sudhakar <anju@linux.vnet.ibm.com>
    powerpc/perf: Fix loop exit condition in nest_imc_event_init

Bo YU <tsu.yubo@gmail.com>
    powerpc/boot: Fix missing check of lseek() return value

Anju T Sudhakar <anju@linux.vnet.ibm.com>
    powerpc/perf: Return accordingly on invalid chip-id in

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: hdmi-codec: unlock the device on startup errors

Fei Yang <fei.yang@intel.com>
    usb: gadget: f_fs: don't free buffer prematurely

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc3: move synchronize_irq() out of the spinlock protected block

Minas Harutyunyan <minas.harutyunyan@synopsys.com>
    usb: dwc2: gadget: Increase descriptors count for ISOC's

Mac Chiang <mac.chiang@intel.com>
    ASoC: Intel: kbl_da7219_max98357a: Map BTN_0 to KEY_PLAYPAUSE

Wen Yang <wen.yang99@zte.com.cn>
    pinctrl: zte: fix leaked of_node references

João Paulo Rechi Vita <jprvita@gmail.com>
    Bluetooth: Ignore CC events not matching the last HCI command

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: fix race that may miss tx queue wakeup

Sameeh Jubran <sameehj@amazon.com>
    net: ena: fix: set freed objects to NULL to avoid failing future allocations

Sameeh Jubran <sameehj@amazon.com>
    net: ena: gcc 8: fix compilation warning

Sameer Pujar <spujar@nvidia.com>
    dmaengine: tegra210-dma: free dma controller in remove()

Ming Lei <ming.lei@redhat.com>
    blk-mq: grab .q_usage_counter when queuing request from plug code path

Ming Lei <ming.lei@redhat.com>
    blk-mq: split blk_mq_alloc_and_init_hctx into two parts

Tony Nguyen <anthony.l.nguyen@intel.com>
    ice: Separate if conditions for ice_set_features()

Masahiro Yamada <yamada.masahiro@socionext.com>
    bpftool: exclude bash-completion/bpftool from .gitignore pattern

Yonghong Song <yhs@fb.com>
    selftests/bpf: set RLIMIT_MEMLOCK properly for test_libbpf_open.c

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    tools/bpf: fix perf build error with uClibc (seen on ARC)

Raul E Rangel <rrangel@chromium.org>
    mmc: core: Verify SD bus width

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix occasional glock use-after-free

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Fix WQ_MEM_RECLAIM warning

Abhi Das <adas@redhat.com>
    gfs2: fix race between gfs2_freeze_func and unmount

Roberto Bergantinos Corpas <rbergant@redhat.com>
    NFS: make nfs_match_client killable

David Howells <dhowells@redhat.com>
    afs: Fix getting the afs.fid xattr

YueHaibing <yuehaibing@huawei.com>
    cxgb4: Fix error path in cxgb4_init_module

Ross Lagerwall <ross.lagerwall@citrix.com>
    gfs2: Fix lru_count going negative

David Sterba <dsterba@suse.com>
    Revert "btrfs: Honour FITRIM range constraints during free space trim"

Kristian Evensen <kristian.evensen@gmail.com>
    netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression

Al Viro <viro@zeniv.linux.org.uk>
    acct_on(): don't mess with freeze protection

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

Hans Verkuil <hverkuil@xs4all.nl>
    media: vb2: add waiting_in_dqbuf flag

YueHaibing <yuehaibing@huawei.com>
    media: serial_ir: Fix use-after-free in serial_ir_init_module

YueHaibing <yuehaibing@huawei.com>
    media: cpia2: Fix use-after-free in cpia2_exit

Jiufei Xue <jiufei.xue@linux.alibaba.com>
    fbdev: fix WARNING in __alloc_pages_nodemask bug

Amir Goldstein <amir73il@gmail.com>
    ovl: relax WARN_ON() for overlapping layers use case

Josef Bacik <josef@toxicpanda.com>
    btrfs: honor path->skip_locking in backref code

Will Deacon <will.deacon@arm.com>
    arm64: errata: Add workaround for Cortex-A76 erratum #1463225

Arend van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: add subtype check for event handling in data path

Arend van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: assure SSID length from firmware is limited

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix credits leak for SMB1 oplock breaks

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

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't double unlock on error in btrfs_punch_hole

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix sign extension bug in gfs2_update_stats

Christoph Hellwig <hch@lst.de>
    arm64/iommu: handle non-remapped addresses in ->mmap and ->get_sgtable

Ard Biesheuvel <ard.biesheuvel@arm.com>
    arm64/kernel: kaslr: reduce module randomization range to 2 GB

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

Eric Biggers <ebiggers@google.com>
    crypto: hash - fix incorrect HASH_MAX_DESCSIZE

Martin K. Petersen <martin.petersen@oracle.com>
    Revert "scsi: sd: Keep disk read-only when re-reading partition"

Andrea Parri <andrea.parri@amarulasolutions.com>
    sbitmap: fix improper use of smp_mb__before_atomic()

Andrea Parri <andrea.parri@amarulasolutions.com>
    bio: fix improper use of smp_mb__before_atomic()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix return value for reserved EFER

Jan Kara <jack@suse.cz>
    ext4: wait for outstanding dio during truncate in nojournal mode

Jan Kara <jack@suse.cz>
    ext4: do not delete unlinked inode from orphan list on failed truncate

Steven Rostedt (VMware) <rostedt@goodmis.org>
    x86: Hide the int3_emulate_call/jmp functions from UML


-------------

Diffstat:

 Documentation/arm64/silicon-errata.txt             |   1 +
 .../devicetree/bindings/phy/qcom-qmp-phy.txt       |   6 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/cp15.h                        |   2 +
 arch/arm/vdso/vgettimeofday.c                      |   5 +-
 arch/arm64/Kconfig                                 |  18 +++
 arch/arm64/include/asm/cpucaps.h                   |   3 +-
 arch/arm64/include/asm/pgtable.h                   |   3 +-
 arch/arm64/include/asm/vdso_datapage.h             |   1 +
 arch/arm64/kernel/asm-offsets.c                    |   2 +-
 arch/arm64/kernel/cpu_errata.c                     |  24 ++++
 arch/arm64/kernel/cpu_ops.c                        |   1 +
 arch/arm64/kernel/kaslr.c                          |   6 +-
 arch/arm64/kernel/module.c                         |   2 +-
 arch/arm64/kernel/syscall.c                        |  31 +++++
 arch/arm64/kernel/vdso.c                           |   3 +
 arch/arm64/kernel/vdso/gettimeofday.S              |   7 +-
 arch/arm64/mm/dma-mapping.c                        |  10 ++
 arch/arm64/mm/fault.c                              |  37 +++++-
 arch/powerpc/boot/addnote.c                        |   6 +-
 arch/powerpc/kernel/head_64.S                      |   4 +-
 arch/powerpc/kernel/watchdog.c                     |  81 ++++++------
 arch/powerpc/mm/numa.c                             |  18 ++-
 arch/powerpc/perf/imc-pmu.c                        |   7 +-
 arch/powerpc/platforms/powernv/opal-imc.c          |   2 +-
 arch/s390/kernel/kexec_elf.c                       |   7 +-
 arch/s390/mm/pgtable.c                             |   2 +
 arch/sh/include/cpu-sh4/cpu/sh7786.h               |   2 +-
 arch/x86/Makefile                                  |   2 +-
 arch/x86/events/intel/cstate.c                     |   2 +
 arch/x86/events/intel/rapl.c                       |   2 +
 arch/x86/events/msr.c                              |   1 +
 arch/x86/ia32/ia32_signal.c                        |  29 +++--
 arch/x86/include/asm/text-patching.h               |   4 +-
 arch/x86/include/asm/uaccess.h                     |   7 +-
 arch/x86/kernel/alternative.c                      |  28 +++--
 arch/x86/kernel/cpu/hygon.c                        |   5 +
 arch/x86/kernel/cpu/mce/core.c                     |  66 ++++++----
 arch/x86/kernel/cpu/mce/inject.c                   |  14 +--
 arch/x86/kernel/cpu/microcode/core.c               |   3 +-
 arch/x86/kernel/ftrace.c                           |   8 ++
 arch/x86/kernel/irq_64.c                           |  19 ++-
 arch/x86/kernel/module.c                           |   2 +-
 arch/x86/kernel/signal.c                           |  29 +++--
 arch/x86/kernel/vmlinux.lds.S                      |   6 +-
 arch/x86/kvm/svm.c                                 |   6 +-
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/x86/lib/memcpy_64.S                           |   3 +-
 arch/x86/mm/fault.c                                |   2 -
 block/blk-mq-sched.c                               |  12 +-
 block/blk-mq.c                                     | 139 +++++++++++----------
 block/blk.h                                        |   2 +-
 block/genhd.c                                      |  19 +++
 block/partition-generic.c                          |   7 ++
 block/sed-opal.c                                   |   9 +-
 crypto/hmac.c                                      |   2 +
 drivers/acpi/arm64/iort.c                          |  19 ++-
 drivers/acpi/property.c                            |   8 ++
 drivers/base/power/main.c                          |   4 +
 drivers/bluetooth/btbcm.c                          |   4 +-
 drivers/bluetooth/hci_qca.c                        |   2 +
 drivers/char/hw_random/omap-rng.c                  |   1 +
 drivers/char/random.c                              |  57 +++++----
 drivers/char/virtio_console.c                      |   3 +-
 drivers/clk/renesas/r8a774a1-cpg-mssr.c            |   8 +-
 drivers/clk/renesas/r8a774c0-cpg-mssr.c            |   2 +-
 drivers/clk/renesas/r8a7795-cpg-mssr.c             |   8 +-
 drivers/clk/renesas/r8a7796-cpg-mssr.c             |   8 +-
 drivers/clk/renesas/r8a77965-cpg-mssr.c            |   8 +-
 drivers/clk/renesas/r8a77990-cpg-mssr.c            |   2 +-
 drivers/clk/renesas/r8a77995-cpg-mssr.c            |   2 +-
 drivers/clk/rockchip/clk-rk3288.c                  |  21 ++--
 drivers/clk/zynqmp/divider.c                       |   9 +-
 drivers/cpufreq/cpufreq.c                          |   1 +
 drivers/cpufreq/cpufreq_governor.c                 |   2 +
 drivers/cpufreq/imx6q-cpufreq.c                    |   4 +-
 drivers/cpufreq/kirkwood-cpufreq.c                 |  19 +--
 drivers/cpufreq/pasemi-cpufreq.c                   |   1 +
 drivers/cpufreq/pmac32-cpufreq.c                   |   2 +
 drivers/cpufreq/ppc_cbe_cpufreq.c                  |   1 +
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c            |   5 +-
 drivers/crypto/vmx/aesp8-ppc.pl                    |   2 +-
 drivers/devfreq/devfreq.c                          |   4 +-
 drivers/dma/at_xdmac.c                             |   6 +-
 drivers/dma/pl330.c                                |  10 +-
 drivers/dma/tegra210-adma.c                        |  28 ++---
 drivers/extcon/extcon-arizona.c                    |  10 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  24 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   5 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  15 ++-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   6 +-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c  |  20 ++-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  12 +-
 drivers/gpu/drm/drm_atomic_state_helper.c          |   4 +
 drivers/gpu/drm/drm_drv.c                          |   5 +-
 drivers/gpu/drm/drm_file.c                         |   1 +
 drivers/gpu/drm/drm_writeback.c                    |  14 ++-
 drivers/gpu/drm/etnaviv/etnaviv_drv.c              |   5 +
 drivers/gpu/drm/etnaviv/etnaviv_drv.h              |   1 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  10 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |  15 ++-
 drivers/gpu/drm/msm/msm_gem_vma.c                  |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c     |  12 +-
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |  60 ++++-----
 drivers/gpu/drm/omapdrm/omap_connector.c           |  28 +++--
 drivers/gpu/drm/panel/panel-orisetech-otm8009a.c   |   3 +
 drivers/gpu/drm/pl111/pl111_versatile.c            |   4 +
 drivers/gpu/drm/rcar-du/rcar_lvds.c                |   8 +-
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c             |   8 +-
 drivers/gpu/drm/tinydrm/ili9225.c                  |   6 +-
 drivers/gpu/drm/tinydrm/mipi-dbi.c                 |  58 ++++++---
 drivers/gpu/drm/v3d/v3d_drv.c                      |   8 +-
 drivers/gpu/drm/v3d/v3d_drv.h                      |   2 +-
 drivers/gpu/drm/v3d/v3d_irq.c                      |  13 +-
 drivers/hid/hid-core.c                             |  36 ++++--
 drivers/hid/hid-logitech-hidpp.c                   |  23 +++-
 drivers/hwmon/f71805f.c                            |  15 ++-
 drivers/hwmon/pc87427.c                            |  14 ++-
 drivers/hwmon/smsc47b397.c                         |  13 +-
 drivers/hwmon/smsc47m1.c                           |  28 +++--
 drivers/hwmon/vt1211.c                             |  15 ++-
 drivers/iio/adc/Kconfig                            |   1 +
 drivers/iio/adc/ad_sigma_delta.c                   |  16 ++-
 drivers/iio/adc/ti-ads7950.c                       |  19 ++-
 drivers/iio/common/ssp_sensors/ssp_iio.c           |   2 +-
 drivers/iio/magnetometer/hmc5843_i2c.c             |   7 +-
 drivers/iio/magnetometer/hmc5843_spi.c             |   7 +-
 drivers/infiniband/core/cma.c                      |  25 +++-
 drivers/infiniband/hw/cxgb4/cm.c                   |   2 +
 drivers/infiniband/hw/hfi1/init.c                  |   3 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   2 +-
 drivers/md/bcache/alloc.c                          |   5 +-
 drivers/md/bcache/journal.c                        |  26 +++-
 drivers/md/bcache/super.c                          |  25 +++-
 drivers/media/common/videobuf2/videobuf2-core.c    |  22 ++++
 drivers/media/dvb-frontends/m88ds3103.c            |   9 +-
 drivers/media/dvb-frontends/si2165.c               |   8 +-
 drivers/media/i2c/ov2659.c                         |   6 +-
 drivers/media/i2c/ov6650.c                         |  25 ++--
 drivers/media/pci/saa7146/hexium_gemini.c          |   5 +-
 drivers/media/pci/saa7146/hexium_orion.c           |   5 +-
 drivers/media/platform/coda/coda-bit.c             |   3 +
 drivers/media/platform/stm32/stm32-dcmi.c          |  20 ++-
 drivers/media/platform/video-mux.c                 |   5 +
 drivers/media/platform/vim2m.c                     |  35 ++++--
 drivers/media/platform/vimc/vimc-core.c            |   2 +
 drivers/media/platform/vimc/vimc-streamer.c        |   2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   7 +-
 drivers/media/rc/serial_ir.c                       |   9 +-
 drivers/media/usb/au0828/au0828-video.c            |  16 ++-
 drivers/media/usb/cpia2/cpia2_v4l.c                |   3 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |  18 +--
 drivers/media/usb/go7007/go7007-fw.c               |   4 +-
 drivers/media/usb/gspca/gspca.c                    |  12 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h            |   1 +
 drivers/media/v4l2-core/v4l2-fwnode.c              |   6 +-
 drivers/mmc/core/pwrseq_emmc.c                     |  38 +++---
 drivers/mmc/core/sd.c                              |   8 ++
 drivers/mmc/host/mmc_spi.c                         |   4 +
 drivers/mmc/host/sdhci-iproc.c                     |   6 +-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   8 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  27 ++--
 drivers/net/ethernet/chelsio/cxgb3/l2t.h           |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  15 ++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  20 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   5 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  11 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  13 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  12 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   7 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   8 ++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   6 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  25 +++-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +
 drivers/net/ethernet/ti/cpsw.c                     |  12 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 |  19 +--
 drivers/net/ethernet/ti/cpsw_ale.h                 |   3 +-
 drivers/net/hyperv/netvsc.c                        |  15 ++-
 drivers/net/phy/phy_device.c                       |  16 ++-
 drivers/net/usb/qmi_wwan.c                         |  65 +++++-----
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   5 +
 drivers/net/wireless/ath/wil6210/wmi.c             |  11 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   4 +-
 drivers/net/wireless/broadcom/b43/phy_lp.c         |   6 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  15 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |  16 ++-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  42 ++++---
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  27 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/vendor.c  |   5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   7 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   6 +-
 drivers/net/wireless/marvell/mwifiex/cfp.c         |   3 +
 drivers/net/wireless/realtek/rtlwifi/base.c        |   5 +
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |   2 +
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8723ae/fw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |   4 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |  30 +++--
 drivers/net/wireless/st/cw1200/main.c              |   5 +
 drivers/nvdimm/pmem.c                              |  10 +-
 drivers/nvme/host/core.c                           |   7 +-
 drivers/nvme/host/rdma.c                           |  10 +-
 drivers/nvme/host/tcp.c                            |   8 +-
 drivers/perf/arm-cci.c                             |  21 ++--
 drivers/phy/allwinner/phy-sun4i-usb.c              |   4 +
 drivers/phy/motorola/Kconfig                       |   2 +-
 drivers/pinctrl/pinctrl-pistachio.c                |   2 +
 drivers/pinctrl/pinctrl-st.c                       |  15 ++-
 drivers/pinctrl/samsung/pinctrl-exynos-arm.c       |   1 +
 drivers/pinctrl/zte/pinctrl-zx.c                   |   1 +
 drivers/regulator/core.c                           |   3 +-
 drivers/regulator/da9055-regulator.c               |   2 +
 drivers/regulator/da9062-regulator.c               |   2 +
 drivers/regulator/da9063-regulator.c               |   5 +-
 drivers/regulator/da9211-regulator.c               |   4 +
 drivers/regulator/lp8755.c                         |  15 ++-
 drivers/regulator/ltc3589.c                        |  10 +-
 drivers/regulator/ltc3676.c                        |  10 +-
 drivers/regulator/pv88060-regulator.c              |   4 +
 drivers/regulator/pv88080-regulator.c              |   4 +
 drivers/regulator/pv88090-regulator.c              |   4 +
 drivers/regulator/wm831x-dcdc.c                    |   4 +
 drivers/regulator/wm831x-isink.c                   |   2 +
 drivers/regulator/wm831x-ldo.c                     |   2 +
 drivers/rtc/rtc-88pm860x.c                         |   2 +-
 drivers/rtc/rtc-stm32.c                            |   9 +-
 drivers/rtc/rtc-xgene.c                            |  18 +--
 drivers/s390/cio/cio.h                             |   2 +-
 drivers/s390/cio/vfio_ccw_drv.c                    |  32 ++---
 drivers/s390/cio/vfio_ccw_ops.c                    |  11 +-
 drivers/s390/crypto/zcrypt_api.c                   |   4 +
 drivers/s390/net/qeth_core.h                       |  10 +-
 drivers/s390/net/qeth_core_main.c                  |  14 ++-
 drivers/scsi/libsas/sas_expander.c                 |   5 +
 drivers/scsi/lpfc/lpfc_ct.c                        |  22 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  15 ++-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   8 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   2 +-
 drivers/scsi/qedf/qedf_io.c                        |   1 +
 drivers/scsi/qedi/qedi_iscsi.c                     |   3 +
 drivers/scsi/qla2xxx/qla_isr.c                     |   6 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  25 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   7 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +-
 drivers/scsi/sd.c                                  |   3 +-
 drivers/scsi/ufs/ufs-hisi.c                        |   4 +
 drivers/scsi/ufs/ufshcd.c                          |  28 +++--
 drivers/slimbus/qcom-ngd-ctrl.c                    |   4 +
 drivers/spi/atmel-quadspi.c                        |   6 +-
 drivers/spi/spi-imx.c                              |   2 +-
 drivers/spi/spi-pxa2xx.c                           |   8 +-
 drivers/spi/spi-rspi.c                             |   9 +-
 drivers/spi/spi-stm32-qspi.c                       |  46 ++++---
 drivers/spi/spi-tegra114.c                         |  32 ++---
 drivers/spi/spi-topcliff-pch.c                     |  15 ++-
 drivers/spi/spi.c                                  |   2 +
 drivers/ssb/bridge_pcmcia_80211.c                  |   9 +-
 drivers/staging/media/davinci_vpfe/Kconfig         |   2 +-
 drivers/staging/media/ipu3/ipu3.c                  |   2 +-
 drivers/staging/media/sunxi/cedrus/cedrus.h        |   3 +
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c     |   3 +-
 drivers/staging/mt7621-mmc/sd.c                    |  27 +++-
 .../interface/vchiq_arm/vchiq_2835_arm.c           |   3 +
 .../vc04_services/interface/vchiq_arm/vchiq_core.c |   2 +
 drivers/thunderbolt/icm.c                          |   5 +
 drivers/thunderbolt/property.c                     |  12 +-
 drivers/thunderbolt/switch.c                       |  67 +++++-----
 drivers/thunderbolt/tb.h                           |   3 +-
 drivers/thunderbolt/xdomain.c                      |   8 +-
 drivers/tty/ipwireless/main.c                      |   8 ++
 drivers/usb/core/hcd.c                             |   3 +
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/dwc2/gadget.c                          |  27 ++--
 drivers/usb/dwc3/core.c                            |   2 +
 drivers/usb/dwc3/gadget.c                          |   2 -
 drivers/usb/gadget/function/f_fs.c                 |   3 +-
 drivers/video/fbdev/core/fbcmap.c                  |   2 +
 drivers/video/fbdev/core/modedb.c                  |   3 +
 drivers/video/fbdev/efifb.c                        |   3 +-
 drivers/w1/w1_io.c                                 |   3 +-
 drivers/xen/biomerge.c                             |   5 +-
 fs/afs/xattr.c                                     |  15 ++-
 fs/btrfs/backref.c                                 |  19 +--
 fs/btrfs/extent-tree.c                             |  28 ++---
 fs/btrfs/file.c                                    |  19 ++-
 fs/btrfs/relocation.c                              |  31 +++--
 fs/btrfs/root-tree.c                               |  17 +--
 fs/btrfs/sysfs.c                                   |   7 +-
 fs/btrfs/tree-log.c                                |   1 +
 fs/char_dev.c                                      |   6 +
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/cifssmb.c                                  |   2 +-
 fs/cifs/transport.c                                |  10 +-
 fs/ext4/inode.c                                    |  23 ++--
 fs/gfs2/glock.c                                    |  23 ++--
 fs/gfs2/incore.h                                   |   1 +
 fs/gfs2/lock_dlm.c                                 |   9 +-
 fs/gfs2/log.c                                      |   3 +-
 fs/gfs2/lops.c                                     |   6 +-
 fs/gfs2/super.c                                    |   8 +-
 fs/internal.h                                      |   2 -
 fs/nfs/client.c                                    |   7 +-
 fs/nfs/nfs4file.c                                  |   2 +-
 fs/overlayfs/dir.c                                 |   2 +-
 fs/overlayfs/inode.c                               |   3 +-
 include/crypto/hash.h                              |   8 +-
 include/drm/tinydrm/mipi-dbi.h                     |   5 +-
 include/linux/bio.h                                |   2 +-
 include/linux/cgroup-defs.h                        |   5 +
 include/linux/filter.h                             |   1 +
 include/linux/genhd.h                              |   1 +
 include/linux/hid.h                                |   1 +
 include/linux/iio/adc/ad_sigma_delta.h             |   1 +
 include/linux/mount.h                              |   2 +
 include/linux/overflow.h                           |  12 +-
 include/linux/rcupdate.h                           |   6 +-
 include/linux/smpboot.h                            |   2 +-
 include/linux/time64.h                             |  21 ++++
 include/media/videobuf2-core.h                     |   1 +
 include/net/bluetooth/hci.h                        |   1 +
 include/xen/xen.h                                  |   4 +-
 kernel/acct.c                                      |   4 +-
 kernel/auditfilter.c                               |  12 +-
 kernel/auditsc.c                                   |  10 +-
 kernel/bpf/devmap.c                                |   3 +
 kernel/cgroup/cgroup.c                             |   6 +
 kernel/irq_work.c                                  |  75 ++++++-----
 kernel/jump_label.c                                |  21 ++--
 kernel/module.c                                    |   5 +
 kernel/rcu/rcuperf.c                               |   5 +
 kernel/rcu/rcutorture.c                            |   5 +
 kernel/sched/core.c                                |   9 +-
 kernel/sched/fair.c                                |  16 ++-
 kernel/sched/rt.c                                  |   5 +
 kernel/time/time.c                                 |   2 +-
 kernel/time/timekeeping.c                          |   6 +-
 kernel/trace/trace_branch.c                        |   4 +
 lib/kobject_uevent.c                               |  11 +-
 lib/sbitmap.c                                      |   2 +-
 lib/strncpy_from_user.c                            |   5 +-
 lib/strnlen_user.c                                 |   4 +-
 net/batman-adv/distributed-arp-table.c             |   4 +-
 net/batman-adv/main.c                              |   1 +
 net/batman-adv/multicast.c                         |  11 +-
 net/batman-adv/types.h                             |   5 +
 net/bluetooth/hci_core.c                           |   5 +
 net/bluetooth/hci_event.c                          |  12 ++
 net/bluetooth/hci_request.c                        |   5 +
 net/bluetooth/hci_request.h                        |   1 +
 net/mac80211/mlme.c                                |   3 -
 net/netfilter/nf_conntrack_netlink.c               |   2 +-
 net/wireless/nl80211.c                             |   5 +
 samples/bpf/asm_goto_workaround.h                  |   1 +
 security/selinux/netlabel.c                        |  14 +--
 sound/pci/hda/hda_codec.c                          |   8 +-
 sound/soc/codecs/hdmi-codec.c                      |   6 +-
 sound/soc/fsl/Kconfig                              |   9 +-
 sound/soc/fsl/eukrea-tlv320.c                      |   4 +-
 sound/soc/fsl/fsl_sai.c                            |   2 +
 sound/soc/fsl/fsl_utils.c                          |   1 +
 sound/soc/intel/boards/kbl_da7219_max98357a.c      |   2 +-
 sound/soc/ti/Kconfig                               |   4 +-
 sound/soc/ti/davinci-mcasp.c                       |   2 +
 tools/bpf/bpftool/.gitignore                       |   2 +-
 tools/lib/bpf/bpf.c                                |   2 +
 tools/lib/bpf/bpf.h                                |   1 +
 tools/testing/selftests/bpf/test_libbpf_open.c     |   2 +
 tools/testing/selftests/bpf/trace_helpers.c        |   4 +
 tools/testing/selftests/cgroup/test_memcontrol.c   |  38 +++---
 378 files changed, 2617 insertions(+), 1202 deletions(-)


