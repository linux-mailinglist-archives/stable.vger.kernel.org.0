Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C6545C408
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351261AbhKXNpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353744AbhKXNoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:44:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF865632F5;
        Wed, 24 Nov 2021 12:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758764;
        bh=VcC1DpK/U2cfXiwrJMiso0myRhst7ZEk9njAPSmhip0=;
        h=From:To:Cc:Subject:Date:From;
        b=t0z3lBdnh7UU3C6Qp6I7n/LTQEzqlBFxtKulnpwF16obHX5In4OWeQxgCli2pMW8n
         9p4iDs8x9rbiB+nltubQocCW3co7Y3LVGUKXb4UPaAgr1B3n/kx03MKGOeY2EL0PTD
         nVyxam7wHW91TWobt9nFicZZG3jl3PIkeh2wcKDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.15 000/279] 5.15.5-rc1 review
Date:   Wed, 24 Nov 2021 12:54:47 +0100
Message-Id: <20211124115718.776172708@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.5-rc1
X-KernelTest-Deadline: 2021-11-26T11:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.5 release.
There are 279 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.5-rc1

Randy Dunlap <rdunlap@infradead.org>
    x86/Kconfig: Fix an unused variable error in dell-smm-hwmon

Eric Dumazet <edumazet@google.com>
    net: add and use skb_unclone_keeptruesize() helper

Josef Bacik <josef@toxicpanda.com>
    btrfs: update device path inode time instead of bd_inode

Josef Bacik <josef@toxicpanda.com>
    fs: export an inode_update_time helper

Leon Romanovsky <leon@kernel.org>
    ice: Delete always true check of PF pointer

Brett Creeley <brett.creeley@intel.com>
    ice: Fix VF true promiscuous mode

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: max-3421: Use driver data instead of maintaining a list of bound devices

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: fixup DMAEngine API

Takashi Iwai <tiwai@suse.de>
    ASoC: DAPM: Cover regression by kctl change notification fix

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix NULL-pointer dereference when hashtab allocation fails

Dmitrii Banshchikov <me@ubique.spb.ru>
    bpf: Forbid bpf_ktime_get_coarse_ns and bpf_timer_* in tracing progs

Leon Romanovsky <leon@kernel.org>
    RDMA/netlink: Add __maybe_unused to static inline in C file

Nadav Amit <namit@vmware.com>
    hugetlbfs: flush TLBs correctly after huge_pmd_unshare

Eric W. Biederman <ebiederm@xmission.com>
    signal: Replace force_fatal_sig with force_exit_sig when in doubt

Eric W. Biederman <ebiederm@xmission.com>
    signal: Don't always set SA_IMMUTABLE for forced signals

Eric W. Biederman <ebiederm@xmission.com>
    signal: Replace force_sigsegv(SIGSEGV) with force_fatal_sig(SIGSEGV)

Eric W. Biederman <ebiederm@xmission.com>
    signal/x86: In emulate_vsyscall force a signal instead of calling do_exit

Eric W. Biederman <ebiederm@xmission.com>
    signal/vm86_32: Properly send SIGSEGV when the vm86 state cannot be saved.

Eric W. Biederman <ebiederm@xmission.com>
    signal/sparc32: In setup_rt_frame and setup_fram use force_fatal_sig

Eric W. Biederman <ebiederm@xmission.com>
    signal/sparc32: Exit with a fatal signal when try_to_clear_window_buffer fails

Eric W. Biederman <ebiederm@xmission.com>
    signal/s390: Use force_sigsegv in default_trap_handler

Eric W. Biederman <ebiederm@xmission.com>
    signal/powerpc: On swapcontext failure force SIGSEGV

Eric W. Biederman <ebiederm@xmission.com>
    exit/syscall_user_dispatch: Send ordinary signals on failure

Eric W. Biederman <ebiederm@xmission.com>
    signal: Implement force_fatal_sig

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: avoid duplicate powergate/ungate setting

hongao <hongao@uniontech.com>
    drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix type1 DVI DP dual mode adapter heuristic for modern platforms

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Ensure max link params are always valid

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Ensure sink rate values are always valid

Jeremy Cline <jcline@redhat.com>
    drm/nouveau: clean up all clients on device removal

Jeremy Cline <jcline@redhat.com>
    drm/nouveau: use drm_dev_unplug() during device removal

Jeremy Cline <jcline@redhat.com>
    drm/nouveau: Add a dedicated mutex for the clients list

Anand K Mistry <amistry@google.com>
    drm/prime: Fix use after free in mmap with drm_gem_ttm_mmap

Johan Hovold <johan@kernel.org>
    drm/udl: fix control-message timeout

Matthew Brost <matthew.brost@intel.com>
    drm/i915/guc: Unwind context requests in reverse order

Matthew Brost <matthew.brost@intel.com>
    drm/i915/guc: Don't drop ce->guc_active.lock when unwinding context

Matthew Brost <matthew.brost@intel.com>
    drm/i915/guc: Workaround reset G2H is received after schedule done G2H

Matthew Brost <matthew.brost@intel.com>
    drm/i915/guc: Don't enable scheduling on a banned context, guc_id invalid, not registered

Matthew Brost <matthew.brost@intel.com>
    drm/i915/guc: Fix outstanding G2H accounting

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Limit max DSC target bpp for specific monitors

Alvin Lee <Alvin.Lee2@amd.com>
    drm/amd/display: Update swizzle mode enums

Felix Fietkau <nbd@nbd.name>
    mac80211: drop check for DONT_REORDER in __ieee80211_select_queue

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix radiotap header generation

Nguyen Dinh Phi <phind.uet@gmail.com>
    cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Sven Schnelle <svens@stackframe.org>
    parisc/sticon: fix reverse colors

Thomas Gleixner <tglx@linutronix.de>
    net: stmmac: Fix signed/unsigned wreckage

Christian Brauner <christian.brauner@ubuntu.com>
    fs: handle circular mappings correctly

Nikolay Borisov <nborisov@suse.com>
    btrfs: fix memory ordering between normal and ordered work functions

Boqun Feng <boqun.feng@gmail.com>
    Drivers: hv: balloon: Use VMBUS_RING_SIZE() wrapper for dm_ring_size

Meng Li <meng.li@windriver.com>
    net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform

Michael Walle <michael@walle.cc>
    spi: fix use-after-free of the add_lock mutex

Jan Kara <jack@suse.cz>
    udf: Fix crash after seekdir

Nicholas Piggin <npiggin@gmail.com>
    printk: restore flushing of NMI buffers on remote CPUs after NMI backtraces

Thomas Zimmermann <tzimmermann@suse.de>
    drm/cma-helper: Release non-coherent memory with dma_free_noncoherent()

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: nVMX: don't use vcpu->arch.efer when checking host state on nested state load

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Disallow COPY_ENC_CONTEXT_FROM if target has created vCPUs

Javier Martinez Canillas <javierm@redhat.com>
    fbdev: Prevent probing generic drivers if a FB is already registered

Alistair Delva <adelva@google.com>
    block: Check ADMIN before NICE for IOPRIO_CLASS_RT

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/dump: fix copying to user-space of swapped kdump oldmem

Baoquan He <bhe@redhat.com>
    s390/kexec: fix memory leak of ipl report buffer

Sven Schnelle <svens@linux.ibm.com>
    s390/vdso: filter out -mstack-guard and -mstack-size

Vasily Gorbik <gor@linux.ibm.com>
    s390/boot: simplify and fix kernel memory layout setup

Vasily Gorbik <gor@linux.ibm.com>
    s390/setup: avoid reserving memory above identity mapping

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    pinctrl: ralink: include 'ralink_regs.h' in 'pinctrl-mt7620.c'

Ewan D. Milne <emilne@redhat.com>
    scsi: qla2xxx: Fix mailbox direction flags in qla2xxx_get_adapter_id()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata: add missing ata_identify_page_supported() calls

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    ata: libata: improve ata_read_log_page() error message

Helge Deller <deller@gmx.de>
    Revert "parisc: Reduce sigreturn trampoline to 3 instructions"

Vandita Kulkarni <vandita.kulkarni@intel.com>
    Revert "drm/i915/tgl/dsi: Gate the ddi clocks after pll mapping"

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Fix pinned TLBs with CONFIG_STRICT_KERNEL_RWX

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Change IRQ domain to a tree domain

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/signal32: Fix sigset_t copy

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Fix get_attr of KVM_XEN_ATTR_TYPE_SHARED_INFO

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86/mmu: include EFER.LMA in extended mmu role

黄乐 <huangle1@jd.com>
    KVM: x86: Fix uninitialized eoi_exit_bitmap usage in vcpu_load_eoi_exitmap()

Tom Lendacky <thomas.lendacky@amd.com>
    KVM: x86: Assume a 64-bit hypercall for guests with protected state

Sean Christopherson <seanjc@google.com>
    x86/hyperv: Fix NULL deref in set_hv_tscchange_cb() if Hyper-V setup fails

Reinette Chatre <reinette.chatre@intel.com>
    x86/sgx: Fix free page accounting

Borislav Petkov <bp@suse.de>
    x86/boot: Pull up cmdline preparation and early param parsing

SeongJae Park <sj@kernel.org>
    mm/damon/dbgfs: fix missed use of damon_dbgfs_lock

SeongJae Park <sj@kernel.org>
    mm/damon/dbgfs: use '__GFP_NOWARN' for user-specified size buffer allocation

Ard Biesheuvel <ardb@kernel.org>
    kmap_local: don't assume kmap PTEs are linear arrays in memory

Mina Almasry <almasrymina@google.com>
    hugetlb, userfaultfd: fix reservation restore on userfaultfd error

Rustam Kovhaev <rkovhaev@gmail.com>
    mm: kmemleak: slob: respect SLAB_NOLEAKTRACE flag

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
    shm: extend forced shm destroy to support objects from several IPC nses

Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
    ipc: WARN if trying to remove ipc object which is absent

Tadeusz Struk <tadeusz.struk@linaro.org>
    tipc: check for null after calling kmemdup

Nathan Chancellor <nathan@kernel.org>
    hexagon: clean up timer-regs.h

Nathan Chancellor <nathan@kernel.org>
    hexagon: export raw I/O routines for modules

Geert Uytterhoeven <geert@linux-m68k.org>
    pstore/blk: Use "%lu" to format unsigned long

Kees Cook <keescook@chromium.org>
    Revert "mark pstore-blk as broken"

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    tun: fix bonding active backup with arp monitoring

Arnd Bergmann <arnd@arndb.de>
    dmaengine: remove debugfs #ifdef

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: fix missing put device in error path from blkg_conf_pref()

Heiko Carstens <hca@linux.ibm.com>
    s390/kexec: fix return code handling

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix IIO event constraints for Snowridge

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix IIO event constraints for Skylake Server

Alexander Antonov <alexander.antonov@linux.intel.com>
    perf/x86/intel/uncore: Fix filter_tid mask for CHA events on Skylake Server

Bjorn Andersson <bjorn.andersson@linaro.org>
    pinctrl: qcom: sm8350: Correct UFS and SDC offsets

Bjorn Andersson <bjorn.andersson@linaro.org>
    pinctrl: qcom: sdm845: Enable dual edge errata

Nicholas Piggin <npiggin@gmail.com>
    powerpc/pseries: Fix numa FORM2 parsing fallback code

Nicholas Piggin <npiggin@gmail.com>
    powerpc/pseries: rename numa_dist_table to form2_distances

Masahiro Yamada <masahiroy@kernel.org>
    powerpc: clean vdso32 and vdso64 directories

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Use GLOBAL_TOC for kvmppc_h_set_dabr/xdabr()

Andreas Schwab <schwab@suse.de>
    riscv: fix building external modules

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Fix removal of feature-sync-compare-and-swap feature detection

Sohaib Mohamed <sohaib.amhmd@gmail.com>
    perf bench: Fix two memory leaks detected with ASan

Dan Carpenter <dan.carpenter@oracle.com>
    ptp: ocp: Fix a couple NULL vs IS_ERR() checks

Jesse Brandeburg <jesse.brandeburg@intel.com>
    e100: fix device suspend/resume

Lin Ma <linma@zju.edu.cn>
    NFC: add NCI_UNREG flag to eliminate the race

Lin Ma <linma@zju.edu.cn>
    NFC: reorder the logic in nfc_{un,}register_device

Lin Ma <linma@zju.edu.cn>
    NFC: reorganize the functions in nci_request

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    i40e: Fix display error code in dmesg

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    i40e: Fix creation of first queue by omitting it if is not power of two

Karen Sornek <karen.sornek@intel.com>
    i40e: Fix warning message and call stack during rmmod i40e driver

Jack Wang <jinpu.wang@ionos.com>
    RDMA/mlx4: Do not fail the registration on port stats

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix ping is lost after configuring ADq on VF

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix changing previously set num_queue_pairs for PFs

Michal Maloszewski <michal.maloszewski@intel.com>
    i40e: Fix NULL ptr dereference on VSI filter sync

Eryk Rybak <eryk.roch.rybak@intel.com>
    i40e: Fix correct max_pkt_size on VF RX queue

Jonathan Davies <jonathan.davies@nutanix.com>
    net: virtio_net_hdr_to_skb: count transport header in UFO

Pavel Skripkin <paskripkin@gmail.com>
    net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove

Xin Long <lucien.xin@gmail.com>
    net: sched: act_mirred: drop dst for the direction from egress to ingress

Marcin Wojtas <mw@semihalf.com>
    net: mvmdio: fix compilation warning

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Fix another task management completion race

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Fix task management completion timeout race

Mike Christie <michael.christie@oracle.com>
    scsi: core: sysfs: Fix hang when device state is set via sysfs

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Improve SCSI abort handling

Raed Salem <raeds@nvidia.com>
    net/mlx5: E-Switch, return error if encap isn't supported

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Lag, update tracker when state change event received

Roi Dayan <roid@nvidia.com>
    net/mlx5e: CT, Fix multiple allocations and memleak of mod acts

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: E-Switch, rebuild lag only when needed

Neta Ostrovsky <netao@nvidia.com>
    net/mlx5: Update error handler for UCTX and UMEM

Valentine Fatiev <valentinef@nvidia.com>
    net/mlx5e: nullify cq->dbg pointer in mlx5_debug_cq_remove()

Paul Blakey <paulb@nvidia.com>
    net/mlx5: E-Switch, Fix resetting of encap mode when entering switchdev

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Wait for concurrent flow deletion during neigh/fib events

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: kTLS, Fix crash in RX resync flow

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Set send and receive CQ before forwarding to the driver

Colin Ian King <colin.i.king@googlemail.com>
    btrfs: make 1-bit bit-fields of scrub_page unsigned int

Cong Wang <cong.wang@bytedance.com>
    udp: Validate checksum in udp_read_sock()

Alex Williamson <alex.williamson@redhat.com>
    platform/x86: think-lmi: Abort probe on analyze failure

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    platform/x86: hp_accel: Fix an error handling path in 'lis3lv02d_probe()'

Randy Dunlap <rdunlap@infradead.org>
    gpio: rockchip: needs GENERIC_IRQ_CHIP to fix build errors

Randy Dunlap <rdunlap@infradead.org>
    mips: lantiq: add support for clk_get_parent()

Randy Dunlap <rdunlap@infradead.org>
    mips: bcm63xx: add support for clk_get_parent()

Colin Ian King <colin.i.king@googlemail.com>
    MIPS: generic/yamon-dt: fix uninitialized variable error

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix toctou on read-only map's constant scalar tracking

Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
    iavf: Restore VLAN filters after link down

Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
    iavf: Fix for setting queues to 0

Surabhi Boob <surabhi.boob@intel.com>
    iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset

Mitch Williams <mitch.a.williams@intel.com>
    iavf: validate pointers

Jacob Keller <jacob.e.keller@intel.com>
    iavf: prevent accidental free of filter structure

Piotr Marczak <piotr.marczak@intel.com>
    iavf: Fix failure to exit out from last all-multicast mode

Nicholas Nunley <nicholas.d.nunley@intel.com>
    iavf: don't clear a lock we don't hold

Nicholas Nunley <nicholas.d.nunley@intel.com>
    iavf: free q_vectors before queues in iavf_disable_vf

Nicholas Nunley <nicholas.d.nunley@intel.com>
    iavf: check for null in iavf_fix_features

Mateusz Palczewski <mateusz.palczewski@intel.com>
    iavf: Fix return of set the new channel count

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix exposure in nfsd4_decode_bitmap()

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Make sure the link_id is unique

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    sock: fix /proc/net/sockstat underflow in sk_clone_lock()

Xin Long <lucien.xin@gmail.com>
    tipc: only accept encrypted MSG_CRYPTO msgs

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    bnxt_en: reject indirect blk offload when hw-tc-offload is off

Pavel Skripkin <paskripkin@gmail.com>
    net: bnx2x: fix variable dereferenced before check

Li Zhijian <lizhijian@cn.fujitsu.com>
    selftests: gpio: fix gpio compiling error

Alex Elder <elder@linaro.org>
    net: ipa: disable HOLB drop when updating timer

Alex Elder <elder@linaro.org>
    net: ipa: HOLB register sometimes must be written twice

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix monitor_sdata RCU/locking assertions

Johannes Berg <johannes.berg@intel.com>
    nl80211: fix radio statistics in survey dump

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Add length protection to histogram string copies

Arjun Roy <arjunroy@google.com>
    tcp: Fix uninitialized access in skb frags array for Rx 0cp.

Konrad Dybcio <konrad.dybcio@somainline.org>
    net/ipa: ipa_resource: Fix wrong for loop range

Jakub Kicinski <kuba@kernel.org>
    selftests: net: switch to socat in the GSO GRE test

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    samples/bpf: Fix incorrect use of strlen in xdp_redirect_cpu

Alexander Lobakin <alexandr.lobakin@intel.com>
    samples/bpf: Fix summary per-sec stats in xdp_sample_user

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix inner map state pruning regression.

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    drm/nouveau: hdmigv100.c: fix corrupted HDMI Vendor InfoFrame

James Clark <james.clark@arm.com>
    perf tests: Remove bash construct from record+zstd_comp_decomp.sh

Sohaib Mohamed <sohaib.amhmd@gmail.com>
    perf bench futex: Fix memory leak of perf_cpu_map__new()

Ian Rogers <irogers@google.com>
    perf bpf: Avoid memory leak from perf_env__insert_btf()

Masami Hiramatsu <mhiramat@kernel.org>
    tracing/histogram: Do not copy the fixed-size char array field over the field size

Laibin Qiu <qiulaibin@huawei.com>
    blkcg: Remove extra blkcg_bio_issue_init

Like Xu <likexu@tencent.com>
    perf/x86/vlbr: Add c->flags to vlbr event constraints

Mathias Krause <minipli@grsecurity.net>
    sched/fair: Prevent dead task groups from regaining cfs_rq's

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/core: Mitigate race cpus_share_cache()/update_top_cache_domain()

Randy Dunlap <rdunlap@infradead.org>
    MIPS: boot/compressed/: add __bswapdi2() to target for ZSTD decompression

Randy Dunlap <rdunlap@infradead.org>
    mips: BCM63XX: ensure that CPU_SUPPORTS_32BIT_KERNEL is set

Quentin Perret <qperret@google.com>
    KVM: arm64: Fix host stage-2 finalization

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gcc-msm8996: Drop (again) gcc_aggre1_pnoc_ahb_clk

Joel Stanley <joel@jms.id.au>
    clk/ast2600: Fix soc revision for AHB

Paul Cercueil <paul@crapouillou.net>
    clk: ingenic: Fix bugs with divided dividers

Chao Yu <chao@kernel.org>
    f2fs: fix incorrect return value in f2fs_sanity_check_ckpt()

Hyeong-Jun Kim <hj514.kim@samsung.com>
    f2fs: compress: disallow disabling compress on non-empty compressed file

Randy Dunlap <rdunlap@infradead.org>
    sh: define __BIG_ENDIAN for math-emu

Randy Dunlap <rdunlap@infradead.org>
    sh: math-emu: drop unused functions

Randy Dunlap <rdunlap@infradead.org>
    sh: fix kconfig unmet dependency warning for FRAME_POINTER

Chao Yu <chao@kernel.org>
    f2fs: fix wrong condition to trigger background checkpoint correctly

Keoseong Park <keosung.park@samsung.com>
    f2fs: fix to use WHINT_MODE

Gao Xiang <hsiangkao@linux.alibaba.com>
    f2fs: fix up f2fs_lookup tracepoints

Lu Wei <luwei32@huawei.com>
    maple: fix wrong return value of maple_bus_init().

Nick Desaulniers <ndesaulniers@google.com>
    sh: check return code of request_irq

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Fix Oops with STRICT_KERNEL_RWX without DEBUG_RODATA_TEST

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/dcr: Use cmplwi instead of 3-argument cmpli

Sven Peter <sven@svenpeter.dev>
    iommu/dart: Initialize DART_STREAMS_ENABLE

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: sama7g5: remove prescaler part of master clock

Chengfeng Ye <cyeaa@connect.ust.hk>
    ALSA: usb-audio: fix null pointer dereference on pointer cs_desc

Chengfeng Ye <cyeaa@connect.ust.hk>
    ALSA: gus: fix null pointer dereference on pointer block

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: Fix node name of rpm-msg-ram device nodes

David Heidelberg <david@ixit.cz>
    ARM: dts: qcom: fix memory and mdio nodes naming for RB3011

Anatolij Gustschin <agust@denx.de>
    powerpc/5200: dts: fix memory node unit name

Dmitry Osipenko <digetx@gmail.com>
    memory: tegra20-emc: Add runtime dependency on devfreq governor module

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Allow fabric node recovery if recovery is in progress before devloss

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix link down processing to address NULL pointer dereference

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix use-after-free in lpfc_unreg_rpi() routine

wangyugui <wangyugui@e16-tech.com>
    RDMA/core: Use kvzalloc when allocating the struct ib_port

Teng Qi <starmiku1207184332@gmail.com>
    iio: imu: st_lsm6dsx: Avoid potential array overflow in st_lsm6dsx_set_odr()

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix alua_tg_pt_gps_count tracking

Mike Christie <michael.christie@oracle.com>
    scsi: target: Fix ordered tag handling

Ye Bin <yebin10@huawei.com>
    scsi: scsi_debug: Fix out-of-bound read in resp_report_tgtpgs()

Ye Bin <yebin10@huawei.com>
    scsi: scsi_debug: Fix out-of-bound read in resp_readcap16()

Bart Van Assche <bvanassche@acm.org>
    MIPS: sni: Fix the build

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    iommu/vt-d: Do not falsely log intel_iommu is unsupported kernel option

Randy Dunlap <rdunlap@infradead.org>
    ALSA: ISA: not for M68K

Li Yang <leoyang.li@nxp.com>
    ARM: dts: ls1021a-tsn: use generic "jedec,spi-nor" compatible for flash

Li Yang <leoyang.li@nxp.com>
    ARM: dts: ls1021a: move thermal-zones node out of soc/

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5682: fix a little pop while playback

Yang Yingliang <yangyingliang@huawei.com>
    usb: host: ohci-tmio: check return value after calling platform_get_resource()

Roger Quadros <rogerq@kernel.org>
    ARM: dts: omap: fix gpmc,mux-add-data type

William Overton <willovertonuk@gmail.com>
    ALSA: usb-audio: Add support for the Pioneer DJM 750MK2 Mixer/Soundcard

José Expósito <jose.exposito89@gmail.com>
    HID: multitouch: disable sticky fingers for UPERFECT Y

Dmitry Osipenko <digetx@gmail.com>
    cpuidle: tegra: Check whether PMC is ready

Luis Chamberlain <mcgrof@kernel.org>
    firmware_loader: fix pre-allocated buf built-in firmware use

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add missing quirk for Dell SKU 0A45

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: soc-acpi: add missing quirk for TGL SDCA single amp

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: intel-dsp-config: add quirk for APL/GLK/TGL devices based on ES8336 codec

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx8mm-kontron: Fix reset delays for ethernet PHY

Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
    scsi: smartpqi: Add controller handshake during kdump

Guo Zhi <qtxuning1999@sjtu.edu.cn>
    scsi: advansys: Fix kernel pointer leak

Hans de Goede <hdegoede@redhat.com>
    ASoC: nau8824: Add DMI quirk mechanism for active-high jack-detect

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5651: Use IRQF_NO_AUTOEN when requesting the IRQ

Hans de Goede <hdegoede@redhat.com>
    ASoC: es8316: Use IRQF_NO_AUTOEN when requesting the IRQ

Stefan Riedmueller <s.riedmueller@phytec.de>
    clk: imx: imx6ul: Move csi_sel mux to correct base register

Geraldo Nascimento <geraldogabriel@gmail.com>
    ALSA: usb-audio: disable implicit feedback sync for Behringer UFX1204 and UFX1604

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: core: Fix scsi_mode_sense() buffer length handling

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: fix potential locking issue

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Separate HW and SW l/rkeys

Kuldeep Singh <kuldeep.singh@nxp.com>
    arm64: dts: ls1012a: Add serial alias for ls1012a-rdb

Michael Walle <michael@walle.cc>
    arm64: dts: freescale: fix arm,sp805 compatible string

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Add unit name for /soc node

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: sdm845: Fix qcom,controlled-remotely property

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: ipq8074: Fix qcom,controlled-remotely property

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: ipq6018: Fix qcom,controlled-remotely property

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    arm64: dts: qcom: msm8998: Fix CPU/L2 idle state latency and residency

Christian Lamparter <chunkeey@gmail.com>
    ARM: BCM53016: Specify switch ports for Meraki MR32

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: remove a third possible deadlock

Hans de Goede <hdegoede@redhat.com>
    staging: rtl8723bs: remove a second possible deadlock

Fabio Aiuto <fabioaiuto83@gmail.com>
    staging: rtl8723bs: remove possible deadlock when disconnect (v2)

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Skomer regulator fixes

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Remove WARN_ON in tps6598x_block_read

Yang Yingliang <yangyingliang@huawei.com>
    usb: musb: tusb6010: check return value after calling platform_get_resource()

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Use context lost quirk for otg

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Add quirk handling for reinit on context lost

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Check if the vlan is valid before reporting

Michael Walle <michael@walle.cc>
    arm64: dts: hisilicon: fix arm,sp805 compatible string

Matthias Brugger <mbrugger@suse.com>
    arm64: dts: rockchip: Disable CDN DP on Pinebook Pro

Bixuan Cui <cuibixuan@huawei.com>
    ASoC: mediatek: mt8195: Add missing of_node_put()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()

Ajish Koshy <Ajish.Koshy@microchip.com>
    scsi: pm80xx: Fix memory leak during rmmod

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: broadcom: bcm4908: Move reboot syscon out of bus

Matthew Hagan <mnhagan88@gmail.com>
    ARM: dts: NSP: Fix mpcore, mmc node names

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Fix MDIO mux binding

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: Fix nodes names

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: ensure IRQ is ready before enabling it

Maxime Ripard <maxime@cerno.tech>
    arm64: dts: allwinner: a100: Fix thermal zone node name

Maxime Ripard <maxime@cerno.tech>
    arm64: dts: allwinner: h5: Fix GPU thermal zone node name

Maxime Ripard <maxime@cerno.tech>
    ARM: dts: sunxi: Fix OPPs node name

Samuel Holland <samuel@sholland.org>
    clk: sunxi-ng: Unregister clocks/resets when unbinding

Michal Simek <michal.simek@xilinx.com>
    arm64: zynqmp: Fix serial compatible string

Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
    arm64: zynqmp: Do not duplicate flash partition label property


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/kernel/process.c                          |   2 +-
 arch/arm/Kconfig                                   |   1 +
 arch/arm/boot/dts/bcm-nsp.dtsi                     |   4 +-
 arch/arm/boot/dts/bcm47094-linksys-panamera.dts    |   2 +-
 arch/arm/boot/dts/bcm53016-meraki-mr32.dts         |  22 +++
 arch/arm/boot/dts/bcm5301x.dtsi                    |  10 +-
 arch/arm/boot/dts/ls1021a-tsn.dts                  |   2 +-
 arch/arm/boot/dts/ls1021a.dtsi                     |  66 +++----
 arch/arm/boot/dts/omap-gpmc-smsc9221.dtsi          |   2 +-
 arch/arm/boot/dts/omap3-overo-tobiduo-common.dtsi  |   2 +-
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts          |   6 +-
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts     |   8 +-
 arch/arm/boot/dts/sun8i-a33.dtsi                   |   4 +-
 arch/arm/boot/dts/sun8i-a83t.dtsi                  |   4 +-
 arch/arm/boot/dts/sun8i-h3.dtsi                    |   4 +-
 arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi     |   6 +-
 .../boot/dts/allwinner/sun50i-a64-cpu-opp.dtsi     |   2 +-
 .../boot/dts/allwinner/sun50i-h5-cpu-opp.dtsi      |   2 +-
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi       |   2 +-
 .../boot/dts/allwinner/sun50i-h6-cpu-opp.dtsi      |   2 +-
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi  |  12 +-
 arch/arm64/boot/dts/freescale/fsl-ls1012a-rdb.dts  |   1 +
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |  16 +-
 arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     |  16 +-
 .../boot/dts/freescale/imx8mm-kontron-n801x-s.dts  |   4 +-
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi          |   4 +-
 arch/arm64/boot/dts/hisilicon/hi6220.dtsi          |   2 +-
 arch/arm64/boot/dts/qcom/ipq6018.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   4 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  22 ++-
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |   2 +-
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts      |   4 -
 .../boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts    |   4 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |   4 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |  14 +-
 arch/hexagon/include/asm/timer-regs.h              |  26 ---
 arch/hexagon/include/asm/timex.h                   |   3 +-
 arch/hexagon/kernel/time.c                         |  12 +-
 arch/hexagon/lib/io.c                              |   4 +
 arch/m68k/kernel/traps.c                           |   2 +-
 arch/mips/Kconfig                                  |   3 +
 arch/mips/bcm63xx/clk.c                            |   6 +
 arch/mips/boot/compressed/Makefile                 |   6 +
 arch/mips/generic/yamon-dt.c                       |   2 +-
 arch/mips/lantiq/clk.c                             |   6 +
 arch/mips/sni/time.c                               |   4 +-
 arch/parisc/include/asm/rt_sigframe.h              |   2 +-
 arch/parisc/kernel/signal.c                        |  13 +-
 arch/parisc/kernel/signal32.h                      |   2 +-
 arch/powerpc/boot/dts/charon.dts                   |   2 +-
 arch/powerpc/boot/dts/digsy_mtc.dts                |   2 +-
 arch/powerpc/boot/dts/lite5200.dts                 |   2 +-
 arch/powerpc/boot/dts/lite5200b.dts                |   2 +-
 arch/powerpc/boot/dts/media5200.dts                |   2 +-
 arch/powerpc/boot/dts/mpc5200b.dtsi                |   2 +-
 arch/powerpc/boot/dts/o2d.dts                      |   2 +-
 arch/powerpc/boot/dts/o2d.dtsi                     |   2 +-
 arch/powerpc/boot/dts/o2dnt2.dts                   |   2 +-
 arch/powerpc/boot/dts/o3dnt.dts                    |   2 +-
 arch/powerpc/boot/dts/pcm032.dts                   |   2 +-
 arch/powerpc/boot/dts/tqm5200.dts                  |   2 +-
 arch/powerpc/kernel/Makefile                       |   3 +
 arch/powerpc/kernel/head_8xx.S                     |  13 +-
 arch/powerpc/kernel/signal.h                       |  10 +-
 arch/powerpc/kernel/signal_32.c                    |   6 +-
 arch/powerpc/kernel/signal_64.c                    |   9 +-
 arch/powerpc/kernel/watchdog.c                     |   6 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   4 +-
 arch/powerpc/mm/numa.c                             |  44 +++--
 arch/powerpc/sysdev/dcr-low.S                      |   2 +-
 arch/powerpc/sysdev/xive/Kconfig                   |   1 -
 arch/powerpc/sysdev/xive/common.c                  |   3 +-
 arch/riscv/Makefile                                |   2 +
 arch/s390/Kconfig                                  |   2 +-
 arch/s390/Makefile                                 |  10 +-
 arch/s390/boot/startup.c                           |  88 ++++------
 arch/s390/include/asm/kexec.h                      |   6 +
 arch/s390/kernel/crash_dump.c                      |   4 +-
 arch/s390/kernel/ipl.c                             |   3 +-
 arch/s390/kernel/machine_kexec_file.c              |  18 +-
 arch/s390/kernel/setup.c                           |  10 +-
 arch/s390/kernel/traps.c                           |   2 +-
 arch/s390/kernel/vdso64/Makefile                   |   5 +-
 arch/sh/Kconfig.debug                              |   1 +
 arch/sh/include/asm/sfp-machine.h                  |   8 +
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                 |   5 +-
 arch/sh/math-emu/math.c                            | 103 -----------
 arch/sparc/kernel/signal_32.c                      |   4 +-
 arch/sparc/kernel/windows.c                        |   6 +-
 arch/um/kernel/trap.c                              |   2 +-
 arch/x86/Kconfig                                   |   3 +-
 arch/x86/entry/vsyscall/vsyscall_64.c              |   3 +-
 arch/x86/events/intel/core.c                       |   4 +-
 arch/x86/events/intel/uncore_snbep.c               |  12 ++
 arch/x86/hyperv/hv_init.c                          |   3 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kernel/cpu/sgx/main.c                     |  12 +-
 arch/x86/kernel/setup.c                            |  66 ++++---
 arch/x86/kernel/vm86_32.c                          |   4 +-
 arch/x86/kvm/hyperv.c                              |   4 +-
 arch/x86/kvm/mmu/mmu.c                             |   1 +
 arch/x86/kvm/svm/sev.c                             |   7 +-
 arch/x86/kvm/vmx/nested.c                          |  22 ++-
 arch/x86/kvm/x86.c                                 |  10 +-
 arch/x86/kvm/x86.h                                 |  12 ++
 arch/x86/kvm/xen.c                                 |   4 +-
 block/blk-cgroup.c                                 |   9 +-
 block/blk-core.c                                   |   4 +-
 block/ioprio.c                                     |   9 +-
 drivers/ata/libata-core.c                          |  11 +-
 drivers/base/firmware_loader/main.c                |  13 +-
 drivers/bus/ti-sysc.c                              | 110 +++++++++++-
 drivers/clk/at91/sama7g5.c                         |  11 +-
 drivers/clk/clk-ast2600.c                          |  12 +-
 drivers/clk/imx/clk-imx6ul.c                       |   2 +-
 drivers/clk/ingenic/cgu.c                          |   6 +-
 drivers/clk/qcom/gcc-msm8996.c                     |  15 --
 drivers/clk/sunxi-ng/ccu-sun4i-a10.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a100-r.c           |   2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a100.c             |   2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |   2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c             |   2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c             |   4 +-
 drivers/clk/sunxi-ng/ccu-sun5i.c                   |   2 +-
 drivers/clk/sunxi-ng/ccu-sun6i-a31.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-a23.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-a33.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-a83t.c              |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-de2.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-h3.c                |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-r.c                 |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-r40.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-sun9i-a80-de.c            |   3 +-
 drivers/clk/sunxi-ng/ccu-sun9i-a80-usb.c           |   3 +-
 drivers/clk/sunxi-ng/ccu-sun9i-a80.c               |   2 +-
 drivers/clk/sunxi-ng/ccu-suniv-f1c100s.c           |   2 +-
 drivers/clk/sunxi-ng/ccu_common.c                  |  89 ++++++++--
 drivers/clk/sunxi-ng/ccu_common.h                  |   6 +-
 drivers/cpuidle/cpuidle-tegra.c                    |   3 +
 drivers/dma/xilinx/xilinx_dpdma.c                  |  15 +-
 drivers/gpio/Kconfig                               |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   3 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  35 ++++
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   4 +-
 .../drm/amd/display/dc/dml/display_mode_enums.h    |   4 +-
 drivers/gpu/drm/amd/include/amd_shared.h           |   3 +-
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |  10 ++
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h            |   8 +
 drivers/gpu/drm/drm_gem_cma_helper.c               |   9 +-
 drivers/gpu/drm/drm_prime.c                        |   6 +-
 drivers/gpu/drm/i915/display/icl_dsi.c             |  10 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |  85 ++++++---
 drivers/gpu/drm/i915/display/intel_dp.c            |  29 +++-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  | 154 ++++++++++-------
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  42 ++++-
 drivers/gpu/drm/nouveau/nouveau_drv.h              |   5 +
 .../gpu/drm/nouveau/nvkm/engine/disp/hdmigv100.c   |   1 -
 drivers/gpu/drm/udl/udl_connector.c                |   2 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-multitouch.c                       |  13 ++
 drivers/hv/hv_balloon.c                            |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   6 +-
 drivers/infiniband/core/sysfs.c                    |   4 +-
 drivers/infiniband/core/verbs.c                    |   3 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  12 +-
 drivers/infiniband/hw/mlx4/main.c                  |  18 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |   1 +
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  69 ++++++--
 drivers/infiniband/sw/rxe/rxe_mw.c                 |  30 ++--
 drivers/infiniband/sw/rxe/rxe_req.c                |  14 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |  18 +-
 drivers/iommu/apple-dart.c                         |   5 +
 drivers/iommu/intel/iommu.c                        |   6 +-
 drivers/memory/tegra/tegra20-emc.c                 |   1 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h   |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   4 +-
 drivers/net/ethernet/intel/e100.c                  |  18 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 160 +++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 121 +++++--------
 drivers/net/ethernet/intel/iavf/iavf.h             |   1 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  30 +++-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  55 ++++--
 drivers/net/ethernet/intel/ice/ice.h               |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 -
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  78 ++++-----
 drivers/net/ethernet/marvell/mvmdio.c              |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  26 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   8 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  23 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  21 ++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  28 ++-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  24 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  23 ++-
 drivers/net/ipa/ipa_endpoint.c                     |   5 +
 drivers/net/ipa/ipa_resource.c                     |   2 +-
 drivers/net/tun.c                                  |   5 +
 drivers/pinctrl/qcom/pinctrl-sdm845.c              |   1 +
 drivers/pinctrl/qcom/pinctrl-sm8350.c              |   8 +-
 drivers/pinctrl/ralink/pinctrl-mt7620.c            |   1 +
 drivers/platform/x86/hp_accel.c                    |   2 +
 drivers/platform/x86/think-lmi.c                   |  13 +-
 drivers/platform/x86/think-lmi.h                   |   1 -
 drivers/ptp/ptp_ocp.c                              |   9 +-
 drivers/scsi/advansys.c                            |   4 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   2 +
 drivers/scsi/lpfc/lpfc_disc.h                      |  12 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   7 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   | 112 +++++++++++-
 drivers/scsi/lpfc/lpfc_init.c                      |  12 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  10 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  15 +-
 drivers/scsi/pm8001/pm8001_init.c                  |  11 ++
 drivers/scsi/pm8001/pm8001_sas.h                   |   1 +
 drivers/scsi/qla2xxx/qla_mbx.c                     |   6 +-
 drivers/scsi/scsi_debug.c                          |  11 +-
 drivers/scsi/scsi_lib.c                            |  25 +--
 drivers/scsi/scsi_sysfs.c                          |  30 ++--
 drivers/scsi/smartpqi/smartpqi_init.c              |  41 ++++-
 drivers/scsi/smartpqi/smartpqi_sis.c               |  51 ++++++
 drivers/scsi/smartpqi/smartpqi_sis.h               |   1 +
 drivers/scsi/ufs/ufshcd.c                          |   9 +-
 drivers/sh/maple/maple.c                           |   5 +-
 drivers/spi/spi.c                                  |  12 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |  12 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |  11 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c          |  10 +-
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c       |  33 ++--
 drivers/staging/rtl8723bs/core/rtw_xmit.c          |  16 +-
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c     |   2 -
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c     |   2 -
 drivers/staging/wfx/bus_sdio.c                     |  17 +-
 drivers/target/target_core_alua.c                  |   1 -
 drivers/target/target_core_device.c                |   2 +
 drivers/target/target_core_internal.h              |   1 +
 drivers/target/target_core_transport.c             |  76 ++++++---
 drivers/tty/tty_buffer.c                           |   3 +
 drivers/usb/host/max3421-hcd.c                     |  25 +--
 drivers/usb/host/ohci-tmio.c                       |   2 +-
 drivers/usb/musb/tusb6010.c                        |   5 +
 drivers/usb/typec/tipd/core.c                      |   2 +-
 drivers/video/console/sticon.c                     |  12 +-
 drivers/video/fbdev/efifb.c                        |  11 ++
 drivers/video/fbdev/simplefb.c                     |  11 ++
 fs/attr.c                                          |   4 +-
 fs/btrfs/async-thread.c                            |  14 ++
 fs/btrfs/scrub.c                                   |   4 +-
 fs/btrfs/volumes.c                                 |  21 ++-
 fs/exec.c                                          |   2 +-
 fs/f2fs/f2fs.h                                     |   3 +-
 fs/f2fs/segment.c                                  |   2 +-
 fs/f2fs/super.c                                    |   4 +-
 fs/inode.c                                         |   7 +-
 fs/nfsd/nfs4xdr.c                                  |   7 +-
 fs/pstore/Kconfig                                  |   1 -
 fs/pstore/blk.c                                    |   2 +-
 fs/udf/dir.c                                       |  32 +++-
 fs/udf/namei.c                                     |   3 +
 fs/udf/super.c                                     |   2 +
 include/linux/bpf.h                                |   3 +-
 include/linux/dmaengine.h                          |   2 -
 include/linux/fs.h                                 |   2 +
 include/linux/ipc_namespace.h                      |  15 ++
 include/linux/mlx5/eswitch.h                       |   4 +-
 include/linux/platform_data/ti-sysc.h              |   1 +
 include/linux/printk.h                             |   4 +
 include/linux/sched/signal.h                       |   2 +
 include/linux/sched/task.h                         |   2 +-
 include/linux/skbuff.h                             |  16 ++
 include/linux/trace_events.h                       |   2 +-
 include/linux/virtio_net.h                         |   7 +-
 include/net/nfc/nci_core.h                         |   1 +
 include/rdma/rdma_netlink.h                        |   2 +-
 include/target/target_core_base.h                  |   6 +-
 include/trace/events/f2fs.h                        |  12 +-
 ipc/shm.c                                          | 189 ++++++++++++++++-----
 ipc/util.c                                         |   6 +-
 kernel/bpf/cgroup.c                                |   2 +
 kernel/bpf/helpers.c                               |   2 -
 kernel/bpf/syscall.c                               |  57 ++++---
 kernel/bpf/verifier.c                              |  27 ++-
 kernel/entry/syscall_user_dispatch.c               |  12 +-
 kernel/printk/printk.c                             |   5 +
 kernel/sched/autogroup.c                           |   2 +-
 kernel/sched/core.c                                |  47 ++++-
 kernel/sched/fair.c                                |   4 +-
 kernel/sched/rt.c                                  |  12 +-
 kernel/sched/sched.h                               |   3 +-
 kernel/signal.c                                    |  60 +++++--
 kernel/trace/bpf_trace.c                           |   2 -
 kernel/trace/trace_events_hist.c                   |  14 +-
 lib/nmi_backtrace.c                                |   6 +
 mm/Kconfig                                         |   3 +
 mm/damon/dbgfs.c                                   |  15 +-
 mm/highmem.c                                       |  32 ++--
 mm/hugetlb.c                                       |  30 +++-
 mm/slab.h                                          |   2 +-
 net/core/filter.c                                  |   6 +
 net/core/skbuff.c                                  |  14 +-
 net/core/sock.c                                    |   6 +-
 net/ipv4/bpf_tcp_ca.c                              |   2 +
 net/ipv4/tcp.c                                     |   3 +
 net/ipv4/tcp_output.c                              |   6 +-
 net/ipv4/udp.c                                     |  11 ++
 net/mac80211/cfg.c                                 |  12 +-
 net/mac80211/iface.c                               |   4 +-
 net/mac80211/rx.c                                  |   2 +-
 net/mac80211/util.c                                |   7 +-
 net/mac80211/wme.c                                 |   3 +-
 net/nfc/core.c                                     |  32 ++--
 net/nfc/nci/core.c                                 |  30 +++-
 net/sched/act_mirred.c                             |  11 +-
 net/smc/smc_core.c                                 |   3 +-
 net/tipc/crypto.c                                  |   4 +
 net/tipc/link.c                                    |   7 +-
 net/wireless/nl80211.c                             |  34 ++--
 net/wireless/nl80211.h                             |   6 +-
 net/wireless/util.c                                |   1 +
 samples/bpf/xdp_redirect_cpu_user.c                |   5 +-
 samples/bpf/xdp_sample_user.c                      |  28 +--
 security/selinux/ss/hashtab.c                      |  17 +-
 sound/core/Makefile                                |   2 +
 sound/hda/intel-dsp-config.c                       |  22 ++-
 sound/isa/Kconfig                                  |   2 +-
 sound/isa/gus/gus_dma.c                            |   2 +
 sound/pci/Kconfig                                  |   1 +
 sound/soc/codecs/es8316.c                          |   7 +-
 sound/soc/codecs/nau8824.c                         |  40 +++++
 sound/soc/codecs/rt5651.c                          |   7 +-
 sound/soc/codecs/rt5682.c                          |  56 +++++-
 sound/soc/codecs/rt5682.h                          |  20 +++
 sound/soc/intel/boards/sof_sdw.c                   |  10 ++
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c  |  41 +++++
 .../mediatek/mt8195/mt8195-mt6359-rt1019-rt5682.c  |   6 +-
 sound/soc/sh/rcar/dma.c                            |   2 +-
 sound/soc/soc-dapm.c                               |  29 +++-
 sound/soc/sof/intel/hda-dai.c                      |   7 +-
 sound/usb/clock.c                                  |   4 +
 sound/usb/implicit.c                               |   2 -
 sound/usb/mixer_quirks.c                           |  34 ++++
 sound/usb/quirks-table.h                           |  58 +++++++
 tools/build/feature/test-all.c                     |   1 -
 tools/perf/bench/futex-lock-pi.c                   |   1 +
 tools/perf/bench/futex-requeue.c                   |   1 +
 tools/perf/bench/futex-wake-parallel.c             |   1 +
 tools/perf/bench/futex-wake.c                      |   1 +
 tools/perf/bench/sched-messaging.c                 |   4 +
 tools/perf/tests/shell/record+zstd_comp_decomp.sh  |   2 +-
 tools/perf/util/bpf-event.c                        |   6 +-
 tools/perf/util/env.c                              |   5 +-
 tools/perf/util/env.h                              |   2 +-
 tools/testing/selftests/gpio/Makefile              |   1 +
 tools/testing/selftests/net/gre_gso.sh             |  16 +-
 371 files changed, 3095 insertions(+), 1545 deletions(-)


