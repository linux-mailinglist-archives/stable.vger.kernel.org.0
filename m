Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9480D171E6D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733217AbgB0OHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387675AbgB0OHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:07:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE8620801;
        Thu, 27 Feb 2020 14:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812463;
        bh=XY6MrgRX6zdfjX/dCvQxSwjGiIF5/yBbEGKH4TVw464=;
        h=From:To:Cc:Subject:Date:From;
        b=doePcq1H6+PocaBT1gWT3G81fTBRwBkFkuLCgyhNdAaLw6sf4jJb4oG0aiOSsQN2a
         n+zIuC/aBg2Cw6zl9oqXEE9rz/vX1uQun7Lhx++irDykyzTCHojhdcqiJUCD7iBVfS
         4S6R7nJIf8NUrFugDEwEhyoXVMX4ZTd0CXcIepB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/135] 5.4.23-stable review
Date:   Thu, 27 Feb 2020 14:35:40 +0100
Message-Id: <20200227132228.710492098@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.23-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.23-rc1
X-KernelTest-Deadline: 2020-02-29T13:22+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.23 release.
There are 135 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.23-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.23-rc1

John Fastabend <john.fastabend@gmail.com>
    bpf: Selftests build error in sockmap_basic.c

Nathan Chancellor <natechancellor@gmail.com>
    s390/mm: Explicitly compare PAGE_DEFAULT_KEY against zero in storage_key_init_range

Nathan Chancellor <natechancellor@gmail.com>
    s390/kaslr: Fix casts in get_random

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Fix crash in recovery flow without devlink reporter

Huy Nguyen <huyn@mellanox.com>
    net/mlx5: Fix sleep while atomic in mlx5_eswitch_get_vepa

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Reset RQ doorbell counter before moving RQ state from RST to RDY

Thomas Gleixner <tglx@linutronix.de>
    xen: Enable interrupts when calling _cond_resched()

Prabhakar Kushwaha <pkushwaha@marvell.com>
    ata: ahci: Add shutdown to freeze hardware resources of ahci

Stefano Garzarella <sgarzare@redhat.com>
    io_uring: prevent sq_thread from spinning when it should stop

David Howells <dhowells@redhat.com>
    rxrpc: Fix call RCU cleanup using non-bh-safe locks

Cong Wang <xiyou.wangcong@gmail.com>
    netfilter: xt_hashlimit: limit the max size of hashtable

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix concurrent access to queue current tick/time

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Avoid concurrent access to queue flags

Takashi Iwai <tiwai@suse.de>
    ALSA: rawmidi: Avoid bit fields for state flags

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: fix __io_iopoll_check deadlock in io_sq_thread

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: lse: Fix LSE atomics with LLVM

Johannes Krude <johannes@krude.de>
    bpf, offload: Replace bitwise AND by logical AND in bpf_prog_offload_info_fill

Thomas Gleixner <tglx@linutronix.de>
    genirq/proc: Reject invalid affinity masks (again)

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    crypto: rename sm3-256 to sm3 in hash_algo_name

Joerg Roedel <jroedel@suse.de>
    iommu/vt-d: Fix compile warning from intel-svm.h

Aditya Pakki <pakki001@umn.edu>
    ecryptfs: replace BUG_ON with error handling code

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: fsl_sai: Fix exiting path on probing failure

Arnd Bergmann <arnd@arndb.de>
    ASoC: atmel: fix atmel_ssc_set_audio link failure

Dan Carpenter <dan.carpenter@oracle.com>
    staging: greybus: use after free in gb_audio_manager_remove_all()

Colin Ian King <colin.king@canonical.com>
    staging: rtl8723bs: fix copy of overlapping memory

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: Fix in ISOC request length checking

Jack Pham <jackp@codeaurora.org>
    usb: gadget: composite: Fix bMaxPower for SuperSpeedPlus

Bart Van Assche <bvanassche@acm.org>
    scsi: Revert "target: iscsi: Wait for all commands to finish before freeing a session"

Bart Van Assche <bvanassche@acm.org>
    scsi: Revert "RDMA/isert: Fix a recently introduced regression related to logout"

Rob Clark <robdclark@chromium.org>
    drm/msm/dpu: fix BGR565 vs RGB565 confusion

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Protect defer_request() from new waiters

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/bridge: tc358767: fix poll timeouts

Igor Druzhinin <igor.druzhinin@citrix.com>
    drm/i915/gvt: more locking for ppgtt mm LRU list

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/execlists: Always force a context reload when rewinding RING_TAIL

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Detect if we miss WaIdleLiteRestore

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "dmaengine: imx-sdma: Fix memory leak"

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix deadlock during fast fsync when logging prealloc extents beyond eof

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't set path->leave_spinning for truncate

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between shrinking truncate and fiemap

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix btrfs_wait_ordered_range() so that it waits for all ordered extents

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not check delayed items are empty for single transaction cleanup

Josef Bacik <josef@toxicpanda.com>
    btrfs: reset fs_root to NULL on error in open_ctree

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix bytes_may_use underflow in prealloc error condtition

Jeff Mahoney <jeffm@suse.com>
    btrfs: destroy qgroup extent records on transaction abort

Miaohe Lin <linmiaohe@huawei.com>
    KVM: apic: avoid calculating pending eoi from an uninitialized val

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: handle nested posted interrupts when apicv is disabled for L1

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only when apicv is globally disabled

Oliver Upton <oupton@google.com>
    KVM: nVMX: Check IO instruction VM-exit conditions

Oliver Upton <oupton@google.com>
    KVM: nVMX: Refactor IO bitmap checks into helper function

Eric Biggers <ebiggers@google.com>
    ext4: fix race between writepages and enabling EXT4_EXTENTS_FL

Eric Biggers <ebiggers@google.com>
    ext4: rename s_journal_flag_rwsem to s_writepages_rwsem

Jan Kara <jack@suse.cz>
    ext4: fix mount failure with quota configured as module

Suraj Jitindar Singh <surajjs@amazon.com>
    ext4: fix potential race between s_flex_groups online resizing and access

Suraj Jitindar Singh <surajjs@amazon.com>
    ext4: fix potential race between s_group_info online resizing and access

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential race between online resizing and write operations

Shijie Luo <luoshijie1@huawei.com>
    ext4: add cond_resched() to __ext4_find_entry()

Qian Cai <cai@lca.pw>
    ext4: fix a data race in EXT4_I(inode)->i_disksize

Miaohe Lin <linmiaohe@huawei.com>
    KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt EOI

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: Don't emulate instructions in guest mode

Suren Baghdasaryan <surenb@google.com>
    sched/psi: Fix OOB write when writing 0 bytes to PSI files

Jani Nikula <jani.nikula@intel.com>
    drm/i915: Update drm/i915 bug filing URL

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Wean off drm_pci_alloc/drm_pci_free

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/gv100-: Re-set LUT after clearing for modesets

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: disable gfxoff when reading rlc clock

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: disable gfxoff when reading rlc clock

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/soc15: fix xclk for raven

Catalin Marinas <catalin.marinas@arm.com>
    mm: Avoid creating virtual address aliases in brk()/mmap()/mremap()

Alexander Potapenko <glider@google.com>
    lib/stackdepot.c: fix global out-of-bounds in stack_slabs

Wei Yang <richardw.yang@linux.intel.com>
    mm/sparsemem: pfn_to_page is not valid yet on SPARSEMEM

Gavin Shan <gshan@redhat.com>
    mm/vmscan.c: don't round up scan size for online memory cgroup

Zenghui Yu <yuzenghui@huawei.com>
    genirq/irqdomain: Make sure all irq domain flags are distinct

Logan Gunthorpe <logang@deltatee.com>
    nvme-multipath: Fix memory leak with ana_log_buf

Vasily Averin <vvs@virtuozzo.com>
    mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()

Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
    Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem()"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: s2idle: Check fixed wakeup events in acpi_s2idle_wake()

Jani Nikula <jani.nikula@intel.com>
    MAINTAINERS: Update drm/i915 bug filing URL

Johan Hovold <johan@kernel.org>
    serdev: ttyport: restore client ops on deregistration

satya priya <skakit@codeaurora.org>
    tty: serial: qcom_geni_serial: Fix RX cancel command failure

Fugang Duan <fugang.duan@nxp.com>
    tty: serial: imx: setup the correct sg entry for tx dma

Nicolas Ferre <nicolas.ferre@microchip.com>
    tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250: Check UPF_IRQ_SHARED in advance

Kim Phillips <kim.phillips@amd.com>
    x86/cpu/amd: Enable the fixed Instructions Retired counter IRPERF

Thomas Gleixner <tglx@linutronix.de>
    x86/mce/amd: Fix kobject lifetime

Borislav Petkov <bp@suse.de>
    x86/mce/amd: Publish the bank pointer only after setup has succeeded

Ard Biesheuvel <ardb@kernel.org>
    x86/ima: use correct identifier for SetupMode variable

wangyan <wangyan122@huawei.com>
    jbd2: fix ocfs2 corrupt when clearing block group bits

Will Deacon <will@kernel.org>
    arm64: memory: Add missing brackets to untagged_addr() macro

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/hugetlb: Fix 8M hugepages on 8xx

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/hugetlb: Fix 512k hugepages on 8xx with 16k page size

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/entry: Fix an #if which should be an #ifdef in entry_32.S

Gustavo Luiz Duarte <gustavold@linux.ibm.com>
    powerpc/tm: Fix clearing MSR[TS] in current when reclaiming on signal delivery

Sam Bobroff <sbobroff@linux.ibm.com>
    powerpc/eeh: Fix deadlock handling dead PHB

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/8xx: Fix clearing of bits 20-23 in ITLB miss

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: perfcnt: Reserve/use the AS attached to the perfcnt MMU context

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8723bs: Fix potential overuse of kernel memory

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8723bs: Fix potential security hole

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8188eu: Fix potential overuse of kernel memory

Larry Finger <Larry.Finger@lwfinger.net>
    staging: rtl8188eu: Fix potential security hole

Bart Van Assche <bvanassche@acm.org>
    scsi: Revert "target/core: Inline transport_lun_remove_cmd()"

Colin Ian King <colin.king@canonical.com>
    usb: dwc3: debug: fix string position formatting mixup with ret and len

Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
    usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows

Hardik Gajjar <hgajjar@de.adit-jv.com>
    USB: hub: Fix the broken detection of USB3 device in SMSC hub

Alan Stern <stern@rowland.harvard.edu>
    USB: hub: Don't record a connect-change event during reset-resume

Richard Dodd <richard.o.dodd@gmail.com>
    USB: Fix novation SourceControl XL after suspend

EJ Hsu <ejh@nvidia.com>
    usb: uas: fix a plug & unplug racing

Johan Hovold <johan@kernel.org>
    USB: quirks: blacklist duplicate ep on Sound Devices USBPre2

Johan Hovold <johan@kernel.org>
    USB: core: add endpoint-blacklist quirk

Peter Chen <peter.chen@nxp.com>
    usb: host: xhci: update event ring dequeue pointer on purpose

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix memory leak when caching protocol extended capability PSI tables - take 2

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix runtime pm enabling for quirky Intel hosts

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Force Maximum Packet size for Full-speed bulk devices to valid range.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.

Suren Baghdasaryan <surenb@google.com>
    staging: android: ashmem: Disallow ashmem memory from being remapped

Eric Dumazet <edumazet@google.com>
    vt: vt_ioctl: fix race in VT_RESIZEX

Jiri Slaby <jslaby@suse.cz>
    vt: selection, close sel_buffer race

Jiri Slaby <jslaby@suse.cz>
    vt: selection, handle pending signals in paste_selection

Nicolas Pitre <nico@fluxnic.net>
    vt: fix scrollback flushing on background consoles

Linus Torvalds <torvalds@linux-foundation.org>
    floppy: check FDC index for errors before assigning it

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    e1000e: Use rtnl_lock to prevent race conditions between net and pci/pm

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: misc: iowarrior: add support for the 100 device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: misc: iowarrior: add support for the 28 and 28L devices

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: misc: iowarrior: add support for 2 OEMed devices

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Prevent crash if non-active NVMem file is read

Josef Bacik <josef@toxicpanda.com>
    btrfs: handle logged extent failure properly

Wenwen Wang <wenwen@cs.uga.edu>
    ecryptfs: fix a memory leak bug in ecryptfs_init_messaging()

Wenwen Wang <wenwen@cs.uga.edu>
    ecryptfs: fix a memory leak bug in parse_tag_1_packet()

Roberto Sassu <roberto.sassu@huawei.com>
    tpm: Initialize crypto_id of allocated_banks to HASH_ALGO__LAST

Samuel Holland <samuel@sholland.org>
    ASoC: sun8i-codec: Fix setting DAI data format

Samuel Holland <samuel@sholland.org>
    ASoC: codec2codec: avoid invalid/double-free of pcm runtime

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Apply quirk for yet another MSI laptop

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Apply quirk for MSI GP63, too

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Use scnprintf() for printing texts for sysfs/procfs

Robin Murphy <robin.murphy@arm.com>
    iommu/qcom: Fix bogus detach logic


-------------

Diffstat:

 Documentation/arm64/tagged-address-abi.rst         |  11 +-
 MAINTAINERS                                        |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/include/asm/lse.h                       |   2 +-
 arch/arm64/include/asm/memory.h                    |   2 +-
 arch/powerpc/include/asm/page.h                    |   5 +
 arch/powerpc/kernel/eeh_driver.c                   |  21 ++--
 arch/powerpc/kernel/entry_32.S                     |   4 +-
 arch/powerpc/kernel/head_8xx.S                     |   2 +-
 arch/powerpc/kernel/signal.c                       |  17 +++-
 arch/powerpc/kernel/signal_32.c                    |  28 ++---
 arch/powerpc/kernel/signal_64.c                    |  22 ++--
 arch/powerpc/mm/hugetlbpage.c                      |  29 ++++--
 arch/s390/boot/kaslr.c                             |   2 +-
 arch/s390/include/asm/page.h                       |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/msr-index.h                   |   2 +
 arch/x86/kernel/cpu/amd.c                          |  14 +++
 arch/x86/kernel/cpu/mce/amd.c                      |  50 ++++-----
 arch/x86/kernel/ima_arch.c                         |   6 +-
 arch/x86/kvm/irq_comm.c                            |   2 +-
 arch/x86/kvm/lapic.c                               |   9 +-
 arch/x86/kvm/svm.c                                 |   7 +-
 arch/x86/kvm/vmx/capabilities.h                    |   1 +
 arch/x86/kvm/vmx/nested.c                          |  44 ++++----
 arch/x86/kvm/vmx/nested.h                          |   5 +-
 arch/x86/kvm/vmx/vmx.c                             |  82 +++++++++++----
 crypto/hash_info.c                                 |   2 +-
 drivers/acpi/acpica/evevent.c                      |  45 ++++++++
 drivers/acpi/sleep.c                               |   7 ++
 drivers/ata/ahci.c                                 |   7 ++
 drivers/ata/libata-core.c                          |  21 ++++
 drivers/block/floppy.c                             |   7 +-
 drivers/char/tpm/tpm2-cmd.c                        |   2 +
 drivers/dma/imx-sdma.c                             |  19 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 +
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   7 +-
 drivers/gpu/drm/bridge/tc358767.c                  |   8 +-
 drivers/gpu/drm/i915/Kconfig                       |   5 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h   |   3 -
 drivers/gpu/drm/i915/gem/i915_gem_phys.c           |  98 +++++++++---------
 drivers/gpu/drm/i915/gt/intel_engine.h             |   8 ++
 drivers/gpu/drm/i915/gt/intel_engine_types.h       |   1 +
 drivers/gpu/drm/i915/gt/intel_lrc.c                |  63 ++++++------
 drivers/gpu/drm/i915/gt/intel_ringbuffer.c         |   2 +
 drivers/gpu/drm/i915/gvt/gtt.c                     |   4 +
 drivers/gpu/drm/i915/i915_gem.c                    |   8 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |   3 +-
 drivers/gpu/drm/i915/i915_scheduler.c              |   6 +-
 drivers/gpu/drm/i915/i915_utils.c                  |   5 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c        |   4 +-
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   2 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   7 +-
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c        |  11 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  12 +++
 drivers/iommu/qcom_iommu.c                         |  28 +++--
 drivers/net/ethernet/intel/e1000e/netdev.c         |  68 +++++++------
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   8 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  14 +--
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |  39 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |   2 +
 drivers/nvme/host/multipath.c                      |   1 +
 drivers/staging/android/ashmem.c                   |  28 +++++
 drivers/staging/greybus/audio_manager.c            |   2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   4 +-
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c     |   5 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c     |   4 +-
 drivers/staging/vt6656/dpc.c                       |   2 +-
 drivers/target/iscsi/iscsi_target.c                |  16 +--
 drivers/target/target_core_transport.c             |  31 +++++-
 drivers/thunderbolt/switch.c                       |   7 ++
 drivers/tty/serdev/serdev-ttyport.c                |   6 +-
 drivers/tty/serial/8250/8250_aspeed_vuart.c        |   1 -
 drivers/tty/serial/8250/8250_core.c                |   5 +-
 drivers/tty/serial/8250/8250_of.c                  |   1 -
 drivers/tty/serial/8250/8250_port.c                |   4 +
 drivers/tty/serial/atmel_serial.c                  |   3 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/qcom_geni_serial.c              |  18 +++-
 drivers/tty/tty_port.c                             |   5 +-
 drivers/tty/vt/selection.c                         |  32 ++++--
 drivers/tty/vt/vt.c                                |  15 ++-
 drivers/tty/vt/vt_ioctl.c                          |  17 ++--
 drivers/usb/core/config.c                          |  11 ++
 drivers/usb/core/hub.c                             |  20 +++-
 drivers/usb/core/hub.h                             |   1 +
 drivers/usb/core/quirks.c                          |  40 ++++++++
 drivers/usb/core/usb.h                             |   3 +
 drivers/usb/dwc2/gadget.c                          |  40 ++++----
 drivers/usb/dwc3/debug.h                           |  39 +++----
 drivers/usb/dwc3/gadget.c                          |   3 +-
 drivers/usb/gadget/composite.c                     |   8 +-
 drivers/usb/host/xhci-hub.c                        |  25 +++--
 drivers/usb/host/xhci-mem.c                        |  71 ++++++++-----
 drivers/usb/host/xhci-pci.c                        |  10 +-
 drivers/usb/host/xhci-ring.c                       |  60 +++++++----
 drivers/usb/host/xhci.h                            |  14 ++-
 drivers/usb/misc/iowarrior.c                       |  31 +++++-
 drivers/usb/storage/uas.c                          |  23 ++++-
 drivers/xen/preempt.c                              |   4 +-
 fs/btrfs/disk-io.c                                 |   3 +-
 fs/btrfs/extent-tree.c                             |   2 +
 fs/btrfs/inode.c                                   |  26 ++++-
 fs/btrfs/ordered-data.c                            |   7 +-
 fs/btrfs/qgroup.c                                  |  13 +++
 fs/btrfs/qgroup.h                                  |   1 +
 fs/btrfs/transaction.c                             |   2 +
 fs/ecryptfs/crypto.c                               |   6 +-
 fs/ecryptfs/keystore.c                             |   2 +-
 fs/ecryptfs/messaging.c                            |   1 +
 fs/ext4/balloc.c                                   |  14 ++-
 fs/ext4/ext4.h                                     |  39 +++++--
 fs/ext4/ialloc.c                                   |  23 +++--
 fs/ext4/inode.c                                    |  16 +--
 fs/ext4/mballoc.c                                  |  61 +++++++----
 fs/ext4/migrate.c                                  |  27 +++--
 fs/ext4/namei.c                                    |   1 +
 fs/ext4/resize.c                                   |  62 ++++++++---
 fs/ext4/super.c                                    | 113 ++++++++++++++-------
 fs/io_uring.c                                      |  47 ++++-----
 fs/jbd2/transaction.c                              |   8 +-
 include/acpi/acpixf.h                              |   1 +
 include/linux/intel-svm.h                          |   2 +-
 include/linux/irqdomain.h                          |   2 +-
 include/linux/libata.h                             |   1 +
 include/linux/tty.h                                |   2 +
 include/linux/usb/quirks.h                         |   3 +
 include/scsi/iscsi_proto.h                         |   1 -
 include/sound/rawmidi.h                            |   6 +-
 ipc/sem.c                                          |   6 +-
 kernel/bpf/offload.c                               |   2 +-
 kernel/irq/internals.h                             |   2 -
 kernel/irq/manage.c                                |  18 +---
 kernel/irq/proc.c                                  |  22 ++++
 kernel/sched/psi.c                                 |   3 +
 lib/stackdepot.c                                   |   8 +-
 mm/memcontrol.c                                    |   4 +-
 mm/mmap.c                                          |   4 -
 mm/mremap.c                                        |   1 -
 mm/sparse.c                                        |   2 +-
 mm/vmscan.c                                        |   9 +-
 net/netfilter/xt_hashlimit.c                       |  10 ++
 net/rxrpc/call_object.c                            |  22 +++-
 sound/core/seq/seq_clientmgr.c                     |   4 +-
 sound/core/seq/seq_queue.c                         |  29 ++++--
 sound/core/seq/seq_timer.c                         |  13 ++-
 sound/core/seq/seq_timer.h                         |   3 +-
 sound/hda/hdmi_chmap.c                             |   2 +-
 sound/pci/hda/hda_codec.c                          |   2 +-
 sound/pci/hda/hda_eld.c                            |   2 +-
 sound/pci/hda/hda_sysfs.c                          |   4 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/atmel/Kconfig                            |   4 +-
 sound/soc/atmel/Makefile                           |  10 +-
 sound/soc/fsl/fsl_sai.c                            |  22 +++-
 sound/soc/soc-dapm.c                               |   3 -
 sound/soc/sunxi/sun8i-codec.c                      |   3 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   5 +
 162 files changed, 1523 insertions(+), 716 deletions(-)


