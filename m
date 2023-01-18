Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28A3671B23
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 12:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjARLqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 06:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjARLo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 06:44:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCE82E0D9;
        Wed, 18 Jan 2023 03:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEB74B81C16;
        Wed, 18 Jan 2023 11:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCA5C433D2;
        Wed, 18 Jan 2023 11:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674039929;
        bh=BE3zOGhei0g4FNlGV14h8reQOn3ENLtMluFzm4504dE=;
        h=From:To:Cc:Subject:Date:From;
        b=D9NAdVO1IWt7V+ELj3vvHwIBCNKIQJ+jOU2E0zpSOifM8u3xOVua8KYxiS0b9iMOt
         JEM4l8aoZ67xUu/HZkdOBBp0kF6DlFjRAzJN/H7cYZYyuP9SW+YD9PeAy2LyizxsPa
         jATmn3+0X0IWMH4l22CUFP0e6MtN0ZtEWkJgCoss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.1.7
Date:   Wed, 18 Jan 2023 12:05:18 +0100
Message-Id: <16740399191863@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.1.7 kernel.

All users of the 6.1 kernel series must upgrade.

The updated 6.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/display/msm/dsi-controller-main.yaml |    4 
 Documentation/devicetree/bindings/display/msm/dsi-phy-10nm.yaml        |    1 
 Documentation/devicetree/bindings/display/msm/dsi-phy-14nm.yaml        |    1 
 Documentation/devicetree/bindings/display/msm/dsi-phy-28nm.yaml        |    4 
 Documentation/gpu/todo.rst                                             |   11 
 Documentation/sphinx/load_config.py                                    |    6 
 Documentation/virt/kvm/api.rst                                         |   14 
 Makefile                                                               |    2 
 arch/arm64/include/asm/atomic_ll_sc.h                                  |    2 
 arch/arm64/include/asm/atomic_lse.h                                    |    2 
 arch/arm64/include/asm/kvm_emulate.h                                   |   22 
 arch/arm64/include/asm/pgtable.h                                       |    6 
 arch/arm64/kernel/elfcore.c                                            |   61 -
 arch/arm64/kernel/ptrace.c                                             |    2 
 arch/arm64/kernel/signal.c                                             |    9 
 arch/ia64/kernel/elfcore.c                                             |    4 
 arch/powerpc/include/asm/imc-pmu.h                                     |    2 
 arch/powerpc/perf/imc-pmu.c                                            |  136 +-
 arch/s390/include/asm/cpu_mf.h                                         |   31 
 arch/s390/include/asm/percpu.h                                         |    2 
 arch/s390/kernel/machine_kexec_file.c                                  |    5 
 arch/s390/kernel/perf_cpum_sf.c                                        |  101 +-
 arch/x86/boot/bioscall.S                                               |    4 
 arch/x86/kernel/cpu/resctrl/monitor.c                                  |   49 -
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                                 |   12 
 arch/x86/kvm/cpuid.c                                                   |   32 
 arch/x86/mm/pat/memtype.c                                              |    3 
 arch/x86/um/elfcore.c                                                  |    4 
 block/blk-merge.c                                                      |    4 
 block/blk-mq.c                                                         |    5 
 drivers/acpi/glue.c                                                    |   14 
 drivers/acpi/scan.c                                                    |    7 
 drivers/acpi/video_detect.c                                            |    4 
 drivers/block/drbd/drbd_req.c                                          |    2 
 drivers/block/ps3vram.c                                                |    2 
 drivers/cpufreq/amd-pstate.c                                           |    1 
 drivers/edac/edac_device.c                                             |   17 
 drivers/edac/edac_module.h                                             |    2 
 drivers/firmware/efi/efi.c                                             |    9 
 drivers/firmware/efi/runtime-wrappers.c                                |    1 
 drivers/firmware/psci/psci.c                                           |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                             |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                                |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                             |    5 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c                           |    2 
 drivers/gpu/drm/amd/amdgpu/soc21.c                                     |   11 
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c                  |    5 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c                   |    8 
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.h                   |    3 
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c                |   25 
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h                          |    4 
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_0_ppsmc.h           |    8 
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h                           |    5 
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                           |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                         |   23 
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c                   |   95 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c                   |    3 
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c                                 |   18 
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h                                 |    3 
 drivers/gpu/drm/drm_buddy.c                                            |   81 +
 drivers/gpu/drm/i915/gem/i915_gem_context.c                            |   24 
 drivers/gpu/drm/i915/gt/intel_engine_cs.c                              |    7 
 drivers/gpu/drm/i915/gt/intel_gt_sysfs.c                               |   15 
 drivers/gpu/drm/i915/gt/intel_gt_sysfs.h                               |    2 
 drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c                            |  461 ++++-----
 drivers/gpu/drm/i915/gt/intel_reset.c                                  |   34 
 drivers/gpu/drm/i915/i915_vma.c                                        |    2 
 drivers/gpu/drm/msm/adreno/adreno_gpu.h                                |   10 
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c                    |    3 
 drivers/gpu/drm/msm/dp/dp_aux.c                                        |    4 
 drivers/gpu/drm/msm/msm_drv.c                                          |    2 
 drivers/gpu/drm/msm/msm_mdss.c                                         |    6 
 drivers/gpu/drm/virtio/virtgpu_ioctl.c                                 |   19 
 drivers/gpu/drm/vmwgfx/Makefile                                        |    2 
 drivers/gpu/drm/vmwgfx/ttm_object.c                                    |  156 +--
 drivers/gpu/drm/vmwgfx/ttm_object.h                                    |   32 
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                                     |   38 
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c                             |   62 -
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                                    |   71 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                                    |   29 
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c                                |  190 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_hashtab.c                                |  199 ----
 drivers/gpu/drm/vmwgfx/vmwgfx_hashtab.h                                |   83 -
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c                               |   33 
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c                             |   55 -
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.h                             |   26 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c                            |    4 
 drivers/iommu/arm/arm-smmu/arm-smmu.c                                  |   32 
 drivers/iommu/iova.c                                                   |    4 
 drivers/iommu/mtk_iommu_v1.c                                           |    4 
 drivers/md/dm.c                                                        |    2 
 drivers/md/md.c                                                        |    2 
 drivers/mtd/parsers/scpart.c                                           |    2 
 drivers/mtd/spi-nor/core.c                                             |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                              |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c              |    2 
 drivers/net/ethernet/intel/iavf/iavf_main.c                            |    2 
 drivers/net/ethernet/intel/ice/ice_gnss.c                              |   24 
 drivers/net/ethernet/intel/igc/igc_defines.h                           |    2 
 drivers/net/ethernet/intel/igc/igc_ptp.c                               |   10 
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                           |   14 
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c                        |    4 
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h                        |    1 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c                   |    2 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                          |   13 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c              |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c              |   19 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                      |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                        |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                        |    5 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c             |    2 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c                |   16 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c                  |   38 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h                  |    6 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c             |   18 
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c                    |    2 
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c                   |    3 
 drivers/net/ethernet/realtek/r8169_main.c                              |    5 
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c                   |   26 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c                       |    5 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c                  |    5 
 drivers/nfc/pn533/usb.c                                                |   44 
 drivers/nvme/host/multipath.c                                          |    2 
 drivers/pinctrl/pinctrl-amd.c                                          |   10 
 drivers/platform/surface/aggregator/controller.c                       |    4 
 drivers/platform/surface/aggregator/ssh_request_layer.c                |   14 
 drivers/platform/x86/amd/pmc.c                                         |    2 
 drivers/platform/x86/asus-wmi.c                                        |    3 
 drivers/platform/x86/dell/dell-wmi-privacy.c                           |   41 
 drivers/platform/x86/ideapad-laptop.c                                  |    6 
 drivers/platform/x86/intel/int3472/clk_and_regulator.c                 |    3 
 drivers/platform/x86/intel/int3472/discrete.c                          |    4 
 drivers/platform/x86/sony-laptop.c                                     |   21 
 drivers/platform/x86/thinkpad_acpi.c                                   |   23 
 drivers/regulator/da9211-regulator.c                                   |   11 
 drivers/s390/block/dcssblk.c                                           |    2 
 drivers/scsi/mpi3mr/Makefile                                           |    2 
 drivers/scsi/storvsc_drv.c                                             |    3 
 drivers/tty/hvc/hvc_xen.c                                              |   46 
 drivers/ufs/core/ufshcd.c                                              |   26 
 fs/binfmt_elf.c                                                        |    4 
 fs/binfmt_elf_fdpic.c                                                  |    4 
 fs/cifs/connect.c                                                      |    9 
 fs/cifs/link.c                                                         |    1 
 fs/cifs/smb1ops.c                                                      |   63 -
 fs/cifs/smb2pdu.c                                                      |    5 
 fs/nfsd/filecache.c                                                    |  484 +++++-----
 fs/nfsd/filecache.h                                                    |    9 
 fs/nfsd/nfs3proc.c                                                     |   10 
 fs/nfsd/nfs4proc.c                                                     |   11 
 fs/nfsd/nfs4state.c                                                    |   20 
 fs/nfsd/trace.h                                                        |  129 +-
 fs/nfsd/vfs.c                                                          |   19 
 fs/nfsd/vfs.h                                                          |    3 
 include/acpi/acpi_bus.h                                                |    3 
 include/linux/elfcore.h                                                |    8 
 include/linux/mlx5/driver.h                                            |    2 
 include/linux/mtd/spi-nor.h                                            |    1 
 include/linux/tpm_eventlog.h                                           |    4 
 include/uapi/linux/psci.h                                              |    4 
 io_uring/fdinfo.c                                                      |   12 
 io_uring/io-wq.c                                                       |    6 
 io_uring/poll.c                                                        |   50 -
 io_uring/rw.c                                                          |    6 
 kernel/sched/core.c                                                    |   41 
 mm/memblock.c                                                          |    8 
 net/core/gro.c                                                         |   71 -
 net/ipv6/raw.c                                                         |    4 
 net/netfilter/ipset/ip_set_bitmap_ip.c                                 |    4 
 net/netfilter/nft_payload.c                                            |    2 
 net/sched/act_mpls.c                                                   |    8 
 net/tipc/node.c                                                        |   12 
 sound/core/control_led.c                                               |    5 
 sound/pci/hda/patch_realtek.c                                          |   53 -
 sound/soc/codecs/rt9120.c                                              |   12 
 sound/soc/codecs/wm8904.c                                              |    7 
 sound/soc/intel/boards/Kconfig                                         |    1 
 sound/soc/intel/boards/sof_nau8825.c                                   |   22 
 sound/soc/intel/common/soc-acpi-intel-adl-match.c                      |   18 
 sound/soc/qcom/Kconfig                                                 |   21 
 sound/soc/qcom/Makefile                                                |    2 
 sound/soc/qcom/common.c                                                |  114 --
 sound/soc/qcom/common.h                                                |   10 
 sound/soc/qcom/lpass-cpu.c                                             |    5 
 sound/soc/qcom/sc8280xp.c                                              |    1 
 sound/soc/qcom/sdw.c                                                   |  123 ++
 sound/soc/qcom/sdw.h                                                   |   18 
 sound/soc/qcom/sm8250.c                                                |    1 
 sound/usb/implicit.c                                                   |    3 
 sound/usb/pcm.c                                                        |   16 
 sound/usb/stream.c                                                     |    6 
 tools/include/nolibc/arch-mips.h                                       |    2 
 tools/include/nolibc/arch-riscv.h                                      |   14 
 tools/perf/builtin-kmem.c                                              |   65 +
 tools/perf/builtin-trace.c                                             |    2 
 tools/perf/util/auxtrace.c                                             |    2 
 tools/perf/util/bpf_counter.h                                          |    6 
 tools/testing/memblock/internal.h                                      |    4 
 tools/testing/selftests/net/af_unix/test_unix_oob.c                    |    2 
 tools/testing/selftests/net/l2_tos_ttl_inherit.sh                      |  202 ++--
 tools/testing/selftests/netfilter/nft_trans_stress.sh                  |   16 
 tools/testing/selftests/netfilter/settings                             |    1 
 202 files changed, 2656 insertions(+), 2152 deletions(-)

Aaron Thompson (1):
      mm: Always release pages to the buddy allocator in memblock_free_late().

Adrian Hunter (1):
      perf auxtrace: Fix address filter duplicate symbol selection

Alex Deucher (1):
      Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""

Alexander Egorenkov (1):
      s390/kexec: fix ipl report address for kdump

Angela Czubak (1):
      octeontx2-af: Fix LMAC config in cgx_lmac_rx_tx_enable

Ao Zhong (1):
      drm/amd/display: move remaining FPU code to dml folder

Ard Biesheuvel (1):
      efi: tpm: Avoid READ_ONCE() for accessing the event log

Ariel Levkovich (2):
      net/mlx5: check attr pointer validity before dereferencing it
      net/mlx5e: TC, Keep mod hdr actions after mod hdr alloc

Arnd Bergmann (3):
      ASoC: Intel: fix sof-nau8825 link failure
      ASoC: Intel: sof-nau8825: fix module alias overflow
      mtd: cfi: allow building spi-intel standalone

Arunpravin Paneer Selvam (1):
      drm: Optimize drm buddy top-down allocation method

Biao Huang (1):
      stmmac: dwmac-mediatek: remove the dwmac_fix_mac_speed

Brent Lu (1):
      ASoC: Intel: sof_nau8825: support rt1015p speaker amplifier

Brian Norris (1):
      ASoC: qcom: lpass-cpu: Fix fallback SD line index handling

Bryan O'Donoghue (4):
      dt-bindings: msm: dsi-controller-main: Fix operating-points-v2 constraint
      dt-bindings: msm: dsi-controller-main: Fix power-domain constraint
      dt-bindings: msm: dsi-controller-main: Fix description of core clock
      dt-bindings: msm: dsi-phy-28nm: Add missing qcom, dsi-phy-regulator-ldo-mode

Candice Li (1):
      drm/amd/pm: Enable bad memory page/channel recording support for smu v13_0_0

Catalin Marinas (3):
      arm64: mte: Fix double-freeing of the temporary tag storage during coredump
      arm64: mte: Avoid the racy walk of the vma list during core dump
      elfcore: Add a cprm parameter to elf_core_extra_{phdrs,data_size}

ChiYuan Huang (1):
      ASoC: rt9120: Make dev PM runtime bind AsoC component PM

Chris Wilson (2):
      drm/i915/gt: Reset twice
      drm/i915/gt: Cleanup partial engine discovery failures

Christophe JAILLET (1):
      iommu/mediatek-v1: Fix an error handling path in mtk_iommu_v1_probe()

Christopher S Hall (1):
      igc: Fix PPS delta between two synchronized end-points

Chuck Lever (4):
      NFSD: Pass the target nfsd_file to nfsd_commit()
      NFSD: Revert "NFSD: NFSv4 CLOSE should release an nfsd_file immediately"
      NFSD: Add an NFSD_FILE_GC flag to enable nfsd_file garbage collection
      NFSD: Add an nfsd_file_fsync tracepoint

Clément Léger (1):
      net: lan966x: check for ptp to be enabled in lan966x_ptp_deinit()

Daniil Tatianin (1):
      iavf/iavf_main: actually log ->src mask when talking about it

Ding Hui (1):
      efi: fix userspace infinite retry read efivars after EFI runtime services page fault

Dmitry Baryshkov (1):
      drm/msm: another fix for the headless Adreno GPU

Dragos Tatulea (3):
      net/mlx5e: IPoIB, Block queue count configuration when sub interfaces are present
      net/mlx5e: IPoIB, Block PKEY interfaces with less rx queues than parent
      net/mlx5e: IPoIB, Fix child PKEY interface stats on rx path

Eliav Farber (1):
      EDAC/device: Fix period calculation in edac_device_reset_delay_period()

Emanuele Ghidoli (1):
      ASoC: wm8904: fix wrong outputs volume after power reactivation

Emeel Hakim (2):
      net/mlx5e: Fix macsec ssci attribute handling in offload path
      net/mlx5e: Fix macsec possible null dereference when updating MAC security entity (SecY)

Eric Dumazet (1):
      gro: take care of DODGY packets

Evan Quan (4):
      drm/amd/pm: correct the reference clock for fan speed(rpm) calculation
      drm/amd/pm: add the missing mapping for PPT feature on SMU13.0.0 and 13.0.7
      drm/amd/pm: enable GPO dynamic control support for SMU13.0.0
      drm/amd/pm: enable GPO dynamic control support for SMU13.0.7

Ferry Toth (2):
      usb: ulpi: defer ulpi_register on ulpi_read_id timeout
      Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"

Florian Westphal (1):
      selftests: netfilter: fix transaction test script timeout handling

Gavin Li (1):
      net/mlx5e: Don't support encap rules with gbp option

Gavrilov Ilia (1):
      netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Greg Kroah-Hartman (1):
      Linux 6.1.7

Guchun Chen (1):
      drm/amd/pm/smu13: BACO is supported when it's in BACO state

Guillaume Nault (3):
      selftests/net: l2_tos_ttl_inherit.sh: Set IPv6 addresses with "nodad".
      selftests/net: l2_tos_ttl_inherit.sh: Run tests in their own netns.
      selftests/net: l2_tos_ttl_inherit.sh: Ensure environment cleanup on failure.

Hans de Goede (7):
      ACPI: Fix selecting wrong ACPI fwnode for the iGPU on some Dell laptops
      ACPI: video: Allow selecting NVidia-WMI-EC or Apple GMUX backlight from the cmdline
      platform/x86: dell-privacy: Only register SW_CAMERA_LENS_COVER if present
      platform/x86: int3472/discrete: Ensure the clk/power enable pins are in output mode
      platform/x86: dell-privacy: Fix SW_CAMERA_LENS_COVER reporting
      platform/x86: ideapad-laptop: Add Legion 5 15ARH05 DMI id to set_fn_lock_led_list[]
      platform/x86: sony-laptop: Don't turn off 0x153 keyboard backlight during probe

Hariprasad Kelam (1):
      octeontx2-pf: Fix resource leakage in VF driver unbind

Heiko Carstens (2):
      s390/cpum_sf: add READ_ONCE() semantics to compare and swap loops
      s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()

Heiner Kallweit (1):
      Revert "r8169: disable detection of chip version 36"

Herbert Xu (1):
      ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Ian Rogers (1):
      perf build: Properly guard libbpf includes

Ido Schimmel (1):
      net/sched: act_mpls: Fix warning during failed attribute validation

Ivan T. Ivanov (1):
      brcmfmac: Prefer DT board type over DMI board type

Jakub Kicinski (1):
      bnxt: make sure we return pages to the pool

Jaroslav Kysela (3):
      ALSA: control-led: use strscpy in set_led_id()
      ALSA: usb-audio: Always initialize fixed_rate in snd_usb_find_implicit_fb_sync_format()
      ALSA: usb-audio: Fix possible NULL pointer dereference in snd_usb_pcm_has_fixed_rate()

Jeff Layton (4):
      nfsd: remove the pages_flushed statistic from filecache
      nfsd: reorganize filecache.c
      nfsd: rework refcounting in filecache
      nfsd: fix handling of cached open files in nfsd4_open codepath

Jens Axboe (6):
      io_uring/poll: add hash if ready poll request can't complete inline
      io_uring/fdinfo: include locked hash table in fdinfo output
      io_uring/poll: attempt request issue after racy poll wakeup
      io_uring/io-wq: free worker if task_work creation is canceled
      io_uring/io-wq: only free worker if it was allocated for creation
      block: handle bio_split_to_limits() NULL return

Jiasheng Jiang (1):
      ice: Add check for kzalloc

Jie Wang (1):
      net: hns3: fix wrong use of rss size during VF rss config

Johan Hovold (1):
      efi: fix NULL-deref in init error path

Jonathan Corbet (1):
      docs: Fix the docs build with Sphinx 6.0

Juergen Gross (1):
      x86/pat: Fix pat_x_mtrr_type() for MTRR disabled case

Kajol Jain (1):
      powerpc/imc-pmu: Fix use of mutex in IRQs disabled section

Kenneth Feng (1):
      drm/amd/pm: enable mode1 reset on smu_v13_0_10

Konrad Dybcio (3):
      drm/msm/adreno: Make adreno quirks not overwrite each other
      dt-bindings: msm/dsi: Don't require vdds-supply on 10nm PHY
      dt-bindings: msm/dsi: Don't require vcca-supply on 14nm PHY

Kuogee Hsieh (1):
      drm/msm/dp: do not complete dp_aux_cmd_fifo_tx() if irq is not for aux transfer

Leo Yan (2):
      perf kmem: Support legacy tracepoints
      perf kmem: Support field "node" in evsel__process_alloc_event() coping with recent tracepoint restructuring

Liu Shixin (2):
      arm64/mm: add pud_user_exec() check in pud_user_accessible_page()
      arm64/mm: fix incorrect file_map_count for invalid pmd

Luben Tuikov (1):
      drm/amdgpu: Fix potential NULL dereference

Luka Guzenko (1):
      ALSA: hda/realtek: Enable mute/micmute LEDs on HP Spectre x360 13-aw0xxx

Maaz Mombasawala (5):
      drm/vmwgfx: Refactor resource manager's hashtable to use linux/hashtable implementation.
      drm/vmwgfx: Remove ttm object hashtable
      drm/vmwgfx: Refactor resource validation hashtable to use linux/hashtable implementation.
      drm/vmwgfx: Refactor ttm reference object hashtable to use linux/hashtable.
      drm/vmwgfx: Remove vmwgfx_hashtab

Marc Zyngier (2):
      KVM: arm64: Fix S1PTW handling on RO memslots
      firmware/psci: Don't register with debugfs if PSCI isn't available

Mario Limonciello (2):
      drm/amd: Delay removal of the firmware framebuffer
      pinctrl: amd: Add dynamic debugging for active GPIOs

Mark Brown (2):
      arm64/signal: Always allocate SVE signal frames on SME only systems
      arm64/signal: Always accept SVE signal frames on SME only systems

Mark Pearson (1):
      platform/x86: thinkpad_acpi: Fix profile mode display in AMT mode

Mark Rutland (1):
      arm64: cmpxchg_double*: hazard against entire exchange variable

Maximilian Luz (2):
      platform/surface: aggregator: Ignore command messages not intended for us
      platform/surface: aggregator: Add missing call to ssam_request_sync_free()

Miaoqian Lin (2):
      drm/msm/dpu: Fix memory leak in msm_mdss_parse_data_bus_icc_path
      platform/x86/amd: Fix refcount leak in amd_pmc_probe

Michael Kelley (1):
      scsi: storvsc: Fix swiotlb bounce buffer leak in confidential VM

Mikhail Zhilkin (1):
      mtd: parsers: scpart: fix __udivdi3 undefined on mips

Minsuk Kang (1):
      nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Mirsad Goran Todorovac (1):
      af_unix: selftest: Fix the size of the parameter to connect()

Moshe Shemesh (1):
      net/mlx5: Fix command stats access after free

Nathan Chancellor (1):
      drm/i915: Fix CFI violations in gt_sysfs

Nirmoy Das (1):
      drm/i915: Reserve enough fence slot for i915_vma_unbind_async

Noor Azura Ahmad Tarmizi (1):
      net: stmmac: add aux timestamps fifo clearance wait

Pablo Neira Ayuso (1):
      netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits

Paolo Bonzini (1):
      KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID

Paulo Alcantara (4):
      cifs: fix file info setting in cifs_query_path_info()
      cifs: fix file info setting in cifs_open_file()
      cifs: do not query ifaces on smb1 mounts
      cifs: fix double free on failed kerberos auth

Pavel Begunkov (1):
      io_uring: lock overflowing for IOPOLL

Perry Yuan (1):
      cpufreq: amd-pstate: fix kernel hang issue while amd-pstate unregistering

Peter Newman (2):
      x86/resctrl: Fix task CLOSID/RMID update race
      x86/resctrl: Fix event counts regression in reused RMIDs

Peter Wang (1):
      scsi: ufs: core: WLUN suspend SSU/enter hibern8 fail recovery

Peter Zijlstra (1):
      x86/boot: Avoid using Intel mnemonics in AT&T syntax asm

Rahul Rameshbabu (1):
      net/mlx5: Fix ptp max frequency adjustment range

Ricardo Ribalda (1):
      regulator: da9211: Use irq handler when ready

Richard Gobert (1):
      gro: avoid checking for a failed search

Rob Clark (2):
      drm/virtio: Fix GEM handle creation UAF
      drm/i915: Fix potential context UAFs

Robin Murphy (1):
      iommu/arm-smmu: Report IOMMU_CAP_CACHE_COHERENCY even betterer

Roger Pau Monne (1):
      hvc/xen: lock console list traversal

Roy Novich (1):
      net/mlx5e: Verify dev is present for fix features ndo

Saleemkhan Jamadar (2):
      drm/amdgpu: Enable pg/cg flags on GC11_0_4 for VCN
      drm/amdgpu: enable VCN DPG for GC IP v11.0.4

Shin'ichiro Kawasaki (1):
      scsi: mpi3mr: Refer CONFIG_SCSI_MPI3MR in Makefile

Stephan Gerhold (1):
      ASoC: qcom: Fix building APQ8016 machine driver without SOUNDWIRE

Takashi Iwai (3):
      Revert "ALSA: usb-audio: Drop superfluous interface setup at parsing"
      ALSA: usb-audio: Make sure to stop endpoints before closing EPs
      ALSA: usb-audio: Relax hw constraints for implicit fb sync

Thomas Weißschuh (1):
      platform/x86: asus-wmi: Don't load fan curves without fan

Tung Nguyen (1):
      tipc: fix unexpected link reset due to discovery messages

Vladimir Oltean (2):
      iommu/arm-smmu-v3: Don't unregister on shutdown
      iommu/arm-smmu: Don't unregister on shutdown

Volker Lendecke (1):
      cifs: Fix uninitialized memory read for smb311 posix symlink create

Waiman Long (1):
      sched/core: Fix use-after-free bug in dup_user_cpus_ptr()

Will Deacon (1):
      firmware/psci: Fix MEM_PROTECT_RANGE function numbers

Willy Tarreau (2):
      tools/nolibc: restore mips branch ordering in the _start block
      tools/nolibc: fix the O_* fcntl/open macro definitions for riscv

Yair Podemsky (1):
      sched/core: Fix arch_scale_freq_tick() on tickless systems

Yang Li (1):
      drm/msm/dpu: Fix some kernel-doc comments

Yang Yingliang (1):
      ixgbe: fix pci device refcount leak

YiPeng Chai (1):
      drm/amdgpu: Fixed bug on error when unloading amdgpu

Yifan Zhang (1):
      drm/amdgpu: add soc21 common ip block support for GC 11.0.4

Yuan Can (1):
      ice: Fix potential memory leak in ice_gnss_tty_write()

Yuchi Yang (1):
      ALSA: hda/realtek - Turn on power early

Yunfei Wang (1):
      iommu/iova: Fix alloc iova overflows issue

Zack Rusin (2):
      drm/vmwgfx: Write the driver id registers
      drm/vmwgfx: Remove rcu locks from user resources

Zenghui Yu (1):
      arm64: ptrace: Use ARM64_SME to guard the SME register enumerations

