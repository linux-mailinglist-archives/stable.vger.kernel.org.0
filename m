Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FA52CB916
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 10:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388265AbgLBJjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 04:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388239AbgLBJjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 04:39:07 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.12
Date:   Wed,  2 Dec 2020 10:39:30 +0100
Message-Id: <1606901970206151@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.12 kernel.

All users of the 5.9 kernel series must upgrade.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                               |    2 
 arch/arc/include/asm/pgtable.h                         |    2 
 arch/arm/boot/dts/dra76x.dtsi                          |    4 
 arch/arm/include/asm/pgtable-2level.h                  |    2 
 arch/arm/include/asm/pgtable-3level.h                  |    2 
 arch/arm/mach-omap2/cpuidle44xx.c                      |    8 
 arch/arm64/boot/dts/nvidia/tegra194-p3668-0000.dtsi    |    2 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi               |    2 
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi         |   20 -
 arch/arm64/include/asm/pgtable.h                       |   34 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                     |   22 +
 arch/mips/include/asm/pgtable-32.h                     |    3 
 arch/powerpc/include/asm/book3s/32/pgtable.h           |    2 
 arch/powerpc/include/asm/book3s/64/kup-radix.h         |    2 
 arch/powerpc/include/asm/nohash/32/pgtable.h           |    2 
 arch/powerpc/kernel/exceptions-64s.S                   |   13 
 arch/powerpc/kvm/book3s_xive_native.c                  |    7 
 arch/riscv/include/asm/pgtable-32.h                    |    2 
 arch/riscv/include/asm/vdso/processor.h                |    2 
 arch/riscv/kernel/setup.c                              |    1 
 arch/riscv/kernel/vdso/Makefile                        |    2 
 arch/s390/kernel/asm-offsets.c                         |   10 
 arch/s390/kernel/entry.S                               |    2 
 arch/s390/kvm/kvm-s390.c                               |    4 
 arch/s390/kvm/pv.c                                     |    3 
 arch/s390/mm/gmap.c                                    |    2 
 arch/x86/events/intel/cstate.c                         |    6 
 arch/x86/events/intel/uncore.c                         |    4 
 arch/x86/events/intel/uncore.h                         |   12 
 arch/x86/events/rapl.c                                 |   14 
 arch/x86/include/asm/kvm_host.h                        |    1 
 arch/x86/kernel/cpu/bugs.c                             |    4 
 arch/x86/kernel/cpu/mce/core.c                         |    6 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                 |   65 +---
 arch/x86/kernel/dumpstack.c                            |   23 +
 arch/x86/kernel/tboot.c                                |    5 
 arch/x86/kvm/irq.c                                     |   85 ++---
 arch/x86/kvm/lapic.c                                   |    2 
 arch/x86/kvm/x86.c                                     |   18 -
 arch/x86/xen/spinlock.c                                |   12 
 arch/xtensa/include/asm/uaccess.h                      |    2 
 block/keyslot-manager.c                                |    7 
 drivers/bus/ti-sysc.c                                  |   29 +
 drivers/cpuidle/cpuidle-tegra.c                        |    4 
 drivers/dma/pl330.c                                    |    2 
 drivers/dma/xilinx/xilinx_dma.c                        |    4 
 drivers/firmware/efi/Kconfig                           |    2 
 drivers/firmware/efi/efi.c                             |    2 
 drivers/firmware/xilinx/zynqmp.c                       |   65 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c             |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                |    6 
 drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.h                |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c              |   10 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h              |   11 
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.h                |    1 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                 |   41 ++
 drivers/gpu/drm/amd/amdgpu/psp_gfx_if.h                |    4 
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c                  |   20 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c      |    2 
 drivers/gpu/drm/mediatek/mtk_dsi.c                     |   61 +---
 drivers/gpu/drm/nouveau/nouveau_gem.c                  |    8 
 drivers/hid/hid-cypress.c                              |   44 ++-
 drivers/hid/hid-ids.h                                  |    9 
 drivers/hid/hid-input.c                                |    3 
 drivers/hid/hid-ite.c                                  |   61 ++++
 drivers/hid/hid-logitech-hidpp.c                       |    6 
 drivers/hid/hid-quirks.c                               |    5 
 drivers/hid/hid-sensor-hub.c                           |    3 
 drivers/hid/hid-uclogic-core.c                         |    2 
 drivers/hid/hid-uclogic-params.c                       |    2 
 drivers/infiniband/hw/hfi1/file_ops.c                  |    4 
 drivers/infiniband/hw/hfi1/hfi.h                       |    2 
 drivers/infiniband/hw/hfi1/mmu_rb.c                    |   68 ++--
 drivers/infiniband/hw/hfi1/mmu_rb.h                    |   16 +
 drivers/infiniband/hw/hfi1/user_exp_rcv.c              |   12 
 drivers/infiniband/hw/hfi1/user_exp_rcv.h              |    6 
 drivers/infiniband/hw/hfi1/user_sdma.c                 |   13 
 drivers/infiniband/hw/hfi1/user_sdma.h                 |    7 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c             |    9 
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h             |    2 
 drivers/infiniband/hw/i40iw/i40iw_main.c               |    5 
 drivers/infiniband/hw/i40iw/i40iw_verbs.c              |   37 --
 drivers/infiniband/hw/mthca/mthca_cq.c                 |   10 
 drivers/input/serio/i8042.c                            |   12 
 drivers/iommu/intel/dmar.c                             |    3 
 drivers/iommu/intel/iommu.c                            |    4 
 drivers/iommu/iommu.c                                  |   10 
 drivers/irqchip/irq-sni-exiu.c                         |    2 
 drivers/net/bonding/bond_main.c                        |   61 ++--
 drivers/net/bonding/bond_sysfs_slave.c                 |   18 -
 drivers/net/can/m_can/m_can.c                          |    4 
 drivers/net/can/usb/gs_usb.c                           |  131 ++++----
 drivers/net/dsa/mv88e6xxx/chip.c                       |    2 
 drivers/net/dsa/mv88e6xxx/global1.c                    |   31 ++
 drivers/net/dsa/mv88e6xxx/global1.h                    |    1 
 drivers/net/ethernet/amazon/ena/ena_eth_com.c          |    3 
 drivers/net/ethernet/amazon/ena/ena_netdev.c           |   80 ++---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c       |  126 +++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c              |    4 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c      |    3 
 drivers/net/ethernet/freescale/dpaa2/Kconfig           |    1 
 drivers/net/ethernet/freescale/enetc/enetc_qos.c       |   14 
 drivers/net/ethernet/ibm/ibmvnic.c                     |   17 -
 drivers/net/ethernet/ibm/ibmvnic.h                     |    3 
 drivers/net/ethernet/intel/i40e/i40e.h                 |    1 
 drivers/net/ethernet/intel/i40e/i40e_main.c            |   22 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c     |   26 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c      |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c        |    2 
 drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h |    8 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c      |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c    |  103 ++++---
 drivers/nfc/s3fwrn5/i2c.c                              |    4 
 drivers/nvme/host/pci.c                                |   15 +
 drivers/phy/qualcomm/Kconfig                           |    4 
 drivers/phy/tegra/xusb.c                               |    1 
 drivers/platform/x86/thinkpad_acpi.c                   |    1 
 drivers/platform/x86/toshiba_acpi.c                    |    3 
 drivers/ptp/ptp_clockmatrix.c                          |   49 +--
 drivers/rtc/rtc-pcf2127.c                              |    4 
 drivers/s390/net/qeth_core.h                           |    9 
 drivers/s390/net/qeth_core_main.c                      |   82 +++--
 drivers/scsi/libiscsi.c                                |   23 +
 drivers/scsi/ufs/ufshcd.c                              |    6 
 drivers/spi/spi-bcm-qspi.c                             |   34 --
 drivers/spi/spi-bcm2835.c                              |   27 -
 drivers/spi/spi-bcm2835aux.c                           |    3 
 drivers/spi/spi-imx.c                                  |    1 
 drivers/staging/ralink-gdma/Kconfig                    |    1 
 drivers/target/iscsi/iscsi_target.c                    |   17 -
 drivers/tee/optee/call.c                               |    3 
 drivers/usb/cdns3/gadget.c                             |   80 ++---
 drivers/usb/core/devio.c                               |   14 
 drivers/usb/core/quirks.c                              |   10 
 drivers/usb/gadget/function/f_midi.c                   |   10 
 drivers/usb/gadget/legacy/inode.c                      |    3 
 drivers/vdpa/Kconfig                                   |    1 
 drivers/vhost/scsi.c                                   |  249 +++++++++--------
 drivers/vhost/vhost.c                                  |    6 
 drivers/vhost/vhost.h                                  |    1 
 drivers/video/fbdev/hyperv_fb.c                        |    7 
 fs/btrfs/file.c                                        |   57 ---
 fs/btrfs/inode.c                                       |   58 +++
 fs/btrfs/qgroup.c                                      |   22 +
 fs/btrfs/tests/inode-tests.c                           |   12 
 fs/btrfs/tree-checker.c                                |    3 
 fs/btrfs/volumes.c                                     |    8 
 fs/cifs/cifsacl.c                                      |    1 
 fs/cifs/smb2ops.c                                      |   88 ++++--
 fs/efivarfs/inode.c                                    |    2 
 fs/efivarfs/super.c                                    |    1 
 fs/io_uring.c                                          |   66 +++-
 fs/proc/self.c                                         |    7 
 include/kunit/test.h                                   |    2 
 include/linux/firmware/xlnx-zynqmp.h                   |    4 
 include/linux/pgtable.h                                |   13 
 include/linux/platform_data/ti-sysc.h                  |    1 
 include/net/bonding.h                                  |    8 
 include/scsi/libiscsi.h                                |    3 
 include/trace/events/writeback.h                       |    8 
 kernel/locking/lockdep.c                               |    6 
 mm/filemap.c                                           |    8 
 mm/page-writeback.c                                    |    6 
 net/batman-adv/log.c                                   |    1 
 net/ipv4/fib_frontend.c                                |    2 
 tools/perf/util/dwarf-aux.c                            |    8 
 tools/perf/util/stat-display.c                         |    5 
 tools/perf/util/synthetic-events.c                     |    3 
 168 files changed, 1700 insertions(+), 1097 deletions(-)

Alan Stern (2):
      USB: core: Change %pK for __user pointers to %px
      USB: core: Fix regression in Hercules audio card

Amadeusz Sławiński (1):
      efi/efivars: Set generic ops before loading SSDT

Amit Sunil Dhamne (1):
      firmware: xilinx: Use hash-table for api feature check

Anand K Mistry (1):
      x86/speculation: Fix prctl() when spectre_v2_user={seccomp,prctl},ibpb

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset

Antonio Borneo (1):
      net: stmmac: fix incorrect merge of patch upstream

Anup Patel (1):
      RISC-V: Add missing jump label initialization

Ard Biesheuvel (1):
      efivarfs: revert "fix memory leak in efivarfs_create()"

Arnd Bergmann (1):
      arch: pgtable: define MAX_POSSIBLE_PHYSMEM_BITS where needed

Avraham Stern (1):
      iwlwifi: mvm: write queue_sync_state only for sync

Benjamin Berg (1):
      platform/x86: thinkpad_acpi: Send tablet mode switch at wakeup time

Biwen Li (1):
      rtc: pcf2127: fix a bug when not specify interrupts property

Boqun Feng (1):
      lockdep: Put graph lock/unlock under lock_recursion protection

Brian Masney (1):
      x86/xen: don't unbind uninitialized lock_kicker_irq

Bryan O'Donoghue (2):
      phy: qualcomm: usb: Fix SuperSpeed PHY OF dependency
      phy: qualcomm: Fix 28 nm Hi-Speed USB PHY OF dependency

CK Hu (1):
      drm/mediatek: dsi: Modify horizontal front/back porch byte formula

Chen Baozi (1):
      irqchip/exiu: Fix the index of fwspec for IRQ type

Chris Ye (1):
      HID: add HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE for Gamevice devices

Clark Wang (1):
      spi: imx: fix the unbalanced spi runtime pm management

Collin Walling (1):
      KVM: s390: remove diag318 reset code

Cédric Le Goater (1):
      KVM: PPC: Book3S HV: XIVE: Fix possible oops when accessing ESB page

Daniel Latypov (1):
      kunit: fix display of failed expectations for strings

Daniel Xu (1):
      btrfs: tree-checker: add missing return after error in root_item

David Sterba (1):
      btrfs: tree-checker: add missing returns after data_ref alignment checks

David Woodhouse (1):
      iommu/vt-d: Don't read VCCAP register unless it exists

Dennis Dalessandro (1):
      IB/hfi1: Ensure correct mm is used at all times

Dexuan Cui (1):
      video: hyperv_fb: Fix the cache type when mapping the VRAM

Dipen Patel (1):
      arm64: tegra: Wrong AON HSP reg property size

Dmitry Osipenko (1):
      cpuidle: tegra: Annotate tegra_pm_set_cpu_in_lp2() with RCU_NONIDLE

Emmanuel Grumbach (2):
      iwlwifi: mvm: use the HOT_SPOT_CMD to cancel an AUX ROC
      iwlwifi: mvm: properly cancel a session protection for P2P

Eric Biggers (1):
      block/keyslot-manager: prevent crash when num_slots=1

Filipe Manana (2):
      btrfs: fix missing delalloc new bit for new delalloc ranges
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
      Linux 5.9.12

Grygorii Strashko (1):
      bus: ti-sysc: suppress err msg for timers used as clockevent/source

Hans de Goede (4):
      HID: ite: Replace ABS_MISC 120/121 events with touchpad on/off keypresses
      Input: i8042 - allow insmod to succeed on devices without an i8042 controller
      HID: logitech-hidpp: Add HIDPP_CONSUMER_VENDOR_KEYS quirk for the Dinovo Edge
      HID: Add Logitech Dinovo Edge battery quirk

Hugh Dickins (1):
      mm: fix VM_BUG_ON(PageTail) and BUG_ON(PageWriteback)

Hui Su (1):
      trace: fix potenial dangerous pointer

Ioana Ciornei (1):
      dpaa2-eth: select XGMAC_MDIO for MDIO bus support

JC Kuo (1):
      arm64: tegra: Fix USB_VBUS_EN0 regulator on Jetson TX1

Jamie Iles (1):
      bonding: wait for sysfs kobject destruction before freeing struct slave

Janosch Frank (1):
      KVM: s390: pv: Mark mm as protected after the set secure parameters and improve cleanup

Jens Axboe (2):
      proc: don't allow async path resolution of /proc/self components
      io_uring: handle -EOPNOTSUPP on path resolution

Jiri Kosina (1):
      HID: add support for Sega Saturn

Jisheng Zhang (1):
      net: stmmac: dwmac_lib: enlarge dma reset timeout

Johannes Thumshirn (1):
      btrfs: don't access possibly stale fs_info data for printing duplicate device

Jon Hunter (1):
      arm64: tegra: Correct the UART for Jetson Xavier NX

Joseph Qi (1):
      io_uring: fix shift-out-of-bounds when round up cq size

Julian Wiedmann (3):
      s390/qeth: make af_iucv TX notification call more robust
      s390/qeth: fix af_iucv notification race
      s390/qeth: fix tear down of async TX buffers

Kaixu Xia (1):
      platform/x86: toshiba_acpi: Fix the wrong variable assignment

Kenneth Feng (1):
      drm/amd/amdgpu: fix null pointer in runtime pm

Krzysztof Kozlowski (1):
      nfc: s3fwrn5: use signed integer for parsing GPIO numbers

Laurent Pinchart (1):
      xtensa: uaccess: Add missing __user to strncpy_from_user() prototype

Laurent Vivier (1):
      vdpasim: fix "mac_pton" undefined error

Lee Duncan (1):
      scsi: libiscsi: Fix NOP race condition

Lijun Pan (5):
      ibmvnic: fix call_netdevice_notifiers in do_reset
      ibmvnic: notify peers when failover and migration happen
      ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
      ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq
      ibmvnic: enhance resetting status check during module exit

Likun Gao (2):
      drm/amdgpu: update golden setting for sienna_cichlid
      drm/amdgpu: add rlc iram and dram firmware support

Lincoln Ramsay (1):
      aquantia: Remove the build_skb path

Lu Baolu (1):
      x86/tboot: Don't disable swiotlb when iommu is forced on

Lukas Wunner (2):
      spi: bcm-qspi: Fix use-after-free on unbind
      spi: bcm2835: Fix use-after-free on unbind

Manish Narani (1):
      firmware: xilinx: Fix SD DLL node reset issue

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

Matti Hamalainen (1):
      drm/nouveau: fix relocations applying logic and a double-free

Michael Chan (1):
      bnxt_en: Release PCI regions when DMA mask setup fails during probe.

Mike Christie (4):
      vhost: add helper to check if a vq has been setup
      vhost scsi: alloc cmds per vq instead of session
      vhost scsi: fix cmd completion race
      scsi: target: iscsi: Fix cmd abort fabric stop race

Min Li (1):
      ptp: clockmatrix: bug fix for idtcm_strverscmp

Minwoo Im (1):
      nvme: free sq/cq dbbuf pointers when dbbuf set fails

Namhyung Kim (2):
      perf record: Synthesize cgroup events only if needed
      perf stat: Use proper cpu for shadow stats

Namjae Jeon (1):
      cifs: fix a memleak with modefromsid

Nathan Chancellor (2):
      riscv: Explicitly specify the build id style in vDSO Makefile again
      spi: bcm2835aux: Restore err assignment in bcm2835aux_spi_probe

Necip Fazil Yildiran (1):
      staging: ralink-gdma: fix kconfig dependency bug for DMA_RALINK

Nicholas Piggin (2):
      powerpc/64s: Fix KVM system reset handling when CONFIG_PPC_PSERIES=y
      powerpc/64s/exception: KVM Fix for host DSI being taken in HPT guest MMU context

Pablo Ceballos (1):
      HID: hid-sensor-hub: Fix issue with devices with no report ID

Paolo Bonzini (2):
      KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint
      KVM: x86: Fix split-irqchip vs interrupt injection window request

Pavel Begunkov (3):
      io_uring: get an active ref_node from files_data
      io_uring: order refnode recycling
      io_uring: fix ITER_BVEC check

Peter Chen (2):
      usb: cdns3: gadget: fix some endian issues
      usb: cdns3: gadget: calculate TD_SIZE based on TD

Qu Wenruo (1):
      btrfs: qgroup: don't commit transaction when we already hold the handle

Raju Rangoju (1):
      cxgb4: fix the panic caused by non smac rewrite

Randy Dunlap (1):
      RISC-V: fix barrier() use in <vdso/processor.h>

Rodrigo Siqueira (1):
      drm/amd/display: Avoid HDCP initialization in devices without output

Rohith Surabattula (3):
      smb3: Call cifs reconnect from demultiplex thread
      smb3: Avoid Mid pending list corruption
      smb3: Handle error case during offload read path

Rui Miguel Silva (1):
      optee: add writeback to valid memory type

Sami Tolvanen (1):
      perf/x86: fix sysfs type mismatches

Shameer Kolothum (1):
      iommu: Check return of __iommu_attach_device()

Shay Agroskin (3):
      net: ena: handle bad request id in ena_netdev
      net: ena: set initial DMA width to avoid intel iommu issue
      net: ena: fix packet's addresses for rx_offset feature

Shiraz Saleem (1):
      RDMA/i40iw: Address an mmap handler exploit in i40iw

Sonny Jiang (2):
      drm/amdgpu: fix SI UVD firmware validate resume fail
      drm/amdgpu: fix a page fault

Stanley Chu (1):
      scsi: ufs: Fix race between shutdown and runtime resume flow

Stephen Rothwell (1):
      powerpc/64s: Fix allnoconfig build since uaccess flush

Sugar Zhang (1):
      dmaengine: pl330: _prep_dma_memcpy: Fix wrong burst size

Sven Schnelle (1):
      s390: fix fpu restore in entry.S

Sylwester Dziedziuch (1):
      i40e: Fix removing driver while bare-metal VFs pass traffic

Taehee Yoo (1):
      batman-adv: set .owner to THIS_MODULE

Thomas Gleixner (1):
      x86/dumpstack: Do not try to access user space code of other tasks

Tony Lindgren (3):
      bus: ti-sysc: Fix reset status check for modules with quirks
      bus: ti-sysc: Fix bogus resetdone warning on enable for cpsw
      ARM: OMAP2+: Manage MPU state properly for omap_enter_idle_coupled()

Vladimir Oltean (1):
      enetc: Let the hardware auto-advance the taprio base-time of 0

Wenpeng Liang (2):
      RDMA/hns: Fix wrong field of SRQ number the device supports
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

