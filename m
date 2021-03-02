Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ACA32B2AD
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343898AbhCCAxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1444899AbhCBTbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 14:31:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94A6864F2D;
        Tue,  2 Mar 2021 19:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614713345;
        bh=8R3MIXMnZPXR4zqyPF/VnhySj3lYEDb2ltqi3aJUe4o=;
        h=From:To:Cc:Subject:Date:From;
        b=ZZqMNQA7r58JXNG2n7KTBI8Mlid/rPtsuNTAESuq6resGnPE722ajxiIQf4CYEkar
         F3W5WmYkEE0GiVFqQt7hAgo9srxfEMFWyy7iJu6J8PqUeITSVT9mvnnJuWuPel0vhX
         DTGyoNVB9rFgZ6CPUKVkgdk+M8dDZNMwacTORnxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 000/773] 5.11.3-rc3 review
Date:   Tue,  2 Mar 2021 20:29:01 +0100
Message-Id: <20210302192719.741064351@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.11.3-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.3-rc3
X-KernelTest-Deadline: 2021-03-04T19:27+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.3 release.
There are 773 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.3-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.3-rc3

Cong Wang <cong.wang@bytedance.com>
    net_sched: fix RTNL deadlock again caused by request_module()

Takeshi Misawa <jeliantsurux@gmail.com>
    net: qrtr: Fix memory leak in qrtr_tun_open

Vlad Buslov <vladbu@nvidia.com>
    net: sched: fix police ext initialization

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: queueing: get rid of per-peer ring buffers

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: test multiple parallel streams

Jason A. Donenfeld <Jason@zx2c4.com>
    net: icmp: pass zeroed opts from icmp{,v6}_ndo_send before sending

Leon Romanovsky <leon@kernel.org>
    ipv6: silence compilation warning for non-IPV6 builds

Sumit Garg <sumit.garg@linaro.org>
    kgdb: fix to kill breakpoints on initmem after boot

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Reject 446-480MHz HDMI clock on GLK

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: only resize metadata in preresume

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Reinitialize bitset cache before digesting a new writeset

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Use correct value size in equality function of writeset tree

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Fix bitset memory leaks

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Verify the data block size hasn't changed

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Update in-core bitset after committing the metadata

Nikos Tsironis <ntsironis@arrikto.com>
    dm era: Recover committed writeset after crash

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: fix writing beyond end of underlying device when shrinking

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: return the exact table values that were set

Mikulas Patocka <mpatocka@redhat.com>
    dm writecache: fix performance degradation in ssd mode

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix zoned iterate_devices based device capability checks

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix DAX iterate_devices based device capability checks

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix iterate_devices based device capability checks

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix deadlock when swapping to encrypted device

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Recursive gfs2_quota_hold in gfs2_iomap_end

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Lock imbalance on error path in gfs2_recover_one

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't skip dlm unlock if glock has an lvb

Bob Peterson <rpeterso@redhat.com>
    gfs2: fix glock confusion in function signal_our_withdraw

Masahisa Kojima <masahisa.kojima@linaro.org>
    spi: spi-synquacer: fix set_cs handling

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    spi: fsl: invert spisel_boot signal on MPC8309

Paul Cercueil <paul@crapouillou.net>
    perf stat: Use nftw() instead of ftw()

Al Viro <viro@zeniv.linux.org.uk>
    sparc32: fix a user-triggerable oops in clear_user()

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix handling of escaped ',' in the password mount argument

Paulo Alcantara <pc@cjr.nz>
    cifs: fix nodfs mount option

Paulo Alcantara <pc@cjr.nz>
    cifs: introduce helper for finding referral server to improve DFS target resolution

Paulo Alcantara <pc@cjr.nz>
    cifs: check all path components in resolved dfs target

Paulo Alcantara <pc@cjr.nz>
    cifs: fix DFS failover

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: flush data when enabling checkpoint back

Chao Yu <chao@kernel.org>
    f2fs: enforce the immutable flag on open files

Chao Yu <chao@kernel.org>
    f2fs: fix out-of-repair __setattr_copy()

Huacai Chen <chenhuacai@kernel.org>
    irqchip/loongson-pch-msi: Use bitmap_zalloc() to allocate bitmap

Johannes Berg <johannes.berg@intel.com>
    um: defer killing userspace on page table update failures

Johannes Berg <johannes.berg@intel.com>
    um: mm: check more comprehensively for stub changes

Cornelia Huck <cohuck@redhat.com>
    virtio/s390: implement virtio-ccw revision 2 correctly

Heiko Carstens <hca@linux.ibm.com>
    s390/vtime: fix inline assembly clobber list

Jens Axboe <axboe@kernel.dk>
    proc: don't allow async path resolution of /proc/thread-self components

Chen Yu <yu.c.chen@intel.com>
    cpufreq: intel_pstate: Get per-CPU max freq via MSR_HWP_CAPABILITIES if available

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Change intel_pstate_get_hwp_max() argument

Shawn Guo <shawn.guo@linaro.org>
    cpufreq: qcom-hw: drop devm_xxx() calls from init/exit hooks

Viresh Kumar <viresh.kumar@linaro.org>
    thermal: cpufreq_cooling: freq_qos_update_request() returns < 0 on error

Chris Wilson <chris@chris-wilson.co.uk>
    kcmp: Support selection of SYS_kcmp without CHECKPOINT_RESTORE

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    zonefs: Fix file size of zones in full condition

Namjae Jeon <namjae.jeon@samsung.com>
    exfat: fix shift-out-of-bounds in exfat_fill_super()

Muchun Song <songmuchun@bytedance.com>
    printk: fix deadlock when kernel panic

Tim Harvey <tharvey@gateworks.com>
    mfd: gateworks-gsc: Fix interrupt type

Maxim Kiselev <bigunclemax@gmail.com>
    gpio: pcf857x: Fix missing first interrupt

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add adler lake point LP DID

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add adler lake point S DID

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: emmitsburg workstation DID

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: fix transfer over dma with extended header

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: block send with vtag on non-conformat FW

Subbaraman Narayanamurthy <subbaram@codeaurora.org>
    spmi: spmi-pmic-arb: Fix hw_irq overflow

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Add missing call to kuep_lock on syscall entry

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/kexec_file: fix FDT size estimation for kdump kernel

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Preserve cr1 in exception prolog stack check to fix build error

Shirley Her <shirley.her@bayhubtech.com>
    mmc: sdhci-pci-o2micro: Bug fix for SDR104 HW tuning failure

Frank Li <Frank.Li@nxp.com>
    mmc: sdhci-esdhc-imx: fix kernel panic when remove module

Fangrui Song <maskray@google.com>
    module: Ignore _GLOBAL_OFFSET_TABLE_ when warning for undefined symbols

Subbaraman Narayanamurthy <subbaram@codeaurora.org>
    nvmem: qcom-spmi-sdam: Fix uninitialized pdev pointer

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nSVM: fix running nested guests when npt=0

Vlastimil Babka <vbabka@suse.cz>
    mm, compaction: make fast_isolate_freepages() stay within zone

Dave Hansen <dave.hansen@linux.intel.com>
    mm/vmscan: restore zone_reclaim_mode ABI

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix copy_huge_page_from_user contig page struct assumption

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix update_and_free_page contig page struct assumption

Muchun Song <songmuchun@bytedance.com>
    mm: memcontrol: fix get_active_memcg return value

Muchun Song <songmuchun@bytedance.com>
    mm: memcontrol: fix swap undercounting in cgroup2

NeilBrown <neilb@suse.de>
    x86: fix seq_file iteration for pat/memtype.c

NeilBrown <neilb@suse.de>
    seq_file: document how per-entry resources are managed.

Pan Bian <bianpan2016@163.com>
    fs/affs: release old buffer head on error path

Pan Bian <bianpan2016@163.com>
    mtd: spi-nor: hisi-sfc: Put child node np on error path

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: core: Add erase size check for erase command initialization

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: core: Fix erase type discovery for overlaid region

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: sfdp: Fix wrong erase type bitmask for overlaid region

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: sfdp: Fix last erase region marking

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Handle accesses to TRCSTALLCTLR

Alexander Usyskin <alexander.usyskin@intel.com>
    watchdog: mei_wdt: request stop on unregister

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    watchdog: qcom: Remove incorrect usage of QCOM_WDT_ENABLE_IRQ

Tobias Klauser <tklauser@distanz.ch>
    riscv: Disable KSAN_SANITIZE for vDSO

Will Deacon <will@kernel.org>
    arm64: spectre: Prevent lockdep splat on v4 mitigation enable path

Shaoying Xu <shaoyi@amazon.com>
    arm64 module: set plt* section addresses to 0x0

He Zhe <zhe.he@windriver.com>
    arm64: uprobe: Return EOPNOTSUPP for AARCH32 instruction probing

qiuguorui1 <qiuguorui1@huawei.com>
    arm64: kexec_file: fix memory leakage in create_dtb() when fdt_open_into() fails

Viresh Kumar <viresh.kumar@linaro.org>
    mailbox: arm_mhuv2: Skip calling kfree() with invalid pointer

Isaac J. Manjarres <isaacm@codeaurora.org>
    iommu/arm-smmu-qcom: Fix mask extraction for bootloader programmed SMRs

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix to delay the kprobes jump optimization

Frederic Weisbecker <frederic@kernel.org>
    entry/kvm: Explicitly flush pending rcuog wakeup before last rescheduling point

Frederic Weisbecker <frederic@kernel.org>
    entry: Explicitly flush pending rcuog wakeup before last rescheduling point

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Trigger self-IPI on late deferred wake up before user resume

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Perform deferred wake up before last idle's need_resched() check

Frederic Weisbecker <frederic@kernel.org>
    rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers

Cédric Le Goater <clg@kaod.org>
    powerpc/prom: Fix "ibm,arch-vec-5-platform-support" scan

Thomas Gleixner <tglx@linutronix.de>
    x86/entry: Fix instrumentation annotation

Andy Lutomirski <luto@kernel.org>
    x86/fault: Fix AMD erratum #91 errata fixup for user code

Sean Christopherson <seanjc@google.com>
    x86/reboot: Force all cpus to exit VMX root if VMX is supported

Sean Christopherson <seanjc@google.com>
    x86/virt: Eat faults on VMXOFF in reboot flows

Sean Young <sean@mess.org>
    media: smipcie: fix interrupt handling and IR timeout

Lubomir Rintel <lkundrak@v3.sk>
    media: marvell-ccic: power up the device on mclk enable

Pavel Machek <pavel@denx.de>
    media: ipu3-cio2: Fix mbus_code processing in cio2_subdev_set_fmt()

Sean Young <sean@mess.org>
    media: ir_toy: add another IR Droid device

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: ioctl: Fix memory leak in video_usercopy

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: max9286: fix access to unallocated memory

Jiri Kosina <jkosina@suse.cz>
    floppy: reintroduce O_NDELAY fix

Martin Kaiser <martin@kaiser.cx>
    staging: rtl8188eu: Add Edimax EW-7811UN V2 to device table

Amey Narkhede <ameynarkhede03@gmail.com>
    staging: gdm724x: Fix DMA from stack

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    staging/mt7621-dma: mtk-hsdma.c->hsdma-mt7621.c

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: agilex: fix phy interface bit shift for gmac1 and gmac2

Frank Wunderlich <frank-w@public-files.de>
    dts64: mt7622: fix slow sd card access

Jiri Bohac <jbohac@suse.cz>
    pstore: Fix typo in compression option name

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    drivers/misc/vmw_vmci: restrict too big queue size in qp_host_alloc_queue

Ricky Wu <ricky_wu@realtek.com>
    misc: rtsx: init of rts522a add OCP power off when no card is present

Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
    arm64: ptrace: Fix seccomp of traced syscall -1 (NO_SYSCALL)

Paul Cercueil <paul@crapouillou.net>
    seccomp: Add missing return in non-void function

Krzysztof Kozlowski <krzk@kernel.org>
    soc: samsung: exynos-asv: handle reading revision register error

Marek Szyprowski <m.szyprowski@samsung.com>
    soc: samsung: exynos-asv: don't defer early on not-supported SoCs

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - initialize need_fallback

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - handle BigEndian for cipher

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - IV register does not work on A10 and A13

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - checking sg length is not sufficient

Ard Biesheuvel <ardb@kernel.org>
    crypto: michael_mic - fix broken misalignment handling

Ard Biesheuvel <ardb@kernel.org>
    crypto: aesni - prevent misaligned buffers on the stack

Ard Biesheuvel <ardb@kernel.org>
    crypto: arm64/sha - add missing module aliases

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Correct surface base address for renderclear

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Flush before changing register state

Filipe Manana <fdmanana@suse.com>
    btrfs: fix extent buffer leak on failure to copy root

Josef Bacik <josef@toxicpanda.com>
    btrfs: account for new extents being deleted in total_bytes_pinned

Josef Bacik <josef@toxicpanda.com>
    btrfs: handle space_info::total_bytes_pinned inside the delayed ref itself

Josef Bacik <josef@toxicpanda.com>
    btrfs: splice remaining dirty_bg's onto the transaction dirty bg list

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix reloc root leak with 0 ref reloc roots on recovery

Josef Bacik <josef@toxicpanda.com>
    btrfs: abort the transaction if we fail to inc ref in btrfs_copy_root

Josef Bacik <josef@toxicpanda.com>
    btrfs: add asserts for deleting backref cache nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not warn if we can't find the reloc root when looking up backref

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not cleanup upper nodes in btrfs_backref_cleanup_node

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Reserve TPM for seal and unseal operations

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix migratable=1 failing

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix incorrect handling of tpm_get_random()

James Bottomley <James.Bottomley@HansenPartnership.com>
    tpm_tis: Clean up locality release

James Bottomley <James.Bottomley@HansenPartnership.com>
    tpm_tis: Fix check_locality for correct locality acquisition

Gao Xiang <hsiangkao@redhat.com>
    erofs: initialized fields can only be observed after bit is set

Amir Goldstein <amir73il@gmail.com>
    selinux: fix inconsistency between inode_getxattr and inode_listsecurity

Takashi Iwai <tiwai@suse.de>
    ASoC: siu: Fix build error by a wrong const prefix

Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
    drm/rockchip: Require the YTR modifier for AFBC

Heiko Stuebner <heiko@sntech.de>
    drm/panel: kd35t133: allow using non-continuous dsi clock

Andrey Grodzovsky <andrey.grodzovsky@amd.com>
    drm/sched: Cancel and flush all outstanding jobs before finish.

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/modes: Switch to 64bit maths to avoid integer overflow

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/kms: handle mDP connectors

xinhui pan <xinhui.pan@amd.com>
    drm/ttm: Fix a memory leak

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: fix shutdown and poweroff process failed with s0ix

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Set reference clock to 100Mhz on Renoir (v2)

Marek Olšák <marek.olsak@amd.com>
    drm/amdgpu: fix CGTS_TCC_DISABLE register offset on gfx10.3

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: Fix recursive lock warnings

Anson Jacob <Anson.Jacob@amd.com>
    Revert "drm/amd/display: reuse current context instead of recreating one"

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Add vupdate_no_lock interrupts for DCN2.1

Eric Bernstein <eric.bernstein@amd.com>
    drm/amd/display: Remove Assert from dcn10_get_dig_frontend

Jan Kokemüller <jan.kokemueller@gmail.com>
    drm/amd/display: Add FPU wrappers to dcn21_validate_bandwidth()

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amd/display: Update NV1x SR latency values"

Kai Krakow <kai@kaishome.de>
    bcache: Move journal work to new flush wq

Kai Krakow <kai@kaishome.de>
    bcache: Give btree_io_wq correct semantics again

Kai Krakow <kai@kaishome.de>
    Revert "bcache: Kill btree_io_wq"

Alexander Lobakin <alobakin@pm.me>
    MIPS: compressed: fix build with enabled UBSAN

Kevin Hao <haokexin@gmail.com>
    Revert "MIPS: Octeon: Remove special handling of CONFIG_MIPS_ELF_APPENDED_DTB=y"

Nathan Chancellor <nathan@kernel.org>
    MIPS: VDSO: Use CLANG_FLAGS instead of filtering out '--target='

Aurelien Jarno <aurelien@aurel32.net>
    MIPS: Support binutils configured with --enable-mips-fix-loongson3-llsc=yes

Paul Cercueil <paul@crapouillou.net>
    MIPS: Ingenic: Disable HPTLB for D0 XBurst CPUs too

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup

PeiSen Hou <pshou@realtek.com>
    ALSA: hda/realtek: modify EAPD in the ALC886

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Drop bogus check at closing a stream

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: Add another CometLake-H PCI ID

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: fireface: fix to parse sync status register of latter protocol

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add implicit fb quirk for BOSS GP-10

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Don't avoid stopping the stream at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: More strict state change in EP

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Handle invalid running state at releasing EP

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct document for snd_usb_endpoint_free_all()

Mathias Kresin <dev@kresin.me>
    phy: lantiq: rcu-usb2: wait after clock enable

Dan Carpenter <dan.carpenter@oracle.com>
    USB: serial: mos7720: fix error code in mos7720_write()

Dan Carpenter <dan.carpenter@oracle.com>
    USB: serial: mos7840: fix error code in mos7840_write()

Johan Hovold <johan@kernel.org>
    USB: serial: pl2303: fix line-speed handling on newer chips

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix FTX sub-integer prescaler

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix dep->interval for fullspeed interrupt

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix setting of DEPCFG.bInterval_m1

Paul Cercueil <paul@crapouillou.net>
    usb: musb: Fix runtime PM race in musb_queue_resume_work

Lech Perczak <lech.perczak@gmail.com>
    USB: serial: option: update interface mapping for ZTE P685M

James Reynolds <jr@memlen.com>
    media: mceusb: Fix potential out-of-bounds shift

Marcos Paulo de Souza <mpdesouza@suse.com>
    Input: i8042 - add ASUS Zenbook Flip to noselftest list

Dan Carpenter <dan.carpenter@oracle.com>
    Input: joydev - prevent potential read overflow in ioctl

Olivier Crête <olivier.crete@ocrete.ca>
    Input: xpad - add support for PowerA Enhanced Wired Controller for Xbox Series X|S

jeffrey.lin <jeffrey.lin@rad-ic.com>
    Input: raydium_ts_i2c - do not send zero length

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Ignore attempts to overwrite the touch_max value from HID

Filipe Laíns <lains@riseup.net>
    HID: logitech-dj: add support for keyboard events in eQUAD step 4 Gaming

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: ACPI: Set cpuinfo.max_freq directly if max boost is known

Qinglang Miao <miaoqinglang@huawei.com>
    ACPI: configfs: add missing check after configfs_register_default_group()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: property: Fix fwnode string properties matching

Marcin Ślusarz <marcin.slusarz@intel.com>
    soundwire: intel: fix possible crash when no device is detected

Mikulas Patocka <mpatocka@redhat.com>
    blk-settings: align max_sectors on "logical_block_size" boundary

Bart Van Assche <bvanassche@acm.org>
    scsi: sd: Fix Opal support

Finn Thain <fthain@telegraphics.com.au>
    ide/falconide: Fix module unload

Ming Lei <ming.lei@redhat.com>
    block: fix logging on capacity change

Christoph Hellwig <hch@lst.de>
    block: reopen the device in blkdev_reread_part

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    scsi: sd: sd_zbc: Don't pass GFP_NOIO to kvcalloc

Randy Dunlap <rdunlap@infradead.org>
    scsi: bnx2fc: Fix Kconfig warning & CNIC build errors

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    csky: Fix a size determination in gpr_get()

Josef Bacik <josef@toxicpanda.com>
    proc: use kvzalloc for our kernel buffer

Miaohe Lin <linmiaohe@huawei.com>
    mm/rmap: fix potential pte_unmap on an not mapped pte

Dan Williams <dan.j.williams@intel.com>
    mm: fix memory_failure() handling of dax-namespace metadata

Rik van Riel <riel@surriel.com>
    mm,thp,shmem: make khugepaged obey tmpfs mount flags

Mårten Lindahl <martenli@axis.com>
    i2c: exynos5: Preserve high speed master code

Maxime Ripard <maxime@cerno.tech>
    i2c: brcmstb: Fix brcmstd_send_i2c_cmd condition

Marc Zyngier <maz@kernel.org>
    arm64: Add missing ISB after invalidating TLB in __primary_switch

YueHaibing <yuehaibing@huawei.com>
    cifs: Fix inconsistent IS_ERR and PTR_ERR

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Expand collapsible SPTE zap for TDP MMU to ZONE_DEVICE and HugeTLB pages

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Intercept INVPCID when it's disabled to inject #UD

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fixes for nfs4_bitmask_adjust()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix jumbo packet handling on RTL8168e

Christian Melki <christian.melki@t2data.com>
    net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081

Wonhyuk Yang <vvghjk1234@gmail.com>
    mm/compaction: fix misbehaviors of fast_find_migrateblock()

Chen Wandun <chenwandun@huawei.com>
    mm/hugetlb: suppress wrong warning info when alloc gigantic page

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix potential double free in hugetlb_register_node() error path

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory.c: fix potential pte_unmap_unlock pte error

Muchun Song <songmuchun@bytedance.com>
    mm: memcontrol: fix slub memory accounting

Muchun Song <songmuchun@bytedance.com>
    mm: memcontrol: fix NR_ANON_THPS accounting in charge moving

Dan Carpenter <dan.carpenter@oracle.com>
    ocfs2: fix a use after free on error

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: kconfig: use arm chacha even with no neon

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: device: do not generate ICMP for non-IP packets

Taehee Yoo <ap420073@gmail.com>
    vxlan: move debug check after netdev unregister

Chen-Yu Tsai <wens@csie.org>
    PCI: rockchip: Make 'ep-gpios' DT property optional

Chuhong Yuan <hslester96@gmail.com>
    net/mlx4_core: Add missed mlx4_free_cmd_mailbox()

Song, Yoong Siang <yoong.siang.song@intel.com>
    net: stmmac: fix CBS idleslope and sendslope calculation

Camelia Groza <camelia.groza@nxp.com>
    dpaa_eth: fix the access method for the dpaa_napi_portal

Henry Tieman <henry.w.tieman@intel.com>
    ice: update the number of available RSS queues

Dave Ertman <david.m.ertman@intel.com>
    ice: Fix state bits on LLDP mode switch

Brett Creeley <brett.creeley@intel.com>
    ice: Account for port VLAN in VF max packet size calculation

Dave Ertman <david.m.ertman@intel.com>
    ice: report correct max number of TCs

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: iqs620a: Fix overflow and optimize calculations

Dan Carpenter <dan.carpenter@oracle.com>
    octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()

Norbert Ciosek <norbertx.ciosek@intel.com>
    i40e: Fix endianness conversions

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix add TC filter for IPv6

Andreas Oetken <andreas.oetken@siemens.com>
    nios2: fixed broken sys_clone syscall

Jann Horn <jannh@google.com>
    Take mmap lock in cacheflush syscall

Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
    i40e: Fix VFs not created

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix addition of RX filters after enabling FW LLDP agent

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Fix overwriting flow control settings during driver loading

Mateusz Palczewski <mateusz.palczewski@intel.com>
    i40e: Add zero-initialization of AQ command structures

Slawomir Laba <slawomirx.laba@intel.com>
    i40e: Fix flow for IPv6 next header (extension header)

Krzysztof Wilczyński <kw@linux.com>
    PCI: cadence: Fix DMA range mapping early return error

Russell King <rmk+kernel@armlinux.org.uk>
    PCI: pci-bridge-emul: Fix array overruns, improve safety

Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
    device-dax: Fix default return code of range_parse()

Magnum Shan <magnum.shan@unisoc.com>
    mailbox: sprd: correct definition of SPRD_OUTBOX_FIFO_FULL

Geert Uytterhoeven <geert@linux-m68k.org>
    ext: EXT4_KUNIT_TESTS should depend on EXT4_FS instead of selecting it

Bard Liao <yung-chuan.liao@linux.intel.com>
    regmap: sdw: use _no_pm functions in regmap_read/write

Loic Poulain <loic.poulain@linaro.org>
    mhi: Fix double dma free

Tzung-Bi Shih <tzungbi@google.com>
    remoteproc/mediatek: acknowledge watchdog IRQ after handled

Jonathan Marek <jonathan@marek.ca>
    misc: fastrpc: fix incorrect usage of dma_map_sgtable

Stephen Boyd <swboyd@chromium.org>
    drm/msm/dp: Add a missing semi-colon

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: bus: fix confusion on device used by pm_runtime

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: export sdw_write/read_no_pm functions

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: bus: use sdw_write_no_pm when setting the bus scale registers

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: bus: use sdw_update_no_pm when initializing a device

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix legacy relocs path

Ahmad Fatoum <a.fatoum@pengutronix.de>
    nvmem: core: skip child nodes not matching binding

Dan Carpenter <dan.carpenter@oracle.com>
    nvmem: core: Fix a resource leak on error in nvmem_add_cells_from_of()

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Skip accessing TRCPDCR in save/restore

Geert Uytterhoeven <geert+renesas@glider.be>
    phy: USB_LGM_PHY should depend on X86

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential htree index checksum corruption

Max Gurtovoy <mgurtovoy@nvidia.com>
    vfio-pci/zdev: fix possible segmentation fault issue

Keqian Zhu <zhukeqian1@huawei.com>
    vfio/iommu_type1: Fix some sanity checks in detach group

Keqian Zhu <zhukeqian1@huawei.com>
    vfio/iommu_type1: Populate full dirty when detach non-pinned group

Judy Hsiao <judyhsiao@google.com>
    drm/msm/dp: trigger unplug event in msm_dp_display_disable

Stephen Boyd <swboyd@chromium.org>
    drm/msm/kms: Make a lock_class_key for each crtc mutex

Eric Anholt <eric@anholt.net>
    drm/msm: Fix races managing the OOB state for timestamp vs timestamps.

Eric Anholt <eric@anholt.net>
    drm/msm: Fix race of GPU init vs timestamp power management.

Iskren Chernev <iskren.chernev@gmail.com>
    drm/msm/mdp5: Fix wait-for-commit for cmd panels

Konrad Dybcio <konrad.dybcio@somainline.org>
    drm/msm/dsi: Correct io_start for MSM8994 (20nm PHY)

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    drm/msm: Add proper checks for GPU LLCC support

Iskren Chernev <iskren.chernev@gmail.com>
    drm/msm: Fix MSM_INFO_GET_IOVA with carveout

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: hbm: call mei_set_devstate() on hbm stop response

Heiner Kallweit <hkallweit1@gmail.com>
    PCI: Align checking of syscall user config accessors

Jorgen Hansen <jhansen@vmware.com>
    VMCI: Use set_page_dirty_lock() when unregistering guest memory

Pan Bian <bianpan2016@163.com>
    PCI: xilinx-cpm: Fix reference count leak on error path

Simon South <simon@simonsouth.net>
    pwm: rockchip: Eliminate potential race condition when probing

Simon South <simon@simonsouth.net>
    pwm: rockchip: rockchip_pwm_probe(): Remove superfluous clk_unprepare()

Simon South <simon@simonsouth.net>
    pwm: rockchip: Enable APB clock during register access while probing

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence: fix ACK/NAK handling

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: debugfs: use controller id instead of link_id

Marek Vasut <marek.vasut+renesas@gmail.com>
    PCI: rcar: Always allocate MSI addresses in 32bit space

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Add module alias to avoid breaking support for non device tree users

Dan Carpenter <dan.carpenter@oracle.com>
    phy: cadence-torrent: Fix error code in cdns_torrent_phy_probe()

Chris Ruehl <chris.ruehl@gtsys.com.hk>
    phy: rockchip-emmc: emmc_phy_init() always return 0

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Fix module alias to enable module autoprobe

Geert Uytterhoeven <geert+renesas@glider.be>
    Input: st1232 - fix NORMAL vs. IDLE state handling

Randy Dunlap <rdunlap@infradead.org>
    ARM: 9065/1: OABI compat: fix build when EPOLL is not enabled

Michael Tretter <m.tretter@pengutronix.de>
    Input: st1232 - add IDLE state as ready condition

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: zinitix - fix return type of zinitix_init_touch()

Randy Dunlap <rdunlap@infradead.org>
    sparc: fix led.c driver when PROC_FS is not enabled

Randy Dunlap <rdunlap@infradead.org>
    sparc64: only select COMPAT_BINFMT_ELF if BINFMT_ELF is set

Dan Carpenter <dan.carpenter@oracle.com>
    Input: elo - fix an error code in elo_connect()

Namhyung Kim <namhyung@kernel.org>
    perf test: Fix unaligned access in sample parsing test

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix IPC with CYC threshold

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix premature IPC

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix missing CYC processing in PSB

Dave Rigby <d.rigby@me.com>
    perf unwind: Set userdata for all __report_module() paths

Yang Jihong <yangjihong1@huawei.com>
    perf record: Fix continue profiling after draining the buffer

Dan Carpenter <dan.carpenter@oracle.com>
    Input: sur40 - fix an error code in sur40_probe()

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-srv: Do not pass a valid pointer to PTR_ERR()

Gioh Kim <gi-oh.kim@cloud.ionos.com>
    RDMA/rtrs-srv-sysfs: fix missing put_device

Gioh Kim <gi-oh.kim@cloud.ionos.com>
    RDMA/rtrs-srv: fix memory leak by missing kobject free

Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
    RDMA/rtrs: Only allow addition of path to an already established session

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-srv: Fix stack-out-of-bounds

Avihai Horon <avihaih@nvidia.com>
    RDMA/ucma: Fix use-after-free bug in ucma_create_uevent

Lang Cheng <chenglang@huawei.com>
    RDMA/hns: Fixes missing error code of CMDQ

Jeff Layton <jlayton@kernel.org>
    ceph: fix flush_snap logic after putting caps

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Hold private mutex while invoking rdma_accept()

J. Bruce Fields <bfields@redhat.com>
    nfsd: register pernet ops last, unregister first

Nicholas Fraser <nfraser@codeweavers.com>
    perf symbols: Fix return value when loading PE DSO

John Ogness <john.ogness@linutronix.de>
    printk: avoid prb_first_valid_seq() where possible

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    spi: Skip zero-length transfers in spi_transfer_one_message()

Kees Cook <keescook@chromium.org>
    spi: dw: Avoid stack content exposure

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    regulator: bd718x7, bd71828, Fix dvs voltage levels

Dmitry Safonov <0x7f454c46@gmail.com>
    perf symbols: Use (long) for iterator for bfd symbols

Tom Zanussi <zanussi@kernel.org>
    selftests/ftrace: Update synthetic event syntax errors

Ryan Chen <ryan_chen@aspeedtech.com>
    clk: aspeed: Fix APLL calculate formula from ast2600-A2

Jonathan Marek <jonathan@marek.ca>
    regulator: qcom-rpmh: fix pm8009 ldo7

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/kuap: Restore AMR after replaying soft interrupts

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/uaccess: Avoid might_fault() when user access is enabled

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: pxa2xx: Fix the controller numbering for Wildcat Point

Michael Tretter <m.tretter@pengutronix.de>
    clk: divider: fix initialization with parent_hw

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Disable RQ inline by default

Xi Wang <wangxi11@huawei.com>
    RDMA/hns: Add mapped page count checking for MTR

Weihang Li <liweihang@huawei.com>
    RDMA/hns: Fix type of sq_signal_bits

Weihang Li <liweihang@huawei.com>
    RDMA/hns: Avoid filling sgid index when modifying QP to RTR

Kamal Heib <kamalheib1@gmail.com>
    RDMA/siw: Fix calculation of tx_valid_cpus size

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Remove the reserved WQE of SRQ

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fixed wrong judgments in the goto branch

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Force srq_limit to 0 when creating SRQ

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Bugfix for checking whether the srq is full when post wr

Lang Cheng <chenglang@huawei.com>
    RDMA/hns: Allocate one more recv SGE for HIP08

John Stultz <john.stultz@linaro.org>
    kselftests: dmabuf-heaps: Fix Makefile's inclusion of the kernel's usr/include dir

Daniel Latypov <dlatypov@google.com>
    kunit: tool: fix unit test cleanup handling

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    clk: qcom: gcc-msm8998: Fix Alpha PLL type for all GPLLs

Taniya Das <tdas@codeaurora.org>
    clk: qcom: gcc-sc7180: Mark the MM XO clocks to be always ON

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    clk: qcom: gfm-mux: fix clk mask

Sandipan Das <sandipan@linux.ibm.com>
    powerpc/sstep: Fix darn emulation

Sandipan Das <sandipan@linux.ibm.com>
    powerpc/sstep: Fix load-store and update emulation

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Fix software emulation interrupt

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/dlpar: handle ibm, configure-connector delay status

Dan Carpenter <dan.carpenter@oracle.com>
    mfd: wm831x-auxadc: Prevent use after free in wm831x_auxadc_read_irq()

Arnd Bergmann <arnd@arndb.de>
    mfd: altera-sysmgr: Fix physical address storing more

Alain Volmat <alain.volmat@foss.st.com>
    spi: stm32: properly handle 0 byte transfer

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Correct skb on loopback path

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix coding error in rxe_rcv_mcast_pkt

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix coding error in rxe_recv.c

John Garry <john.garry@huawei.com>
    perf vendor events arm64: Fix Ampere eMag event typo

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Fix DSO filtering when not finding a map for a sampled address

David E. Box <david.e.box@linux.intel.com>
    platform/x86: intel_pmt_crashlog: Add dependency on MFD_INTEL_PMT

David E. Box <david.e.box@linux.intel.com>
    platform/x86: intel_pmt_telemetry: Add dependency on MFD_INTEL_PMT

David E. Box <david.e.box@linux.intel.com>
    platform/x86: intel_pmt: Make INTEL_PMT_CLASS non-user-selectable

David Gow <davidgow@google.com>
    rtc: zynqmp: depend on HAS_IOMEM

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracepoint: Do not fail unregistering a probe due to memory failure

Parav Pandit <parav@nvidia.com>
    IB/cm: Avoid a loop when device has 255 ports

Parav Pandit <parav@nvidia.com>
    IB/mlx5: Return appropriate error code instead of ENOMEM

Douglas Anderson <dianders@chromium.org>
    iommu: Properly pass gfp_t in _iommu_map() to avoid atomic sleeping

Yong Wu <yong.wu@mediatek.com>
    iommu: Move iotlb_sync_map out from __iommu_map

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    amba: Fix resource leak for drivers without .remove

David Gow <davidgow@google.com>
    i3c/master/mipi-i3c-hci: Specify HAS_IOMEM dependency

Roja Rani Yarubandi <rojay@codeaurora.org>
    i2c: i2c-qcom-geni: Add shutdown callback for i2c

Roja Rani Yarubandi <rojay@codeaurora.org>
    i2c: qcom-geni: Store DMA mapping data in geni_i2c_dev struct

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 9046/1: decompressor: Do not clear SCTLR.nTLSMD for ARMv7+ cores

Takeshi Saito <takeshi.saito.xv@renesas.com>
    mmc: renesas_sdhi_internal_dmac: Fix DMA buffer alignment from 8 to 128-bytes

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: usdhi6rol0: Fix a resource leak in the error handling path of the probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: sdhci-sprd: Fix some resource leaks in the remove function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: owl-mmc: Fix a resource leak in an error handling path and in the remove function

Michal Suchanek <msuchanek@suse.de>
    powerpc: Fix build error in paravirt.h

Pingfan Liu <kernelfans@gmail.com>
    powerpc/time: Enable sched clock for irqtime

Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
    powerpc/sstep: Fix incorrect return from analyze_instr()

Ananth N Mavinakayanahalli <ananth@linux.ibm.com>
    powerpc/sstep: Check instruction validity against ISA version before emulation

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/47x: Disable 256k page size

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/kvm: Force selection of CONFIG_PPC_FPU

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Make the VMX instruction emulation routines static

Shay Drory <shayd@nvidia.com>
    IB/umad: Return EPOLLERR in case of when device disassociated

Shay Drory <shayd@nvidia.com>
    IB/umad: Return EIO in case of when device disassociated

Mark Bloch <mbloch@nvidia.com>
    RDMA/mlx5: Allow creating all QPs even when non RDMA profile is used

Maor Gottlieb <maorg@nvidia.com>
    tools/testing/scatterlist: Fix overflow of max segment size

Yong Wu <yong.wu@mediatek.com>
    iommu: Switch gather->end to the inclusive end

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: lpfc: Fix ancient double free

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix ".cold" section suffix check for newer versions of GCC

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix retpoline detection in asm code

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix error handling for STD/CLD warnings

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: Fix duplicate CHARLCD config symbol

Geert Uytterhoeven <geert@linux-m68k.org>
    auxdisplay: ht16k33: Fix refresh rate handling

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    watchdog: intel-mid_wdt: Postpone IRQ handler registration till SCU is ready

Pan Bian <bianpan2016@163.com>
    isofs: release buffer head before return

Hans de Goede <hdegoede@redhat.com>
    regulator: core: Avoid debugfs: Directory ... already present! error

Dmitry Osipenko <digetx@gmail.com>
    power: supply: smb347-charger: Fix interrupt usage if interrupt is unavailable

Samuel Holland <samuel@sholland.org>
    power: supply: axp20x_usb_power: Init work before enabling IRQs

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: isci: Pass gfp_t flags in isci_port_bc_change_received()

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: isci: Pass gfp_t flags in isci_port_link_up()

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: isci: Pass gfp_t flags in isci_port_link_down()

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: mvsas: Pass gfp_t flags to libsas event notifiers

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: libsas: Introduce a _gfp() variant of event notifiers

John Garry <john.garry@huawei.com>
    scsi: libsas: Remove notifier indirection

Krzysztof Kozlowski <krzk@kernel.org>
    regulator: s5m8767: Drop regulators OF node reference

Pan Bian <bianpan2016@163.com>
    spi: atmel: Put allocated master before return

Pan Bian <bianpan2016@163.com>
    regulator: s5m8767: Fix reference count leak

David Howells <dhowells@redhat.com>
    certs: Fix blacklist flag type confusion

Gabriel Krisman Bertazi <krisman@collabora.com>
    watch_queue: Drop references to /dev/watch_queue

Pan Bian <bianpan2016@163.com>
    regulator: axp20x: Fix reference cout leak

Evan Benn <evanbenn@chromium.org>
    platform/chrome: cros_ec_proto: Add LID and BATTERY to default mask

Evan Benn <evanbenn@chromium.org>
    platform/chrome: cros_ec_proto: Use EC_HOST_EVENT_MASK not BIT

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: h6: Fix clock divider range on some clocks

Parav Pandit <parav@nvidia.com>
    IB/mlx5: Add mutex destroy call to cap_mask_mutex mutex

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Use the correct obj_id upon DEVX TIR creation

Guido Günther <agx@sigxcpu.org>
    spi: imx: Don't print error on -EPROBEDEFER

Frank van der Linden <fllinden@amazon.com>
    module: harden ELF info handling

Tom Rix <trix@redhat.com>
    clocksource/drivers/mxs_timer: Add missing semicolon when DEBUG is defined

Arnd Bergmann <arnd@arndb.de>
    clocksource/drivers/ixp4xx: Select TIMER_OF when needed

Randy Dunlap <rdunlap@infradead.org>
    power: supply: fix sbs-charger build, needs REGMAP_I2C

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: set DMA channel to be private

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    rtc: s5m: select REGMAP_I2C

Claudiu Beznea <claudiu.beznea@microchip.com>
    power: reset: at91-sama5d2_shdwc: fix wkupdbc mask

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs: Fix KASAN: stack-out-of-bounds bug

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-srv: Init wr_cnt as 1

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    RDMA/rtrs-clt: Refactor the failure cases in alloc_clt

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-srv: Fix missing wr_cqe

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    RDMA/rtrs: Call kobject_put in the failure path

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    RDMA/rtrs-srv: Jump to dereg_mr label if allocate iu fails

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-clt: Set mininum limit when create QP

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-srv: Use sysfs_remove_file_self for disconnect

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-srv: Release lock before call into close_sess

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs: Extend ibtrs_cq_qp_create

Nicolas Boichat <drinkcat@chromium.org>
    of/fdt: Make sure no-map does not remove already reserved regions

KarimAllah Ahmed <karahmed@amazon.de>
    fdt: Properly handle "no-map" field in the memory region

Colin Ian King <colin.king@canonical.com>
    power: supply: cpcap-charger: Fix power_supply_put on null battery pointer

Can Guo <cang@codeaurora.org>
    scsi: ufs: Fix a possible NULL pointer issue

Tony Lindgren <tony@atomide.com>
    power: supply: cpcap-battery: Fix missing power_supply_put()

Tony Lindgren <tony@atomide.com>
    power: supply: cpcap-charger: Fix missing power_supply_put()

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    mfd: bd9571mwv: Use devm_mfd_add_devices()

Ferry Toth <ftoth@exalondelft.nl>
    dmaengine: hsu: disable spurious interrupt

Vignesh Raghavendra <vigneshr@ti.com>
    dmaengine: ti: k3-udma: Set rflow count for BCDMA split channels

Nathan Chancellor <nathan@kernel.org>
    dmaengine: qcom: Always inline gpi_update_reg

Arnd Bergmann <arnd@arndb.de>
    rtc: rx6110: fix build against modular I2C

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: owl-dma: Fix a resource leak in the remove function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: fsldma: Fix a resource leak in an error handling path of the probe function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: fsldma: Fix a resource leak in the remove function

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix handling of zero-sized Read and Receive Queues.

Randy Dunlap <rdunlap@infradead.org>
    HID: core: detect and skip invalid inputs to snto32()

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a779a0: Fix parent of CBFUSA clock

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a779a0: Remove non-existent S2 clock

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: h6: Fix CEC clock

Pratyush Yadav <p.yadav@ti.com>
    spi: cadence-quadspi: Abort read if dummy cycles required are too many

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    i2c: iproc: handle master read request

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    i2c: iproc: update slave isr mask (ISR_MASK_SLAVE)

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    i2c: iproc: handle only slave interrupts which are enabled

Jan Kara <jack@suse.cz>
    quota: Fix memory leak when handling corrupted quota file

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qrb5165-rb5: fix pm8009 regulators

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    regulator: qcom-rpmh-regulator: add pm8009-1 chip revision

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests/powerpc: Make the test check in eeh-basic.sh posix compliant

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: clk-pll: propagate the error from meson_clk_pll_set_rate()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: clk-pll: make "ret" a signed integer

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: clk-pll: fix initializing the old rate (fallback) for a PLL

Tony Lindgren <tony@atomide.com>
    power: supply: cpcap: Add missing IRQF_ONESHOT to fix regression

Zhang Qilong <zhangqilong3@huawei.com>
    HSI: Fix PM usage counter unbalance in ssi_hw_init

Eric W. Biederman <ebiederm@xmission.com>
    capabilities: Don't allow writing ambiguous v3 file capabilities

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: imx_keypad - add dependency on HAS_IOMEM

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: da7280 - protect OF match table with CONFIG_OF

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: da7280 - fix missing error test

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu/display: remove hdcp_srm sysfs on device removal

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    smp: Process pending softirqs in flush_smp_call_function_from_idle()

Geert Uytterhoeven <geert+renesas@glider.be>
    irqchip/imx: IMX_INTMUX should not default to y, unconditionally

Wang ShaoBo <bobo.shaobowang@huawei.com>
    ubifs: Fix error return code in alloc_wbufs()

Arnd Bergmann <arnd@arndb.de>
    ubifs: replay: Fix high stack usage, again

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ubifs: Fix memleak in ubifs_init_authentication

Tom Rix <trix@redhat.com>
    jffs2: fix use after free in jffs2_sum_write_data()

Colin Ian King <colin.king@canonical.com>
    fs/jfs: fix potential integer overflow on shift of a int

Sameer Pujar <spujar@nvidia.com>
    ASoC: simple-card-utils: Fix device module clock

Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
    ima: Free IMA measurement buffer after kexec syscall

Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
    ima: Free IMA measurement buffer on error

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: sof-pci-dev: add missing Up-Extreme quirk

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvmet: set status to 0 in case for invalid nsid

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvmet: remove extra variable in identify ns

Keith Busch <kbusch@kernel.org>
    nvme-multipath: set nr_zones for zoned namespaces

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix potential race of tcp socket closing accept_work

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix receive data digest calculation for multiple h2cdata PDUs

Hao Xu <haoxu@linux.alibaba.com>
    io_uring: fix possible deadlock in io_uring_poll

Daniele Alessandrelli <daniele.alessandrelli@intel.com>
    crypto: ecdh_helper - Ensure 'len >= secret.len' in decode_key()

Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>
    hwrng: timeriomem - Fix cooldown period calculation

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Don't cache EDIDs for physical ports

Dan Carpenter <dan.carpenter@oracle.com>
    drm/virtio: fix an error code in virtio_gpu_init()

Qinglang Miao <miaoqinglang@huawei.com>
    drm/lima: fix reference leak in lima_pm_busy

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Update the CEC clock divider on HSM rate change

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Compute the CEC clock divider from the clock rate

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Restore cec physical address on reconnect

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Fix up CEC registers

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Fix register offset with longer CEC messages

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Move hdmi reset to bind

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: return EIO when msg retry limit reached

Sean Christopherson <seanjc@google.com>
    KVM: x86: Restore all 64 bits of DR6 and DR7 during RSM on x86-64

Jinyang He <hejinyang@loongson.cn>
    MIPS: relocatable: Provide kaslr_offset() to get the kernel offset

Qu Wenruo <wqu@suse.com>
    btrfs: fix double accounting of ordered extent for subpage case in btrfs_invalidapge

Zhihao Cheng <chengzhihao1@huawei.com>
    btrfs: clarify error returns values in __load_free_space_cache

Hui Wang <hui.wang@canonical.com>
    ASoC: SOF: debug: Fix a potential issue on string buffer termination

Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
    ASoC: rt5682: Fix panic in rt5682_jack_detect_handler happening during system shutdown

Jun Nie <jun.nie@linaro.org>
    ASoC: qcom: lpass: Fix i2s ctl register bit map

Peter Zijlstra <peterz@infradead.org>
    locking/lockdep: Avoid unmatched unlock

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A3E

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A32

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add missing TGL_HDMI quirk for Dell SKU 0A5E

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    Drivers: hv: vmbus: Avoid use-after-free in vmbus_onoffer_rescind()

Yongqiang Niu <yongqiang.niu@mediatek.com>
    drm/mediatek: Check if fb is null

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Don't strip host's C-bit from guest's CR3 when reading PDPTRs

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    ASoC: qcom: Fix typo error in HDMI regmap config callbacks

Dehe Gu <gudehe@huawei.com>
    f2fs: fix a wrong condition in __submit_bio

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amdgpu: Prevent shift wrapping in amdgpu_read_mask()

Yi Chen <chenyi77@huawei.com>
    f2fs: fix to avoid inconsistent quota data

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mtd: rawnand: intel: Fix an error handling path in 'ebu_dma_start()'

Manivannan Sadhasivam <mani@kernel.org>
    mtd: parsers: afs: Fix freeing the part name memory in failure

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: add missing max_register in regmap config

Sebastian Reichel <sre@kernel.org>
    ASoC: cpcap: fix microphone timeslot mask

Florian Fainelli <f.fainelli@gmail.com>
    ata: ahci_brcm: Add back regulators management

Will Deacon <will@kernel.org>
    mm: proc: Invalidate TLB after clearing soft-dirty page state

Biwen Li <biwen.li@nxp.com>
    irqchip/ls-extirq: add IRQCHIP_SKIP_SET_WAKE to the irqchip flags

Frantisek Hrbata <frantisek@hrbata.com>
    drm/nouveau: bail out of nouveau_channel_new if channel init fails

Christophe Leroy <christophe.leroy@csgroup.eu>
    crypto: talitos - Fix ctr(aes) on SEC1

Christophe Leroy <christophe.leroy@csgroup.eu>
    crypto: talitos - Work around SEC6 ERRATA (AES-CTR mode data size error)

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: parser: imagetag: fix error codes in bcm963xx_parse_imagetag_partitions()

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Move IRQs when migrating context

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Fix PMU instance naming

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: hda: cancel D0i3 work during runtime suspend

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    ASoC: qcom: lpass-cpu: Remove bit clock state check

Chao Yu <chao@kernel.org>
    f2fs: compress: fix potential deadlock

Daeho Jeong <daehojeong@google.com>
    f2fs: fix null page reference in redirty_blocks

Qais Yousef <qais.yousef@arm.com>
    sched/eas: Don't update misfit status if the task is pinned

Judy Hsiao <judyhsiao@google.com>
    ASoC: max98373: Fixes a typo in max98373_feedback_get

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    media: i2c/Kconfig: Select FWNODE for OV772x sensor

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values

Tom Rix <trix@redhat.com>
    media: pxa_camera: declare variable when DEBUG is defined

yangerkun <yangerkun@huawei.com>
    mtd: phram: use div_u64_rem to stop overwrite len in phram_setup

Tom Rix <trix@redhat.com>
    media: mtk-vcodec: fix argument used when DEBUG is defined

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: cx25821: Fix a bug when reallocating some dma memory

Luo Meng <luomeng12@huawei.com>
    media: qm1d1c0042: fix error return code in qm1d1c0042_init()

Dan Carpenter <dan.carpenter@oracle.com>
    media: atomisp: Fix a buffer overflow in debug code

Daniel W. S. Almeida <dwlsalmeida@gmail.com>
    media: vidtv: psi: fix missing crc for PMT

Joe Perches <joe@perches.com>
    media: lmedm04: Fix misuse of comma

Daniel Scally <djrscally@gmail.com>
    media: software_node: Fix refcounts in software_node_get_next_child()

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Fix HDMI deep color output for DCE 6-11.

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Fix 10/12 bpc setup in DCE output bit depth reduction.

Finn Thain <fthain@telegraphics.com.au>
    macintosh/adb-iop: Use big-endian autopoll mask

Pan Bian <bianpan2016@163.com>
    bsg: free the request before return error code

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: toggle on DF Cstate after finishing xgmi injection

Qinglang Miao <miaoqinglang@huawei.com>
    drm/tegra: Fix reference leak when pm_runtime_get_sync() fails

Nathan Chancellor <nathan@kernel.org>
    MIPS: Compare __SYNC_loongson3_war against 0

Alexander Lobakin <alobakin@pm.me>
    MIPS: properly stop .eh_frame generation

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: ti-vpe: cal: fix write to unallocated memory

Rui Miguel Silva <rmfrfs@gmail.com>
    media: imx7: csi: Fix pad link validation

Fabio Estevam <festevam@gmail.com>
    media: imx7: csi: Fix regression for parallel cameras on i.MX6UL

Giulio Benetti <giulio.benetti@micronovasrl.com>
    drm/sun4i: tcon: fix inverted DCLK polarity

Xuewen Yan <xuewen.yan@unisoc.com>
    sched/fair: Avoid stale CPU util_est value for schedutil in task dequeue

Jiri Olsa <jolsa@kernel.org>
    crypto: bcm - Rename struct device_private to bcm_device_private

Marco Chiappero <marco.chiappero@intel.com>
    crypto: qat - replace CRYPTO_AES with CRYPTO_LIB_AES in Kconfig

Dinghao Liu <dinghao.liu@zju.edu.cn>
    evm: Fix memleak in init_desc

Stephan Gerhold <stephan@gerhold.net>
    ASoC: qcom: qdsp6: Move frontend AIFs to q6asm-dai

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: cs42l56: fix up error handling in probe

Zhang Changzhong <zhangchangzhong@huawei.com>
    media: aspeed: fix error return code in aspeed_video_setup_video()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: tm6000: Fix memleak in tm6000_start_stream

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: media/pci: Fix memleak in empress_init

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: em28xx: Fix use-after-free in em28xx_alloc_urbs

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: vsp1: Fix an error handling path in the probe function

Dan Carpenter <dan.carpenter@oracle.com>
    media: camss: missing error code in msm_video_register()

Dan Carpenter <dan.carpenter@oracle.com>
    media: camss: Fix signedness bug in video_enum_fmt()

Zhang Changzhong <zhangchangzhong@huawei.com>
    media: mtk-vcodec: fix error return code in vdec_vp9_decode()

Ezequiel Garcia <ezequiel@collabora.com>
    media: imx: Fix csc/scaler unregister

Ezequiel Garcia <ezequiel@collabora.com>
    media: imx: Unregister csc/scaler only if registered

Jacopo Mondi <jacopo@jmondi.org>
    media: i2c: ov5670: Fix PIXEL_RATE minimum value

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    media: ipu3-cio2: Build only for x86

Simon Ser <contact@emersion.fr>
    drm/fourcc: fix Amlogic format modifier masks

Chia-I Wu <olvaffe@gmail.com>
    drm/virtio: make sure context is created in gem open

Nathan Chancellor <nathan@kernel.org>
    MIPS: lantiq: Explicitly compare LTQ_EBU_PCC_ISTAT against 0

Nathan Chancellor <nathan@kernel.org>
    MIPS: c-r4k: Fix section mismatch for loongson2_sc_init

Chenyang Li <lichenyang@loongson.cn>
    drm/amdgpu: Fix macro name _AMDGPU_TRACE_H_ in preprocessor if condition

Wang Xiaojun <wangxiaojun11@huawei.com>
    drm: rcar-du: Fix the return check of of_parse_phandle and of_find_device_by_node

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm: rcar-du: Fix crash when using LVDS1 clock for CRTC

Qinglang Miao <miaoqinglang@huawei.com>
    drm: rcar-du: Fix PM reference leak in rcar_cmm_enable()

Marco Elver <elver@google.com>
    kcsan: Rewrite kcsan_prandom_u32_max() without prandom_u32_state()

Arnd Bergmann <arnd@arndb.de>
    ASoC: fsl_aud2htx: select SND_SOC_IMX_PCM_DMA

Dan Carpenter <dan.carpenter@oracle.com>
    media: allegro: Fix use after free on error

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hwrng: ingenic - Fix a resource leak in an error handling path

Ard Biesheuvel <ardb@kernel.org>
    crypto: arm64/aes-ce - really hide slower algos when faster ones are enabled

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - fix kmap usage

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun4i-ss - linearize buffers content must be kept

Linus Walleij <linus.walleij@linaro.org>
    drm/panel: s6e63m0: Support max-brightness

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: hdmi: Take into account the clock doubling flag in atomic_check

Guido Günther <agx@sigxcpu.org>
    drm/panel: mantix: Tweak init sequence

Linus Walleij <linus.walleij@linaro.org>
    drm/panel: s6e63m0: Fix init sequence again

Chuhong Yuan <hslester96@gmail.com>
    drm/fb-helper: Add missed unlocks in setcmap_legacy()

Dan Carpenter <dan.carpenter@oracle.com>
    gma500: clean up error handling in init

Simon Ser <contact@emersion.fr>
    drm: document that user-space should force-probe connectors

Jialin Zhang <zhangjialin11@huawei.com>
    drm/gma500: Fix error return code in psb_driver_load()

Randy Dunlap <rdunlap@infradead.org>
    fbdev: aty: SPARC64 requires FB_ATY_CT

Bjarni Jonasson <bjarni.jonasson@microchip.com>
    net: phy: mscc: coma mode disabled for VSC8514

Bjarni Jonasson <bjarni.jonasson@microchip.com>
    net: phy: mscc: improved serdes calibration applied to VSC8514

Alex Elder <elder@linaro.org>
    net: ipa: initialize all resources

Dany Madden <drt@linux.ibm.com>
    ibmvnic: change IBMVNIC_MAX_IND_DESCS to 16

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Fix CQ params of ICOSQ and async ICOSQ

Raed Salem <raeds@nvidia.com>
    net/mlx5e: Enable striding RQ for Connect-X IPsec capable devices

Parav Pandit <parav@nvidia.com>
    net/mlx5e: E-switch, Fix rate calculation for overflow

Joel Stanley <joel@jms.id.au>
    soc: aspeed: socinfo: Add new systems

Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
    Bluetooth: hci_qca: Fixed issue during suspend

Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
    Bluetooth: hci_qca: check for SSR triggered flag while suspend

Matthias Brugger <mbrugger@suse.com>
    arm64: dts: mt8183: Fix GCE include path

Peter Geis <pgwipeout@gmail.com>
    ARM: tegra: ouya: Fix eMMC on specific bootloaders

Pali Rohár <pali@kernel.org>
    net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    arm64: dts: mt8183: Add missing power-domain for pwm0 node

Yongqiang Niu <yongqiang.niu@mediatek.com>
    arm64: dts: mt8183: refine gamma compatible name

Yongqiang Niu <yongqiang.niu@mediatek.com>
    arm64: dts: mt8183: rename rdma fifo size

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Don't exit on failed bpf_testmod unload

Sami Tolvanen <samitolvanen@google.com>
    x86/sgx: Fix the return type of sgx_init()

Linus Torvalds <torvalds@linux-foundation.org>
    tty: implement read_iter

Linus Torvalds <torvalds@linux-foundation.org>
    tty: convert tty_ldisc_ops 'read()' function to take a kernel pointer

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qrb5165-rb5: fix uSD pins drive strength

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8250: correct sdhc_2 xo clk

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Sync RCU before unloading bpf_testmod

Andrii Nakryiko <andrii@kernel.org>
    bpf: Declare __bpf_free_used_maps() unconditionally

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix DMA initialization error handling

Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
    Bluetooth: hci_qca: Wait for SSR completion during suspend

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: broadcom: bcm4908: use proper NAND binding

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    Bluetooth: Remove hci_req_le_suspend_config

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: fix destroyed phylink dereference during unbind

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: mvneta: Remove per-cpu queue mapping for Armada 3700

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Reset link when the link never comes back

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    net: amd-xgbe: Reset the PHY rx data path when mailbox command timeout

Bjarni Jonasson <bjarni.jonasson@microchip.com>
    net: phy: mscc: adding LCPLL reset to VSC8514

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: don't deinitialize unused ports

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: felix: perform teardown in reverse order of setup

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: serialize access to work queue on remove

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: skip send_request_unmap for timeout reset

Lijun Pan <ljp@linux.ibm.com>
    ibmvnic: add memory barrier to protect long term buffer

Ilya Leoshkevich <iii@linux.ibm.com>
    bpf: Clear subreg_def for global function return values

Colin Ian King <colin.king@canonical.com>
    b43: N-PHY: Fix the update of coef for the PHY revision >= 3case

Ayush Sawal <ayush.sawal@chelsio.com>
    cxgb4/chtls/cxgbit: Keeping the max ofld immediate data size same in cxgb4 and ulds

Robert Hancock <robert.hancock@calian.com>
    net: axienet: Handle deferred probe on clock properly

Eric Dumazet <edumazet@google.com>
    tcp: fix SO_RCVLOWAT related hangs under mem pressure

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: fix ACKRX debug message

Jesper Dangaard Brouer <brouer@redhat.com>
    bpf: Fix bpf_fib_lookup helper MTU check for SKB ctx

Jun'ichi Nomura <junichi.nomura@nec.com>
    bpf, devmap: Use GFP_KERNEL for xdp bulk queue allocation

Yonghong Song <yhs@fb.com>
    bpf: Fix an unitialized value in bpf_iter

Martin KaFai Lau <kafai@fb.com>
    libbpf: Ignore non function pointer member in struct_ops

Colin Ian King <colin.king@canonical.com>
    mac80211: fix potential overflow when multiplying to u32 integers

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5e: Check tunnel offload is required before setting SWP

Oz Shlomo <ozsh@nvidia.com>
    net/mlx5e: CT: manage the lifetime of the ct entry object

Shay Drory <shayd@nvidia.com>
    net/mlx5: Disable devlink reload for lag devices

Shay Drory <shayd@nvidia.com>
    net/mlx5: Disallow RoCE on lag device

Shay Drory <shayd@nvidia.com>
    net/mlx5: Disallow RoCE on multi port slave device

Shay Drory <shayd@nvidia.com>
    net/mlx5: Disable devlink reload for multi port slave device

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: kTLS, Use refcounts to free kTLS RX priv context

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Replace synchronize_rcu with synchronize_net

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix health error state handling

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Change interrupt moderation channel params also when channels are closed

Maxim Mikityanskiy <maximmi@mellanox.com>
    net/mlx5e: Don't change interrupt moderation params when DIM is enabled

Raed Salem <raeds@nvidia.com>
    net/mlx5e: Enable XDP for Connect-X IPsec capable devices

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: consider that suspend2ram may cut off PHY power

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-eth: fix memory leak in XDP_REDIRECT

Juergen Gross <jgross@suse.com>
    xen/netback: fix spurious event detection for common event case

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix devlink info's stored fw.psid version format.

Edwin Peer <edwin.peer@broadcom.com>
    bnxt_en: reverse order of TX disable and carrier off

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: Set to CLOSED state even on error

Björn Töpel <bjorn@kernel.org>
    selftests/bpf: Convert test_xdp_redirect.sh to bash

Linus Lüssing <ll@simonwunderlich.de>
    ath9k: fix data bus crash when setting nf_override via debugfs

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pnvm: increment the pointer before checking the TLV

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: pnvm: set the PNVM again if it was already loaded

Marco Elver <elver@google.com>
    bpf_lru_list: Read double-checked variable once without lock

Sara Sharon <sara.sharon@intel.com>
    iwlwifi: mvm: don't check if CSA event is running before removing

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: assign SAR table revision to the command later

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: send stored PPAG command instead of local

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: store PPAG enabled/disabled flag properly

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: fix the type we use in the PPAG table validity checks

Jae Hyun Yoo <jae.hyun.yoo@intel.com>
    soc: aspeed: snoop: Add clock control logic

Dan Carpenter <dan.carpenter@oracle.com>
    ath11k: fix a locking bug in ath11k_mac_op_start()

Anand K Mistry <amistry@google.com>
    ath10k: Fix lockdep assertion warning in ath10k_sta_statistics

Anand K Mistry <amistry@google.com>
    ath10k: Fix suspicious RCU usage warning in ath10k_wmi_tlv_parse_peer_stats_info()

Arnd Bergmann <arnd@arndb.de>
    ARM: at91: use proper asm syntax in pm_suspend

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix possible panic with re-queued frames

Arnd Bergmann <arnd@arndb.de>
    optee: simplify i2c access

Arnd Bergmann <arnd@arndb.de>
    ARM: s3c: fix fiq for clang IAS

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: set enabled in the PPAG command properly

Artem Lapkin <email2tema@gmail.com>
    arm64: dts: meson: fix broken wifi node for Khadas VIM3L

Vincent Knecht <vincent.knecht@mailoo.org>
    arm64: dts: msm8916: Fix reserved and rfsa nodes unit address

Luca Weiss <luca@z3ntu.xyz>
    soc: qcom: ocmem: don't return NULL in of_get_ocmem

Jupeng Zhong <zhongjupeng@yulong.com>
    Bluetooth: btusb: Fix memory leak in btusb_mtk_wmt_recv

Dmitry Osipenko <digetx@gmail.com>
    opp: Correct debug message in _opp_add_static_v2()

Marek Behún <kabel@kernel.org>
    arm64: dts: armada-3720-turris-mox: rename u-boot mtd partition to a53-firmware

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada388-helios4: assign pinctrl to each fan

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada388-helios4: assign pinctrl to LEDs

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_probe(): fix errata reference

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: beacon: Fix EEPROM compatible value

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    x86/MSR: Filter MSR writes through X86_IOC_WRMSR_REGS ioctl too

Chen-Yu Tsai <wens@csie.org>
    staging: rtl8723bs: wifi_regd.c: Fix incorrect number of regulatory rules

Guenter Roeck <linux@roeck-us.net>
    usb: dwc2: Make "trimming xfer length" a debug message

Guenter Roeck <linux@roeck-us.net>
    usb: dwc2: Abort transaction after errors with unknown reason

Guenter Roeck <linux@roeck-us.net>
    usb: dwc2: Do not update data length if it is 0 on inbound transfers

Tony Lindgren <tony@atomide.com>
    ARM: dts: Configure missing thermal interrupt for 4430

Pan Bian <bianpan2016@163.com>
    memory: ti-aemif: Drop child node when jumping out loop

Pan Bian <bianpan2016@163.com>
    Bluetooth: Put HCI device if inquiry procedure interrupts

Pan Bian <bianpan2016@163.com>
    Bluetooth: drop HCI device reference before return

Borislav Petkov <bp@suse.de>
    staging: media: atomisp: Fix size_t format specifier in hmm_alloc() debug statemenet

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    soc: ti: pm33xx: Fix some resource leak in the error handling paths of the probe function

Dan Carpenter <dan.carpenter@oracle.com>
    soc: qcom: socinfo: Fix an off by one in qcom_show_pmic_model()

Robert Foss <robert.foss@linaro.org>
    arm64: dts: qcom: sdm845-db845c: Fix reset-pin of ov8856 node

Jack Pham <jackp@codeaurora.org>
    usb: gadget: u_audio: Free requests only after callback

Maximilian Luz <luzmaximilian@gmail.com>
    ACPICA: Fix exception code class checks

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: rk3328: Add clock_in_out property to gmac2phy node

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    cpufreq: brcmstb-avs-cpufreq: Fix resource leaks in ->remove()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    cpufreq: brcmstb-avs-cpufreq: Free resources in error path

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916-samsung-a2015: Fix sensors

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: A64: Limit MMC2 bus frequency to 150 MHz

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: H6: Allow up to 150 MHz MMC bus frequency

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: Drop non-removable from SoPine/LTS SD card

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: H6: properly connect USB PHY to port 0

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: A64: properly connect USB PHY to port 0

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix call site of scmi_notification_exit

Andrii Nakryiko <andrii@kernel.org>
    bpf: Avoid warning when re-casting __bpf_call_base into __bpf_call_base_args

Andrii Nakryiko <andrii@kernel.org>
    bpf: Add bpf_patch_call_args prototype to include/linux/bpf.h

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: stmmac: dwmac-meson8b: fix enabling the timing-adjustment clock

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916-samsung-a5u: Fix iris compatible

Phil Elwell <phil@raspberrypi.com>
    staging: vchiq: Fix bulk transfers on 64-bit builds

Phil Elwell <phil@raspberrypi.com>
    staging: vchiq: Fix bulk userdata handling

Dinghao Liu <dinghao.liu@zju.edu.cn>
    Bluetooth: hci_qca: Fix memleak in qca_controller_memdump

Zhang Qilong <zhangqilong3@huawei.com>
    memory: mtk-smi: Fix PM usage counter unbalance in mtk_smi ops

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: dts: exynos: correct PMIC interrupt trigger level on Espresso

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: dts: exynos: correct PMIC interrupt trigger level on TM2

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid XU3 family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Arndale Octa

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Spring

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Rinato

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Monk

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Artik 5

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: beacon: Fix audio-1.8V pin enable

Adam Ford <aford173@gmail.com>
    arm64: dts: renesas: beacon kit: Fix choppy Bluetooth Audio

Christopher William Snowhill <chris@kode54.net>
    Bluetooth: Fix initializing response id after clearing struct

Claire Chang <tientzu@chromium.org>
    Bluetooth: hci_uart: Fix a race for write_work scheduling

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Bluetooth: btqcomsmd: Fix a resource leak in error handling paths in the probe function

Rakesh Pillai <pillair@codeaurora.org>
    ath10k: Fix error handling in case of CE pipe init failure

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: One more flush for Baytrail clear residuals

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Don't call sync_stop if it hasn't been stopped

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Assure sync with the pending stop operation at suspend

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Call sync_stop at disconnection

Eric Biggers <ebiggers@google.com>
    random: fix the RNDRESEEDCRNG ioctl

Nathan Chancellor <nathan@kernel.org>
    vmlinux.lds.h: Define SANTIZER_DISCARDS with CONFIG_GCOV_KERNEL=y

Alexander Lobakin <alobakin@pm.me>
    MIPS: vmlinux.lds.S: add missing PAGE_ALIGNED_DATA() section

Rokudo Yan <wu-yan@tcl.com>
    zsmalloc: account the number of compacted pages correctly

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix PCM buffer allocation in non-vmalloc mode

Jan Kara <jack@suse.cz>
    bfq: Avoid false bfq queue merging

Hans de Goede <hdegoede@redhat.com>
    virt: vbox: Do not use wait_event_interruptible when called from kernel context

Ard Biesheuvel <ardb@kernel.org>
    PCI: Decline to resize resources if boot config must be preserved

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Use PHY_REFCLK_USE_PAD only for ipq8064

Ivan Zaentsev <ivan.zaentsev@wirenboard.ru>
    w1: w1_therm: Fix conversion result for negative temperatures

Sumit Garg <sumit.garg@linaro.org>
    kdb: Make memory allocations more robust

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix mailbox Ch erroneous error

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: libsas: docs: Remove notify_ha_event()

Dave Jiang <dave.jiang@intel.com>
    driver core: auxiliary bus: Fix calling stage for auxiliary bus init

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    debugfs: do not attempt to create a new file before the filesystem is initalized

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    debugfs: be more robust at handling improper input in debugfs_lookup()

Stefano Garzarella <sgarzare@redhat.com>
    vdpa/mlx5: fix param validation in mlx5_vdpa_get_config()

Nick Desaulniers <ndesaulniers@google.com>
    vmlinux.lds.h: add DWARF v5 sections


-------------

Diffstat:

 Documentation/admin-guide/perf/arm-cmn.rst         |   2 +-
 Documentation/admin-guide/sysctl/vm.rst            |  10 +-
 Documentation/filesystems/seq_file.rst             |   6 +
 Documentation/scsi/libsas.rst                      |  10 +-
 Documentation/security/keys/core.rst               |   4 +-
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/head.S                    |   4 +-
 arch/arm/boot/dts/armada-388-helios4.dts           |  28 +-
 arch/arm/boot/dts/exynos3250-artik5.dtsi           |   2 +-
 arch/arm/boot/dts/exynos3250-monk.dts              |   2 +-
 arch/arm/boot/dts/exynos3250-rinato.dts            |   2 +-
 arch/arm/boot/dts/exynos5250-spring.dts            |   2 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |   2 +-
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi      |   2 +-
 arch/arm/boot/dts/omap443x.dtsi                    |   2 +
 arch/arm/boot/dts/tegra30-ouya.dts                 |   4 +-
 arch/arm/kernel/sys_oabi-compat.c                  |  15 +
 arch/arm/mach-at91/pm_suspend.S                    |   2 +-
 arch/arm/mach-ixp4xx/Kconfig                       |   1 -
 arch/arm/mach-s3c/irq-s3c24xx-fiq.S                |   9 +-
 arch/arm64/Kconfig                                 |   2 +-
 .../boot/dts/allwinner/sun50i-a64-pinebook.dts     |   5 +-
 .../boot/dts/allwinner/sun50i-a64-sopine.dtsi      |   1 -
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi      |   6 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |   7 +
 .../boot/dts/amlogic/meson-sm1-khadas-vim3l.dts    |   7 +-
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi  |   2 +-
 .../boot/dts/exynos/exynos5433-tm2-common.dtsi     |   2 +-
 arch/arm64/boot/dts/exynos/exynos7-espresso.dts    |   2 +-
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi      |   4 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   2 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi           |   2 +
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |  10 +-
 .../dts/qcom/msm8916-samsung-a2015-common.dtsi     |   6 +
 .../boot/dts/qcom/msm8916-samsung-a5u-eur.dts      |   2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   4 +-
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts           |  15 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   4 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +-
 .../boot/dts/renesas/beacon-renesom-baseboard.dtsi |   2 +-
 .../arm64/boot/dts/renesas/beacon-renesom-som.dtsi |   4 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   1 +
 arch/arm64/crypto/aes-glue.c                       |   4 +-
 arch/arm64/crypto/sha1-ce-glue.c                   |   1 +
 arch/arm64/crypto/sha2-ce-glue.c                   |   2 +
 arch/arm64/crypto/sha3-ce-glue.c                   |   4 +
 arch/arm64/crypto/sha512-ce-glue.c                 |   2 +
 arch/arm64/include/asm/module.lds.h                |   6 +-
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kernel/head.S                           |   1 +
 arch/arm64/kernel/machine_kexec_file.c             |   4 +-
 arch/arm64/kernel/probes/uprobes.c                 |   2 +-
 arch/arm64/kernel/ptrace.c                         |   2 +-
 arch/arm64/kernel/suspend.c                        |   2 +-
 arch/csky/kernel/ptrace.c                          |   2 +-
 arch/mips/Makefile                                 |  19 +
 arch/mips/boot/compressed/Makefile                 |   1 +
 arch/mips/cavium-octeon/setup.c                    |   9 +-
 arch/mips/include/asm/asm.h                        |  18 +
 arch/mips/include/asm/atomic.h                     |   2 +-
 arch/mips/include/asm/cmpxchg.h                    |   6 +-
 arch/mips/include/asm/page.h                       |   6 +
 arch/mips/kernel/cpu-probe.c                       |  15 +-
 arch/mips/kernel/relocate.c                        |  10 +
 arch/mips/kernel/setup.c                           |   3 +
 arch/mips/kernel/vmlinux.lds.S                     |   2 +-
 arch/mips/lantiq/irq.c                             |   2 +-
 arch/mips/loongson64/Platform                      |  22 -
 arch/mips/mm/c-r4k.c                               |   2 +-
 arch/mips/vdso/Makefile                            |   5 +-
 arch/nios2/kernel/entry.S                          |   3 +
 arch/nios2/kernel/sys_nios2.c                      |  11 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/include/asm/kexec.h                   |   1 +
 arch/powerpc/include/asm/paravirt.h                |   1 +
 arch/powerpc/include/asm/uaccess.h                 |  13 +-
 arch/powerpc/kernel/entry_32.S                     |   3 +
 arch/powerpc/kernel/head_32.h                      |   2 +-
 arch/powerpc/kernel/head_8xx.S                     |   2 +-
 arch/powerpc/kernel/head_book3s_32.S               |   6 -
 arch/powerpc/kernel/irq.c                          |  27 +-
 arch/powerpc/kernel/prom_init.c                    |  12 +-
 arch/powerpc/kernel/time.c                         |   2 +
 arch/powerpc/kexec/elf_64.c                        |   2 +-
 arch/powerpc/kexec/file_load_64.c                  |  35 ++
 arch/powerpc/kvm/Kconfig                           |   1 +
 arch/powerpc/kvm/powerpc.c                         |   8 +-
 arch/powerpc/lib/sstep.c                           | 101 +++-
 arch/powerpc/platforms/pseries/dlpar.c             |   7 +-
 arch/riscv/kernel/vdso/Makefile                    |   3 +-
 arch/s390/kernel/vtime.c                           |   3 +-
 arch/sparc/Kconfig                                 |   2 +-
 arch/sparc/kernel/led.c                            |   2 +
 arch/sparc/lib/memset.S                            |   1 +
 arch/um/include/shared/skas/mm_id.h                |   1 +
 arch/um/kernel/tlb.c                               |  19 +-
 arch/um/os-Linux/skas/process.c                    |   4 +
 arch/x86/crypto/aesni-intel_glue.c                 |  28 +-
 arch/x86/entry/common.c                            |   2 +-
 arch/x86/include/asm/virtext.h                     |  17 +-
 arch/x86/kernel/cpu/sgx/main.c                     |  14 +-
 arch/x86/kernel/msr.c                              |   7 +
 arch/x86/kernel/reboot.c                           |  30 +-
 arch/x86/kvm/emulate.c                             |   4 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   3 +-
 arch/x86/kvm/svm/nested.c                          |  22 +-
 arch/x86/kvm/svm/svm.c                             |   8 +-
 arch/x86/kvm/x86.c                                 |   1 +
 arch/x86/mm/fault.c                                |  27 +-
 arch/x86/mm/pat/memtype.c                          |   4 +-
 block/bfq-iosched.c                                |   1 +
 block/blk-settings.c                               |  12 +
 block/bsg.c                                        |   4 +-
 block/genhd.c                                      |   2 +-
 block/ioctl.c                                      |  21 +-
 certs/blacklist.c                                  |   2 +-
 crypto/ecdh_helper.c                               |   3 +
 crypto/michael_mic.c                               |  31 +-
 drivers/acpi/acpi_configfs.c                       |   7 +-
 drivers/acpi/property.c                            |  44 +-
 drivers/amba/bus.c                                 |  20 +-
 drivers/ata/ahci_brcm.c                            |  14 +-
 drivers/auxdisplay/Kconfig                         |   3 -
 drivers/auxdisplay/ht16k33.c                       |   3 +-
 drivers/base/auxiliary.c                           |  13 +-
 drivers/base/base.h                                |   5 +
 drivers/base/init.c                                |   1 +
 drivers/base/regmap/regmap-sdw.c                   |   4 +-
 drivers/base/swnode.c                              |   8 +-
 drivers/block/floppy.c                             |  30 +-
 drivers/block/zram/zram_drv.c                      |   2 +-
 drivers/bluetooth/btqcomsmd.c                      |  27 +-
 drivers/bluetooth/btusb.c                          |  20 +-
 drivers/bluetooth/hci_ldisc.c                      |  41 +-
 drivers/bluetooth/hci_qca.c                        |  33 +-
 drivers/bluetooth/hci_serdev.c                     |   4 +-
 drivers/bus/mhi/core/init.c                        |   3 +
 drivers/char/hw_random/ingenic-trng.c              |   6 +-
 drivers/char/hw_random/timeriomem-rng.c            |   2 +-
 drivers/char/random.c                              |   2 +-
 drivers/char/tpm/tpm.h                             |   4 -
 drivers/char/tpm/tpm_tis_core.c                    |  50 +-
 drivers/clk/clk-ast2600.c                          |  37 +-
 drivers/clk/clk-divider.c                          |   9 +-
 drivers/clk/meson/clk-pll.c                        |  10 +-
 drivers/clk/qcom/gcc-msm8998.c                     | 100 ++--
 drivers/clk/qcom/gcc-sc7180.c                      |  47 +-
 drivers/clk/qcom/lpass-gfm-sm8250.c                |   8 +-
 drivers/clk/renesas/r8a779a0-cpg-mssr.c            |   3 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c               |  10 +-
 drivers/clocksource/Kconfig                        |   1 +
 drivers/clocksource/mxs_timer.c                    |   5 +-
 drivers/cpufreq/acpi-cpufreq.c                     |  62 +-
 drivers/cpufreq/brcmstb-avs-cpufreq.c              |  24 +-
 drivers/cpufreq/freq_table.c                       |   8 +-
 drivers/cpufreq/intel_pstate.c                     |  21 +-
 drivers/cpufreq/qcom-cpufreq-hw.c                  |  40 +-
 .../crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c    | 173 +++---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h       |   2 +
 drivers/crypto/bcm/cipher.c                        |   2 +-
 drivers/crypto/bcm/cipher.h                        |   4 +-
 drivers/crypto/bcm/util.c                          |   2 +-
 drivers/crypto/qat/Kconfig                         |   2 +-
 drivers/crypto/talitos.c                           |  50 +-
 drivers/crypto/talitos.h                           |   1 +
 drivers/dax/bus.c                                  |   2 +-
 drivers/dma/fsldma.c                               |   6 +
 drivers/dma/hsu/pci.c                              |  21 +-
 drivers/dma/idxd/dma.c                             |   1 +
 drivers/dma/owl-dma.c                              |   1 +
 drivers/dma/qcom/gpi.c                             |   2 +-
 drivers/dma/ti/k3-udma.c                           |   1 +
 drivers/firmware/arm_scmi/driver.c                 |   4 +-
 drivers/gpio/gpio-pcf857x.c                        |   2 +-
 drivers/gpu/drm/Kconfig                            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h          |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  22 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   2 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |   4 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  25 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   3 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h |   2 +-
 .../gpu/drm/amd/display/dc/bios/command_table.c    |  61 ++
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  27 +-
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |   3 +-
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |  14 +
 .../drm/amd/display/dc/dce/dce_stream_encoder.c    |   1 +
 drivers/gpu/drm/amd/display/dc/dce/dce_transform.c |   8 +-
 .../drm/amd/display/dc/dcn10/dcn10_link_encoder.c  |   1 -
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   6 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |  20 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |   2 +
 .../amd/display/dc/irq/dcn21/irq_service_dcn21.c   |  22 +
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   6 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |   3 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  15 +-
 drivers/gpu/drm/drm_modes.c                        |   4 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         |  22 +-
 drivers/gpu/drm/gma500/psb_drv.c                   |   2 +
 drivers/gpu/drm/i915/display/intel_hdmi.c          |   6 +-
 drivers/gpu/drm/i915/gt/gen7_renderclear.c         |  12 +-
 drivers/gpu/drm/lima/lima_sched.c                  |   2 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  25 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h              |   8 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  10 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |  10 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |   2 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   2 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   5 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_20nm.c         |   2 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   3 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   2 +
 drivers/gpu/drm/msm/msm_kms.h                      |   8 +-
 .../drm/nouveau/include/nvkm/subdev/bios/conn.h    |   1 +
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   1 +
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   1 +
 drivers/gpu/drm/panel/panel-elida-kd35t133.c       |   3 +-
 drivers/gpu/drm/panel/panel-mantix-mlaf057we51.c   |   5 +
 drivers/gpu/drm/panel/panel-samsung-s6e63m0.c      |  59 +-
 drivers/gpu/drm/rcar-du/rcar_cmm.c                 |   2 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |  10 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.h              |   6 +-
 drivers/gpu/drm/rcar-du/rcar_du_encoder.c          |   5 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |   8 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |  11 +
 drivers/gpu/drm/scheduler/sched_main.c             |   3 +
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |  21 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.h                 |   1 +
 drivers/gpu/drm/tegra/dc.c                         |   2 +-
 drivers/gpu/drm/tegra/dsi.c                        |   2 +-
 drivers/gpu/drm/tegra/hdmi.c                       |   2 +-
 drivers/gpu/drm/tegra/hub.c                        |   2 +-
 drivers/gpu/drm/tegra/sor.c                        |   2 +-
 drivers/gpu/drm/tegra/vic.c                        |   2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   9 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  87 ++-
 drivers/gpu/drm/vc4/vc4_hdmi_regs.h                |   4 +-
 drivers/gpu/drm/virtio/virtgpu_gem.c               |   8 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c               |   1 +
 drivers/hid/hid-core.c                             |   3 +
 drivers/hid/hid-logitech-dj.c                      |   1 +
 drivers/hid/wacom_wac.c                            |   7 +-
 drivers/hsi/controllers/omap_ssi_core.c            |   2 +-
 drivers/hv/channel_mgmt.c                          |   3 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  21 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   2 +-
 drivers/i2c/busses/i2c-bcm-iproc.c                 | 231 ++++++--
 drivers/i2c/busses/i2c-brcmstb.c                   |   2 +-
 drivers/i2c/busses/i2c-exynos5.c                   |   8 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |  93 ++-
 drivers/i3c/master/Kconfig                         |   1 +
 drivers/ide/falconide.c                            |   3 +-
 drivers/infiniband/core/cm.c                       |   8 +-
 drivers/infiniband/core/cma.c                      |  70 ++-
 drivers/infiniband/core/user_mad.c                 |  17 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |  11 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |   9 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |  16 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  70 ++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   3 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |  19 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  56 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  37 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |  52 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |  14 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  27 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |   5 +
 drivers/infiniband/sw/rxe/rxe_recv.c               |  27 +-
 drivers/infiniband/sw/siw/siw.h                    |   2 +-
 drivers/infiniband/sw/siw/siw_main.c               |   2 +-
 drivers/infiniband/sw/siw/siw_qp.c                 | 271 +++++----
 drivers/infiniband/sw/siw/siw_qp_rx.c              |  26 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |   4 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  20 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c       |   2 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |  51 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.h             |   1 +
 drivers/infiniband/ulp/rtrs/rtrs-pri.h             |   9 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c       |   9 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             | 120 ++--
 drivers/infiniband/ulp/rtrs/rtrs.c                 |  28 +-
 drivers/input/joydev.c                             |   7 +-
 drivers/input/joystick/xpad.c                      |   1 +
 drivers/input/keyboard/Kconfig                     |   2 +-
 drivers/input/misc/da7280.c                        |   3 +
 drivers/input/serio/i8042-x86ia64io.h              |   4 +
 drivers/input/serio/serport.c                      |   4 +-
 drivers/input/touchscreen/elo.c                    |   4 +-
 drivers/input/touchscreen/raydium_i2c_ts.c         |   3 +-
 drivers/input/touchscreen/st1232.c                 |   9 +-
 drivers/input/touchscreen/sur40.c                  |   1 +
 drivers/input/touchscreen/zinitix.c                |   2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   2 +
 drivers/iommu/iommu.c                              |  23 +-
 drivers/iommu/mtk_iommu.c                          |   2 +-
 drivers/irqchip/Kconfig                            |   3 +-
 drivers/irqchip/irq-loongson-pch-msi.c             |   2 +-
 drivers/irqchip/irq-ls-extirq.c                    |   2 +-
 drivers/macintosh/adb-iop.c                        |   6 +-
 drivers/mailbox/arm_mhuv2.c                        |   4 +-
 drivers/mailbox/sprd-mailbox.c                     |   2 +-
 drivers/md/bcache/bcache.h                         |   3 +
 drivers/md/bcache/btree.c                          |  21 +-
 drivers/md/bcache/journal.c                        |   4 +-
 drivers/md/bcache/super.c                          |  20 +
 drivers/md/dm-core.h                               |   4 +
 drivers/md/dm-crypt.c                              |   1 +
 drivers/md/dm-era-target.c                         |  93 +--
 drivers/md/dm-table.c                              | 168 +++---
 drivers/md/dm-writecache.c                         |  74 ++-
 drivers/md/dm.c                                    |  62 +-
 drivers/md/dm.h                                    |   2 +-
 drivers/media/i2c/Kconfig                          |   1 +
 drivers/media/i2c/max9286.c                        |   2 +-
 drivers/media/i2c/ov5670.c                         |   3 +-
 drivers/media/pci/cx25821/cx25821-core.c           |   4 +-
 drivers/media/pci/intel/ipu3/Kconfig               |   3 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |   5 +-
 drivers/media/pci/smipcie/smipcie-ir.c             |  46 +-
 drivers/media/platform/aspeed-video.c              |   6 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   2 +
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |   4 +-
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   |   3 +-
 drivers/media/platform/pxa_camera.c                |   3 +
 drivers/media/platform/qcom/camss/camss-video.c    |   3 +-
 drivers/media/platform/ti-vpe/cal.c                |   4 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   4 +-
 drivers/media/rc/ir_toy.c                          |   1 +
 drivers/media/rc/mceusb.c                          |   2 +-
 drivers/media/test-drivers/vidtv/vidtv_psi.c       |   5 +-
 drivers/media/tuners/qm1d1c0042.c                  |   4 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   2 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   6 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |   4 +
 drivers/media/usb/uvc/uvc_v4l2.c                   |  18 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  32 +-
 drivers/memory/mtk-smi.c                           |   4 +-
 drivers/memory/ti-aemif.c                          |   8 +-
 drivers/mfd/altera-sysmgr.c                        |   3 +-
 drivers/mfd/bd9571mwv.c                            |   6 +-
 drivers/mfd/gateworks-gsc.c                        |   2 +-
 drivers/mfd/wm831x-auxadc.c                        |   3 +-
 drivers/misc/cardreader/rts5227.c                  |   5 +
 drivers/misc/eeprom/eeprom_93xx46.c                |   1 +
 drivers/misc/fastrpc.c                             |   7 +-
 drivers/misc/mei/bus.c                             |   7 +
 drivers/misc/mei/hbm.c                             |   2 +-
 drivers/misc/mei/hw-me-regs.h                      |   5 +
 drivers/misc/mei/interrupt.c                       |  33 +-
 drivers/misc/mei/pci-me.c                          |   5 +
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   5 +-
 drivers/mmc/host/owl-mmc.c                         |   9 +-
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |   4 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   3 +-
 drivers/mmc/host/sdhci-pci-o2micro.c               |  20 +
 drivers/mmc/host/sdhci-sprd.c                      |   6 +-
 drivers/mmc/host/usdhi6rol0.c                      |   4 +-
 drivers/mtd/devices/phram.c                        |   6 +-
 drivers/mtd/nand/raw/intel-nand-controller.c       |   6 +-
 drivers/mtd/parsers/afs.c                          |   4 +-
 drivers/mtd/parsers/parser_imagetag.c              |   4 +
 drivers/mtd/spi-nor/controllers/hisi-sfc.c         |   4 +-
 drivers/mtd/spi-nor/core.c                         |  10 +-
 drivers/mtd/spi-nor/sfdp.c                         |   5 +-
 drivers/net/Kconfig                                |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   2 +-
 drivers/net/dsa/ocelot/felix.c                     |  16 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |  14 +
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   1 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  39 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   3 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  11 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.h         |   3 -
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  14 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   5 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  43 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  16 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  62 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   2 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 -
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c        |   6 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  34 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  33 +-
 drivers/net/ethernet/marvell/mvneta.c              |   9 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   2 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 259 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   2 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  66 +--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  39 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  30 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  26 +-
 drivers/net/gtp.c                                  |   1 -
 drivers/net/ipa/ipa_main.c                         |   4 +-
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/phy/mscc/Makefile                      |   1 +
 drivers/net/phy/mscc/mscc.h                        |  28 +
 drivers/net/phy/mscc/mscc_main.c                   | 608 +++++++++++--------
 drivers/net/phy/mscc/mscc_serdes.c                 | 650 +++++++++++++++++++++
 drivers/net/phy/mscc/mscc_serdes.h                 |  31 +
 drivers/net/phy/phy_device.c                       |  53 +-
 drivers/net/phy/sfp.c                              | 100 ++--
 drivers/net/ppp/ppp_async.c                        |   3 +-
 drivers/net/ppp/ppp_synctty.c                      |   3 +-
 drivers/net/vxlan.c                                |  11 +-
 drivers/net/wireguard/device.c                     |  19 +-
 drivers/net/wireguard/device.h                     |  15 +-
 drivers/net/wireguard/peer.c                       |  28 +-
 drivers/net/wireguard/peer.h                       |   4 +-
 drivers/net/wireguard/queueing.c                   |  86 ++-
 drivers/net/wireguard/queueing.h                   |  45 +-
 drivers/net/wireguard/receive.c                    |  16 +-
 drivers/net/wireguard/send.c                       |  31 +-
 drivers/net/wireless/ath/ath10k/mac.c              |   2 +
 drivers/net/wireless/ath/ath10k/snoc.c             |   5 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   3 +
 drivers/net/wireless/ath/ath11k/mac.c              |  11 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   5 +-
 drivers/net/wireless/broadcom/b43/phy_n.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  43 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   3 -
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  21 +-
 drivers/net/xen-netback/interface.c                |   8 +-
 drivers/nvme/host/multipath.c                      |   4 +
 drivers/nvme/target/admin-cmd.c                    |  33 +-
 drivers/nvme/target/tcp.c                          |  59 +-
 drivers/nvmem/core.c                               |   5 +-
 drivers/nvmem/qcom-spmi-sdam.c                     |   7 +-
 drivers/of/fdt.c                                   |  12 +-
 drivers/opp/of.c                                   |   4 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |   5 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   4 +-
 drivers/pci/controller/pcie-rcar-host.c            |   2 +-
 drivers/pci/controller/pcie-rockchip.c             |  12 +-
 drivers/pci/controller/pcie-xilinx-cpm.c           |   1 +
 drivers/pci/pci-bridge-emul.c                      |  11 +-
 drivers/pci/setup-res.c                            |   6 +
 drivers/pci/syscall.c                              |  10 +-
 drivers/perf/arm-cmn.c                             |  17 +-
 drivers/phy/Kconfig                                |   1 +
 drivers/phy/cadence/phy-cadence-torrent.c          |   1 +
 drivers/phy/lantiq/phy-lantiq-rcu-usb2.c           |  10 +-
 drivers/phy/rockchip/phy-rockchip-emmc.c           |   8 +-
 drivers/platform/chrome/cros_ec_proto.c            |  12 +-
 drivers/platform/x86/Kconfig                       |   4 +-
 drivers/power/reset/at91-sama5d2_shdwc.c           |   2 +-
 drivers/power/supply/Kconfig                       |   1 +
 drivers/power/supply/axp20x_usb_power.c            |   2 +-
 drivers/power/supply/cpcap-battery.c               |  12 +-
 drivers/power/supply/cpcap-charger.c               |   4 +-
 drivers/power/supply/smb347-charger.c              |  12 +-
 drivers/pwm/pwm-iqs620a.c                          |   8 +-
 drivers/pwm/pwm-rockchip.c                         |  18 +-
 drivers/regulator/axp20x-regulator.c               |   7 +-
 drivers/regulator/core.c                           |   6 +-
 drivers/regulator/qcom-rpmh-regulator.c            |  26 +
 drivers/regulator/rohm-regulator.c                 |   9 +-
 drivers/regulator/s5m8767.c                        |  15 +-
 drivers/remoteproc/mtk_common.h                    |   1 +
 drivers/remoteproc/mtk_scp.c                       |  20 +-
 drivers/rtc/Kconfig                                |   3 +-
 drivers/rtc/rtc-rx6110.c                           |   4 +-
 drivers/s390/crypto/zcrypt_api.c                   |  14 +
 drivers/s390/virtio/virtio_ccw.c                   |   4 +-
 drivers/scsi/aic94xx/aic94xx_scb.c                 |  20 +-
 drivers/scsi/bnx2fc/Kconfig                        |   1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  12 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   3 +-
 drivers/scsi/isci/port.c                           |  11 +-
 drivers/scsi/libsas/sas_event.c                    |  66 ++-
 drivers/scsi/libsas/sas_init.c                     |  27 +-
 drivers/scsi/libsas/sas_internal.h                 |   5 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  15 +-
 drivers/scsi/mvsas/mv_sas.c                        |  25 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  40 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   7 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  35 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   1 +
 drivers/scsi/qla2xxx/qla_mbx.c                     |   3 +-
 drivers/scsi/sd.c                                  |   6 +-
 drivers/scsi/sd_zbc.c                              |   6 +-
 drivers/scsi/ufs/ufshcd.c                          |  17 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  30 +-
 drivers/soc/aspeed/aspeed-socinfo.c                |  33 +-
 drivers/soc/qcom/ocmem.c                           |   8 +-
 drivers/soc/qcom/socinfo.c                         |   2 +-
 drivers/soc/samsung/exynos-asv.c                   |  18 +-
 drivers/soc/ti/pm33xx.c                            |   5 +-
 drivers/soundwire/bus.c                            |  47 +-
 drivers/soundwire/cadence_master.c                 |   8 +-
 drivers/soundwire/debugfs.c                        |   2 +-
 drivers/soundwire/intel_init.c                     |   3 +-
 drivers/spi/spi-atmel.c                            |   2 +-
 drivers/spi/spi-cadence-quadspi.c                  |   2 +-
 drivers/spi/spi-dw-bt1.c                           |   2 +-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/spi-imx.c                              |   2 +-
 drivers/spi/spi-pxa2xx-pci.c                       |  27 +-
 drivers/spi/spi-stm32.c                            |   4 +
 drivers/spi/spi-synquacer.c                        |   4 +
 drivers/spi/spi.c                                  |   2 +-
 drivers/spmi/spmi-pmic-arb.c                       |   5 +-
 drivers/staging/gdm724x/gdm_usb.c                  |  10 +-
 drivers/staging/media/allegro-dvt/allegro-core.c   |   3 +-
 drivers/staging/media/atomisp/pci/atomisp_subdev.c |  24 +-
 drivers/staging/media/atomisp/pci/hmm/hmm.c        |   2 +-
 drivers/staging/media/imx/imx-media-csc-scaler.c   |   4 -
 drivers/staging/media/imx/imx-media-dev.c          |   7 +-
 drivers/staging/media/imx/imx7-media-csi.c         |  27 +-
 drivers/staging/mt7621-dma/Makefile                |   2 +-
 .../mt7621-dma/{mtk-hsdma.c => hsdma-mt7621.c}     |   2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   1 +
 drivers/staging/rtl8723bs/os_dep/wifi_regd.c       |   2 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |   6 +-
 drivers/staging/wfx/data_tx.c                      |  10 +-
 drivers/staging/wfx/data_tx.h                      |   1 +
 drivers/target/iscsi/cxgbit/cxgbit_target.c        |   3 +-
 drivers/tee/optee/rpc.c                            |  31 +-
 drivers/thermal/cpufreq_cooling.c                  |   2 +-
 drivers/tty/n_gsm.c                                |   3 +-
 drivers/tty/n_hdlc.c                               |  60 +-
 drivers/tty/n_null.c                               |   3 +-
 drivers/tty/n_r3964.c                              |  10 +-
 drivers/tty/n_tracerouter.c                        |   4 +-
 drivers/tty/n_tracesink.c                          |   4 +-
 drivers/tty/n_tty.c                                |  82 ++-
 drivers/tty/serial/stm32-usart.c                   |  24 +-
 drivers/tty/tty_io.c                               |  82 ++-
 drivers/usb/dwc2/hcd.c                             |  15 +-
 drivers/usb/dwc2/hcd_intr.c                        |  14 +-
 drivers/usb/dwc3/gadget.c                          |  19 +-
 drivers/usb/gadget/function/u_audio.c              |  17 +-
 drivers/usb/musb/musb_core.c                       |  31 +-
 drivers/usb/serial/ftdi_sio.c                      |   5 +-
 drivers/usb/serial/mos7720.c                       |   4 +-
 drivers/usb/serial/mos7840.c                       |   4 +-
 drivers/usb/serial/option.c                        |   3 +-
 drivers/usb/serial/pl2303.c                        |   8 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   2 +-
 drivers/vfio/pci/vfio_pci_zdev.c                   |   4 +
 drivers/vfio/vfio_iommu_type1.c                    |  48 +-
 drivers/video/fbdev/Kconfig                        |   2 +-
 drivers/virt/vboxguest/vboxguest_utils.c           |  18 +-
 drivers/w1/slaves/w1_therm.c                       |  22 +-
 drivers/watchdog/intel-mid_wdt.c                   |   8 +-
 drivers/watchdog/mei_wdt.c                         |   1 +
 drivers/watchdog/qcom-wdt.c                        |  13 +-
 fs/affs/namei.c                                    |   4 +-
 fs/btrfs/backref.c                                 |   9 +-
 fs/btrfs/backref.h                                 |   9 +-
 fs/btrfs/block-group.c                             |  29 +-
 fs/btrfs/ctree.c                                   |   7 +-
 fs/btrfs/delayed-ref.c                             |  56 +-
 fs/btrfs/delayed-ref.h                             |  16 +-
 fs/btrfs/extent-tree.c                             | 128 +---
 fs/btrfs/free-space-cache.c                        |   6 +-
 fs/btrfs/inode.c                                   |   3 +-
 fs/btrfs/relocation.c                              |   4 +-
 fs/btrfs/space-info.h                              |  17 +
 fs/ceph/caps.c                                     |  10 +-
 fs/cifs/cifs_swn.c                                 |   2 +-
 fs/cifs/connect.c                                  | 259 ++++----
 fs/cifs/dfs_cache.c                                |  33 +-
 fs/cifs/fs_context.c                               |  43 +-
 fs/debugfs/inode.c                                 |   5 +-
 fs/erofs/xattr.c                                   |  10 +-
 fs/erofs/zmap.c                                    |  10 +-
 fs/eventpoll.c                                     |   4 +-
 fs/exfat/exfat_raw.h                               |   4 +
 fs/exfat/super.c                                   |  31 +-
 fs/ext4/Kconfig                                    |   3 +-
 fs/ext4/namei.c                                    |   7 +-
 fs/f2fs/compress.c                                 |   5 +-
 fs/f2fs/data.c                                     |  12 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/file.c                                     |  30 +-
 fs/f2fs/inline.c                                   |   4 +
 fs/f2fs/super.c                                    |   3 +
 fs/gfs2/bmap.c                                     |   6 +-
 fs/gfs2/lock_dlm.c                                 |   8 +-
 fs/gfs2/recovery.c                                 |   4 +-
 fs/gfs2/util.c                                     |  16 +-
 fs/io_uring.c                                      |  17 +-
 fs/isofs/dir.c                                     |   1 +
 fs/isofs/namei.c                                   |   1 +
 fs/jffs2/summary.c                                 |   3 +
 fs/jfs/jfs_dmap.c                                  |   2 +-
 fs/nfs/nfs4proc.c                                  |  15 +-
 fs/nfsd/nfsctl.c                                   |  14 +-
 fs/ocfs2/cluster/heartbeat.c                       |   8 +-
 fs/proc/proc_sysctl.c                              |   4 +-
 fs/proc/self.c                                     |   2 +-
 fs/proc/task_mmu.c                                 |   9 +-
 fs/proc/thread_self.c                              |   7 +
 fs/pstore/platform.c                               |   4 +-
 fs/quota/quota_v2.c                                |  11 +-
 fs/ubifs/auth.c                                    |   2 +-
 fs/ubifs/replay.c                                  |   4 +-
 fs/ubifs/super.c                                   |   4 +-
 fs/zonefs/super.c                                  |   3 +
 include/acpi/acexcep.h                             |  10 +-
 include/asm-generic/vmlinux.lds.h                  |  16 +-
 include/linux/bpf.h                                |   8 +-
 include/linux/device-mapper.h                      |   5 +
 include/linux/entry-kvm.h                          |  14 +
 include/linux/eventpoll.h                          |   2 +-
 include/linux/filter.h                             |   2 +-
 include/linux/icmpv6.h                             |  28 +-
 include/linux/iommu.h                              |   4 +-
 include/linux/ipv6.h                               |   1 -
 include/linux/kexec.h                              |   5 +
 include/linux/key.h                                |   1 +
 include/linux/kgdb.h                               |   2 +
 include/linux/khugepaged.h                         |   2 +
 include/linux/memremap.h                           |   6 +
 include/linux/mfd/rohm-generic.h                   |  14 +-
 include/linux/rcupdate.h                           |   2 +
 include/linux/rmap.h                               |   3 +-
 include/linux/soundwire/sdw.h                      |   2 +
 include/linux/tpm.h                                |   5 +-
 include/linux/tty_ldisc.h                          |   3 +-
 include/linux/zsmalloc.h                           |   2 +-
 include/net/act_api.h                              |   6 +-
 include/net/icmp.h                                 |   6 +-
 include/net/tcp.h                                  |   9 +-
 include/scsi/libsas.h                              |  11 +-
 include/uapi/drm/drm_fourcc.h                      |   4 +-
 include/uapi/drm/drm_mode.h                        |  13 +-
 init/Kconfig                                       |  11 +
 init/main.c                                        |   1 +
 kernel/Makefile                                    |   2 +-
 kernel/bpf/bpf_iter.c                              |   2 +-
 kernel/bpf/bpf_lru_list.c                          |   7 +-
 kernel/bpf/devmap.c                                |   4 +-
 kernel/bpf/verifier.c                              |   3 +-
 kernel/debug/debug_core.c                          |  11 +
 kernel/debug/kdb/kdb_private.h                     |   2 +-
 kernel/entry/common.c                              |   7 +
 kernel/kcsan/core.c                                |  26 +-
 kernel/kexec_file.c                                |   5 +
 kernel/kprobes.c                                   |  31 +-
 kernel/locking/lockdep.c                           |   3 +-
 kernel/module.c                                    | 164 +++++-
 kernel/module_signature.c                          |   2 +-
 kernel/module_signing.c                            |   2 +-
 kernel/printk/printk.c                             |  28 +-
 kernel/printk/printk_safe.c                        |  16 +-
 kernel/rcu/tree.c                                  |  53 +-
 kernel/rcu/tree.h                                  |   2 +-
 kernel/rcu/tree_plugin.h                           |  31 +-
 kernel/sched/fair.c                                |  45 +-
 kernel/sched/idle.c                                |   1 +
 kernel/seccomp.c                                   |   2 +
 kernel/smp.c                                       |   4 +
 kernel/tracepoint.c                                |  80 ++-
 mm/compaction.c                                    |  43 +-
 mm/hugetlb.c                                       |  14 +-
 mm/khugepaged.c                                    |  22 +-
 mm/memcontrol.c                                    |  30 +-
 mm/memory-failure.c                                |   6 +
 mm/memory.c                                        |  16 +-
 mm/memremap.c                                      |  15 +
 mm/slab_common.c                                   |   4 +-
 mm/slub.c                                          |   8 +-
 mm/vmscan.c                                        |   9 +-
 mm/zsmalloc.c                                      |  17 +-
 net/bluetooth/a2mp.c                               |   3 +-
 net/bluetooth/hci_core.c                           |   6 +-
 net/bluetooth/hci_request.c                        |  25 +-
 net/core/filter.c                                  |  13 +-
 net/ipv4/icmp.c                                    |   5 +-
 net/ipv6/icmp.c                                    |  18 +-
 net/ipv6/ip6_icmp.c                                |  12 +-
 net/mac80211/mesh_hwmp.c                           |   2 +-
 net/nfc/nci/uart.c                                 |   3 +-
 net/qrtr/tun.c                                     |  12 +-
 net/sched/act_api.c                                | 106 ++--
 net/sched/cls_api.c                                |  12 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   6 +-
 samples/Kconfig                                    |   2 +-
 samples/watch_queue/watch_test.c                   |   2 +-
 security/commoncap.c                               |  12 +-
 security/integrity/evm/evm_crypto.c                |   7 +-
 security/integrity/ima/ima_kexec.c                 |   3 +
 security/integrity/ima/ima_mok.c                   |   5 +-
 security/keys/Kconfig                              |   8 +-
 security/keys/key.c                                |   2 +
 security/keys/trusted-keys/trusted_tpm1.c          |  22 +-
 security/keys/trusted-keys/trusted_tpm2.c          |  22 +-
 security/selinux/hooks.c                           |   4 +
 sound/core/init.c                                  |   4 +
 sound/core/pcm.c                                   |   4 +
 sound/core/pcm_local.h                             |   1 +
 sound/core/pcm_native.c                            |  27 +-
 sound/firewire/fireface/ff-protocol-latter.c       | 118 +++-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_hdmi.c                         |   1 -
 sound/pci/hda/patch_realtek.c                      |  40 ++
 sound/soc/codecs/cpcap.c                           |  12 +-
 sound/soc/codecs/cs42l56.c                         |   3 +-
 sound/soc/codecs/max98373.c                        |   2 +-
 sound/soc/codecs/rt5682-i2c.c                      |   3 +
 sound/soc/codecs/wsa881x.c                         |   1 +
 sound/soc/fsl/Kconfig                              |   1 +
 sound/soc/generic/simple-card-utils.c              |  13 +-
 sound/soc/intel/boards/sof_sdw.c                   |   9 +-
 sound/soc/qcom/lpass-apq8016.c                     |   2 +-
 sound/soc/qcom/lpass-cpu.c                         |  30 +-
 sound/soc/qcom/lpass-lpaif-reg.h                   |   3 -
 sound/soc/qcom/lpass-sc7180.c                      |   2 +-
 sound/soc/qcom/lpass.h                             |   1 -
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  21 +
 sound/soc/qcom/qdsp6/q6routing.c                   |  18 -
 sound/soc/sh/siu.h                                 |   2 +-
 sound/soc/sh/siu_pcm.c                             |   2 +-
 sound/soc/sof/debug.c                              |   2 +-
 sound/soc/sof/intel/hda-dsp.c                      |   4 +
 sound/soc/sof/sof-pci-dev.c                        |   7 +
 sound/usb/card.h                                   |   2 +-
 sound/usb/endpoint.c                               |  87 +--
 sound/usb/implicit.c                               |   2 +
 sound/usb/pcm.c                                    |   7 +-
 tools/lib/bpf/libbpf.c                             |  22 +-
 tools/objtool/arch/x86/special.c                   |   2 +-
 tools/objtool/check.c                              |  15 +-
 tools/objtool/check.h                              |  11 +
 tools/perf/builtin-record.c                        |   2 +-
 .../pmu-events/arch/arm64/ampere/emag/cache.json   |   2 +-
 tools/perf/tests/sample-parsing.c                  |   2 +-
 tools/perf/util/cgroup.c                           |   8 +-
 tools/perf/util/event.c                            |   2 +
 tools/perf/util/evlist.c                           |   8 +
 tools/perf/util/evlist.h                           |   4 +
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  41 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.h  |   2 +
 tools/perf/util/intel-pt.c                         |  29 +-
 tools/perf/util/symbol.c                           |   7 +-
 tools/perf/util/unwind-libdw.c                     |  11 +-
 tools/testing/kunit/kunit_tool_test.py             |  14 +-
 tools/testing/scatterlist/main.c                   |   1 -
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |  33 --
 tools/testing/selftests/bpf/test_progs.c           |  13 +-
 tools/testing/selftests/bpf/test_progs.h           |   1 +
 tools/testing/selftests/bpf/test_xdp_redirect.sh   |  10 +-
 tools/testing/selftests/dmabuf-heaps/Makefile      |   2 +-
 .../trigger-synthetic_event_syntax_errors.tc       |  35 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   2 +-
 tools/testing/selftests/powerpc/eeh/eeh-basic.sh   |   2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   2 +-
 tools/testing/selftests/wireguard/netns.sh         |  15 +-
 779 files changed, 7955 insertions(+), 3974 deletions(-)


