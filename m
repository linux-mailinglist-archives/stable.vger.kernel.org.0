Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A282233F67F
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 18:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhCQRTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 13:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhCQRTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 13:19:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5910364E61;
        Wed, 17 Mar 2021 17:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616001554;
        bh=qCd26QHEJCj+sQ6tXdOVSnNQwNEYB5KNVUPY2BR48eA=;
        h=From:To:Cc:Subject:Date:From;
        b=VPor7x+sKTCYSC2+EyOOMdCPIdQZ75SV5t2LOeUYJVk9H8Gc3kuvn4sSzL7yUZXyP
         eCvO57goW0l6eTQAuhDmFRIRnsJtK2h6zlOqmP8jiXjl/vLK4syqDmQWSCeRcwER7a
         byjHzWpO76tyTkMLc6bKkwIJ2V+AQIU8tpRmHBRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.106
Date:   Wed, 17 Mar 2021 18:19:01 +0100
Message-Id: <161600154187210@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.106 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/virt/kvm/api.txt                                      |    3 
 Makefile                                                            |   14 -
 arch/arm/include/asm/kvm_asm.h                                      |    2 
 arch/arm/kvm/hyp/tlb.c                                              |    3 
 arch/arm64/include/asm/kvm_asm.h                                    |    2 
 arch/arm64/include/asm/memory.h                                     |    5 
 arch/arm64/include/asm/mmu_context.h                                |    5 
 arch/arm64/kernel/head.S                                            |    2 
 arch/arm64/kvm/hyp/tlb.c                                            |    3 
 arch/arm64/kvm/reset.c                                              |   11 
 arch/arm64/mm/init.c                                                |   12 
 arch/arm64/mm/mmu.c                                                 |    2 
 arch/powerpc/include/asm/code-patching.h                            |    2 
 arch/powerpc/include/asm/machdep.h                                  |    3 
 arch/powerpc/include/asm/ptrace.h                                   |    3 
 arch/powerpc/kernel/asm-offsets.c                                   |    2 
 arch/powerpc/kernel/head_32.S                                       |    9 
 arch/powerpc/kernel/pci-common.c                                    |   10 
 arch/powerpc/kernel/process.c                                       |    2 
 arch/powerpc/kernel/traps.c                                         |    5 
 arch/powerpc/perf/core-book3s.c                                     |   19 +
 arch/powerpc/platforms/pseries/msi.c                                |   25 +
 arch/s390/kernel/smp.c                                              |    2 
 arch/sparc/include/asm/mman.h                                       |   54 ++--
 arch/sparc/mm/init_32.c                                             |    3 
 arch/x86/kernel/unwind_orc.c                                        |   12 
 drivers/base/swnode.c                                               |    3 
 drivers/block/rsxx/core.c                                           |    1 
 drivers/block/zram/zram_drv.c                                       |   11 
 drivers/gpu/drm/drm_gem_shmem_helper.c                              |   25 +
 drivers/gpu/drm/drm_ioc32.c                                         |   11 
 drivers/gpu/drm/meson/meson_drv.c                                   |   11 
 drivers/gpu/drm/qxl/qxl_display.c                                   |    1 
 drivers/hid/hid-logitech-dj.c                                       |    7 
 drivers/i2c/busses/i2c-rcar.c                                       |   13 
 drivers/input/keyboard/applespi.c                                   |   21 +
 drivers/iommu/amd_iommu_init.c                                      |   45 ++-
 drivers/media/platform/vsp1/vsp1_drm.c                              |    6 
 drivers/media/rc/Makefile                                           |    1 
 drivers/media/rc/keymaps/Makefile                                   |    1 
 drivers/media/rc/keymaps/rc-cec.c                                   |   28 --
 drivers/media/rc/rc-main.c                                          |    6 
 drivers/media/usb/usbtv/usbtv-audio.c                               |    2 
 drivers/misc/fastrpc.c                                              |    5 
 drivers/misc/pvpanic.c                                              |    1 
 drivers/mmc/core/bus.c                                              |   11 
 drivers/mmc/core/mmc.c                                              |   15 -
 drivers/mmc/host/mtk-sd.c                                           |   18 -
 drivers/mmc/host/mxs-mmc.c                                          |    2 
 drivers/net/can/flexcan.c                                           |   24 +
 drivers/net/can/m_can/tcan4x5x.c                                    |    6 
 drivers/net/ethernet/atheros/alx/main.c                             |    7 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                           |   14 -
 drivers/net/ethernet/davicom/dm9000.c                               |   21 +
 drivers/net/ethernet/freescale/enetc/enetc.c                        |   19 -
 drivers/net/ethernet/freescale/enetc/enetc.h                        |    5 
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                     |   40 ++-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c                     |    7 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h              |    6 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c             |    7 
 drivers/net/ethernet/ibm/ibmvnic.c                                  |    5 
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c                      |    5 
 drivers/net/ethernet/intel/ixgbevf/ipsec.c                          |    5 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                     |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                      |    2 
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                        |    1 
 drivers/net/ethernet/renesas/sh_eth.c                               |    7 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c                    |   19 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c                    |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                   |    2 
 drivers/net/netdevsim/netdev.c                                      |    1 
 drivers/net/phy/phy.c                                               |    7 
 drivers/net/usb/qmi_wwan.c                                          |   14 -
 drivers/net/wan/lapbether.c                                         |    3 
 drivers/net/wireless/ath/ath9k/ath9k.h                              |    3 
 drivers/net/wireless/ath/ath9k/xmit.c                               |    6 
 drivers/net/wireless/mediatek/mt76/dma.c                            |   11 
 drivers/nvme/host/core.c                                            |    8 
 drivers/pci/controller/pci-xgene-msi.c                              |   10 
 drivers/pci/controller/pcie-mediatek.c                              |    7 
 drivers/pci/pci.c                                                   |    4 
 drivers/platform/olpc/olpc-ec.c                                     |   15 -
 drivers/s390/block/dasd.c                                           |    6 
 drivers/s390/cio/vfio_ccw_ops.c                                     |    6 
 drivers/s390/crypto/vfio_ap_ops.c                                   |    2 
 drivers/scsi/libiscsi.c                                             |   11 
 drivers/spi/spi-stm32.c                                             |   15 -
 drivers/staging/comedi/drivers/addi_apci_1032.c                     |    4 
 drivers/staging/comedi/drivers/addi_apci_1500.c                     |   18 -
 drivers/staging/comedi/drivers/adv_pci1710.c                        |   10 
 drivers/staging/comedi/drivers/das6402.c                            |    2 
 drivers/staging/comedi/drivers/das800.c                             |    2 
 drivers/staging/comedi/drivers/dmm32at.c                            |    2 
 drivers/staging/comedi/drivers/me4000.c                             |    2 
 drivers/staging/comedi/drivers/pcl711.c                             |    2 
 drivers/staging/comedi/drivers/pcl818.c                             |    2 
 drivers/staging/ks7010/ks_wlan_net.c                                |    6 
 drivers/staging/rtl8188eu/core/rtw_ap.c                             |    5 
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c                      |    6 
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c                          |    7 
 drivers/staging/rtl8192u/r8192U_wx.c                                |    6 
 drivers/staging/rtl8712/rtl871x_cmd.c                               |    6 
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c                       |    2 
 drivers/target/target_core_pr.c                                     |   15 -
 drivers/target/target_core_transport.c                              |   15 -
 drivers/usb/class/cdc-acm.c                                         |    5 
 drivers/usb/class/usblp.c                                           |   16 -
 drivers/usb/dwc3/dwc3-qcom.c                                        |   16 -
 drivers/usb/gadget/function/f_uac1.c                                |    1 
 drivers/usb/gadget/function/f_uac2.c                                |    2 
 drivers/usb/gadget/function/u_ether_configfs.h                      |    5 
 drivers/usb/host/xhci-pci.c                                         |   13 
 drivers/usb/host/xhci-ring.c                                        |    3 
 drivers/usb/host/xhci.c                                             |   78 +++--
 drivers/usb/host/xhci.h                                             |    1 
 drivers/usb/renesas_usbhs/pipe.c                                    |    2 
 drivers/usb/serial/ch341.c                                          |    1 
 drivers/usb/serial/cp210x.c                                         |    3 
 drivers/usb/serial/io_edgeport.c                                    |   26 +
 drivers/usb/usbip/stub_dev.c                                        |   42 ++-
 drivers/usb/usbip/vhci_sysfs.c                                      |   39 ++
 drivers/usb/usbip/vudc_sysfs.c                                      |   49 +++
 drivers/xen/events/events_2l.c                                      |   22 +
 drivers/xen/events/events_base.c                                    |  132 +++++++---
 drivers/xen/events/events_fifo.c                                    |    7 
 drivers/xen/events/events_internal.h                                |   22 +
 fs/binfmt_misc.c                                                    |   29 +-
 fs/cifs/cifsfs.c                                                    |    2 
 fs/configfs/file.c                                                  |    6 
 fs/nfs/dir.c                                                        |   40 +--
 fs/nfs/nfs4proc.c                                                   |    2 
 fs/pnode.h                                                          |    2 
 fs/udf/inode.c                                                      |    9 
 include/linux/can/skb.h                                             |    8 
 include/linux/sched/mm.h                                            |    3 
 include/linux/stop_machine.h                                        |   11 
 include/linux/virtio_net.h                                          |    7 
 include/media/rc-map.h                                              |    7 
 include/target/target_core_backend.h                                |    1 
 include/uapi/linux/netfilter/nfnetlink_cthelper.h                   |    2 
 kernel/sched/membarrier.c                                           |    4 
 kernel/sysctl.c                                                     |    8 
 kernel/time/hrtimer.c                                               |   60 ++--
 lib/logic_pio.c                                                     |    3 
 mm/slub.c                                                           |    2 
 net/ipv4/cipso_ipv4.c                                               |   11 
 net/ipv4/nexthop.c                                                  |   10 
 net/ipv4/tcp.c                                                      |   23 +
 net/ipv4/udp_offload.c                                              |    2 
 net/ipv6/calipso.c                                                  |   14 -
 net/mpls/mpls_gso.c                                                 |    3 
 net/netfilter/nf_nat_proto.c                                        |   25 +
 net/netfilter/x_tables.c                                            |    6 
 net/netlabel/netlabel_cipso_v4.c                                    |    3 
 net/qrtr/qrtr.c                                                     |    4 
 net/sched/sch_api.c                                                 |    8 
 net/sunrpc/sched.c                                                  |    5 
 samples/bpf/xdpsock_user.c                                          |    2 
 security/commoncap.c                                                |   12 
 sound/pci/hda/hda_bind.c                                            |    4 
 sound/pci/hda/hda_controller.c                                      |    7 
 sound/pci/hda/hda_intel.c                                           |    2 
 sound/pci/hda/patch_ca0132.c                                        |    1 
 sound/pci/hda/patch_hdmi.c                                          |   13 
 sound/usb/quirks.c                                                  |    9 
 tools/perf/util/trace-event-read.c                                  |    1 
 tools/testing/selftests/bpf/progs/test_tunnel_kern.c                |    6 
 tools/testing/selftests/bpf/verifier/array_access.c                 |    3 
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh |    9 
 virt/kvm/arm/arm.c                                                  |    8 
 virt/kvm/arm/mmu.c                                                  |    3 
 172 files changed, 1211 insertions(+), 585 deletions(-)

Adrian Hunter (1):
      mmc: core: Fix partition switch time for eMMC

Alain Volmat (1):
      spi: stm32: make spurious and overrun interrupts visible

Aleksandr Miloserdov (2):
      scsi: target: core: Add cmd length set before cmd complete
      scsi: target: core: Prevent underflow for service actions

Andreas Larsson (1):
      sparc32: Limit memblock allocation to low memory

Andrey Konovalov (1):
      arm64: kasan: fix page_alloc tagging with DEBUG_VIRTUAL

Anna-Maria Behnsen (1):
      hrtimer: Update softirq_expires_next correctly after __hrtimer_get_next_event()

Anshuman Khandual (1):
      arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory

Antony Antony (1):
      ixgbe: fail to create xfrm offload of IPsec tunnel mode SA

Ard Biesheuvel (1):
      arm64: mm: use a 48-bit ID map when possible on 52-bit VA builds

Arnd Bergmann (1):
      stop_machine: mark helpers __always_inline

Artem Lapkin (1):
      drm: meson_drv add shutdown function

Athira Rajeev (1):
      powerpc/perf: Record counter overflow always if SAMPLE_IP is unset

Balazs Nemeth (2):
      net: check if protocol extracted by virtio_net_hdr_set_proto is correct
      net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0

Benjamin Coddington (1):
      SUNRPC: Set memalloc_nofs_save() for sync tasks

Biju Das (2):
      media: v4l: vsp1: Fix uif null pointer access
      media: v4l: vsp1: Fix bru null pointer access

Chaotian Jing (1):
      mmc: mediatek: fix race condition between msdc_request_timeout and irq

Christian Brauner (1):
      mount: fix mounting of detached mounts onto targets that reside on shared mounts

Christophe JAILLET (1):
      mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'

Christophe Leroy (1):
      powerpc/603: Fix protection of user pages mapped with PROT_NONE

Colin Ian King (1):
      qxl: Fix uninitialised struct field head.surface_id

Daiyue Zhang (1):
      configfs: fix a use-after-free in __configfs_open_file

Dan Carpenter (6):
      USB: gadget: u_ether: Fix a configfs return code
      staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()
      staging: rtl8188eu: prevent ->ssid overflow in rtw_wx_set_scan()
      staging: rtl8712: unterminated string leads to read overflow
      staging: rtl8188eu: fix potential memory corruption in rtw_check_beacon_data()
      staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()

Daniel Borkmann (1):
      net: Fix gro aggregation for udp encaps with zero csum

Daniel Vetter (1):
      drm/compat: Clear bounce structures

Daniele Palmas (1):
      net: usb: qmi_wwan: allow qmimux add/del with master up

Danielle Ratson (1):
      selftests: forwarding: Fix race condition in mirror installation

Dmitry Baryshkov (1):
      misc: fastrpc: restrict user apps from sending kernel RPC messages

Dmitry V. Levin (1):
      uapi: nfnetlink_cthelper.h: fix userspace compilation error

Edwin Peer (1):
      bnxt_en: reliably allocate IRQ table on reset to avoid crash

Eric Dumazet (1):
      tcp: add sanity tests to TCP_QUEUE_SEQ

Eric Farman (1):
      s390/cio: return -EFAULT if copy_to_user() fails

Eric W. Biederman (1):
      Revert 95ebabde382c ("capabilities: Don't allow writing ambiguous v3 file capabilities")

Felix Fietkau (1):
      ath9k: fix transmitting to stations in dynamic SMPS mode

Filipe Laíns (1):
      HID: logitech-dj: add support for the new lightspeed connection iteration

Florian Westphal (1):
      netfilter: nf_nat: undo erroneous tcp edemux lookup

Forest Crossman (1):
      usb: xhci: Fix ASMedia ASM1042A and ASM3242 DMA addressing

Frank Li (1):
      mmc: cqhci: Fix random crash when remove mmc module/card

Geert Uytterhoeven (1):
      PCI: Fix pci_register_io_range() memory leak

Greg Kroah-Hartman (1):
      Linux 5.4.106

Greg Kurz (1):
      powerpc/pseries: Don't enforce MSI affinity with kdump

Guangbin Huang (1):
      net: phy: fix save wrong speed and duplex problem if autoneg is on

Hangbin Liu (1):
      selftests/bpf: No need to drop the packet when there is no geneve opt

Hans Verkuil (1):
      media: rc: compile rc-cec.c into rc-core

Heikki Krogerus (1):
      software node: Fix node registration

Heiko Carstens (1):
      s390/smp: __smp_rescan_cpus() - move cpumask away from stack

Hillf Danton (1):
      netdevsim: init u64 stats for 32bit hardware

Ian Abbott (9):
      staging: comedi: addi_apci_1032: Fix endian problem for COS sample
      staging: comedi: addi_apci_1500: Fix endian problem for command sample
      staging: comedi: adv_pci1710: Fix endian problem for AI command data
      staging: comedi: das6402: Fix endian problem for AI command data
      staging: comedi: das800: Fix endian problem for AI command data
      staging: comedi: dmm32at: Fix endian problem for AI command data
      staging: comedi: me4000: Fix endian problem for AI command data
      staging: comedi: pcl711: Fix endian problem for AI command data
      staging: comedi: pcl818: Fix endian problem for AI command data

Ian Rogers (1):
      perf traceevent: Ensure read cmdlines are null terminated.

Ido Schimmel (1):
      nexthop: Do not flush blackhole nexthops when loopback goes down

Jakub Kicinski (1):
      ethernet: alx: fix order of calls on resume

Jia-Ju Bai (2):
      net: qrtr: fix error return code of qrtr_sendmsg()
      block: rsxx: fix error return code of rsxx_pci_probe()

Jian Shen (3):
      net: hns3: fix query vlan mask value error for flow director
      net: hns3: fix bug when calculating the TCAM table info
      net: hns3: fix error mask definition of flow director

Jiri Wiesner (1):
      ibmvnic: always store valid MAC address

Joakim Zhang (5):
      can: flexcan: assert FRZ bit in flexcan_chip_freeze()
      can: flexcan: enable RX FIFO after FRZ/HALT valid
      can: flexcan: invoke flexcan_chip_freeze() to enter freeze mode
      net: stmmac: stop each tx channel independently
      net: stmmac: fix watchdog timeout during suspend/resume stress test

John Ernberg (1):
      ALSA: usb: Add Plantronics C320-M USB ctrl msg delay quirk

Josh Poimboeuf (1):
      x86/unwind/orc: Disable KASAN checking in the ORC unwinder, part 2

Juergen Gross (3):
      xen/events: reset affinity of 2-level event when tearing it down
      xen/events: don't unmask an event channel when an eoi is pending
      xen/events: avoid handling the same event on two cpus at the same time

Karan Singhal (1):
      USB: serial: cp210x: add ID for Acuity Brands nLight Air Adapter

Keita Suzuki (1):
      i40e: Fix memory leak in i40e_probe

Keith Busch (2):
      nvme: unlink head after removing last namespace
      nvme: release namespace head reference on error

Kevin(Yudong) Yang (1):
      net/mlx4_en: update moderation when config reset

Khalid Aziz (1):
      sparc64: Use arch_validate_flags() to validate ADI flag

Krzysztof Wilczyński (1):
      PCI: mediatek: Add missing of_node_put() to fix reference leak

Lee Gibson (2):
      staging: rtl8712: Fix possible buffer overflow in r8712_sitesurvey_cmd
      staging: rtl8192e: Fix possible buffer overflow in _rtl92e_wx_set_scan

Lin Feng (1):
      sysctl.c: fix underflow value setting risk in vm_table

Linus Torvalds (1):
      Revert "mm, slub: consider rest of partial list if acquire_slab() fails"

Lior Ribak (1):
      binfmt_misc: fix possible deadlock in bm_register_write

Lorenzo Bianconi (1):
      mt76: dma: do not report truncated frames to mac80211

Lubomir Rintel (1):
      Platform: OLPC: Fix probe error handling

Maciej Fijalkowski (1):
      samples, bpf: Add missing munmap in xdpsock

Marc Zyngier (3):
      KVM: arm64: Fix exclusive limit for IPA size
      KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
      KVM: arm64: Reject VM creation when the default IPA size is unsupported

Martin Kaiser (1):
      PCI: xgene-msi: Fix race in installing chained irq handler

Mathias Nyman (2):
      xhci: Improve detection of device initiated wake signal.
      xhci: Fix repeated xhci wake after suspend due to uncleared internal wake state

Mathieu Desnoyers (1):
      sched/membarrier: fix missing local execution of ipi_sync_rq_state()

Matthew Wilcox (Oracle) (1):
      include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Matthias Kaehlcke (1):
      usb: dwc3: qcom: Honor wakeup enabled/disabled state

Maxim Mikityanskiy (1):
      media: usbtv: Fix deadlock on suspend

Maximilian Heyne (1):
      net: sched: avoid duplicates in classes dump

Michael Ellerman (1):
      powerpc/64: Fix stack trace not displaying final frame

Mike Christie (1):
      scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling

Minchan Kim (1):
      zram: fix return value on writeback_store

Naveen N. Rao (1):
      powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()

Neil Roberts (2):
      drm/shmem-helper: Check for purged buffers in fault handler
      drm/shmem-helper: Don't remove the offset in vm_area_struct pgoff

Nicholas Piggin (1):
      powerpc: improve handling of unrecoverable system reset

Niv Sardi (1):
      USB: serial: ch341: add new Product ID

Oleksij Rempel (1):
      can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership

Oliver O'Halloran (1):
      powerpc/pci: Add ppc_md.discover_phbs()

Ondrej Mosnacek (1):
      NFSv4.2: fix return value of _nfs4_get_security_label()

Ong Boon Leong (1):
      net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10

Paul Cercueil (2):
      net: davicom: Fix regulator not turned off on failed probe
      net: davicom: Fix regulator not turned off on driver removal

Paul Moore (1):
      cipso,calipso: resolve a number of problems with the DOI refcounts

Paulo Alcantara (1):
      cifs: return proper error code in statfs(2)

Pavel Skripkin (1):
      USB: serial: io_edgeport: fix memory leak in edge_startup

Pete Zaitcev (1):
      USB: usblp: fix a hang in poll() if disconnected

Ronald Tschalär (1):
      Input: applespi - don't wait for responses to commands indefinitely.

Ruslan Bilovol (2):
      usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot
      usb: gadget: f_uac1: stop playback on function disable

Sasha Levin (1):
      kbuild: clamp SUBLEVEL to 255

Sebastian Reichel (1):
      USB: serial: cp210x: add some more GE USB IDs

Serge Semin (1):
      usb: dwc3: qcom: Add missing DWC3 OF node refcount decrement

Sergey Shtylyov (3):
      sh_eth: fix TRSCER mask for SH771x
      sh_eth: fix TRSCER mask for R7S9210
      sh_eth: fix TRSCER mask for R7S72100

Shile Zhang (1):
      misc/pvpanic: Export module FDT device table

Shuah Khan (6):
      usbip: fix stub_dev to check for stream socket
      usbip: fix vhci_hcd to check for stream socket
      usbip: fix vudc to check for stream socket
      usbip: fix stub_dev usbip_sockfd_store() races leading to gpf
      usbip: fix vhci_hcd attach_store() races leading to gpf
      usbip: fix vudc usbip_sockfd_store races leading to gpf

Simeon Simeonoff (1):
      ALSA: hda/ca0132: Add Sound BlasterX AE-5 Plus support

Stanislaw Gruszka (1):
      usb: xhci: do not perform Soft Retry for some xHCI hosts

Stefan Haberland (2):
      s390/dasd: fix hanging DASD driver unbind
      s390/dasd: fix hanging IO request during DASD driver unbind

Steven J. Magnani (1):
      udf: fix silent AED tagLocation corruption

Suravee Suthikulpanit (1):
      iommu/amd: Fix performance counter initialization

Takashi Iwai (6):
      ALSA: hda/hdmi: Cancel pending works before suspend
      ALSA: hda: Drop the BATCH workaround for AMD controllers
      ALSA: hda: Flush pending unsolicited events before suspend
      ALSA: hda: Avoid spurious unsol event handling during S3/S4
      ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar
      ALSA: usb-audio: Apply the control quirk to Plantronics headsets

Torin Cooper-Bennun (1):
      can: tcan4x5x: tcan4x5x_init(): fix initialization - clear MRAM before entering Normal Mode

Trond Myklebust (2):
      NFS: Don't revalidate the directory permissions on a lookup failure
      NFS: Don't gratuitously clear the inode cache when lookup failed

Vasily Averin (1):
      netfilter: x_tables: gpf inside xt_find_revision()

Vladimir Oltean (2):
      net: enetc: don't overwrite the RSS indirection table when initializing
      net: enetc: initialize RFS/RSS memories for unused ports too

Wang Qing (2):
      s390/cio: return -EFAULT if copy_to_user() fails again
      s390/crypto: return -EFAULT if copy_to_user() fails

Wolfram Sang (2):
      i2c: rcar: faster irq code to minimize HW race condition
      i2c: rcar: optimize cacheline to minimize HW race condition

Xie He (1):
      net: lapbether: Remove netif_start_queue / netif_stop_queue

Yauheni Kaliuta (1):
      selftests/bpf: Mask bpf_csum_diff() return value to 16 bits in test_verifier

Yorick de Wid (1):
      Goodix Fingerprint device is not a modem

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM

