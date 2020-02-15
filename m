Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F7E15FBBD
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgBOApd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 19:45:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727529AbgBOApd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 19:45:33 -0500
Received: from localhost (unknown [38.98.37.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63610206CC;
        Sat, 15 Feb 2020 00:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581727531;
        bh=2qRbLEsZwID+5im6zHRlA6oeKNUcTkriB2ipsIr9940=;
        h=Date:From:To:Cc:Subject:From;
        b=iyrc6OFiMNHR318D+XEStaDBFPJXRuXBTDfyiWsU80iOwVH88qdC/dZBqLtg3Gw/2
         U1wFTDroy/iEMH0MBeRXDiqA+7CKwBYHw9x/0+j3Ywg8s0srzle6oqkcBZskvLrPpI
         TjBhTRCQCqck/S6dUGNfJciKP/gwyl1AlsJQ0YPc=
Date:   Fri, 14 Feb 2020 19:42:34 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.4
Message-ID: <20200215004234.GA28708@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.4 kernel.

All users of the 5.5 kernel series must upgrade.

The updated 5.5.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.5.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml  |    8 -
 Makefile                                                   |    2=20
 arch/arc/boot/dts/axs10x_mb.dtsi                           |    1=20
 arch/arm/boot/dts/am43xx-clocks.dtsi                       |   54 ++++++++
 arch/arm/boot/dts/at91sam9260.dtsi                         |   12 -
 arch/arm/boot/dts/at91sam9261.dtsi                         |    6=20
 arch/arm/boot/dts/at91sam9263.dtsi                         |    6=20
 arch/arm/boot/dts/at91sam9g45.dtsi                         |    8 -
 arch/arm/boot/dts/at91sam9rl.dtsi                          |    8 -
 arch/arm/boot/dts/meson8.dtsi                              |    4=20
 arch/arm/boot/dts/meson8b.dtsi                             |    4=20
 arch/arm/boot/dts/sama5d3.dtsi                             |   28 ++--
 arch/arm/boot/dts/sama5d3_can.dtsi                         |    4=20
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                        |    1=20
 arch/arm/boot/dts/sama5d3_uart.dtsi                        |    4=20
 arch/arm/crypto/chacha-glue.c                              |    4=20
 arch/arm/mach-at91/pm.c                                    |    9 +
 arch/arm/mm/init.c                                         |    2=20
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts           |    4=20
 arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts |    2=20
 arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi                  |    1=20
 arch/arm64/boot/dts/qcom/msm8998.dtsi                      |    2=20
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts             |    1=20
 arch/arm64/kernel/cpufeature.c                             |   39 +++++-
 arch/arm64/kernel/entry.S                                  |    5=20
 arch/arm64/kernel/fpsimd.c                                 |   30 ++++
 arch/arm64/kernel/ptrace.c                                 |   21 +++
 arch/arm64/kvm/hyp/switch.c                                |   10 +
 arch/arm64/kvm/va_layout.c                                 |   56 +++-----
 arch/mips/loongson64/platform.c                            |    3=20
 arch/powerpc/Kconfig.debug                                 |    2=20
 arch/powerpc/mm/pgtable_32.c                               |    1=20
 arch/powerpc/platforms/pseries/iommu.c                     |   54 ++++----
 arch/powerpc/platforms/pseries/papr_scm.c                  |    2=20
 arch/powerpc/platforms/pseries/vio.c                       |    2=20
 arch/x86/boot/compressed/acpi.c                            |    6=20
 arch/x86/kernel/alternative.c                              |    1=20
 crypto/testmgr.c                                           |   20 ++-
 drivers/base/regmap/regmap.c                               |   17 +-
 drivers/clk/meson/g12a.c                                   |    1=20
 drivers/crypto/atmel-sha.c                                 |    7 -
 drivers/crypto/axis/artpec6_crypto.c                       |    2=20
 drivers/crypto/caam/caamalg_qi2.c                          |    2=20
 drivers/dma/dma-axi-dmac.c                                 |   10 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c                    |    3=20
 drivers/infiniband/core/addr.c                             |    2=20
 drivers/infiniband/core/cma.c                              |    2=20
 drivers/infiniband/core/ib_core_uverbs.c                   |    2=20
 drivers/infiniband/core/sa_query.c                         |    4=20
 drivers/infiniband/core/umem.c                             |    9 -
 drivers/infiniband/core/uverbs_main.c                      |   32 ++---
 drivers/infiniband/hw/i40iw/i40iw_main.c                   |    2=20
 drivers/infiniband/hw/mlx4/cm.c                            |   29 ----
 drivers/infiniband/hw/mlx4/main.c                          |   20 ++-
 drivers/infiniband/hw/mlx5/ib_virt.c                       |   28 +---
 drivers/infiniband/hw/mlx5/mr.c                            |    2=20
 drivers/infiniband/hw/mlx5/odp.c                           |   19 ++-
 drivers/infiniband/ulp/srp/ib_srp.c                        |    3=20
 drivers/iommu/arm-smmu-v3.c                                |    1=20
 drivers/md/bcache/journal.c                                |   80 ++++++++=
+++-
 drivers/media/i2c/adv748x/adv748x.h                        |    8 -
 drivers/mfd/Kconfig                                        |    1=20
 drivers/mtd/nand/onenand/onenand_base.c                    |   82 ++++++--=
-----
 drivers/mtd/parsers/sharpslpart.c                          |    4=20
 drivers/net/netdevsim/bus.c                                |   64 ++++++++=
+-
 drivers/net/netdevsim/dev.c                                |   13 +-
 drivers/net/netdevsim/health.c                             |    2=20
 drivers/net/netdevsim/netdevsim.h                          |    4=20
 drivers/net/wireless/ath/ath10k/pci.c                      |   19 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c     |    5=20
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c          |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c              |   10 +
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c        |   71 ++++++++=
+--
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.h        |    4=20
 drivers/net/wireless/marvell/libertas/cfg.c                |    2=20
 drivers/net/wireless/marvell/mwifiex/scan.c                |    7 +
 drivers/net/wireless/marvell/mwifiex/wmm.c                 |    4=20
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c         |    3=20
 drivers/pci/controller/pci-tegra.c                         |    2=20
 drivers/pci/iov.c                                          |    9 -
 drivers/pci/pcie/aer.c                                     |    1=20
 drivers/pci/setup-bus.c                                    |   20 ++-
 drivers/pci/switch/switchtec.c                             |    4=20
 drivers/pinctrl/intel/pinctrl-baytrail.c                   |   19 +--
 drivers/pinctrl/qcom/pinctrl-msm.c                         |    5=20
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c                       |    4=20
 drivers/pinctrl/sh-pfc/pfc-r8a77965.c                      |    6=20
 drivers/platform/x86/intel_mid_powerbtn.c                  |    5=20
 drivers/rtc/rtc-cmos.c                                     |    2=20
 drivers/rtc/rtc-hym8563.c                                  |    2=20
 drivers/rtc/rtc-mt6397.c                                   |   10 -
 drivers/scsi/ufs/ufshcd.c                                  |    3=20
 drivers/soc/qcom/rpmhpd.c                                  |    2=20
 drivers/watchdog/qcom-wdt.c                                |    2=20
 drivers/watchdog/stm32_iwdg.c                              |   18 ++
 fs/nfs/Kconfig                                             |    2=20
 fs/nfs/direct.c                                            |    4=20
 fs/nfs/nfs3xdr.c                                           |    5=20
 fs/nfs/nfs42proc.c                                         |   36 ++++-
 fs/nfs/nfs4_fs.h                                           |    4=20
 fs/nfs/nfs4proc.c                                          |   19 ++-
 fs/nfs/nfs4renewd.c                                        |    5=20
 fs/nfs/nfs4state.c                                         |    4=20
 fs/nfs/nfs4trace.h                                         |   33 ++---
 fs/nfs/nfs4xdr.c                                           |    5=20
 fs/nfs/pnfs.c                                              |    4=20
 fs/nfs/pnfs_nfs.c                                          |    7 -
 fs/nfs/write.c                                             |   12 +
 include/linux/mlx5/driver.h                                |    5=20
 include/rdma/ib_verbs.h                                    |    3=20
 kernel/sched/core.c                                        |    6=20
 net/core/bpf_sk_storage.c                                  |    5=20
 net/core/sock_map.c                                        |   28 ++--
 net/netfilter/nf_flow_table_core.c                         |    8 -
 net/netfilter/nf_flow_table_offload.c                      |   11 +
 security/selinux/avc.c                                     |   42 +++---
 security/selinux/hooks.c                                   |   26 +++-
 security/selinux/include/avc.h                             |   13 +-
 sound/soc/soc-generic-dmaengine-pcm.c                      |   16 +-
 tools/bpf/bpftool/prog.c                                   |    2=20
 tools/power/acpi/Makefile.config                           |    2=20
 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c     |   74 ++++++++=
+++
 virt/kvm/arm/aarch32.c                                     |   14 +-
 virt/kvm/arm/arch_timer.c                                  |    3=20
 virt/kvm/arm/mmu.c                                         |    3=20
 virt/kvm/arm/pmu.c                                         |   42 ++++--
 virt/kvm/arm/vgic/vgic-its.c                               |    3=20
 127 files changed, 1106 insertions(+), 463 deletions(-)

Akshu Agrawal (1):
      i2c: cros-ec-tunnel: Fix slave device enumeration

Alexandre Belloni (2):
      ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
      ARM: dts: at91: sama5d3: define clock rate range for tcb1

Alexandru Elisei (1):
      KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer

Alexey Kardashevskiy (1):
      powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-mult=
i-tce for DDW

Andy Shevchenko (2):
      rtc: cmos: Stop using shared IRQ
      pinctrl: baytrail: Allocate IRQ chip dynamic

Ard Biesheuvel (1):
      crypto: arm/chacha - fix build failured when kernel mode NEON is disa=
bled

Artemy Kovalyov (1):
      RDMA/umem: Fix ib_umem_find_best_pgsz()

Avraham Stern (1):
      iwlwifi: mvm: avoid use after free for pmsr request

Bartosz Golaszewski (1):
      mfd: max77650: Select REGMAP_IRQ in Kconfig

Baruch Siach (1):
      arm64: dts: marvell: clearfog-gt-8k: fix switch cpu port node

Bean Huo (1):
      scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_ad=
d_wlus() fails

Ben Whitten (1):
      regmap: fix writes to non incrementing registers

Beniamin Bia (1):
      dt-bindings: iio: adc: ad7606: Fix wrong maxItems value

Bjorn Andersson (1):
      arm64: dts: qcom: msm8998-mtp: Add alias for blsp1_uart3

Bryan O'Donoghue (1):
      ath10k: pci: Only dump ATH10K_MEM_REGION_TYPE_IOREG when safe

Christophe Leroy (2):
      powerpc/ptdump: Fix W+X verification call in mark_rodata_ro()
      powerpc/ptdump: Only enable PPC_CHECK_WX with STRICT_KERNEL_RWX

Christophe Roullier (1):
      drivers: watchdog: stm32_iwdg: set WDOG_HW_RUNNING at probe

Chuhong Yuan (1):
      dmaengine: axi-dmac: add a check for devm_regmap_init_mmio

Claudiu Beznea (2):
      ARM: at91: pm: use SAM9X60 PMC's compatible
      ARM: at91: pm: use of_device_id array to find the proper shdwc node

Coly Li (1):
      bcache: avoid unnecessary btree nodes flushing in btree_flush_write()

Danit Goldberg (1):
      IB/mlx5: Return the administrative GUID if exists

Dave Hansen (1):
      x86/alternatives: add missing insn.h include

Dongdong Liu (1):
      PCI/AER: Initialize aer_fifo

Douglas Anderson (1):
      soc: qcom: rpmhpd: Set 'active_only' for active only power domains

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix TDLS discovery with the new firmware API

Eric Auger (3):
      KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections
      KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset
      KVM: arm64: pmu: Fix chained SW_INCR counters

Eric Biggers (3):
      crypto: testmgr - don't try to decrypt uninitialized buffers
      crypto: artpec6 - return correct error code for failed setkey()
      crypto: atmel-sha - fix error handling when setting hmac key

Gavin Shan (1):
      KVM: arm/arm64: Fix young bit from mmu notifier

Geert Uytterhoeven (3):
      nfs: NFS_SWAP should depend on SWAP
      pinctrl: sh-pfc: r8a77965: Fix DU_DOTCLKIN3 drive/bias control
      pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B

Greg Kroah-Hartman (1):
      Linux 5.5.4

Gustavo A. R. Silva (1):
      media: i2c: adv748x: Fix unsafe macros

Horia Geant=C4=83 (1):
      crypto: caam/qi2 - fix typo in algorithm's driver name

H=C3=A5kon Bugge (2):
      IB/mlx4: Fix leak in id_map_find_del
      RDMA/netlink: Do not always generate an ACK for some netlink operatio=
ns

Ingo van Lil (1):
      ARM: dts: at91: Reenable UART TX pull-ups

Jack Morgenstein (1):
      IB/mlx4: Fix memory leak in add_gid error flow

Jakub Sitnicki (3):
      bpf, sockmap: Don't sleep while holding RCU lock on tear-down
      bpf, sockhash: Synchronize_rcu before free'ing map
      selftests/bpf: Test freeing sockmap/sockhash with a socket in it

James Morse (2):
      KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests
      KVM: arm: Make inject_abt32() inject an external abort instead

Jason Gunthorpe (3):
      RDMA/core: Fix locking in ib_uverbs_event_read
      RDMA/mlx5: Fix handling of IOVA !=3D user_va in ODP paths
      RDMA/core: Ensure that rdma_user_mmap_entry_remove() is a fence

Jeffrey Hugo (1):
      arm64: dts: qcom: msm8998: Fix tcsr syscon size

Jerome Brunet (1):
      clk: meson: g12a: fix missing uart2 in regmap table

Jose Abreu (1):
      ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node

Kuninori Morimoto (1):
      arm64: dts: renesas: r8a77990: ebisu: Remove clkout-lr-synchronous fr=
om sound

Logan Gunthorpe (2):
      PCI/switchtec: Fix vep_vector_number ioread width
      PCI: Don't disable bridge BARs when assigning bus resources

Lorenz Bauer (1):
      bpf, sockmap: Check update requirements after locking

Lorenzo Bianconi (1):
      mt76: mt7615: fix max_nss in mt7615_eeprom_parse_hw_cap

Marcel Ziswiler (1):
      PCI: tegra: Fix afi_pex2_ctrl reg offset for Tegra30

Mark Brown (1):
      arm64: kernel: Correct annotation of end of el0_sync

Martin Blumenstingl (2):
      ARM: dts: meson8: use the actual frequency for the GPU's 182.1MHz OPP
      ARM: dts: meson8b: use the actual frequency for the GPU's 364MHz OPP

Martin KaFai Lau (1):
      bpf: Improve bucket_log calculation logic

Michael Guralnik (1):
      RDMA/uverbs: Verify MR access flags

Mika Westerberg (1):
      platform/x86: intel_mid_powerbtn: Take a copy of ddata

Nathan Chancellor (1):
      mtd: onenand_base: Adjust indentation in onenand_read_ops_nolock

Navid Emamdoost (1):
      PCI/IOV: Fix memory leak in pci_iov_add_virtfn()

Nicolai Stange (2):
      libertas: don't exit from lbs_ibss_join_existing() with RCU read lock=
 held
      libertas: make lbs_ibss_join_existing() return error code on rates ov=
erflow

Olga Kornievskaia (1):
      NFSv4.x recover from pre-mature loss of openstateid

Olof Johansson (1):
      ARM: 8949/1: mm: mark free_memmap as __init

Pablo Neira Ayuso (2):
      netfilter: flowtable: fetch stats only if flow is still alive
      netfilter: flowtable: restrict flow dissector match on meta ingress d=
evice

Parav Pandit (1):
      RDMA/cma: Fix unbalanced cm_id reference count during address resolve

Paul Blakey (2):
      netfilter: flowtable: Fix hardware flush order on nf_flow_table_clean=
up
      netfilter: flowtable: Fix missing flush hardware on table free

Paul Kocialkowski (1):
      rtc: hym8563: Return -EINVAL if the time is known to be invalid

Qais Yousef (1):
      sched/uclamp: Fix a bug in propagating uclamp value in new cgroups

Qing Xu (2):
      mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv=
()

Ram Pai (1):
      Revert "powerpc/pseries/iommu: Don't use dma_iommu_ops on secure gues=
ts"

Raul E Rangel (1):
      i2c: cros-ec-tunnel: Fix ACPI identifier

Robert Milkowski (2):
      NFSv4: try lease recovery on NFS4ERR_EXPIRED
      NFSv4.0: nfs4_do_fsinfo() should not do implicit lease renewals

Russell King (2):
      arm64: dts: uDPU: fix broken ethernet
      arm64: kvm: Fix IDMAP overlap with HYP VA

Sai Prakash Ranjan (1):
      watchdog: qcom: Use platform_get_irq_optional() for bark irq

Sergey Gorenko (1):
      IB/srp: Never use immediate data if it is disabled by a user

Shameer Kolothum (1):
      iommu/arm-smmu-v3: Populate VMID field for CMDQ_OP_TLBI_NH_VA

Shengjiu Wang (1):
      ASoC: soc-generic-dmaengine-pcm: Fix error handling

Stephen Boyd (1):
      pinctrl: qcom: Don't lock around irq_set_irq_wake()

Stephen Smalley (3):
      selinux: revert "stop passing MAY_NOT_BLOCK to the AVC upon follow_li=
nk"
      selinux: fix regression introduced by move_mount(2) syscall
      selinux: fall back to ref-walk if audit is required

Steven Clarkson (1):
      x86/boot: Handle malformed SRAT tables during early ACPI parsing

Suzuki K Poulose (4):
      arm64: cpufeature: Fix the type of no FP/SIMD capability
      arm64: cpufeature: Set the FP/SIMD compat HWCAP bits properly
      arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations
      arm64: nofpsmid: Handle TIF_FOREIGN_FPSTATE flag cleanly

Taehee Yoo (4):
      netdevsim: fix using uninitialized resources
      netdevsim: disable devlink reload when resources are being used
      netdevsim: fix panic in nsim_dev_take_snapshot_write()
      netdevsim: use __GFP_NOWARN to avoid memalloc warning

Tero Kristo (1):
      ARM: dts: am43xx: add support for clkout1 clock

Tiezhu Yang (1):
      MIPS: Loongson: Fix potential NULL dereference in loongson3_platform_=
init()

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      bpftool: Don't crash on missing xlated program instructions

Trond Myklebust (4):
      NFS: Revalidate the file size on a fatal write error
      NFS/pnfs: Fix pnfs_generic_prepare_to_resend_writes()
      NFS: Fix fix of show_nfs_errors
      NFSv4: pnfs_roc() must use cred_fscmp() to compare creds

Tyrel Datwyler (1):
      powerpc/pseries/vio: Fix iommu_table use-after-free refcount warning

Vaibhav Jain (1):
      powerpc/papr_scm: Fix leaking 'bus_desc.provider_name' in some paths

Wei Yongjun (1):
      rtc: mt6397: drop free_irq of devm_ allocated irq

Wesley Sheng (1):
      PCI/switchtec: Use dma_set_mask_and_coherent()

Xiyu Yang (1):
      RDMA/i40iw: fix a potential NULL pointer dereference

YueHaibing (1):
      mtd: sharpslpart: Fix unsigned comparison to zero

Zhengyuan Liu (1):
      tools/power/acpi: fix compilation error


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5HPnoACgkQONu9yGCS
aT5Dyg//VJLnIzEDahwX6gxqc97HesWcykA6FFpoL5FwVep0Qozg+4UJsSDBU0tE
Cfd+cVACkm9PbsUSauIhyq8h3XBSb237/Aaz2x/SZLDlfjg9Xdwtld5+MVbZtKQV
Y/r8n+uH9lBsZ+Kk8wdHROc/dcdj63X88uKZJGmZ9xxe+3cOupt2pxD9xBFYwS7m
7U7mnVpbONn8/+kOrY/QG8qx95ANNP30fPv6oGsOoymVpENhtMBbH5Z+91WWP0GT
coELqfpaZm/y5iLZ7NlunjRzfcqBYa6y84+R27SvRezOl45blgv7PCSsqcztIDpb
YsMc9tzCJEEewpGRY0P+6lWGEixyrNGhWRCdyNQOY70G8OWBXUtvdkN0osYDeDoe
P/hnbdLocnbIUcksv6y2Bg6IS1og3J35ZdZKXIYzA0bBbiOZTFmOrQqtUyA4rCxl
U3X/QyMoPT0TzkGPMnt+aKUFDAIqyeFHXzoGkFfozeoZccehhUveTe3w7+bDIO2W
f6bOUnj7FNkidkuqr7QFjxq/4lsrV9ZeyOAwZgIEUfGVplJhO9N/yfCLBbEjGRT0
/1/ZeQZF4mwifTvrSXZwahTF9S2KNCI6YOfCjRkXX4bCS+A47NDd0u870z8Hgglp
y/PF4sxo2RlKTf1EWlgxYrjG3qDfRYBed5YOHieo/+UUa5TYB3I=
=s966
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
