Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A145F157AC3
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgBJNZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbgBJMg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:57 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EA4220873;
        Mon, 10 Feb 2020 12:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338216;
        bh=EWb4A+iiRWRhSDu6pFLG8syqGPM+rCS2F8yODbP1530=;
        h=From:To:Cc:Subject:Date:From;
        b=i9pIJvfdbmJcnto7Pa+p/xd/5xBuf1Vu9nduM3qq+iPZbC4S5GAEwDVsyxOTVwLJC
         qTotdcQhuPKV1NlJGBm1/lp2vJhLLdhsMaawd9uHMpa5Neps3cJnPc/76nkeXtk8kR
         r5PRXTwIagQ2ziKpMzBBtcX/NiNicXhiTr7iloqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/309] 5.4.19-stable review
Date:   Mon, 10 Feb 2020 04:29:16 -0800
Message-Id: <20200210122406.106356946@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.19-rc1
X-KernelTest-Deadline: 2020-02-12T12:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.19 release.
There are 309 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.19-rc1

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kuap: Fix set direction in allow/prevent_user_access()

Stephen Rothwell <sfr@canb.auug.org.au>
    regulator fix for "regulator: core: Add regulator_is_equal() helper"

David Howells <dhowells@redhat.com>
    rxrpc: Fix service call disconnection

Song Liu <songliubraving@fb.com>
    perf/core: Fix mlock accounting in perf_mmap()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    clocksource: Prevent double add_timer_on() for watchdog_timer

Thomas Gleixner <tglx@linutronix.de>
    x86/apic/msi: Plug non-maskable MSI affinity race

Aurelien Aptel <aaptel@suse.com>
    cifs: fix mode bits from dir listing when mounted with modefromsid

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fail i/o on soft mounts if sessionsetup errors out

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Play nice with read-only memslots when querying host page size

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Use vcpu-specific gva->hva translation when querying host page size

Miaohe Lin <linmiaohe@huawei.com>
    KVM: nVMX: vmread should not set rflags to specify success in case of #PF

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix overlap between SPTE_MMIO_MASK and generation

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: use CPUID to locate host page table reserved bits

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Remove VCPI while disabling topology mgr

Josef Bacik <josef@toxicpanda.com>
    btrfs: free block groups after free'ing fs trees

Anand Jain <anand.jain@oracle.com>
    btrfs: use bool argument in free_root_pointers()

Thomas Gleixner <tglx@linutronix.de>
    x86/timer: Don't skip PIT setup when APIC is disabled or in legacy mode

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    mfd: bd70528: Fix hour register mask

Andreas Kemnade <andreas@kemnade.info>
    mfd: rn5t618: Mark ADC control register volatile

Marco Felsch <m.felsch@pengutronix.de>
    mfd: da9062: Fix watchdog compatible string

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: skl_hda_dsp_common: Fix global-out-of-bounds bug

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5: Deprecate usage of generic TLS HW capability bit

Maor Gottlieb <maorg@mellanox.com>
    net/mlx5: Fix deadlock in fs_core

Ido Schimmel <idosch@mellanox.com>
    drop_monitor: Do not cancel uninitialized work item

Sudarsana Reddy Kalluru <skalluru@marvell.com>
    qed: Fix timestamping issue for L2 unicast ptp packets.

Eric Dumazet <edumazet@google.com>
    ipv6/addrconf: fix potential NULL deref in inet6_set_link_af()

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    taprio: Fix dropping packets when using taprio + ETF offloading

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    taprio: Use taprio_reset_tc() to reset Traffic Classes configuration

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    taprio: Add missing policy validation for flags

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    taprio: Fix still allowing changing the flags during runtime

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    taprio: Fix enabling offload with wrong number of traffic classes

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Limit maximum GEM TX length in TSO

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Remove unnecessary alignment check for TSO

Raed Salem <raeds@mellanox.com>
    net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx

Raed Salem <raeds@mellanox.com>
    net/mlx5: IPsec, Fix esp modify function attribute

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: Avoid RBUF stuck in Wake-on-LAN mode

Dejin Zheng <zhengdejin5@gmail.com>
    net: stmmac: fix a possible endless loop

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix a resource leak in tcindex_set_parms()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: mvneta: move rx_dropped and rx_errors in per-cpu stats

Razvan Stefanescu <razvan.stefanescu@microchip.com>
    net: dsa: microchip: enable module autoprobe

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Always use dev->vlan_enabled in b53_configure_vlan()

Madalin Bucur <madalin.bucur@oss.nxp.com>
    dpaa_eth: support all modes with rate adapting PHYs

Jacob Keller <jacob.e.keller@intel.com>
    devlink: report 0 after hitting end in region read

Eric Dumazet <edumazet@google.com>
    bonding/alb: properly access headers in bond_alb_xmit()

Marek Vasut <marex@denx.de>
    ASoC: sgtl5000: Fix VDDA and VDDIO comparison

Marek Vasut <marex@denx.de>
    regulator: core: Add regulator_is_equal() helper

Quanyang Wang <quanyang.wang@windriver.com>
    ubifs: Fix memory leak from c->sup_node

Dan Carpenter <dan.carpenter@oracle.com>
    ubi: Fix an error pointer dereference in error handling code

Sascha Hauer <s.hauer@pengutronix.de>
    ubi: fastmap: Fix inverted logic in seen selfcheck

David Hildenbrand <david@redhat.com>
    virtio_balloon: Fix memory leaks on errors in virtballoon_probe()

David Hildenbrand <david@redhat.com>
    virtio-balloon: Fix memory leak when unloading while hinting is in progress

Trond Myklebust <trondmy@gmail.com>
    nfsd: Return the correct number of bytes written to the file

Arnd Bergmann <arnd@arndb.de>
    nfsd: fix jiffies/time_t mixup in LRU list

Arnd Bergmann <arnd@arndb.de>
    nfsd: fix delay timer on 32-bit architectures

Yishai Hadas <yishaih@mellanox.com>
    IB/core: Fix ODP get user pages flow

Prabhath Sajeepa <psajeepa@purestorage.com>
    IB/mlx5: Fix outstanding_pi index for GSI qps

Nathan Chancellor <natechancellor@gmail.com>
    net: tulip: Adjust indentation in {dmfe, uli526x}_init_module

Nathan Chancellor <natechancellor@gmail.com>
    net: smc911x: Adjust indentation in smc911x_phy_configure

Nathan Chancellor <natechancellor@gmail.com>
    ppp: Adjust indentation into ppp_async_input

Nathan Chancellor <natechancellor@gmail.com>
    NFC: pn544: Adjust indentation in pn544_hci_check_presence

Nathan Chancellor <natechancellor@gmail.com>
    drm: msm: mdp4: Adjust indentation in mdp4_dsi_encoder_enable

Nathan Chancellor <natechancellor@gmail.com>
    powerpc/44x: Adjust indentation in ibm4xx_denali_fixup_memsize

Nathan Chancellor <natechancellor@gmail.com>
    ext2: Adjust indentation in ext2_fill_super

Nathan Chancellor <natechancellor@gmail.com>
    phy: qualcomm: Adjust indentation in read_poll_timeout

Vignesh Raghavendra <vigneshr@ti.com>
    mtd: spi-nor: Split mt25qu512a (n25q512a) entry into two

Asutosh Das <asutoshd@codeaurora.org>
    scsi: ufs: Recheck bkops level if bkops is disabled

Nathan Chancellor <natechancellor@gmail.com>
    scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free

Nathan Chancellor <natechancellor@gmail.com>
    scsi: csiostor: Adjust indentation in csio_device_reset

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return type

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-fifo: fix fifo threshold setup

Erdem Aktas <erdemaktas@google.com>
    percpu: Separate decrypted varaibles anytime encryption can be enabled

Casey Schaufler <casey@schaufler-ca.com>
    broken ping to ipv6 linklocal addresses on debian buster

Miklos Szeredi <mszeredi@redhat.com>
    fix up iter on short count in fuse_direct_io()

Daniel Verkamp <dverkamp@chromium.org>
    virtio-pci: check name when counting MSI-X vectors

Daniel Verkamp <dverkamp@chromium.org>
    virtio-balloon: initialize all vq callbacks

Lyude Paul <lyude@redhat.com>
    drm/amd/dm/mst: Ignore payload update failures

Stephen Warren <swarren@nvidia.com>
    clk: tegra: Mark fuse clock as critical

Peter Zijlstra <peterz@infradead.org>
    mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush

Niklas Cassel <niklas.cassel@linaro.org>
    arm64: dts: qcom: qcs404-evb: Set vdd_apc regulator in high power mode

David Hildenbrand <david@redhat.com>
    mm/page_alloc.c: fix uninitialized memmaps on a partially populated last section

Gang He <GHe@suse.com>
    ocfs2: fix oops when writing cloned file

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: do not clobber registers during guest reset/store status

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Revert "KVM: X86: Fix fpu state crash in kvm guest"

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Ensure guest's FPU state is loaded when accessing for emulation

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Handle TIF_NEED_FPU_LOAD in kvm_{load,put}_guest_fpu()

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Don't let userspace set host-reserved cr4 bits

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Add non-canonical check on writes to RTIT address MSRs

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/KVM: Clean up host's steal time structure

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/kvm: Cache gfn to pfn translation

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/kvm: Introduce kvm_(un)map_gfn()

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit

John Allen <john.allen@amd.com>
    kvm/svm: PKU not currently supported

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: PPC: Book3S PR: Free shared page if mmu initialization fails

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX platform

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect MSR-based index computations in fixed_msr_to_seg_unit() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect MSR-based index computations from Spectre-v1/L1TF attacks in x86.c

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect ioapic_read_indirect() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect ioapic_write_indirect() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect kvm_hv_msr_[get|set]_crash_data() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect kvm_lapic_reg_write() from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect DR-based index computations from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Refactor prefix decoding to prevent Spectre-v1/L1TF attacks

Marios Pomonis <pomonis@google.com>
    KVM: x86: Refactor picdev_write() to prevent Spectre-v1/L1TF attacks

Jens Axboe <axboe@kernel.dk>
    aio: prevent potential eventfd recursion on poll

Jens Axboe <axboe@kernel.dk>
    eventfd: track eventfd_signal() recursion depth

Coly Li <colyli@suse.de>
    bcache: add readahead cache policy options via sysfs interface

Vladis Dronov <vdronov@redhat.com>
    watchdog: fix UAF in reboot notifier handling in watchdog core code

Juergen Gross <jgross@suse.com>
    xen/balloon: Support xend-based toolstack take two

Gavin Shan <gshan@redhat.com>
    tools/kvm_stat: Fix kvm_exit filter name

Sean Young <sean@mess.org>
    media: rc: ensure lirc is initialized before registering input device

Johan Hovold <johan@kernel.org>
    media: iguanair: fix endpoint sanity check

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/rect: Avoid division by zero

Peter Rosin <peda@axentia.se>
    drm: atmel-hlcdc: prefer a lower pixel-clock than requested

Claudiu Beznea <claudiu.beznea@microchip.com>
    drm: atmel-hlcdc: enable clock before configuring timing engine

Claudiu Beznea <claudiu.beznea@microchip.com>
    drm: atmel-hlcdc: use double rate for pixel clock only if supported

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: fix O_SYNC write handling

Christoph Hellwig <hch@lst.de>
    gfs2: move setting current->backing_dev_info

Abhi Das <adas@redhat.com>
    gfs2: fix gfs2_find_jhead that returns uninitialized jhead with seq 0

Roberto Bergantinos Corpas <rbergant@redhat.com>
    sunrpc: expiry_time should be seconds not timeval

Brian Norris <briannorris@chromium.org>
    mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: don't throw error when trying to remove IGTK

Stephen Warren <swarren@nvidia.com>
    ARM: tegra: Enable PLLP bypass during Tegra124 LP1

Nikolay Borisov <nborisov@suse.com>
    btrfs: Correctly handle empty trees in find_first_clear_extent_bit

Josef Bacik <josef@toxicpanda.com>
    btrfs: flush write bio if we loop in extent_write_cache_pages

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between adding and putting tree mod seq elements and nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop log root for dropped roots

Josef Bacik <josef@toxicpanda.com>
    btrfs: set trans->drity in btrfs_commit_transaction

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix infinite loop during fsync after rename operations

Filipe Manana <fdmanana@suse.com>
    Btrfs: make deduplication with range including the last block work

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix missing hole after hole punching and fsync when using NO_HOLES

Eric Biggers <ebiggers@google.com>
    ext4: fix race conditions in ->d_compare() and ->d_hash()

Eric Biggers <ebiggers@google.com>
    ext4: fix deadlock allocating crypto bounce page from mempool

Vasily Averin <vvs@virtuozzo.com>
    jbd2_seq_info_next should increase position index

Trond Myklebust <trondmy@gmail.com>
    nfsd: fix filecache lookup

Trond Myklebust <trondmy@gmail.com>
    NFS: Directory page cache pages need to be locked when read

Trond Myklebust <trondmy@gmail.com>
    NFS: Fix memory leaks and corruption in readdir

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix unbound NVME response length

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/futex: Fix incorrect user access blocking

Chuhong Yuan <hslester96@gmail.com>
    crypto: picoxcell - adjust the position of tasklet_init and fix missed tasklet_kill

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix race condition in crypto_spawn_alg

Tudor Ambarus <tudor.ambarus@microchip.com>
    crypto: atmel-aes - Fix counter overflow in CTR mode

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Do not clear MAY_SLEEP flag in original request

Ard Biesheuvel <ardb@kernel.org>
    crypto: arm64/ghash-neon - bump priority to 150

Ard Biesheuvel <ardb@kernel.org>
    crypto: ccp - set max RSA modulus size for v3 platform devices as well

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    crypto: hisilicon - Use the offset fields in sqe to avoid need to split scatterlists

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - fix unexpectedly getting generic implementation

Lorenz Bauer <lmb@cloudflare.com>
    selftests: bpf: Ignore FIN packets for reuseport tests

Lorenz Bauer <lmb@cloudflare.com>
    selftests: bpf: Use a temporary file in test_sockmap

Hangbin Liu <liuhangbin@gmail.com>
    selftests/bpf: Skip perf hw events test if the setup disabled it

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: Fix test_attach_probe

Jesper Dangaard Brouer <brouer@redhat.com>
    samples/bpf: Xdp_redirect_cpu fix missing tracepoint attach

Toke Høiland-Jørgensen <toke@redhat.com>
    samples/bpf: Don't try to remove user's homedir on clean

Davide Caratti <dcaratti@redhat.com>
    tc-testing: fix eBPF tests failure on linux fresh clones

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix realloc usage in bpf_core_find_cands

Amol Grover <frextrite@gmail.com>
    bpf, devmap: Pass lockdep expression to RCU lists

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix perf_buffer test on systems w/ offline CPUs

Björn Töpel <bjorn.topel@gmail.com>
    riscv, bpf: Fix broken BPF tail calls

Nikolay Borisov <nborisov@suse.com>
    btrfs: Handle another split brain scenario with metadata uuid feature

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix improper setting of scanned for range cyclic write cache pages

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Avoid deadlock by using per-instance padata queues

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Protect ftrace_graph_hash with ftrace_sync

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Add comment to why rcu_dereference_sched() is open coded

Amol Grover <frextrite@gmail.com>
    tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu

Amol Grover <frextrite@gmail.com>
    tracing: Annotate ftrace_graph_hash pointer with __rcu

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: core: release resources on errors in probe_continue

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Introduce state machine for FW boot

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix stuck login session using prli_pend_timer

Mike Snitzer <snitzer@redhat.com>
    dm: fix potential for q->make_request_fn NULL pointer

Mike Snitzer <snitzer@redhat.com>
    dm thin metadata: use pool locking at end of dm_pool_metadata_close

Milan Broz <gmazyland@gmail.com>
    dm crypt: fix benbi IV constructor crash if used in authenticated mode

Mikulas Patocka <mpatocka@redhat.com>
    dm crypt: fix GFP flags passed to skcipher_request_alloc()

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: fix incorrect flush sequence when doing SSD mode commit

Joe Thornber <ejt@redhat.com>
    dm space map common: fix to ensure new block isn't already in use

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    dm zoned: support zone sizes smaller than 128MiB

Chen-Yu Tsai <wens@csie.org>
    ARM: dma-api: fix max_pfn off-by-one error in __dma_supported()

Michael Ellerman <mpe@ellerman.id.au>
    of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid creating excessively large stack frames

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: core: Fix handling of devices deleted during system-wide resume

Eric Biggers <ebiggers@google.com>
    f2fs: fix race conditions in ->d_compare() and ->d_hash()

Eric Biggers <ebiggers@google.com>
    f2fs: fix dcache lookup of !casefolded directories

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: code cleanup for f2fs_statfs_project()

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: fix miscounted block limit in f2fs_statfs_project()

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: choose hardlimit when softlimit is larger than hardlimit in f2fs_statfs_project()

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix lseek overflow on 32bit

Amir Goldstein <amir73il@gmail.com>
    ovl: fix wrong WARN_ON() in ovl_cache_update_ino()

Sven Van Asbroeck <thesven73@gmail.com>
    power: supply: ltc2941-battery-gauge: fix use-after-free

Samuel Holland <samuel@sholland.org>
    power: supply: axp20x_ac_power: Fix reporting online status

Thomas Renninger <trenn@suse.de>
    cpupower: Revert library ABI changes from commit ae2917093fb60bdc1ed3e

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix mtcp dump collection failure

Anand Lodnoor <anand.lodnoor@broadcom.com>
    scsi: megaraid_sas: Do not initiate OCR if controller is not in ready state

Gao Xiang <xiang@kernel.org>
    erofs: fix out-of-bound read for shifted uncompressed block

Geert Uytterhoeven <geert+renesas@glider.be>
    scripts/find-unused-docs: Fix massive false positives

Filipe Manana <fdmanana@suse.com>
    fs: allow deduplication of eof block into the end of the destination file

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Remove broken queue flushing

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix PM race condition

Ofir Drang <ofir.drang@arm.com>
    crypto: ccree - fix FDE descriptor sequence

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix pm wrongful error reporting

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix AEAD decrypt auth fail

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix backlog memory leak

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Check spawn->alg under lock in crypto_drop_spawn

Bitan Biswas <bbiswas@nvidia.com>
    nvmem: core: fix memory abort in cleanup path

Samuel Holland <samuel@sholland.org>
    mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as volatile

Tianyu Lan <Tianyu.Lan@microsoft.com>
    hv_balloon: Balloon up according to request page number

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: core: free trace on errors

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: sdhci-of-at91: fix memleak on clk_get failure

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix deadlock in concurrent bulk-read and writepage

Eric Biggers <ebiggers@google.com>
    ubifs: Fix FS_IOC_SETFLAGS unexpectedly clearing encrypt flag

Sascha Hauer <s.hauer@pengutronix.de>
    ubifs: Fix wrong memory allocation

Eric Biggers <ebiggers@google.com>
    ubifs: don't trigger assertion on invalid no-key filename

Eric Biggers <ebiggers@google.com>
    fscrypt: don't print name of busy file when removing key

Stephen Boyd <swboyd@chromium.org>
    alarmtimer: Unregister wakeup source when module get fails

Hans de Goede <hdegoede@redhat.com>
    ACPI / battery: Deal better with neither design nor full capacity not being reported

Hans de Goede <hdegoede@redhat.com>
    ACPI / battery: Use design-cap for capacity calculations if full-cap is not available

Hans de Goede <hdegoede@redhat.com>
    ACPI / battery: Deal with design or full capacity being reported as -1

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Do not export a non working backlight interface on MSI MS-7721 boards

Linus Walleij <linus.walleij@linaro.org>
    mmc: spi: Toggle SPI polarity, do not hardcode it

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Fix error handling when "num-viewport" DT property is not populated

Yurii Monakov <monakov.y@gmail.com>
    PCI: keystone: Fix link training retries initiation

Yurii Monakov <monakov.y@gmail.com>
    PCI: keystone: Fix outbound region mapping

David Engraf <david.engraf@sysgo.com>
    PCI: tegra: Fix return value check of pm_runtime_get_sync()

Tom Zanussi <zanussi@kernel.org>
    tracing: Fix now invalid var_ref_vals assumption in trace action

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/32s: Fix CPU wake-up from sleep mode

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/32s: Fix bad_kuap_fault()

Pingfan Liu <kernelfans@gmail.com>
    powerpc/pseries: Advance pfn if section is not present in lmb_is_removable()

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    powerpc/xmon: don't access ASDR in VMs

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/ptdump: Fix W+X verification

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: fix dynamic pagetable upgrade for hugetlbfs

Alexander Lobakin <alobakin@dlink.ru>
    MIPS: boot: fix typo in 'vmlinux.lzma.its' target

Alexander Lobakin <alobakin@dlink.ru>
    MIPS: fix indentation of the 'RELOCS' message

Alexander Lobakin <alobakin@dlink.ru>
    MIPS: syscalls: fix indentation of the 'SYSNR' message

Christoffer Dall <christoffer.dall@arm.com>
    KVM: arm64: Only sign-extend MMIO up to register width

Mark Rutland <mark.rutland@arm.com>
    KVM: arm/arm64: Correct AArch32 SPSR on exception entry

Mark Rutland <mark.rutland@arm.com>
    KVM: arm/arm64: Correct CPSR on exception entry

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Correct PSTATE on exception entry

Mark Rutland <mark.rutland@arm.com>
    arm64: acpi: fix DAIF manipulation with pNMI

Yong Zhi <yong.zhi@intel.com>
    ALSA: hda: Add JasperLake PCI ID and codec vid

Hans de Goede <hdegoede@redhat.com>
    ALSA: hda: Add Clevo W65_67SB the power_save blacklist

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Apply aligned MMIO access only conditionally

Mika Westerberg <mika.westerberg@linux.intel.com>
    platform/x86: intel_scu_ipc: Fix interrupt support

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR

Kevin Hao <haokexin@gmail.com>
    irqdomain: Fix a memory leak in irq_domain_push_irq()

Gustavo A. R. Silva <gustavo@embeddedor.com>
    lib/test_kasan.c: fix memory leak in kmalloc_oob_krealloc_more()

Helen Koike <helen.koike@collabora.com>
    media: v4l2-rect.h: fix v4l2_rect_map_inside() top/left adjustments

Arnd Bergmann <arnd@arndb.de>
    media: v4l2-core: compat: ignore native command codes

John Hubbard <jhubbard@nvidia.com>
    media/v4l2-core: set pages dirty upon releasing DMA buffers

Yang Shi <yang.shi@linux.alibaba.com>
    mm: move_pages: report the number of non-attempted pages

Wei Yang <richardw.yang@linux.intel.com>
    mm: thp: don't need care deferred split queue in memcg charge move path

Dan Williams <dan.j.williams@intel.com>
    mm/memory_hotplug: fix remove_memory() lockdep splat

Amir Goldstein <amir73il@gmail.com>
    utimes: Clamp the timestamps in notify_change()

zhengbin <zhengbin13@huawei.com>
    mmc: sdhci-pci: Make function amd_sdhci_reset static

Pingfan Liu <kernelfans@gmail.com>
    mm/sparse.c: reset section's mem_map when fully deactivated

Theodore Ts'o <tytso@mit.edu>
    memcg: fix a crash in wb_workfn when a device disappears

Takashi Iwai <tiwai@suse.de>
    ALSA: dummy: Fix PCM format loop in proc output

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Annotate endianess in Scarlett gen2 quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix endianess in descriptor validation

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    usb: gadget: f_ecm: Use atomic_t to track in-flight request

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    usb: gadget: f_ncm: Use atomic_t to track in-flight request

Roger Quadros <rogerq@ti.com>
    usb: gadget: legacy: set max_speed to super-speed

Peter Chen <peter.chen@nxp.com>
    usb: gadget: f_fs: set req->num_sgs as 0 for non-sg transfer

Olof Johansson <olof@lixom.net>
    objtool: Silence build output

Jun Li <jun.li@nxp.com>
    usb: typec: tcpci: mask event interrupts when remove driver

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Delay starting transfer

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Check END_TRANSFER completion

Navid Emamdoost <navid.emamdoost@gmail.com>
    brcmfmac: Fix memory leak in brcmf_usbdev_qinit

Kai-Heng Feng <kai.heng.feng@canonical.com>
    Bluetooth: btusb: Disable runtime suspend on Realtek devices

Colin Ian King <colin.king@canonical.com>
    Bluetooth: btusb: fix memory leak on fw

Israel Rukshin <israelr@mellanox.com>
    nvmet: Fix controller use after free

Israel Rukshin <israelr@mellanox.com>
    nvmet: Fix error print message at nvmet_install_queue function

Paul E. McKenney <paulmck@kernel.org>
    rcu: Use READ_ONCE() for ->expmask in rcu_read_unlock_special()

Paul E. McKenney <paulmck@kernel.org>
    srcu: Apply *_ONCE() to ->srcu_last_gp_end

Eric Dumazet <edumazet@google.com>
    rcu: Avoid data-race in rcu_gp_fqs_check_wake()

Paul E. McKenney <paulmck@kernel.org>
    rcu: Use *_ONCE() to protect lockless ->expmask accesses

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    tracing: Fix sched switch start/stop refcount racy updates

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing/kprobes: Have uname use __get_str() in print_fmt

Lu Shuaibing <shuaibinglu@126.com>
    ipc/msg.c: consolidate all xxxctl_down() functions

Kadlecsik József <kadlec@blackhole.kfki.hu>
    netfilter: ipset: fix suspicious RCU usage in find_set_and_id

Oliver Neukum <oneukum@suse.com>
    mfd: dln2: More sanity checking for endpoints

Will Deacon <will@kernel.org>
    media: uvcvideo: Avoid cyclic entity chains due to malformed USB descriptors

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix logic that disables Bus Master during firmware reset.

Taehee Yoo <ap420073@gmail.com>
    netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    MAINTAINERS: correct entries for ISDN/mISDN section

Shannon Nelson <snelson@pensando.io>
    ionic: fix rxq comp packet type mask

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->segs_{in|out} in tcp_disconnect()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->data_segs{in|out} in tcp_disconnect()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->delivered in tcp_disconnect()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->total_retrans in tcp_disconnect()

David Howells <dhowells@redhat.com>
    rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect

David Howells <dhowells@redhat.com>
    rxrpc: Fix missing active use pinning of rxrpc_local object

David Howells <dhowells@redhat.com>
    rxrpc: Fix insufficient receive notification generation

David Howells <dhowells@redhat.com>
    rxrpc: Fix use-after-free in rxrpc_put_local()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix TC queue mapping.

Nicolin Chen <nicoleotsuka@gmail.com>
    net: stmmac: Delete txtimer in suspend()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix an OOB access in cls_tcindex

Eric Dumazet <edumazet@google.com>
    net: hsr: fix possible NULL deref in hsr_handle_frame()

Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
    l2tp: Allow duplicate session creation with UDP

Taehee Yoo <ap420073@gmail.com>
    gtp: use __GFP_NOWARN to avoid memalloc warning

Eric Dumazet <edumazet@google.com>
    cls_rsvp: fix rsvp_policy

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Move devlink_register before registering netdev

Arnd Bergmann <arnd@arndb.de>
    sparc32: fix struct ipc64_perm type definition


-------------

Diffstat:

 MAINTAINERS                                        |   6 +-
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   3 -
 arch/arm/include/asm/kvm_emulate.h                 |  22 ++
 arch/arm/include/asm/kvm_mmio.h                    |   2 +
 arch/arm/mach-tegra/sleep-tegra30.S                |  11 +
 arch/arm/mm/dma-mapping.c                          |   2 +-
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi           |   1 +
 arch/arm64/crypto/ghash-ce-glue.c                  |   2 +-
 arch/arm64/include/asm/daifflags.h                 |  11 +-
 arch/arm64/include/asm/kvm_emulate.h               |  37 ++
 arch/arm64/include/asm/kvm_mmio.h                  |   6 +-
 arch/arm64/include/asm/ptrace.h                    |   1 +
 arch/arm64/include/uapi/asm/ptrace.h               |   1 +
 arch/arm64/kernel/acpi.c                           |   2 +-
 arch/arm64/kvm/inject_fault.c                      |  70 +++-
 arch/mips/Makefile.postlink                        |   2 +-
 arch/mips/boot/Makefile                            |   2 +-
 arch/mips/kernel/syscalls/Makefile                 |   2 +-
 arch/powerpc/Kconfig                               |   4 +-
 arch/powerpc/boot/4xx.c                            |   2 +-
 arch/powerpc/include/asm/book3s/32/kup.h           |  22 +-
 arch/powerpc/include/asm/book3s/32/pgalloc.h       |   8 -
 arch/powerpc/include/asm/book3s/64/kup-radix.h     |  14 +-
 arch/powerpc/include/asm/book3s/64/pgalloc.h       |   2 -
 arch/powerpc/include/asm/futex.h                   |  10 +-
 arch/powerpc/include/asm/kup.h                     |  36 +-
 arch/powerpc/include/asm/nohash/32/kup-8xx.h       |   7 +-
 arch/powerpc/include/asm/nohash/pgalloc.h          |   8 -
 arch/powerpc/include/asm/tlb.h                     |  11 +
 arch/powerpc/include/asm/uaccess.h                 |   4 +-
 arch/powerpc/kernel/entry_32.S                     |   3 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/kvm/book3s_pr.c                       |   4 +-
 arch/powerpc/kvm/book3s_xive_native.c              |   2 +-
 arch/powerpc/mm/book3s64/pgtable.c                 |   7 -
 arch/powerpc/mm/fault.c                            |   2 +-
 arch/powerpc/mm/ptdump/ptdump.c                    |   4 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   4 +-
 arch/powerpc/xmon/xmon.c                           |   9 +-
 arch/riscv/net/bpf_jit_comp.c                      |  13 +-
 arch/s390/include/asm/page.h                       |   2 +
 arch/s390/kvm/kvm-s390.c                           |   6 +-
 arch/s390/mm/hugetlbpage.c                         | 100 ++++-
 arch/sparc/Kconfig                                 |   1 -
 arch/sparc/include/asm/tlb_64.h                    |   9 +
 arch/sparc/include/uapi/asm/ipcbuf.h               |  22 +-
 arch/x86/include/asm/apic.h                        |  10 +
 arch/x86/include/asm/kvm_host.h                    |  13 +-
 arch/x86/include/asm/x86_init.h                    |   2 +
 arch/x86/kernel/apic/apic.c                        |  23 +-
 arch/x86/kernel/apic/msi.c                         | 128 +++++-
 arch/x86/kernel/cpu/tsx.c                          |  13 +-
 arch/x86/kernel/time.c                             |  12 +-
 arch/x86/kernel/x86_init.c                         |   1 +
 arch/x86/kvm/cpuid.c                               |   4 +-
 arch/x86/kvm/emulate.c                             |  66 +++-
 arch/x86/kvm/hyperv.c                              |  10 +-
 arch/x86/kvm/i8259.c                               |   6 +-
 arch/x86/kvm/ioapic.c                              |  15 +-
 arch/x86/kvm/lapic.c                               |  13 +-
 arch/x86/kvm/mmu.c                                 | 107 ++---
 arch/x86/kvm/mmutrace.h                            |  12 +-
 arch/x86/kvm/mtrr.c                                |   8 +-
 arch/x86/kvm/paging_tmpl.h                         |  25 +-
 arch/x86/kvm/pmu.h                                 |  18 +-
 arch/x86/kvm/svm.c                                 |   6 +
 arch/x86/kvm/vmx/capabilities.h                    |   5 +
 arch/x86/kvm/vmx/nested.c                          |   4 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  24 +-
 arch/x86/kvm/vmx/vmx.c                             |   3 +
 arch/x86/kvm/x86.c                                 | 196 +++++++---
 arch/x86/kvm/x86.h                                 |   2 +-
 arch/x86/xen/enlighten_pv.c                        |   1 +
 crypto/algapi.c                                    |  46 ++-
 crypto/api.c                                       |   7 +-
 crypto/internal.h                                  |   1 -
 crypto/pcrypt.c                                    |  37 +-
 drivers/acpi/battery.c                             |  75 +++-
 drivers/acpi/video_detect.c                        |  13 +
 drivers/base/power/main.c                          |  42 +-
 drivers/bluetooth/btusb.c                          |   6 +-
 drivers/clk/tegra/clk-tegra-periph.c               |   6 +-
 drivers/cpufreq/cppc_cpufreq.c                     |   2 +-
 drivers/cpufreq/cpufreq-nforce2.c                  |   2 +-
 drivers/cpufreq/cpufreq.c                          | 147 ++++---
 drivers/cpufreq/freq_table.c                       |   4 +-
 drivers/cpufreq/gx-suspmod.c                       |   2 +-
 drivers/cpufreq/intel_pstate.c                     |  38 +-
 drivers/cpufreq/longrun.c                          |   6 +-
 drivers/cpufreq/pcc-cpufreq.c                      |   2 +-
 drivers/cpufreq/sh-cpufreq.c                       |   2 +-
 drivers/cpufreq/unicore2-cpufreq.c                 |   2 +-
 drivers/crypto/atmel-aes.c                         |  37 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |   1 +
 drivers/crypto/ccree/cc_aead.c                     |   2 +-
 drivers/crypto/ccree/cc_cipher.c                   |  48 ++-
 drivers/crypto/ccree/cc_driver.h                   |   1 +
 drivers/crypto/ccree/cc_pm.c                       |  30 +-
 drivers/crypto/ccree/cc_request_mgr.c              |  51 +--
 drivers/crypto/ccree/cc_request_mgr.h              |   8 -
 drivers/crypto/hisilicon/Kconfig                   |   1 -
 drivers/crypto/hisilicon/zip/zip.h                 |   4 +
 drivers/crypto/hisilicon/zip/zip_crypto.c          |  92 ++---
 drivers/crypto/picoxcell_crypto.c                  |  15 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  13 +-
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     |  18 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  12 +
 drivers/gpu/drm/drm_rect.c                         |   7 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_dsi_encoder.c   |   2 +-
 drivers/hv/hv_balloon.c                            |  13 +-
 drivers/infiniband/core/umem_odp.c                 |   2 +-
 drivers/infiniband/hw/mlx5/gsi.c                   |   3 +-
 drivers/md/bcache/bcache.h                         |   3 +
 drivers/md/bcache/request.c                        |  17 +-
 drivers/md/bcache/sysfs.c                          |  22 ++
 drivers/md/dm-crypt.c                              |  12 +-
 drivers/md/dm-thin-metadata.c                      |  10 +-
 drivers/md/dm-writecache.c                         |  42 +-
 drivers/md/dm-zoned-metadata.c                     |  23 +-
 drivers/md/dm.c                                    |   9 +-
 drivers/md/persistent-data/dm-space-map-common.c   |  27 ++
 drivers/md/persistent-data/dm-space-map-common.h   |   2 +
 drivers/md/persistent-data/dm-space-map-disk.c     |   6 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   5 +-
 drivers/media/rc/iguanair.c                        |   2 +-
 drivers/media/rc/rc-main.c                         |  27 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  12 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      | 148 +++----
 drivers/media/v4l2-core/videobuf-dma-sg.c          |   5 +-
 drivers/mfd/axp20x.c                               |   2 +-
 drivers/mfd/da9062-core.c                          |   2 +-
 drivers/mfd/dln2.c                                 |  13 +-
 drivers/mfd/rn5t618.c                              |   1 +
 drivers/mmc/host/mmc_spi.c                         |  11 +-
 drivers/mmc/host/sdhci-of-at91.c                   |   9 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   2 +-
 drivers/mtd/spi-nor/spi-nor.c                      |   9 +-
 drivers/mtd/ubi/fastmap.c                          |  23 +-
 drivers/net/bonding/bond_alb.c                     |  44 ++-
 drivers/net/dsa/b53/b53_common.c                   |   2 +-
 drivers/net/dsa/bcm_sf2.c                          |   4 +-
 drivers/net/dsa/microchip/ksz9477_spi.c            |   6 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  25 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   1 -
 drivers/net/ethernet/cadence/macb_main.c           |  14 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |   7 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |   4 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  14 +-
 drivers/net/ethernet/marvell/mvneta.c              |  27 +-
 .../net/ethernet/mellanox/mlx5/core/accel/tls.h    |   2 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_ptp.c          |   4 +-
 drivers/net/ethernet/smsc/smc911x.c                |   2 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +
 drivers/net/gtp.c                                  |   4 +-
 drivers/net/netdevsim/dev.c                        |   2 +-
 drivers/net/ppp/ppp_async.c                        |  18 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  10 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   1 +
 drivers/nfc/pn544/pn544.c                          |   2 +-
 drivers/nvme/target/fabrics-cmd.c                  |  15 +-
 drivers/nvmem/core.c                               |   8 +-
 drivers/of/Kconfig                                 |   4 +
 drivers/of/address.c                               |   6 +-
 drivers/pci/controller/dwc/pci-keystone.c          |   6 +-
 drivers/pci/controller/pci-tegra.c                 |   2 +-
 drivers/phy/qualcomm/phy-qcom-apq8064-sata.c       |   2 +-
 drivers/platform/x86/intel_scu_ipc.c               |  21 +-
 drivers/power/supply/axp20x_ac_power.c             |  31 +-
 drivers/power/supply/ltc2941-battery-gauge.c       |   2 +-
 drivers/regulator/helpers.c                        |  14 +
 drivers/scsi/csiostor/csio_scsi.c                  |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   3 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   3 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |   1 +
 drivers/scsi/qla2xxx/qla_dbg.c                     |   6 -
 drivers/scsi/qla2xxx/qla_dbg.h                     |   6 +
 drivers/scsi/qla2xxx/qla_def.h                     |   5 +
 drivers/scsi/qla2xxx/qla_init.c                    |  34 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  12 +
 drivers/scsi/qla2xxx/qla_mbx.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |   7 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   1 +
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |   3 +
 drivers/usb/dwc3/core.h                            |   2 +
 drivers/usb/dwc3/ep0.c                             |   4 +-
 drivers/usb/dwc3/gadget.c                          |  17 +-
 drivers/usb/gadget/function/f_ecm.c                |  16 +-
 drivers/usb/gadget/function/f_fs.c                 |   2 +
 drivers/usb/gadget/function/f_ncm.c                |  17 +-
 drivers/usb/gadget/legacy/cdc2.c                   |   2 +-
 drivers/usb/gadget/legacy/g_ffs.c                  |   2 +-
 drivers/usb/gadget/legacy/multi.c                  |   2 +-
 drivers/usb/gadget/legacy/ncm.c                    |   2 +-
 drivers/usb/typec/tcpm/tcpci.c                     |   6 +
 drivers/virtio/virtio_balloon.c                    |  19 +-
 drivers/virtio/virtio_pci_common.c                 |   2 +-
 drivers/watchdog/watchdog_core.c                   |  35 ++
 drivers/watchdog/watchdog_dev.c                    |  36 +-
 drivers/xen/xen-balloon.c                          |   2 +-
 fs/aio.c                                           |  20 +-
 fs/attr.c                                          |  23 +-
 fs/btrfs/ctree.c                                   |   8 +-
 fs/btrfs/ctree.h                                   |   6 +-
 fs/btrfs/delayed-ref.c                             |   8 +-
 fs/btrfs/disk-io.c                                 |  22 +-
 fs/btrfs/extent_io.c                               |  55 ++-
 fs/btrfs/ioctl.c                                   |   3 +-
 fs/btrfs/tests/btrfs-tests.c                       |   1 -
 fs/btrfs/tests/extent-io-tests.c                   |   9 +
 fs/btrfs/transaction.c                             |  30 +-
 fs/btrfs/tree-log.c                                | 432 +++++++--------------
 fs/btrfs/volumes.c                                 |  17 +-
 fs/cifs/readdir.c                                  |   3 +-
 fs/cifs/smb2pdu.c                                  |  10 +-
 fs/configfs/inode.c                                |   9 +-
 fs/crypto/keyring.c                                |  15 +-
 fs/erofs/decompressor.c                            |  22 +-
 fs/eventfd.c                                       |  15 +
 fs/ext2/super.c                                    |   6 +-
 fs/ext4/dir.c                                      |   9 +-
 fs/ext4/page-io.c                                  |  19 +-
 fs/f2fs/dir.c                                      |  11 +-
 fs/f2fs/file.c                                     |  18 +-
 fs/f2fs/super.c                                    |  14 +-
 fs/fs-writeback.c                                  |   2 +-
 fs/fuse/file.c                                     |   5 +-
 fs/gfs2/file.c                                     |  72 ++--
 fs/gfs2/lops.c                                     |   2 +-
 fs/jbd2/journal.c                                  |   1 +
 fs/nfs/dir.c                                       |  47 ++-
 fs/nfsd/filecache.c                                |   6 +
 fs/nfsd/nfs4layouts.c                              |   2 +-
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nfsd/state.h                                    |   2 +-
 fs/nfsd/vfs.c                                      |   1 +
 fs/ntfs/inode.c                                    |  18 +-
 fs/ocfs2/file.c                                    |  14 +-
 fs/overlayfs/file.c                                |   2 +-
 fs/overlayfs/readdir.c                             |   8 +-
 fs/read_write.c                                    |  10 +-
 fs/ubifs/dir.c                                     |   2 +
 fs/ubifs/file.c                                    |  22 +-
 fs/ubifs/ioctl.c                                   |   3 +-
 fs/ubifs/sb.c                                      |   2 +-
 fs/ubifs/super.c                                   |   2 +
 fs/utimes.c                                        |   4 +-
 include/asm-generic/tlb.h                          |  22 +-
 include/linux/backing-dev.h                        |  10 +
 include/linux/cpufreq.h                            |  32 +-
 include/linux/eventfd.h                            |  14 +
 include/linux/irq.h                                |  18 +
 include/linux/irqdomain.h                          |   7 +
 include/linux/kvm_host.h                           |  13 +-
 include/linux/kvm_types.h                          |   9 +-
 include/linux/mfd/rohm-bd70528.h                   |   2 +-
 include/linux/mlx5/mlx5_ifc.h                      |   7 +-
 include/linux/padata.h                             |  34 +-
 include/linux/percpu-defs.h                        |   3 +-
 include/linux/regulator/consumer.h                 |   7 +
 include/media/v4l2-rect.h                          |   8 +-
 include/net/ipx.h                                  |   5 -
 include/sound/hdaudio.h                            |  77 ++--
 include/trace/events/writeback.h                   |  37 +-
 ipc/msg.c                                          |  19 +-
 kernel/bpf/devmap.c                                |   3 +-
 kernel/events/core.c                               |  10 +-
 kernel/irq/debugfs.c                               |   1 +
 kernel/irq/irqdomain.c                             |   1 +
 kernel/irq/msi.c                                   |   5 +-
 kernel/padata.c                                    | 275 ++++++++-----
 kernel/rcu/srcutree.c                              |   7 +-
 kernel/rcu/tree_exp.h                              |  19 +-
 kernel/rcu/tree_plugin.h                           |  13 +-
 kernel/time/alarmtimer.c                           |   8 +-
 kernel/time/clocksource.c                          |  11 +-
 kernel/trace/ftrace.c                              |  15 +-
 kernel/trace/trace.h                               |  29 +-
 kernel/trace/trace_events_hist.c                   |  53 ++-
 kernel/trace/trace_probe.c                         |   6 +-
 kernel/trace/trace_sched_switch.c                  |   4 +-
 lib/test_kasan.c                                   |   1 +
 mm/backing-dev.c                                   |   1 +
 mm/memcontrol.c                                    |  18 -
 mm/memory_hotplug.c                                |   9 +-
 mm/migrate.c                                       |  25 +-
 mm/mmu_gather.c                                    |  16 +-
 mm/page_alloc.c                                    |  14 +-
 mm/sparse.c                                        |   2 +-
 net/core/devlink.c                                 |   6 +
 net/core/drop_monitor.c                            |   4 +-
 net/hsr/hsr_slave.c                                |   2 +
 net/ipv4/tcp.c                                     |   6 +
 net/ipv6/addrconf.c                                |   3 +
 net/l2tp/l2tp_core.c                               |   7 +-
 net/netfilter/ipset/ip_set_core.c                  |  41 +-
 net/rxrpc/af_rxrpc.c                               |   2 +
 net/rxrpc/ar-internal.h                            |  11 +
 net/rxrpc/call_object.c                            |   4 +-
 net/rxrpc/conn_client.c                            |   3 +-
 net/rxrpc/conn_event.c                             |  30 +-
 net/rxrpc/conn_object.c                            |   3 +-
 net/rxrpc/input.c                                  |   6 +-
 net/rxrpc/local_object.c                           |  23 +-
 net/rxrpc/output.c                                 |  27 +-
 net/rxrpc/peer_event.c                             |  42 +-
 net/sched/cls_rsvp.h                               |   6 +-
 net/sched/cls_tcindex.c                            |  43 +-
 net/sched/sch_taprio.c                             |  92 +++--
 net/sunrpc/auth_gss/svcauth_gss.c                  |   4 +
 samples/bpf/Makefile                               |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c                |  59 ++-
 scripts/find-unused-docs.sh                        |   2 +-
 security/smack/smack_lsm.c                         |  41 +-
 sound/drivers/dummy.c                              |   2 +-
 sound/pci/hda/hda_intel.c                          |   4 +
 sound/pci/hda/hda_tegra.c                          |   1 +
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/soc/codecs/sgtl5000.c                        |   3 +-
 sound/soc/intel/boards/skl_hda_dsp_common.c        |  21 +-
 sound/soc/meson/axg-fifo.c                         |  27 +-
 sound/soc/meson/axg-fifo.h                         |   6 +-
 sound/soc/meson/axg-frddr.c                        |  24 +-
 sound/soc/meson/axg-toddr.c                        |  21 +-
 sound/soc/sof/core.c                               |  87 +++--
 sound/soc/sof/intel/hda-loader.c                   |   1 -
 sound/soc/sof/intel/hda.c                          |   4 +-
 sound/soc/sof/ipc.c                                |  17 +-
 sound/soc/sof/loader.c                             |  19 +-
 sound/soc/sof/pm.c                                 |  25 +-
 sound/soc/sof/sof-priv.h                           |  11 +-
 sound/usb/mixer_scarlett_gen2.c                    |  46 +--
 sound/usb/validate.c                               |   6 +-
 tools/kvm/kvm_stat/kvm_stat                        |   8 +-
 tools/lib/bpf/libbpf.c                             |   4 +-
 tools/objtool/sync-check.sh                        |   2 -
 tools/power/cpupower/lib/cpufreq.c                 |  78 +++-
 tools/power/cpupower/lib/cpufreq.h                 |  20 +-
 tools/power/cpupower/utils/cpufreq-info.c          |  12 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |   7 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |  29 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |   8 +-
 .../bpf/progs/test_select_reuseport_kern.c         |   6 +
 tools/testing/selftests/bpf/test_sockmap.c         |  15 +-
 .../tc-testing/plugin-lib/buildebpfPlugin.py       |   2 +-
 virt/kvm/arm/aarch32.c                             | 117 +++++-
 virt/kvm/arm/mmio.c                                |   6 +
 virt/kvm/async_pf.c                                |  10 +-
 virt/kvm/kvm_main.c                                | 117 +++++-
 358 files changed, 3990 insertions(+), 2199 deletions(-)


