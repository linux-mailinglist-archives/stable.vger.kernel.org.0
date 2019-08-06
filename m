Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64A5838DC
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 20:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfHFSnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 14:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfHFSnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 14:43:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E1320818;
        Tue,  6 Aug 2019 18:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565116984;
        bh=xj+PkYxCyo8lxO2UsWprO2cMofqbkh/INw2WBLbIO8I=;
        h=Date:From:To:Cc:Subject:From;
        b=s8PeT0qOmVe6cCYoVNWzYxjuui3T+TkDqykcJ1R0RKzVc/beRJyScpO/BrX0s4RIk
         V9LM+etCKhr0TVcUhBo2bl/FL8k6/u6lk/sI3oSehw4AuE1osNlo8ms2OjtS0sOMUo
         8hBZUOLzL/sbEaRSiQ/x45GF0zBmgNBb0n8FqFPE=
Date:   Tue, 6 Aug 2019 20:43:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.7
Message-ID: <20190806184302.GA27969@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.7 kernel.

All users of the 5.2 kernel series must upgrade.

The updated 5.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst      |   88 ++++++++++++++++-
 Documentation/admin-guide/kernel-parameters.txt    |    8 -
 Makefile                                           |    5 -
 arch/arm/boot/dts/rk3288-veyron-mickey.dts         |    4=20
 arch/arm/boot/dts/rk3288-veyron-minnie.dts         |    4=20
 arch/arm/boot/dts/rk3288.dtsi                      |    1=20
 arch/arm/mach-exynos/Kconfig                       |    6 +
 arch/arm/mach-exynos/Makefile                      |    2=20
 arch/arm/mach-exynos/suspend.c                     |    6 -
 arch/arm/mach-rpc/dma.c                            |    5 -
 arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi |    2=20
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi           |    2=20
 arch/arm64/boot/dts/qcom/qcs404.dtsi               |    1=20
 arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi  |    5 -
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |    8 -
 arch/arm64/include/asm/cpufeature.h                |    7 -
 arch/arm64/kernel/cpufeature.c                     |    8 +
 arch/arm64/kernel/hw_breakpoint.c                  |    7 -
 arch/mips/lantiq/irq.c                             |    5 -
 arch/nds32/include/asm/syscall.h                   |   27 +++--
 arch/parisc/Makefile                               |    3=20
 arch/parisc/boot/compressed/Makefile               |    4=20
 arch/parisc/boot/compressed/vmlinux.lds.S          |    4=20
 arch/powerpc/mm/kasan/kasan_init_32.c              |    7 +
 arch/x86/boot/compressed/misc.c                    |    1=20
 arch/x86/boot/compressed/misc.h                    |    1=20
 arch/x86/entry/calling.h                           |   17 +++
 arch/x86/entry/entry_64.S                          |   22 +++-
 arch/x86/include/asm/apic.h                        |    2=20
 arch/x86/include/asm/cpufeature.h                  |    4=20
 arch/x86/include/asm/cpufeatures.h                 |   20 ++--
 arch/x86/include/asm/kvm_host.h                    |   34 +++---
 arch/x86/include/asm/paravirt.h                    |    1=20
 arch/x86/include/asm/traps.h                       |    2=20
 arch/x86/kernel/apic/apic.c                        |    2=20
 arch/x86/kernel/cpu/bugs.c                         |  105 ++++++++++++++++=
+++--
 arch/x86/kernel/cpu/common.c                       |   96 ++++++++++------=
---
 arch/x86/kernel/cpu/cpuid-deps.c                   |    3=20
 arch/x86/kernel/cpu/scattered.c                    |    4=20
 arch/x86/kernel/kvm.c                              |    1=20
 arch/x86/kvm/cpuid.h                               |    2=20
 arch/x86/kvm/mmu.c                                 |    6 -
 arch/x86/kvm/vmx/nested.c                          |    5 -
 arch/x86/math-emu/fpu_emu.h                        |    2=20
 arch/x86/math-emu/reg_constant.c                   |    2=20
 arch/x86/xen/enlighten_pv.c                        |    2=20
 arch/x86/xen/xen-asm_64.S                          |    1=20
 drivers/acpi/blacklist.c                           |    4=20
 drivers/block/loop.c                               |   16 +--
 drivers/block/nbd.c                                |    2=20
 drivers/char/tpm/tpm-chip.c                        |   23 +++-
 drivers/clk/mediatek/clk-mt8183.c                  |   46 ++++++---
 drivers/clk/meson/clk-mpll.c                       |    9 +
 drivers/clk/meson/clk-mpll.h                       |    1=20
 drivers/clk/sprd/sc9860-clk.c                      |    5 -
 drivers/clk/tegra/clk-tegra210.c                   |    8 -
 drivers/crypto/ccp/psp-dev.c                       |   19 ++-
 drivers/dax/kmem.c                                 |    5 -
 drivers/dma/sh/rcar-dmac.c                         |    2=20
 drivers/dma/tegra20-apb-dma.c                      |   12 ++
 drivers/firmware/psci/psci_checker.c               |   10 +-
 drivers/gpio/gpiolib.c                             |   23 +++-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |    3=20
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |    1=20
 drivers/gpu/drm/i915/gvt/kvmgt.c                   |   12 ++
 drivers/gpu/drm/i915/i915_perf.c                   |   10 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |    2=20
 drivers/gpu/drm/nouveau/nouveau_connector.c        |    2=20
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |    3=20
 drivers/i2c/busses/i2c-at91-core.c                 |    2=20
 drivers/i2c/busses/i2c-at91-master.c               |    9 +
 drivers/i2c/busses/i2c-bcm-iproc.c                 |   10 +-
 drivers/infiniband/core/device.c                   |   54 ++++++++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |    7 +
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   13 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.h          |    2=20
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   14 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |    7 +
 drivers/infiniband/hw/hfi1/chip.c                  |   11 +-
 drivers/infiniband/hw/hfi1/tid_rdma.c              |   43 --------
 drivers/infiniband/hw/hfi1/verbs.c                 |    2=20
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    1=20
 drivers/infiniband/hw/mlx5/mr.c                    |   23 ++--
 drivers/infiniband/hw/mlx5/qp.c                    |   13 +-
 drivers/misc/eeprom/at24.c                         |    2=20
 drivers/mmc/core/queue.c                           |    5 +
 drivers/mmc/host/dw_mmc.c                          |    3=20
 drivers/mmc/host/meson-mx-sdio.c                   |    2=20
 drivers/mmc/host/sdhci-sprd.c                      |    1=20
 drivers/mtd/nand/raw/nand_micron.c                 |   14 ++
 drivers/net/ethernet/emulex/benet/be_main.c        |    6 +
 drivers/pci/of.c                                   |    8 +
 drivers/perf/arm_pmu.c                             |    2=20
 drivers/rapidio/devices/rio_mport_cdev.c           |    2=20
 drivers/remoteproc/remoteproc_core.c               |    1=20
 drivers/s390/block/dasd_alias.c                    |   22 +++-
 drivers/s390/scsi/zfcp_erp.c                       |    7 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   12 +-
 drivers/soc/imx/soc-imx8.c                         |   19 ++-
 drivers/soc/qcom/rpmpd.c                           |    2=20
 drivers/virtio/virtio_mmio.c                       |    7 +
 drivers/xen/gntdev.c                               |    2=20
 drivers/xen/swiotlb-xen.c                          |    6 -
 fs/adfs/super.c                                    |    5 -
 fs/block_dev.c                                     |   83 +++++++++++-----
 fs/btrfs/ioctl.c                                   |   21 ++++
 fs/btrfs/qgroup.c                                  |   24 ++++
 fs/btrfs/send.c                                    |   77 +++------------
 fs/btrfs/transaction.c                             |   10 ++
 fs/btrfs/tree-checker.c                            |   11 ++
 fs/btrfs/volumes.c                                 |    3=20
 fs/ceph/dir.c                                      |   26 +++--
 fs/ceph/super.h                                    |    7 +
 fs/ceph/xattr.c                                    |   14 +-
 fs/cifs/connect.c                                  |   24 +++-
 fs/coda/psdev.c                                    |    5 -
 fs/dax.c                                           |    2=20
 fs/io_uring.c                                      |    3=20
 include/linux/acpi.h                               |    5 -
 include/linux/coda.h                               |    3=20
 include/linux/coda_psdev.h                         |   11 ++
 include/linux/compiler-gcc.h                       |    2=20
 include/linux/compiler_types.h                     |    4=20
 include/linux/fs.h                                 |    6 +
 include/linux/gpio/consumer.h                      |   64 ++++++------
 include/linux/memory_hotplug.h                     |    8 +
 include/rdma/ib_verbs.h                            |    3=20
 include/uapi/linux/coda_psdev.h                    |   13 --
 ipc/mqueue.c                                       |   19 ++-
 kernel/bpf/btf.c                                   |   19 ++-
 kernel/bpf/core.c                                  |    2=20
 kernel/dma/swiotlb.c                               |    4=20
 kernel/module.c                                    |    6 -
 kernel/stacktrace.c                                |    5 +
 kernel/trace/ftrace.c                              |   28 +++--
 kernel/trace/trace_functions_graph.c               |   17 +--
 lib/Makefile                                       |    3=20
 lib/ioremap.c                                      |    9 +
 lib/test_overflow.c                                |   11 +-
 lib/test_string.c                                  |    6 -
 mm/cma.c                                           |   13 ++
 mm/compaction.c                                    |   11 +-
 mm/memcontrol.c                                    |   22 +++-
 mm/memory_hotplug.c                                |   64 ++++++++----
 mm/migrate.c                                       |   21 ++--
 mm/slab_common.c                                   |    3=20
 mm/vmscan.c                                        |    9 +
 mm/z3fold.c                                        |   15 ++-
 scripts/Makefile.modpost                           |    6 -
 scripts/kconfig/confdata.c                         |    4=20
 security/selinux/ss/policydb.c                     |    6 +
 sound/hda/hdac_i915.c                              |   10 +-
 tools/perf/builtin-version.c                       |    1=20
 tools/testing/selftests/bpf/Makefile               |   13 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |    3=20
 155 files changed, 1239 insertions(+), 631 deletions(-)

Andrea Parri (1):
      ceph: fix improper use of smp_mb__before_atomic()

Andreas Koop (1):
      mmc: mmc_spi: Enable stable writes

Andrii Nakryiko (1):
      bpf: fix BTF verifier size resolution logic

Andy Gross (1):
      arm64: qcom: qcs404: Add reset-cells to GCC node

Anshuman Khandual (1):
      mm/ioremap: check virtual address alignment while creating huge mappi=
ngs

Anson Huang (2):
      soc: imx: soc-imx8: Correct return value of error handle
      soc: imx8: Fix potential kernel dump in error path

Arnd Bergmann (8):
      swiotlb: fix phys_addr_t overflow warning
      ARM: exynos: Only build MCPM support if used
      ACPI: blacklist: fix clang warning for unused DMI table
      x86: kvm: avoid constant-conversion warning
      ACPI: fix false-positive -Wuninitialized warning
      mm/slab_common.c: work around clang bug #42570
      x86: math-emu: Hide clang warnings for 16-bit overflow
      ubsan: build ubsan.c more conservatively

Baolin Wang (1):
      mmc: host: sdhci-sprd: Fix the missing pm_runtime_put_noidle()

Bartosz Golaszewski (1):
      gpio: don't WARN() on NULL descs if gpiolib is disabled

Benjamin Block (1):
      scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitializ=
ed

Benjamin Poirier (1):
      be2net: Signal that the device cannot transmit during reconfiguration

Borislav Petkov (1):
      x86/cpufeatures: Carve out CQM features retrieval

Changbin Du (1):
      fgraph: Remove redundant ftrace_graph_notrace_addr() test

Cheng Jian (1):
      ftrace: Enable trampoline when rec count returns back to one

Chris Down (1):
      cgroup: kselftest: relax fs_spec checks

Chris Packham (1):
      gpiolib: Preserve desc->flags when setting state

Christophe Leroy (1):
      powerpc/kasan: fix early boot failure on PPC32

Chunyan Zhang (1):
      clk: sprd: Add check for return value of sprd_clk_regmap_init()

Clement Leger (1):
      remoteproc: copy parent dma_pfn_offset for vdev

Dan Carpenter (1):
      drivers/rapidio/devices/rio_mport_cdev.c: NUL terminate some strings

David Rientjes (1):
      crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL

David Sterba (1):
      btrfs: fix minimum number of chunk errors for DUP

Dmitry Osipenko (1):
      dmaengine: tegra-apb: Error out if DMA_PREP_INTERRUPT flag is unset

Dmitry V. Levin (1):
      nds32: fix asm/syscall.h

Doug Berger (1):
      mm/cma.c: fail if fixed declaration can't be honored

Douglas Anderson (4):
      ARM: dts: rockchip: Make rk3288-veyron-minnie run at hs200
      ARM: dts: rockchip: Make rk3288-veyron-mickey's emmc work again
      ARM: dts: rockchip: Mark that the rk3288 timer might stop in suspend
      mmc: dw_mmc: Fix occasional hang after tuning on eMMC

Fenghua Yu (1):
      x86/cpufeatures: Combine word 11 and 12 into a new scattered features=
 word

Filipe Manana (2):
      Btrfs: fix incremental send failure after deduplication
      Btrfs: fix race leading to fs corruption after transaction abort

Geert Uytterhoeven (1):
      dmaengine: rcar-dmac: Reject zero-length slave DMA requests

Greg Kroah-Hartman (1):
      Linux 5.2.7

Gustavo A. R. Silva (1):
      IB/hfi1: Fix Spectre v1 vulnerability

Heinrich Schuchardt (1):
      arm64: dts: marvell: mcbin: enlarge PCI memory window

Helen Koike (1):
      arm64: dts: rockchip: fix isp iommu clocks and power domain

Helge Deller (2):
      parisc: Strip debug info from kernel before creating compressed vmlin=
uz
      parisc: Fix build of compressed kernel even with debug enabled

Henry Burns (1):
      mm/z3fold.c: reinitialize zhdr structs after migration

Ihor Matushchak (1):
      virtio-mmio: add error check for platform_get_irq

Ilya Leoshkevich (1):
      selftests/bpf: do not ignore clang failures

JC Kuo (1):
      clk: tegra210: fix PLLU and PLLU_OUT1

Jackie Liu (1):
      io_uring: fix KASAN use after free in io_sq_wq_submit_work

James Bottomley (1):
      parisc: Add archclean Makefile target

Jan Kara (3):
      dax: Fix missed wakeup in put_unlocked_entry()
      mm: migrate: fix reference check race between __find_get_block() and =
migration
      loop: Fix mount(2) failure due to race with LOOP_SET_FD

Jason Gunthorpe (1):
      RDMA/devices: Do not deadlock during client removal

Jean Delvare (1):
      eeprom: at24: make spd world-readable again

Jean-Philippe Brucker (2):
      PCI: OF: Initialize dev->fwnode appropriately
      firmware/psci: psci_checker: Park kthreads before stopping them

Jeff Layton (1):
      ceph: return -ERANGE if virtual xattr value didn't fit in buffer

Jerome Brunet (1):
      clk: meson: mpll: properly handle spread spectrum

Joe Perches (1):
      mmc: meson-mx-sdio: Fix misuse of GENMASK macro

John Fleck (1):
      IB/hfi1: Check for error on call to alloc_rsm_map_table

Josh Poimboeuf (7):
      x86/kvm: Don't call kvm_spurious_fault() from .fixup
      x86/paravirt: Fix callee-saved function ELF sizes
      bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()
      x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations
      x86/speculation: Enable Spectre v1 swapgs mitigations
      x86/entry/64: Use JMP instead of JMPQ
      Documentation: Add swapgs description to the Spectre v1 documentation

Juergen Gross (1):
      xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()

Kaike Wan (2):
      IB/hfi1: Drop all TID RDMA READ RESP packets after r_next_psn
      IB/hfi1: Field not zero-ed when allocating TID flow memory

Kees Cook (2):
      lib/test_overflow.c: avoid tainting the kernel and fix wrap size
      ipc/mqueue.c: only perform resource calculation if user valid

Lionel Landwerlin (1):
      drm/i915/perf: fix ICL perf register offsets

Liran Alon (1):
      KVM: nVMX: Ignore segment base for VMX memory operand when segment no=
t FS or GS

Lyude Paul (1):
      drm/nouveau: Only release VCPI slots on mode changes

M. Vefa Bicakci (1):
      kconfig: Clear "written" flag to avoid data loss

Marco Felsch (1):
      mtd: rawnand: micron: handle on-die "ECC-off" devices correctly

Masahiro Yamada (2):
      kbuild: initialize CLANG_FLAGS correctly in the top Makefile
      kbuild: modpost: include .*.cmd files only when targets exist

Mel Gorman (1):
      mm: compaction: avoid 100% CPU usage during compaction when a task is=
 killed

Michael Wu (1):
      gpiolib: fix incorrect IRQ requesting of an active-low lineevent

Micha=C5=82 Miros=C5=82aw (2):
      i2c: at91: disable TXRDY interrupt after sending data
      i2c: at91: fix clk_offset for sama5d2

Mikko Rapeli (1):
      uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel =
side headers

Milan Broz (1):
      tpm: Fix null pointer dereference on chip register error path

Munehisa Kamata (1):
      nbd: replace kill_bdev() with __invalidate_device() again

Nicholas Kazlauskas (1):
      drm/amd/display: Expose audio inst from DC to DM

Niklas Cassel (1):
      arm64: dts: qcom: qcs404-evb: fix l3 min voltage

Ondrej Mosnacek (1):
      selinux: fix memory leak in policydb_init()

Pavel Tatashin (2):
      device-dax: fix memory and resource leak if hotplug fails
      mm/hotplug: make remove_memory() interface usable

Peter Rosin (1):
      lib/test_string.c: avoid masking memset16/32/64 failures

Peter Zijlstra (1):
      stacktrace: Force USER_DS for stack_trace_save_user()

Petr Cvek (1):
      MIPS: lantiq: Fix bitfield masking

Prarit Bhargava (1):
      kernel/module.c: Only return -EEXIST for modules that have finished l=
oading

Qian Cai (1):
      x86/apic: Silence -Wtype-limits compiler warnings

Qu Wenruo (3):
      btrfs: tree-checker: Check if the file extent end overflows
      btrfs: Flush before reflinking any extent to prevent NOCOW write fall=
ing back to COW without data reservation
      btrfs: qgroup: Don't hold qgroup_ioctl_lock in btrfs_qgroup_inherit()

Ralph Campbell (2):
      drm/nouveau/dmem: missing mutex_lock in error path
      mm/migrate.c: initialize pud_entry in migrate_vma()

Ravi Bangoria (1):
      perf version: Fix segfault due to missing OPT_END()

Rayagonda Kokatanur (1):
      i2c: iproc: Fix i2c master read more than 63 bytes

Ronnie Sahlberg (2):
      cifs: Fix a race condition with cifs_echo_request
      cifs: fix crash in cifs_dfs_do_automount

Russell King (2):
      ARM: riscpc: fix DMA
      fs/adfs: super: fix use-after-free bug

Sam Protsenko (1):
      coda: fix build using bare-metal toolchain

Samuel Thibault (1):
      ALSA: hda: Fix 1-minute detection delay when i915 module is not avail=
able

Selvin Xavier (1):
      RDMA/bnxt_re: Honor vlan_id in GID entry comparison

Sibi Sankar (1):
      soc: qcom: rpmpd: fixup rpmpd set performance state

Souptick Joarder (1):
      xen/gntdev.c: Replace vm_map_pages() with vm_map_pages_zero()

Stefan Haberland (1):
      s390/dasd: fix endless loop after read unit address configuration

Suganath Prabu (1):
      scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA

Thomas Gleixner (1):
      x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS

Vicente Bergas (1):
      arm64: dts: rockchip: Fix USB3 Type-C on rk3399-sapphire

Vitaly Wool (1):
      mm/z3fold: don't try to use buddy slots after free

Weiyi Lu (1):
      clk: mediatek: mt8183: Register 13MHz clock earlier for clocksource

Will Deacon (3):
      drivers/perf: arm_pmu: Fix failure path in PM notifier
      arm64: compat: Allow single-byte watchpoints on all addresses
      arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

Xiaolin Zhang (1):
      drm/i915/gvt: fix incorrect cache entry for guest page mapping

Yafang Shao (1):
      mm/memcontrol.c: keep local VM counters in sync with the hierarchical=
 ones

Yan, Zheng (1):
      ceph: fix dir_lease_is_valid()

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


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1JyjYACgkQONu9yGCS
aT4snw//aB7JjtzkMAwBeqfvcyhSfGd9lwJ2vxNXm7kfn0vev+dZxEttm/natkJW
PLtIZB9LQq/J05P3Qdm3WWUlFMISZfPvEirPFfRRBIopIrQEeyXTGdhW9kbQSYwb
R4XbqoN27jWl3mkuCKdLgY/6jjMz41WMYGucsWhjfM4SCKJ47bIYdIHE3vlMnVCH
qJQurdp9DWNoq35wCpz05cpoQlJp4QIuFAT+WekN/K56u4qmTFjwoBsa7/GdPkud
IIFiE9DpSpATZmQRqk6K5MpJAoDSgypYOIQKyIwDa8o2rmVmoVJNeg6FdOdOb4gI
MprJmmPAAyrEv9yMcptDsJ8Vn2MZHrOkgs5emWpMTXv8wWW0Cs6gjnw2jQF2+Pcd
/f3AmwsfLpQ75wQeO6a1AEVml6z/xnckNCpaHgfmJu69PCeV3dxjNO6BT/rQPrP8
Cp3ulzxzsUp1Q1Vory7futBMLNtvdkOP543iTB8OwZQPmi80vPJXsCKV09QWnWHF
JiKn/fJsr79RzsphjGEa4155ikJblN+PeszEvpYoxEpP5rrW5VKhsPC4HvtVr5Ur
YiKR0pVE2pZCiPG6lKibe3zt6QrhBxQDRgG2tfJhPCVDC1Bqs3ZWdV0Nd+39KKe3
z9wAJ4Esn+f9A0wtkI21hXqkjML1X47v8nYlmqXRVvnzffCbmZw=
=d6ov
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
