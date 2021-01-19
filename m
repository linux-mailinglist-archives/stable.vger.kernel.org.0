Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A7E2FC04C
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 20:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390961AbhASTq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 14:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730018AbhASTog (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 14:44:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B15DC23105;
        Tue, 19 Jan 2021 19:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611085434;
        bh=AtFcs/6gVrk8EkxarG8fgCGuS20TrrZB3U75aBz8yoA=;
        h=From:To:Cc:Subject:Date:From;
        b=W/wxeAGstza440/h7A40vPGNq8hFrXdRFBQzzO/ooEcgvN7TMiL/I8m2K/hcdIhbq
         CzK073j/ttDlnRhWPmVvW2fyPFHIs7J9mi8PA8Sa5b/7r//ErJ9iKVW6CgmN+PN8uC
         W27FOZl/z+1yi2OnhF8O5hFvNHk40mkeOIG/bn7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.91
Date:   Tue, 19 Jan 2021 20:43:47 +0100
Message-Id: <161108542712815@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.91 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    4 -
 arch/arc/Makefile                                    |   20 ++++--
 arch/arc/boot/Makefile                               |   11 ---
 arch/arc/include/asm/page.h                          |    1 
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi               |    4 +
 arch/mips/boot/compressed/decompress.c               |    3 
 arch/mips/kernel/relocate.c                          |   10 ++-
 arch/mips/lib/uncached.c                             |    4 -
 arch/mips/mm/c-r4k.c                                 |    2 
 arch/mips/mm/sc-mips.c                               |    4 -
 arch/x86/hyperv/mmu.c                                |   12 ++-
 block/bfq-iosched.c                                  |    8 +-
 drivers/acpi/internal.h                              |    2 
 drivers/acpi/scan.c                                  |   15 ++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c           |    4 -
 drivers/gpu/drm/i915/display/intel_panel.c           |    9 +-
 drivers/gpu/drm/i915/display/vlv_dsi.c               |   16 ++++-
 drivers/gpu/drm/msm/msm_drv.c                        |    8 +-
 drivers/hwmon/pwm-fan.c                              |   12 +++
 drivers/infiniband/core/restrack.c                   |    1 
 drivers/infiniband/hw/mlx5/main.c                    |    4 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c          |    2 
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c         |    3 
 drivers/iommu/intel-svm.c                            |   22 ++++++-
 drivers/isdn/mISDN/Kconfig                           |    1 
 drivers/md/dm-bufio.c                                |    6 +
 drivers/md/dm-integrity.c                            |   58 ++++++++++++++++---
 drivers/md/dm-raid.c                                 |    6 -
 drivers/md/dm-snap.c                                 |   24 +++++++
 drivers/md/dm.c                                      |    2 
 drivers/misc/habanalabs/device.c                     |    2 
 drivers/misc/habanalabs/habanalabs_drv.c             |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c        |    8 +-
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c |    1 
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c     |    1 
 drivers/net/ethernet/freescale/ucc_geth.h            |    9 ++
 drivers/net/usb/cdc_ether.c                          |    7 ++
 drivers/net/usb/r8152.c                              |    1 
 drivers/nvme/host/pci.c                              |    3 
 drivers/nvme/host/tcp.c                              |    2 
 drivers/nvme/target/rdma.c                           |   10 +++
 drivers/regulator/bd718x7-regulator.c                |   57 ++++++++++++++++++
 drivers/usb/typec/altmodes/Kconfig                   |    2 
 fs/btrfs/extent_io.c                                 |    4 -
 fs/btrfs/qgroup.c                                    |   13 +++-
 fs/btrfs/super.c                                     |    8 ++
 fs/btrfs/tree-checker.c                              |    7 ++
 fs/cifs/smb2pdu.c                                    |   21 +-----
 fs/cifs/smb2proto.h                                  |    2 
 fs/ext4/file.c                                       |    2 
 fs/ext4/ioctl.c                                      |    3 
 fs/ext4/namei.c                                      |   16 ++---
 fs/nfs/internal.h                                    |   12 ++-
 fs/nfs/nfs4proc.c                                    |   28 +++------
 fs/nfs/pnfs.c                                        |   58 ++++++++++---------
 fs/nfs/pnfs.h                                        |    8 --
 include/linux/acpi.h                                 |    7 ++
 include/linux/dm-bufio.h                             |    1 
 kernel/trace/Kconfig                                 |    2 
 kernel/trace/trace_kprobe.c                          |    2 
 lib/raid6/Makefile                                   |    2 
 mm/hugetlb.c                                         |    2 
 mm/slub.c                                            |    2 
 net/netfilter/ipset/ip_set_hash_gen.h                |   22 ++++---
 net/netfilter/nf_conntrack_standalone.c              |    3 
 net/netfilter/nf_nat_core.c                          |    1 
 net/netfilter/nft_compat.c                           |   37 ++++--------
 net/sunrpc/addr.c                                    |    2 
 security/lsm_audit.c                                 |    7 +-
 sound/firewire/fireface/ff-transaction.c             |    2 
 sound/firewire/tascam/tascam-transaction.c           |    2 
 sound/soc/intel/skylake/cnl-sst.c                    |    1 
 sound/soc/meson/axg-tdm-interface.c                  |   14 ++++
 sound/soc/meson/axg-tdmin.c                          |   13 ----
 sound/soc/soc-dapm.c                                 |    1 
 tools/perf/util/machine.c                            |    4 -
 tools/perf/util/session.c                            |    2 
 tools/testing/selftests/net/udpgro.sh                |   34 +++++++++++
 78 files changed, 512 insertions(+), 215 deletions(-)

Adrian Hunter (1):
      perf intel-pt: Fix 'CPU too large' error

Akilesh Kailash (1):
      dm snapshot: flush merged data before committing metadata

Al Viro (1):
      dump_common_audit_data(): fix racy accesses to ->d_name

Alexander Lobakin (1):
      MIPS: relocatable: fix possible boot hangup with KASLR enabled

Anders Roxell (2):
      mips: fix Section mismatch in reference
      mips: lib: uncached: fix non-standard usage of variable 'sp'

Arnd Bergmann (2):
      misdn: dsp: select CONFIG_BITREVERSE
      ARM: picoxcell: fix missing interrupt-parent properties

Craig Tatlor (1):
      drm/msm: Call msm_init_vram before binding the gpu

Dan Carpenter (1):
      ASoC: Intel: fix error code cnl_set_dsp_D0()

Dave Wysochanski (1):
      NFS4: Fix use-after-free in trace_event_raw_event_nfs4_set_lock

Dennis Li (1):
      drm/amdgpu: fix a GPU hang issue when remove device

Dexuan Cui (1):
      ACPI: scan: Harden acpi_device_add() against device ID overflows

Dinghao Liu (3):
      habanalabs: Fix memleak in hl_device_reset
      RDMA/usnic: Fix memleak in find_free_vf_and_create_qp_grp
      netfilter: nf_nat: Fix memleak in nf_nat_init

Filipe Manana (1):
      btrfs: fix transaction leak and crash after RO remount caused by qgroup rescan

Florian Westphal (1):
      netfilter: nft_compat: remove flush counter optimization

Geert Uytterhoeven (2):
      ALSA: fireface: Fix integer overflow in transmit_midi_msg()
      ALSA: firewire-tascam: Fix integer overflow in midi_port_work()

Gopal Tiwari (1):
      nvme-pci: mark Samsung PM1725a as IGNORE_DEV_SUBNQN

Greg Kroah-Hartman (1):
      Linux 5.4.91

Guido Günther (1):
      regulator: bd718x7: Add enable times

Hans de Goede (1):
      drm/i915/dsi: Use unconditional msleep for the panel_on_delay when there is no reset-deassert MIPI-sequence

Israel Rukshin (1):
      nvmet-rdma: Fix list_del corruption on queue establishment failure

Jan Kara (2):
      bfq: Fix computation of shallow depth
      ext4: fix superblock checksum failure when setting password salt

Jani Nikula (1):
      drm/i915/backlight: fix CPU mode backlight takeover on LPT

Jann Horn (1):
      mm, slub: consider rest of partial list if acquire_slab() fails

Jerome Brunet (2):
      ASoC: meson: axg-tdm-interface: fix loopback
      ASoC: meson: axg-tdmin: fix axg skew offset

Jesper Dangaard Brouer (1):
      netfilter: conntrack: fix reading nf_conntrack_buckets

John Millikin (1):
      lib/raid6: Let $(UNROLL) rules work with macOS userland

Leon Romanovsky (1):
      RDMA/restrack: Don't treat as an error allocation ID wrapping

Leon Schuermann (1):
      r8152: Add Lenovo Powered USB-C Travel Hub

Lu Baolu (1):
      iommu/vt-d: Fix unaligned addresses for intel_flush_svm_range_dev()

Mark Bloch (1):
      RDMA/mlx5: Fix wrong free of blue flame register on error

Masahiro Yamada (4):
      ARC: build: remove non-existing bootpImage from KBUILD_IMAGE
      ARC: build: add uImage.lzma to the top-level target
      ARC: build: add boot_targets to PHONY
      ARC: build: move symlink creation to arch/arc/Makefile to avoid race

Masami Hiramatsu (1):
      tracing/kprobes: Do the notrace functions check without kprobes on ftrace

Miaohe Lin (1):
      mm/hugetlb: fix potential missing huge page size info

Michael Chan (1):
      bnxt_en: Improve stats context resource accounting with RDMA driver loaded.

Michael Ellerman (1):
      net: ethernet: fs_enet: Add missing MODULE_LICENSE

Mike Snitzer (2):
      dm raid: fix discard limits for raid1
      dm: eliminate potential source of excessive kernel log noise

Mikulas Patocka (2):
      dm integrity: fix the maximum number of arguments
      dm integrity: fix flush with external metadata device

Oded Gabbay (1):
      habanalabs: register to pci shutdown callback

Olaf Hering (1):
      kbuild: enforce -Werror=return-type

Parav Pandit (1):
      IB/mlx5: Fix error unwinding when set_has_smi_cap fails

Paul Cercueil (1):
      MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB

Paulo Alcantara (1):
      cifs: fix interrupted close commands

Peter Robinson (1):
      usb: typec: Fix copy paste error for NVIDIA alt-mode description

Po-Hsu Lin (1):
      selftests: fix the return value for UDP GRO test

Randy Dunlap (1):
      arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC

Rasmus Villemoes (1):
      ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram

Sagi Grimberg (1):
      nvme-tcp: fix possible data corruption with bio merges

Shawn Guo (1):
      ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI

Steve French (1):
      smb3: remove unused flag passed into close functions

Su Yue (2):
      btrfs: prevent NULL pointer dereference in extent_io_tree_panic
      btrfs: tree-checker: check if chunk item end overflows

Theodore Ts'o (1):
      ext4: don't leak old mountpoint samples

Thomas Hebb (1):
      ASoC: dapm: remove widget from dirty list on free

Tom Rix (1):
      RDMA/ocrdma: Fix use after free in ocrdma_dealloc_ucontext_pd()

Trond Myklebust (5):
      pNFS: We want return-on-close to complete when evicting the inode
      pNFS: Mark layout for return if return-on-close was not sent
      pNFS: Stricter ordering of layoutget and layoutreturn
      NFS/pNFS: Fix a leak of the layout 'plh_outstanding' counter
      NFS: nfs_igrab_and_active must first reference the superblock

Uwe Kleine-König (1):
      hwmon: (pwm-fan) Ensure that calculation doesn't discard big period values

Vasily Averin (1):
      netfilter: ipset: fixes possible oops in mtype_resize

Wei Liu (1):
      x86/hyperv: check cpu mask after interrupt has been disabled

j.nixdorf@avm.de (1):
      net: sunrpc: interpret the return value of kstrtou32 correctly

yangerkun (1):
      ext4: fix bug for rename with RENAME_WHITEOUT

