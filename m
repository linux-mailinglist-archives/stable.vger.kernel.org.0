Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB9F6AF2FD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbjCGS61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbjCGS55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:57:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8737B79DC;
        Tue,  7 Mar 2023 10:45:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C564FB817AE;
        Tue,  7 Mar 2023 18:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67350C433EF;
        Tue,  7 Mar 2023 18:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214715;
        bh=FHuubsb5imcfW4qUOPf5ytvD7ZYh/afpHZBDXRskfLo=;
        h=From:To:Cc:Subject:Date:From;
        b=Bl6ymb+Lcm+fBlXsUd5lCjn1/p54/CFhdXzKf4MN8j6qG2CXWd2aNvTmuWBFhd2ZA
         si3kKwcLriAdM87XeE3APF8UGJjnbMowwusxHUFORTI8CxtTGKHgyid+/huG0RTPzU
         UPF5SEm9erLWjnngDLMiq+ESXF0VKg3E21I+2+MA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/567] 5.15.99-rc1 review
Date:   Tue,  7 Mar 2023 17:55:36 +0100
Message-Id: <20230307165905.838066027@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.99-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.99-rc1
X-KernelTest-Deadline: 2023-03-09T16:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.99 release.
There are 567 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.99-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.99-rc1

Jani Nikula <jani.nikula@intel.com>
    drm/edid: fix AVI infoframe aspect ratio handling

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use BAR mappings for ring buffers with LLC

Mark Hawrylak <mark.hawrylak@gmail.com>
    drm/radeon: Fix eDP for single-display iMac11,2

Mavroudis Chatzilaridis <mavchatz@protonmail.com>
    drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv

Steve Sistare <steven.sistare@oracle.com>
    vfio/type1: restore locked_vm

Steve Sistare <steven.sistare@oracle.com>
    vfio/type1: track locked_vm per dma

Steve Sistare <steven.sistare@oracle.com>
    vfio/type1: prevent underflow of locked_vm via exec()

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    PCI: Avoid FLR for AMD FCH AHCI adapters

Lukas Wunner <lukas@wunner.de>
    PCI: hotplug: Allow marking devices as disconnected during bind/unbind

Lukas Wunner <lukas@wunner.de>
    PCI/PM: Observe reset delay irrespective of bridge_d3

H. Nikolaus Schaller <hns@goldelico.com>
    MIPS: DTS: CI20: fix otg power gpio

Guo Ren <guoren@linux.alibaba.com>
    riscv: ftrace: Reduce the detour code size to half

Guo Ren <guoren@linux.alibaba.com>
    riscv: ftrace: Remove wasted nops for !RISCV_ISA_C

Björn Töpel <bjorn@rivosinc.com>
    riscv, mm: Perform BPF exhandler fixup on page fault

Andy Chiu <andy.chiu@sifive.com>
    riscv: jump_label: Fixup unaligned arch_static_branch function

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    riscv: mm: fix regression due to update_mmu_cache change

Conor Dooley <conor.dooley@microchip.com>
    RISC-V: add a spin_shadow_stack declaration

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix slab-out-of-bounds in ses_intf_remove()

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix possible desc_ptr out-of-bounds accesses

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix possible addl_desc_ptr out-of-bounds accesses

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix slab-out-of-bounds in ses_enclosure_data_process()

James Bottomley <jejb@linux.ibm.com>
    scsi: ses: Don't attach if enclosure has no components

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Remove increment of interface err cnt

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix erroneous link down

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Remove unintended flag clearing

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix DMA-API call trace on NVMe LS requests

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Check if port is online before sending ELS

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix link failure in NPIV environment

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

Antonio Alvarez Feijoo <antonio.feijoo@suse.com>
    tools/bootconfig: fix single & used for logical condition

Mukesh Ojha <quic_mojha@quicinc.com>
    ring-buffer: Handle race between rb_move_tail and rb_check_pages

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Add RUN_TIMEOUT option with default unlimited

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Fix missing "end_monitor" when machine check fails

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Give back console on Ctrt^C on monitor

Yin Fengwei <fengwei.yin@intel.com>
    mm/thp: check and bail out if page in deferred queue already

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: deprecate charge moving

John Ogness <john.ogness@linutronix.de>
    docs: gdbmacros: print newest record

Chen-Yu Tsai <wenst@chromium.org>
    remoteproc/mtk_scp: Move clk ops outside send_lock

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu3-cio2: Fix PM runtime usage_count in driver unbind

Elvira Khabirova <lineprinter0@gmail.com>
    mips: fix syscall_get_nr

Dan Williams <dan.j.williams@intel.com>
    dax/kmem: Fix leak of memory-hotplug resources

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix FEN fault handling

Xiubo Li <xiubli@redhat.com>
    ceph: update the time stamps and try to drop the suid/sgid

Ilya Dryomov <idryomov@gmail.com>
    rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails

Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
    fuse: add inode/permission checks to fileattr_get/fileattr_set

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid HC1

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid XU

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos5250

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Odroid XU3 family

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos4

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct TMU phandle in Exynos4210

Manivannan Sadhasivam <mani@kernel.org>
    ARM: dts: qcom: sdx55: Add Qcom SMMU-500 as the fallback for IOMMU node

Mikulas Patocka <mpatocka@redhat.com>
    dm flakey: fix a bug with 32-bit highmem systems

Mikulas Patocka <mpatocka@redhat.com>
    dm flakey: don't corrupt the zero page

Mikulas Patocka <mpatocka@redhat.com>
    dm flakey: fix logic when corrupting a bio

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: powerclamp: Fix cur_state for multi package system

Manish Chopra <manishc@marvell.com>
    qede: fix interrupt coalescing configuration

Alexander Wetzel <alexander@wetzel-home.de>
    wifi: cfg80211: Fix use after free for wext

Len Brown <len.brown@intel.com>
    wifi: ath11k: allow system suspend to survive ath11k

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Use a longer retry limit of 48

Pingfan Liu <piliu@redhat.com>
    dm: add cond_resched() to dm_wq_work()

Mikulas Patocka <mpatocka@redhat.com>
    dm: send just one event on resize, not two

Louis Rannou <lrannou@baylibre.com>
    mtd: spi-nor: Fix shift-out-of-bounds in spi_nor_set_erase_type

Tudor Ambarus <tudor.ambarus@linaro.org>
    mtd: spi-nor: spansion: Consider reserved bits in CFR5 register

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: sfdp: Fix index value for SCCR dwords

Jan Kara <jack@suse.cz>
    ext4: Fix possible corruption when moving a directory

Jun Nie <jun.nie@linaro.org>
    ext4: refuse to create ea block when umounted

Jun Nie <jun.nie@linaro.org>
    ext4: optimize ea_inode block expansion

Zhihao Cheng <chengzhihao1@huawei.com>
    jbd2: fix data missing when reusing bh which is ready to be checkpointed

Łukasz Stelmach <l.stelmach@samsung.com>
    ALSA: hda/realtek: Add quirk for HP EliteDesk 800 G6 Tower PC

Dmitry Fomin <fomindmitriyfoma@mail.ru>
    ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: allow some retries for poll triggering spuriously

David Lamparter <equinox@diac24.ne>
    io_uring: remove MSG_NOSIGNAL from recvmsg

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: disallow multi-source reg buffers

Jens Axboe <axboe@kernel.dk>
    io_uring: add a conditional reschedule to the IOPOLL cancelation loop

Jens Axboe <axboe@kernel.dk>
    io_uring: mark task TASK_RUNNING before handling resume/task work

Jens Axboe <axboe@kernel.dk>
    io_uring: handle TIF_NOTIFY_RESUME when checking for task_work

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix out-of-bounds read

Marc Zyngier <maz@kernel.org>
    irqdomain: Fix domain registration race

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Drop bogus fwspec-mapping error handling

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Look for existing mapping only once

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix disassociation race

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix association race

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Align ima_file_mmap() parameters with mmap_file LSM hook

Jens Axboe <axboe@kernel.dk>
    brd: return 0/-error from brd_insert_page()

KP Singh <kpsingh@kernel.org>
    Documentation/hw-vuln: Document the interaction between IBRS and STIBP

KP Singh <kpsingh@kernel.org>
    x86/speculation: Allow enabling STIBP with legacy IBRS

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Fix mixed steppings support

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Add a @cpu parameter to the reloading functions

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/amd: Remove load_microcode_amd()'s bsp parameter

Yang Jihong <yangjihong1@huawei.com>
    x86/kprobes: Fix arch_check_optimized_kprobe check within optimized_kprobe range

Yang Jihong <yangjihong1@huawei.com>
    x86/kprobes: Fix __recover_optprobed_insn check optimizing logic

Sean Christopherson <seanjc@google.com>
    x86/reboot: Disable SVM, not just VMX, when stopping CPUs

Sean Christopherson <seanjc@google.com>
    x86/reboot: Disable virtualization in an emergency if SVM is supported

Sean Christopherson <seanjc@google.com>
    x86/crash: Disable virt in core NMI crash handler to avoid double shootdown

Sean Christopherson <seanjc@google.com>
    x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: disable migration mode when dirty tracking is disabled

Randy Dunlap <rdunlap@infradead.org>
    KVM: SVM: hyper-v: placate modpost section mismatch error

Peter Gonda <pgonda@google.com>
    KVM: SVM: Fix potential overflow in SEV's send|receive_update_data()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI

Sean Christopherson <seanjc@google.com>
    KVM: Destroy target device if coalesced MMIO unregistration fails

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix user page pinning accounting

Jan Kara <jack@suse.cz>
    udf: Fix file corruption when appending just after end of preallocated extent

Jan Kara <jack@suse.cz>
    udf: Detect system inodes linked into directory hierarchy

Jan Kara <jack@suse.cz>
    udf: Preserve link count of system files

Jan Kara <jack@suse.cz>
    udf: Do not update file length for failed writes to inline files

Jan Kara <jack@suse.cz>
    udf: Do not bother merging very long extents

Jan Kara <jack@suse.cz>
    udf: Truncate added extents on failed expansion

Jeff Xu <jeffxu@google.com>
    selftests/landlock: Test ptrace as much as possible with Yama

Jeff Xu <jeffxu@google.com>
    selftests/landlock: Skip overlayfs tests when not supported

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix non-auto defrag path not working issue

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix defrag path triggering jbd2 ASSERT

Eric Biggers <ebiggers@google.com>
    f2fs: fix cgroup writeback accounting with fs-layer encryption

Eric Biggers <ebiggers@google.com>
    f2fs: fix information leak in f2fs_move_inline_dirents()

Alexander Aring <aahringo@redhat.com>
    fs: dlm: send FIN ack back in right cases

Alexander Aring <aahringo@redhat.com>
    fs: dlm: move sending fin message into state change handling

Alexander Aring <aahringo@redhat.com>
    fs: dlm: don't set stop rx flag after node reset

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix inode->i_blocks for non-512 byte sector size device

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: redefine DIR_DELETED as the bad cluster number

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix unexpected EOF while reading dir

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix reporting fs error when reading dir beyond EOF

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: hfsplus: fix UAF issue in hfsplus_put_super

Liu Shixin <liushixin2@huawei.com>
    hfs: fix missing hfs_bnode_get() in __hfs_bnode_create

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct HDMI phy compatible in Exynos4

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: do not allow the actual frame length to be smaller than the rfc1002 length

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix wrong data area length for smb2 lock request

Waiman Long <longman@redhat.com>
    locking/rwsem: Prevent non-first waiter from spinning in down_write() slowpath

Boris Burkov <boris@bur.io>
    btrfs: hold block group refcount during async discard

Volker Lendecke <vl@samba.org>
    cifs: Fix uninitialized memory read in smb3_qfs_tcon()

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix current_kprobe never cleared after kprobes reenter

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler

Ilya Leoshkevich <iii@linux.ibm.com>
    s390: discard .interp section

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/extmem: return correct segment type in __segment_load()

Corey Minyard <cminyard@mvista.com>
    ipmi_ssif: Rename idle state and check

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: resend_msg() cannot fail

Johan Hovold <johan+linaro@kernel.org>
    rtc: pm8xxx: fix set-alarm race

Jens Axboe <axboe@kernel.dk>
    block: don't allow multiple bios for IOCB_NOWAIT issue

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    firmware: coreboot: framebuffer: Ignore reserved pixel color bits

Jun ASAKA <JunASAKA@zzy040330.moe>
    wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

Asahi Lina <lina@asahilina.net>
    drm/shmem-helper: Revert accidental non-GPL export

Jeff Layton <jlayton@kernel.org>
    nfsd: zero out pointers after putting nfsd_files on COPY setup error

Mike Snitzer <snitzer@kernel.org>
    dm cache: add cond_resched() to various workqueue loops

Mike Snitzer <snitzer@kernel.org>
    dm thin: add cond_resched() to various workqueue loops

Darrell Kavanagh <darrell.kavanagh@gmail.com>
    drm: panel-orientation-quirks: Add quirk for Lenovo IdeaPad Duet 3 10IGL5

Bastien Nocera <hadess@hadess.net>
    HID: logitech-hidpp: Don't restart communication if not necessary

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    scsi: snic: Fix memory leak with using debugfs_lookup()

Claudiu Beznea <claudiu.beznea@microchip.com>
    pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Robin Murphy <robin.murphy@arm.com>
    hwmon: (coretemp) Simplify platform device handling

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Improve gfs2_make_fs_rw error handling

Kees Cook <keescook@chromium.org>
    regulator: s5m8767: Bounds check id indexing into arrays

Kees Cook <keescook@chromium.org>
    regulator: max77802: Bounds check regulator id against opmode

Kees Cook <keescook@chromium.org>
    ASoC: kirkwood: Iterate over array indexes instead of using pointer math

강신형 <s47.kang@samsung.com>
    ASoC: soc-compress: Reposition and add pcm_mutex

Jakob Koschel <jkl820.git@gmail.com>
    docs/scripts/gdb: add necessary make scripts_gdb step

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dsi: Add missing check for alloc_ordered_workqueue

Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
    drm: amd: display: Fix memory leakage

Thomas Zimmermann <tzimmermann@suse.de>
    Revert "fbcon: don't lose the console font across generic->chip driver switch"

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Fix use-after-free KFENCE violation during sysfs firmware write

Liwei Song <liwei.song@windriver.com>
    drm/radeon: free iio for atombios when driver shutdown

Carlo Caione <ccaione@baylibre.com>
    drm/tiny: ili9486: Do not assume 8-bit only SPI controllers

Jingyuan Liang <jingyliang@chromium.org>
    HID: Add Mapping for System Microphone Mute

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/omap: dsi: Fix excessive stack usage

Roman Li <roman.li@amd.com>
    drm/amd/display: Fix potential null-deref in dm_resume

Ian Chen <ian.chen@amd.com>
    drm/amd/display: Revert Reduce delay when sink device not able to ACK 00340h write

Eric Dumazet <edumazet@google.com>
    scm: add user copy checks to put_cmsg()

Michael Kelley <mikelley@microsoft.com>
    hv_netvsc: Check status in SEND_RNDIS_PKT completion message

Moises Cardona <moisesmcardona@gmail.com>
    Bluetooth: btusb: Add VID:PID 13d3:3529 for Realtek RTL8821CE

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    PM: EM: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    PM: domains: fix memory leak with using debugfs_lookup()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    time/debug: Fix memory leak with using debugfs_lookup()

Heiko Carstens <hca@linux.ibm.com>
    s390/idle: mark arch_cpu_idle() noinstr

Kees Cook <keescook@chromium.org>
    uaccess: Add minimum bounds check on kernel buffer size

Kees Cook <keescook@chromium.org>
    coda: Avoid partial allocation of sig_inputArgs

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer: Fix debug print

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Fix Lenovo Ideapad Z570 DMI match

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: dma: free rx_head in mt76_dma_rx_cleanup

Zhang Rui <rui.zhang@intel.com>
    tools/power/x86/intel-speed-select: Add Emerald Rapid quirk

Alok Tiwari <alok.a.tiwari@oracle.com>
    netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Check syscall_trace_enter() return code

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Add a check for oversized packets

Kees Cook <keescook@chromium.org>
    crypto: hisilicon: Wipe entire pool on error

Feng Tang <feng.tang@intel.com>
    clocksource: Suspend the watchdog temporarily when high read latency detected

Tim Zimmermann <tim@linux4.de>
    thermal: intel: intel_pch: Add support for Wellsburg PCH

Mark Rutland <mark.rutland@arm.com>
    ACPI: Don't build ACPICA with '-Os'

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: add missing checks for PF vsi type

Siddaraju DH <siddaraju.dh@intel.com>
    ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB

Pietro Borrello <borrello@diag.uniroma1.it>
    inet: fix fast path in __inet_hash_connect()

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: mt7601u: fix an integer underflow

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: brcmfmac: ensure CLM version is null-terminated to prevent stack-out-of-bounds

Breno Leitao <leitao@debian.org>
    x86/bugs: Reset speculation control settings on init

Jann Horn <jannh@google.com>
    timers: Prevent union confusion from unexpected restart_syscall()

Yang Li <yang.lee@linux.alibaba.com>
    thermal: intel: Fix unsigned comparison with less than zero

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath11k: debugfs: fix to work with multiple PCI devices

Zqiang <qiang1.zhang@intel.com>
    rcu-tasks: Make rude RCU-Tasks work well with CPU hotplug

Paul E. McKenney <paulmck@kernel.org>
    rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()

Paul E. McKenney <paulmck@kernel.org>
    rcu: Make RCU_LOCKDEP_WARN() avoid early lockdep checks

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    trace/blktrace: fix memory leak with using debugfs_lookup()

Li Nan <linan122@huawei.com>
    blk-iocost: fix divide by 0 error in calc_lcoefs()

Markuss Broks <markuss.broks@gmail.com>
    ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy

Jan Kara <jack@suse.cz>
    udf: Define EFSCORRUPTED error code

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Avoid infinite loop on intent for missing channel

Tasos Sahanidis <tasos@tasossah.com>
    media: saa7134: Use video_unregister_device for radio_dev

Duoming Zhou <duoming@zju.edu.cn>
    media: usb: siano: Fix use after free bugs caused by do_submit_urb

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: i2c: ov7670: 0 instead of -EINVAL was returned

Duoming Zhou <duoming@zju.edu.cn>
    media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Apply clk_bulk api instead of operating specific clk

Ming Qian <ming.qian@nxp.com>
    media: v4l2-jpeg: ignore the unknown APP14 marker

Ming Qian <ming.qian@nxp.com>
    media: v4l2-jpeg: correct the skip count in jpeg_parse_app14_data

Jai Luthra <j-luthra@ti.com>
    media: i2c: imx219: Fix binning for RAW8 capture

Adam Ford <aford173@gmail.com>
    media: i2c: imx219: Split common registers from mode tables

Yuan Can <yuancan@huawei.com>
    media: i2c: ov772x: Fix memleak in ov772x_probe()

Shang XiaoJing <shangxiaojing@huawei.com>
    media: ov5675: Fix memleak in ov5675_init_controls()

Shang XiaoJing <shangxiaojing@huawei.com>
    media: ov2740: Fix memleak in ov2740_init_controls()

Shang XiaoJing <shangxiaojing@huawei.com>
    media: max9286: Fix memleak in max9286_v4l2_register()

Bastian Germann <bage@linutronix.de>
    builddeb: clean generated package content

Nathan Chancellor <nathan@kernel.org>
    s390/vdso: Drop '-shared' from KBUILD_CFLAGS_64

Masahiro Yamada <masahiroy@kernel.org>
    s390/vdso: remove -nostdlib compiler flag

Nathan Chancellor <nathan@kernel.org>
    powerpc: Remove linker flag from KBUILD_AFLAGS

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: platform: ti: Add missing check for devm_regulator_get

Gaosheng Cui <cuigaosheng1@huawei.com>
    media: ti: cal: fix possible memory leak in cal_ctx_create()

Sibi Sankar <quic_sibis@quicinc.com>
    remoteproc: qcom_q6v5_mss: Use a carveout to authenticate modem headers

Patrick Kelsey <pat.kelsey@cornelisnetworks.com>
    IB/hfi1: Fix sdma.h tx->num_descs off-by-one errors

Patrick Kelsey <pat.kelsey@cornelisnetworks.com>
    IB/hfi1: Fix math bugs in hfi1_can_pin_pages()

Tina Zhang <tina.zhang@intel.com>
    iommu/vt-d: Allow to use flush-queue when first level is default

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Use second level for GPA->HPA translation

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Check FL and SL capability sanity in scalable mode

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Remove duplicate identity domain flag

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix error handling in sva enable/disable paths

Kees Cook <keescook@chromium.org>
    dmaengine: dw-axi-dmac: Do not dereference NULL structure

Shravan Chippa <shravan.chippa@microchip.com>
    dmaengine: sf-pdma: pdma_desc memory leak fix

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Fix error unwind in iommu_group_alloc()

Dan Carpenter <error27@gmail.com>
    iw_cxgb4: Fix potential NULL dereference in c4iw_fill_res_cm_id_entry()

Neill Kapron <nkapron@google.com>
    phy: rockchip-typec: fix tcphy_get_mode error case

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dmaengine: dw-edma: Fix readq_ch() return value truncation

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Add DL_FLAG_CYCLE support to device links

Peng Fan <peng.fan@nxp.com>
    tty: serial: imx: disable Ageing Timer interrupt request irq

Marek Vasut <marex@denx.de>
    tty: serial: imx: Handle RS485 DE signal active high

Shenwei Wang <shenwei.wang@nxp.com>
    serial: fsl_lpuart: fix RS485 RTS polariy inverse issue

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Cap MSIX used to online CPUs + 1

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    usb: max-3421: Fix setting of I/O pins

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    RDMA/cxgb4: Fix potential null-ptr-deref in pass_establish()

Andreas Kemnade <andreas@kemnade.info>
    power: supply: remove faulty cooling logic

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Set No Execute Enable bit in PASID table entry

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: configfs: Restrict symlink creation is UDC already binded

Jakob Koschel <jakobkoschel@gmail.com>
    usb: gadget: configfs: remove using list iterator after loop body as a ptr

Linyu Yuan <quic_linyyuan@quicinc.com>
    usb: gadget: configfs: use to_usb_function_instance() in cfg (un)link func

Linyu Yuan <quic_linyyuan@quicinc.com>
    usb: gadget: configfs: use to_config_usb_cfg() in os_desc_link()

Dan Carpenter <error27@gmail.com>
    usb: musb: mediatek: don't unregister something that wasn't registered

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    RDMA/cxgb4: add null-ptr-check after ip_dev_find()

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: Fix the wrong RXWATER setting for rx dma case

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: early: xhci-dbc: Fix a potential out-of-bound memory access

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dmaengine: dw-edma: Fix missing src/dst address of interleaved xfers

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Add missing completion handler

Chen Zhongjin <chenzhongjin@huawei.com>
    firmware: dmi-sysfs: Fix null-ptr-deref in dmi_sysfs_register_handle

Yang Yingliang <yangyingliang@huawei.com>
    drivers: base: transport_class: fix resource leak when transport_add_device() fails

Yang Yingliang <yangyingliang@huawei.com>
    drivers: base: transport_class: fix possible memory leak

Zhengchao Shao <shaozhengchao@huawei.com>
    driver core: fix resource leak in device_add()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    misc/mei/hdcp: Use correct macros to initialize uuid_le

George Kennedy <george.kennedy@oracle.com>
    VMCI: check context->notify_page after call to get_user_pages_fast() to avoid GPF

Yang Yingliang <yangyingliang@huawei.com>
    firmware: stratix10-svc: add missing gen_pool_destroy() in stratix10_svc_drv_probe()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    applicom: Fix PCI device refcount leak in applicom_init()

Yuan Can <yuancan@huawei.com>
    eeprom: idt_89hpesx: Fix error handling in idt_init()

Duoming Zhou <duoming@zju.edu.cn>
    Revert "char: pcmcia: cm4000_cs: Replace mdelay with usleep_range in set_protocol"

Yi Yang <yiyang13@huawei.com>
    serial: tegra: Add missing clk_disable_unprepare() in tegra_uart_hw_init()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    tty: serial: qcom-geni-serial: stop operations in progress at shutdown

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: clear LPUART Status Register in lpuart32_shutdown()

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: disable Rx/Tx DMA in lpuart32_shutdown()

Bjorn Helgaas <bhelgaas@google.com>
    PCI: switchtec: Return -EFAULT for copy_to_user() errors

Alexey V. Vissarionov <gremlin@altlinux.org>
    PCI/IOV: Enlarge virtfn sysfs name buffer

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: typec: intel_pmc_mux: Don't leak the ACPI device reference count

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: intel_pmc_mux: Use the helper acpi_dev_get_memory_resources()

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    ACPI: resource: Add helper function acpi_dev_get_memory_resources()

Mao Jinlong <quic_jinlmao@quicinc.com>
    coresight: cti: Add PM runtime call in enable_store

James Clark <james.clark@arm.com>
    coresight: cti: Prevent negative values of enable count

Junhao He <hejunhao3@huawei.com>
    coresight: etm4x: Fix accesses to TRCSEQRSTEVR and TRCSEQSTR

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: uvcvideo: Check for INACTIVE in uvc_ctrl_is_accessible()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Check controls flags before accessing them

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Use control names from framework

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add support for V4L2_CTRL_TYPE_CTRL_CLASS

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: refactor __uvc_ctrl_add_mapping

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Remove s_ctrl and g_ctrl

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Do not check for V4L2_CTRL_WHICH_DEF_VAL

Al Viro <viro@zeniv.linux.org.uk>
    alpha/boot/tools/objstrip: fix the check for ELF header

Wang Hai <wanghai38@huawei.com>
    kobject: Fix slab-out-of-bounds in fill_kobj_path()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kobject: modify kobject_get_path() to take a const *

Yang Yingliang <yangyingliang@huawei.com>
    driver core: fix potential null-ptr-deref in device_add()

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Don't overflow the command FIFOs

Hanna Hawa <hhhawa@amazon.com>
    i2c: designware: fix i2c_dw_clk_rate() return size to be u32

Gaosheng Cui <cuigaosheng1@huawei.com>
    usb: gadget: fusb300_udc: free irq on the error path in fusb300_probe()

Ferry Toth <ftoth@exalondelft.nl>
    iio: light: tsl2563: Do not hardcode interrupt trigger type

Geert Uytterhoeven <geert+renesas@glider.be>
    dmaengine: HISI_DMA should depend on ARCH_HISI

Fenghua Yu <fenghua.yu@intel.com>
    dmaengine: idxd: Set traffic class values in GRPCFG on DSA 2.0

Qiheng Lin <linqiheng@huawei.com>
    mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()

Randy Dunlap <rdunlap@infradead.org>
    mfd: cs5535: Don't build on UML

Arnd Bergmann <arnd@arndb.de>
    objtool: add UACCESS exceptions for __tsan_volatile_read/write

Arnd Bergmann <arnd@arndb.de>
    printf: fix errname.c list

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix bash specific "==" operator

Randy Dunlap <rdunlap@infradead.org>
    sparc: allow PM configs for sparc32 COMPILE_TEST

Yicong Yang <yangyicong@hisilicon.com>
    perf tools: Fix auto-complete on aarch64

Namhyung Kim <namhyung@kernel.org>
    perf intel-pt: Do not try to queue auxtrace data on pipe

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Add support for emulated ptwrite

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Add link to the perf wiki's Intel PT page

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Add documentation for Event Trace and TNT disable

Namhyung Kim <namhyung@kernel.org>
    perf inject: Use perf_data__read() for auxtrace

Miaoqian Lin <linmq006@gmail.com>
    leds: led-core: Fix refcount leak in of_led_get()

Ian Rogers <irogers@google.com>
    perf llvm: Fix inadvertent file creation

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: jdata writepage fix

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix warning and UAF when destroy the MR list

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix lost destroy smbd connection when MR allocate failed

Benjamin Coddington <bcodding@redhat.com>
    nfsd: fix race to check ls_layouts

Asahi Lina <lina@asahilina.net>
    drm/shmem-helper: Fix locking for drm_gem_shmem_get_pages_sgt()

Pietro Borrello <borrello@diag.uniroma1.it>
    hid: bigben_probe(): validate report count

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: bigben: use spinlock to safely schedule workers

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: bigben_worker() remove unneeded check on report_field

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: bigben: use spinlock to protect concurrent accesses

Lucas Tanure <lucas.tanure@collabora.com>
    ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: synquacer: Fix timeout handling in synquacer_spi_transfer_one()

NeilBrown <neilb@suse.de>
    NFS: fix disabling of swap

Benjamin Coddington <bcodding@redhat.com>
    nfs4trace: fix state manager flag printing

NeilBrown <neilb@suse.de>
    NFSv4: keep state manager thread active if swap is enabled

Mike Snitzer <snitzer@kernel.org>
    dm: remove flush_scheduled_work() during local_exit()

Steffen Aschbacher <steffen.aschbacher@stihl.de>
    ASoC: tlv320adcx140: fix 'ti,gpio-config' DT property init

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (mlxreg-fan) Return zero speed for broken fan

William Zhang <william.zhang@broadcom.com>
    spi: bcm63xx-hsspi: Fix multi-bit mode setting

William Zhang <william.zhang@broadcom.com>
    spi: bcm63xx-hsspi: Endianness fix for ARM based SoC

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: lpass: fix incorrect mclk rate

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: tx-macro: move to individual clks from bulk

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: rx-macro: move to individual clks from bulk

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: tx-macro: move clk provider to managed variants

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: rx-macro: move clk provider to managed variants

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    ASoC: codecs: Change bulk clock voting to optional voting in digital codecs

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: retain initial quirks set up when creating HID devices

Allen Ballway <ballway@chromium.org>
    HID: multitouch: Add quirks for flipped axes

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    scsi: aic94xx: Add missing check for dma_map_single()

Tomas Henzl <thenzl@redhat.com>
    scsi: mpt3sas: Fix a memory leak

Arnd Bergmann <arnd@arndb.de>
    drm/amdgpu: fix enum odm_combine_mode mismatch

Jonathan Cormier <jcormier@criticallink.com>
    hwmon: (ltc2945) Handle error case in ltc2945_value_store

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: dt-bindings: meson: fix gx-card codec node regex

Nathan Chancellor <nathan@kernel.org>
    ASoC: mchp-spdifrx: Fix uninitialized use of mr in mchp_spdifrx_hw_params()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: fixup #endif position

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: disable all interrupts in mchp_spdifrx_dai_remove()

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: fix controls that works with completion mechanism

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: fix return value in case completion times out

Claudiu Beznea <claudiu.beznea@microchip.com>
    ASoC: mchp-spdifrx: fix controls which rely on rsr register

Arnd Bergmann <arnd@arndb.de>
    spi: dw_bt1: fix MUX_MMIO dependencies

Haibo Chen <haibo.chen@nxp.com>
    gpio: vf610: connect GPIO label to dev name

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-compress.c: fixup private_data on snd_soc_new_compress()

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/mediatek: Clean dangling pointer on bind error path

ruanjinjie <ruanjinjie@huawei.com>
    drm/mediatek: mtk_drm_crtc: Add checks for devm_kcalloc

Rob Clark <robdclark@chromium.org>
    drm/mediatek: Drop unbalanced obj unref

Miles Chen <miles.chen@mediatek.com>
    drm/mediatek: Use NULL instead of 0 for NULL pointer

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: dsi: Reduce the time of dsi from LP11 to sending cmd

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: set pdpu->is_rt_pipe early in dpu_plane_sspp_atomic_update()

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: firewall: Check for is_addr_reg existence in IMM check

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Don't skip assigning syncpoints to channels

Guodong Liu <Guodong.Liu@mediatek.com>
    pinctrl: mediatek: Initialize variable *buf to zero

Guodong Liu <Guodong.Liu@mediatek.com>
    pinctrl: mediatek: Initialize variable pullen and pullup to zero

Zhiyong Tao <zhiyong.tao@mediatek.com>
    pinctrl: mediatek: fix coding style

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: bcm2835: Remove of_node_put() in bcm2835_of_gpio_ranges_fallback()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/mdp5: Add check for kzalloc

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dpu: Add check for pstates

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dpu: Add check for cstate

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: use strscpy instead of strncpy

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/dsi: Allow 2 CTRLs on v2.5.0

Jagan Teki <jagan@amarulasolutions.com>
    drm: exynos: dsi: Fix MIPI_DSI*_NO_* mode flags

Daniel Mentz <danielmentz@google.com>
    drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: pass a pointer to the of node

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix clock calculation

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix programming of video modes

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix polarity programming

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix HPD reenablement

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: lt9611: fix sleep mode setup

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Disallow unallocated resources to be returned

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/gem: Add check for kmalloc

Alexey V. Vissarionov <gremlin@altlinux.org>
    ALSA: hda/ca0132: minor fix for allocation size

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/adreno: Fix null ptr access in adreno_gpu_cleanup()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: initialize is_dsp_mode flag

Mark Brown <broonie@kernel.org>
    ASoC: fsl_sai: Update to modern clocking terminology

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix exchange oversubscription for management commands

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix exchange oversubscription

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix I/O timeout due to over-subscription

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: clean event_thread->worker in case of an error

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Correct interlaced timings again

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Fix colour order for xRGB1555 on HVS5

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Set AXI panic modes

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain

Adam Skladowski <a39.skl@gmail.com>
    pinctrl: qcom: pinctrl-msm8976: Correct function names for wcss pins

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/hdmi: Add missing check for alloc_ordered_workqueue

Armin Wolf <W_Armin@gmx.de>
    hwmon: (ftsteutates) Fix scaling of measurements

Liang He <windhl@126.com>
    gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()

Randolph Sapp <rs@ti.com>
    drm: tidss: Fix pixel format definition

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dpi: Fix format mapping for RGB565

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dpi: Add option for inverting pixel clock and output enable

Yuan Can <yuancan@huawei.com>
    drm/vkms: Fix null-ptr-deref in vkms_release()

Yuan Can <yuancan@huawei.com>
    drm/vkms: Fix memory leak in vkms_init()

Yuan Can <yuancan@huawei.com>
    drm/bridge: megachips: Fix error handling in i2c_register_driver()

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC

Frieder Schrempf <frieder.schrempf@kontron.de>
    drm/bridge: ti-sn65dsi83: Fix delay after reset deassert to match spec

Geert Uytterhoeven <geert@linux-m68k.org>
    drm/fourcc: Add missing big-endian XRGB1555 and RGB565 formats

Shang XiaoJing <shangxiaojing@huawei.com>
    drm: Fix potential null-ptr-deref due to drmm_mode_config_init()

Jiri Pirko <jiri@nvidia.com>
    sefltests: netdevsim: wait for devlink instance after netns removal

Roxana Nicolescu <roxana.nicolescu@canonical.com>
    selftest: fib_tests: Always cleanup before exit

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: fix MoCA LED control

Shigeru Yoshida <syoshida@redhat.com>
    l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/net: Interpret UDP_GRO cmsg data as an int value

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts

Andrii Nakryiko <andrii@kernel.org>
    bpf: Fix global subprog context argument resolution logic

Frank Jungclaus <frank.jungclaus@esd.eu>
    can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Yongqin Liu <yongqin.liu@linaro.org>
    thermal/drivers/hisi: Drop second sensor hi3660

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: crypto4xx - Call dma_unmap_page when done

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: resource: Do IRQ override on all TongFang GMxRGxx

Adam Niederer <adam.niederer@gmail.com>
    ACPI: resource: Add IRQ overrides for MAINGEAR Vector Pro 2 models

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Fix out-of-srctree build

Dan Carpenter <error27@gmail.com>
    wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    wifi: iwl4965: Add missing check for create_singlethread_workqueue()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    wifi: iwl3945: Add missing check for create_singlethread_workqueue

Conor Dooley <conor.dooley@microchip.com>
    RISC-V: time: initialize hrtimer based broadcast clock event device

Randy Dunlap <rdunlap@infradead.org>
    m68k: /proc/hardware should depend on PROC_FS

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rsa-pkcs1pad - Use akcipher_request_complete

Pietro Borrello <borrello@diag.uniroma1.it>
    rds: rds_rm_zerocopy_callback() correct order for list_add_tail()

Ilya Leoshkevich <iii@linux.ibm.com>
    libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()

Halil Pasic <pasic@linux.ibm.com>
    s390/ap: fix status returned by ap_qact()

Halil Pasic <pasic@linux.ibm.com>
    s390/ap: fix status returned by ap_aqic()

Zhengping Jiang <jiangzp@google.com>
    Bluetooth: hci_qca: get wakeup status from serdev device handle

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix potential user-after-free

Qi Zheng <zhengqi.arch@bytedance.com>
    OPP: fix error checking in opp_migrate_dentry()

Pietro Borrello <borrello@diag.uniroma1.it>
    tap: tap_open(): correctly initialize socket uid

Pietro Borrello <borrello@diag.uniroma1.it>
    tun: tun_chr_open(): correctly initialize socket uid

Pietro Borrello <borrello@diag.uniroma1.it>
    net: add sock_init_data_uid()

Vasily Gorbik <gor@linux.ibm.com>
    s390/vmem: fix empty page tables cleanup under KASAN

Vasily Gorbik <gor@linux.ibm.com>
    s390/mem_detect: fix detect_memory() error handling

Miaoqian Lin <linmq006@gmail.com>
    irqchip/ti-sci: Fix refcount leak in ti_sci_intr_irq_domain_probe

Miaoqian Lin <linmq006@gmail.com>
    irqchip/irq-mvebu-gicp: Fix refcount leak in mvebu_gicp_probe

Miaoqian Lin <linmq006@gmail.com>
    irqchip/alpine-msi: Fix refcount leak in alpine_msix_init_domains

Miaoqian Lin <linmq006@gmail.com>
    irqchip: Fix refcount leak in platform_irqchip_probe

Jack Morgenstein <jackm@nvidia.com>
    net/mlx5: Enhance debug print in page allocation failure

Felix Fietkau <nbd@nbd.name>
    mt76: mt7915: fix polling firmware-own status

Tonghao Zhang <tong@infragraf.org>
    bpftool: profile online CPUs instead of possible

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - Flush the SEV-ES TMR memory before giving it to firmware

Peter Gonda <pgonda@google.com>
    crypto: ccp - Refactor out sev_fw_alloc()

Hans de Goede <hdegoede@redhat.com>
    leds: led-class: Add missing put_device() to led_put()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: xts - Handle EBUSY correctly

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Adjust late loading result reporting message

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Check CPU capabilities after late microcode update correctly

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Add a parameter to microcode_check() to store CPU capabilities

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Print previous version of microcode after reload

Borislav Petkov <bp@suse.de>
    x86/microcode: Default-disable late loading

Borislav Petkov <bp@suse.de>
    x86/microcode: Rip out the OLD_INTERFACE

Peter Zijlstra <peterz@infradead.org>
    x86: Mark stop_this_cpu() __noreturn

Yang Yingliang <yangyingliang@huawei.com>
    powercap: fix possible name leak in powercap_register_zone()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: seqiv - Handle EBUSY correctly

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: essiv - Handle EBUSY correctly

Koba Ko <koba.taiwan@gmail.com>
    crypto: ccp - Failure on re-initialization due to duplicate sysfs filename

Armin Wolf <W_Armin@gmx.de>
    ACPI: battery: Fix missing NUL-termination with large strings

Shivani Baranwal <quic_shivbara@quicinc.com>
    wifi: cfg80211: Fix extended KCK key length check in nl80211_set_rekey_data()

Miaoqian Lin <linmq006@gmail.com>
    wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails

Pavel Skripkin <paskripkin@gmail.com>
    ath9k: htc: clean up statistics macros

Wan Jiabing <wanjiabing@vivo.com>
    ath9k: hif_usb: simplify if-if to if-else

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: orinoco: check return value of hermes_write_wordrec()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix memory leaks with RTL8723BU, RTL8192EU

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: limit num_sensors to 9 for msm8939

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: fix slope values for msm8939

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: Sort out msm8976 vs msm8956 data

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: Add compat string for the qcom,msm8960

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: Drop msm8976-specific defines

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: nsrepair: handle cases without a return value correctly

David Rientjes <rientjes@google.com>
    crypto: ccp - Avoid page allocation failure warning for SEV_GET_ID2

Herbert Xu <herbert@gondor.apana.org.au>
    lib/mpi: Fix buffer overrun when SG is too long

Frederic Weisbecker <frederic@kernel.org>
    rcu-tasks: Fix synchronize_rcu_tasks() VS zap_pid_ns_processes()

Frederic Weisbecker <frederic@kernel.org>
    rcu-tasks: Remove preemption disablement around srcu_read_[un]lock() calls

Frederic Weisbecker <frederic@kernel.org>
    rcu-tasks: Improve comments explaining tasks_rcu_exit_srcu purpose

Zhen Lei <thunder.leizhen@huawei.com>
    genirq: Fix the return type of kstat_cpu_irqs_sum()

Mario Limonciello <mario.limonciello@amd.com>
    ACPICA: Drop port I/O validation for some regions

Eric Biggers <ebiggers@google.com>
    crypto: x86/ghash - fix unaligned access in ghash_setkey()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas: if_usb: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: libertas_tf: don't call kfree_skb() under spin_lock_irqsave()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()

Zhang Changzhong <zhangchangzhong@huawei.com>
    wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhang Changzhong <zhangchangzhong@huawei.com>
    wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: ipw2200: fix memory leak in ipw_wdev_init()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix btf__align_of() by taking into account field offsets

Li Zetao <lizetao1@huawei.com>
    wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: libertas: fix memory leak in lbs_init_adapter()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: iwlegacy: common: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtlwifi: rtl8723be: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtlwifi: rtl8188ee: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtlwifi: rtl8821ae: don't call kfree_skb() under spin_lock_irqsave()

Yuan Can <yuancan@huawei.com>
    wifi: rsi: Fix memory leak in rsi_coex_attach()

Martin K. Petersen <martin.petersen@oracle.com>
    block: bio-integrity: Copy flags when bio_integrity_payload is cloned

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: pmk8350: Use the correct PON compatible

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: pmk8350: Specify PBS register for PON

Denis Kenzior <denkenz@gmail.com>
    KEYS: asymmetric: Fix ECDSA use via keyctl uapi

silviazhao <silviazhao-oc@zhaoxin.com>
    x86/perf/zhaoxin: Add stepping check for ZXC

Pietro Borrello <borrello@diag.uniroma1.it>
    sched/rt: pick_next_rt_entity(): check list_entry

Dietmar Eggemann <dietmar.eggemann@arm.com>
    sched/deadline,rt: Remove unused parameter from pick_next_[rt|dl]_entity()

Qiheng Lin <linqiheng@huawei.com>
    s390/dasd: Fix potential memleak in dasd_eckd_init()

Jamie Douglass <jamiemdouglass@gmail.com>
    arm64: dts: qcom: msm8992-lg-bullhead: Correct memory overlaps with the SMEM and MPSS memory regions

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: correct stale comment of .get_budget

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: avoid sleep in blk_mq_alloc_request_hctx

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt8192: Fix CPU map for single-cluster SoC

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx7s: correct iomuxc gpr mux controller cells

Samuel Holland <samuel@sholland.org>
    ARM: dts: sun8i: nanopi-duo2: Fix regulator GPIO reference

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: bananapi-m5: switch VDDIO_C pin to OPEN_DRAIN

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: beacon-renesom: Fix gpio expander reference

Waiman Long <longman@redhat.com>
    locking/rwsem: Disable preemption in all down_read*() and up_read() code paths

Muchun Song <songmuchun@bytedance.com>
    locking/rwsem: Optimize down_read_trylock() under highly contended case

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-sm1-odroid-hc4: fix active fan thermal trip

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxbb-kii-pro: fix led node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl-s905d-phicomm-n1: fix led node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-sm1-bananapi-m5: fix adc keys node names

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx-libretech-pc: fix update button name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: add missing unit address to rng node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl-s905d-sml5442tw: drop invalid clock-names property

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: add missing SCPI sensors compatible

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: fix SCPI clock dvfs node name

Angus Chen <angus.chen@jaguarmicro.com>
    ARM: imx: Call ida_simple_remove() for ida_simple_get

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato

Vaishnav Achath <vaishnav.a@ti.com>
    arm64: dts: ti: k3-j7200: Fix wakeup pinmux range

Arnd Bergmann <arnd@arndb.de>
    ARM: s3c: fix s3c64xx_set_timer_source prototype

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: bcm2835_defconfig: Enable the framebuffer

Yang Yingliang <yangyingliang@huawei.com>
    ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: remove CPU opps below 1GHz for G12A boards

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: correct PCIe QMP PHY output clock names

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: fix Gen3 PCIe node

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: correct Gen2 PCIe ranges

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: fix Gen3 PCIe QMP PHY

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: ipq8074: fix PCIe PHY serdes size

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: Fix IPQ8074 PCIe PHY nodes

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: correct USB3 QMP PHY-s clock output names

Petr Vorel <petr.vorel@gmail.com>
    arm64: dts: qcom: msm8992-bullhead: Disable dfps_data_mem

Petr Vorel <petr.vorel@gmail.com>
    arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem size

Dominik Kobinski <dominikkobinski314@gmail.com>
    arm64: dts: msm8992-bullhead: add memory hole region

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix Ethernet MAC address unit name

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7280: correct SPMI bus address cells

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7180: correct SPMI bus address cells

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-db845c: fix audio codec interrupt pin name

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183: Fix systimer 13 MHz clock description

Qiheng Lin <linqiheng@huawei.com>
    ARM: zynq: Fix refcount leak in zynq_early_slcr_init

Marek Vasut <marex@denx.de>
    arm64: dts: imx8m: Align SoC unique ID node unit address

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm6125: Reorder HSUSB PHY clocks to match bindings

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm8150-kumano: Panel framebuffer is 2.5k instead of 4k

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: msm8996-tone: Fix USB taking 6 minutes to wake up

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qcs404: use symbol names for PCIe resets

Chen Hui <judy.chenhui@huawei.com>
    ARM: OMAP2+: Fix memory leak in realtime_counter_init()

Anders Roxell <anders.roxell@linaro.org>
    powerpc/mm: Rearrange if-else block to avoid clang warning

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: asus: use spinlock to safely schedule workers

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: asus: use spinlock to protect concurrent accesses


-------------

Diffstat:

 Documentation/admin-guide/cgroup-v1/memory.rst     |  13 +-
 Documentation/admin-guide/hw-vuln/spectre.rst      |  21 +-
 Documentation/admin-guide/kdump/gdbmacros.txt      |   2 +-
 Documentation/dev-tools/gdb-kernel-debugging.rst   |   4 +
 .../bindings/sound/amlogic,gx-sound-card.yaml      |   2 +-
 Documentation/hwmon/ftsteutates.rst                |   4 +
 Documentation/virt/kvm/api.rst                     |  18 +-
 Documentation/virt/kvm/devices/vm.rst              |   4 +
 Makefile                                           |   4 +-
 arch/alpha/boot/tools/objstrip.c                   |   2 +-
 arch/alpha/kernel/traps.c                          |  30 +-
 arch/arm/boot/dts/exynos3250-rinato.dts            |   2 +-
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi         |   2 +-
 arch/arm/boot/dts/exynos4.dtsi                     |   2 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |   1 -
 arch/arm/boot/dts/exynos5250.dtsi                  |   2 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |   1 -
 arch/arm/boot/dts/exynos5420.dtsi                  |   2 +-
 arch/arm/boot/dts/exynos5422-odroidhc1.dts         |  10 +-
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |  10 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   2 +-
 arch/arm/boot/dts/qcom-sdx55.dtsi                  |   2 +-
 arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts         |   2 +-
 arch/arm/configs/bcm2835_defconfig                 |   1 +
 arch/arm/mach-imx/mmdc.c                           |  24 +-
 arch/arm/mach-omap1/timer.c                        |   2 +-
 arch/arm/mach-omap2/timer.c                        |   1 +
 arch/arm/mach-s3c/s3c64xx.c                        |   3 +-
 arch/arm/mach-zynq/slcr.c                          |   1 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi        |  20 --
 .../boot/dts/amlogic/meson-gx-libretech-pc.dtsi    |   2 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   6 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts |   2 +-
 .../dts/amlogic/meson-gxl-s905d-phicomm-n1.dts     |   2 +-
 .../boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts |   1 -
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |   2 +-
 .../boot/dts/amlogic/meson-sm1-bananapi-m5.dts     |   6 +-
 .../boot/dts/amlogic/meson-sm1-odroid-hc4.dts      |  10 +-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   2 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   2 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |   1 +
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |  12 +-
 arch/arm64/boot/dts/mediatek/mt8192.dtsi           |  11 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |  93 ++++--
 .../boot/dts/qcom/msm8992-bullhead-rev-101.dts     |  18 +-
 .../boot/dts/qcom/msm8996-sony-xperia-tone.dtsi    |   5 +-
 arch/arm64/boot/dts/qcom/pmk8350.dtsi              |   5 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |  12 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   2 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |   6 +-
 .../boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi   |   7 +-
 .../boot/dts/renesas/beacon-renesom-baseboard.dtsi |  24 +-
 .../boot/dts/ti/k3-j7200-common-proc-board.dts     |   2 +-
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi    |  29 +-
 arch/m68k/68000/entry.S                            |   2 +
 arch/m68k/Kconfig.devices                          |   1 +
 arch/m68k/coldfire/entry.S                         |   2 +
 arch/m68k/kernel/entry.S                           |   3 +
 arch/mips/boot/dts/ingenic/ci20.dts                |   2 +-
 arch/mips/include/asm/syscall.h                    |   2 +-
 arch/powerpc/Makefile                              |   2 +-
 arch/powerpc/mm/book3s64/radix_tlb.c               |  11 +-
 arch/riscv/Makefile                                |   6 +-
 arch/riscv/include/asm/ftrace.h                    |  50 ++-
 arch/riscv/include/asm/jump_label.h                |   2 +
 arch/riscv/include/asm/pgtable.h                   |   2 +-
 arch/riscv/include/asm/thread_info.h               |   1 +
 arch/riscv/kernel/ftrace.c                         |  65 ++--
 arch/riscv/kernel/mcount-dyn.S                     |  42 +--
 arch/riscv/kernel/time.c                           |   3 +
 arch/riscv/mm/fault.c                              |  10 +-
 arch/s390/boot/mem_detect.c                        |   2 +-
 arch/s390/include/asm/ap.h                         |  12 +-
 arch/s390/kernel/idle.c                            |   2 +-
 arch/s390/kernel/kprobes.c                         |   4 +-
 arch/s390/kernel/vdso32/Makefile                   |   2 +-
 arch/s390/kernel/vdso64/Makefile                   |   4 +-
 arch/s390/kernel/vmlinux.lds.S                     |   1 +
 arch/s390/kvm/kvm-s390.c                           |  17 +
 arch/s390/mm/extmem.c                              |  12 +-
 arch/s390/mm/vmem.c                                |   6 +-
 arch/sparc/Kconfig                                 |   2 +-
 arch/x86/Kconfig                                   |  15 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |   6 +-
 arch/x86/events/zhaoxin/core.c                     |   8 +-
 arch/x86/include/asm/microcode.h                   |   4 +-
 arch/x86/include/asm/microcode_amd.h               |   4 +-
 arch/x86/include/asm/msr-index.h                   |   4 +
 arch/x86/include/asm/processor.h                   |   5 +-
 arch/x86/include/asm/reboot.h                      |   2 +
 arch/x86/include/asm/virtext.h                     |  16 +-
 arch/x86/kernel/cpu/bugs.c                         |  35 ++-
 arch/x86/kernel/cpu/common.c                       |  47 ++-
 arch/x86/kernel/cpu/microcode/amd.c                |  53 ++--
 arch/x86/kernel/cpu/microcode/core.c               | 134 ++------
 arch/x86/kernel/crash.c                            |  17 +-
 arch/x86/kernel/kprobes/opt.c                      |   6 +-
 arch/x86/kernel/process.c                          |   2 +-
 arch/x86/kernel/reboot.c                           |  88 ++++--
 arch/x86/kernel/smp.c                              |   6 +-
 arch/x86/kvm/lapic.c                               |  10 +-
 arch/x86/kvm/svm/sev.c                             |   4 +-
 arch/x86/kvm/svm/svm_onhyperv.h                    |   4 +-
 block/bio-integrity.c                              |   1 +
 block/blk-iocost.c                                 |  11 +-
 block/blk-mq-sched.c                               |   7 +-
 block/blk-mq.c                                     |   3 +-
 block/fops.c                                       |  21 +-
 crypto/asymmetric_keys/public_key.c                |  24 +-
 crypto/essiv.c                                     |   7 +-
 crypto/rsa-pkcs1pad.c                              |  34 +-
 crypto/seqiv.c                                     |   2 +-
 crypto/xts.c                                       |   8 +-
 drivers/acpi/acpica/Makefile                       |   2 +-
 drivers/acpi/acpica/hwvalid.c                      |   7 +-
 drivers/acpi/acpica/nsrepair.c                     |  12 +-
 drivers/acpi/battery.c                             |   2 +-
 drivers/acpi/resource.c                            |  43 ++-
 drivers/acpi/video_detect.c                        |   2 +-
 drivers/base/core.c                                |  31 +-
 drivers/base/power/domain.c                        |   5 +-
 drivers/base/transport_class.c                     |  17 +-
 drivers/block/brd.c                                |  26 +-
 drivers/block/rbd.c                                |  20 +-
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/bluetooth/hci_qca.c                        |   7 +-
 drivers/char/applicom.c                            |   5 +-
 drivers/char/ipmi/ipmi_ssif.c                      |  74 ++---
 drivers/char/pcmcia/cm4000_cs.c                    |   6 +-
 drivers/crypto/amcc/crypto4xx_core.c               |  10 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |  21 +-
 drivers/crypto/ccp/sev-dev.c                       |  33 +-
 drivers/crypto/hisilicon/sgl.c                     |   3 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |   2 +-
 drivers/dax/bus.c                                  |   2 +-
 drivers/dax/kmem.c                                 |   4 +-
 drivers/dma/Kconfig                                |   2 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   2 -
 drivers/dma/dw-edma/dw-edma-core.c                 |   4 +
 drivers/dma/dw-edma/dw-edma-v0-core.c              |   2 +-
 drivers/dma/idxd/device.c                          |   2 +-
 drivers/dma/idxd/init.c                            |   2 +-
 drivers/dma/idxd/sysfs.c                           |   4 +-
 drivers/dma/sf-pdma/sf-pdma.c                      |   3 +-
 drivers/dma/sf-pdma/sf-pdma.h                      |   1 -
 drivers/firmware/dmi-sysfs.c                       |  10 +-
 drivers/firmware/google/framebuffer-coreboot.c     |   4 +-
 drivers/firmware/stratix10-svc.c                   |  16 +-
 drivers/gpio/gpio-vf610.c                          |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   6 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  14 +-
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h       |   1 -
 .../amd/display/dc/dml/dcn20/display_mode_vba_20.c |   8 +-
 .../display/dc/dml/dcn20/display_mode_vba_20v2.c   |  10 +-
 .../amd/display/dc/dml/dcn21/display_mode_vba_21.c |  12 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |  65 ++--
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |   6 +-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |   2 +
 drivers/gpu/drm/drm_edid.c                         |  21 +-
 drivers/gpu/drm/drm_fourcc.c                       |   4 +
 drivers/gpu/drm/drm_gem_shmem_helper.c             |  52 ++--
 drivers/gpu/drm/drm_mipi_dsi.c                     |  52 ++++
 drivers/gpu/drm/drm_mode_config.c                  |   8 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |   8 +-
 drivers/gpu/drm/i915/display/intel_quirks.c        |   2 +
 drivers/gpu/drm/i915/gt/intel_ring.c               |   4 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |   2 +
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   1 +
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   4 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   2 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   4 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |   7 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |  15 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c             |   5 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |   5 +-
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                  |   4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   3 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   4 +
 drivers/gpu/drm/msm/msm_drv.c                      |   2 +-
 drivers/gpu/drm/msm/msm_fence.c                    |   2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   4 +
 drivers/gpu/drm/mxsfb/Kconfig                      |   1 +
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |  26 +-
 drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c      |   4 +-
 drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c   |   3 +-
 drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c      |   2 -
 drivers/gpu/drm/radeon/atombios_encoders.c         |   5 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   1 +
 drivers/gpu/drm/tegra/firewall.c                   |   3 +
 drivers/gpu/drm/tidss/tidss_dispc.c                |   4 +-
 drivers/gpu/drm/tiny/ili9486.c                     |  13 +-
 drivers/gpu/drm/vc4/vc4_dpi.c                      |  66 ++--
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   5 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |  11 +
 drivers/gpu/drm/vc4/vc4_plane.c                    |   2 +
 drivers/gpu/drm/vc4/vc4_regs.h                     |   6 +
 drivers/gpu/drm/vkms/vkms_drv.c                    |  10 +-
 drivers/gpu/host1x/hw/syncpt_hw.c                  |   3 -
 drivers/gpu/ipu-v3/ipu-common.c                    |   1 +
 drivers/hid/hid-asus.c                             |  37 ++-
 drivers/hid/hid-bigbenff.c                         |  75 ++++-
 drivers/hid/hid-debug.c                            |   1 +
 drivers/hid/hid-input.c                            |   8 +
 drivers/hid/hid-logitech-hidpp.c                   |  32 +-
 drivers/hid/hid-multitouch.c                       |  39 ++-
 drivers/hid/hid-quirks.c                           |   2 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   6 +-
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  42 +++
 drivers/hid/i2c-hid/i2c-hid.h                      |   3 +
 drivers/hwmon/coretemp.c                           | 128 ++++----
 drivers/hwmon/ftsteutates.c                        |  19 +-
 drivers/hwmon/ltc2945.c                            |   2 +
 drivers/hwmon/mlxreg-fan.c                         |   6 +
 drivers/hwtracing/coresight/coresight-cti-core.c   |  11 +-
 drivers/hwtracing/coresight/coresight-cti-sysfs.c  |  13 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  18 +-
 drivers/i2c/busses/i2c-designware-common.c         |   2 +-
 drivers/i2c/busses/i2c-designware-core.h           |   2 +-
 drivers/iio/light/tsl2563.c                        |   8 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   7 +
 drivers/infiniband/hw/cxgb4/restrack.c             |   2 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   4 +-
 drivers/infiniband/hw/hfi1/sdma.h                  |  15 +-
 drivers/infiniband/hw/hfi1/user_pages.c            |  61 ++--
 drivers/infiniband/hw/irdma/hw.c                   |   2 +
 drivers/infiniband/sw/siw/siw_mem.c                |  23 +-
 drivers/iommu/intel/cap_audit.c                    |  13 +
 drivers/iommu/intel/cap_audit.h                    |   1 +
 drivers/iommu/intel/iommu.c                        |  50 ++-
 drivers/iommu/intel/pasid.c                        |  11 +
 drivers/iommu/iommu.c                              |   8 +-
 drivers/irqchip/irq-alpine-msi.c                   |   1 +
 drivers/irqchip/irq-bcm7120-l2.c                   |   3 +-
 drivers/irqchip/irq-brcmstb-l2.c                   |   6 +-
 drivers/irqchip/irq-mvebu-gicp.c                   |   1 +
 drivers/irqchip/irq-ti-sci-intr.c                  |   1 +
 drivers/irqchip/irqchip.c                          |   8 +-
 drivers/leds/led-class.c                           |   6 +-
 drivers/md/dm-cache-target.c                       |   4 +
 drivers/md/dm-flakey.c                             |  31 +-
 drivers/md/dm-ioctl.c                              |  13 +-
 drivers/md/dm-thin.c                               |   2 +
 drivers/md/dm.c                                    |  29 +-
 drivers/md/dm.h                                    |   2 +-
 drivers/media/i2c/imx219.c                         | 255 +++++++--------
 drivers/media/i2c/max9286.c                        |   1 +
 drivers/media/i2c/ov2740.c                         |   4 +-
 drivers/media/i2c/ov5675.c                         |   4 +-
 drivers/media/i2c/ov7670.c                         |   2 +-
 drivers/media/i2c/ov772x.c                         |   3 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c      |   3 +
 drivers/media/pci/saa7134/saa7134-core.c           |   2 +-
 drivers/media/platform/imx-jpeg/mxc-jpeg.c         |  35 +--
 drivers/media/platform/imx-jpeg/mxc-jpeg.h         |   4 +-
 drivers/media/platform/omap3isp/isp.c              |   9 +
 drivers/media/platform/ti-vpe/cal.c                |   4 +-
 drivers/media/rc/ene_ir.c                          |   3 +-
 drivers/media/usb/siano/smsusb.c                   |   1 +
 drivers/media/usb/uvc/uvc_ctrl.c                   | 250 ++++++++++++---
 drivers/media/usb/uvc/uvc_driver.c                 |   8 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  90 ++----
 drivers/media/usb/uvc/uvcvideo.h                   |   6 +-
 drivers/media/v4l2-core/v4l2-jpeg.c                |   4 +-
 drivers/mfd/Kconfig                                |   1 +
 drivers/mfd/pcf50633-adc.c                         |   7 +-
 drivers/misc/eeprom/idt_89hpesx.c                  |  10 +-
 drivers/misc/mei/hdcp/mei_hdcp.c                   |   4 +-
 drivers/misc/vmw_vmci/vmci_host.c                  |   2 +
 drivers/mtd/spi-nor/core.c                         |   9 +
 drivers/mtd/spi-nor/core.h                         |   1 +
 drivers/mtd/spi-nor/sfdp.c                         |   6 +-
 drivers/mtd/spi-nor/spansion.c                     |   9 +-
 drivers/net/can/usb/esd_usb2.c                     |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   8 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  11 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  17 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   2 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   3 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  11 +-
 drivers/net/hyperv/netvsc.c                        |  18 ++
 drivers/net/tap.c                                  |   2 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/wireless/ath/ath11k/core.h             |   1 -
 drivers/net/wireless/ath/ath11k/debugfs.c          |  48 ++-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   1 +
 drivers/net/wireless/ath/ath11k/pci.c              |   2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  62 ++--
 drivers/net/wireless/ath/ath9k/htc.h               |  32 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   2 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  10 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   4 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   5 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  11 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |  16 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  12 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   4 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |   2 +
 drivers/net/wireless/marvell/libertas/cmdresp.c    |   2 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |   2 +-
 drivers/net/wireless/marvell/libertas/main.c       |   3 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   2 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |   6 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   1 +
 drivers/net/wireless/mediatek/mt7601u/dma.c        |   3 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   5 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  19 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |  52 ++--
 drivers/net/wireless/rsi/rsi_91x_coex.c            |   1 +
 drivers/net/wireless/wl3501_cs.c                   |   2 +-
 drivers/opp/debugfs.c                              |   2 +-
 drivers/pci/iov.c                                  |   2 +-
 drivers/pci/pci.c                                  |   2 +-
 drivers/pci/pci.h                                  |  43 +--
 drivers/pci/quirks.c                               |   1 +
 drivers/pci/switch/switchtec.c                     |   9 +-
 drivers/phy/rockchip/phy-rockchip-typec.c          |   4 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |   2 -
 drivers/pinctrl/mediatek/pinctrl-paris.c           |  12 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                |   4 +-
 drivers/pinctrl/pinctrl-at91.c                     |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   1 +
 drivers/pinctrl/qcom/pinctrl-msm8976.c             |   8 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   1 +
 drivers/power/supply/power_supply_core.c           |  97 ------
 drivers/powercap/powercap_sys.c                    |  14 +-
 drivers/regulator/max77802-regulator.c             |  34 +-
 drivers/regulator/s5m8767.c                        |   6 +-
 drivers/remoteproc/mtk_scp_ipi.c                   |  11 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |  59 +++-
 drivers/rpmsg/qcom_glink_native.c                  |   1 +
 drivers/rtc/rtc-pm8xxx.c                           |  24 +-
 drivers/s390/block/dasd_eckd.c                     |   4 +-
 drivers/scsi/aic94xx/aic94xx_task.c                |   3 +
 drivers/scsi/hosts.c                               |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  19 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   3 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |   9 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   6 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |  10 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |   8 +
 drivers/scsi/qla2xxx/qla_init.c                    |  14 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |  55 +++-
 drivers/scsi/qla2xxx/qla_iocb.c                    |  95 +++++-
 drivers/scsi/qla2xxx/qla_isr.c                     |   6 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  34 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   9 +-
 drivers/scsi/ses.c                                 |  64 +++-
 drivers/scsi/snic/snic_debugfs.c                   |   4 +-
 drivers/soundwire/cadence_master.c                 |   3 +-
 drivers/spi/Kconfig                                |   1 -
 drivers/spi/spi-bcm63xx-hsspi.c                    |  14 +-
 drivers/spi/spi-synquacer.c                        |   7 +-
 drivers/thermal/hisi_thermal.c                     |   4 -
 drivers/thermal/intel/intel_pch_thermal.c          |   8 +
 drivers/thermal/intel/intel_powerclamp.c           |  20 +-
 drivers/thermal/intel/intel_soc_dts_iosf.c         |   2 +-
 drivers/thermal/qcom/tsens-v0_1.c                  |  28 +-
 drivers/thermal/qcom/tsens-v1.c                    |  61 ++--
 drivers/thermal/qcom/tsens.c                       |   6 +
 drivers/thermal/qcom/tsens.h                       |   2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  19 +-
 drivers/tty/serial/imx.c                           |  69 ++++-
 drivers/tty/serial/qcom_geni_serial.c              |   2 +
 drivers/tty/serial/serial-tegra.c                  |   7 +-
 drivers/usb/early/xhci-dbc.c                       |   3 +-
 drivers/usb/gadget/configfs.c                      |  44 +--
 drivers/usb/gadget/udc/fotg210-udc.c               |  16 +
 drivers/usb/gadget/udc/fusb300_udc.c               |  10 +-
 drivers/usb/host/max3421-hcd.c                     |   2 +-
 drivers/usb/musb/mediatek.c                        |   3 +-
 drivers/usb/typec/mux/intel_pmc_mux.c              |  15 +-
 drivers/vfio/vfio_iommu_type1.c                    |  99 ++++--
 drivers/video/fbdev/core/fbcon.c                   |  17 +-
 fs/btrfs/discard.c                                 |  41 ++-
 fs/ceph/file.c                                     |   8 +
 fs/cifs/smb2ops.c                                  |  13 +-
 fs/cifs/smbdirect.c                                |   4 +-
 fs/coda/upcall.c                                   |   2 +-
 fs/dlm/midcomms.c                                  |  45 +--
 fs/exfat/dir.c                                     |   7 +-
 fs/exfat/exfat_fs.h                                |   2 +-
 fs/exfat/file.c                                    |   3 +-
 fs/exfat/inode.c                                   |   6 +-
 fs/exfat/namei.c                                   |   2 +-
 fs/exfat/super.c                                   |   3 +-
 fs/ext4/namei.c                                    |  11 +-
 fs/ext4/xattr.c                                    |  35 ++-
 fs/f2fs/data.c                                     |   6 +-
 fs/f2fs/inline.c                                   |  13 +-
 fs/fuse/ioctl.c                                    |   6 +
 fs/gfs2/aops.c                                     |   3 +-
 fs/gfs2/super.c                                    |   8 +-
 fs/hfs/bnode.c                                     |   1 +
 fs/hfsplus/super.c                                 |   4 +-
 fs/jbd2/transaction.c                              |  50 +--
 fs/ksmbd/smb2misc.c                                |  31 +-
 fs/nfs/file.c                                      |  15 +-
 fs/nfs/nfs4_fs.h                                   |   1 +
 fs/nfs/nfs4proc.c                                  |  22 ++
 fs/nfs/nfs4state.c                                 |  40 ++-
 fs/nfs/nfs4trace.h                                 |  42 +--
 fs/nfsd/nfs4layouts.c                              |   4 +-
 fs/nfsd/nfs4proc.c                                 |   2 +
 fs/ocfs2/move_extents.c                            |  34 +-
 fs/udf/file.c                                      |  26 +-
 fs/udf/inode.c                                     |  74 ++---
 fs/udf/super.c                                     |   1 +
 fs/udf/udf_i.h                                     |   3 +-
 fs/udf/udf_sb.h                                    |   2 +
 include/drm/drm_mipi_dsi.h                         |   4 +
 include/linux/acpi.h                               |   1 +
 include/linux/device.h                             |   1 +
 include/linux/hid.h                                |   1 +
 include/linux/ima.h                                |   6 +-
 include/linux/intel-iommu.h                        |   3 -
 include/linux/kernel_stat.h                        |   2 +-
 include/linux/kobject.h                            |   2 +-
 include/linux/kprobes.h                            |   2 +
 include/linux/nfs_xdr.h                            |   2 +
 include/linux/rcupdate.h                           |  11 +-
 include/linux/transport_class.h                    |   8 +-
 include/linux/uaccess.h                            |   4 +
 include/net/sock.h                                 |   7 +-
 include/sound/soc-dapm.h                           |   1 +
 io_uring/io_uring.c                                |  41 ++-
 kernel/bpf/btf.c                                   |  13 +-
 kernel/irq/irqdomain.c                             | 153 +++++----
 kernel/kprobes.c                                   |   6 +-
 kernel/locking/rwsem.c                             |  60 ++--
 kernel/pid_namespace.c                             |  17 +
 kernel/power/energy_model.c                        |   5 +-
 kernel/rcu/tasks.h                                 |  64 ++--
 kernel/rcu/tree_exp.h                              |   2 +
 kernel/resource.c                                  |  14 -
 kernel/sched/deadline.c                            |   5 +-
 kernel/sched/rt.c                                  |  10 +-
 kernel/time/clocksource.c                          |  45 ++-
 kernel/time/hrtimer.c                              |   2 +
 kernel/time/posix-stubs.c                          |   2 +
 kernel/time/posix-timers.c                         |   2 +
 kernel/time/test_udelay.c                          |   2 +-
 kernel/trace/blktrace.c                            |   4 +-
 kernel/trace/ring_buffer.c                         |  42 +--
 lib/errname.c                                      |  22 +-
 lib/kobject.c                                      |  20 +-
 lib/mpi/mpicoder.c                                 |   3 +-
 mm/huge_memory.c                                   |   3 +
 mm/memcontrol.c                                    |   4 +
 net/bluetooth/l2cap_core.c                         |  24 --
 net/bluetooth/l2cap_sock.c                         |   8 +
 net/core/scm.c                                     |   2 +
 net/core/sock.c                                    |  15 +-
 net/ipv4/inet_hashtables.c                         |  12 +-
 net/l2tp/l2tp_ppp.c                                | 125 ++++----
 net/mac80211/sta_info.c                            |   2 +-
 net/netfilter/nf_tables_api.c                      |   3 +
 net/rds/message.c                                  |   2 +-
 net/sunrpc/clnt.c                                  |   4 +
 net/wireless/nl80211.c                             |   2 +-
 net/wireless/sme.c                                 |  31 +-
 scripts/package/mkdebian                           |   2 +-
 security/integrity/ima/ima_main.c                  |   7 +-
 security/security.c                                |   7 +-
 sound/pci/hda/patch_ca0132.c                       |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/ice1712/aureon.c                         |   2 +-
 sound/soc/atmel/mchp-spdifrx.c                     | 342 ++++++++++++++-------
 sound/soc/codecs/lpass-rx-macro.c                  | 100 ++++--
 sound/soc/codecs/lpass-tx-macro.c                  | 104 +++++--
 sound/soc/codecs/lpass-va-macro.c                  |   2 +-
 sound/soc/codecs/tlv320adcx140.c                   |   2 +-
 sound/soc/fsl/fsl_sai.c                            |  35 ++-
 sound/soc/fsl/fsl_sai.h                            |   2 +-
 sound/soc/kirkwood/kirkwood-dma.c                  |   2 +-
 sound/soc/sh/rcar/rsnd.h                           |   4 +-
 sound/soc/soc-compress.c                           |  11 +-
 tools/bootconfig/scripts/ftrace2bconf.sh           |   2 +-
 tools/bpf/bpftool/prog.c                           |  38 ++-
 tools/lib/bpf/btf.c                                |  13 +
 tools/lib/bpf/nlattr.c                             |   2 +-
 tools/objtool/check.c                              |   3 +
 tools/perf/Documentation/perf-intel-pt.txt         | 229 +++++++++++++-
 tools/perf/builtin-inject.c                        |   6 +-
 tools/perf/perf-completion.sh                      |  11 +-
 tools/perf/util/auxtrace.c                         |   3 +
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  99 +++++-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.h  |   1 +
 .../util/intel-pt-decoder/intel-pt-insn-decoder.c  |   1 +
 .../util/intel-pt-decoder/intel-pt-insn-decoder.h  |   1 +
 tools/perf/util/intel-pt.c                         |  43 ++-
 tools/perf/util/llvm-utils.c                       |  25 +-
 tools/power/x86/intel-speed-select/isst-config.c   |   2 +-
 tools/testing/ktest/ktest.pl                       |  26 +-
 tools/testing/ktest/sample.conf                    |   5 +
 tools/testing/selftests/bpf/Makefile               |   2 -
 .../selftests/drivers/net/netdevsim/devlink.sh     |  18 ++
 .../ftrace/test.d/ftrace/func_event_triggers.tc    |   2 +-
 tools/testing/selftests/landlock/fs_test.c         |  47 +++
 tools/testing/selftests/landlock/ptrace_test.c     | 113 ++++++-
 tools/testing/selftests/net/fib_tests.sh           |   2 +
 tools/testing/selftests/net/udpgso_bench_rx.c      |   6 +-
 virt/kvm/coalesced_mmio.c                          |   8 +-
 521 files changed, 5196 insertions(+), 2849 deletions(-)


