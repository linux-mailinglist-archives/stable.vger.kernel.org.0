Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBDCE6969
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbfJ0VgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727671AbfJ0VHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:07:06 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02EB2208C0;
        Sun, 27 Oct 2019 21:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210425;
        bh=8mRT+C+hFvKGKxCsT5Hp2605/2AVGW/zOQ7u9u9RtQM=;
        h=From:To:Cc:Subject:Date:From;
        b=Hs2tPDYLBQlxW61dfbAOrIf2ofehYCt15MB2f5vQT/gcVpvRvo6M+MODXT+pKSXBe
         SekCEzbO+QqUXgorn9n2FiS76y/jU4buVgFZDGryDLjmMfIbR+/pzbTvIM3F2lWcLH
         qQ4zQu4LtE1l5+n0LF0WK147K1k+0+FZtZL1cEMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 000/119] 4.14.151-stable review
Date:   Sun, 27 Oct 2019 21:59:37 +0100
Message-Id: <20191027203259.948006506@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.151-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.151-rc1
X-KernelTest-Deadline: 2019-10-29T20:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.151 release.
There are 119 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.151-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.151-rc1

Greg KH <gregkh@linuxfoundation.org>
    RDMA/cxgb4: Do not dma memory off of the stack

Jim Mattson <jmattson@google.com>
    kvm: vmx: Basic APIC virtualization controls have three settings

Junaid Shahid <junaids@google.com>
    kvm: apic: Flush TLB after APIC mode/address change if VPIDs are in use

Jim Mattson <jmattson@google.com>
    kvm: vmx: Introduce lapic_mode enumeration

Wanpeng Li <wanpeng.li@hotmail.com>
    KVM: X86: introduce invalidate_gpa argument to tlb flush

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Fix pci_power_up()

Juergen Gross <jgross@suse.com>
    xen/netback: fix error path of xenvif_connect_data()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid cpufreq_suspend() deadlock on system shutdown

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    memstick: jmb38x_ms: Fix an error handling path in 'jmb38x_ms_probe()'

Qu Wenruo <wqu@suse.com>
    btrfs: block-group: Fix a memory leak due to missing btrfs_put_block_group()

Patrick Williams <alpawi@amazon.com>
    pinctrl: armada-37xx: swap polarity on LED group

Patrick Williams <alpawi@amazon.com>
    pinctrl: armada-37xx: fix control of pins 32 and up

Steve Wahl <steve.wahl@hpe.com>
    x86/boot/64: Make level2_kernel_pgt pages invalid outside kernel area

Roberto Bergantinos Corpas <rbergant@redhat.com>
    CIFS: avoid using MID 0xFFFF

Helge Deller <deller@gmx.de>
    parisc: Fix vmap memory leak in ioremap()/iounmap()

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: drop EXPORT_SYMBOL for outs*/ins*

David Hildenbrand <david@redhat.com>
    hugetlbfs: don't access uninitialized memmaps in pfn_range_valid_gigantic()

Qian Cai <cai@lca.pw>
    mm/page_owner: don't access uninitialized memmaps when reading /proc/pagetypeinfo

Qian Cai <cai@lca.pw>
    mm/slub: fix a deadlock in show_slab_objects()

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix reaction on bit error threshold notification

David Hildenbrand <david@redhat.com>
    fs/proc/page.c: don't access uninitialized memmaps in fs/proc/page.c

David Hildenbrand <david@redhat.com>
    drivers/base/memory.c: don't access uninitialized memmaps in soft_offline_page_store()

Hans de Goede <hdegoede@redhat.com>
    drm/amdgpu: Bail earlier when amdgpu.cik_/si_support is not set to 1

Kai-Heng Feng <kai.heng.feng@canonical.com>
    drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50

Will Deacon <will@kernel.org>
    mac80211: Reject malformed SSID elements

Will Deacon <will@kernel.org>
    cfg80211: wext: avoid copying malformed SSIDs

Junya Monden <jmonden@jp.adit-jv.com>
    ASoC: rsnd: Reinitialize bit clock inversion flag for every format setting

Evan Green <evgreen@chromium.org>
    Input: synaptics-rmi4 - avoid processing unknown IRQs

Marco Felsch <m.felsch@pengutronix.de>
    Input: da9063 - fix capability and drop KEY_SLEEP

Bart Van Assche <bvanassche@acm.org>
    scsi: ch: Make it possible to open a ch device multiple times again

Yufen Yu <yuyufen@huawei.com>
    scsi: core: try to get module before removing device

Damien Le Moal <damien.lemoal@wdc.com>
    scsi: core: save/restore command resid for error handling

Oliver Neukum <oneukum@suse.com>
    scsi: sd: Ignore a failure to sync cache due to lack of authorization

Colin Ian King <colin.king@canonical.com>
    staging: wlan-ng: fix exit return when sme->key_idx >= NUM_WEPKEYS

Paul Burton <paulburton@kernel.org>
    MIPS: tlbex: Fix build_restore_pagemask KScratch restore

Josh Poimboeuf <jpoimboe@redhat.com>
    arm64/speculation: Support 'mitigations=' cmdline option

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Use firmware to detect CPUs that are not affected by Spectre-v2

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Force SSBS on context switch

Will Deacon <will.deacon@arm.com>
    arm64: ssbs: Don't treat CPUs with SSBS as unaffected by SSB

Jeremy Linton <jeremy.linton@arm.com>
    arm64: add sysfs vulnerability show for speculative store bypass

Jeremy Linton <jeremy.linton@arm.com>
    arm64: add sysfs vulnerability show for spectre-v2

Jeremy Linton <jeremy.linton@arm.com>
    arm64: Always enable spectre-v2 vulnerability detection

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Advertise mitigation of Spectre-v2, or lack thereof

Jeremy Linton <jeremy.linton@arm.com>
    arm64: Provide a command line to disable spectre_v2 mitigation

Jeremy Linton <jeremy.linton@arm.com>
    arm64: Always enable ssb vulnerability detection

Mian Yousaf Kaukab <ykaukab@suse.de>
    arm64: enable generic CPU vulnerabilites support

Jeremy Linton <jeremy.linton@arm.com>
    arm64: add sysfs vulnerability show for meltdown

Mian Yousaf Kaukab <ykaukab@suse.de>
    arm64: Add sysfs vulnerability show for spectre-v1

Mark Rutland <mark.rutland@arm.com>
    arm64: fix SSBS sanitization

Will Deacon <will.deacon@arm.com>
    KVM: arm64: Set SCTLR_EL2.DSSBS if SSBD is forcefully disabled and !vhe

Will Deacon <will.deacon@arm.com>
    arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3

Will Deacon <will.deacon@arm.com>
    arm64: cpufeature: Detect SSBS and advertise to userspace

Marc Zyngier <marc.zyngier@arm.com>
    arm64: Get rid of __smccc_workaround_1_hvc_*

Mark Rutland <mark.rutland@arm.com>
    arm64: don't zero DIT on signal return

Shanker Donthineni <shankerd@codeaurora.org>
    arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP hardening

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Add support for checks based on a list of MIDRs

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Add MIDR encoding for Arm Cortex-A55 and Cortex-A35

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Add helpers for checking CPU MIDR against a range

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Clean up midr range helpers

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Change scope of VHE to Boot CPU feature

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Add support for features enabled early

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Restrict KPTI detection to boot-time CPUs

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Introduce weak features based on local CPU

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Group handling of features and errata workarounds

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Allow features based on local CPU scope

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Split the processing of errata work arounds

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Prepare for grouping features and errata work arounds

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Filter the entries based on a given mask

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Unify the verification

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Add flags to handle the conflicts on late CPU

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Prepare for fine grained capabilities

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Move errata processing code

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: capabilities: Move errata work around check on boot CPU

Dave Martin <dave.martin@arm.com>
    arm64: capabilities: Update prototype for enable call back

Mark Rutland <mark.rutland@arm.com>
    arm64: Introduce sysreg_clear_set()

Mark Rutland <mark.rutland@arm.com>
    arm64: add PSR_AA32_* definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: move SCTLR_EL{1,2} assertions to <asm/sysreg.h>

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Expose Arm v8.4 features

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Documentation: cpu-feature-registers: Remove RES0 fields

Dongjiu Geng <gengdongjiu@huawei.com>
    arm64: v8.4: Support for new floating point multiplication instructions

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Fix the feature type for ID register fields

Suzuki K Poulose <suzuki.poulose@arm.com>
    arm64: Expose support for optional ARMv8-A features

James Morse <james.morse@arm.com>
    arm64: sysreg: Move to use definitions for all the SCTLR bits

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix read info leaks

Johan Hovold <johan@kernel.org>
    USB: usblp: fix use-after-free on disconnect

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix memleak on disconnect

Johan Hovold <johan@kernel.org>
    USB: serial: ti_usb_3410_5052: fix port-close races

Gustavo A. R. Silva <gustavo@embeddedor.com>
    usb: udc: lpc32xx: fix bad bit shift operation

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support for ALC711

Johan Hovold <johan@kernel.org>
    USB: legousbtower: fix memleak on disconnect

Matthew Wilcox (Oracle) <willy@infradead.org>
    memfd: Fix locking when tagging pins

Alessio Balsini <balsini@android.com>
    loop: Add LOOP_SET_DIRECT_IO to compat ioctl

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: elf_hwcap: Export userspace ASEs

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Treat Loongson Extensions as ASEs

Eric Dumazet <edumazet@google.com>
    net: avoid potential infinite loop in tc_ctl_action()

Xin Long <lucien.xin@gmail.com>
    sctp: change sctp_prot .no_autobind with true

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: disable/enable ptp_ref_clk in suspend/resume flow

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    net: i82596: fix dma_alloc_attr for sni_82596

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Set phydev->dev_flags only for internal PHYs

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3

Stefano Brivio <sbrivio@redhat.com>
    ipv4: Return -ENETUNREACH if we can't create route but saddr is valid

Yi Li <yilikernel@gmail.com>
    ocfs2: fix panic due to ocfs2_wq is null

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/radeon: Fix EEH during kexec"

Song Liu <songliubraving@fb.com>
    md/raid0: fix warning message for parameter default_layout

Jacob Keller <jacob.e.keller@intel.com>
    namespace: fix namespace.pl script to support relative paths

Kai-Heng Feng <kai.heng.feng@canonical.com>
    r8152: Set macpassthru in reset_resume callback

Yizhuo <yzhai003@ucr.edu>
    net: hisilicon: Fix usage of uninitialized variable in function mdio_sc_cfg_reg_write()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mips: Loongson: Fix the link time qualifier of 'serial_exit()'

Miaoqing Pan <miaoqing@codeaurora.org>
    mac80211: fix txq null pointer dereference

Miaoqing Pan <miaoqing@codeaurora.org>
    nl80211: fix null pointer dereference

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen/efi: Set nonblocking callbacks

Oleksij Rempel <o.rempel@pengutronix.de>
    MIPS: dts: ar9331: fix interrupt-controller size

Michal Vokáč <michal.vokac@ysoft.com>
    net: dsa: qca8k: Use up to 7 ports for all operations

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ARM: dts: am4372: Set memory bandwidth limit for DISPC

Navid Emamdoost <navid.emamdoost@gmail.com>
    ieee802154: ca8210: prevent memory leak

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix missing reset done flag for am3 and am43

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix unbound sleep in fcport delete path.

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: megaraid: disable device when probe failed after enabled device

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: skip shutdown if hba is not powered


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  16 +-
 Documentation/arm64/cpu-feature-registers.txt      |  26 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am4372.dtsi                      |   2 +
 .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |   3 +-
 arch/arm/xen/efi.c                                 |   2 +
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/cpucaps.h                   |   6 +-
 arch/arm64/include/asm/cpufeature.h                | 250 +++++++++-
 arch/arm64/include/asm/cputype.h                   |  43 ++
 arch/arm64/include/asm/kvm_asm.h                   |   2 -
 arch/arm64/include/asm/kvm_host.h                  |  11 +
 arch/arm64/include/asm/processor.h                 |  22 +-
 arch/arm64/include/asm/ptrace.h                    |  58 ++-
 arch/arm64/include/asm/sysreg.h                    |  95 +++-
 arch/arm64/include/asm/virt.h                      |   6 -
 arch/arm64/include/uapi/asm/hwcap.h                |  12 +
 arch/arm64/include/uapi/asm/ptrace.h               |   1 +
 arch/arm64/kernel/bpi.S                            |  19 +-
 arch/arm64/kernel/cpu_errata.c                     | 495 ++++++++++++--------
 arch/arm64/kernel/cpufeature.c                     | 517 +++++++++++++++------
 arch/arm64/kernel/cpuinfo.c                        |  12 +
 arch/arm64/kernel/fpsimd.c                         |   1 +
 arch/arm64/kernel/head.S                           |  13 +-
 arch/arm64/kernel/process.c                        |  31 ++
 arch/arm64/kernel/ptrace.c                         |  13 +-
 arch/arm64/kernel/smp.c                            |  44 --
 arch/arm64/kernel/ssbd.c                           |  22 +
 arch/arm64/kernel/traps.c                          |   4 +-
 arch/arm64/kvm/hyp/entry.S                         |  12 -
 arch/arm64/kvm/hyp/switch.c                        |  10 -
 arch/arm64/kvm/hyp/sysreg-sr.c                     |  11 +
 arch/arm64/mm/fault.c                              |   3 +-
 arch/arm64/mm/proc.S                               |  24 +-
 arch/mips/boot/dts/qca/ar9331.dtsi                 |   2 +-
 arch/mips/include/asm/cpu-features.h               |  16 +
 arch/mips/include/asm/cpu.h                        |   4 +
 arch/mips/include/uapi/asm/hwcap.h                 |  11 +
 arch/mips/kernel/cpu-probe.c                       |  37 ++
 arch/mips/kernel/proc.c                            |   4 +
 arch/mips/loongson64/common/serial.c               |   2 +-
 arch/mips/mm/tlbex.c                               |  23 +-
 arch/parisc/mm/ioremap.c                           |  12 +-
 arch/x86/include/asm/kvm_host.h                    |   4 +-
 arch/x86/kernel/head64.c                           |  22 +-
 arch/x86/kvm/lapic.c                               |  12 +-
 arch/x86/kvm/lapic.h                               |  14 +
 arch/x86/kvm/svm.c                                 |  18 +-
 arch/x86/kvm/vmx.c                                 |  79 ++--
 arch/x86/kvm/x86.c                                 |  32 +-
 arch/x86/xen/efi.c                                 |   2 +
 arch/xtensa/kernel/xtensa_ksyms.c                  |   7 -
 drivers/base/core.c                                |   3 +
 drivers/base/memory.c                              |   3 +
 drivers/block/loop.c                               |   1 +
 drivers/cpufreq/cpufreq.c                          |  10 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  35 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  35 --
 drivers/gpu/drm/drm_edid.c                         |   3 +
 drivers/gpu/drm/radeon/radeon_drv.c                |   8 -
 drivers/infiniband/hw/cxgb4/mem.c                  |  28 +-
 drivers/input/misc/da9063_onkey.c                  |   5 +-
 drivers/input/rmi4/rmi_driver.c                    |   6 +-
 drivers/md/raid0.c                                 |   2 +-
 drivers/memstick/host/jmb38x_ms.c                  |   2 +-
 drivers/net/dsa/qca8k.c                            |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  11 +-
 drivers/net/ethernet/hisilicon/hns_mdio.c          |   6 +-
 drivers/net/ethernet/i825xx/lasi_82596.c           |   4 +-
 drivers/net/ethernet/i825xx/lib82596.c             |   4 +-
 drivers/net/ethernet/i825xx/sni_82596.c            |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  12 +-
 drivers/net/ieee802154/ca8210.c                    |   2 +-
 drivers/net/usb/r8152.c                            |   3 +-
 drivers/net/xen-netback/interface.c                |   1 -
 drivers/pci/pci.c                                  |  24 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  26 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  16 +-
 drivers/scsi/ch.c                                  |   1 -
 drivers/scsi/megaraid.c                            |   4 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   4 +
 drivers/scsi/scsi_error.c                          |   3 +
 drivers/scsi/scsi_sysfs.c                          |  11 +-
 drivers/scsi/sd.c                                  |   3 +-
 drivers/scsi/ufs/ufshcd.c                          |   3 +
 drivers/staging/wlan-ng/cfg80211.c                 |   6 +-
 drivers/usb/class/usblp.c                          |   4 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   6 +-
 drivers/usb/misc/ldusb.c                           |  20 +-
 drivers/usb/misc/legousbtower.c                    |   5 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |  10 +-
 fs/btrfs/extent-tree.c                             |   1 +
 fs/cifs/smb1ops.c                                  |   3 +
 fs/ocfs2/journal.c                                 |   3 +-
 fs/ocfs2/localalloc.c                              |   3 +-
 fs/proc/page.c                                     |  28 +-
 include/scsi/scsi_eh.h                             |   1 +
 mm/hugetlb.c                                       |   5 +-
 mm/page_owner.c                                    |   5 +-
 mm/shmem.c                                         |  18 +-
 mm/slub.c                                          |  13 +-
 net/ipv4/route.c                                   |   9 +-
 net/mac80211/debugfs_netdev.c                      |  11 +-
 net/mac80211/mlme.c                                |   5 +-
 net/sched/act_api.c                                |  13 +-
 net/sctp/socket.c                                  |   4 +-
 net/wireless/nl80211.c                             |   3 +
 net/wireless/wext-sme.c                            |   8 +-
 scripts/namespace.pl                               |  13 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/sh/rcar/core.c                           |   1 +
 112 files changed, 1773 insertions(+), 808 deletions(-)


