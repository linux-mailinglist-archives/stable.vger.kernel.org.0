Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5FC1AE0A1
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 17:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgDQPJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 11:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgDQPJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 11:09:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEEDF20857;
        Fri, 17 Apr 2020 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587136192;
        bh=D6aLuriHKWeuKhhLMmBUUOBvMT4azzQaGZwIevDu754=;
        h=Date:From:To:Cc:Subject:From;
        b=NBiVViZUNueVGi7gmzqAMcZfmShoEsEJ79xPUTgHfbORu4JjpzYwjz40mQ+ythdi9
         OFDeaZ+WbyOXHBpaQ7LZ6l+GJ7RKzT2Ep0b/TQnLczWOa77UEDwMZigJL7C35nEyCD
         +99NMg4xHkShZZlzJH68p/NK3ietQfFpUBrDVzeo=
Date:   Fri, 17 Apr 2020 17:09:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.116
Message-ID: <20200417150949.GA705681@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.116 kernel.

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

 Documentation/sound/hd-audio/index.rst                |    1=20
 Documentation/sound/hd-audio/models.rst               |    2=20
 Documentation/sound/hd-audio/realtek-pc-beep.rst      |  129 +++++++++
 Makefile                                              |    2=20
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts             |    4=20
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi          |    3=20
 arch/arm64/kernel/armv8_deprecated.c                  |    2=20
 arch/mips/cavium-octeon/octeon-irq.c                  |    3=20
 arch/mips/mm/tlbex.c                                  |    5=20
 arch/powerpc/include/asm/book3s/64/hash-4k.h          |    6=20
 arch/powerpc/include/asm/book3s/64/hash-64k.h         |    8=20
 arch/powerpc/include/asm/book3s/64/pgtable.h          |    4=20
 arch/powerpc/include/asm/book3s/64/radix.h            |    5=20
 arch/powerpc/include/asm/drmem.h                      |    4=20
 arch/powerpc/include/asm/setjmp.h                     |    6=20
 arch/powerpc/kernel/Makefile                          |    3=20
 arch/powerpc/kernel/idle_book3s.S                     |   27 +-
 arch/powerpc/kernel/kprobes.c                         |    3=20
 arch/powerpc/kernel/signal_64.c                       |    4=20
 arch/powerpc/mm/tlb_nohash_low.S                      |   12=20
 arch/powerpc/platforms/pseries/hotplug-memory.c       |    8=20
 arch/powerpc/platforms/pseries/lpar.c                 |    2=20
 arch/powerpc/sysdev/xive/common.c                     |   12=20
 arch/powerpc/sysdev/xive/native.c                     |    4=20
 arch/powerpc/sysdev/xive/spapr.c                      |    4=20
 arch/powerpc/sysdev/xive/xive-internal.h              |    7=20
 arch/powerpc/xmon/Makefile                            |    3=20
 arch/s390/kernel/diag.c                               |    2=20
 arch/s390/kvm/vsie.c                                  |    1=20
 arch/s390/mm/gmap.c                                   |    6=20
 arch/x86/boot/compressed/head_32.S                    |    2=20
 arch/x86/boot/compressed/head_64.S                    |    4=20
 arch/x86/entry/entry_32.S                             |    1=20
 arch/x86/include/asm/kvm_host.h                       |    2=20
 arch/x86/include/asm/pgtable.h                        |    7=20
 arch/x86/include/asm/pgtable_types.h                  |    2=20
 arch/x86/kernel/acpi/boot.c                           |    2=20
 arch/x86/kvm/svm.c                                    |    4=20
 arch/x86/kvm/vmx.c                                    |  110 ++------
 arch/x86/kvm/x86.c                                    |   21 +
 arch/x86/platform/efi/efi_64.c                        |    4=20
 block/bfq-iosched.c                                   |   16 -
 block/blk-ioc.c                                       |    7=20
 block/blk-settings.c                                  |    3=20
 drivers/ata/libata-pmp.c                              |    1=20
 drivers/ata/libata-scsi.c                             |    9=20
 drivers/base/firmware_loader/fallback.c               |    2=20
 drivers/block/null_blk_main.c                         |   10=20
 drivers/block/xen-blkfront.c                          |   17 -
 drivers/bus/sunxi-rsb.c                               |    2=20
 drivers/char/ipmi/ipmi_msghandler.c                   |    4=20
 drivers/char/tpm/eventlog/common.c                    |   12=20
 drivers/char/tpm/eventlog/tpm1.c                      |    2=20
 drivers/char/tpm/eventlog/tpm2.c                      |    2=20
 drivers/char/tpm/tpm-chip.c                           |    4=20
 drivers/char/tpm/tpm.h                                |    2=20
 drivers/clk/ingenic/jz4770-cgu.c                      |    4=20
 drivers/cpufreq/imx6q-cpufreq.c                       |    3=20
 drivers/cpufreq/powernv-cpufreq.c                     |    6=20
 drivers/crypto/caam/caamalg_desc.c                    |   16 +
 drivers/crypto/ccree/cc_aead.c                        |   56 +++-
 drivers/crypto/ccree/cc_aead.h                        |    1=20
 drivers/crypto/ccree/cc_buffer_mgr.c                  |  108 ++++----
 drivers/crypto/mxs-dcp.c                              |   58 ++--
 drivers/firmware/arm_sdei.c                           |   32 +-
 drivers/firmware/efi/efi.c                            |    2=20
 drivers/gpu/drm/drm_dp_mst_topology.c                 |   19 -
 drivers/gpu/drm/drm_pci.c                             |   25 -
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c             |  103 ++++++-
 drivers/i2c/busses/i2c-st.c                           |    1=20
 drivers/infiniband/hw/mlx5/main.c                     |    6=20
 drivers/input/serio/i8042-x86ia64io.h                 |   11=20
 drivers/irqchip/irq-gic-v3-its.c                      |    6=20
 drivers/irqchip/irq-versatile-fpga.c                  |   18 +
 drivers/md/dm-verity-fec.c                            |    1=20
 drivers/md/dm-writecache.c                            |    6=20
 drivers/md/dm-zoned-metadata.c                        |    1=20
 drivers/md/md.c                                       |    2=20
 drivers/media/i2c/ov5695.c                            |   49 ++-
 drivers/media/i2c/video-i2c.c                         |    2=20
 drivers/media/platform/qcom/venus/hfi_parser.c        |    1=20
 drivers/media/platform/ti-vpe/cal.c                   |   16 -
 drivers/mfd/dln2.c                                    |    9=20
 drivers/misc/echo/echo.c                              |    2=20
 drivers/mtd/nand/spi/core.c                           |   17 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c        |    3=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c     |    3=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c      |   51 ---
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c     |    5=20
 drivers/net/ethernet/neterion/vxge/vxge-config.h      |    2=20
 drivers/net/ethernet/neterion/vxge/vxge-main.h        |   14 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |    2=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c    |   31 +-
 drivers/net/wireless/ath/ath9k/main.c                 |    3=20
 drivers/nvme/host/core.c                              |   11=20
 drivers/nvme/host/fc.c                                |   14 -
 drivers/nvme/target/fcloop.c                          |    1=20
 drivers/pci/endpoint/pci-epc-mem.c                    |   10=20
 drivers/pci/hotplug/pciehp_hpc.c                      |   14 -
 drivers/pci/pcie/aspm.c                               |    4=20
 drivers/pci/quirks.c                                  |   80 +++++-
 drivers/pci/switch/switchtec.c                        |    2=20
 drivers/rtc/rtc-omap.c                                |    4=20
 drivers/s390/scsi/zfcp_erp.c                          |    2=20
 drivers/scsi/lpfc/lpfc_nvme.c                         |    2=20
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                  |    8=20
 drivers/scsi/qla2xxx/qla_nvme.c                       |    1=20
 drivers/staging/erofs/utils.c                         |    2=20
 drivers/usb/dwc3/core.c                               |    5=20
 drivers/usb/dwc3/core.h                               |    4=20
 drivers/usb/gadget/composite.c                        |    9=20
 drivers/usb/gadget/function/f_fs.c                    |    1=20
 drivers/usb/host/xhci.c                               |    4=20
 fs/btrfs/async-thread.c                               |    8=20
 fs/btrfs/async-thread.h                               |    1=20
 fs/btrfs/delayed-inode.c                              |   13 +
 fs/btrfs/disk-io.c                                    |   27 +-
 fs/btrfs/file.c                                       |   11=20
 fs/btrfs/qgroup.c                                     |   11=20
 fs/btrfs/relocation.c                                 |   35 +-
 fs/cifs/file.c                                        |    2=20
 fs/exec.c                                             |    2=20
 fs/ext4/inode.c                                       |    2=20
 fs/filesystems.c                                      |    4=20
 fs/gfs2/glock.c                                       |    3=20
 fs/hfsplus/attributes.c                               |    4=20
 fs/nfs/write.c                                        |    1=20
 fs/ocfs2/alloc.c                                      |    4=20
 fs/pstore/inode.c                                     |    5=20
 fs/pstore/platform.c                                  |    4=20
 include/linux/devfreq_cooling.h                       |    2=20
 include/linux/iocontext.h                             |    1=20
 include/linux/mlx5/mlx5_ifc.h                         |    9=20
 include/linux/nvme-fc-driver.h                        |    4=20
 include/linux/pci-epc.h                               |    3=20
 include/linux/sched.h                                 |    4=20
 include/linux/swab.h                                  |    1=20
 include/uapi/linux/swab.h                             |   10=20
 kernel/cpu.c                                          |    5=20
 kernel/irq/irqdomain.c                                |   10=20
 kernel/kmod.c                                         |    4=20
 kernel/locking/lockdep.c                              |    4=20
 kernel/sched/sched.h                                  |    8=20
 kernel/signal.c                                       |    2=20
 kernel/trace/trace_kprobe.c                           |    2=20
 lib/find_bit.c                                        |   16 -
 mm/page_alloc.c                                       |    8=20
 mm/slub.c                                             |    2=20
 security/keys/key.c                                   |    2=20
 security/keys/keyctl.c                                |    4=20
 sound/core/oss/pcm_plugin.c                           |   32 +-
 sound/pci/hda/hda_beep.c                              |    6=20
 sound/pci/hda/hda_intel.c                             |   16 +
 sound/pci/hda/patch_realtek.c                         |   50 ---
 sound/pci/ice1712/prodigy_hifi.c                      |    4=20
 sound/soc/soc-dapm.c                                  |    8=20
 sound/soc/soc-ops.c                                   |    4=20
 sound/soc/soc-pcm.c                                   |    6=20
 sound/soc/soc-topology.c                              |    2=20
 sound/usb/mixer_maps.c                                |   28 ++
 tools/gpio/Makefile                                   |    2=20
 tools/perf/Makefile.config                            |   11=20
 tools/testing/selftests/vm/mlock2-tests.c             |  233 ++-----------=
-----
 tools/testing/selftests/x86/ptrace_syscall.c          |    8=20
 164 files changed, 1221 insertions(+), 834 deletions(-)

Alain Volmat (1):
      i2c: st: fix missing struct parameter description

Alex Vesker (1):
      IB/mlx5: Replace tunnel mpls capability bits for tunnel_offloads

Alexander Duyck (1):
      mm: Use fixed constant in page_frag_alloc instead of size + 1

Alexander Sverdlin (1):
      genirq/irqdomain: Check pointer in irq_domain_alloc_irqs_hierarchy()

Alexey Dobriyan (1):
      null_blk: fix spurious IO errors after failed past-wp access

Andrei Botila (1):
      crypto: caam - update xts sector size for large input length

Andy Lutomirski (1):
      selftests/x86/ptrace_syscall_32: Fix no-vDSO segfault

Andy Shevchenko (1):
      mfd: dln2: Fix sanity checking for endpoints

Aneesh Kumar K.V (1):
      powerpc/hash64/devmap: Use H_PAGE_THP_HUGE when setting up huge devma=
p PTE entries

Anssi Hannula (1):
      tools: gpio: Fix out-of-tree build regression

Ard Biesheuvel (1):
      efi/x86: Ignore the memory attributes table on i386

Arvind Sankar (1):
      x86/boot: Use unsigned comparison for addresses

Bart Van Assche (2):
      null_blk: Fix the null_add_dev() error path
      null_blk: Handle null_add_dev() failures properly

Benoit Parrot (1):
      media: ti-vpe: cal: fix disable_irqs to only the intended target

Bob Liu (1):
      dm zoned: remove duplicate nr_rnd_zones increase in dmz_init_zone()

Bob Peterson (1):
      gfs2: Don't demote a glock until its revokes are written

Boqun Feng (1):
      locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps=
()

Changwei Ge (1):
      ocfs2: no need try to truncate file beyond i_size

Chris Wilson (1):
      drm: Remove PageReserved manipulation from drm_pci_alloc

Christian Gmeiner (2):
      drm/etnaviv: rework perfmon query infrastructure
      etnaviv: perfmon: fix total and idle HI cyleces readout

Christoph Niedermaier (1):
      cpufreq: imx6q: Fixes unwanted cpu overclocking on i.MX6ULL

Christophe Leroy (1):
      powerpc/kprobes: Ignore traps that happened in real mode

Clement Courbet (1):
      powerpc: Make setjmp/longjmp signature standard

C=C3=A9dric Le Goater (1):
      powerpc/xive: Use XIVE_BAD_IRQ instead of zero to catch non configure=
d IPIs

David Hildenbrand (2):
      KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks
      KVM: s390: vsie: Fix delivery of addressing exceptions

Dongchun Zhu (1):
      media: i2c: ov5695: Fix power on and off sequences

Eric Biggers (2):
      fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_onc=
e()
      kmod: make request_module() return an error when autoloading is disab=
led

Eric W. Biederman (1):
      signal: Extend exec_id to 64bits

Filipe Manana (2):
      Btrfs: fix crash during unmount due to race with delayed inode workers
      btrfs: fix missing file extent item for hole after ranged fsync

Fredrik Strupe (1):
      arm64: armv8_deprecated: Fix undef_hook mask for thumb setend

Frieder Schrempf (2):
      mtd: spinand: Stop using spinand->oobbuf for buffering bad block mark=
ers
      mtd: spinand: Do not erase the block before writing a bad block marker

Gao Xiang (1):
      erofs: correct the remaining shrink objects

Gary Lin (1):
      efi/x86: Fix the deletion of variables in mixed mode

Gilad Ben-Yossef (4):
      crypto: ccree - zero out internal struct before use
      crypto: ccree - don't mangle the request assoclen
      crypto: ccree - dec auth tag size from cryptlen map
      crypto: ccree - only try to map auth tag if needed

Greg Kroah-Hartman (1):
      Linux 4.19.116

Guoqing Jiang (1):
      md: check arrays is suspended in mddev_detach before call quiesce ope=
rations

Gustavo A. R. Silva (1):
      MIPS: OCTEON: irq: Fix potential NULL pointer dereference

Hadar Gat (1):
      crypto: ccree - improve error handling

Hans de Goede (1):
      Input: i8042 - add Acer Aspire 5738z to nomux list

Huacai Chen (1):
      MIPS/tlbex: Fix LDDIR usage in setup_pw() for Loongson-3

James Morse (1):
      firmware: arm_sdei: fix double-lock on hibernate with shared events

James Smart (2):
      nvme-fc: Revert "add module to ops template to allow module reference=
s"
      nvme: Treat discovery subsystems as unique subsystems

Jan Engelhardt (1):
      acpi/x86: ignore unspecified bit positions in the ACPI global lock fi=
eld

John Garry (1):
      libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()

Josef Bacik (5):
      btrfs: remove a BUG_ON() from merge_reloc_roots()
      btrfs: track reloc roots based on their commit root bytenr
      btrfs: set update the uuid generation as soon as possible
      btrfs: drop block from cache on error in relocation
      btrfs: use nofs allocations for running delayed items

Juergen Gross (1):
      xen/blkfront: fix memory allocation flags in blkfront_setup_indirect()

Junyong Sun (1):
      firmware: fix a double abort case with fw_load_sysfs_fallback

Kai-Heng Feng (1):
      libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DF=
LAG_DETACH is set

Kees Cook (1):
      slub: improve bit diffusion for freelist ptr obfuscation

Kishon Vijay Abraham I (1):
      PCI: endpoint: Fix for concurrent memory allocation in OB address reg=
ion

Konstantin Khlebnikov (1):
      block: keep bdi->io_pages in sync with max_sectors_kb for stacked dev=
ices

Laurentiu Tudor (1):
      powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Libor Pechacek (1):
      powerpc/pseries: Avoid NULL pointer dereference when drmem is unavail=
able

Logan Gunthorpe (1):
      PCI/switchtec: Fix init_completion race condition with poll_wait()

Lukas Wunner (1):
      PCI: pciehp: Fix indefinite wait on sysfs requests

Luo bin (2):
      hinic: fix a bug of waitting for IO stopped
      hinic: fix wrong para of wait_for_completion_timeout

Lyude Paul (1):
      drm/dp_mst: Fix clearing payload state on topology disable

Marc Zyngier (1):
      irqchip/gic-v4: Provide irq_retrigger to avoid circular locking depen=
dency

Martin Blumenstingl (1):
      thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=
=3Dn

Masami Hiramatsu (1):
      ftrace/kprobe: Show the maxactive number on kprobe_events

Mathias Nyman (1):
      xhci: bail out early if driver can't accress host in resume

Matt Ranostay (1):
      media: i2c: video-i2c: fix build errors due to 'imply hwmon'

Matthew Garrett (1):
      tpm: Don't make log failures fatal

Maxime Ripard (1):
      arm64: dts: allwinner: h6: Fix PMU compatible

Michael Ellerman (2):
      powerpc/powernv/idle: Restore AMR/UAMOR/AMOR after idle
      powerpc/64/tm: Don't let userspace set regs->trap via sigreturn

Michael Mueller (1):
      s390/diag: fix display of diagnose call statistics

Michael Wang (1):
      sched: Avoid scale real weight down to zero

Michal Hocko (1):
      selftests: vm: drop dependencies on page flags from mlock2 tests

Mikulas Patocka (1):
      dm writecache: add cond_resched to avoid CPU hangs

Nathan Chancellor (2):
      rtc: omap: Use define directive for PIN_CONFIG_ACTIVE_HIGH
      misc: echo: Remove unnecessary parentheses and simplify check for zero

Neil Armstrong (1):
      usb: dwc3: core: add support for disabling SS instances in park mode

Oliver O'Halloran (1):
      cpufreq: powernv: Fix use-after-free

Ondrej Jirman (2):
      ARM: dts: sun8i-a83t-tbs-a711: HM5065 doesn't like such a high voltage
      bus: sunxi-rsb: Return correct data when mixing 16-bit and 8-bit reads

Paul Cercueil (1):
      clk: ingenic/jz4770: Exit with error if CGU init failed

Qian Cai (1):
      ext4: fix a data race at inode->i_blocks

Qu Wenruo (1):
      btrfs: qgroup: ensure qgroup_rescan_running is only set when the work=
er is at least queued

Raju Rangoju (1):
      cxgb4/ptp: pass the sign of offset delta in FW CMD

Remi Pommarel (1):
      ath9k: Handle txpower changes even when TPC is disabled

Robbie Ko (1):
      btrfs: fix missing semaphore unlock in btrfs_sync_file

Rosioru Dragos (1):
      crypto: mxs-dcp - fix scatterlist linearization for hash

Sahitya Tummala (1):
      block: Fix use-after-free issue accessing struct io_cq

Sam Lunt (1):
      perf tools: Support Python 3.8+ in Makefile

Sasha Levin (1):
      Revert "drm/dp_mst: Remove VCPI while disabling topology mgr"

Sean Christopherson (4):
      KVM: nVMX: Properly handle userspace interrupt window request
      KVM: x86: Allocate new rmap and large page tracking when moving memsl=
ot
      KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support
      KVM: x86: Gracefully handle __vmalloc() failure during VM allocation

Sean V Kelley (1):
      PCI: Add boot interrupt quirk mechanism for Xeon chipsets

Segher Boessenkool (1):
      powerpc: Add attributes for setjmp/longjmp

Shetty, Harshini X (EXT-Sony Mobile) (1):
      dm verity fec: fix memory leak in verity_fec_dtr

Simon Gander (1):
      hfsplus: fix crash and filesystem corruption when deleting files

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug

Sriharsha Allenki (1):
      usb: gadget: f_fs: Fix use after free issue as part of queue failure

Steffen Maier (1):
      scsi: zfcp: fix missing erp_lock in port recovery trigger for point-t=
o-point

Stephan Gerhold (1):
      media: venus: hfi_parser: Ignore HEVC encoding for V1

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Allow configuration updates to existing devices

Sungbo Eo (2):
      irqchip/versatile-fpga: Handle chained IRQs properly
      irqchip/versatile-fpga: Apply clear-mask earlier

Takashi Iwai (6):
      ALSA: usb-audio: Add mixer workaround for TRX40 and co
      ALSA: hda: Add driver blacklist
      ALSA: hda: Fix potential access overflow in beep helper
      ALSA: ice1724: Fix invalid access for enumerated ctl items
      ALSA: pcm: oss: Fix regression by buffer overflow fix
      ALSA: hda/realtek - Add quirk for MSI GL63

Thinh Nguyen (1):
      usb: gadget: composite: Inform controller driver of self-powered

Thomas Gleixner (1):
      x86/entry/32: Add missing ASM_CLAC to general_protection entry

Thomas Hebb (3):
      ALSA: doc: Document PC Beep Hidden Register on Realtek ALC256
      ALSA: hda/realtek - Set principled PC Beep configuration for ALC256
      ALSA: hda/realtek - Remove now-unnecessary XPS 13 headphone noise fix=
ups

Thomas Hellstrom (1):
      x86: Don't let pgprot_modify() change the page encryption bit

Trond Myklebust (1):
      NFS: Fix a page leak in nfs_destroy_unlinked_subrequests()

Vasily Averin (3):
      tpm: tpm1_bios_measurements_next should increase position index
      tpm: tpm2_bios_measurements_next should increase position index
      pstore: pstore_ftrace_seq_next should increase position index

Vitaly Kuznetsov (1):
      KVM: VMX: fix crash cleanup when KVM wasn't used

Wen Yang (1):
      ipmi: fix hung processes in __get_guid()

Xu Wang (1):
      qlcnic: Fix bad kzalloc null test

Yang Xu (1):
      KEYS: reaching the keys quotas correctly

Yicong Yang (1):
      PCI/ASPM: Clear the correct bits when enabling L1 substates

Yilu Lin (1):
      CIFS: Fix bug which the return value by asynchronous read is error

YueHaibing (1):
      powerpc/pseries: Drop pointless static qualifier in vpa_debugfs_init()

Yury Norov (1):
      uapi: rename ext2_swab() to swab() and share globally in swab.h

Zheng Wei (1):
      net: vxge: fix wrong __VA_ARGS__ usage

Zhenzhong Duan (1):
      x86/speculation: Remove redundant arch_smt_update() invocation

Zhiqiang Liu (1):
      block, bfq: fix use-after-free in bfq_idle_slice_timer_body

chenqiwu (1):
      pstore/platform: fix potential mem leak if pstore_init_fs failed

=EC=9D=B4=EA=B2=BD=ED=83=9D (4):
      ASoC: fix regwmask
      ASoC: dapm: connect virtual mux with default value
      ASoC: dpcm: allow start or stop during pause for backend
      ASoC: topology: use name_prefix for new kcontrol


--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6ZxroACgkQONu9yGCS
aT7VgxAAjOWaZcsmANN2rANiDbt0dQHlm5F4ti6V0bIhjjBWytlwghj3wcufNKo0
rnEUOsK4b7j6YjDuGp7vCiNISKsO+fB2dgh/bib/4dT3YQSq+yGhWlWwCyWQolxr
lshFvrPD/ktvDNrf6cZnlh8s9k2J1gOWSSkjMLSti/dCKtd1wffDgMrdl8dRgl6I
6CdI3SgO7IMXzBAdQNF/9yxkNhNxglcgWpp/xah+MRO5JO8nNpWsN6VYrwMXDTv4
O+t/sj26ZbIRWLGd0cyKXFK/mwZ3VzRpdm3pN3oxEwN7zu8y7AgJZ5Y8UzzOQJ0b
R0Pp669QSdIbkWUOOz92JE729JcIFyzfcU8R4zp1oqTV38bVHT9s7SqIHYDAlD9D
V2xukCkIxSJdMB1qPnDInVo3KdpX3jR7mpNcgm28U/ctovTGG/9PjeVTJx/eM+hn
qgbXEXsxa4xjUBESYvPiQ28QQAjOdyEE409lOuMUE65noxGTZ0g4hP1egpwIdDJN
oH3z0w5IFrSXhPUKoyafQqPUJ/+lYAO1kc7r3IJS3LUbDMm34/8v1DcOjdRf0g8l
u0H2FXayN8TJUJ1SEzoB2iDSILi0UF/HFfutEgLb01yruzlY0UJNFCkjQpYhWgy8
e1Od8zDWx76H/orKCfzJxjViK0O91I5ZG8N22+qDUk0kTAFerv0=
=piZQ
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
