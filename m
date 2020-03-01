Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B62174C85
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 10:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCAJhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Mar 2020 04:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgCAJhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Mar 2020 04:37:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07FE6214DB;
        Sun,  1 Mar 2020 09:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583055471;
        bh=NHj+6Zhq6i4MXch7R8n6kNXyRGcUrgaENIzGzt2dPVw=;
        h=Date:From:To:Cc:Subject:From;
        b=AIL4whBAZ+EPcGXNseIpwdmxWMuLmfr7UitLslbefwF05Fx3E6DswB28hFP2w8LQz
         Ljz3R3evoDbg1d2fgMjk00FSXak+yqI/z2qwVbiN0d8GOgssN1AOehftCHt5sQkksG
         b+1jpKff7iguJh9+Jz7XQ4XVgjY9zKJvBnMLLsuU=
Date:   Sun, 1 Mar 2020 10:37:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.7
Message-ID: <20200301093749.GA1013956@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.7 kernel.

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

 Documentation/arm64/tagged-address-abi.rst                 |   11=20
 MAINTAINERS                                                |    2=20
 Makefile                                                   |    2=20
 arch/arm64/include/asm/lse.h                               |    2=20
 arch/arm64/include/asm/memory.h                            |    2=20
 arch/mips/boot/dts/ingenic/jz4740.dtsi                     |   17=20
 arch/mips/boot/dts/ingenic/jz4780.dtsi                     |   17=20
 arch/powerpc/include/asm/page.h                            |    5=20
 arch/powerpc/kernel/eeh_driver.c                           |   21=20
 arch/powerpc/kernel/entry_32.S                             |    4=20
 arch/powerpc/kernel/head_8xx.S                             |    2=20
 arch/powerpc/kernel/signal.c                               |   17=20
 arch/powerpc/kernel/signal_32.c                            |   28 -
 arch/powerpc/kernel/signal_64.c                            |   22=20
 arch/powerpc/mm/hugetlbpage.c                              |   29 -
 arch/s390/boot/kaslr.c                                     |    2=20
 arch/s390/include/asm/page.h                               |    2=20
 arch/x86/include/asm/kvm_host.h                            |    2=20
 arch/x86/include/asm/msr-index.h                           |    2=20
 arch/x86/kernel/cpu/amd.c                                  |   14=20
 arch/x86/kernel/cpu/mce/amd.c                              |   50 +-
 arch/x86/kernel/ima_arch.c                                 |    6=20
 arch/x86/kvm/irq_comm.c                                    |    2=20
 arch/x86/kvm/lapic.c                                       |    9=20
 arch/x86/kvm/svm.c                                         |    7=20
 arch/x86/kvm/vmx/capabilities.h                            |    1=20
 arch/x86/kvm/vmx/nested.c                                  |   44 +
 arch/x86/kvm/vmx/nested.h                                  |    5=20
 arch/x86/kvm/vmx/vmx.c                                     |   82 ++-
 crypto/hash_info.c                                         |    2=20
 drivers/acpi/acpica/evevent.c                              |   45 +
 drivers/acpi/sleep.c                                       |    7=20
 drivers/ata/ahci.c                                         |    7=20
 drivers/ata/libata-core.c                                  |   21=20
 drivers/block/floppy.c                                     |    7=20
 drivers/char/tpm/Makefile                                  |    8=20
 drivers/char/tpm/tpm2-cmd.c                                |    2=20
 drivers/char/tpm/tpm_tis_spi.c                             |  298 --------=
-----
 drivers/char/tpm/tpm_tis_spi_main.c                        |  298 ++++++++=
+++++
 drivers/dma/imx-sdma.c                                     |   19=20
 drivers/fsi/Kconfig                                        |    1=20
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                     |    2=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                      |    2=20
 drivers/gpu/drm/amd/amdgpu/soc15.c                         |    7=20
 drivers/gpu/drm/bridge/tc358767.c                          |    8=20
 drivers/gpu/drm/i915/Kconfig                               |    5=20
 drivers/gpu/drm/i915/display/intel_ddi.c                   |    4=20
 drivers/gpu/drm/i915/display/intel_display.c               |    2=20
 drivers/gpu/drm/i915/gem/i915_gem_context.c                |   16=20
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h           |    3=20
 drivers/gpu/drm/i915/gem/i915_gem_phys.c                   |   98 ++--
 drivers/gpu/drm/i915/gt/intel_lrc.c                        |   25 -
 drivers/gpu/drm/i915/gt/intel_ring.c                       |    1=20
 drivers/gpu/drm/i915/gt/intel_ring.h                       |    8=20
 drivers/gpu/drm/i915/gt/intel_ring_types.h                 |    1=20
 drivers/gpu/drm/i915/gt/mock_engine.c                      |   17=20
 drivers/gpu/drm/i915/gvt/gtt.c                             |    4=20
 drivers/gpu/drm/i915/i915_gem.c                            |    8=20
 drivers/gpu/drm/i915/i915_gpu_error.c                      |    3=20
 drivers/gpu/drm/i915/i915_scheduler.c                      |    6=20
 drivers/gpu/drm/i915/i915_utils.c                          |    5=20
 drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c                |    4=20
 drivers/gpu/drm/nouveau/dispnv50/wndw.c                    |    2=20
 drivers/gpu/drm/panfrost/panfrost_mmu.c                    |    7=20
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c                |   11=20
 drivers/hwmon/acpi_power_meter.c                           |   16=20
 drivers/infiniband/ulp/isert/ib_isert.c                    |   12=20
 drivers/iommu/intel-iommu.c                                |   41 +
 drivers/iommu/qcom_iommu.c                                 |   28 -
 drivers/net/ethernet/intel/ice/ice_txrx.c                  |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c        |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h          |    8=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |   20=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    4=20
 drivers/net/ethernet/mellanox/mlx5/core/wq.c               |   39 +
 drivers/net/ethernet/mellanox/mlx5/core/wq.h               |    2=20
 drivers/nvme/host/multipath.c                              |    1=20
 drivers/staging/android/ashmem.c                           |   28 +
 drivers/staging/greybus/audio_manager.c                    |    2=20
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c             |    4=20
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c             |    5=20
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c             |    4=20
 drivers/staging/vt6656/dpc.c                               |    2=20
 drivers/target/iscsi/iscsi_target.c                        |   16=20
 drivers/target/target_core_transport.c                     |   31 +
 drivers/thunderbolt/switch.c                               |    7=20
 drivers/tty/serdev/serdev-ttyport.c                        |    6=20
 drivers/tty/serial/8250/8250_aspeed_vuart.c                |    1=20
 drivers/tty/serial/8250/8250_core.c                        |    5=20
 drivers/tty/serial/8250/8250_of.c                          |    1=20
 drivers/tty/serial/8250/8250_port.c                        |    4=20
 drivers/tty/serial/atmel_serial.c                          |    3=20
 drivers/tty/serial/imx.c                                   |    2=20
 drivers/tty/serial/qcom_geni_serial.c                      |   18=20
 drivers/tty/tty_port.c                                     |    5=20
 drivers/tty/vt/selection.c                                 |    9=20
 drivers/tty/vt/vt.c                                        |   15=20
 drivers/tty/vt/vt_ioctl.c                                  |   17=20
 drivers/usb/core/config.c                                  |   11=20
 drivers/usb/core/hub.c                                     |   20=20
 drivers/usb/core/hub.h                                     |    1=20
 drivers/usb/core/quirks.c                                  |   40 +
 drivers/usb/core/usb.h                                     |    3=20
 drivers/usb/dwc2/gadget.c                                  |   40 +
 drivers/usb/dwc3/debug.h                                   |   39 -
 drivers/usb/dwc3/gadget.c                                  |    3=20
 drivers/usb/gadget/composite.c                             |    8=20
 drivers/usb/host/xhci-hub.c                                |   25 -
 drivers/usb/host/xhci-mem.c                                |   71 ++-
 drivers/usb/host/xhci-pci.c                                |   10=20
 drivers/usb/host/xhci.h                                    |   14=20
 drivers/usb/misc/iowarrior.c                               |   31 +
 drivers/usb/serial/ch341.c                                 |   10=20
 drivers/usb/storage/uas.c                                  |   23 -
 drivers/xen/preempt.c                                      |    4=20
 fs/btrfs/disk-io.c                                         |    3=20
 fs/btrfs/extent-tree.c                                     |    2=20
 fs/btrfs/inode.c                                           |   26 -
 fs/btrfs/ordered-data.c                                    |    7=20
 fs/btrfs/qgroup.c                                          |   13=20
 fs/btrfs/qgroup.h                                          |    1=20
 fs/btrfs/transaction.c                                     |    2=20
 fs/ecryptfs/crypto.c                                       |    6=20
 fs/ecryptfs/keystore.c                                     |    2=20
 fs/ecryptfs/messaging.c                                    |    1=20
 fs/ext4/balloc.c                                           |   14=20
 fs/ext4/ext4.h                                             |   39 +
 fs/ext4/ialloc.c                                           |   23 -
 fs/ext4/inode.c                                            |   16=20
 fs/ext4/mballoc.c                                          |   61 +-
 fs/ext4/migrate.c                                          |   27 -
 fs/ext4/namei.c                                            |    1=20
 fs/ext4/resize.c                                           |   62 ++
 fs/ext4/super.c                                            |  113 +++-
 fs/io_uring.c                                              |   51 --
 fs/jbd2/transaction.c                                      |    8=20
 include/acpi/acpixf.h                                      |    1=20
 include/linux/intel-svm.h                                  |    2=20
 include/linux/irqdomain.h                                  |    2=20
 include/linux/libata.h                                     |    1=20
 include/linux/tty.h                                        |    2=20
 include/linux/usb/quirks.h                                 |    3=20
 include/scsi/iscsi_proto.h                                 |    1=20
 include/sound/rawmidi.h                                    |    6=20
 ipc/sem.c                                                  |    6=20
 kernel/bpf/offload.c                                       |    2=20
 kernel/dma/direct.c                                        |   24 -
 kernel/irq/internals.h                                     |    2=20
 kernel/irq/manage.c                                        |   18=20
 kernel/irq/proc.c                                          |   22=20
 kernel/sched/psi.c                                         |    3=20
 lib/crypto/chacha20poly1305.c                              |    3=20
 lib/stackdepot.c                                           |    8=20
 mm/memcontrol.c                                            |    4=20
 mm/mmap.c                                                  |    4=20
 mm/mremap.c                                                |    1=20
 mm/sparse.c                                                |    2=20
 mm/vmscan.c                                                |    9=20
 net/netfilter/xt_hashlimit.c                               |   10=20
 net/rxrpc/call_object.c                                    |   22=20
 scripts/get_maintainer.pl                                  |    8=20
 sound/core/seq/seq_clientmgr.c                             |    4=20
 sound/core/seq/seq_queue.c                                 |   29 -
 sound/core/seq/seq_timer.c                                 |   13=20
 sound/core/seq/seq_timer.h                                 |    3=20
 sound/hda/hdmi_chmap.c                                     |    2=20
 sound/pci/hda/hda_codec.c                                  |    2=20
 sound/pci/hda/hda_eld.c                                    |    2=20
 sound/pci/hda/hda_sysfs.c                                  |    4=20
 sound/pci/hda/patch_realtek.c                              |    2=20
 sound/soc/atmel/Kconfig                                    |    4=20
 sound/soc/atmel/Makefile                                   |   10=20
 sound/soc/fsl/fsl_sai.c                                    |   22=20
 sound/soc/soc-dapm.c                                       |    3=20
 sound/soc/sof/intel/hda-dai.c                              |    4=20
 sound/soc/sunxi/sun8i-codec.c                              |    3=20
 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c     |    5=20
 178 files changed, 1838 insertions(+), 1007 deletions(-)

Aditya Pakki (1):
      ecryptfs: replace BUG_ON with error handling code

Alan Stern (1):
      USB: hub: Don't record a connect-change event during reset-resume

Alex Deucher (3):
      drm/amdgpu/soc15: fix xclk for raven
      drm/amdgpu/gfx9: disable gfxoff when reading rlc clock
      drm/amdgpu/gfx10: disable gfxoff when reading rlc clock

Alexander Potapenko (1):
      lib/stackdepot.c: fix global out-of-bounds in stack_slabs

Andy Shevchenko (1):
      serial: 8250: Check UPF_IRQ_SHARED in advance

Anurag Kumar Vulisha (1):
      usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields

Ard Biesheuvel (1):
      x86/ima: use correct identifier for SetupMode variable

Arnd Bergmann (1):
      ASoC: atmel: fix atmel_ssc_set_audio link failure

Aya Levin (2):
      net/mlx5e: Reset RQ doorbell counter before moving RQ state from RST =
to RDY
      net/mlx5e: Fix crash in recovery flow without devlink reporter

Bart Van Assche (3):
      scsi: Revert "target/core: Inline transport_lun_remove_cmd()"
      scsi: Revert "RDMA/isert: Fix a recently introduced regression relate=
d to logout"
      scsi: Revert "target: iscsi: Wait for all commands to finish before f=
reeing a session"

Boris Brezillon (1):
      drm/panfrost: perfcnt: Reserve/use the AS attached to the perfcnt MMU=
 context

Borislav Petkov (1):
      x86/mce/amd: Publish the bank pointer only after setup has succeeded

Brendan Higgins (1):
      fsi: aspeed: add unspecified HAS_IOMEM dependency

Catalin Marinas (1):
      mm: Avoid creating virtual address aliases in brk()/mmap()/mremap()

Chris Wilson (5):
      drm/i915: Wean off drm_pci_alloc/drm_pci_free
      drm/i915/execlists: Always force a context reload when rewinding RING=
_TAIL
      drm/i915/selftests: Add a mock i915_vma to the mock_ring
      drm/i915/gem: Require per-engine reset support for non-persistent con=
texts
      drm/i915/gt: Protect defer_request() from new waiters

Christoph Hellwig (1):
      dma-direct: relax addressability checks in dma_direct_supported

Christophe Leroy (4):
      powerpc/8xx: Fix clearing of bits 20-23 in ITLB miss
      powerpc/entry: Fix an #if which should be an #ifdef in entry_32.S
      powerpc/hugetlb: Fix 512k hugepages on 8xx with 16k page size
      powerpc/hugetlb: Fix 8M hugepages on 8xx

Colin Ian King (2):
      usb: dwc3: debug: fix string position formatting mixup with ret and l=
en
      staging: rtl8723bs: fix copy of overlapping memory

Cong Wang (1):
      netfilter: xt_hashlimit: limit the max size of hashtable

Dan Carpenter (1):
      staging: greybus: use after free in gb_audio_manager_remove_all()

David Howells (1):
      rxrpc: Fix call RCU cleanup using non-bh-safe locks

Dmytro Linkin (1):
      net/mlx5e: Don't clear the whole vf config when switching modes

Douglas Anderson (1):
      scripts/get_maintainer.pl: deprioritize old Fixes: addresses

EJ Hsu (1):
      usb: uas: fix a plug & unplug racing

Eric Biggers (2):
      ext4: rename s_journal_flag_rwsem to s_writepages_rwsem
      ext4: fix race between writepages and enabling EXT4_EXTENTS_FL

Eric Dumazet (1):
      vt: vt_ioctl: fix race in VT_RESIZEX

Filipe Manana (3):
      Btrfs: fix race between shrinking truncate and fiemap
      Btrfs: fix btrfs_wait_ordered_range() so that it waits for all ordere=
d extents
      Btrfs: fix deadlock during fast fsync when logging prealloc extents b=
eyond eof

Fugang Duan (1):
      tty: serial: imx: setup the correct sg entry for tx dma

Gavin Shan (1):
      mm/vmscan.c: don't round up scan size for online memory cgroup

Greg Kroah-Hartman (5):
      USB: misc: iowarrior: add support for 2 OEMed devices
      USB: misc: iowarrior: add support for the 28 and 28L devices
      USB: misc: iowarrior: add support for the 100 device
      Revert "dmaengine: imx-sdma: Fix memory leak"
      Linux 5.5.7

Guenter Roeck (1):
      hwmon: (acpi_power_meter) Fix lockdep splat

Gustavo Luiz Duarte (1):
      powerpc/tm: Fix clearing MSR[TS] in current when reclaiming on signal=
 delivery

Hardik Gajjar (1):
      USB: hub: Fix the broken detection of USB3 device in SMSC hub

Huy Nguyen (1):
      net/mlx5: Fix sleep while atomic in mlx5_eswitch_get_vepa

Igor Druzhinin (1):
      drm/i915/gvt: more locking for ppgtt mm LRU list

Ioanna Alifieraki (1):
      Revert "ipc,sem: remove uneeded sem_undo_list lock usage in exit_sem(=
)"

Jack Pham (1):
      usb: gadget: composite: Fix bMaxPower for SuperSpeedPlus

Jan Kara (1):
      ext4: fix mount failure with quota configured as module

Jani Nikula (2):
      MAINTAINERS: Update drm/i915 bug filing URL
      drm/i915: Update drm/i915 bug filing URL

Jarkko Sakkinen (1):
      tpm: Revert tpm_tis_spi_mod.ko to tpm_tis_spi.ko.

Jason A. Donenfeld (1):
      crypto: chacha20poly1305 - prevent integer overflow on large input

Jeff Mahoney (1):
      btrfs: destroy qgroup extent records on transaction abort

Jiri Slaby (1):
      vt: selection, handle pending signals in paste_selection

Joerg Roedel (6):
      iommu/vt-d: Add attach_deferred() helper
      iommu/vt-d: Move deferred device attachment into helper function
      iommu/vt-d: Do deferred attachment in iommu_need_mapping()
      iommu/vt-d: Remove deferred_attach_domain()
      iommu/vt-d: Simplify check in identity_mapping()
      iommu/vt-d: Fix compile warning from intel-svm.h

Johan Hovold (4):
      USB: serial: ch341: fix receiver regression
      USB: core: add endpoint-blacklist quirk
      USB: quirks: blacklist duplicate ep on Sound Devices USBPre2
      serdev: ttyport: restore client ops on deregistration

Johannes Krude (1):
      bpf, offload: Replace bitwise AND by logical AND in bpf_prog_offload_=
info_fill

John Fastabend (1):
      bpf: Selftests build error in sockmap_basic.c

Josef Bacik (5):
      btrfs: don't set path->leave_spinning for truncate
      btrfs: handle logged extent failure properly
      btrfs: fix bytes_may_use underflow in prealloc error condtition
      btrfs: reset fs_root to NULL on error in open_ctree
      btrfs: do not check delayed items are empty for single transaction cl=
eanup

Kim Phillips (1):
      x86/cpu/amd: Enable the fixed Instructions Retired counter IRPERF

Larry Finger (4):
      staging: rtl8188eu: Fix potential security hole
      staging: rtl8188eu: Fix potential overuse of kernel memory
      staging: rtl8723bs: Fix potential security hole
      staging: rtl8723bs: Fix potential overuse of kernel memory

Linus Torvalds (1):
      floppy: check FDC index for errors before assigning it

Logan Gunthorpe (1):
      nvme-multipath: Fix memory leak with ana_log_buf

Lyude Paul (1):
      drm/nouveau/kms/gv100-: Re-set LUT after clearing for modesets

Malcolm Priestley (1):
      staging: vt6656: fix sign of rx_dbm to bb_pre_ed_rssi.

Mathias Nyman (4):
      xhci: Force Maximum Packet size for Full-speed bulk devices to valid =
range.
      xhci: fix runtime pm enabling for quirky Intel hosts
      xhci: apply XHCI_PME_STUCK_QUIRK to Intel Comet Lake platforms
      xhci: Fix memory leak when caching protocol extended capability PSI t=
ables - take 2

Matt Roper (1):
      drm/i915/ehl: Update port clock voltage level requirements

Miaohe Lin (2):
      KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt E=
OI
      KVM: apic: avoid calculating pending eoi from an uninitialized val

Mika Westerberg (1):
      thunderbolt: Prevent crash if non-active NVMem file is read

Minas Harutyunyan (2):
      usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
      usb: dwc2: Fix in ISOC request length checking

Nathan Chancellor (2):
      s390/kaslr: Fix casts in get_random
      s390/mm: Explicitly compare PAGE_DEFAULT_KEY against zero in storage_=
key_init_range

Nicolas Ferre (1):
      tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode

Nicolas Pitre (1):
      vt: fix scrollback flushing on background consoles

Oleksandr Suvorov (1):
      ASoC: fsl_sai: Fix exiting path on probing failure

Oliver Upton (2):
      KVM: nVMX: Refactor IO bitmap checks into helper function
      KVM: nVMX: Check IO instruction VM-exit conditions

Paolo Bonzini (1):
      KVM: nVMX: Don't emulate instructions in guest mode

Paul Cercueil (1):
      MIPS: ingenic: DTS: Fix watchdog nodes

Prabhakar Kushwaha (1):
      ata: ahci: Add shutdown to freeze hardware resources of ahci

Qian Cai (1):
      ext4: fix a data race in EXT4_I(inode)->i_disksize

Rafael J. Wysocki (1):
      ACPI: PM: s2idle: Check fixed wakeup events in acpi_s2idle_wake()

Richard Dodd (1):
      USB: Fix novation SourceControl XL after suspend

Rob Clark (1):
      drm/msm/dpu: fix BGR565 vs RGB565 confusion

Roberto Sassu (1):
      tpm: Initialize crypto_id of allocated_banks to HASH_ALGO__LAST

Robin Murphy (1):
      iommu/qcom: Fix bogus detach logic

Sam Bobroff (1):
      powerpc/eeh: Fix deadlock handling dead PHB

Samuel Holland (2):
      ASoC: codec2codec: avoid invalid/double-free of pcm runtime
      ASoC: sun8i-codec: Fix setting DAI data format

Sathyanarayana Nujella (1):
      ASoC: SOF: Intel: hda: Add iDisp4 DAI

Shijie Luo (1):
      ext4: add cond_resched() to __ext4_find_entry()

Stefano Garzarella (1):
      io_uring: prevent sq_thread from spinning when it should stop

Suraj Jitindar Singh (2):
      ext4: fix potential race between s_group_info online resizing and acc=
ess
      ext4: fix potential race between s_flex_groups online resizing and ac=
cess

Suren Baghdasaryan (2):
      staging: android: ashmem: Disallow ashmem memory from being remapped
      sched/psi: Fix OOB write when writing 0 bytes to PSI files

Takashi Iwai (6):
      ALSA: hda: Use scnprintf() for printing texts for sysfs/procfs
      ALSA: hda/realtek - Apply quirk for MSI GP63, too
      ALSA: hda/realtek - Apply quirk for yet another MSI laptop
      ALSA: rawmidi: Avoid bit fields for state flags
      ALSA: seq: Avoid concurrent access to queue flags
      ALSA: seq: Fix concurrent access to queue current tick/time

Theodore Ts'o (1):
      ext4: fix potential race between online resizing and write operations

Thomas Gleixner (3):
      x86/mce/amd: Fix kobject lifetime
      genirq/proc: Reject invalid affinity masks (again)
      xen: Enable interrupts when calling _cond_resched()

Tianjia Zhang (1):
      crypto: rename sm3-256 to sm3 in hash_algo_name

Tomi Valkeinen (1):
      drm/bridge: tc358767: fix poll timeouts

Tony Nguyen (1):
      ice: Remove possible null dereference

Vasily Averin (1):
      mm/memcontrol.c: lost css_put in memcg_expand_shrinker_maps()

Vincenzo Frascino (1):
      arm64: lse: Fix LSE atomics with LLVM

Vitaly Kuznetsov (2):
      KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only=
 when apicv is globally disabled
      KVM: nVMX: handle nested posted interrupts when apicv is disabled for=
 L1

Wei Yang (1):
      mm/sparsemem: pfn_to_page is not valid yet on SPARSEMEM

Wenwen Wang (2):
      ecryptfs: fix a memory leak bug in parse_tag_1_packet()
      ecryptfs: fix a memory leak bug in ecryptfs_init_messaging()

Will Deacon (1):
      arm64: memory: Add missing brackets to untagged_addr() macro

Xiaoguang Wang (1):
      io_uring: fix __io_iopoll_check deadlock in io_sq_thread

Zenghui Yu (1):
      genirq/irqdomain: Make sure all irq domain flags are distinct

satya priya (1):
      tty: serial: qcom_geni_serial: Fix RX cancel command failure

wangyan (1):
      jbd2: fix ocfs2 corrupt when clearing block group bits


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5bgmwACgkQONu9yGCS
aT6lhxAAgFp8b547gva2eUihLA+uLCpUMu7X+6minlzBxdMnkKfY3AMzKU0RHe3C
a8FsyU1gd0Gr9719AYQUQpetWlsF2Ukxq9tBHnJ64dQepYEhsG9cextq72CYao33
PWlpD3sEaeAkZPKybRmAVQo3oiGcAalQ0CUW7ME09hDcQqIeEE7v4g+xKqs+HvSH
1FjQ9P2trRNwSm+pE6wuGcPrkgonc/sRqFXCnVa6z6Xguyf4pO79Nsh+wXLzEDt+
HdKoDOgkEKZQ9Rtt3JbDF7hwCOqtUm+gO2dHy73lAaSmWdOU+AgPR0HM4naTMpeX
u3tktB3/dnMI0rML2MO0HHQZqm8G9AOjVeoqc8EA2IiHE9OfMTf1nCMrGzSX7rCd
ndQew59QA8mfnybeCS32qE/f9fprB665EqlIWvd//4PvWoz8RjhhOB8POOsm8jdu
D5iyEsKVM/LtY9aDimiJiBIvP88z/thsF4H6CHC33kN7NhZlxRm+x16mCjpL7IfE
gKWAigxzkAlDm+XHG+QWY78+1WONQKE8vAKdx7fogpPZIcN8brYyik+LGjkDCxhS
wEuXkMumzwRQyVp1AvqSaXYyWd0iT3Io7odtGazVtXqU7k+GBEPSa8wq/NPSDcjm
uwWKXG7YnCvDhq1SKUoFBJSUSbd+cUNw9A49RcgJs5cfIhpyNbw=
=uBPS
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
