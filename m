Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86A71AC83A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732756AbgDPPF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408895AbgDPNwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:52:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB7862076D;
        Thu, 16 Apr 2020 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045146;
        bh=NiievQg91zeZsaIymuaXnvRE5U61AhR6t2tSjiqlmsc=;
        h=From:To:Cc:Subject:Date:From;
        b=PHruNCSYfKmx/a+4pgNzEI4x8QTw8h8gQJqi8M9etmQMF+dBFn7BrlBmi0SSqfOc7
         hMa3iQRxQK6Avyl7uXxPn/BJqxHM1+YQn+LEEnpRDasG93b644gExipzUF9Qh8rB57
         Upoz0Q7ySPb65K9utciEeyvSqeiLHxCgpTuVpuy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.6 000/254] 5.6.5-rc1 review
Date:   Thu, 16 Apr 2020 15:21:29 +0200
Message-Id: <20200416131325.804095985@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.6.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.6.5-rc1
X-KernelTest-Deadline: 2020-04-18T13:13+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.6.5 release.
There are 254 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.6.5-rc1

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kasan: Fix kasan_remap_early_shadow_ro()

Peter Zijlstra <peterz@infradead.org>
    perf/core: Remove 'struct sched_in_data'

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix event cgroup tracking

Peter Zijlstra <peterz@infradead.org>
    perf/core: Unify {pinned,flexible}_sched_in()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Fill all the unused space in the GGTT

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915/ggtt: do not set bits 1-11 in gen12 ptes

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: fix gfx hang during suspend with video playback (v2)

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Fix clearing payload state on topology disable

Lyude Paul <lyude@redhat.com>
    Revert "drm/dp_mst: Remove VCPI while disabling topology mgr"

Mark Brown <broonie@kernel.org>
    arm64: Always force a branch protection mode when the compiler has one

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Prevent stack protection in early boot

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kprobes: Ignore traps that happened in real mode

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Fix xmon support on the PowerNV platform

Daniel Axtens <dja@axtens.net>
    powerpc/64: Setup a paca before parsing device tree etc.

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Use XIVE_BAD_IRQ instead of zero to catch non configured IPIs

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/hash64/devmap: Use H_PAGE_THP_HUGE when setting up huge devmap PTE entries

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64/tm: Don't let userspace set regs->trap via sigreturn

Clement Courbet <courbet@google.com>
    powerpc: Make setjmp/longjmp signature standard

Bart Van Assche <bvanassche@acm.org>
    scsi: sr: Fix sr_block_release()

Merlijn Wajer <merlijn@archive.org>
    scsi: sr: get rid of sr global mutex

Juergen Gross <jgross@suse.com>
    xen/blkfront: fix memory allocation flags in blkfront_setup_indirect()

Wen Yang <wenyang@linux.alibaba.com>
    ipmi: fix hung processes in __get_guid()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DFLAG_DETACH is set

Simon Gander <simon@tuxera.com>
    hfsplus: fix crash and filesystem corruption when deleting files

Oliver O'Halloran <oohall@gmail.com>
    cpufreq: powernv: Fix use-after-free

Eric Biggers <ebiggers@google.com>
    kmod: make request_module() return an error when autoloading is disabled

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic/TCU: Fix round_rate returning error

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic/jz4770: Exit with error if CGU init failed

Masami Hiramatsu <mhiramat@kernel.org>
    ftrace/kprobe: Show the maxactive number on kprobe_events

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - add Acer Aspire 5738z to nomux list

Michael Mueller <mimu@linux.ibm.com>
    s390/diag: fix display of diagnose call statistics

Sam Lunt <samueljlunt@gmail.com>
    perf tools: Support Python 3.8+ in Makefile

Changwei Ge <chge@linux.alibaba.com>
    ocfs2: no need try to truncate file beyond i_size

Eric Biggers <ebiggers@google.com>
    fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()

Mike Willard <mwillard@izotope.com>
    ASoC: cs4270: pull reset GPIO low then high

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Treat idling as a RPS downclock event

Qian Cai <cai@lca.pw>
    ext4: fix a data race at inode->i_blocks

Scott Mayhew <smayhew@redhat.com>
    NFS: Fix a few constant_table array definitions

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: finish_automount() requires us to hold 2 refs to the mount record

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a page leak in nfs_destroy_unlinked_subrequests()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix use-after-free issues in nfs_pageio_add_request()

J. Bruce Fields <bfields@redhat.com>
    nfsd: fsnotify on rmdir under nfsd/clients/

Hans de Goede <hdegoede@redhat.com>
    drm/vboxvideo: Add missing remove_conflicting_pci_framebuffers call, v2

Libor Pechacek <lpechacek@suse.cz>
    powerpc/pseries: Avoid NULL pointer dereference when drmem is unavailable

Imre Deak <imre.deak@intel.com>
    drm/i915/icl+: Don't enable DDI IO power on a TypeC port in TBT mode

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/prime: fix extracting of the DMA addresses from a scatterlist

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Check for null fclk voltage when parsing clock table

Aaron Liu <aaron.liu@amd.com>
    drm/amdgpu: unify fw_write_wait for new gfx9 asics

Prike Liang <Prike.Liang@amd.com>
    drm/amd/powerplay: implement the is_dpm_running()

Yuxian Dai <Yuxian.Dai@amd.com>
    drm/amdgpu/powerplay: using the FCLK DPM table to set the MCLK

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Remove PageReserved manipulation from drm_pci_alloc

Christian Gmeiner <christian.gmeiner@gmail.com>
    drm/etnaviv: rework perfmon query infrastructure

Torsten Duwe <duwe@lst.de>
    drm/bridge: analogix-anx78xx: Fix drm_dp_link helper removal

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Flush all the reloc_gpu batch

Eric Auger <eric.auger@redhat.com>
    vfio: platform: Switch to platform_get_irq_optional()

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Fix try-run when source tree is not writable

Christophe Leroy <christophe.leroy@c-s.fr>
    selftests/powerpc: Add tlbie_test in .gitignore

Christophe Leroy <christophe.leroy@c-s.fr>
    selftests/vm: fix map_hugetlb length used for testing read and write

Michal Hocko <mhocko@suse.com>
    selftests: vm: drop dependencies on page flags from mlock2 tests

Fredrik Strupe <fredrik@strupe.net>
    arm64: armv8_deprecated: Fix undef_hook mask for thumb setend

Dave Gerlach <d-gerlach@ti.com>
    arm64: dts: ti: k3-am65: Add clocks to dwc3 nodes

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: exynos: Fix polarity of the LCD SPI bus on UniversalC210 board

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix broken Credit Recovery after driver load

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix lpfc_io_buf resource leak in lpfc_get_scsi_buf_s4 error path

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: fix Auto-Hibern8 error detection

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix missing erp_lock in port recovery trigger for point-to-point

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - dec auth tag size from cryptlen map

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - only try to map auth tag if needed

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - protect against empty or NULL scatterlists

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam - update xts sector size for large input length

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam/qi2 - fix chacha20 data size error

Matthew Wilcox (Oracle) <willy@infradead.org>
    xarray: Fix early termination of xas_for_each_marked

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix xas_pause for large multi-index entries

Nikos Tsironis <ntsironis@arrikto.com>
    dm clone metadata: Fix return type of dm_clone_nr_of_hydrated_regions()

Nikos Tsironis <ntsironis@arrikto.com>
    dm clone: Add missing casts to prevent overflows and data corruption

Nikos Tsironis <ntsironis@arrikto.com>
    dm clone: Add overflow check for number of regions

Nikos Tsironis <ntsironis@arrikto.com>
    dm clone: Fix handling of partial region discards

Bob Liu <bob.liu@oracle.com>
    dm zoned: remove duplicate nr_rnd_zones increase in dmz_init_zone()

Shetty, Harshini X (EXT-Sony Mobile) <Harshini.X.Shetty@sony.com>
    dm verity fec: fix memory leak in verity_fec_dtr

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix a crash with unusually large tag size

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: add cond_resched to avoid CPU hangs

Jakub Kicinski <kuba@kernel.org>
    mm, memcg: do not high throttle allocators based on wraparound

Maxime Ripard <maxime@cerno.tech>
    arm64: dts: allwinner: h5: Fix PMU compatible

Scott Wood <swood@redhat.com>
    sched/core: Remove duplicate assignment in sched_tick_remote()

Maxime Ripard <maxime@cerno.tech>
    arm64: dts: allwinner: h6: Fix PMU compatible

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
    net: qualcomm: rmnet: Allow configuration updates to existing devices

Anssi Hannula <anssi.hannula@bitwise.fi>
    tools: gpio: Fix out-of-tree build regression

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug

Jens Axboe <axboe@kernel.dk>
    io_uring: honor original task RLIMIT_FSIZE

Rosioru Dragos <dragos.rosioru@nxp.com>
    crypto: mxs-dcp - fix scatterlist linearization for hash

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: rng - Fix a refcounting bug in crypto_rng_reset()

Dmitry Safonov <0x7f454c46@gmail.com>
    time/namespace: Add max_time_namespaces ucount

Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>
    time/namespace: Fix time_for_children symlink

Nikita Shubin <NShubin@topcon.com>
    remoteproc: Fix NULL pointer dereference in rproc_virtio_notify

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom_q6v5_mss: Reload the mba region on coredump

Bjorn Andersson <bjorn.andersson@linaro.org>
    remoteproc: qcom_q6v5_mss: Don't reassign mpss region on shutdown

Josef Bacik <josef@toxicpanda.com>
    btrfs: use nofs allocations for running delayed items

Robbie Ko <robbieko@synology.com>
    btrfs: fix missing semaphore unlock in btrfs_sync_file

Josef Bacik <josef@toxicpanda.com>
    btrfs: unset reloc control if we fail to recover

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing file extent item for hole after ranged fsync

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop block from cache on error in relocation

Josef Bacik <josef@toxicpanda.com>
    btrfs: set update the uuid generation as soon as possible

Josef Bacik <josef@toxicpanda.com>
    btrfs: reloc: clean dirty subvols if we fail to start a transaction

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix crash during unmount due to race with delayed inode workers

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix btrfs_calc_reclaim_metadata_size calculation

Qu Wenruo <wqu@suse.com>
    btrfs: Don't submit any btree write bio if the fs has errors

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915/gen12: Disable preemption timeout

Piotr Sroka <piotrs@cadence.com>
    mtd: rawnand: cadence: reinit completion before executing a new command

Piotr Sroka <piotrs@cadence.com>
    mtd: rawnand: cadence: change bad block marker size

Piotr Sroka <piotrs@cadence.com>
    mtd: rawnand: cadence: fix the calculation of the avaialble OOB size

Frieder Schrempf <frieder.schrempf@kontron.de>
    mtd: spinand: Do not erase the block before writing a bad block marker

Frieder Schrempf <frieder.schrempf@kontron.de>
    mtd: spinand: Stop using spinand->oobbuf for buffering bad block markers

Murphy Zhou <jencce.kernel@gmail.com>
    CIFS: check new file size when extending file by fallocate

Yilu Lin <linyilu@huawei.com>
    CIFS: Fix bug which the return value by asynchronous read is error

Steve French <stfrench@microsoft.com>
    smb3: fix performance regression with setting mtime

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: VMX: fix crash cleanup when KVM wasn't used

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Add a trampoline to fix VMREAD error handling

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Gracefully handle __vmalloc() failure during VM allocation

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Allocate new rmap and large page tracking when moving memslot

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: Fix delivery of addressing exceptions

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Properly handle userspace interrupt window request

Fabiano Rosas <farosas@linux.ibm.com>
    KVM: PPC: Book3S HV: Skip kvmppc_uvmem_free if Ultravisor is not supported

Kristian Klausen <kristian@klausen.dk>
    platform/x86: asus-wmi: Support laptops where the first battery is named BATT

Thomas Gleixner <tglx@linutronix.de>
    x86/entry/32: Add missing ASM_CLAC to general_protection entry

Hans de Goede <hdegoede@redhat.com>
    x86/tsc_msr: Make MSR derived TSC frequency more accurate

Hans de Goede <hdegoede@redhat.com>
    x86/tsc_msr: Fix MSR_FSB_FREQ mask for Cherry Trail devices

Hans de Goede <hdegoede@redhat.com>
    x86/tsc_msr: Use named struct initializers

Eric W. Biederman <ebiederm@xmission.com>
    signal: Extend exec_id to 64bits

Remi Pommarel <repk@triplefau.lt>
    ath9k: Handle txpower changes even when TPC is disabled

Neeraj Upadhyay <neeraju@codeaurora.org>
    PM: sleep: wakeup: Skip wakeup_source_sysfs_remove() if device is not there

Ulf Hansson <ulf.hansson@linaro.org>
    PM / Domains: Allow no domain-idle-states DT property in genpd when parsing

Gustavo A. R. Silva <gustavo@embeddedor.com>
    MIPS: OCTEON: irq: Fix potential NULL pointer dereference

Huacai Chen <chenhc@lemote.com>
    MIPS/tlbex: Fix LDDIR usage in setup_pw() for Loongson-3

Vasily Averin <vvs@virtuozzo.com>
    pstore: pstore_ftrace_seq_next should increase position index

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix ctx refcounting in io_submit_sqes()

Jens Axboe <axboe@kernel.dk>
    io_uring: remove bogus RLIMIT_NOFILE check in file registration

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure openat sets O_LARGEFILE if needed

Sungbo Eo <mans0n@gorani.run>
    irqchip/versatile-fpga: Apply clear-mask earlier

Thomas Gleixner <tglx@linutronix.de>
    genirq/debugfs: Add missing sanity checks to interrupt injection

Thomas Gleixner <tglx@linutronix.de>
    cpu/hotplug: Ignore pm_wakeup_pending() for disable_nonboot_cpus()

Paul E. McKenney <paulmck@kernel.org>
    rcu: Make rcu_barrier() account for offline no-CBs CPUs

Ludovic Barre <ludovic.barre@st.com>
    mmc: mmci_sdmmc: Fix clear busyd0end irq flag

Yang Xu <xuyang2018.jy@cn.fujitsu.com>
    KEYS: reaching the keys quotas correctly

Vasily Averin <vvs@virtuozzo.com>
    tpm: tpm2_bios_measurements_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    tpm: tpm1_bios_measurements_next should increase position index

Matthew Garrett <matthewgarrett@google.com>
    tpm: Don't make log failures fatal

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix enqueue_task_fair warning

Gao Xiang <xiang@kernel.org>
    erofs: correct the remaining shrink objects

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: endpoint: Fix for concurrent memory allocation in OB address region

Bjorn Andersson <bjorn.andersson@linaro.org>
    PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM

Sean V Kelley <sean.v.kelley@linux.intel.com>
    PCI: Add boot interrupt quirk mechanism for Xeon chipsets

Yicong Yang <yangyicong@hisilicon.com>
    PCI/ASPM: Clear the correct bits when enabling L1 substates

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Fix indefinite wait on sysfs requests

Tom Lendacky <thomas.lendacky@amd.com>
    efi/x86: Add TPM related EFI tables to unencrypted mapping checks

James Smart <jsmart2021@gmail.com>
    nvme-fc: Revert "add module to ops template to allow module references"

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix maxh2cdata icresp parameter

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=n

Gayatri Kammela <gayatri.kammela@intel.com>
    thermal: int340x_thermal: fix: Update Tiger Lake ACPI device IDs

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: s2idle: Refine active GPEs check

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Allow acpi_any_gpe_status_set() to skip one GPE

Jan Engelhardt <jengelh@inai.de>
    acpi/x86: ignore unspecified bit positions in the ACPI global lock field

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Avoid printing confusing messages in acpi_ec_setup()

Sven Schnelle <svens@linux.ibm.com>
    seccomp: Add missing compat_ioctl for notify

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: cal: fix a kernel oops when unloading module

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: cal: fix disable_irqs to only the intended target

Andrzej Pietrasiewicz <andrzej.p@collabora.com>
    media: hantro: Read be32 words starting at every fourth byte

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: firmware: Ignore secure call error on first resume

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: cache vb payload to be used by clock scaling

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Add quirk for MSI GL63

Hans de Goede <hdegoede@redhat.com>
    ALSA: hda/realtek - Add quirk for Lenovo Carbon X1 8th gen

Thomas Hebb <tommyhebb@gmail.com>
    ALSA: hda/realtek - Remove now-unnecessary XPS 13 headphone noise fixups

Thomas Hebb <tommyhebb@gmail.com>
    ALSA: hda/realtek - Set principled PC Beep configuration for ALC256

Thomas Hebb <tommyhebb@gmail.com>
    ALSA: doc: Document PC Beep Hidden Register on Realtek ALC256

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - a fake key event is triggered by running shutup

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Enable mute LED on an HP system

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix regression by buffer overflow fix

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1724: Fix invalid access for enumerated ctl items

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix potential access overflow in beep helper

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add driver blacklist

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add mixer workaround for TRX40 and co

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: composite: Inform controller driver of self-powered

Sriharsha Allenki <sallenki@codeaurora.org>
    usb: gadget: f_fs: Fix use after free issue as part of queue failure

이경택 <gt82.lee@samsung.com>
    ASoC: topology: use name_prefix for new kcontrol

이경택 <gt82.lee@samsung.com>
    ASoC: dpcm: allow start or stop during pause for backend

이경택 <gt82.lee@samsung.com>
    ASoC: dapm: connect virtual mux with default value

이경택 <gt82.lee@samsung.com>
    ASoC: fix regwmask

Josef Bacik <josef@toxicpanda.com>
    btrfs: track reloc roots based on their commit root bytenr

Josef Bacik <josef@toxicpanda.com>
    btrfs: restart relocate_tree_blocks properly

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove a BUG_ON() from merge_reloc_roots()

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: ensure qgroup_rescan_running is only set when the worker is at least queued

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    block, bfq: fix use-after-free in bfq_idle_slice_timer_body

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-pci: avoid to poweroff the phy for slot one

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps()

Vladimir Oltean <vladimir.oltean@nxp.com>
    spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion

Junyong Sun <sunjy516@gmail.com>
    firmware: fix a double abort case with fw_load_sysfs_fallback

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: check arrays is suspended in mddev_detach before call quiesce operations

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v4: Provide irq_retrigger to avoid circular locking dependency

Neil Armstrong <narmstrong@baylibre.com>
    usb: dwc3: core: add support for disabling SS instances in park mode

Dongchun Zhu <dongchun.zhu@mediatek.com>
    media: i2c: ov5695: Fix power on and off sequences

Hsin-Yi Wang <hsinyi@chromium.org>
    media: mtk-vpu: avoid unaligned access to DTCM buffer.

Alexey Dobriyan <adobriyan@gmail.com>
    block, zoned: fix integer overflow with BLKRESETZONE et al

Sahitya Tummala <stummala@codeaurora.org>
    block: Fix use-after-free issue accessing struct io_cq

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    genirq/irqdomain: Check pointer in irq_domain_alloc_irqs_hierarchy()

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Ignore the memory attributes table on i386

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot: Use unsigned comparison for addresses

Peng Fan <peng.fan@nxp.com>
    cpufreq: imx6q: fix error handling

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't demote a glock until its revokes are written

Bob Peterson <rpeterso@redhat.com>
    gfs2: Do log_flush in gfs2_ail_empty_gl even if ail list is empty

chenqiwu <chenqiwu@xiaomi.com>
    pstore/platform: fix potential mem leak if pstore_init_fs failed

John Garry <john.garry@huawei.com>
    libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()

Matt Ranostay <matt.ranostay@konsulko.com>
    media: i2c: video-i2c: fix build errors due to 'imply hwmon'

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: move forward the getting of an extra ref in bfq_bfqq_move

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Fix init_completion race condition with poll_wait()

Andy Lutomirski <luto@kernel.org>
    selftests/x86/ptrace_syscall_32: Fix no-vDSO segfault

Tao Zhou <ouwen210@hotmail.com>
    sched/fair: Fix condition of avg_load calculation

Michael Wang <yun.wang@linux.alibaba.com>
    sched: Avoid scale real weight down to zero

Michael Tretter <m.tretter@pengutronix.de>
    media: allegro: fix type of gop_length in channel_create message

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v4.1: Skip absent CPUs while iterating over redistributors

Ahmed S. Darwish <a.darwish@linutronix.de>
    time/sched_clock: Expire timer in hardirq context

Sungbo Eo <mans0n@gorani.run>
    irqchip/versatile-fpga: Handle chained IRQs properly

Vladimir Oltean <vladimir.oltean@nxp.com>
    spi: spi-fsl-dspi: Avoid NULL pointer in dspi_slave_abort for non-DMA mode

Taehee Yoo <ap420073@gmail.com>
    debugfs: Check module state before warning in {full/open}_proxy_open()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    block: keep bdi->io_pages in sync with max_sectors_kb for stacked devices

Thomas Hellstrom <thellstrom@vmware.com>
    dma-mapping: Fix dma_pgprot() for unencrypted coherent pages

Thomas Hellstrom <thellstrom@vmware.com>
    x86: Don't let pgprot_modify() change the page encryption bit

Claudiu Beznea <claudiu.beznea@microchip.com>
    clocksource/drivers/timer-microchip-pit64b: Fix rate for gck

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: bail out early if driver can't accress host in resume

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx: imx7-media-csi: Fix video field handling

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx: imx7_mipi_csis: Power off the source when stopping streaming

Alexey Dobriyan <adobriyan@gmail.com>
    null_blk: fix spurious IO errors after failed past-wp access

Bart Van Assche <bvanassche@acm.org>
    null_blk: Suppress an UBSAN complaint triggered when setting 'memory_backed'

Bart Van Assche <bvanassche@acm.org>
    null_blk: Handle null_add_dev() failures properly

Bart Van Assche <bvanassche@acm.org>
    blk-mq: Fix a recently introduced regression in blk_mq_realloc_hw_ctxs()

Bart Van Assche <bvanassche@acm.org>
    null_blk: Fix the null_add_dev() error path

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: check return value from st_lsm6dsx_sensor_set_enable

Chris Wilson <chris@chris-wilson.co.uk>
    sched/vtime: Prevent unstable evaluation of WARN(vtime->state)

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Hold memory hotplug lock while walking for kernel page table dump

Krzysztof Kozlowski <krzk@kernel.org>
    usb: phy: tegra: Include proper GPIO consumer header to fix compile testing

Mohammad Rasim <mohammad.rasim96@gmail.com>
    media: arm64: dts: amlogic: add rc-videostrong-kii-pro keymap

James Morse <james.morse@arm.com>
    firmware: arm_sdei: fix double-lock on hibernate with shared events

Stephan Gerhold <stephan@gerhold.net>
    media: venus: hfi_parser: Ignore HEVC encoding for V1

Helen Koike <helen.koike@collabora.com>
    media: staging: rkisp1: isp: do not set invalid mbus code for pad

Helen Koike <helen.koike@collabora.com>
    media: staging: rkisp1: use consistent bus_info string for media_dev

Philipp Zabel <p.zabel@pengutronix.de>
    media: hantro: fix extra MV/MC sync space calculation

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: vimc: streamer: fix memory leak in vimc subdevs if kthread_run fails

Ajay Singh <ajay.kathat@microchip.com>
    staging: wilc1000: avoid double unlocking of 'wilc->hif_cs' mutex

Ajay Gupta <ajayg@nvidia.com>
    usb: ucsi: ccg: disable runtime pm during fw flashing

Robert Richter <rrichter@marvell.com>
    EDAC/mc: Report "unknown memory" on too many DIMM labels found

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    cpufreq: imx6q: Fixes unwanted cpu overclocking on i.MX6ULL

Mohammad Rasim <mohammad.rasim96@gmail.com>
    media: rc: add keymap for Videostrong KII Pro


-------------

Diffstat:

 Documentation/admin-guide/sysctl/user.rst          |   6 +
 Documentation/sound/hd-audio/index.rst             |   1 +
 Documentation/sound/hd-audio/models.rst            |   2 -
 Documentation/sound/hd-audio/realtek-pc-beep.rst   | 129 ++++++++++++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/exynos4210-universal_c210.dts    |   4 +-
 arch/arm64/Makefile                                |   4 +
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi       |   3 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |   3 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts |   4 +
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |   2 +
 arch/arm64/kernel/armv8_deprecated.c               |   2 +-
 arch/arm64/mm/ptdump_debugfs.c                     |   4 +
 arch/mips/cavium-octeon/octeon-irq.c               |   3 +
 arch/mips/mm/tlbex.c                               |   5 +-
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |   6 +
 arch/powerpc/include/asm/book3s/64/hash-64k.h      |   8 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   4 +-
 arch/powerpc/include/asm/book3s/64/radix.h         |   5 +
 arch/powerpc/include/asm/drmem.h                   |   4 +-
 arch/powerpc/include/asm/setjmp.h                  |   6 +-
 arch/powerpc/kernel/dt_cpu_ftrs.c                  |   1 -
 arch/powerpc/kernel/kprobes.c                      |   3 +
 arch/powerpc/kernel/paca.c                         |  14 +-
 arch/powerpc/kernel/setup.h                        |   6 +
 arch/powerpc/kernel/setup_64.c                     |  32 ++-
 arch/powerpc/kernel/signal_64.c                    |   4 +-
 arch/powerpc/kexec/Makefile                        |   3 -
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   3 +
 arch/powerpc/mm/kasan/kasan_init_32.c              |   2 +-
 arch/powerpc/mm/nohash/tlb_low.S                   |  12 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   8 +-
 arch/powerpc/sysdev/xive/common.c                  |  16 +-
 arch/powerpc/sysdev/xive/native.c                  |   4 +-
 arch/powerpc/sysdev/xive/spapr.c                   |   4 +-
 arch/powerpc/sysdev/xive/xive-internal.h           |   7 +
 arch/powerpc/xmon/Makefile                         |   3 -
 arch/s390/kernel/diag.c                            |   2 +-
 arch/s390/kvm/vsie.c                               |   1 +
 arch/s390/mm/gmap.c                                |   6 +-
 arch/x86/boot/compressed/head_32.S                 |   2 +-
 arch/x86/boot/compressed/head_64.S                 |   4 +-
 arch/x86/entry/entry_32.S                          |   1 +
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/pgtable.h                     |   7 +-
 arch/x86/include/asm/pgtable_types.h               |   2 +-
 arch/x86/kernel/acpi/boot.c                        |   2 +-
 arch/x86/kernel/tsc_msr.c                          | 128 +++++++++--
 arch/x86/kvm/svm.c                                 |   4 +
 arch/x86/kvm/vmx/nested.c                          |  18 +-
 arch/x86/kvm/vmx/ops.h                             |  28 ++-
 arch/x86/kvm/vmx/vmenter.S                         |  58 +++++
 arch/x86/kvm/vmx/vmx.c                             |  92 +++-----
 arch/x86/kvm/x86.c                                 |  21 +-
 arch/x86/platform/efi/efi.c                        |   2 +
 block/bfq-cgroup.c                                 |  14 +-
 block/bfq-iosched.c                                |  16 +-
 block/blk-ioc.c                                    |   7 +
 block/blk-mq.c                                     |   1 -
 block/blk-settings.c                               |   3 +
 block/blk-zoned.c                                  |   2 +-
 crypto/rng.c                                       |   8 +-
 drivers/acpi/acpica/achware.h                      |   2 +-
 drivers/acpi/acpica/evxfgpe.c                      |  17 +-
 drivers/acpi/acpica/hwgpe.c                        |  47 ++++-
 drivers/acpi/ec.c                                  |  26 ++-
 drivers/acpi/internal.h                            |   1 +
 drivers/acpi/sleep.c                               |  19 +-
 drivers/ata/libata-pmp.c                           |   1 +
 drivers/ata/libata-scsi.c                          |   9 +-
 drivers/base/firmware_loader/fallback.c            |   2 +-
 drivers/base/power/domain.c                        |   2 +-
 drivers/base/power/wakeup.c                        |   4 +-
 drivers/block/null_blk_main.c                      |  12 +-
 drivers/block/xen-blkfront.c                       |  17 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   4 +-
 drivers/char/tpm/eventlog/common.c                 |  12 +-
 drivers/char/tpm/eventlog/tpm1.c                   |   2 +-
 drivers/char/tpm/eventlog/tpm2.c                   |   2 +-
 drivers/char/tpm/tpm-chip.c                        |   4 +-
 drivers/char/tpm/tpm.h                             |   2 +-
 drivers/clk/ingenic/jz4770-cgu.c                   |   4 +-
 drivers/clk/ingenic/tcu.c                          |   2 +-
 drivers/clocksource/timer-microchip-pit64b.c       |   1 +
 drivers/cpufreq/imx6q-cpufreq.c                    |  12 +-
 drivers/cpufreq/powernv-cpufreq.c                  |   6 +
 drivers/crypto/caam/caamalg_desc.c                 |  30 ++-
 drivers/crypto/ccree/cc_buffer_mgr.c               |  76 ++++---
 drivers/crypto/ccree/cc_buffer_mgr.h               |   1 +
 drivers/crypto/mxs-dcp.c                           |  58 +++--
 drivers/edac/edac_mc.c                             |  21 +-
 drivers/firmware/arm_sdei.c                        |  32 ++-
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   5 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 +
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |   2 +-
 drivers/gpu/drm/amd/powerplay/renoir_ppt.c         |  18 ++
 drivers/gpu/drm/amd/powerplay/renoir_ppt.h         |   2 +-
 drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c |   5 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  20 +-
 drivers/gpu/drm/drm_pci.c                          |  23 +-
 drivers/gpu/drm/drm_prime.c                        |  37 ++--
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c          |  59 +++++-
 drivers/gpu/drm/i915/Kconfig.profile               |   4 +
 drivers/gpu/drm/i915/display/intel_ddi.c           |   6 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   8 +-
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c               |  26 +++
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |  13 +-
 drivers/gpu/drm/i915/gt/intel_ggtt.c               |  48 +++--
 drivers/gpu/drm/i915/gt/intel_gtt.c                |  24 ---
 drivers/gpu/drm/i915/gt/intel_gtt.h                |   4 -
 drivers/gpu/drm/i915/gt/intel_rps.c                |  13 ++
 drivers/gpu/drm/vboxvideo/vbox_drv.c               |   4 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c       |   5 +-
 drivers/input/serio/i8042-x86ia64io.h              |  11 +
 drivers/irqchip/irq-gic-v3-its.c                   |  10 +
 drivers/irqchip/irq-versatile-fpga.c               |  18 +-
 drivers/md/dm-clone-metadata.c                     |  15 +-
 drivers/md/dm-clone-metadata.h                     |   2 +-
 drivers/md/dm-clone-target.c                       |  66 ++++--
 drivers/md/dm-integrity.c                          |   4 +-
 drivers/md/dm-verity-fec.c                         |   1 +
 drivers/md/dm-writecache.c                         |   6 +-
 drivers/md/dm-zoned-metadata.c                     |   1 -
 drivers/md/md.c                                    |   2 +-
 drivers/media/i2c/ov5695.c                         |  49 +++--
 drivers/media/i2c/video-i2c.c                      |   2 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c       |   9 +-
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    |   6 +-
 drivers/media/platform/mtk-vcodec/venc_vpu_if.c    |  12 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |  45 ++--
 drivers/media/platform/mtk-vpu/mtk_vpu.h           |   2 +-
 drivers/media/platform/qcom/venus/core.h           |   1 +
 drivers/media/platform/qcom/venus/firmware.c       |  10 +-
 drivers/media/platform/qcom/venus/helpers.c        |  20 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     |   1 +
 drivers/media/platform/ti-vpe/cal.c                |  29 +--
 drivers/media/platform/vimc/vimc-streamer.c        |   9 +-
 drivers/media/rc/keymaps/Makefile                  |   1 +
 drivers/media/rc/keymaps/rc-videostrong-kii-pro.c  |  83 ++++++++
 drivers/mmc/host/mmci_stm32_sdmmc.c                |   4 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |  13 +-
 drivers/mtd/nand/spi/core.c                        |  17 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |  31 +--
 drivers/net/wireless/ath/ath9k/main.c              |   3 +
 drivers/nvme/host/fc.c                             |  14 +-
 drivers/nvme/target/fcloop.c                       |   1 -
 drivers/nvme/target/tcp.c                          |   2 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   8 +-
 drivers/pci/endpoint/pci-epc-mem.c                 |  10 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |  14 +-
 drivers/pci/pcie/aspm.c                            |   4 +-
 drivers/pci/quirks.c                               |  80 ++++++-
 drivers/pci/switch/switchtec.c                     |   2 +-
 drivers/platform/x86/asus-wmi.c                    |   5 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |  54 +++--
 drivers/remoteproc/remoteproc_virtio.c             |   7 +
 drivers/s390/scsi/zfcp_erp.c                       |   2 +-
 drivers/scsi/lpfc/lpfc.h                           |   1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  59 ++++--
 drivers/scsi/lpfc/lpfc_nvme.c                      |   2 -
 drivers/scsi/lpfc/lpfc_scsi.c                      |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   8 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   1 -
 drivers/scsi/sr.c                                  |  22 +-
 drivers/scsi/sr.h                                  |   2 +
 drivers/scsi/ufs/ufshcd.c                          |   3 +-
 drivers/scsi/ufs/ufshcd.h                          |   6 +
 drivers/spi/spi-fsl-dspi.c                         |  25 +--
 drivers/staging/media/allegro-dvt/allegro-core.c   |   5 +-
 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c  |   9 +-
 drivers/staging/media/hantro/hantro_v4l2.c         |   2 +-
 .../staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c  |   9 +-
 drivers/staging/media/imx/imx7-media-csi.c         |   4 +
 drivers/staging/media/imx/imx7-mipi-csis.c         |   2 +-
 drivers/staging/media/rkisp1/rkisp1-dev.c          |   3 +-
 drivers/staging/media/rkisp1/rkisp1-isp.c          |   4 +-
 drivers/staging/mt7621-pci/pci-mt7621.c            |   3 +-
 drivers/staging/wilc1000/wlan.c                    |   1 -
 .../intel/int340x_thermal/int3400_thermal.c        |   2 +-
 .../intel/int340x_thermal/int3403_thermal.c        |   2 +-
 drivers/usb/dwc3/core.c                            |   5 +
 drivers/usb/dwc3/core.h                            |   4 +
 drivers/usb/gadget/composite.c                     |   9 +
 drivers/usb/gadget/function/f_fs.c                 |   1 +
 drivers/usb/host/xhci.c                            |   4 +-
 drivers/usb/phy/phy-tegra-usb.c                    |   3 +-
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   2 +
 drivers/vfio/platform/vfio_platform.c              |   2 +-
 fs/btrfs/async-thread.c                            |   8 +
 fs/btrfs/async-thread.h                            |   1 +
 fs/btrfs/delayed-inode.c                           |  13 ++
 fs/btrfs/disk-io.c                                 |  27 ++-
 fs/btrfs/extent_io.c                               |  35 +++-
 fs/btrfs/file.c                                    |  11 +
 fs/btrfs/qgroup.c                                  |  11 +-
 fs/btrfs/relocation.c                              |  62 +++---
 fs/btrfs/space-info.c                              |  43 +++-
 fs/cifs/file.c                                     |   2 +-
 fs/cifs/inode.c                                    |  23 +-
 fs/cifs/smb2ops.c                                  |   4 +
 fs/debugfs/file.c                                  |  18 +-
 fs/erofs/utils.c                                   |   2 +-
 fs/exec.c                                          |   2 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/filesystems.c                                   |   4 +-
 fs/gfs2/glock.c                                    |   3 +
 fs/gfs2/glops.c                                    |  27 ++-
 fs/gfs2/log.c                                      |   2 +-
 fs/gfs2/log.h                                      |   1 +
 fs/hfsplus/attributes.c                            |   4 +
 fs/io_uring.c                                      |  23 +-
 fs/nfs/fs_context.c                                |   5 +-
 fs/nfs/namespace.c                                 |  12 +-
 fs/nfs/pagelist.c                                  |  48 ++---
 fs/nfs/write.c                                     |   1 +
 fs/nfsd/nfsctl.c                                   |   1 +
 fs/ocfs2/alloc.c                                   |   4 +
 fs/pstore/inode.c                                  |   5 +-
 fs/pstore/platform.c                               |   4 +-
 include/acpi/acpixf.h                              |   2 +-
 include/linux/cpu.h                                |  12 +-
 include/linux/devfreq_cooling.h                    |   2 +-
 include/linux/iocontext.h                          |   1 +
 include/linux/nvme-fc-driver.h                     |   4 -
 include/linux/pci-epc.h                            |   3 +
 include/linux/sched.h                              |   4 +-
 include/linux/xarray.h                             |   6 +-
 include/media/rc-map.h                             |   1 +
 include/trace/events/rcu.h                         |   1 +
 kernel/cpu.c                                       |   4 +-
 kernel/dma/mapping.c                               |   2 +
 kernel/events/core.c                               | 150 ++++++-------
 kernel/irq/debugfs.c                               |  11 +-
 kernel/irq/irqdomain.c                             |  10 +-
 kernel/kmod.c                                      |   4 +-
 kernel/locking/lockdep.c                           |   4 +
 kernel/rcu/tree.c                                  |  36 ++--
 kernel/sched/core.c                                |   1 -
 kernel/sched/cputime.c                             |  41 ++--
 kernel/sched/fair.c                                |  29 ++-
 kernel/sched/sched.h                               |   8 +-
 kernel/seccomp.c                                   |   1 +
 kernel/signal.c                                    |   2 +-
 kernel/time/namespace.c                            |   1 +
 kernel/time/sched_clock.c                          |   9 +-
 kernel/trace/trace_kprobe.c                        |   2 +
 kernel/ucount.c                                    |   1 +
 lib/test_xarray.c                                  |  37 ++++
 lib/xarray.c                                       |   4 +-
 mm/memcontrol.c                                    |   3 +
 security/keys/key.c                                |   2 +-
 security/keys/keyctl.c                             |   4 +-
 sound/core/oss/pcm_plugin.c                        |  32 ++-
 sound/pci/hda/hda_beep.c                           |   6 +-
 sound/pci/hda/hda_intel.c                          |  16 ++
 sound/pci/hda/patch_realtek.c                      | 233 ++++++++++++---------
 sound/pci/ice1712/prodigy_hifi.c                   |   4 +-
 sound/soc/codecs/cs4270.c                          |  40 +++-
 sound/soc/soc-dapm.c                               |   8 +-
 sound/soc/soc-ops.c                                |   4 +-
 sound/soc/soc-pcm.c                                |   6 +-
 sound/soc/soc-topology.c                           |   2 +-
 sound/usb/mixer_maps.c                             |  28 +++
 tools/gpio/Makefile                                |   2 +-
 tools/perf/Makefile.config                         |  11 +-
 tools/testing/radix-tree/Makefile                  |   4 +-
 tools/testing/radix-tree/iteration_check_2.c       |  87 ++++++++
 tools/testing/radix-tree/main.c                    |   1 +
 tools/testing/radix-tree/test.h                    |   1 +
 tools/testing/selftests/powerpc/mm/.gitignore      |   1 +
 tools/testing/selftests/powerpc/pmu/ebb/Makefile   |   1 +
 tools/testing/selftests/vm/map_hugetlb.c           |  14 +-
 tools/testing/selftests/vm/mlock2-tests.c          | 233 ++++-----------------
 tools/testing/selftests/x86/ptrace_syscall.c       |   8 +-
 275 files changed, 2648 insertions(+), 1319 deletions(-)


