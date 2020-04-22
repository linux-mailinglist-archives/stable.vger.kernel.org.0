Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040551B4241
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbgDVK64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbgDVKD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:03:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23C3120784;
        Wed, 22 Apr 2020 10:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549807;
        bh=1+Q2gOos5L4a3IG+8mmwSr9J+vcA/MXQ1kadCsCEEkA=;
        h=From:To:Cc:Subject:Date:From;
        b=OTKlJ5jGsqdAX+aMY0p0pJcohNW54IcCqRCLfSte+yrZ1sgZ6KK3/E3c1MPN6mMds
         zrdCJgrrpZOioWvNSwzT3IBkoRk0sF31pU58myqVu6/atzRPvq6W0rczucft5o79+x
         iTB/KdcY9SsdcOK7SVx2Wm0tTZySWPTntmpLNwLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/125] 4.9.220-rc1 review
Date:   Wed, 22 Apr 2020 11:55:17 +0200
Message-Id: <20200422095032.909124119@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.220-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.220-rc1
X-KernelTest-Deadline: 2020-04-24T09:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.220 release.
There are 125 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.220-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.220-rc1

Samuel Neves <sneves@dei.uc.pt>
    x86/vdso: Fix lsl operand order

Evalds Iodzevics <evalds.iodzevics@gmail.com>
    x86/microcode/intel: replace sync_core() with native_cpuid_reg(eax)

Borislav Petkov <bp@suse.de>
    x86/CPU: Add native CPUID variants returning a single datum

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

Adrian Huang <ahuang12@lenovo.com>
    iommu/amd: Fix the configuration of GCR3 table root pointer

Dan Carpenter <dan.carpenter@oracle.com>
    libnvdimm: Out of bounds read in __nd_ioctl()

Jan Kara <jack@suse.cz>
    ext2: fix debug reference to ext2_xattr_cache

Randy Dunlap <rdunlap@infradead.org>
    ext2: fix empty body warnings when -Wextra is used

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: Fix possible race when shadowing region 3 tables

Vegard Nossum <vegard.nossum@oracle.com>
    compiler.h: fix error in BUILD_BUG_ON() reporting

Qian Cai <cai@lca.pw>
    percpu_counter: fix a data race at vm_committed_as

Eric Sandeen <sandeen@redhat.com>
    ext4: do not commit super on read-only bdev

Nathan Chancellor <natechancellor@gmail.com>
    powerpc/maple: Fix declaration made after definition

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/cpuinfo: fix wrong output when CPU0 is offline

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Sowjanya Komatineni <skomatineni@nvidia.com>
    clk: tegra: Fix Tegra PMC clock out parents

Dmitry Osipenko <digetx@gmail.com>
    power: supply: bq27xxx_battery: Silence deferred-probe error

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: usb: continue if clk_hw_round_rate() return zero

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak in of_unittest_platform_populate()

Arnd Bergmann <arnd@arndb.de>
    arm64: cpu_errata: include required headers

Rob Herring <robh@kernel.org>
    of: fix missing kobject init for !SYSFS && OF_DYNAMIC config

Chris Lew <clew@codeaurora.org>
    soc: qcom: smem: Use le32_to_cpu for comparison

Lior David <qca_liord@qca.qualcomm.com>
    wil6210: fix length check in __wmi_send

Mohit Aggarwal <maggarwa@codeaurora.org>
    rtc: pm8xxx: Fix issue in RTC write path

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

Timur Tabi <timur@codeaurora.org>
    Revert "gpio: set up initial state from .get_direction()"

Joe Moriarty <joe.moriarty@oracle.com>
    drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem

Nathan Chancellor <natechancellor@gmail.com>
    video: fbdev: sis: Remove unnecessary parentheses and commented code

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak on changeset destroy

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Don't release card at firmware loading error

Li Bin <huawei.libin@huawei.com>
    scsi: sg: add sg_remove_request in sg_common_write

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix switch table detection in .text.unlikely

Xiao Yang <yangx.jy@cn.fujitsu.com>
    tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation

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

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: improve comments about freeing data buffers whose page mapping is NULL

Can Guo <cang@codeaurora.org>
    scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic

Tim Stallard <code@timstallard.me.uk>
    net: ipv6: do not consider routes via gateways for anycast address check

Wang Wenhu <wenhu.wang@vivo.com>
    net: qrtr: send msgs from local of same id as broadcast

Taras Chornyi <taras.chornyi@plvision.eu>
    net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin

Taehee Yoo <ap420073@gmail.com>
    hsr: check protocol version in hsr_newlink()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: dln2: Fix sanity checking for endpoints

Nathan Chancellor <natechancellor@gmail.com>
    misc: echo: Remove unnecessary parentheses and simplify check for zero

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Wen Yang <wenyang@linux.alibaba.com>
    ipmi: fix hung processes in __get_guid()

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Remove PageReserved manipulation from drm_pci_alloc

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Fix clearing payload state on topology disable

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix crash during unmount due to race with delayed inode workers

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64/tm: Don't let userspace set regs->trap via sigreturn

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

Changwei Ge <chge@linux.alibaba.com>
    ocfs2: no need try to truncate file beyond i_size

Qian Cai <cai@lca.pw>
    ext4: fix a data race at inode->i_blocks

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

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Initialize power_state field properly

Rosioru Dragos <dragos.rosioru@nxp.com>
    crypto: mxs-dcp - fix scatterlist linearization for hash

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop block from cache on error in relocation

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

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=n

Jan Engelhardt <jengelh@inai.de>
    acpi/x86: ignore unspecified bit positions in the ACPI global lock field

Benoit Parrot <bparrot@ti.com>
    media: ti-vpe: cal: fix disable_irqs to only the intended target

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

YueHaibing <yuehaibing@huawei.com>
    misc: rtsx: set correct pcr_ops for rts522A

Josef Bacik <josef@toxicpanda.com>
    btrfs: track reloc roots based on their commit root bytenr

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove a BUG_ON() from merge_reloc_roots()

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps()

Arvind Sankar <nivedita@alum.mit.edu>
    x86/boot: Use unsigned comparison for addresses

Bob Peterson <rpeterso@redhat.com>
    gfs2: Don't demote a glock until its revokes are written

John Garry <john.garry@huawei.com>
    libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()

Andy Lutomirski <luto@kernel.org>
    selftests/x86/ptrace_syscall_32: Fix no-vDSO segfault

Michael Wang <yun.wang@linux.alibaba.com>
    sched: Avoid scale real weight down to zero

Sungbo Eo <mans0n@gorani.run>
    irqchip/versatile-fpga: Handle chained IRQs properly

Alain Volmat <avolmat@me.com>
    i2c: st: fix missing struct parameter description

Xu Wang <vulab@iscas.ac.cn>
    qlcnic: Fix bad kzalloc null test

Zheng Wei <wei.zheng@vivo.com>
    net: vxge: fix wrong __VA_ARGS__ usage

Ondrej Jirman <megous@megous.com>
    bus: sunxi-rsb: Return correct data when mixing 16-bit and 8-bit reads


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/kernel/armv8_deprecated.c               |  2 +-
 arch/arm64/kernel/cpu_errata.c                     |  2 +
 arch/mips/cavium-octeon/octeon-irq.c               |  3 +
 arch/powerpc/kernel/signal_64.c                    |  4 +-
 arch/powerpc/mm/tlb_nohash_low.S                   | 12 +++-
 arch/powerpc/platforms/maple/setup.c               | 34 +++++-----
 arch/s390/kernel/diag.c                            |  2 +-
 arch/s390/kernel/processor.c                       |  5 +-
 arch/s390/kvm/vsie.c                               |  1 +
 arch/s390/mm/gmap.c                                |  7 +-
 arch/x86/boot/compressed/head_32.S                 |  2 +-
 arch/x86/boot/compressed/head_64.S                 |  4 +-
 arch/x86/entry/entry_32.S                          |  1 +
 arch/x86/include/asm/microcode_intel.h             |  2 +-
 arch/x86/include/asm/processor.h                   | 18 +++++
 arch/x86/include/asm/vgtod.h                       |  2 +-
 arch/x86/kernel/acpi/boot.c                        |  2 +-
 arch/x86/kvm/cpuid.c                               |  3 +-
 arch/x86/kvm/vmx.c                                 | 79 +++++++---------------
 arch/x86/kvm/x86.c                                 | 11 +++
 drivers/ata/libata-pmp.c                           |  1 +
 drivers/ata/libata-scsi.c                          |  9 +--
 drivers/bus/sunxi-rsb.c                            |  2 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  4 +-
 drivers/clk/at91/clk-usb.c                         |  3 +
 drivers/clk/tegra/clk-tegra-pmc.c                  | 12 ++--
 drivers/cpufreq/powernv-cpufreq.c                  |  6 ++
 drivers/crypto/mxs-dcp.c                           | 58 ++++++++--------
 drivers/gpio/gpiolib.c                             | 31 ++-------
 drivers/gpu/drm/drm_dp_mst_topology.c              | 15 ++--
 drivers/gpu/drm/drm_pci.c                          | 25 +------
 drivers/i2c/busses/i2c-st.c                        |  1 +
 drivers/input/serio/i8042-x86ia64io.h              | 11 +++
 drivers/iommu/amd_iommu_types.h                    |  2 +-
 drivers/irqchip/irq-versatile-fpga.c               | 18 +++--
 drivers/md/dm-flakey.c                             |  5 ++
 drivers/md/dm-verity-fec.c                         |  1 +
 drivers/media/platform/ti-vpe/cal.c                | 16 ++---
 drivers/mfd/dln2.c                                 |  9 ++-
 drivers/mfd/rts5227.c                              |  1 +
 drivers/misc/echo/echo.c                           |  2 +-
 drivers/mtd/devices/phram.c                        | 15 ++--
 drivers/mtd/lpddr/lpddr_cmds.c                     |  1 -
 drivers/net/ethernet/neterion/vxge/vxge-config.h   |  2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h     | 14 ++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  2 +-
 drivers/net/wireless/ath/ath9k/main.c              |  3 +
 drivers/net/wireless/ath/wil6210/debugfs.c         |  7 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       | 22 +++++-
 drivers/net/wireless/ath/wil6210/main.c            |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  4 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |  2 +-
 drivers/net/wireless/mac80211_hwsim.c              | 12 ++--
 drivers/nvdimm/bus.c                               |  6 +-
 drivers/of/base.c                                  |  3 -
 drivers/of/unittest.c                              | 11 ++-
 drivers/power/supply/bq27xxx_battery.c             |  5 +-
 drivers/rtc/rtc-omap.c                             |  4 +-
 drivers/rtc/rtc-pm8xxx.c                           | 49 +++++++++++---
 drivers/s390/scsi/zfcp_erp.c                       |  2 +-
 drivers/scsi/sg.c                                  |  4 +-
 drivers/scsi/ufs/ufs-qcom.c                        |  2 +-
 drivers/scsi/ufs/ufshcd.c                          | 32 ++++++---
 drivers/soc/qcom/smem.c                            |  2 +-
 drivers/target/iscsi/iscsi_target.c                | 79 +++++++---------------
 drivers/target/iscsi/iscsi_target.h                |  1 -
 drivers/target/iscsi/iscsi_target_configfs.c       |  5 +-
 drivers/target/iscsi/iscsi_target_login.c          |  5 +-
 drivers/tty/ehv_bytechan.c                         | 21 +++++-
 drivers/usb/gadget/composite.c                     |  9 +++
 drivers/usb/gadget/function/f_fs.c                 |  1 +
 drivers/video/fbdev/core/fbmem.c                   |  2 +-
 drivers/video/fbdev/sis/init301.c                  |  4 +-
 fs/btrfs/async-thread.c                            |  8 +++
 fs/btrfs/async-thread.h                            |  2 +
 fs/btrfs/disk-io.c                                 | 13 ++++
 fs/btrfs/relocation.c                              | 39 +++++++----
 fs/exec.c                                          |  2 +-
 fs/ext2/xattr.c                                    |  8 +--
 fs/ext4/extents.c                                  |  8 +--
 fs/ext4/inode.c                                    |  2 +-
 fs/ext4/super.c                                    |  9 +--
 fs/gfs2/glock.c                                    |  3 +
 fs/hfsplus/attributes.c                            |  4 ++
 fs/jbd2/commit.c                                   |  7 +-
 fs/nfs/direct.c                                    |  2 +
 fs/nfs/pagelist.c                                  | 17 +++--
 fs/ocfs2/alloc.c                                   |  4 ++
 include/linux/compiler.h                           |  2 +-
 include/linux/devfreq_cooling.h                    |  2 +-
 include/linux/percpu_counter.h                     |  4 +-
 include/linux/sched.h                              |  4 +-
 include/net/ip6_route.h                            |  1 +
 include/target/iscsi/iscsi_target_core.h           |  2 +-
 kernel/cpu.c                                       |  5 +-
 kernel/kmod.c                                      |  4 +-
 kernel/locking/lockdep.c                           |  4 ++
 kernel/locking/locktorture.c                       |  8 +--
 kernel/sched/sched.h                               |  8 ++-
 kernel/signal.c                                    |  2 +-
 kernel/trace/trace_events_trigger.c                | 10 +--
 mm/page_alloc.c                                    |  8 +--
 net/hsr/hsr_netlink.c                              |  9 ++-
 net/ipv4/devinet.c                                 | 13 ++--
 net/qrtr/qrtr.c                                    |  7 +-
 security/keys/key.c                                |  2 +-
 security/keys/keyctl.c                             |  4 +-
 sound/core/oss/pcm_plugin.c                        | 32 ++++++---
 sound/pci/hda/hda_beep.c                           |  6 +-
 sound/pci/hda/hda_codec.c                          |  1 +
 sound/pci/hda/hda_intel.c                          | 35 ++++++----
 sound/pci/ice1712/prodigy_hifi.c                   |  4 +-
 sound/soc/intel/atom/sst-atom-controls.c           |  2 +-
 sound/soc/intel/atom/sst/sst_pci.c                 |  2 +-
 sound/soc/soc-dapm.c                               |  8 ++-
 sound/soc/soc-ops.c                                |  4 +-
 sound/soc/soc-pcm.c                                |  6 +-
 sound/soc/soc-topology.c                           |  2 +-
 sound/usb/mixer.c                                  |  2 +-
 sound/usb/mixer_maps.c                             | 28 ++++++++
 tools/gpio/Makefile                                |  2 +-
 tools/objtool/check.c                              |  5 +-
 tools/testing/selftests/x86/ptrace_syscall.c       |  8 ++-
 124 files changed, 685 insertions(+), 454 deletions(-)


