Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AB11B5949
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgDWKeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgDWKeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 06:34:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0639120776;
        Thu, 23 Apr 2020 10:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587638055;
        bh=FhKOsBuMYtSgl4QafcyuUp1YYkxEwd/FD+7ZGe+Q0mM=;
        h=From:To:Cc:Subject:Date:From;
        b=aYvgdJZUvXGACta3AL4E37P4RBvgnc4TC9yvf5Mi/QWC15eoWoexOxeYQVpDxzw20
         8g17zDUOGfUngNU1ru+ANg93j9zkFMPJRqg+gnXLaC0D6qA1Ha0BShcF68MXf0qYw1
         dD+UEwyhiLJyQrEsv5hGjp8+Am2lefDGm+ddpVjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/99] 4.4.220-rc2 review
Date:   Thu, 23 Apr 2020 12:34:12 +0200
Message-Id: <20200423103313.886224224@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.220-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.220-rc2
X-KernelTest-Deadline: 2020-04-25T10:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.220 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Apr 2020 10:31:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.220-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.220-rc2

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

Randy Dunlap <rdunlap@infradead.org>
    ext2: fix empty body warnings when -Wextra is used

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix memory leaks in nfs_pageio_stop_mirroring()

Vegard Nossum <vegard.nossum@oracle.com>
    compiler.h: fix error in BUILD_BUG_ON() reporting

Qian Cai <cai@lca.pw>
    percpu_counter: fix a data race at vm_committed_as

Eric Sandeen <sandeen@redhat.com>
    ext4: do not commit super on read-only bdev

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
    NFS: direct.c: Fix memory leak of dreq when nfs_get_lock_context fails

Sowjanya Komatineni <skomatineni@nvidia.com>
    clk: tegra: Fix Tegra PMC clock out parents

Claudiu Beznea <claudiu.beznea@microchip.com>
    clk: at91: usb: continue if clk_hw_round_rate() return zero

Frank Rowand <frank.rowand@sony.com>
    of: unittest: kmemleak in of_unittest_platform_populate()

Rob Herring <robh@kernel.org>
    of: fix missing kobject init for !SYSFS && OF_DYNAMIC config

Chris Lew <clew@codeaurora.org>
    soc: qcom: smem: Use le32_to_cpu for comparison

Mohit Aggarwal <maggarwa@codeaurora.org>
    rtc: pm8xxx: Fix issue in RTC write path

Dedy Lansky <dlansky@codeaurora.org>
    wil6210: rate limit wil_rx_refill error

Subhash Jadavani <subhashj@codeaurora.org>
    scsi: ufs: ufs-qcom: remove broken hci version quirk

Dedy Lansky <dlansky@codeaurora.org>
    wil6210: fix temperature debugfs

Hamad Kadmany <hkadmany@codeaurora.org>
    wil6210: increase firmware ready timeout

Joe Moriarty <joe.moriarty@oracle.com>
    drm: NULL pointer dereference [null-pointer-deref] (CWE 476) problem

Nathan Chancellor <natechancellor@gmail.com>
    video: fbdev: sis: Remove unnecessary parentheses and commented code

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Don't release card at firmware loading error

Li Bin <huawei.libin@huawei.com>
    scsi: sg: add sg_remove_request in sg_common_write

Xiao Yang <yangx.jy@cn.fujitsu.com>
    tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation

Borislav Petkov <bp@suse.de>
    x86/mitigations: Clear CPU buffers on the SYSCALL fast path

Jim Mattson <jmattson@google.com>
    kvm: x86: Host feature SSBD doesn't imply guest feature SPEC_CTRL_SSBD

Goldwyn Rodrigues <rgoldwyn@suse.com>
    dm flakey: check for null arg_name in parse_features()

Jan Kara <jack@suse.cz>
    ext4: do not zeroout extents beyond i_disksize

Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
    mac80211_hwsim: Use kstrndup() in place of kasprintf()

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

Taras Chornyi <taras.chornyi@plvision.eu>
    net: ipv4: devinet: Fix crash when add/del multicast IP with autojoin

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: dln2: Fix sanity checking for endpoints

Nathan Chancellor <natechancellor@gmail.com>
    misc: echo: Remove unnecessary parentheses and simplify check for zero

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Wen Yang <wenyang@linux.alibaba.com>
    ipmi: fix hung processes in __get_guid()

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

Fredrik Strupe <fredrik@strupe.net>
    arm64: armv8_deprecated: Fix undef_hook mask for thumb setend

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix missing erp_lock in port recovery trigger for point-to-point

Alex Vesker <valex@mellanox.com>
    IB/ipoib: Fix lockdep issue found on ipoib_ib_dev_heavy_flush

Filipe Manana <fdmanana@suse.com>
    Btrfs: incremental send, fix invalid memory access

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Initialize power_state field properly

Vineeth Remanan Pillai <vineethp@amazon.com>
    xen-netfront: Rework the fix for Rx stall during OOM and network stress

Jiri Slaby <jslaby@suse.cz>
    futex: futex_wake_op, do not fail on invalid op

Rosioru Dragos <dragos.rosioru@nxp.com>
    crypto: mxs-dcp - fix scatterlist linearization for hash

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Allocate new rmap and large page tracking when moving memslot

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
 arch/mips/cavium-octeon/octeon-irq.c               |  3 ++
 arch/powerpc/kernel/signal_64.c                    |  4 +-
 arch/powerpc/mm/tlb_nohash_low.S                   | 12 ++++-
 arch/s390/kernel/diag.c                            |  2 +-
 arch/x86/boot/compressed/head_32.S                 |  2 +-
 arch/x86/boot/compressed/head_64.S                 |  4 +-
 arch/x86/entry/entry_32.S                          |  1 +
 arch/x86/entry/entry_64.S                          |  2 +
 arch/x86/include/asm/microcode_intel.h             |  2 +-
 arch/x86/include/asm/processor.h                   | 18 +++++++
 arch/x86/include/asm/spec-ctrl.h                   |  2 +
 arch/x86/include/asm/vgtod.h                       |  2 +-
 arch/x86/kernel/acpi/boot.c                        |  2 +-
 arch/x86/kernel/cpu/bugs.c                         |  5 ++
 arch/x86/kvm/cpuid.c                               |  3 +-
 arch/x86/kvm/x86.c                                 | 11 ++++
 drivers/ata/libata-pmp.c                           |  1 +
 drivers/ata/libata-scsi.c                          |  9 ++--
 drivers/bus/sunxi-rsb.c                            |  2 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  4 +-
 drivers/clk/at91/clk-usb.c                         |  3 ++
 drivers/clk/tegra/clk-tegra-pmc.c                  | 12 ++---
 drivers/crypto/mxs-dcp.c                           | 58 +++++++++++-----------
 drivers/gpu/drm/drm_dp_mst_topology.c              | 15 ++++--
 drivers/i2c/busses/i2c-st.c                        |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  7 ++-
 drivers/input/serio/i8042-x86ia64io.h              | 11 ++++
 drivers/iommu/amd_iommu_types.h                    |  2 +-
 drivers/irqchip/irq-versatile-fpga.c               | 18 +++++--
 drivers/md/dm-flakey.c                             |  5 ++
 drivers/mfd/dln2.c                                 |  9 +++-
 drivers/mfd/rts5227.c                              |  1 +
 drivers/misc/echo/echo.c                           |  2 +-
 drivers/mtd/devices/phram.c                        | 15 +++---
 drivers/mtd/lpddr/lpddr_cmds.c                     |  1 -
 drivers/net/ethernet/neterion/vxge/vxge-config.h   |  2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h     | 14 +++---
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  2 +-
 drivers/net/wireless/ath/ath9k/main.c              |  3 ++
 drivers/net/wireless/ath/wil6210/debugfs.c         |  7 +--
 drivers/net/wireless/ath/wil6210/main.c            |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  4 +-
 drivers/net/wireless/mac80211_hwsim.c              | 12 ++---
 drivers/net/xen-netfront.c                         | 14 ++++--
 drivers/of/base.c                                  |  3 --
 drivers/of/unittest.c                              |  7 ++-
 drivers/rtc/rtc-pm8xxx.c                           | 49 ++++++++++++++----
 drivers/s390/scsi/zfcp_erp.c                       |  2 +-
 drivers/scsi/sg.c                                  |  4 +-
 drivers/scsi/ufs/ufs-qcom.c                        |  2 +-
 drivers/scsi/ufs/ufshcd.c                          |  5 ++
 drivers/soc/qcom/smem.c                            |  2 +-
 drivers/tty/ehv_bytechan.c                         | 21 ++++++--
 drivers/usb/gadget/composite.c                     |  9 ++++
 drivers/usb/gadget/function/f_fs.c                 |  1 +
 drivers/video/fbdev/core/fbmem.c                   |  2 +-
 drivers/video/fbdev/sis/init301.c                  |  4 +-
 fs/btrfs/async-thread.c                            |  8 +++
 fs/btrfs/async-thread.h                            |  2 +
 fs/btrfs/disk-io.c                                 | 13 +++++
 fs/btrfs/relocation.c                              | 33 ++++++++----
 fs/btrfs/send.c                                    |  7 +--
 fs/exec.c                                          |  2 +-
 fs/ext2/xattr.c                                    |  5 +-
 fs/ext4/extents.c                                  |  8 +--
 fs/ext4/inode.c                                    |  2 +-
 fs/ext4/super.c                                    |  9 ++--
 fs/gfs2/glock.c                                    |  3 ++
 fs/hfsplus/attributes.c                            |  4 ++
 fs/jbd2/commit.c                                   |  7 +--
 fs/nfs/direct.c                                    |  2 +
 fs/nfs/pagelist.c                                  | 17 +++----
 fs/ocfs2/alloc.c                                   |  4 ++
 include/linux/compiler.h                           |  2 +-
 include/linux/devfreq_cooling.h                    |  2 +-
 include/linux/percpu_counter.h                     |  4 +-
 include/linux/sched.h                              |  4 +-
 include/net/ip6_route.h                            |  1 +
 kernel/futex.c                                     | 12 ++++-
 kernel/kmod.c                                      |  4 +-
 kernel/locking/lockdep.c                           |  4 ++
 kernel/locking/locktorture.c                       |  8 +--
 kernel/signal.c                                    |  2 +-
 kernel/trace/trace_events_trigger.c                | 10 ++--
 net/ipv4/devinet.c                                 | 13 +++--
 security/keys/key.c                                |  2 +-
 security/keys/keyctl.c                             |  4 +-
 sound/core/oss/pcm_plugin.c                        | 32 +++++++++---
 sound/pci/hda/hda_beep.c                           |  6 ++-
 sound/pci/hda/hda_codec.c                          |  1 +
 sound/pci/hda/hda_intel.c                          | 35 +++++++------
 sound/pci/ice1712/prodigy_hifi.c                   |  4 +-
 sound/soc/intel/atom/sst-atom-controls.c           |  2 +-
 sound/soc/intel/atom/sst/sst_pci.c                 |  2 +-
 sound/soc/soc-dapm.c                               |  8 ++-
 sound/soc/soc-ops.c                                |  4 +-
 sound/soc/soc-pcm.c                                |  6 ++-
 sound/soc/soc-topology.c                           |  2 +-
 sound/usb/mixer.c                                  |  2 +-
 sound/usb/mixer_maps.c                             | 28 +++++++++++
 tools/testing/selftests/x86/ptrace_syscall.c       |  8 ++-
 103 files changed, 531 insertions(+), 235 deletions(-)


