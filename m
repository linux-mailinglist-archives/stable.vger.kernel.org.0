Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FAA69F41D
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjBVMPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBVMPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:15:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4432034C3B;
        Wed, 22 Feb 2023 04:15:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4C08B81230;
        Wed, 22 Feb 2023 12:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB8DC433D2;
        Wed, 22 Feb 2023 12:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677068101;
        bh=KWFFo0Ir0++v8r71LEoYbFmQ2ZKgPuJEtDmpI6pogE4=;
        h=From:To:Cc:Subject:Date:From;
        b=YbJNBy+DXj39imQyxmX559VlcIrZacThn+NVcQKcxwn6Hn6V/Ptly/s2QiJ2hI0gH
         T7lFcO9noRXlpIhLx/Lf2xrWxqtzPmJdFePMfAYOhNWb1PpdOlFe7mOnZbHnZmgihP
         BTwuCQNBmRoG4MzEepvy/RmneXjuf5i+9rBLVnzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.232
Date:   Wed, 22 Feb 2023 13:14:57 +0100
Message-Id: <167706809820092@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.232 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                  |    4 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi           |    6 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                   |    6 
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h              |    2 
 arch/parisc/kernel/firmware.c                               |    5 
 arch/parisc/kernel/ptrace.c                                 |   15 
 arch/powerpc/perf/imc-pmu.c                                 |   14 
 arch/riscv/Makefile                                         |    3 
 arch/riscv/mm/cacheflush.c                                  |    4 
 arch/s390/boot/compressed/decompressor.c                    |    2 
 arch/x86/kvm/x86.c                                          |    3 
 drivers/ata/libata-core.c                                   |    2 
 drivers/bus/sunxi-rsb.c                                     |    8 
 drivers/firewire/core-cdev.c                                |    4 
 drivers/firmware/efi/efi.c                                  |    2 
 drivers/firmware/efi/memattr.c                              |    2 
 drivers/fpga/stratix10-soc.c                                |    4 
 drivers/fsi/fsi-sbefifo.c                                   |    6 
 drivers/i2c/busses/i2c-rk3x.c                               |   44 
 drivers/iio/accel/hid-sensor-accel-3d.c                     |    1 
 drivers/iio/adc/berlin2-adc.c                               |    4 
 drivers/iio/adc/stm32-dfsdm-adc.c                           |    1 
 drivers/iio/adc/twl6030-gpadc.c                             |   32 
 drivers/infiniband/hw/hfi1/file_ops.c                       |    7 
 drivers/infiniband/hw/usnic/usnic_uiom.c                    |    8 
 drivers/infiniband/ulp/ipoib/ipoib_main.c                   |    8 
 drivers/input/serio/i8042-x86ia64io.h                       | 1188 ++++----
 drivers/iommu/amd_iommu.c                                   |    5 
 drivers/iommu/arm-smmu-v3.c                                 |    2 
 drivers/iommu/arm-smmu.c                                    |    2 
 drivers/iommu/dma-iommu.c                                   |    6 
 drivers/iommu/exynos-iommu.c                                |    2 
 drivers/iommu/intel-iommu.c                                 |    2 
 drivers/iommu/iommu.c                                       |   43 
 drivers/iommu/ipmmu-vmsa.c                                  |    2 
 drivers/iommu/msm_iommu.c                                   |    2 
 drivers/iommu/mtk_iommu.c                                   |    2 
 drivers/iommu/mtk_iommu_v1.c                                |    2 
 drivers/iommu/omap-iommu.c                                  |    2 
 drivers/iommu/qcom_iommu.c                                  |    2 
 drivers/iommu/rockchip-iommu.c                              |    2 
 drivers/iommu/s390-iommu.c                                  |    2 
 drivers/iommu/tegra-gart.c                                  |    2 
 drivers/iommu/tegra-smmu.c                                  |    2 
 drivers/iommu/virtio-iommu.c                                |    2 
 drivers/mmc/core/sdio_bus.c                                 |   17 
 drivers/mmc/core/sdio_cis.c                                 |   12 
 drivers/mmc/host/mmc_spi.c                                  |    8 
 drivers/net/bonding/bond_debugfs.c                          |    2 
 drivers/net/ethernet/broadcom/bgmac-bcma.c                  |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   |    8 
 drivers/net/ethernet/intel/i40e/i40e_main.c                 |    4 
 drivers/net/ethernet/intel/ice/ice_main.c                   |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                    |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c               |   28 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c             |   15 
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c     |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c                |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c           |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c       |    2 
 drivers/net/phy/meson-gxl.c                                 |    4 
 drivers/net/usb/kalmia.c                                    |    8 
 drivers/net/usb/plusb.c                                     |    4 
 drivers/net/virtio_net.c                                    |    2 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |   17 
 drivers/nvme/host/pci.c                                     |    3 
 drivers/nvme/target/fc.c                                    |    4 
 drivers/nvmem/core.c                                        |    3 
 drivers/pinctrl/aspeed/pinctrl-aspeed.c                     |    2 
 drivers/pinctrl/intel/pinctrl-intel.c                       |   16 
 drivers/pinctrl/pinctrl-single.c                            |    2 
 drivers/scsi/iscsi_tcp.c                                    |    9 
 drivers/scsi/scsi_scan.c                                    |    7 
 drivers/target/target_core_file.c                           |    4 
 drivers/target/target_core_tmr.c                            |    4 
 drivers/tty/serial/8250/8250_dma.c                          |   26 
 drivers/tty/vt/vc_screen.c                                  |    9 
 drivers/usb/core/quirks.c                                   |    3 
 drivers/usb/dwc3/dwc3-qcom.c                                |   10 
 drivers/usb/gadget/function/f_fs.c                          |    4 
 drivers/usb/typec/altmodes/displayport.c                    |    8 
 drivers/video/fbdev/core/fbcon.c                            |    7 
 drivers/video/fbdev/smscufx.c                               |   46 
 drivers/watchdog/diag288_wdt.c                              |   15 
 drivers/xen/pvcalls-back.c                                  |    8 
 fs/aio.c                                                    |    4 
 fs/btrfs/volumes.c                                          |   18 
 fs/btrfs/zlib.c                                             |    2 
 fs/ceph/mds_client.c                                        |    6 
 fs/f2fs/gc.c                                                |   18 
 fs/nilfs2/ioctl.c                                           |    7 
 fs/nilfs2/super.c                                           |    9 
 fs/nilfs2/the_nilfs.c                                       |    8 
 fs/proc/task_mmu.c                                          |    4 
 fs/squashfs/squashfs_fs.h                                   |    2 
 fs/squashfs/squashfs_fs_sb.h                                |    2 
 fs/squashfs/xattr.h                                         |    4 
 fs/squashfs/xattr_id.c                                      |    2 
 fs/xfs/libxfs/xfs_defer.c                                   |  358 +-
 fs/xfs/libxfs/xfs_defer.h                                   |   49 
 fs/xfs/libxfs/xfs_inode_fork.c                              |    2 
 fs/xfs/libxfs/xfs_trans_inode.c                             |    2 
 fs/xfs/xfs_aops.c                                           |    4 
 fs/xfs/xfs_bmap_item.c                                      |  238 -
 fs/xfs/xfs_bmap_item.h                                      |    3 
 fs/xfs/xfs_extfree_item.c                                   |  175 -
 fs/xfs/xfs_extfree_item.h                                   |   18 
 fs/xfs/xfs_icreate_item.c                                   |    1 
 fs/xfs/xfs_inode.c                                          |    4 
 fs/xfs/xfs_inode_item.c                                     |    2 
 fs/xfs/xfs_inode_item.h                                     |    4 
 fs/xfs/xfs_iwalk.c                                          |   27 
 fs/xfs/xfs_log.c                                            |   68 
 fs/xfs/xfs_log.h                                            |    3 
 fs/xfs/xfs_log_cil.c                                        |    8 
 fs/xfs/xfs_log_recover.c                                    |  160 -
 fs/xfs/xfs_mount.c                                          |    3 
 fs/xfs/xfs_refcount_item.c                                  |  173 -
 fs/xfs/xfs_refcount_item.h                                  |    3 
 fs/xfs/xfs_rmap_item.c                                      |  161 -
 fs/xfs/xfs_rmap_item.h                                      |    3 
 fs/xfs/xfs_stats.c                                          |    4 
 fs/xfs/xfs_stats.h                                          |    1 
 fs/xfs/xfs_super.c                                          |    8 
 fs/xfs/xfs_trace.h                                          |    1 
 fs/xfs/xfs_trans.h                                          |   10 
 include/linux/hugetlb.h                                     |   18 
 include/linux/iommu.h                                       |   21 
 include/linux/stmmac.h                                      |    1 
 include/net/sock.h                                          |   13 
 kernel/sched/psi.c                                          |    7 
 kernel/trace/trace.c                                        |    3 
 mm/memblock.c                                               |    8 
 mm/mempolicy.c                                              |    3 
 mm/swapfile.c                                               |   13 
 net/bridge/br_netfilter_hooks.c                             |    1 
 net/can/j1939/address-claim.c                               |   40 
 net/can/j1939/transport.c                                   |    4 
 net/core/dev.c                                              |    2 
 net/core/filter.c                                           |    3 
 net/dccp/ipv6.c                                             |    7 
 net/ipv6/datagram.c                                         |    2 
 net/ipv6/tcp_ipv6.c                                         |   11 
 net/mpls/af_mpls.c                                          |    4 
 net/netfilter/nft_tproxy.c                                  |    8 
 net/netrom/af_netrom.c                                      |    5 
 net/openvswitch/datapath.c                                  |   12 
 net/rds/message.c                                           |    6 
 net/rose/af_rose.c                                          |    8 
 net/sched/sch_htb.c                                         |    5 
 net/sctp/diag.c                                             |    4 
 net/sunrpc/xprtrdma/verbs.c                                 |    4 
 net/x25/af_x25.c                                            |    6 
 net/xfrm/xfrm_input.c                                       |    3 
 sound/pci/hda/patch_conexant.c                              |    1 
 sound/pci/hda/patch_realtek.c                               |    2 
 sound/pci/hda/patch_via.c                                   |    3 
 sound/pci/lx6464es/lx_core.c                                |   11 
 sound/soc/codecs/cs42l56.c                                  |    6 
 sound/soc/intel/boards/bytcr_rt5651.c                       |    2 
 sound/soc/sof/intel/hda-dai.c                               |    8 
 sound/synth/emux/emux_nrpn.c                                |    3 
 tools/testing/selftests/bpf/verifier/search_pruning.c       |   36 
 tools/testing/selftests/net/fib_tests.sh                    | 1727 ++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh               |    4 
 tools/testing/selftests/net/udpgso_bench.sh                 |   24 
 tools/testing/selftests/net/udpgso_bench_rx.c               |    4 
 tools/testing/selftests/net/udpgso_bench_tx.c               |   36 
 tools/virtio/linux/bug.h                                    |    8 
 tools/virtio/linux/build_bug.h                              |    7 
 tools/virtio/linux/cpumask.h                                |    7 
 tools/virtio/linux/gfp.h                                    |    7 
 tools/virtio/linux/kernel.h                                 |    1 
 tools/virtio/linux/kmsan.h                                  |   12 
 tools/virtio/linux/scatterlist.h                            |    1 
 tools/virtio/linux/topology.h                               |    7 
 177 files changed, 4189 insertions(+), 1339 deletions(-)

Aaron Thompson (1):
      Revert "mm: Always release pages to the buddy allocator in memblock_free_late()."

Al Viro (3):
      WRITE is "data source", not destination...
      fix iov_iter_bvec() "direction" argument
      fix "direction" argument of iov_iter_kvec()

Alan Stern (1):
      net: USB: Fix wrong-direction WARNING in plusb.c

Alexander Egorenkov (2):
      watchdog: diag288_wdt: do not use stack buffers for hardware data
      watchdog: diag288_wdt: fix __diag288() inline assembly

Alexander Potapenko (1):
      btrfs: zlib: zero-initialize zlib workspace

Amit Engel (1):
      nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association

Anand Jain (1):
      btrfs: free device in btrfs_close_devices for a single device filesystem

Andrea Righi (1):
      mm: swap: properly update readahead statistics in unuse_pte_range()

Andreas Kemnade (2):
      iio:adc:twl6030: Enable measurements of VUSB, VBAT and others
      iio:adc:twl6030: Enable measurement of VAC

Andreas Schwab (1):
      riscv: disable generation of unwind tables

Andrei Gherzan (4):
      selftests: net: udpgso_bench_rx: Fix 'used uninitialized' compiler warning
      selftests: net: udpgso_bench_rx/tx: Stop when wrong CLI args are provided
      selftests: net: udpgso_bench: Fix racing bug between the rx/tx programs
      selftests: net: udpgso_bench_tx: Cater for pending datagrams zerocopy benchmarking

Andrew Morton (1):
      revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"

Andrey Konovalov (1):
      net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC

Andy Shevchenko (3):
      ASoC: Intel: bytcr_rt5651: Drop reference count of ACPI device after use
      pinctrl: intel: Restore the pins that used to be in Direct IRQ mode
      nvme-pci: Move enumeration by class to be last in the table

Anirudh Venkataramanan (1):
      ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Anton Gusev (1):
      efi: fix potential NULL deref in efi_mem_reserve_persistent

Ard Biesheuvel (1):
      efi: Accept version 2 of memory attributes table

Arnd Bergmann (1):
      ASoC: cs42l56: fix DT probe

Artemii Karasev (2):
      ALSA: hda/via: Avoid potential array out-of-bound in add_secret_dac_path()
      ALSA: emux: Avoid potential array out-of-bound in snd_emux_xg_control()

Bo Liu (1):
      ALSA: hda/conexant: add a new hda codec SN6180

Brian Foster (1):
      xfs: sync lazy sb accounting on quiesce of read-only mounts

Chao Yu (1):
      f2fs: fix to do sanity check on i_extra_isize in is_alive()

Chris Healy (1):
      net: phy: meson-gxl: Add generic dummy stubs for MMD register access

Christian Hopps (1):
      xfrm: fix bug with DSCP copy to v6 from v4 tunnel

Christoph Hellwig (8):
      xfs: remove the xfs_efi_log_item_t typedef
      xfs: remove the xfs_efd_log_item_t typedef
      xfs: remove the xfs_inode_log_item_t typedef
      xfs: factor out a xfs_defer_create_intent helper
      xfs: merge the ->log_item defer op into ->create_intent
      xfs: merge the ->diff_items defer op into ->create_intent
      xfs: turn dfp_intent into a xfs_log_item
      xfs: refactor xfs_defer_finish_noroll

Cristian Ciocaltea (1):
      net: stmmac: Restrict warning on disabling DMA store and fwd mode

Damien Le Moal (1):
      ata: libata: Fix sata_down_spd_limit() when no link speed is reported

Dan Carpenter (2):
      ALSA: pci: lx6464es: fix a debug loop
      net: sched: sch: Fix off by one in htb_activate_prios()

Darrick J. Wong (15):
      xfs: log new intent items created as part of finishing recovered intent items
      xfs: proper replay of deferred ops queued during log recovery
      xfs: xfs_defer_capture should absorb remaining block reservations
      xfs: xfs_defer_capture should absorb remaining transaction reservation
      xfs: clean up bmap intent item recovery checking
      xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering
      xfs: fix an incore inode UAF in xfs_bui_recover
      xfs: change the order in which child and parent defer ops are finished
      xfs: periodically relog deferred intent items
      xfs: expose the log push threshold
      xfs: only relog deferred intent items if free space in the log gets low
      xfs: fix missing CoW blocks writeback conversion retry
      xfs: ensure inobt record walks always make forward progress
      xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
      xfs: prevent UAF in xfs_log_item_in_current_chkpt

Dave Chinner (1):
      xfs: fix finobt btree block recovery ordering

Dean Luick (1):
      IB/hfi1: Restore allocated resources on failed copyout

Devid Antonio Filoni (1):
      can: j1939: do not wait 250 ms if the same addr was already claimed

Dmitry Perchanov (1):
      iio: hid: fix the retval in accel_3d_capture_sample

Dongliang Mu (1):
      fbdev: smscufx: fix error handling code in ufx_usb_probe

Dragos Tatulea (1):
      IB/IPoIB: Fix legacy IPoIB due to wrong number of queues

Eduard Zingerman (1):
      selftests/bpf: Verify copy_register_state() preserves parent/live fields

Fedor Pchelkin (2):
      squashfs: harden sanity check in squashfs_read_xattr_id_table
      net: openvswitch: fix flow memory leak in ovs_flow_cmd_new

Felix Riemann (1):
      net: Fix unwanted sign extension in netdev_stats_to_stats64()

Florian Westphal (2):
      netfilter: br_netfilter: disable sabotage_in hook after first suppression
      netfilter: nft_tproxy: restrict to prerouting hook

George Kennedy (1):
      vc_screen: move load of struct vc_data pointer in vcs_read() to avoid UAF

Greg Kroah-Hartman (2):
      kvm: initialize all of the kvm_debugregs structure before sending it to userspace
      Linux 5.4.232

Guillaume Nault (2):
      ipv6: Fix datagram socket connection with DSCP.
      ipv6: Fix tcp socket connection with DSCP.

Guo Ren (1):
      riscv: Fixup race condition on PG_dcache_clean in flush_icache_pte

Hangbin Liu (1):
      selftests: forwarding: lib: quote the sysctl values

Heiner Kallweit (4):
      net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY
      arm64: dts: meson-gx: Make mmc host controller interrupts level-sensitive
      arm64: dts: meson-g12-common: Make mmc host controller interrupts level-sensitive
      arm64: dts: meson-axg: Make mmc host controller interrupts level-sensitive

Helge Deller (2):
      parisc: Fix return code of pdc_iodc_print()
      parisc: Wire up PTRACE_GETREGS/PTRACE_SETREGS for compat case

Hyunwoo Kim (3):
      netrom: Fix use-after-free caused by accept on already connected socket
      net/x25: Fix to not accept on connected socket
      net/rose: Fix to not accept on connected socket

Ido Schimmel (1):
      ipv4: Fix incorrect route flushing when source address is deleted

Ilpo Järvinen (2):
      serial: 8250_dma: Fix DMA Rx completion race
      serial: 8250_dma: Fix DMA Rx rearm race

Jakub Kicinski (1):
      net: mpls: fix stale pointer if allocation fails during device rename

Jason Xing (3):
      ixgbe: allow to increase MTU to 3K with XDP enabled
      i40e: add double of VLAN header when computing the max MTU
      ixgbe: add double of VLAN header when computing the max MTU

Joel Stanley (1):
      pinctrl: aspeed: Fix confusing types in return value

Joerg Roedel (1):
      iommu/amd: Pass gfp flags to iommu_map_page() in amd_iommu_map()

Johannes Zink (1):
      net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence

Josef Bacik (1):
      btrfs: limit device extents to the device size

Kailang Yang (1):
      ALSA: hda/realtek - fixed wrong gpio assigned

Kees Cook (1):
      net: sched: sch: Bounds check priority

Kuniyuki Iwashima (1):
      dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.

Longlong Xia (1):
      mm/swapfile: add cond_resched() in get_swap_pages()

Mark Pearson (1):
      usb: core: add quirk for Alcor Link AK9563 smartcard reader

Martin K. Petersen (1):
      scsi: Revert "scsi: core: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT"

Maurizio Lombardi (1):
      scsi: target: core: Fix warning on RT kernels

Maxim Korotkov (1):
      pinctrl: single: fix potential NULL dereference

Michael Chan (1):
      bnxt_en: Fix mqprio and XDP ring checking logic

Michael Ellerman (1):
      powerpc/imc-pmu: Revert nest_init_lock to being a mutex

Michael Walle (1):
      nvmem: core: fix cell removal on error

Mike Christie (1):
      scsi: iscsi_tcp: Fix UAF during login when accessing the shost ipaddress

Mike Kravetz (3):
      mm: hugetlb: proc: check for hugetlb shared PMD in /proc/PID/smaps
      migrate: hugetlb: check for hugetlb shared PMD in node migration
      hugetlb: check for undefined shift on 32 bit architectures

Miko Larsson (1):
      net/usb: kalmia: Don't pass act_len in usb_bulk_msg error path

Minsuk Kang (1):
      wifi: brcmfmac: Check the count value of channel spec to prevent out-of-bounds reads

Munehisa Kamata (1):
      sched/psi: Fix use-after-free in ep_remove_wait_queue()

Natalia Petrova (1):
      i40e: Add checking for null for nlmsg_find_attr()

Neel Patel (1):
      ionic: clean interrupt before enabling queue to avoid credit race

Neil Armstrong (1):
      usb: dwc3: qcom: enable vbus override when in OTG dr-mode

Olivier Moysan (1):
      iio: adc: stm32-dfsdm: fill module aliases

Parav Pandit (1):
      virtio-net: Keep stop() to follow mirror sequence of open()

Phillip Lougher (1):
      Squashfs: fix handling and sanity checking of xattr_ids count

Pierluigi Passaro (1):
      arm64: dts: imx8mm: Fix pad control for UART1_DTE_RX

Pierre-Louis Bossart (1):
      ASoC: SOF: Intel: hda-dai: fix possible stream_tag leak

Pietro Borrello (2):
      rds: rds_rm_zerocopy_callback() use list_first_entry()
      sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list

Prashant Malani (1):
      usb: typec: altmodes/displayport: Fix probe pin assign check

Qi Zheng (1):
      bonding: fix error checking in bond_debug_reregister()

Rafał Miłecki (1):
      net: bgmac: fix BCM5358 support by setting correct flags

Randy Dunlap (1):
      i2c: rk3x: fix a bunch of kernel-doc warnings

Ryusuke Konishi (1):
      nilfs2: fix underflow in second superblock position calculations

Samuel Thibault (1):
      fbcon: Check font dimension limits

Seth Jenkins (1):
      aio: fix mremap after fork null-deref

Shaoying Xu (1):
      Revert "ipv4: Fix incorrect route flushing when source address is deleted"

Shiju Jose (1):
      tracing: Fix poll() and select() do not work on per_cpu trace_pipe and trace_pipe_raw

Shunsuke Mie (1):
      tools/virtio: fix the vringh test for virtio ring changes

Takashi Sakamoto (1):
      firewire: fix memory leak for payload of request subaction to IEC 61883-1 FCP region

Toke Høiland-Jørgensen (1):
      bpf: Always return target ifindex in bpf_fib_lookup

Tom Murphy (1):
      iommu: Add gfp parameter to iommu_ops::map

Udipto Goswami (1):
      usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait

Vasily Gorbik (1):
      s390/decompressor: specify __decompress() buf len to avoid overflow

Werner Sembach (4):
      Input: i8042 - move __initconst to fix code styling warning
      Input: i8042 - merge quirk tables
      Input: i8042 - add TUXEDO devices to i8042 quirk tables
      Input: i8042 - add Clevo PCX0DX to i8042 quirk table

Wesley Cheng (1):
      usb: dwc3: dwc3-qcom: Fix typo in the dwc3 vbus override API

Xiongfeng Wang (1):
      iio: adc: berlin2-adc: Add missing of_node_put() in error path

Xiubo Li (1):
      ceph: flush cap releases when the session is flushed

Yang Yingliang (3):
      RDMA/usnic: use iommu_map_atomic() under spin_lock()
      mmc: sdio: fix possible resource leaks in some error paths
      mmc: mmc_spi: fix error handling in mmc_spi_probe()

Yuan Can (1):
      bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()

Zhang Xiaoxu (1):
      xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()

Zheng Yongjun (1):
      fpga: stratix10-soc: Fix return value check in s10_ops_write_init()

Ziyang Xuan (1):
      can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

