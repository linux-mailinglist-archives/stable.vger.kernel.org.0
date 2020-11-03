Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314692A510D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgKCUhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729718AbgKCUhc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:37:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D52ED22226;
        Tue,  3 Nov 2020 20:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435848;
        bh=qR6v2NrXhrcJHtHTOgGpf7jOg91gE6epMkrSrAe86Mw=;
        h=From:To:Cc:Subject:Date:From;
        b=kvd6tuZGyHwMQAAmYMvbQAzLfVYO0DQ/wfzWOu6CcbQy/WEGK7WjwEmhjiSALxwqy
         cLCsyOf/ZrSbIpVnJUA8zjPZt9z9CJWoFR4BZOOoejYQQ9jG6IBszDlTYknGLIT35y
         bt7JIVFpMCRo0Q+naEjwX0cXLvzLso5cSXvupwO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 000/391] 5.9.4-rc1 review
Date:   Tue,  3 Nov 2020 21:30:51 +0100
Message-Id: <20201103203348.153465465@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.4-rc1
X-KernelTest-Deadline: 2020-11-05T20:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.9.4 release.
There are 391 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.4-rc1

Stephen Boyd <swboyd@chromium.org>
    KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED

Quanyang Wang <quanyang.wang@windriver.com>
    time/sched_clock: Mark sched_clock_read_begin/retry() as notrace

Zeng Tao <prime.zeng@hisilicon.com>
    time: Prevent undefined behaviour in timespec64_to_ns()

Jing Xiangfeng <jingxiangfeng@huawei.com>
    vdpa/mlx5: Fix error return in map_direct_mr()

Dan Carpenter <dan.carpenter@oracle.com>
    vhost_vdpa: Return -EFAULT if copy_from_user() fails

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: schedutil: Always call driver if CPUFREQ_NEED_UPDATE_LIMITS is set

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Introduce cpufreq_driver_test_flags()

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    staging: octeon: Drop on uncorrectable alignment or FCS error

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    staging: octeon: repair "fixed-link" support

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice

Jing Xiangfeng <jingxiangfeng@huawei.com>
    staging: fieldbus: anybuss: jump to correct label in an error path

Zong Li <zong.li@sifive.com>
    stop_machine, rcu: Mark functions as notrace

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and DBGVCR

Takashi Iwai <tiwai@suse.de>
    KVM: x86: Fix NULL dereference at kvm_msr_ignored_check()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Don't clear secondary pointer for shared primary firmware node

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Keep secondary firmware node secondary by type

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: cti: Initialize dynamic sysfs attributes

Kanchan Joshi <joshi.k@samsung.com>
    null_blk: synchronization fix for zoned device

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: espressobin: Add ethernet switch aliases

Fangrui Song <maskray@google.com>
    arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: s3c24xx: fix missing system reset

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: samsung: fix PM debug build with DEBUG_LL but !MMU

Joel Stanley <joel@jms.id.au>
    ARM: config: aspeed: Fix selection of media drivers

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: fix pinctrl property of "vibrator-en" regulator in Aries

Joel Stanley <joel@jms.id.au>
    ARM: aspeed: g5: Do not set sirq polarity

Frank Wunderlich <frank-w@public-files.de>
    arm: dts: mt7623: add missing pause for switchport

Helge Deller <deller@gmx.de>
    hil/parisc: Disable HIL driver when it gets stuck

Matthew Wilcox (Oracle) <willy@infradead.org>
    cachefiles: Handle readpage error correctly

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    arm64: berlin: Select DW_APB_TIMER_OF

Linus Torvalds <torvalds@linux-foundation.org>
    tty: make FONTX ioctl use the tty pointer they were actually passed

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: correct the cu and rb info for sienna cichlid

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amd/psp: Fix sysfs: cannot create duplicate filename

Kevin Wang <kevin1.wang@amd.com>
    drm/amd/swsmu: add missing feature map for sienna_cichlid

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: fix pp_dpm_fclk

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: increase mclk switch threshold to 200 us

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/swsmu: drop smu i2c bus on navi1x

Andrei Vagin <avagin@gmail.com>
    futex: Adjust absolute futex timeouts with per time namespace offset

Alex Dewar <alex.dewar90@gmail.com>
    memory: brcmstb_dpfe: Fix memory leak

Thierry Reding <treding@nvidia.com>
    memory: tegra: Remove GPU from DRM IOMMU group

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    mmc: sdhci: Use Auto CMD Auto Select only when v4_mode is true

Michael Walle <michael@walle.cc>
    mmc: sdhci-of-esdhc: set timeout to max before tuning

Yangbo Lu <yangbo.lu@nxp.com>
    mmc: sdhci-of-esdhc: make sure delay chain locked for HS400

Dave Airlie <airlied@redhat.com>
    drm/ttm: fix eviction valuable range check.

yangerkun <yangerkun@huawei.com>
    ext4: do not use extent after put_bh

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: fix bs < ps issue reported with dioread_nolock mount opt

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    ext4: fix bdev write error check failed when mount fs with ro

zhangyi (F) <yi.zhang@huawei.com>
    ext4: clear buffer verified flag if read meta block from disk

Constantine Sapuntzakis <costa@purestorage.com>
    ext4: fix superblock checksum calculation race

Luo Meng <luomeng12@huawei.com>
    ext4: fix invalid inode checksum

Ritesh Harjani <riteshh@linux.ibm.com>
    ext4: implement swap_activate aops using iomap

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ext4: fix error handling code in add_new_gdb

Eric Biggers <ebiggers@google.com>
    ext4: fix leaking sysfs kobject after failed mount

Stefano Garzarella <sgarzare@redhat.com>
    vringh: fix __vringh_iov() when riov and wiov are different

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Avoid missing HWP max updates in passive mode

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Introduce CPUFREQ_NEED_UPDATE_LIMITS driver flag

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid configuring old governors as default with intel_pstate

Chen Yu <yu.c.chen@intel.com>
    intel_idle: Fix max_cstate for processor models without C-state tables

Mel Gorman <mgorman@techsingularity.net>
    intel_idle: Ignore _CST if control cannot be taken from the platform

Qiujun Huang <hqjagain@gmail.com>
    ring-buffer: Return 0 on success from ring_buffer_resize()

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Make sure PCIe is reset before init for rev 2.1.0

Artur Molchanov <arturmolchanov@gmail.com>
    net/sunrpc: Fix return value for sysctl sunrpc.transports

Matthew Wilcox (Oracle) <willy@infradead.org>
    9P: Cast to loff_t before multiplying

Ilya Dryomov <idryomov@gmail.com>
    libceph: clear con->out_msg on Policy::stateful_server faults

Matthew Wilcox (Oracle) <willy@infradead.org>
    ceph: promote to unsigned long long before shifting

Takashi Iwai <tiwai@suse.de>
    drm/amd/display: Fix kernel panic by dal_gpio_open() error

Takashi Iwai <tiwai@suse.de>
    drm/amd/display: Don't invoke kgdb_breakpoint() unconditionally

Christian König <christian.koenig@amd.com>
    drm/amdgpu: increase the reserved VM size to 2MB

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: add function to program pbb mode for sienna cichlid

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amd/display: Avoid MST manager resource leak.

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Use same SQ prefetch setting as amdgpu

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: correct the gpu reset handling for job != NULL case

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: update golden setting for sienna_cichlid

Veerabadhran G <vegopala@amd.com>
    drm/amdgpu: vcn and jpeg ring synchronization

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Increase timeout for DP Disable

David Galiffi <David.Galiffi@amd.com>
    drm/amd/display: Fix incorrect backlight register offset for DCN

Madhav Chauhan <madhav.chauhan@amd.com>
    drm/amdgpu: don't map BO in reserved region

Krzysztof Kozlowski <krzk@kernel.org>
    i2c: imx: Fix external abort on interrupt in exit paths

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    rtc: rx8010: don't modify the global rtc ops

Krzysztof Kozlowski <krzk@kernel.org>
    ia64: fix build error with !COREDUMP

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: check kthread_should_stop() after the setting of task state

Vineet Gupta <vgupta@synopsys.com>
    ARC: perf: redo the pct irq missing in device-tree handling

Jiri Olsa <jolsa@kernel.org>
    perf python scripting: Fix printable strings in python3 scripts

Kim Phillips <kim.phillips@amd.com>
    perf vendor events amd: Add L2 Prefetch events for zen1

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: mount_ubifs: Release authentication resource in error handling path

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Don't parse authentication mount options in remount process

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix a memleak after dumping authentication mount options

Richard Weinberger <richard@nod.at>
    ubifs: journal: Make sure to not dirty twice for auth nodes

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: xattr: Fix some potential memory leaks while iterating entries

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: dent: Fix some potential memory leaks while iterating entries

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add missing NFSv2 .pc_func methods

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2: support EXCHGID4_FLAG_SUPP_FENCE_OPS 4.2 EXCHANGE_ID flag

Benjamin Coddington <bcodding@redhat.com>
    NFSv4: Wait for stateid updates after CLOSE/OPEN_DOWNGRADE

Bob Peterson <rpeterso@redhat.com>
    gfs2: Only access gl_delete for iopen glocks

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Make sure we don't miss any delayed withdraws

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: Fixup coredump debugfs disable request

Jens Axboe <axboe@kernel.dk>
    io_uring: use type appropriate io_kiocb handler for double poll

Naohiro Aota <naohiro.aota@wdc.com>
    block: advance iov_iter on bio_add_hw_page failure

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix vmap stack - Properly set r1 before activating MMU

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix vmap stack - Do not activate MMU before reading task struct

Michael Neuling <mikey@neuling.org>
    powerpc: Fix undetected data corruption with P9N DD2.1 VSX CI load emulation

Ganesh Goudar <ganeshgr@linux.ibm.com>
    powerpc/mce: Avoid nmi_enter/exit in real mode on pseries hash

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/powermac: Fix low_sleep_handler with KUAP and KUEP

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc/powernv/elog: Fix race while processing OPAL error log event.

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/memhotplug: Make lmb size 64bit

Joel Stanley <joel@jms.id.au>
    powerpc: Warn about use of smt_snooze_delay

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc/rtas: Restrict RTAS requests from userspace

Sven Schnelle <svens@linux.ibm.com>
    s390/stp: add locking to sysfs functions

Paul Cercueil <paul@crapouillou.net>
    MIPS: configs: lb60: Fix defconfig not selecting correct board

Maciej W. Rozycki <macro@linux-mips.org>
    MIPS: DEC: Restore bootmem reservation for firmware working memory area

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Enclose task-list scan in rcu_read_lock()

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Fix low-probability task_struct leak

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Fix grace-period/unlock race in RCU Tasks Trace

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/drmem: Make lmb_size 64 bit

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:st_lsm6dsx Fix alignment and data leak issues

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc12138 Fix alignment issue with timestamp

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc0832 Fix alignment issue with timestamp

Nuno Sá <nuno.sa@analog.com>
    iio: ad7292: Fix of_node refcounting

Tobias Jordan <kernel@cdqe.de>
    iio: adc: gyroadc: fix leak of device node iterator

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:si1145: Fix timestamp alignment and prevent data leak.

Tom Rix <trix@redhat.com>
    iio:imu:st_lsm6dsx: check st_lsm6dsx_shub_read_output return

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:inv_mpu6050 Fix dma and ts alignment and data leak issues.

Eugen Hristev <eugen.hristev@microchip.com>
    iio: adc: at91-sama5d2_adc: fix DMA conversion crash

Nuno Sá <nuno.sa@analog.com>
    iio: ltc2983: Fix of_node refcounting

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/shme-helpers: Fix dma_buf_mmap forwarding bug

Laurent Vivier <lvivier@redhat.com>
    vdpa_sim: Fix DMA mask

Paul Cercueil <paul@crapouillou.net>
    dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status

Jan Kara <jack@suse.cz>
    udf: Fix memory leak when mounting

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Fix random segfault when freeing hugetlb range

Michael S. Tsirkin <mst@redhat.com>
    Revert "vhost-vdpa: fix page pinning leakage in error path"

Gaurav Kohli <gkohli@codeaurora.org>
    tracing: Fix race in trace_open and buffer resize call

Vladimir Oltean <vladimir.oltean@nxp.com>
    tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like LS1028A

Russell King <rmk+kernel@armlinux.org.uk>
    tty: serial: 21285: fix lockup on open

Borislav Petkov <bp@suse.de>
    x86/mce: Allow for copy_mc_fragile symbol checksum to be generated

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Avoid entering wacom_wac_pen_report for pad / battery

Jiri Slaby <jirislaby@kernel.org>
    vt_ioctl: fix GIO_UNIMAP regression

Jiri Slaby <jirislaby@kernel.org>
    vt: keyboard, extend func_buf_lock to readers

Jiri Slaby <jirislaby@kernel.org>
    vt: keyboard, simplify vt_kdgkbsent

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Force VT'd workarounds when running as a guest OS

Bastien Nocera <hadess@hadess.net>
    USB: apple-mfi-fastcharge: don't probe unhandled devices

Bastien Nocera <hadess@hadess.net>
    usbcore: Check both id_table and match() when both available

Ran Wang <ran.wang_1@nxp.com>
    usb: host: fsl-mph-dr-of: check return of dma_set_mask()

Li Jun <jun.li@nxp.com>
    usb: typec: tcpm: reset hard_reset_count for any disconnect

Jerome Brunet <jbrunet@baylibre.com>
    usb: cdc-acm: fix cooldown mechanism

Pawel Laszczak <pawell@cadence.com>
    usb: cdns3: Fix on-chip memory overflow issue

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Resume pending requests after CLEAR_STALL

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: don't trigger runtime pm when remove driver

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: add phy cleanup for probe error handling

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Reclaim extra TRBs after request completion

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Check MPS of the request length

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Fix ZLP for OUT ep0 requests

Raymond Tan <raymond.tan@intel.com>
    usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method for PM functionality

Sandeep Singh <sandeep.singh@amd.com>
    usb: xhci: Workaround for S3 issue on AMD SNPS 3.0 xHC

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop the path before adding block group sysfs files

Filipe Manana <fdmanana@suse.com>
    btrfs: fix readahead hang and use-after-free after removing a device

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free on readahead extent after failure to create it

Daniel Xu <dxu@dxuuu.xyz>
    btrfs: tree-checker: validate number of chunk stripes and parity

Anand Jain <anand.jain@oracle.com>
    btrfs: skip devices without magic signature when mounting

Josef Bacik <josef@toxicpanda.com>
    btrfs: cleanup cow block on error

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: reschedule when cloning lots of extents

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: fix false alert caused by legacy btrfs root item

Denis Efremov <efremov@linux.com>
    btrfs: use kvzalloc() to allocate clone_roots in btrfs_ioctl_send()

Filipe Manana <fdmanana@suse.com>
    btrfs: send, recompute reference path after orphanization of a directory

Filipe Manana <fdmanana@suse.com>
    btrfs: send, orphanize first all conflicting inodes when processing references

Filipe Manana <fdmanana@suse.com>
    btrfs: reschedule if necessary when logging directory items

Qu Wenruo <wqu@suse.com>
    btrfs: tracepoints: output proper root owner for trace_find_free_extent()

Josef Bacik <josef@toxicpanda.com>
    btrfs: sysfs: init devices outside of the chunk_mutex

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: fix qgroup meta rsv leak for subvolume operations

Anand Jain <anand.jain@oracle.com>
    btrfs: improve device scanning messages

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: fix wrong qgroup metadata reserve for delayed inode

Xiang Chen <chenxiang66@hisilicon.com>
    PM: runtime: Remove link state checks in rpm_get/put_supplier()

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix crash on session cleanup with unload

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix reset of MPI firmware

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix MPI reset needed message

Helge Deller <deller@gmx.de>
    scsi: mptfusion: Fix null pointer dereferences in mptscsih_remove()

Kees Cook <keescook@chromium.org>
    fs/kernel_read_file: Remove FIRMWARE_PREALLOC_BUFFER enum

Martin Fuzzey <martin.fuzzey@flowbird.group>
    w1: mxc_w1: Fix timeout resolution problem leading to bus error

Jens Axboe <axboe@kernel.dk>
    io-wq: assign NUMA node locality if appropriate

Wei Huang <wei.huang2@amd.com>
    acpi-cpufreq: Honor _PSD table setting on new AMD CPUs

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: PM: Drop ec_no_wakeup check from acpi_ec_dispatch_gpe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: PM: Flush EC work unconditionally after wakeup

Lukas Wunner <lukas@wunner.de>
    PCI/ACPI: Whitelist hotplug ports for D3 if power managed by ACPI

Jamie Iles <jamie@nuviainc.com>
    ACPI: debug: don't allow debugging when ACPI is disabled

Alex Hung <alex.hung@canonical.com>
    ACPI: video: use ACPI backlight for HP 635 Notebook

Ben Hutchings <ben@decadent.org.uk>
    ACPI / extlog: Check for RDMSR failure

dmitry.torokhov@gmail.com <dmitry.torokhov@gmail.com>
    ACPI: button: fix handling lid state changes when input device closed

Ashish Sangwan <ashishsangwan2@gmail.com>
    NFS: fix nfs_path in case of a rename retry

Hanjun Guo <guohanjun@huawei.com>
    ACPI: configfs: Add missing config_item_put() to fix refcount leak

Jan Kara <jack@suse.cz>
    fs: Don't invalidate page buffers in block_write_full_page()

Hans de Goede <hdegoede@redhat.com>
    media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not having any effect

Steve Foreman <foremans@google.com>
    hwmon: (pmbus/max34440) Fix OC fault limits

Marek Behún <marek.behun@nic.cz>
    leds: bcm6328, bcm6358: use devres LED registering function

Krzysztof Kozlowski <krzk@kernel.org>
    extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips

Krzysztof Kozlowski <krzk@kernel.org>
    spi: sprd: Release DMA channel also on probe deferral

Chuanhong Guo <gch981213@gmail.com>
    spi: spi-mtk-nor: fix timeout calculation overflow

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Fix raw sample data accumulation

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Don't include randomized bits in get_ibs_op_count()

Kim Phillips <kim.phillips@amd.com>
    perf/amd/uncore: Set all slices and threads to restore perf stat -a behaviour

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd: Fix sampling Large Increment per Cycle events

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix Ice Lake event constraint table

Andy Lutomirski <luto@kernel.org>
    selftests/x86/fsgsbase: Test PTRACE_PEEKUSER for GSBASE with invalid LDT GS

Jann Horn <jannh@google.com>
    seccomp: Make duplicate listener detection non-racy

Bharata B Rao <bharata@linux.ibm.com>
    mm: memcg/slab: uncharge during kmem_cache_free_bulk()

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci-acpi: AMDI0040: Set SDHCI_QUIRK2_PRESET_VALUE_BROKEN

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Add LTR support for some Intel BYT based controllers

Song Liu <songliubraving@fb.com>
    md/raid5: fix oops during stripe resizing

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: fix the checking of wrong work queue

Huacai Chen <chenhc@lemote.com>
    irqchip/loongson-htvec: Fix initial interrupt clearing

Nick Desaulniers <ndesaulniers@google.com>
    vmlinux.lds.h: Add PGO and AutoFDO input sections

Chao Leng <lengchao@huawei.com>
    nvme-rdma: fix crash when connect rejected

Douglas Gilbert <dgilbert@interlog.com>
    sgl_alloc_order: fix memory leak

Xiubo Li <xiubli@redhat.com>
    nbd: make the config put is called before the notifying the waiter

Konrad Dybcio <konradybcio@gmail.com>
    arm64: dts: qcom: kitakami: Temporarily disable SDHCI1

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Move scmi bus init and exit calls into the driver

Grygorii Strashko <grygorii.strashko@ti.com>
    bindings: soc: ti: soc: ringacc: remove ti,dma-ring-reset-quirk

Grygorii Strashko <grygorii.strashko@ti.com>
    soc: ti: k3: ringacc: add am65x sr2.0 support

Stephen Boyd <swboyd@chromium.org>
    soc: qcom: rpmh-rsc: Sleep waiting for tcs slots to be free

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: align SPI GPIO node name with dtschema in Aries

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: add RTC 32 KHz clock in Aries family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: remove dedicated 'audio-subsystem' node

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: move PMU node out of clock controller

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: move fixed clocks under root node

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: remove DMA controller bus node name to fix dtschema warnings

Jonathan Bakker <xc-racer2@live.ca>
    ARM: dts: s5pv210: Enable audio on Aries boards

Dan Carpenter <dan.carpenter@oracle.com>
    memory: emif: Remove bogus debugfs error handling

Tony Lindgren <tony@atomide.com>
    ARM: dts: omap4: Fix sgx clock rate for 4430

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    arm64: dts: renesas: ulcb: add full-pwr-cycle-in-suspend into eMMC nodes

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: handle -EINTR in cifs_setattr

Rohith Surabattula <rohiths@microsoft.com>
    Handle STATUS_IO_TIMEOUT gracefully

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    gfs2: add validation checks for size of superblock

Jamie Iles <jamie@nuviainc.com>
    gfs2: use-after-free in sysfs deregistration

Andrew Price <anprice@redhat.com>
    gfs2: Fix NULL pointer dereference in gfs2_rgrp_dump

Bob Peterson <rpeterso@redhat.com>
    gfs2: call truncate_inode_pages_final for address space glocks

Christoph Hellwig <hch@lst.de>
    scsi: core: Clean up allocation and freeing of sgtables

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Book3S HV: Do not allocate HPT for a nested guest

Jan Kara <jack@suse.cz>
    ext4: Detect already used quota file early

changfengnan <fengnanchang@foxmail.com>
    jbd2: avoid transaction reuse after reformatting

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    drivers: watchdog: rdc321x_wdt: Fix race condition bugs

Yan, Zheng <zyan@redhat.com>
    ceph: encode inodes' parent/d_name in cap reconnect message

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid

J. Bruce Fields <bfields@redhat.com>
    nfsd4: remove check_conflicting_opens warning

Hou Tao <houtao1@huawei.com>
    nfsd: rename delegation related tracepoints to make them less confusing

Tero Kristo <t-kristo@ti.com>
    clk: ti: clockdomain: fix static checker warning

Tuan Phan <tuanphan@os.amperecomputing.com>
    PCI/ACPI: Add Ampere Altra SOC MCFG quirk

Chris Lew <clew@codeaurora.org>
    rpmsg: glink: Use complete_all for open states

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Log unknown link speed appropriately.

Chao Yu <chao@kernel.org>
    f2fs: fix to set SBI_NEED_FSCK flag for inconsistent inode

Zhao Heming <heming.zhao@suse.com>
    md/bitmap: md_bitmap_get_counter returns wrong blocks

Anand Jain <anand.jain@oracle.com>
    btrfs: fix replace of seed device

Gabriel Krisman Bertazi <krisman@collabora.com>
    block: Consider only dispatched requests for inflight statistic

Zhen Lei <thunder.leizhen@huawei.com>
    ARC: [dts] fix the errors detected by dtbs_check

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Avoid set zero in the requested clk

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: HDMI remote sink need mode validation for Linux

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    power: supply: test_power: add missing newlines when printing parameters by sysfs

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    ACPI: HMAT: Fix handling of changes from ACPI 6.2 to ACPI 6.3

Diana Craciun <diana.craciun@oss.nxp.com>
    bus/fsl_mc: Do not rely on caller to provide non NULL mc_io

Bhaumik Bhatt <bbhatt@codeaurora.org>
    bus: mhi: core: Abort suspends due to outgoing pending packets

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: do not queue work if dr_mode is not USB_DR_MODE_OTG

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values

Wen Gong <wgong@codeaurora.org>
    ath11k: change to disable softirqs for ath11k_regd_update to solve deadlock

Carl Huang <cjhuang@codeaurora.org>
    ath11k: fix warning caused by lockdep_assert_held

Wen Gong <wgong@codeaurora.org>
    ath11k: Use GFP_ATOMIC instead of GFP_KERNEL in ath11k_dp_htt_get_ppdu_desc

Wright Feng <wright.feng@cypress.com>
    brcmfmac: Fix warning message after dongle setup failed

Stanislaw Kardach <skardach@marvell.com>
    octeontx2-af: fix LD CUSTOM LTYPE aliasing

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    ACPI: Add out of bounds and numa_off protections to pxm_to_node()

Gao Xiang <hsiangkao@redhat.com>
    xfs: avoid LR buffer overrun due to crafted h_len

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't free rt blocks when we're doing a REMAP bunmapi call

farah kassabri <fkassabri@habana.ai>
    habanalabs: remove security from ARB_MST_QUIET register

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: disable clocks during stop mode

Zhengyuan Liu <liuzhengyuan@tj.kylinos.cn>
    arm64/mm: return cpu_all_mask when node is NUMA_NO_NODE

Dmitry Osipenko <digetx@gmail.com>
    cpuidle: tegra: Correctly handle result of arm_cpuidle_simple_enter()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Mitigate cond_resched() in xprt_transmit()

Peter Chen <peter.chen@nxp.com>
    usb: xhci: omit duplicate actions when suspending a runtime suspended host.

Felix Fietkau <nbd@nbd.name>
    mac80211: add missing queue/hash initialization to 802.3 xmit

Luben Tuikov <luben.tuikov@amd.com>
    drm/amdgpu: No sysfs, not an error condition

Linu Cherian <lcherian@marvell.com>
    coresight: Make sysfs functional on topologies with per core sink

Lang Dai <lang.dai@intel.com>
    uio: free uio id after uio file node is freed

Oliver Neukum <oneukum@suse.com>
    USB: adutux: fix debugging

Alain Volmat <avolmat@me.com>
    cpufreq: sti-cpufreq: add stih418 support

Zong Li <zong.li@sifive.com>
    riscv: Define AT_VECTOR_SIZE_ARCH for ARCH_DLINFO

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Check clock table return

Magnus Karlsson <magnus.karlsson@intel.com>
    samples/bpf: Fix possible deadlock in xdpsock

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: access policycaps with READ_ONCE/WRITE_ONCE

Yonghong Song <yhs@fb.com>
    selftests/bpf: Define string const as global for test_sysctl_prog.c

Krzysztof Kozlowski <krzk@kernel.org>
    nfc: s3fwrn5: Add missing CRYPTO_HASH dependency

Daniel W. S. Almeida <dwlsalmeida@gmail.com>
    media: uvcvideo: Fix dereference of out-of-bound list iterator

Marek Szyprowski <m.szyprowski@samsung.com>
    drm: panfrost: fix common struct sg_table related issues

Marek Szyprowski <m.szyprowski@samsung.com>
    drm: lima: fix common struct sg_table related issues

Marek Szyprowski <m.szyprowski@samsung.com>
    xen: gntdev: fix common struct sg_table related issues

Marek Szyprowski <m.szyprowski@samsung.com>
    drm: exynos: fix common struct sg_table related issues

Yonghong Song <yhs@fb.com>
    bpf: Permit map_ptr arithmetic with opcode add and offset 0

Douglas Anderson <dianders@chromium.org>
    kgdb: Make "kgdbcon" work properly with "kgdb_earlycon"

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Make using_hash_mmu() work on Cell & PowerMac

Masami Hiramatsu <mhiramat@kernel.org>
    ia64: kprobes: Use generic kretprobe trampoline handler

John Ogness <john.ogness@linutronix.de>
    printk: reduce LOG_BUF_SHIFT range for H8300

Valentin Schneider <valentin.schneider@arm.com>
    arm64: topology: Stop using MPIDR for topology information

Dmitry Osipenko <digetx@gmail.com>
    brcmfmac: increase F2 watermark for BCM4329

Antonio Borneo <antonio.borneo@st.com>
    drm/bridge/synopsys: dsi: add support for non-continuous HS clock

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    mmc: via-sdmmc: Fix data race bug

Hans Verkuil <hverkuil@xs4all.nl>
    media: imx274: fix frame interval handling

Sidong Yang <realwakka@gmail.com>
    drm/vkms: avoid warning in vkms_get_vblank_timestamp

Tom Rix <trix@redhat.com>
    media: tw5864: check status of tw5864_frameinterval_get

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: During PR_SWAP, source caps should be sent only after tSwapSourceStart

Xia Jiang <xia.jiang@mediatek.com>
    media: platform: Improve queue set up flow for bug fixing

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix potential use before init

Marek Szyprowski <m.szyprowski@samsung.com>
    misc: fastrpc: fix common struct sg_table related issues

Akshu Agrawal <akshu.agrawal@amd.com>
    ASoC: AMD: Clean kernel log from deferred probe error messages

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videodev2.h: RGB BT2020 and HSV are always full range

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    drm/bridge_connector: Set default status connected for eDP connectors

Andy Lutomirski <luto@kernel.org>
    selftests/x86/fsgsbase: Reap a forgotten child

Rander Wang <rander.wang@intel.com>
    ASoC: SOF: fix a runtime pm issue in SOF when HDMI codec doesn't work

Nadezda Lutovinova <lutovinova@ispras.ru>
    drm/brige/megachips: Add checking if ge_b850v3_lvds_init() is working correctly

Luben Tuikov <luben.tuikov@amd.com>
    drm/scheduler: Scheduler priority fixes (v2)

Sathishkumar Muruganandam <murugana@codeaurora.org>
    ath10k: fix VHT NSS calculation when STBC is enabled

Wen Gong <wgong@codeaurora.org>
    ath10k: start recovery process when payload length exceeds max htc length for sdio

Tom Rix <trix@redhat.com>
    video: fbdev: pvr2fb: initialize variables

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: restore ras flags when user resets eeprom(v2)

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Separate DRM driver from PCI code

Arvind Sankar <nivedita@alum.mit.edu>
    x86/kaslr: Initialize mem_limit to the real maximum address

Venkateswara Naralasetty <vnaralas@codeaurora.org>
    ath10k: fix retry packets update in station dump

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't set COMP_LOCKED if won't put

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix realtime bitmap/summary file truncation when growing rt volume

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: change the order in which child and parent defer ops are finished

Krzysztof Kozlowski <krzk@kernel.org>
    power: supply: bq27xxx: report "not charging" on all types

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: log new intent items created as part of finishing recovered intent items

Chandan Babu R <chandanrlinux@gmail.com>
    xfs: Set xfs_buf's b_ops member when zeroing bitmap/summary files

Chandan Babu R <chandanrlinux@gmail.com>
    xfs: Set xfs_buf type flag when growing summary/bitmap files

Dave Wysochanski <dwysocha@redhat.com>
    NFS4: Fix oops when copy_file_range is attempted with NFS4.0 source

Douglas Anderson <dianders@chromium.org>
    ARM: 8997/2: hw_breakpoint: Handle inexact watchpoint addresses

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: handle ISA v3.1 local copy-paste context switches

David Howells <dhowells@redhat.com>
    afs: Don't assert on unpurgeable server records

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: handle errors of f2fs_get_meta_page_nofail

Johannes Berg <johannes.berg@intel.com>
    um: change sigio_spinlock to a mutex

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap/zcrypt: revisit ap and zcrypt error handling

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to disallow enabling compress on non-empty file

Vasily Gorbik <gor@linux.ibm.com>
    s390/startup: avoid save_area_sync overflow

Chao Yu <chao@kernel.org>
    f2fs: fix to check segment boundary during SIT page readahead

Chao Yu <chao@kernel.org>
    f2fs: fix uninit-value in f2fs_lookup

Chao Yu <chao@kernel.org>
    f2fs: do sanity check on zoned block device path

Zhang Qilong <zhangqilong3@huawei.com>
    f2fs: add trace exit in exception path

Nicholas Piggin <npiggin@gmail.com>
    sparc64: remove mm_cpumask clearing to fix kthread_use_mm race

Nicholas Piggin <npiggin@gmail.com>
    powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM

Nicholas Piggin <npiggin@gmail.com>
    mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/watchpoint/ptrace: Fix SETHWDEBUG when CONFIG_HAVE_HW_BREAKPOINT=N

Chao Yu <chao@kernel.org>
    f2fs: allocate proper size memory for zstd decompress

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/core: Change how failing destroy is handled during uobj abort

Oliver O'Halloran <oohall@gmail.com>
    powerpc/powernv/smp: Fix spurious DBG() warning

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/vmemmap: Fix memory leak with vmemmap list allocation failures.

Mateusz Nosek <mateusznosek0@gmail.com>
    futex: Fix incorrect should_fail_futex() handling

Tang Bin <tangbin@cmss.chinamobile.com>
    usb: host: ehci-tegra: Fix error handling in tegra_ehci_probe()

Peter Zijlstra <peterz@infradead.org>
    lockdep: Fix preemption WARN for spurious IRQ-enable

Georgi Djakov <georgi.djakov@linaro.org>
    interconnect: qcom: sdm845: Enable keepalive for the MM1 BCM

Laurent Vivier <lvivier@redhat.com>
    vdpasim: fix MAC address configuration

David Howells <dhowells@redhat.com>
    afs: Fix dirty-region encoding on ppc32 with 64K pages

David Howells <dhowells@redhat.com>
    afs: Fix afs_invalidatepage to adjust the dirty region

David Howells <dhowells@redhat.com>
    afs: Alter dirty range encoding in page->private

David Howells <dhowells@redhat.com>
    afs: Wrap page->private manipulations in inline functions

David Howells <dhowells@redhat.com>
    afs: Fix where page->private is set during write

David Howells <dhowells@redhat.com>
    afs: Fix page leak on afs_write_begin() failure

David Howells <dhowells@redhat.com>
    afs: Fix to take ref on page when PG_private is set

Ard Biesheuvel <ardb@kernel.org>
    arm64: efi: increase EFI PE/COFF header padding to 64 KB

Sascha Hauer <s.hauer@pengutronix.de>
    ata: sata_nv: Fix retrieving of active qcs

Alok Prasad <palok@marvell.com>
    RDMA/qedr: Fix memory leak in iWARP CM

David Howells <dhowells@redhat.com>
    afs: Fix afs_launder_page to not clear PG_writeback

Dan Carpenter <dan.carpenter@oracle.com>
    afs: Fix a use after free in afs_xattr_get_acl()

Sasha Levin <sashal@kernel.org>
    tracing, synthetic events: Replace buggy strcat() with seq_buf operations

Amit Cohen <amcohen@nvidia.com>
    mlxsw: core: Fix use-after-free in mlxsw_emad_trans_finish()

Parav Pandit <parav@nvidia.com>
    RDMA/mlx5: Fix devlink deadlock on net namespace deletion

Sasha Levin <sashal@kernel.org>
    ionic: no rx flush in deinit

Juergen Gross <jgross@suse.com>
    x86/alternative: Don't call text_poke() in lazy TLB mode

Florian Fainelli <f.fainelli@gmail.com>
    firmware: arm_scmi: Fix duplicate workqueue name

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix locking in notifications

Jiri Slaby <jirislaby@kernel.org>
    x86/unwind/orc: Fix inactive tasks with stack pointer in %sp on GCC 10 compiled kernels

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Add missing Rx size re-initialisation

Sumit Garg <sumit.garg@linaro.org>
    tee: client UUID: Skip REE kernel login method as well

Etienne Carriere <etienne.carriere@linaro.org>
    firmware: arm_scmi: Expand SMC/HVC message pool to more than one

Etienne Carriere <etienne.carriere@linaro.org>
    firmware: arm_scmi: Fix ARCH_COLD_RESET

Juergen Gross <jgross@suse.com>
    xen/events: block rogue events for some time

Juergen Gross <jgross@suse.com>
    xen/events: defer eoi in case of excessive number of events

Juergen Gross <jgross@suse.com>
    xen/events: use a common cpu hotplug hook for event channels

Juergen Gross <jgross@suse.com>
    xen/events: switch user event channels to lateeoi model

Juergen Gross <jgross@suse.com>
    xen/pciback: use lateeoi irq binding

Juergen Gross <jgross@suse.com>
    xen/pvcallsback: use lateeoi irq binding

Juergen Gross <jgross@suse.com>
    xen/scsiback: use lateeoi irq binding

Juergen Gross <jgross@suse.com>
    xen/netback: use lateeoi irq binding

Juergen Gross <jgross@suse.com>
    xen/blkback: use lateeoi irq binding

Juergen Gross <jgross@suse.com>
    xen/events: add a new "late EOI" evtchn framework

Juergen Gross <jgross@suse.com>
    xen/events: fix race in evtchn_fifo_unmask()

Juergen Gross <jgross@suse.com>
    xen/events: add a proper barrier to 2-level uevent unmasking

Juergen Gross <jgross@suse.com>
    xen/events: avoid removing an event channel while handling it


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   8 +
 .../devicetree/bindings/soc/ti/k3-ringacc.yaml     |   6 -
 .../userspace-api/media/v4l/colorspaces-defs.rst   |   9 +-
 .../media/v4l/colorspaces-details.rst              |   5 +-
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   7 +
 arch/arc/boot/dts/axc001.dtsi                      |   2 +-
 arch/arc/boot/dts/axc003.dtsi                      |   2 +-
 arch/arc/boot/dts/axc003_idu.dtsi                  |   2 +-
 arch/arc/boot/dts/vdk_axc003.dtsi                  |   2 +-
 arch/arc/boot/dts/vdk_axc003_idu.dtsi              |   2 +-
 arch/arc/kernel/perf_event.c                       |  27 +-
 arch/arm/Kconfig                                   |   2 +
 arch/arm/boot/dts/aspeed-g5.dtsi                   |   1 -
 arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts      |   1 +
 arch/arm/boot/dts/omap4.dtsi                       |   2 +-
 arch/arm/boot/dts/omap443x.dtsi                    |  10 +
 arch/arm/boot/dts/s5pv210-aries.dtsi               |  26 +-
 arch/arm/boot/dts/s5pv210-fascinate4g.dts          |  98 +++++
 arch/arm/boot/dts/s5pv210-galaxys.dts              |  85 +++++
 arch/arm/boot/dts/s5pv210.dtsi                     | 163 ++++----
 arch/arm/configs/aspeed_g4_defconfig               |   3 +-
 arch/arm/configs/aspeed_g5_defconfig               |   3 +-
 arch/arm/kernel/hw_breakpoint.c                    | 100 +++--
 arch/arm/plat-samsung/Kconfig                      |   1 +
 arch/arm64/Kconfig.platforms                       |   1 +
 .../marvell/armada-3720-espressobin-v7-emmc.dts    |  10 +-
 .../dts/marvell/armada-3720-espressobin-v7.dts     |  10 +-
 .../boot/dts/marvell/armada-3720-espressobin.dtsi  |  12 +-
 .../dts/qcom/msm8994-sony-xperia-kitakami.dtsi     |   7 +-
 arch/arm64/boot/dts/renesas/ulcb.dtsi              |   1 +
 arch/arm64/include/asm/kvm_host.h                  |   1 +
 arch/arm64/include/asm/numa.h                      |   3 +
 arch/arm64/kernel/efi-header.S                     |   2 +-
 arch/arm64/kernel/topology.c                       |  32 +-
 arch/arm64/kvm/hypercalls.c                        |   2 +-
 arch/arm64/kvm/sys_regs.c                          |   6 +-
 arch/arm64/lib/memcpy.S                            |   3 +-
 arch/arm64/lib/memmove.S                           |   3 +-
 arch/arm64/lib/memset.S                            |   3 +-
 arch/arm64/mm/numa.c                               |   6 +-
 arch/ia64/kernel/Makefile                          |   2 +-
 arch/ia64/kernel/kprobes.c                         |  77 +---
 arch/mips/configs/qi_lb60_defconfig                |   1 +
 arch/mips/dec/setup.c                              |   9 +-
 arch/powerpc/Kconfig                               |  14 +
 arch/powerpc/include/asm/drmem.h                   |   4 +-
 arch/powerpc/include/asm/mmu_context.h             |   2 +-
 arch/powerpc/kernel/head_32.S                      |   8 +-
 arch/powerpc/kernel/head_32.h                      |  72 ++--
 arch/powerpc/kernel/mce.c                          |   7 +-
 arch/powerpc/kernel/process.c                      |  16 +-
 arch/powerpc/kernel/ptrace/ptrace-noadv.c          |   2 +-
 arch/powerpc/kernel/rtas.c                         | 153 ++++++++
 arch/powerpc/kernel/sysfs.c                        |  42 +-
 arch/powerpc/kernel/traps.c                        |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |  13 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   8 +
 arch/powerpc/mm/hugetlbpage.c                      |  18 +-
 arch/powerpc/mm/init_64.c                          |  35 +-
 arch/powerpc/platforms/powermac/sleep.S            |   9 +-
 arch/powerpc/platforms/powernv/opal-elog.c         |  33 +-
 arch/powerpc/platforms/powernv/smp.c               |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  43 ++-
 arch/riscv/include/uapi/asm/auxvec.h               |   3 +
 arch/s390/boot/head.S                              |  21 +-
 arch/s390/kernel/time.c                            | 118 ++++--
 arch/sparc/kernel/smp_64.c                         |  65 +---
 arch/um/kernel/sigio.c                             |   6 +-
 arch/x86/boot/compressed/kaslr.c                   |  41 +-
 arch/x86/events/amd/ibs.c                          |  38 +-
 arch/x86/events/amd/uncore.c                       |  28 +-
 arch/x86/events/core.c                             |   4 +-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/include/asm/asm-prototypes.h              |   1 +
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/kernel/alternative.c                      |   9 +
 arch/x86/kernel/unwind_orc.c                       |   9 +-
 arch/x86/kvm/x86.c                                 |   8 +-
 block/bio.c                                        |  11 +-
 block/blk-mq.c                                     |   2 +-
 drivers/acpi/acpi_configfs.c                       |   1 +
 drivers/acpi/acpi_dbg.c                            |   3 +
 drivers/acpi/acpi_extlog.c                         |   6 +-
 drivers/acpi/button.c                              |  13 +-
 drivers/acpi/ec.c                                  |  10 +-
 drivers/acpi/numa/hmat.c                           |   3 +-
 drivers/acpi/numa/srat.c                           |   2 +-
 drivers/acpi/pci_mcfg.c                            |  20 +
 drivers/acpi/video_detect.c                        |   9 +
 drivers/ata/sata_nv.c                              |   2 +-
 drivers/base/core.c                                |   4 +-
 drivers/base/firmware_loader/main.c                |   5 +-
 drivers/base/power/runtime.c                       |   5 +-
 drivers/block/nbd.c                                |   2 +-
 drivers/block/null_blk.h                           |   1 +
 drivers/block/null_blk_zoned.c                     |  22 +-
 drivers/block/xen-blkback/blkback.c                |  22 +-
 drivers/block/xen-blkback/xenbus.c                 |   5 +-
 drivers/bus/fsl-mc/mc-io.c                         |   7 +-
 drivers/bus/mhi/core/pm.c                          |   6 +-
 drivers/clk/ti/clockdomain.c                       |   2 +
 drivers/cpufreq/Kconfig                            |   2 +
 drivers/cpufreq/acpi-cpufreq.c                     |   3 +-
 drivers/cpufreq/cpufreq.c                          |  15 +-
 drivers/cpufreq/intel_pstate.c                     |  13 +-
 drivers/cpufreq/sti-cpufreq.c                      |   6 +-
 drivers/cpuidle/cpuidle-tegra.c                    |  34 +-
 drivers/dma/dma-jz4780.c                           |   7 +-
 drivers/extcon/extcon-ptn5150.c                    |   8 +-
 drivers/firmware/arm_scmi/base.c                   |   2 +
 drivers/firmware/arm_scmi/bus.c                    |   6 +-
 drivers/firmware/arm_scmi/clock.c                  |   2 +
 drivers/firmware/arm_scmi/common.h                 |   5 +
 drivers/firmware/arm_scmi/driver.c                 |  24 +-
 drivers/firmware/arm_scmi/notify.c                 |  22 +-
 drivers/firmware/arm_scmi/perf.c                   |   2 +
 drivers/firmware/arm_scmi/reset.c                  |   4 +-
 drivers/firmware/arm_scmi/sensors.c                |   2 +
 drivers/firmware/arm_scmi/smc.c                    |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  10 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c          |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  72 ++++
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c             |  24 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |  28 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.h              |   3 +-
 .../drm/amd/amdkfd/kfd_device_queue_manager_v10.c  |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 +
 .../amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.c |   3 +-
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |   7 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   2 +-
 .../gpu/drm/amd/display/dc/dce/dce_panel_cntl.h    |   2 +-
 .../amd/display/dc/dcn10/dcn10_stream_encoder.c    |   4 +-
 drivers/gpu/drm/amd/display/dc/gpio/gpio_base.c    |   4 +-
 drivers/gpu/drm/amd/display/dc/os_types.h          |   2 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   2 +-
 drivers/gpu/drm/amd/powerplay/inc/smu_types.h      |   1 +
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c         |  26 --
 drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c |   6 +
 drivers/gpu/drm/ast/ast_drv.c                      |  59 +--
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |  12 +-
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c      |   9 +-
 drivers/gpu/drm/drm_bridge_connector.c             |   1 +
 drivers/gpu/drm/drm_gem.c                          |   4 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   7 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c            |  10 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   6 +-
 drivers/gpu/drm/lima/lima_gem.c                    |  11 +-
 drivers/gpu/drm/lima/lima_vm.c                     |   5 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |   4 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   7 +-
 drivers/gpu/drm/scheduler/sched_main.c             |   4 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   2 +-
 drivers/gpu/drm/vkms/vkms_crtc.c                   |   5 +
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/hwmon/pmbus/max34440.c                     |  23 ++
 drivers/hwtracing/coresight/coresight-cti-sysfs.c  |   7 +
 drivers/hwtracing/coresight/coresight-priv.h       |   3 +-
 drivers/hwtracing/coresight/coresight.c            |  62 ++-
 drivers/i2c/busses/i2c-imx.c                       |  24 +-
 drivers/idle/intel_idle.c                          |   9 +-
 drivers/iio/adc/ad7292.c                           |   4 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |  16 +-
 drivers/iio/adc/rcar-gyroadc.c                     |  21 +-
 drivers/iio/adc/ti-adc0832.c                       |  11 +-
 drivers/iio/adc/ti-adc12138.c                      |  13 +-
 drivers/iio/gyro/itg3200_buffer.c                  |  15 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          |  12 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c         |  12 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |   6 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |  42 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c       |   2 +
 drivers/iio/light/si1145.c                         |  19 +-
 drivers/iio/temperature/ltc2983.c                  |  19 +-
 drivers/infiniband/core/rdma_core.c                |  30 +-
 drivers/infiniband/hw/mlx5/main.c                  |   6 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |   1 +
 drivers/input/serio/hil_mlc.c                      |  21 +-
 drivers/input/serio/hp_sdc_mlc.c                   |   8 +-
 drivers/interconnect/qcom/sdm845.c                 |   2 +-
 drivers/irqchip/irq-loongson-htvec.c               |   4 +-
 drivers/leds/leds-bcm6328.c                        |   2 +-
 drivers/leds/leds-bcm6358.c                        |   2 +-
 drivers/md/md-bitmap.c                             |   2 +-
 drivers/md/md.c                                    |   2 +-
 drivers/md/raid5.c                                 |   4 +-
 drivers/media/i2c/imx274.c                         |   8 +-
 drivers/media/pci/tw5864/tw5864-video.c            |   6 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |   7 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |  27 +-
 drivers/memory/brcmstb_dpfe.c                      |  16 +-
 drivers/memory/emif.c                              |  33 +-
 drivers/memory/tegra/tegra124.c                    |   1 -
 drivers/message/fusion/mptscsih.c                  |  13 +-
 drivers/misc/fastrpc.c                             |   4 +-
 drivers/misc/habanalabs/gaudi/gaudi_security.c     |  55 +--
 drivers/mmc/host/sdhci-acpi.c                      |  37 ++
 drivers/mmc/host/sdhci-esdhc.h                     |   2 +
 drivers/mmc/host/sdhci-of-esdhc.c                  |  28 ++
 drivers/mmc/host/sdhci-pci-core.c                  | 154 ++++++++
 drivers/mmc/host/sdhci.c                           |   6 +-
 drivers/mmc/host/via-sdmmc.c                       |   3 +
 drivers/mtd/ubi/wl.c                               |  13 +
 drivers/net/can/flexcan.c                          |  30 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |   5 -
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   3 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   1 -
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  13 -
 drivers/net/ethernet/pensando/ionic/ionic_txrx.h   |   1 -
 drivers/net/wan/hdlc_fr.c                          |  98 ++---
 drivers/net/wireless/ath/ath10k/htt_rx.c           |  16 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   5 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   4 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   2 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   4 +
 drivers/net/wireless/ath/ath11k/reg.c              |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   1 +
 drivers/net/xen-netback/common.h                   |  15 +
 drivers/net/xen-netback/interface.c                |  61 ++-
 drivers/net/xen-netback/netback.c                  |  11 +-
 drivers/net/xen-netback/rx.c                       |  13 +-
 drivers/nfc/s3fwrn5/Kconfig                        |   1 +
 drivers/nvme/host/rdma.c                           |   1 -
 drivers/pci/controller/dwc/pcie-qcom.c             |  13 +
 drivers/pci/ecam.c                                 |  10 +
 drivers/pci/pci-acpi.c                             |  10 +
 drivers/power/supply/bq27xxx_battery.c             |   6 +-
 drivers/power/supply/test_power.c                  |   6 +
 drivers/remoteproc/remoteproc_debugfs.c            |   2 +-
 drivers/rpmsg/qcom_glink_native.c                  |   6 +-
 drivers/rtc/rtc-rx8010.c                           |  24 +-
 drivers/s390/crypto/ap_bus.h                       |   1 +
 drivers/s390/crypto/ap_queue.c                     |   8 +-
 drivers/s390/crypto/zcrypt_debug.h                 |   8 +
 drivers/s390/crypto/zcrypt_error.h                 |  88 ++---
 drivers/s390/crypto/zcrypt_msgtype50.c             |  50 +--
 drivers/s390/crypto/zcrypt_msgtype6.c              |  92 ++---
 drivers/scsi/qla2xxx/qla_attr.c                    |  10 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   1 -
 drivers/scsi/qla2xxx/qla_init.c                    |   2 +
 drivers/scsi/qla2xxx/qla_isr.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  13 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  49 +--
 drivers/scsi/scsi_lib.c                            |  22 +-
 drivers/scsi/sd.c                                  |  27 +-
 drivers/scsi/sr.c                                  |  16 +-
 drivers/soc/qcom/rpmh-internal.h                   |   4 +
 drivers/soc/qcom/rpmh-rsc.c                        | 115 +++---
 drivers/soc/ti/k3-ringacc.c                        |  33 +-
 drivers/spi/spi-mtk-nor.c                          |   6 +-
 drivers/spi/spi-sprd.c                             |   2 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   1 +
 drivers/staging/fieldbus/anybuss/arcx-anybus.c     |   2 +-
 drivers/staging/octeon/ethernet-mdio.c             |   6 -
 drivers/staging/octeon/ethernet-rx.c               |  34 +-
 drivers/staging/octeon/ethernet.c                  |   9 +
 drivers/staging/wfx/sta.c                          |  28 +-
 drivers/tee/tee_core.c                             |   3 +-
 drivers/tty/serial/21285.c                         |  12 +-
 drivers/tty/serial/fsl_lpuart.c                    |  13 +-
 drivers/tty/vt/keyboard.c                          |  39 +-
 drivers/tty/vt/vt_ioctl.c                          |  47 +--
 drivers/uio/uio.c                                  |   4 +-
 drivers/usb/cdns3/ep0.c                            |  65 ++--
 drivers/usb/cdns3/gadget.c                         | 102 ++---
 drivers/usb/cdns3/gadget.h                         |   3 +-
 drivers/usb/class/cdc-acm.c                        |  12 +-
 drivers/usb/class/cdc-acm.h                        |   3 +-
 drivers/usb/core/driver.c                          |  30 +-
 drivers/usb/core/generic.c                         |   4 +-
 drivers/usb/core/usb.h                             |   2 +
 drivers/usb/dwc3/core.c                            |  21 +-
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/dwc3-pci.c                        |   3 +-
 drivers/usb/dwc3/ep0.c                             |  27 +-
 drivers/usb/dwc3/gadget.c                          |  70 +++-
 drivers/usb/dwc3/gadget.h                          |   1 +
 drivers/usb/host/ehci-tegra.c                      |   4 +-
 drivers/usb/host/fsl-mph-dr-of.c                   |   9 +-
 drivers/usb/host/xhci-pci.c                        |  17 +
 drivers/usb/host/xhci.c                            |   7 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/misc/adutux.c                          |   1 +
 drivers/usb/misc/apple-mfi-fastcharge.c            |  17 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   8 +-
 drivers/vdpa/mlx5/core/mr.c                        |   5 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   7 +-
 drivers/vhost/vdpa.c                               | 129 +++----
 drivers/vhost/vringh.c                             |   9 +-
 drivers/video/fbdev/pvr2fb.c                       |   2 +
 drivers/w1/masters/mxc_w1.c                        |  14 +-
 drivers/watchdog/rdc321x_wdt.c                     |   5 +-
 drivers/xen/events/events_2l.c                     |   9 +-
 drivers/xen/events/events_base.c                   | 423 +++++++++++++++++++--
 drivers/xen/events/events_fifo.c                   |  83 ++--
 drivers/xen/events/events_internal.h               |  20 +-
 drivers/xen/evtchn.c                               |   7 +-
 drivers/xen/gntdev-dmabuf.c                        |  13 +-
 drivers/xen/pvcalls-back.c                         |  76 ++--
 drivers/xen/xen-pciback/pci_stub.c                 |  13 +-
 drivers/xen/xen-pciback/pciback.h                  |  12 +-
 drivers/xen/xen-pciback/pciback_ops.c              |  48 ++-
 drivers/xen/xen-pciback/xenbus.c                   |   2 +-
 drivers/xen/xen-scsiback.c                         |  23 +-
 fs/9p/vfs_file.c                                   |   4 +-
 fs/afs/dir.c                                       |  12 +-
 fs/afs/dir_edit.c                                  |   6 +-
 fs/afs/file.c                                      |  77 +++-
 fs/afs/internal.h                                  |  57 +++
 fs/afs/server.c                                    |   7 +-
 fs/afs/write.c                                     | 105 ++---
 fs/afs/xattr.c                                     |   2 +-
 fs/btrfs/block-group.c                             |   1 +
 fs/btrfs/ctree.c                                   |   6 +
 fs/btrfs/ctree.h                                   |   4 +-
 fs/btrfs/delayed-inode.c                           |   3 +-
 fs/btrfs/dev-replace.c                             |   7 +-
 fs/btrfs/disk-io.c                                 |   8 +-
 fs/btrfs/extent-tree.c                             |   7 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/ioctl.c                                   |   6 +-
 fs/btrfs/reada.c                                   |  47 +++
 fs/btrfs/reflink.c                                 |   2 +
 fs/btrfs/root-tree.c                               |  13 +-
 fs/btrfs/send.c                                    | 201 ++++++++--
 fs/btrfs/tree-checker.c                            |  35 +-
 fs/btrfs/tree-log.c                                |   8 +
 fs/btrfs/volumes.c                                 |  42 +-
 fs/btrfs/volumes.h                                 |   1 +
 fs/buffer.c                                        |  16 -
 fs/cachefiles/rdwr.c                               |   3 +-
 fs/ceph/addr.c                                     |   2 +-
 fs/ceph/mds_client.c                               |  89 +++--
 fs/cifs/cifsglob.h                                 |   2 +
 fs/cifs/connect.c                                  |  15 +-
 fs/cifs/inode.c                                    |  13 +-
 fs/cifs/smb2maperror.c                             |   2 +-
 fs/cifs/smb2ops.c                                  |  15 +
 fs/exec.c                                          |  24 +-
 fs/ext4/balloc.c                                   |   1 +
 fs/ext4/extents.c                                  |  33 +-
 fs/ext4/ialloc.c                                   |   1 +
 fs/ext4/inode.c                                    |  29 +-
 fs/ext4/resize.c                                   |   4 +-
 fs/ext4/super.c                                    |  31 +-
 fs/f2fs/checkpoint.c                               |  10 +-
 fs/f2fs/compress.c                                 |   7 +-
 fs/f2fs/dir.c                                      |   8 +-
 fs/f2fs/f2fs.h                                     |   4 +-
 fs/f2fs/file.c                                     |   2 +
 fs/f2fs/inode.c                                    |   3 +
 fs/f2fs/node.c                                     |   2 +-
 fs/f2fs/segment.c                                  |  12 +-
 fs/f2fs/super.c                                    |   6 +
 fs/gfs2/glock.c                                    |  18 +-
 fs/gfs2/glops.c                                    |  11 +-
 fs/gfs2/incore.h                                   |   1 +
 fs/gfs2/log.c                                      |  61 +--
 fs/gfs2/ops_fstype.c                               |  40 +-
 fs/gfs2/rgrp.c                                     |   9 +-
 fs/gfs2/rgrp.h                                     |   2 +-
 fs/gfs2/super.c                                    |   3 +
 fs/gfs2/sys.c                                      |   5 +-
 fs/gfs2/util.c                                     |   2 +-
 fs/gfs2/util.h                                     |  10 +
 fs/io-wq.c                                         |   1 +
 fs/io_uring.c                                      |   8 +-
 fs/jbd2/recovery.c                                 |  78 +++-
 fs/nfs/namespace.c                                 |  12 +-
 fs/nfs/nfs4_fs.h                                   |   8 +
 fs/nfs/nfs4file.c                                  |   3 +-
 fs/nfs/nfs4proc.c                                  |  90 +++--
 fs/nfs/nfs4trace.h                                 |   1 +
 fs/nfsd/nfs4state.c                                |   5 +-
 fs/nfsd/nfsproc.c                                  |  16 +
 fs/nfsd/trace.h                                    |   4 +-
 fs/ubifs/debug.c                                   |   1 +
 fs/ubifs/journal.c                                 |   6 +-
 fs/ubifs/orphan.c                                  |   2 +
 fs/ubifs/super.c                                   |  44 ++-
 fs/ubifs/tnc.c                                     |   3 +
 fs/ubifs/xattr.c                                   |   2 +
 fs/udf/super.c                                     |  21 +-
 fs/xfs/libxfs/xfs_bmap.c                           |  19 +-
 fs/xfs/libxfs/xfs_defer.c                          |  37 +-
 fs/xfs/libxfs/xfs_defer.h                          |   6 +
 fs/xfs/xfs_bmap_item.c                             |   2 +-
 fs/xfs/xfs_log_recover.c                           |  39 +-
 fs/xfs/xfs_refcount_item.c                         |   2 +-
 fs/xfs/xfs_rtalloc.c                               |  19 +-
 include/asm-generic/vmlinux.lds.h                  |   5 +-
 include/drm/gpu_scheduler.h                        |  12 +-
 include/linux/arm-smccc.h                          |   2 +
 include/linux/cpufreq.h                            |  11 +-
 include/linux/fs.h                                 |   1 -
 include/linux/hil_mlc.h                            |   2 +-
 include/linux/mlx5/driver.h                        |  18 +
 include/linux/pci-ecam.h                           |   1 +
 include/linux/rcupdate_trace.h                     |   4 +
 include/linux/time64.h                             |   4 +
 include/linux/usb/pd.h                             |   1 +
 include/rdma/ib_verbs.h                            |   5 -
 include/scsi/scsi_cmnd.h                           |   3 +-
 include/trace/events/afs.h                         |  22 +-
 include/trace/events/btrfs.h                       |  10 +-
 include/uapi/linux/btrfs_tree.h                    |  14 +
 include/uapi/linux/nfs4.h                          |   3 +
 include/uapi/linux/videodev2.h                     |  17 +-
 include/xen/events.h                               |  21 +
 init/Kconfig                                       |   3 +-
 kernel/bpf/verifier.c                              |   4 +
 kernel/debug/debug_core.c                          |  22 +-
 kernel/futex.c                                     |   9 +-
 kernel/locking/lockdep.c                           |   4 +-
 kernel/module.c                                    |   2 +-
 kernel/rcu/tasks.h                                 |  16 +-
 kernel/rcu/tree.c                                  |   2 +-
 kernel/sched/cpufreq_schedutil.c                   |   6 +-
 kernel/seccomp.c                                   |  38 +-
 kernel/stop_machine.c                              |   2 +-
 kernel/time/itimer.c                               |   4 -
 kernel/time/sched_clock.c                          |   4 +-
 kernel/trace/ring_buffer.c                         |  18 +-
 kernel/trace/trace_events_synth.c                  |  23 +-
 lib/scatterlist.c                                  |   2 +-
 mm/slab.c                                          |   2 +-
 mm/slab.h                                          |  42 +-
 mm/slub.c                                          |   3 +-
 net/9p/trans_fd.c                                  |   2 +-
 net/ceph/messenger.c                               |   5 +
 net/mac80211/tx.c                                  |   6 +
 net/sunrpc/sysctl.c                                |   8 +-
 net/sunrpc/xprt.c                                  |   6 +-
 samples/bpf/xdpsock_user.c                         |   1 +
 security/integrity/digsig.c                        |   2 +-
 security/integrity/ima/ima_fs.c                    |   2 +-
 security/integrity/ima/ima_main.c                  |   6 +-
 security/selinux/include/security.h                |  14 +-
 security/selinux/ss/services.c                     |   3 +-
 sound/soc/amd/acp3x-rt5682-max9836.c               |  11 +-
 sound/soc/sof/intel/hda-codec.c                    |   4 +-
 tools/perf/pmu-events/arch/x86/amdzen1/cache.json  |  18 +
 tools/perf/util/print_binary.c                     |   2 +-
 .../testing/selftests/bpf/progs/test_sysctl_prog.c |   4 +-
 tools/testing/selftests/powerpc/utils.c            |   4 +-
 tools/testing/selftests/x86/fsgsbase.c             |  68 ++++
 460 files changed, 5209 insertions(+), 2493 deletions(-)


