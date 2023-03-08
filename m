Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540096B02E3
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 10:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjCHJ3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 04:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjCHJ3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 04:29:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76E0A02AC;
        Wed,  8 Mar 2023 01:29:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AF266171E;
        Wed,  8 Mar 2023 09:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6798BC433D2;
        Wed,  8 Mar 2023 09:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678267765;
        bh=ycOqvGVDsEnhKweXG33yBN99C6cpgR4GqcWFgA5tdLY=;
        h=From:To:Cc:Subject:Date:From;
        b=NnTvHEcw2v8bDEjj5T/IIaPYolD5Uz3NjTjdvKUF5FalY5BSTnDOyGN8r2C0ESyJG
         /Vxzu0PE41KT19h6Eg+lUo6X4m0cVf8w6i2lEmWvtuy1vh7OuZ5XihO78ExyTKtjib
         VIpueH3MZo/7Xe67qJ0x4nB2w6kLacTOo2vykJUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Date:   Wed,  8 Mar 2023 10:29:21 +0100
Message-Id: <20230308091912.362228731@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.2.3-rc2
X-KernelTest-Deadline: 2023-03-10T09:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.2.3 release.
There are 1000 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.2.3-rc2

Pankaj Raghav <p.raghav@samsung.com>
    brd: use radix_tree_maybe_preload instead of radix_tree_preload

Michal Schmidt <mschmidt@redhat.com>
    qede: avoid uninitialized entries in coal_entry array

Jani Nikula <jani.nikula@intel.com>
    drm/edid: fix parsing of 3D modes from HDMI VSDB

Jani Nikula <jani.nikula@intel.com>
    drm/edid: fix AVI infoframe aspect ratio handling

Noralf Trønnes <noralf@tronnes.org>
    drm/gud: Fix UBSAN warning

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use BAR mappings for ring buffers with LLC

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use stolen memory for ring buffers with LLC

Mark Hawrylak <mark.hawrylak@gmail.com>
    drm/radeon: Fix eDP for single-display iMac11,2

Mavroudis Chatzilaridis <mavchatz@protonmail.com>
    drm/i915/quirks: Add inverted backlight quirk for HP 14-r206nv

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix initialization for nbio 7.5.1

Steve Sistare <steven.sistare@oracle.com>
    vfio/type1: restore locked_vm

Steve Sistare <steven.sistare@oracle.com>
    vfio/type1: track locked_vm per dma

Steve Sistare <steven.sistare@oracle.com>
    vfio/type1: prevent underflow of locked_vm via exec()

Steve Sistare <steven.sistare@oracle.com>
    vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix PASID directory pointer coherency

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Do not add the same hwpt to the ioas->hwpt_list twice

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Make sure to zero vfio_iommu_type1_info before copying to user

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Save channel state locally during suspend and resume

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Move chan->lock to the start of processing queued ch ring

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Only send -ENOTCONN status if client driver is available

Lukas Wunner <lukas@wunner.de>
    PCI/DPC: Await readiness of secondary bus after reset

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    PCI: Avoid FLR for AMD FCH AHCI adapters

Lukas Wunner <lukas@wunner.de>
    PCI: hotplug: Allow marking devices as disconnected during bind/unbind

Lukas Wunner <lukas@wunner.de>
    PCI: Unify delay handling for reset and resume

Lukas Wunner <lukas@wunner.de>
    PCI/PM: Observe reset delay irrespective of bridge_d3

H. Nikolaus Schaller <hns@goldelico.com>
    MIPS: DTS: CI20: fix otg power gpio

Guo Ren <guoren@kernel.org>
    riscv: ftrace: Reduce the detour code size to half

Guo Ren <guoren@kernel.org>
    riscv: ftrace: Remove wasted nops for !RISCV_ISA_C

Björn Töpel <bjorn@rivosinc.com>
    riscv, mm: Perform BPF exhandler fixup on page fault

Andy Chiu <andy.chiu@sifive.com>
    riscv: ftrace: Fixup panic by disabling preemption

Andy Chiu <andy.chiu@sifive.com>
    riscv: jump_label: Fixup unaligned arch_static_branch function

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    riscv: mm: fix regression due to update_mmu_cache change

Mattias Nissler <mnissler@rivosinc.com>
    riscv: Avoid enabling interrupts in die()

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

Kees Cook <keescook@chromium.org>
    scsi: aacraid: Allocate cmd_priv with scsicmd

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix to add filter on eprobe description in README file

Antonio Alvarez Feijoo <antonio.feijoo@suse.com>
    tools/bootconfig: fix single & used for logical condition

Mukesh Ojha <quic_mojha@quicinc.com>
    ring-buffer: Handle race between rb_move_tail and rb_check_pages

Tong Tiangen <tongtiangen@huawei.com>
    memory tier: release the new_memtier in find_create_memory_tier()

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Add RUN_TIMEOUT option with default unlimited

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Fix missing "end_monitor" when machine check fails

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Fix to handle forcibly unoptimized kprobes on freeing_list

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Give back console on Ctrt^C on monitor

Yin Fengwei <fengwei.yin@intel.com>
    mm/thp: check and bail out if page in deferred queue already

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: deprecate charge moving

John Ogness <john.ogness@linutronix.de>
    docs: gdbmacros: print newest record

Yan Zhao <yan.y.zhao@intel.com>
    vfio: Fix NULL pointer dereference caused by uninitialized group->iommufd

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

Dhruva Gole <d-gole@ti.com>
    spi: spi-sn-f-ospi: fix duplicate flag while assigning to mode_bits

Marc Zyngier <maz@kernel.org>
    genirq/msi: Take the per-device MSI lock before validating the control structure

Thomas Gleixner <tglx@linutronix.de>
    genirq/msi, platform-msi: Ensure that MSI descriptors are unreferenced

Naoya Horiguchi <naoya.horiguchi@nec.com>
    mm/hwpoison: convert TTU_IGNORE_HWPOISON to TTU_HWPOISON

Guilherme G. Piccoli <gpiccoli@igalia.com>
    panic: fix the panic_print NMI backtrace setting

Matthias Kaehlcke <mka@chromium.org>
    regulator: core: Use ktime_get_boottime() to determine how long a regulator was off

Xiubo Li <xiubli@redhat.com>
    ceph: update the time stamps and try to drop the suid/sgid

Ilya Dryomov <idryomov@gmail.com>
    rbd: avoid use-after-free in do_rbd_add() when rbd_dev_create() fails

Alexander Mikhalitsyn <alexander@mihalicyn.com>
    fuse: add inode/permission checks to fileattr_get/fileattr_set

Peter Collingbourne <pcc@google.com>
    arm64: Reset KASAN tag in copy_highpage with HW tags only

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mm: hugetlb: Disable HUGETLB_PAGE_OPTIMIZE_VMEMMAP

Sudeep Holla <sudeep.holla@arm.com>
    arm64: acpi: Fix possible memory leak of ffh_ctxt

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

Manivannan Sadhasivam <mani@kernel.org>
    ARM: dts: qcom: sdx65: Add Qcom SMMU-500 as the fallback for IOMMU node

Mika Westerberg <mika.westerberg@linux.intel.com>
    spi: intel: Check number of chip selects after reading the descriptor

Zev Weiss <zev@bewilderbeest.net>
    hwmon: (nct6775) Fix incorrect parenthesization in nct6775_write_fan_div()

Zev Weiss <zev@bewilderbeest.net>
    hwmon: (peci/cputemp) Fix off-by-one in coretemp_label allocation

Mikulas Patocka <mpatocka@redhat.com>
    dm flakey: fix a bug with 32-bit highmem systems

Mikulas Patocka <mpatocka@redhat.com>
    dm flakey: don't corrupt the zero page

Joe Thornber <ejt@redhat.com>
    dm cache: free background tracker's queued work in btracker_destroy

Mikulas Patocka <mpatocka@redhat.com>
    dm flakey: fix logic when corrupting a bio

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: intel: powerclamp: Fix cur_state for multi package system

Manish Chopra <manishc@marvell.com>
    qede: fix interrupt coalescing configuration

Arnd Bergmann <arnd@arndb.de>
    cpuidle: add ARCH_SUSPEND_POSSIBLE dependencies

Marc Bornand <dev.mbornand@systemb.ch>
    wifi: cfg80211: Set SSID if it is not already set

Alexander Wetzel <alexander@wetzel-home.de>
    wifi: cfg80211: Fix use after free for wext

Len Brown <len.brown@intel.com>
    wifi: ath11k: allow system suspend to survive ath11k

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Use a longer retry limit of 48

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: use RTW_FLAG_POWERON flag to prevent to power on/off twice

Mike Snitzer <snitzer@kernel.org>
    dm: add cond_resched() to dm_wq_requeue_work()

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

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: exc3000 - properly stop timer on shutdown

Dan Williams <dan.j.williams@intel.com>
    cxl/pmem: Fix nvdimm registration races

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

andrew.yang <andrew.yang@mediatek.com>
    mm/damon/paddr: fix missing folio_put()

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix out-of-bounds read

Marc Zyngier <maz@kernel.org>
    irqdomain: Fix domain registration race

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix mapping-creation race

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Refactor __irq_domain_alloc_irqs()

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Drop bogus fwspec-mapping error handling

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Look for existing mapping only once

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix disassociation race

Johan Hovold <johan+linaro@kernel.org>
    irqdomain: Fix association race

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: seccomp: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: vm: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: dmabuf-heaps: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: drivers: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: futex: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: ipc: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: perf_events: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: mount_setattr: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: move_mount_set_group: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: rseq: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: sync: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: ptp: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: user_events: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: filesystems: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: gpio: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: media_tests: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: kcmp: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: membarrier: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: pidfd: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: clone3: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: arm64: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: pid_namespace: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: core: Fix incorrect kernel headers search path

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: sched: Fix incorrect kernel headers search path

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix eprobe syntax test case to check filter support

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/powerpc: Fix incorrect kernel headers search path

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Align ima_file_mmap() parameters with mmap_file LSM hook

Matt Bobrowski <mattbobrowski@google.com>
    ima: fix error handling logic when file measurement failed

Jens Axboe <axboe@kernel.dk>
    brd: check for REQ_NOWAIT and set correct page allocation mask

Jens Axboe <axboe@kernel.dk>
    brd: return 0/-error from brd_insert_page()

Jens Axboe <axboe@kernel.dk>
    brd: mark as nowait compatible

Tom Lendacky <thomas.lendacky@amd.com>
    virt/sev-guest: Return -EIO if certificate buffer is not large enough

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

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests: x86: Fix incorrect kernel headers search path

Randy Dunlap <rdunlap@infradead.org>
    KVM: SVM: hyper-v: placate modpost section mismatch error

Peter Gonda <pgonda@google.com>
    KVM: SVM: Fix potential overflow in SEV's send|receive_update_data()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32

Sean Christopherson <seanjc@google.com>
    KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Don't put/load AVIC when setting virtual APIC mode

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid target

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Flush the "current" TLB when activating AVIC

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID mismatch is due to 32-bit ID

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't inhibit APICv/AVIC on xAPIC ID "change" if APIC is disabled

Sean Christopherson <seanjc@google.com>
    KVM: x86: Blindly get current x2APIC reg value on "nodecode write" traps

Sean Christopherson <seanjc@google.com>
    KVM: x86: Purge "highest ISR" cache when updating APICv state

Sean Christopherson <seanjc@google.com>
    KVM: Register /dev/kvm as the _very_ last thing during initialization

Alexandru Matei <alexandru.matei@uipath.com>
    KVM: VMX: Fix crash due to uninitialized current_vmcs

Sean Christopherson <seanjc@google.com>
    KVM: Destroy target device if coalesced MMIO unregistration fails

Hou Tao <houtao1@huawei.com>
    md: don't update recovery_cp when curr_resync is ACTIVE

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

Andrew Morton <akpm@linux-foundation.org>
    fs/cramfs/inode.c: initialize file_ra_state

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix non-auto defrag path not working issue

Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: fix defrag path triggering jbd2 ASSERT

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: Revert "f2fs: truncate blocks in batch in __complete_revoke_list()"

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix kernel crash due to null io->bio

Eric Biggers <ebiggers@google.com>
    f2fs: fix cgroup writeback accounting with fs-layer encryption

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: retry to update the inode page given data corruption

Eric Biggers <ebiggers@google.com>
    f2fs: fix information leak in f2fs_move_inline_dirents()

Alexander Aring <aahringo@redhat.com>
    fs: dlm: send FIN ack back in right cases

Alexander Aring <aahringo@redhat.com>
    fs: dlm: move sending fin message into state change handling

Alexander Aring <aahringo@redhat.com>
    fs: dlm: don't set stop rx flag after node reset

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix race setting stop tx flag

Alexander Aring <aahringo@redhat.com>
    fs: dlm: be sure to call dlm_send_queue_flush()

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix use after free in midcomms commit

Alexander Aring <aahringo@redhat.com>
    fs: dlm: start midcomms before scand

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

Jens Axboe <axboe@kernel.dk>
    io_uring: mark task TASK_RUNNING before handling resume/task work

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: correct HDMI phy compatible in Exynos4

Joel Fernandes (Google) <joel@joelfernandes.org>
    torture: Fix hang during kthread shutdown phase

Hangyu Hua <hbh25y@gmail.com>
    ksmbd: fix possible memory leak in smb2_lock()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: do not allow the actual frame length to be smaller than the rfc1002 length

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix wrong data area length for smb2 lock request

Waiman Long <longman@redhat.com>
    locking/rwsem: Prevent non-first waiter from spinning in down_write() slowpath

Qu Wenruo <wqu@suse.com>
    btrfs: sysfs: update fs features directory asynchronously

Boris Burkov <boris@bur.io>
    btrfs: hold block group refcount during async discard

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: mpi3mr: Remove unnecessary memcpy() to alltgt_info->dmi

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: mpi3mr: Fix issues in mpi3mr_get_all_tgt_info()

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: mpi3mr: Fix missing mrioc->evtack_cmds initialization

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: return a single-use cfid if we did not get a lease

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: Check the lease context if we actually got a lease

Stefan Metzmacher <metze@samba.org>
    cifs: don't try to use rdma offload on encrypted connections

Stefan Metzmacher <metze@samba.org>
    cifs: split out smb3_use_rdma_offload() helper

Stefan Metzmacher <metze@samba.org>
    cifs: introduce cifs_io_parms in smb2_async_writev()

Paulo Alcantara <pc@manguebit.com>
    cifs: fix mount on old smb servers

Volker Lendecke <vl@samba.org>
    cifs: Fix uninitialized memory reads for oparms.mode

Volker Lendecke <vl@samba.org>
    cifs: Fix uninitialized memory read in smb3_qfs_tcon()

Paulo Alcantara <pc@manguebit.com>
    cifs: improve checking of DFS links over STATUS_OBJECT_NAME_INVALID

Nico Boehr <nrb@linux.ibm.com>
    KVM: s390: disable migration mode when dirty tracking is disabled

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix current_kprobe never cleared after kprobes reenter

Vasily Gorbik <gor@linux.ibm.com>
    s390/kprobes: fix irq mask clobbering on kprobe reenter from post_handler

Sven Schnelle <svens@linux.ibm.com>
    s390/ipl: add loadparm parameter to eckd ipl/reipl data

Sven Schnelle <svens@linux.ibm.com>
    s390/ipl: add DEFINE_GENERIC_LOADPARM()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390: discard .interp section

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/extmem: return correct segment type in __segment_load()

Joseph Qi <joseph.qi@linux.alibaba.com>
    io_uring: fix fget leak when fs don't support nowait buffered read

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: allow some retries for poll triggering spuriously

David Lamparter <equinox@diac24.net>
    io_uring: remove MSG_NOSIGNAL from recvmsg

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: disallow multi-source reg buffers

Jens Axboe <axboe@kernel.dk>
    io_uring: add reschedule point to handle_tw_list()

Jens Axboe <axboe@kernel.dk>
    io_uring: add a conditional reschedule to the IOPOLL cancelation loop

Jens Axboe <axboe@kernel.dk>
    io_uring: handle TIF_NOTIFY_RESUME when checking for task_work

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: use user visible tail in io_uring_poll()

Kees Cook <keescook@chromium.org>
    io_uring: Replace 0-length array with flexible array

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Add a timer between request retries

Corey Minyard <cminyard@mvista.com>
    ipmi_ssif: Rename idle state and check

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: resend_msg() cannot fail

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ipmi: ipmb: Fix the MODULE_PARM_DESC associated to 'retry_time_ms'

Johan Hovold <johan+linaro@kernel.org>
    rtc: pm8xxx: fix set-alarm race

Jens Axboe <axboe@kernel.dk>
    block: be a bit more careful in checking for NULL bdev while polling

Jens Axboe <axboe@kernel.dk>
    block: clear bio->bi_bdev when putting a bio back in the cache

Jens Axboe <axboe@kernel.dk>
    block: don't allow multiple bios for IOCB_NOWAIT issue

Alper Nebi Yasak <alpernebiyasak@gmail.com>
    firmware: coreboot: framebuffer: Ignore reserved pixel color bits

Jun ASAKA <JunASAKA@zzy040330.moe>
    wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Avoid spurious error message

Asahi Lina <lina@asahilina.net>
    drm/shmem-helper: Revert accidental non-GPL export

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/mtl: Correct implementation of Wa_18018781329

Paulo Alcantara <pc@cjr.nz>
    cifs: prevent data race in smb2_reconnect()

Jeff Layton <jlayton@kernel.org>
    nfsd: don't hand out delegation on setuid files being opened for write

Jeff Layton <jlayton@kernel.org>
    nfsd: zero out pointers after putting nfsd_files on COPY setup error

Mike Snitzer <snitzer@kernel.org>
    dm cache: add cond_resched() to various workqueue loops

Mike Snitzer <snitzer@kernel.org>
    dm thin: add cond_resched() to various workqueue loops

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: disable SubVP + DRR to prevent underflow

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Disable HUBP/DPP PG on DCN314 for now

Darrell Kavanagh <darrell.kavanagh@gmail.com>
    drm: panel-orientation-quirks: Add quirk for Lenovo IdeaPad Duet 3 10IGL5

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Enable P-state validation checks for DCN314

Bastien Nocera <hadess@hadess.net>
    HID: logitech-hidpp: Don't restart communication if not necessary

Mason Zhang <Mason.Zhang@mediatek.com>
    scsi: ufs: core: Fix device management cmd timeout flow

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    scsi: snic: Fix memory leak with using debugfs_lookup()

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Do not commit pipe when updating DRR

Claudiu Beznea <claudiu.beznea@microchip.com>
    pinctrl: at91: use devm_kasprintf() to avoid potential leaks

Denis Pauk <pauk.denis@gmail.com>
    hwmon: (nct6775) B650/B660/X670 ASUS boards support

Denis Pauk <pauk.denis@gmail.com>
    hwmon: (nct6775) Directly call ASUS ACPI WMI method

Robin Murphy <robin.murphy@arm.com>
    hwmon: (coretemp) Simplify platform device handling

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Improve gfs2_make_fs_rw error handling

Vladimir Stempen <vladimir.stempen@amd.com>
    drm/amd/display: fix FCLK pstate change underflow

Vitaly Prosyak <vitaly.prosyak@amd.com>
    Revert "drm/amdgpu: TA unload messages are not actually sent to psp when amdgpu is uninstalled"

Kees Cook <keescook@chromium.org>
    regulator: s5m8767: Bounds check id indexing into arrays

Kees Cook <keescook@chromium.org>
    regulator: max77802: Bounds check regulator id against opmode

Kees Cook <keescook@chromium.org>
    ASoC: kirkwood: Iterate over array indexes instead of using pointer math

강신형 <s47.kang@samsung.com>
    ASoC: soc-compress: Reposition and add pcm_mutex

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Add DSC hardware blocks to register snapshot

Jakob Koschel <jkl820.git@gmail.com>
    docs/scripts/gdb: add necessary make scripts_gdb step

farah kassabri <fkassabri@habana.ai>
    habanalabs: fix bug in timestamps registration code

Moti Haimovski <mhaimovski@habana.ai>
    habanalabs: extend fatal messages to contain PCI info

Thomas Zimmermann <tzimmermann@suse.de>
    drm/client: Test for connectors before sending hotplug event

Roman Li <roman.li@amd.com>
    drm/amd/display: Set hvm_enabled flag for S/G mode

Wayne Lin <Wayne.Lin@amd.com>
    drm/drm_print: correct format problem

Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
    drm: rcar-du: Fix setting a reserved bit in DPLLCR

Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
    drm: rcar-du: Add quirk for H3 ES1.x pclk workaround

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dsi: Add missing check for alloc_ordered_workqueue

José Expósito <jose.exposito89@gmail.com>
    HID: uclogic: Add support for XP-PEN Deco Pro MW

José Expósito <jose.exposito89@gmail.com>
    HID: uclogic: Add support for XP-PEN Deco Pro SW

José Expósito <jose.exposito89@gmail.com>
    HID: uclogic: Add battery quirk

José Expósito <jose.exposito89@gmail.com>
    HID: uclogic: Add frame type quirk

Brandon Syu <Brandon.Syu@amd.com>
    drm/amd/display: fix mapping to non-allocated address

Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
    drm: amd: display: Fix memory leakage

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Avoid ASSERT for some message failures

Thomas Zimmermann <tzimmermann@suse.de>
    Revert "fbcon: don't lose the console font across generic->chip driver switch"

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Fix use-after-free KFENCE violation during sysfs firmware write

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Page aligned memory reserve size

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Avoid BUG() for case of SRIOV missing IP version

Liwei Song <liwei.song@windriver.com>
    drm/radeon: free iio for atombios when driver shutdown

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Defer DIG FIFO disable after VID stream enable

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

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Reduce expected sdp bandwidth for dcn321

Allen Ballway <ballway@chromium.org>
    drm: panel-orientation-quirks: Add quirk for DynaBook K50

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Tab 3 X90F

Eric Dumazet <edumazet@google.com>
    scm: add user copy checks to put_cmsg()

Moshe Shemesh <moshe@nvidia.com>
    devlink: Fix TP_STRUCT_entry in trace of devlink health report

Heiko Carstens <hca@linux.ibm.com>
    s390/kfence: fix page fault reporting

Michael Kelley <mikelley@microsoft.com>
    hv_netvsc: Check status in SEND_RNDIS_PKT completion message

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: debug: avoid invalid access on RTW89_DBG_SEL_MAC_30

Moises Cardona <moisesmcardona@gmail.com>
    Bluetooth: btusb: Add VID:PID 13d3:3529 for Realtek RTL8821CE

Mario Limonciello <mario.limonciello@amd.com>
    Bluetooth: btusb: Add new PID/VID 0489:e0f2 for MT7921

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Fix issue with Actions Semi ATS2851 based devices

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

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-ddv: Add support for interface version 3

Zhang Rui <rui.zhang@intel.com>
    tools/power/x86/intel-speed-select: Add Emerald Rapid quirk

Sam James <sam@gentoo.org>
    gcc-plugins: drop -std=gnu++11 to fix GCC 13 build

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: check CAN address family in isotp_bind()

Alok Tiwari <alok.a.tiwari@oracle.com>
    netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()

Vasily Gorbik <gor@linux.ibm.com>
    s390/mm,ptdump: avoid Kasan vs Memcpy Real markers swapping

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

Dave Thaler <dthaler@microsoft.com>
    bpf, docs: Fix modulo zero, division by zero, overflow, and underflow

Mark Rutland <mark.rutland@arm.com>
    ACPI: Don't build ACPICA with '-Os'

Mark Rutland <mark.rutland@arm.com>
    Compiler attributes: GCC cold function alignment workarounds

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: add missing checks for PF vsi type

Siddaraju DH <siddaraju.dh@intel.com>
    ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB

Pietro Borrello <borrello@diag.uniroma1.it>
    inet: fix fast path in __inet_hash_connect()

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: mt7601u: fix an integer underflow

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: fix assignation of TX BD RAM table

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: brcmfmac: ensure CLM version is null-terminated to prevent stack-out-of-bounds

Holger Hoffstätte <holger@applied-asynchrony.com>
    bpftool: Always disable stack protection for BPF objects

Breno Leitao <leitao@debian.org>
    x86/bugs: Reset speculation control settings on init

Jann Horn <jannh@google.com>
    timers: Prevent union confusion from unexpected restart_syscall()

Yang Li <yang.lee@linux.alibaba.com>
    thermal: intel: Fix unsigned comparison with less than zero

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath11k: debugfs: fix to work with multiple PCI devices

Zqiang <qiang1.zhang@intel.com>
    rcu-tasks: Handle queue-shrink/callback-enqueue race condition

Zqiang <qiang1.zhang@intel.com>
    rcu-tasks: Make rude RCU-Tasks work well with CPU hotplug

Pingfan Liu <kernelfans@gmail.com>
    srcu: Delegate work to the boot cpu if using SRCU_SIZE_SMALL

Paul E. McKenney <paulmck@kernel.org>
    rcu: Suppress smp_processor_id() complaint in synchronize_rcu_expedited_wait()

Paul E. McKenney <paulmck@kernel.org>
    rcu: Make RCU_LOCKDEP_WARN() avoid early lockdep checks

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()

Nagarajan Maran <quic_nmaran@quicinc.com>
    wifi: ath11k: fix monitor mode bringup crash

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect()

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Add Meteor Lake support

Peter Zijlstra <peterz@infradead.org>
    cpuidle: lib/bug: Disable rcu_is_watching() during WARN/BUG

Mark Rutland <mark.rutland@arm.com>
    cpuidle: drivers: firmware: psci: Dont instrument suspend code

Jens Axboe <axboe@kernel.dk>
    x86/fpu: Don't set TIF_NEED_FPU_LOAD for PF_IO_WORKER threads

Peter Zijlstra <peterz@infradead.org>
    cpuidle, intel_idle: Fix CPUIDLE_FLAG_INIT_XSTATE

Michael Grzeschik <m.grzeschik@pengutronix.de>
    arm64: zynqmp: Enable hs termination flag for USB dwc3 controller

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: improve tree block error reporting

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    trace/blktrace: fix memory leak with using debugfs_lookup()

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: dropping parent refcount after pd_free_fn() is done

Li Nan <linan122@huawei.com>
    blk-iocost: fix divide by 0 error in calc_lcoefs()

Jann Horn <jannh@google.com>
    fs: Use CHECK_DATA_CORRUPTION() when kernel bugs are detected

Markuss Broks <markuss.broks@gmail.com>
    ARM: dts: exynos: Use Exynos5420 compatible for the MIPI video phy

Nicholas Piggin <npiggin@gmail.com>
    exit: Detect and fix irq disabled state in oops

Peter Zijlstra <peterz@infradead.org>
    context_tracking: Fix noinstr vs KASAN

Jan Kara <jack@suse.cz>
    udf: Define EFSCORRUPTED error code

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: msm8996: Add additional A2NoC clocks

Liang He <windhl@126.com>
    ARM: OMAP2+: omap4-common: Fix refcount leak bug

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Release driver_override

Bjorn Andersson <quic_bjorande@quicinc.com>
    rpmsg: glink: Avoid infinite loop on intent for missing channel

Tasos Sahanidis <tasos@tasossah.com>
    media: saa7134: Use video_unregister_device for radio_dev

Duoming Zhou <duoming@zju.edu.cn>
    media: usb: siano: Fix use after free bugs caused by do_submit_urb

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: i2c: ov7670: 0 instead of -EINVAL was returned

Hans de Goede <hdegoede@redhat.com>
    media: atomisp: Only set default_run_mode on first open of a stream/asd

Arnd Bergmann <arnd@arndb.de>
    media: atomisp: fix videobuf2 Kconfig depenendency

Duoming Zhou <duoming@zju.edu.cn>
    media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()

Dong Chuanjian <chuanjian@nfschina.com>
    media: drivers/media/v4l2-core/v4l2-h264 : add detection of null pointers

Ming Qian <ming.qian@nxp.com>
    media: amphion: correct the unspecified color space

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Apply clk_bulk api instead of operating specific clk

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: hantro: Fix JPEG encoder ENUM_FRMSIZE on RK3399

Ming Qian <ming.qian@nxp.com>
    media: v4l2-jpeg: ignore the unknown APP14 marker

Ming Qian <ming.qian@nxp.com>
    media: v4l2-jpeg: correct the skip count in jpeg_parse_app14_data

Arnd Bergmann <arnd@arndb.de>
    media: platform: mtk-mdp3: fix Kconfig dependencies

Arnd Bergmann <arnd@arndb.de>
    media: camss: csiphy-3ph: avoid undefined behavior

Qiheng Lin <linqiheng@huawei.com>
    media: platform: mtk-mdp3: Fix return value check in mdp_probe()

Jai Luthra <j-luthra@ti.com>
    media: i2c: imx219: Fix binning for RAW8 capture

Adam Ford <aford173@gmail.com>
    media: i2c: imx219: Split common registers from mode tables

Yuan Can <yuancan@huawei.com>
    media: i2c: ov772x: Fix memleak in ov772x_probe()

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: mc: Get media_device directly from pad

Jai Luthra <j-luthra@ti.com>
    media: ov5640: Handle delays when no reset_gpio set

Jai Luthra <j-luthra@ti.com>
    media: ov5640: Fix soft reset sequence and timings

Marco Felsch <m.felsch@pengutronix.de>
    media: i2c: tc358746: fix possible endianness issue

Marco Felsch <m.felsch@pengutronix.de>
    media: i2c: tc358746: fix ignoring read error in g_register callback

Marco Felsch <m.felsch@pengutronix.de>
    media: i2c: tc358746: fix missing return assignment

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

Nathan Chancellor <nathan@kernel.org>
    powerpc: Remove linker flag from KBUILD_AFLAGS

Yang Yingliang <yangyingliang@huawei.com>
    media: imx: imx7-media-csi: fix missing clk_disable_unprepare() in imx7_csi_init()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: platform: ti: Add missing check for devm_regulator_get

Gaosheng Cui <cuigaosheng1@huawei.com>
    media: ti: cal: fix possible memory leak in cal_ctx_create()

Sibi Sankar <quic_sibis@quicinc.com>
    remoteproc: qcom_q6v5_mss: Use a carveout to authenticate modem headers

Christoph Hellwig <hch@lst.de>
    Revert "remoteproc: qcom_q6v5_mss: map/unmap metadata region before/after use"

Patrick Kelsey <pat.kelsey@cornelisnetworks.com>
    IB/hfi1: Fix sdma.h tx->num_descs off-by-one errors

Patrick Kelsey <pat.kelsey@cornelisnetworks.com>
    IB/hfi1: Fix math bugs in hfi1_can_pin_pages()

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix missing memory barriers in rxe_queue.h

Long Li <longli@microsoft.com>
    RDMA/mana_ib: Fix a bug when the PF indicates more entries for registering memory on first packet

Bob Pearson <rpearsonhpe@gmail.com>
    Subject: RDMA/rxe: Handle zero length rdma

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Replace rxe_map and rxe_phys_buf by xarray

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Cleanup page variables in rxe_mr.c

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA-rxe: Isolate mr code from atomic_write_reply()

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA-rxe: Isolate mr code from atomic_reply()

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Move rxe_map_mr_sg to rxe_mr.c

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Cleanup mr_check_range

Tina Zhang <tina.zhang@intel.com>
    iommu/vt-d: Allow to use flush-queue when first level is default

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix error handling in sva enable/disable paths

Eric Pilmore <epilmore@gigaio.com>
    dmaengine: ptdma: check for null desc before calling pt_cmd_callback

Kees Cook <keescook@chromium.org>
    dmaengine: dw-axi-dmac: Do not dereference NULL structure

Shravan Chippa <shravan.chippa@microchip.com>
    dmaengine: sf-pdma: pdma_desc memory leak fix

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Do not identity map v2 capable device when snp is enabled

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Fix error unwind in iommu_group_alloc()

Dan Carpenter <error27@gmail.com>
    iw_cxgb4: Fix potential NULL dereference in c4iw_fill_res_cm_id_entry()

Johan Hovold <johan+linaro@kernel.org>
    PCI: qcom: Fix host-init error handling

Neill Kapron <nkapron@google.com>
    phy: rockchip-typec: fix tcphy_get_mode error case

Geert Uytterhoeven <geert+renesas@glider.be>
    PCI: Fix dropping valid root bus resources with .end = zero

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dmaengine: dw-edma: Fix readq_ch() return value truncation

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: host: fsl-mph-dr-of: reuse device_set_of_node_from_dev

Saravana Kannan <saravanak@google.com>
    mtd: mtdpart: Don't create platform device that'll never probe

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Make cycle detection more robust

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Improve check for fwnode with no device/driver

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Consolidate device link flag computation

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Allow marking a fwnode link as being part of a cycle

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Don't purge child fwnode's consumer links

Saravana Kannan <saravanak@google.com>
    driver core: fw_devlink: Add DL_FLAG_CYCLE support to device links

Peng Fan <peng.fan@nxp.com>
    tty: serial: imx: disable Ageing Timer interrupt request irq

Shenwei Wang <shenwei.wang@nxp.com>
    serial: fsl_lpuart: fix RS485 RTS polariy inverse issue

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Cap MSIX used to online CPUs + 1

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    usb: max-3421: Fix setting of I/O pins

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    RDMA/cxgb4: Fix potential null-ptr-deref in pass_establish()

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix user page pinning accounting

Andreas Kemnade <andreas@kemnade.info>
    power: supply: remove faulty cooling logic

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Set No Execute Enable bit in PASID table entry

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    PCI: mt7621: Delay phy ports initialization

Chunfeng Yun <chunfeng.yun@mediatek.com>
    phy: mediatek: remove temporary variable @mask_

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: configfs: Restrict symlink creation is UDC already binded

Dan Carpenter <error27@gmail.com>
    usb: musb: mediatek: don't unregister something that wasn't registered

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    RDMA/cxgb4: add null-ptr-check after ip_dev_find()

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: Fix the wrong RXWATER setting for rx dma case

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: early: xhci-dbc: Fix a potential out-of-bound memory access

Ivan Bornyakov <i.bornyakov@metrotek.ru>
    fpga: microchip-spi: rewrite status polling in a time measurable way

Ivan Bornyakov <i.bornyakov@metrotek.ru>
    fpga: microchip-spi: move SPI I/O buffers out of stack

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dmaengine: dw-edma: Fix missing src/dst address of interleaved xfers

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Add missing completion handler

Yi Liu <yi.l.liu@intel.com>
    iommufd: Add three missing structures in ucmd_buffer

Nicolin Chen <nicolinc@nvidia.com>
    selftests: iommu: Fix test_cmd_destroy_access() call in user_copy

Chen Zhongjin <chenzhongjin@huawei.com>
    firmware: dmi-sysfs: Fix null-ptr-deref in dmi_sysfs_register_handle

Yang Yingliang <yangyingliang@huawei.com>
    drivers: base: transport_class: fix resource leak when transport_add_device() fails

Yang Yingliang <yangyingliang@huawei.com>
    drivers: base: transport_class: fix possible memory leak

Hanjun Guo <guohanjun@huawei.com>
    driver core: location: Free struct acpi_pld_info *pld before return false

Zhengchao Shao <shaozhengchao@huawei.com>
    driver core: fix resource leak in device_add()

Yang Yingliang <yangyingliang@huawei.com>
    iommu/exynos: Fix error handling in exynos_iommu_init()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    misc: fastrpc: Fix an error handling path in fastrpc_rpmsg_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    misc/mei/hdcp: Use correct macros to initialize uuid_le

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mei: pxp: Use correct macros to initialize uuid_le

George Kennedy <george.kennedy@oracle.com>
    VMCI: check context->notify_page after call to get_user_pages_fast() to avoid GPF

Yang Yingliang <yangyingliang@huawei.com>
    firmware: stratix10-svc: fix error handle while alloc/add device failed

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

Yicong Yang <yangyicong@hisilicon.com>
    hwtracing: hisi_ptt: Only add the supported devices to the filters list

Yang Yingliang <yangyingliang@huawei.com>
    PCI: endpoint: pci-epf-vntb: Add epf_ntb_mw_bar_clear() num_mws kernel-doc

Bjorn Helgaas <bhelgaas@google.com>
    PCI: switchtec: Return -EFAULT for copy_to_user() errors

Alexey V. Vissarionov <gremlin@altlinux.org>
    PCI/IOV: Enlarge virtfn sysfs name buffer

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: typec: intel_pmc_mux: Don't leak the ACPI device reference count

Mao Jinlong <quic_jinlmao@quicinc.com>
    coresight: cti: Add PM runtime call in enable_store

James Clark <james.clark@arm.com>
    coresight: cti: Prevent negative values of enable count

Junhao He <hejunhao3@huawei.com>
    coresight: etm4x: Fix accesses to TRCSEQRSTEVR and TRCSEQSTR

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Refactor power_line_frequency_controls_limited

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Refactor uvc_ctrl_mappings_uvcXX

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Implement mask for V4L2_CTRL_TYPE_MENU

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: uvcvideo: Check for INACTIVE in uvc_ctrl_is_accessible()

Al Viro <viro@zeniv.linux.org.uk>
    alpha/boot/tools/objstrip: fix the check for ELF header

Wang Hai <wanghai38@huawei.com>
    kobject: Fix slab-out-of-bounds in fill_kobj_path()

Yang Yingliang <yangyingliang@huawei.com>
    driver core: fix potential null-ptr-deref in device_add()

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Don't overflow the command FIFOs

Yang Yingliang <yangyingliang@huawei.com>
    i2c: qcom-geni: change i2c_master_hub to static

Hanna Hawa <hhhawa@amazon.com>
    i2c: designware: fix i2c_dw_clk_rate() return size to be u32

Gaosheng Cui <cuigaosheng1@huawei.com>
    usb: gadget: fusb300_udc: free irq on the error path in fusb300_probe()

Ferry Toth <ftoth@exalondelft.nl>
    iio: light: tsl2563: Do not hardcode interrupt trigger type

Miaoqian Lin <linmq006@gmail.com>
    RDMA/hns: Fix refcount leak in hns_roce_mmap

Geert Uytterhoeven <geert+renesas@glider.be>
    dmaengine: HISI_DMA should depend on ARCH_HISI

Miaoqian Lin <linmq006@gmail.com>
    RDMA/erdma: Fix refcount leak in erdma_mmap

Fenghua Yu <fenghua.yu@intel.com>
    dmaengine: idxd: Set traffic class values in GRPCFG on DSA 2.0

Qiheng Lin <linqiheng@huawei.com>
    mfd: pcf50633-adc: Fix potential memleak in pcf50633_adc_async_read()

Randy Dunlap <rdunlap@infradead.org>
    mfd: cs5535: Don't build on UML

Tom Fitzhenry <tom@tom-fitzhenry.me.uk>
    mfd: rk808: Re-add rk808-clkout to RK818

Ondrej Mosnacek <omosnace@redhat.com>
    sysctl: fix proc_dobool() usability

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix probepoint testcase to ignore __pfx_* symbols

Arnd Bergmann <arnd@arndb.de>
    objtool: add UACCESS exceptions for __tsan_volatile_read/write

Kajol Jain <kjain@linux.ibm.com>
    perf tests stat_all_metrics: Change true workload to sleep workload for system wide check

Arnd Bergmann <arnd@arndb.de>
    printf: fix errname.c list

Yang Jihong <yangjihong1@huawei.com>
    perf record: Fix segfault with --overwrite and --max-size

Guillaume Tucker <guillaume.tucker@collabora.com>
    selftests: use printf instead of echo -ne

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix bash specific "==" operator

Guillaume Tucker <guillaume.tucker@collabora.com>
    selftests: find echo binary to use -ne options

Randy Dunlap <rdunlap@infradead.org>
    sparc: allow PM configs for sparc32 COMPILE_TEST

Ian Rogers <irogers@google.com>
    perf stat: Avoid merging/aggregating metric counts twice

Yicong Yang <yangyicong@hisilicon.com>
    perf tools: Fix auto-complete on aarch64

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    perf test bpf: Skip test if kernel-debuginfo is not present

Ian Rogers <irogers@google.com>
    perf jevents: Correct bad character encoding

Namhyung Kim <namhyung@kernel.org>
    perf stat: Hide invalid uncore event output for aggr mode

Namhyung Kim <namhyung@kernel.org>
    perf intel-pt: Do not try to queue auxtrace data on pipe

Namhyung Kim <namhyung@kernel.org>
    perf inject: Use perf_data__read() for auxtrace

Andreas Ziegler <br015@umbiko.net>
    tools/tracing/rtla: osnoise_hist: use total duration for average calculation

Henning Schild <henning.schild@siemens.com>
    leds: simatic-ipc-leds-gpio: Make sure we have the GPIO providing driver

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    leds: is31fl319x: Wrap mutex_destroy() for devm_add_action_or_rest()

Miaoqian Lin <linmq006@gmail.com>
    leds: led-core: Fix refcount leak in of_led_get()

Ian Rogers <irogers@google.com>
    perf llvm: Fix inadvertent file creation

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: jdata writepage fix

Shyam Prasad N <sprasad@microsoft.com>
    cifs: use tcon allocation functions even for dummy tcon

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix warning and UAF when destroy the MR list

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix lost destroy smbd connection when MR allocate failed

Chuck Lever <chuck.lever@oracle.com>
    NFSD: copy the whole verifier in nfsd_copy_write_verifier

Jeff Layton <jlayton@kernel.org>
    nfsd: don't fsync nfsd_files on last close

Jeff Layton <jlayton@kernel.org>
    nfsd: fix courtesy client with deny mode handling in nfs4_upgrade_open

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix problems with cleanup on errors in nfsd4_copy

Jeff Layton <jlayton@kernel.org>
    nfsd: clean up potential nfsd_file refcount leaks in COPY codepath

Benjamin Coddington <bcodding@redhat.com>
    nfsd: fix race to check ls_layouts

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix leaked reference count of nfsd4_ssc_umount_item

Dai Ngo <dai.ngo@oracle.com>
    NFSD: enhance inter-server copy cleanup

Asahi Lina <lina@asahilina.net>
    drm/shmem-helper: Fix locking for drm_gem_shmem_get_pages_sgt()

Orlando Chamberlain <orlandoch.dev@gmail.com>
    ALSA: hda/hdmi: Register with vga_switcheroo on Dual GPU Macbooks

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

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/i915: Fix GEN8_MISCCPCTL

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/pvc: Annotate two more workaround/tuning registers as MCR

Wayne Boyer <wayne.boyer@intel.com>
    drm/i915/pvc: Implement recommended caching policy

NeilBrown <neilb@suse.de>
    NFS: fix disabling of swap

Benjamin Coddington <bcodding@redhat.com>
    nfs4trace: fix state manager flag printing

Mike Snitzer <snitzer@kernel.org>
    dm: remove flush_scheduled_work() during local_exit()

Steffen Aschbacher <steffen.aschbacher@stihl.de>
    ASoC: tlv320adcx140: fix 'ti,gpio-config' DT property init

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (mlxreg-fan) Return zero speed for broken fan

William Zhang <william.zhang@broadcom.com>
    spi: bcm63xx-hsspi: Fix multi-bit mode setting

Bastien Nocera <hadess@hadess.net>
    HID: logitech-hidpp: Hard-code HID++ 1.0 fast scroll support

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amd/display: don't call dc_interrupt_set() for disabled crtcs

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: lpass: fix incorrect mclk rate

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: lpass: register mclk after runtime pm

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: q6apm-dai: Add SNDRV_PCM_INFO_BATCH flag

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: q6apm-dai: fix race condition while updating the position pointer

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: q6apm-lpass-dai: unprepare stream if its already prepared

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

Jaroslav Kysela <perex@perex.cz>
    ALSA: hda: Fix the control element identification for multiple codecs

Jonathan Cormier <jcormier@criticallink.com>
    hwmon: (ltc2945) Handle error case in ltc2945_value_store

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) add missing mutex path

Jerome Neanne <jneanne@baylibre.com>
    regulator: tps65219: use generic set_bypass()

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: dt-bindings: meson: fix gx-card codec node regex

Nathan Chancellor <nathan@kernel.org>
    ASoC: mchp-spdifrx: Fix uninitialized use of mr in mchp_spdifrx_hw_params()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: fixup #endif position

Arnd Bergmann <arnd@arndb.de>
    accel: fix CONFIG_DRM dependencies

Daniel Golle <daniel@makrotopia.org>
    regmap: apply reg_base and reg_downshift for single register ops

Mike Snitzer <snitzer@kernel.org>
    dm: improve shrinker debug names

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

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Properly access value coming from topology file

Haibo Chen <haibo.chen@nxp.com>
    gpio: vf610: connect GPIO label to dev name

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: pca9570: rename platform_data to chip_data

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    dt-bindings: display: mediatek: Fix the fallback for mediatek,mt8186-disp-ccorr

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

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/xehp: Annotate a couple more workaround registers as MCR

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix configuring the GPIO pins as interrupts

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/xehp: GAM registers don't need to be re-applied on engine resets

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/mtl: Add initial gt workarounds

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: firewall: Check for is_addr_reg existence in IMM check

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Don't skip assigning syncpoints to channels

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Fix mask for syncpoint increment register

Guodong Liu <Guodong.Liu@mediatek.com>
    pinctrl: mediatek: Initialize variable *buf to zero

Guodong Liu <Guodong.Liu@mediatek.com>
    pinctrl: mediatek: Initialize variable pullen and pullup to zero

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: bcm2835: Remove of_node_put() in bcm2835_of_gpio_ranges_fallback()

farah kassabri <fkassabri@habana.ai>
    habanalabs: bugs fixes in timestamps buff alloc

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/mdp5: Add check for kzalloc

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dpu: Add check for pstates

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/dpu: Add check for cstate

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: use strscpy instead of strncpy

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: sc7180: add missing WB2 clock control

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: exynos: Fix DMA alignment for PAGE_SIZE != 4096

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/dsi: Allow 2 CTRLs on v2.5.0

Jagan Teki <jagan@amarulasolutions.com>
    drm: exynos: dsi: Fix MIPI_DSI*_NO_* mode flags

Daniel Mentz <danielmentz@google.com>
    drm/mipi-dsi: Fix byte order of 16-bit DCS set/get brightness

Randy Dunlap <rdunlap@infradead.org>
    regulator: tps65219: use IS_ERR() to detect an error pointer

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

Leo Liu <leo.liu@amd.com>
    drm/amdgpu: Use the sched from entity for amdgpu_cs trace

Alexey V. Vissarionov <gremlin@altlinux.org>
    ALSA: hda/ca0132: minor fix for allocation size

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/adreno: Fix null ptr access in adreno_gpu_cleanup()

Marek Vasut <marex@denx.de>
    drm/bridge: tc358767: Set default CLRSIPO count

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: initialize is_dsp_mode flag

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: edif: Fix clang warning

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix exchange oversubscription for management commands

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix exchange oversubscription

Abel Vesa <abel.vesa@linaro.org>
    drm/panel-edp: fix name for IVO product id 854b

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm: clean event_thread->worker in case of an error

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hdmi: Correct interlaced timings again

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Fix colour order for xRGB1555 on HVS5

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Correct interrupt masking bit assignment for HVS5

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: SCALER_DISPBKGND_AUTOHS is only valid on HVS4

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Set AXI panic modes

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Configure the HVS COB allocations

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups

Miaoqian Lin <linmq006@gmail.com>
    pinctrl: stm32: Fix refcount leak in stm32_pctrl_get_irq_domain

Adam Skladowski <a39.skl@gmail.com>
    pinctrl: qcom: pinctrl-msm8976: Correct function names for wcss pins

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/msm/hdmi: Add missing check for alloc_ordered_workqueue

Hui Tang <tanghui20@huawei.com>
    drm/msm/dpu: check for null return of devm_kzalloc() in dpu_writeback_init()

Armin Wolf <W_Armin@gmx.de>
    hwmon: (ftsteutates) Fix scaling of measurements

Maíra Canal <mcanal@igalia.com>
    drm/vc4: drop all currently held locks if deadlock happens

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Init iosys_map pointer as I/O memory for damage handling

Liang He <windhl@126.com>
    gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()

Randolph Sapp <rs@ti.com>
    drm: tidss: Fix pixel format definition

Pin-yen Lin <treapking@chromium.org>
    drm/bridge: it6505: Guard bridge power in IRQ handler

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: dpi: Fix format mapping for RGB565

Maxime Ripard <maxime@cerno.tech>
    drm/modes: Use strscpy() to copy command-line mode name

Yuan Can <yuancan@huawei.com>
    drm/vkms: Fix null-ptr-deref in vkms_release()

Yuan Can <yuancan@huawei.com>
    drm/vkms: Fix memory leak in vkms_init()

Yuan Can <yuancan@huawei.com>
    drm/bridge: megachips: Fix error handling in i2c_register_driver()

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC

Geert Uytterhoeven <geert+renesas@glider.be>
    drm: mxsfb: DRM_IMX_LCDIF should depend on ARCH_MXC

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

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Align IPsec ASO result memory to be as required by hardware

Kees Cook <keescook@chromium.org>
    net/mlx4_en: Introduce flexible array to silence overflow warning

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix possible deadlock inside PTP

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: fix MoCA LED control

Shigeru Yoshida <syoshida@redhat.com>
    l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/net: Interpret UDP_GRO cmsg data as an int value

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix application data exception

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix potential panic dues to unprotected smc_llc_srv_add_link()

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-bcm7120-l2: Set IRQ_LEVEL for level triggered interrupts

Florian Fainelli <f.fainelli@gmail.com>
    irqchip/irq-brcmstb-l2: Set IRQ_LEVEL for level triggered interrupts

Andrii Nakryiko <andrii@kernel.org>
    bpf: Fix global subprog context argument resolution logic

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch, bpf: Use 4 instructions for function address in JIT

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: check IFF_UP earlier in Tx path

Frank Jungclaus <frank.jungclaus@esd.eu>
    can: esd_usb: Make use of can_change_state() and relocate checking skb for NULL

Frank Jungclaus <frank.jungclaus@esd.eu>
    can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Fix xdp_do_redirect on s390x

Hou Tao <houtao1@huawei.com>
    bpf: Zeroing allocated object from slab in bpf memory allocator

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: pass 'sta' to ieee80211_rx_data_set_sta()

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: Fix map_kptr test.

Yongqin Liu <yongqin.liu@linaro.org>
    thermal/drivers/hisi: Drop second sensor hi3660

Vincent Guittot <vincent.guittot@linaro.org>
    tools/lib/thermal: Fix thermal_sampling_exit()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix off-by-one link setting

Arnd Bergmann <arnd@arndb.de>
    wifi: mac80211: avoid u32_encode_bits() warning

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    wifi: mac80211: Don't translate MLD addresses for multicast

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: mac80211: fix non-MLO station association

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mac80211: move color collision detection report in a delayed work

Eric Farman <farman@linux.ibm.com>
    vfio/ccw: remove WARN_ON during shutdown

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: crypto4xx - Call dma_unmap_page when done

Alexander Lobakin <alobakin@pm.me>
    crypto: octeontx2 - Fix objects shared between several modules

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: resource: Do IRQ override on all TongFang GMxRGxx

Adam Niederer <adam.niederer@gmail.com>
    ACPI: resource: Add IRQ overrides for MAINGEAR Vector Pro 2 models

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Fix out-of-srctree build

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: fix parsing offset for MCC C2H

Dan Carpenter <error27@gmail.com>
    wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()

Hector Martin <marcan@marcan.st>
    wifi: brcmfmac: pcie: Perform correct BCM4364 firmware selection

Hector Martin <marcan@marcan.st>
    wifi: brcmfmac: pcie: Add IDs/properties for BCM4377

Hector Martin <marcan@marcan.st>
    wifi: brcmfmac: pcie: Add IDs/properties for BCM4355

Hector Martin <marcan@marcan.st>
    wifi: brcmfmac: Rename Cypress 89459 to BCM4355

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    wifi: iwl4965: Add missing check for create_singlethread_workqueue()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    wifi: iwl3945: Add missing check for create_singlethread_workqueue

Matt Evans <mev@rivosinc.com>
    clocksource/drivers/riscv: Patch riscv_clock_next_event() jump before first use

Conor Dooley <conor.dooley@microchip.com>
    RISC-V: time: initialize hrtimer based broadcast clock event device

Randy Dunlap <rdunlap@infradead.org>
    m68k: /proc/hardware should depend on PROC_FS

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rsa-pkcs1pad - Use akcipher_request_complete

Pietro Borrello <borrello@diag.uniroma1.it>
    rds: rds_rm_zerocopy_callback() correct order for list_add_tail()

Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
    xen/grant-dma-iommu: Implement a dummy probe_device() callback

Ilya Leoshkevich <iii@linux.ibm.com>
    libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()

Halil Pasic <pasic@linux.ibm.com>
    s390/ap: fix status returned by ap_qact()

Halil Pasic <pasic@linux.ibm.com>
    s390/ap: fix status returned by ap_aqic()

Halil Pasic <pasic@linux.ibm.com>
    s390: vfio-ap: tighten the NIB validity check

Alex Elder <elder@linaro.org>
    net: ipa: generic command param fix

Zhengping Jiang <jiangzp@google.com>
    Bluetooth: hci_qca: get wakeup status from serdev device handle

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix potential user-after-free

Kees Cook <keescook@chromium.org>
    Bluetooth: hci_conn: Refactor hci_bind_bis() since it always succeeds

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    cpufreq: davinci: Fix clk use after free

Qi Zheng <zhengqi.arch@bytedance.com>
    OPP: fix error checking in opp_migrate_dentry()

David Howells <dhowells@redhat.com>
    rxrpc: Fix overwaking on call poking

Pietro Borrello <borrello@diag.uniroma1.it>
    tap: tap_open(): correctly initialize socket uid

Pietro Borrello <borrello@diag.uniroma1.it>
    tun: tun_chr_open(): correctly initialize socket uid

Pietro Borrello <borrello@diag.uniroma1.it>
    net: add sock_init_data_uid()

Vasily Gorbik <gor@linux.ibm.com>
    s390/boot: fix mem_detect extended area allocation

Vasily Gorbik <gor@linux.ibm.com>
    s390/mem_detect: rely on diag260() if sclp_early_get_memsize() fails

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/boot: cleanup decompressor header files

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

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: rely on mt76_connac2_mac_tx_rate_val

Aaron Ma <aaron.ma@canonical.com>
    wifi: mt76: mt7921: fix error code of return in mt7921_acpi_read

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: add memory barrier to SDIO queue kick

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7915: fix WED TxS reporting

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: fix switch default case in mt7996_reverse_frag0_hdr_trans

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: dma: fix memory leak running mt76_dma_tx_cleanup

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: fix memory leak in mt7996_mcu_exit

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7915: fix memory leak in mt7915_mcu_exit

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: mt7921: fix invalid remain_on_channel duration

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: connac: fix POWER_CTRL command name typo

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: update register for CFEND_RATE

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: fix chainmask calculation in mt7996_set_antenna()

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: mt7921: fix channel switch fail in monitor mode

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7915: rework mt7915_thermal_temp_store()

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7915: rework mt7915_mcu_set_thermal_throttling

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7915: call mt7915_mcu_set_thermal_throttling() only after init_work

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7921: fix deadlock in mt7921_abort_roc

Tonghao Zhang <tong@infragraf.org>
    bpftool: profile online CPUs instead of possible

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - Flush the SEV-ES TMR memory before giving it to firmware

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests/bpf: Initialize tc in xdp_synproxy

Geert Uytterhoeven <geert+renesas@glider.be>
    can: rcar_canfd: Fix R-Car V3U GAFLCFG field accesses

Geert Uytterhoeven <geert+renesas@glider.be>
    can: rcar_canfd: Fix R-Car V3U CAN mode selection

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix enumeration of systems without 128 bit SME

Gregory Greenman <gregory.greenman@intel.com>
    wifi: iwlwifi: mei: fix compilation errors in rfkill()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Add expoline to tail calls

Kees Cook <keescook@chromium.org>
    drm/nouveau/disp: Fix nvif_outp_acquire_dp() argument size

Hans de Goede <hdegoede@redhat.com>
    leds: led-class: Add missing put_device() to led_put()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: xts - Handle EBUSY correctly

Daniel T. Lee <danieltimlee@gmail.com>
    selftests/bpf: Fix vmtest static compilation error

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Adjust late loading result reporting message

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Check CPU capabilities after late microcode update correctly

Ashok Raj <ashok.raj@intel.com>
    x86/microcode: Add a parameter to microcode_check() to store CPU capabilities

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix partial dynptr stack slot reads/writes

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix missing var_off check for ARG_PTR_TO_DYNPTR

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix state pruning for STACK_DYNPTR stack slots

Yang Yingliang <yangyingliang@huawei.com>
    powercap: fix possible name leak in powercap_register_zone()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: seqiv - Handle EBUSY correctly

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: essiv - Handle EBUSY correctly

Koba Ko <koba.taiwan@gmail.com>
    crypto: ccp - Failure on re-initialization due to duplicate sysfs filename

Tiezhu Yang <yangtiezhu@loongson.cn>
    selftests/bpf: Fix build errors if CONFIG_NF_CONNTRACK=m

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

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function

Viorel Suman <viorel.suman@nxp.com>
    thermal/drivers/imx_sc_thermal: Fix the loop condition

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    wifi: rtw88: Use non-atomic sta iterator in rtw_ra_mask_info_update()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    wifi: rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: orinoco: check return value of hermes_write_wordrec()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix memory leaks with RTL8723BU, RTL8192EU

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    wifi: rtw89: Add missing check for alloc_workqueue

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: fix potential leak in rtw89_append_probe_req_ie()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: limit num_sensors to 9 for msm8939

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: fix slope values for msm8939

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: Sort out msm8976 vs msm8956 data

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    thermal/drivers/tsens: Drop msm8976-specific defines

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    x86/signal: Fix the value returned by strict_sas_size()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    s390/vfio-ap: fix an error handling path in vfio_ap_mdev_probe_queue()

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/early: fix sclp_early_sccb variable lifetime

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    workqueue: Protects wq_unbound_cpumask with wq_pool_attach_mutex

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix syscall-abi for systems without 128 bit SME

Mark Brown <broonie@kernel.org>
    arm64/sysreg: Fix errors in 32 bit enumeration values

Mark Brown <broonie@kernel.org>
    arm64/cpufeature: Fix field sign for DIT hwcap detection

Magnus Karlsson <magnus.karlsson@intel.com>
    selftests/xsk: print correct error codes when exiting

Magnus Karlsson <magnus.karlsson@intel.com>
    selftests/xsk: print correct payload for packet dump

Michal Suchanek <msuchanek@suse.de>
    bpf_doc: Fix build error with older python versions

Ludovic L'Hours <ludovic.lhours@gmail.com>
    libbpf: Fix map creation flags sanitization

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: nsrepair: handle cases without a return value correctly

Prashant Malani <pmalani@chromium.org>
    platform/chrome: cros_ec_typec: Update port DP VDO

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

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    crypto: ux500 - update debug config after ux500 cryp driver removal

Eric Biggers <ebiggers@google.com>
    crypto: x86/ghash - fix unaligned access in ghash_setkey()

Daniel T. Lee <danieltimlee@gmail.com>
    libbpf: Fix invalid return address register in s390

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

Wang Yufen <wangyufen@huawei.com>
    wifi: wilc1000: add missing unregister_netdev() in wilc_netdev_ifc_init()

Zhang Changzhong <zhangchangzhong@huawei.com>
    wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: ipw2200: fix memory leak in ipw_wdev_init()

Yang Yingliang <yangyingliang@huawei.com>
    wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix btf__align_of() by taking into account field offsets

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix single-line struct definition output in btf_dump

Li Zetao <lizetao1@huawei.com>
    wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: 8852c: rfk: correct DPK settings

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: 8852c: rfk: correct DACK setting

Yang Yingliang <yangyingliang@huawei.com>
    wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix assignment to bit field priv->cck_agc_report_type

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix assignment to bit field priv->pi_enabled

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

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921: resource leaks at mt7921_check_offload_capability()

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: fix coverity uninit_use_in_call in mt76_connac2_reverse_frag0_hdr_trans()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7915: fix unintended sign extension of mt7915_hw_queue_read()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7996: fix unintended sign extension of mt7996_hw_queue_read()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt76x0: fix oob access in mt76x0_phy_get_target_power

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: fix endianness warning in mt7996_mcu_sta_he_tlv

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7996: drop always true condition of __mt7996_reg_addr()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7915: drop always true condition of __mt7915_reg_addr()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7996: check return value before accessing free_block_num

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7915: check return value before accessing free_block_num

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7996: fix integer handling issue of mt7996_rf_regval_set()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7996: fix insecure data handling of mt7996_mcu_rx_radar_detected()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7996: fix insecure data handling of mt7996_mcu_ie_countdown()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7915: fix mt7915_rate_txpower_get() resource leaks

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: mt7921s: fix slab-out-of-bounds access in sdio host

Wang Yufen <wangyufen@huawei.com>
    wifi: mt76: mt7915: add missing of_node_put()

Jens Axboe <axboe@kernel.dk>
    block: use proper return value from bio_failfast()

Martin K. Petersen <martin.petersen@oracle.com>
    block: bio-integrity: Copy flags when bio_integrity_payload is cloned

Jinke Han <hanjinke.666@bytedance.com>
    block: Fix io statistics for cgroup in throttle path

Ming Lei <ming.lei@redhat.com>
    block: sync mixed merged request's failfast with 1st bio's

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: relinquish volume with mutex held

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: pmk8350: Use the correct PON compatible

Liu Xiaodong <xiaodong.liu@intel.com>
    block: ublk: check IO buffer based on flag need_get_data

Denis Kenzior <denkenz@gmail.com>
    KEYS: asymmetric: Fix ECDSA use via keyctl uapi

silviazhao <silviazhao-oc@zhaoxin.com>
    x86/perf/zhaoxin: Add stepping check for ZXC

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/ds: Fix the conversion from TSC to perf time

Pietro Borrello <borrello@diag.uniroma1.it>
    sched/rt: pick_next_rt_entity(): check list_entry

Richard Guy Briggs <rgb@redhat.com>
    io_uring,audit: don't log IORING_OP_MADVISE

Qiheng Lin <linqiheng@huawei.com>
    s390/dasd: Fix potential memleak in dasd_eckd_init()

Petr Vorel <pvorel@suse.cz>
    arm64: dts: qcom: msm8992-lg-bullhead: Enable regulators

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6115: correct TLMM gpio-ranges

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: msm8953: correct TLMM gpio-ranges

Jamie Douglass <jamiemdouglass@gmail.com>
    arm64: dts: qcom: msm8992-lg-bullhead: Correct memory overlaps with the SMEM and MPSS memory regions

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: drop incorrect cells from serial

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8350: drop incorrect cells from serial

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996 switch from RPM_SMD_BB_CLK1 to RPM_SMD_XO_CLK_SRC

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: support using GPLL0 as kryocc input

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: correct stale comment of .get_budget

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: Fix potential io hung for shared sbitmap per tagset

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: wait on correct sbitmap_queue in blk_mq_mark_tag_wait

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: remove stale comment for blk_mq_sched_mark_restart_hctx

Kemeng Shi <shikemeng@huaweicloud.com>
    blk-mq: avoid sleep in blk_mq_alloc_request_hctx

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sm8450-nagara: Correct firmware paths

Patrick Delaunay <patrick.delaunay@foss.st.com>
    ARM: dts: stm32: Update part number NVMEM description on stm32mp131

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    arm64: dts: mediatek: mt7986: Fix watchdog compatible

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8195: Fix watchdog compatible

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8186: Fix watchdog compatible

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt8186: Fix CPU map for single-cluster SoC

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt8192: Fix CPU map for single-cluster SoC

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt8195: Fix CPU map for single-cluster SoC

Kemeng Shi <shikemeng@huaweicloud.com>
    sbitmap: correct wake_batch recalculation to avoid potential IO hung

Kemeng Shi <shikemeng@huaweicloud.com>
    sbitmap: remove redundant check in __sbitmap_queue_get_batch

Peng Fan <peng.fan@nxp.com>
    ARM: dts: imx7s: correct iomuxc gpr mux controller cells

Ming Lei <ming.lei@redhat.com>
    ublk_drv: don't probe partitions if the ubq daemon isn't trusted

Ming Lei <ming.lei@redhat.com>
    ublk_drv: remove nr_aborted_queues from ublk_device

Samuel Holland <samuel@sholland.org>
    ARM: dts: sun8i: nanopi-duo2: Fix regulator GPIO reference

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: bananapi-m5: switch VDDIO_C pin to OPEN_DRAIN

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson: radxa-zero: allow usb otg mode

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: beacon-renesom: Fix gpio expander reference

Mikko Perttunen <mperttunen@nvidia.com>
    arm64: tegra: Mark host1x as dma-coherent on Tegra194/234

Thierry Reding <treding@nvidia.com>
    arm64: tegra: Sort nodes by unit-address, then alphabetically

Thierry Reding <treding@nvidia.com>
    arm64: tegra: Bump #address-cells and #size-cells

Waiman Long <longman@redhat.com>
    locking/rwsem: Disable preemption in all down_read*() and up_read() code paths

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-sm1-odroid-hc4: fix active fan thermal trip

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-g12b-odroid-go-ultra: fix rk818 pmic properties

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
    arm64: dts: amlogic: meson-axg-jethome-jethub-j1xx: fix invalid rtc node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl-s905w-jethome-jethub-j80: fix invalid rtc node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gx: add missing unit address to rng node name

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-gxl-s905d-sml5442tw: drop invalid clock-names property

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: amlogic: meson-axg-jethome-jethub-j1xx: fix supply name of USB controller node

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

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8192: Mark scp_adsp clock as broken

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

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: fix Gen2 PCIe QMP PHY

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: correct USB3 QMP PHY-s clock output names

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8956: use SoC-specific compat for tsens

Petr Vorel <petr.vorel@gmail.com>
    arm64: dts: qcom: msm8992-bullhead: Disable dfps_data_mem

Petr Vorel <petr.vorel@gmail.com>
    arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem size

Thierry Reding <treding@nvidia.com>
    arm64: tegra: Fix duplicate regulator on Jetson TX1

Dhruva Gole <d-gole@ti.com>
    arm64: dts: ti: k3-am62-main: Fix clocks for McSPI

Peter Zijlstra <peterz@infradead.org>
    cpuidle, intel_idle: Fix CPUIDLE_FLAG_IRQ_ENABLE *again*

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix the SCPI DVFS node name and unit address

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gx: Fix Ethernet MAC address unit name

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-axg: jethub-j1xx: Fix MAC address node names

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gxl: jethub-j80: Fix Bluetooth MAC node name

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: meson-gxl: jethub-j80: Fix WiFi MAC address node

Bjorn Andersson <quic_bjorande@quicinc.com>
    arm64: dts: qcom: sc8280xp: Vote for CX in USB controllers

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996-oneplus-common: drop vdda-supply from DSI PHY

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm845: make DP node follow the schema

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: correct Soundwire wakeup interrupt name

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc8280xp: correct SPMI bus address cells

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7280: correct SPMI bus address cells

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7180: correct SPMI bus address cells

Kishon Vijay Abraham I <kvijayab@amd.com>
    x86/acpi/boot: Do not register processors that cannot be onlined for x2APIC

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-xiaomi-beryllium: fix audio codec interrupt pin name

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-db845c: fix audio codec interrupt pin name

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8186: Fix systimer 13 MHz clock description

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8195: Fix systimer 13 MHz clock description

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8192: Fix systimer 13 MHz clock description

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183: Fix systimer 13 MHz clock description

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8195: Add power domain to U3PHY1 T-PHY

Yang Yingliang <yangyingliang@huawei.com>
    fs: dlm: fix return value check in dlm_memory_init()

Qiheng Lin <linqiheng@huawei.com>
    ARM: zynq: Fix refcount leak in zynq_early_slcr_init

Marek Vasut <marex@denx.de>
    arm64: dts: imx8m: Align SoC unique ID node unit address

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm6125-seine: Clean up gpio-keys (volume down)

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm6125: Reorder HSUSB PHY clocks to match bindings

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm6350-lena: Flatten gpio-keys pinctrl state

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sm8350-sagami: Rectify GPIO keys

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sm8350-sagami: Add GPIO line names for PMIC GPIOs

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sm8350-sagami: Configure SLG51000 PMIC on PDX215

Dzmitry Sankouski <dsankouski@gmail.com>
    arm64: dts: qcom: Re-enable resin on MSM8998 and SDM845 boards

Richard Acayan <mailingradian@gmail.com>
    arm64: dts: qcom: sdm670-google-sargo: keep pm660 ldo8 on

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sm6350: Fix up the ramoops node

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: pmi8950: Correct rev_1250v channel label to mv

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: sm8150-kumano: Panel framebuffer is 2.5k instead of 4k

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sm6115: Provide xo clk to rpmcc

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sm6115: Fix UFS node

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: msm8996-tone: Fix USB taking 6 minutes to wake up

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qcs404: use symbol names for PCIe resets

Chen Hui <judy.chenhui@huawei.com>
    ARM: OMAP2+: Fix memory leak in realtime_counter_init()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: ahci: Revert "ata: ahci: Add Tiger Lake UP{3,4} AHCI controller"

Anders Roxell <anders.roxell@linaro.org>
    powerpc/mm: Rearrange if-else block to avoid clang warning

Vasant Hegde <vasant.hegde@amd.com>
    iommu: Attach device group to old domain in error path

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Improve page fault error reporting

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Skip attach device domain is same as new domain

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix error handling for pdev_pri_ats_enable()

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: asus: use spinlock to safely schedule workers

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: asus: use spinlock to protect concurrent accesses


-------------

Diffstat:

 Documentation/admin-guide/cgroup-v1/memory.rst     |   13 +-
 Documentation/admin-guide/hw-vuln/spectre.rst      |   21 +-
 Documentation/admin-guide/kdump/gdbmacros.txt      |    2 +-
 Documentation/bpf/instruction-set.rst              |   16 +-
 Documentation/dev-tools/gdb-kernel-debugging.rst   |    4 +
 .../bindings/display/mediatek/mediatek,ccorr.yaml  |    2 +-
 .../bindings/sound/amlogic,gx-sound-card.yaml      |    2 +-
 Documentation/hwmon/ftsteutates.rst                |    4 +
 Documentation/virt/kvm/api.rst                     |   18 +-
 Documentation/virt/kvm/devices/vm.rst              |    4 +
 Makefile                                           |    4 +-
 arch/alpha/boot/tools/objstrip.c                   |    2 +-
 arch/alpha/kernel/traps.c                          |   30 +-
 arch/arm/boot/dts/exynos3250-rinato.dts            |    2 +-
 arch/arm/boot/dts/exynos4-cpu-thermal.dtsi         |    2 +-
 arch/arm/boot/dts/exynos4.dtsi                     |    2 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |    1 -
 arch/arm/boot/dts/exynos5250.dtsi                  |    2 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts          |    1 -
 arch/arm/boot/dts/exynos5420.dtsi                  |    2 +-
 arch/arm/boot/dts/exynos5422-odroidhc1.dts         |   10 +-
 arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi |   10 +-
 arch/arm/boot/dts/imx7s.dtsi                       |    2 +-
 arch/arm/boot/dts/qcom-sdx55.dtsi                  |    2 +-
 arch/arm/boot/dts/qcom-sdx65.dtsi                  |    2 +-
 arch/arm/boot/dts/stm32mp131.dtsi                  |    1 +
 arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts         |    2 +-
 arch/arm/configs/bcm2835_defconfig                 |    1 +
 arch/arm/mach-imx/mmdc.c                           |   24 +-
 arch/arm/mach-omap1/timer.c                        |    2 +-
 arch/arm/mach-omap2/omap4-common.c                 |    1 +
 arch/arm/mach-omap2/timer.c                        |    1 +
 arch/arm/mach-s3c/s3c64xx.c                        |    3 +-
 arch/arm/mach-zynq/slcr.c                          |    1 +
 arch/arm64/Kconfig                                 |    1 -
 .../dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi |   10 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |    4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |    2 +-
 .../boot/dts/amlogic/meson-g12a-radxa-zero.dts     |    1 -
 arch/arm64/boot/dts/amlogic/meson-g12a.dtsi        |   20 -
 .../dts/amlogic/meson-g12b-odroid-go-ultra.dts     |    2 +-
 .../boot/dts/amlogic/meson-gx-libretech-pc.dtsi    |    2 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |    6 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts |    2 +-
 .../dts/amlogic/meson-gxl-s905d-phicomm-n1.dts     |    2 +-
 .../boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts |    1 -
 .../amlogic/meson-gxl-s905w-jethome-jethub-j80.dts |    6 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |    2 +-
 .../boot/dts/amlogic/meson-sm1-bananapi-m5.dts     |    6 +-
 .../boot/dts/amlogic/meson-sm1-odroid-hc4.dts      |   10 +-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |    2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |    2 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |    2 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |    2 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |    1 +
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |    3 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   12 +-
 arch/arm64/boot/dts/mediatek/mt8186.dtsi           |   17 +-
 arch/arm64/boot/dts/mediatek/mt8192.dtsi           |   25 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   25 +-
 arch/arm64/boot/dts/nvidia/tegra132-norrin.dts     |   16 +-
 arch/arm64/boot/dts/nvidia/tegra132.dtsi           |  232 +-
 arch/arm64/boot/dts/nvidia/tegra186-p2771-0000.dts | 2564 +++++++++----------
 arch/arm64/boot/dts/nvidia/tegra186-p3310.dtsi     |   86 +-
 .../dts/nvidia/tegra186-p3509-0000+p3636-0001.dts  | 1730 ++++++-------
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           |  470 ++--
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi     |   36 +-
 arch/arm64/boot/dts/nvidia/tegra194-p2972-0000.dts | 2418 +++++++++---------
 .../arm64/boot/dts/nvidia/tegra194-p3509-0000.dtsi | 2495 +++++++++----------
 arch/arm64/boot/dts/nvidia/tegra194-p3668.dtsi     |   36 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           | 1604 ++++++------
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   66 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2371-2180.dts |  278 +--
 arch/arm64/boot/dts/nvidia/tegra210-p2595.dtsi     |    3 +
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |    5 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2894.dtsi     |   86 +-
 arch/arm64/boot/dts/nvidia/tegra210-p3450-0000.dts |  384 +--
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts      |   66 +-
 arch/arm64/boot/dts/nvidia/tegra210.dtsi           |  310 +--
 .../arm64/boot/dts/nvidia/tegra234-p3701-0000.dtsi |   70 +-
 .../dts/nvidia/tegra234-p3737-0000+p3701-0000.dts  | 2588 ++++++++++----------
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           | 1895 +++++++-------
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   63 +-
 arch/arm64/boot/dts/qcom/msm8953.dtsi              |    2 +-
 arch/arm64/boot/dts/qcom/msm8956.dtsi              |    4 +
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi  |   48 +-
 .../boot/dts/qcom/msm8996-oneplus-common.dtsi      |    1 -
 .../boot/dts/qcom/msm8996-sony-xperia-tone.dtsi    |    5 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   22 +-
 arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts    |   11 +-
 .../boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi |   11 +-
 arch/arm64/boot/dts/qcom/pmi8950.dtsi              |    2 +-
 arch/arm64/boot/dts/qcom/pmk8350.dtsi              |    2 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |   12 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |    6 +-
 arch/arm64/boot/dts/qcom/sdm670-google-sargo.dts   |    1 +
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   13 +-
 arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi     |   11 +-
 arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts  |   11 +-
 .../dts/qcom/sdm845-xiaomi-beryllium-common.dtsi   |   13 +-
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts |   11 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |    1 -
 arch/arm64/boot/dts/qcom/sm6115.dtsi               |    9 +-
 .../dts/qcom/sm6125-sony-xperia-seine-pdx201.dts   |   19 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |    6 +-
 .../dts/qcom/sm6350-sony-xperia-lena-pdx213.dts    |   18 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |    7 +-
 .../boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi   |    7 +-
 .../dts/qcom/sm8350-sony-xperia-sagami-pdx214.dts  |   23 +
 .../dts/qcom/sm8350-sony-xperia-sagami-pdx215.dts  |   87 +
 .../boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi   |   88 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |    2 -
 .../boot/dts/qcom/sm8450-sony-xperia-nagara.dtsi   |    6 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |    6 +-
 .../boot/dts/renesas/beacon-renesom-baseboard.dtsi |   24 +-
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi           |    6 +-
 .../boot/dts/ti/k3-j7200-common-proc-board.dts     |    2 +-
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi    |   29 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |    2 +
 arch/arm64/kernel/acpi.c                           |    8 +-
 arch/arm64/kernel/cpufeature.c                     |    2 +-
 arch/arm64/mm/copypage.c                           |    3 +-
 arch/arm64/tools/sysreg                            |    8 +-
 arch/loongarch/net/bpf_jit.c                       |    2 +-
 arch/loongarch/net/bpf_jit.h                       |   21 +
 arch/m68k/68000/entry.S                            |    2 +
 arch/m68k/Kconfig.devices                          |    1 +
 arch/m68k/coldfire/entry.S                         |    2 +
 arch/m68k/kernel/entry.S                           |    3 +
 arch/mips/boot/dts/ingenic/ci20.dts                |    2 +-
 arch/mips/include/asm/syscall.h                    |    2 +-
 arch/powerpc/Makefile                              |    2 +-
 arch/powerpc/mm/book3s64/radix_tlb.c               |   11 +-
 arch/riscv/Kconfig                                 |    2 +-
 arch/riscv/Makefile                                |    6 +-
 arch/riscv/include/asm/ftrace.h                    |   50 +-
 arch/riscv/include/asm/jump_label.h                |    2 +
 arch/riscv/include/asm/pgtable.h                   |    2 +-
 arch/riscv/include/asm/thread_info.h               |    1 +
 arch/riscv/kernel/ftrace.c                         |   65 +-
 arch/riscv/kernel/mcount-dyn.S                     |   42 +-
 arch/riscv/kernel/time.c                           |    3 +
 arch/riscv/kernel/traps.c                          |    5 +-
 arch/riscv/mm/fault.c                              |   10 +-
 arch/s390/boot/boot.h                              |   26 +-
 arch/s390/boot/decompressor.c                      |    1 +
 arch/s390/boot/decompressor.h                      |   26 -
 arch/s390/boot/kaslr.c                             |    6 -
 arch/s390/boot/mem_detect.c                        |   54 +-
 arch/s390/boot/startup.c                           |   21 +-
 arch/s390/include/asm/ap.h                         |   12 +-
 arch/s390/kernel/early.c                           |    1 -
 arch/s390/kernel/head64.S                          |    1 +
 arch/s390/kernel/idle.c                            |    2 +-
 arch/s390/kernel/ipl.c                             |   94 +-
 arch/s390/kernel/kprobes.c                         |    4 +-
 arch/s390/kernel/vdso64/Makefile                   |    2 +-
 arch/s390/kernel/vmlinux.lds.S                     |    1 +
 arch/s390/kvm/kvm-s390.c                           |   43 +-
 arch/s390/mm/dump_pagetables.c                     |   16 +-
 arch/s390/mm/extmem.c                              |   12 +-
 arch/s390/mm/fault.c                               |   49 +-
 arch/s390/mm/vmem.c                                |    6 +-
 arch/s390/net/bpf_jit_comp.c                       |   12 +-
 arch/sparc/Kconfig                                 |    2 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |    6 +-
 arch/x86/events/intel/ds.c                         |   35 +-
 arch/x86/events/intel/uncore.c                     |    7 +
 arch/x86/events/intel/uncore.h                     |    1 +
 arch/x86/events/intel/uncore_snb.c                 |  161 ++
 arch/x86/events/zhaoxin/core.c                     |    8 +-
 arch/x86/include/asm/fpu/sched.h                   |    2 +-
 arch/x86/include/asm/fpu/xcr.h                     |    4 +-
 arch/x86/include/asm/microcode.h                   |    4 +-
 arch/x86/include/asm/microcode_amd.h               |    4 +-
 arch/x86/include/asm/msr-index.h                   |    4 +
 arch/x86/include/asm/processor.h                   |    3 +-
 arch/x86/include/asm/reboot.h                      |    2 +
 arch/x86/include/asm/special_insns.h               |    2 +-
 arch/x86/include/asm/virtext.h                     |   16 +-
 arch/x86/kernel/acpi/boot.c                        |   19 +-
 arch/x86/kernel/cpu/bugs.c                         |   35 +-
 arch/x86/kernel/cpu/common.c                       |   45 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   55 +-
 arch/x86/kernel/cpu/microcode/core.c               |   26 +-
 arch/x86/kernel/crash.c                            |   17 +-
 arch/x86/kernel/fpu/context.h                      |    2 +-
 arch/x86/kernel/fpu/core.c                         |    6 +-
 arch/x86/kernel/kprobes/opt.c                      |    6 +-
 arch/x86/kernel/reboot.c                           |   88 +-
 arch/x86/kernel/signal.c                           |    2 +-
 arch/x86/kernel/smp.c                              |    6 +-
 arch/x86/kvm/lapic.c                               |   38 +-
 arch/x86/kvm/svm/avic.c                            |   53 +-
 arch/x86/kvm/svm/sev.c                             |    4 +-
 arch/x86/kvm/svm/svm.c                             |    2 +-
 arch/x86/kvm/svm/svm.h                             |    2 +-
 arch/x86/kvm/svm/svm_onhyperv.h                    |    4 +-
 arch/x86/kvm/vmx/hyperv.h                          |   11 -
 arch/x86/kvm/vmx/vmx.c                             |    9 +-
 block/bio-integrity.c                              |    1 +
 block/bio.c                                        |    1 +
 block/blk-cgroup.c                                 |   39 +-
 block/blk-core.c                                   |   33 +-
 block/blk-iocost.c                                 |   11 +-
 block/blk-merge.c                                  |   35 +-
 block/blk-mq-sched.c                               |    7 +-
 block/blk-mq.c                                     |   15 +-
 block/fops.c                                       |   21 +-
 crypto/asymmetric_keys/public_key.c                |   24 +-
 crypto/essiv.c                                     |    7 +-
 crypto/rsa-pkcs1pad.c                              |   34 +-
 crypto/seqiv.c                                     |    2 +-
 crypto/xts.c                                       |    8 +-
 drivers/accel/Kconfig                              |    5 +-
 drivers/acpi/acpica/Makefile                       |    2 +-
 drivers/acpi/acpica/hwvalid.c                      |    7 +-
 drivers/acpi/acpica/nsrepair.c                     |   12 +-
 drivers/acpi/battery.c                             |    2 +-
 drivers/acpi/resource.c                            |   26 +-
 drivers/acpi/video_detect.c                        |    2 +-
 drivers/ata/ahci.c                                 |    1 -
 drivers/base/core.c                                |  452 ++--
 drivers/base/physical_location.c                   |    5 +-
 drivers/base/platform-msi.c                        |    1 +
 drivers/base/power/domain.c                        |    5 +-
 drivers/base/regmap/regmap.c                       |    6 +
 drivers/base/transport_class.c                     |   17 +-
 drivers/block/brd.c                                |   67 +-
 drivers/block/rbd.c                                |   20 +-
 drivers/block/ublk_drv.c                           |   23 +-
 drivers/bluetooth/btusb.c                          |   16 +
 drivers/bluetooth/hci_qca.c                        |    7 +-
 drivers/bus/mhi/ep/main.c                          |   35 +-
 drivers/char/applicom.c                            |    5 +-
 drivers/char/ipmi/ipmi_ipmb.c                      |    2 +-
 drivers/char/ipmi/ipmi_ssif.c                      |  104 +-
 drivers/char/pcmcia/cm4000_cs.c                    |    6 +-
 drivers/clocksource/timer-riscv.c                  |   10 +-
 drivers/cpufreq/davinci-cpufreq.c                  |    4 +-
 drivers/cpuidle/Kconfig.arm                        |    2 +
 drivers/crypto/amcc/crypto4xx_core.c               |   10 +-
 drivers/crypto/ccp/ccp-dmaengine.c                 |   21 +-
 drivers/crypto/ccp/sev-dev.c                       |   15 +-
 drivers/crypto/hisilicon/sgl.c                     |    3 +-
 drivers/crypto/marvell/octeontx2/Makefile          |   11 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c       |    9 +-
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h       |    2 -
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |    2 -
 .../marvell/octeontx2/otx2_cpt_mbox_common.c       |   14 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c      |   11 +
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |    2 +
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |    2 +
 drivers/crypto/qat/qat_common/qat_algs.c           |    2 +-
 drivers/crypto/ux500/Kconfig                       |    7 +-
 drivers/cxl/pmem.c                                 |    1 +
 drivers/dax/bus.c                                  |    2 +-
 drivers/dax/kmem.c                                 |    4 +-
 drivers/dma/Kconfig                                |    2 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |    2 -
 drivers/dma/dw-edma/dw-edma-core.c                 |    4 +
 drivers/dma/dw-edma/dw-edma-v0-core.c              |    2 +-
 drivers/dma/idxd/device.c                          |    2 +-
 drivers/dma/idxd/init.c                            |    2 +-
 drivers/dma/idxd/sysfs.c                           |    4 +-
 drivers/dma/ptdma/ptdma-dmaengine.c                |    2 +-
 drivers/dma/sf-pdma/sf-pdma.c                      |    3 +-
 drivers/dma/sf-pdma/sf-pdma.h                      |    1 -
 drivers/firmware/dmi-sysfs.c                       |   10 +-
 drivers/firmware/google/framebuffer-coreboot.c     |    4 +-
 drivers/firmware/psci/psci.c                       |   31 +-
 drivers/firmware/stratix10-svc.c                   |   25 +-
 drivers/fpga/microchip-spi.c                       |  123 +-
 drivers/gpio/gpio-pca9570.c                        |   24 +-
 drivers/gpio/gpio-vf610.c                          |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |    3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h          |    4 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c             |    5 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |    9 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   13 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    7 +
 .../drm/amd/display/dc/clk_mgr/dcn314/dcn314_smu.c |    3 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   16 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |    6 -
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   14 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |    2 +-
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h       |    1 -
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.h  |    3 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c  |    9 +
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.h  |    2 +
 .../display/dc/dcn314/dcn314_dio_stream_encoder.c  |    6 +-
 .../drm/amd/display/dc/dcn314/dcn314_resource.c    |    4 +-
 .../amd/display/dc/dml/dcn20/display_mode_vba_20.c |    8 +-
 .../display/dc/dml/dcn20/display_mode_vba_20v2.c   |   10 +-
 .../amd/display/dc/dml/dcn21/display_mode_vba_21.c |   12 +-
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |    8 +
 .../gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c |    2 +-
 .../amd/display/dc/gpio/dcn20/hw_factory_dcn20.c   |    6 +-
 .../amd/display/dc/gpio/dcn30/hw_factory_dcn30.c   |    6 +-
 .../amd/display/dc/gpio/dcn32/hw_factory_dcn32.c   |    6 +-
 drivers/gpu/drm/amd/display/dc/gpio/ddc_regs.h     |    7 +
 .../drm/amd/display/dc/inc/hw/timing_generator.h   |    1 +
 drivers/gpu/drm/amd/include/amd_shared.h           |    1 +
 drivers/gpu/drm/ast/ast_mode.c                     |    2 +-
 drivers/gpu/drm/bridge/ite-it6505.c                |   22 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   65 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |    6 +-
 drivers/gpu/drm/bridge/tc358767.c                  |    8 +-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |    2 +-
 drivers/gpu/drm/drm_client.c                       |    5 +
 drivers/gpu/drm/drm_edid.c                         |   43 +-
 drivers/gpu/drm/drm_fbdev_generic.c                |    5 -
 drivers/gpu/drm/drm_fourcc.c                       |    4 +
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   52 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   52 +
 drivers/gpu/drm/drm_mode_config.c                  |    8 +-
 drivers/gpu/drm/drm_modes.c                        |    2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   39 +-
 drivers/gpu/drm/exynos/exynos_drm_dsi.c            |    8 +-
 drivers/gpu/drm/gud/gud_pipe.c                     |    4 +-
 drivers/gpu/drm/i915/display/intel_quirks.c        |    2 +
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |    6 +-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |    6 +-
 drivers/gpu/drm/i915/gt/intel_gt_mcr.c             |   11 +-
 drivers/gpu/drm/i915/gt/intel_gt_regs.h            |   25 +-
 drivers/gpu/drm/i915/gt/intel_ring.c               |    6 +-
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |  199 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc.c             |    9 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c          |    5 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |    8 +-
 drivers/gpu/drm/i915/i915_drv.h                    |    4 +
 drivers/gpu/drm/i915/intel_device_info.c           |    6 +
 drivers/gpu/drm/i915/intel_pm.c                    |   10 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |    2 +
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |    1 +
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |    4 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |    2 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |    4 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |    7 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |    2 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |    5 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |   15 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c             |    5 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c      |    2 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |    5 +-
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                  |    4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |    3 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |    4 +
 drivers/gpu/drm/msm/msm_drv.c                      |    2 +-
 drivers/gpu/drm/msm/msm_fence.c                    |    2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |    4 +
 drivers/gpu/drm/mxsfb/Kconfig                      |    2 +
 drivers/gpu/drm/nouveau/include/nvif/outp.h        |    3 +-
 drivers/gpu/drm/nouveau/nvif/outp.c                |    2 +-
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |   26 +-
 drivers/gpu/drm/panel/panel-edp.c                  |    2 +-
 drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c      |    4 +-
 drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c   |    3 +-
 drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c      |    2 -
 drivers/gpu/drm/radeon/atombios_encoders.c         |    5 +-
 drivers/gpu/drm/radeon/radeon_device.c             |    1 +
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |   31 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c              |   49 +
 drivers/gpu/drm/rcar-du/rcar_du_drv.h              |    2 +
 drivers/gpu/drm/rcar-du/rcar_du_regs.h             |    8 +-
 drivers/gpu/drm/tegra/firewall.c                   |    3 +
 drivers/gpu/drm/tidss/tidss_dispc.c                |    4 +-
 drivers/gpu/drm/tiny/ili9486.c                     |   13 +-
 drivers/gpu/drm/vc4/vc4_dpi.c                      |    2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   16 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |  129 +-
 drivers/gpu/drm/vc4/vc4_plane.c                    |    2 +
 drivers/gpu/drm/vc4/vc4_regs.h                     |   17 +-
 drivers/gpu/drm/vkms/vkms_drv.c                    |   10 +-
 drivers/gpu/host1x/hw/hw_host1x06_uclass.h         |    2 +-
 drivers/gpu/host1x/hw/hw_host1x07_uclass.h         |    2 +-
 drivers/gpu/host1x/hw/hw_host1x08_uclass.h         |    2 +-
 drivers/gpu/host1x/hw/syncpt_hw.c                  |    3 -
 drivers/gpu/ipu-v3/ipu-common.c                    |    1 +
 drivers/hid/hid-asus.c                             |   37 +-
 drivers/hid/hid-bigbenff.c                         |   75 +-
 drivers/hid/hid-debug.c                            |    1 +
 drivers/hid/hid-ids.h                              |    2 +
 drivers/hid/hid-input.c                            |   12 +
 drivers/hid/hid-logitech-hidpp.c                   |   49 +-
 drivers/hid/hid-multitouch.c                       |   39 +-
 drivers/hid/hid-quirks.c                           |    2 +-
 drivers/hid/hid-uclogic-core.c                     |   26 +-
 drivers/hid/hid-uclogic-params.c                   |   14 +
 drivers/hid/hid-uclogic-params.h                   |   24 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |    6 +-
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |   42 +
 drivers/hid/i2c-hid/i2c-hid.h                      |    3 +
 drivers/hwmon/Kconfig                              |    2 +-
 drivers/hwmon/asus-ec-sensors.c                    |    1 +
 drivers/hwmon/coretemp.c                           |  128 +-
 drivers/hwmon/ftsteutates.c                        |   19 +-
 drivers/hwmon/ltc2945.c                            |    2 +
 drivers/hwmon/mlxreg-fan.c                         |    6 +
 drivers/hwmon/nct6775-core.c                       |    2 +-
 drivers/hwmon/nct6775-platform.c                   |  150 +-
 drivers/hwmon/peci/cputemp.c                       |    2 +-
 drivers/hwtracing/coresight/coresight-cti-core.c   |   11 +-
 drivers/hwtracing/coresight/coresight-cti-sysfs.c  |   13 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   18 +-
 drivers/hwtracing/ptt/hisi_ptt.c                   |   10 +
 drivers/i2c/busses/i2c-designware-common.c         |    2 +-
 drivers/i2c/busses/i2c-designware-core.h           |    2 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |    2 +-
 drivers/idle/intel_idle.c                          |    8 +-
 drivers/iio/light/tsl2563.c                        |    8 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |    7 +
 drivers/infiniband/hw/cxgb4/restrack.c             |    2 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |    4 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |    4 +-
 drivers/infiniband/hw/hfi1/sdma.h                  |   15 +-
 drivers/infiniband/hw/hfi1/user_pages.c            |   61 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |    5 +-
 drivers/infiniband/hw/irdma/hw.c                   |    2 +
 drivers/infiniband/hw/mana/main.c                  |   22 +-
 drivers/infiniband/sw/rxe/rxe.h                    |   38 +
 drivers/infiniband/sw/rxe/rxe_loc.h                |   12 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  604 +++--
 drivers/infiniband/sw/rxe/rxe_queue.h              |  108 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  202 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   56 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   32 +-
 drivers/infiniband/sw/siw/siw_mem.c                |   23 +-
 drivers/input/touchscreen/exc3000.c                |   10 +
 drivers/iommu/amd/init.c                           |   16 +-
 drivers/iommu/amd/iommu.c                          |   41 +-
 drivers/iommu/exynos-iommu.c                       |    2 +-
 drivers/iommu/intel/iommu.c                        |   26 +-
 drivers/iommu/intel/pasid.c                        |   18 +
 drivers/iommu/iommu.c                              |   24 +-
 drivers/iommu/iommufd/device.c                     |    4 -
 drivers/iommu/iommufd/main.c                       |    3 +
 drivers/iommu/iommufd/vfio_compat.c                |    2 +-
 drivers/irqchip/irq-alpine-msi.c                   |    1 +
 drivers/irqchip/irq-bcm7120-l2.c                   |    3 +-
 drivers/irqchip/irq-brcmstb-l2.c                   |    6 +-
 drivers/irqchip/irq-mvebu-gicp.c                   |    1 +
 drivers/irqchip/irq-ti-sci-intr.c                  |    1 +
 drivers/irqchip/irqchip.c                          |    8 +-
 drivers/leds/led-class.c                           |    6 +-
 drivers/leds/leds-is31fl319x.c                     |    7 +-
 drivers/leds/simple/simatic-ipc-leds-gpio.c        |    2 +
 drivers/md/dm-bufio.c                              |    2 +-
 drivers/md/dm-cache-background-tracker.c           |    8 +
 drivers/md/dm-cache-target.c                       |    4 +
 drivers/md/dm-flakey.c                             |   31 +-
 drivers/md/dm-ioctl.c                              |   13 +-
 drivers/md/dm-thin.c                               |    2 +
 drivers/md/dm-zoned-metadata.c                     |    2 +-
 drivers/md/dm.c                                    |   30 +-
 drivers/md/dm.h                                    |    2 +-
 drivers/md/md.c                                    |    2 +-
 drivers/media/i2c/imx219.c                         |  255 +-
 drivers/media/i2c/max9286.c                        |    1 +
 drivers/media/i2c/ov2740.c                         |    4 +-
 drivers/media/i2c/ov5640.c                         |   56 +-
 drivers/media/i2c/ov5675.c                         |    4 +-
 drivers/media/i2c/ov7670.c                         |    2 +-
 drivers/media/i2c/ov772x.c                         |    3 +-
 drivers/media/i2c/tc358746.c                       |    9 +-
 drivers/media/mc/mc-entity.c                       |    8 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c      |    3 +
 drivers/media/pci/saa7134/saa7134-core.c           |    2 +-
 drivers/media/platform/amphion/vpu_color.c         |    6 +-
 drivers/media/platform/mediatek/mdp3/Kconfig       |    7 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-core.c   |    7 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |   35 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h     |    4 +-
 drivers/media/platform/nxp/imx7-media-csi.c        |    4 +-
 .../platform/qcom/camss/camss-csiphy-3ph-1-0.c     |    3 +-
 drivers/media/platform/ti/cal/cal.c                |    4 +-
 drivers/media/platform/ti/omap3isp/isp.c           |    9 +
 drivers/media/platform/verisilicon/hantro_v4l2.c   |    7 +-
 drivers/media/rc/ene_ir.c                          |    3 +-
 drivers/media/usb/siano/smsusb.c                   |    1 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |  154 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   18 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |    6 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    6 +-
 drivers/media/v4l2-core/v4l2-h264.c                |    4 +
 drivers/media/v4l2-core/v4l2-jpeg.c                |    4 +-
 drivers/mfd/Kconfig                                |    1 +
 drivers/mfd/pcf50633-adc.c                         |    7 +-
 drivers/mfd/rk808.c                                |    1 +
 drivers/misc/eeprom/idt_89hpesx.c                  |   10 +-
 drivers/misc/fastrpc.c                             |   13 +-
 .../misc/habanalabs/common/command_submission.c    |   33 +-
 drivers/misc/habanalabs/common/device.c            |   38 +-
 drivers/misc/habanalabs/common/memory.c            |    5 +-
 drivers/misc/mei/hdcp/mei_hdcp.c                   |    4 +-
 drivers/misc/mei/pxp/mei_pxp.c                     |    4 +-
 drivers/misc/vmw_vmci/vmci_host.c                  |    2 +
 drivers/mtd/mtdpart.c                              |   10 +
 drivers/mtd/spi-nor/core.c                         |    9 +
 drivers/mtd/spi-nor/core.h                         |    1 +
 drivers/mtd/spi-nor/sfdp.c                         |    6 +-
 drivers/mtd/spi-nor/spansion.c                     |    9 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   23 +-
 drivers/net/can/usb/esd_usb.c                      |   52 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |    8 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   11 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   17 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   22 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |    2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |    2 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |    3 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |    4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   16 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |    2 +
 drivers/net/ethernet/ti/am65-cpts.c                |   15 +-
 drivers/net/ethernet/ti/am65-cpts.h                |    5 +
 drivers/net/hyperv/netvsc.c                        |   18 +
 drivers/net/ipa/gsi.c                              |    3 +-
 drivers/net/ipa/gsi_reg.h                          |    1 -
 drivers/net/tap.c                                  |    2 +-
 drivers/net/tun.c                                  |    2 +-
 drivers/net/wireless/ath/ath11k/core.h             |    1 -
 drivers/net/wireless/ath/ath11k/debugfs.c          |   48 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    2 +
 drivers/net/wireless/ath/ath11k/pci.c              |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   33 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    4 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   33 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    8 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   11 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   16 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   12 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |    6 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |    2 +
 drivers/net/wireless/marvell/libertas/cmdresp.c    |    2 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |    2 +-
 drivers/net/wireless/marvell/libertas/main.c       |    3 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |    2 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |    6 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   16 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    3 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    9 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |    7 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   24 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |    3 -
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   11 +
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   67 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    4 +
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |    1 -
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |    1 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   27 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   70 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    2 +
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |   18 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   52 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   20 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |   16 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |    4 +
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |    4 +
 drivers/net/wireless/mediatek/mt7601u/dma.c        |    3 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |    8 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |    2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |    5 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   25 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   52 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |    2 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |   10 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    4 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    6 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    2 +-
 drivers/net/wireless/realtek/rtw88/ps.c            |    4 +-
 drivers/net/wireless/realtek/rtw88/wow.c           |    2 +-
 drivers/net/wireless/realtek/rtw89/core.c          |    3 +
 drivers/net/wireless/realtek/rtw89/debug.c         |    7 +
 drivers/net/wireless/realtek/rtw89/fw.c            |    4 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   34 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   15 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   15 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |   11 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    1 +
 drivers/net/wireless/rsi/rsi_91x_coex.c            |    1 +
 drivers/net/wireless/wl3501_cs.c                   |    2 +-
 drivers/nvdimm/bus.c                               |   19 +-
 drivers/nvdimm/dimm_devs.c                         |    5 +-
 drivers/nvdimm/nd-core.h                           |    1 +
 drivers/opp/debugfs.c                              |    2 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   13 +-
 drivers/pci/controller/pcie-mt7621.c               |    2 +
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |    1 +
 drivers/pci/iov.c                                  |    2 +-
 drivers/pci/pci-driver.c                           |    2 +-
 drivers/pci/pci.c                                  |   59 +-
 drivers/pci/pci.h                                  |   59 +-
 drivers/pci/pcie/dpc.c                             |    4 +-
 drivers/pci/probe.c                                |    2 +-
 drivers/pci/quirks.c                               |    1 +
 drivers/pci/switch/switchtec.c                     |    9 +-
 drivers/phy/mediatek/phy-mtk-io.h                  |    4 +-
 drivers/phy/rockchip/phy-rockchip-typec.c          |    4 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |    2 -
 drivers/pinctrl/mediatek/pinctrl-paris.c           |    4 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                |    4 +-
 drivers/pinctrl/pinctrl-at91.c                     |    2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |    1 +
 drivers/pinctrl/qcom/pinctrl-msm8976.c             |    8 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   17 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |    1 +
 drivers/platform/chrome/cros_ec_typec.c            |    2 +-
 drivers/platform/x86/dell/dell-wmi-ddv.c           |    6 +-
 drivers/power/supply/power_supply_core.c           |   93 -
 drivers/powercap/powercap_sys.c                    |   14 +-
 drivers/regulator/core.c                           |    6 +-
 drivers/regulator/max77802-regulator.c             |   34 +-
 drivers/regulator/s5m8767.c                        |    6 +-
 drivers/regulator/tps65219-regulator.c             |   22 +-
 drivers/remoteproc/mtk_scp_ipi.c                   |   11 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |   87 +-
 drivers/rpmsg/qcom_glink_native.c                  |    3 +
 drivers/rtc/rtc-pm8xxx.c                           |   24 +-
 drivers/s390/block/dasd_eckd.c                     |    4 +-
 drivers/s390/char/sclp_early.c                     |    2 +-
 drivers/s390/cio/vfio_ccw_drv.c                    |    2 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |   12 +-
 drivers/scsi/aacraid/aachba.c                      |    5 +-
 drivers/scsi/aic94xx/aic94xx_task.c                |    3 +
 drivers/scsi/hosts.c                               |    2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   19 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |   28 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |    4 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |    3 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |    9 +-
 drivers/scsi/qla2xxx/qla_def.h                     |    6 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   10 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |   11 +-
 drivers/scsi/qla2xxx/qla_edif_bsg.h                |   15 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   14 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |   55 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |   95 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |    6 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   34 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    9 +-
 drivers/scsi/ses.c                                 |   64 +-
 drivers/scsi/snic/snic_debugfs.c                   |    4 +-
 drivers/soundwire/cadence_master.c                 |    3 +-
 drivers/spi/Kconfig                                |    1 -
 drivers/spi/spi-bcm63xx-hsspi.c                    |   12 +-
 drivers/spi/spi-intel.c                            |    8 +-
 drivers/spi/spi-sn-f-ospi.c                        |    2 +-
 drivers/spi/spi-synquacer.c                        |    7 +-
 drivers/staging/media/atomisp/Kconfig              |    2 +-
 drivers/staging/media/atomisp/pci/atomisp_fops.c   |    4 +-
 drivers/thermal/hisi_thermal.c                     |    4 -
 drivers/thermal/imx_sc_thermal.c                   |    4 +-
 drivers/thermal/intel/intel_pch_thermal.c          |    8 +
 drivers/thermal/intel/intel_powerclamp.c           |   20 +-
 drivers/thermal/intel/intel_soc_dts_iosf.c         |    2 +-
 drivers/thermal/qcom/tsens-v0_1.c                  |   28 +-
 drivers/thermal/qcom/tsens-v1.c                    |   61 +-
 drivers/thermal/qcom/tsens.c                       |    3 +
 drivers/thermal/qcom/tsens.h                       |    2 +-
 drivers/tty/serial/fsl_lpuart.c                    |   19 +-
 drivers/tty/serial/imx.c                           |    5 +
 drivers/tty/serial/qcom_geni_serial.c              |    2 +
 drivers/tty/serial/serial-tegra.c                  |    7 +-
 drivers/ufs/core/ufshcd.c                          |   20 +-
 drivers/ufs/host/ufs-exynos.c                      |    2 +-
 drivers/usb/early/xhci-dbc.c                       |    3 +-
 drivers/usb/fotg210/fotg210-udc.c                  |   16 +
 drivers/usb/gadget/configfs.c                      |    6 +
 drivers/usb/gadget/udc/fusb300_udc.c               |   10 +-
 drivers/usb/host/fsl-mph-dr-of.c                   |    3 +-
 drivers/usb/host/max3421-hcd.c                     |    2 +-
 drivers/usb/musb/mediatek.c                        |    3 +-
 drivers/usb/typec/mux/intel_pmc_mux.c              |    4 +-
 drivers/vfio/group.c                               |    2 +-
 drivers/vfio/vfio_iommu_type1.c                    |  143 +-
 drivers/video/fbdev/core/fbcon.c                   |   17 +-
 drivers/virt/coco/sev-guest/sev-guest.c            |   20 +-
 drivers/xen/grant-dma-iommu.c                      |   11 +-
 fs/btrfs/discard.c                                 |   41 +-
 fs/btrfs/disk-io.c                                 |    3 +
 fs/btrfs/fs.c                                      |    4 +
 fs/btrfs/fs.h                                      |    6 +
 fs/btrfs/scrub.c                                   |   49 +-
 fs/btrfs/sysfs.c                                   |   29 +-
 fs/btrfs/sysfs.h                                   |    3 +-
 fs/btrfs/transaction.c                             |    5 +
 fs/ceph/file.c                                     |    8 +
 fs/cifs/cached_dir.c                               |   43 +-
 fs/cifs/cifsacl.c                                  |   34 +-
 fs/cifs/cifsproto.h                                |   20 +-
 fs/cifs/cifssmb.c                                  |   17 +-
 fs/cifs/connect.c                                  |   94 +-
 fs/cifs/dir.c                                      |   19 +-
 fs/cifs/file.c                                     |   35 +-
 fs/cifs/inode.c                                    |   53 +-
 fs/cifs/link.c                                     |   66 +-
 fs/cifs/misc.c                                     |   67 +
 fs/cifs/smb1ops.c                                  |   72 +-
 fs/cifs/smb2inode.c                                |   38 +-
 fs/cifs/smb2ops.c                                  |  227 +-
 fs/cifs/smb2pdu.c                                  |  212 +-
 fs/cifs/smbdirect.c                                |    4 +-
 fs/coda/upcall.c                                   |    2 +-
 fs/cramfs/inode.c                                  |    2 +-
 fs/dlm/lockspace.c                                 |   16 +-
 fs/dlm/memory.c                                    |    2 +-
 fs/dlm/midcomms.c                                  |   55 +-
 fs/erofs/fscache.c                                 |    2 +-
 fs/exfat/dir.c                                     |    7 +-
 fs/exfat/exfat_fs.h                                |    2 +-
 fs/exfat/file.c                                    |    3 +-
 fs/exfat/inode.c                                   |    6 +-
 fs/exfat/namei.c                                   |    2 +-
 fs/exfat/super.c                                   |    3 +-
 fs/ext4/xattr.c                                    |   35 +-
 fs/f2fs/data.c                                     |   10 +-
 fs/f2fs/inline.c                                   |   13 +-
 fs/f2fs/inode.c                                    |   13 +-
 fs/f2fs/segment.c                                  |    9 +-
 fs/fuse/ioctl.c                                    |    6 +
 fs/gfs2/aops.c                                     |    3 +-
 fs/gfs2/super.c                                    |    8 +-
 fs/hfs/bnode.c                                     |    1 +
 fs/hfsplus/super.c                                 |    4 +-
 fs/jbd2/transaction.c                              |   50 +-
 fs/ksmbd/smb2misc.c                                |   31 +-
 fs/ksmbd/smb2pdu.c                                 |   28 +-
 fs/ksmbd/vfs_cache.c                               |    5 +-
 fs/lockd/svc.c                                     |    2 +-
 fs/nfs/nfs4proc.c                                  |    4 +-
 fs/nfs/nfs4trace.h                                 |   42 +-
 fs/nfsd/filecache.c                                |   44 +-
 fs/nfsd/nfs4layouts.c                              |    4 +-
 fs/nfsd/nfs4proc.c                                 |  160 +-
 fs/nfsd/nfs4state.c                                |   53 +-
 fs/nfsd/nfssvc.c                                   |    2 +-
 fs/nfsd/trace.h                                    |   31 -
 fs/nfsd/xdr4.h                                     |    2 +-
 fs/ocfs2/move_extents.c                            |   34 +-
 fs/open.c                                          |    5 +-
 fs/proc/proc_sysctl.c                              |    6 +
 fs/super.c                                         |   21 +-
 fs/udf/file.c                                      |   26 +-
 fs/udf/inode.c                                     |   74 +-
 fs/udf/super.c                                     |    1 +
 fs/udf/udf_i.h                                     |    3 +-
 fs/udf/udf_sb.h                                    |    2 +
 include/drm/drm_mipi_dsi.h                         |    4 +
 include/drm/drm_print.h                            |    2 +-
 include/linux/blkdev.h                             |    1 +
 include/linux/bpf.h                                |    7 +
 include/linux/compiler_attributes.h                |    6 -
 include/linux/compiler_types.h                     |   27 +
 include/linux/context_tracking.h                   |   27 +
 include/linux/device.h                             |    1 +
 include/linux/fwnode.h                             |   12 +-
 include/linux/hid.h                                |    1 +
 include/linux/ima.h                                |    6 +-
 include/linux/kernel_stat.h                        |    2 +-
 include/linux/kprobes.h                            |    2 +
 include/linux/libnvdimm.h                          |    3 +
 include/linux/mlx4/qp.h                            |    1 +
 include/linux/msi.h                                |    2 +
 include/linux/nfs_ssc.h                            |    2 +-
 include/linux/poison.h                             |    3 +
 include/linux/rcupdate.h                           |   11 +-
 include/linux/rmap.h                               |    2 +-
 include/linux/transport_class.h                    |    8 +-
 include/linux/uaccess.h                            |    4 +
 include/net/sock.h                                 |    7 +-
 include/sound/hda_codec.h                          |    1 +
 include/sound/soc-dapm.h                           |    1 +
 include/trace/events/devlink.h                     |    2 +-
 include/uapi/linux/io_uring.h                      |    2 +-
 include/uapi/linux/vfio.h                          |   15 +-
 include/ufs/ufshcd.h                               |    4 +-
 io_uring/io_uring.c                                |   13 +-
 io_uring/io_uring.h                                |   10 +
 io_uring/net.c                                     |    2 +-
 io_uring/opdef.c                                   |    1 +
 io_uring/poll.c                                    |   14 +-
 io_uring/poll.h                                    |    1 +
 io_uring/rsrc.c                                    |   13 +-
 kernel/bpf/btf.c                                   |   13 +-
 kernel/bpf/hashtab.c                               |    4 +-
 kernel/bpf/memalloc.c                              |    2 +-
 kernel/bpf/verifier.c                              |  258 +-
 kernel/context_tracking.c                          |   12 +-
 kernel/exit.c                                      |   16 +-
 kernel/irq/irqdomain.c                             |  283 ++-
 kernel/irq/msi.c                                   |   32 +-
 kernel/kprobes.c                                   |   27 +-
 kernel/locking/lockdep.c                           |    3 +
 kernel/locking/rwsem.c                             |   49 +-
 kernel/panic.c                                     |   49 +-
 kernel/pid_namespace.c                             |   17 +
 kernel/power/energy_model.c                        |    5 +-
 kernel/rcu/srcutree.c                              |    9 +-
 kernel/rcu/tasks.h                                 |   77 +-
 kernel/rcu/tree_exp.h                              |    2 +
 kernel/resource.c                                  |   14 -
 kernel/sched/rt.c                                  |    5 +-
 kernel/sysctl.c                                    |   43 +-
 kernel/time/clocksource.c                          |   45 +-
 kernel/time/hrtimer.c                              |    2 +
 kernel/time/posix-stubs.c                          |    2 +
 kernel/time/posix-timers.c                         |    2 +
 kernel/time/test_udelay.c                          |    2 +-
 kernel/torture.c                                   |    2 +-
 kernel/trace/blktrace.c                            |    4 +-
 kernel/trace/ring_buffer.c                         |   42 +-
 kernel/trace/trace.c                               |    2 +-
 kernel/workqueue.c                                 |   41 +-
 lib/bug.c                                          |   15 +-
 lib/errname.c                                      |   22 +-
 lib/kobject.c                                      |   12 +-
 lib/mpi/mpicoder.c                                 |    3 +-
 lib/sbitmap.c                                      |   13 +-
 mm/damon/paddr.c                                   |    7 +-
 mm/huge_memory.c                                   |    3 +
 mm/hugetlb_vmemmap.c                               |    2 +-
 mm/memcontrol.c                                    |    4 +
 mm/memory-failure.c                                |    8 +-
 mm/memory-tiers.c                                  |    4 +-
 mm/rmap.c                                          |    2 +-
 net/bluetooth/hci_conn.c                           |   12 +-
 net/bluetooth/l2cap_core.c                         |   24 -
 net/bluetooth/l2cap_sock.c                         |    8 +
 net/can/isotp.c                                    |    3 +
 net/core/scm.c                                     |    2 +
 net/core/sock.c                                    |   15 +-
 net/ipv4/inet_hashtables.c                         |   12 +-
 net/l2tp/l2tp_ppp.c                                |  125 +-
 net/mac80211/cfg.c                                 |   26 +-
 net/mac80211/ieee80211_i.h                         |    3 +
 net/mac80211/link.c                                |    3 +
 net/mac80211/rx.c                                  |   32 +-
 net/mac80211/sta_info.c                            |    2 +-
 net/mac80211/tx.c                                  |    2 +-
 net/netfilter/nf_tables_api.c                      |    3 +
 net/rds/message.c                                  |    2 +-
 net/rxrpc/call_object.c                            |    6 +-
 net/smc/af_smc.c                                   |    2 +
 net/smc/smc_core.c                                 |   17 +-
 net/sunrpc/clnt.c                                  |    2 +
 net/wireless/nl80211.c                             |    2 +-
 net/wireless/sme.c                                 |   48 +-
 net/xdp/xsk.c                                      |   59 +-
 scripts/bpf_doc.py                                 |    2 +-
 scripts/gcc-plugins/Makefile                       |    2 +-
 scripts/package/mkdebian                           |    2 +-
 security/integrity/ima/ima_api.c                   |    2 +-
 security/integrity/ima/ima_main.c                  |    9 +-
 security/security.c                                |    7 +-
 sound/pci/hda/Kconfig                              |   14 +
 sound/pci/hda/hda_codec.c                          |   13 +-
 sound/pci/hda/hda_controller.c                     |    1 +
 sound/pci/hda/hda_controller.h                     |    1 +
 sound/pci/hda/hda_intel.c                          |    8 +-
 sound/pci/hda/patch_ca0132.c                       |    2 +-
 sound/pci/hda/patch_realtek.c                      |    1 +
 sound/pci/ice1712/aureon.c                         |    2 +-
 sound/soc/atmel/mchp-spdifrx.c                     |  342 ++-
 sound/soc/codecs/lpass-rx-macro.c                  |   12 +-
 sound/soc/codecs/lpass-tx-macro.c                  |   12 +-
 sound/soc/codecs/lpass-va-macro.c                  |   20 +-
 sound/soc/codecs/lpass-wsa-macro.c                 |    9 +-
 sound/soc/codecs/tlv320adcx140.c                   |    2 +-
 sound/soc/fsl/fsl_sai.c                            |    1 +
 sound/soc/kirkwood/kirkwood-dma.c                  |    2 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   22 +-
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |    5 +
 sound/soc/sh/rcar/rsnd.h                           |    4 +-
 sound/soc/soc-compress.c                           |   11 +-
 sound/soc/soc-topology.c                           |    2 +-
 tools/bootconfig/scripts/ftrace2bconf.sh           |    2 +-
 tools/bpf/bpftool/Makefile                         |    3 +-
 tools/bpf/bpftool/prog.c                           |   38 +-
 tools/lib/bpf/bpf_tracing.h                        |    2 +-
 tools/lib/bpf/btf.c                                |   13 +
 tools/lib/bpf/btf_dump.c                           |    7 +-
 tools/lib/bpf/libbpf.c                             |    2 +-
 tools/lib/bpf/nlattr.c                             |    2 +-
 tools/lib/thermal/sampling.c                       |    2 +-
 tools/objtool/check.c                              |    2 +
 tools/perf/Documentation/perf-intel-pt.txt         |   30 +
 tools/perf/builtin-inject.c                        |    6 +-
 tools/perf/builtin-record.c                        |   16 +-
 tools/perf/perf-completion.sh                      |   11 +-
 tools/perf/pmu-events/metric_test.py               |    4 +-
 tools/perf/tests/bpf.c                             |    6 +-
 tools/perf/tests/shell/stat_all_metrics.sh         |    2 +-
 tools/perf/util/auxtrace.c                         |    3 +
 tools/perf/util/intel-pt.c                         |    6 +
 tools/perf/util/llvm-utils.c                       |   25 +-
 tools/perf/util/stat-display.c                     |   51 +-
 tools/perf/util/stat-shadow.c                      |    2 +-
 tools/power/x86/intel-speed-select/isst-config.c   |    2 +-
 tools/testing/ktest/ktest.pl                       |   26 +-
 tools/testing/ktest/sample.conf                    |    5 +
 tools/testing/selftests/Makefile                   |    4 +-
 tools/testing/selftests/arm64/abi/syscall-abi.c    |    8 +
 tools/testing/selftests/arm64/fp/Makefile          |    2 +-
 .../selftests/arm64/signal/testcases/ssve_regs.c   |    4 +
 .../selftests/arm64/signal/testcases/za_regs.c     |    4 +
 tools/testing/selftests/arm64/tags/Makefile        |    2 +-
 tools/testing/selftests/bpf/Makefile               |    7 +-
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |    2 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |    4 +
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |   10 +-
 tools/testing/selftests/bpf/progs/map_kptr.c       |   12 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |   11 +-
 tools/testing/selftests/bpf/xdp_synproxy.c         |    1 +
 tools/testing/selftests/bpf/xskxceiver.c           |   22 +-
 tools/testing/selftests/clone3/Makefile            |    2 +-
 tools/testing/selftests/core/Makefile              |    2 +-
 tools/testing/selftests/dmabuf-heaps/Makefile      |    2 +-
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c |    3 +-
 tools/testing/selftests/drivers/dma-buf/Makefile   |    2 +-
 .../selftests/drivers/net/netdevsim/devlink.sh     |   18 +
 .../selftests/drivers/s390x/uvdevice/Makefile      |    3 +-
 tools/testing/selftests/filesystems/Makefile       |    2 +-
 .../selftests/filesystems/binderfs/Makefile        |    2 +-
 tools/testing/selftests/filesystems/epoll/Makefile |    2 +-
 .../test.d/dynevent/eprobes_syntax_errors.tc       |    4 +-
 .../ftrace/test.d/ftrace/func_event_triggers.tc    |    2 +-
 .../selftests/ftrace/test.d/kprobe/probepoint.tc   |    2 +-
 tools/testing/selftests/futex/functional/Makefile  |    2 +-
 tools/testing/selftests/gpio/Makefile              |    2 +-
 tools/testing/selftests/iommu/iommufd.c            |    2 +-
 tools/testing/selftests/ipc/Makefile               |    2 +-
 tools/testing/selftests/kcmp/Makefile              |    2 +-
 tools/testing/selftests/landlock/fs_test.c         |   47 +
 tools/testing/selftests/landlock/ptrace_test.c     |  113 +-
 tools/testing/selftests/media_tests/Makefile       |    2 +-
 tools/testing/selftests/membarrier/Makefile        |    2 +-
 tools/testing/selftests/mount_setattr/Makefile     |    2 +-
 .../selftests/move_mount_set_group/Makefile        |    2 +-
 tools/testing/selftests/net/fib_tests.sh           |    2 +
 tools/testing/selftests/net/udpgso_bench_rx.c      |    6 +-
 tools/testing/selftests/perf_events/Makefile       |    2 +-
 tools/testing/selftests/pid_namespace/Makefile     |    2 +-
 tools/testing/selftests/pidfd/Makefile             |    2 +-
 tools/testing/selftests/powerpc/ptrace/Makefile    |    2 +-
 tools/testing/selftests/powerpc/security/Makefile  |    2 +-
 tools/testing/selftests/powerpc/syscalls/Makefile  |    2 +-
 tools/testing/selftests/powerpc/tm/Makefile        |    2 +-
 tools/testing/selftests/ptp/Makefile               |    2 +-
 tools/testing/selftests/rseq/Makefile              |    2 +-
 tools/testing/selftests/sched/Makefile             |    2 +-
 tools/testing/selftests/seccomp/Makefile           |    2 +-
 tools/testing/selftests/sync/Makefile              |    2 +-
 tools/testing/selftests/user_events/Makefile       |    2 +-
 tools/testing/selftests/vm/Makefile                |    2 +-
 tools/testing/selftests/x86/Makefile               |    2 +-
 tools/tracing/rtla/src/osnoise_hist.c              |    5 +-
 virt/kvm/coalesced_mmio.c                          |    8 +-
 virt/kvm/kvm_main.c                                |   31 +-
 988 files changed, 18517 insertions(+), 14322 deletions(-)


