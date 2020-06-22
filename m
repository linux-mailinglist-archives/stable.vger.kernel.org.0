Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20575203175
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgFVIIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 04:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgFVIIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 04:08:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B3D4207F5;
        Mon, 22 Jun 2020 08:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813297;
        bh=apxKAUgftJx5I3qPa9kSu38PxZhr8ldI8JH3nn6D5P8=;
        h=From:To:Cc:Subject:Date:From;
        b=UyXVH4kORYfKKtzWrLT/oJYRpSlertLWklBnCxIF84OSZ9wR4oPIe9DTUFl0x2r4Y
         IFu1a9l7RHrIkQopvP2adcK81nysB4ekXRe19w4rFnZ3l/j9MPJcFikdvpfkRwtDjb
         Yc+DT2FYM8PEJCOcEZZYrhjN6HFvYsPjYgKsRLzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.228
Date:   Mon, 22 Jun 2020 10:08:08 +0200
Message-Id: <159281328812922@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.228 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/display/mediatek/mediatek,dpi.txt |    6 
 Documentation/virtual/kvm/api.txt                                   |    2 
 Makefile                                                            |   15 
 arch/arm/kernel/ptrace.c                                            |    4 
 arch/arm/mach-tegra/tegra.c                                         |    4 
 arch/arm/mm/proc-macros.S                                           |    3 
 arch/arm64/include/asm/kvm_host.h                                   |    6 
 arch/m68k/include/asm/mac_via.h                                     |    1 
 arch/m68k/mac/config.c                                              |   21 
 arch/m68k/mac/via.c                                                 |    6 
 arch/mips/Makefile                                                  |   13 
 arch/mips/boot/compressed/Makefile                                  |    2 
 arch/mips/include/asm/kvm_host.h                                    |    6 
 arch/mips/kernel/genex.S                                            |    6 
 arch/mips/kernel/mips-cm.c                                          |    6 
 arch/mips/kernel/setup.c                                            |   10 
 arch/mips/kernel/time.c                                             |   70 +++
 arch/mips/kernel/vmlinux.lds.S                                      |    2 
 arch/powerpc/platforms/cell/spufs/file.c                            |  113 +++-
 arch/sparc/kernel/ptrace_32.c                                       |  228 ++++------
 arch/sparc/kernel/ptrace_64.c                                       |   17 
 arch/x86/boot/compressed/head_32.S                                  |    5 
 arch/x86/boot/compressed/head_64.S                                  |    1 
 arch/x86/include/asm/cpufeatures.h                                  |    2 
 arch/x86/include/asm/nospec-branch.h                                |    1 
 arch/x86/kernel/cpu/bugs.c                                          |   94 ++--
 arch/x86/kernel/process.c                                           |   28 -
 arch/x86/kernel/process.h                                           |    2 
 arch/x86/kernel/reboot.c                                            |    8 
 arch/x86/kernel/time.c                                              |    4 
 arch/x86/kernel/vmlinux.lds.S                                       |    4 
 arch/x86/kvm/svm.c                                                  |    2 
 arch/x86/kvm/vmx.c                                                  |    2 
 arch/x86/mm/init.c                                                  |    2 
 arch/x86/pci/fixup.c                                                |    4 
 block/blk-mq.c                                                      |    8 
 drivers/acpi/cppc_acpi.c                                            |    4 
 drivers/acpi/device_pm.c                                            |    2 
 drivers/acpi/evged.c                                                |   22 
 drivers/acpi/scan.c                                                 |   28 -
 drivers/acpi/sysfs.c                                                |    4 
 drivers/char/agp/intel-gtt.c                                        |    4 
 drivers/clocksource/dw_apb_timer_of.c                               |    6 
 drivers/cpuidle/sysfs.c                                             |    6 
 drivers/crypto/talitos.c                                            |    2 
 drivers/firmware/efi/efivars.c                                      |    4 
 drivers/macintosh/windfarm_pm112.c                                  |   22 
 drivers/md/md.c                                                     |    3 
 drivers/media/dvb-core/dvb_frontend.c                               |    2 
 drivers/media/platform/rcar-fcp.c                                   |    5 
 drivers/media/tuners/si2157.c                                       |   15 
 drivers/media/usb/dvb-usb/dibusb-mb.c                               |    2 
 drivers/media/usb/go7007/snd-go7007.c                               |   35 -
 drivers/mmc/host/sdhci-esdhc-imx.c                                  |    2 
 drivers/mtd/nand/brcmnand/brcmnand.c                                |   11 
 drivers/mtd/nand/pasemi_nand.c                                      |    4 
 drivers/net/can/usb/kvaser_usb.c                                    |    6 
 drivers/net/ethernet/allwinner/sun4i-emac.c                         |    4 
 drivers/net/ethernet/amazon/ena/ena_com.c                           |    6 
 drivers/net/ethernet/ibm/ibmvnic.c                                  |    8 
 drivers/net/ethernet/intel/e1000/e1000_main.c                       |    4 
 drivers/net/ethernet/intel/e1000e/e1000.h                           |    1 
 drivers/net/ethernet/intel/e1000e/netdev.c                          |   12 
 drivers/net/ethernet/intel/igb/igb_ethtool.c                        |    3 
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                     |    2 
 drivers/net/ethernet/nxp/lpc_eth.c                                  |    3 
 drivers/net/macvlan.c                                               |    4 
 drivers/net/vmxnet3/vmxnet3_ethtool.c                               |    2 
 drivers/net/vxlan.c                                                 |    4 
 drivers/net/wireless/ath/ath9k/hif_usb.c                            |   58 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h                            |    6 
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                       |   10 
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                       |    6 
 drivers/net/wireless/ath/ath9k/htc_hst.c                            |    3 
 drivers/net/wireless/ath/ath9k/wmi.c                                |    5 
 drivers/net/wireless/ath/ath9k/wmi.h                                |    3 
 drivers/net/wireless/ath/carl9170/fw.c                              |    4 
 drivers/net/wireless/ath/carl9170/main.c                            |   21 
 drivers/net/wireless/broadcom/b43/main.c                            |    2 
 drivers/net/wireless/broadcom/b43legacy/main.c                      |    1 
 drivers/net/wireless/broadcom/b43legacy/xmit.c                      |    1 
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                     |   14 
 drivers/net/wireless/realtek/rtlwifi/usb.c                          |    8 
 drivers/pci/probe.c                                                 |   24 -
 drivers/pinctrl/samsung/pinctrl-exynos.c                            |    9 
 drivers/power/reset/vexpress-poweroff.c                             |    1 
 drivers/scsi/scsi_lib.c                                             |    4 
 drivers/spi/spi-bcm-qspi.c                                          |    8 
 drivers/spi/spi-bcm2835.c                                           |    4 
 drivers/spi/spi-bcm2835aux.c                                        |    4 
 drivers/spi/spi-dw-mid.c                                            |   16 
 drivers/spi/spi-dw.c                                                |   14 
 drivers/spi/spi-pxa2xx.c                                            |    4 
 drivers/spi/spi.c                                                   |    5 
 drivers/staging/android/ion/ion_heap.c                              |    4 
 drivers/staging/greybus/sdio.c                                      |   10 
 drivers/video/fbdev/w100fb.c                                        |    2 
 drivers/w1/masters/omap_hdq.c                                       |   10 
 fs/btrfs/file-item.c                                                |    6 
 fs/btrfs/inode.c                                                    |    6 
 fs/btrfs/send.c                                                     |   67 ++
 fs/ext4/ext4_extents.h                                              |    9 
 fs/ext4/fsync.c                                                     |   28 -
 fs/fat/inode.c                                                      |    6 
 fs/fs-writeback.c                                                   |    1 
 fs/nilfs2/segment.c                                                 |    2 
 fs/overlayfs/copy_up.c                                              |    2 
 fs/proc/inode.c                                                     |    2 
 fs/proc/self.c                                                      |    2 
 fs/proc/thread_self.c                                               |    2 
 include/linux/kgdb.h                                                |    2 
 include/linux/sunrpc/gss_api.h                                      |    1 
 include/linux/sunrpc/svcauth_gss.h                                  |    3 
 include/uapi/linux/dvb/frontend.h                                   |    1 
 include/uapi/linux/kvm.h                                            |    2 
 kernel/cpu_pm.c                                                     |    4 
 kernel/debug/debug_core.c                                           |    1 
 kernel/events/core.c                                                |   23 -
 kernel/exit.c                                                       |   25 -
 kernel/sched/fair.c                                                 |    2 
 lib/mpi/longlong.h                                                  |    2 
 mm/huge_memory.c                                                    |   31 +
 mm/slub.c                                                           |    4 
 net/bluetooth/hci_event.c                                           |    1 
 net/ipv6/ipv6_sockglue.c                                            |   13 
 net/netfilter/nft_nat.c                                             |    4 
 net/sunrpc/auth_gss/gss_mech_switch.c                               |   12 
 net/sunrpc/auth_gss/svcauth_gss.c                                   |   18 
 security/integrity/evm/evm_crypto.c                                 |    2 
 security/integrity/ima/ima.h                                        |    7 
 security/integrity/ima/ima_policy.c                                 |    3 
 security/smack/smackfs.c                                            |   10 
 sound/core/pcm_native.c                                             |    5 
 sound/isa/es1688/es1688.c                                           |    4 
 sound/usb/card.c                                                    |   20 
 sound/usb/usbaudio.h                                                |    2 
 tools/objtool/check.c                                               |    6 
 tools/perf/builtin-probe.c                                          |    3 
 tools/perf/util/dso.c                                               |   16 
 tools/perf/util/dso.h                                               |    1 
 tools/perf/util/probe-finder.c                                      |    1 
 tools/perf/util/symbol.c                                            |    2 
 142 files changed, 1010 insertions(+), 565 deletions(-)

Adrian Hunter (1):
      perf symbols: Fix debuginfo search for Ubuntu

Al Viro (2):
      sparc32: fix register window handling in genregs32_[gs]et()
      sparc64: fix misuses of access_process_vm() in genregs32_[sg]et()

Alexander Sverdlin (1):
      macvlan: Skip loopback packets in RX handler

Anders Roxell (1):
      power: vexpress: add suppress_bind_attrs to true

Andrea Arcangeli (1):
      mm: thp: make the THP mapcount atomic against __split_huge_pmd_locked()

Andy Shevchenko (2):
      spi: No need to assign dummy value in spi_unregister_controller()
      spi: dw: Zero DMA Tx and Rx configurations on stack

Anthony Steinhauser (3):
      x86/speculation: Prevent rogue cross-process SSBD shutdown
      x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.
      x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for indirect branches.

Ard Biesheuvel (3):
      efi/efivars: Add missing kobject_put() in sysfs entry creation error path
      ACPI: GED: add support for _Exx / _Lxx handler methods
      ACPI: GED: use correct trigger type field in _Exx / _Lxx handling

Arthur Kiyanovski (1):
      net: ena: fix error returning in ena_com_get_hash_function()

Arvind Sankar (2):
      x86/boot: Correct relocation destination on old linkers
      x86/mm: Stop printing BRK addresses

Ashok Raj (1):
      PCI: Program MPS for RCiEP devices

Barret Rhoden (1):
      perf: Add cond_resched() to task_function_call()

Bob Haarman (1):
      x86_64: Fix jiffies ODR violation

Brad Love (1):
      media: si2157: Better check for running tuner in init

Casey Schaufler (1):
      Smack: slab-out-of-bounds in vsscanf

Chris Wilson (1):
      agp/intel: Reinforce the barrier after GTT updates

Christian Lamparter (1):
      carl9170: remove P2P_GO support

Christoph Hellwig (1):
      staging: android: ion: use vmap instead of vm_map_ram

Christophe JAILLET (1):
      video: fbdev: w100fb: Fix a potential double free.

Chuhong Yuan (2):
      ALSA: es1688: Add the missed snd_card_free()
      media: go7007: fix a miss of snd_card_free

Colin Ian King (2):
      media: dvb_frontend: ensure that inital front end status initialized
      media: dvb: return -EREMOTEIO on i2c transfer failure.

Dan Carpenter (1):
      rtlwifi: Fix a double free in _rtl_usb_tx_urb_setup()

Daniel Thompson (1):
      kgdb: Fix spurious true from in_dbg_master()

Dmitry Osipenko (1):
      ARM: tegra: Correct PL310 Auxiliary Control Register initialization

Douglas Anderson (2):
      kgdb: Prevent infinite recursive entries to the debugger
      kernel/cpu_pm: Fix uninitted local in cpu_pm

Eric Biggers (1):
      ext4: fix race between ext4_sync_parent() and rename()

Eric W. Biederman (1):
      proc: Use new_inode not new_inode_pseudo

Filipe Manana (1):
      btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums

Finn Thain (1):
      m68k: mac: Don't call via_flush_cache() on Mac IIfx

Fredrik Strupe (1):
      ARM: 8977/1: ptrace: Fix mask for thumb breakpoint hook

Giuliano Procida (1):
      blk-mq: move blk_mq_update_nr_hw_queues synchronize_rcu call

Greg Kroah-Hartman (1):
      Linux 4.9.228

Guoqing Jiang (1):
      md: don't flush workqueue unconditionally in md_open

H. Nikolaus Schaller (1):
      w1: omap-hdq: cleanup to add missing newline for some dev_dbg

Haibo Chen (1):
      mmc: sdhci-esdhc-imx: fix the mask for tuning start point

Hangbin Liu (1):
      ipv6: fix IPV6_ADDRFORM operation logic

Harshad Shirwadkar (1):
      ext4: fix EXT_MAX_EXTENT/INDEX to check for zeroed eh_max

Hill Ma (1):
      x86/reboot/quirks: Add MacBook6,1 reboot quirk

Hsin-Yu Chao (1):
      Bluetooth: Add SCO fallback for invalid LMP parameters error

Ido Schimmel (1):
      vxlan: Avoid infinite loop when suppressing NS messages with invalid options

Jann Horn (1):
      exit: Move preemption fixup up, move blocking operations down

Jens Axboe (1):
      sched/fair: Don't NUMA balance for kthreads

Jeremy Kerr (1):
      powerpc/spufs: fix copy_to_user while atomic

Jia-Ju Bai (1):
      net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()

Jiaxun Yang (2):
      MIPS: Truncate link address into 32bit for 32bit kernel
      PCI: Don't disable decoding when mmio_always_on is set

Jitao Shi (1):
      dt-bindings: display: mediatek: control dpi pins mode to avoid leakage

Johannes Thumshirn (1):
      scsi: return correct blkprep status code in case scsi_init_io() fails.

Jon Doron (1):
      x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit

Jonathan Bakker (1):
      pinctrl: samsung: Save/restore eint_mask over suspend for EINT_TYPE GPIOs

Julien Thierry (1):
      objtool: Ignore empty alternatives

Justin Chen (1):
      spi: bcm-qspi: when tx/rx buffer is NULL set to 0

Kai-Heng Feng (1):
      igb: Report speed and duplex as unknown when device is runtime suspended

Kees Cook (1):
      e1000: Distribute switch variables for initialization

Kieran Bingham (1):
      media: platform: fcp: Set appropriate DMA parameters

Krzysztof Struczynski (1):
      ima: Fix ima digest hash table key calculation

Larry Finger (3):
      b43legacy: Fix case where channel status is corrupted
      b43: Fix connection problem with WPA3
      b43_legacy: Fix connection problem with WPA3

Linus Walleij (1):
      ARM: 8978/1: mm: make act_mm() respect THREAD_SIZE

Lukas Wunner (5):
      spi: bcm2835aux: Fix controller unregister order
      spi: dw: Fix controller unregister order
      spi: Fix controller unregister order
      spi: pxa2xx: Fix controller unregister order
      spi: bcm2835: Fix controller unregister order

Marc Zyngier (1):
      KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts

Marcos Paulo de Souza (1):
      btrfs: send: emit file capabilities after chown

Masahiro Yamada (1):
      kbuild: force to build vmlinux if CONFIG_MODVERSION=y

Masami Hiramatsu (1):
      perf probe: Do not show the skipped events

Masashi Honma (1):
      ath9k_htc: Silence undersized packet warnings

Michael Ellerman (1):
      drivers/macintosh: Fix memleak in windfarm_pm112 driver

Michał Mirosław (1):
      ALSA: pcm: disallow linking stream to itself

Miquel Raynal (1):
      mtd: rawnand: pasemi: Fix the probe error path

Nathan Chancellor (1):
      lib/mpi: Fix 64-bit MIPS build with Clang

NeilBrown (2):
      sunrpc: svcauth_gss_register_pseudoflavor must reject duplicate registrations.
      sunrpc: clean up properly in gss_mech_unregister()

OGAWA Hirofumi (1):
      fat: don't allow to mount if the FAT length == 0

Omar Sandoval (1):
      btrfs: fix error handling when submitting direct I/O bio

Pablo Neira Ayuso (1):
      netfilter: nft_nat: return EOPNOTSUPP if type or flags are not supported

Pali Rohár (1):
      mwifiex: Fix memory corruption in dump_station

Paolo Bonzini (1):
      KVM: nSVM: leave ASID aside in copy_vmcb_control_area

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

Rafael J. Wysocki (1):
      ACPI: PM: Avoid using power resources if there are none for D0

Roberto Sassu (2):
      ima: Directly assign the ima_default_policy pointer to ima_rules
      evm: Fix possible memory leak in evm_calc_hmac_or_hash()

Ryusuke Konishi (1):
      nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

Sasha Levin (1):
      spi: dw: fix possible race condition

Sean Christopherson (1):
      KVM: nVMX: Consult only the "basic" exit reason when routing nested exit

Serge Semin (5):
      spi: dw: Enable interrupts in accordance with DMA xfer mode
      clocksource: dw_apb_timer_of: Fix missing clockevent timers
      mips: cm: Fix an invalid error code of INTVN_*_ERR
      mips: Add udelay lpj numbers adjustment
      spi: dw: Return any value retrieved from the dma_transfer callback

Su Kang Yin (1):
      crypto: talitos - fix ECB and CBC algs ivsize

Takashi Iwai (1):
      ALSA: usb-audio: Fix inconsistent card PM state after resume

Tejun Heo (1):
      cgroup, blkcg: Prepare some symbols for module and !CONFIG_CGROUP usages

Thomas Falcon (1):
      drivers/net/ibmvnic: Update VNIC protocol version reporting

Thomas Lendacky (1):
      x86/speculation: Add support for STIBP always-on preferred mode

Tiezhu Yang (1):
      MIPS: Make sparse_init() using top-down allocation

Ulf Hansson (1):
      staging: greybus: sdio: Respect the cmd->busy_timeout from the mmc core

Waiman Long (1):
      x86/speculation: Change misspelled STIPB to STIBP

Wang Hai (1):
      mm/slub: fix a memory leak in sysfs_slab_add()

Wei Yongjun (1):
      net: lpc-enet: fix error return code in lpc_mii_init()

Xiaochun Lee (1):
      x86/PCI: Mark Intel C620 MROMs as having non-compliant BARs

Xiaolong Huang (1):
      can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices

Xie XiuQi (1):
      ixgbe: fix signed-integer-overflow warning

Xing Li (2):
      KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
      KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits

YuanJunQing (1):
      MIPS: Fix IRQ tracing when call handle_fpe() and handle_msa_fpe()

Yunjian Wang (1):
      net: allwinner: Fix use correct return type for ndo_start_xmit()

Yuxuan Shui (1):
      ovl: initialize error in ovl_copy_xattr

Álvaro Fernández Rojas (1):
      mtd: rawnand: brcmnand: fix hamming oob layout

