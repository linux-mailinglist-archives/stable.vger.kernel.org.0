Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9033027CBEB
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgI2Mbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729348AbgI2LXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:23:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B49A2206DB;
        Tue, 29 Sep 2020 11:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378443;
        bh=Z/abO3Pnvg3XPs2V2JeGa1wb05Zl64RRfMha4rEPIzk=;
        h=From:To:Cc:Subject:Date:From;
        b=uWsqp9jUDleCebN6u0bmASE4+q1Y9VyAvqpPN40+S+ue1DLzqFgbZ9NIHxZrypP/U
         nnl5hP5Nmm7WE4XEOKBV3ohJY3hlIDC1nWqc/BFUFUaZkkbsUg93N+g/0PXGWPaX0e
         VsHBKCMLWxv+4AtiduV2ZMg21A9SjFjCpuNC7a9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.19 000/245] 4.19.149-rc1 review
Date:   Tue, 29 Sep 2020 12:57:31 +0200
Message-Id: <20200929105946.978650816@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.149-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.149-rc1
X-KernelTest-Deadline: 2020-10-01T10:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.149 release.
There are 245 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.149-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.149-rc1

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch

Jiri Slaby <jslaby@suse.cz>
    ata: sata_mv, avoid trigerrable BUG_ON

Jiri Slaby <jslaby@suse.cz>
    ata: make qc_prep return ata_completion_errors

Jiri Slaby <jslaby@suse.cz>
    ata: define AC_ERR_OK

Muchun Song <songmuchun@bytedance.com>
    kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/zcrypt: Fix ZCRYPT_PERDEV_REQCNT ioctl

Gao Xiang <hsiangkao@redhat.com>
    mm, THP, swap: fix allocating cluster for swapfile by mistake

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix zero write for FBA devices

Tom Rix <trix@redhat.com>
    tracing: fix double free

Tom Lendacky <thomas.lendacky@amd.com>
    KVM: SVM: Add a dedicated INVD intercept routine

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Reset MMU context if guest toggles CR4.SMAP or CR4.PKE

Wei Li <liwei391@huawei.com>
    MIPS: Add the missing 'CPU_1074K' into __get_cpu_type()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    regmap: fix page selection for noinc reads

Tom Rix <trix@redhat.com>
    ALSA: asihpi: fix iounmap in error handler

Yonghong Song <yhs@fb.com>
    bpf: Fix a rcu warning for bpffs map pretty-print

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh

Sven Eckelmann <sven@narfation.org>
    batman-adv: Add missing include for in_interrupt()

Martin Cerveny <m.cerveny@computer.org>
    drm/sun4i: sun8i-csc: Secondary CSC register correction

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: qed: RDMA personality shouldn't fail VF load

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/vc4/vc4_hdmi: fill ASoC card owner

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix clobbering of r2 in bpf_gen_ld_abs

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

Dennis Li <Dennis.Li@amd.com>
    drm/amdkfd: fix a memory leak issue

Sven Schnelle <svens@linux.ibm.com>
    lockdep: fix order in trace_hardirqs_off_caller()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/init: add missing __init annotations

Palmer Dabbelt <palmerdabbelt@google.com>
    RISC-V: Take text_mutex in ftrace_init_nop()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN Converter9 2-in-1

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: wm8994: Skip setting of the WM8994_MICBIAS register for WM1811

Anthony Iliopoulos <ailiop@suse.com>
    nvme: explicitly update mpath disk capacity on revalidation

Tonghao Zhang <xiangxia.m.yue@gmail.com>
    net: openvswitch: use div_u64() for 64-by-32 divisions

Jin Yao <yao.jin@linux.intel.com>
    perf parse-events: Use strcmp() to compare the PMU name

Hou Tao <houtao1@huawei.com>
    ubi: fastmap: Free unused fastmap anchor peb during detach

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

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix possible deadlock when I/O is blocked

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
    PCI: tegra: Fix runtime PM imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    mtd: rawnand: omap_elm: Fix runtime PM imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    wlcore: fix runtime pm imbalance in wlcore_regdomain_config

Dinghao Liu <dinghao.liu@zju.edu.cn>
    wlcore: fix runtime pm imbalance in wl1271_tx_work

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ASoC: img-i2s-out: Fix runtime PM imbalance on error

Adrian Hunter <adrian.hunter@intel.com>
    perf kcore_copy: Fix module map when there are no modules loaded

Ian Rogers <irogers@google.com>
    perf metricgroup: Free metric_events on error

Xie XiuQi <xiexiuqi@huawei.com>
    perf util: Fix memory leak of prefix_if_not_in

Jiri Olsa <jolsa@kernel.org>
    perf stat: Fix duration_time value for higher intervals

Ian Rogers <irogers@google.com>
    perf trace: Fix the selection for architectures to generate the errno name tables

Ian Rogers <irogers@google.com>
    perf evsel: Fix 2 memory leaks

Qian Cai <cai@lca.pw>
    vfio/pci: fix memory leaks of eventfd ctx

David Sterba <dsterba@suse.com>
    btrfs: don't force read-only after error in drop snapshot

Yu Chen <chenyu56@huawei.com>
    usb: dwc3: Increase timeout for CmdAct cleared by device controller

Shreyas Joshi <shreyas.joshi@biamp.com>
    printk: handle blank console arguments passed in.

Dinghao Liu <dinghao.liu@zju.edu.cn>
    drm/nouveau/dispnv50: fix runtime pm imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    drm/nouveau: fix runtime pm imbalance on error

Dinghao Liu <dinghao.liu@zju.edu.cn>
    drm/nouveau/debugfs: fix runtime pm imbalance on error

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    e1000: Do not perform reset in reset_task if we are already down

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/cpufeature: Drop TraceFilt feature exposure from ID_DFR0 register

Wei Yongjun <weiyongjun1@huawei.com>
    scsi: cxlflash: Fix error return code in cxlflash_probe()

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

Tuong Lien <tuong.t.lien@dektech.com.au>
    tipc: fix memory leak in service subscripting

Tang Bin <tangbin@cmss.chinamobile.com>
    USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()

Sonny Sasaka <sonnysasaka@chromium.org>
    Bluetooth: Handle Inquiry Cancel error after Inquiry Complete

Jonathan Bakker <xc-racer2@live.ca>
    phy: samsung: s5pv210-usb2: Add delay after reset

Jonathan Bakker <xc-racer2@live.ca>
    power: supply: max17040: Correct voltage reading

Ian Rogers <irogers@google.com>
    perf mem2node: Avoid double free related to realloc

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: aacraid: Fix error handling paths in aac_probe_one()

Tonghao Zhang <xiangxia.m.yue@gmail.com>
    net: openvswitch: use u64 for meter bucket

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm64: vgic-its: Fix memory leak on the error path of vgic_add_lpi()

Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
    drivers: char: tlclk.c: Avoid data race between init and interrupt handler

Douglas Anderson <dianders@chromium.org>
    bdev: Reduce time holding bd_mutex in sync in blkdev_close()

Stephane Eranian <eranian@google.com>
    perf stat: Force error in fallback on :k events

Steve Rutherford <srutherford@google.com>
    KVM: Remove CREATE_IRQCHIP/SET_PIT2 race

Raviteja Narayanam <raviteja.narayanam@xilinx.com>
    serial: uartps: Wait for tx_empty in console setup

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Fix termination timeouts in session logout

Jaewon Kim <jaewon31.kim@samsung.com>
    mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area

Israel Rukshin <israelr@mellanox.com>
    nvmet-rdma: fix double free of rdma queue

Qian Cai <cai@lca.pw>
    mm/vmscan.c: fix data races using kswapd_classzone_idx

Xianting Tian <xianting_tian@126.com>
    mm/filemap.c: clear page error before actual read

Nathan Chancellor <natechancellor@gmail.com>
    mm/kmemleak.c: use address-of operator on section symbols

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix races nfs_page_group_destroy() vs nfs_destroy_unlinked_subrequests()

Stuart Hayes <stuart.w.hayes@gmail.com>
    PCI: pciehp: Fix MSI interrupt race

Andreas Steinmetz <ast@domdv.de>
    ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor

Liu Song <liu.song11@zte.com.cn>
    ubifs: Fix out-of-bounds memory access caused by abnormal value of node_len

Mikel Rychliski <mikel@mikelr.com>
    PCI: Use ioremap(), not phys_to_virt() for platform ROM

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Fix leak of transport addresses

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    SUNRPC: Fix a potential buffer overflow in 'svc_print_xprts()'

Don Brace <don.brace@microsemi.com>
    scsi: hpsa: correct race condition in offload enabled

Zhu Yanjun <yanjunz@mellanox.com>
    RDMA/rxe: Set sys_image_guid to be aligned with HW IB devices

Israel Rukshin <israelr@mellanox.com>
    nvme: Fix controller creation races with teardown flow

John Meneghini <johnm@netapp.com>
    nvme-multipath: do not reset on unknown status

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

Ian Rogers <irogers@google.com>
    perf parse-events: Fix 3 use after frees found with clang ASAN

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    thermal: rcar_thermal: Handle probe error gracefully

Nathan Chancellor <natechancellor@gmail.com>
    tracing: Use address-of operator on section symbols

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm/a5xx: Always set an OPP supported hardware value

Pavel Machek <pavel@denx.de>
    drm/msm: fix leaks if initialization fails

Gustavo Romero <gromero@linux.ibm.com>
    KVM: PPC: Book3S HV: Treat TM-related invalid form instructions on P9 like the valid ones

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/cm: Remove a race freeing timewait_info

Trond Myklebust <trondmy@gmail.com>
    nfsd: Don't add locks to closed or closing open stateids

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: ds1374: fix possible race condition

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: sa1100: fix possible race condition

Stefan Berger <stefanb@linux.ibm.com>
    tpm: ibmvtpm: Wait for buffer to be set before proceeding

Dmitry Monakhov <dmonakhov@gmail.com>
    ext4: mark block bitmap corrupted when found instead of BUGON

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: mark dir corrupt when lookup-by-hash fails

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

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Stop if retimer is not available

John Clements <john.clements@amd.com>
    drm/amdgpu: increase atombios cmd timeout

Kirill A. Shutemov <kirill@shutemov.name>
    mm: avoid data corruption on CoW fault into PFN-mapped VMA

John Garry <john.garry@huawei.com>
    perf jevents: Fix leak of mapfile memory

Qiujun Huang <hqjagain@gmail.com>
    ext4: fix a data race at inode->i_disksize

Wen Yang <wenyang@linux.alibaba.com>
    timekeeping: Prevent 32bit truncation in scale64_check_overflow()

Alain Michaud <alainm@chromium.org>
    Bluetooth: guard against controllers sending zero'd events

Takashi Iwai <tiwai@suse.de>
    media: go7007: Fix URB type for interrupt handling

John Garry <john.garry@huawei.com>
    bus: hisi_lpc: Fixup IO ports addresses to avoid use-after-free in host removal

Qian Cai <cai@lca.pw>
    random: fix data races at timer_rand_state

James Morse <james.morse@arm.com>
    firmware: arm_sdei: Use cpus_read_lock() to avoid races with cpuhp

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: dal_ddc_i2c_payloads_create can fail causing panic

Dmitry Osipenko <digetx@gmail.com>
    dmaengine: tegra-apb: Prevent race conditions on channel's freeing

Amelie Delaunay <amelie.delaunay@st.com>
    dmaengine: stm32-dma: use vchan_terminate_vdesc() in .terminate_all

Thomas Gleixner <tglx@linutronix.de>
    bpf: Remove recursion prevention from rcu free callback

Dave Hansen <dave.hansen@linux.intel.com>
    x86/pkeys: Add check for pkey "overflow"

Dan Carpenter <dan.carpenter@oracle.com>
    media: staging/imx: Missing assignment in imx_media_capture_device_register()

Amelie Delaunay <amelie.delaunay@st.com>
    dmaengine: stm32-mdma: use vchan_terminate_vdesc() in .terminate_all

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix incorrect comparison in trace event

Bart Van Assche <bvanassche@acm.org>
    RDMA/rxe: Fix configuration of atomic queue pair attributes

Thomas Richter <tmricht@linux.ibm.com>
    perf test: Fix test trace+probe_vfs_getname.sh on s390

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't create a mixer element with bogus volume range

Felix Fietkau <nbd@nbd.name>
    mt76: clear skb pointers from rx aggregation reorder buffer during cleanup

Ayush Sawal <ayush.sawal@chelsio.com>
    crypto: chelsio - This fixes the kernel panic which occurs during a libkcapi test

Dinh Nguyen <dinguyen@kernel.org>
    clk: stratix10: use do_div() for 64-bit calculation

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

Vasily Averin <vvs@virtuozzo.com>
    mm/swapfile.c: swap_next should increase position index

Manish Mandlik <mmandlik@google.com>
    Bluetooth: Fix refcount use-after-free issue

Doug Smythies <doug.smythies@gmail.com>
    tools/power/x86/intel_pstate_tracer: changes for python 3 compatibility

Sven Schnelle <svens@linux.ibm.com>
    selftests/ftrace: fix glob selftest

Jeff Layton <jlayton@kernel.org>
    ceph: ensure we have a new cap before continuing in fill_inode

Mert Dirik <mertdirik@gmail.com>
    ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter

Vincent Whitchurch <vincent.whitchurch@axis.com>
    ARM: 8948/1: Prevent OOB access in stacktrace

Josef Bacik <jbacik@fb.com>
    tracing: Set kernel_stack's caller size properly

Maxim Mikityanskiy <maxtram95@gmail.com>
    Bluetooth: btrtl: Use kvmalloc for FW allocations

Oliver O'Halloran <oohall@gmail.com>
    powerpc/eeh: Only dump stack once if an MMIO loop is detected

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Use kzalloc and minor changes

Matthias Fend <matthias.fend@wolfvision.net>
    dmaengine: zynqmp_dma: fix burst length configuration

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Fix a race condition in the tracing code

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Make ufshcd_add_command_trace() easier to read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Reference count query handlers under lock

Kevin Kou <qdkevin.kou@gmail.com>
    sctp: move trace_sctp_probe_path into sctp_outq_sack

Nikhil Devshatwar <nikhil.nd@ti.com>
    media: ti-vpe: cal: Restrict DMA to avoid memory corruption

Marco Elver <elver@google.com>
    seqlock: Require WRITE_ONCE surrounding raw_seqcount_barrier

Vasily Averin <vvs@virtuozzo.com>
    ipv6_route_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    rt_cpu_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    neigh_stat_seq_next() should increase position index

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: fix log reservation overflows when allocating large rt extents

Miaohe Lin <linmiaohe@huawei.com>
    KVM: arm/arm64: vgic: Fix potential double free dist->spis in __kvm_vgic_destroy()

Joe Perches <joe@perches.com>
    kernel/sys.c: avoid copying possible padding bytes in copy_to_user

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: max98090: remove msleep in PLL unlocked workaround

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Properly process SMB3 lease breaks

Kusanagi Kouichi <slash@ac.auone-net.jp>
    debugfs: Fix !DEBUG_FS debugfs_create_automount

peter chang <dpf@google.com>
    scsi: pm80xx: Cleanup command when a reset times out

Bob Peterson <rpeterso@redhat.com>
    gfs2: clean up iopen glock mess in gfs2_create_inode

Bradley Bolen <bradleybolen@gmail.com>
    mmc: core: Fix size overflow for mmc partitions

Sascha Hauer <s.hauer@pengutronix.de>
    ubi: Fix producing anchor PEBs

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    RDMA/iw_cgxb4: Fix an error handling path in 'c4iw_connect()'

Brian Foster <bfoster@redhat.com>
    xfs: fix attr leaf header freemap.size underflow

Al Viro <viro@zeniv.linux.org.uk>
    fix dget_parent() fastpath race

Pan Bian <bianpan2016@163.com>
    RDMA/i40iw: Fix potential use after free

Pan Bian <bianpan2016@163.com>
    RDMA/qedr: Fix potential use after free

Satendra Singh Thakur <sst2005@gmail.com>
    dmaengine: mediatek: hsdma_probe: fixed a memory leak when devm_request_irq fails

Guoju Fang <fangguoju@gmail.com>
    bcache: fix a lost wake-up problem caused by mca_cannibalize_lock

Divya Indi <divya.indi@oracle.com>
    tracing: Adding NULL checks for trace_array descriptor pointer

Ivan Lazeev <ivan.lazeev@gmail.com>
    tpm_crb: fix fTPM on AMD Zen+ CPUs

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/powerplay/smu7: fix AVFS handling with custom powerplay table

Lee Jones <lee.jones@linaro.org>
    mfd: mfd-core: Protect against NULL call-back function pointer

Hou Tao <houtao1@huawei.com>
    mtd: cfi_cmdset_0002: don't free cfi->cfiq in error path of cfi_amdstd_setup()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/powerplay: fix AVFS handling with custom powerplay table

Stephen Kitt <steve@sk2.org>
    clk/ti/adpll: allocate room for terminating null

Eric Dumazet <edumazet@google.com>
    net: silence data-races on sk_backlog.tail

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix kernel crash at lpfc_nvme_info_show during remote port bounce

Pan Bian <bianpan2016@163.com>
    scsi: fnic: fix use after free

Dmitry Osipenko <digetx@gmail.com>
    PM / devfreq: tegra30: Fix integer overflow on CPU's freq max out

Oleh Kravchenko <oleg@kaa.org.ua>
    leds: mlxreg: Fix possible buffer overflow

Nick Desaulniers <ndesaulniers@google.com>
    lib/string.c: implement stpcpy

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Enable front panel headset LED on Lenovo ThinkStation P520

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

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix memory leak for tpc_stats_final

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix array out-of-bounds access

Chris Wilson <chris@chris-wilson.co.uk>
    dma-fence: Serialise signal enabling (dma_fence_enable_sw_signaling)

zhengbin <zhengbin13@huawei.com>
    media: mc-device.c: fix memleak in media_device_register_entity

Jonathan Lebon <jlebon@redhat.com>
    selinux: allow labeling before policy is loaded


-------------

Diffstat:

 Documentation/devicetree/bindings/sound/wm8994.txt |  18 ++-
 Documentation/driver-api/libata.rst                |   2 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/kvm_emulate.h                 |  11 +-
 arch/arm/kernel/stacktrace.c                       |   2 +
 arch/arm/kernel/traps.c                            |   6 +-
 arch/arm64/include/asm/kvm_emulate.h               |   9 +-
 arch/arm64/kernel/cpufeature.c                     |  12 +-
 arch/arm64/kvm/hyp/switch.c                        |   2 +-
 arch/m68k/q40/config.c                             |   1 +
 arch/mips/include/asm/cpu-type.h                   |   1 +
 arch/powerpc/include/asm/kvm_asm.h                 |   3 +
 arch/powerpc/kernel/eeh.c                          |   2 +-
 arch/powerpc/kernel/traps.c                        |   6 +-
 arch/powerpc/kvm/book3s_hv_tm.c                    |  28 +++-
 arch/powerpc/kvm/book3s_hv_tm_builtin.c            |  16 ++-
 arch/riscv/include/asm/ftrace.h                    |   7 +
 arch/riscv/kernel/ftrace.c                         |  19 +++
 arch/s390/kernel/perf_cpum_sf.c                    |   9 +-
 arch/s390/kernel/setup.c                           |   6 +-
 arch/x86/include/asm/nospec-branch.h               |   4 +-
 arch/x86/include/asm/pkeys.h                       |   5 +
 arch/x86/kernel/apic/io_apic.c                     |   1 +
 arch/x86/kernel/fpu/xstate.c                       |   9 +-
 arch/x86/kvm/mmutrace.h                            |   2 +-
 arch/x86/kvm/svm.c                                 |   8 +-
 arch/x86/kvm/x86.c                                 |  13 +-
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
 drivers/ata/sata_nv.c                              |  18 ++-
 drivers/ata/sata_promise.c                         |   6 +-
 drivers/ata/sata_qstor.c                           |   8 +-
 drivers/ata/sata_rcar.c                            |   6 +-
 drivers/ata/sata_sil.c                             |   8 +-
 drivers/ata/sata_sil24.c                           |   6 +-
 drivers/ata/sata_sx4.c                             |   6 +-
 drivers/atm/eni.c                                  |   2 +-
 drivers/base/regmap/regmap.c                       |  12 +-
 drivers/bluetooth/btrtl.c                          |  20 +--
 drivers/bus/hisi_lpc.c                             |  27 +++-
 drivers/char/random.c                              |  12 +-
 drivers/char/tlclk.c                               |  17 ++-
 drivers/char/tpm/tpm_crb.c                         | 123 ++++++++++++-----
 drivers/char/tpm/tpm_ibmvtpm.c                     |   9 ++
 drivers/char/tpm/tpm_ibmvtpm.h                     |   1 +
 drivers/clk/socfpga/clk-pll-s10.c                  |   4 +-
 drivers/clk/ti/adpll.c                             |  11 +-
 drivers/clocksource/h8300_timer8.c                 |   2 +-
 drivers/cpufreq/powernv-cpufreq.c                  |  13 +-
 drivers/crypto/chelsio/chcr_algo.c                 |   5 +-
 drivers/crypto/chelsio/chtls/chtls_io.c            |  10 +-
 drivers/devfreq/tegra-devfreq.c                    |   4 +-
 drivers/dma-buf/dma-fence.c                        |  78 +++++------
 drivers/dma/mediatek/mtk-hsdma.c                   |   4 +-
 drivers/dma/stm32-dma.c                            |   9 +-
 drivers/dma/stm32-mdma.c                           |   9 +-
 drivers/dma/tegra20-apb-dma.c                      |   3 +-
 drivers/dma/xilinx/zynqmp_dma.c                    |  24 ++--
 drivers/firmware/arm_sdei.c                        |  26 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |  31 +++--
 drivers/gpu/drm/amd/amdgpu/atom.c                  |   4 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   2 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  67 +++++-----
 drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c  |  52 ++++----
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c   |   7 +
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c |   7 +
 drivers/gpu/drm/gma500/cdv_intel_display.c         |   2 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  27 +++-
 drivers/gpu/drm/msm/msm_drv.c                      |   6 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_debugfs.c          |   5 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   4 +-
 .../gpu/drm/nouveau/nvkm/subdev/bios/shadowpci.c   |  17 ++-
 drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c    |   4 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |  30 +++--
 drivers/gpu/drm/sun4i/sun8i_csc.h                  |   2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   1 +
 drivers/i2c/i2c-core-base.c                        |   2 +-
 drivers/infiniband/core/cm.c                       |  25 ++--
 drivers/infiniband/hw/cxgb4/cm.c                   |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |   2 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |   2 +-
 drivers/infiniband/sw/rxe/rxe.c                    |   2 +
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   7 +-
 drivers/leds/leds-mlxreg.c                         |   4 +-
 drivers/md/bcache/bcache.h                         |   1 +
 drivers/md/bcache/btree.c                          |  12 +-
 drivers/md/bcache/super.c                          |   1 +
 drivers/media/dvb-frontends/tda10071.c             |   9 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   3 +-
 drivers/media/media-device.c                       |  65 ++++-----
 drivers/media/platform/ti-vpe/cal.c                |   6 +-
 drivers/media/usb/go7007/go7007-usb.c              |   4 +-
 drivers/mfd/mfd-core.c                             |  10 ++
 drivers/mmc/core/mmc.c                             |   9 +-
 drivers/mtd/chips/cfi_cmdset_0002.c                |   1 -
 drivers/mtd/cmdlinepart.c                          |  23 +++-
 drivers/mtd/nand/raw/omap_elm.c                    |   1 +
 drivers/mtd/ubi/fastmap-wl.c                       |  46 ++++---
 drivers/mtd/ubi/fastmap.c                          |  14 +-
 drivers/mtd/ubi/ubi.h                              |   6 +-
 drivers/mtd/ubi/wl.c                               |  32 ++---
 drivers/mtd/ubi/wl.h                               |   1 -
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  18 ++-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   1 +
 drivers/net/ieee802154/adf7242.c                   |   4 +-
 drivers/net/ieee802154/ca8210.c                    |   1 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |   2 +
 drivers/net/wireless/ath/ath10k/debug.c            |   3 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |  18 ++-
 drivers/net/wireless/ath/ath10k/wmi.c              |  49 ++++---
 drivers/net/wireless/marvell/mwifiex/fw.h          |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   4 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |   1 +
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/net/wireless/ti/wlcore/tx.c                |   1 +
 drivers/nvme/host/core.c                           |  12 +-
 drivers/nvme/host/multipath.c                      |  21 ++-
 drivers/nvme/host/nvme.h                           |  19 ++-
 drivers/nvme/target/rdma.c                         |  30 +++--
 drivers/pci/controller/pci-tegra.c                 |   3 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |  26 +++-
 drivers/pci/rom.c                                  |  17 ---
 drivers/phy/samsung/phy-s5pv210-usb2.c             |   4 +
 drivers/power/supply/max17040_battery.c            |   2 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  14 +-
 drivers/rtc/rtc-ds1374.c                           |  15 ++-
 drivers/rtc/rtc-sa1100.c                           |  18 +--
 drivers/s390/block/dasd_fba.c                      |   9 +-
 drivers/s390/crypto/zcrypt_api.c                   |   3 +-
 drivers/scsi/aacraid/aachba.c                      |   8 +-
 drivers/scsi/aacraid/commsup.c                     |   2 +-
 drivers/scsi/aacraid/linit.c                       |  46 +++++--
 drivers/scsi/cxlflash/main.c                       |   1 +
 drivers/scsi/fnic/fnic_scsi.c                      |   3 +-
 drivers/scsi/hpsa.c                                |  80 ++++++++----
 drivers/scsi/libfc/fc_rport.c                      |  13 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  35 ++---
 drivers/scsi/lpfc/lpfc_ct.c                        | 137 +++++++++----------
 drivers/scsi/lpfc/lpfc_hw.h                        |  36 +++--
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +
 drivers/scsi/pm8001/pm8001_sas.c                   |  50 +++++--
 drivers/scsi/qedi/qedi_iscsi.c                     |   3 +
 drivers/scsi/ufs/ufshcd.c                          |  14 +-
 drivers/staging/media/imx/imx-media-capture.c      |   2 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |  19 +--
 drivers/thermal/rcar_thermal.c                     |   6 +-
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
 fs/ceph/caps.c                                     |  14 +-
 fs/ceph/inode.c                                    |   5 +-
 fs/cifs/cifsglob.h                                 |   9 +-
 fs/cifs/file.c                                     |  21 ++-
 fs/cifs/misc.c                                     |  17 +--
 fs/cifs/smb1ops.c                                  |   8 +-
 fs/cifs/smb2misc.c                                 |  32 +----
 fs/cifs/smb2ops.c                                  |  44 +++++--
 fs/cifs/smb2pdu.h                                  |   2 +-
 fs/dcache.c                                        |   4 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |  11 +-
 fs/fuse/dev.c                                      |   1 -
 fs/gfs2/inode.c                                    |  13 +-
 fs/nfs/pagelist.c                                  |  67 ++++++----
 fs/nfs/write.c                                     |  10 +-
 fs/nfsd/nfs4state.c                                |  73 ++++++-----
 fs/ubifs/io.c                                      |  16 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   4 +-
 fs/xfs/libxfs/xfs_dir2_node.c                      |   1 +
 fs/xfs/libxfs/xfs_trans_resv.c                     |  96 +++++++++++---
 fs/xfs/scrub/dir.c                                 |   3 +
 include/linux/debugfs.h                            |   5 +-
 include/linux/libata.h                             |  13 +-
 include/linux/mmc/card.h                           |   2 +-
 include/linux/nfs_page.h                           |   2 +
 include/linux/pci.h                                |   1 -
 include/linux/seqlock.h                            |  11 +-
 include/linux/skbuff.h                             |  14 +-
 include/net/sock.h                                 |   4 +-
 include/trace/events/sctp.h                        |   9 --
 kernel/audit_watch.c                               |   2 -
 kernel/bpf/hashtab.c                               |   8 --
 kernel/bpf/inode.c                                 |   4 +-
 kernel/kprobes.c                                   |  22 +++-
 kernel/printk/printk.c                             |   3 +
 kernel/sys.c                                       |   4 +-
 kernel/time/timekeeping.c                          |   3 +-
 kernel/trace/trace.c                               |   5 +-
 kernel/trace/trace_entries.h                       |   2 +-
 kernel/trace/trace_events.c                        |   2 +
 kernel/trace/trace_events_hist.c                   |   1 -
 kernel/trace/trace_preemptirq.c                    |   4 +-
 lib/string.c                                       |  24 ++++
 mm/filemap.c                                       |   8 ++
 mm/kmemleak.c                                      |   2 +-
 mm/memory.c                                        | 121 +++++++++++++++--
 mm/mmap.c                                          |   2 +
 mm/pagewalk.c                                      |   4 +-
 mm/swap_state.c                                    |   5 +-
 mm/swapfile.c                                      |   4 +-
 mm/vmscan.c                                        |  45 ++++---
 net/atm/lec.c                                      |   6 +
 net/batman-adv/bridge_loop_avoidance.c             | 145 +++++++++++++++++----
 net/batman-adv/bridge_loop_avoidance.h             |   4 +-
 net/batman-adv/routing.c                           |   4 +
 net/batman-adv/soft-interface.c                    |   6 +-
 net/bluetooth/hci_event.c                          |  25 +++-
 net/bluetooth/l2cap_core.c                         |  29 +++--
 net/bluetooth/l2cap_sock.c                         |  18 ++-
 net/core/filter.c                                  |   4 +-
 net/core/neighbour.c                               |   1 +
 net/ipv4/route.c                                   |   1 +
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv6/ip6_fib.c                                 |   7 +-
 net/llc/af_llc.c                                   |   2 +-
 net/mac802154/tx.c                                 |   8 +-
 net/openvswitch/meter.c                            |   4 +-
 net/openvswitch/meter.h                            |   2 +-
 net/sctp/outqueue.c                                |   6 +
 net/sunrpc/svc_xprt.c                              |  19 ++-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c         |   1 +
 net/tipc/topsrv.c                                  |   4 +-
 net/unix/af_unix.c                                 |  11 +-
 security/selinux/hooks.c                           |  12 ++
 security/selinux/selinuxfs.c                       |   1 +
 sound/hda/hdac_bus.c                               |   4 +
 sound/pci/asihpi/hpioctl.c                         |   4 +-
 sound/pci/hda/hda_controller.c                     |  11 +-
 sound/pci/hda/patch_realtek.c                      |  13 +-
 sound/soc/codecs/max98090.c                        |   8 +-
 sound/soc/codecs/wm8994.c                          |  10 ++
 sound/soc/codecs/wm_hubs.c                         |   3 +
 sound/soc/codecs/wm_hubs.h                         |   1 +
 sound/soc/img/img-i2s-out.c                        |   8 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  10 ++
 sound/soc/kirkwood/kirkwood-dma.c                  |   2 +-
 sound/usb/midi.c                                   |  29 ++++-
 sound/usb/mixer.c                                  |  10 ++
 sound/usb/quirks.c                                 |   7 +-
 tools/gpio/gpio-hammer.c                           |  17 ++-
 tools/objtool/check.c                              |   2 +-
 tools/perf/builtin-stat.c                          |   2 +-
 tools/perf/pmu-events/jevents.c                    |  15 ++-
 tools/perf/tests/shell/lib/probe_vfs_getname.sh    |   2 +-
 tools/perf/trace/beauty/arch_errno_names.sh        |   2 +-
 tools/perf/util/cpumap.c                           |  10 +-
 tools/perf/util/evsel.c                            |   7 +
 tools/perf/util/mem2node.c                         |   3 +-
 tools/perf/util/metricgroup.c                      |   3 +
 tools/perf/util/parse-events.c                     |   9 +-
 tools/perf/util/sort.c                             |   2 +-
 tools/perf/util/symbol-elf.c                       |   7 +
 .../x86/intel_pstate_tracer/intel_pstate_tracer.py |  22 ++--
 .../ftrace/test.d/ftrace/func-filter-glob.tc       |   2 +-
 tools/testing/selftests/x86/syscall_nt.c           |   1 +
 virt/kvm/arm/mmio.c                                |   2 +-
 virt/kvm/arm/mmu.c                                 |   5 +-
 virt/kvm/arm/vgic/vgic-init.c                      |   1 +
 virt/kvm/arm/vgic/vgic-its.c                       |  11 +-
 virt/kvm/kvm_main.c                                |   1 +
 279 files changed, 2370 insertions(+), 1213 deletions(-)


