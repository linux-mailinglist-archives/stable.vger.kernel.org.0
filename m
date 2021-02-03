Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C1630E6B4
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhBCXFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233645AbhBCXFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:05:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2284B64F74;
        Wed,  3 Feb 2021 23:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612393480;
        bh=48idWlPl2DHtPDu4eevOeC1mhgry/6H4vja2se/Yzb4=;
        h=From:To:Cc:Subject:Date:From;
        b=pNewNDm4AV/Ndf1EuAIxYOahYtIAUewSdrAAyfZauLRM6R13lnTX7QMDgpTOkGAx+
         CPZsTpk3UE+GBSfTmDO21g2SBSqN8kd8GEXzd6r03DuHk4v6sREJ/60eaaVL/BS5OU
         vtLfOzVvxizFRfyD17kM1P2trp8QyX+sJv2/uZ3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.13
Date:   Thu,  4 Feb 2021 00:04:32 +0100
Message-Id: <161239347273177@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.13 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/asm-annotations.rst                              |    5 
 Documentation/virt/kvm/api.rst                                 |    5 
 Makefile                                                       |    2 
 arch/arm/boot/compressed/atags_to_fdt.c                        |    3 
 arch/arm/boot/dts/imx6q-tbs2910.dts                            |    7 
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi                          |    2 
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi                  |    6 
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi                          |   12 +
 arch/arm/boot/dts/ste-db8500.dtsi                              |   38 +++
 arch/arm/boot/dts/ste-db8520.dtsi                              |   38 +++
 arch/arm/boot/dts/ste-db9500.dtsi                              |   35 +++
 arch/arm/boot/dts/ste-snowball.dts                             |    2 
 arch/arm/mach-imx/suspend-imx6.S                               |    1 
 arch/arm64/boot/dts/broadcom/stingray/stingray-usb.dtsi        |    7 
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                 |    2 
 arch/arm64/boot/dts/freescale/imx8mp.dtsi                      |    2 
 arch/arm64/kvm/pmu-emul.c                                      |   10 -
 arch/parisc/Kconfig                                            |    5 
 arch/parisc/kernel/entry.S                                     |   13 +
 arch/powerpc/kernel/irq.c                                      |   28 +-
 arch/s390/boot/uv.c                                            |    2 
 arch/s390/include/asm/uv.h                                     |    4 
 arch/s390/kernel/uv.c                                          |    2 
 arch/x86/entry/thunk_64.S                                      |    8 
 arch/x86/include/asm/idtentry.h                                |    1 
 arch/x86/kvm/svm/nested.c                                      |    6 
 arch/x86/kvm/vmx/nested.c                                      |   46 +++-
 arch/x86/kvm/vmx/pmu_intel.c                                   |    6 
 arch/x86/kvm/x86.c                                             |    4 
 arch/x86/xen/enlighten_pv.c                                    |   15 +
 arch/x86/xen/xen-asm.S                                         |    1 
 block/blk-mq.h                                                 |    2 
 drivers/acpi/arm64/iort.c                                      |   14 +
 drivers/acpi/device_sysfs.c                                    |   20 --
 drivers/acpi/thermal.c                                         |   46 +++-
 drivers/block/nbd.c                                            |    8 
 drivers/block/xen-blkfront.c                                   |   20 --
 drivers/clk/imx/Kconfig                                        |    2 
 drivers/clk/mmp/clk-audio.c                                    |    6 
 drivers/clk/qcom/gcc-sm8250.c                                  |    4 
 drivers/crypto/marvell/cesa/cesa.h                             |    4 
 drivers/firmware/efi/apple-properties.c                        |   13 -
 drivers/firmware/imx/Kconfig                                   |    1 
 drivers/gpu/drm/amd/pm/inc/amdgpu_smu.h                        |    1 
 drivers/gpu/drm/amd/pm/inc/smu_v11_0.h                         |    3 
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c                      |    9 
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c              |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c                |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c        |    1 
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c                 |   31 +++
 drivers/gpu/drm/i915/gt/gen7_renderclear.c                     |   12 +
 drivers/gpu/drm/i915/gt/intel_ggtt.c                           |   47 +++-
 drivers/gpu/drm/i915/i915_active.c                             |   28 +-
 drivers/gpu/drm/i915/i915_drv.h                                |    2 
 drivers/gpu/drm/i915/i915_pmu.c                                |   30 +--
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c                  |    2 
 drivers/gpu/drm/nouveau/dispnv50/base507c.c                    |    6 
 drivers/gpu/drm/nouveau/dispnv50/base827c.c                    |    6 
 drivers/gpu/drm/nouveau/dispnv50/head917d.c                    |   28 ++
 drivers/gpu/drm/nouveau/dispnv50/wndw.c                        |   17 +
 drivers/gpu/drm/nouveau/include/nvhw/class/cl917d.h            |    4 
 drivers/gpu/drm/nouveau/nouveau_svm.c                          |    4 
 drivers/gpu/drm/vc4/vc4_hvs.c                                  |    8 
 drivers/gpu/drm/vc4/vc4_plane.c                                |   11 -
 drivers/infiniband/hw/cxgb4/qp.c                               |    2 
 drivers/infiniband/hw/mlx5/main.c                              |    6 
 drivers/iommu/amd/amd_iommu.h                                  |    7 
 drivers/iommu/amd/amd_iommu_types.h                            |    4 
 drivers/iommu/amd/init.c                                       |   56 +++++
 drivers/iommu/intel/dmar.c                                     |    2 
 drivers/leds/led-triggers.c                                    |   10 -
 drivers/md/bcache/features.h                                   |    6 
 drivers/media/cec/platform/Makefile                            |    1 
 drivers/media/rc/ir-mce_kbd-decoder.c                          |    2 
 drivers/media/rc/ite-cir.c                                     |    2 
 drivers/media/rc/rc-main.c                                     |    8 
 drivers/media/rc/serial_ir.c                                   |    2 
 drivers/net/can/dev.c                                          |    2 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c             |   11 -
 drivers/net/ethernet/intel/ice/ice.h                           |    4 
 drivers/net/ethernet/intel/ice/ice_ethtool.c                   |    8 
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c              |    8 
 drivers/net/ethernet/intel/ice/ice_lib.c                       |   14 -
 drivers/net/ethernet/intel/ice/ice_main.c                      |   16 -
 drivers/net/ethernet/intel/ice/ice_txrx.c                      |    9 
 drivers/net/ethernet/intel/igc/igc_ethtool.c                   |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c            |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c             |   20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c             |   13 -
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c           |    8 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |   39 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c               |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |   22 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c              |    1 
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h             |    5 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c            |   58 +++--
 drivers/net/team/team.c                                        |    6 
 drivers/net/usb/qmi_wwan.c                                     |    1 
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c                   |   56 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-config.h                |    2 
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h                  |    6 
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                    |    3 
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c       |   42 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                |   14 -
 drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c          |    9 
 drivers/net/wireless/mediatek/mt7601u/dma.c                    |    5 
 drivers/nvme/host/multipath.c                                  |    2 
 drivers/of/device.c                                            |   10 -
 drivers/s390/crypto/vfio_ap_drv.c                              |    6 
 drivers/s390/crypto/vfio_ap_ops.c                              |  100 ++++++----
 drivers/s390/crypto/vfio_ap_private.h                          |   12 -
 drivers/scsi/qla2xxx/qla_os.c                                  |    2 
 drivers/soc/atmel/soc.c                                        |   13 +
 drivers/soc/imx/Kconfig                                        |    2 
 drivers/spi/spi-altera.c                                       |    3 
 drivers/staging/media/hantro/hantro_v4l2.c                     |    2 
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c               |    2 
 drivers/tee/optee/call.c                                       |    4 
 drivers/tty/tty_io.c                                           |   20 +-
 drivers/xen/xenbus/xenbus_probe.c                              |   31 +++
 fs/block_dev.c                                                 |   10 -
 fs/btrfs/block-group.c                                         |   10 -
 fs/btrfs/ctree.h                                               |    3 
 fs/btrfs/free-space-tree.c                                     |   10 -
 fs/btrfs/volumes.c                                             |    2 
 fs/btrfs/volumes.h                                             |   11 -
 fs/io_uring.c                                                  |   10 -
 fs/nfs/pnfs.c                                                  |   40 ++--
 include/dt-bindings/sound/apq8016-lpass.h                      |    7 
 include/dt-bindings/sound/qcom,lpass.h                         |   15 +
 include/dt-bindings/sound/sc7180-lpass.h                       |    6 
 include/linux/linkage.h                                        |    5 
 include/linux/mlx5/driver.h                                    |   18 -
 include/net/tcp.h                                              |    3 
 include/uapi/linux/rpl.h                                       |    6 
 kernel/kexec_core.c                                            |    2 
 kernel/power/swap.c                                            |    2 
 net/ipv4/tcp_input.c                                           |   14 -
 net/ipv4/tcp_output.c                                          |    2 
 net/ipv4/tcp_recovery.c                                        |    5 
 net/ipv4/tcp_timer.c                                           |   18 +
 net/mac80211/ieee80211_i.h                                     |    1 
 net/mac80211/iface.c                                           |    6 
 net/netfilter/nft_dynset.c                                     |    4 
 net/nfc/netlink.c                                              |    1 
 net/nfc/rawsock.c                                              |    2 
 net/rxrpc/call_accept.c                                        |    1 
 net/vmw_vsock/af_vsock.c                                       |   17 +
 net/wireless/wext-core.c                                       |    5 
 net/xfrm/xfrm_input.c                                          |    2 
 net/xfrm/xfrm_policy.c                                         |   30 ++-
 sound/pci/hda/patch_realtek.c                                  |    1 
 sound/pci/hda/patch_via.c                                      |    2 
 sound/soc/amd/renoir/rn-pci-acp3x.c                            |   18 +
 sound/soc/intel/skylake/skl-topology.c                         |   13 -
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c             |    5 
 sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c     |    5 
 sound/soc/qcom/lpass-cpu.c                                     |   42 ++--
 sound/soc/qcom/lpass-ipq806x.c                                 |    2 
 sound/soc/qcom/lpass-lpaif-reg.h                               |    2 
 sound/soc/qcom/lpass-platform.c                                |   27 +-
 sound/soc/qcom/lpass-sc7180.c                                  |    9 
 sound/soc/qcom/lpass.h                                         |    2 
 sound/soc/soc-topology.c                                       |   11 -
 sound/soc/sof/intel/Kconfig                                    |    3 
 tools/testing/selftests/net/forwarding/router_mpath_nh.sh      |    2 
 tools/testing/selftests/net/forwarding/router_multipath.sh     |    2 
 tools/testing/selftests/net/xfrm_policy.sh                     |   45 ++++
 virt/kvm/kvm_main.c                                            |    1 
 170 files changed, 1334 insertions(+), 567 deletions(-)

Alex Deucher (1):
      Revert "drm/amdgpu/swsmu: drop set_fan_speed_percent (v2)"

Alexander Popov (1):
      vsock: fix the race conditions in multi-transport support

Amadeusz Sławiński (1):
      ASoC: topology: Properly unregister DAI on removal

Andrea Righi (1):
      leds: trigger: fix potential deadlock with libata

Arnd Bergmann (3):
      clk: imx: fix Kconfig warning for i.MX SCU clk
      clk: mmp2: fix build without CONFIG_PM
      ARM: imx: fix imx8m dependencies

Baoquan He (1):
      kernel: kexec: remove the lock operation of system_transition_mutex

Bastian Beranek (1):
      drm/nouveau/dispnv50: Restore pushing of all data.

Bharat Gooty (1):
      arm64: dts: broadcom: Fix USB DMA address translation for Stingray

Brett Creeley (2):
      ice: Don't allow more channels than LAN MSI-X available
      ice: Fix MSI-X vector fallback logic

Chris Wilson (3):
      drm/i915: Always flush the active worker before returning from the wait
      drm/i915/gt: Always try to reserve GGTT address 0x0
      drm/i915/gt: Clear CACHE_MODE prior to clearing residuals

Claudiu Beznea (1):
      drivers: soc: atmel: add null entry at the end of at91_soc_allowed_list[]

Coly Li (1):
      bcache: only check feature sets when sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES

Corinna Vinschen (1):
      igc: fix link speed advertising

Dan Carpenter (2):
      can: dev: prevent potential information leak in can_fill_info()
      ASoC: topology: Fix memory corruption in soc_tplg_denum_create_values()

Daniel Jurgens (1):
      net/mlx5: Maintain separate page trees for ECPF and PF functions

Daniel Wagner (1):
      nvme-multipath: Early exit if no path is available

Danielle Ratson (1):
      selftests: forwarding: Specify interface when invoking mausezahn

David Woodhouse (1):
      xen: Fix XenStore initialisation for XS_LOCAL

Dmitry Baryshkov (1):
      clk: qcom: gcc-sm250: Use floor ops for sdcc clks

Dom Cobley (2):
      drm/vc4: Correct lbm size and calculation
      drm/vc4: Correct POS1_SCL for hvs5

Enke Chen (1):
      tcp: make TCP_USER_TIMEOUT accurate for zero window probes

Enzo Matsumiya (1):
      scsi: qla2xxx: Fix description for parameter ql2xenforce_iocb_limit

Eric Dumazet (1):
      iwlwifi: provide gso_type to GSO packets

Eyal Birger (1):
      xfrm: fix disable_xfrm sysctl when used on xfrm interfaces

Giacinto Cifelli (1):
      net: usb: qmi_wwan: added support for Thales Cinterion PLSx3 modem family

Greg Kroah-Hartman (1):
      Linux 5.10.13

Helge Deller (1):
      parisc: Enable -mlong-calls gcc option by default when !CONFIG_MODULES

Henry Tieman (1):
      ice: fix FDir IPv6 flexbyte

Herbert Xu (1):
      crypto: marvel/cesa - Fix tdma descriptor on 64-bit

Ivan Vecera (1):
      team: protect features update by RCU to avoid deadlock

Jacky Bai (1):
      arm64: dts: imx8mp: Correct the gpio ranges of gpio3

Janosch Frank (1):
      s390: uv: Fix sysfs max number of VCPUs reporting

Jaroslav Kysela (1):
      ASoC: AMD Renoir - refine DMI entries for some Lenovo products

Jay Zhou (1):
      KVM: x86: get smi pending status correctly

Jernej Skrabec (1):
      media: cedrus: Fix H264 decoding

Jian-Hong Pan (1):
      ALSA: hda/realtek: Enable headset of ASUS B1400CEPE with ALC256

Johannes Berg (8):
      wext: fix NULL-ptr-dereference with cfg80211's lack of commit()
      iwlwifi: pcie: avoid potential PNVM leaks
      iwlwifi: pnvm: don't skip everything when not reloading
      iwlwifi: pnvm: don't try to load after failures
      iwlwifi: pcie: set LTR on more devices
      iwlwifi: pcie: use jiffies for memory read spin time limit
      iwlwifi: pcie: reschedule in long-running memory reads
      mac80211: pause TX while changing interface type

Josef Bacik (2):
      nbd: freeze the queue while we're adding connections
      btrfs: fix possible free space tree corruption with online conversion

Juergen Gross (1):
      x86/xen: avoid warning in Xen pv guest with CONFIG_AMD_MEM_ENCRYPT enabled

Justin Iurman (1):
      uapi: fix big endian definition of ipv6_rpl_sr_hdr

Kai-Heng Feng (1):
      ACPI: sysfs: Prefer "compatible" modalias

Kamal Heib (1):
      RDMA/cxgb4: Fix the reported max_recv_sge value

Karol Herbst (1):
      drm/nouveau/svm: fail NOUVEAU_SVM_INIT ioctl on unsupported devices

Koen Vandeputte (1):
      ARM: dts: imx6qdl-gw52xx: fix duplicate regulator naming

Laurent Badel (1):
      PM: hibernate: flush swap writer after marking

Like Xu (2):
      KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]
      KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()

Linus Torvalds (1):
      tty: avoid using vfs_iocb_iter_write() for redirected console writes

Linus Walleij (1):
      ARM: dts: ux500: Reserve memory carveouts

Lorenzo Bianconi (3):
      mt7601u: fix kernel crash unplugging the device
      mt76: mt7663s: fix rx buffer refcounting
      mt7601u: fix rx buffer refcounting

Lu Baolu (1):
      iommu/vt-d: Correctly check addr alignment in qi_flush_dev_iotlb_pasid()

Lukas Wunner (1):
      efi/apple-properties: Reinstate support for boolean properties

Lyude Paul (2):
      drm/nouveau/kms/gk104-gp1xx: Fix > 64x64 cursors
      drivers/nouveau/kms/nv50-: Reject format modifiers for cursor planes

Maor Dickman (2):
      net/mlx5e: Reduce tc unsupported key print level
      net/mlx5e: Disable hw-tc-offload when MLX5_CLS_ACT config is disabled

Marc Zyngier (2):
      KVM: arm64: Filter out v8.1+ events on v8.0 HW
      KVM: Forbid the use of tagged userspace addresses for memslots

Marco Felsch (2):
      ARM: dts: imx6qdl-kontron-samx6i: fix pwms for lcd-backlight
      ARM: dts: imx6qdl-kontron-samx6i: fix i2c_lcd/cam default status

Matthias Reichl (2):
      media: rc: fix timeout handling after switch to microsecond durations
      media: rc: ite-cir: fix min_timeout calculation

Matti Gottlieb (1):
      iwlwifi: Fix IWL_SUBDEVICE_NO_160 macro to use the correct bit.

Max Krummenacher (1):
      ARM: imx: build suspend-imx6.S with arm instruction set

Maxim Levitsky (2):
      KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES on nested vmexit
      KVM: nVMX: Sync unsync'd vmcs02 state to vmcs12 on migration

Maxim Mikityanskiy (5):
      net/mlx5e: Fix IPSEC stats
      Revert "block: simplify set_init_blocksize" to regain lost performance
      net/mlx5e: Correctly handle changing the number of queues when the interface is down
      net/mlx5e: Revert parameters on errors when changing trust state without reset
      net/mlx5e: Revert parameters on errors when changing MTU and LRO state without reset

Michael Walle (1):
      arm64: dts: ls1028a: fix the offset of the reset register

Ming Lei (1):
      blk-mq: test QUEUE_FLAG_HCTX_ACTIVE for sbitmap_shared in hctx_may_queue

Moritz Fischer (1):
      ACPI/IORT: Do not blindly trust DMA masks from firmware

Nicholas Piggin (1):
      powerpc/64s: prevent recursive replay_soft_interrupts causing superfluous interrupt

Nick Desaulniers (1):
      x86/entry: Emit a symbol for register restoring thunk

Nick Nunley (2):
      ice: Implement flow for IPv6 next header (extension header)
      ice: update dev_addr in ice_set_mac_address even if HW filter exists

Pablo Neira Ayuso (1):
      netfilter: nft_dynset: add timeout extension to template

Pan Bian (5):
      drm/i915/selftest: Fix potential memory leak
      spi: altera: Fix memory leak on error path
      net/mlx5e: free page before return
      NFC: fix resource leak when target index is invalid
      NFC: fix possible resource leak

Paolo Bonzini (1):
      KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX

Parav Pandit (2):
      Revert "RDMA/mlx5: Fix devlink deadlock on net namespace deletion"
      net/mlx5e: E-switch, Fix rate calculation for overflow

Paul Blakey (2):
      net/mlx5e: Fix CT rule + encap slow path offload and deletion
      net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhashtable

Pavel Begunkov (1):
      io_uring: fix wqe->lock/completion_lock deadlock

Pengcheng Yang (1):
      tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN

Pierre-Louis Bossart (1):
      ASoC: SOF: Intel: soundwire: fix select/depend unmet dependencies

Po-Hsu Lin (1):
      selftests: xfrm: fix test return value override issue in xfrm_policy.sh

Quentin Perret (1):
      KVM: Documentation: Fix spec for KVM_CAP_ENABLE_CAP_VM

Rafael J. Wysocki (1):
      ACPI: thermal: Do not call acpi_thermal_check() directly

Randy Dunlap (1):
      firmware: imx: select SOC_BUS to fix firmware build

Ricardo Ribalda (2):
      media: hantro: Fix reset_raw_fmt initialization
      ASoC: Intel: Skylake: skl-topology: Fix OOPs ib skl_tplg_complete

Rob Herring (1):
      ARM: zImage: atags_to_fdt: Fix node names on added root nodes

Roger Pau Monne (1):
      xen-blkfront: allow discard-* nodes to be optional

Roi Dayan (1):
      net/mlx5: Fix memory leak on flow table creation error flow

Rouven Czerwinski (1):
      tee: optee: replace might_sleep with cond_resched

Russell King (1):
      ARM: dts: imx6qdl-sr-som: fix some cubox-i platforms

Sean Young (1):
      media: rc: ensure that uevent can be read directly after rc device register

Shmulik Ladkani (1):
      xfrm: Fix oops in xfrm_replay_advance_bmp

Soeren Moch (1):
      ARM: dts: tbs2910: rename MMC node aliases

Srinivas Kandagatla (3):
      ASoC: dt-bindings: lpass: Fix and common up lpass dai ids
      ASoC: qcom: Fix broken support to MI2S TERTIARY and QUATERNARY
      ASoC: qcom: lpass-ipq806x: fix bitwidth regmap field

Srinivasa Rao Mandadapu (1):
      ASoC: qcom: Fix incorrect volatile registers

Stefan Assmann (1):
      i40e: acquire VSI pointer only after VF is initialized

Stephan Gerhold (1):
      ASoC: qcom: lpass: Fix out-of-bounds DAI ID lookup

Su Yue (1):
      btrfs: fix lockdep warning due to seqcount_mutex on 32bit arch

Sudeep Holla (1):
      drivers: soc: atmel: Avoid calling at91_soc_init on non AT91 SoCs

Suravee Suthikulpanit (1):
      iommu/amd: Use IVHD EFR for early initialization of IOMMU features

Takashi Iwai (1):
      ALSA: hda/via: Apply the workaround generically for Clevo machines

Takeshi Misawa (1):
      rxrpc: Fix memory leak in rxrpc_lookup_local

Tony Krowiak (1):
      s390/vfio-ap: No need to disable IRQ after queue reset

Trond Myklebust (2):
      pNFS/NFSv4: Fix a layout segment leak in pnfs_layout_process()
      pNFS/NFSv4: Update the layout barrier when we schedule a layoutreturn

Tvrtko Ursulin (1):
      drm/i915/pmu: Don't grab wakeref when enabling events

Tzung-Bi Shih (2):
      ASoC: mediatek: mt8183-da7219: ignore TDM DAI link by default
      ASoC: mediatek: mt8183-mt6358: ignore TDM DAI link by default

Umesh Nerlige Ramappa (1):
      drm/i915: Check for all subplatform bits

Visa Hankala (1):
      xfrm: Fix wraparound in xfrm_policy_addr_delta()

Yannick Fertre (1):
      media: cec: add stm32 driver

Yong Wu (1):
      of/device: Update dma_range_map only when dev has valid dma-ranges

