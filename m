Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36338157C32
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBJMfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbgBJMfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:17 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FEB92173E;
        Mon, 10 Feb 2020 12:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338115;
        bh=0CNQV2Cg8u7/VaNQXGh0DpFZ1G6psWXAq/igQF4yXEg=;
        h=From:To:Cc:Subject:Date:From;
        b=K0Ct2l6qa4t+JzRXmsN9AVrXDskjW2QssO+Dfd3J+TQb13GX8zsopIyJGhpm46zBQ
         QFzayNo0PRXmmMt3r1sm2ZP953Salqv+0kHAQWoMWOKsVwpD9wXoNeWD1VY+QdY7q4
         51PbFmhGq1PP52xqxlnmvoEW5BrcbuVmphV5OVEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/195] 4.19.103-stable review
Date:   Mon, 10 Feb 2020 04:30:58 -0800
Message-Id: <20200210122305.731206734@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.103-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.103-rc1
X-KernelTest-Deadline: 2020-02-12T12:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.103 release.
There are 195 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.103-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.103-rc1

David Howells <dhowells@redhat.com>
    rxrpc: Fix service call disconnection

Song Liu <songliubraving@fb.com>
    perf/core: Fix mlock accounting in perf_mmap()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    clocksource: Prevent double add_timer_on() for watchdog_timer

Thomas Gleixner <tglx@linutronix.de>
    x86/apic/msi: Plug non-maskable MSI affinity race

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fail i/o on soft mounts if sessionsetup errors out

David Hildenbrand <david@redhat.com>
    mm/page_alloc.c: fix uninitialized memmaps on a partially populated last section

Pavel Tatashin <pavel.tatashin@microsoft.com>
    mm: return zero_resv_unavail optimization

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: zero remaining unavailable struct pages

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Play nice with read-only memslots when querying host page size

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: Use vcpu-specific gva->hva translation when querying host page size

Miaohe Lin <linmiaohe@huawei.com>
    KVM: nVMX: vmread should not set rflags to specify success in case of #PF

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: VMX: Add non-canonical check on writes to RTIT address MSRs

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM

Josef Bacik <josef@toxicpanda.com>
    btrfs: flush write bio if we loop in extent_write_cache_pages

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Remove VCPI while disabling topology mgr

Claudiu Beznea <claudiu.beznea@microchip.com>
    drm: atmel-hlcdc: enable clock before configuring timing engine

Josef Bacik <josef@toxicpanda.com>
    btrfs: free block groups after free'ing fs trees

Anand Jain <anand.jain@oracle.com>
    btrfs: use bool argument in free_root_pointers()

Eric Biggers <ebiggers@google.com>
    ext4: fix deadlock allocating crypto bounce page from mempool

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: b53: Always use dev->vlan_enabled in b53_configure_vlan()

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

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix a resource leak in tcindex_set_parms()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: mvneta: move rx_dropped and rx_errors in per-cpu stats

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port

Eric Dumazet <edumazet@google.com>
    bonding/alb: properly access headers in bond_alb_xmit()

Andreas Kemnade <andreas@kemnade.info>
    mfd: rn5t618: Mark ADC control register volatile

Marco Felsch <m.felsch@pengutronix.de>
    mfd: da9062: Fix watchdog compatible string

Dan Carpenter <dan.carpenter@oracle.com>
    ubi: Fix an error pointer dereference in error handling code

Sascha Hauer <s.hauer@pengutronix.de>
    ubi: fastmap: Fix inverted logic in seen selfcheck

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

Asutosh Das <asutoshd@codeaurora.org>
    scsi: ufs: Recheck bkops level if bkops is disabled

Nathan Chancellor <natechancellor@gmail.com>
    scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free

Nathan Chancellor <natechancellor@gmail.com>
    scsi: csiostor: Adjust indentation in csio_device_reset

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return type

Erdem Aktas <erdemaktas@google.com>
    percpu: Separate decrypted varaibles anytime encryption can be enabled

Lyude Paul <lyude@redhat.com>
    drm/amd/dm/mst: Ignore payload update failures

Stephen Warren <swarren@nvidia.com>
    clk: tegra: Mark fuse clock as critical

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: do not clobber registers during guest reset/store status

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Don't let userspace set host-reserved cr4 bits

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit

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

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/rect: Avoid division by zero

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: fix O_SYNC write handling

Christoph Hellwig <hch@lst.de>
    gfs2: move setting current->backing_dev_info

Roberto Bergantinos Corpas <rbergant@redhat.com>
    sunrpc: expiry_time should be seconds not timeval

Brian Norris <briannorris@chromium.org>
    mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: don't throw error when trying to remove IGTK

Stephen Warren <swarren@nvidia.com>
    ARM: tegra: Enable PLLP bypass during Tegra124 LP1

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race between adding and putting tree mod seq elements and nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: set trans->drity in btrfs_commit_transaction

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix missing hole after hole punching and fsync when using NO_HOLES

Vasily Averin <vvs@virtuozzo.com>
    jbd2_seq_info_next should increase position index

Trond Myklebust <trondmy@gmail.com>
    NFS: Directory page cache pages need to be locked when read

Trond Myklebust <trondmy@gmail.com>
    NFS: Fix memory leaks and corruption in readdir

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix unbound NVME response length

Chuhong Yuan <hslester96@gmail.com>
    crypto: picoxcell - adjust the position of tasklet_init and fix missed tasklet_kill

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix race condition in crypto_spawn_alg

Tudor Ambarus <tudor.ambarus@microchip.com>
    crypto: atmel-aes - Fix counter overflow in CTR mode

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Do not clear MAY_SLEEP flag in original request

Ard Biesheuvel <ardb@kernel.org>
    crypto: ccp - set max RSA modulus size for v3 platform devices as well

Toke Høiland-Jørgensen <toke@redhat.com>
    samples/bpf: Don't try to remove user's homedir on clean

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Protect ftrace_graph_hash with ftrace_sync

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Add comment to why rcu_dereference_sched() is open coded

Amol Grover <frextrite@gmail.com>
    tracing: Annotate ftrace_graph_notrace_hash pointer with __rcu

Amol Grover <frextrite@gmail.com>
    tracing: Annotate ftrace_graph_hash pointer with __rcu

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Remove broken queue flushing

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: fix incorrect flush sequence when doing SSD mode commit

Mike Snitzer <snitzer@redhat.com>
    dm: fix potential for q->make_request_fn NULL pointer

Milan Broz <gmazyland@gmail.com>
    dm crypt: fix benbi IV constructor crash if used in authenticated mode

Joe Thornber <ejt@redhat.com>
    dm space map common: fix to ensure new block isn't already in use

Dmitry Fomichev <dmitry.fomichev@wdc.com>
    dm zoned: support zone sizes smaller than 128MiB

Michael Ellerman <mpe@ellerman.id.au>
    of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: core: Fix handling of devices deleted during system-wide resume

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: code cleanup for f2fs_statfs_project()

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: fix miscounted block limit in f2fs_statfs_project()

Chengguang Xu <cgxu519@mykernel.net>
    f2fs: choose hardlimit when softlimit is larger than hardlimit in f2fs_statfs_project()

Amir Goldstein <amir73il@gmail.com>
    ovl: fix wrong WARN_ON() in ovl_cache_update_ino()

Sven Van Asbroeck <thesven73@gmail.com>
    power: supply: ltc2941-battery-gauge: fix use-after-free

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix mtcp dump collection failure

Geert Uytterhoeven <geert+renesas@glider.be>
    scripts/find-unused-docs: Fix massive false positives

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix PM race condition

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix pm wrongful error reporting

Gilad Ben-Yossef <gilad@benyossef.com>
    crypto: ccree - fix backlog memory leak

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Check spawn->alg under lock in crypto_drop_spawn

Samuel Holland <samuel@sholland.org>
    mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as volatile

Tianyu Lan <Tianyu.Lan@microsoft.com>
    hv_balloon: Balloon up according to request page number

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    mmc: sdhci-of-at91: fix memleak on clk_get failure

Yurii Monakov <monakov.y@gmail.com>
    PCI: keystone: Fix link training retries initiation

Eric Biggers <ebiggers@google.com>
    crypto: geode-aes - convert to skcipher API and make thread-safe

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix deadlock in concurrent bulk-read and writepage

Eric Biggers <ebiggers@google.com>
    ubifs: Fix FS_IOC_SETFLAGS unexpectedly clearing encrypt flag

Eric Biggers <ebiggers@google.com>
    ubifs: don't trigger assertion on invalid no-key filename

Hou Tao <houtao1@huawei.com>
    ubifs: Reject unsupported ioctl flags explicitly

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

David Engraf <david.engraf@sysgo.com>
    PCI: tegra: Fix return value check of pm_runtime_get_sync()

Steve French <stfrench@microsoft.com>
    smb3: fix signing verification of large reads

Pingfan Liu <kernelfans@gmail.com>
    powerpc/pseries: Advance pfn if section is not present in lmb_is_removable()

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    powerpc/xmon: don't access ASDR in VMs

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/mm: fix dynamic pagetable upgrade for hugetlbfs

Alexander Lobakin <alobakin@dlink.ru>
    MIPS: boot: fix typo in 'vmlinux.lzma.its' target

Alexander Lobakin <alobakin@dlink.ru>
    MIPS: fix indentation of the 'RELOCS' message

Christoffer Dall <christoffer.dall@arm.com>
    KVM: arm64: Only sign-extend MMIO up to register width

Mark Rutland <mark.rutland@arm.com>
    KVM: arm/arm64: Correct AArch32 SPSR on exception entry

Mark Rutland <mark.rutland@arm.com>
    KVM: arm/arm64: Correct CPSR on exception entry

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Correct PSTATE on exception entry

Hans de Goede <hdegoede@redhat.com>
    ALSA: hda: Add Clevo W65_67SB the power_save blacklist

Mika Westerberg <mika.westerberg@linux.intel.com>
    platform/x86: intel_scu_ipc: Fix interrupt support

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

Dan Williams <dan.j.williams@intel.com>
    mm/memory_hotplug: fix remove_memory() lockdep splat

Takashi Iwai <tiwai@suse.de>
    ALSA: dummy: Fix PCM format loop in proc output

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix endianess in descriptor validation

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    usb: gadget: f_ecm: Use atomic_t to track in-flight request

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    usb: gadget: f_ncm: Use atomic_t to track in-flight request

Roger Quadros <rogerq@ti.com>
    usb: gadget: legacy: set max_speed to super-speed

Jun Li <jun.li@nxp.com>
    usb: typec: tcpci: mask event interrupts when remove driver

Navid Emamdoost <navid.emamdoost@gmail.com>
    brcmfmac: Fix memory leak in brcmf_usbdev_qinit

Eric Dumazet <edumazet@google.com>
    rcu: Avoid data-race in rcu_gp_fqs_check_wake()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    tracing: Fix sched switch start/stop refcount racy updates

Lu Shuaibing <shuaibinglu@126.com>
    ipc/msg.c: consolidate all xxxctl_down() functions

Oliver Neukum <oneukum@suse.com>
    mfd: dln2: More sanity checking for endpoints

Will Deacon <will@kernel.org>
    media: uvcvideo: Avoid cyclic entity chains due to malformed USB descriptors

David Howells <dhowells@redhat.com>
    rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect

David Howells <dhowells@redhat.com>
    rxrpc: Fix missing active use pinning of rxrpc_local object

David Howells <dhowells@redhat.com>
    rxrpc: Fix insufficient receive notification generation

David Howells <dhowells@redhat.com>
    rxrpc: Fix use-after-free in rxrpc_put_local()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->segs_{in|out} in tcp_disconnect()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->data_segs{in|out} in tcp_disconnect()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->delivered in tcp_disconnect()

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->total_retrans in tcp_disconnect()

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

Arnd Bergmann <arnd@arndb.de>
    sparc32: fix struct ipc64_perm type definition

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: fix NVM check for 3168 devices

John Ogness <john.ogness@linutronix.de>
    printk: fix exclusive_console replaying

Jan Kara <jack@suse.cz>
    udf: Allow writing to 'Rewritable' partitions

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR

Gang He <GHe@suse.com>
    ocfs2: fix oops when writing cloned file

Johan Hovold <johan@kernel.org>
    media: iguanair: fix endpoint sanity check

YueHaibing <yuehaibing@huawei.com>
    kernel/module: Fix memleak in module_add_modinfo_attrs()

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix lseek overflow on 32bit

Icenowy Zheng <icenowy@aosc.io>
    Revert "drm/sun4i: dsi: Change the start delay calculation"


-------------

Diffstat:

 Makefile                                           |    4 +-
 arch/arm/include/asm/kvm_emulate.h                 |   22 +
 arch/arm/include/asm/kvm_mmio.h                    |    2 +
 arch/arm/mach-tegra/sleep-tegra30.S                |   11 +
 arch/arm64/include/asm/kvm_emulate.h               |   37 +
 arch/arm64/include/asm/kvm_mmio.h                  |    6 +-
 arch/arm64/include/asm/ptrace.h                    |    1 +
 arch/arm64/include/uapi/asm/ptrace.h               |    1 +
 arch/arm64/kvm/inject_fault.c                      |   70 +-
 arch/mips/Makefile.postlink                        |    2 +-
 arch/mips/boot/Makefile                            |    2 +-
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/boot/4xx.c                            |    2 +-
 arch/powerpc/kvm/book3s_hv.c                       |    4 +-
 arch/powerpc/kvm/book3s_pr.c                       |    4 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |    4 +-
 arch/powerpc/xmon/xmon.c                           |    9 +-
 arch/s390/include/asm/page.h                       |    2 +
 arch/s390/kvm/kvm-s390.c                           |    6 +-
 arch/s390/mm/hugetlbpage.c                         |  100 +-
 arch/sparc/include/uapi/asm/ipcbuf.h               |   22 +-
 arch/x86/include/asm/apic.h                        |    8 +
 arch/x86/include/asm/kvm_host.h                    |    8 +-
 arch/x86/kernel/apic/msi.c                         |  128 +-
 arch/x86/kernel/cpu/tsx.c                          |   13 +-
 arch/x86/kvm/emulate.c                             |   27 +-
 arch/x86/kvm/hyperv.c                              |   10 +-
 arch/x86/kvm/i8259.c                               |    6 +-
 arch/x86/kvm/ioapic.c                              |   15 +-
 arch/x86/kvm/lapic.c                               |   13 +-
 arch/x86/kvm/mmu.c                                 |   78 +-
 arch/x86/kvm/mmutrace.h                            |   12 +-
 arch/x86/kvm/mtrr.c                                |    8 +-
 arch/x86/kvm/paging_tmpl.h                         |   25 +-
 arch/x86/kvm/pmu.h                                 |   18 +-
 arch/x86/kvm/pmu_intel.c                           |   24 +-
 arch/x86/kvm/vmx.c                                 |    4 +-
 arch/x86/kvm/vmx/vmx.c                             | 8033 ++++++++++++++++++++
 arch/x86/kvm/x86.c                                 |  101 +-
 arch/x86/kvm/x86.h                                 |    2 +-
 crypto/algapi.c                                    |   22 +-
 crypto/api.c                                       |    3 +-
 crypto/internal.h                                  |    1 -
 crypto/pcrypt.c                                    |    1 -
 drivers/acpi/battery.c                             |   75 +-
 drivers/acpi/video_detect.c                        |   13 +
 drivers/base/power/main.c                          |   42 +-
 drivers/clk/tegra/clk-tegra-periph.c               |    6 +-
 drivers/crypto/atmel-aes.c                         |   37 +-
 drivers/crypto/ccp/ccp-dev-v3.c                    |    1 +
 drivers/crypto/ccree/cc_driver.h                   |    1 +
 drivers/crypto/ccree/cc_pm.c                       |   30 +-
 drivers/crypto/ccree/cc_request_mgr.c              |   51 +-
 drivers/crypto/ccree/cc_request_mgr.h              |    8 -
 drivers/crypto/geode-aes.c                         |  442 +-
 drivers/crypto/geode-aes.h                         |   15 +-
 drivers/crypto/picoxcell_crypto.c                  |   15 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   13 +-
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     |    8 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   12 +
 drivers/gpu/drm/drm_rect.c                         |    7 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_dsi_encoder.c   |    2 +-
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c             |    3 +-
 drivers/hv/hv_balloon.c                            |   13 +-
 drivers/infiniband/core/umem_odp.c                 |    2 +-
 drivers/infiniband/hw/mlx5/gsi.c                   |    3 +-
 drivers/md/bcache/bcache.h                         |    3 +
 drivers/md/bcache/request.c                        |   17 +-
 drivers/md/bcache/sysfs.c                          |   22 +
 drivers/md/dm-crypt.c                              |   10 +-
 drivers/md/dm-writecache.c                         |   41 +-
 drivers/md/dm-zoned-metadata.c                     |   23 +-
 drivers/md/dm.c                                    |    9 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   27 +
 drivers/md/persistent-data/dm-space-map-common.h   |    2 +
 drivers/md/persistent-data/dm-space-map-disk.c     |    6 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |    5 +-
 drivers/media/rc/iguanair.c                        |    2 +-
 drivers/media/rc/rc-main.c                         |   27 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   12 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  148 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c          |    5 +-
 drivers/mfd/axp20x.c                               |    2 +-
 drivers/mfd/da9062-core.c                          |    2 +-
 drivers/mfd/dln2.c                                 |   13 +-
 drivers/mfd/rn5t618.c                              |    1 +
 drivers/mmc/host/mmc_spi.c                         |   11 +-
 drivers/mmc/host/sdhci-of-at91.c                   |    9 +-
 drivers/mtd/ubi/fastmap.c                          |   23 +-
 drivers/net/bonding/bond_alb.c                     |   44 +-
 drivers/net/dsa/b53/b53_common.c                   |    2 +-
 drivers/net/dsa/bcm_sf2.c                          |    4 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |    3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    2 +-
 drivers/net/ethernet/cadence/macb_main.c           |   14 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |    7 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |    4 +-
 drivers/net/ethernet/marvell/mvneta.c              |   27 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |    3 +-
 drivers/net/ethernet/smsc/smc911x.c                |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    4 +
 drivers/net/gtp.c                                  |    4 +-
 drivers/net/ppp/ppp_async.c                        |   18 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   10 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |    1 +
 drivers/nfc/pn544/pn544.c                          |    2 +-
 drivers/of/Kconfig                                 |    4 +
 drivers/of/address.c                               |    6 +-
 drivers/pci/controller/dwc/pci-keystone-dw.c       |    2 +-
 drivers/pci/controller/pci-tegra.c                 |    2 +-
 drivers/phy/qualcomm/phy-qcom-apq8064-sata.c       |    2 +-
 drivers/platform/x86/intel_scu_ipc.c               |   21 +-
 drivers/power/supply/ltc2941-battery-gauge.c       |    2 +-
 drivers/scsi/csiostor/csio_scsi.c                  |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |    6 -
 drivers/scsi/qla2xxx/qla_dbg.h                     |    6 +
 drivers/scsi/qla2xxx/qla_isr.c                     |   12 +
 drivers/scsi/qla2xxx/qla_mbx.c                     |    3 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |    7 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    2 +-
 drivers/scsi/ufs/ufshcd.c                          |    3 +
 drivers/usb/gadget/function/f_ecm.c                |   16 +-
 drivers/usb/gadget/function/f_ncm.c                |   17 +-
 drivers/usb/gadget/legacy/cdc2.c                   |    2 +-
 drivers/usb/gadget/legacy/g_ffs.c                  |    2 +-
 drivers/usb/gadget/legacy/multi.c                  |    2 +-
 drivers/usb/gadget/legacy/ncm.c                    |    2 +-
 drivers/usb/typec/tcpci.c                          |    6 +
 drivers/watchdog/watchdog_core.c                   |   35 +
 drivers/watchdog/watchdog_dev.c                    |   36 +-
 drivers/xen/xen-balloon.c                          |    2 +-
 fs/aio.c                                           |   20 +-
 fs/btrfs/ctree.c                                   |    8 +-
 fs/btrfs/ctree.h                                   |    6 +-
 fs/btrfs/delayed-ref.c                             |    8 +-
 fs/btrfs/disk-io.c                                 |   22 +-
 fs/btrfs/extent_io.c                               |    8 +
 fs/btrfs/tests/btrfs-tests.c                       |    1 -
 fs/btrfs/transaction.c                             |    8 +
 fs/btrfs/tree-log.c                                |  388 +-
 fs/cifs/smb2pdu.c                                  |   14 +-
 fs/eventfd.c                                       |   15 +
 fs/ext2/super.c                                    |    6 +-
 fs/ext4/page-io.c                                  |   19 +-
 fs/f2fs/super.c                                    |   14 +-
 fs/gfs2/file.c                                     |   72 +-
 fs/jbd2/journal.c                                  |    1 +
 fs/nfs/dir.c                                       |   47 +-
 fs/nfsd/nfs4layouts.c                              |    2 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/nfsd/state.h                                    |    2 +-
 fs/nfsd/vfs.c                                      |    1 +
 fs/ocfs2/file.c                                    |   14 +-
 fs/overlayfs/file.c                                |    2 +-
 fs/overlayfs/readdir.c                             |    8 +-
 fs/ubifs/dir.c                                     |    2 +
 fs/ubifs/file.c                                    |    4 +-
 fs/ubifs/ioctl.c                                   |   11 +-
 fs/udf/super.c                                     |    1 -
 include/linux/eventfd.h                            |   14 +
 include/linux/irq.h                                |   18 +
 include/linux/irqdomain.h                          |    7 +
 include/linux/kvm_host.h                           |    8 +-
 include/linux/memblock.h                           |   15 -
 include/linux/percpu-defs.h                        |    3 +-
 include/media/v4l2-rect.h                          |    8 +-
 include/net/ipx.h                                  |    5 -
 ipc/msg.c                                          |   19 +-
 kernel/events/core.c                               |   10 +-
 kernel/irq/debugfs.c                               |    1 +
 kernel/irq/irqdomain.c                             |    1 +
 kernel/irq/msi.c                                   |    5 +-
 kernel/module.c                                    |    2 +
 kernel/padata.c                                    |   46 +-
 kernel/printk/printk.c                             |    4 +-
 kernel/rcu/tree_plugin.h                           |   11 +-
 kernel/time/alarmtimer.c                           |    8 +-
 kernel/time/clocksource.c                          |   11 +-
 kernel/trace/ftrace.c                              |   15 +-
 kernel/trace/trace.h                               |   29 +-
 kernel/trace/trace_sched_switch.c                  |    4 +-
 lib/test_kasan.c                                   |    1 +
 mm/memory_hotplug.c                                |    9 +-
 mm/migrate.c                                       |   25 +-
 mm/page_alloc.c                                    |   64 +-
 net/hsr/hsr_slave.c                                |    2 +
 net/ipv4/tcp.c                                     |    6 +
 net/l2tp/l2tp_core.c                               |    7 +-
 net/rxrpc/af_rxrpc.c                               |    2 +
 net/rxrpc/ar-internal.h                            |   11 +
 net/rxrpc/call_object.c                            |    4 +-
 net/rxrpc/conn_client.c                            |    3 +-
 net/rxrpc/conn_event.c                             |   31 +-
 net/rxrpc/conn_object.c                            |    3 +-
 net/rxrpc/input.c                                  |    6 +-
 net/rxrpc/local_object.c                           |   23 +-
 net/rxrpc/output.c                                 |   27 +-
 net/rxrpc/peer_event.c                             |   42 +-
 net/sched/cls_rsvp.h                               |    6 +-
 net/sched/cls_tcindex.c                            |   43 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |    4 +
 samples/bpf/Makefile                               |    2 +-
 scripts/find-unused-docs.sh                        |    2 +-
 sound/drivers/dummy.c                              |    2 +-
 sound/pci/hda/hda_intel.c                          |    2 +
 sound/usb/validate.c                               |    6 +-
 tools/kvm/kvm_stat/kvm_stat                        |    8 +-
 virt/kvm/arm/aarch32.c                             |  117 +-
 virt/kvm/arm/mmio.c                                |    6 +
 virt/kvm/async_pf.c                                |   10 +-
 virt/kvm/kvm_main.c                                |    4 +-
 213 files changed, 10303 insertions(+), 1570 deletions(-)


