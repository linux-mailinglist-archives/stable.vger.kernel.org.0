Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C102FC049
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 20:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390462AbhASTqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 14:46:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729648AbhASTpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 14:45:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3FEA23109;
        Tue, 19 Jan 2021 19:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611085441;
        bh=zE6LlzT0Ug8j7sqIH0N3c0lU2AT+4hXsKeacYAYAy0o=;
        h=From:To:Cc:Subject:Date:From;
        b=MjWM8Pid0DDI/KkDF4Urzv3Fqf+GUKD3Vj4u5/97qw9TbfRJIagC90GjXtA9O2VON
         rArhDHNfjQVLb1SGIfuMlrGWjgQXqcLSv8vxKAwZWk258RnaF/aX345QlN3/bp3tqm
         azI9Mpa4wsU7vGhieXo31wOviHnTY57DsZoeEIKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.9
Date:   Tue, 19 Jan 2021 20:43:54 +0100
Message-Id: <1611085434254201@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.9 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/display/bridge/sii902x.txt     |    4 
 Documentation/sound/alsa-configuration.rst                       |    2 
 Makefile                                                         |    2 
 arch/arc/Makefile                                                |   20 -
 arch/arc/boot/Makefile                                           |   11 
 arch/arc/include/asm/page.h                                      |    1 
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi                           |    4 
 arch/arm/boot/dts/ste-ux500-samsung-golden.dts                   |    1 
 arch/arm/mach-omap2/pmic-cpcap.c                                 |    2 
 arch/mips/boot/compressed/decompress.c                           |    3 
 arch/mips/kernel/binfmt_elfn32.c                                 |    7 
 arch/mips/kernel/binfmt_elfo32.c                                 |    7 
 arch/mips/kernel/relocate.c                                      |   10 
 arch/mips/lib/uncached.c                                         |    4 
 arch/mips/mm/c-r4k.c                                             |    2 
 arch/mips/mm/sc-mips.c                                           |    4 
 arch/riscv/include/asm/pgtable.h                                 |    1 
 arch/riscv/include/asm/vdso.h                                    |    2 
 arch/riscv/kernel/entry.S                                        |   15 
 arch/riscv/kernel/vdso.c                                         |    2 
 arch/riscv/mm/kasan_init.c                                       |    4 
 arch/x86/hyperv/mmu.c                                            |   12 
 arch/x86/kernel/sev-es-shared.c                                  |    4 
 block/bfq-iosched.c                                              |    8 
 block/blk-mq-debugfs.c                                           |    1 
 drivers/acpi/internal.h                                          |    2 
 drivers/acpi/scan.c                                              |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                       |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                          |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                          |   18 -
 drivers/gpu/drm/amd/amdgpu/soc15.c                               |    3 
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                    |    7 
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c |   11 
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c                  |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c                   |    1 
 drivers/gpu/drm/bridge/sii902x.c                                 |  100 +++--
 drivers/gpu/drm/i915/Makefile                                    |    1 
 drivers/gpu/drm/i915/display/icl_dsi.c                           |    4 
 drivers/gpu/drm/i915/display/intel_panel.c                       |    9 
 drivers/gpu/drm/i915/display/vlv_dsi.c                           |   16 
 drivers/gpu/drm/i915/gt/gen7_renderclear.c                       |  157 +++++----
 drivers/gpu/drm/i915/gt/intel_ring_submission.c                  |    6 
 drivers/gpu/drm/i915/i915_mitigations.c                          |  146 ++++++++
 drivers/gpu/drm/i915/i915_mitigations.h                          |   13 
 drivers/gpu/drm/msm/msm_drv.c                                    |    8 
 drivers/hwmon/pwm-fan.c                                          |   12 
 drivers/infiniband/core/restrack.c                               |    1 
 drivers/infiniband/hw/mlx5/main.c                                |    4 
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c                      |    2 
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c                     |    3 
 drivers/iommu/intel/iommu.c                                      |   16 
 drivers/iommu/intel/svm.c                                        |   36 +-
 drivers/isdn/mISDN/Kconfig                                       |    1 
 drivers/md/Kconfig                                               |    1 
 drivers/md/dm-bufio.c                                            |    6 
 drivers/md/dm-crypt.c                                            |  170 ++++++++--
 drivers/md/dm-integrity.c                                        |   62 ++-
 drivers/md/dm-raid.c                                             |    6 
 drivers/md/dm-snap.c                                             |   24 +
 drivers/md/dm.c                                                  |    2 
 drivers/misc/habanalabs/common/device.c                          |    2 
 drivers/misc/habanalabs/common/habanalabs_drv.c                  |    1 
 drivers/misc/habanalabs/common/pci.c                             |   28 +
 drivers/misc/habanalabs/gaudi/gaudi.c                            |   14 
 drivers/misc/habanalabs/gaudi/gaudi_coresight.c                  |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c                    |    8 
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c             |    1 
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c                 |    1 
 drivers/net/ethernet/freescale/ucc_geth.h                        |    9 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c               |   77 ++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c    |   27 -
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c    |    2 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c   |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c                |    6 
 drivers/net/usb/cdc_ether.c                                      |    7 
 drivers/net/usb/r8152.c                                          |    1 
 drivers/net/wireless/ath/ath11k/dp_rx.c                          |   10 
 drivers/net/wireless/ath/ath11k/qmi.c                            |   24 +
 drivers/net/wireless/ath/ath11k/qmi.h                            |    1 
 drivers/nvme/host/core.c                                         |   11 
 drivers/nvme/host/fc.c                                           |   15 
 drivers/nvme/host/pci.c                                          |   10 
 drivers/nvme/host/tcp.c                                          |    4 
 drivers/nvme/target/rdma.c                                       |   26 +
 drivers/regulator/bd718x7-regulator.c                            |   57 +++
 drivers/scsi/ufs/ufshcd.c                                        |    3 
 drivers/spi/spi-altera.c                                         |   26 -
 drivers/spi/spi.c                                                |    6 
 drivers/staging/hikey9xx/hisi-spmi-controller.c                  |   21 -
 drivers/usb/typec/altmodes/Kconfig                               |    2 
 drivers/xen/privcmd.c                                            |   25 +
 fs/btrfs/discard.c                                               |   60 +--
 fs/btrfs/extent_io.c                                             |    4 
 fs/btrfs/qgroup.c                                                |   13 
 fs/btrfs/relocation.c                                            |    7 
 fs/btrfs/super.c                                                 |    8 
 fs/btrfs/tree-checker.c                                          |    7 
 fs/cifs/dfs_cache.c                                              |    3 
 fs/cifs/smb2pdu.c                                                |    2 
 fs/ext4/fast_commit.c                                            |   25 -
 fs/ext4/file.c                                                   |    2 
 fs/ext4/ioctl.c                                                  |    3 
 fs/ext4/namei.c                                                  |   17 -
 fs/io_uring.c                                                    |   29 +
 fs/namespace.c                                                   |    7 
 fs/nfs/delegation.c                                              |   12 
 fs/nfs/internal.h                                                |   38 +-
 fs/nfs/nfs4proc.c                                                |   28 -
 fs/nfs/nfs4super.c                                               |    4 
 fs/nfs/pnfs.c                                                    |   58 +--
 fs/nfs/pnfs.h                                                    |    8 
 fs/nfs/pnfs_nfs.c                                                |   22 -
 fs/proc/task_mmu.c                                               |   53 +--
 fs/select.c                                                      |   14 
 include/linux/acpi.h                                             |    7 
 include/linux/compiler-gcc.h                                     |    6 
 include/linux/dm-bufio.h                                         |    1 
 include/linux/rcupdate.h                                         |    6 
 init/main.c                                                      |    1 
 kernel/bpf/task_iter.c                                           |   57 +--
 kernel/rcu/tasks.h                                               |   25 +
 kernel/trace/Kconfig                                             |    2 
 kernel/trace/trace_kprobe.c                                      |    2 
 lib/raid6/Makefile                                               |    2 
 mm/hugetlb.c                                                     |    2 
 mm/process_vm_access.c                                           |    1 
 mm/slub.c                                                        |    2 
 mm/vmalloc.c                                                     |    4 
 mm/vmscan.c                                                      |    2 
 net/netfilter/ipset/ip_set_hash_gen.h                            |   22 -
 net/netfilter/nf_conntrack_standalone.c                          |    3 
 net/netfilter/nf_nat_core.c                                      |    1 
 net/sunrpc/addr.c                                                |    2 
 net/wireless/Kconfig                                             |    1 
 scripts/kconfig/Makefile                                         |   10 
 security/lsm_audit.c                                             |    7 
 sound/firewire/fireface/ff-transaction.c                         |    2 
 sound/firewire/tascam/tascam-transaction.c                       |    2 
 sound/pci/hda/patch_realtek.c                                    |    4 
 sound/soc/amd/renoir/rn-pci-acp3x.c                              |    7 
 sound/soc/intel/skylake/cnl-sst.c                                |    1 
 sound/soc/meson/axg-tdm-interface.c                              |   14 
 sound/soc/meson/axg-tdmin.c                                      |   13 
 sound/soc/soc-dapm.c                                             |    1 
 tools/bootconfig/scripts/bconf2ftrace.sh                         |    1 
 tools/bootconfig/scripts/ftrace2bconf.sh                         |    4 
 tools/perf/util/machine.c                                        |    4 
 tools/perf/util/session.c                                        |    2 
 tools/testing/selftests/net/udpgro.sh                            |   34 ++
 tools/testing/selftests/netfilter/nft_conntrack_helper.sh        |   12 
 151 files changed, 1519 insertions(+), 609 deletions(-)

Adrian Hunter (1):
      perf intel-pt: Fix 'CPU too large' error

Akilesh Kailash (1):
      dm snapshot: flush merged data before committing metadata

Al Viro (3):
      MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps
      dump_common_audit_data(): fix racy accesses to ->d_name
      umount(2): move the flag validity checks first

Alaa Hleihel (1):
      net/mlx5: E-Switch, fix changing vf VLANID

Alexander Lobakin (1):
      MIPS: relocatable: fix possible boot hangup with KASLR enabled

Alexandre Demers (1):
      drm/amdgpu: fix DRM_INFO flood if display core is not supported (bug 210921)

Alexandru Gagniuc (3):
      drm/bridge: sii902x: Refactor init code into separate function
      dt-bindings: display: sii902x: Add supply bindings
      drm/bridge: sii902x: Enable I/O and core VCC supplies if present

Anders Roxell (2):
      mips: fix Section mismatch in reference
      mips: lib: uncached: fix non-standard usage of variable 'sp'

Andreas Schwab (1):
      riscv: return -ENOSYS for syscall -1

Andrew Morton (1):
      mm/process_vm_access.c: include compat.h

Arnd Bergmann (4):
      misdn: dsp: select CONFIG_BITREVERSE
      ARM: picoxcell: fix missing interrupt-parent properties
      cfg80211: select CONFIG_CRC32
      dm zoned: select CONFIG_CRC32

Atish Patra (1):
      riscv: Trace irq on only interrupt is enabled

Carl Huang (2):
      ath11k: fix crash caused by NULL rx_channel
      ath11k: qmi: try to allocate a big block of DMA memory first

Carl Philipp Klemm (1):
      ARM: omap2: pmic-cpcap: fix maximum voltage to be consistent with defaults on xt875

Chen Yi (1):
      selftests: netfilter: Pass family parameter "-f" to conntrack tool

Chris Wilson (3):
      drm/i915: Allow the sysadmin to override security mitigations
      drm/i915/gt: Limit VFE threads based on GT
      drm/i915/gt: Restore clear-residual mitigations for Ivybridge, Baytrail

Christophe JAILLET (1):
      staging: spmi: hisi-spmi-controller: Fix some error handling paths

Craig Tatlor (1):
      drm/msm: Call msm_init_vram before binding the gpu

Daejun Park (1):
      ext4: fix wrong list_splice in ext4_fc_cleanup

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

Geert Uytterhoeven (2):
      ALSA: fireface: Fix integer overflow in transmit_midi_msg()
      ALSA: firewire-tascam: Fix integer overflow in midi_port_work()

Gopal Tiwari (1):
      nvme-pci: mark Samsung PM1725a as IGNORE_DEV_SUBNQN

Greg Kroah-Hartman (1):
      Linux 5.10.9

Guido Günther (1):
      regulator: bd718x7: Add enable times

Guo Ren (1):
      riscv: Fixup CONFIG_GENERIC_TIME_VSYSCALL

Hans de Goede (1):
      drm/i915/dsi: Use unconditional msleep for the panel_on_delay when there is no reset-deassert MIPI-sequence

Ignat Korchagin (4):
      dm crypt: use GFP_ATOMIC when allocating crypto requests from softirq
      dm crypt: do not wait for backlogged crypto request completion in softirq
      dm crypt: do not call bio_endio() from the dm-crypt tasklet
      dm crypt: defer decryption to a tasklet if interrupts disabled

Imre Deak (1):
      drm/i915/icl: Fix initing the DSI DSC power refcount during HW readout

Israel Rukshin (2):
      nvmet-rdma: Fix list_del corruption on queue establishment failure
      nvmet-rdma: Fix NULL deref when setting pi_enable and traddr INADDR_ANY

James Smart (1):
      nvme-fc: avoid calling _nvme_fc_abort_outstanding_ios from interrupt context

Jan Kara (2):
      bfq: Fix computation of shallow depth
      ext4: fix superblock checksum failure when setting password salt

Jani Nikula (1):
      drm/i915/backlight: fix CPU mode backlight takeover on LPT

Jann Horn (1):
      mm, slub: consider rest of partial list if acquire_slab() fails

Jaroslav Kysela (1):
      ASoC: AMD Renoir - add DMI entry for Lenovo ThinkPad X395

Jeremy Szu (1):
      ALSA: hda/realtek: fix right sounds and mute/micmute LEDs for HP machines

Jerome Brunet (2):
      ASoC: meson: axg-tdm-interface: fix loopback
      ASoC: meson: axg-tdmin: fix axg skew offset

Jesper Dangaard Brouer (1):
      netfilter: conntrack: fix reading nf_conntrack_buckets

Jiawei Gu (1):
      drm/amdgpu: fix potential memory leak during navi12 deinitialization

John Garry (1):
      blk-mq-debugfs: Add decode for BLK_MQ_F_TAG_HCTX_SHARED

John Millikin (1):
      lib/raid6: Let $(UNROLL) rules work with macOS userland

Jonathan Lemon (1):
      bpf: Save correct stopping point in file seq iteration

Jonathan Neuschäfer (1):
      ALSA: doc: Fix reference to mixart.rst

Kefeng Wang (1):
      riscv: Drop a duplicated PAGE_KERNEL_EXEC

Kevin Wang (1):
      drm/amd/display: fix sysfs amdgpu_current_backlight_pwm NULL pointer issue

Lalithambika Krishnakumar (1):
      nvme: avoid possible double fetch in handling CQE

Leon Romanovsky (1):
      RDMA/restrack: Don't treat as an error allocation ID wrapping

Leon Schuermann (1):
      r8152: Add Lenovo Powered USB-C Travel Hub

Linus Torvalds (4):
      poll: fix performance regression due to out-of-line __put_user()
      mm: fix clear_refs_write locking
      mm: don't play games with pinned pages in clear_page_refs
      mm: don't put pinned pages into the swap cache

Linus Walleij (1):
      ARM: dts: ux500/golden: Set display max brightness

Lu Baolu (3):
      iommu/vt-d: Fix lockdep splat in sva bind()/unbind()
      iommu/vt-d: Update domain geometry in iommu_ops.at(de)tach_dev
      iommu/vt-d: Fix unaligned addresses for intel_flush_svm_range_dev()

Mark Bloch (1):
      RDMA/mlx5: Fix wrong free of blue flame register on error

Masahiro Yamada (5):
      ARC: build: remove non-existing bootpImage from KBUILD_IMAGE
      ARC: build: add uImage.lzma to the top-level target
      ARC: build: add boot_targets to PHONY
      ARC: build: move symlink creation to arch/arc/Makefile to avoid race
      kconfig: remove 'kvmconfig' and 'xenconfig' shorthands

Masami Hiramatsu (2):
      tracing/kprobes: Do the notrace functions check without kprobes on ftrace
      tools/bootconfig: Add tracing_on support to helper scripts

Miaohe Lin (2):
      mm/vmalloc.c: fix potential memory leak
      mm/hugetlb: fix potential missing huge page size info

Michael Chan (1):
      bnxt_en: Improve stats context resource accounting with RDMA driver loaded.

Michael Ellerman (1):
      net: ethernet: fs_enet: Add missing MODULE_LICENSE

Mike Snitzer (2):
      dm raid: fix discard limits for raid1
      dm: eliminate potential source of excessive kernel log noise

Mikulas Patocka (2):
      dm integrity: fix flush with external metadata device
      dm integrity: fix the maximum number of arguments

Nick Hu (1):
      riscv: Fix KASAN memory mapping.

Oded Gabbay (3):
      habanalabs: adjust pci controller init to new firmware
      habanalabs/gaudi: retry loading TPC f/w on -EINTR
      habanalabs: register to pci shutdown callback

Oz Shlomo (1):
      net/mlx5e: CT: Use per flow counter when CT flow accounting is enabled

Parav Pandit (1):
      IB/mlx5: Fix error unwinding when set_has_smi_cap fails

Paul Cercueil (1):
      MIPS: boot: Fix unaligned access with CONFIG_MIPS_RAW_APPENDED_DTB

Paulo Alcantara (1):
      cifs: fix interrupted close commands

Pavel Begunkov (5):
      io_uring: don't take files/mm for a dead task
      io_uring: drop mm and files after task_work_run
      btrfs: fix async discard stall
      btrfs: merge critical sections of discard lock in workfn
      io_uring: drop file refs after task cancel

Peter Gonda (1):
      x86/sev-es: Fix SEV-ES OUT/IN immediate opcode vc handling

Peter Robinson (1):
      usb: typec: Fix copy paste error for NVIDIA alt-mode description

Po-Hsu Lin (1):
      selftests: fix the return value for UDP GRO test

Prike Liang (1):
      drm/amdgpu: add green_sardine device id (v2)

Qu Wenruo (1):
      btrfs: reloc: fix wrong file extent type check to avoid false ENOENT

Randy Dunlap (1):
      arch/arc: add copy_user_page() to <asm/page.h> to fix build error on ARC

Rasmus Villemoes (1):
      ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram

Rodrigo Siqueira (1):
      Revert "drm/amd/display: Fixed Intermittent blue screen on OLED panel"

Roger Pau Monne (1):
      xen/privcmd: allow fetching resource sizes

Sagi Grimberg (3):
      nvme: don't intialize hwmon for discovery controllers
      nvme-tcp: fix possible data corruption with bio merges
      nvme-tcp: Fix warning with CONFIG_DEBUG_PREEMPT

Scott Mayhew (1):
      NFS: Adjust fs_context error logging

Shawn Guo (1):
      ACPI: scan: add stub acpi_create_platform_device() for !CONFIG_ACPI

Song Liu (1):
      bpf: Simplify task_file_seq_get_next()

Stanley Chu (1):
      scsi: ufs: Fix possible power drain during system suspend

Su Yue (2):
      btrfs: prevent NULL pointer dereference in extent_io_tree_panic
      btrfs: tree-checker: check if chunk item end overflows

Theodore Ts'o (1):
      ext4: don't leak old mountpoint samples

Thomas Hebb (1):
      ASoC: dapm: remove widget from dirty list on free

Tom Rix (2):
      cifs: check pointer before freeing
      RDMA/ocrdma: Fix use after free in ocrdma_dealloc_ucontext_pd()

Trond Myklebust (8):
      pNFS: We want return-on-close to complete when evicting the inode
      pNFS: Mark layout for return if return-on-close was not sent
      pNFS: Stricter ordering of layoutget and layoutreturn
      NFS/pNFS: Don't call pnfs_free_bucket_lseg() before removing the request
      NFS/pNFS: Don't leak DS commits in pnfs_generic_retry_commit()
      NFS/pNFS: Fix a leak of the layout 'plh_outstanding' counter
      NFS: nfs_delegation_find_inode_server must first reference the superblock
      NFS: nfs_igrab_and_active must first reference the superblock

Uladzislau Rezki (Sony) (1):
      rcu-tasks: Move RCU-tasks initialization to before early_initcall()

Uwe Kleine-König (1):
      hwmon: (pwm-fan) Ensure that calculation doesn't discard big period values

Vasily Averin (1):
      netfilter: ipset: fixes possible oops in mtype_resize

Voon Weifeng (1):
      stmmac: intel: change all EHL/TGL to auto detect phy addr

Wei Liu (1):
      x86/hyperv: check cpu mask after interrupt has been disabled

Will Deacon (1):
      compiler.h: Raise minimum version of GCC to 5.1 for arm64

Xiaojian Du (1):
      drm/amd/pm: fix the failure when change power profile for renoir

Xu Yilun (2):
      spi: altera: fix return value for altera_spi_txrx()
      spi: fix the divide by 0 error when calculating xfer waiting time

Yi Li (1):
      ext4: use IS_ERR instead of IS_ERR_OR_NULL and set inode null when IS_ERR

YueHaibing (1):
      net/mlx5: Fix passing zero to 'PTR_ERR'

j.nixdorf@avm.de (1):
      net: sunrpc: interpret the return value of kstrtou32 correctly

mengwang (1):
      drm/amdgpu: add new device id for Renior

yangerkun (1):
      ext4: fix bug for rename with RENAME_WHITEOUT

