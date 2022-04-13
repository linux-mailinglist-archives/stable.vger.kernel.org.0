Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E9C4FFE60
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 21:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbiDMTFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 15:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbiDMTFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 15:05:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7F76D19A;
        Wed, 13 Apr 2022 12:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 541A5B8275A;
        Wed, 13 Apr 2022 19:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E82BC385A3;
        Wed, 13 Apr 2022 19:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649876562;
        bh=Dnj8s1g2PUuDW5O+4p9+6fANCmizBx37ccuTSRMwTYo=;
        h=From:To:Cc:Subject:Date:From;
        b=atkhsC0wBh7I6Tb3V6Q6fgHxm8Ndwm59vz7uZoYVqKqmC6WT/3QslyU6WLTaycZjf
         ibZcIx3GcSnIujMCiFWu53dR5hwZWb4xMXTVFQ8T4dMTz6/XXO9wfGqrbYUvury/2S
         tFaKQIzc/uv0EjCNpxiTWCqBMlP48zMaqc35BImI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.111
Date:   Wed, 13 Apr 2022 21:02:34 +0200
Message-Id: <16498765548467@kroah.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.111 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arm64/include/asm/cputype.h                               |    2 
 arch/arm64/include/asm/module.lds.h                            |    6 
 arch/arm64/kernel/insn.c                                       |    4 
 arch/arm64/kernel/proton-pack.c                                |    1 
 arch/mips/boot/dts/ingenic/jz4780.dtsi                         |    2 
 arch/mips/include/asm/setup.h                                  |    2 
 arch/mips/kernel/traps.c                                       |   22 -
 arch/mips/ralink/ill_acc.c                                     |    1 
 arch/parisc/kernel/patch.c                                     |   25 -
 arch/powerpc/boot/dts/fsl/t104xrdb.dtsi                        |    4 
 arch/powerpc/include/asm/page.h                                |    6 
 arch/powerpc/kernel/rtas.c                                     |    6 
 arch/powerpc/kernel/secvar-sysfs.c                             |    9 
 arch/powerpc/kexec/core.c                                      |   15 
 arch/x86/Kconfig                                               |    5 
 arch/x86/kvm/emulate.c                                         |    4 
 arch/x86/kvm/kvm_emulate.h                                     |    1 
 arch/x86/kvm/svm/pmu.c                                         |    8 
 arch/x86/kvm/x86.c                                             |    6 
 arch/x86/power/cpu.c                                           |   21 +
 arch/x86/xen/smp_hvm.c                                         |    6 
 arch/x86/xen/time.c                                            |   24 +
 arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi                    |    8 
 arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi                     |    8 
 arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi                      |    4 
 drivers/ata/sata_dwc_460ex.c                                   |    6 
 drivers/block/drbd/drbd_int.h                                  |    8 
 drivers/block/drbd/drbd_nl.c                                   |   41 +-
 drivers/block/drbd/drbd_state.c                                |   18 -
 drivers/block/drbd/drbd_state_change.h                         |    8 
 drivers/char/virtio_console.c                                  |    8 
 drivers/clk/clk-si5341.c                                       |   16 
 drivers/clk/clk.c                                              |   24 +
 drivers/clk/ti/clk.c                                           |   13 
 drivers/dma/sh/shdma-base.c                                    |    4 
 drivers/gpio/gpiolib.c                                         |   19 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c                         |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                     |    3 
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c                          |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c                    |   24 -
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c              |    3 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c           |    8 
 drivers/gpu/drm/drm_panel_orientation_quirks.c                 |    6 
 drivers/gpu/drm/imx/imx-ldb.c                                  |    2 
 drivers/gpu/drm/imx/parallel-display.c                         |    4 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c                |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c                |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c                |    1 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h                 |    1 
 drivers/hv/Kconfig                                             |    1 
 drivers/hv/channel_mgmt.c                                      |    6 
 drivers/hv/vmbus_drv.c                                         |    9 
 drivers/infiniband/hw/hfi1/mmu_rb.c                            |    6 
 drivers/infiniband/hw/mlx5/mr.c                                |    4 
 drivers/infiniband/sw/rdmavt/qp.c                              |    6 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c                    |    1 
 drivers/iommu/omap-iommu.c                                     |    2 
 drivers/irqchip/irq-gic-v3.c                                   |   14 
 drivers/irqchip/irq-gic.c                                      |    6 
 drivers/md/dm-ioctl.c                                          |    2 
 drivers/md/dm-rq.c                                             |    7 
 drivers/md/dm.c                                                |   11 
 drivers/mmc/host/mmci_stm32_sdmmc.c                            |    6 
 drivers/mmc/host/renesas_sdhi_core.c                           |    4 
 drivers/mmc/host/sdhci-xenon.c                                 |   10 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                      |    3 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c              |    4 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c               |    4 
 drivers/net/ethernet/intel/ice/ice.h                           |    2 
 drivers/net/ethernet/intel/ice/ice_lib.c                       |    3 
 drivers/net/ethernet/intel/ice/ice_main.c                      |    4 
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c               |    4 
 drivers/net/ethernet/intel/ice/ice_xsk.c                       |    4 
 drivers/net/ethernet/qlogic/qede/qede_fp.c                     |    3 
 drivers/net/ethernet/sfc/rx_common.c                           |    3 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c          |    3 
 drivers/net/macvtap.c                                          |    6 
 drivers/net/mdio/mdio-mscc-miim.c                              |    6 
 drivers/net/phy/sfp-bus.c                                      |    6 
 drivers/net/tap.c                                              |    3 
 drivers/net/tun.c                                              |    3 
 drivers/net/wireless/ath/ath11k/ahb.c                          |    2 
 drivers/net/wireless/ath/ath11k/mhi.c                          |    2 
 drivers/net/wireless/ath/ath5k/eeprom.c                        |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                  |    5 
 drivers/net/wireless/mediatek/mt76/dma.c                       |    1 
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c                |    2 
 drivers/parisc/dino.c                                          |   41 ++
 drivers/parisc/gsc.c                                           |   31 +
 drivers/parisc/gsc.h                                           |    1 
 drivers/parisc/lasi.c                                          |    7 
 drivers/parisc/wax.c                                           |    7 
 drivers/pci/controller/pci-aardvark.c                          |   16 
 drivers/pci/endpoint/functions/pci-epf-test.c                  |   14 
 drivers/pci/hotplug/pciehp_hpc.c                               |    2 
 drivers/perf/qcom_l2_pmu.c                                     |    6 
 drivers/phy/amlogic/phy-meson8b-usb2.c                         |    5 
 drivers/power/supply/axp20x_battery.c                          |   13 
 drivers/power/supply/axp288_charger.c                          |   14 
 drivers/ptp/ptp_sysfs.c                                        |    4 
 drivers/rtc/rtc-wm8350.c                                       |   11 
 drivers/scsi/aha152x.c                                         |    6 
 drivers/scsi/bfa/bfad_attr.c                                   |   26 -
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c                         |   16 
 drivers/scsi/libfc/fc_exch.c                                   |    1 
 drivers/scsi/mvsas/mv_init.c                                   |    4 
 drivers/scsi/pm8001/pm8001_hwi.c                               |   27 +
 drivers/scsi/pm8001/pm8001_sas.c                               |    2 
 drivers/scsi/pm8001/pm80xx_hwi.c                               |   17 -
 drivers/scsi/zorro7xx.c                                        |    2 
 drivers/spi/spi-bcm-qspi.c                                     |    4 
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c |    6 
 drivers/staging/wfx/main.c                                     |    7 
 drivers/tty/serial/samsung_tty.c                               |    5 
 drivers/usb/dwc3/dwc3-omap.c                                   |    2 
 drivers/usb/gadget/udc/tegra-xudc.c                            |   20 -
 drivers/usb/host/ehci-pci.c                                    |    9 
 drivers/vhost/net.c                                            |    1 
 drivers/w1/slaves/w1_therm.c                                   |    8 
 fs/btrfs/extent_io.h                                           |    2 
 fs/btrfs/inode.c                                               |   22 +
 fs/ceph/dir.c                                                  |   11 
 fs/gfs2/bmap.c                                                 |    2 
 fs/gfs2/file.c                                                 |    3 
 fs/gfs2/inode.c                                                |    2 
 fs/gfs2/rgrp.c                                                 |    7 
 fs/gfs2/rgrp.h                                                 |    2 
 fs/gfs2/super.c                                                |    2 
 fs/io_uring.c                                                  |   23 -
 fs/jfs/inode.c                                                 |    3 
 fs/minix/inode.c                                               |    3 
 fs/nfs/dir.c                                                   |   10 
 fs/nfs/direct.c                                                |   48 +-
 fs/nfs/file.c                                                  |    4 
 fs/nfs/inode.c                                                 |    1 
 fs/nfs/internal.h                                              |   17 +
 fs/nfs/nfs42proc.c                                             |    9 
 fs/nfs/nfs4file.c                                              |    6 
 fs/nfs/nfs4state.c                                             |   12 
 fs/nfs/pagelist.c                                              |   10 
 fs/nfs/pnfs_nfs.c                                              |    8 
 fs/nfs/write.c                                                 |   34 +-
 fs/ubifs/dir.c                                                 |   12 
 include/linux/gpio/driver.h                                    |    9 
 include/linux/ipv6.h                                           |    2 
 include/linux/mmzone.h                                         |   11 
 include/linux/nfs_fs.h                                         |   10 
 include/net/arp.h                                              |    1 
 include/net/bluetooth/bluetooth.h                              |   14 
 include/uapi/linux/bpf.h                                       |    3 
 include/uapi/linux/can/isotp.h                                 |   28 +
 init/main.c                                                    |    6 
 kernel/cgroup/cgroup-v1.c                                      |    7 
 kernel/cgroup/cgroup.c                                         |   17 -
 lib/lz4/lz4_decompress.c                                       |    8 
 lib/test_ubsan.c                                               |   11 
 mm/memory.c                                                    |   25 +
 mm/mempolicy.c                                                 |    1 
 mm/mremap.c                                                    |    3 
 mm/rmap.c                                                      |   25 +
 net/batman-adv/multicast.c                                     |    2 
 net/bluetooth/hci_event.c                                      |    3 
 net/bluetooth/l2cap_core.c                                     |    1 
 net/can/isotp.c                                                |   12 
 net/core/filter.c                                              |   27 +
 net/core/rtnetlink.c                                           |   13 
 net/ipv4/arp.c                                                 |    9 
 net/ipv4/fib_frontend.c                                        |    5 
 net/ipv4/fib_semantics.c                                       |    7 
 net/ipv4/inet_hashtables.c                                     |   53 +--
 net/ipv6/addrconf.c                                            |    4 
 net/ipv6/inet6_hashtables.c                                    |    5 
 net/ipv6/ip6_input.c                                           |    2 
 net/ipv6/ip6mr.c                                               |    8 
 net/ipv6/route.c                                               |    2 
 net/netlabel/netlabel_kapi.c                                   |    2 
 net/openvswitch/actions.c                                      |    2 
 net/openvswitch/flow_netlink.c                                 |   99 +++++-
 net/rxrpc/net_ns.c                                             |    2 
 net/smc/smc_core.c                                             |    2 
 net/sunrpc/clnt.c                                              |    7 
 net/sunrpc/sched.c                                             |   11 
 net/sunrpc/svcsock.c                                           |    4 
 net/sunrpc/xprt.c                                              |   16 
 net/sunrpc/xprtrdma/transport.c                                |    6 
 net/sunrpc/xprtsock.c                                          |   54 ++-
 net/tls/tls_sw.c                                               |    2 
 net/wireless/scan.c                                            |    9 
 scripts/Makefile.ubsan                                         |    1 
 tools/build/feature/Makefile                                   |    9 
 tools/lib/bpf/Makefile                                         |    4 
 tools/perf/Makefile.config                                     |    6 
 tools/perf/arch/arm64/util/arm-spe.c                           |    6 
 tools/perf/perf.c                                              |    2 
 tools/perf/util/session.c                                      |   15 
 tools/perf/util/setup.py                                       |    8 
 tools/testing/selftests/cgroup/cgroup_util.c                   |    6 
 tools/testing/selftests/cgroup/test_core.c                     |  165 ++++++++++
 200 files changed, 1425 insertions(+), 533 deletions(-)

Adam Wujek (1):
      clk: si5341: fix reported clk_rate when output divider is 2

Adrian Hunter (1):
      perf tools: Fix perf's libperf_print callback

Aharon Landau (1):
      RDMA/mlx5: Don't remove cache MRs when a delay is needed

Alex Deucher (2):
      drm/amdkfd: make CRAT table missing message informational only
      drm/amdgpu/smu10: fix SoC/fclk units in auto mode

Alexander Lobakin (1):
      MIPS: fix fortify panic when copying asm exception handlers

Amjad Ouled-Ameur (1):
      phy: amlogic: meson8b-usb2: Use dev_err_probe()

Anatolii Gerasymenko (2):
      ice: Set txq_teid to ICE_INVAL_TEID on ring creation
      ice: Do not skip not enabled queues in ice_vc_dis_qs_msg

Andre Przywara (1):
      irqchip/gic, gic-v3: Prevent GSI to SGI translations

Andrea Parri (Microsoft) (1):
      Drivers: hv: vmbus: Replace smp_store_mb() with virt_store_mb()

Andreas Gruenbacher (2):
      gfs2: Check for active reservation in gfs2_release
      gfs2: gfs2_setattr_size error path fix

Andy Gospodarek (1):
      bnxt_en: reserve space inside receive page for skb_shared_info

Anisse Astier (1):
      drm: Add orientation quirk for GPD Win Max

Arnaldo Carvalho de Melo (4):
      perf build: Don't use -ffat-lto-objects in the python feature test when building with clang-13
      perf python: Fix probing for some clang command line options
      tools build: Filter out options and warnings not supported by clang
      tools build: Use $(shell ) instead of `` to get embedded libperl's ccopts

Avraham Stern (1):
      cfg80211: don't add non transmitted BSS to 6GHz scanned channels

Bob Peterson (1):
      gfs2: Fix gfs2_release for non-writers regression

Chanho Park (1):
      arm64: Add part number for Arm Cortex-A78AE

Chen-Yu Tsai (1):
      net: stmmac: Fix unset max_speed difference between DT and non-DT platforms

ChenXiaoSong (2):
      Revert "NFSv4: Handle the special Linux file open access mode"
      NFSv4: fix open failure with O_ACCMODE flag

Christian Lamparter (1):
      ata: sata_dwc_460ex: Fix crash due to OOB write

Christophe JAILLET (1):
      scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()

Dale Zhao (1):
      drm/amd/display: Add signal type check when verify stream backends same

Damien Le Moal (5):
      scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
      scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
      scsi: pm8001: Fix task leak in pm8001_send_abort_all()
      scsi: pm8001: Fix tag leaks on error
      scsi: pm8001: Fix memory leak in pm8001_chip_fw_flash_update_req()

Dan Carpenter (1):
      drm/amdgpu: fix off by one in amdgpu_gfx_kiq_acquire()

David Ahern (1):
      ipv6: Fix stats accounting in ip6_pkt_drop

Denis Nikitin (1):
      perf session: Remap buf if there is no space for event

Dongli Zhang (1):
      xen: delay xen_hvm_init_time_ops() if kdump is boot on vcpu>=32

Douglas Miller (1):
      RDMA/hfi1: Fix use-after-free bug for mm struct

Dust Li (1):
      net/smc: correct settings of RMB window update limit

Eric Dumazet (2):
      ipv6: make mc_forwarding atomic
      rxrpc: fix a race in rxrpc_exit_net()

Ethan Lien (1):
      btrfs: fix qgroup reserve overflow the qgroup limit

Evgeny Boger (1):
      power: supply: axp20x_battery: properly report current when discharging

Fangrui Song (1):
      arm64: module: remove (NOLOAD) from linker script

Greg Kroah-Hartman (1):
      Linux 5.10.111

Guilherme G. Piccoli (1):
      Drivers: hv: vmbus: Fix potential crash on module unload

Guo Ren (1):
      arm64: patch_text: Fixup last cpu should be master

Guo Xuenan (1):
      lz4: fix LZ4_decompress_safe_partial read out of bound

H. Nikolaus Schaller (1):
      usb: dwc3: omap: fix "unbalanced disables for smps10_out1" on omap5evm

Haimin Zhang (1):
      jfs: prevent NULL deref in diFree

Hangyu Hua (2):
      mips: ralink: fix a refcount leak in ill_acc_of_setup()
      powerpc/secvar: fix refcount leak in format_show()

Hans de Goede (1):
      power: supply: axp288-charger: Set Vhold to 4.4V

Harold Huang (1):
      tuntap: add sanity checks about msg_controllen in sendmsg

Helge Deller (1):
      parisc: Fix CPU affinity for Lasi, WAX and Dino chips

Hou Wenlong (1):
      KVM: x86/emulator: Emulate RDPID only if it is enabled in guest

Hou Zhiqiang (1):
      PCI: endpoint: Fix alignment fault error in copy tests

Ido Schimmel (1):
      ipv4: Invalidate neighbour for broadcast address upon address addition

Ilan Peer (1):
      iwlwifi: mvm: Correctly set fragmented EBS

Ilya Maximets (2):
      net: openvswitch: don't send internal clone attribute to the userspace.
      net: openvswitch: fix leak of nested actions

Ivan Vecera (1):
      ice: Clear default forwarding VSI during VSI release

Jakub Kicinski (2):
      net: account alternate interface name memory
      net: limit altnames to 64k total

Jakub Sitnicki (1):
      bpf: Make dst_port field in struct bpf_sock 16-bit wide

James Clark (1):
      perf: arm-spe: Fix perf report --mem-mode

Jamie Bainbridge (1):
      qede: confirm skb is allocated before using

Jens Axboe (1):
      io_uring: fix race between timeout flush and removal

Jianglei Nie (1):
      scsi: libfc: Fix use after free in fc_exch_abts_resp()

Jiasheng Jiang (2):
      rtc: wm8350: Handle error for wm8350_register_irq
      drm/imx: imx-ldb: Check for null pointer after calling kmemdup

Jim Mattson (1):
      KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs

Jiri Slaby (1):
      serial: samsung_tty: do not unlock port->lock for uart_write_wakeup()

John David Anglin (1):
      parisc: Fix patch code locking and flushing

Jordy Zomer (1):
      dm ioctl: prevent potential spectre v1 gadget

José Expósito (1):
      drm/imx: Fix memory leak in imx_pd_connector_get_modes

Kaiwen Hu (1):
      btrfs: prevent subvol with swapfile from being deleted

Kalle Valo (1):
      ath11k: mhi: use mhi_sync_power_up()

Kamal Dasu (1):
      spi: bcm-qspi: fix MSPI only access with bcm_qspi_exec_mem_op()

Karol Herbst (1):
      drm/nouveau/pmu: Add missing callbacks for Tegra devices

Kees Cook (1):
      ubsan: remove CONFIG_UBSAN_OBJECT_SIZE

Kefeng Wang (1):
      powerpc: Fix virt_addr_valid() for 64-bit Book3E & 32-bit

Krzysztof Kozlowski (1):
      MIPS: ingenic: correct unit node address

Lee Jones (1):
      drm/amdkfd: Create file descriptor after client is added to smi_clients list

Li Chen (1):
      PCI: endpoint: Fix misused goto label

Lorenzo Bianconi (1):
      mt76: dma: initialize skip_unmap in mt76_dma_rx_fill

Lucas Denefle (1):
      w1: w1_therm: fixes w1_seq for ds28ea00 sensors

Luiz Augusto von Dentz (2):
      Bluetooth: Fix not checking for valid hdev on bt_dev_{info,warn,err,dbg}
      Bluetooth: Fix use after free in hci_send_acl

Lv Yunlong (1):
      drbd: Fix five use after free bugs in get_initial_state

Maciej Fijalkowski (1):
      ice: synchronize_rcu() when terminating rings

Manivannan Sadhasivam (1):
      PCI: pciehp: Add Qualcomm quirk for Command Completed erratum

Marc Zyngier (1):
      irqchip/gic-v3: Fix GICR_CTLR.RWP polling

Martin Habets (1):
      sfc: Do not free an empty page_ring

Mauricio Faria de Oliveira (1):
      mm: fix race between MADV_FREE reclaim and blkdev direct IO read

Max Filippov (1):
      xtensa: fix DTC warning unit_address_format

Maxim Kiselev (1):
      powerpc: dts: t104xrdb: fix phy type for FMAN 4/5

Maxim Mikityanskiy (1):
      bpf: Support dual-stack sockets in bpf_tcp_check_syncookie

Maxime Ripard (1):
      clk: Enforce that disjoints limits are invalid

Miaohe Lin (1):
      mm/mempolicy: fix mpol_new leak in shared_policy_replace

Miaoqian Lin (1):
      dpaa2-ptp: Fix refcount leak in dpaa2_ptp_probe

Michael Chan (1):
      bnxt_en: Eliminate unintended link toggle during FW reset

Michael Walle (2):
      net: sfp: add 2500base-X quirk for Lantech SFP module
      net: phy: mscc-miim: reject clause 45 register accesses

Mike Snitzer (1):
      dm: requeue IO if mapping table not yet available

Minghao Chi (CGEL ZTE) (1):
      Bluetooth: use memset avoid memory leaks

Nathan Chancellor (1):
      x86/Kconfig: Do not allow CONFIG_X86_X32_ABI=y with llvm-objcopy

Neal Liu (1):
      usb: ehci: add pci device support for Aspeed platforms

NeilBrown (5):
      SUNRPC/call_alloc: async tasks mustn't block waiting for memory
      SUNRPC/xprt: async tasks mustn't block waiting for memory
      SUNRPC: remove scheduling boost for "SWAPPER" tasks.
      NFS: swap IO handling is slightly different for O_DIRECT IO
      NFS: swap-out must always use STABLE writes.

Niels Dossche (1):
      IB/rdmavt: add lock to call to rvt_error_qp to prevent a race condition

Nikolay Aleksandrov (1):
      net: ipv4: fix route with nexthop object delete warning

Oliver Hartkopp (1):
      can: isotp: set default value for N_As to 50 micro seconds

Pali Rohár (2):
      PCI: aardvark: Fix support for MSI interrupts
      Revert "mmc: sdhci-xenon: fix annoying 1.8V regulator warning"

Paolo Bonzini (1):
      mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

Pavel Begunkov (1):
      io_uring: don't touch scm_fp_list after queueing skb

Pawan Gupta (2):
      x86/pm: Save the MSR validity status at context setup
      x86/speculation: Restore speculation related MSRs during S3 resume

Peter Xu (1):
      mm: don't skip swap entry even if zap_details specified

Qi Liu (1):
      scsi: hisi_sas: Free irq vectors in order for v3 HW

Qinghua Jin (1):
      minix: fix bug when opening a file with O_DIRECT

Rajneesh Bhardwaj (1):
      drm/amdgpu: Fix recursive locking warning

Randy Dunlap (3):
      scsi: aha152x: Fix aha152x_setup() __setup handler return value
      init/main.c: return 1 from handled __setup() functions
      virtio_console: eliminate anonymous module_init & module_exit

Sachin Sant (1):
      selftests/cgroup: Fix build on older distros

Sasha Levin (1):
      Revert "hv: utils: add PTP_1588_CLOCK to Kconfig to fix build"

Sebastian Andrzej Siewior (1):
      tcp: Don't acquire inet_listen_hashbucket::lock with disabled BH.

Shreeya Patel (1):
      gpio: Restrict usage of GPIO chip irq members before initialization

Sourabh Jain (1):
      powerpc: Set crashkernel offset to mid of RMA region

Stefan Wahren (1):
      staging: vchiq_core: handle NULL result of find_service_by_handle

Sven Eckelmann (1):
      macvtap: advertise link netns via netlink

Tejun Heo (4):
      cgroup: Use open-time credentials for process migraton perm checks
      selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644
      selftests: cgroup: Test open-time credential usage for migration checks
      selftests: cgroup: Test open-time cgroup namespace usage for migration checks

Tony Lindgren (2):
      clk: ti: Preserve node in ti_dt_clocks_register()
      iommu/omap: Fix regression in probe for NULL pointer dereference

Trond Myklebust (7):
      NFSv4: Protect the state recovery thread against direct reclaim
      SUNRPC: Fix socket waits for write buffer space
      NFS: nfsiod should not block forever in mempool_alloc()
      NFS: Avoid writeback threads getting stuck in mempool_alloc()
      SUNRPC: Handle ENOMEM in call_transmit_status()
      SUNRPC: Handle low memory situations in call_status()
      SUNRPC: svc_tcp_sendmsg() should handle errors from xdr_alloc_bvec()

Venkateswara Naralasetty (1):
      ath11k: fix kernel panic during unload/load ath11k modules

Vinod Koul (1):
      dmaengine: Revert "dmaengine: shdma: Fix runtime PM imbalance on error"

Waiman Long (1):
      mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

Wang Yufen (1):
      netlabel: fix out-of-bounds memory accesses

Wayne Chang (2):
      usb: gadget: tegra-xudc: Do not program SPARAM
      usb: gadget: tegra-xudc: Fix control endpoint's definitions

Wolfram Sang (1):
      mmc: renesas_sdhi: don't overwrite TAP settings when HS400 tuning is complete

Xiaoke Wang (1):
      staging: wfx: fix an error handling in wfx_init_common()

Xiaomeng Tong (1):
      perf: qcom_l2_pmu: fix an incorrect NULL check on list iterator

Xin Xiong (2):
      drm/amd/amdgpu/amdgpu_cs: fix refcount leak of a dma_fence obj
      NFSv4.2: fix reference count leaks in _nfs42_proc_copy_notify()

Xiubo Li (1):
      ceph: fix memory leak in ceph_readdir when note_last_dentry returns error

Yang Guang (3):
      ptp: replace snprintf with sysfs_emit
      scsi: mvsas: Replace snprintf() with sysfs_emit()
      scsi: bfa: Replace snprintf() with sysfs_emit()

Yang Li (1):
      mt76: mt7615: Fix assigning negative values to unsigned variable

Yann Gautier (1):
      mmc: mmci: stm32: correctly check all elements of sg list

Yonghong Song (1):
      libbpf: Fix build issue with llvm-readelf

Zekun Shen (1):
      ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

Zhihao Cheng (1):
      ubifs: Rectify space amount budget for mkdir/tmpfile operations

Zhou Guanghui (1):
      iommu/arm-smmu-v3: fix event handling soft lockup

Ziyang Xuan (1):
      net/tls: fix slab-out-of-bounds bug in decrypt_internal

