Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E8715FBB9
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgBOApP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 19:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727529AbgBOApM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 19:45:12 -0500
Received: from localhost (unknown [38.98.37.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05F66206CC;
        Sat, 15 Feb 2020 00:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581727511;
        bh=G9jVIUdvk3Vx4xgiiGFHrKfzRHbSKigpXUhl6hVUcoY=;
        h=Date:From:To:Cc:Subject:From;
        b=qG8DHUhXDG4UzW2xRkMftXLRbAskwXCNoghjb2Fpzy8tzztnU97AY9lcAGFDzZey8
         cuJP0fFDR88+O2Xe3cWqVyROcHjFEDlg77oAib0LVhbxyYQrp7SD2adQIDxQaY8eOP
         m/r6JGrMOzbc41Z715c5jRBLzXtvcB3iRZCAuGR4=
Date:   Fri, 14 Feb 2020 19:42:06 -0500
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.20
Message-ID: <20200215004206.GA28647@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.20 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/iio/adc/adi,ad7606.yaml  |    8 -
 Makefile                                                   |    2=20
 arch/arc/boot/dts/axs10x_mb.dtsi                           |    1=20
 arch/arm/boot/dts/am43xx-clocks.dtsi                       |   54 +++++++
 arch/arm/boot/dts/at91sam9260.dtsi                         |   12 -
 arch/arm/boot/dts/at91sam9261.dtsi                         |    6=20
 arch/arm/boot/dts/at91sam9263.dtsi                         |    6=20
 arch/arm/boot/dts/at91sam9g45.dtsi                         |    8 -
 arch/arm/boot/dts/at91sam9rl.dtsi                          |    8 -
 arch/arm/boot/dts/meson8.dtsi                              |    4=20
 arch/arm/boot/dts/meson8b.dtsi                             |    4=20
 arch/arm/boot/dts/sama5d3.dtsi                             |   28 +--
 arch/arm/boot/dts/sama5d3_can.dtsi                         |    4=20
 arch/arm/boot/dts/sama5d3_tcb1.dtsi                        |    1=20
 arch/arm/boot/dts/sama5d3_uart.dtsi                        |    4=20
 arch/arm/mach-at91/pm.c                                    |    9 +
 arch/arm/mm/init.c                                         |    2=20
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts           |    4=20
 arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts |    2=20
 arch/arm64/boot/dts/qcom/msm8998.dtsi                      |    2=20
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts             |    1=20
 arch/arm64/kernel/cpufeature.c                             |   39 ++++-
 arch/arm64/kernel/fpsimd.c                                 |   30 +++-
 arch/arm64/kernel/ptrace.c                                 |   21 ++
 arch/arm64/kvm/hyp/switch.c                                |   10 +
 arch/powerpc/Kconfig.debug                                 |    2=20
 arch/powerpc/mm/pgtable_32.c                               |    1=20
 arch/powerpc/platforms/pseries/iommu.c                     |   54 ++++---
 arch/powerpc/platforms/pseries/papr_scm.c                  |    2=20
 arch/powerpc/platforms/pseries/vio.c                       |    2=20
 arch/x86/boot/compressed/acpi.c                            |    6=20
 crypto/testmgr.c                                           |   20 ++
 drivers/base/regmap/regmap.c                               |   17 +-
 drivers/clk/meson/g12a.c                                   |    1=20
 drivers/crypto/atmel-sha.c                                 |    7=20
 drivers/crypto/axis/artpec6_crypto.c                       |    2=20
 drivers/crypto/caam/caamalg_qi2.c                          |    2=20
 drivers/dma/dma-axi-dmac.c                                 |   10 +
 drivers/infiniband/core/addr.c                             |    2=20
 drivers/infiniband/core/cma.c                              |    2=20
 drivers/infiniband/core/sa_query.c                         |    4=20
 drivers/infiniband/core/umem.c                             |    9 -
 drivers/infiniband/core/uverbs_main.c                      |   32 +---
 drivers/infiniband/hw/i40iw/i40iw_main.c                   |    2=20
 drivers/infiniband/hw/mlx4/cm.c                            |   29 ---
 drivers/infiniband/hw/mlx4/main.c                          |   20 ++
 drivers/infiniband/ulp/srp/ib_srp.c                        |    3=20
 drivers/iommu/arm-smmu-v3.c                                |    1=20
 drivers/md/bcache/journal.c                                |   80 ++++++++=
++
 drivers/media/i2c/adv748x/adv748x.h                        |    8 -
 drivers/mfd/Kconfig                                        |    1=20
 drivers/mtd/nand/onenand/onenand_base.c                    |   82 +++++---=
---
 drivers/mtd/parsers/sharpslpart.c                          |    4=20
 drivers/net/wireless/ath/ath10k/pci.c                      |   19 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c     |    5=20
 drivers/net/wireless/marvell/libertas/cfg.c                |    2=20
 drivers/net/wireless/marvell/mwifiex/scan.c                |    7=20
 drivers/net/wireless/marvell/mwifiex/wmm.c                 |    4=20
 drivers/pci/controller/pci-tegra.c                         |    2=20
 drivers/pci/iov.c                                          |    9 -
 drivers/pci/pcie/aer.c                                     |    1=20
 drivers/pci/setup-bus.c                                    |   20 ++
 drivers/pci/switch/switchtec.c                             |    4=20
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c                       |    4=20
 drivers/pinctrl/sh-pfc/pfc-r8a77965.c                      |    6=20
 drivers/platform/x86/intel_mid_powerbtn.c                  |    5=20
 drivers/rtc/rtc-cmos.c                                     |    2=20
 drivers/rtc/rtc-hym8563.c                                  |    2=20
 drivers/scsi/ufs/ufshcd.c                                  |    3=20
 drivers/soc/qcom/rpmhpd.c                                  |    2=20
 drivers/watchdog/qcom-wdt.c                                |    2=20
 drivers/watchdog/stm32_iwdg.c                              |   18 ++
 fs/nfs/Kconfig                                             |    2=20
 fs/nfs/direct.c                                            |    4=20
 fs/nfs/nfs3xdr.c                                           |    5=20
 fs/nfs/nfs4_fs.h                                           |    4=20
 fs/nfs/nfs4proc.c                                          |   17 +-
 fs/nfs/nfs4renewd.c                                        |    5=20
 fs/nfs/nfs4state.c                                         |    4=20
 fs/nfs/nfs4trace.h                                         |   31 ++--
 fs/nfs/nfs4xdr.c                                           |    5=20
 fs/nfs/pnfs.c                                              |    2=20
 fs/nfs/pnfs_nfs.c                                          |    7=20
 fs/nfs/write.c                                             |   12 +
 include/rdma/ib_verbs.h                                    |    3=20
 kernel/sched/core.c                                        |    6=20
 net/core/bpf_sk_storage.c                                  |    5=20
 net/core/sock_map.c                                        |   28 ++-
 net/vmw_vsock/hyperv_transport.c                           |   68 +--------
 security/selinux/avc.c                                     |   42 +++--
 security/selinux/hooks.c                                   |   26 ++-
 security/selinux/include/avc.h                             |   13 +
 sound/soc/soc-pcm.c                                        |   95 ++++++++=
+----
 tools/bpf/bpftool/prog.c                                   |    2=20
 tools/power/acpi/Makefile.config                           |    2=20
 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c     |   74 ++++++++=
++
 virt/kvm/arm/aarch32.c                                     |   14 +
 virt/kvm/arm/arch_timer.c                                  |    3=20
 virt/kvm/arm/mmu.c                                         |    3=20
 virt/kvm/arm/pmu.c                                         |   42 ++++-
 virt/kvm/arm/vgic/vgic-its.c                               |    3=20
 101 files changed, 899 insertions(+), 420 deletions(-)

Alexandre Belloni (2):
      ARM: dts: at91: sama5d3: fix maximum peripheral clock rates
      ARM: dts: at91: sama5d3: define clock rate range for tcb1

Alexandru Elisei (1):
      KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer

Alexey Kardashevskiy (1):
      powerpc/pseries: Allow not having ibm, hypertas-functions::hcall-mult=
i-tce for DDW

Andy Shevchenko (1):
      rtc: cmos: Stop using shared IRQ

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

Dongdong Liu (1):
      PCI/AER: Initialize aer_fifo

Douglas Anderson (1):
      soc: qcom: rpmhpd: Set 'active_only' for active only power domains

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
      Linux 5.4.20

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

Jason Gunthorpe (1):
      RDMA/core: Fix locking in ib_uverbs_event_read

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

Marcel Ziswiler (1):
      PCI: tegra: Fix afi_pex2_ctrl reg offset for Tegra30

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

Olof Johansson (1):
      ARM: 8949/1: mm: mark free_memmap as __init

Parav Pandit (1):
      RDMA/cma: Fix unbalanced cm_id reference count during address resolve

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

Ranjani Sridharan (1):
      ASoC: pcm: update FE/BE trigger order based on the command

Robert Milkowski (2):
      NFSv4: try lease recovery on NFS4ERR_EXPIRED
      NFSv4.0: nfs4_do_fsinfo() should not do implicit lease renewals

Russell King (1):
      arm64: dts: uDPU: fix broken ethernet

Sai Prakash Ranjan (1):
      watchdog: qcom: Use platform_get_irq_optional() for bark irq

Sergey Gorenko (1):
      IB/srp: Never use immediate data if it is disabled by a user

Shameer Kolothum (1):
      iommu/arm-smmu-v3: Populate VMID field for CMDQ_OP_TLBI_NH_VA

Stephen Smalley (3):
      selinux: revert "stop passing MAY_NOT_BLOCK to the AVC upon follow_li=
nk"
      selinux: fix regression introduced by move_mount(2) syscall
      selinux: fall back to ref-walk if audit is required

Steven Clarkson (1):
      x86/boot: Handle malformed SRAT tables during early ACPI parsing

Sunil Muthuswamy (1):
      hv_sock: Remove the accept port restriction

Suzuki K Poulose (4):
      arm64: cpufeature: Fix the type of no FP/SIMD capability
      arm64: cpufeature: Set the FP/SIMD compat HWCAP bits properly
      arm64: ptrace: nofpsimd: Fail FP/SIMD regset operations
      arm64: nofpsmid: Handle TIF_FOREIGN_FPSTATE flag cleanly

Tero Kristo (1):
      ARM: dts: am43xx: add support for clkout1 clock

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

Wesley Sheng (1):
      PCI/switchtec: Use dma_set_mask_and_coherent()

Xiyu Yang (1):
      RDMA/i40iw: fix a potential NULL pointer dereference

YueHaibing (1):
      mtd: sharpslpart: Fix unsigned comparison to zero

Zhengyuan Liu (1):
      tools/power/acpi: fix compilation error


--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5HPl4ACgkQONu9yGCS
aT5igg/8CqS2gI0Qi9/E/DkLKevPf6Wq4uRz8TozbvmAcr+CzIXW8SmsajoG6M72
KaVKQh+pd6KZmOopgPvFJpgkB22lCKrlLKyEh1GRuXzsQ5UHdxv10jOrE01gUlcO
htxxFyR6mOJMLlOUhChG6Q7r5yWvpxKmDhtoqx2PypILDkbmwd0Cg4yuiS2wzO8v
AK9PTq5Kffew6oSEbF19ieUSB3u8BxsbrwDB50rRTBL6IPZltrB0YKM+B9KAMJ88
pHa5oxHedzyVEc4aTRCRGAjQp4CB2g9f/oZuCKTRqFg3nlZTj4D0SCqpMBwge3JY
Wn9Tw5SSYnsS34BDRc8QTPSJSWSeIVdM3mcBwuk2jB0IpzjzwEKkRH3T+5+9fYFw
eQemdB1MTFjy8mIZncMEULgRPv0rtY6Alz3gWWZiWBYSA8gqEe8NnCEVXj3bM1l0
0WFYunWSbDdzxCS5etA0r+n85qqt/p85or1/HPOo7+DYT5iZOugsB1KJs6Jw/EJa
YZJRC6K2trShUQxxMa4zY3mTiOwX6a4yebYuLm2JIGuwKC8F4fVObf4OovRxQ3dQ
s4UBzEiY9ySJGQk9PIVo4osEIf+fZ3AyH975c5L0kxRNsJLu8SUDpFuMbkrVuUrr
IbLSzo2kuzPSrOq6cLOeVhekSc7njrS3xdQg/q1bAIakhzZARdA=
=sEpe
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
