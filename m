Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0DF838D8
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 20:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfHFSmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 14:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbfHFSmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 14:42:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47AF6216B7;
        Tue,  6 Aug 2019 18:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565116962;
        bh=E43LtAZo6+Ac+2iU6Kjj7i7wwyUgtw12unihTIKbklA=;
        h=Date:From:To:Cc:Subject:From;
        b=opeuYTDEHX1SwKPBcmAvyoWrAenKTXNic3LE/4kuOB5d8Fn+X6d+A+JcE7MYbf3ng
         PQZnURG1xljjS8VKYEoMAzDsMuavGntT4wBDaeH+TwPPmmvlocdmFa7KDmj9TDpa49
         2iCGYioKIcxJaFPJtXAqe0Mog1mod2Ka3zsKCBZM=
Date:   Tue, 6 Aug 2019 20:42:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.65
Message-ID: <20190806184240.GA27858@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.65 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst      |   88 ++++++++++++++++-
 Documentation/admin-guide/kernel-parameters.txt    |    7 -
 Makefile                                           |    5 -
 arch/arc/Kconfig                                   |   13 --
 arch/arc/configs/nps_defconfig                     |    1=20
 arch/arc/configs/vdk_hs38_defconfig                |    1=20
 arch/arc/configs/vdk_hs38_smp_defconfig            |    2=20
 arch/arc/kernel/head.S                             |    2=20
 arch/arc/kernel/setup.c                            |    2=20
 arch/arm/boot/dts/rk3288-veyron-mickey.dts         |    4=20
 arch/arm/boot/dts/rk3288-veyron-minnie.dts         |    4=20
 arch/arm/boot/dts/rk3288.dtsi                      |    1=20
 arch/arm/mach-rpc/dma.c                            |    5 -
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |    8 -
 arch/arm64/include/asm/cpufeature.h                |    7 -
 arch/arm64/kernel/cpufeature.c                     |    8 +
 arch/arm64/kernel/hw_breakpoint.c                  |    7 -
 arch/mips/lantiq/irq.c                             |    5 -
 arch/parisc/boot/compressed/vmlinux.lds.S          |    4=20
 arch/x86/boot/compressed/misc.c                    |    1=20
 arch/x86/boot/compressed/misc.h                    |    1=20
 arch/x86/entry/calling.h                           |   17 +++
 arch/x86/entry/entry_64.S                          |   22 +++-
 arch/x86/entry/vdso/vclock_gettime.c               |   19 +++
 arch/x86/include/asm/apic.h                        |    2=20
 arch/x86/include/asm/cpufeature.h                  |    4=20
 arch/x86/include/asm/cpufeatures.h                 |   20 ++--
 arch/x86/include/asm/kvm_host.h                    |   34 +++---
 arch/x86/include/asm/paravirt.h                    |    1=20
 arch/x86/include/asm/traps.h                       |    2=20
 arch/x86/kernel/apic/apic.c                        |    2=20
 arch/x86/kernel/cpu/bugs.c                         |  105 ++++++++++++++++=
+++--
 arch/x86/kernel/cpu/common.c                       |   94 ++++++++++------=
--
 arch/x86/kernel/cpu/cpuid-deps.c                   |    3=20
 arch/x86/kernel/cpu/scattered.c                    |    4=20
 arch/x86/kernel/kvm.c                              |    1=20
 arch/x86/kvm/cpuid.h                               |    2=20
 arch/x86/kvm/mmu.c                                 |    6 -
 arch/x86/math-emu/fpu_emu.h                        |    2=20
 arch/x86/math-emu/reg_constant.c                   |    2=20
 arch/x86/xen/enlighten_pv.c                        |    2=20
 arch/x86/xen/xen-asm_64.S                          |    1=20
 drivers/acpi/blacklist.c                           |    4=20
 drivers/block/nbd.c                                |    2=20
 drivers/clk/sprd/sc9860-clk.c                      |    5 -
 drivers/clk/tegra/clk-tegra210.c                   |    8 -
 drivers/dma/sh/rcar-dmac.c                         |    2=20
 drivers/dma/tegra20-apb-dma.c                      |   12 ++
 drivers/firmware/psci_checker.c                    |   10 +-
 drivers/gpio/gpiolib.c                             |    6 -
 drivers/gpu/drm/i915/gvt/kvmgt.c                   |   12 ++
 drivers/gpu/drm/nouveau/nouveau_connector.c        |    2=20
 drivers/infiniband/hw/hfi1/chip.c                  |   11 +-
 drivers/infiniband/hw/hfi1/verbs.c                 |    2=20
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    1=20
 drivers/infiniband/hw/mlx5/mr.c                    |   23 ++--
 drivers/infiniband/hw/mlx5/qp.c                    |   13 +-
 drivers/misc/eeprom/at24.c                         |    2=20
 drivers/mmc/host/dw_mmc.c                          |    3=20
 drivers/mmc/host/meson-mx-sdio.c                   |    2=20
 drivers/mtd/nand/raw/nand_micron.c                 |   14 ++
 drivers/net/ethernet/emulex/benet/be_main.c        |    6 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c |   16 +--
 drivers/perf/arm_pmu.c                             |    2=20
 drivers/rapidio/devices/rio_mport_cdev.c           |    2=20
 drivers/s390/block/dasd_alias.c                    |   22 +++-
 drivers/s390/scsi/zfcp_erp.c                       |    7 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   12 +-
 drivers/xen/swiotlb-xen.c                          |    4=20
 fs/adfs/super.c                                    |    5 -
 fs/btrfs/qgroup.c                                  |   24 ++++
 fs/btrfs/send.c                                    |   77 +++------------
 fs/btrfs/transaction.c                             |   10 ++
 fs/btrfs/volumes.c                                 |    3=20
 fs/ceph/super.h                                    |    7 +
 fs/ceph/xattr.c                                    |   14 +-
 fs/cifs/connect.c                                  |    8 -
 fs/coda/psdev.c                                    |    5 -
 include/linux/acpi.h                               |    5 -
 include/linux/coda.h                               |    3=20
 include/linux/coda_psdev.h                         |   11 ++
 include/uapi/linux/coda_psdev.h                    |   13 --
 ipc/mqueue.c                                       |   19 ++-
 kernel/module.c                                    |    6 -
 kernel/trace/ftrace.c                              |   28 +++--
 lib/test_overflow.c                                |   11 +-
 lib/test_string.c                                  |    6 -
 mm/cma.c                                           |   13 ++
 mm/vmscan.c                                        |    9 +
 scripts/kconfig/confdata.c                         |    4=20
 security/selinux/ss/policydb.c                     |    6 +
 sound/hda/hdac_i915.c                              |   10 +-
 tools/objtool/elf.c                                |    2=20
 tools/perf/builtin-version.c                       |    1=20
 tools/testing/selftests/cgroup/cgroup_util.c       |    3=20
 95 files changed, 673 insertions(+), 356 deletions(-)

Andrea Parri (1):
      ceph: fix improper use of smp_mb__before_atomic()

Andy Lutomirski (1):
      x86/vdso: Prevent segfaults due to hoisted vclock reads

Arnd Bergmann (4):
      ACPI: blacklist: fix clang warning for unused DMI table
      x86: kvm: avoid constant-conversion warning
      ACPI: fix false-positive -Wuninitialized warning
      x86: math-emu: Hide clang warnings for 16-bit overflow

Benjamin Block (1):
      scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitializ=
ed

Benjamin Poirier (1):
      be2net: Signal that the device cannot transmit during reconfiguration

Borislav Petkov (1):
      x86/cpufeatures: Carve out CQM features retrieval

Cheng Jian (1):
      ftrace: Enable trampoline when rec count returns back to one

Chris Down (1):
      cgroup: kselftest: relax fs_spec checks

Chunyan Zhang (1):
      clk: sprd: Add check for return value of sprd_clk_regmap_init()

Dan Carpenter (1):
      drivers/rapidio/devices/rio_mport_cdev.c: NUL terminate some strings

David Sterba (1):
      btrfs: fix minimum number of chunk errors for DUP

Dmitry Osipenko (1):
      dmaengine: tegra-apb: Error out if DMA_PREP_INTERRUPT flag is unset

Doug Berger (1):
      mm/cma.c: fail if fixed declaration can't be honored

Douglas Anderson (4):
      ARM: dts: rockchip: Make rk3288-veyron-minnie run at hs200
      ARM: dts: rockchip: Make rk3288-veyron-mickey's emmc work again
      ARM: dts: rockchip: Mark that the rk3288 timer might stop in suspend
      mmc: dw_mmc: Fix occasional hang after tuning on eMMC

Eugeniy Paltsev (1):
      ARC: enable uboot support unconditionally

Fenghua Yu (1):
      x86/cpufeatures: Combine word 11 and 12 into a new scattered features=
 word

Filipe Manana (2):
      Btrfs: fix incremental send failure after deduplication
      Btrfs: fix race leading to fs corruption after transaction abort

Geert Uytterhoeven (1):
      dmaengine: rcar-dmac: Reject zero-length slave DMA requests

Greg Kroah-Hartman (1):
      Linux 4.19.65

Gustavo A. R. Silva (1):
      IB/hfi1: Fix Spectre v1 vulnerability

Helen Koike (1):
      arm64: dts: rockchip: fix isp iommu clocks and power domain

Helge Deller (1):
      parisc: Fix build of compressed kernel even with debug enabled

JC Kuo (1):
      clk: tegra210: fix PLLU and PLLU_OUT1

Jean Delvare (1):
      eeprom: at24: make spd world-readable again

Jean-Philippe Brucker (1):
      firmware/psci: psci_checker: Park kthreads before stopping them

Jeff Layton (1):
      ceph: return -ERANGE if virtual xattr value didn't fit in buffer

Joe Perches (1):
      mmc: meson-mx-sdio: Fix misuse of GENMASK macro

John Fleck (1):
      IB/hfi1: Check for error on call to alloc_rsm_map_table

Josh Poimboeuf (7):
      x86/kvm: Don't call kvm_spurious_fault() from .fixup
      x86/paravirt: Fix callee-saved function ELF sizes
      objtool: Support GCC 9 cold subfunction naming scheme
      x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations
      x86/speculation: Enable Spectre v1 swapgs mitigations
      x86/entry/64: Use JMP instead of JMPQ
      Documentation: Add swapgs description to the Spectre v1 documentation

Juergen Gross (1):
      xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()

Kees Cook (2):
      lib/test_overflow.c: avoid tainting the kernel and fix wrap size
      ipc/mqueue.c: only perform resource calculation if user valid

Linus Torvalds (1):
      gcc-9: properly declare the {pv,hv}clock_page storage

M. Vefa Bicakci (1):
      kconfig: Clear "written" flag to avoid data loss

Marco Felsch (1):
      mtd: rawnand: micron: handle on-die "ECC-off" devices correctly

Masahiro Yamada (1):
      kbuild: initialize CLANG_FLAGS correctly in the top Makefile

Michael Wu (1):
      gpiolib: fix incorrect IRQ requesting of an active-low lineevent

Mikko Rapeli (1):
      uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel =
side headers

Munehisa Kamata (1):
      nbd: replace kill_bdev() with __invalidate_device() again

Ondrej Mosnacek (1):
      selinux: fix memory leak in policydb_init()

Peter Rosin (1):
      lib/test_string.c: avoid masking memset16/32/64 failures

Petr Cvek (1):
      MIPS: lantiq: Fix bitfield masking

Petr Machata (1):
      mlxsw: spectrum_dcb: Configure DSCP map as the last rule is removed

Prarit Bhargava (1):
      kernel/module.c: Only return -EEXIST for modules that have finished l=
oading

Qian Cai (1):
      x86/apic: Silence -Wtype-limits compiler warnings

Qu Wenruo (1):
      btrfs: qgroup: Don't hold qgroup_ioctl_lock in btrfs_qgroup_inherit()

Ravi Bangoria (1):
      perf version: Fix segfault due to missing OPT_END()

Ronnie Sahlberg (1):
      cifs: Fix a race condition with cifs_echo_request

Russell King (2):
      ARM: riscpc: fix DMA
      fs/adfs: super: fix use-after-free bug

Sam Protsenko (1):
      coda: fix build using bare-metal toolchain

Samuel Thibault (1):
      ALSA: hda: Fix 1-minute detection delay when i915 module is not avail=
able

Stefan Haberland (1):
      s390/dasd: fix endless loop after read unit address configuration

Suganath Prabu (1):
      scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA

Thomas Gleixner (1):
      x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS

Will Deacon (3):
      drivers/perf: arm_pmu: Fix failure path in PM notifier
      arm64: compat: Allow single-byte watchpoints on all addresses
      arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

Xiaolin Zhang (1):
      drm/i915/gvt: fix incorrect cache entry for guest page mapping

Yang Shi (1):
      mm: vmscan: check if mem cgroup is disabled or not before calling mem=
cg slab shrinker

Yishai Hadas (5):
      IB/mlx5: Fix unreg_umr to ignore the mkey state
      IB/mlx5: Use direct mkey destroy command upon UMR unreg failure
      IB/mlx5: Move MRs to a kernel PD when freeing them to the MR cache
      IB/mlx5: Fix clean_mr() to work in the expected order
      IB/mlx5: Fix RSS Toeplitz setup to be aligned with the HW specificati=
on

Yongxin Liu (1):
      drm/nouveau: fix memory leak in nouveau_conn_reset()

Zhenzhong Duan (2):
      xen/pv: Fix a boot up hang revealed by int3 self test
      x86, boot: Remove multiple copy of static function sanitize_boot_para=
ms()

Zhouyang Jia (1):
      coda: add error handling for fget


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1JyiAACgkQONu9yGCS
aT4vOg/9Ekzo+zhFX/GPufk4swXayWzokO2L3cNCf3y+wMrbVdgsKl/eJ5R2uoR8
s/8iSj6yRwsi9cJScjosz6Gs5SXKZm2kDpR3BwuO0irA2BsLSFXtgWfqNCIFVP/p
VyVr9J5uhg7ugMsJDrWFCuth4T/6UE8cFgaUUPwJlIHCCIUFEDa5Ktf+BinA7mCW
7u2uui50u048WbyDagRAY2JDH2R1AnOIrAnGnyu0NZcpsp/OqYsgRDCGuOd6HwRm
kPJFQOQvmDKEosBne3M98H3FUoCS7UrXrNiez/qjMStLTOvP8TVjfqZRWxNqAi8I
+0I3j8hwf71KQ8Ph2jCPD4hguqYFKdOYi8+X8JSM+5M7PgPQQ4rHEBD9LoRCMy9H
e2s5KDIPTyyTOhEm7wk/drzwbdWkmbfVlR6fHfNfPclze6t2L1QpD0T/QLPYNyaC
howHdsnXFh9KZ8UZmNFOS3OnlHTVyXrHyWgl1wJGfH4emLuudxyMrobv0mjU52rT
wRfs6mMOMm8ZQDHbfQTB7OYapglHd7YaP+aZKfTB4aGVfqXLPENKqaAJl7pwOn69
/BmmzoSS3UGSTqyA7TAYj4wsVPczbMakJ+8T6ygDpna98tOhTslBlcRRkD7k3lpU
rMxM6Xy72Ppd+xZ2Qt1LxyxAVjKR2D+Dw7wiRR9Sxgs7XyKK4wQ=
=VIvY
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
