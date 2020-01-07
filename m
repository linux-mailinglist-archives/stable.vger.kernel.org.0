Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF021334C7
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgAGU4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727258AbgAGU4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:56:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E32F820880;
        Tue,  7 Jan 2020 20:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430601;
        bh=8zdGaSEDzh2mw0rF5Ok4ZY/IP3okPezSJwRUjdT9v0A=;
        h=From:To:Cc:Subject:Date:From;
        b=fQHqlYXQhvvz6LsH0rY8W6FNETgzjjgelxzSrsz9OXmjWeD/R8lHI71F6DqYxqfKj
         MCcHjnCK3CEEfpVYpPetLx8ZRioGvLD9Y26xNCFReBOKMOx5W+mRALAObJBbMNWO2P
         1OkmoPvCPQ/1QPEOHRGqE/QNkM60jd/7ZbRIScEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/191] 5.4.9-stable review
Date:   Tue,  7 Jan 2020 21:52:00 +0100
Message-Id: <20200107205332.984228665@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.9-rc1
X-KernelTest-Deadline: 2020-01-09T20:53+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.9 release.
There are 191 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Jan 2020 20:44:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.9-rc1

Waiman Long <longman@redhat.com>
    mm/hugetlb: defer freeing of huge pages if in non-task context

Taehee Yoo <ap420073@gmail.com>
    hsr: fix a race condition in node list insertion and deletion

Taehee Yoo <ap420073@gmail.com>
    hsr: fix error handling routine in hsr_dev_finalize()

Taehee Yoo <ap420073@gmail.com>
    hsr: avoid debugfs warning message when module is remove

Eric Dumazet <edumazet@google.com>
    net: annotate lockless accesses to sk->sk_pacing_shift

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel/bts: Fix the use of page_private()

Ard Biesheuvel <ardb@kernel.org>
    efi: Don't attempt to map RCI2 config table if it doesn't exist

Julien Grall <julien.grall@arm.com>
    lib/ubsan: don't serialize UBSAN report

SeongJae Park <sjpark@amazon.de>
    xen/blkback: Avoid unmapping unmapped grant pages

Ilya Leoshkevich <iii@linux.ibm.com>
    mm/sparse.c: mark populate_section_memmap as __meminit

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/smp: fix physical to logical CPU map for SMT

Chris Mason <clm@fb.com>
    Btrfs: only associate the locked page with one async_chunk struct

Omar Sandoval <osandov@fb.com>
    btrfs: get rid of unique workqueue helper functions

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: ubifs_tnc_start_commit: Fix OOB in layout_in_gaps

Eric Dumazet <edumazet@google.com>
    net: add annotations on hh->hh_len lockless accesses

Darrick J. Wong <darrick.wong@oracle.com>
    xfs: periodically yield scrub threads to the scheduler

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/execlists: Fix annotation for decoupling virtual request

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Discard undersized packets

Masashi Honma <masashi.honma@gmail.com>
    ath9k_htc: Modify byte order for an error message

Al Viro <viro@zeniv.linux.org.uk>
    fix compat handling of FICLONERANGE, FIDEDUPERANGE and FS_IOC_FIEMAP

Deepa Dinamani <deepa.kernel@gmail.com>
    fs: cifs: Fix atime update check vs mtime

Paulo Alcantara (SUSE) <pc@cjr.nz>
    cifs: Fix lookup of root ses in DFS referral cache

Leo Yan <leo.yan@linaro.org>
    tty: serial: msm_serial: Fix lockup for sysrq and oops

Geert Uytterhoeven <geert+renesas@glider.be>
    phy: renesas: rcar-gen3-usb2: Use platform_get_irq_optional() for optional irq

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: meson: odroid-c2: Disable usb_otg bus to avoid power failed warning

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: clock: renesas: rcar-usb2-clock-sel: Fix typo in example

Navid Emamdoost <navid.emamdoost@gmail.com>
    media: usb: fix memory leak in af9005_identify_state

Stephan Gerhold <stephan@gerhold.net>
    regulator: ab8500: Remove AB8505 USB regulator

Colin Ian King <colin.king@canonical.com>
    media: flexcop-usb: ensure -EIO is returned on error condition

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxm-khadas-vim2: fix uart_A bluetooth node

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxl-s905x-khadas-vim: fix uart_A bluetooth node

Navid Emamdoost <navid.emamdoost@gmail.com>
    Bluetooth: Fix memory leak in hci_connect_le_scan

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: delete a stray unlock

Oliver Neukum <oneukum@suse.com>
    Bluetooth: btusb: fix PM leak in error case of setup

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/mm: Mark get_slice_psize() & slice_addr_is_low() as notrace

Chen-Yu Tsai <wens@csie.org>
    regulator: axp20x: Fix AXP22x ELDO2 regulator enable bitmask

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    spi: uniphier: Fix FIFO threshold

Axel Lin <axel.lin@ingics.com>
    regulator: bd70528: Remove .set_ramp_delay for bd70528_ldo_ops

Axel Lin <axel.lin@ingics.com>
    regulator: axp20x: Fix axp20x_set_ramp_delay

YueHaibing <yuehaibing@huawei.com>
    watchdog: tqmx86_wdt: Fix build error

Alexander Lobakin <alobakin@dlink.ru>
    net, sysctl: Fix compiler warning when only cBPF is present

Marco Oliverio <marco.oliverio@tanaza.com>
    netfilter: nf_queue: enqueue skbs with NULL dst

Michael Haener <michael.haener@siemens.com>
    platform/x86: pmc_atom: Add Siemens CONNECT X300 to critclk_systems DMI table

Omar Sandoval <osandov@fb.com>
    xfs: don't check for AG deadlock for realtime files in bunmapi

Wen Yang <wenyang@linux.alibaba.com>
    firmware: arm_scmi: Avoid double free in error flow

Paulo Alcantara (SUSE) <pc@cjr.nz>
    cifs: Fix potential softlockups while refreshing DFS cache

Frank Rowand <frank.rowand@sony.com>
    of: overlay: add_changeset_property() memory leak

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Remove incorrect PSI capability check

Adrian Hunter <adrian.hunter@intel.com>
    perf callchain: Fix segfault in thread__resolve_callchain_sample()

Yunfeng Ye <yeyunfeng@huawei.com>
    ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX to 0x100

Konstantin Khorenko <khorenko@virtuozzo.com>
    kernel/module.c: wakeup processes in module_wq on module unload

Eric Dumazet <edumazet@google.com>
    net/sched: annotate lockless accesses to qdisc->empty

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: i2c-hid: Reset ALPS touchpads on resume

Alastair D'Silva <alastair@d-silva.org>
    powerpc: Chunk calls to flush_dcache_range in arch_*_memory

Scott Mayhew <smayhew@redhat.com>
    nfsd4: fix up replay_matches_cache()

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    arm64: dts: qcom: msm8998-clamshell: Remove retention idle state

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    sunrpc: fix crash when cache_head become valid before update

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Check NULL governor in available_governors_show

Arnd Bergmann <arnd@arndb.de>
    drm/msm: include linux/sched/task.h

Vladimir Oltean <olteanv@gmail.com>
    spi: spi-fsl-dspi: Fix 16-bit word order in 32-bit XSPI mode

Wen Yang <wenyang@linux.alibaba.com>
    ftrace: Avoid potential division by zero in function profiler

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Revert support for execute-only user mappings

chenqiwu <chenqiwu@xiaomi.com>
    exit: panic before exit_mm() on global init exit

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix rpi release when deleting vport

Takashi Iwai <tiwai@suse.de>
    ALSA: firewire-motu: Correct a typo in the clock proc string

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Yet another missing check of non-cached buffer type

Colin Ian King <colin.king@canonical.com>
    ALSA: cs4236: fix error return comparison of an unsigned integer

Masahiro Yamada <masahiroy@kernel.org>
    gen_initramfs_list.sh: fix 'bad variable name' error

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: virt-dma: Fix access after free in vchan_complete()

John Johansen <john.johansen@canonical.com>
    apparmor: fix aa_xattrs_match() may sleep while holding a RCU lock

Navid Emamdoost <navid.emamdoost@gmail.com>
    mm/gup: fix memory leak in __gup_benchmark_ioctl

Jens Axboe <axboe@kernel.dk>
    io_uring: use current task creds instead of allocating a new one

Sven Schnelle <svens@linux.ibm.com>
    samples/trace_printk: Wait for IRQ work to finish

Sven Schnelle <svens@linux.ibm.com>
    tracing: Fix endianness bug in histogram trigger

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have the histogram compare functions convert to u64 first

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    tracing: Avoid memory leak in process_system_preds()

Prateek Sood <prsood@codeaurora.org>
    tracing: Fix lock inversion in trace_event_enable_tgid_record()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq/selftests: Fix: Namespace gettid() for compatibility with glibc 2.30

Zong Li <zong.li@sifive.com>
    riscv: ftrace: correct the condition logic in function graph tracer

Zong Li <zong.li@sifive.com>
    clocksource: riscv: add notrace to riscv_sched_clock

Russell King <rmk+kernel@armlinux.org.uk>
    gpiolib: fix up emulated open drain outputs

Max Filippov <jcmvbkbc@gmail.com>
    gpio: xtensa: fix driver build

Sascha Hauer <s.hauer@pengutronix.de>
    libata: Fix retrieving of active qcs

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: BCM7425 AHCI requires AHCI_HFLAG_DELAY_ENGINE

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Add missing clock management during recovery

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Fix AHCI resources management

Florian Fainelli <f.fainelli@gmail.com>
    ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix precision tracking for unbounded scalars

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: block: handle BLKGETZONESZ/BLKGETNRZONES

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: block: handle BLKREPORTZONE/BLKRESETZONE

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: block: handle Persistent Reservations

Ming Lei <ming.lei@redhat.com>
    block: fix splitting segments on boundary masks

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix infinite loop during nocow writeback due to race

Paul Cercueil <paul@crapouillou.net>
    dmaengine: dma-jz4780: Also break descriptor chains on JZ4725B

Lukas Wunner <lukas@wunner.de>
    dmaengine: Fix access to uninitialized dma_slave_caps

Sargun Dhillon <sargun@sargun.me>
    selftests/seccomp: Catch garbage on SECCOMP_IOCTL_NOTIF_RECV

Sargun Dhillon <sargun@sargun.me>
    samples/seccomp: Zero out members based on seccomp_notif_sizes

Sargun Dhillon <sargun@sargun.me>
    seccomp: Check that seccomp_notif is zeroed out by the user

Sargun Dhillon <sargun@sargun.me>
    selftests/seccomp: Zero out seccomp_notif

Amir Goldstein <amir73il@gmail.com>
    locks: print unsigned ino in /proc/locks

Arnd Bergmann <arnd@arndb.de>
    gcc-plugins: make it possible to disable CONFIG_GCC_PLUGINS again

Kees Cook <keescook@chromium.org>
    pstore/ram: Fix error-path memory leak in persistent_ram_new() callers

Aleksandr Yashkin <a.yashkin@inango-systems.com>
    pstore/ram: Write new dumps to start of recycled zones

Gang He <GHe@suse.com>
    ocfs2: fix the crash due to call ocfs2_get_dlm_debug once less

Ilya Dryomov <idryomov@gmail.com>
    mm/oom: fix pgtables units mismatch in Killed process message

Yang Shi <yang.shi@linux.alibaba.com>
    mm: move_pages: return valid node id in status if the page is already on the target node

Shakeel Butt <shakeelb@google.com>
    memcg: account security cred as well to kmemcg

Chanho Min <chanho.min@lge.com>
    mm/zsmalloc.c: fix the migrated zspage statistics.

David Hildenbrand <david@redhat.com>
    mm/memory_hotplug: shrink zones when offlining memory

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: check 'transmit_in_progress', not 'transmitting'

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: avoid decrementing transmit_queue_sz if it is 0

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: CEC 2.0-only bcast messages were ignored

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: pulse8-cec: fix lost cec_transmit_attempt_done() call

Paul Burton <paulburton@kernel.org>
    MIPS: Avoid VDSO ABI breakage due to global register variable

Alexander Lobakin <alobakin@dlink.ru>
    MIPS: BPF: eBPF JIT: check for MIPS ISA compliance in Kconfig

Paul Burton <paulburton@kernel.org>
    MIPS: BPF: Disable MIPS32 eBPF JIT

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu: add metrics table lock for vega20 (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu: add metrics table lock for navi (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu: add metrics table lock for arcturus (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu: add metrics table lock

Stefan Mavrodiev <stefan@olimex.com>
    drm/sun4i: hdmi: Remove duplicate cleanup calls

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add headset Mic no shutup for ALC283

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Apply sync-write workaround to old Intel platforms, too

Hui Wang <hui.wang@canonical.com>
    ALSA: usb-audio: set the interface format after resume on Dell WD19

Johan Hovold <johan@kernel.org>
    ALSA: usb-audio: fix set_format altsetting sanity check

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code

Johannes Weiner <hannes@cmpxchg.org>
    mm: drop mmap_sem before calling balance_dirty_pages() in write fault

Ming Lei <ming.lei@redhat.com>
    block: add bio_truncate to fix guard_bio_eod

Phil Sutter <phil@nwl.cc>
    netfilter: nft_tproxy: Fix port selector on Big Endian

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Downgrade error message for single-cmd fallback

Christian Brauner <christian.brauner@ubuntu.com>
    taskstats: fix data-race

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    shmem: pin the file in shmem_fault() if mmap_sem is dropped

Eric Dumazet <edumazet@google.com>
    tcp: fix data-race in tcp_recvmsg()

Jaroslav Kysela <perex@perex.cz>
    ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen

Takashi Iwai <tiwai@suse.de>
    PCI: Fix missing inline for pci_pr3_present()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda: Allow HDA to be runtime suspended when dGPU is not bound to a driver

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI: Add a helper to check Power Resource Requirements _PR3 existence

Chris Chiu <chiu@endlessm.com>
    ALSA: hda/realtek - Enable the bass speaker of ASUS UX431FLC

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add Bass Speaker and fixed dac for bass speaker

Andy Whitcroft <apw@canonical.com>
    PM / hibernate: memory_bm_find_bit(): Tighten node optimisation

Juergen Gross <jgross@suse.com>
    xen/balloon: fix ballooned page accounting without hotplug enabled

Paul Durrant <pdurrant@amazon.com>
    xen-blkback: prevent premature module unload

Maor Gottlieb <maorg@mellanox.com>
    IB/mlx5: Fix steering rule of drop and count

Parav Pandit <parav@mellanox.com>
    IB/mlx4: Follow mirror sequence of device add during device removal

Mark Zhang <markz@mellanox.com>
    RDMA/counter: Prevent auto-binding a QP which are not tracked with res

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Avoid SBD overflow condition in irq handler

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    md: raid1: check rdev before reference in raid1_sync_request func

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    raid5: need to set STRIPE_HANDLE for batch head

David Howells <dhowells@redhat.com>
    afs: Fix creation calls in the dynamic root to fail with EOPNOTSUPP

David Howells <dhowells@redhat.com>
    afs: Fix mountpoint parsing

Jens Axboe <axboe@kernel.dk>
    net: make socket read/write_iter() honor IOCB_NOWAIT

EJ Hsu <ejh@nvidia.com>
    usb: gadget: fix wrong endpoint desc

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/kms/nv50-: fix panel scaling

Hans de Goede <hdegoede@redhat.com>
    drm/nouveau: Fix drm-core using atomic code-paths on pre-nv50 hardware

Hans de Goede <hdegoede@redhat.com>
    drm/nouveau: Move the declaration of struct nouveau_conn_atom up a bit

Kay Friedrich <kay.friedrich@fau.de>
    staging/wlan-ng: add CRC32 dependency in Kconfig

Bo Wu <wubo40@huawei.com>
    scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: stop discovering if oob mode is disconnected

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: iscsi: qla4xxx: fix double free in probe

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Don't defer relogin unconditonally

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Send Notify ACK after N2N PLOGI

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Configure local loop for N2N target

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Don't call qlt_async_event twice

Roman Bolshakov <r.bolshakov@yadro.com>
    scsi: qla2xxx: Drop superfluous INIT_WORK of del_work

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Use explicit LOGO in target mode

Bo Wu <wubo40@huawei.com>
    scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func

Steve Wise <larrystevenwise@gmail.com>
    rxe: correctly calculate iCRC for unaligned payloads

Chuhong Yuan <hslester96@gmail.com>
    RDMA/cma: add missed unregister_pernet_subsys in init failure

David Howells <dhowells@redhat.com>
    afs: Fix SELinux setting security label on /afs

Marc Dionne <marc.dionne@auristor.com>
    afs: Fix afs_find_server lookups for ipv4 peers

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Don't fail devfreq_dev_release if not in list

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Set scaling_max_freq to max on OPP notifier error

Leonard Crestez <leonard.crestez@nxp.com>
    PM / devfreq: Fix devfreq_notifier_call returning errno

Geert Uytterhoeven <geert+renesas@glider.be>
    iio: adc: max9611: Fix too short conversion time delay

YueHaibing <yuehaibing@huawei.com>
    iio: st_accel: Fix unused variable warning

Keith Busch <kbusch@kernel.org>
    nvme/pci: Fix read queue count

Keith Busch <kbusch@kernel.org>
    nvme/pci: Fix write and poll queue types

Eric Yang <Eric.Yang2@amd.com>
    drm/amd/display: update dispclk and dppclk vco frequency

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Reset steer fifo before unblanking the stream

Leo (Hanghong) Ma <hanghong.ma@amd.com>
    drm/amd/display: Change the delay time before enabling FEC

David Galiffi <David.Galiffi@amd.com>
    drm/amd/display: Fixed kernel panic when booting with DP-to-HDMI dongle

Nikola Cornij <nikola.cornij@amd.com>
    drm/amd/display: Map DSC resources 1-to-1 if numbers of OPPs and DSCs are equal

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: add cache flush workaround to gfx8 emit_fence

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add header line for power profile on Arcturus

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: add check before enabling/disabling broadcast mode

James Smart <jsmart2021@gmail.com>
    nvme-fc: fix double-free scenarios on hw queues

James Smart <jsmart2021@gmail.com>
    nvme_fc: add module to ops template to allow module references

Stephan Gerhold <stephan@gerhold.net>
    drm/mcde: dsi: Fix invalid pointer dereference if panel cannot be found


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +-
 .../bindings/clock/renesas,rcar-usb2-clock-sel.txt |   2 +-
 Makefile                                           |   4 +-
 .../arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts |   4 +-
 .../dts/amlogic/meson-gxl-s905x-khadas-vim.dts     |   3 +
 .../boot/dts/amlogic/meson-gxm-khadas-vim2.dts     |   3 +
 arch/arm64/boot/dts/qcom/msm8998-clamshell.dtsi    |  37 ++++++
 arch/arm64/include/asm/pgtable-prot.h              |   5 +-
 arch/arm64/include/asm/pgtable.h                   |  10 +-
 arch/arm64/mm/fault.c                              |   2 +-
 arch/arm64/mm/mmu.c                                |   4 +-
 arch/ia64/mm/init.c                                |   4 +-
 arch/mips/Kconfig                                  |   2 +-
 arch/mips/include/asm/thread_info.h                |  20 +++-
 arch/mips/net/ebpf_jit.c                           |   2 +-
 arch/powerpc/mm/mem.c                              |  30 ++++-
 arch/powerpc/mm/slice.c                            |   4 +-
 arch/riscv/kernel/ftrace.c                         |   2 +-
 arch/s390/kernel/perf_cpum_sf.c                    |  22 +++-
 arch/s390/kernel/smp.c                             |  80 +++++++++----
 arch/s390/mm/init.c                                |   4 +-
 arch/sh/mm/init.c                                  |   4 +-
 arch/x86/events/intel/bts.c                        |  16 ++-
 arch/x86/mm/init_32.c                              |   4 +-
 arch/x86/mm/init_64.c                              |   4 +-
 block/bio.c                                        |  39 ++++++
 block/blk-merge.c                                  |  18 +--
 block/compat_ioctl.c                               |  13 ++
 drivers/acpi/sysfs.c                               |   6 +-
 drivers/ata/ahci_brcm.c                            | 133 +++++++++++++++------
 drivers/ata/libahci_platform.c                     |   6 +-
 drivers/ata/libata-core.c                          |  24 ++++
 drivers/ata/sata_fsl.c                             |   2 +-
 drivers/ata/sata_mv.c                              |   2 +-
 drivers/ata/sata_nv.c                              |   2 +-
 drivers/block/xen-blkback/blkback.c                |   2 +
 drivers/block/xen-blkback/xenbus.c                 |  10 ++
 drivers/bluetooth/btusb.c                          |   3 +-
 drivers/clocksource/timer-riscv.c                  |   2 +-
 drivers/devfreq/devfreq.c                          |  30 ++---
 drivers/dma/dma-jz4780.c                           |   3 +-
 drivers/dma/virt-dma.c                             |   3 +-
 drivers/firewire/net.c                             |   6 +-
 drivers/firmware/arm_scmi/bus.c                    |   8 +-
 drivers/firmware/efi/rci2-table.c                  |   3 +
 drivers/gpio/gpio-xtensa.c                         |   7 +-
 drivers/gpio/gpiolib.c                             |   8 ++
 drivers/gpu/drm/amd/amdgpu/df_v3_6.c               |  38 +++---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |  22 +++-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |   9 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |  13 +-
 .../amd/display/dc/dcn20/dcn20_stream_encoder.c    |  12 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   2 +-
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c         |   1 +
 drivers/gpu/drm/amd/powerplay/arcturus_ppt.c       |   8 ++
 drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h     |   1 +
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c         |   3 +
 drivers/gpu/drm/amd/powerplay/vega20_ppt.c         |   3 +
 drivers/gpu/drm/i915/gt/intel_lrc.c                |   3 +-
 drivers/gpu/drm/mcde/mcde_dsi.c                    |   6 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   1 +
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   6 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |  28 +++--
 drivers/gpu/drm/nouveau/nouveau_connector.h        | 116 +++++++++---------
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |   2 -
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  12 +-
 drivers/iio/accel/st_accel_core.c                  |   8 +-
 drivers/iio/adc/max9611.c                          |  16 ++-
 drivers/infiniband/core/cma.c                      |   1 +
 drivers/infiniband/core/counters.c                 |   3 +
 drivers/infiniband/hw/mlx4/main.c                  |   9 +-
 drivers/infiniband/hw/mlx5/main.c                  |  13 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |   2 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   6 +
 drivers/infiniband/sw/rxe/rxe_resp.c               |   7 ++
 drivers/iommu/intel-svm.c                          |   6 +-
 drivers/md/raid1.c                                 |   2 +-
 drivers/md/raid5.c                                 |   2 +-
 drivers/media/cec/cec-adap.c                       |  40 +++++--
 drivers/media/usb/b2c2/flexcop-usb.c               |   2 +-
 drivers/media/usb/dvb-usb/af9005.c                 |   5 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |  17 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  23 +++-
 drivers/nvme/host/fc.c                             |  32 ++++-
 drivers/nvme/host/pci.c                            |  14 +--
 drivers/nvme/target/fcloop.c                       |   1 +
 drivers/of/overlay.c                               |  37 +++---
 drivers/pci/pci.c                                  |  18 +++
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |   2 +-
 drivers/platform/x86/pmc_atom.c                    |   8 ++
 drivers/regulator/ab8500.c                         |  17 ---
 drivers/regulator/axp20x-regulator.c               |  11 +-
 drivers/regulator/bd70528-regulator.c              |   1 -
 drivers/scsi/libsas/sas_discover.c                 |  11 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |  15 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  88 +++++++++-----
 drivers/scsi/lpfc/lpfc_nvme.c                      |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   2 +
 drivers/scsi/qla2xxx/qla_def.h                     |   1 +
 drivers/scsi/qla2xxx/qla_init.c                    |  11 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |  22 +++-
 drivers/scsi/qla2xxx/qla_isr.c                     |   4 -
 drivers/scsi/qla2xxx/qla_mbx.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   1 +
 drivers/scsi/qla2xxx/qla_target.c                  |   3 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   1 +
 drivers/scsi/qla4xxx/ql4_os.c                      |   1 -
 drivers/scsi/scsi_transport_iscsi.c                |   7 ++
 drivers/spi/spi-fsl-dspi.c                         |  15 +--
 drivers/spi/spi-uniphier.c                         |  31 +++--
 drivers/staging/wlan-ng/Kconfig                    |   1 +
 drivers/tty/serial/msm_serial.c                    |  13 +-
 drivers/usb/gadget/function/f_ecm.c                |   6 +-
 drivers/usb/gadget/function/f_rndis.c              |   1 +
 drivers/watchdog/Kconfig                           |   1 +
 drivers/xen/balloon.c                              |   3 +-
 fs/afs/dynroot.c                                   |   3 +
 fs/afs/mntpt.c                                     |   6 +-
 fs/afs/server.c                                    |  21 ++--
 fs/afs/super.c                                     |   1 -
 fs/btrfs/async-thread.c                            |  58 ++-------
 fs/btrfs/async-thread.h                            |  33 +----
 fs/btrfs/block-group.c                             |   3 +-
 fs/btrfs/delayed-inode.c                           |   4 +-
 fs/btrfs/disk-io.c                                 |  34 ++----
 fs/btrfs/extent_io.c                               |   2 +-
 fs/btrfs/inode.c                                   |  67 ++++++-----
 fs/btrfs/ordered-data.c                            |   1 -
 fs/btrfs/qgroup.c                                  |   1 -
 fs/btrfs/raid56.c                                  |   5 +-
 fs/btrfs/reada.c                                   |   3 +-
 fs/btrfs/scrub.c                                   |  14 +--
 fs/btrfs/volumes.c                                 |   3 +-
 fs/buffer.c                                        |  25 +---
 fs/cifs/dfs_cache.c                                |   3 +-
 fs/cifs/inode.c                                    |   2 +-
 fs/cifs/smb2pdu.c                                  |  41 +++++--
 fs/compat_ioctl.c                                  |   3 +-
 fs/io_uring.c                                      |   4 +-
 fs/locks.c                                         |   2 +-
 fs/nfsd/nfs4state.c                                |  15 ++-
 fs/ocfs2/dlmglue.c                                 |   1 +
 fs/pstore/ram.c                                    |  13 ++
 fs/ubifs/tnc_commit.c                              |  34 ++++--
 fs/xfs/libxfs/xfs_bmap.c                           |   2 +-
 fs/xfs/scrub/common.h                              |   9 +-
 include/linux/ahci_platform.h                      |   2 +
 include/linux/bio.h                                |   1 +
 include/linux/dmaengine.h                          |   5 +-
 include/linux/libata.h                             |   1 +
 include/linux/memory_hotplug.h                     |   7 +-
 include/linux/nvme-fc-driver.h                     |   4 +
 include/linux/pci.h                                |   2 +
 include/linux/regulator/ab8500.h                   |   1 -
 include/net/neighbour.h                            |   2 +-
 include/net/sch_generic.h                          |   6 +-
 include/net/sock.h                                 |   4 +-
 kernel/bpf/verifier.c                              |  43 +++----
 kernel/cred.c                                      |   6 +-
 kernel/exit.c                                      |  12 +-
 kernel/module.c                                    |   2 +
 kernel/power/snapshot.c                            |   9 +-
 kernel/seccomp.c                                   |   7 ++
 kernel/taskstats.c                                 |  30 +++--
 kernel/trace/ftrace.c                              |   6 +-
 kernel/trace/trace.c                               |   8 ++
 kernel/trace/trace_events.c                        |   8 +-
 kernel/trace/trace_events_filter.c                 |   2 +-
 kernel/trace/trace_events_hist.c                   |  21 +++-
 kernel/trace/tracing_map.c                         |   4 +-
 lib/ubsan.c                                        |  64 ++++------
 mm/filemap.c                                       |  21 ----
 mm/gup_benchmark.c                                 |   8 +-
 mm/hugetlb.c                                       |  51 +++++++-
 mm/internal.h                                      |  21 ++++
 mm/memory.c                                        |  38 ++++--
 mm/memory_hotplug.c                                |  31 ++---
 mm/memremap.c                                      |   2 +-
 mm/migrate.c                                       |  23 +++-
 mm/mmap.c                                          |   6 -
 mm/oom_kill.c                                      |   2 +-
 mm/shmem.c                                         |  11 +-
 mm/sparse.c                                        |   4 +-
 mm/zsmalloc.c                                      |   5 +
 net/bluetooth/hci_conn.c                           |   4 +-
 net/bluetooth/l2cap_core.c                         |   4 +-
 net/core/dev.c                                     |   2 +-
 net/core/neighbour.c                               |   4 +-
 net/core/sock.c                                    |   2 +-
 net/core/sysctl_net_core.c                         |   2 +
 net/ethernet/eth.c                                 |   7 +-
 net/hsr/hsr_debugfs.c                              |  16 ++-
 net/hsr/hsr_device.c                               |  26 ++--
 net/hsr/hsr_framereg.c                             |  73 ++++++-----
 net/hsr/hsr_framereg.h                             |   6 +-
 net/hsr/hsr_main.c                                 |   2 +-
 net/hsr/hsr_main.h                                 |  16 ++-
 net/ipv4/tcp.c                                     |  14 +--
 net/ipv4/tcp_bbr.c                                 |   3 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/netfilter/nf_queue.c                           |   2 +-
 net/netfilter/nft_tproxy.c                         |   4 +-
 net/sched/sch_generic.c                            |   2 +-
 net/socket.c                                       |   4 +-
 net/sunrpc/cache.c                                 |   6 -
 samples/seccomp/user-trap.c                        |   4 +-
 samples/trace_printk/trace-printk.c                |   1 +
 scripts/gcc-plugins/Kconfig                        |   9 +-
 security/apparmor/apparmorfs.c                     |   2 +-
 security/apparmor/domain.c                         |  82 +++++++------
 security/apparmor/policy.c                         |   4 +-
 sound/core/pcm_native.c                            |   3 +-
 sound/firewire/motu/motu-proc.c                    |   2 +-
 sound/isa/cs423x/cs4236.c                          |   3 +-
 sound/pci/hda/hda_controller.c                     |   2 +-
 sound/pci/hda/hda_intel.c                          |  17 ++-
 sound/pci/hda/patch_realtek.c                      |  61 ++++++++--
 sound/pci/ice1712/ice1724.c                        |   9 +-
 sound/usb/card.h                                   |   1 +
 sound/usb/pcm.c                                    |  25 +++-
 sound/usb/quirks-table.h                           |   3 +-
 sound/usb/quirks.c                                 |  11 ++
 sound/usb/usbaudio.h                               |   3 +-
 tools/perf/util/machine.c                          |   2 +-
 tools/testing/selftests/rseq/param_test.c          |  18 +--
 tools/testing/selftests/seccomp/seccomp_bpf.c      |  15 ++-
 usr/gen_initramfs_list.sh                          |   2 +-
 228 files changed, 1774 insertions(+), 1039 deletions(-)


