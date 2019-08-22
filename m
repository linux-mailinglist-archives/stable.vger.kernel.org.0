Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD08F99AFF
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388877AbfHVRIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfHVRIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:15 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EBDB233FC;
        Thu, 22 Aug 2019 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493693;
        bh=z63E/P8vAkb0UbP5fw57KiZttklaJT4hAGDCPRmRUcw=;
        h=From:To:Cc:Subject:Date:From;
        b=eTq/5CYKiYbNSPoweY3zHw7Xd3x4QADyaI0/GQyHUNzRm7SQZXQJuVDsKoTUihfj0
         CV3VHWMj6HWiZ03bm+YH5P6njWigRd3HMgMlboF7Qdb7doVr1ZeUB4gbB09QiJ2Lul
         /tlNZPncSYV1hBJ34GfcvfaLUWc10jFQ1YQUlloM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Subject: [PATCH 5.2 000/135] 5.2.10-stable review
Date:   Thu, 22 Aug 2019 13:05:56 -0400
Message-Id: <20190822170811.13303-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 5.2.10 release.
There are 135 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 24 Aug 2019 05:07:10 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.10-rc1.gz
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
and the diffstat can be found below.

--
Thanks,
Sasha

-------------------------

Pseudo-Shortlog of commits:

Alan Stern (1):
  USB: core: Fix races in character device registration and
    deregistraion

Aleix Roca Nonell (1):
  io_uring: fix manual setup of iov_iter for fixed buffers

Anders Roxell (1):
  arm64: KVM: regmap: Fix unexpected switch fall-through

Aneesh Kumar K.V (1):
  powerpc/nvdimm: Pick nearby online node if the device node is not
    online

Arnaldo Carvalho de Melo (1):
  tools perf beauty: Fix usbdevfs_ioctl table generator to handle _IOC()

Arnd Bergmann (1):
  page flags: prioritize kasan bits over last-cpuid

Aya Levin (2):
  net/mlx5e: Fix false negative indication on tx reporter CQE recovery
  net/mlx5e: Remove redundant check in CQE recovery flow of tx reporter

Bob Ham (1):
  USB: serial: option: add the BroadMobi BM818 card

Chen-Yu Tsai (1):
  net: dsa: Check existence of .port_mdb_add callback before calling it

Chris Packham (1):
  tipc: initialise addr_trail_end when setting node addresses

Christian König (1):
  drm/amdgpu: fix error handling in amdgpu_cs_process_fence_dep

Christoph Hellwig (2):
  dma-mapping: check pfn validity in dma_common_{mmap,get_sgtable}
  mm/hmm: always return EBUSY for invalid ranges in
    hmm_range_{fault,snapshot}

Chuhong Yuan (1):
  IB/mlx5: Replace kfree with kvfree

Chunyan Zhang (1):
  clk: sprd: Select REGMAP_MMIO to avoid compile errors

Codrin Ciubotariu (1):
  clk: at91: generated: Truncate divisor to GENERATED_MAX_DIV + 1

Colin Ian King (1):
  drm/exynos: fix missing decrement of retry counter

David Ahern (2):
  netdevsim: Restore per-network namespace accounting for fib entries
  netlink: Fix nlmsg_parse as a wrapper for strict message parsing

Denis Kirjanov (1):
  net: usb: pegasus: fix improper read if get_registers() fail

Dirk Morris (1):
  netfilter: conntrack: Use consistent ct id hash calculation

Don Brace (1):
  scsi: hpsa: correct scsi command status issue after reset

Eric Dumazet (2):
  bpf: fix access to skb_shared_info->gso_segs
  net/packet: fix race in tpacket_snd()

Evan Quan (1):
  drm/amd/powerplay: fix null pointer dereference around dpm state
    relates

Fabio Estevam (1):
  Revert "i2c: imx: improve the error handling in i2c_imx_dma_request()"

Filipe Manana (1):
  Btrfs: fix deadlock between fiemap and transaction commits

Florian Westphal (1):
  netfilter: ebtables: also count base chain policies

Gal Pressman (1):
  RDMA/restrack: Track driver QP types in resource tracker

Geert Uytterhoeven (1):
  clk: renesas: cpg-mssr: Fix reset control race condition

Gustavo A. R. Silva (1):
  sh: kernel: hw_breakpoint: Fix missing break in switch statement

Guy Levi (1):
  IB/mlx5: Fix MR registration flow to use UMR properly

Haim Dreyfuss (1):
  iwlwifi: Add support for SAR South Korea limitation

Heiner Kallweit (1):
  net: phy: consider AN_RESTART status when reading link status

Henry Burns (2):
  mm/z3fold.c: fix z3fold_destroy_pool() ordering
  mm/z3fold.c: fix z3fold_destroy_pool() race condition

Hillf Danton (2):
  HID: hiddev: avoid opening a disconnected device
  HID: hiddev: do cleanup in failure of opening a device

Hui Peng (2):
  ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term
  ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit

Hui Wang (2):
  ALSA: hda - Add a generic reboot_notify
  ALSA: hda - Let all conexant codec enter D3 when rebooting

Huy Nguyen (1):
  net/mlx5e: Only support tx/rx pause setting for port owner

Ian Abbott (2):
  staging: comedi: dt3000: Fix signed integer overflow 'divider * base'
  staging: comedi: dt3000: Fix rounding up of timer divisor

Isaac J. Manjarres (1):
  mm/usercopy: use memory range to be accessed for wraparound check

Ivan Khoronzhuk (1):
  net: sched: sch_taprio: fix memleak in error path for sched list parse

Jack Morgenstein (1):
  IB/mad: Fix use-after-free in ib mad completion handling

Jacopo Mondi (1):
  iio: adc: max9611: Fix temperature reading in probe

Jaegeuk Kim (1):
  f2fs: fix to read source block before invalidating it

Jakub Kicinski (1):
  net/tls: prevent skb_orphan() from leaking TLS plain text with offload

Jean Delvare (1):
  platform/x86: pcengines-apuv2: Fix softdep statement

Jeffrey Hugo (1):
  drm: msm: Fix add_gpu_components

Jia-Ju Bai (1):
  scsi: qla2xxx: Fix possible fcport null-pointer dereferences

Julien Thierry (1):
  arm64: Lower priority mask for GIC_PRIO_IRQON

Kees Cook (1):
  libata: zpodd: Fix small read overflow in zpodd_get_mech_type()

Kent Russell (1):
  drm/amdkfd: Fix byte align on VegaM

Leon Romanovsky (1):
  RDMA/mlx5: Release locks during notifier unregister

Lucas Stach (1):
  irqchip/irq-imx-gpcv2: Forward irq type to parent

Lyude Paul (1):
  drm/nouveau: Only recalculate PBN/VCPI on mode/connector changes

Manish Chopra (1):
  bnx2x: Fix VF's VLAN reconfiguration in reload.

Mao Han (1):
  riscv: Fix perf record without libelf support

Masahiro Yamada (2):
  tracing: Fix header include guards in trace event headers
  kbuild: modpost: handle KBUILD_EXTRA_SYMBOLS only for external modules

Masami Hiramatsu (3):
  arm64: unwind: Prohibit probing on return_address()
  arm64: kprobes: Recover pstate.D in single-step exception handler
  arm64: Make debug exception handlers visible from RCU

Max Filippov (1):
  xtensa: add missing isync to the cpu_reset TLB code

Maxim Mikityanskiy (1):
  net/mlx5e: Use flow keys dissector to parse packets for ARFS

Mel Gorman (1):
  mm, vmscan: do not special-case slab reclaim when watermarks are
    boosted

Michael Chan (2):
  bnxt_en: Fix VNIC clearing logic for 57500 chips.
  bnxt_en: Improve RX doorbell sequence.

Michal Kalderon (1):
  RDMA/qedr: Fix the hca_type and hca_rev returned in device attributes

Miles Chen (1):
  mm/memcontrol.c: fix use after free in mem_cgroup_iter()

Miquel Raynal (1):
  ata: libahci: do not complain in case of deferred probe

Mohamad Heib (1):
  net/mlx5e: ethtool, Avoid setting speed to 56GBASE when autoneg off

Nayna Jain (1):
  tpm: tpm_ibm_vtpm: Fix unallocated banks

NeilBrown (1):
  seq_file: fix problem when seeking mid-record

Nianyao Tang (1):
  irqchip/gic-v3-its: Free unused vpt_page when alloc vpe table fail

Numfor Mbiziwo-Tiapo (1):
  perf header: Fix use of unitialized value warning

Oliver Neukum (5):
  HID: holtek: test for sanity of intfdata
  Input: kbtab - sanity check for endpoint type
  Input: iforce - add sanity checks
  usb: cdc-acm: make sure a refcount is taken early enough
  USB: CDC: fix sanity checks in CDC union parser

Pierre-Eric Pelloux-Prayer (1):
  drm/amdgpu: fix gfx9 soft recovery

Qian Cai (4):
  arm64/efi: fix variable 'si' set but not used
  arm64/mm: fix variable 'pud' set but not used
  arm64/mm: fix variable 'tag' set but not used
  asm-generic: fix -Wtype-limits compiler warnings

Rajneesh Bhardwaj (1):
  platform/x86: intel_pmc_core: Add ICL-NNPI support to PMC Core

Ralph Campbell (1):
  mm/hmm: fix bad subpage pointer in try_to_unmap_one

Roberto Sassu (1):
  KEYS: trusted: allow module init if TPM is inactive or deactivated

Rogan Dawes (1):
  USB: serial: option: add D-Link DWM-222 device ID

Roman Mashak (2):
  net sched: update skbedit action for batched events operations
  tc-testing: updated skbedit action tests with batch create/delete

Ross Lagerwall (1):
  xen/netback: Reset nr_frags before freeing skb

Sasha Levin (1):
  Linux 5.2.10-rc1

Somnath Kotur (1):
  bnxt_en: Fix to include flow direction in L2 key

Stephen Boyd (1):
  kbuild: Check for unknown options with cc-option usage in Kconfig and
    clang

Takashi Iwai (2):
  ALSA: hda/realtek - Add quirk for HP Envy x360
  ALSA: hda - Apply workaround for another AMD chip 1022:1487

Thiébaud Weksteen (1):
  usb: setup authorized_default attributes using usb_bus_notify

Tony Lindgren (1):
  USB: serial: option: Add Motorola modem UARTs

Tony Luck (1):
  IB/core: Add mitigation for Spectre V1

Vasundhara Volam (2):
  bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
  bnxt_en: Suppress HWRM errors for HWRM_NVM_GET_VARIABLE command

Venkat Duvvuru (1):
  bnxt_en: Use correct src_fid to determine direction of the flow

Vince Weaver (1):
  perf header: Fix divide by zero error if f_header.attr_size==0

Vincent Chen (2):
  riscv: Correct the initialized flow of FP register
  riscv: Make __fstate_clean() work correctly.

Viresh Kumar (1):
  cpufreq: schedutil: Don't skip freq update when limits change

Wang Xiayang (1):
  drm/amdgpu: fix a potential information leaking bug

Wei Yongjun (1):
  RDMA/hns: Fix error return code in hns_roce_v1_rsv_lp_qp()

Wenwen Wang (2):
  ALSA: hda - Fix a memory leak bug
  net/mlx4_en: fix a memory leak bug

Will Deacon (1):
  arm64: ftrace: Ensure module ftrace trampoline is coherent with I-side

Xi Wang (1):
  RDMA/hns: Fix sg offset non-zero issue

Xin Long (1):
  sctp: fix the transport error_count check

Yang Shi (3):
  mm: mempolicy: make the behavior consistent when MPOL_MF_MOVE* and
    MPOL_MF_STRICT were specified
  mm: mempolicy: handle vma with unmovable pages mapped correctly in
    mbind
  Revert "kmemleak: allow to coexist with fault injection"

Yoshiaki Okamoto (1):
  USB: serial: option: Add support for ZTE MF871A

Yoshihiro Shimoda (1):
  usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"

YueHaibing (7):
  xen/pciback: remove set but not used variable 'old_state'
  drm/bridge: lvds-encoder: Fix build error while
    CONFIG_DRM_KMS_HELPER=m
  drm/bridge: tc358764: Fix build error
  ocfs2: remove set but not used variable 'last_hash'
  Input: psmouse - fix build error of multiple definition
  bonding: Add vlan tx offload to hw_enc_features
  team: Add vlan tx offload to hw_enc_features

Yuki Tsunashima (1):
  ALSA: pcm: fix lost wakeup event scenarios in snd_pcm_drain

zhengbin (2):
  blk-mq: move cancel of requeue_work to the front of blk_exit_queue
  sctp: fix memleak in sctp_send_reset_streams

 Documentation/networking/tls-offload.rst      |  18 ---
 Documentation/vm/hmm.rst                      |   2 +-
 Makefile                                      |   4 +-
 arch/arm64/include/asm/arch_gicv3.h           |   6 +
 arch/arm64/include/asm/daifflags.h            |   2 +
 arch/arm64/include/asm/efi.h                  |   6 +-
 arch/arm64/include/asm/memory.h               |  10 +-
 arch/arm64/include/asm/pgtable.h              |   4 +-
 arch/arm64/include/asm/ptrace.h               |   2 +-
 arch/arm64/kernel/ftrace.c                    |  22 ++--
 arch/arm64/kernel/probes/kprobes.c            |  40 +-----
 arch/arm64/kernel/return_address.c            |   3 +
 arch/arm64/kernel/stacktrace.c                |   3 +
 arch/arm64/kvm/regmap.c                       |   5 +
 arch/arm64/mm/fault.c                         |  57 ++++++--
 arch/mips/vdso/vdso.h                         |   1 +
 arch/powerpc/platforms/pseries/papr_scm.c     |  29 ++++-
 arch/riscv/include/asm/switch_to.h            |   8 +-
 arch/riscv/kernel/process.c                   |  11 +-
 arch/riscv/kernel/vdso/Makefile               |   2 +-
 arch/sh/kernel/hw_breakpoint.c                |   1 +
 arch/xtensa/kernel/setup.c                    |   1 +
 block/blk-mq.c                                |   2 -
 block/blk-sysfs.c                             |   3 +
 drivers/ata/libahci_platform.c                |   3 +
 drivers/ata/libata-zpodd.c                    |   2 +-
 drivers/char/tpm/tpm-chip.c                   |  20 +++
 drivers/char/tpm/tpm.h                        |   2 +
 drivers/char/tpm/tpm1-cmd.c                   |  36 +++--
 drivers/char/tpm/tpm2-cmd.c                   |   6 +-
 drivers/clk/at91/clk-generated.c              |   2 +
 drivers/clk/renesas/renesas-cpg-mssr.c        |  16 +--
 drivers/clk/sprd/Kconfig                      |   1 +
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c        |  26 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c        |  18 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c         |   2 +-
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c    |   3 +-
 drivers/gpu/drm/bridge/Kconfig                |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_scaler.c    |   4 +-
 drivers/gpu/drm/msm/msm_drv.c                 |   3 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c       |  22 ++--
 drivers/hid/hid-holtek-kbd.c                  |   9 +-
 drivers/hid/usbhid/hiddev.c                   |  12 ++
 drivers/i2c/busses/i2c-imx.c                  |  18 +--
 drivers/iio/adc/max9611.c                     |   2 +-
 drivers/infiniband/core/core_priv.h           |   5 +-
 drivers/infiniband/core/mad.c                 |  20 +--
 drivers/infiniband/core/user_mad.c            |   6 +-
 drivers/infiniband/hw/hns/hns_roce_db.c       |  15 ++-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c    |   4 +-
 drivers/infiniband/hw/mlx5/main.c             |   7 +-
 drivers/infiniband/hw/mlx5/mr.c               |  27 ++--
 drivers/infiniband/hw/mlx5/odp.c              |   4 +-
 drivers/infiniband/hw/qedr/main.c             |  10 +-
 drivers/input/joystick/iforce/iforce-usb.c    |   5 +
 drivers/input/mouse/trackpoint.h              |   3 +-
 drivers/input/tablet/kbtab.c                  |   6 +-
 drivers/irqchip/irq-gic-v3-its.c              |   2 +-
 drivers/irqchip/irq-imx-gpcv2.c               |   1 +
 drivers/net/bonding/bond_main.c               |   2 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |   7 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |   2 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  17 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  36 +++--
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   9 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h  |   6 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   3 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |  97 +++++---------
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  11 ++
 drivers/net/netdevsim/dev.c                   |  63 ++++-----
 drivers/net/netdevsim/fib.c                   | 102 +++++++++------
 drivers/net/netdevsim/netdev.c                |   9 +-
 drivers/net/netdevsim/netdevsim.h             |  10 +-
 drivers/net/phy/phy-c45.c                     |  14 ++
 drivers/net/phy/phy_device.c                  |  12 +-
 drivers/net/team/team.c                       |   2 +
 drivers/net/usb/pegasus.c                     |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  |  28 ++--
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |   5 +-
 .../net/wireless/intel/iwlwifi/fw/api/power.h |  12 ++
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  55 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   1 +
 drivers/net/xen-netback/netback.c             |   2 +
 drivers/platform/x86/intel_pmc_core.c         |   1 +
 drivers/platform/x86/pcengines-apuv2.c        |   4 +-
 drivers/scsi/hpsa.c                           |  12 +-
 drivers/scsi/qla2xxx/qla_init.c               |   2 +-
 drivers/staging/comedi/drivers/dt3000.c       |   8 +-
 drivers/usb/class/cdc-acm.c                   |  12 +-
 drivers/usb/core/file.c                       |  10 +-
 drivers/usb/core/hcd.c                        | 123 ------------------
 drivers/usb/core/message.c                    |   4 +-
 drivers/usb/core/sysfs.c                      | 121 +++++++++++++++++
 drivers/usb/core/usb.h                        |   5 +
 drivers/usb/gadget/udc/renesas_usb3.c         |   5 +-
 drivers/usb/serial/option.c                   |  10 ++
 .../xen/xen-pciback/conf_space_capability.c   |   3 +-
 fs/btrfs/backref.c                            |   2 +-
 fs/btrfs/transaction.c                        |  22 +++-
 fs/btrfs/transaction.h                        |   3 +
 fs/f2fs/gc.c                                  |  70 +++++-----
 fs/io_uring.c                                 |   4 +-
 fs/ocfs2/xattr.c                              |   3 -
 fs/seq_file.c                                 |   2 +-
 include/asm-generic/getorder.h                |  50 +++----
 include/linux/page-flags-layout.h             |  18 ++-
 include/linux/skbuff.h                        |   8 ++
 include/linux/socket.h                        |   3 +
 include/net/netlink.h                         |   5 +-
 include/net/sock.h                            |  10 +-
 include/trace/events/dma_fence.h              |   2 +-
 include/trace/events/napi.h                   |   4 +-
 include/trace/events/qdisc.h                  |   4 +-
 include/trace/events/tegra_apb_dma.h          |   4 +-
 kernel/dma/mapping.c                          |  13 +-
 kernel/sched/cpufreq_schedutil.c              |  14 +-
 mm/hmm.c                                      |  10 +-
 mm/kmemleak.c                                 |   2 +-
 mm/memcontrol.c                               |  39 ++++--
 mm/mempolicy.c                                | 100 ++++++++++----
 mm/rmap.c                                     |   8 ++
 mm/usercopy.c                                 |   2 +-
 mm/vmscan.c                                   |  13 +-
 mm/z3fold.c                                   |  14 +-
 net/bridge/netfilter/ebtables.c               |  28 ++--
 net/core/filter.c                             |   6 +-
 net/core/sock.c                               |  19 ++-
 net/dsa/switch.c                              |   3 +
 net/ipv4/tcp.c                                |   3 +
 net/ipv4/tcp_bpf.c                            |   6 +-
 net/ipv4/tcp_output.c                         |   3 +
 net/netfilter/nf_conntrack_core.c             |  16 +--
 net/packet/af_packet.c                        |   7 +
 net/sched/act_skbedit.c                       |  12 ++
 net/sched/sch_taprio.c                        |   3 +-
 net/sctp/sm_sideeffect.c                      |   2 +-
 net/sctp/stream.c                             |   1 +
 net/tipc/addr.c                               |   1 +
 net/tls/tls_device.c                          |   9 +-
 scripts/Kconfig.include                       |   2 +-
 scripts/Makefile.modpost                      |   2 +-
 security/keys/trusted.c                       |  13 --
 sound/core/pcm_native.c                       |   3 +-
 sound/pci/hda/hda_generic.c                   |  21 ++-
 sound/pci/hda/hda_generic.h                   |   1 +
 sound/pci/hda/hda_intel.c                     |   3 +
 sound/pci/hda/patch_conexant.c                |  15 +--
 sound/pci/hda/patch_realtek.c                 |  12 +-
 sound/usb/mixer.c                             |  37 ++++--
 tools/perf/trace/beauty/usbdevfs_ioctl.sh     |   9 +-
 tools/perf/util/header.c                      |   9 +-
 .../tc-testing/tc-tests/actions/skbedit.json  |  47 +++++++
 158 files changed, 1317 insertions(+), 837 deletions(-)

-- 
2.20.1

