Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0693E8420
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 10:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfJ2JTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 05:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730665AbfJ2JTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 05:19:08 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFDC20717;
        Tue, 29 Oct 2019 09:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572340746;
        bh=5WYeM91U85M7/9vZ93zeyUnPbLtmTVPxfGqSdyQGLBU=;
        h=Date:From:To:Cc:Subject:From;
        b=mIGahF4zC/7P+oabdhY9bdkY2a4Tnj1fumFNdz0e7hlyDZ+ZmVWUn6/lyTImv/CNP
         hEpBBx2525pGdfVQOYOquI11aORo4+K3lp1gtF3vwFK+cq18MUOXEUoO9YeeTb1wPy
         AITpPDdbhWp6nqvnc8Os2wZ8PQtUX0IGCKbsj/cM=
Date:   Tue, 29 Oct 2019 10:19:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.151
Message-ID: <20191029091904.GA581861@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.151 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt         |   16=20
 Documentation/arm64/cpu-feature-registers.txt           |   26=20
 Makefile                                                |    2=20
 arch/arm/boot/dts/am4372.dtsi                           |    2=20
 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |    3=20
 arch/arm/xen/efi.c                                      |    2=20
 arch/arm64/Kconfig                                      |    1=20
 arch/arm64/include/asm/cpucaps.h                        |    6=20
 arch/arm64/include/asm/cpufeature.h                     |  250 +++++++
 arch/arm64/include/asm/cputype.h                        |   43 +
 arch/arm64/include/asm/kvm_asm.h                        |    2=20
 arch/arm64/include/asm/kvm_host.h                       |   11=20
 arch/arm64/include/asm/processor.h                      |   22=20
 arch/arm64/include/asm/ptrace.h                         |   58 +
 arch/arm64/include/asm/sysreg.h                         |   95 ++
 arch/arm64/include/asm/virt.h                           |    6=20
 arch/arm64/include/uapi/asm/hwcap.h                     |   12=20
 arch/arm64/include/uapi/asm/ptrace.h                    |    1=20
 arch/arm64/kernel/bpi.S                                 |   19=20
 arch/arm64/kernel/cpu_errata.c                          |  495 +++++++++--=
----
 arch/arm64/kernel/cpufeature.c                          |  517 +++++++++++=
-----
 arch/arm64/kernel/cpuinfo.c                             |   12=20
 arch/arm64/kernel/fpsimd.c                              |    1=20
 arch/arm64/kernel/head.S                                |   13=20
 arch/arm64/kernel/process.c                             |   31=20
 arch/arm64/kernel/ptrace.c                              |   13=20
 arch/arm64/kernel/smp.c                                 |   44 -
 arch/arm64/kernel/ssbd.c                                |   22=20
 arch/arm64/kernel/traps.c                               |    4=20
 arch/arm64/kvm/hyp/entry.S                              |   12=20
 arch/arm64/kvm/hyp/switch.c                             |   10=20
 arch/arm64/kvm/hyp/sysreg-sr.c                          |   11=20
 arch/arm64/mm/fault.c                                   |    3=20
 arch/arm64/mm/proc.S                                    |   24=20
 arch/mips/boot/dts/qca/ar9331.dtsi                      |    2=20
 arch/mips/loongson64/common/serial.c                    |    2=20
 arch/mips/mm/tlbex.c                                    |   23=20
 arch/parisc/mm/ioremap.c                                |   12=20
 arch/x86/include/asm/kvm_host.h                         |    4=20
 arch/x86/kernel/head64.c                                |   22=20
 arch/x86/kvm/lapic.c                                    |   12=20
 arch/x86/kvm/lapic.h                                    |   14=20
 arch/x86/kvm/svm.c                                      |   18=20
 arch/x86/kvm/vmx.c                                      |   79 +-
 arch/x86/kvm/x86.c                                      |   32=20
 arch/x86/xen/efi.c                                      |    2=20
 arch/xtensa/kernel/xtensa_ksyms.c                       |    7=20
 drivers/base/core.c                                     |    3=20
 drivers/base/memory.c                                   |    3=20
 drivers/block/loop.c                                    |    1=20
 drivers/cpufreq/cpufreq.c                               |   10=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                 |   35 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                 |   35 -
 drivers/gpu/drm/drm_edid.c                              |    3=20
 drivers/gpu/drm/radeon/radeon_drv.c                     |    8=20
 drivers/infiniband/hw/cxgb4/mem.c                       |   28=20
 drivers/input/misc/da9063_onkey.c                       |    5=20
 drivers/input/rmi4/rmi_driver.c                         |    6=20
 drivers/md/raid0.c                                      |    2=20
 drivers/memstick/host/jmb38x_ms.c                       |    2=20
 drivers/net/dsa/qca8k.c                                 |    4=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.h          |    1=20
 drivers/net/ethernet/broadcom/genet/bcmmii.c            |   11=20
 drivers/net/ethernet/hisilicon/hns_mdio.c               |    6=20
 drivers/net/ethernet/i825xx/lasi_82596.c                |    4=20
 drivers/net/ethernet/i825xx/lib82596.c                  |    4=20
 drivers/net/ethernet/i825xx/sni_82596.c                 |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       |   12=20
 drivers/net/ieee802154/ca8210.c                         |    2=20
 drivers/net/usb/r8152.c                                 |    3=20
 drivers/net/xen-netback/interface.c                     |    1=20
 drivers/pci/pci.c                                       |   24=20
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c             |   26=20
 drivers/s390/scsi/zfcp_fsf.c                            |   16=20
 drivers/scsi/ch.c                                       |    1=20
 drivers/scsi/megaraid.c                                 |    4=20
 drivers/scsi/qla2xxx/qla_target.c                       |    4=20
 drivers/scsi/scsi_error.c                               |    3=20
 drivers/scsi/scsi_sysfs.c                               |   11=20
 drivers/scsi/sd.c                                       |    3=20
 drivers/scsi/ufs/ufshcd.c                               |    3=20
 drivers/staging/wlan-ng/cfg80211.c                      |    6=20
 drivers/usb/class/usblp.c                               |    4=20
 drivers/usb/gadget/udc/lpc32xx_udc.c                    |    6=20
 drivers/usb/misc/ldusb.c                                |   20=20
 drivers/usb/misc/legousbtower.c                         |    5=20
 drivers/usb/serial/ti_usb_3410_5052.c                   |   10=20
 fs/btrfs/extent-tree.c                                  |    1=20
 fs/cifs/smb1ops.c                                       |    3=20
 fs/ocfs2/journal.c                                      |    3=20
 fs/ocfs2/localalloc.c                                   |    3=20
 fs/proc/page.c                                          |   28=20
 include/scsi/scsi_eh.h                                  |    1=20
 mm/hugetlb.c                                            |    5=20
 mm/page_owner.c                                         |    5=20
 mm/shmem.c                                              |   18=20
 mm/slub.c                                               |   13=20
 net/ipv4/route.c                                        |    9=20
 net/mac80211/debugfs_netdev.c                           |   11=20
 net/mac80211/mlme.c                                     |    5=20
 net/sched/act_api.c                                     |   13=20
 net/sctp/socket.c                                       |    4=20
 net/wireless/nl80211.c                                  |    3=20
 net/wireless/wext-sme.c                                 |    8=20
 scripts/namespace.pl                                    |   13=20
 sound/pci/hda/patch_realtek.c                           |    3=20
 sound/soc/sh/rcar/core.c                                |    1=20
 107 files changed, 1700 insertions(+), 807 deletions(-)

Alessio Balsini (1):
      loop: Add LOOP_SET_DIRECT_IO to compat ioctl

Alex Deucher (1):
      Revert "drm/radeon: Fix EEH during kexec"

Bart Van Assche (1):
      scsi: ch: Make it possible to open a ch device multiple times again

Biao Huang (1):
      net: stmmac: disable/enable ptp_ref_clk in suspend/resume flow

Christophe JAILLET (2):
      mips: Loongson: Fix the link time qualifier of 'serial_exit()'
      memstick: jmb38x_ms: Fix an error handling path in 'jmb38x_ms_probe()'

Colin Ian King (1):
      staging: wlan-ng: fix exit return when sme->key_idx >=3D NUM_WEPKEYS

Damien Le Moal (1):
      scsi: core: save/restore command resid for error handling

Dave Martin (1):
      arm64: capabilities: Update prototype for enable call back

David Hildenbrand (3):
      drivers/base/memory.c: don't access uninitialized memmaps in soft_off=
line_page_store()
      fs/proc/page.c: don't access uninitialized memmaps in fs/proc/page.c
      hugetlbfs: don't access uninitialized memmaps in pfn_range_valid_giga=
ntic()

Dongjiu Geng (1):
      arm64: v8.4: Support for new floating point multiplication instructio=
ns

Eric Dumazet (1):
      net: avoid potential infinite loop in tc_ctl_action()

Evan Green (1):
      Input: synaptics-rmi4 - avoid processing unknown IRQs

Florian Fainelli (2):
      net: bcmgenet: Fix RGMII_MODE_EN value for GENET v1/2/3
      net: bcmgenet: Set phydev->dev_flags only for internal PHYs

Greg KH (1):
      RDMA/cxgb4: Do not dma memory off of the stack

Greg Kroah-Hartman (1):
      Linux 4.14.151

Gustavo A. R. Silva (1):
      usb: udc: lpc32xx: fix bad bit shift operation

Hans de Goede (1):
      drm/amdgpu: Bail earlier when amdgpu.cik_/si_support is not set to 1

Helge Deller (1):
      parisc: Fix vmap memory leak in ioremap()/iounmap()

Jacob Keller (1):
      namespace: fix namespace.pl script to support relative paths

James Morse (1):
      arm64: sysreg: Move to use definitions for all the SCTLR bits

Jeremy Linton (6):
      arm64: add sysfs vulnerability show for meltdown
      arm64: Always enable ssb vulnerability detection
      arm64: Provide a command line to disable spectre_v2 mitigation
      arm64: Always enable spectre-v2 vulnerability detection
      arm64: add sysfs vulnerability show for spectre-v2
      arm64: add sysfs vulnerability show for speculative store bypass

Jim Mattson (2):
      kvm: vmx: Introduce lapic_mode enumeration
      kvm: vmx: Basic APIC virtualization controls have three settings

Johan Hovold (5):
      USB: legousbtower: fix memleak on disconnect
      USB: serial: ti_usb_3410_5052: fix port-close races
      USB: ldusb: fix memleak on disconnect
      USB: usblp: fix use-after-free on disconnect
      USB: ldusb: fix read info leaks

Josh Poimboeuf (1):
      arm64/speculation: Support 'mitigations=3D' cmdline option

Juergen Gross (1):
      xen/netback: fix error path of xenvif_connect_data()

Junaid Shahid (1):
      kvm: apic: Flush TLB after APIC mode/address change if VPIDs are in u=
se

Junya Monden (1):
      ASoC: rsnd: Reinitialize bit clock inversion flag for every format se=
tting

Kai-Heng Feng (2):
      r8152: Set macpassthru in reset_resume callback
      drm/edid: Add 6 bpc quirk for SDC panel in Lenovo G50

Kailang Yang (1):
      ALSA: hda/realtek - Add support for ALC711

Marc Zyngier (4):
      arm64: Get rid of __smccc_workaround_1_hvc_*
      arm64: Advertise mitigation of Spectre-v2, or lack thereof
      arm64: Force SSBS on context switch
      arm64: Use firmware to detect CPUs that are not affected by Spectre-v2

Marco Felsch (1):
      Input: da9063 - fix capability and drop KEY_SLEEP

Mark Rutland (5):
      arm64: move SCTLR_EL{1,2} assertions to <asm/sysreg.h>
      arm64: add PSR_AA32_* definitions
      arm64: Introduce sysreg_clear_set()
      arm64: don't zero DIT on signal return
      arm64: fix SSBS sanitization

Matthew Wilcox (Oracle) (1):
      memfd: Fix locking when tagging pins

Max Filippov (1):
      xtensa: drop EXPORT_SYMBOL for outs*/ins*

Mian Yousaf Kaukab (2):
      arm64: Add sysfs vulnerability show for spectre-v1
      arm64: enable generic CPU vulnerabilites support

Miaoqing Pan (2):
      nl80211: fix null pointer dereference
      mac80211: fix txq null pointer dereference

Michal Vok=C3=A1=C4=8D (1):
      net: dsa: qca8k: Use up to 7 ports for all operations

Navid Emamdoost (1):
      ieee802154: ca8210: prevent memory leak

Oleksij Rempel (1):
      MIPS: dts: ar9331: fix interrupt-controller size

Oliver Neukum (1):
      scsi: sd: Ignore a failure to sync cache due to lack of authorization

Patrick Williams (2):
      pinctrl: armada-37xx: fix control of pins 32 and up
      pinctrl: armada-37xx: swap polarity on LED group

Paul Burton (1):
      MIPS: tlbex: Fix build_restore_pagemask KScratch restore

Peter Ujfalusi (1):
      ARM: dts: am4372: Set memory bandwidth limit for DISPC

Qian Cai (2):
      mm/slub: fix a deadlock in show_slab_objects()
      mm/page_owner: don't access uninitialized memmaps when reading /proc/=
pagetypeinfo

Qu Wenruo (1):
      btrfs: block-group: Fix a memory leak due to missing btrfs_put_block_=
group()

Quinn Tran (1):
      scsi: qla2xxx: Fix unbound sleep in fcport delete path.

Rafael J. Wysocki (2):
      cpufreq: Avoid cpufreq_suspend() deadlock on system shutdown
      PCI: PM: Fix pci_power_up()

Roberto Bergantinos Corpas (1):
      CIFS: avoid using MID 0xFFFF

Ross Lagerwall (1):
      xen/efi: Set nonblocking callbacks

Shanker Donthineni (1):
      arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP hardening

Song Liu (1):
      md/raid0: fix warning message for parameter default_layout

Stanley Chu (1):
      scsi: ufs: skip shutdown if hba is not powered

Stefano Brivio (1):
      ipv4: Return -ENETUNREACH if we can't create route but saddr is valid

Steffen Maier (1):
      scsi: zfcp: fix reaction on bit error threshold notification

Steve Wahl (1):
      x86/boot/64: Make level2_kernel_pgt pages invalid outside kernel area

Suzuki K Poulose (22):
      arm64: Expose support for optional ARMv8-A features
      arm64: Fix the feature type for ID register fields
      arm64: Documentation: cpu-feature-registers: Remove RES0 fields
      arm64: Expose Arm v8.4 features
      arm64: capabilities: Move errata work around check on boot CPU
      arm64: capabilities: Move errata processing code
      arm64: capabilities: Prepare for fine grained capabilities
      arm64: capabilities: Add flags to handle the conflicts on late CPU
      arm64: capabilities: Unify the verification
      arm64: capabilities: Filter the entries based on a given mask
      arm64: capabilities: Prepare for grouping features and errata work ar=
ounds
      arm64: capabilities: Split the processing of errata work arounds
      arm64: capabilities: Allow features based on local CPU scope
      arm64: capabilities: Group handling of features and errata workarounds
      arm64: capabilities: Introduce weak features based on local CPU
      arm64: capabilities: Restrict KPTI detection to boot-time CPUs
      arm64: capabilities: Add support for features enabled early
      arm64: capabilities: Change scope of VHE to Boot CPU feature
      arm64: capabilities: Clean up midr range helpers
      arm64: Add helpers for checking CPU MIDR against a range
      arm64: Add MIDR encoding for Arm Cortex-A55 and Cortex-A35
      arm64: capabilities: Add support for checks based on a list of MIDRs

Thomas Bogendoerfer (1):
      net: i82596: fix dma_alloc_attr for sni_82596

Tony Lindgren (1):
      ARM: OMAP2+: Fix missing reset done flag for am3 and am43

Wanpeng Li (1):
      KVM: X86: introduce invalidate_gpa argument to tlb flush

Will Deacon (6):
      arm64: cpufeature: Detect SSBS and advertise to userspace
      arm64: ssbd: Add support for PSTATE.SSBS rather than trapping to EL3
      KVM: arm64: Set SCTLR_EL2.DSSBS if SSBD is forcefully disabled and !v=
he
      arm64: ssbs: Don't treat CPUs with SSBS as unaffected by SSB
      cfg80211: wext: avoid copying malformed SSIDs
      mac80211: Reject malformed SSID elements

Xiang Chen (1):
      scsi: megaraid: disable device when probe failed after enabled device

Xin Long (1):
      sctp: change sctp_prot .no_autobind with true

Yi Li (1):
      ocfs2: fix panic due to ocfs2_wq is null

Yizhuo (1):
      net: hisilicon: Fix usage of uninitialized variable in function mdio_=
sc_cfg_reg_write()

Yufen Yu (1):
      scsi: core: try to get module before removing device


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl24BAcACgkQONu9yGCS
aT7D5g/+II0u0FXs1PBYIeSeQI1867Bj4gG7P45IMddvs1+YXudQSLAw1KD2LhXd
wi3dmB5zP7+wSSoCbLHnOnqx7bro5KfLbJ++SJLQBTXzC6BSkqMrlUDDxwfdOxu1
zaHWGiH9f3G5hnbW5gWhqEwO0WZIdpK7jEvZ/afLT3RUXbxnelec5sI5BmZrh7tx
BE/F5UG6oIbBcCRDrWI/gFMmHNhEKZJxvcxCP/5dTxsgcw0Hd29NJBKzs1z0Ib26
jc4nhhxOc6oBnmO8eUAuWwNGaCNe02yzdZhYPHAsHV4lvygTj2a+QnkSgtEfmb4N
K/FAMhTkIO/tEYP2QJ3ioJA/jYPwbE4Qc7luwQM0Up452i8HZxuwD9BKJ4IgK2QS
AkTmDy8rAJt56ijhZ6iX9bdPyrGaNqO5Tq0gFlc3oj1I0XiTkI09b1a2bBXIOdJW
P3XG5iWwIswLh//E2T3elBbbl3YdXC/AW+0YxmX4KxAuG1ZhLJlrC2WKTCdTojGR
TOW1m8gKmKJe7h5JUMPqp3oGcnXzxLMslO6V/rYnBXFo3J8mcvuJb0O9L4hJTnuW
MrcUDtD0v7gp6hqmoDEcZI0js0vGIWumfmE6gzoGKZcDXRzy1v41HxFTD0bHnvxj
ZDwGUDDC+C9UV/2bzgZh8wX5YVnvhfZbxhjkLpK6EbtLYYdpQp8=
=MoGe
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
