Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDF91B594F
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgDWKfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgDWKfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 06:35:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B70B52076C;
        Thu, 23 Apr 2020 10:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587638145;
        bh=et5WKsrIfhSSDUSG7KyrMJFE+xvtpwtPsfZQFXTrL94=;
        h=From:To:Cc:Subject:Date:From;
        b=YsUvL94PGvMVpiisQ4uge84wiEc74GwdmW6dRV9sud27VHTEGS9WfqB8XfnvRfEjb
         ZXF1KaFna5RsDLfM3mgjxgjH5/grtOaWQ3NFJzcGUwJlXjeny7eH9wxMRhilGI+hXM
         Yv+9TqtLmp0rv9KEJabjhyzqX3UYaQEqMQnuMx4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/198] 4.14.177-rc2 review
Date:   Thu, 23 Apr 2020 12:35:42 +0200
Message-Id: <20200423103335.768056640@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.177-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.177-rc2
X-KernelTest-Deadline: 2020-04-25T10:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.177 release.
There are 198 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Apr 2020 10:31:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.177-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.177-rc2

Waiman Long <longman@redhat.com>
    KEYS: Don't write out to userspace while holding key semaphore

David Howells <dhowells@redhat.com>
    KEYS: Use individual pages in big_key for crypto buffers

Wen Yang <wenyang@linux.alibaba.com>
    mtd: phram: fix a double free issue in error path

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: lpddr: Fix a double free in probe()

Paul E. McKenney <paulmck@kernel.org>
    locktorture: Print ratio of acquisitions, not failures

Stephen Rothwell <sfr@canb.auug.org.au>
    tty: evh_bytechan: Fix out of bounds accesses

Dan Carpenter <dan.carpenter@oracle.com>
    fbdev: potential information leak in do_fb_ioctl()

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix overflow checks

Adrian Huang <ahuang12@lenovo.com>
    iommu/amd: Fix the configuration of GCR3 table root pointer

Dan Carpenter <dan.carpenter@oracle.com>
    libnvdimm: Out of bounds read in __nd_ioctl()

Jan Kara <jack@suse.cz>
    ext2: fix debug reference to ext2_xattr_cache

Randy Dunlap <rdunlap@infradead.org>
    ext2: fix empty body warnings when -Wextra is used

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Fix mm reference leak

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

Jack Zhang <Jack.Zhang1@amd.com>
    drm/amdkfd: kfree the wrong pointer

Qian Cai <cai@lca.pw>
    x86: ACPI: fix CPU hotplug deadlock

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: Fix possible race when shadowing region 3 tables

Vegard Nossum <vegard.nossum@oracle.com>
    compiler.h: fix error in BUILD_BUG_ON() reporting

Qian Cai <cai@lca.pw>
    percpu_counter: fix a data race at vm_committed_as

Steven Price <steven.price@arm.com>
    include/linux/swapops.h: correct guards for non_swap_entry()

Eric Sandeen <sandeen@redhat.com>
    ext4: do not commit super on read-only bdev

Nathan Chancellor <natechancellor@gmail.com>
    powerpc/maple: Fix declaration made after definition

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/cpuinfo: fix wrong output when CPU0 is offline

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Return valid stateids in nfs_layout_find_inode_by_stateid()

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: 88pm860x: fix possible race condition

Lucas Stach <l.stach@pengutronix.de>
    soc: imx: gpc: fix power up sequencing

Sowjanya Komatineni <skomatineni@nvidia.com>
    clk: tegra: Fix Tegra PMC clock out parents

Dmitry Osipenko <digetx@gmail.com>
    power: supply: bq27xxx_battery: Silence deferred-probe error

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: usb: continue if clk_hw_round_rate() return zero

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak in of_unittest_platform_populate()

Ilya Dryomov <idryomov@gmail.com>
    rbd: call rbd_dev_unprobe() after unwatching and flushing notifies

Ilya Dryomov <idryomov@gmail.com>
    rbd: avoid a deadlock on header_rwsem when flushing notifies

Rob Herring <robh@kernel.org>
    of: fix missing kobject init for !SYSFS && OF_DYNAMIC config

Chris Lew <clew@codeaurora.org>
    soc: qcom: smem: Use le32_to_cpu for comparison

Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
    wil6210: abort properly in cfg suspend

Lior David <qca_liord@qca.qualcomm.com>
    wil6210: fix length check in __wmi_send

Lior David <qca_liord@qca.qualcomm.com>
    wil6210: add block size checks during FW load

Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
    wil6210: fix PCIe bus mastering in case of interface down

Bjorn Andersson <bjorn.andersson@linaro.org>
    rpmsg: glink: smem: Ensure ordering during tx

Wei Yongjun <weiyongjun1@huawei.com>
    rpmsg: glink: Fix missing mutex_init() in qcom_glink_alloc_channel()

Mohit Aggarwal <maggarwa@codeaurora.org>
    rtc: pm8xxx: Fix issue in RTC write path

Arvind Yadav <arvind.yadav.cs@gmail.com>
    rpmsg: glink: use put_device() if device_register fail

Dedy Lansky <dlansky@codeaurora.org>
    wil6210: rate limit wil_rx_refill error

Subhash Jadavani <subhashj@codeaurora.org>
    scsi: ufs: ufs-qcom: remove broken hci version quirk

Venkat Gopalakrishnan <venkatg@codeaurora.org>
    scsi: ufs: make sure all interrupts are processed

Dedy Lansky <dlansky@codeaurora.org>
    wil6210: fix temperature debugfs

Hamad Kadmany <hkadmany@codeaurora.org>
    wil6210: increase firmware ready timeout

Prasad Sodagudi <psodagud@codeaurora.org>
    arch_topology: Fix section miss match warning due to free_raw_capacity()

Will Deacon <will.deacon@arm.com>
    arm64: traps: Don't print stack or raw PC/LR values in backtraces

Xu YiPing <xuyiping@hisilicon.com>
    arm64: perf: remove unsupported events for Cortex-A73

Timur Tabi <timur@codeaurora.org>
    Revert "gpio: set up initial state from .get_direction()"

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: Fix debugfs_create_*() usage

Joe Moriarty <joe.moriarty@oracle.com>
    drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem

Nathan Chancellor <natechancellor@gmail.com>
    video: fbdev: sis: Remove unnecessary parentheses and commented code

ndesaulniers@google.com <ndesaulniers@google.com>
    lib/raid6: use vdupq_n_u8 to avoid endianness warnings

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Don't release card at firmware loading error

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/mbigen: Free msi_desc on device teardown

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: report EOPNOTSUPP on unsupported flags/object type

Luke Nelson <lukenels@cs.washington.edu>
    arm, bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0

Roman Gushchin <guro@fb.com>
    ext4: use non-movable memory for superblock readahead

Li Bin <huawei.libin@huawei.com>
    scsi: sg: add sg_remove_request in sg_common_write

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix switch table detection in .text.unlikely

Austin Kim <austindh.kim@gmail.com>
    mm/vmalloc.c: move 'area->pages' after if statement

Reinette Chatre <reinette.chatre@intel.com>
    x86/resctrl: Fix invalid attempt at removing the default resource group

James Morse <james.morse@arm.com>
    x86/resctrl: Preserve CDP enable over CPU hotplug

Fenghua Yu <fenghua.yu@intel.com>
    x86/intel_rdt: Enable L2 CDP in MSR IA32_L2_QOS_CFG

Fenghua Yu <fenghua.yu@intel.com>
    x86/intel_rdt: Add two new resources for L2 Code and Data Prioritization (CDP)

Fenghua Yu <fenghua.yu@intel.com>
    x86/intel_rdt: Enumerate L2 Code and Data Prioritization (CDP) feature

John Allen <john.allen@amd.com>
    x86/microcode/AMD: Increase microcode PATCH_MAX_SIZE

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: fix hang when multiple threads try to destroy the same iscsi session

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: remove boilerplate code

Jim Mattson <jmattson@google.com>
    kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD

Goldwyn Rodrigues <rgoldwyn@suse.com>
    dm flakey: check for null arg_name in parse_features()

Jan Kara <jack@suse.cz>
    ext4: do not zeroout extents beyond i_disksize

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    mac80211_hwsim: Use kstrndup() in place of kasprintf()

Josef Bacik <josef@toxicpanda.com>
    btrfs: check commit root generation in should_ignore_root

Xiao Yang <yangx.jy@cn.fujitsu.com>
    tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't override ignore_ctl_error value from the map

Colin Ian King <colin.king@canonical.com>
    ASoC: Intel: mrfld: return error codes when an error occurs

Colin Ian King <colin.king@canonical.com>
    ASoC: Intel: mrfld: fix incorrect check on p->sink

Josh Triplett <josh@joshtriplett.org>
    ext4: fix incorrect inodes per group in error message

Josh Triplett <josh@joshtriplett.org>
    ext4: fix incorrect group count in ext4_fill_super error message

Sven Van Asbroeck <TheSven73@gmail.com>
    pwm: pca9685: Fix PWM/GPIO inter-operation

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: improve comments about freeing data buffers whose page mapping is NULL

Can Guo <cang@codeaurora.org>
    scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Florian Fainelli <f.fainelli@gmail.com>
    net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    net: revert default NAPI poll timeout to 2 jiffies

Wang Wenhu <wenhu.wang@vivo.com>
    net: qrtr: send msgs from local of same id as broadcast

Tim Stallard <code@timstallard.me.uk>
    net: ipv6: do not consider routes via gateways for anycast address check

Taras Chornyi <taras.chornyi@plvision.eu>
    net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin

Taehee Yoo <ap420073@gmail.com>
    hsr: check protocol version in hsr_newlink()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    amd-xgbe: Use __napi_schedule() in BH context

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: dln2: Fix sanity checking for endpoints

Nathan Chancellor <natechancellor@gmail.com>
    misc: echo: Remove unnecessary parentheses and simplify check for zero

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Wen Yang <wenyang@linux.alibaba.com>
    ipmi: fix hung processes in __get_guid()

Masami Hiramatsu <mhiramat@kernel.org>
    ftrace/kprobe: Show the maxactive number on kprobe_events

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Remove PageReserved manipulation from drm_pci_alloc

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Fix clearing payload state on topology disable

Andrei Botila <andrei.botila@nxp.com>
    crypto: caam - update xts sector size for large input length

Bob Liu <bob.liu@oracle.com>
    dm zoned: remove duplicate nr_rnd_zones increase in dmz_init_zone()

Josef Bacik <josef@toxicpanda.com>
    btrfs: use nofs allocations for running delayed items

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix crash during unmount due to race with delayed inode workers

Clement Courbet <courbet@google.com>
    powerpc: Make setjmp/longjmp signature standard

Segher Boessenkool <segher@kernel.crashing.org>
    powerpc: Add attributes for setjmp/longjmp

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kprobes: Ignore traps that happened in real mode

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Use XIVE_BAD_IRQ instead of zero to catch non configured IPIs

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/hash64/devmap: Use H_PAGE_THP_HUGE when setting up huge devmap PTE entries

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64/tm: Don't let userspace set regs->trap via sigreturn

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv/idle: Restore AMR/UAMOR/AMOR after idle

Kai-Heng Feng <kai.heng.feng@canonical.com>
    libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DFLAG_DETACH is set

Simon Gander <simon@tuxera.com>
    hfsplus: fix crash and filesystem corruption when deleting files

Oliver O'Halloran <oohall@gmail.com>
    cpufreq: powernv: Fix use-after-free

Eric Biggers <ebiggers@google.com>
    kmod: make request_module() return an error when autoloading is disabled

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

Qian Cai <cai@lca.pw>
    ext4: fix a data race at inode->i_blocks

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a page leak in nfs_destroy_unlinked_subrequests()

Nathan Chancellor <natechancellor@gmail.com>
    rtc: omap: Use define directive for PIN_CONFIG_ACTIVE_HIGH

Fredrik Strupe <fredrik@strupe.net>
    arm64: armv8_deprecated: Fix undef_hook mask for thumb setend

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix missing erp_lock in port recovery trigger for point-to-point

Shetty, Harshini X (EXT-Sony Mobile) <Harshini.X.Shetty@sony.com>
    dm verity fec: fix memory leak in verity_fec_dtr

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    mm: Use fixed constant in page_frag_alloc instead of size + 1

Anssi Hannula <anssi.hannula@bitwise.fi>
    tools: gpio: Fix out-of-tree build regression

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    x86/speculation: Remove redundant arch_smt_update() invocation

YueHaibing <yuehaibing@huawei.com>
    powerpc/pseries: Drop pointless static qualifier in vpa_debugfs_init()

Roopa Prabhu <roopa@cumulusnetworks.com>
    net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_flags

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Initialize power_state field properly

Rosioru Dragos <dragos.rosioru@nxp.com>
    crypto: mxs-dcp - fix scatterlist linearization for hash

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop block from cache on error in relocation

Yilu Lin <linyilu@huawei.com>
    CIFS: Fix bug which the return value by asynchronous read is error

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: VMX: fix crash cleanup when KVM wasn't used

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

Thomas Gleixner <tglx@linutronix.de>
    x86/entry/32: Add missing ASM_CLAC to general_protection entry

Eric W. Biederman <ebiederm@xmission.com>
    signal: Extend exec_id to 64bits

Remi Pommarel <repk@triplefau.lt>
    ath9k: Handle txpower changes even when TPC is disabled

Gustavo A. R. Silva <gustavo@embeddedor.com>
    MIPS: OCTEON: irq: Fix potential NULL pointer dereference

Sungbo Eo <mans0n@gorani.run>
    irqchip/versatile-fpga: Apply clear-mask earlier

Yang Xu <xuyang2018.jy@cn.fujitsu.com>
    KEYS: reaching the keys quotas correctly

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: endpoint: Fix for concurrent memory allocation in OB address region

Yicong Yang <yangyicong@hisilicon.com>
    PCI/ASPM: Clear the correct bits when enabling L1 substates

James Smart <jsmart2021@gmail.com>
    nvme-fc: Revert "add module to ops template to allow module references"

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=n

Jan Engelhardt <jengelh@inai.de>
    acpi/x86: ignore unspecified bit positions in the ACPI global lock field

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: cal: fix disable_irqs to only the intended target

Thomas Hebb <tommyhebb@gmail.com>
    ALSA: hda/realtek - Set principled PC Beep configuration for ALC256

Thomas Hebb <tommyhebb@gmail.com>
    ALSA: doc: Document PC Beep Hidden Register on Realtek ALC256

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

Kees Cook <keescook@chromium.org>
    slub: improve bit diffusion for freelist ptr obfuscation

YueHaibing <yuehaibing@huawei.com>
    misc: rtsx: set correct pcr_ops for rts522A

Yury Norov <yury.norov@gmail.com>
    uapi: rename ext2_swab() to swab() and share globally in swab.h

Josef Bacik <josef@toxicpanda.com>
    btrfs: track reloc roots based on their commit root bytenr

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove a BUG_ON() from merge_reloc_roots()

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    block, bfq: fix use-after-free in bfq_idle_slice_timer_body

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v4: Provide irq_retrigger to avoid circular locking dependency

Neil Armstrong <narmstrong@baylibre.com>
    usb: dwc3: core: add support for disabling SS instances in park mode

Sahitya Tummala <stummala@codeaurora.org>
    block: Fix use-after-free issue accessing struct io_cq

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    genirq/irqdomain: Check pointer in irq_domain_alloc_irqs_hierarchy()

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Ignore the memory attributes table on i386

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot: Use unsigned comparison for addresses

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't demote a glock until its revokes are written

John Garry <john.garry@huawei.com>
    libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()

Logan Gunthorpe <logang@deltatee.com>
    PCI/switchtec: Fix init_completion race condition with poll_wait()

Andy Lutomirski <luto@kernel.org>
    selftests/x86/ptrace_syscall_32: Fix no-vDSO segfault

Michael Wang <yun.wang@linux.alibaba.com>
    sched: Avoid scale real weight down to zero

Sungbo Eo <mans0n@gorani.run>
    irqchip/versatile-fpga: Handle chained IRQs properly

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    block: keep bdi->io_pages in sync with max_sectors_kb for stacked devices

Thomas Hellstrom <thellstrom@vmware.com>
    x86: Don't let pgprot_modify() change the page encryption bit

Alexey Dobriyan <adobriyan@gmail.com>
    null_blk: fix spurious IO errors after failed past-wp access

Bart Van Assche <bvanassche@acm.org>
    null_blk: Handle null_add_dev() failures properly

Bart Van Assche <bvanassche@acm.org>
    null_blk: Fix the null_add_dev() error path

Alain Volmat <avolmat@me.com>
    i2c: st: fix missing struct parameter description

Xu Wang <vulab@iscas.ac.cn>
    qlcnic: Fix bad kzalloc null test

Raju Rangoju <rajur@chelsio.com>
    cxgb4/ptp: pass the sign of offset delta in FW CMD

Luo bin <luobin9@huawei.com>
    hinic: fix wrong para of wait_for_completion_timeout

Luo bin <luobin9@huawei.com>
    hinic: fix a bug of waitting for IO stopped

Zheng Wei <wei.zheng@vivo.com>
    net: vxge: fix wrong __VA_ARGS__ usage

Ondrej Jirman <megous@megous.com>
    bus: sunxi-rsb: Return correct data when mixing 16-bit and 8-bit reads


-------------

Diffstat:

 Documentation/sound/hd-audio/index.rst             |   1 +
 Documentation/sound/hd-audio/realtek-pc-beep.rst   | 129 ++++++++++++++++++++
 Makefile                                           |   4 +-
 arch/arm/net/bpf_jit_32.c                          |  12 +-
 arch/arm64/kernel/armv8_deprecated.c               |   2 +-
 arch/arm64/kernel/perf_event.c                     |   6 -
 arch/arm64/kernel/process.c                        |   8 +-
 arch/arm64/kernel/traps.c                          |  65 +---------
 arch/mips/cavium-octeon/octeon-irq.c               |   3 +
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |   6 +
 arch/powerpc/include/asm/book3s/64/hash-64k.h      |   8 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   4 +-
 arch/powerpc/include/asm/book3s/64/radix.h         |   5 +
 arch/powerpc/include/asm/setjmp.h                  |   6 +-
 arch/powerpc/kernel/Makefile                       |   3 -
 arch/powerpc/kernel/idle_book3s.S                  |  27 ++++-
 arch/powerpc/kernel/kprobes.c                      |   3 +
 arch/powerpc/kernel/signal_64.c                    |   4 +-
 arch/powerpc/mm/tlb_nohash_low.S                   |  12 +-
 arch/powerpc/platforms/maple/setup.c               |  34 +++---
 arch/powerpc/platforms/pseries/lpar.c              |   2 +-
 arch/powerpc/sysdev/xive/common.c                  |  12 +-
 arch/powerpc/sysdev/xive/native.c                  |   4 +-
 arch/powerpc/sysdev/xive/spapr.c                   |   4 +-
 arch/powerpc/sysdev/xive/xive-internal.h           |   7 ++
 arch/powerpc/xmon/Makefile                         |   3 -
 arch/s390/kernel/diag.c                            |   2 +-
 arch/s390/kernel/processor.c                       |   5 +-
 arch/s390/kvm/vsie.c                               |   1 +
 arch/s390/mm/gmap.c                                |   7 +-
 arch/x86/boot/compressed/head_32.S                 |   2 +-
 arch/x86/boot/compressed/head_64.S                 |   4 +-
 arch/x86/entry/entry_32.S                          |   1 +
 arch/x86/include/asm/cpufeatures.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/microcode_amd.h               |   2 +-
 arch/x86/include/asm/pgtable.h                     |   7 +-
 arch/x86/include/asm/pgtable_types.h               |   2 +-
 arch/x86/kernel/acpi/boot.c                        |   2 +-
 arch/x86/kernel/acpi/cstate.c                      |   3 +-
 arch/x86/kernel/cpu/intel_rdt.c                    |  68 +++++++++--
 arch/x86/kernel/cpu/intel_rdt.h                    |   6 +
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c           | 133 ++++++++++++++++-----
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kvm/cpuid.c                               |   3 +-
 arch/x86/kvm/vmx.c                                 | 106 ++++++----------
 arch/x86/kvm/x86.c                                 |  21 +++-
 block/bfq-iosched.c                                |  16 ++-
 block/blk-ioc.c                                    |   7 ++
 block/blk-settings.c                               |   3 +
 drivers/acpi/processor_throttling.c                |   7 --
 drivers/ata/libata-pmp.c                           |   1 +
 drivers/ata/libata-scsi.c                          |   9 +-
 drivers/base/arch_topology.c                       |   2 +-
 drivers/block/null_blk.c                           |  10 +-
 drivers/block/rbd.c                                |  25 ++--
 drivers/bus/sunxi-rsb.c                            |   2 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   4 +-
 drivers/clk/at91/clk-usb.c                         |   3 +
 drivers/clk/clk.c                                  |  32 +++--
 drivers/clk/tegra/clk-tegra-pmc.c                  |  12 +-
 drivers/cpufreq/powernv-cpufreq.c                  |   6 +
 drivers/crypto/caam/caamalg_desc.c                 |  16 ++-
 drivers/crypto/mxs-dcp.c                           |  58 +++++----
 drivers/firmware/efi/efi.c                         |   2 +-
 drivers/gpio/gpiolib.c                             |  31 ++---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   4 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  15 ++-
 drivers/gpu/drm/drm_pci.c                          |  25 +---
 drivers/i2c/busses/i2c-st.c                        |   1 +
 drivers/input/serio/i8042-x86ia64io.h              |  11 ++
 drivers/iommu/amd_iommu_types.h                    |   2 +-
 drivers/iommu/intel-svm.c                          |   7 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   6 +
 drivers/irqchip/irq-mbigen.c                       |   8 +-
 drivers/irqchip/irq-versatile-fpga.c               |  18 ++-
 drivers/md/dm-flakey.c                             |   5 +
 drivers/md/dm-verity-fec.c                         |   1 +
 drivers/md/dm-zoned-metadata.c                     |   1 -
 drivers/media/platform/ti-vpe/cal.c                |  16 +--
 drivers/mfd/dln2.c                                 |   9 +-
 drivers/mfd/rts5227.c                              |   1 +
 drivers/misc/echo/echo.c                           |   2 +-
 drivers/mtd/devices/phram.c                        |  15 ++-
 drivers/mtd/lpddr/lpddr_cmds.c                     |   1 -
 drivers/net/dsa/bcm_sf2_cfp.c                      |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c     |   3 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |   3 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |  51 +-------
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |   5 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.h   |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h     |  14 +--
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |   2 +
 drivers/net/wireless/ath/ath9k/main.c              |   3 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   7 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   7 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c          |  58 +++++----
 drivers/net/wireless/ath/wil6210/interrupt.c       |  22 +++-
 drivers/net/wireless/ath/wil6210/main.c            |   2 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |  24 ++--
 drivers/net/wireless/ath/wil6210/pm.c              |  10 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |   4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |   5 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |  13 +-
 drivers/net/wireless/mac80211_hwsim.c              |  12 +-
 drivers/nvdimm/bus.c                               |   6 +-
 drivers/nvme/host/fc.c                             |  14 +--
 drivers/nvme/target/fcloop.c                       |   1 -
 drivers/of/base.c                                  |   3 -
 drivers/of/unittest.c                              |   7 +-
 drivers/pci/endpoint/pci-epc-mem.c                 |  10 +-
 drivers/pci/pcie/aspm.c                            |   4 +-
 drivers/pci/switch/switchtec.c                     |   2 +-
 drivers/power/supply/bq27xxx_battery.c             |   5 +-
 drivers/pwm/pwm-pca9685.c                          |  85 +++++++------
 drivers/rpmsg/qcom_glink_native.c                  |   1 +
 drivers/rpmsg/qcom_glink_smem.c                    |   6 +-
 drivers/rtc/rtc-88pm860x.c                         |  14 ++-
 drivers/rtc/rtc-omap.c                             |   4 +-
 drivers/rtc/rtc-pm8xxx.c                           |  49 ++++++--
 drivers/s390/scsi/zfcp_erp.c                       |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   2 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   8 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   1 -
 drivers/scsi/sg.c                                  |   4 +-
 drivers/scsi/ufs/ufs-qcom.c                        |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  32 +++--
 drivers/soc/imx/gpc.c                              |  24 ++--
 drivers/soc/qcom/smem.c                            |   2 +-
 drivers/target/iscsi/iscsi_target.c                |  79 ++++--------
 drivers/target/iscsi/iscsi_target.h                |   1 -
 drivers/target/iscsi/iscsi_target_configfs.c       |   5 +-
 drivers/target/iscsi/iscsi_target_login.c          |   5 +-
 drivers/tty/ehv_bytechan.c                         |  21 +++-
 drivers/usb/dwc3/core.c                            |   5 +
 drivers/usb/dwc3/core.h                            |   4 +
 drivers/usb/gadget/composite.c                     |   9 ++
 drivers/usb/gadget/function/f_fs.c                 |   1 +
 drivers/video/fbdev/core/fbmem.c                   |   2 +-
 drivers/video/fbdev/sis/init301.c                  |   4 +-
 fs/btrfs/async-thread.c                            |   8 ++
 fs/btrfs/async-thread.h                            |   2 +
 fs/btrfs/delayed-inode.c                           |  13 ++
 fs/btrfs/disk-io.c                                 |  13 ++
 fs/btrfs/relocation.c                              |  39 +++---
 fs/buffer.c                                        |  11 ++
 fs/cifs/file.c                                     |   2 +-
 fs/exec.c                                          |   2 +-
 fs/ext2/xattr.c                                    |   8 +-
 fs/ext4/extents.c                                  |   8 +-
 fs/ext4/inode.c                                    |   4 +-
 fs/ext4/super.c                                    |  11 +-
 fs/filesystems.c                                   |   4 +-
 fs/gfs2/glock.c                                    |   3 +
 fs/hfsplus/attributes.c                            |   4 +
 fs/jbd2/commit.c                                   |   7 +-
 fs/nfs/callback_proc.c                             |   2 +
 fs/nfs/direct.c                                    |   2 +
 fs/nfs/pagelist.c                                  |  17 ++-
 fs/nfs/write.c                                     |   1 +
 fs/ocfs2/alloc.c                                   |   4 +
 include/acpi/processor.h                           |   8 ++
 include/keys/big_key-type.h                        |   2 +-
 include/keys/user-type.h                           |   3 +-
 include/linux/buffer_head.h                        |   8 ++
 include/linux/compiler.h                           |   2 +-
 include/linux/devfreq_cooling.h                    |   2 +-
 include/linux/iocontext.h                          |   1 +
 include/linux/key-type.h                           |   2 +-
 include/linux/nvme-fc-driver.h                     |   4 -
 include/linux/pci-epc.h                            |   3 +
 include/linux/percpu_counter.h                     |   4 +-
 include/linux/sched.h                              |   4 +-
 include/linux/swab.h                               |   1 +
 include/linux/swapops.h                            |   3 +-
 include/net/ip6_route.h                            |   1 +
 include/target/iscsi/iscsi_target_core.h           |   2 +-
 include/uapi/linux/swab.h                          |  10 ++
 kernel/cpu.c                                       |   5 +-
 kernel/irq/irqdomain.c                             |  10 +-
 kernel/kmod.c                                      |   4 +-
 kernel/locking/lockdep.c                           |   4 +
 kernel/locking/locktorture.c                       |   8 +-
 kernel/sched/sched.h                               |   8 +-
 kernel/signal.c                                    |   2 +-
 kernel/trace/trace_events_trigger.c                |  10 +-
 kernel/trace/trace_kprobe.c                        |   2 +
 lib/find_bit.c                                     |  16 +--
 lib/raid6/neon.uc                                  |   5 +-
 lib/raid6/recov_neon_inner.c                       |   7 +-
 mm/page_alloc.c                                    |   8 +-
 mm/slub.c                                          |   2 +-
 mm/vmalloc.c                                       |   8 +-
 net/core/dev.c                                     |   3 +-
 net/core/rtnetlink.c                               |   2 +-
 net/dns_resolver/dns_key.c                         |   2 +-
 net/hsr/hsr_netlink.c                              |  10 +-
 net/ipv4/devinet.c                                 |  13 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/qrtr/qrtr.c                                    |   7 +-
 net/rxrpc/key.c                                    |  27 ++---
 security/keys/big_key.c                            | 119 +++++++++++++-----
 security/keys/encrypted-keys/encrypted.c           |   7 +-
 security/keys/key.c                                |   2 +-
 security/keys/keyctl.c                             |  77 +++++++++---
 security/keys/keyring.c                            |   6 +-
 security/keys/request_key_auth.c                   |   7 +-
 security/keys/trusted.c                            |  14 +--
 security/keys/user_defined.c                       |   5 +-
 sound/core/oss/pcm_plugin.c                        |  32 +++--
 sound/pci/hda/hda_beep.c                           |   6 +-
 sound/pci/hda/hda_codec.c                          |   1 +
 sound/pci/hda/hda_intel.c                          |  35 +++---
 sound/pci/hda/patch_realtek.c                      |  15 ++-
 sound/pci/ice1712/prodigy_hifi.c                   |   4 +-
 sound/soc/intel/atom/sst-atom-controls.c           |   2 +-
 sound/soc/intel/atom/sst/sst_pci.c                 |   2 +-
 sound/soc/soc-dapm.c                               |   8 +-
 sound/soc/soc-ops.c                                |   4 +-
 sound/soc/soc-pcm.c                                |   6 +-
 sound/soc/soc-topology.c                           |   2 +-
 sound/usb/mixer.c                                  |   2 +-
 sound/usb/mixer_maps.c                             |  28 +++++
 tools/gpio/Makefile                                |   2 +-
 tools/objtool/check.c                              |   5 +-
 tools/perf/Makefile.config                         |  11 +-
 tools/testing/selftests/x86/ptrace_syscall.c       |   8 +-
 229 files changed, 1638 insertions(+), 996 deletions(-)


