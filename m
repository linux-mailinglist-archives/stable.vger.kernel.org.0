Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A8927C469
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgI2LNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728469AbgI2LN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:13:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A86A21D46;
        Tue, 29 Sep 2020 11:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378003;
        bh=jqq52cS0S3YX4AxGaMScmrgvr1kgWyp4bNLfBiBoJSs=;
        h=From:To:Cc:Subject:Date:From;
        b=FGUeha1CkASTtp+wVJy1QaRsE0PxzQiq9DYbvBrO0MBMHPziponV/8v+EFqvFi7gl
         3YdRn8AMegbv/XUIbahf+jlh+l8P2sfelxe8Pl/sYWk/L6ZJ/ETIa5tZ/ZYOHltuz6
         WqHJChbzNA3+MN5BY64/th/sNwqM5AvDXGaO3ktg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.14 000/166] 4.14.200-rc1 review
Date:   Tue, 29 Sep 2020 12:58:32 +0200
Message-Id: <20200929105935.184737111@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.200-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.200-rc1
X-KernelTest-Deadline: 2020-10-01T10:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.200 release.
There are 166 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.200-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.200-rc1

Jiri Slaby <jslaby@suse.cz>
    ata: sata_mv, avoid trigerrable BUG_ON

Jiri Slaby <jslaby@suse.cz>
    ata: make qc_prep return ata_completion_errors

Jiri Slaby <jslaby@suse.cz>
    ata: define AC_ERR_OK

Nick Desaulniers <ndesaulniers@google.com>
    lib/string.c: implement stpcpy

Gao Xiang <hsiangkao@redhat.com>
    mm, THP, swap: fix allocating cluster for swapfile by mistake

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix zero write for FBA devices

Wei Li <liwei391@huawei.com>
    MIPS: Add the missing 'CPU_1074K' into __get_cpu_type()

Tom Rix <trix@redhat.com>
    ALSA: asihpi: fix iounmap in error handler

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh

Sven Eckelmann <sven@narfation.org>
    batman-adv: Add missing include for in_interrupt()

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: qed: RDMA personality shouldn't fail VF load

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/vc4/vc4_hdmi: fill ASoC card owner

Eric Dumazet <edumazet@google.com>
    mac802154: tx: fix use-after-free

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast/TT: fix wrongly dropped or rerouted packets

Jing Xiangfeng <jingxiangfeng@huawei.com>
    atm: eni: fix the missed pci_disable_device() for eni_init_one()

Linus Lüssing <ll@simonwunderlich.de>
    batman-adv: bla: fix type misuse for backbone_gw hash indexing

Maximilian Luz <luzmaximilian@gmail.com>
    mwifiex: Increase AES key storage size to 256 bits

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    clocksource/drivers/h8300_timer8: Fix wrong return value in h8300_8timer_init()

Tom Rix <trix@redhat.com>
    ieee802154/adf7242: check status of adf7242_read_reg

Liu Jian <liujian56@huawei.com>
    ieee802154: fix one possible memleak in ca8210_dev_com_init

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix noreturn detection for ignored functions

Hans de Goede <hdegoede@redhat.com>
    i2c: core: Call i2c_acpi_install_space_handler() before i2c_acpi_register_devices()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/init: add missing __init annotations

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: fix data leak caused by race between writeback and truncate

Zeng Tao <prime.zeng@hisilicon.com>
    vfio/pci: fix racy on error and request eventfd ctx

Andy Lutomirski <luto@kernel.org>
    selftests/x86/syscall_nt: Clear weird flags after each test

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Skip additional kref updating work event

Javed Hasan <jhasan@marvell.com>
    scsi: libfc: Handling of extra kref

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix double add page to memcg when cifs_readpages

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Clear error and request eventfd ctx after releasing

Thomas Gleixner <tglx@linutronix.de>
    x86/speculation/mds: Mark mds_user_clear_cpu_buffers() __always_inline

Boris Brezillon <boris.brezillon@collabora.com>
    mtd: parser: cmdline: Support MTD names containing one or more colons

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    rapidio: avoid data race between file operation callbacks and mport_cdev_add().

Qian Cai <cai@lca.pw>
    mm/swap_state: fix a data race in swapin_nr_pages

Jeff Layton <jlayton@kernel.org>
    ceph: fix potential race in ceph_check_caps

Dinghao Liu <dinghao.liu@zju.edu.cn>
    mtd: rawnand: omap_elm: Fix runtime PM imbalance on error

Adrian Hunter <adrian.hunter@intel.com>
    perf kcore_copy: Fix module map when there are no modules loaded

Xie XiuQi <xiexiuqi@huawei.com>
    perf util: Fix memory leak of prefix_if_not_in

Qian Cai <cai@lca.pw>
    vfio/pci: fix memory leaks of eventfd ctx

David Sterba <dsterba@suse.com>
    btrfs: don't force read-only after error in drop snapshot

Yu Chen <chenyu56@huawei.com>
    usb: dwc3: Increase timeout for CmdAct cleared by device controller

Shreyas Joshi <shreyas.joshi@biamp.com>
    printk: handle blank console arguments passed in.

Dinghao Liu <dinghao.liu@zju.edu.cn>
    drm/nouveau/debugfs: fix runtime pm imbalance on error

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    e1000: Do not perform reset in reset_task if we are already down

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/cpufeature: Drop TraceFilt feature exposure from ID_DFR0 register

Colin Ian King <colin.king@canonical.com>
    USB: EHCI: ehci-mv: fix less than zero comparison of an unsigned int

Miklos Szeredi <mszeredi@redhat.com>
    fuse: don't check refcount after stealing page

Nicholas Piggin <npiggin@gmail.com>
    powerpc/traps: Make unrecoverable NMIs die instead of panic

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix potential race in unsol event handler

Jonathan Bakker <xc-racer2@live.ca>
    tty: serial: samsung: Correct clock selection logic

Tang Bin <tangbin@cmss.chinamobile.com>
    USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()

Sonny Sasaka <sonnysasaka@chromium.org>
    Bluetooth: Handle Inquiry Cancel error after Inquiry Complete

Jonathan Bakker <xc-racer2@live.ca>
    phy: samsung: s5pv210-usb2: Add delay after reset

Jonathan Bakker <xc-racer2@live.ca>
    power: supply: max17040: Correct voltage reading

Cong Wang <xiyou.wangcong@gmail.com>
    atm: fix a memory leak of vcc->user_back

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: sound: wm8994: Correct required supplies based on actual implementaion

Will Deacon <will@kernel.org>
    arm64: cpufeature: Relax checks for AArch32 support at EL[0-2]

Wei Yongjun <weiyongjun1@huawei.com>
    sparc64: vcc: Fix error return code in vcc_probe()

Ivan Safonov <insafonov@gmail.com>
    staging:r8188eu: avoid skb_clone for amsdu to msdu conversion

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    drivers: char: tlclk.c: Avoid data race between init and interrupt handler

Douglas Anderson <dianders@chromium.org>
    bdev: Reduce time holding bd_mutex in sync in blkdev_close()

Steve Rutherford <srutherford@google.com>
    KVM: Remove CREATE_IRQCHIP/SET_PIT2 race

Raviteja Narayanam <raviteja.narayanam@xilinx.com>
    serial: uartps: Wait for tx_empty in console setup

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Fix termination timeouts in session logout

Jaewon Kim <jaewon31.kim@samsung.com>
    mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area

Qian Cai <cai@lca.pw>
    mm/vmscan.c: fix data races using kswapd_classzone_idx

Xianting Tian <xianting_tian@126.com>
    mm/filemap.c: clear page error before actual read

Nathan Chancellor <natechancellor@gmail.com>
    mm/kmemleak.c: use address-of operator on section symbols

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix races nfs_page_group_destroy() vs nfs_destroy_unlinked_subrequests()

Andreas Steinmetz <ast@domdv.de>
    ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor

Liu Song <liu.song11@zte.com.cn>
    ubifs: Fix out-of-bounds memory access caused by abnormal value of node_len

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix leak of transport addresses

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    SUNRPC: Fix a potential buffer overflow in 'svc_print_xprts()'

Zhu Yanjun <yanjunz@mellanox.com>
    RDMA/rxe: Set sys_image_guid to be aligned with HW IB devices

Gabriel Ravier <gabravier@gmail.com>
    tools: gpio-hammer: Avoid potential overflow in main

Pratik Rajesh Sampat <psampat@linux.ibm.com>
    cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_work_fn

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    perf cpumap: Fix snprintf overflow check

Vignesh Raghavendra <vigneshr@ti.com>
    serial: 8250: 8250_omap: Terminate DMA before pushing data on RX timeout

Peter Ujfalusi <peter.ujfalusi@ti.com>
    serial: 8250_omap: Fix sleeping function called from invalid context during probe

Vignesh Raghavendra <vigneshr@ti.com>
    serial: 8250_port: Don't service RX FIFO if throttled

Nathan Chancellor <natechancellor@gmail.com>
    tracing: Use address-of operator on section symbols

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: ds1374: fix possible race condition

Stefan Berger <stefanb@linux.ibm.com>
    tpm: ibmvtpm: Wait for buffer to be set before proceeding

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: don't ever return a stale pointer from __xfs_dir3_free_read

Colin Ian King <colin.king@canonical.com>
    media: tda10071: fix unsigned sign extension overflow

Howard Chung <howardchung@google.com>
    Bluetooth: L2CAP: handle l2cap config request during open state

Sagar Biradar <Sagar.Biradar@microchip.com>
    scsi: aacraid: Disabling TM path and only processing IOP reset

Wen Gong <wgong@codeaurora.org>
    ath10k: use kzalloc to read for ath10k_sdio_hif_diag_read

John Clements <john.clements@amd.com>
    drm/amdgpu: increase atombios cmd timeout

Kirill A. Shutemov <kirill@shutemov.name>
    mm: avoid data corruption on CoW fault into PFN-mapped VMA

Qiujun Huang <hqjagain@gmail.com>
    ext4: fix a data race at inode->i_disksize

Wen Yang <wenyang@linux.alibaba.com>
    timekeeping: Prevent 32bit truncation in scale64_check_overflow()

Alain Michaud <alainm@chromium.org>
    Bluetooth: guard against controllers sending zero'd events

Takashi Iwai <tiwai@suse.de>
    media: go7007: Fix URB type for interrupt handling

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Prevent race conditions on channel's freeing

Thomas Gleixner <tglx@linutronix.de>
    bpf: Remove recursion prevention from rcu free callback

Dave Hansen <dave.hansen@linux.intel.com>
    x86/pkeys: Add check for pkey "overflow"

Dan Carpenter <dan.carpenter@oracle.com>
    media: staging/imx: Missing assignment in imx_media_capture_device_register()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix incorrect comparison in trace event

Bart Van Assche <bvanassche@acm.org>
    RDMA/rxe: Fix configuration of atomic queue pair attributes

Thomas Richter <tmricht@linux.ibm.com>
    perf test: Fix test trace+probe_vfs_getname.sh on s390

Wen Yang <wen.yang99@zte.com.cn>
    drm/omap: fix possible object reference leak

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix coverity errors in fmdi attribute handling

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix RQ buffer leakage when no IOCBs available

Vasily Averin <vvs@virtuozzo.com>
    selinux: sel_avc_get_stat_idx should increase position index

Steve Grubb <sgrubb@redhat.com>
    audit: CONFIG_CHANGE don't log internal bookkeeping as an event

Qian Cai <cai@lca.pw>
    skbuff: fix a data race in skb_queue_len()

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda: Clear RIRB status before reading WP

Zhuang Yanying <ann.zhuangyanying@huawei.com>
    KVM: fix overflow of zero page refcount with ksm running

Hillf Danton <hdanton@sina.com>
    Bluetooth: prefetch channel before killing sock

Steven Price <steven.price@arm.com>
    mm: pagewalk: fix termination condition in walk_pte_range()

Manish Mandlik <mmandlik@google.com>
    Bluetooth: Fix refcount use-after-free issue

Doug Smythies <doug.smythies@gmail.com>
    tools/power/x86/intel_pstate_tracer: changes for python 3 compatibility

Sven Schnelle <svens@linux.ibm.com>
    selftests/ftrace: fix glob selftest

Mert Dirik <mertdirik@gmail.com>
    ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter

Josef Bacik <jbacik@fb.com>
    tracing: Set kernel_stack's caller size properly

Oliver O'Halloran <oohall@gmail.com>
    powerpc/eeh: Only dump stack once if an MMIO loop is detected

Matthias Fend <matthias.fend@wolfvision.net>
    dmaengine: zynqmp_dma: fix burst length configuration

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Reference count query handlers under lock

Nikhil Devshatwar <nikhil.nd@ti.com>
    media: ti-vpe: cal: Restrict DMA to avoid memory corruption

Marco Elver <elver@google.com>
    seqlock: Require WRITE_ONCE surrounding raw_seqcount_barrier

Vasily Averin <vvs@virtuozzo.com>
    rt_cpu_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    neigh_stat_seq_next() should increase position index

Joe Perches <joe@perches.com>
    kernel/sys.c: avoid copying possible padding bytes in copy_to_user

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Properly process SMB3 lease breaks

Kusanagi Kouichi <slash@ac.auone-net.jp>
    debugfs: Fix !DEBUG_FS debugfs_create_automount

Bob Peterson <rpeterso@redhat.com>
    gfs2: clean up iopen glock mess in gfs2_create_inode

Bradley Bolen <bradleybolen@gmail.com>
    mmc: core: Fix size overflow for mmc partitions

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    RDMA/iw_cgxb4: Fix an error handling path in 'c4iw_connect()'

Brian Foster <bfoster@redhat.com>
    xfs: fix attr leaf header freemap.size underflow

Pan Bian <bianpan2016@163.com>
    RDMA/i40iw: Fix potential use after free

Guoju Fang <fangguoju@gmail.com>
    bcache: fix a lost wake-up problem caused by mca_cannibalize_lock

Divya Indi <divya.indi@oracle.com>
    tracing: Adding NULL checks for trace_array descriptor pointer

Lee Jones <lee.jones@linaro.org>
    mfd: mfd-core: Protect against NULL call-back function pointer

Hou Tao <houtao1@huawei.com>
    mtd: cfi_cmdset_0002: don't free cfi->cfiq in error path of cfi_amdstd_setup()

Stephen Kitt <steve@sk2.org>
    clk/ti/adpll: allocate room for terminating null

Pan Bian <bianpan2016@163.com>
    scsi: fnic: fix use after free

Dmitry Osipenko <digetx@gmail.com>
    PM / devfreq: tegra30: Fix integer overflow on CPU's freq max out

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Couldn't detect Mic if booting with headset plugged

Joakim Tjernlund <joakim.tjernlund@infinera.com>
    ALSA: usb-audio: Add delay quirk for H570e USB headsets

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Unbreak check_timer()

Mikulas Patocka <mpatocka@redhat.com>
    arch/x86/lib/usercopy_64.c: fix __copy_user_flushcache() cache writeback

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: smiapp: Fix error handling at NVM reading

Russell King <rmk+kernel@armlinux.org.uk>
    ASoC: kirkwood: fix IRQ error handling

Kangjie Lu <kjlu@umn.edu>
    gma/gma500: fix a memory disclosure bug due to uninitialized bytes

Fuqian Huang <huangfq.daxian@gmail.com>
    m68k: q40: Fix info-leak in rtc_ioctl

Balsundar P <balsundar.p@microsemi.com>
    scsi: aacraid: fix illegal IO beyond last LBA

Jia He <justin.he@arm.com>
    mm: fix double page fault on arm64 if PTE_AF is cleared

Lukas Wunner <lukas@wunner.de>
    serial: 8250: Avoid error message on reprobe

Mark Gray <mark.d.gray@redhat.com>
    geneve: add transport ports in route lookup for geneve

David Ahern <dsahern@kernel.org>
    ipv4: Update exception handling for multipath routes via same device

Eric Dumazet <edumazet@google.com>
    net: add __must_check to skb_put_padto()

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: Avoid NPD upon phy_detach() when driver is unbound

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.

Xin Long <lucien.xin@gmail.com>
    tipc: use skb_unshare() instead in tipc_buf_append()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tipc: fix shutdown() of connection oriented socket

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    net: ipv6: fix kconfig dependency warning for IPV6_SEG6_HMAC

Wei Wang <weiwan@google.com>
    ip: fix tos reflection in ack and reset packets

Dan Carpenter <dan.carpenter@oracle.com>
    hdlc_ppp: add range checks in ppp_cp_parse_cr()

Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
    RDMA/ucma: ucma_context reference leak in error path

Ralph Campbell <rcampbell@nvidia.com>
    mm/thp: fix __split_huge_pmd_locked() for migration PMD

Muchun Song <songmuchun@bytedance.com>
    kprobes: fix kill kprobe which has been marked as gone

Rustam Kovhaev <rkovhaev@gmail.com>
    KVM: fix memory leak in kvm_io_bus_unregister_dev()

Sivaprakash Murugesan <sivaprak@codeaurora.org>
    phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init

Mark Salyzyn <salyzyn@android.com>
    af_key: pfkey_dump needs parameter validation


-------------

Diffstat:

 Documentation/devicetree/bindings/sound/wm8994.txt |  18 ++-
 Documentation/driver-api/libata.rst                |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/kernel/cpufeature.c                     |  12 +-
 arch/m68k/q40/config.c                             |   1 +
 arch/mips/include/asm/cpu-type.h                   |   1 +
 arch/powerpc/kernel/eeh.c                          |   2 +-
 arch/powerpc/kernel/traps.c                        |   6 +-
 arch/s390/kernel/setup.c                           |   6 +-
 arch/x86/include/asm/nospec-branch.h               |   4 +-
 arch/x86/include/asm/pkeys.h                       |   5 +
 arch/x86/kernel/apic/io_apic.c                     |   1 +
 arch/x86/kernel/fpu/xstate.c                       |   9 +-
 arch/x86/kvm/mmutrace.h                            |   2 +-
 arch/x86/kvm/x86.c                                 |  10 +-
 arch/x86/lib/usercopy_64.c                         |   2 +-
 drivers/acpi/ec.c                                  |  16 +--
 drivers/ata/acard-ahci.c                           |   6 +-
 drivers/ata/libahci.c                              |   6 +-
 drivers/ata/libata-core.c                          |   9 +-
 drivers/ata/libata-sff.c                           |  12 +-
 drivers/ata/pata_macio.c                           |   6 +-
 drivers/ata/pata_pxa.c                             |   8 +-
 drivers/ata/pdc_adma.c                             |   7 +-
 drivers/ata/sata_fsl.c                             |   4 +-
 drivers/ata/sata_inic162x.c                        |   4 +-
 drivers/ata/sata_mv.c                              |  34 ++---
 drivers/ata/sata_nv.c                              |  18 +--
 drivers/ata/sata_promise.c                         |   6 +-
 drivers/ata/sata_qstor.c                           |   8 +-
 drivers/ata/sata_rcar.c                            |   6 +-
 drivers/ata/sata_sil.c                             |   8 +-
 drivers/ata/sata_sil24.c                           |   6 +-
 drivers/ata/sata_sx4.c                             |   6 +-
 drivers/atm/eni.c                                  |   2 +-
 drivers/char/tlclk.c                               |  17 +--
 drivers/char/tpm/tpm_ibmvtpm.c                     |   9 ++
 drivers/char/tpm/tpm_ibmvtpm.h                     |   1 +
 drivers/clk/ti/adpll.c                             |  11 +-
 drivers/clocksource/h8300_timer8.c                 |   2 +-
 drivers/cpufreq/powernv-cpufreq.c                  |  13 +-
 drivers/devfreq/tegra-devfreq.c                    |   4 +-
 drivers/dma/tegra20-apb-dma.c                      |   3 +-
 drivers/dma/xilinx/zynqmp_dma.c                    |  24 ++--
 drivers/gpu/drm/amd/amdgpu/atom.c                  |   4 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |   2 +
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |   5 +-
 drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c    |   4 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   1 +
 drivers/i2c/i2c-core-base.c                        |   2 +-
 drivers/infiniband/core/ucma.c                     |   6 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   2 +-
 drivers/infiniband/sw/rxe/rxe.c                    |   2 +
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   7 +-
 drivers/md/bcache/bcache.h                         |   1 +
 drivers/md/bcache/btree.c                          |  12 +-
 drivers/md/bcache/super.c                          |   1 +
 drivers/media/dvb-frontends/tda10071.c             |   9 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   3 +-
 drivers/media/platform/ti-vpe/cal.c                |   6 +-
 drivers/media/usb/go7007/go7007-usb.c              |   4 +-
 drivers/mfd/mfd-core.c                             |  10 ++
 drivers/mmc/core/mmc.c                             |   9 +-
 drivers/mtd/chips/cfi_cmdset_0002.c                |   1 -
 drivers/mtd/cmdlinepart.c                          |  23 +++-
 drivers/mtd/nand/omap_elm.c                        |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  31 +++--
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  18 ++-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   1 +
 drivers/net/geneve.c                               |  37 ++++--
 drivers/net/ieee802154/adf7242.c                   |   4 +-
 drivers/net/ieee802154/ca8210.c                    |   1 +
 drivers/net/phy/phy_device.c                       |   3 +-
 drivers/net/wan/hdlc_ppp.c                         |  16 ++-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   2 +
 drivers/net/wireless/ath/ath10k/sdio.c             |  18 ++-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   4 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |  18 +--
 drivers/phy/samsung/phy-s5pv210-usb2.c             |   4 +
 drivers/power/supply/max17040_battery.c            |   2 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  14 +--
 drivers/rtc/rtc-ds1374.c                           |  15 ++-
 drivers/s390/block/dasd_fba.c                      |   9 +-
 drivers/scsi/aacraid/aachba.c                      |   8 +-
 drivers/scsi/aacraid/commsup.c                     |   2 +-
 drivers/scsi/aacraid/linit.c                       |  34 +++--
 drivers/scsi/fnic/fnic_scsi.c                      |   3 +-
 drivers/scsi/libfc/fc_rport.c                      |  13 +-
 drivers/scsi/lpfc/lpfc_ct.c                        | 137 +++++++++++----------
 drivers/scsi/lpfc/lpfc_hw.h                        |  36 +++---
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +
 drivers/scsi/qedi/qedi_iscsi.c                     |   3 +
 drivers/staging/media/imx/imx-media-capture.c      |   2 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |  19 +--
 drivers/tty/serial/8250/8250_core.c                |  11 +-
 drivers/tty/serial/8250/8250_omap.c                |   8 +-
 drivers/tty/serial/8250/8250_port.c                |  16 ++-
 drivers/tty/serial/samsung.c                       |   8 +-
 drivers/tty/serial/xilinx_uartps.c                 |   8 ++
 drivers/tty/vcc.c                                  |   1 +
 drivers/usb/dwc3/gadget.c                          |   2 +-
 drivers/usb/host/ehci-mv.c                         |   8 +-
 drivers/vfio/pci/vfio_pci.c                        |  13 ++
 fs/block_dev.c                                     |  10 ++
 fs/btrfs/extent-tree.c                             |   2 -
 fs/btrfs/inode.c                                   |  23 ++--
 fs/ceph/caps.c                                     |  14 ++-
 fs/cifs/cifsglob.h                                 |   9 +-
 fs/cifs/file.c                                     |  21 ++--
 fs/cifs/misc.c                                     |  17 +--
 fs/cifs/smb1ops.c                                  |   8 +-
 fs/cifs/smb2misc.c                                 |  32 ++---
 fs/cifs/smb2ops.c                                  |  44 ++++---
 fs/cifs/smb2pdu.h                                  |   2 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/fuse/dev.c                                      |   1 -
 fs/gfs2/inode.c                                    |  13 +-
 fs/nfs/pagelist.c                                  |  67 ++++++----
 fs/nfs/write.c                                     |  10 +-
 fs/ubifs/io.c                                      |  16 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   4 +-
 fs/xfs/libxfs/xfs_dir2_node.c                      |   1 +
 include/linux/debugfs.h                            |   5 +-
 include/linux/libata.h                             |  13 +-
 include/linux/mmc/card.h                           |   2 +-
 include/linux/nfs_page.h                           |   2 +
 include/linux/seqlock.h                            |  11 +-
 include/linux/skbuff.h                             |  21 +++-
 kernel/audit_watch.c                               |   2 -
 kernel/bpf/hashtab.c                               |   8 --
 kernel/kprobes.c                                   |  14 ++-
 kernel/printk/printk.c                             |   3 +
 kernel/sys.c                                       |   4 +-
 kernel/time/timekeeping.c                          |   3 +-
 kernel/trace/trace.c                               |   5 +-
 kernel/trace/trace_entries.h                       |   2 +-
 kernel/trace/trace_events.c                        |   2 +
 lib/string.c                                       |  24 ++++
 mm/filemap.c                                       |   8 ++
 mm/huge_memory.c                                   |  40 +++---
 mm/kmemleak.c                                      |   2 +-
 mm/memory.c                                        | 121 +++++++++++++++---
 mm/mmap.c                                          |   2 +
 mm/pagewalk.c                                      |   4 +-
 mm/swap_state.c                                    |   5 +-
 mm/swapfile.c                                      |   2 +-
 mm/vmscan.c                                        |  45 ++++---
 net/atm/lec.c                                      |   6 +
 net/batman-adv/bridge_loop_avoidance.c             |  42 +++++--
 net/batman-adv/bridge_loop_avoidance.h             |   4 +-
 net/batman-adv/routing.c                           |   4 +
 net/batman-adv/soft-interface.c                    |   6 +-
 net/bluetooth/hci_event.c                          |  25 +++-
 net/bluetooth/l2cap_core.c                         |  29 +++--
 net/bluetooth/l2cap_sock.c                         |  18 ++-
 net/core/neighbour.c                               |   1 +
 net/ipv4/ip_output.c                               |   3 +-
 net/ipv4/route.c                                   |  12 +-
 net/ipv6/Kconfig                                   |   1 +
 net/key/af_key.c                                   |   7 ++
 net/mac802154/tx.c                                 |   8 +-
 net/sunrpc/svc_xprt.c                              |  19 ++-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c         |   1 +
 net/tipc/msg.c                                     |   3 +-
 net/tipc/socket.c                                  |   5 +-
 net/unix/af_unix.c                                 |  11 +-
 security/selinux/selinuxfs.c                       |   1 +
 sound/hda/hdac_bus.c                               |   4 +
 sound/pci/asihpi/hpioctl.c                         |   4 +-
 sound/pci/hda/hda_controller.c                     |  11 +-
 sound/pci/hda/patch_realtek.c                      |   6 +-
 sound/soc/kirkwood/kirkwood-dma.c                  |   2 +-
 sound/usb/midi.c                                   |  29 ++++-
 sound/usb/quirks.c                                 |   7 +-
 tools/gpio/gpio-hammer.c                           |  17 ++-
 tools/objtool/check.c                              |   2 +-
 tools/perf/tests/shell/lib/probe_vfs_getname.sh    |   2 +-
 tools/perf/util/cpumap.c                           |  10 +-
 tools/perf/util/sort.c                             |   2 +-
 tools/perf/util/symbol-elf.c                       |   7 ++
 .../x86/intel_pstate_tracer/intel_pstate_tracer.py |  22 ++--
 .../ftrace/test.d/ftrace/func-filter-glob.tc       |   2 +-
 tools/testing/selftests/x86/syscall_nt.c           |   1 +
 virt/kvm/kvm_main.c                                |  22 ++--
 186 files changed, 1320 insertions(+), 677 deletions(-)


