Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863462A5444
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387759AbgKCVJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388537AbgKCVJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8428B205ED;
        Tue,  3 Nov 2020 21:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437773;
        bh=X9M5Vn/b3vsXzpmZVS0kb34ivALhliBmG47nSQRE1lc=;
        h=From:To:Cc:Subject:Date:From;
        b=Gxubjp/A0sNApco4r3BJD5qFaEaFjUDAuuXuJ1HAmdgGiYKEAibq0ELfr6C+AhR6s
         dD3wIHJqiN2gp9W33F2fXUGrvhIkT2PGlnNOT5naTlgMPOqQVNY5JmjnidJ39iIiea
         PFnoSysPFt5TnkMF2E9gWT32pwCSuAmsw0xsWSS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.14 000/125] 4.14.204-rc1 review
Date:   Tue,  3 Nov 2020 21:36:17 +0100
Message-Id: <20201103203156.372184213@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.204-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.204-rc1
X-KernelTest-Deadline: 2020-11-05T20:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.204 release.
There are 125 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.204-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.204-rc1

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

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    rtc: rx8010: don't modify the global rtc ops

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

Madhav Chauhan <madhav.chauhan@amd.com>
    drm/amdgpu: don't map BO in reserved region

Krzysztof Kozlowski <krzk@kernel.org>
    ia64: fix build error with !COREDUMP

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: check kthread_should_stop() after the setting of task state

Jiri Olsa <jolsa@kernel.org>
    perf python scripting: Fix printable strings in python3 scripts

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: dent: Fix some potential memory leaks while iterating entries

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add missing NFSv2 .pc_func methods

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2: support EXCHGID4_FLAG_SUPP_FENCE_OPS 4.2 EXCHANGE_ID flag

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc/powernv/elog: Fix race while processing OPAL error log event.

Joel Stanley <joel@jms.id.au>
    powerpc: Warn about use of smt_snooze_delay

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc/rtas: Restrict RTAS requests from userspace

Sven Schnelle <svens@linux.ibm.com>
    s390/stp: add locking to sysfs functions

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc12138 Fix alignment issue with timestamp

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ti-adc0832 Fix alignment issue with timestamp

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:light:si1145: Fix timestamp alignment and prevent data leak.

Paul Cercueil <paul@crapouillou.net>
    dmaengine: dma-jz4780: Fix race in jz4780_dma_tx_status

Jiri Slaby <jslaby@suse.cz>
    vt: keyboard, extend func_buf_lock to readers

Jiri Slaby <jslaby@suse.cz>
    vt: keyboard, simplify vt_kdgkbsent

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Force VT'd workarounds when running as a guest OS

Ran Wang <ran.wang_1@nxp.com>
    usb: host: fsl-mph-dr-of: check return of dma_set_mask()

Jerome Brunet <jbrunet@baylibre.com>
    usb: cdc-acm: fix cooldown mechanism

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: don't trigger runtime pm when remove driver

Li Jun <jun.li@nxp.com>
    usb: dwc3: core: add phy cleanup for probe error handling

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Fix ZLP for OUT ep0 requests

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free on readahead extent after failure to create it

Josef Bacik <josef@toxicpanda.com>
    btrfs: cleanup cow block on error

Denis Efremov <efremov@linux.com>
    btrfs: use kvzalloc() to allocate clone_roots in btrfs_ioctl_send()

Filipe Manana <fdmanana@suse.com>
    btrfs: send, recompute reference path after orphanization of a directory

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
    ARM: dts: s5pv210: remove DMA controller bus node name to fix dtschema warnings

Dan Carpenter <dan.carpenter@oracle.com>
    memory: emif: Remove bogus debugfs error handling

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    arm64: dts: renesas: ulcb: add full-pwr-cycle-in-suspend into eMMC nodes

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    gfs2: add validation checks for size of superblock

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

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Log unknown link speed appropriately.

Zhao Heming <heming.zhao@suse.com>
    md/bitmap: md_bitmap_get_counter returns wrong blocks

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    power: supply: test_power: add missing newlines when printing parameters by sysfs

Diana Craciun <diana.craciun@oss.nxp.com>
    bus/fsl_mc: Do not rely on caller to provide non NULL mc_io

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    ACPI: Add out of bounds and numa_off protections to pxm_to_node()

Zhengyuan Liu <liuzhengyuan@tj.kylinos.cn>
    arm64/mm: return cpu_all_mask when node is NUMA_NO_NODE

Lang Dai <lang.dai@intel.com>
    uio: free uio id after uio file node is freed

Oliver Neukum <oneukum@suse.com>
    USB: adutux: fix debugging

Alain Volmat <avolmat@me.com>
    cpufreq: sti-cpufreq: add stih418 support

Douglas Anderson <dianders@chromium.org>
    kgdb: Make "kgdbcon" work properly with "kgdb_earlycon"

John Ogness <john.ogness@linutronix.de>
    printk: reduce LOG_BUF_SHIFT range for H8300

Antonio Borneo <antonio.borneo@st.com>
    drm/bridge/synopsys: dsi: add support for non-continuous HS clock

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    mmc: via-sdmmc: Fix data race bug

Tom Rix <trix@redhat.com>
    media: tw5864: check status of tw5864_frameinterval_get

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: During PR_SWAP, source caps should be sent only after tSwapSourceStart

Xia Jiang <xia.jiang@mediatek.com>
    media: platform: Improve queue set up flow for bug fixing

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videodev2.h: RGB BT2020 and HSV are always full range

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

Nicholas Piggin <npiggin@gmail.com>
    powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM

Oliver O'Halloran <oohall@gmail.com>
    powerpc/powernv/smp: Fix spurious DBG() warning

Mateusz Nosek <mateusznosek0@gmail.com>
    futex: Fix incorrect should_fail_futex() handling

Amit Cohen <amcohen@nvidia.com>
    mlxsw: core: Fix use-after-free in mlxsw_emad_trans_finish()

Jiri Slaby <jslaby@suse.cz>
    x86/unwind/orc: Fix inactive tasks with stack pointer in %sp on GCC 10 compiled kernels

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

Juergen Gross <jgross@suse.com>
    x86/xen: disable Firmware First mode for correctable memory errors

Kim Phillips <kim.phillips@amd.com>
    arch/x86/amd/ibs: Fix re-arming IBS Fetch

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: fix memory leak caused by tipc_buf_append()

Andrew Gabbasov <andrew_gabbasov@mentor.com>
    ravb: Fix bit fields checking in ravb_hwtstamp_get()

Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
    gtp: fix an use-before-init in gtp_newlink()

Michael Schaller <misch@google.com>
    efivarfs: Replace invalid slashes with exclamation marks in dentries.

Nick Desaulniers <ndesaulniers@google.com>
    arm64: link with -z norelro regardless of CONFIG_RELOCATABLE

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    scripts/setlocalversion: make git describe output more reliable


-------------

Diffstat:

 Documentation/media/uapi/v4l/colorspaces-defs.rst  |   9 +-
 .../media/uapi/v4l/colorspaces-details.rst         |   5 +-
 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   2 +
 arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts      |   1 +
 arch/arm/boot/dts/s5pv210.dtsi                     | 127 ++++++++---------
 arch/arm/kernel/hw_breakpoint.c                    | 100 ++++++++++----
 arch/arm/plat-samsung/Kconfig                      |   1 +
 arch/arm64/Kconfig.platforms                       |   1 +
 arch/arm64/Makefile                                |   4 +-
 arch/arm64/boot/dts/renesas/ulcb.dtsi              |   1 +
 arch/arm64/include/asm/kvm_host.h                  |   1 +
 arch/arm64/include/asm/numa.h                      |   3 +
 arch/arm64/kvm/sys_regs.c                          |   6 +-
 arch/arm64/mm/numa.c                               |   6 +-
 arch/ia64/kernel/Makefile                          |   2 +-
 arch/powerpc/Kconfig                               |  14 ++
 arch/powerpc/include/asm/mmu_context.h             |   2 +-
 arch/powerpc/kernel/rtas.c                         | 153 +++++++++++++++++++++
 arch/powerpc/kernel/sysfs.c                        |  42 +++---
 arch/powerpc/platforms/powernv/opal-elog.c         |  33 ++++-
 arch/powerpc/platforms/powernv/smp.c               |   2 +-
 arch/s390/kernel/time.c                            | 118 +++++++++++-----
 arch/sparc/kernel/smp_64.c                         |  65 ++-------
 arch/um/kernel/sigio.c                             |   6 +-
 arch/x86/events/amd/ibs.c                          |  53 +++++--
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/kernel/unwind_orc.c                       |   9 +-
 arch/x86/xen/enlighten_pv.c                        |   9 ++
 drivers/acpi/acpi_dbg.c                            |   3 +
 drivers/acpi/acpi_extlog.c                         |   6 +-
 drivers/acpi/numa.c                                |   2 +-
 drivers/acpi/video_detect.c                        |   9 ++
 drivers/ata/sata_rcar.c                            |   2 +-
 drivers/base/core.c                                |   4 +-
 drivers/block/nbd.c                                |   2 +-
 drivers/clk/ti/clockdomain.c                       |   2 +
 drivers/cpufreq/acpi-cpufreq.c                     |   3 +-
 drivers/cpufreq/sti-cpufreq.c                      |   6 +-
 drivers/dma/dma-jz4780.c                           |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  10 ++
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |  12 +-
 drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c      |   9 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   6 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   2 +-
 drivers/iio/adc/ti-adc0832.c                       |  11 +-
 drivers/iio/adc/ti-adc12138.c                      |  13 +-
 drivers/iio/gyro/itg3200_buffer.c                  |  15 +-
 drivers/iio/light/si1145.c                         |  19 +--
 drivers/input/serio/hil_mlc.c                      |  21 ++-
 drivers/input/serio/hp_sdc_mlc.c                   |   8 +-
 drivers/leds/leds-bcm6328.c                        |   2 +-
 drivers/leds/leds-bcm6358.c                        |   2 +-
 drivers/md/bitmap.c                                |   2 +-
 drivers/md/raid5.c                                 |   4 +-
 drivers/media/pci/tw5864/tw5864-video.c            |   6 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |   7 +
 drivers/memory/emif.c                              |  33 +----
 drivers/message/fusion/mptscsih.c                  |  13 +-
 drivers/mmc/host/via-sdmmc.c                       |   3 +
 drivers/mtd/ubi/wl.c                               |  13 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   3 +
 drivers/net/ethernet/renesas/ravb_main.c           |  10 +-
 drivers/net/gtp.c                                  |  16 +--
 drivers/net/wan/hdlc_fr.c                          |  98 ++++++-------
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   8 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   4 +
 drivers/net/wireless/intersil/p54/p54pci.c         |   4 +-
 drivers/nvme/host/rdma.c                           |   1 -
 drivers/power/supply/test_power.c                  |   6 +
 drivers/rtc/rtc-rx8010.c                           |  24 +++-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   1 +
 drivers/staging/fsl-mc/bus/mc-io.c                 |   7 +-
 drivers/staging/octeon/ethernet-mdio.c             |   6 -
 drivers/staging/octeon/ethernet-rx.c               |  34 +++--
 drivers/staging/octeon/ethernet.c                  |   9 ++
 drivers/staging/typec/pd.h                         |   1 +
 drivers/staging/typec/tcpm.c                       |   2 +-
 drivers/tty/vt/keyboard.c                          |  39 +++---
 drivers/tty/vt/vt_ioctl.c                          |  32 +++--
 drivers/uio/uio.c                                  |   4 +-
 drivers/usb/class/cdc-acm.c                        |  12 +-
 drivers/usb/class/cdc-acm.h                        |   3 +-
 drivers/usb/dwc3/core.c                            |  15 +-
 drivers/usb/dwc3/ep0.c                             |  11 +-
 drivers/usb/host/fsl-mph-dr-of.c                   |   9 +-
 drivers/usb/misc/adutux.c                          |   1 +
 drivers/vhost/vringh.c                             |   9 +-
 drivers/video/fbdev/pvr2fb.c                       |   2 +
 drivers/w1/masters/mxc_w1.c                        |  14 +-
 drivers/watchdog/rdc321x_wdt.c                     |   5 +-
 fs/9p/vfs_file.c                                   |   4 +-
 fs/btrfs/ctree.c                                   |   6 +
 fs/btrfs/reada.c                                   |   2 +
 fs/btrfs/send.c                                    |  74 +++++++++-
 fs/btrfs/tree-log.c                                |   8 ++
 fs/buffer.c                                        |  16 ---
 fs/cachefiles/rdwr.c                               |   3 +-
 fs/ceph/addr.c                                     |   2 +-
 fs/crypto/policy.c                                 |   3 +-
 fs/efivarfs/super.c                                |   3 +
 fs/ext4/inode.c                                    |  11 +-
 fs/ext4/namei.c                                    |   6 +-
 fs/ext4/resize.c                                   |   4 +-
 fs/ext4/super.c                                    |  17 +++
 fs/f2fs/checkpoint.c                               |   8 +-
 fs/f2fs/namei.c                                    |   6 +-
 fs/fuse/dev.c                                      |  28 ++--
 fs/gfs2/ops_fstype.c                               |  18 ++-
 fs/nfs/namespace.c                                 |  12 +-
 fs/nfs/nfs4proc.c                                  |   9 +-
 fs/nfsd/nfsproc.c                                  |  16 +++
 fs/ubifs/debug.c                                   |   1 +
 fs/ubifs/dir.c                                     |   6 +-
 fs/xfs/xfs_rtalloc.c                               |  10 +-
 include/asm-generic/io.h                           |  39 ++++--
 include/linux/hil_mlc.h                            |   2 +-
 include/linux/mtd/pfow.h                           |   2 +-
 include/uapi/linux/nfs4.h                          |   3 +
 include/uapi/linux/videodev2.h                     |  17 ++-
 init/Kconfig                                       |   3 +-
 kernel/debug/debug_core.c                          |  22 +--
 kernel/futex.c                                     |   4 +-
 kernel/trace/ring_buffer.c                         |   8 +-
 lib/scatterlist.c                                  |   2 +-
 net/9p/trans_fd.c                                  |   2 +-
 net/ceph/messenger.c                               |   5 +
 net/tipc/msg.c                                     |   5 +-
 scripts/setlocalversion                            |  21 ++-
 tools/perf/util/print_binary.c                     |   2 +-
 131 files changed, 1227 insertions(+), 616 deletions(-)


