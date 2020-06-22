Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546C9203185
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgFVII4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 04:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgFVIIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 04:08:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E76920809;
        Mon, 22 Jun 2020 08:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813323;
        bh=Y4SWdzxSH1C3ii3nzalRvUXIGHAeWoNgVQnpc60TINs=;
        h=From:To:Cc:Subject:Date:From;
        b=UhpoBL6//MMDrKI2sXL7NmfTF8s8p+CrdOJCJ+AY+c7YgljN2qhRe8O7InUbdCcHz
         7If4/Ud4iREcNgyiTEHM9JX6/EBVgM/4DBAdj7vvUtS7Q6oUBkX/F7WNi3122FySb+
         bUzzdzIRSRX8+6D65IL14OUhKJ+tNgdueGbyMQxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.129
Date:   Mon, 22 Jun 2020 10:08:23 +0200
Message-Id: <159281330384197@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.129 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.txt |    6 
 Documentation/virtual/kvm/api.txt                                   |    2 
 Makefile                                                            |   15 
 arch/alpha/include/asm/io.h                                         |   74 ++
 arch/alpha/include/asm/uaccess.h                                    |    8 
 arch/alpha/kernel/io.c                                              |   60 ++
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts                           |    4 
 arch/arm/boot/dts/exynos4412-galaxy-s3.dtsi                         |    2 
 arch/arm/boot/dts/s5pv210-aries.dtsi                                |    1 
 arch/arm/include/asm/kvm_host.h                                     |    2 
 arch/arm/kernel/ptrace.c                                            |    4 
 arch/arm/mach-tegra/tegra.c                                         |    4 
 arch/arm/mm/proc-macros.S                                           |    3 
 arch/arm64/include/asm/cacheflush.h                                 |    6 
 arch/arm64/include/asm/kvm_host.h                                   |    8 
 arch/arm64/kernel/insn.c                                            |   14 
 arch/m68k/include/asm/mac_via.h                                     |    1 
 arch/m68k/mac/config.c                                              |   21 
 arch/m68k/mac/via.c                                                 |    6 
 arch/mips/Makefile                                                  |   13 
 arch/mips/boot/compressed/Makefile                                  |    2 
 arch/mips/configs/loongson3_defconfig                               |    2 
 arch/mips/include/asm/kvm_host.h                                    |    6 
 arch/mips/include/asm/mipsregs.h                                    |    2 
 arch/mips/kernel/genex.S                                            |    6 
 arch/mips/kernel/mips-cm.c                                          |    6 
 arch/mips/kernel/setup.c                                            |   10 
 arch/mips/kernel/time.c                                             |   70 ++
 arch/mips/kernel/vmlinux.lds.S                                      |    2 
 arch/openrisc/include/asm/uaccess.h                                 |    8 
 arch/powerpc/kernel/dt_cpu_ftrs.c                                   |    8 
 arch/powerpc/kernel/prom.c                                          |   19 
 arch/powerpc/platforms/cell/spufs/file.c                            |  113 ++--
 arch/powerpc/platforms/powernv/smp.c                                |    1 
 arch/powerpc/sysdev/xive/common.c                                   |    5 
 arch/sh/include/asm/uaccess.h                                       |    7 
 arch/sparc/kernel/ptrace_32.c                                       |  228 +++-----
 arch/sparc/kernel/ptrace_64.c                                       |   17 
 arch/x86/boot/compressed/head_32.S                                  |    5 
 arch/x86/boot/compressed/head_64.S                                  |    1 
 arch/x86/include/asm/cpufeatures.h                                  |    1 
 arch/x86/include/asm/nospec-branch.h                                |    1 
 arch/x86/include/asm/set_memory.h                                   |   19 
 arch/x86/include/asm/uaccess.h                                      |   12 
 arch/x86/kernel/amd_nb.c                                            |   15 
 arch/x86/kernel/cpu/amd.c                                           |    3 
 arch/x86/kernel/cpu/bugs.c                                          |   94 ++-
 arch/x86/kernel/cpu/mcheck/mce.c                                    |   11 
 arch/x86/kernel/process.c                                           |   28 -
 arch/x86/kernel/process.h                                           |    2 
 arch/x86/kernel/reboot.c                                            |    8 
 arch/x86/kernel/time.c                                              |    4 
 arch/x86/kernel/vmlinux.lds.S                                       |    4 
 arch/x86/kvm/mmu.c                                                  |   37 -
 arch/x86/kvm/svm.c                                                  |    6 
 arch/x86/kvm/vmx.c                                                  |    2 
 arch/x86/kvm/x86.c                                                  |    7 
 arch/x86/mm/init.c                                                  |    2 
 arch/x86/pci/fixup.c                                                |    4 
 drivers/acpi/cppc_acpi.c                                            |    1 
 drivers/acpi/device_pm.c                                            |    2 
 drivers/acpi/evged.c                                                |   22 
 drivers/acpi/scan.c                                                 |   28 -
 drivers/acpi/sysfs.c                                                |    4 
 drivers/bluetooth/btbcm.c                                           |    2 
 drivers/bluetooth/hci_bcm.c                                         |    5 
 drivers/char/agp/intel-gtt.c                                        |    4 
 drivers/char/ipmi/ipmi_si_pci.c                                     |    5 
 drivers/clk/clk.c                                                   |    6 
 drivers/clocksource/dw_apb_timer.c                                  |    5 
 drivers/clocksource/dw_apb_timer_of.c                               |    6 
 drivers/cpuidle/sysfs.c                                             |    6 
 drivers/crypto/cavium/nitrox/nitrox_main.c                          |    4 
 drivers/crypto/ccp/Kconfig                                          |    3 
 drivers/crypto/chelsio/chcr_algo.c                                  |    2 
 drivers/crypto/stm32/stm32_crc32.c                                  |  144 +++--
 drivers/crypto/talitos.c                                            |    2 
 drivers/crypto/virtio/virtio_crypto_algs.c                          |   21 
 drivers/dma/pch_dma.c                                               |    1 
 drivers/firmware/efi/efivars.c                                      |    4 
 drivers/firmware/efi/libstub/Makefile                               |    1 
 drivers/gnss/sirf.c                                                 |    8 
 drivers/gpio/gpio-ml-ioh.c                                          |    2 
 drivers/gpio/gpio-pch.c                                             |    1 
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c                      |   12 
 drivers/gpu/drm/i915/i915_gem_execbuffer.c                          |   16 
 drivers/gpu/drm/vkms/vkms_drv.h                                     |    5 
 drivers/gpu/drm/vkms/vkms_gem.c                                     |   11 
 drivers/hwmon/k10temp.c                                             |    9 
 drivers/i2c/busses/i2c-eg20t.c                                      |    1 
 drivers/infiniband/core/uverbs_main.c                               |    2 
 drivers/input/mouse/synaptics.c                                     |    1 
 drivers/input/touchscreen/mms114.c                                  |   12 
 drivers/isdn/hardware/mISDN/w6692.c                                 |    3 
 drivers/macintosh/windfarm_pm112.c                                  |   21 
 drivers/md/bcache/super.c                                           |    7 
 drivers/md/dm-crypt.c                                               |    2 
 drivers/md/md.c                                                     |    3 
 drivers/media/cec/cec-adap.c                                        |    8 
 drivers/media/i2c/ov5640.c                                          |    4 
 drivers/media/platform/rcar-fcp.c                                   |    5 
 drivers/media/tuners/si2157.c                                       |   15 
 drivers/media/usb/dvb-usb/dibusb-mb.c                               |    2 
 drivers/media/usb/go7007/snd-go7007.c                               |   35 -
 drivers/misc/pch_phub.c                                             |    1 
 drivers/misc/pci_endpoint_test.c                                    |   20 
 drivers/mmc/core/sdio.c                                             |    3 
 drivers/mmc/host/meson-mx-sdio.c                                    |    3 
 drivers/mmc/host/sdhci-esdhc-imx.c                                  |    2 
 drivers/mmc/host/sdhci-msm.c                                        |   10 
 drivers/mmc/host/via-sdmmc.c                                        |    7 
 drivers/mtd/nand/raw/brcmnand/brcmnand.c                            |   11 
 drivers/mtd/nand/raw/pasemi_nand.c                                  |    4 
 drivers/net/ethernet/allwinner/sun4i-emac.c                         |    4 
 drivers/net/ethernet/amazon/ena/ena_com.c                           |    6 
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                     |    6 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                      |    4 
 drivers/net/ethernet/ibm/ibmvnic.c                                  |    8 
 drivers/net/ethernet/intel/e1000/e1000_main.c                       |    4 
 drivers/net/ethernet/intel/e1000e/e1000.h                           |    1 
 drivers/net/ethernet/intel/e1000e/netdev.c                          |   16 
 drivers/net/ethernet/intel/igb/igb_ethtool.c                        |    3 
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                     |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                       |    3 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                     |   15 
 drivers/net/ethernet/nxp/lpc_eth.c                                  |    3 
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c                |    7 
 drivers/net/ethernet/qlogic/qede/qede.h                             |    2 
 drivers/net/ethernet/qlogic/qede/qede_main.c                        |   11 
 drivers/net/ethernet/realtek/r8169.c                                |    2 
 drivers/net/macvlan.c                                               |    4 
 drivers/net/net_failover.c                                          |    3 
 drivers/net/tun.c                                                   |   12 
 drivers/net/veth.c                                                  |    8 
 drivers/net/vmxnet3/vmxnet3_ethtool.c                               |    2 
 drivers/net/vxlan.c                                                 |    4 
 drivers/net/wireless/ath/ath10k/mac.c                               |    3 
 drivers/net/wireless/ath/ath10k/wmi-ops.h                           |   10 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                           |   15 
 drivers/net/wireless/ath/ath9k/hif_usb.c                            |   58 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h                            |    6 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                       |   10 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                       |    6 
 drivers/net/wireless/ath/ath9k/htc_hst.c                            |    3 
 drivers/net/wireless/ath/ath9k/wmi.c                                |    5 
 drivers/net/wireless/ath/ath9k/wmi.h                                |    3 
 drivers/net/wireless/ath/carl9170/fw.c                              |    4 
 drivers/net/wireless/ath/carl9170/main.c                            |   21 
 drivers/net/wireless/ath/wcn36xx/main.c                             |    6 
 drivers/net/wireless/broadcom/b43/main.c                            |    2 
 drivers/net/wireless/broadcom/b43legacy/main.c                      |    1 
 drivers/net/wireless/broadcom/b43legacy/xmit.c                      |    1 
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c          |    3 
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                     |   14 
 drivers/net/wireless/mediatek/mt76/agg-rx.c                         |    8 
 drivers/net/wireless/mediatek/mt76/mt76.h                           |    6 
 drivers/net/wireless/realtek/rtlwifi/usb.c                          |    8 
 drivers/nvme/host/core.c                                            |   16 
 drivers/pci/controller/pcie-mediatek.c                              |   18 
 drivers/pci/controller/vmd.c                                        |    2 
 drivers/pci/probe.c                                                 |   24 
 drivers/pci/quirks.c                                                |  260 +++++++---
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c                        |    2 
 drivers/pinctrl/samsung/pinctrl-exynos.c                            |   82 ++-
 drivers/platform/x86/hp-wmi.c                                       |   10 
 drivers/platform/x86/intel-hid.c                                    |    7 
 drivers/platform/x86/intel-vbtn.c                                   |   75 ++
 drivers/power/reset/vexpress-poweroff.c                             |    1 
 drivers/scsi/megaraid/megaraid_sas_fusion.c                         |    7 
 drivers/spi/spi-bcm-qspi.c                                          |    8 
 drivers/spi/spi-bcm2835.c                                           |    4 
 drivers/spi/spi-bcm2835aux.c                                        |    4 
 drivers/spi/spi-dw-mid.c                                            |   16 
 drivers/spi/spi-dw.c                                                |   12 
 drivers/spi/spi-pxa2xx.c                                            |   12 
 drivers/spi/spi-topcliff-pch.c                                      |    1 
 drivers/spi/spi.c                                                   |    4 
 drivers/staging/android/ion/ion_heap.c                              |    4 
 drivers/staging/greybus/sdio.c                                      |   10 
 drivers/tty/serial/8250/8250_pci.c                                  |    6 
 drivers/tty/serial/pch_uart.c                                       |    2 
 drivers/usb/dwc3/dwc3-haps.c                                        |    4 
 drivers/usb/gadget/udc/pch_udc.c                                    |    1 
 drivers/video/fbdev/w100fb.c                                        |    2 
 drivers/w1/masters/omap_hdq.c                                       |   10 
 drivers/xen/pvcalls-back.c                                          |    3 
 fs/aio.c                                                            |    8 
 fs/btrfs/dev-replace.c                                              |    8 
 fs/btrfs/disk-io.c                                                  |   10 
 fs/btrfs/file-item.c                                                |    6 
 fs/btrfs/inode.c                                                    |   10 
 fs/btrfs/ioctl.c                                                    |    5 
 fs/btrfs/qgroup.c                                                   |   14 
 fs/btrfs/scrub.c                                                    |    4 
 fs/btrfs/send.c                                                     |   67 ++
 fs/btrfs/tree-checker.c                                             |   20 
 fs/btrfs/volumes.c                                                  |   86 +--
 fs/btrfs/volumes.h                                                  |    4 
 fs/ext4/ext4_extents.h                                              |    9 
 fs/ext4/fsync.c                                                     |   28 -
 fs/ext4/xattr.c                                                     |    7 
 fs/fat/inode.c                                                      |    6 
 fs/fs-writeback.c                                                   |    1 
 fs/nilfs2/segment.c                                                 |    2 
 fs/overlayfs/copy_up.c                                              |    2 
 fs/proc/inode.c                                                     |    2 
 fs/proc/self.c                                                      |    2 
 fs/proc/thread_self.c                                               |    2 
 fs/xfs/xfs_bmap_util.c                                              |    2 
 fs/xfs/xfs_buf.c                                                    |    8 
 fs/xfs/xfs_dquot.c                                                  |    9 
 include/linux/kgdb.h                                                |    2 
 include/linux/kvm_host.h                                            |    4 
 include/linux/mm.h                                                  |    1 
 include/linux/mmzone.h                                              |    2 
 include/linux/pci_ids.h                                             |   36 +
 include/linux/sched/mm.h                                            |    2 
 include/linux/set_memory.h                                          |    2 
 include/linux/string.h                                              |   60 +-
 include/linux/sunrpc/gss_api.h                                      |    1 
 include/linux/sunrpc/svcauth_gss.h                                  |    3 
 include/linux/uaccess.h                                             |    2 
 include/uapi/linux/kvm.h                                            |    2 
 kernel/audit.c                                                      |   52 +-
 kernel/audit.h                                                      |    2 
 kernel/auditfilter.c                                                |   16 
 kernel/compat.c                                                     |    6 
 kernel/cpu.c                                                        |   18 
 kernel/cpu_pm.c                                                     |    4 
 kernel/debug/debug_core.c                                           |    5 
 kernel/events/core.c                                                |   23 
 kernel/exit.c                                                       |   31 -
 kernel/sched/core.c                                                 |    5 
 kernel/sched/fair.c                                                 |    2 
 lib/mpi/longlong.h                                                  |    2 
 lib/strncpy_from_user.c                                             |   23 
 lib/strnlen_user.c                                                  |   23 
 mm/huge_memory.c                                                    |   31 +
 mm/page_alloc.c                                                     |   19 
 mm/slub.c                                                           |    4 
 mm/util.c                                                           |   18 
 net/batman-adv/bat_v_elp.c                                          |   15 
 net/bluetooth/hci_event.c                                           |    1 
 net/bridge/br_arp_nd_proxy.c                                        |    4 
 net/ipv6/ipv6_sockglue.c                                            |   13 
 net/netfilter/nft_nat.c                                             |    4 
 net/sunrpc/auth_gss/gss_mech_switch.c                               |   12 
 net/sunrpc/auth_gss/svcauth_gss.c                                   |   18 
 security/integrity/evm/evm_crypto.c                                 |    2 
 security/integrity/ima/ima.h                                        |   10 
 security/integrity/ima/ima_crypto.c                                 |    6 
 security/integrity/ima/ima_init.c                                   |    2 
 security/integrity/ima/ima_policy.c                                 |    3 
 security/integrity/ima/ima_template_lib.c                           |   18 
 security/keys/internal.h                                            |   11 
 security/keys/keyctl.c                                              |   16 
 security/smack/smackfs.c                                            |   10 
 sound/core/pcm_native.c                                             |    5 
 sound/isa/es1688/es1688.c                                           |    4 
 sound/pci/hda/patch_realtek.c                                       |    6 
 sound/pci/lx6464es/lx6464es.c                                       |    8 
 sound/usb/card.c                                                    |   19 
 sound/usb/quirks-table.h                                            |   20 
 sound/usb/usbaudio.h                                                |    2 
 tools/lib/api/fs/fs.c                                               |   17 
 tools/lib/api/fs/fs.h                                               |   12 
 tools/objtool/check.c                                               |    6 
 tools/perf/builtin-probe.c                                          |    3 
 tools/perf/util/dso.c                                               |   16 
 tools/perf/util/dso.h                                               |    1 
 tools/perf/util/probe-event.c                                       |   49 +
 tools/perf/util/probe-finder.c                                      |    1 
 tools/perf/util/symbol.c                                            |    2 
 tools/testing/selftests/bpf/test_progs.c                            |    1 
 tools/testing/selftests/bpf/test_select_reuseport.c                 |    8 
 tools/testing/selftests/networking/timestamping/rxtimestamp.c       |    1 
 virt/kvm/arm/aarch32.c                                              |   28 +
 virt/kvm/kvm_main.c                                                 |   24 
 278 files changed, 2428 insertions(+), 1159 deletions(-)

Abhinav Ratna (1):
      PCI: Add ACS quirk for iProc PAXB

Abhishek Sahu (2):
      PCI: Add NVIDIA GPU multi-function power dependencies
      PCI: Generalize multi-function power dependency device links

Adrian Hunter (1):
      perf symbols: Fix debuginfo search for Ubuntu

Al Viro (2):
      sparc32: fix register window handling in genregs32_[gs]et()
      sparc64: fix misuses of access_process_vm() in genregs32_[sg]et()

Alexander Sverdlin (1):
      macvlan: Skip loopback packets in RX handler

Anand Jain (2):
      btrfs: merge btrfs_find_device and find_device
      btrfs: include non-missing as a qualifier for the latest_bdev

Anders Roxell (1):
      power: vexpress: add suppress_bind_attrs to true

Andrea Arcangeli (1):
      mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()

Andrii Nakryiko (1):
      selftests/bpf: Fix memory leak in extract_build_id()

Andy Shevchenko (4):
      spi: No need to assign dummy value in spi_unregister_controller()
      spi: dw: Zero DMA Tx and Rx configurations on stack
      platform/x86: hp-wmi: Convert simple_strtoul() to kstrtou32()
      PCI: Move Rohm Vendor ID to generic list

Anthony Steinhauser (3):
      x86/speculation: Prevent rogue cross-process SSBD shutdown
      x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.
      x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for indirect branches.

Ard Biesheuvel (4):
      efi/efivars: Add missing kobject_put() in sysfs entry creation error path
      ACPI: GED: add support for _Exx / _Lxx handler methods
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

Barret Rhoden (1):
      perf: Add cond_resched() to task_function_call()

Ben Chuang (1):
      PCI: Add Genesys Logic, Inc. Vendor ID

Bhupesh Sharma (1):
      net: qed*: Reduce RX and TX default ring count when running inside kdump kernel

Bjorn Helgaas (2):
      PCI: Make ACS quirk implementations more uniform
      PCI: Unify ACS quirk desired vs provided checking

Bob Haarman (1):
      x86_64: Fix jiffies ODR violation

Bogdan Togorean (1):
      drm: bridge: adv7511: Extend list of audio sample rates

Brad Love (1):
      media: si2157: Better check for running tuner in init

Brian Foster (2):
      xfs: reset buffer write failure state on successful completion
      xfs: fix duplicate verification from xfs_qm_dqflush()

Casey Schaufler (1):
      Smack: slab-out-of-bounds in vsscanf

Chris Wilson (1):
      agp/intel: Reinforce the barrier after GTT updates

Christian Lamparter (1):
      carl9170: remove P2P_GO support

Christoph Hellwig (2):
      staging: android: ion: use vmap instead of vm_map_ram
      nvme: refine the Qemu Identify CNS quirk

Christophe JAILLET (3):
      crypto: cavium/nitrox - Fix 'nitrox_get_first_device()' when ndevlist is fully iterated
      video: fbdev: w100fb: Fix a potential double free.
      wcn36xx: Fix error handling path in 'wcn36xx_probe()'

Christophe Leroy (1):
      lib: Reduce user_access_begin() boundaries in strncpy_from_user() and strnlen_user()

Chuhong Yuan (2):
      ALSA: es1688: Add the missed snd_card_free()
      media: go7007: fix a miss of snd_card_free

Colin Ian King (1):
      media: dvb: return -EREMOTEIO on i2c transfer failure.

Coly Li (1):
      bcache: fix refcount underflow in bcache_device_free()

Corey Minyard (1):
      pci:ipmi: Move IPMI PCI class id defines to pci_ids.h

Cédric Le Goater (1):
      powerpc/xive: Clear the page tables for the ESB IO mapping

Dan Carpenter (2):
      media: cec: silence shift wrapping warning in __cec_s_log_addrs()
      rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()

Daniel Axtens (1):
      string.h: fix incompatibility between FORTIFY_SOURCE and KASAN

Daniel Thompson (2):
      arm64: cacheflush: Fix KGDB trap detection
      kgdb: Fix spurious true from in_dbg_master()

Darrick J. Wong (1):
      xfs: clean up the error handling in xfs_swap_extents

Dennis Kadioglu (1):
      Input: synaptics - add a second working PNP_ID for Lenovo T470s

Devulapally Shiva Krishna (1):
      Crypto/chcr: fix for ccm(aes) failed test

Dmitry Osipenko (1):
      ARM: tegra: Correct PL310 Auxiliary Control Register initialization

Doug Berger (1):
      net: bcmgenet: set Rx mode before starting netif

Douglas Anderson (3):
      kgdb: Disable WARN_CONSOLE_UNLOCKED for all kgdb
      kgdb: Prevent infinite recursive entries to the debugger
      kernel/cpu_pm: Fix uninitted local in cpu_pm

Eiichi Tsukata (1):
      KVM: x86: Fix APIC page invalidation race

Erez Shitrit (1):
      net/mlx5e: IPoIB, Drop multicast packets that this interface sent

Eric Biggers (2):
      ext4: fix race between ext4_sync_parent() and rename()
      dm crypt: avoid truncating the logical block size

Eric W. Biederman (1):
      proc: Use new_inode not new_inode_pseudo

Evan Green (1):
      spi: pxa2xx: Apply CS clk quirk to BXT

Ezequiel Garcia (1):
      drm/vkms: Hold gem object while still in-use

Filipe Manana (2):
      btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums
      btrfs: fix wrong file range cleanup after an error filling dealloc range

Finn Thain (1):
      m68k: mac: Don't call via_flush_cache() on Mac IIfx

Fredrik Strupe (1):
      ARM: 8977/1: ptrace: Fix mask for thumb breakpoint hook

Greg Kroah-Hartman (1):
      Linux 4.19.129

Guoqing Jiang (1):
      md: don't flush workqueue unconditionally in md_open

Gustavo Pimentel (1):
      PCI: Add Synopsys endpoint EDDA Device ID

H. Nikolaus Schaller (1):
      w1: omap-hdq: cleanup to add missing newline for some dev_dbg

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: fix the mask for tuning start point

Hangbin Liu (1):
      ipv6: fix IPV6_ADDRFORM operation logic

Hans de Goede (6):
      Bluetooth: btbcm: Add 2 missing models to subver tables
      platform/x86: intel-vbtn: Use acpi_evaluate_integer()
      platform/x86: intel-vbtn: Split keymap into buttons and switches parts
      platform/x86: intel-vbtn: Do not advertise switches to userspace if they are not there
      platform/x86: intel-vbtn: Also handle tablet-mode switch on "Detachable" and "Portable" chassis-types
      platform/x86: intel-vbtn: Only blacklist SW_TABLET_MODE on the 9 / "Laptop" chasis-type

Harshad Shirwadkar (1):
      ext4: fix EXT_MAX_EXTENT/INDEX to check for zeroed eh_max

Heiner Kallweit (1):
      PCI: add USR vendor id and use it in r8169 and w6692 driver

Hill Ma (1):
      x86/reboot/quirks: Add MacBook6,1 reboot quirk

Hsin-Yu Chao (1):
      Bluetooth: Add SCO fallback for invalid LMP parameters error

Hui Wang (1):
      ALSA: hda/realtek - add a pintbl quirk for several Lenovo machines

Ido Schimmel (2):
      bridge: Avoid infinite loop when suppressing NS messages with invalid options
      vxlan: Avoid infinite loop when suppressing NS messages with invalid options

Jaehoon Chung (1):
      brcmfmac: fix wrong location to get firmware feature

Jakub Kicinski (1):
      PCI: Remove unused NFP32xx IDs

Jann Horn (1):
      exit: Move preemption fixup up, move blocking operations down

Jason Gunthorpe (1):
      RDMA/uverbs: Make the event_queue fds return POLLERR when disassociated

Jeffle Xu (1):
      ext4: fix error pointer dereference

Jens Axboe (1):
      sched/fair: Don't NUMA balance for kthreads

Jeremy Kerr (1):
      powerpc/spufs: fix copy_to_user while atomic

Jesper Dangaard Brouer (2):
      ixgbe: Fix XDP redirect on archs with PAGE_SIZE above 4K
      veth: Adjust hard_start offset on redirect XDP frames

Jia-Ju Bai (1):
      net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()

Jianjun Wang (1):
      PCI: mediatek: Add controller support for MT7629

Jiaxun Yang (2):
      MIPS: Truncate link address into 32bit for 32bit kernel
      PCI: Don't disable decoding when mmio_always_on is set

Jitao Shi (1):
      dt-bindings: display: mediatek: control dpi pins mode to avoid leakage

Jon Derrick (1):
      PCI: vmd: Add device id for VMD device 8086:9A0B

Jon Doron (1):
      x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit

Jonathan Bakker (3):
      pinctrl: samsung: Correct setting of eint wakeup mask on s5pv210
      pinctrl: samsung: Save/restore eint_mask over suspend for EINT_TYPE GPIOs
      ARM: dts: s5pv210: Set keep-power-in-suspend for SDHCI1 on Aries

Jonathan Chocron (1):
      PCI: Add Amazon's Annapurna Labs vendor ID

Juergen Gross (1):
      xen/pvcalls-back: test for errors when calling backend_connect()

Julien Thierry (1):
      objtool: Ignore empty alternatives

Justin Chen (1):
      spi: bcm-qspi: when tx/rx buffer is NULL set to 0

Kai Huang (1):
      kvm: x86: Fix L1TF mitigation for shadow MMU

Kai-Heng Feng (5):
      ALSA: usb-audio: Add vendor, product and profile name for HP Thunderbolt Dock
      PCI: Avoid Pericom USB controller OHCI/EHCI PME# defect
      serial: 8250_pci: Move Pericom IDs to pci_ids.h
      e1000e: Disable TSO for buffer overrun workaround
      igb: Report speed and duplex as unknown when device is runtime suspended

Kees Cook (1):
      e1000: Distribute switch variables for initialization

Kevin Buettner (1):
      PCI: Avoid FLR for AMD Starship USB 3.0

Kieran Bingham (1):
      media: platform: fcp: Set appropriate DMA parameters

Kim Phillips (1):
      x86/cpu/amd: Make erratum #1054 a legacy erratum

Kishon Vijay Abraham I (1):
      misc: pci_endpoint_test: Add support to test PCI EP in AM654x

Krzysztof Struczynski (1):
      ima: Fix ima digest hash table key calculation

Larry Finger (3):
      b43legacy: Fix case where channel status is corrupted
      b43: Fix connection problem with WPA3
      b43_legacy: Fix connection problem with WPA3

Linus Torvalds (2):
      make 'user_access_begin()' do 'access_ok()'
      Fix 'acccess_ok()' on alpha and SH

Linus Walleij (1):
      ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE

Longpeng(Mike) (3):
      crypto: virtio: Fix use-after-free in virtio_crypto_skcipher_finalize_req()
      crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()
      crypto: virtio: Fix dest length calculation in __virtio_crypto_skcipher_do_req()

Lorenz Bauer (1):
      selftests: bpf: fix use of undeclared RET_IF macro

Lubomir Rintel (1):
      spi: pxa2xx: Balance runtime PM enable/disable on error

Ludovic Desroches (2):
      ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node description
      ARM: dts: at91: sama5d2_ptc_ek: fix vbus pin

Lukas Wunner (7):
      spi: dw: Fix controller unregister order
      spi: bcm2835aux: Fix controller unregister order
      spi: Fix controller unregister order
      spi: pxa2xx: Fix controller unregister order
      spi: bcm2835: Fix controller unregister order
      spi: pxa2xx: Fix runtime PM ref imbalance on probe error
      PCI: Enable NVIDIA HDA controllers

Luke Nelson (1):
      arm64: insn: Fix two bugs in encoding 32-bit logical immediates

Marc Zyngier (2):
      KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
      KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception

Marcel Bocu (1):
      x86/amd_nb: Add PCI device IDs for family 17h, model 70h

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

Masami Hiramatsu (4):
      perf probe: Accept the instance number of kretprobe event
      perf probe: Do not show the skipped events
      perf probe: Fix to check blacklist address correctly
      perf probe: Check address correctness by map instead of _etext

Masashi Honma (1):
      ath9k_htc: Silence undersized packet warnings

Michael Ellerman (3):
      drivers/macintosh: Fix memleak in windfarm_pm112 driver
      powerpc/64s: Don't let DT CPU features set FSCR_DSCR
      powerpc/64s: Save FSCR to init_task.thread.fscr after feature init

Michał Mirosław (2):
      ALSA: pcm: disallow linking stream to itself
      Bluetooth: hci_bcm: fix freeing not-requested IRQ

Miklos Szeredi (1):
      aio: fix async fsync creds

Mikulas Patocka (1):
      alpha: fix memory barriers so that they conform to the specification

Miquel Raynal (1):
      mtd: rawnand: pasemi: Fix the probe error path

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

OGAWA Hirofumi (1):
      fat: don't allow to mount if the FAT length == 0

Omar Sandoval (1):
      btrfs: fix error handling when submitting direct I/O bio

Pablo Neira Ayuso (1):
      netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported

Pali Rohár (1):
      mwifiex: Fix memory corruption in dump_station

Paolo Bonzini (3):
      KVM: x86: only do L1TF workaround on affected processors
      KVM: nSVM: fix condition for filtering async PF
      KVM: nSVM: leave ASID aside in copy_vmcb_control_area

Paul Moore (2):
      audit: fix a net reference leak in audit_send_reply()
      audit: fix a net reference leak in audit_list_rules_send()

Pavel Tatashin (1):
      mm: initialize deferred pages with interrupts enabled

Peter Zijlstra (1):
      sched/core: Fix illegal RCU from offline CPUs

Punit Agrawal (1):
      e1000e: Relax condition to trigger reset for ME workaround

Qiujun Huang (4):
      ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
      ath9k: Fix use-after-free Write in ath9k_htc_rx_msg
      ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
      ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

Qiushi Wu (3):
      ACPI: sysfs: Fix reference count leak in acpi_sysfs_add_hotplug_profile()
      ACPI: CPPC: Fix reference count leak in acpi_cppc_processor_probe()
      cpuidle: Fix three reference count leaks

Qu Wenruo (3):
      btrfs: Detect unbalanced tree with empty leaf before crashing btree operations
      btrfs: tree-checker: Check level for leaves and nodes
      btrfs: qgroup: mark qgroup inconsistent if we're inherting snapshot to a new qgroup

Rafael J. Wysocki (2):
      ACPI: PM: Avoid using power resources if there are none for D0
      PM: runtime: clk: Fix clk_pm_runtime_get() error path

Rakesh Pillai (1):
      ath10k: Remove msdu from idr when management pkt send fails

Roberto Sassu (3):
      ima: Directly assign the ima_default_policy pointer to ima_rules
      evm: Fix possible memory leak in evm_calc_hmac_or_hash()
      ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()

Ryder Lee (1):
      mt76: avoid rx reorder buffer overflow

Ryusuke Konishi (1):
      nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

Sean Christopherson (2):
      KVM: x86/mmu: Consolidate "is MMIO SPTE" code
      KVM: nVMX: Consult only the "basic" exit reason when routing nested exit

Serge Semin (8):
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

Stafford Horne (1):
      arch/openrisc: Fix issues with access_ok()

Stephan Gerhold (1):
      Input: mms114 - fix handling of mms345l

Stephane Eranian (1):
      tools api fs: Make xxx__mountpoint() more scalable

Su Kang Yin (1):
      crypto: talitos - fix ECB and CBC algs ivsize

Sumit Saxena (1):
      scsi: megaraid_sas: TM command refire leads to controller firmware crash

Sven Eckelmann (1):
      batman-adv: Revert "disable ethtool link speed detection when auto negotiation off"

Takashi Iwai (1):
      ALSA: usb-audio: Fix inconsistent card PM state after resume

Tejun Heo (1):
      cgroup, blkcg: Prepare some symbols for module and !CONFIG_CGROUP usages

Thinh Nguyen (1):
      PCI: Move Synopsys HAPS platform device IDs

Thomas Falcon (1):
      drivers/net/ibmvnic: Update VNIC protocol version reporting

Thomas Lendacky (1):
      x86/speculation: Add support for STIBP always-on preferred mode

Tiezhu Yang (3):
      MIPS: Loongson: Build ATI Radeon GPU driver as module
      MIPS: Make sparse_init() using top-down allocation
      PCI: Add Loongson vendor ID

Tim Blechmann (1):
      ALSA: lx6464es - add support for LX6464ESe pci express variant

Tomi Valkeinen (1):
      media: ov5640: fix use of destroyed mutex

Tony Luck (1):
      x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned

Ulf Hansson (3):
      mmc: sdio: Fix potential NULL pointer error in mmc_sdio_init_card()
      staging: greybus: sdio: Respect the cmd->busy_timeout from the mmc core
      mmc: via-sdmmc: Respect the cmd->busy_timeout from the mmc core

Vasily Averin (1):
      net_failover: fixed rollback in net_failover_open()

Veerabhadrarao Badiganti (2):
      mmc: sdhci-msm: Clear tuning done flag while hs400 tuning
      mmc: sdhci-msm: Set SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 quirk

Waiman Long (2):
      mm: add kvfree_sensitive() for freeing sensitive data objects
      x86/speculation: Change misspelled STIPB to STIBP

Wang Hai (1):
      mm/slub: fix a memory leak in sysfs_slab_add()

Wei Yongjun (2):
      net: lpc-enet: fix error return code in lpc_mii_init()
      gnss: sirf: fix error return code in sirf_probe()

Will Deacon (1):
      x86: uaccess: Inhibit speculation past access_ok() in user_access_begin()

Willem de Bruijn (1):
      tun: correct header offsets in napi frags mode

Woods, Brian (2):
      hwmon/k10temp, x86/amd_nb: Consolidate shared device IDs
      x86/amd_nb: Add PCI device IDs for family 17h, model 30h

Xiaochun Lee (1):
      x86/PCI: Mark Intel C620 MROMs as having non-compliant BARs

Xiaowei Bao (1):
      misc: pci_endpoint_test: Add the layerscape EP device support

Xie XiuQi (1):
      ixgbe: fix signed-integer-overflow warning

Xing Li (2):
      KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
      KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits

Yazen Ghannam (1):
      x86/amd_nb: Add Family 19h PCI IDs

YuanJunQing (1):
      MIPS: Fix IRQ tracing when call handle_fpe() and handle_msa_fpe()

Yunjian Wang (1):
      net: allwinner: Fix use correct return type for ndo_start_xmit()

Yuxuan Shui (1):
      ovl: initialize error in ovl_copy_xattr

tannerlove (1):
      selftests/net: in rxtimestamp getopt_long needs terminating null entry

Álvaro Fernández Rojas (1):
      mtd: rawnand: brcmnand: fix hamming oob layout

