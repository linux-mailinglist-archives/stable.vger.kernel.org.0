Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708BC6D940E
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 12:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbjDFK3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 06:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbjDFK3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 06:29:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF713C0B;
        Thu,  6 Apr 2023 03:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D87062AE5;
        Thu,  6 Apr 2023 10:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B916C4339B;
        Thu,  6 Apr 2023 10:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680776951;
        bh=y/VF2gcIebe+fV0rqrrXMVH8JC34a5fYEdjaO6CQ7Qk=;
        h=From:To:Cc:Subject:Date:From;
        b=E6YFlzqXXRStCVkzh9Gq01j0+QiiAMAOu+hj1vlLnzYj2agEB8roR5gRqfUG6P8FG
         yBiiNfbT0vffKQ0nJjrsnj17RVrAP/5lcwlyLFhEMqYguYTK35mLvRC2gKdD+QQh7j
         cNZyH1xYGcdhu2eaoC9tnBx7aBmmeeibPAJyt6Xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.2.10
Date:   Thu,  6 Apr 2023 12:29:04 +0200
Message-Id: <2023040603-prologue-magnetic-a058@gregkh>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.2.10 kernel.

All users of the 6.2 kernel series must upgrade.

The updated 6.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/mtd/jedec,spi-nor.yaml             |    7 
 Makefile                                                             |    2 
 arch/arm64/kvm/mmu.c                                                 |   99 
 arch/arm64/kvm/pmu-emul.c                                            |    3 
 arch/arm64/kvm/sys_regs.c                                            |   21 
 arch/mips/bmips/dma.c                                                |    5 
 arch/mips/bmips/setup.c                                              |    8 
 arch/powerpc/include/asm/book3s/64/tlbflush.h                        |    9 
 arch/powerpc/kernel/ptrace/ptrace-view.c                             |    6 
 arch/powerpc/platforms/pseries/vas.c                                 |    8 
 arch/riscv/kvm/vcpu_timer.c                                          |    6 
 arch/s390/Makefile                                                   |    2 
 arch/s390/lib/uaccess.c                                              |    2 
 arch/x86/xen/Makefile                                                |    2 
 arch/x86/xen/enlighten_pv.c                                          |    3 
 arch/x86/xen/enlighten_pvh.c                                         |   13 
 arch/x86/xen/vga.c                                                   |    5 
 arch/x86/xen/xen-ops.h                                               |    7 
 arch/xtensa/kernel/traps.c                                           |   16 
 drivers/acpi/bus.c                                                   |   83 
 drivers/acpi/video_detect.c                                          |    7 
 drivers/acpi/x86/utils.c                                             |   45 
 drivers/block/loop.c                                                 |   18 
 drivers/gpio/gpiolib-acpi.c                                          |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c                             |    7 
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h                             |    4 
 drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h                          |    3 
 drivers/gpu/drm/amd/amdgpu/soc21.c                                   |  103 
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c                             |   16 
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c                             |   33 
 drivers/gpu/drm/amd/amdkfd/kfd_module.c                              |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h                                |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_process.c                             |   67 
 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c               |    4 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c               |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c          |   51 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h          |   15 
 drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c                          |   10 
 drivers/gpu/drm/i915/display/intel_color.c                           |   44 
 drivers/gpu/drm/i915/display/intel_display.c                         |   28 
 drivers/gpu/drm/i915/display/intel_dpt.c                             |    2 
 drivers/gpu/drm/i915/display/intel_tc.c                              |    4 
 drivers/gpu/drm/i915/gem/i915_gem_lmem.c                             |    3 
 drivers/gpu/drm/i915/gem/i915_gem_object.h                           |    2 
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h                     |    3 
 drivers/gpu/drm/i915/gt/intel_rps.c                                  |   38 
 drivers/gpu/drm/i915/gt/intel_rps.h                                  |    4 
 drivers/gpu/drm/i915/i915_perf.c                                     |   14 
 drivers/gpu/drm/i915/i915_perf_types.h                               |    6 
 drivers/gpu/drm/i915/i915_pmu.c                                      |   10 
 drivers/gpu/drm/nouveau/nouveau_backlight.c                          |    7 
 drivers/idle/intel_idle.c                                            |    8 
 drivers/input/joystick/xpad.c                                        |    7 
 drivers/input/mouse/alps.c                                           |   16 
 drivers/input/mouse/focaltech.c                                      |    8 
 drivers/input/serio/i8042-acpipnpio.h                                |   36 
 drivers/input/touchscreen/goodix.c                                   |   14 
 drivers/iommu/intel/dmar.c                                           |    3 
 drivers/md/dm.c                                                      |    2 
 drivers/md/md.c                                                      |    3 
 drivers/media/platform/qcom/venus/firmware.c                         |    4 
 drivers/mtd/nand/ecc-mxic.c                                          |    1 
 drivers/mtd/nand/raw/meson_nand.c                                    |   10 
 drivers/net/dsa/microchip/ksz8795.c                                  |   11 
 drivers/net/dsa/microchip/ksz8863_smi.c                              |    9 
 drivers/net/dsa/microchip/ksz_common.c                               |   12 
 drivers/net/dsa/mv88e6xxx/chip.c                                     |    9 
 drivers/net/dsa/realtek/realtek-mdio.c                               |    5 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                      |   16 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                            |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                            |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                    |    3 
 drivers/net/ethernet/intel/i40e/i40e_diag.c                          |   11 
 drivers/net/ethernet/intel/i40e/i40e_diag.h                          |    2 
 drivers/net/ethernet/intel/ice/ice_sched.c                           |    8 
 drivers/net/ethernet/intel/ice/ice_switch.c                          |   26 
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c                   |   73 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c                       |   30 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c                       |   86 
 drivers/net/ethernet/mediatek/mtk_eth_soc.c                          |    8 
 drivers/net/ethernet/mediatek/mtk_ppe.c                              |    6 
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c                      |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                    |   10 
 drivers/net/ethernet/realtek/r8169_phy_config.c                      |    3 
 drivers/net/ethernet/sfc/ef10.c                                      |   38 
 drivers/net/ethernet/sfc/efx.c                                       |   17 
 drivers/net/ethernet/smsc/smsc911x.c                                 |    7 
 drivers/net/ethernet/stmicro/stmmac/common.h                         |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c                    |   61 
 drivers/net/ieee802154/ca8210.c                                      |    3 
 drivers/net/ipa/gsi_trans.c                                          |    2 
 drivers/net/net_failover.c                                           |    8 
 drivers/net/phy/dp83869.c                                            |    6 
 drivers/net/vmxnet3/vmxnet3_drv.c                                    |    4 
 drivers/net/wwan/iosm/iosm_ipc_imem.c                                |    7 
 drivers/net/xen-netback/common.h                                     |    2 
 drivers/net/xen-netback/netback.c                                    |   25 
 drivers/nvme/host/pci.c                                              |    3 
 drivers/pci/controller/dwc/pcie-designware.c                         |   10 
 drivers/pinctrl/pinctrl-amd.c                                        |   36 
 drivers/pinctrl/pinctrl-at91-pio4.c                                  |    1 
 drivers/pinctrl/pinctrl-ocelot.c                                     |    2 
 drivers/platform/surface/aggregator/bus.c                            |    4 
 drivers/platform/x86/ideapad-laptop.c                                |   23 
 drivers/platform/x86/intel/pmc/core.c                                |   13 
 drivers/platform/x86/think-lmi.c                                     |   60 
 drivers/ptp/ptp_qoriq.c                                              |    2 
 drivers/regulator/fixed.c                                            |    2 
 drivers/s390/crypto/vfio_ap_drv.c                                    |    3 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                          |    4 
 drivers/scsi/mpt3sas/mpt3sas_base.c                                  |    5 
 drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c |    1 
 drivers/thunderbolt/quirks.c                                         |   31 
 drivers/thunderbolt/tb.h                                             |    3 
 drivers/thunderbolt/usb4.c                                           |   17 
 drivers/usb/typec/ucsi/ucsi.c                                        |   22 
 drivers/video/fbdev/au1200fb.c                                       |    3 
 drivers/video/fbdev/geode/lxfb_core.c                                |    3 
 drivers/video/fbdev/intelfb/intelfbdrv.c                             |    3 
 drivers/video/fbdev/nvidia/nvidia.c                                  |    2 
 drivers/video/fbdev/tgafb.c                                          |    3 
 fs/btrfs/backref.c                                                   |   85 
 fs/btrfs/block-group.c                                               |   30 
 fs/btrfs/free-space-cache.c                                          |    8 
 fs/btrfs/fs.h                                                        |    7 
 fs/btrfs/ioctl.c                                                     |    2 
 fs/btrfs/qgroup.c                                                    |   11 
 fs/btrfs/space-info.c                                                |   42 
 fs/btrfs/space-info.h                                                |    2 
 fs/btrfs/transaction.c                                               |   15 
 fs/btrfs/volumes.c                                                   |   20 
 fs/btrfs/zoned.c                                                     |   31 
 fs/cifs/cifsfs.h                                                     |    5 
 fs/cifs/cifsproto.h                                                  |    1 
 fs/cifs/cifssmb.c                                                    |   52 
 fs/cifs/connect.c                                                    |   64 
 fs/cifs/misc.c                                                       |   44 
 fs/cifs/smb2pdu.c                                                    |  132 
 fs/cifs/smb2transport.c                                              |   17 
 fs/nfs/nfs4proc.c                                                    |    5 
 fs/verity/enable.c                                                   |   24 
 fs/zonefs/Makefile                                                   |    2 
 fs/zonefs/file.c                                                     |  902 +++++
 fs/zonefs/super.c                                                    | 1640 ++--------
 fs/zonefs/trace.h                                                    |   20 
 fs/zonefs/zonefs.h                                                   |  100 
 include/acpi/acpi_bus.h                                              |    5 
 include/trace/events/rcu.h                                           |    2 
 include/xen/interface/platform.h                                     |    3 
 io_uring/alloc_cache.h                                               |    1 
 io_uring/poll.c                                                      |    1 
 io_uring/rsrc.h                                                      |   12 
 kernel/compat.c                                                      |    2 
 kernel/sched/core.c                                                  |    4 
 kernel/trace/kprobe_event_gen_test.c                                 |    4 
 lib/zstd/common/zstd_deps.h                                          |    2 
 lib/zstd/decompress/zstd_decompress.c                                |   25 
 net/can/bcm.c                                                        |   16 
 net/can/j1939/transport.c                                            |    8 
 net/dsa/slave.c                                                      |  121 
 net/hsr/hsr_framereg.c                                               |    2 
 net/mac80211/cfg.c                                                   |   21 
 net/sunrpc/xprtsock.c                                                |    1 
 net/xfrm/xfrm_user.c                                                 |   45 
 scripts/mod/modpost.c                                                |    2 
 sound/core/pcm_lib.c                                                 |    2 
 sound/pci/asihpi/hpi6205.c                                           |    2 
 sound/pci/hda/patch_ca0132.c                                         |    4 
 sound/pci/hda/patch_conexant.c                                       |    6 
 sound/pci/hda/patch_realtek.c                                        |    5 
 sound/pci/ymfpci/ymfpci.c                                            |    2 
 sound/pci/ymfpci/ymfpci_main.c                                       |    2 
 sound/soc/codecs/hdmi-codec.c                                        |   11 
 sound/soc/codecs/lpass-tx-macro.c                                    |   11 
 sound/soc/intel/avs/boards/da7219.c                                  |   21 
 sound/soc/intel/avs/boards/max98357a.c                               |   22 
 sound/soc/intel/avs/boards/nau8825.c                                 |   14 
 sound/soc/intel/avs/boards/rt5682.c                                  |   22 
 sound/soc/intel/avs/boards/ssm4567.c                                 |   31 
 sound/soc/sof/intel/hda-ctrl.c                                       |    3 
 sound/soc/sof/intel/hda-dsp.c                                        |   12 
 sound/soc/sof/intel/pci-tng.c                                        |    6 
 sound/soc/sof/ipc3.c                                                 |    5 
 sound/soc/sof/ipc4-control.c                                         |    3 
 sound/soc/sof/ipc4-topology.c                                        |    6 
 sound/soc/sof/ipc4-topology.h                                        |    6 
 sound/usb/endpoint.c                                                 |   22 
 sound/usb/endpoint.h                                                 |    4 
 sound/usb/format.c                                                   |    8 
 sound/usb/pcm.c                                                      |    2 
 tools/lib/bpf/btf_dump.c                                             |  154 
 tools/power/acpi/tools/pfrut/pfrut.c                                 |   18 
 tools/power/x86/turbostat/turbostat.8                                |    2 
 tools/power/x86/turbostat/turbostat.c                                |    4 
 tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c     |    2 
 tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c       |   80 
 tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c       |  162 
 197 files changed, 3762 insertions(+), 2181 deletions(-)

Adham Faris (1):
      net/mlx5e: Lower maximum allowed MTU in XSK to match XDP prerequisites

Ahmad Fatoum (1):
      net: dsa: realtek: fix out-of-bounds access

Alex Elder (1):
      net: ipa: compute DMA pool size properly

Alyssa Ross (1):
      loop: LOOP_CONFIGURE: send uevents for partitions

Amadeusz Sławiński (3):
      ASoC: Intel: avs: max98357a: Explicitly define codec format
      ASoC: Intel: avs: da7219: Explicitly define codec format
      ASoC: Intel: avs: rt5682: Explicitly define codec format

Anand Jain (1):
      btrfs: scan device in non-exclusive mode

Andrii Nakryiko (3):
      libbpf: Fix BTF-to-C converter's padding logic
      selftests/bpf: Add few corner cases to test padding handling of btf_dump
      libbpf: Fix btf_dump's packed struct determination

Anton Gusev (1):
      tracing: Fix wrong return in kprobe_event_gen_test.c

Antti Laakso (1):
      tools/power turbostat: fix decoding of HWP_STATUS

Arseniy Krasnov (2):
      mtd: rawnand: meson: initialize struct with zeroes
      mtd: rawnand: meson: invalidate cache on polling ECC bit

Ashutosh Dixit (1):
      drm/i915/pmu: Use functions common with sysfs to read actual freq

Ben Hutchings (1):
      modpost: Fix processing of CRCs on 32-bit build machines

Benjamin Gray (1):
      powerpc/64s: Fix __pte_needs_flush() false positive warning

Bhawanpreet Lakha (1):
      drm/amd/display: Fix HDCP failing to enable after suspend

Brett Creeley (1):
      ice: Fix ice_cfg_rdma_fltr() to only update relevant fields

Cezary Rojewski (2):
      ASoC: Intel: avs: ssm4567: Remove nau8825 bits
      ASoC: Intel: avs: nau8825: Adjust clock control

Chen Yu (1):
      ACPI: tools: pfrut: Check if the input of level and type is in the right numeric range

Chia-I Wu (2):
      drm/amdkfd: fix a potential double free in pqm_create_queue
      drm/amdkfd: fix potential kgd_mem UAFs

Chia-Lin Kao (AceLan) (1):
      ACPI: video: Add backlight=native DMI quirk for Dell Vostro 15 3535

Chris Wilson (2):
      drm/i915/perf: Drop wakeref on GuC RC error
      drm/i915/gem: Flush lmem contents after construction

Christophe JAILLET (2):
      mtd: nand: mxic-ecc: Fix mxic_ecc_data_xfer_wait_for_completion() when irq is used
      regulator: Handle deferred clk

ChunHao Lin (1):
      r8169: fix RTL8168H and RTL8107E rx crc error

Damien Le Moal (7):
      zonefs: Reorganize code
      zonefs: Simplify IO error handling
      zonefs: Reduce struct zonefs_inode_info size
      zonefs: Separate zone information from inode information
      zonefs: Fix error message in zonefs_file_dio_append()
      zonefs: Do not propagate iomap_dio_rw() ENOTBLK error to user space
      zonefs: Always invalidate last cached page on append write

David Belanger (1):
      drm/amdkfd: Fixed kfd_process cleanup on module exit.

David Disseldorp (1):
      cifs: fix DFS traversal oops without CONFIG_CIFS_DFS_UPCALL

David Matlack (1):
      KVM: arm64: Retry fault if vma_lookup() results become invalid

Douglas Raillard (1):
      rcu: Fix rcu_torture_read ftrace event

Emil Abildgaard Svendsen (1):
      ASoC: hdmi-codec: only startup/shutdown on supported streams

Eric Biggers (1):
      fsverity: don't drop pagecache at end of FS_IOC_ENABLE_VERITY

Faicker Mo (1):
      net/net_failover: fix txq exceeding warning

Fangzhi Zuo (2):
      drm/amd/display: Add DSC Support for Synaptics Cascaded MST Hub
      drm/amd/display: Take FEC Overhead into Timeslot Calculation

Felix Fietkau (4):
      net: ethernet: mtk_eth_soc: fix tx throughput regression with direct 1G links
      net: ethernet: mtk_eth_soc: fix flow block refcounting logic
      net: ethernet: mtk_eth_soc: fix L2 offloading with DSA untag offload
      net: ethernet: mtk_eth_soc: add missing ppe cache flush when deleting a flow

Filipe Manana (3):
      btrfs: fix deadlock when aborting transaction during relocation with scrub
      btrfs: fix race between quota disable and quota assign ioctls
      btrfs: ignore fiemap path cache when there are multiple paths for a node

Geert Uytterhoeven (1):
      dt-bindings: mtd: jedec,spi-nor: Document CPOL/CPHA support

Gil Fine (1):
      thunderbolt: Limit USB3 bandwidth of certain Intel USB4 host routers

Greg Kroah-Hartman (1):
      Linux 6.2.10

Hans de Goede (7):
      ACPI: x86: Introduce an acpi_quirk_skip_gpio_event_handlers() helper
      ACPI: x86: Add skip i2c clients quirk for Acer Iconia One 7 B1-750
      ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Book X90
      drm/nouveau/kms: Fix backlight registration
      Input: goodix - add Lenovo Yoga Book X90F to nine_bytes_report DMI table
      platform/x86: ideapad-laptop: Stop sending KEY_TOUCHPAD_TOGGLE
      usb: ucsi: Fix ucsi->connector race

Haren Myneni (1):
      powerpc/pseries/vas: Ignore VAS update for DLPAR if copy/paste is not enabled

Harshit Mogalapalli (1):
      ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()

Heiko Carstens (1):
      s390/uaccess: add missing earlyclobber annotations to __clear_user()

Herbert Xu (1):
      xfrm: Zero padding when dumping algos and encap

Horatiu Vultur (1):
      pinctrl: ocelot: Fix alt mode for ocelot

Imre Deak (1):
      drm/i915/tc: Fix the ICL PHY ownership check in TC-cold state

Irvin Cote (1):
      nvme-pci: fixing memory leak in probe teardown path

Ivan Orlov (1):
      can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Jakob Koschel (1):
      ice: fix invalid check for empty list in ice_sched_assoc_vsi_to_agg()

Jakub Kicinski (1):
      bnx2x: use the right build_skb() helper

Jan Beulich (2):
      x86/PVH: obtain VGA console info in Dom0
      x86/PVH: avoid 32-bit build warning when obtaining VGA console info

Jane Jian (1):
      drm/amdgpu/vcn: custom video info caps for sriov

Jason A. Donenfeld (1):
      Input: focaltech - use explicitly signed char type

Javier Martinez Canillas (1):
      Revert "venus: firmware: Correct non-pix start and end addresses"

Jens Axboe (2):
      io_uring/poll: clear single/double poll flags on poll arming
      powerpc: Don't try to copy PPR for task with NULL pt_regs

Jerry Snitselaar (1):
      scsi: mpt3sas: Don't print sense pool info twice

Jiri Slaby (SUSE) (1):
      s390: reintroduce expoline dependence to scripts

Johan Hovold (1):
      pinctrl: at91-pio4: fix domain name assignment

Johannes Berg (1):
      wifi: mac80211: check basic rates validity

Jonathan Denose (1):
      Input: i8042 - add quirk for Fujitsu Lifebook A574/H

Jonathan Neuschäfer (1):
      zstd: Fix definition of assert()

Josef Bacik (3):
      btrfs: rename BTRFS_FS_NO_OVERCOMMIT to BTRFS_FS_ACTIVE_ZONE_TRACKING
      btrfs: fix uninitialized variable warning in btrfs_update_block_group
      btrfs: use temporary variable for space_info in btrfs_update_block_group

Josua Mayer (1):
      net: phy: dp83869: fix default value for tx-/rx-internal-delay

Juergen Gross (1):
      xen/netback: don't do grant copy across page boundary

Junfeng Guo (1):
      ice: add profile conflict check for AVF FDIR

Kalesh AP (2):
      bnxt_en: Fix reporting of test result in ethtool selftest
      bnxt_en: Fix typo in PCI id to device description string mapping

Kornel Dulęba (1):
      pinctrl: amd: Disable and mask interrupts on resume

Kristian Overskeid (1):
      net: hsr: Don't log netdev_err message on unknown prp dst node

Kuninori Morimoto (2):
      ALSA: asihpi: check pao in control_message()
      ALSA: hda/ca0132: fixup buffer overrun at tuning_ctl_set()

Liang He (1):
      platform/surface: aggregator: Add missing fwnode_handle_put()

Linus Torvalds (1):
      sched_getaffinity: don't assume 'cpumask_size()' is fully initialized

Lu Baolu (1):
      iommu/vt-d: Allow zero SAGAW if second-stage not supported

Lucas Stach (1):
      drm/etnaviv: fix reference leak when mmaping imported buffer

M Chetan Kumar (1):
      net: wwan: iosm: fixes 7560 modem crash

Marc Zyngier (2):
      KVM: arm64: Disable interrupts while walking userspace PTs
      KVM: arm64: Check for kvm_vma_mte_allowed in the critical section

Mark Pearson (4):
      platform/x86: think-lmi: add missing type attribute
      platform/x86: think-lmi: use correct possible_values delimiters
      platform/x86: think-lmi: only display possible_values if available
      platform/x86: think-lmi: Add possible_values for ThinkStation

Matthias Benkmann (1):
      Input: xpad - fix incorrectly applied patch for MAP_PROFILE_BUTTON

Matthieu Baerts (1):
      hsr: ratelimit only when errors are printed

Max Filippov (1):
      xtensa: fix KASAN report for show_stack

Michael Chan (1):
      bnxt_en: Add missing 200G link speed reporting

Mike Snitzer (1):
      dm: fix __send_duplicate_bios() to always allow for splitting IO

Naohiro Aota (2):
      btrfs: zoned: count fresh BG region as zone unusable
      btrfs: zoned: drop space_info->active_total_bytes

NeilBrown (1):
      md: avoid signed overflow in slot_store()

Nick Terrell (1):
      lib: zstd: Backport fix for in-place decompression

Oleksij Rempel (7):
      net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
      net: dsa: microchip: ksz8: fix ksz8_fdb_dump() to extract all 1024 entries
      net: dsa: microchip: ksz8: fix offset for the timestamp filed
      net: dsa: microchip: ksz8: ksz8_fdb_dump: avoid extracting ghost entry from empty dynamic MAC table.
      net: dsa: microchip: ksz8863_smi: fix bulk access
      net: dsa: microchip: ksz8: fix MDB configuration with non-zero VID
      can: j1939: prevent deadlock by moving j1939_sk_errqueue()

Paulo Alcantara (3):
      cifs: prevent data race in cifs_reconnect_tcon()
      cifs: fix missing unload_nls() in smb2_reconnect()
      cifs: prevent infinite recursion in CIFSGetDFSRefer()

Pavel Begunkov (2):
      io_uring/rsrc: fix rogue rsrc node grabbing
      io_uring: fix poll/netmsg alloc caches

Peter Ujfalusi (1):
      ASoC: SOF: ipc3: Check for upper size limit for the received message

Philipp Geulen (1):
      nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM620

Pierre-Louis Bossart (2):
      ASoC: SOF: Intel: pci-tng: revert invalid bar size setting
      ASoC: SOF: Intel: hda-ctrl: re-add sleep after entering and exiting reset

Prarit Bhargava (1):
      tools/power turbostat: Fix /dev/cpu_dma_latency warnings

Radoslaw Tyl (1):
      i40e: fix registers dump after run ethtool adapter self test

Rafael J. Wysocki (1):
      ACPI: bus: Rework system-level device notification handling

Rajnesh Kanwal (1):
      riscv/kvm: Fix VM hang in case of timer delta being zero.

Rajvi Jingar (1):
      platform/x86/intel/pmc: Alder Lake PCH slp_s0_residency fix

Rander Wang (2):
      ASoC: SOF: Intel: hda-dsp: harden D0i3 programming sequence
      ASoC: SOF: IPC4: update gain ipc msg definition to align with fw

Ravulapati Vishnu Vardhan Rao (1):
      ASoC: codecs: tx-macro: Fix for KASAN: slab-out-of-bounds

Reiji Watanabe (2):
      KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
      KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

Ronak Doshi (1):
      vmxnet3: use gro callback when UPT is enabled

Sasha Levin (1):
      Revert "cpuidle, intel_idle: Fix CPUIDLE_FLAG_IRQ_ENABLE *again*"

Seppo Ingalsuo (1):
      ASoC: SOF: ipc4-topology: Fix incorrect sample rate print unit

Shyam Prasad N (2):
      cifs: update ip_addr for ses only for primary chan setup
      cifs: avoid race conditions with parallel reconnects

Siddharth Kawar (1):
      SUNRPC: fix shutdown of NFS TCP client socket

SongJingyi (1):
      ptp_qoriq: fix memory leak in probe()

Srinivas Pandruvada (1):
      thermal: intel: int340x: processor_thermal: Fix additional deadlock

Steffen Bätz (1):
      net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only

Sven Auhagen (3):
      net: mvpp2: classifier flow fix fragmentation flags
      net: mvpp2: parser fix QinQ
      net: mvpp2: parser fix PPPoE

Takashi Iwai (3):
      ALSA: usb-audio: Fix recursive locking at XRUN during syncing
      ALSA: hda/conexant: Partial revert of a quirk for Lenovo
      ALSA: usb-audio: Fix regression on detection of Roland VS-100

Tasos Sahanidis (2):
      ALSA: ymfpci: Create card with device-managed snd_devm_card_new()
      ALSA: ymfpci: Fix BUG_ON in probe function

Tim Crawford (1):
      ALSA: hda/realtek: Add quirks for some Clevo laptops

Tim Huang (1):
      drm/amdgpu: allow more APUs to do mode2 reset when go to S4

Tomas Henzl (1):
      scsi: megaraid_sas: Fix crash after a double completion

Tony Krowiak (1):
      s390/vfio-ap: fix memory leak in vfio_ap device driver

Trond Myklebust (1):
      NFSv4: Fix hangs when recovering open state after a server reboot

Ville Syrjälä (4):
      drm/i915/dpt: Treat the DPT BO as a framebuffer
      drm/i915: Disable DC states for all commits
      drm/i915: Split icl_color_commit_noarm() from skl_color_commit_noarm()
      drm/i915: Move CSC load back into .color_commit_arm() when PSR is enabled on skl/glk

Vladimir Oltean (2):
      net: stmmac: don't reject VLANs when IFF_PROMISC is set
      net: dsa: sync unicast and multicast addresses for VLAN filters too

Wei Chen (5):
      fbdev: tgafb: Fix potential divide by zero
      fbdev: nvidia: Fix potential divide by zero
      fbdev: intelfb: Fix potential divide by zero
      fbdev: lxfb: Fix potential divide by zero
      fbdev: au1200fb: Fix potential divide by zero

Werner Sembach (1):
      Input: i8042 - add TUXEDO devices to i8042 quirk tables for partial fix

Wolfram Sang (1):
      smsc911x: avoid PHY being resumed when interface is not up

Xiaogang Chen (2):
      drm/amdkfd: Fix BO offset for multi-VMA page migration
      drm/amdkfd: Get prange->offset after svm_range_vram_node_new

Yoshihiro Shimoda (1):
      PCI: dwc: Fix PORT_LINK_CONTROL update when CDM check enabled

huangwenhui (1):
      ALSA: hda/realtek: Add quirk for Lenovo ZhaoYang CF4620Z

msizanoen (1):
      Input: alps - fix compatibility with -funsigned-char

Álvaro Fernández Rojas (1):
      mips: bmips: BCM6358: disable RAC flush for TP1

Íñigo Huguet (1):
      sfc: ef10: don't overwrite offload features at NIC reset

