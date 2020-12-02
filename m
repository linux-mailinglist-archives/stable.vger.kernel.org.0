Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876982CB915
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 10:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388236AbgLBJjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 04:39:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388224AbgLBJi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 04:38:58 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.81
Date:   Wed,  2 Dec 2020 10:39:24 +0100
Message-Id: <1606901964112134@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.81 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arc/include/asm/pgtable.h                     |    2 
 arch/arm/boot/dts/dra76x.dtsi                      |    4 
 arch/arm/include/asm/pgtable-2level.h              |    2 
 arch/arm/include/asm/pgtable-3level.h              |    2 
 arch/arm/mach-omap2/cpuidle44xx.c                  |    8 -
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |    2 
 arch/arm64/include/asm/pgtable.h                   |   34 ++--
 arch/mips/include/asm/pgtable-32.h                 |    3 
 arch/powerpc/include/asm/book3s/32/pgtable.h       |    2 
 arch/powerpc/include/asm/book3s/64/kup-radix.h     |    2 
 arch/powerpc/include/asm/nohash/32/pgtable.h       |    2 
 arch/powerpc/kvm/book3s_xive_native.c              |    7 
 arch/riscv/include/asm/pgtable-32.h                |    2 
 arch/x86/events/intel/cstate.c                     |    6 
 arch/x86/events/intel/uncore.c                     |    4 
 arch/x86/events/intel/uncore.h                     |   12 -
 arch/x86/events/rapl.c                             |   14 -
 arch/x86/include/asm/kvm_host.h                    |    1 
 arch/x86/kernel/cpu/bugs.c                         |    4 
 arch/x86/kernel/cpu/mce/core.c                     |    6 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   65 +++-----
 arch/x86/kvm/irq.c                                 |   85 ++++-------
 arch/x86/kvm/lapic.c                               |    2 
 arch/x86/kvm/x86.c                                 |   18 +-
 arch/x86/xen/spinlock.c                            |   12 +
 arch/xtensa/include/asm/uaccess.h                  |    2 
 drivers/bus/ti-sysc.c                              |    3 
 drivers/dma/pl330.c                                |    2 
 drivers/dma/xilinx/xilinx_dma.c                    |    4 
 drivers/firmware/efi/Kconfig                       |    2 
 drivers/hid/hid-cypress.c                          |   44 +++++
 drivers/hid/hid-ids.h                              |    9 +
 drivers/hid/hid-input.c                            |    3 
 drivers/hid/hid-ite.c                              |   61 +++++++-
 drivers/hid/hid-logitech-hidpp.c                   |    6 
 drivers/hid/hid-quirks.c                           |    5 
 drivers/hid/hid-sensor-hub.c                       |    3 
 drivers/hid/hid-uclogic-core.c                     |    2 
 drivers/hid/hid-uclogic-params.c                   |    2 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |    9 -
 drivers/infiniband/hw/mthca/mthca_cq.c             |   10 -
 drivers/input/serio/i8042.c                        |   12 +
 drivers/irqchip/irq-sni-exiu.c                     |    2 
 drivers/net/can/m_can/m_can.c                      |    4 
 drivers/net/can/usb/gs_usb.c                       |  131 +++++++++--------
 drivers/net/dsa/mv88e6xxx/chip.c                   |    2 
 drivers/net/dsa/mv88e6xxx/global1.c                |   31 ++++
 drivers/net/dsa/mv88e6xxx/global1.h                |    1 
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   17 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |    3 
 drivers/net/ethernet/ibm/ibmvnic.c                 |   14 +
 drivers/net/ethernet/intel/i40e/i40e.h             |    1 
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   22 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   26 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    3 
 drivers/nfc/s3fwrn5/i2c.c                          |    4 
 drivers/nvme/host/pci.c                            |   15 +
 drivers/phy/tegra/xusb.c                           |    1 
 drivers/platform/x86/thinkpad_acpi.c               |    1 
 drivers/platform/x86/toshiba_acpi.c                |    3 
 drivers/s390/net/qeth_core.h                       |    9 -
 drivers/s390/net/qeth_core_main.c                  |   82 +++++++---
 drivers/scsi/libiscsi.c                            |   23 +--
 drivers/scsi/ufs/ufshcd.c                          |    6 
 drivers/spi/spi-bcm-qspi.c                         |   34 +---
 drivers/spi/spi-bcm2835.c                          |   18 --
 drivers/spi/spi-bcm2835aux.c                       |    3 
 drivers/staging/ralink-gdma/Kconfig                |    1 
 drivers/target/iscsi/iscsi_target.c                |   17 +-
 drivers/tee/optee/call.c                           |    3 
 drivers/usb/core/devio.c                           |   14 -
 drivers/usb/core/quirks.c                          |   10 +
 drivers/usb/gadget/function/f_midi.c               |   10 -
 drivers/usb/gadget/legacy/inode.c                  |    3 
 drivers/vhost/scsi.c                               |   42 +----
 drivers/video/fbdev/hyperv_fb.c                    |    7 
 fs/btrfs/qgroup.c                                  |    2 
 fs/btrfs/tree-checker.c                            |    3 
 fs/btrfs/volumes.c                                 |    8 -
 fs/cifs/cifsacl.c                                  |    1 
 fs/cifs/smb2ops.c                                  |   88 +++++++++--
 fs/efivarfs/inode.c                                |    2 
 fs/efivarfs/super.c                                |    1 
 fs/proc/self.c                                     |    7 
 include/asm-generic/pgtable.h                      |   13 +
 include/linux/netfilter.h                          |    2 
 include/scsi/libiscsi.h                            |    3 
 include/trace/events/writeback.h                   |    8 -
 include/uapi/linux/wireless.h                      |    6 
 include/uapi/sound/skl-tplg-interface.h            |    2 
 net/batman-adv/log.c                               |    1 
 net/ipv4/fib_frontend.c                            |    2 
 sound/soc/intel/skylake/bxt-sst.c                  |    3 
 sound/soc/intel/skylake/cnl-sst.c                  |   35 +++-
 sound/soc/intel/skylake/skl-nhlt.c                 |    3 
 sound/soc/intel/skylake/skl-sst-dsp.h              |    2 
 sound/soc/intel/skylake/skl-topology.c             |  159 ++++++++++++++++++++-
 sound/soc/intel/skylake/skl-topology.h             |    1 
 sound/soc/intel/skylake/skl.c                      |   29 +--
 tools/perf/util/dwarf-aux.c                        |    8 +
 tools/perf/util/stat-display.c                     |    5 
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   |   22 ++
 104 files changed, 1012 insertions(+), 453 deletions(-)

Alan Stern (2):
      USB: core: Change %pK for __user pointers to %px
      USB: core: Fix regression in Hercules audio card

Anand K Mistry (1):
      x86/speculation: Fix prctl() when spectre_v2_user={seccomp,prctl},ibpb

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset

Ard Biesheuvel (1):
      efivarfs: revert "fix memory leak in efivarfs_create()"

Arnd Bergmann (1):
      arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed

Avraham Stern (1):
      iwlwifi: mvm: write queue_sync_state only for sync

Benjamin Berg (1):
      platform/x86: thinkpad_acpi: Send tablet mode switch at wakeup time

Brian Masney (1):
      x86/xen: don't unbind uninitialized lock_kicker_irq

Cezary Rojewski (6):
      ASoC: Intel: Skylake: Remove superfluous chip initialization
      ASoC: Intel: Skylake: Select hda configuration permissively
      ASoC: Intel: Skylake: Enable codec wakeup during chip init
      ASoC: Intel: Skylake: Shield against no-NHLT configurations
      ASoC: Intel: Allow for ROM init retry on CNL platforms
      ASoC: Intel: Skylake: Await purge request ack on CNL

Chen Baozi (1):
      irqchip/exiu: Fix the index of fwspec for IRQ type

Chris Ye (1):
      HID: add HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE for Gamevice devices

Cong Wang (1):
      netfilter: clear skb->next in NF_HOOK_LIST()

Cédric Le Goater (1):
      KVM: PPC: Book3S HV: XIVE: Fix possible oops when accessing ESB page

Daniel Xu (1):
      btrfs: tree-checker: add missing return after error in root_item

David Sterba (1):
      btrfs: tree-checker: add missing returns after data_ref alignment checks

Dexuan Cui (1):
      video: hyperv_fb: Fix the cache type when mapping the VRAM

Dipen Patel (1):
      arm64: tegra: Wrong AON HSP reg property size

Filipe Manana (1):
      btrfs: fix lockdep splat when reading qgroup config on mount

Florian Klink (1):
      ipv4: use IS_ENABLED instead of ifdef

Frank Yang (1):
      HID: cypress: Support Varmilo Keyboards' media hotkeys

Gabriele Paoloni (1):
      x86/mce: Do not overwrite no_way_out if mce_end() fails

Geert Uytterhoeven (1):
      efi: EFI_EARLYCON should depend on EFI

Greg Kroah-Hartman (1):
      Linux 5.4.81

Hans de Goede (4):
      HID: ite: Replace ABS_MISC 120/121 events with touchpad on/off keypresses
      Input: i8042 - allow insmod to succeed on devices without an i8042 controller
      HID: logitech-hidpp: Add HIDPP_CONSUMER_VENDOR_KEYS quirk for the Dinovo Edge
      HID: Add Logitech Dinovo Edge battery quirk

Hauke Mehrtens (1):
      wireless: Use linux/stddef.h instead of stddef.h

Hui Su (1):
      trace: fix potenial dangerous pointer

Jens Axboe (1):
      proc: don't allow async path resolution of /proc/self components

Jiri Kosina (1):
      HID: add support for Sega Saturn

Johannes Thumshirn (1):
      btrfs: don't access possibly stale fs_info data for printing duplicate device

Julian Wiedmann (3):
      s390/qeth: make af_iucv TX notification call more robust
      s390/qeth: fix af_iucv notification race
      s390/qeth: fix tear down of async TX buffers

Kaixu Xia (1):
      platform/x86: toshiba_acpi: Fix the wrong variable assignment

Krzysztof Kozlowski (1):
      nfc: s3fwrn5: use signed integer for parsing GPIO numbers

Laurent Pinchart (1):
      xtensa: uaccess: Add missing __user to strncpy_from_user() prototype

Lee Duncan (1):
      scsi: libiscsi: Fix NOP race condition

Lijun Pan (4):
      ibmvnic: fix call_netdevice_notifiers in do_reset
      ibmvnic: notify peers when failover and migration happen
      ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
      ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq

Lukas Wunner (2):
      spi: bcm-qspi: Fix use-after-free on unbind
      spi: bcm2835: Fix use-after-free on unbind

Marc Ferland (1):
      dmaengine: xilinx_dma: use readl_poll_timeout_atomic variant

Marc Kleine-Budde (4):
      ARM: dts: dra76x: m_can: fix order of clocks
      can: gs_usb: fix endianess problem with candleLight firmware
      can: m_can: m_can_open(): remove IRQF_TRIGGER_FALLING from request_threaded_irq()'s flags
      can: m_can: fix nominal bitiming tseg2 min for version >= 3.1

Marc Zyngier (1):
      phy: tegra: xusb: Fix dangling pointer on probe failure

Martijn van de Streek (1):
      HID: uclogic: Add ID for Trust Flex Design Tablet

Masami Hiramatsu (1):
      perf probe: Fix to die_entrypc() returns error correctly

Mateusz Gorski (2):
      ASoC: Intel: Multiple I/O PCM format support for pipe
      ASoC: Intel: Skylake: Automatic DMIC format configuration according to information from NHLT

Michael Chan (1):
      bnxt_en: Release PCI regions when DMA mask setup fails during probe.

Mike Christie (2):
      vhost scsi: fix cmd completion race
      scsi: target: iscsi: Fix cmd abort fabric stop race

Minwoo Im (1):
      nvme: free sq/cq dbbuf pointers when dbbuf set fails

Namhyung Kim (1):
      perf stat: Use proper cpu for shadow stats

Namjae Jeon (1):
      cifs: fix a memleak with modefromsid

Nathan Chancellor (1):
      spi: bcm2835aux: Restore err assignment in bcm2835aux_spi_probe

Necip Fazil Yildiran (1):
      staging: ralink-gdma: fix kconfig dependency bug for DMA_RALINK

Pablo Ceballos (1):
      HID: hid-sensor-hub: Fix issue with devices with no report ID

Paolo Bonzini (2):
      KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint
      KVM: x86: Fix split-irqchip vs interrupt injection window request

Raju Rangoju (1):
      cxgb4: fix the panic caused by non smac rewrite

Rohith Surabattula (3):
      smb3: Call cifs reconnect from demultiplex thread
      smb3: Avoid Mid pending list corruption
      smb3: Handle error case during offload read path

Rui Miguel Silva (1):
      optee: add writeback to valid memory type

Sami Tolvanen (1):
      perf/x86: fix sysfs type mismatches

Shay Agroskin (1):
      net: ena: set initial DMA width to avoid intel iommu issue

Stanley Chu (1):
      scsi: ufs: Fix race between shutdown and runtime resume flow

Stephen Rothwell (1):
      powerpc/64s: Fix allnoconfig build since uaccess flush

Sugar Zhang (1):
      dmaengine: pl330: _prep_dma_memcpy: Fix wrong burst size

Sylwester Dziedziuch (1):
      i40e: Fix removing driver while bare-metal VFs pass traffic

Taehee Yoo (1):
      batman-adv: set .owner to THIS_MODULE

Tony Lindgren (2):
      bus: ti-sysc: Fix bogus resetdone warning on enable for cpsw
      ARM: OMAP2+: Manage MPU state properly for omap_enter_idle_coupled()

Wenpeng Liang (1):
      RDMA/hns: Fix retry_cnt and rnr_cnt when querying QP

Will Deacon (2):
      arm64: pgtable: Fix pte_accessible()
      arm64: pgtable: Ensure dirty bit is preserved across pte_wrprotect()

Xiaochen Shen (2):
      x86/resctrl: Remove superfluous kernfs_get() calls to prevent refcount leak
      x86/resctrl: Add necessary kernfs_put() calls to prevent refcount leak

Xiongfeng Wang (1):
      IB/mthca: fix return value of error branch in mthca_init_cq()

Yixian Liu (1):
      RDMA/hns: Bugfix for memory window mtpt configuration

Zenghui Yu (1):
      KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace

Zhang Changzhong (2):
      bnxt_en: fix error return code in bnxt_init_one()
      bnxt_en: fix error return code in bnxt_init_board()

Zhang Qilong (2):
      usb: gadget: f_midi: Fix memleak in f_midi_alloc
      usb: gadget: Fix memleak in gadgetfs_fill_super

penghao (1):
      USB: quirks: Add USB_QUIRK_DISCONNECT_SUSPEND quirk for Lenovo A630Z TIO built-in usb-audio card

