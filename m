Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1652431618D
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhBJI4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:56:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230007AbhBJIyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:54:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CC9B64E42;
        Wed, 10 Feb 2021 08:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612947202;
        bh=AmVthugo8vTu4qRrDYOj+aVT37zkyF1fcXN1mh9NoJA=;
        h=From:To:Cc:Subject:Date:From;
        b=qK3BYq+0lgIMSYyijd6eeJlUom4gM6HNMT3m2xo74j9bFnzHKZd5pfMEA6P3QY0DV
         ZTAMNod2XBvvkFZl1Jbfq/+D8AxRmS3h+cPVR5k4XuN8RrsFa6zwqBQBT1BYFtHkMZ
         rrSOrjwkGPpheXUCTGR2MYZspt5rMQCiN4s8Bbfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.97
Date:   Wed, 10 Feb 2021 09:53:15 +0100
Message-Id: <161294719694120@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.97 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    8 -
 arch/arm/boot/dts/sun7i-a20-bananapro.dts            |    2 
 arch/arm/mach-footbridge/dc21285.c                   |   12 -
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi    |    2 
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi       |    2 
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts |   10 -
 arch/arm64/boot/dts/rockchip/px30.dtsi               |    2 
 arch/um/drivers/virtio_uml.c                         |    3 
 arch/x86/Makefile                                    |    3 
 arch/x86/include/asm/apic.h                          |   10 -
 arch/x86/include/asm/barrier.h                       |   18 ++
 arch/x86/kernel/apic/apic.c                          |    4 
 arch/x86/kernel/apic/x2apic_cluster.c                |    6 
 arch/x86/kernel/apic/x2apic_phys.c                   |    9 -
 arch/x86/kvm/emulate.c                               |    2 
 arch/x86/kvm/svm.c                                   |    5 
 arch/x86/mm/mem_encrypt.c                            |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    |    2 
 drivers/input/joystick/xpad.c                        |   17 ++
 drivers/input/serio/i8042-x86ia64io.h                |    2 
 drivers/iommu/intel-iommu.c                          |    6 
 drivers/md/md.c                                      |    2 
 drivers/mmc/core/sdio_cis.c                          |    6 
 drivers/net/dsa/mv88e6xxx/chip.c                     |    6 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c   |   13 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h   |    1 
 drivers/net/ethernet/intel/igc/igc_ethtool.c         |    3 
 drivers/net/ethernet/intel/igc/igc_i225.c            |    3 
 drivers/net/ethernet/intel/igc/igc_mac.c             |    2 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c       |   10 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c    |    5 
 drivers/net/ethernet/realtek/r8169_main.c            |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          |    9 +
 drivers/nvdimm/dimm_devs.c                           |   18 ++
 drivers/nvme/host/pci.c                              |    2 
 drivers/nvme/target/tcp.c                            |    3 
 drivers/usb/class/usblp.c                            |   19 +-
 drivers/usb/dwc2/gadget.c                            |    8 -
 drivers/usb/dwc3/core.c                              |    2 
 drivers/usb/gadget/legacy/ether.c                    |    4 
 drivers/usb/host/xhci-mtk-sch.c                      |  130 +++++++++++++------
 drivers/usb/host/xhci-mtk.c                          |    2 
 drivers/usb/host/xhci-mtk.h                          |   15 ++
 drivers/usb/host/xhci-mvebu.c                        |   42 ++++++
 drivers/usb/host/xhci-mvebu.h                        |    6 
 drivers/usb/host/xhci-plat.c                         |   26 +++
 drivers/usb/host/xhci-plat.h                         |    1 
 drivers/usb/host/xhci-ring.c                         |   31 ++--
 drivers/usb/host/xhci.c                              |    8 -
 drivers/usb/host/xhci.h                              |    5 
 drivers/usb/renesas_usbhs/fifo.c                     |    1 
 drivers/usb/serial/cp210x.c                          |    2 
 drivers/usb/serial/option.c                          |    6 
 fs/afs/main.c                                        |    6 
 fs/cifs/dir.c                                        |   22 ++-
 fs/cifs/smb2pdu.h                                    |    2 
 fs/cifs/transport.c                                  |   18 ++
 fs/hugetlbfs/inode.c                                 |    3 
 fs/overlayfs/dir.c                                   |    2 
 include/linux/hugetlb.h                              |    2 
 include/linux/msi.h                                  |    6 
 include/net/sch_generic.h                            |    2 
 init/init_task.c                                     |    3 
 kernel/bpf/cgroup.c                                  |    7 -
 kernel/irq/msi.c                                     |   44 ++----
 kernel/kprobes.c                                     |    4 
 kernel/trace/fgraph.c                                |    2 
 mm/compaction.c                                      |    3 
 mm/huge_memory.c                                     |   37 +++--
 mm/hugetlb.c                                         |   48 ++++++-
 mm/memblock.c                                        |   49 -------
 net/core/neighbour.c                                 |    7 -
 net/ipv4/ip_tunnel.c                                 |   16 +-
 net/lapb/lapb_out.c                                  |    3 
 net/mac80211/driver-ops.c                            |    5 
 net/mac80211/rate.c                                  |    3 
 net/rxrpc/af_rxrpc.c                                 |    6 
 77 files changed, 557 insertions(+), 264 deletions(-)

Aleksandr Loktionov (1):
      i40e: Revert "i40e: don't report link up for a VF who hasn't enabled queues"

Alexander Ovechkin (1):
      net: sched: replaced invalid qdisc tree flush helper in qdisc_replace

Alexey Dobriyan (1):
      Input: i8042 - unbreak Pegatron C15B

Aurelien Aptel (1):
      cifs: report error instead of invalid when revalidating a dentry fails

Benjamin Valentin (1):
      Input: xpad - sync supported devices with fork on GitHub

Chenxin Jin (1):
      USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000

Chinmay Agarwal (1):
      neighbour: Prevent a dead entry from updating gc_list

Christoph Schemmel (1):
      USB: serial: option: Adding support for Cinterion MV31

Chunfeng Yun (2):
      usb: xhci-mtk: skip dropping bandwidth of unchecked endpoints
      usb: xhci-mtk: break loop when find the endpoint to drop

DENG Qingfang (1):
      net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add

Dan Carpenter (1):
      USB: gadget: legacy: fix an error code in eth_bind()

Dan Williams (1):
      libnvdimm/dimm: Avoid race between probe and available_slots_show()

Dave Hansen (1):
      x86/apic: Add extra serialization for non-serializing MSRs

David Howells (1):
      rxrpc: Fix deadlock around release of dst cached on udp tunnel

Felix Fietkau (1):
      mac80211: fix station rate table updates on assoc

Fengnan Chang (1):
      mmc: core: Limit retries when analyse of SDIO tuples fails

Gary Bisson (1):
      usb: dwc3: fix clock issue during resume in OTG mode

Greg Kroah-Hartman (1):
      Linux 5.4.97

Gustavo A. R. Silva (1):
      smb3: Fix out-of-bounds bug in SMB2_negotiate()

Heiko Stuebner (1):
      usb: dwc2: Fix endpoint direction check in ep_from_windex

Heiner Kallweit (1):
      r8169: fix WoL on shutdown if CONFIG_DEBUG_SHIRQ is set

Hermann Lauer (1):
      ARM: dts: sun7i: a20: bananapro: Fix ethernet phy-mode

Hugh Dickins (1):
      mm: thp: fix MADV_REMOVE deadlock on shmem THP

Ikjoon Jang (1):
      usb: xhci-mtk: fix unreleased bandwidth data

Jeremy Figgins (1):
      USB: usblp: don't call usb_set_interface if there's a single alt

Johannes Berg (1):
      um: virtio: free vu_dev only with the contained struct device

Josh Poimboeuf (1):
      x86/build: Disable CET instrumentation in the kernel

Kai-Heng Feng (1):
      igc: Report speed and duplex as unknown when device is runtime suspended

Kevin Lo (2):
      igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr
      igc: check return value of ret_val in igc_config_fc_after_link_up

Liangyan (1):
      ovl: fix dentry leak in ovl_get_redirect

Loris Reiff (2):
      bpf, cgroup: Fix optlen WARN_ON_ONCE toctou
      bpf, cgroup: Fix problematic bounds check

Luca Coelho (1):
      iwlwifi: mvm: don't send RFH_QUEUE_CONFIG_CMD with no queues

Maor Gottlieb (1):
      net/mlx5: Fix leak upon failure of rule creation

Marc Zyngier (1):
      genirq/msi: Activate Multi-MSI early when MSI_FLAG_ACTIVATE_EARLY is set

Mathias Nyman (1):
      xhci: fix bounce buffer usage for non-sg list case

Muchun Song (4):
      mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
      mm: hugetlb: fix a race between freeing and dissolving the page
      mm: hugetlb: fix a race between isolating and freeing page
      mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active

Nadav Amit (1):
      iommu/vt-d: Do not use flush-queue when caching-mode is on

Pali Rohár (1):
      usb: host: xhci: mvebu: make USB 3.0 PHY optional for Armada 3720

Pavel Shilovsky (1):
      smb3: fix crediting for compounding when only one request in flight

Peter Chen (1):
      usb: host: xhci-plat: add priv quirk for skip PHY initialization

Pho Tran (1):
      USB: serial: cp210x: add pid/vid for WSDA-200-USB

Rokudo Yan (1):
      mm, compaction: move high_pfn to the for loop scope

Roman Gushchin (1):
      memblock: do not start bottom-up allocations with kernel_end

Russell King (1):
      ARM: footbridge: fix dc21285 PCI configuration accessors

Sagi Grimberg (1):
      nvmet-tcp: fix out-of-bounds access when receiving multiple h2cdata PDUs

Sandy Huang (1):
      arm64: dts: rockchip: fix vopl iommu irq on px30

Sean Christopherson (2):
      KVM: SVM: Treat SVM as unsupported when running as an SEV guest
      KVM: x86: Update emulator context mode if SYSENTER xfers to 64-bit mode

Serge Semin (1):
      arm64: dts: amlogic: meson-g12: Set FL-adj property value

Shawn Guo (1):
      arm64: dts: qcom: c630: keep both touchpad devices enabled

Stefan Chulski (1):
      net: mvpp2: TCAM entry enable should be written after SRAM data

Steven Rostedt (VMware) (1):
      fgraph: Initialize tracing_graph_pause at task creation

Stylon Wang (1):
      drm/amd/display: Revert "Fix EDID parsing after resume from suspend"

Thorsten Leemhuis (1):
      nvme-pci: avoid the deepest sleep state on Kingston A2000 SSDs

Vadim Fedorenko (1):
      net: ip_tunnel: fix mtu calculation

Wang ShaoBo (1):
      kretprobe: Avoid re-registration of the same kretprobe earlier

Xiao Ni (1):
      md: Set prev_flush_start and flush_bio in an atomic way

Xie He (1):
      net: lapb: Copy the skb before sending a packet

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()

Zyta Szpak (1):
      arm64: dts: ls1046a: fix dcfg address range

