Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D04543C52D
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbhJ0Ict (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240985AbhJ0Iba (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 04:31:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48C7C610A0;
        Wed, 27 Oct 2021 08:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635323344;
        bh=fUxAwQ+jnQS4F9Sc8L2UzK4xATBhEZUOrGxbTWz9O9A=;
        h=From:To:Cc:Subject:Date:From;
        b=jWNCzRKzD03rb0sW28Ej5iJ1Ovemvalhg5fXJn6BavPxI1IFv9b5uM6N8KtCpxuo4
         Al3rlO3b3hhSyoKvVcEwiYGmJcZw2AijJUU3f1plhzdDIHx/ShMo+E22sJYXydwzLK
         e326WEtu7Ux37Pyl+586wZfqiXwLD8pP4Msa5ub0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.15
Date:   Wed, 27 Oct 2021 10:28:55 +0200
Message-Id: <163532333562190@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.15 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/devlink/ice.rst                          |    9 
 Makefile                                                          |    2 
 arch/arm/Kconfig                                                  |    1 
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts                       |    1 
 arch/arm/boot/dts/spear3xx.dtsi                                   |    2 
 arch/arm/boot/dts/vexpress-v2m.dtsi                               |    2 
 arch/arm/boot/dts/vexpress-v2p-ca9.dts                            |    2 
 arch/arm64/kvm/hyp/include/nvhe/gfp.h                             |    1 
 arch/arm64/kvm/hyp/nvhe/mem_protect.c                             |   13 
 arch/arm64/kvm/hyp/nvhe/page_alloc.c                              |   14 
 arch/arm64/kvm/mmu.c                                              |    6 
 arch/nios2/include/asm/irqflags.h                                 |    4 
 arch/nios2/include/asm/registers.h                                |    2 
 arch/parisc/math-emu/fpudispatch.c                                |   56 +++
 arch/powerpc/include/asm/code-patching.h                          |    1 
 arch/powerpc/include/asm/security_features.h                      |    5 
 arch/powerpc/kernel/idle_book3s.S                                 |   10 
 arch/powerpc/kernel/security.c                                    |    5 
 arch/powerpc/kernel/smp.c                                         |    2 
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                           |   28 -
 arch/powerpc/lib/code-patching.c                                  |    7 
 arch/powerpc/net/bpf_jit.h                                        |   33 +
 arch/powerpc/net/bpf_jit64.h                                      |    8 
 arch/powerpc/net/bpf_jit_comp.c                                   |    6 
 arch/powerpc/net/bpf_jit_comp32.c                                 |    8 
 arch/powerpc/net/bpf_jit_comp64.c                                 |   63 +++
 arch/s390/include/asm/pci.h                                       |    2 
 arch/s390/pci/pci.c                                               |   48 ++
 arch/s390/pci/pci_event.c                                         |    4 
 arch/sh/include/asm/pgtable-3level.h                              |    2 
 arch/x86/events/msr.c                                             |    1 
 arch/x86/include/asm/kvm_host.h                                   |    3 
 arch/x86/kvm/mmu/mmu.c                                            |    6 
 arch/x86/kvm/svm/sev.c                                            |   16 
 arch/x86/kvm/svm/svm.h                                            |    2 
 arch/x86/kvm/vmx/vmx.c                                            |   17 
 arch/x86/kvm/x86.c                                                |  150 +++++---
 arch/x86/xen/enlighten.c                                          |    9 
 arch/xtensa/platforms/xtfpga/setup.c                              |   12 
 block/blk-cgroup.c                                                |    5 
 block/blk-mq-debugfs.c                                            |    1 
 block/mq-deadline.c                                               |   12 
 drivers/base/test/Makefile                                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                        |    8 
 drivers/gpu/drm/amd/display/Kconfig                               |    2 
 drivers/gpu/drm/kmb/kmb_crtc.c                                    |   41 ++
 drivers/gpu/drm/kmb/kmb_drv.c                                     |   10 
 drivers/gpu/drm/kmb/kmb_drv.h                                     |   13 
 drivers/gpu/drm/kmb/kmb_dsi.c                                     |   25 -
 drivers/gpu/drm/kmb/kmb_dsi.h                                     |    2 
 drivers/gpu/drm/kmb/kmb_plane.c                                   |  122 ++++++-
 drivers/gpu/drm/kmb/kmb_plane.h                                   |   11 
 drivers/gpu/drm/kmb/kmb_regs.h                                    |    3 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c                             |    6 
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h                             |    3 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                             |   40 +-
 drivers/gpu/drm/mxsfb/mxsfb_drv.c                                 |    6 
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c                     |   12 
 drivers/iio/test/Makefile                                         |    1 
 drivers/input/keyboard/snvs_pwrkey.c                              |   29 +
 drivers/isdn/capi/kcapi.c                                         |    5 
 drivers/isdn/hardware/mISDN/netjet.c                              |    2 
 drivers/net/can/rcar/rcar_can.c                                   |   20 -
 drivers/net/can/sja1000/peak_pci.c                                |    9 
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c                        |    5 
 drivers/net/dsa/lantiq_gswip.c                                    |    2 
 drivers/net/dsa/mt7530.c                                          |    8 
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c              |    2 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                   |    5 
 drivers/net/ethernet/hisilicon/hns3/hnae3.c                       |   21 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                       |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c                   |   37 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h                   |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c            |    9 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c            |    5 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h            |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c           |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c             |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c         |    6 
 drivers/net/ethernet/intel/e1000e/e1000.h                         |    4 
 drivers/net/ethernet/intel/e1000e/ich8lan.c                       |   31 +
 drivers/net/ethernet/intel/e1000e/ich8lan.h                       |    3 
 drivers/net/ethernet/intel/e1000e/netdev.c                        |   29 -
 drivers/net/ethernet/intel/ice/ice_common.c                       |    2 
 drivers/net/ethernet/intel/ice/ice_devids.h                       |    4 
 drivers/net/ethernet/intel/ice/ice_devlink.c                      |    3 
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c                    |    4 
 drivers/net/ethernet/intel/ice/ice_lib.c                          |    9 
 drivers/net/ethernet/intel/ice/ice_main.c                         |    8 
 drivers/net/ethernet/intel/ice/ice_sched.c                        |   13 
 drivers/net/ethernet/intel/ice/ice_sched.h                        |    1 
 drivers/net/ethernet/intel/igc/igc_hw.h                           |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c               |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c     |   51 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c                   |   20 -
 drivers/net/ethernet/mellanox/mlx5/core/lag.c                     |   19 -
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c                  |   13 
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h                  |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c               |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                 |    2 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c             |    8 
 drivers/net/hamradio/baycom_epp.c                                 |    6 
 drivers/net/phy/mdio_bus.c                                        |    1 
 drivers/net/usb/Kconfig                                           |    1 
 drivers/net/usb/r8152.c                                           |   16 
 drivers/pci/hotplug/s390_pci_hpc.c                                |    9 
 drivers/pinctrl/stm32/pinctrl-stm32.c                             |    4 
 drivers/platform/x86/intel_scu_ipc.c                              |    4 
 drivers/ptp/ptp_clock.c                                           |   15 
 drivers/scsi/hosts.c                                              |    3 
 drivers/scsi/mpi3mr/mpi3mr_os.c                                   |    2 
 drivers/scsi/qla2xxx/qla_bsg.c                                    |    2 
 drivers/scsi/scsi_transport_iscsi.c                               |    2 
 drivers/scsi/storvsc_drv.c                                        |   32 +
 drivers/spi/spi-mux.c                                             |    7 
 drivers/spi/spi.c                                                 |   27 -
 drivers/thunderbolt/Makefile                                      |    1 
 fs/autofs/waitq.c                                                 |    2 
 fs/btrfs/tree-log.c                                               |   47 +-
 fs/ceph/caps.c                                                    |   12 
 fs/ceph/file.c                                                    |    1 
 fs/ceph/inode.c                                                   |    2 
 fs/ceph/mds_client.c                                              |   17 
 fs/ceph/super.c                                                   |   17 
 fs/ceph/super.h                                                   |    3 
 fs/kernel_read_file.c                                             |    2 
 fs/nfsd/nfsctl.c                                                  |    5 
 fs/ocfs2/alloc.c                                                  |   46 --
 fs/ocfs2/super.c                                                  |   14 
 fs/userfaultfd.c                                                  |   12 
 include/linux/elfcore.h                                           |    2 
 include/linux/mlx5/driver.h                                       |    1 
 include/linux/secretmem.h                                         |    2 
 include/linux/spi/spi.h                                           |    3 
 include/linux/trace_recursion.h                                   |   49 --
 include/linux/user_namespace.h                                    |    2 
 include/net/sctp/sm.h                                             |    6 
 include/sound/hda_codec.h                                         |    1 
 kernel/auditsc.c                                                  |    2 
 kernel/cred.c                                                     |    9 
 kernel/dma/debug.c                                                |   12 
 kernel/sched/core.c                                               |    1 
 kernel/signal.c                                                   |   25 -
 kernel/trace/ftrace.c                                             |    4 
 kernel/ucount.c                                                   |   49 ++
 lib/Makefile                                                      |    2 
 lib/kunit/executor_test.c                                         |    4 
 mm/huge_memory.c                                                  |    6 
 mm/mempolicy.c                                                    |   16 
 mm/slub.c                                                         |   23 -
 net/bpf/test_run.c                                                |   14 
 net/bridge/br_private.h                                           |    4 
 net/can/isotp.c                                                   |   51 ++
 net/can/j1939/j1939-priv.h                                        |    1 
 net/can/j1939/main.c                                              |    7 
 net/can/j1939/transport.c                                         |   14 
 net/dsa/dsa2.c                                                    |    9 
 net/ipv4/tcp_ipv4.c                                               |   19 -
 net/ipv6/ip6_output.c                                             |    3 
 net/ipv6/netfilter/ip6t_rt.c                                      |   48 --
 net/netfilter/Kconfig                                             |    2 
 net/netfilter/ipvs/ip_vs_ctl.c                                    |    5 
 net/netfilter/nft_chain_filter.c                                  |    9 
 net/netfilter/xt_IDLETIMER.c                                      |    2 
 net/nfc/nci/rsp.c                                                 |    2 
 net/sched/act_ct.c                                                |    2 
 scripts/Makefile.gcc-plugins                                      |    4 
 security/keys/process_keys.c                                      |    8 
 sound/hda/hdac_controller.c                                       |    5 
 sound/pci/hda/hda_bind.c                                          |   20 -
 sound/pci/hda/hda_codec.c                                         |    1 
 sound/pci/hda/hda_controller.c                                    |   24 -
 sound/pci/hda/hda_controller.h                                    |    2 
 sound/pci/hda/hda_intel.c                                         |   29 +
 sound/pci/hda/hda_intel.h                                         |    4 
 sound/pci/hda/patch_realtek.c                                     |    1 
 sound/soc/codecs/Kconfig                                          |    1 
 sound/soc/codecs/cs4341.c                                         |    7 
 sound/soc/codecs/nau8824.c                                        |    4 
 sound/soc/codecs/pcm179x-spi.c                                    |    1 
 sound/soc/codecs/pcm512x.c                                        |    2 
 sound/soc/codecs/wm8960.c                                         |   13 
 sound/soc/fsl/fsl_xcvr.c                                          |   17 
 sound/soc/soc-dapm.c                                              |   13 
 sound/usb/quirks-table.h                                          |   32 +
 tools/lib/perf/tests/test-evlist.c                                |    6 
 tools/lib/perf/tests/test-evsel.c                                 |    7 
 tools/objtool/elf.c                                               |   56 +--
 tools/testing/selftests/net/forwarding/Makefile                   |    1 
 tools/testing/selftests/net/forwarding/forwarding.config.sample   |    2 
 tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh |  172 ++++++++++
 tools/testing/selftests/net/forwarding/lib.sh                     |    8 
 tools/testing/selftests/netfilter/nft_flowtable.sh                |    1 
 tools/testing/selftests/vm/userfaultfd.c                          |   23 +
 195 files changed, 1756 insertions(+), 730 deletions(-)

Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: fix register definition

Alex Deucher (1):
      drm/amdgpu/display: fix dependencies for DRM_AMD_DC_SI

Andrea Parri (Microsoft) (1):
      scsi: storvsc: Fix validation for unsolicited incoming packets

Anitha Chrisanthus (4):
      drm/kmb: Work around for higher system clock
      drm/kmb: Corrected typo in handle_lcd_irq
      drm/kmb: Enable ADV bridge after modeset
      drm/kmb: Limit supported mode to 1080p

Antoine Tenart (1):
      netfilter: ipvs: make global sysctl readonly in non-init netns

Arnd Bergmann (1):
      bitfield: build kunit tests without structleak plugin

Benjamin Coddington (1):
      NFSD: Keep existing listeners on portlist error

Brendan Grieve (1):
      ALSA: usb-audio: Provide quirk for Sennheiser GSP670 Headset

Brendan Higgins (4):
      gcc-plugins/structleak: add makefile var for disabling structleak
      iio/test-format: build kunit tests without structleak plugin
      device property: build kunit tests without structleak plugin
      thunderbolt: build kunit tests without structleak plugin

Brett Creeley (2):
      ice: Fix failure to re-add LAN/RDMA Tx queues
      ice: Print the api_patch as part of the fw.mgmt.api

Chenyi Qiang (1):
      KVM: MMU: Reset mmu->pkru_mask to avoid stale data

Christophe JAILLET (1):
      net: dsa: Fix an error handling path in 'dsa_switch_parse_ports_of()'

DENG Qingfang (1):
      net: dsa: mt7530: correct ds->num_ports

Dan Johansen (1):
      drm/panel: ilitek-ili9881c: Fix sync for Feixin K101-IM2BYL02 panel

Daniel Borkmann (1):
      bpf, test, cgroup: Use sk_{alloc,free} for test cases

Dave Ertman (1):
      ice: Avoid crash from unnecessary IDA free

Dexuan Cui (1):
      scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()

Edmund Dea (3):
      drm/kmb: Remove clearing DPHY regs
      drm/kmb: Disable change of plane parameters
      drm/kmb: Enable alpha blended second plane

Emeel Hakim (2):
      net/mlx5e: IPsec: Fix a misuse of the software parser's fields
      net/mlx5e: IPsec: Fix work queue entry ethernet segment checksum flags

Eric Dumazet (1):
      mm/mempolicy: do not allow illegal MPOL_F_NUMA_BALANCING | MPOL_LOCAL in mbind()

Eric W. Biederman (4):
      ucounts: Move get_ucounts from cred_alloc_blank to key_change_session_keyring
      ucounts: Pair inc_rlimit_ucounts with dec_rlimit_ucoutns in commit_creds
      ucounts: Proper error handling in set_cred_ucounts
      ucounts: Fix signal ucount refcounting

Eugen Hristev (1):
      ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default

Fabien Dessenne (1):
      pinctrl: stm32: use valid pin identifier in stm32_pinctrl_resume()

Filipe Manana (1):
      btrfs: deal with errors when checking if a dir entry exists during log replay

Florian Westphal (2):
      netfilter: nf_tables: skip netdev events generated on netns removal
      selftests: netfilter: remove stray bash debug line

Gaosheng Cui (1):
      audit: fix possible null-pointer dereference in audit_filter_rules

Geert Uytterhoeven (2):
      block/mq-deadline: Move dd_queued() to fix defined but not used warning
      sh: pgtable-3level: fix cast to pointer from integer of different size

Gerald Schaefer (1):
      dma-debug: fix sg checks in debug_dma_map_sg()

Greg Kroah-Hartman (1):
      Linux 5.14.15

Guangbin Huang (2):
      net: hns3: reset DWRR of unused tc to zero
      net: hns3: add limit ets dwrr bandwidth cannot be 0

Guenter Roeck (1):
      xtensa: xtfpga: Try software restart before simulating CPU reset

Hans de Goede (1):
      ASoC: nau8824: Fix headphone vs headset, button-press detection no longer working

Hayes Wang (1):
      r8152: avoid to resubmit rx immediately

Helge Deller (1):
      parisc: math-emu: Fix fall-through warnings

Herve Codina (2):
      net: stmmac: add support for dwmac 3.40a
      ARM: dts: spear3xx: Fix gmac node

Ian Kent (1):
      autofs: fix wait name hash calculation in autofs_wait()

Jan Beulich (1):
      xen/x86: prevent PVH type from getting clobbered

Jan Kara (1):
      ocfs2: fix data corruption after conversion from inline format

Jeff Layton (2):
      ceph: skip existing superblocks that are blocklisted or shut down when mounting
      ceph: fix handling of "meta" errors

Jiaran Zhang (1):
      net: hns3: Add configuration of TM QCN error event

Johannes Thumshirn (1):
      block: decode QUEUE_FLAG_HCTX_ACTIVE in debugfs output

Joy Gu (1):
      scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()

Juhee Kang (1):
      netfilter: xt_IDLETIMER: fix panic that occurs when timer_type has garbage value

Kai Vehmanen (1):
      ALSA: hda: avoid write to STATESTS if controller is in reset

Kan Liang (1):
      perf/x86/msr: Add Sapphire Rapids CPU support

Kurt Kanzenbach (1):
      net: stmmac: Fix E2E delay mechanism

Leonard Crestez (1):
      tcp: md5: Fix overlap between vrf and non-vrf keys

Lin Ma (1):
      nfc: nci: fix the UAF of rf_conn_info object

Lukas Bulwahn (1):
      elfcore: correct reference to CONFIG_UML

Maor Dickman (1):
      net/mlx5: Lag, change multipath and bonding to be mutually exclusive

Marc Kleine-Budde (1):
      can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path

Marek Szyprowski (1):
      mm/thp: decrease nr_thps in file's mapping on THP split

Marek Vasut (1):
      drm: mxsfb: Fix NULL pointer dereference crash on unload

Mark Bloch (1):
      net/mlx5: Lag, move lag destruction to a workqueue

Mark Brown (3):
      ASoC: pcm179x: Add missing entries SPI to device ID table
      ASoC: cs4341: Add SPI device ID table
      spi: Fix deadlock when adding SPI controllers on SPI buses

Masahiro Kozuka (1):
      KVM: SEV: Flush cache on non-coherent systems before RECEIVE_UPDATE_DATA

Matthew Wilcox (Oracle) (1):
      vfs: check fd has read access in kernel_read_file_from_fd()

Max Filippov (1):
      xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF

Miaohe Lin (4):
      mm, slub: fix mismatch between reconstructed freelist depth and cnt
      mm, slub: fix potential memoryleak in kmem_cache_open()
      mm, slub: fix potential use-after-free in slab_debugfs_fops
      mm, slub: fix incorrect memcg slab count for bulk free

Michael Ellerman (3):
      KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()
      KVM: PPC: Book3S HV: Make idle_kvm_start_guest() return 0 if it went to guest
      powerpc/idle: Don't corrupt back chain when going idle

Michael Forney (2):
      objtool: Check for gelf_update_rel[a] failures
      objtool: Update section header before relocations

Michal Swiatkowski (1):
      ice: fix getting UDP tunnel entry

Mike Christie (1):
      scsi: iscsi: Fix set_param() handling

Nadav Amit (1):
      userfaultfd: fix a race between writeprotect and exit_mmap()

Nathan Lynch (1):
      powerpc/smp: do not decrement idle task preempt count in CPU offline

Naveen N. Rao (4):
      powerpc/lib: Add helper to check if offset is within conditional branch range
      powerpc/bpf: Validate branch ranges
      powerpc/security: Add a helper to query stf_barrier type
      powerpc/bpf: Emit stf barrier instruction sequences for BPF_NOSPEC

Nick Desaulniers (1):
      ARM: 9122/1: select HAVE_FUTEX_CMPXCHG

Niklas Schnelle (2):
      s390/pci: cleanup resources only if necessary
      s390/pci: fix zpci_zdev_put() on reserve

Nikolay Aleksandrov (1):
      net: bridge: mcast: use multicast_membership_interval for IGMPv3

Paolo Bonzini (11):
      KVM: nVMX: promptly process interrupts delivered while in guest mode
      KVM: SEV-ES: rename guest_ins_data to sev_pio_data
      KVM: SEV-ES: clean up kvm_sev_es_ins/outs
      KVM: SEV-ES: keep INS functions together
      KVM: SEV-ES: fix length of string I/O
      KVM: SEV-ES: go over the sev_pio_data buffer in multiple passes if needed
      KVM: SEV-ES: reduce ghcb_sa_len to 32 bits
      KVM: x86: leave vcpu->arch.pio.count alone in emulator_pio_in_out
      KVM: x86: check for interrupts before deciding whether to exit the fast path
      KVM: x86: split the two parts of emulator_pio_in
      KVM: x86: remove unnecessary arguments from complete_emulator_pio_in

Paul Blakey (1):
      net/sched: act_ct: Fix byte count on fragmented packets

Peng Li (1):
      net: hns3: disable sriov before unload hclge layer

Peter Gonda (1):
      KVM: SEV-ES: Set guest_state_protected after VMSA update

Peter Rosin (1):
      ASoC: pcm512x: Mend accesses to the I2S_1 and I2S_2 registers

Peter Xu (1):
      mm/userfaultfd: selftests: fix memory corruption with thp enabled

Prashant Malani (2):
      platform/x86: intel_scu_ipc: Increase virtual timeout to 10s
      platform/x86: intel_scu_ipc: Update timeout value in comment

Quentin Perret (2):
      KVM: arm64: Fix host stage-2 PGD refcount
      KVM: arm64: Release mmap_lock when using VM_SHARED with MTE

Randy Dunlap (2):
      hamradio: baycom_epp: fix build for UML
      NIOS2: irqflags: rename a redefined register name

Rob Clark (1):
      drm/msm/a6xx: Serialize GMU communication

Rob Herring (1):
      arm: dts: vexpress-v2p-ca9: Fix the SMB unit-address

Sasha Neftin (3):
      e1000e: Fix packet loss on Tiger Lake and later
      igc: Update I226_K device ID
      e1000e: Separate TGP board type from SPT

Sean Christopherson (1):
      mm/secretmem: fix NULL page->mapping dereference in page_is_secretmem()

Shengjiu Wang (2):
      ASoC: fsl_xcvr: Fix channel swap issue with ARC
      ASoC: wm8960: Fix clock configuration on slave mode

Shunsuke Nakamura (2):
      libperf test evsel: Fix build error on !x86 architectures
      libperf tests: Fix test_stat_cpu

Sreekanth Reddy (1):
      scsi: mpi3mr: Fix duplicate device entries when scanning through sysfs

Srinivasa Rao Mandadapu (1):
      ASoC: codec: wcd938x: Add irq config support

Stephane Grosjean (1):
      can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification

Stephen Suryaputra (1):
      ipv6: When forwarding count rx stats on the orig netdev

Steven Clarkson (1):
      ALSA: hda/realtek: Add quirk for Clevo PC50HS

Steven Rostedt (VMware) (1):
      tracing: Have all levels of checks prevent recursion

Takashi Iwai (2):
      ASoC: DAPM: Fix missing kctl change notifications
      ALSA: hda: intel: Allow repeatedly probing on codec configuration errors

Tejun Heo (1):
      blk-cgroup: blk_cgroup_bio_start() should use irq-safe operations on blkg->iostat_cpu

Tony Nguyen (1):
      ice: Add missing E810 device ids

Uwe Kleine-König (2):
      spi-mux: Fix false-positive lockdep splats
      Input: snvs_pwrkey - add clk handling

Valentin Vidic (1):
      ocfs2: mount fails with buffer overflow in strlen

Vegard Nossum (2):
      lan78xx: select CRC32
      netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Vladimir Oltean (2):
      net: enetc: fix ethtool counter name for PM0_TERR
      net: enetc: make sure all traffic classes can send large frames

Woody Lin (1):
      sched/scs: Reset the shadow stack when idle_task_exit

Xiaolong Huang (1):
      isdn: cpai: check ctr->cnr to avoid array index out of bound

Xin Long (2):
      netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
      sctp: fix transport encap_port update in sctp_vtag_verify

Xiyu Yang (1):
      kunit: fix reference count leak in kfree_at_end

Yanfei Xu (1):
      net: mdiobus: Fix memory leak in __mdiobus_register

Yang Yingliang (1):
      ptp: Fix possible memory leak in ptp_clock_register()

Yifan Zhang (1):
      drm/amdgpu: init iommu after amdkfd device init

Yoshihiro Shimoda (1):
      can: rcar_can: fix suspend/resume

Yufeng Mo (1):
      net: hns3: fix vf reset workqueue cannot exit

Yunsheng Lin (3):
      net: hns3: schedule the polling again when allocation fails
      net: hns3: fix the max tx size according to user manual
      net: hns3: fix for miscalculation of rx unused desc

Zhang Changzhong (2):
      can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length
      can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes

Zheyu Ma (2):
      can: peak_pci: peak_pci_remove(): fix UAF
      isdn: mISDN: Fix sleeping function called from invalid context

Ziyang Xuan (4):
      can: isotp: isotp_sendmsg(): add result check for wait_event_interruptible()
      can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()
      can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer
      can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv

