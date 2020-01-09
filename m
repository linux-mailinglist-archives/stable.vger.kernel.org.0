Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAB91361BA
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 21:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgAIU0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 15:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729823AbgAIU0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 15:26:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33A9E206ED;
        Thu,  9 Jan 2020 20:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578601594;
        bh=J/+weyeP0Eq7o4pGQSwWvVxp9QvLtyN7Oqj0/YXWpGM=;
        h=Date:From:To:Cc:Subject:From;
        b=Qv/Ko6EF/aFMlyogPM0xsM12gIp9ruXDJsfVrBN4PzTF2GNcpjkrBHLMHdAPPIlyZ
         hVvPBHj/ozTVB2XtKSmGPeXPVlGaFs7jFPGu3EDBS/q2q/I48CP14T+AxtZMmGkKgU
         1kQNBjpOIcLfRcb54GZiYtHgCNqb/ntvm8fQual4=
Date:   Thu, 9 Jan 2020 21:26:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.9
Message-ID: <20200109202632.GA7864@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.9 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt                         | =
   2=20
 Documentation/devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.txt | =
   2=20
 Makefile                                                                | =
   2=20
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts                     | =
   4=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts              | =
   3=20
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts                   | =
   3=20
 arch/arm64/boot/dts/qcom/msm8998-clamshell.dtsi                         | =
  37 ++
 arch/arm64/include/asm/pgtable-prot.h                                   | =
   5=20
 arch/arm64/include/asm/pgtable.h                                        | =
  10=20
 arch/arm64/mm/fault.c                                                   | =
   2=20
 arch/arm64/mm/mmu.c                                                     | =
   4=20
 arch/ia64/mm/init.c                                                     | =
   4=20
 arch/mips/Kconfig                                                       | =
   2=20
 arch/mips/include/asm/thread_info.h                                     | =
  20 +
 arch/mips/net/ebpf_jit.c                                                | =
   2=20
 arch/powerpc/mm/mem.c                                                   | =
  30 +-
 arch/powerpc/mm/slice.c                                                 | =
   4=20
 arch/riscv/kernel/ftrace.c                                              | =
   2=20
 arch/s390/kernel/perf_cpum_sf.c                                         | =
  22 +
 arch/s390/kernel/smp.c                                                  | =
  80 ++++--
 arch/s390/mm/init.c                                                     | =
   4=20
 arch/sh/mm/init.c                                                       | =
   4=20
 arch/x86/events/intel/bts.c                                             | =
  16 -
 arch/x86/mm/init_32.c                                                   | =
   4=20
 arch/x86/mm/init_64.c                                                   | =
   4=20
 block/bio.c                                                             | =
  39 ++
 block/compat_ioctl.c                                                    | =
  13=20
 drivers/acpi/sysfs.c                                                    | =
   6=20
 drivers/ata/ahci_brcm.c                                                 | =
 133 +++++++---
 drivers/ata/libahci_platform.c                                          | =
   6=20
 drivers/ata/libata-core.c                                               | =
  24 +
 drivers/ata/sata_fsl.c                                                  | =
   2=20
 drivers/ata/sata_mv.c                                                   | =
   2=20
 drivers/ata/sata_nv.c                                                   | =
   2=20
 drivers/block/xen-blkback/blkback.c                                     | =
   2=20
 drivers/block/xen-blkback/xenbus.c                                      | =
  10=20
 drivers/bluetooth/btusb.c                                               | =
   3=20
 drivers/clocksource/timer-riscv.c                                       | =
   2=20
 drivers/devfreq/devfreq.c                                               | =
  30 +-
 drivers/dma/dma-jz4780.c                                                | =
   3=20
 drivers/dma/virt-dma.c                                                  | =
   3=20
 drivers/firewire/net.c                                                  | =
   6=20
 drivers/firmware/arm_scmi/bus.c                                         | =
   8=20
 drivers/firmware/efi/rci2-table.c                                       | =
   3=20
 drivers/gpio/gpio-xtensa.c                                              | =
   7=20
 drivers/gpio/gpiolib.c                                                  | =
   8=20
 drivers/gpu/drm/amd/amdgpu/df_v3_6.c                                    | =
  38 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c                                   | =
  22 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                           | =
   2=20
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c                        | =
   9=20
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c                   | =
  13=20
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_stream_encoder.c             | =
  12=20
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c                   | =
   2=20
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c                              | =
   1=20
 drivers/gpu/drm/amd/powerplay/arcturus_ppt.c                            | =
   8=20
 drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h                          | =
   1=20
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c                              | =
   3=20
 drivers/gpu/drm/amd/powerplay/vega20_ppt.c                              | =
   3=20
 drivers/gpu/drm/i915/gt/intel_lrc.c                                     | =
   3=20
 drivers/gpu/drm/mcde/mcde_dsi.c                                         | =
   6=20
 drivers/gpu/drm/msm/msm_gpu.c                                           | =
   1=20
 drivers/gpu/drm/nouveau/dispnv50/disp.c                                 | =
   6=20
 drivers/gpu/drm/nouveau/nouveau_connector.c                             | =
  28 +-
 drivers/gpu/drm/nouveau/nouveau_connector.h                             | =
 116 ++++----
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c                                  | =
   2=20
 drivers/hid/i2c-hid/i2c-hid-core.c                                      | =
  12=20
 drivers/iio/accel/st_accel_core.c                                       | =
   8=20
 drivers/iio/adc/max9611.c                                               | =
  16 -
 drivers/infiniband/core/cma.c                                           | =
   1=20
 drivers/infiniband/core/counters.c                                      | =
   3=20
 drivers/infiniband/hw/mlx4/main.c                                       | =
   9=20
 drivers/infiniband/hw/mlx5/main.c                                       | =
  13=20
 drivers/infiniband/sw/rxe/rxe_recv.c                                    | =
   2=20
 drivers/infiniband/sw/rxe/rxe_req.c                                     | =
   6=20
 drivers/infiniband/sw/rxe/rxe_resp.c                                    | =
   7=20
 drivers/iommu/intel-svm.c                                               | =
   6=20
 drivers/md/raid1.c                                                      | =
   2=20
 drivers/md/raid5.c                                                      | =
   2=20
 drivers/media/cec/cec-adap.c                                            | =
  40 ++-
 drivers/media/usb/b2c2/flexcop-usb.c                                    | =
   2=20
 drivers/media/usb/dvb-usb/af9005.c                                      | =
   5=20
 drivers/media/usb/pulse8-cec/pulse8-cec.c                               | =
  17 -
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                           | =
  23 +
 drivers/nvme/host/fc.c                                                  | =
  32 ++
 drivers/nvme/host/pci.c                                                 | =
  14 -
 drivers/nvme/target/fcloop.c                                            | =
   1=20
 drivers/of/overlay.c                                                    | =
  37 +-
 drivers/pci/pci.c                                                       | =
  18 +
 drivers/phy/renesas/phy-rcar-gen3-usb2.c                                | =
   2=20
 drivers/platform/x86/pmc_atom.c                                         | =
   8=20
 drivers/regulator/ab8500.c                                              | =
  17 -
 drivers/regulator/axp20x-regulator.c                                    | =
  11=20
 drivers/regulator/bd70528-regulator.c                                   | =
   1=20
 drivers/scsi/libsas/sas_discover.c                                      | =
  11=20
 drivers/scsi/lpfc/lpfc_bsg.c                                            | =
  15 -
 drivers/scsi/lpfc/lpfc_hbadisc.c                                        | =
  88 ++++--
 drivers/scsi/lpfc/lpfc_nvme.c                                           | =
   2=20
 drivers/scsi/lpfc/lpfc_sli.c                                            | =
   2=20
 drivers/scsi/qla2xxx/qla_def.h                                          | =
   1=20
 drivers/scsi/qla2xxx/qla_init.c                                         | =
  11=20
 drivers/scsi/qla2xxx/qla_iocb.c                                         | =
  22 +
 drivers/scsi/qla2xxx/qla_isr.c                                          | =
   4=20
 drivers/scsi/qla2xxx/qla_mbx.c                                          | =
   3=20
 drivers/scsi/qla2xxx/qla_nvme.c                                         | =
   1=20
 drivers/scsi/qla2xxx/qla_target.c                                       | =
   3=20
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                                      | =
   1=20
 drivers/scsi/qla4xxx/ql4_os.c                                           | =
   1=20
 drivers/scsi/scsi_transport_iscsi.c                                     | =
   7=20
 drivers/spi/spi-fsl-dspi.c                                              | =
  15 -
 drivers/spi/spi-uniphier.c                                              | =
  31 +-
 drivers/staging/wlan-ng/Kconfig                                         | =
   1=20
 drivers/tty/serial/msm_serial.c                                         | =
  13=20
 drivers/usb/gadget/function/f_ecm.c                                     | =
   6=20
 drivers/usb/gadget/function/f_rndis.c                                   | =
   1=20
 drivers/watchdog/Kconfig                                                | =
   1=20
 drivers/xen/balloon.c                                                   | =
   3=20
 fs/afs/dynroot.c                                                        | =
   3=20
 fs/afs/mntpt.c                                                          | =
   6=20
 fs/afs/server.c                                                         | =
  21 -
 fs/afs/super.c                                                          | =
   1=20
 fs/btrfs/async-thread.c                                                 | =
  58 ----
 fs/btrfs/async-thread.h                                                 | =
  33 --
 fs/btrfs/block-group.c                                                  | =
   3=20
 fs/btrfs/delayed-inode.c                                                | =
   4=20
 fs/btrfs/disk-io.c                                                      | =
  34 --
 fs/btrfs/extent_io.c                                                    | =
   2=20
 fs/btrfs/inode.c                                                        | =
  67 ++---
 fs/btrfs/ordered-data.c                                                 | =
   1=20
 fs/btrfs/qgroup.c                                                       | =
   1=20
 fs/btrfs/raid56.c                                                       | =
   5=20
 fs/btrfs/reada.c                                                        | =
   3=20
 fs/btrfs/scrub.c                                                        | =
  14 -
 fs/btrfs/volumes.c                                                      | =
   3=20
 fs/buffer.c                                                             | =
  25 -
 fs/cifs/dfs_cache.c                                                     | =
   3=20
 fs/cifs/inode.c                                                         | =
   2=20
 fs/cifs/smb2pdu.c                                                       | =
  41 ++-
 fs/compat_ioctl.c                                                       | =
   3=20
 fs/io_uring.c                                                           | =
   4=20
 fs/locks.c                                                              | =
   2=20
 fs/nfsd/nfs4state.c                                                     | =
  15 -
 fs/ocfs2/dlmglue.c                                                      | =
   1=20
 fs/pstore/ram.c                                                         | =
  13=20
 fs/ubifs/tnc_commit.c                                                   | =
  34 ++
 fs/xfs/libxfs/xfs_bmap.c                                                | =
   2=20
 fs/xfs/scrub/common.h                                                   | =
   9=20
 include/linux/ahci_platform.h                                           | =
   2=20
 include/linux/bio.h                                                     | =
   1=20
 include/linux/dmaengine.h                                               | =
   5=20
 include/linux/libata.h                                                  | =
   1=20
 include/linux/memory_hotplug.h                                          | =
   7=20
 include/linux/nvme-fc-driver.h                                          | =
   4=20
 include/linux/pci.h                                                     | =
   2=20
 include/linux/regulator/ab8500.h                                        | =
   1=20
 include/net/neighbour.h                                                 | =
   2=20
 include/net/sch_generic.h                                               | =
   6=20
 include/net/sock.h                                                      | =
   4=20
 kernel/bpf/verifier.c                                                   | =
  43 +--
 kernel/cred.c                                                           | =
   6=20
 kernel/exit.c                                                           | =
  12=20
 kernel/module.c                                                         | =
   2=20
 kernel/power/snapshot.c                                                 | =
   9=20
 kernel/seccomp.c                                                        | =
   7=20
 kernel/taskstats.c                                                      | =
  30 +-
 kernel/trace/ftrace.c                                                   | =
   6=20
 kernel/trace/trace.c                                                    | =
   8=20
 kernel/trace/trace_events.c                                             | =
   8=20
 kernel/trace/trace_events_filter.c                                      | =
   2=20
 kernel/trace/trace_events_hist.c                                        | =
  21 +
 kernel/trace/tracing_map.c                                              | =
   4=20
 lib/ubsan.c                                                             | =
  64 +---
 mm/filemap.c                                                            | =
  21 -
 mm/gup_benchmark.c                                                      | =
   8=20
 mm/hugetlb.c                                                            | =
  51 +++
 mm/internal.h                                                           | =
  21 +
 mm/memory.c                                                             | =
  38 ++
 mm/memory_hotplug.c                                                     | =
  31 +-
 mm/memremap.c                                                           | =
   2=20
 mm/migrate.c                                                            | =
  23 +
 mm/mmap.c                                                               | =
   6=20
 mm/oom_kill.c                                                           | =
   2=20
 mm/shmem.c                                                              | =
  11=20
 mm/sparse.c                                                             | =
   4=20
 mm/zsmalloc.c                                                           | =
   5=20
 net/bluetooth/hci_conn.c                                                | =
   4=20
 net/bluetooth/l2cap_core.c                                              | =
   4=20
 net/core/dev.c                                                          | =
   2=20
 net/core/neighbour.c                                                    | =
   4=20
 net/core/sock.c                                                         | =
   2=20
 net/core/sysctl_net_core.c                                              | =
   2=20
 net/ethernet/eth.c                                                      | =
   7=20
 net/hsr/hsr_debugfs.c                                                   | =
  16 -
 net/hsr/hsr_device.c                                                    | =
  26 +
 net/hsr/hsr_framereg.c                                                  | =
  73 +++--
 net/hsr/hsr_framereg.h                                                  | =
   6=20
 net/hsr/hsr_main.c                                                      | =
   2=20
 net/hsr/hsr_main.h                                                      | =
  16 -
 net/ipv4/tcp.c                                                          | =
  14 -
 net/ipv4/tcp_bbr.c                                                      | =
   3=20
 net/ipv4/tcp_output.c                                                   | =
   4=20
 net/netfilter/nf_queue.c                                                | =
   2=20
 net/netfilter/nft_tproxy.c                                              | =
   4=20
 net/sched/sch_generic.c                                                 | =
   2=20
 net/socket.c                                                            | =
   4=20
 net/sunrpc/cache.c                                                      | =
   6=20
 samples/seccomp/user-trap.c                                             | =
   4=20
 samples/trace_printk/trace-printk.c                                     | =
   1=20
 scripts/gcc-plugins/Kconfig                                             | =
   9=20
 security/apparmor/apparmorfs.c                                          | =
   2=20
 security/apparmor/domain.c                                              | =
  82 +++---
 security/apparmor/policy.c                                              | =
   4=20
 sound/core/pcm_native.c                                                 | =
   3=20
 sound/firewire/motu/motu-proc.c                                         | =
   2=20
 sound/isa/cs423x/cs4236.c                                               | =
   3=20
 sound/pci/hda/hda_controller.c                                          | =
   2=20
 sound/pci/hda/hda_intel.c                                               | =
  17 -
 sound/pci/hda/patch_realtek.c                                           | =
  61 +++-
 sound/pci/ice1712/ice1724.c                                             | =
   9=20
 sound/usb/card.h                                                        | =
   1=20
 sound/usb/pcm.c                                                         | =
  25 +
 sound/usb/quirks-table.h                                                | =
   3=20
 sound/usb/quirks.c                                                      | =
  11=20
 sound/usb/usbaudio.h                                                    | =
   3=20
 tools/perf/util/machine.c                                               | =
   2=20
 tools/testing/selftests/rseq/param_test.c                               | =
  18 -
 tools/testing/selftests/seccomp/seccomp_bpf.c                           | =
  15 +
 usr/gen_initramfs_list.sh                                               | =
   2=20
 227 files changed, 1764 insertions(+), 1029 deletions(-)

Adrian Hunter (1):
      perf callchain: Fix segfault in thread__resolve_callchain_sample()

Al Viro (1):
      fix compat handling of FICLONERANGE, FIDEDUPERANGE and FS_IOC_FIEMAP

Alastair D'Silva (1):
      powerpc: Chunk calls to flush_dcache_range in arch_*_memory

Aleksandr Yashkin (1):
      pstore/ram: Write new dumps to start of recycled zones

Alex Deucher (5):
      drm/amdgpu: add header line for power profile on Arcturus
      drm/amdgpu/smu: add metrics table lock
      drm/amdgpu/smu: add metrics table lock for arcturus (v2)
      drm/amdgpu/smu: add metrics table lock for navi (v2)
      drm/amdgpu/smu: add metrics table lock for vega20 (v2)

Alexander Lobakin (2):
      MIPS: BPF: eBPF JIT: check for MIPS ISA compliance in Kconfig
      net, sysctl: Fix compiler warning when only cBPF is present

Alexander Shishkin (1):
      perf/x86/intel/bts: Fix the use of page_private()

Amir Goldstein (1):
      locks: print unsigned ino in /proc/locks

Anand Moon (1):
      arm64: dts: meson: odroid-c2: Disable usb_otg bus to avoid power fail=
ed warning

Andy Whitcroft (1):
      PM / hibernate: memory_bm_find_bit(): Tighten node optimisation

Ard Biesheuvel (1):
      efi: Don't attempt to map RCI2 config table if it doesn't exist

Arnd Bergmann (5):
      gcc-plugins: make it possible to disable CONFIG_GCC_PLUGINS again
      compat_ioctl: block: handle Persistent Reservations
      compat_ioctl: block: handle BLKREPORTZONE/BLKRESETZONE
      compat_ioctl: block: handle BLKGETZONESZ/BLKGETNRZONES
      drm/msm: include linux/sched/task.h

Axel Lin (2):
      regulator: axp20x: Fix axp20x_set_ramp_delay
      regulator: bd70528: Remove .set_ramp_delay for bd70528_ldo_ops

Ben Skeggs (1):
      drm/nouveau/kms/nv50-: fix panel scaling

Bo Wu (2):
      scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func
      scsi: iscsi: Avoid potential deadlock in iscsi_if_rx func

Catalin Marinas (1):
      arm64: Revert support for execute-only user mappings

Chanho Min (1):
      mm/zsmalloc.c: fix the migrated zspage statistics.

Chen-Yu Tsai (1):
      regulator: axp20x: Fix AXP22x ELDO2 regulator enable bitmask

Chris Chiu (1):
      ALSA: hda/realtek - Enable the bass speaker of ASUS UX431FLC

Chris Mason (1):
      Btrfs: only associate the locked page with one async_chunk struct

Chris Wilson (1):
      drm/i915/execlists: Fix annotation for decoupling virtual request

Christian Brauner (1):
      taskstats: fix data-race

Christian Hewitt (2):
      arm64: dts: meson-gxl-s905x-khadas-vim: fix uart_A bluetooth node
      arm64: dts: meson-gxm-khadas-vim2: fix uart_A bluetooth node

Chuhong Yuan (1):
      RDMA/cma: add missed unregister_pernet_subsys in init failure

Colin Ian King (2):
      ALSA: cs4236: fix error return comparison of an unsigned integer
      media: flexcop-usb: ensure -EIO is returned on error condition

Dan Carpenter (2):
      scsi: iscsi: qla4xxx: fix double free in probe
      Bluetooth: delete a stray unlock

Daniel Borkmann (1):
      bpf: Fix precision tracking for unbounded scalars

Darrick J. Wong (1):
      xfs: periodically yield scrub threads to the scheduler

David Galiffi (1):
      drm/amd/display: Fixed kernel panic when booting with DP-to-HDMI dong=
le

David Hildenbrand (1):
      mm/memory_hotplug: shrink zones when offlining memory

David Howells (3):
      afs: Fix SELinux setting security label on /afs
      afs: Fix mountpoint parsing
      afs: Fix creation calls in the dynamic root to fail with EOPNOTSUPP

Deepa Dinamani (1):
      fs: cifs: Fix atime update check vs mtime

EJ Hsu (1):
      usb: gadget: fix wrong endpoint desc

Eric Dumazet (4):
      tcp: fix data-race in tcp_recvmsg()
      net/sched: annotate lockless accesses to qdisc->empty
      net: add annotations on hh->hh_len lockless accesses
      net: annotate lockless accesses to sk->sk_pacing_shift

Eric Yang (1):
      drm/amd/display: update dispclk and dppclk vco frequency

Filipe Manana (1):
      Btrfs: fix infinite loop during nocow writeback due to race

Florian Fainelli (4):
      ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()
      ata: ahci_brcm: Fix AHCI resources management
      ata: ahci_brcm: Add missing clock management during recovery
      ata: ahci_brcm: BCM7425 AHCI requires AHCI_HFLAG_DELAY_ENGINE

Frank Rowand (1):
      of: overlay: add_changeset_property() memory leak

Gang He (1):
      ocfs2: fix the crash due to call ocfs2_get_dlm_debug once less

Geert Uytterhoeven (3):
      iio: adc: max9611: Fix too short conversion time delay
      dt-bindings: clock: renesas: rcar-usb2-clock-sel: Fix typo in example
      phy: renesas: rcar-gen3-usb2: Use platform_get_irq_optional() for opt=
ional irq

Greg Kroah-Hartman (1):
      Linux 5.4.9

Guchun Chen (1):
      drm/amdgpu: add check before enabling/disabling broadcast mode

Guoqing Jiang (1):
      raid5: need to set STRIPE_HANDLE for batch head

Hans Verkuil (4):
      media: pulse8-cec: fix lost cec_transmit_attempt_done() call
      media: cec: CEC 2.0-only bcast messages were ignored
      media: cec: avoid decrementing transmit_queue_sz if it is 0
      media: cec: check 'transmit_in_progress', not 'transmitting'

Hans de Goede (2):
      drm/nouveau: Move the declaration of struct nouveau_conn_atom up a bit
      drm/nouveau: Fix drm-core using atomic code-paths on pre-nv50 hardware

Heiko Carstens (1):
      s390/smp: fix physical to logical CPU map for SMT

Hui Wang (1):
      ALSA: usb-audio: set the interface format after resume on Dell WD19

Ilya Dryomov (1):
      mm/oom: fix pgtables units mismatch in Killed process message

Ilya Leoshkevich (1):
      mm/sparse.c: mark populate_section_memmap as __meminit

James Smart (3):
      nvme_fc: add module to ops template to allow module references
      nvme-fc: fix double-free scenarios on hw queues
      scsi: lpfc: Fix rpi release when deleting vport

Jaroslav Kysela (1):
      ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen

Jason Yan (1):
      scsi: libsas: stop discovering if oob mode is disconnected

Jeffrey Hugo (1):
      arm64: dts: qcom: msm8998-clamshell: Remove retention idle state

Jens Axboe (2):
      net: make socket read/write_iter() honor IOCB_NOWAIT
      io_uring: use current task creds instead of allocating a new one

Johan Hovold (1):
      ALSA: usb-audio: fix set_format altsetting sanity check

Johannes Weiner (1):
      mm: drop mmap_sem before calling balance_dirty_pages() in write fault

John Johansen (1):
      apparmor: fix aa_xattrs_match() may sleep while holding a RCU lock

Juergen Gross (1):
      xen/balloon: fix ballooned page accounting without hotplug enabled

Julien Grall (1):
      lib/ubsan: don't serialize UBSAN report

Kai-Heng Feng (3):
      PCI: Add a helper to check Power Resource Requirements _PR3 existence
      ALSA: hda: Allow HDA to be runtime suspended when dGPU is not bound t=
o a driver
      HID: i2c-hid: Reset ALPS touchpads on resume

Kailang Yang (2):
      ALSA: hda/realtek - Add Bass Speaker and fixed dac for bass speaker
      ALSA: hda/realtek - Add headset Mic no shutup for ALC283

Kay Friedrich (1):
      staging/wlan-ng: add CRC32 dependency in Kconfig

Kees Cook (1):
      pstore/ram: Fix error-path memory leak in persistent_ram_new() callers

Keita Suzuki (1):
      tracing: Avoid memory leak in process_system_preds()

Keith Busch (2):
      nvme/pci: Fix write and poll queue types
      nvme/pci: Fix read queue count

Kirill A. Shutemov (1):
      shmem: pin the file in shmem_fault() if mmap_sem is dropped

Konstantin Khorenko (1):
      kernel/module.c: wakeup processes in module_wq on module unload

Kunihiko Hayashi (1):
      spi: uniphier: Fix FIFO threshold

Leo (Hanghong) Ma (1):
      drm/amd/display: Change the delay time before enabling FEC

Leo Yan (1):
      tty: serial: msm_serial: Fix lockup for sysrq and oops

Leonard Crestez (4):
      PM / devfreq: Fix devfreq_notifier_call returning errno
      PM / devfreq: Set scaling_max_freq to max on OPP notifier error
      PM / devfreq: Don't fail devfreq_dev_release if not in list
      PM / devfreq: Check NULL governor in available_governors_show

Lu Baolu (1):
      iommu/vt-d: Remove incorrect PSI capability check

Lukas Wunner (1):
      dmaengine: Fix access to uninitialized dma_slave_caps

Maor Gottlieb (1):
      IB/mlx5: Fix steering rule of drop and count

Marc Dionne (1):
      afs: Fix afs_find_server lookups for ipv4 peers

Marco Oliverio (1):
      netfilter: nf_queue: enqueue skbs with NULL dst

Mark Zhang (1):
      RDMA/counter: Prevent auto-binding a QP which are not tracked with res

Masahiro Yamada (1):
      gen_initramfs_list.sh: fix 'bad variable name' error

Masashi Honma (2):
      ath9k_htc: Modify byte order for an error message
      ath9k_htc: Discard undersized packets

Mathieu Desnoyers (1):
      rseq/selftests: Fix: Namespace gettid() for compatibility with glibc =
2.30

Max Filippov (1):
      gpio: xtensa: fix driver build

Michael Ellerman (1):
      powerpc/mm: Mark get_slice_psize() & slice_addr_is_low() as notrace

Michael Haener (1):
      platform/x86: pmc_atom: Add Siemens CONNECT X300 to critclk_systems D=
MI table

Ming Lei (1):
      block: add bio_truncate to fix guard_bio_eod

Navid Emamdoost (3):
      mm/gup: fix memory leak in __gup_benchmark_ioctl
      Bluetooth: Fix memory leak in hci_connect_le_scan
      media: usb: fix memory leak in af9005_identify_state

Nikola Cornij (2):
      drm/amd/display: Map DSC resources 1-to-1 if numbers of OPPs and DSCs=
 are equal
      drm/amd/display: Reset steer fifo before unblanking the stream

Oliver Neukum (1):
      Bluetooth: btusb: fix PM leak in error case of setup

Omar Sandoval (2):
      xfs: don't check for AG deadlock for realtime files in bunmapi
      btrfs: get rid of unique workqueue helper functions

Parav Pandit (1):
      IB/mlx4: Follow mirror sequence of device add during device removal

Paul Burton (2):
      MIPS: BPF: Disable MIPS32 eBPF JIT
      MIPS: Avoid VDSO ABI breakage due to global register variable

Paul Cercueil (1):
      dmaengine: dma-jz4780: Also break descriptor chains on JZ4725B

Paul Durrant (1):
      xen-blkback: prevent premature module unload

Paulo Alcantara (SUSE) (2):
      cifs: Fix potential softlockups while refreshing DFS cache
      cifs: Fix lookup of root ses in DFS referral cache

Pavel Tikhomirov (1):
      sunrpc: fix crash when cache_head become valid before update

Peter Ujfalusi (1):
      dmaengine: virt-dma: Fix access after free in vchan_complete()

Phil Sutter (1):
      netfilter: nft_tproxy: Fix port selector on Big Endian

Pierre-Eric Pelloux-Prayer (1):
      drm/amdgpu: add cache flush workaround to gfx8 emit_fence

Prateek Sood (1):
      tracing: Fix lock inversion in trace_event_enable_tgid_record()

Quinn Tran (1):
      scsi: qla2xxx: Use explicit LOGO in target mode

Roman Bolshakov (7):
      scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
      scsi: qla2xxx: Don't call qlt_async_event twice
      scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
      scsi: qla2xxx: Configure local loop for N2N target
      scsi: qla2xxx: Send Notify ACK after N2N PLOGI
      scsi: qla2xxx: Don't defer relogin unconditonally
      scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI

Russell King (1):
      gpiolib: fix up emulated open drain outputs

Sargun Dhillon (4):
      selftests/seccomp: Zero out seccomp_notif
      seccomp: Check that seccomp_notif is zeroed out by the user
      samples/seccomp: Zero out members based on seccomp_notif_sizes
      selftests/seccomp: Catch garbage on SECCOMP_IOCTL_NOTIF_RECV

Sascha Hauer (1):
      libata: Fix retrieving of active qcs

Scott Mayhew (1):
      nfsd4: fix up replay_matches_cache()

SeongJae Park (1):
      xen/blkback: Avoid unmapping unmapped grant pages

Shakeel Butt (1):
      memcg: account security cred as well to kmemcg

Stefan Mavrodiev (1):
      drm/sun4i: hdmi: Remove duplicate cleanup calls

Stephan Gerhold (2):
      drm/mcde: dsi: Fix invalid pointer dereference if panel cannot be fou=
nd
      regulator: ab8500: Remove AB8505 USB regulator

Steve Wise (1):
      rxe: correctly calculate iCRC for unaligned payloads

Steven Rostedt (VMware) (1):
      tracing: Have the histogram compare functions convert to u64 first

Sven Schnelle (2):
      tracing: Fix endianness bug in histogram trigger
      samples/trace_printk: Wait for IRQ work to finish

Taehee Yoo (3):
      hsr: avoid debugfs warning message when module is remove
      hsr: fix error handling routine in hsr_dev_finalize()
      hsr: fix a race condition in node list insertion and deletion

Takashi Iwai (6):
      PCI: Fix missing inline for pci_pr3_present()
      ALSA: hda - Downgrade error message for single-cmd fallback
      ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code
      ALSA: hda - Apply sync-write workaround to old Intel platforms, too
      ALSA: pcm: Yet another missing check of non-cached buffer type
      ALSA: firewire-motu: Correct a typo in the clock proc string

Thomas Richter (2):
      s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits
      s390/cpum_sf: Avoid SBD overflow condition in irq handler

Vladimir Oltean (1):
      spi: spi-fsl-dspi: Fix 16-bit word order in 32-bit XSPI mode

Waiman Long (1):
      mm/hugetlb: defer freeing of huge pages if in non-task context

Wen Yang (2):
      ftrace: Avoid potential division by zero in function profiler
      firmware: arm_scmi: Avoid double free in error flow

Yang Shi (1):
      mm: move_pages: return valid node id in status if the page is already=
 on the target node

YueHaibing (2):
      iio: st_accel: Fix unused variable warning
      watchdog: tqmx86_wdt: Fix build error

Yunfeng Ye (1):
      ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX to 0x100

Zhihao Cheng (1):
      ubifs: ubifs_tnc_start_commit: Fix OOB in layout_in_gaps

Zhiqiang Liu (1):
      md: raid1: check rdev before reference in raid1_sync_request func

Zong Li (2):
      clocksource: riscv: add notrace to riscv_sched_clock
      riscv: ftrace: correct the condition logic in function graph tracer

chenqiwu (1):
      exit: panic before exit_mm() on global init exit


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4XjHgACgkQONu9yGCS
aT5KaA/+IAUQS6NgbWoqdQksQAl88H+HJgi+UH4UvFTKjjnDYN7V+tmO9mx9tfKo
GhMo8AfxxbnG5+mstnfP4f/UeMP7Vvw2HHLJOU8nZYyyw2vwxto+4qPYFYy8YUUH
AfNkJRcf6p9jZ3wxrTQj9VPt/vg99sggzsyeYoACniVUk6Z16U0jFQtZWqL4xbJM
CDKnHPELyV7LBPcIsCW48du6PwSqjax47rrs6l+/XBZxzat7P0UEcGhy3WoWV27E
4VcuxW5J1hjJcOKdEunD/Q0KzmOzCbSUglNFh7PJ7Ble/IZXofRrWLRTsgzkPENP
X4e0106Pen5O+V7D2+YO7XCNQZWrofRfsEGuJPlTaCY3fpCjTysBC8kXXRBlBb2X
9iW1tdxXED1WWdmNHvklwDcUxJ2Epa9nCeoBNC8PTQKUqNA/I5i0Ae54Yqwy+FfJ
LkCaf+1eOM/EtRgFLkY7qt0cWhVQa4HV5aoFT327NT1WGbebMz4kBRoQVk7+B2o0
uUVnRBWh+XN+H1xocUsAZtp08I5tU8O0JFp+Ly01QWGaQNVpt8ZwWF+MUa00oVS9
V/TZzgibB2QGhWbbqlWHeq0lGAZRnylIfTzfrjpvx/EwZMddKfZ97YmuD9O11KNo
tvY3htLAgMCjfQ+M32is+BMOC/qvNKqkq5Es1SC0RhQt2iouvQ0=
=WMct
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
