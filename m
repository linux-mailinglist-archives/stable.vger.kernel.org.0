Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307E8366A41
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 13:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbhDUL6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 07:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239339AbhDUL6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 07:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 034B16144A;
        Wed, 21 Apr 2021 11:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619006266;
        bh=naCpWbYAdL822AS3zNefyCQEIFRoBO4QXNOZ01lstds=;
        h=From:To:Cc:Subject:Date:From;
        b=LWK0jvAPKHixEyysJQz/tMRfsF60icdRyLHRejzfX0IiNq/bJwTCC3ZbNVa0saQSw
         0st26DuAO6FOAOTrF6DAZT4CRkoWC3sVwCqtJsT85bBvN+o8FJUU2tcIm/WdjMpvZm
         0oR4JQKytUwvSQrDETXBTgCYc138mlj/umnc5Yng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.16
Date:   Wed, 21 Apr 2021 13:57:33 +0200
Message-Id: <161900625349118@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.16 kernel.

All users of the 5.11 kernel series must upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                       |    2 
 arch/arc/kernel/signal.c                                       |    4 
 arch/arm/Kconfig                                               |    8 
 arch/arm/boot/dts/omap4.dtsi                                   |    5 
 arch/arm/boot/dts/omap44xx-clocks.dtsi                         |    8 
 arch/arm/boot/dts/omap5.dtsi                                   |    5 
 arch/arm/mach-footbridge/cats-pci.c                            |    4 
 arch/arm/mach-footbridge/ebsa285-pci.c                         |    4 
 arch/arm/mach-footbridge/netwinder-pci.c                       |    2 
 arch/arm/mach-footbridge/personal-pci.c                        |    5 
 arch/arm/mach-keystone/keystone.c                              |    4 
 arch/arm/mach-omap1/ams-delta-fiq-handler.S                    |    1 
 arch/arm/mach-omap2/board-generic.c                            |    2 
 arch/arm/mach-omap2/sr_device.c                                |    2 
 arch/arm/mm/mmu.c                                              |    3 
 arch/arm/mm/pmsa-v7.c                                          |    4 
 arch/arm/mm/pmsa-v8.c                                          |    4 
 arch/arm/probes/uprobes/core.c                                 |    4 
 arch/arm64/Kconfig                                             |    6 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts        |    4 
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi           |    2 
 arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts        |    4 
 arch/arm64/include/asm/alternative-macros.h                    |    8 
 arch/arm64/include/asm/word-at-a-time.h                        |   10 
 arch/arm64/kernel/entry.S                                      |   10 
 arch/arm64/kernel/sleep.S                                      |    2 
 arch/ia64/configs/generic_defconfig                            |    2 
 arch/powerpc/kernel/signal_32.c                                |   20 -
 arch/riscv/Kconfig                                             |    2 
 arch/x86/kernel/acpi/wakeup_64.S                               |    2 
 arch/x86/kernel/setup.c                                        |    5 
 arch/x86/kvm/vmx/nested.c                                      |   42 +--
 arch/x86/kvm/vmx/vmx.c                                         |   78 ++---
 arch/x86/kvm/vmx/vmx.h                                         |   25 +
 drivers/dma/dmaengine.c                                        |    1 
 drivers/dma/dw/Kconfig                                         |    2 
 drivers/dma/idxd/device.c                                      |   65 +++-
 drivers/dma/idxd/idxd.h                                        |    3 
 drivers/dma/idxd/init.c                                        |   11 
 drivers/dma/idxd/irq.c                                         |    4 
 drivers/dma/idxd/sysfs.c                                       |   19 -
 drivers/dma/plx_dma.c                                          |   18 -
 drivers/gpio/gpiolib-sysfs.c                                   |    8 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.h              |    1 
 drivers/gpu/drm/i915/display/vlv_dsi.c                         |    4 
 drivers/gpu/drm/i915/intel_pm.c                                |    4 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                          |    4 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                          |    4 
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                            |    2 
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c                            |    4 
 drivers/gpu/drm/xen/xen_drm_front.c                            |    6 
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c                         |   40 ++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h                         |    1 
 drivers/hid/wacom_wac.c                                        |    6 
 drivers/input/keyboard/nspire-keypad.c                         |   56 ++--
 drivers/input/serio/i8042-x86ia64io.h                          |    1 
 drivers/input/touchscreen/s6sy761.c                            |    4 
 drivers/md/dm-verity-fec.c                                     |   11 
 drivers/md/dm-verity-fec.h                                     |    1 
 drivers/mtd/nand/raw/mtk_nand.c                                |    4 
 drivers/net/dsa/mv88e6xxx/chip.c                               |   30 --
 drivers/net/ethernet/amd/pcnet32.c                             |    5 
 drivers/net/ethernet/cadence/macb_main.c                       |    2 
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  102 -------
 drivers/net/ethernet/davicom/dm9000.c                          |    6 
 drivers/net/ethernet/ibm/ibmvnic.c                             |   25 -
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |    6 
 drivers/net/ethernet/intel/ice/ice_dcb.c                       |    4 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |   14 -
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c              |   23 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |    3 
 drivers/net/ethernet/realtek/r8169_main.c                      |   18 -
 drivers/net/ethernet/xilinx/xilinx_axienet.h                   |   12 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c              |   12 
 drivers/net/phy/marvell.c                                      |   32 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                  |    1 
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                   |    7 
 drivers/net/wireless/virt_wifi.c                               |    5 
 drivers/nvdimm/region_devs.c                                   |    9 
 drivers/remoteproc/pru_rproc.c                                 |   18 +
 drivers/scsi/libsas/sas_ata.c                                  |    9 
 drivers/scsi/scsi_transport_srp.c                              |    2 
 drivers/vfio/pci/vfio_pci.c                                    |    4 
 fs/readdir.c                                                   |    6 
 include/linux/bpf.h                                            |    2 
 include/linux/kasan.h                                          |    2 
 include/linux/marvell_phy.h                                    |    5 
 include/linux/netfilter_arp/arp_tables.h                       |    5 
 include/linux/netfilter_bridge/ebtables.h                      |    5 
 include/uapi/linux/idxd.h                                      |    4 
 kernel/bpf/trampoline.c                                        |   30 ++
 kernel/bpf/verifier.c                                          |  138 ++++++----
 kernel/locking/lockdep.c                                       |    3 
 lib/Kconfig.debug                                              |    6 
 lib/Kconfig.kasan                                              |    9 
 mm/kasan/common.c                                              |    2 
 mm/kasan/kasan.h                                               |    2 
 mm/kasan/report_generic.c                                      |    2 
 mm/ptdump.c                                                    |    2 
 net/bridge/netfilter/ebtable_broute.c                          |    8 
 net/bridge/netfilter/ebtable_filter.c                          |    8 
 net/bridge/netfilter/ebtable_nat.c                             |    8 
 net/bridge/netfilter/ebtables.c                                |   30 +-
 net/core/dev.c                                                 |    3 
 net/core/neighbour.c                                           |    2 
 net/ethtool/pause.c                                            |    8 
 net/ieee802154/nl802154.c                                      |   41 ++
 net/ipv4/netfilter/arp_tables.c                                |    9 
 net/ipv4/netfilter/arptable_filter.c                           |   10 
 net/ipv4/sysctl_net_ipv4.c                                     |   16 -
 net/ipv6/ip6_tunnel.c                                          |   10 
 net/ipv6/sit.c                                                 |    4 
 net/mac80211/cfg.c                                             |    4 
 net/netfilter/nf_conntrack_standalone.c                        |    1 
 net/netfilter/nf_flow_table_offload.c                          |    6 
 net/netfilter/nf_tables_api.c                                  |   46 ++-
 net/netfilter/nft_limit.c                                      |    4 
 net/sctp/socket.c                                              |   13 
 net/xfrm/xfrm_output.c                                         |   13 
 scripts/Makefile.kasan                                         |   20 -
 security/Kconfig.hardening                                     |    4 
 sound/soc/codecs/max98373-i2c.c                                |    1 
 sound/soc/codecs/max98373-sdw.c                                |    1 
 sound/soc/codecs/max98373.c                                    |    2 
 sound/soc/fsl/fsl_esai.c                                       |    8 
 tools/include/uapi/asm/errno.h                                 |    2 
 tools/lib/bpf/xsk.c                                            |    5 
 127 files changed, 916 insertions(+), 520 deletions(-)

A. Cody Schuffelen (1):
      virt_wifi: Return micros for BSS TSF values

Alexander Aring (11):
      net: ieee802154: stop dump llsec keys for monitors
      net: ieee802154: forbid monitor for add llsec key
      net: ieee802154: forbid monitor for del llsec key
      net: ieee802154: stop dump llsec devs for monitors
      net: ieee802154: forbid monitor for add llsec dev
      net: ieee802154: forbid monitor for del llsec dev
      net: ieee802154: stop dump llsec devkeys for monitors
      net: ieee802154: forbid monitor for add llsec devkey
      net: ieee802154: forbid monitor for del llsec devkey
      net: ieee802154: stop dump llsec seclevels for monitors
      net: ieee802154: forbid monitor for add llsec seclevel

Alexander Duyck (1):
      ixgbe: Fix NULL pointer dereference in ethtool loopback test

Alexander Shiyan (1):
      ASoC: fsl_esai: Fix TDM slot setup for I2S mode

Andre Przywara (1):
      arm64: dts: allwinner: Fix SD card CD GPIO for SOPine systems

Andy Shevchenko (1):
      dmaengine: dw: Make it dependent to HAS_IOMEM

Ard Biesheuvel (1):
      ARM: 9063/1: mm: reduce maximum number of CPUs if DEBUG_KMAP_LOCAL is enabled

Arnd Bergmann (4):
      ARM: keystone: fix integer overflow warning
      ARM: omap1: fix building with clang IAS
      Input: i8042 - fix Pegatron C15B ID entry
      kasan: fix hwasan build for gcc

Aya Levin (1):
      net/mlx5e: Fix setting of RS FEC mode

Caleb Connolly (1):
      Input: s6sy761 - fix coordinate read bit shift

Catalin Marinas (1):
      arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is set atomically

Christian A. Ehrhardt (1):
      vfio/pci: Add missing range check in vfio_pci_mmap

Christophe JAILLET (1):
      net: davicom: Fix regulator not turned off on failed probe

Christophe Leroy (2):
      powerpc/signal32: Fix Oops on sigreturn with unmapped VDSO
      mm: ptdump: fix build failure

Ciara Loftus (1):
      libbpf: Fix potential NULL pointer dereference

Claudiu Beznea (1):
      net: macb: fix the restore of cmp registers

Colin Ian King (1):
      ice: Fix potential infinite loop when using u8 loop counter

Dan Carpenter (1):
      dmaengine: plx_dma: add a missing put_device() on error path

Daniel Borkmann (6):
      bpf: Use correct permission flag for mixed signed bounds arithmetic
      bpf: Ensure off_reg has no mixed signed bounds for all types
      bpf: Move off_reg into sanitize_ptr_alu
      bpf: Rework ptr_limit into alu_limit and add common error path
      bpf: Improve verifier error messages for users
      bpf: Move sanitize_val_alu out of op switch

Daniel Mack (1):
      net: axienet: allow setups without MDIO

Dave Jiang (6):
      dmaengine: idxd: Fix clobbering of SWERR overflow bit on writeback
      dmaengine: idxd: fix delta_rec and crc size field for completion record
      dmaengine: idxd: fix opcap sysfs attribute output
      dmaengine: idxd: fix wq size store permission state
      dmaengine: idxd: clear MSIX permission entry on shutdown
      dmaengine: idxd: fix wq cleanup of WQCFG registers

Dimitar Dimitrov (1):
      remoteproc: pru: Fix loading of GNU Binutils ELF

Eric Dumazet (2):
      netfilter: nft_limit: avoid possible divide error in nft_limit_init
      gro: ensure frag0 meets IP header alignment

Fabian Vogt (1):
      Input: nspire-keypad - enable interrupts only when opened

Florian Westphal (2):
      netfilter: bridge: add pre_exit hooks for ebtable unregistration
      netfilter: arp_tables: add pre_exit hook for table unregister

Fredrik Strupe (1):
      ARM: 9071/1: uprobes: Don't hook on thumb instructions

Greg Kroah-Hartman (1):
      Linux 5.11.16

Guenter Roeck (1):
      pcnet32: Use pci_resource_len to validate PCI resource

Hans de Goede (4):
      AMD_SFH: Removed unused activecontrolstatus member from the amd_mp2_dev struct
      AMD_SFH: Add sensor_mask module parameter
      AMD_SFH: Add DMI quirk table for BIOS-es which don't set the activestatus bits
      drm/i915/display/vlv_dsi: Do not skip panel_pwr_cycle_delay when disabling the panel

Hauke Mehrtens (1):
      mtd: rawnand: mtk: Fix WAITRDY break condition and timeout

Heiner Kallweit (2):
      r8169: tweak max read request size for newer chips also in jumbo mtu mode
      r8169: don't advertise pause in jumbo mode

Hristo Venev (2):
      net: sit: Unregister catch-all devices
      net: ip6_tunnel: Unregister catch-all devices

Jaegeuk Kim (1):
      dm verity fec: fix misaligned RS roots IO

Jakub Kicinski (1):
      ethtool: pause: make sure we init driver stats

Jason Xing (1):
      i40e: fix the panic when running bpf in xdpdrv mode

Jernej Skrabec (1):
      arm64: dts: allwinner: h6: beelink-gs1: Remove ext. 32 kHz osc reference

Jiri Kosina (1):
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()

Jiri Olsa (1):
      bpf: Take module reference for trampoline in module

John Paul Adrian Glaubitz (1):
      ia64: tools: remove inclusion of ia64-specific version of errno.h header

Jolly Shah (1):
      scsi: libsas: Reset num_scatter if libata marks qc as NODATA

Jonathon Reinhart (1):
      net: Make tcp_allowed_congestion_control readonly in non-init netns

Julian Braha (1):
      lib: fix kconfig dependency on ARCH_WANT_FRAME_POINTERS

Kefeng Wang (1):
      riscv: Fix spelling mistake "SPARSEMEM" to "SPARSMEM"

Lijun Pan (4):
      ibmvnic: correctly use dev_consume/free_skb_irq
      ibmvnic: avoid calling napi_disable() twice
      ibmvnic: remove duplicate napi_schedule call in do_reset function
      ibmvnic: remove duplicate napi_schedule call in open function

Linus Torvalds (1):
      readdir: make sure to verify directory entry for legacy interfaces too

Lv Yunlong (2):
      dmaengine: Fix a double free in dma_async_device_register
      gpu/xen: Fix a use after free in xen_drm_drv_init

Martin Wilck (1):
      scsi: scsi_transport_srp: Don't block target in SRP_PORT_LOST state

Matt Chen (1):
      iwlwifi: add support for Qu with AX201 device

Matti Vaittinen (1):
      gpio: sysfs: Obey valid_mask

Nathan Chancellor (1):
      arm64: alternatives: Move length validation in alternative_{insn, endif}

Or Cohen (1):
      net/sctp: fix race condition in sctp_destroy_sock

Pablo Neira Ayuso (3):
      netfilter: flowtable: fix NAT IPv6 offload mangling
      netfilter: conntrack: do not print icmpv6 as unknown via /proc
      netfilter: nftables: clone set element expression template

Pali Rohár (1):
      net: phy: marvell: fix detection of PHY on Topaz switches

Peter Collingbourne (1):
      arm64: fix inline asm in load_unaligned_zeropad()

Ping Cheng (1):
      HID: wacom: set EV_KEY and EV_ABS only for non-HID_GENERIC type of devices

Qingqing Zhuo (1):
      drm/amd/display: Add missing mask for DCN3

Rafael J. Wysocki (1):
      ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()

Randy Dunlap (1):
      ia64: remove duplicate entries in generic_defconfig

Reiji Watanabe (1):
      KVM: VMX: Don't use vcpu->run->internal.ndata as an array index

Rob Clark (1):
      drm/msm: Fix a5xx/a6xx timestamps

Russell King (1):
      ARM: footbridge: fix PCI interrupt mapping

Ryan Lee (2):
      ASoC: max98373: Changed amp shutdown register as volatile
      ASoC: max98373: Added 30ms turn on/off time delay

Sean Christopherson (1):
      KVM: VMX: Convert vcpu_vmx.exit_reason to a union

Seevalamuthu Mariappan (1):
      mac80211: clear sta->fast_rx when STA removed from 4-addr VLAN

Tetsuo Handa (1):
      lockdep: Add a missing initialization hint to the "INFO: Trying to register non-static key" message

Tong Zhu (1):
      neighbour: Disregard DEAD dst in neigh_update

Tony Lindgren (4):
      ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race
      ARM: dts: Fix moving mmc devices with aliases for omap4 & 5
      ARM: OMAP2+: Fix warning for omap_init_time_of()
      ARM: OMAP2+: Fix uninitialized sr_inst

Vaibhav Jain (1):
      libnvdimm/region: Fix nvdimm_has_flush() to handle ND_REGION_ASYNC

Ville Syrjälä (1):
      drm/i915: Don't zero out the Y plane's watermarks

Vinay Kumar Yadav (4):
      ch_ktls: Fix kernel panic
      ch_ktls: fix device connection close
      ch_ktls: tcb close causes tls connection failure
      ch_ktls: do not send snd_una update to TCB in middle

Vladimir Murzin (1):
      ARM: 9069/1: NOMMU: Fix conversion for_each_membock() to for_each_mem_range()

Walter Wu (1):
      kasan: remove redundant config option

Wang Qing (1):
      arc: kernel: Return -EFAULT if copy_to_user() fails

Xin Long (1):
      xfrm: BEET mode doesn't support fragments for inner packets

Yongxin Liu (1):
      ixgbe: fix unbalanced device enable/disable in suspend/resume

Zack Rusin (1):
      drm/vmwgfx: Make sure we unpin no longer needed buffers

wenxu (1):
      net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta

