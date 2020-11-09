Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4092ABD0D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgKINAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:00:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730311AbgKINAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:00:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2466C20789;
        Mon,  9 Nov 2020 13:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926805;
        bh=uDvaQ5vzbXo7gHoDBJ82M3VyAyN+TZ8IDDEvEmP6mZ0=;
        h=From:To:Cc:Subject:Date:From;
        b=pIH+O1dOBAxtA9Q9J1j3L5ZyuGmvrfTiOvasRvSpy1sTWoqTGy3rRAyiziOhsvFmP
         vxDzuI55s/tnTZFA+KX/3qFvlIdlqn33R4Nr5WQ96kAyWwfWWg46vh5BNYmByCBVz+
         9+zqNomWZ5bARENpQI9BAqBPsrVk7+6VoTEbz7p0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.9 000/117] 4.9.242-rc1 review
Date:   Mon,  9 Nov 2020 13:53:46 +0100
Message-Id: <20201109125025.630721781@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.242-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.242-rc1
X-KernelTest-Deadline: 2020-11-11T12:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.242 release.
There are 117 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.242-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.242-rc1

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    Revert "ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE"

Vineet Gupta <vgupta@synopsys.com>
    ARC: stack unwinding: avoid indefinite looping

Alan Stern <stern@rowland.harvard.edu>
    USB: Add NO_LPM quirk for Kingston flash drive

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN980 composition 0x1055

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add LE910Cx compositions 0x1203, 0x1230, 0x1231

Johan Hovold <johan@kernel.org>
    USB: serial: cyberjack: fix write-URB completion race

Qinglang Miao <miaoqinglang@huawei.com>
    serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init

Claire Chang <tientzu@chromium.org>
    serial: 8250_mtk: Fix uart_get_baud_rate warning

Eddy Wu <itseddy0402@gmail.com>
    fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent

Daniel Vetter <daniel.vetter@ffwll.ch>
    vt: Disable KD_FONT_OP_COPY

Zhang Qilong <zhangqilong3@huawei.com>
    ACPI: NFIT: Fix comparison to '-ENXIO'

Jeff Vander Stoep <jeffv@google.com>
    vsock: use ns_capable_noaudit() on socket create

Ming Lei <ming.lei@redhat.com>
    scsi: core: Don't start concurrent async scan on same host

Vincent Whitchurch <vincent.whitchurch@axis.com>
    of: Fix reserved-memory overlap detection

Kairui Song <kasong@redhat.com>
    x86/kexec: Use up-to-dated screen_info copy to fill boot params

Clément Péron <peron.clem@gmail.com>
    ARM: dts: sun4i-a10: fix cpu_alert temperature

Qiujun Huang <hqjagain@gmail.com>
    tracing: Fix out of bounds write in get_trace_buf

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Handle tracing when switching between context

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Fix recursion check for NMI test

Zqiang <qiang.zhang@windriver.com>
    kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Add implicit feedback quirk for Qu-16

Lee Jones <lee.jones@linaro.org>
    Fonts: Replace discarded const qualifier

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Account for Tx PTP timestamp in the skb headroom

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP

Hoang Huu Le <hoang.h.le@dektech.com.au>
    tipc: fix use-after-free in tipc_bcast_get_mode

Juergen Gross <jgross@suse.com>
    xen/events: don't use chip_data for legacy IRQs

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    staging: octeon: Drop on uncorrectable alignment or FCS error

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    staging: octeon: repair "fixed-link" support

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and DBGVCR

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Don't clear secondary pointer for shared primary firmware node

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Keep secondary firmware node secondary by type

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: s3c24xx: fix missing system reset

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: samsung: fix PM debug build with DEBUG_LL but !MMU

Helge Deller <deller@gmx.de>
    hil/parisc: Disable HIL driver when it gets stuck

Matthew Wilcox (Oracle) <willy@infradead.org>
    cachefiles: Handle readpage error correctly

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    arm64: berlin: Select DW_APB_TIMER_OF

Linus Torvalds <torvalds@linux-foundation.org>
    tty: make FONTX ioctl use the tty pointer they were actually passed

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    rtc: rx8010: don't modify the global rtc ops

Stefano Garzarella <sgarzare@redhat.com>
    vringh: fix __vringh_iov() when riov and wiov are different

Qiujun Huang <hqjagain@gmail.com>
    ring-buffer: Return 0 on success from ring_buffer_resize()

Matthew Wilcox (Oracle) <willy@infradead.org>
    9P: Cast to loff_t before multiplying

Ilya Dryomov <idryomov@gmail.com>
    libceph: clear con->out_msg on Policy::stateful_server faults

Matthew Wilcox (Oracle) <willy@infradead.org>
    ceph: promote to unsigned long long before shifting

Krzysztof Kozlowski <krzk@kernel.org>
    ia64: fix build error with !COREDUMP

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: check kthread_should_stop() after the setting of task state

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: dent: Fix some potential memory leaks while iterating entries

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc/powernv/elog: Fix race while processing OPAL error log event.

Joel Stanley <joel@jms.id.au>
    powerpc: Warn about use of smt_snooze_delay

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc12138 Fix alignment issue with timestamp

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:si1145: Fix timestamp alignment and prevent data leak.

Paul Cercueil <paul@crapouillou.net>
    dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status

Jiri Slaby <jslaby@suse.cz>
    vt: keyboard, extend func_buf_lock to readers

Jiri Slaby <jslaby@suse.cz>
    vt: keyboard, simplify vt_kdgkbsent

Ran Wang <ran.wang_1@nxp.com>
    usb: host: fsl-mph-dr-of: check return of dma_set_mask()

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: don't trigger runtime pm when remove driver

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: add phy cleanup for probe error handling

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free on readahead extent after failure to create it

Josef Bacik <josef@toxicpanda.com>
    btrfs: cleanup cow block on error

Filipe Manana <fdmanana@suse.com>
    btrfs: reschedule if necessary when logging directory items

Helge Deller <deller@gmx.de>
    scsi: mptfusion: Fix null pointer dereferences in mptscsih_remove()

Martin Fuzzey <martin.fuzzey@flowbird.group>
    w1: mxc_w1: Fix timeout resolution problem leading to bus error

Wei Huang <wei.huang2@amd.com>
    acpi-cpufreq: Honor _PSD table setting on new AMD CPUs

Jamie Iles <jamie@nuviainc.com>
    ACPI: debug: don't allow debugging when ACPI is disabled

Alex Hung <alex.hung@canonical.com>
    ACPI: video: use ACPI backlight for HP 635 Notebook

Ben Hutchings <ben@decadent.org.uk>
    ACPI / extlog: Check for RDMSR failure

Ashish Sangwan <ashishsangwan2@gmail.com>
    NFS: fix nfs_path in case of a rename retry

Jan Kara <jack@suse.cz>
    fs: Don't invalidate page buffers in block_write_full_page()

Marek Behún <marek.behun@nic.cz>
    leds: bcm6328, bcm6358: use devres LED registering function

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Fix raw sample data accumulation

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Don't include randomized bits in get_ibs_op_count()

Song Liu <songliubraving@fb.com>
    md/raid5: fix oops during stripe resizing

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: remove dedicated 'audio-subsystem' node

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: move PMU node out of clock controller

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: remove DMA controller bus node name to fix dtschema warnings

Dan Carpenter <dan.carpenter@oracle.com>
    memory: emif: Remove bogus debugfs error handling

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    gfs2: add validation checks for size of superblock

Jan Kara <jack@suse.cz>
    ext4: Detect already used quota file early

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    drivers: watchdog: rdc321x_wdt: Fix race condition bugs

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid

Tero Kristo <t-kristo@ti.com>
    clk: ti: clockdomain: fix static checker warning

Zhao Heming <heming.zhao@suse.com>
    md/bitmap: md_bitmap_get_counter returns wrong blocks

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    power: supply: test_power: add missing newlines when printing parameters by sysfs

Diana Craciun <diana.craciun@oss.nxp.com>
    bus/fsl_mc: Do not rely on caller to provide non NULL mc_io

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values

Zhengyuan Liu <liuzhengyuan@tj.kylinos.cn>
    arm64/mm: return cpu_all_mask when node is NUMA_NO_NODE

Oliver Neukum <oneukum@suse.com>
    USB: adutux: fix debugging

Alain Volmat <avolmat@me.com>
    cpufreq: sti-cpufreq: add stih418 support

Douglas Anderson <dianders@chromium.org>
    kgdb: Make "kgdbcon" work properly with "kgdb_earlycon"

John Ogness <john.ogness@linutronix.de>
    printk: reduce LOG_BUF_SHIFT range for H8300

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    mmc: via-sdmmc: Fix data race bug

Tom Rix <trix@redhat.com>
    media: tw5864: check status of tw5864_frameinterval_get

Sathishkumar Muruganandam <murugana@codeaurora.org>
    ath10k: fix VHT NSS calculation when STBC is enabled

Tom Rix <trix@redhat.com>
    video: fbdev: pvr2fb: initialize variables

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix realtime bitmap/summary file truncation when growing rt volume

Douglas Anderson <dianders@chromium.org>
    ARM: 8997/2: hw_breakpoint: Handle inexact watchpoint addresses

Johannes Berg <johannes.berg@intel.com>
    um: change sigio_spinlock to a mutex

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to check segment boundary during SIT page readahead

Zhang Qilong <zhangqilong3@huawei.com>
    f2fs: add trace exit in exception path

Nicholas Piggin <npiggin@gmail.com>
    sparc64: remove mm_cpumask clearing to fix kthread_use_mm race

Oliver O'Halloran <oohall@gmail.com>
    powerpc/powernv/smp: Fix spurious DBG() warning

Amit Cohen <amcohen@nvidia.com>
    mlxsw: core: Fix use-after-free in mlxsw_emad_trans_finish()

Eric Biggers <ebiggers@google.com>
    fscrypt: use EEXIST when file already uses different policy

Eric Biggers <ebiggers@google.com>
    fscrypto: move ioctl processing more fully into common code

Eric Biggers <ebiggers@google.com>
    fscrypt: return -EXDEV for incompatible rename or link into encrypted dir

Geert Uytterhoeven <geert+renesas@glider.be>
    ata: sata_rcar: Fix DMA boundary mask

Gustavo A. R. Silva <gustavo@embeddedor.com>
    mtd: lpddr: Fix bad logic in print_drs_error

Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
    p54: avoid accessing the data mapped to streaming DMA

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix page dereference after free

Kim Phillips <kim.phillips@amd.com>
    arch/x86/amd/ibs: Fix re-arming IBS Fetch

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix memory leak caused by tipc_buf_append()

Andrew Gabbasov <andrew_gabbasov@mentor.com>
    ravb: Fix bit fields checking in ravb_hwtstamp_get()

Michael Schaller <misch@google.com>
    efivarfs: Replace invalid slashes with exclamation marks in dentries.

Mukesh Ojha <mukesh02@linux.vnet.ibm.com>
    powerpc/powernv/opal-dump : Use IRQ_HANDLED instead of numbers in interrupt handler

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    scripts/setlocalversion: make git describe output more reliable

NeilBrown <neilb@suse.com>
    SUNRPC: ECONNREFUSED should cause a rebind.


-------------

Diffstat:

 Makefile                                   |   4 +-
 arch/arc/kernel/entry.S                    |  16 ++--
 arch/arc/kernel/stacktrace.c               |   7 +-
 arch/arm/Kconfig                           |   2 +
 arch/arm/boot/dts/s5pv210.dtsi             | 127 +++++++++++++----------------
 arch/arm/boot/dts/sun4i-a10.dtsi           |   2 +-
 arch/arm/kernel/hw_breakpoint.c            | 100 ++++++++++++++++-------
 arch/arm/plat-samsung/Kconfig              |   1 +
 arch/arm64/Kconfig.platforms               |   1 +
 arch/arm64/include/asm/kvm_host.h          |   1 +
 arch/arm64/include/asm/numa.h              |   3 +
 arch/arm64/kvm/sys_regs.c                  |   6 +-
 arch/arm64/mm/numa.c                       |   6 +-
 arch/ia64/kernel/Makefile                  |   2 +-
 arch/powerpc/kernel/sysfs.c                |  42 ++++------
 arch/powerpc/platforms/powernv/opal-dump.c |   9 +-
 arch/powerpc/platforms/powernv/opal-elog.c |  33 ++++++--
 arch/powerpc/platforms/powernv/smp.c       |   2 +-
 arch/sparc/kernel/smp_64.c                 |  65 ++++-----------
 arch/um/kernel/sigio.c                     |   6 +-
 arch/x86/events/amd/ibs.c                  |  53 ++++++++----
 arch/x86/include/asm/msr-index.h           |   1 +
 arch/x86/kernel/kexec-bzimage64.c          |   3 +-
 drivers/acpi/acpi_dbg.c                    |   3 +
 drivers/acpi/acpi_extlog.c                 |   6 +-
 drivers/acpi/nfit/core.c                   |   2 +-
 drivers/acpi/video_detect.c                |   9 ++
 drivers/ata/sata_rcar.c                    |   2 +-
 drivers/base/core.c                        |   4 +-
 drivers/clk/ti/clockdomain.c               |   2 +
 drivers/cpufreq/acpi-cpufreq.c             |   3 +-
 drivers/cpufreq/sti-cpufreq.c              |   6 +-
 drivers/dma/dma-jz4780.c                   |   7 +-
 drivers/iio/adc/ti-adc12138.c              |  13 ++-
 drivers/iio/gyro/itg3200_buffer.c          |  15 +++-
 drivers/iio/light/si1145.c                 |  19 +++--
 drivers/input/serio/hil_mlc.c              |  21 ++++-
 drivers/input/serio/hp_sdc_mlc.c           |   8 +-
 drivers/leds/leds-bcm6328.c                |   2 +-
 drivers/leds/leds-bcm6358.c                |   2 +-
 drivers/md/bitmap.c                        |   2 +-
 drivers/md/raid5.c                         |   4 +-
 drivers/media/pci/tw5864/tw5864-video.c    |   6 ++
 drivers/memory/emif.c                      |  33 ++------
 drivers/message/fusion/mptscsih.c          |  13 +--
 drivers/mmc/host/via-sdmmc.c               |   3 +
 drivers/mtd/ubi/wl.c                       |  13 +++
 drivers/net/ethernet/freescale/gianfar.c   |  14 +---
 drivers/net/ethernet/mellanox/mlxsw/core.c |   3 +
 drivers/net/ethernet/renesas/ravb_main.c   |  10 ++-
 drivers/net/wan/hdlc_fr.c                  |  98 +++++++++++-----------
 drivers/net/wireless/ath/ath10k/htt_rx.c   |   8 +-
 drivers/net/wireless/intersil/p54/p54pci.c |   4 +-
 drivers/of/of_reserved_mem.c               |  13 ++-
 drivers/power/supply/test_power.c          |   6 ++
 drivers/rtc/rtc-rx8010.c                   |  24 ++++--
 drivers/scsi/scsi_scan.c                   |   7 +-
 drivers/staging/comedi/drivers/cb_pcidas.c |   1 +
 drivers/staging/fsl-mc/bus/mc-io.c         |   7 +-
 drivers/staging/octeon/ethernet-mdio.c     |   6 --
 drivers/staging/octeon/ethernet-rx.c       |  34 ++++----
 drivers/staging/octeon/ethernet.c          |   9 ++
 drivers/tty/serial/8250/8250_mtk.c         |   2 +-
 drivers/tty/serial/serial_txx9.c           |   3 +
 drivers/tty/vt/keyboard.c                  |  39 +++++----
 drivers/tty/vt/vt.c                        |  24 +-----
 drivers/tty/vt/vt_ioctl.c                  |  32 ++++----
 drivers/usb/core/quirks.c                  |   3 +
 drivers/usb/dwc3/core.c                    |  15 +++-
 drivers/usb/host/fsl-mph-dr-of.c           |   9 +-
 drivers/usb/misc/adutux.c                  |   1 +
 drivers/usb/serial/cyberjack.c             |   7 +-
 drivers/usb/serial/option.c                |   8 ++
 drivers/vhost/vringh.c                     |   9 +-
 drivers/video/fbdev/pvr2fb.c               |   2 +
 drivers/w1/masters/mxc_w1.c                |  14 ++--
 drivers/watchdog/rdc321x_wdt.c             |   5 +-
 drivers/xen/events/events_base.c           |  29 +++++--
 fs/9p/vfs_file.c                           |   4 +-
 fs/btrfs/ctree.c                           |   6 ++
 fs/btrfs/reada.c                           |   2 +
 fs/btrfs/tree-log.c                        |   8 ++
 fs/buffer.c                                |  16 ----
 fs/cachefiles/rdwr.c                       |   3 +-
 fs/ceph/addr.c                             |   2 +-
 fs/crypto/policy.c                         |  39 +++++----
 fs/efivarfs/super.c                        |   3 +
 fs/ext4/ext4.h                             |   4 +-
 fs/ext4/ioctl.c                            |  34 ++------
 fs/ext4/namei.c                            |   6 +-
 fs/ext4/super.c                            |   5 ++
 fs/f2fs/checkpoint.c                       |   8 +-
 fs/f2fs/f2fs.h                             |   4 +-
 fs/f2fs/file.c                             |  19 +----
 fs/f2fs/namei.c                            |   6 +-
 fs/fuse/dev.c                              |  28 ++++---
 fs/gfs2/ops_fstype.c                       |  18 ++--
 fs/nfs/namespace.c                         |  12 ++-
 fs/ubifs/debug.c                           |   1 +
 fs/xfs/xfs_rtalloc.c                       |  10 ++-
 include/linux/fscrypto.h                   |  12 +--
 include/linux/hil_mlc.h                    |   2 +-
 include/linux/mtd/pfow.h                   |   2 +-
 init/Kconfig                               |   3 +-
 kernel/debug/debug_core.c                  |  22 +++--
 kernel/fork.c                              |  10 +--
 kernel/kthread.c                           |   3 +-
 kernel/trace/ring_buffer.c                 |   8 +-
 kernel/trace/trace.c                       |   2 +-
 kernel/trace/trace.h                       |  26 +++++-
 kernel/trace/trace_selftest.c              |   9 +-
 lib/fonts/font_10x18.c                     |   2 +-
 lib/fonts/font_6x10.c                      |   2 +-
 lib/fonts/font_6x11.c                      |   2 +-
 lib/fonts/font_7x14.c                      |   2 +-
 lib/fonts/font_8x16.c                      |   2 +-
 lib/fonts/font_8x8.c                       |   2 +-
 lib/fonts/font_acorn_8x8.c                 |   2 +-
 lib/fonts/font_mini_4x6.c                  |   2 +-
 lib/fonts/font_pearl_8x8.c                 |   2 +-
 lib/fonts/font_sun12x22.c                  |   2 +-
 lib/fonts/font_sun8x16.c                   |   2 +-
 net/9p/trans_fd.c                          |   2 +-
 net/ceph/messenger.c                       |   5 ++
 net/sunrpc/clnt.c                          |   8 ++
 net/tipc/core.c                            |   5 ++
 net/tipc/msg.c                             |   5 +-
 net/vmw_vsock/af_vsock.c                   |   2 +-
 scripts/setlocalversion                    |  21 +++--
 sound/usb/pcm.c                            |   1 +
 130 files changed, 894 insertions(+), 650 deletions(-)


