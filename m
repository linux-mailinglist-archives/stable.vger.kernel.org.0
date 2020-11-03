Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D7D2A5799
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbgKCUyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:54:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732533AbgKCUyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:54:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D914822226;
        Tue,  3 Nov 2020 20:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436848;
        bh=I7QkIFhqJHSvJsshbDhntgUyFRdMr1i/1mZAzLDA1rw=;
        h=From:To:Cc:Subject:Date:From;
        b=O1hRJcwO7eNk+wh3FMoj1xlsJYEsp9aC0Ajw729BfUbeS8bPk/7O+5EQmk7qGBt5X
         GaTDPlT6mYz25tZFDNUdAJkQ+mxf/pjgywjVfO4qiTcvu0/oaHhoPHQ7WpU29HMI5B
         xdfXDD2PRPBFd1V1jPcohz4Gn/Jj6zx8nup1ZrUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 000/214] 5.4.75-rc1 review
Date:   Tue,  3 Nov 2020 21:34:08 +0100
Message-Id: <20201103203249.448706377@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.75-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.75-rc1
X-KernelTest-Deadline: 2020-11-05T20:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.75 release.
There are 214 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.75-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.75-rc1

Stephen Boyd <swboyd@chromium.org>
    KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    staging: octeon: Drop on uncorrectable alignment or FCS error

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    staging: octeon: repair "fixed-link" support

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: cb_pcidas: Allow 2-channel commands for AO subdevice

Jing Xiangfeng <jingxiangfeng@huawei.com>
    staging: fieldbus: anybuss: jump to correct label in an error path

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

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: increase mclk switch threshold to 200 us

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    mmc: sdhci: Use Auto CMD Auto Select only when v4_mode is true

Michael Walle <michael@walle.cc>
    mmc: sdhci-of-esdhc: set timeout to max before tuning

Dave Airlie <airlied@redhat.com>
    drm/ttm: fix eviction valuable range check.

Constantine Sapuntzakis <costa@purestorage.com>
    ext4: fix superblock checksum calculation race

Luo Meng <luomeng12@huawei.com>
    ext4: fix invalid inode checksum

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ext4: fix error handling code in add_new_gdb

Eric Biggers <ebiggers@google.com>
    ext4: fix leaking sysfs kobject after failed mount

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

Takashi Iwai <tiwai@suse.de>
    drm/amd/display: Fix kernel panic by dal_gpio_open() error

Takashi Iwai <tiwai@suse.de>
    drm/amd/display: Don't invoke kgdb_breakpoint() unconditionally

Christian König <christian.koenig@amd.com>
    drm/amdgpu: increase the reserved VM size to 2MB

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/amd/display: Avoid MST manager resource leak.

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Use same SQ prefetch setting as amdgpu

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: correct the gpu reset handling for job != NULL case

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Increase timeout for DP Disable

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

Michael Neuling <mikey@neuling.org>
    powerpc: Fix undetected data corruption with P9N DD2.1 VSX CI load emulation

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

Maciej W. Rozycki <macro@linux-mips.org>
    MIPS: DEC: Restore bootmem reservation for firmware working memory area

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/drmem: Make lmb_size 64 bit

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc12138 Fix alignment issue with timestamp

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc0832 Fix alignment issue with timestamp

Tobias Jordan <kernel@cdqe.de>
    iio: adc: gyroadc: fix leak of device node iterator

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:si1145: Fix timestamp alignment and prevent data leak.

Paul Cercueil <paul@crapouillou.net>
    dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status

Jan Kara <jack@suse.cz>
    udf: Fix memory leak when mounting

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Avoid entering wacom_wac_pen_report for pad / battery

Jiri Slaby <jslaby@suse.cz>
    vt: keyboard, extend func_buf_lock to readers

Jiri Slaby <jslaby@suse.cz>
    vt: keyboard, simplify vt_kdgkbsent

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Force VT'd workarounds when running as a guest OS

Ran Wang <ran.wang_1@nxp.com>
    usb: host: fsl-mph-dr-of: check return of dma_set_mask()

Li Jun <jun.li@nxp.com>
    usb: typec: tcpm: reset hard_reset_count for any disconnect

Jerome Brunet <jbrunet@baylibre.com>
    usb: cdc-acm: fix cooldown mechanism

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Resume pending requests after CLEAR_STALL

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: don't trigger runtime pm when remove driver

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: add phy cleanup for probe error handling

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Check MPS of the request length

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Fix ZLP for OUT ep0 requests

Raymond Tan <raymond.tan@intel.com>
    usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method for PM functionality

Sandeep Singh <sandeep.singh@amd.com>
    usb: xhci: Workaround for S3 issue on AMD SNPS 3.0 xHC

Filipe Manana <fdmanana@suse.com>
    btrfs: fix readahead hang and use-after-free after removing a device

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free on readahead extent after failure to create it

Daniel Xu <dxu@dxuuu.xyz>
    btrfs: tree-checker: validate number of chunk stripes and parity

Josef Bacik <josef@toxicpanda.com>
    btrfs: cleanup cow block on error

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

Anand Jain <anand.jain@oracle.com>
    btrfs: improve device scanning messages

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: fix wrong qgroup metadata reserve for delayed inode

Xiang Chen <chenxiang66@hisilicon.com>
    PM: runtime: Remove link state checks in rpm_get/put_supplier()

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix crash on session cleanup with unload

Helge Deller <deller@gmx.de>
    scsi: mptfusion: Fix null pointer dereferences in mptscsih_remove()

Martin Fuzzey <martin.fuzzey@flowbird.group>
    w1: mxc_w1: Fix timeout resolution problem leading to bus error

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

Jan Kara <jack@suse.cz>
    fs: Don't invalidate page buffers in block_write_full_page()

Hans de Goede <hdegoede@redhat.com>
    media: uvcvideo: Fix uvc_ctrl_fixup_xu_info() not having any effect

Marek Behún <marek.behun@nic.cz>
    leds: bcm6328, bcm6358: use devres LED registering function

Krzysztof Kozlowski <krzk@kernel.org>
    extcon: ptn5150: Fix usage of atomic GPIO with sleeping GPIO chips

Krzysztof Kozlowski <krzk@kernel.org>
    spi: sprd: Release DMA channel also on probe deferral

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Fix raw sample data accumulation

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Don't include randomized bits in get_ibs_op_count()

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix Ice Lake event constraint table

Andy Lutomirski <luto@kernel.org>
    selftests/x86/fsgsbase: Test PTRACE_PEEKUSER for GSBASE with invalid LDT GS

Jann Horn <jannh@google.com>
    seccomp: Make duplicate listener detection non-racy

Raul E Rangel <rrangel@chromium.org>
    mmc: sdhci-acpi: AMDI0040: Set SDHCI_QUIRK2_PRESET_VALUE_BROKEN

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Add LTR support for some Intel BYT based controllers

Song Liu <songliubraving@fb.com>
    md/raid5: fix oops during stripe resizing

Chao Leng <lengchao@huawei.com>
    nvme-rdma: fix crash when connect rejected

Douglas Gilbert <dgilbert@interlog.com>
    sgl_alloc_order: fix memory leak

Xiubo Li <xiubli@redhat.com>
    nbd: make the config put is called before the notifying the waiter

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: remove dedicated 'audio-subsystem' node

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: move PMU node out of clock controller

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: move fixed clocks under root node

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: remove DMA controller bus node name to fix dtschema warnings

Dan Carpenter <dan.carpenter@oracle.com>
    memory: emif: Remove bogus debugfs error handling

Tony Lindgren <tony@atomide.com>
    ARM: dts: omap4: Fix sgx clock rate for 4430

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    arm64: dts: renesas: ulcb: add full-pwr-cycle-in-suspend into eMMC nodes

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: handle -EINTR in cifs_setattr

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    gfs2: add validation checks for size of superblock

Jamie Iles <jamie@nuviainc.com>
    gfs2: use-after-free in sysfs deregistration

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Book3S HV: Do not allocate HPT for a nested guest

Jan Kara <jack@suse.cz>
    ext4: Detect already used quota file early

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    drivers: watchdog: rdc321x_wdt: Fix race condition bugs

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    asm-generic/io.h: Fix !CONFIG_GENERIC_IOMAP pci_iounmap() implementation

Tero Kristo <t-kristo@ti.com>
    clk: ti: clockdomain: fix static checker warning

Chris Lew <clew@codeaurora.org>
    rpmsg: glink: Use complete_all for open states

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Log unknown link speed appropriately.

Zhao Heming <heming.zhao@suse.com>
    md/bitmap: md_bitmap_get_counter returns wrong blocks

Anand Jain <anand.jain@oracle.com>
    btrfs: fix replace of seed device

Zhen Lei <thunder.leizhen@huawei.com>
    ARC: [dts] fix the errors detected by dtbs_check

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: HDMI remote sink need mode validation for Linux

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    power: supply: test_power: add missing newlines when printing parameters by sysfs

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    ACPI: HMAT: Fix handling of changes from ACPI 6.2 to ACPI 6.3

Diana Craciun <diana.craciun@oss.nxp.com>
    bus/fsl_mc: Do not rely on caller to provide non NULL mc_io

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values

Wright Feng <wright.feng@cypress.com>
    brcmfmac: Fix warning message after dongle setup failed

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    ACPI: Add out of bounds and numa_off protections to pxm_to_node()

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't free rt blocks when we're doing a REMAP bunmapi call

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: disable clocks during stop mode

Zhengyuan Liu <liuzhengyuan@tj.kylinos.cn>
    arm64/mm: return cpu_all_mask when node is NUMA_NO_NODE

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Mitigate cond_resched() in xprt_transmit()

Peter Chen <peter.chen@nxp.com>
    usb: xhci: omit duplicate actions when suspending a runtime suspended host.

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

Magnus Karlsson <magnus.karlsson@intel.com>
    samples/bpf: Fix possible deadlock in xdpsock

Yonghong Song <yhs@fb.com>
    selftests/bpf: Define string const as global for test_sysctl_prog.c

Daniel W. S. Almeida <dwlsalmeida@gmail.com>
    media: uvcvideo: Fix dereference of out-of-bound list iterator

Yonghong Song <yhs@fb.com>
    bpf: Permit map_ptr arithmetic with opcode add and offset 0

Douglas Anderson <dianders@chromium.org>
    kgdb: Make "kgdbcon" work properly with "kgdb_earlycon"

Masami Hiramatsu <mhiramat@kernel.org>
    ia64: kprobes: Use generic kretprobe trampoline handler

John Ogness <john.ogness@linutronix.de>
    printk: reduce LOG_BUF_SHIFT range for H8300

Valentin Schneider <valentin.schneider@arm.com>
    arm64: topology: Stop using MPIDR for topology information

Antonio Borneo <antonio.borneo@st.com>
    drm/bridge/synopsys: dsi: add support for non-continuous HS clock

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    mmc: via-sdmmc: Fix data race bug

Hans Verkuil <hverkuil@xs4all.nl>
    media: imx274: fix frame interval handling

Tom Rix <trix@redhat.com>
    media: tw5864: check status of tw5864_frameinterval_get

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: During PR_SWAP, source caps should be sent only after tSwapSourceStart

Xia Jiang <xia.jiang@mediatek.com>
    media: platform: Improve queue set up flow for bug fixing

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videodev2.h: RGB BT2020 and HSV are always full range

Andy Lutomirski <luto@kernel.org>
    selftests/x86/fsgsbase: Reap a forgotten child

Nadezda Lutovinova <lutovinova@ispras.ru>
    drm/brige/megachips: Add checking if ge_b850v3_lvds_init() is working correctly

Sathishkumar Muruganandam <murugana@codeaurora.org>
    ath10k: fix VHT NSS calculation when STBC is enabled

Wen Gong <wgong@codeaurora.org>
    ath10k: start recovery process when payload length exceeds max htc length for sdio

Tom Rix <trix@redhat.com>
    video: fbdev: pvr2fb: initialize variables

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix realtime bitmap/summary file truncation when growing rt volume

Krzysztof Kozlowski <krzk@kernel.org>
    power: supply: bq27xxx: report "not charging" on all types

Dave Wysochanski <dwysocha@redhat.com>
    NFS4: Fix oops when copy_file_range is attempted with NFS4.0 source

Douglas Anderson <dianders@chromium.org>
    ARM: 8997/2: hw_breakpoint: Handle inexact watchpoint addresses

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: handle errors of f2fs_get_meta_page_nofail

Johannes Berg <johannes.berg@intel.com>
    um: change sigio_spinlock to a mutex

Vasily Gorbik <gor@linux.ibm.com>
    s390/startup: avoid save_area_sync overflow

Chao Yu <chao@kernel.org>
    f2fs: fix to check segment boundary during SIT page readahead

Chao Yu <chao@kernel.org>
    f2fs: fix uninit-value in f2fs_lookup

Zhang Qilong <zhangqilong3@huawei.com>
    f2fs: add trace exit in exception path

Nicholas Piggin <npiggin@gmail.com>
    sparc64: remove mm_cpumask clearing to fix kthread_use_mm race

Nicholas Piggin <npiggin@gmail.com>
    powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM

Nicholas Piggin <npiggin@gmail.com>
    mm: fix exec activate_mm vs TLB shootdown and lazy tlb switching race

Oliver O'Halloran <oohall@gmail.com>
    powerpc/powernv/smp: Fix spurious DBG() warning

Mateusz Nosek <mateusznosek0@gmail.com>
    futex: Fix incorrect should_fail_futex() handling

Sascha Hauer <s.hauer@pengutronix.de>
    ata: sata_nv: Fix retrieving of active qcs

Alok Prasad <palok@marvell.com>
    RDMA/qedr: Fix memory leak in iWARP CM

Amit Cohen <amcohen@nvidia.com>
    mlxsw: core: Fix use-after-free in mlxsw_emad_trans_finish()

Jiri Slaby <jslaby@suse.cz>
    x86/unwind/orc: Fix inactive tasks with stack pointer in %sp on GCC 10 compiled kernels

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Add missing Rx size re-initialisation

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
 Documentation/media/uapi/v4l/colorspaces-defs.rst  |   9 +-
 .../media/uapi/v4l/colorspaces-details.rst         |   5 +-
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   7 +
 arch/arc/boot/dts/axc001.dtsi                      |   2 +-
 arch/arc/boot/dts/axc003.dtsi                      |   2 +-
 arch/arc/boot/dts/axc003_idu.dtsi                  |   2 +-
 arch/arc/boot/dts/vdk_axc003.dtsi                  |   2 +-
 arch/arc/boot/dts/vdk_axc003_idu.dtsi              |   2 +-
 arch/arc/kernel/perf_event.c                       |  27 +-
 arch/arm/Kconfig                                   |   2 +
 arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts      |   1 +
 arch/arm/boot/dts/omap4.dtsi                       |   2 +-
 arch/arm/boot/dts/omap443x.dtsi                    |  10 +
 arch/arm/boot/dts/s5pv210.dtsi                     | 163 ++++----
 arch/arm/kernel/hw_breakpoint.c                    | 100 +++--
 arch/arm/plat-samsung/Kconfig                      |   1 +
 arch/arm64/Kconfig.platforms                       |   1 +
 arch/arm64/boot/dts/renesas/ulcb.dtsi              |   1 +
 arch/arm64/include/asm/kvm_host.h                  |   1 +
 arch/arm64/include/asm/numa.h                      |   3 +
 arch/arm64/kernel/topology.c                       |  32 +-
 arch/arm64/kvm/sys_regs.c                          |   6 +-
 arch/arm64/mm/numa.c                               |   6 +-
 arch/ia64/kernel/Makefile                          |   2 +-
 arch/ia64/kernel/kprobes.c                         |  77 +---
 arch/mips/dec/setup.c                              |   9 +-
 arch/powerpc/Kconfig                               |  14 +
 arch/powerpc/include/asm/drmem.h                   |   4 +-
 arch/powerpc/include/asm/mmu_context.h             |   2 +-
 arch/powerpc/kernel/head_32.S                      |   2 +-
 arch/powerpc/kernel/rtas.c                         | 153 ++++++++
 arch/powerpc/kernel/sysfs.c                        |  42 +-
 arch/powerpc/kernel/traps.c                        |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |   6 +
 arch/powerpc/platforms/powermac/sleep.S            |   9 +-
 arch/powerpc/platforms/powernv/opal-elog.c         |  33 +-
 arch/powerpc/platforms/powernv/smp.c               |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  43 ++-
 arch/riscv/include/uapi/asm/auxvec.h               |   3 +
 arch/s390/boot/head.S                              |  21 +-
 arch/s390/kernel/time.c                            | 118 ++++--
 arch/sparc/kernel/smp_64.c                         |  65 +---
 arch/um/kernel/sigio.c                             |   6 +-
 arch/x86/events/amd/ibs.c                          |  38 +-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/kernel/unwind_orc.c                       |   9 +-
 drivers/acpi/acpi_dbg.c                            |   3 +
 drivers/acpi/acpi_extlog.c                         |   6 +-
 drivers/acpi/button.c                              |  13 +-
 drivers/acpi/ec.c                                  |  10 +-
 drivers/acpi/hmat/hmat.c                           |   3 +-
 drivers/acpi/numa.c                                |   2 +-
 drivers/acpi/video_detect.c                        |   9 +
 drivers/ata/sata_nv.c                              |   2 +-
 drivers/base/core.c                                |   4 +-
 drivers/base/power/runtime.c                       |   5 +-
 drivers/block/nbd.c                                |   2 +-
 drivers/block/xen-blkback/blkback.c                |  22 +-
 drivers/block/xen-blkback/xenbus.c                 |   5 +-
 drivers/bus/fsl-mc/mc-io.c                         |   7 +-
 drivers/clk/ti/clockdomain.c                       |   2 +
 drivers/cpufreq/acpi-cpufreq.c                     |   3 +-
 drivers/cpufreq/sti-cpufreq.c                      |   6 +-
 drivers/dma/dma-jz4780.c                           |   7 +-
 drivers/extcon/extcon-ptn5150.c                    |   8 +-
 drivers/firmware/arm_scmi/base.c                   |   2 +
 drivers/firmware/arm_scmi/clock.c                  |   2 +
 drivers/firmware/arm_scmi/common.h                 |   2 +
 drivers/firmware/arm_scmi/driver.c                 |   8 +
 drivers/firmware/arm_scmi/perf.c                   |   2 +
 drivers/firmware/arm_scmi/reset.c                  |   4 +-
 drivers/firmware/arm_scmi/sensors.c                |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  10 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   4 +-
 .../drm/amd/amdkfd/kfd_device_queue_manager_v10.c  |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   2 +-
 .../amd/display/dc/dcn10/dcn10_stream_encoder.c    |   4 +-
 drivers/gpu/drm/amd/display/dc/gpio/gpio_base.c    |   4 +-
 drivers/gpu/drm/amd/display/dc/os_types.h          |   2 +-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   2 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |  12 +-
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c      |   9 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   6 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   2 +-
 drivers/hid/wacom_wac.c                            |   4 +-
 drivers/hwtracing/coresight/coresight-priv.h       |   3 +-
 drivers/hwtracing/coresight/coresight.c            |  62 ++-
 drivers/i2c/busses/i2c-imx.c                       |  24 +-
 drivers/iio/adc/rcar-gyroadc.c                     |  21 +-
 drivers/iio/adc/ti-adc0832.c                       |  11 +-
 drivers/iio/adc/ti-adc12138.c                      |  13 +-
 drivers/iio/gyro/itg3200_buffer.c                  |  15 +-
 drivers/iio/light/si1145.c                         |  19 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |   1 +
 drivers/input/serio/hil_mlc.c                      |  21 +-
 drivers/input/serio/hp_sdc_mlc.c                   |   8 +-
 drivers/leds/leds-bcm6328.c                        |   2 +-
 drivers/leds/leds-bcm6358.c                        |   2 +-
 drivers/md/md-bitmap.c                             |   2 +-
 drivers/md/raid5.c                                 |   4 +-
 drivers/media/i2c/imx274.c                         |   8 +-
 drivers/media/pci/tw5864/tw5864-video.c            |   6 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |   7 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |  27 +-
 drivers/memory/emif.c                              |  33 +-
 drivers/message/fusion/mptscsih.c                  |  13 +-
 drivers/mmc/host/sdhci-acpi.c                      |  37 ++
 drivers/mmc/host/sdhci-of-esdhc.c                  |  11 +
 drivers/mmc/host/sdhci-pci-core.c                  | 154 ++++++++
 drivers/mmc/host/sdhci.c                           |   6 +-
 drivers/mmc/host/via-sdmmc.c                       |   3 +
 drivers/mtd/ubi/wl.c                               |  13 +
 drivers/net/can/flexcan.c                          |  30 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   3 +
 drivers/net/wan/hdlc_fr.c                          |  98 ++---
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   8 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   4 +
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  10 +-
 drivers/net/xen-netback/common.h                   |  15 +
 drivers/net/xen-netback/interface.c                |  61 ++-
 drivers/net/xen-netback/netback.c                  |  11 +-
 drivers/net/xen-netback/rx.c                       |  13 +-
 drivers/nvme/host/rdma.c                           |   1 -
 drivers/pci/pci-acpi.c                             |  10 +
 drivers/power/supply/bq27xxx_battery.c             |   6 +-
 drivers/power/supply/test_power.c                  |   6 +
 drivers/rpmsg/qcom_glink_native.c                  |   6 +-
 drivers/rtc/rtc-rx8010.c                           |  24 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  13 +-
 drivers/spi/spi-sprd.c                             |   2 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   1 +
 drivers/staging/fieldbus/anybuss/arcx-anybus.c     |   2 +-
 drivers/staging/octeon/ethernet-mdio.c             |   6 -
 drivers/staging/octeon/ethernet-rx.c               |  34 +-
 drivers/staging/octeon/ethernet.c                  |   9 +
 drivers/tty/vt/keyboard.c                          |  39 +-
 drivers/tty/vt/vt_ioctl.c                          |  32 +-
 drivers/uio/uio.c                                  |   4 +-
 drivers/usb/class/cdc-acm.c                        |  12 +-
 drivers/usb/class/cdc-acm.h                        |   3 +-
 drivers/usb/dwc3/core.c                            |  15 +-
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/dwc3-pci.c                        |   3 +-
 drivers/usb/dwc3/ep0.c                             |  27 +-
 drivers/usb/dwc3/gadget.c                          |  60 ++-
 drivers/usb/dwc3/gadget.h                          |   1 +
 drivers/usb/host/fsl-mph-dr-of.c                   |   9 +-
 drivers/usb/host/xhci-pci.c                        |  17 +
 drivers/usb/host/xhci.c                            |   7 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/misc/adutux.c                          |   1 +
 drivers/usb/typec/tcpm/tcpm.c                      |   8 +-
 drivers/vhost/vringh.c                             |   9 +-
 drivers/video/fbdev/pvr2fb.c                       |   2 +
 drivers/w1/masters/mxc_w1.c                        |  14 +-
 drivers/watchdog/rdc321x_wdt.c                     |   5 +-
 drivers/xen/events/events_2l.c                     |   9 +-
 drivers/xen/events/events_base.c                   | 422 +++++++++++++++++++--
 drivers/xen/events/events_fifo.c                   |  83 ++--
 drivers/xen/events/events_internal.h               |  20 +-
 drivers/xen/evtchn.c                               |   7 +-
 drivers/xen/pvcalls-back.c                         |  76 ++--
 drivers/xen/xen-pciback/pci_stub.c                 |  14 +-
 drivers/xen/xen-pciback/pciback.h                  |  12 +-
 drivers/xen/xen-pciback/pciback_ops.c              |  48 ++-
 drivers/xen/xen-pciback/xenbus.c                   |   2 +-
 drivers/xen/xen-scsiback.c                         |  23 +-
 fs/9p/vfs_file.c                                   |   4 +-
 fs/btrfs/ctree.c                                   |   6 +
 fs/btrfs/ctree.h                                   |   2 +
 fs/btrfs/delayed-inode.c                           |   3 +-
 fs/btrfs/dev-replace.c                             |   7 +-
 fs/btrfs/reada.c                                   |  47 +++
 fs/btrfs/send.c                                    | 201 ++++++++--
 fs/btrfs/tree-checker.c                            |  35 +-
 fs/btrfs/tree-log.c                                |   8 +
 fs/btrfs/volumes.c                                 |  17 +-
 fs/btrfs/volumes.h                                 |   1 +
 fs/buffer.c                                        |  16 -
 fs/cachefiles/rdwr.c                               |   3 +-
 fs/ceph/addr.c                                     |   2 +-
 fs/cifs/inode.c                                    |  13 +-
 fs/exec.c                                          |  17 +-
 fs/ext4/inode.c                                    |  11 +-
 fs/ext4/resize.c                                   |   4 +-
 fs/ext4/super.c                                    |  17 +
 fs/f2fs/checkpoint.c                               |  10 +-
 fs/f2fs/dir.c                                      |   8 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/node.c                                     |   2 +-
 fs/f2fs/segment.c                                  |  12 +-
 fs/gfs2/incore.h                                   |   1 +
 fs/gfs2/ops_fstype.c                               |  40 +-
 fs/gfs2/super.c                                    |   1 +
 fs/gfs2/sys.c                                      |   5 +-
 fs/nfs/namespace.c                                 |  12 +-
 fs/nfs/nfs4_fs.h                                   |   8 +
 fs/nfs/nfs4file.c                                  |   3 +-
 fs/nfs/nfs4proc.c                                  |  90 +++--
 fs/nfs/nfs4trace.h                                 |   1 +
 fs/nfsd/nfsproc.c                                  |  16 +
 fs/ubifs/debug.c                                   |   1 +
 fs/ubifs/journal.c                                 |   6 +-
 fs/ubifs/orphan.c                                  |   2 +
 fs/ubifs/super.c                                   |  44 ++-
 fs/ubifs/tnc.c                                     |   3 +
 fs/ubifs/xattr.c                                   |   2 +
 fs/udf/super.c                                     |  21 +-
 fs/xfs/libxfs/xfs_bmap.c                           |  19 +-
 fs/xfs/xfs_rtalloc.c                               |  10 +-
 include/asm-generic/io.h                           |  39 +-
 include/linux/arm-smccc.h                          |   2 +
 include/linux/hil_mlc.h                            |   2 +-
 include/linux/usb/pd.h                             |   1 +
 include/uapi/linux/btrfs_tree.h                    |  14 +
 include/uapi/linux/nfs4.h                          |   3 +
 include/uapi/linux/videodev2.h                     |  17 +-
 include/xen/events.h                               |  29 +-
 init/Kconfig                                       |   3 +-
 kernel/bpf/verifier.c                              |   4 +
 kernel/debug/debug_core.c                          |  22 +-
 kernel/futex.c                                     |   4 +-
 kernel/seccomp.c                                   |  38 +-
 kernel/trace/ring_buffer.c                         |   8 +-
 lib/scatterlist.c                                  |   2 +-
 net/9p/trans_fd.c                                  |   2 +-
 net/ceph/messenger.c                               |   5 +
 net/sunrpc/xprt.c                                  |   6 +-
 samples/bpf/xdpsock_user.c                         |   1 +
 tools/perf/util/print_binary.c                     |   2 +-
 .../testing/selftests/bpf/progs/test_sysctl_prog.c |   4 +-
 tools/testing/selftests/x86/fsgsbase.c             |  68 ++++
 virt/kvm/arm/psci.c                                |   2 +-
 239 files changed, 2954 insertions(+), 1226 deletions(-)


