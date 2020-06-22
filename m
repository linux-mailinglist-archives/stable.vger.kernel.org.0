Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7781B20318B
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgFVIJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 04:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgFVIIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 04:08:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5EB5208B8;
        Mon, 22 Jun 2020 08:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813330;
        bh=85NOwtYuzsNvplqco4MN65Owq5q9y2qsUkbO92OMe8k=;
        h=From:To:Cc:Subject:Date:From;
        b=I8VWw2PmTN9AQdC5oRpnNBN85cfyrDnS2xZ8La2PC4Tbb/tBffMmvz2q+SJ8ocBYc
         P7eQSl9Kot5B4sZ0mHZKRWlPXN+wnhFvXSbzaSZ/id33GnrClGMdvwyPVaRCUfWbRa
         3l1gi9kVIsV1Z2RvS5moIadgBu+TuBLUZdn6kZGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.48
Date:   Mon, 22 Jun 2020 10:08:33 +0200
Message-Id: <15928133133012@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.48 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.txt |    6 
 Documentation/virt/kvm/api.txt                                      |    2 
 Makefile                                                            |   15 
 arch/alpha/include/asm/io.h                                         |   74 ++-
 arch/alpha/kernel/io.c                                              |   60 ++
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts                           |    2 
 arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi                         |    2 
 arch/arm/boot/dts/s5pv210-aries.dtsi                                |    1 
 arch/arm/mach-tegra/tegra.c                                         |    4 
 arch/arm/mm/proc-macros.S                                           |    3 
 arch/arm64/include/asm/cacheflush.h                                 |    6 
 arch/arm64/include/asm/pgtable.h                                    |    1 
 arch/arm64/kernel/head.S                                            |   12 
 arch/arm64/kernel/insn.c                                            |   14 
 arch/arm64/kernel/vmlinux.lds.S                                     |    1 
 arch/m68k/include/asm/mac_via.h                                     |    1 
 arch/m68k/mac/config.c                                              |   21 
 arch/m68k/mac/via.c                                                 |    6 
 arch/mips/Makefile                                                  |   13 
 arch/mips/boot/compressed/Makefile                                  |    2 
 arch/mips/configs/loongson3_defconfig                               |    2 
 arch/mips/include/asm/cpu-features.h                                |    6 
 arch/mips/include/asm/mipsregs.h                                    |    2 
 arch/mips/kernel/genex.S                                            |    6 
 arch/mips/kernel/mips-cm.c                                          |    6 
 arch/mips/kernel/setup.c                                            |   10 
 arch/mips/kernel/time.c                                             |   70 +++
 arch/mips/kernel/vmlinux.lds.S                                      |    2 
 arch/mips/tools/elf-entry.c                                         |    9 
 arch/powerpc/Kconfig                                                |    2 
 arch/powerpc/include/asm/book3s/32/kup.h                            |    3 
 arch/powerpc/include/asm/fadump-internal.h                          |    4 
 arch/powerpc/include/asm/kasan.h                                    |    6 
 arch/powerpc/kernel/dt_cpu_ftrs.c                                   |    8 
 arch/powerpc/kernel/fadump.c                                        |  155 ++++--
 arch/powerpc/kernel/prom.c                                          |   19 
 arch/powerpc/mm/init_32.c                                           |    2 
 arch/powerpc/mm/kasan/kasan_init_32.c                               |    4 
 arch/powerpc/mm/pgtable_32.c                                        |    4 
 arch/powerpc/platforms/cell/spufs/file.c                            |  113 +++-
 arch/powerpc/platforms/powernv/smp.c                                |    1 
 arch/sparc/kernel/ptrace_32.c                                       |  228 ++++------
 arch/sparc/kernel/ptrace_64.c                                       |   17 
 arch/x86/boot/compressed/head_32.S                                  |    5 
 arch/x86/boot/compressed/head_64.S                                  |    1 
 arch/x86/include/asm/smap.h                                         |   11 
 arch/x86/kernel/amd_nb.c                                            |    8 
 arch/x86/kernel/irq_64.c                                            |    2 
 arch/x86/mm/init.c                                                  |    2 
 block/blk-iocost.c                                                  |   28 +
 block/blk-mq.c                                                      |   26 -
 drivers/acpi/acpica/dsfield.c                                       |   17 
 drivers/acpi/arm64/iort.c                                           |    5 
 drivers/acpi/evged.c                                                |    2 
 drivers/bluetooth/btbcm.c                                           |    2 
 drivers/bluetooth/btmtkuart.c                                       |   14 
 drivers/bluetooth/hci_bcm.c                                         |    5 
 drivers/clk/mediatek/clk-mux.c                                      |    2 
 drivers/clocksource/dw_apb_timer.c                                  |    5 
 drivers/clocksource/dw_apb_timer_of.c                               |    6 
 drivers/cpuidle/sysfs.c                                             |    6 
 drivers/crypto/ccp/Kconfig                                          |    3 
 drivers/crypto/chelsio/chcr_algo.c                                  |    2 
 drivers/crypto/stm32/stm32-crc32.c                                  |  144 +++---
 drivers/edac/amd64_edac.c                                           |   13 
 drivers/edac/amd64_edac.h                                           |    3 
 drivers/firmware/efi/libstub/Makefile                               |    1 
 drivers/gnss/sirf.c                                                 |    8 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c                             |   43 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c                              |   14 
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c                              |   11 
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c                      |   12 
 drivers/gpu/drm/mcde/mcde_dsi.c                                     |    7 
 drivers/gpu/drm/mediatek/mtk_dpi.c                                  |   31 +
 drivers/gpu/drm/rcar-du/rcar_du_plane.c                             |   16 
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c                               |   14 
 drivers/hv/connection.c                                             |   20 
 drivers/hv/hv.c                                                     |    7 
 drivers/hv/hyperv_vmbus.h                                           |   11 
 drivers/hv/vmbus_drv.c                                              |   20 
 drivers/hwmon/k10temp.c                                             |    1 
 drivers/macintosh/windfarm_pm112.c                                  |   21 
 drivers/md/bcache/super.c                                           |    7 
 drivers/md/dm-crypt.c                                               |    2 
 drivers/md/md.c                                                     |    3 
 drivers/md/raid5.c                                                  |   15 
 drivers/media/cec/cec-adap.c                                        |    8 
 drivers/media/dvb-core/dvbdev.c                                     |    5 
 drivers/media/i2c/ov5640.c                                          |    4 
 drivers/media/platform/rcar-fcp.c                                   |    5 
 drivers/media/platform/vicodec/vicodec-core.c                       |   15 
 drivers/media/tuners/si2157.c                                       |   15 
 drivers/media/usb/dvb-usb/dibusb-mb.c                               |    2 
 drivers/media/usb/go7007/snd-go7007.c                               |   35 -
 drivers/mmc/host/meson-mx-sdio.c                                    |    3 
 drivers/mmc/host/sdhci-esdhc-imx.c                                  |    2 
 drivers/mmc/host/sdhci-msm.c                                        |    4 
 drivers/mmc/host/via-sdmmc.c                                        |    7 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                            |   11 
 drivers/mtd/nand/raw/diskonchip.c                                   |    7 
 drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c                     |    2 
 drivers/mtd/nand/raw/mtk_nand.c                                     |    2 
 drivers/mtd/nand/raw/nand_base.c                                    |   10 
 drivers/mtd/nand/raw/nand_onfi.c                                    |    2 
 drivers/mtd/nand/raw/orion_nand.c                                   |    2 
 drivers/mtd/nand/raw/oxnas_nand.c                                   |    8 
 drivers/mtd/nand/raw/pasemi_nand.c                                  |    4 
 drivers/mtd/nand/raw/plat_nand.c                                    |    2 
 drivers/mtd/nand/raw/sharpsl.c                                      |    2 
 drivers/mtd/nand/raw/socrates_nand.c                                |    2 
 drivers/mtd/nand/raw/sunxi_nand.c                                   |    2 
 drivers/mtd/nand/raw/tmio_nand.c                                    |    2 
 drivers/mtd/nand/raw/xway_nand.c                                    |    2 
 drivers/net/ethernet/allwinner/sun4i-emac.c                         |    4 
 drivers/net/ethernet/amazon/ena/ena_com.c                           |    6 
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                     |    6 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                      |    4 
 drivers/net/ethernet/broadcom/genet/bcmgenet.h                      |    2 
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c                  |   39 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                    |    4 
 drivers/net/ethernet/intel/e1000/e1000_main.c                       |    4 
 drivers/net/ethernet/intel/e1000e/e1000.h                           |    1 
 drivers/net/ethernet/intel/e1000e/netdev.c                          |   16 
 drivers/net/ethernet/intel/ice/ice_common.c                         |    8 
 drivers/net/ethernet/intel/ice/ice_controlq.c                       |   49 +-
 drivers/net/ethernet/intel/ice/ice_main.c                           |    3 
 drivers/net/ethernet/intel/igb/igb_ethtool.c                        |    3 
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                     |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                       |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                     |   15 
 drivers/net/ethernet/nxp/lpc_eth.c                                  |    3 
 drivers/net/ethernet/qlogic/qede/qede.h                             |    2 
 drivers/net/ethernet/qlogic/qede/qede_main.c                        |   11 
 drivers/net/ethernet/ti/davinci_mdio.c                              |    2 
 drivers/net/macvlan.c                                               |    4 
 drivers/net/veth.c                                                  |    8 
 drivers/net/vmxnet3/vmxnet3_ethtool.c                               |    2 
 drivers/net/wireless/ath/ath10k/htt.h                               |    7 
 drivers/net/wireless/ath/ath10k/htt_tx.c                            |    8 
 drivers/net/wireless/ath/ath10k/mac.c                               |    5 
 drivers/net/wireless/ath/ath10k/pci.c                               |    1 
 drivers/net/wireless/ath/ath10k/txrx.c                              |    2 
 drivers/net/wireless/ath/ath10k/wmi-ops.h                           |   10 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                           |   15 
 drivers/net/wireless/ath/carl9170/fw.c                              |    4 
 drivers/net/wireless/ath/carl9170/main.c                            |   21 
 drivers/net/wireless/ath/wcn36xx/main.c                             |    6 
 drivers/net/wireless/broadcom/b43/main.c                            |    2 
 drivers/net/wireless/broadcom/b43legacy/main.c                      |    1 
 drivers/net/wireless/broadcom/b43legacy/xmit.c                      |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c          |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c                    |   11 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                   |    5 
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c                      |   15 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                        |   18 
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h                        |    6 
 drivers/net/wireless/marvell/libertas_tf/if_usb.c                   |    6 
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                     |   14 
 drivers/net/wireless/mediatek/mt76/agg-rx.c                         |    8 
 drivers/net/wireless/mediatek/mt76/mt76.h                           |    6 
 drivers/net/wireless/realtek/rtlwifi/usb.c                          |    8 
 drivers/net/wireless/realtek/rtw88/pci.c                            |    1 
 drivers/nvme/host/core.c                                            |   16 
 drivers/nvme/host/pci.c                                             |   57 +-
 drivers/nvme/host/tcp.c                                             |    4 
 drivers/pci/controller/vmd.c                                        |    2 
 drivers/pci/probe.c                                                 |   24 -
 drivers/pci/quirks.c                                                |   48 +-
 drivers/perf/arm_smmuv3_pmu.c                                       |    5 
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c                        |    2 
 drivers/pinctrl/samsung/pinctrl-exynos.c                            |   82 ++-
 drivers/platform/x86/asus-wmi.c                                     |    2 
 drivers/platform/x86/dell-laptop.c                                  |   11 
 drivers/platform/x86/hp-wmi.c                                       |   10 
 drivers/platform/x86/intel-hid.c                                    |    7 
 drivers/platform/x86/intel-vbtn.c                                   |   75 ++-
 drivers/power/reset/vexpress-poweroff.c                             |    1 
 drivers/power/supply/power_supply_hwmon.c                           |    4 
 drivers/regulator/qcom-rpmh-regulator.c                             |    8 
 drivers/soc/tegra/Kconfig                                           |    1 
 drivers/spi/spi-dw-mid.c                                            |   16 
 drivers/spi/spi-dw.c                                                |    8 
 drivers/spi/spi-mem.c                                               |   10 
 drivers/spi/spi-pxa2xx.c                                            |    1 
 drivers/spi/spi.c                                                   |    1 
 drivers/staging/android/ion/ion_heap.c                              |    4 
 drivers/staging/greybus/sdio.c                                      |   10 
 drivers/staging/media/imx/imx7-mipi-csis.c                          |   82 +--
 drivers/staging/media/ipu3/ipu3-mmu.c                               |   10 
 drivers/staging/media/ipu3/ipu3-v4l2.c                              |   10 
 drivers/staging/media/ipu3/ipu3.c                                   |    5 
 drivers/staging/media/ipu3/ipu3.h                                   |    4 
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c                     |    2 
 drivers/staging/media/sunxi/cedrus/cedrus_video.c                   |    3 
 drivers/tty/serial/8250/8250_core.c                                 |   14 
 drivers/tty/serial/8250/8250_pci.c                                  |    6 
 drivers/tty/serial/kgdboc.c                                         |  126 ++++-
 drivers/w1/masters/omap_hdq.c                                       |   10 
 fs/btrfs/block-group.c                                              |    2 
 fs/btrfs/block-rsv.c                                                |    3 
 fs/btrfs/ctree.h                                                    |    1 
 fs/btrfs/file-item.c                                                |    6 
 fs/btrfs/inode.c                                                    |   81 +++
 fs/btrfs/qgroup.c                                                   |   14 
 fs/btrfs/send.c                                                     |   67 ++
 fs/btrfs/space-info.c                                               |   43 +
 fs/btrfs/space-info.h                                               |    1 
 fs/btrfs/transaction.c                                              |   60 +-
 fs/btrfs/transaction.h                                              |    3 
 fs/btrfs/volumes.c                                                  |   14 
 fs/ext4/ext4_extents.h                                              |    9 
 fs/ext4/fsync.c                                                     |   28 -
 fs/ext4/xattr.c                                                     |    7 
 fs/f2fs/f2fs.h                                                      |    1 
 fs/f2fs/super.c                                                     |   25 -
 fs/xfs/xfs_bmap_util.c                                              |    2 
 fs/xfs/xfs_buf.c                                                    |    8 
 fs/xfs/xfs_dquot.c                                                  |    9 
 include/linux/kgdb.h                                                |    2 
 include/linux/mmzone.h                                              |    2 
 include/linux/pci_ids.h                                             |   11 
 include/linux/sched/mm.h                                            |    2 
 include/linux/skmsg.h                                               |    8 
 include/linux/string.h                                              |   60 ++
 include/linux/sunrpc/gss_api.h                                      |    1 
 include/linux/sunrpc/svcauth_gss.h                                  |    3 
 include/net/tls.h                                                   |    9 
 include/uapi/linux/kvm.h                                            |    2 
 kernel/audit.c                                                      |   52 +-
 kernel/audit.h                                                      |    2 
 kernel/auditfilter.c                                                |   16 
 kernel/bpf/syscall.c                                                |    3 
 kernel/cpu.c                                                        |   18 
 kernel/cpu_pm.c                                                     |    4 
 kernel/debug/debug_core.c                                           |    5 
 kernel/exit.c                                                       |   25 -
 kernel/sched/core.c                                                 |   13 
 kernel/sched/fair.c                                                 |    4 
 kernel/sched/rt.c                                                   |   12 
 kernel/sched/sched.h                                                |    2 
 lib/mpi/longlong.h                                                  |    2 
 lib/test_kasan.c                                                    |   29 -
 mm/huge_memory.c                                                    |   31 +
 mm/page_alloc.c                                                     |   27 -
 net/batman-adv/bat_v_elp.c                                          |   15 
 net/bluetooth/hci_event.c                                           |    1 
 net/core/skmsg.c                                                    |   98 +++-
 net/netfilter/nft_nat.c                                             |    4 
 net/sunrpc/auth_gss/gss_mech_switch.c                               |   12 
 net/sunrpc/auth_gss/svcauth_gss.c                                   |   18 
 net/tls/tls_sw.c                                                    |   20 
 security/integrity/evm/evm_crypto.c                                 |    2 
 security/integrity/ima/ima.h                                        |   10 
 security/integrity/ima/ima_crypto.c                                 |   53 +-
 security/integrity/ima/ima_init.c                                   |   24 -
 security/integrity/ima/ima_main.c                                   |    3 
 security/integrity/ima/ima_policy.c                                 |   12 
 security/integrity/ima/ima_template_lib.c                           |   18 
 security/lockdown/lockdown.c                                        |    2 
 security/selinux/ss/policydb.c                                      |    1 
 tools/cgroup/iocost_monitor.py                                      |   42 -
 tools/lib/api/fs/fs.c                                               |   17 
 tools/lib/api/fs/fs.h                                               |   12 
 tools/lib/bpf/hashmap.c                                             |    7 
 tools/lib/bpf/libbpf.c                                              |    5 
 tools/objtool/check.c                                               |    6 
 tools/perf/builtin-probe.c                                          |    3 
 tools/perf/util/dso.c                                               |   16 
 tools/perf/util/dso.h                                               |    1 
 tools/perf/util/probe-event.c                                       |   46 +-
 tools/perf/util/probe-finder.c                                      |    1 
 tools/perf/util/symbol.c                                            |    4 
 tools/testing/selftests/bpf/config                                  |    1 
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c             |    1 
 tools/testing/selftests/bpf/test_progs.c                            |    1 
 275 files changed, 2677 insertions(+), 1240 deletions(-)

Adrian Hunter (2):
      perf symbols: Fix debuginfo search for Ubuntu
      perf symbols: Fix kernel maps for kcore and eBPF

Al Viro (2):
      sparc32: fix register window handling in genregs32_[gs]et()
      sparc64: fix misuses of access_process_vm() in genregs32_[sg]et()

Alan Maguire (1):
      selftests/bpf: CONFIG_IPV6_SEG6_BPF required for test_seg6_loop.o

Alexander Monakov (3):
      x86/amd_nb: Add AMD family 17h model 60h PCI IDs
      hwmon: (k10temp) Add AMD family 17h model 60h PCI match
      EDAC/amd64: Add AMD family 17h model 60h PCI IDs

Alexander Sverdlin (1):
      macvlan: Skip loopback packets in RX handler

Anand Jain (2):
      btrfs: free alien device after device add
      btrfs: include non-missing as a qualifier for the latest_bdev

Anders Roxell (1):
      power: vexpress: add suppress_bind_attrs to true

Andrea Arcangeli (1):
      mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()

Andrea Parri (Microsoft) (1):
      Drivers: hv: vmbus: Always handle the VMBus messages on CPU0

Andrii Nakryiko (2):
      libbpf: Fix memory leak and possible double-free in hashmap__clear
      selftests/bpf: Fix memory leak in extract_build_id()

Andy Shevchenko (3):
      spi: dw: Zero DMA Tx and Rx configurations on stack
      spi: Respect DataBitLength field of SpiSerialBusV2() ACPI resource
      platform/x86: hp-wmi: Convert simple_strtoul() to kstrtou32()

Anton Protopopov (1):
      bpf: Fix map permissions check

Ard Biesheuvel (2):
      ACPI: GED: use correct trigger type field in _Exx / _Lxx handling
      efi/libstub/x86: Work around LLVM ELF quirk build regression

Arnd Bergmann (1):
      crypto: ccp -- don't "select" CONFIG_DMADEVICES

Arthur Kiyanovski (1):
      net: ena: fix error returning in ena_com_get_hash_function()

Arvind Sankar (2):
      x86/boot: Correct relocation destination on old linkers
      x86/mm: Stop printing BRK addresses

Ashok Raj (2):
      PCI: Add ACS quirk for Intel Root Complex Integrated Endpoints
      PCI: Program MPS for RCiEP devices

Bhupesh Sharma (1):
      net: qed*: Reduce RX and TX default ring count when running inside kdump kernel

Bingbu Cao (2):
      media: staging: imgu: do not hold spinlock during freeing mmu page table
      media: staging/intel-ipu3: Implement lock for stream on/off operations

Bjorn Andersson (1):
      regulator: qcom-rpmh: Fix typos in pm8150 and pm8150l

Bogdan Togorean (1):
      drm: bridge: adv7511: Extend list of audio sample rates

Boris Brezillon (1):
      mtd: rawnand: Fix nand_gpio_waitrdy()

Brad Love (2):
      media: si2157: Better check for running tuner in init
      media: dvbdev: Fix tuner->demod media controller link

Brian Foster (2):
      xfs: reset buffer write failure state on successful completion
      xfs: fix duplicate verification from xfs_qm_dqflush()

Chris Chiu (1):
      platform/x86: asus_wmi: Reserve more space for struct bias_args

Christian König (1):
      drm/amdgpu: fix and cleanup amdgpu_gem_object_close v4

Christian Lamparter (1):
      carl9170: remove P2P_GO support

Christoph Hellwig (3):
      x86: fix vmap arguments in map_irq_stack
      staging: android: ion: use vmap instead of vm_map_ram
      nvme: refine the Qemu Identify CNS quirk

Christophe JAILLET (1):
      wcn36xx: Fix error handling path in 'wcn36xx_probe()'

Christophe Leroy (5):
      powerpc/mm: Fix conditions to perform MMU specific management by blocks on PPC32.
      powerpc/32s: Fix another build failure with CONFIG_PPC_KUAP_DEBUG
      powerpc/kasan: Fix issues by lowering KASAN_SHADOW_END
      powerpc/kasan: Fix shadow pages allocation failure
      powerpc/32: Disable KASAN with pages bigger than 16k

Chuhong Yuan (2):
      Bluetooth: btmtkuart: Improve exception handling in btmtuart_probe()
      media: go7007: fix a miss of snd_card_free

Colin Ian King (2):
      media: dvb: return -EREMOTEIO on i2c transfer failure.
      libertas_tf: avoid a null dereference in pointer priv

Coly Li (2):
      raid5: remove gfp flags from scribble_alloc()
      bcache: fix refcount underflow in bcache_device_free()

Corentin Labbe (1):
      soc/tegra: pmc: Select GENERIC_PINCONF

Dan Carpenter (3):
      media: vicodec: Fix error codes in probe function
      media: cec: silence shift wrapping warning in __cec_s_log_addrs()
      rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()

Daniel Axtens (2):
      kasan: stop tests being eliminated as dead code with FORTIFY_SOURCE
      string.h: fix incompatibility between FORTIFY_SOURCE and KASAN

Daniel Jordan (1):
      mm/pagealloc.c: call touch_nmi_watchdog() on max order boundaries in deferred init

Daniel Thompson (2):
      arm64: cacheflush: Fix KGDB trap detection
      kgdb: Fix spurious true from in_dbg_master()

Darrick J. Wong (1):
      xfs: clean up the error handling in xfs_swap_extents

Dejin Zheng (1):
      rtw88: fix an issue about leak system resources

Devulapally Shiva Krishna (1):
      Crypto/chcr: fix for ccm(aes) failed test

Dmitry Osipenko (1):
      ARM: tegra: Correct PL310 Auxiliary Control Register initialization

Doug Berger (2):
      net: bcmgenet: set Rx mode before starting netif
      net: bcmgenet: Fix WoL with password after deep sleep

Douglas Anderson (4):
      kgdb: Disable WARN_CONSOLE_UNLOCKED for all kgdb
      kgdb: Prevent infinite recursive entries to the debugger
      kgdboc: Use a platform device to handle tty drivers showing up late
      kernel/cpu_pm: Fix uninitted local in cpu_pm

Eelco Chaudron (1):
      libbpf: Fix perf_buffer__free() API for sparse allocs

Erez Shitrit (1):
      net/mlx5e: IPoIB, Drop multicast packets that this interface sent

Eric Biggers (2):
      ext4: fix race between ext4_sync_parent() and rename()
      dm crypt: avoid truncating the logical block size

Erik Kaneda (1):
      ACPICA: Dispatcher: add status checks

Evan Green (1):
      spi: pxa2xx: Apply CS clk quirk to BXT

Felix Kuehling (1):
      drm/amdgpu: Sync with VM root BO when switching VM to CPU update mode

Filipe Manana (4):
      btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums
      btrfs: fix wrong file range cleanup after an error filling dealloc range
      btrfs: fix space_info bytes_may_use underflow after nocow buffered write
      btrfs: fix space_info bytes_may_use underflow during space cache writeout

Finn Thain (1):
      m68k: mac: Don't call via_flush_cache() on Mac IIfx

Gavin Shan (1):
      arm64/kernel: Fix range on invalidating dcache for boot page tables

Geert Uytterhoeven (1):
      spi: spi-mem: Fix Dual/Quad modes on Octal-capable devices

Greg Kroah-Hartman (1):
      Linux 5.4.48

Guoqing Jiang (1):
      md: don't flush workqueue unconditionally in md_open

H. Nikolaus Schaller (1):
      w1: omap-hdq: cleanup to add missing newline for some dev_dbg

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: fix the mask for tuning start point

Hans de Goede (6):
      Bluetooth: btbcm: Add 2 missing models to subver tables
      platform/x86: intel-vbtn: Use acpi_evaluate_integer()
      platform/x86: intel-vbtn: Split keymap into buttons and switches parts
      platform/x86: intel-vbtn: Do not advertise switches to userspace if they are not there
      platform/x86: intel-vbtn: Also handle tablet-mode switch on "Detachable" and "Portable" chassis-types
      platform/x86: intel-vbtn: Only blacklist SW_TABLET_MODE on the 9 / "Laptop" chasis-type

Hari Bathini (3):
      powerpc/fadump: use static allocation for reserved memory ranges
      powerpc/fadump: consider reserved ranges while reserving memory
      powerpc/fadump: Account for memory_limit while reserving memory

Harshad Shirwadkar (1):
      ext4: fix EXT_MAX_EXTENT/INDEX to check for zeroed eh_max

Hsin-Yu Chao (1):
      Bluetooth: Add SCO fallback for invalid LMP parameters error

Huaixin Chang (2):
      sched/fair: Refill bandwidth before scaling
      sched: Defend cfs and rt bandwidth quota against overflow

Jacob Keller (1):
      ice: fix potential double free in probe unrolling

Jaegeuk Kim (1):
      f2fs: fix checkpoint=disable:%u%%

Jaehoon Chung (1):
      brcmfmac: fix wrong location to get firmware feature

Jakub Sitnicki (1):
      selftests/bpf, flow_dissector: Close TAP device FD after the test

Jann Horn (1):
      exit: Move preemption fixup up, move blocking operations down

Jean-Philippe Brucker (1):
      pmu/smmuv3: Clear IRQ affinity hint on device removal

Jeffle Xu (1):
      ext4: fix error pointer dereference

Jeremy Cline (1):
      lockdown: Allow unprivileged users to see lockdown status

Jeremy Kerr (1):
      powerpc/spufs: fix copy_to_user while atomic

Jesper Dangaard Brouer (3):
      ixgbe: Fix XDP redirect on archs with PAGE_SIZE above 4K
      dpaa2-eth: fix return codes used in ndo_setup_tc
      veth: Adjust hard_start offset on redirect XDP frames

Jia-Ju Bai (1):
      net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()

Jiaxun Yang (2):
      MIPS: Truncate link address into 32bit for 32bit kernel
      PCI: Don't disable decoding when mmio_always_on is set

Jitao Shi (2):
      dt-bindings: display: mediatek: control dpi pins mode to avoid leakage
      drm/mediatek: set dpi pin mode to gpio low to avoid leakage current

John Fastabend (2):
      bpf: Refactor sockmap redirect code so its easy to reuse
      bpf: Fix running sk_skb program types with ktls

Jon Derrick (1):
      PCI: vmd: Add device id for VMD device 8086:9A0B

Jon Doron (1):
      x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit

Jonathan Bakker (3):
      pinctrl: samsung: Correct setting of eint wakeup mask on s5pv210
      pinctrl: samsung: Save/restore eint_mask over suspend for EINT_TYPE GPIOs
      ARM: dts: s5pv210: Set keep-power-in-suspend for SDHCI1 on Aries

Josef Bacik (3):
      btrfs: account for trans_block_rsv in may_commit_transaction
      btrfs: improve global reserve stealing logic
      btrfs: force chunk allocation if our global rsv is larger than metadata

Julien Thierry (1):
      objtool: Ignore empty alternatives

Kai-Heng Feng (4):
      PCI: Avoid Pericom USB controller OHCI/EHCI PME# defect
      serial: 8250_pci: Move Pericom IDs to pci_ids.h
      e1000e: Disable TSO for buffer overrun workaround
      igb: Report speed and duplex as unknown when device is runtime suspended

Kaige Li (1):
      MIPS: tools: Fix resource leak in elf-entry.c

Kees Cook (1):
      e1000: Distribute switch variables for initialization

Kevin Buettner (1):
      PCI: Avoid FLR for AMD Starship USB 3.0

Kieran Bingham (1):
      media: platform: fcp: Set appropriate DMA parameters

Koba Ko (1):
      platform/x86: dell-laptop: don't register micmute LED if there is no token

Krzysztof Struczynski (3):
      ima: Fix ima digest hash table key calculation
      ima: Remove redundant policy rule set in add_rules()
      ima: Set again build_ima_appraise variable

Larry Finger (3):
      b43legacy: Fix case where channel status is corrupted
      b43: Fix connection problem with WPA3
      b43_legacy: Fix connection problem with WPA3

Laurent Pinchart (1):
      media: imx: imx7-mipi-csis: Cleanup and fix subdev pad format handling

Linus Walleij (1):
      ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE

Ludovic Desroches (1):
      ARM: dts: at91: sama5d2_ptc_ek: fix vbus pin

Lukas Wunner (1):
      serial: 8250: Avoid error message on reprobe

Luke Nelson (1):
      arm64: insn: Fix two bugs in encoding 32-bit logical immediates

Maharaja Kennadyrajan (1):
      ath10k: Fix the race condition in firmware dump work queue

Marcos Paulo de Souza (1):
      btrfs: send: emit file capabilities after chown

Marcos Scriven (1):
      PCI: Avoid FLR for AMD Matisse HD Audio & USB 3.0

Marek Szyprowski (1):
      ARM: dts: exynos: Fix GPIO polarity for thr GalaxyS3 CM36651 sensor's bus

Mark Starovoytov (1):
      net: atlantic: make hw_get_regs optional

Martin Blumenstingl (1):
      mmc: meson-mx-sdio: trigger a soft reset after a timeout or CRC error

Masahiro Yamada (1):
      kbuild: force to build vmlinux if CONFIG_MODVERSION=y

Masami Hiramatsu (3):
      perf probe: Do not show the skipped events
      perf probe: Fix to check blacklist address correctly
      perf probe: Check address correctness by map instead of _etext

Michael Ellerman (3):
      drivers/macintosh: Fix memleak in windfarm_pm112 driver
      powerpc/64s: Don't let DT CPU features set FSCR_DSCR
      powerpc/64s: Save FSCR to init_task.thread.fscr after feature init

Michał Mirosław (2):
      Bluetooth: hci_bcm: fix freeing not-requested IRQ
      power: supply: core: fix HWMON temperature labels

Mikulas Patocka (1):
      alpha: fix memory barriers so that they conform to the specification

Ming Lei (1):
      block: alloc map and request for new hardware queue

Miquel Raynal (13):
      mtd: rawnand: onfi: Fix redundancy detection check
      mtd: rawnand: diskonchip: Fix the probe error path
      mtd: rawnand: sharpsl: Fix the probe error path
      mtd: rawnand: ingenic: Fix the probe error path
      mtd: rawnand: xway: Fix the probe error path
      mtd: rawnand: orion: Fix the probe error path
      mtd: rawnand: socrates: Fix the probe error path
      mtd: rawnand: oxnas: Fix the probe error path
      mtd: rawnand: sunxi: Fix the probe error path
      mtd: rawnand: plat_nand: Fix the probe error path
      mtd: rawnand: pasemi: Fix the probe error path
      mtd: rawnand: mtk: Fix the probe error path
      mtd: rawnand: tmio: Fix the probe error path

Mordechay Goodstein (1):
      iwlwifi: avoid debug max amsdu config overwriting itself

Nathan Chancellor (1):
      lib/mpi: Fix 64-bit MIPS build with Clang

NeilBrown (2):
      sunrpc: svcauth_gss_register_pseudoflavor must reject duplicate registrations.
      sunrpc: clean up properly in gss_mech_unregister()

Nickolai Kozachenko (1):
      platform/x86: intel-hid: Add a quirk to support HP Spectre X2 (2015)

Nicolas Toromanoff (3):
      crypto: stm32/crc32 - fix ext4 chksum BUG_ON()
      crypto: stm32/crc32 - fix run-time self test issue.
      crypto: stm32/crc32 - fix multi-instance

Omar Sandoval (1):
      btrfs: fix error handling when submitting direct I/O bio

Pablo Neira Ayuso (1):
      netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported

Pali Rohár (1):
      mwifiex: Fix memory corruption in dump_station

Paul Moore (2):
      audit: fix a net reference leak in audit_send_reply()
      audit: fix a net reference leak in audit_list_rules_send()

Pavel Tatashin (2):
      mm: initialize deferred pages with interrupts enabled
      mm: call cond_resched() from deferred_init_memmap()

Peter Zijlstra (2):
      x86,smap: Fix smap_{save,restore}() alternatives
      sched/core: Fix illegal RCU from offline CPUs

Punit Agrawal (1):
      e1000e: Relax condition to trigger reset for ME workaround

Qiushi Wu (2):
      cpuidle: Fix three reference count leaks
      power: supply: core: fix memory leak in HWMON error path

Qu Wenruo (1):
      btrfs: qgroup: mark qgroup inconsistent if we're inherting snapshot to a new qgroup

Rakesh Pillai (1):
      ath10k: Remove msdu from idr when management pkt send fails

Roberto Sassu (6):
      ima: Switch to ima_hash_algo for boot aggregate
      ima: Evaluate error in init_ima()
      ima: Directly assign the ima_default_policy pointer to ima_rules
      ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()
      ima: Remove __init annotation from ima_pcrread()
      evm: Fix possible memory leak in evm_calc_hmac_or_hash()

Ryder Lee (1):
      mt76: avoid rx reorder buffer overflow

Sagi Grimberg (1):
      nvme-tcp: use bh_lock in data_ready

Samuel Holland (1):
      media: cedrus: Program output format during each run

Serge Semin (9):
      mips: Fix cpu_has_mips64r1/2 activation for MIPS32 CPUs
      spi: dw: Enable interrupts in accordance with DMA xfer mode
      clocksource: dw_apb_timer: Make CPU-affiliation being optional
      clocksource: dw_apb_timer_of: Fix missing clockevent timers
      spi: dw: Fix Rx-only DMA transfers
      mips: cm: Fix an invalid error code of INTVN_*_ERR
      mips: MAAR: Use more precise address mask
      mips: Add udelay lpj numbers adjustment
      spi: dw: Return any value retrieved from the dma_transfer callback

Shaokun Zhang (1):
      drivers/perf: hisi: Fix typo in events attribute array

Sharon (1):
      iwlwifi: mvm: fix aux station leak

Stephane Eranian (1):
      tools api fs: Make xxx__mountpoint() more scalable

Surabhi Boob (2):
      ice: Fix memory leak
      ice: Fix for memory leaks and modify ICE_FREE_CQ_BUFS

Sven Eckelmann (1):
      batman-adv: Revert "disable ethtool link speed detection when auto negotiation off"

Tejun Heo (2):
      iocost_monitor: drop string wrap around numbers when outputting json
      iocost: don't let vrate run wild while there's no saturation signal

Tiezhu Yang (3):
      MIPS: Loongson: Build ATI Radeon GPU driver as module
      MIPS: Make sparse_init() using top-down allocation
      PCI: Add Loongson vendor ID

Tomasz Figa (1):
      media: staging: ipu3: Fix stale list entries on parameter queue failure

Tomi Valkeinen (1):
      media: ov5640: fix use of destroyed mutex

Tomohito Esaki (1):
      drm: rcar-du: Set primary plane zpos immutably at initializing

Tuan Phan (1):
      ACPI/IORT: Fix PMCG node single ID mapping handling

Ulf Hansson (2):
      staging: greybus: sdio: Respect the cmd->busy_timeout from the mmc core
      mmc: via-sdmmc: Respect the cmd->busy_timeout from the mmc core

Veerabhadrarao Badiganti (1):
      mmc: sdhci-msm: Set SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 quirk

Venkateswara Naralasetty (1):
      ath10k: fix kernel null pointer dereference

Wei Yongjun (5):
      net: lpc-enet: fix error return code in lpc_mii_init()
      selinux: fix error return code in policydb_read()
      drivers: net: davinci_mdio: fix potential NULL dereference in davinci_mdio_probe()
      drm/mcde: dsi: Fix return value check in mcde_dsi_bind()
      gnss: sirf: fix error return code in sirf_probe()

Weiping Zhang (2):
      block: reset mapping if failed to update hardware queue count
      nvme-pci: align io queue count with allocted nvme_queue in nvme_probe

Weiyi Lu (1):
      clk: mediatek: assign the initial value to clk_init_data of mtk_mux

Wen Gong (2):
      ath10k: remove the max_sched_scan_reqs value
      ath10k: add flush tx packets for SDIO chip

Xie XiuQi (1):
      ixgbe: fix signed-integer-overflow warning

Yazen Ghannam (1):
      x86/amd_nb: Add Family 19h PCI IDs

YuanJunQing (1):
      MIPS: Fix IRQ tracing when call handle_fpe() and handle_msa_fpe()

Yunjian Wang (1):
      net: allwinner: Fix use correct return type for ndo_start_xmit()

chen gong (1):
      drm/amd/powerpay: Disable gfxoff when setting manual mode on picasso and raven

limingyu (1):
      drm/amdgpu: Init data to avoid oops while reading pp_num_states.

Álvaro Fernández Rojas (1):
      mtd: rawnand: brcmnand: fix hamming oob layout

