Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3C5316191
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhBJI4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhBJIyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:54:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC0E664E53;
        Wed, 10 Feb 2021 08:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612947216;
        bh=Dk5MBj6T1VHGy/VJKO2uJ7DeEPEpPI1roKmCUiuNt3M=;
        h=From:To:Cc:Subject:Date:From;
        b=kcoDsidlpxARfxhE+BheS9FHCOr+Hr1I7lcGbLswojWZFhWwOZCdjKS9aPdYDTBcO
         CZGvsZ7Smb5MpSXyHMB1DwUgTcst1X+G+T0jirq22UGdi/FKSdhvAgsqBXmNPf7QsV
         7aC44VHS/1qyPRmaUEtmGp4L6auwKnQIfDMwkl3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.15
Date:   Wed, 10 Feb 2021 09:53:24 +0100
Message-Id: <161294720540228@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.15 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/overlayfs.rst              |    8 +
 Makefile                                             |   12 -
 arch/arm/boot/dts/omap3-gta04.dtsi                   |    3 
 arch/arm/boot/dts/stm32mp15xx-dhcom-drc02.dtsi       |   12 +
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi         |    3 
 arch/arm/boot/dts/sun7i-a20-bananapro.dts            |    2 
 arch/arm/include/debug/tegra.S                       |   54 +++----
 arch/arm/mach-footbridge/dc21285.c                   |   12 -
 arch/arm/mach-omap1/board-osk.c                      |    2 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi    |    2 
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts  |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi       |    2 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts |   10 -
 arch/arm64/boot/dts/rockchip/px30.dtsi               |    2 
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts |    1 
 arch/riscv/Kconfig                                   |    2 
 arch/um/drivers/virtio_uml.c                         |    3 
 arch/x86/Makefile                                    |    3 
 arch/x86/include/asm/apic.h                          |   10 -
 arch/x86/include/asm/barrier.h                       |   18 ++
 arch/x86/kernel/apic/apic.c                          |    4 
 arch/x86/kernel/apic/x2apic_cluster.c                |    6 
 arch/x86/kernel/apic/x2apic_phys.c                   |    9 -
 arch/x86/kernel/hw_breakpoint.c                      |   61 +++++---
 arch/x86/kvm/cpuid.c                                 |    2 
 arch/x86/kvm/emulate.c                               |    2 
 arch/x86/kvm/mmu/tdp_mmu.c                           |    6 
 arch/x86/kvm/svm/sev.c                               |   17 +-
 arch/x86/kvm/svm/svm.c                               |    5 
 arch/x86/kvm/vmx/vmx.c                               |   17 +-
 arch/x86/kvm/x86.c                                   |   27 ++-
 arch/x86/mm/mem_encrypt.c                            |    1 
 drivers/gpio/gpiolib.c                               |   10 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    |    2 
 drivers/gpu/drm/drm_dp_mst_topology.c                |   24 ++-
 drivers/gpu/drm/i915/display/intel_ddi.c             |   37 +++--
 drivers/gpu/drm/i915/display/intel_display.c         |    9 -
 drivers/gpu/drm/i915/display/intel_dp_mst.c          |    4 
 drivers/gpu/drm/i915/display/intel_overlay.c         |    4 
 drivers/gpu/drm/i915/display/intel_sprite.c          |   65 +--------
 drivers/gpu/drm/i915/gem/i915_gem_domain.c           |   45 ------
 drivers/gpu/drm/i915/gem/i915_gem_object.h           |    1 
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c          |    6 
 drivers/input/joystick/xpad.c                        |   17 ++
 drivers/input/serio/i8042-x86ia64io.h                |    2 
 drivers/input/touchscreen/goodix.c                   |    2 
 drivers/input/touchscreen/ili210x.c                  |   26 ++-
 drivers/md/md.c                                      |    2 
 drivers/mmc/core/sdio_cis.c                          |    6 
 drivers/mmc/host/sdhci-pltfm.h                       |    7 -
 drivers/net/dsa/mv88e6xxx/chip.c                     |    6 
 drivers/net/ethernet/ibm/ibmvnic.c                   |    5 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c   |   13 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h   |    1 
 drivers/net/ethernet/intel/igc/igc_ethtool.c         |    3 
 drivers/net/ethernet/intel/igc/igc_i225.c            |    3 
 drivers/net/ethernet/intel/igc/igc_mac.c             |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c       |   10 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c      |   16 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c    |    5 
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c  |    2 
 drivers/net/ethernet/realtek/r8169_main.c            |   75 +++++++++-
 drivers/net/ipa/gsi.c                                |    2 
 drivers/nvdimm/dimm_devs.c                           |   18 ++
 drivers/nvdimm/namespace_devs.c                      |   10 -
 drivers/nvme/host/pci.c                              |    2 
 drivers/nvme/target/tcp.c                            |    3 
 drivers/thunderbolt/acpi.c                           |    2 
 drivers/usb/class/usblp.c                            |   19 +-
 drivers/usb/dwc2/gadget.c                            |    8 -
 drivers/usb/dwc3/core.c                              |    2 
 drivers/usb/gadget/legacy/ether.c                    |    4 
 drivers/usb/gadget/udc/aspeed-vhub/hub.c             |    4 
 drivers/usb/host/xhci-mtk-sch.c                      |  130 +++++++++++++------
 drivers/usb/host/xhci-mtk.c                          |    2 
 drivers/usb/host/xhci-mtk.h                          |   15 ++
 drivers/usb/host/xhci-mvebu.c                        |   42 ++++++
 drivers/usb/host/xhci-mvebu.h                        |    6 
 drivers/usb/host/xhci-plat.c                         |   20 ++
 drivers/usb/host/xhci-plat.h                         |    1 
 drivers/usb/host/xhci-ring.c                         |   31 ++--
 drivers/usb/host/xhci.c                              |    8 -
 drivers/usb/host/xhci.h                              |    4 
 drivers/usb/renesas_usbhs/fifo.c                     |    1 
 drivers/usb/serial/cp210x.c                          |    2 
 drivers/usb/serial/option.c                          |    6 
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                   |    1 
 drivers/vdpa/mlx5/core/mr.c                          |   28 +---
 drivers/vdpa/mlx5/net/mlx5_vnet.c                    |   18 ++
 fs/afs/main.c                                        |    6 
 fs/cifs/dir.c                                        |   22 ++-
 fs/cifs/smb2pdu.h                                    |    2 
 fs/cifs/transport.c                                  |   18 ++
 fs/hugetlbfs/inode.c                                 |    3 
 fs/io_uring.c                                        |    6 
 fs/overlayfs/dir.c                                   |    2 
 fs/overlayfs/file.c                                  |    5 
 fs/overlayfs/overlayfs.h                             |    1 
 fs/overlayfs/ovl_entry.h                             |    2 
 fs/overlayfs/readdir.c                               |   28 +---
 fs/overlayfs/super.c                                 |   34 +++-
 fs/overlayfs/util.c                                  |   27 +++
 include/drm/drm_dp_mst_helper.h                      |    1 
 include/linux/hugetlb.h                              |    2 
 include/linux/iommu.h                                |    5 
 include/linux/irq.h                                  |    4 
 include/linux/kprobes.h                              |    2 
 include/linux/msi.h                                  |    6 
 include/linux/tracepoint.h                           |   12 +
 include/linux/vmalloc.h                              |    9 -
 include/net/sch_generic.h                            |    2 
 include/net/udp.h                                    |    2 
 init/init_task.c                                     |    3 
 kernel/bpf/bpf_inode_storage.c                       |    6 
 kernel/bpf/cgroup.c                                  |    7 -
 kernel/bpf/preload/Makefile                          |    5 
 kernel/irq/msi.c                                     |   44 ++----
 kernel/kprobes.c                                     |   36 ++++-
 kernel/trace/fgraph.c                                |    2 
 kernel/trace/trace_irqsoff.c                         |    4 
 kernel/trace/trace_kprobe.c                          |   10 -
 mm/compaction.c                                      |    3 
 mm/filemap.c                                         |    4 
 mm/huge_memory.c                                     |   37 +++--
 mm/hugetlb.c                                         |   48 ++++++-
 mm/memblock.c                                        |   49 -------
 net/core/neighbour.c                                 |    7 -
 net/ipv4/ip_tunnel.c                                 |   16 +-
 net/ipv4/udp_offload.c                               |   69 +++++++++-
 net/ipv6/udp_offload.c                               |    2 
 net/lapb/lapb_out.c                                  |    3 
 net/mac80211/driver-ops.c                            |    5 
 net/mac80211/rate.c                                  |    3 
 net/rxrpc/af_rxrpc.c                                 |    6 
 net/sunrpc/svcsock.c                                 |    7 -
 scripts/Makefile                                     |    8 -
 137 files changed, 1105 insertions(+), 605 deletions(-)

Aleksandr Loktionov (1):
      i40e: Revert "i40e: don't report link up for a VF who hasn't enabled queues"

Alexander Ovechkin (1):
      net: sched: replaced invalid qdisc tree flush helper in qdisc_replace

Alexey Dobriyan (1):
      Input: i8042 - unbreak Pegatron C15B

Alexey Kardashevskiy (1):
      tracepoint: Fix race between tracing and removing tracepoint

Andres Calderon Jaramillo (1):
      drm/i915/display: Prevent double YUV range correction on HDR planes

AngeloGioacchino Del Regno (1):
      Input: goodix - add support for Goodix GT9286 chip

Atish Patra (1):
      RISC-V: Define MAXPHYSMEM_1GB only for RV32

Aurelien Aptel (1):
      cifs: report error instead of invalid when revalidating a dentry fails

Ben Gardon (1):
      KVM: x86/mmu: Fix TDP MMU zap collapsible SPTEs

Benjamin Valentin (1):
      Input: xpad - sync supported devices with fork on GitHub

Chenxin Jin (1):
      USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000

Chinmay Agarwal (1):
      neighbour: Prevent a dead entry from updating gc_list

Chris Wilson (2):
      drm/i915/gem: Drop lru bumping on display unpinning
      drm/i915/gt: Close race between enable_breadcrumbs and cancel_breadcrumbs

Christoph Schemmel (1):
      USB: serial: option: Adding support for Cinterion MV31

Chuck Lever (1):
      SUNRPC: Fix NFS READs that start at non-page-aligned offsets

Chunfeng Yun (2):
      usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints
      usb: xhci-mtk: break loop when find the endpoint to drop

DENG Qingfang (1):
      net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add

Dan Carpenter (2):
      USB: gadget: legacy: fix an error code in eth_bind()
      net: ipa: pass correct dma_handle to dma_free_coherent()

Dan Williams (2):
      libnvdimm/namespace: Fix visibility of namespace resource attribute
      libnvdimm/dimm: Avoid race between probe and available_slots_show()

Daniel Jurgens (1):
      net/mlx5: Fix function calculation for page trees

Dave Hansen (1):
      x86/apic: Add extra serialization for non-serializing MSRs

David Howells (1):
      rxrpc: Fix deadlock around release of dst cached on udp tunnel

Dmitry Osipenko (1):
      ARM: 9043/1: tegra: Fix misplaced tegra_uart_config in decompressor

Dongseok Yi (1):
      udp: ipv4: manipulate network header of NATed UDP GRO fraglist

Eli Cohen (2):
      vdpa/mlx5: Fix memory key MTT population
      vdpa/mlx5: Restore the hardware used index after change map

Felix Fietkau (1):
      mac80211: fix station rate table updates on assoc

Fengnan Chang (1):
      mmc: core: Limit retries when analyse of SDIO tuples fails

Gary Bisson (1):
      usb: dwc3: fix clock issue during resume in OTG mode

Greg Kroah-Hartman (1):
      Linux 5.10.15

Gustavo A. R. Silva (1):
      smb3: Fix out-of-bounds bug in SMB2_negotiate()

H. Nikolaus Schaller (2):
      DTS: ARM: gta04: remove legacy spi-cs-high to make display work again
      ARM: dts; gta04: SPI panel chip select is active low

Hans de Goede (1):
      genirq: Prevent [devm_]irq_alloc_desc from returning irq 0

Heiko Stuebner (1):
      usb: dwc2: Fix endpoint direction check in ep_from_windex

Heiner Kallweit (2):
      r8169: work around RTL8125 UDP hw bug
      r8169: fix WoL on shutdown if CONFIG_DEBUG_SHIRQ is set

Hermann Lauer (1):
      ARM: dts: sun7i: a20: bananapro: Fix ethernet phy-mode

Hugh Dickins (1):
      mm: thp: fix MADV_REMOVE deadlock on shmem THP

Ikjoon Jang (1):
      usb: xhci-mtk: fix unreleased bandwidth data

Imre Deak (2):
      drm/dp/mst: Export drm_dp_get_vc_payload_bw()
      drm/i915: Fix the MST PBN divider calculation

Jeremy Figgins (1):
      USB: usblp: don't call usb_set_interface if there's a single alt

Joerg Roedel (1):
      iommu: Check dev->iommu in dev_iommu_priv_get() before dereferencing it

Johannes Berg (1):
      um: virtio: free vu_dev only with the contained struct device

Josh Poimboeuf (1):
      x86/build: Disable CET instrumentation in the kernel

Kai-Heng Feng (1):
      igc: Report speed and duplex as unknown when device is runtime suspended

Kevin Lo (2):
      igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr
      igc: check return value of ret_val in igc_config_fc_after_link_up

Lai Jiangshan (2):
      x86/debug: Prevent data breakpoints on __per_cpu_offset
      x86/debug: Prevent data breakpoints on cpu_dr7

Liangyan (1):
      ovl: fix dentry leak in ovl_get_redirect

Lijun Pan (1):
      ibmvnic: device remove has higher precedence over reset

Linus Walleij (1):
      ARM: OMAP1: OSK: fix ohci-omap breakage

Loris Reiff (2):
      bpf, cgroup: Fix optlen WARN_ON_ONCE toctou
      bpf, cgroup: Fix problematic bounds check

Maor Dickman (1):
      net/mlx5e: Release skb in case of failure in tc update skb

Maor Gottlieb (1):
      net/mlx5: Fix leak upon failure of rule creation

Marc Zyngier (1):
      genirq/msi: Activate Multi-MSI early when MSI_FLAG_ACTIVATE_EARLY is set

Marek Szyprowski (1):
      arm64: dts: meson: switch TFLASH_VDD_EN pin to open drain on Odroid-C4

Marek Vasut (6):
      ARM: dts: stm32: Fix polarity of the DH DRC02 uSD card detect
      ARM: dts: stm32: Connect card-detect signal on DHCOM
      ARM: dts: stm32: Disable WP on DHCOM uSD slot
      ARM: dts: stm32: Disable optional TSC2004 on DRC02 board
      ARM: dts: stm32: Fix GPIO hog flags on DHCOM DRC02
      Input: ili210x - implement pressure reporting for ILI251x

Mario Limonciello (1):
      thunderbolt: Fix possible NULL pointer dereference in tb_acpi_add_link()

Masahiro Yamada (1):
      kbuild: fix duplicated flags in DEBUG_CFLAGS

Masami Hiramatsu (1):
      tracing/kprobe: Fix to support kretprobe events on unloaded modules

Mathias Nyman (1):
      xhci: fix bounce buffer usage for non-sg list case

Maxim Mikityanskiy (1):
      net/mlx5e: Update max_opened_tc also when channels are closed

Michael Roth (1):
      KVM: x86: fix CPUID entries returned by KVM_GET_CPUID2 ioctl

Miklos Szeredi (1):
      ovl: avoid deadlock on directory ioctl

Muchun Song (4):
      mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
      mm: hugetlb: fix a race between freeing and dissolving the page
      mm: hugetlb: fix a race between isolating and freeing page
      mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active

Pali Rohár (1):
      usb: host: xhci: mvebu: make USB 3.0 PHY optional for Armada 3720

Pan Bian (1):
      bpf, inode_storage: Put file handler if no storage was found

Paolo Bonzini (1):
      KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off

Pavel Shilovsky (1):
      smb3: fix crediting for compounding when only one request in flight

Peter Gonda (1):
      Fix unsynchronized access to sev members through svm_register_enc_region

Peter Zijlstra (1):
      x86/debug: Fix DR6 handling

Pho Tran (1):
      USB: serial: cp210x: add pid/vid for WSDA-200-USB

Quanyang Wang (1):
      gpiolib: free device name on error path to fix kmemleak

Quentin Monnet (1):
      bpf, preload: Fix build when $(O) points to a relative path

Rick Edgecombe (1):
      mm/vmalloc: separate put pages and flush VM flags

Rokudo Yan (1):
      mm, compaction: move high_pfn to the for loop scope

Rolf Eike Beer (1):
      scripts: use pkg-config to locate libcrypto

Roman Gushchin (1):
      memblock: do not start bottom-up allocations with kernel_end

Russell King (1):
      ARM: footbridge: fix dc21285 PCI configuration accessors

Sagi Grimberg (1):
      nvmet-tcp: fix out-of-bounds access when receiving multiple h2cdata PDUs

Sandy Huang (1):
      arm64: dts: rockchip: fix vopl iommu irq on px30

Sargun Dhillon (1):
      ovl: implement volatile-specific fsync error behaviour

Sean Christopherson (3):
      KVM: SVM: Treat SVM as unsupported when running as an SEV guest
      KVM: x86: Update emulator context mode if SYSENTER xfers to 64-bit mode
      KVM: x86: Set so called 'reserved CR3 bits in LM mask' at vCPU reset

Serge Semin (1):
      arm64: dts: amlogic: meson-g12: Set FL-adj property value

Shawn Guo (1):
      arm64: dts: qcom: c630: keep both touchpad devices enabled

Simon South (1):
      arm64: dts: rockchip: Use only supported PCIe link speed on Pinebook Pro

Stefan Chulski (1):
      net: mvpp2: TCAM entry enable should be written after SRAM data

Steven Rostedt (VMware) (1):
      fgraph: Initialize tracing_graph_pause at task creation

Stylon Wang (1):
      drm/amd/display: Revert "Fix EDID parsing after resume from suspend"

Thorsten Leemhuis (1):
      nvme-pci: avoid the deepest sleep state on Kingston A2000 SSDs

Ulf Hansson (1):
      mmc: sdhci-pltfm: Fix linking err for sdhci-brcmstb

Vadim Fedorenko (1):
      net: ip_tunnel: fix mtu calculation

Viktor Rosendahl (1):
      tracing: Use pause-on-trace with the latency tracers

Ville Syrjälä (2):
      drm/i915: Extract intel_ddi_power_up_lanes()
      drm/i915: Power up combo PHY lanes for for HDMI as well

Waiman Long (1):
      mm/filemap: add missing mem_cgroup_uncharge() to __add_to_page_cache_locked()

Wang ShaoBo (1):
      kretprobe: Avoid re-registration of the same kretprobe earlier

Xiao Ni (1):
      md: Set prev_flush_start and flush_bio in an atomic way

Xiaoguang Wang (1):
      io_uring: don't modify identity's files uncess identity is cowed

Xie He (1):
      net: lapb: Copy the skb before sending a packet

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()

Zyta Szpak (1):
      arm64: dts: ls1046a: fix dcfg address range

kernel test robot (1):
      usb: gadget: aspeed: add missing of_node_put

