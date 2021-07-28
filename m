Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB5C3D8E8D
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 15:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbhG1NIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 09:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236301AbhG1NIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 09:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C7F60F9E;
        Wed, 28 Jul 2021 13:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627477699;
        bh=lb8jdBVnWSDBqfGZ16Mu5fz1FhsGd2Id87EZcBAyInU=;
        h=From:To:Cc:Subject:Date:From;
        b=0m4b55lUwSuT1KbuOcDJBb34qWHJUFVb22drPHOHDcmXO/FzvRRoRsibYnF4r2hYX
         TMfvwhdW9+bxxpkbRkAeo2CuAAB2eI/6R1O6PNyR9UhePrOSVUZZXhRRYohhXNYQea
         6Jyvu+pMECQ9ErcRDR2xi5Rm1TZOgaH4IgvnQ7X8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.13.6
Date:   Wed, 28 Jul 2021 15:08:13 +0200
Message-Id: <1627477693174147@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.13.6 kernel.

All users of the 5.13 kernel series must upgrade.

The updated 5.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.13.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/tagged-address-abi.rst                           |   26 -
 Documentation/driver-api/early-userspace/early_userspace_support.rst |    8 
 Documentation/filesystems/ramfs-rootfs-initramfs.rst                 |    2 
 Documentation/networking/ip-sysctl.rst                               |    2 
 Documentation/trace/histogram.rst                                    |    2 
 Makefile                                                             |    2 
 arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts                    |    4 
 arch/arm/configs/multi_v7_defconfig                                  |    2 
 arch/arm64/kernel/Makefile                                           |    2 
 arch/arm64/kernel/mte.c                                              |   15 
 arch/nds32/mm/mmap.c                                                 |    2 
 arch/powerpc/kvm/book3s_hv.c                                         |    2 
 arch/powerpc/kvm/book3s_hv_nested.c                                  |   20 +
 arch/powerpc/kvm/book3s_rtas.c                                       |   25 +
 arch/powerpc/kvm/powerpc.c                                           |    4 
 arch/riscv/include/asm/efi.h                                         |    4 
 arch/riscv/mm/init.c                                                 |    4 
 arch/s390/boot/text_dma.S                                            |   19 -
 arch/s390/include/asm/ftrace.h                                       |    1 
 arch/s390/kernel/ftrace.c                                            |    2 
 arch/s390/kernel/mcount.S                                            |    4 
 arch/s390/net/bpf_jit_comp.c                                         |    2 
 arch/x86/kvm/cpuid.c                                                 |    3 
 arch/x86/kvm/svm/sev.c                                               |   14 
 drivers/acpi/Kconfig                                                 |    2 
 drivers/acpi/utils.c                                                 |    7 
 drivers/base/auxiliary.c                                             |    8 
 drivers/base/core.c                                                  |    6 
 drivers/block/rbd.c                                                  |   32 -
 drivers/bus/mhi/core/main.c                                          |   17 
 drivers/bus/mhi/pci_generic.c                                        |   45 +-
 drivers/firmware/arm_scmi/bus.c                                      |    3 
 drivers/firmware/efi/dev-path-parser.c                               |   46 --
 drivers/firmware/efi/efi.c                                           |   13 
 drivers/firmware/efi/tpm.c                                           |    8 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                               |    3 
 drivers/gpu/drm/drm_ioctl.c                                          |    3 
 drivers/gpu/drm/i915/gvt/handlers.c                                  |   15 
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c                |    1 
 drivers/gpu/drm/ttm/ttm_device.c                                     |    2 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                       |   49 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c                                  |    1 
 drivers/i2c/busses/i2c-mpc.c                                         |    4 
 drivers/media/pci/intel/ipu3/cio2-bridge.c                           |    6 
 drivers/media/pci/ngene/ngene-core.c                                 |    2 
 drivers/media/pci/ngene/ngene.h                                      |   14 
 drivers/misc/eeprom/at24.c                                           |   17 
 drivers/mmc/core/host.c                                              |   20 -
 drivers/net/bonding/bond_main.c                                      |  183 ++++++++--
 drivers/net/dsa/mv88e6xxx/Kconfig                                    |    2 
 drivers/net/dsa/sja1105/sja1105_main.c                               |    6 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                            |   63 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c                        |    9 
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c              |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                      |   18 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c                       |    3 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c                  |   16 
 drivers/net/ethernet/google/gve/gve_main.c                           |    5 
 drivers/net/ethernet/hisilicon/hip04_eth.c                           |    6 
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h                      |    6 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c               |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c            |   10 
 drivers/net/ethernet/ibm/ibmvnic.c                                   |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c                           |    1 
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c                         |    1 
 drivers/net/ethernet/intel/iavf/iavf_main.c                          |    1 
 drivers/net/ethernet/intel/igb/igb_main.c                            |   15 
 drivers/net/ethernet/intel/igc/igc.h                                 |    2 
 drivers/net/ethernet/intel/igc/igc_main.c                            |    3 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                        |    4 
 drivers/net/ethernet/intel/ixgbevf/ipsec.c                           |   20 -
 drivers/net/ethernet/mscc/ocelot_net.c                               |    9 
 drivers/net/ethernet/realtek/r8169_main.c                            |    3 
 drivers/net/ethernet/sfc/efx_channels.c                              |   18 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                    |    1 
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c                |    8 
 drivers/net/phy/marvell10g.c                                         |   40 +-
 drivers/net/usb/hso.c                                                |   33 +
 drivers/nvme/host/core.c                                             |    5 
 drivers/nvme/host/pci.c                                              |    5 
 drivers/pwm/pwm-sprd.c                                               |   11 
 drivers/regulator/hi6421-regulator.c                                 |   30 -
 drivers/scsi/scsi_transport_iscsi.c                                  |   90 +---
 drivers/spi/spi-bcm2835.c                                            |   12 
 drivers/spi/spi-cadence-quadspi.c                                    |    3 
 drivers/spi/spi-cadence.c                                            |   14 
 drivers/spi/spi-mt65xx.c                                             |   16 
 drivers/spi/spi-stm32.c                                              |    9 
 drivers/target/target_core_sbc.c                                     |   35 -
 drivers/target/target_core_transport.c                               |    2 
 drivers/usb/core/hub.c                                               |  120 ++++--
 drivers/usb/core/quirks.c                                            |    4 
 drivers/usb/dwc2/core.h                                              |    4 
 drivers/usb/dwc2/core_intr.c                                         |    3 
 drivers/usb/dwc2/gadget.c                                            |   31 +
 drivers/usb/dwc2/hcd.c                                               |    6 
 drivers/usb/dwc2/params.c                                            |    1 
 drivers/usb/gadget/udc/tegra-xudc.c                                  |    1 
 drivers/usb/host/ehci-hcd.c                                          |   18 
 drivers/usb/host/max3421-hcd.c                                       |   44 --
 drivers/usb/host/xhci-hub.c                                          |    3 
 drivers/usb/host/xhci-pci-renesas.c                                  |   16 
 drivers/usb/host/xhci-pci.c                                          |    7 
 drivers/usb/renesas_usbhs/fifo.c                                     |    7 
 drivers/usb/serial/cp210x.c                                          |    5 
 drivers/usb/serial/option.c                                          |    3 
 drivers/usb/storage/unusual_uas.h                                    |    7 
 drivers/usb/typec/stusb160x.c                                        |   20 -
 drivers/usb/typec/tipd/core.c                                        |    9 
 fs/afs/cmservice.c                                                   |   25 -
 fs/afs/write.c                                                       |   18 
 fs/btrfs/backref.c                                                   |    6 
 fs/btrfs/backref.h                                                   |    3 
 fs/btrfs/delayed-ref.c                                               |    4 
 fs/btrfs/extent-tree.c                                               |    3 
 fs/btrfs/qgroup.c                                                    |   38 +-
 fs/btrfs/qgroup.h                                                    |    2 
 fs/btrfs/tests/qgroup-tests.c                                        |   20 -
 fs/btrfs/tree-log.c                                                  |   31 +
 fs/ceph/mds_client.c                                                 |    2 
 fs/cifs/smb2ops.c                                                    |   49 ++
 fs/hugetlbfs/inode.c                                                 |    2 
 fs/io_uring.c                                                        |   33 +
 fs/proc/base.c                                                       |    2 
 fs/userfaultfd.c                                                     |   26 -
 include/acpi/acpi_bus.h                                              |    8 
 include/drm/drm_ioctl.h                                              |    1 
 include/linux/highmem.h                                              |    2 
 include/linux/marvell_phy.h                                          |    6 
 include/linux/memblock.h                                             |    4 
 include/net/bonding.h                                                |    9 
 include/net/mptcp.h                                                  |    5 
 include/sound/soc.h                                                  |    6 
 include/trace/events/afs.h                                           |   67 +++
 kernel/bpf/verifier.c                                                |    2 
 kernel/dma/ops_helpers.c                                             |   12 
 kernel/time/posix-cpu-timers.c                                       |   10 
 kernel/time/timer.c                                                  |    8 
 kernel/trace/ring_buffer.c                                           |   28 +
 kernel/trace/trace.c                                                 |    4 
 kernel/trace/trace_events_hist.c                                     |   22 -
 kernel/trace/trace_synth.h                                           |    2 
 kernel/tracepoint.c                                                  |    2 
 mm/kfence/core.c                                                     |   19 -
 mm/memblock.c                                                        |    3 
 mm/memory.c                                                          |   11 
 mm/page_alloc.c                                                      |   29 -
 net/bpf/test_run.c                                                   |    3 
 net/caif/caif_socket.c                                               |    3 
 net/core/dev.c                                                       |   28 +
 net/core/skbuff.c                                                    |    1 
 net/core/skmsg.c                                                     |   16 
 net/decnet/af_decnet.c                                               |   27 -
 net/ipv4/tcp_bpf.c                                                   |    2 
 net/ipv4/tcp_fastopen.c                                              |   28 +
 net/ipv4/tcp_input.c                                                 |   19 -
 net/ipv4/tcp_ipv4.c                                                  |    2 
 net/ipv4/udp.c                                                       |   25 +
 net/ipv4/udp_bpf.c                                                   |    2 
 net/ipv6/ip6_output.c                                                |    4 
 net/ipv6/route.c                                                     |    2 
 net/ipv6/udp.c                                                       |   25 +
 net/mptcp/mib.c                                                      |    1 
 net/mptcp/mib.h                                                      |    1 
 net/mptcp/options.c                                                  |   24 -
 net/mptcp/pm_netlink.c                                               |   10 
 net/mptcp/protocol.c                                                 |   81 ++--
 net/mptcp/protocol.h                                                 |   14 
 net/mptcp/subflow.c                                                  |   21 -
 net/mptcp/syncookies.c                                               |   16 
 net/netrom/nr_timer.c                                                |   20 -
 net/sched/act_skbmod.c                                               |   12 
 net/sched/cls_api.c                                                  |    2 
 net/sched/cls_tcindex.c                                              |    5 
 net/sctp/auth.c                                                      |    2 
 net/sctp/socket.c                                                    |    4 
 samples/bpf/xdpsock_user.c                                           |   28 +
 scripts/Makefile.build                                               |    2 
 sound/core/pcm_native.c                                              |   25 -
 sound/hda/intel-dsp-config.c                                         |    4 
 sound/isa/sb/sb16_csp.c                                              |    4 
 sound/pci/hda/patch_hdmi.c                                           |    1 
 sound/pci/hda/patch_realtek.c                                        |    1 
 sound/soc/codecs/rt5631.c                                            |    2 
 sound/soc/codecs/wm_adsp.c                                           |    2 
 sound/soc/soc-pcm.c                                                  |   22 -
 sound/soc/sof/intel/pci-tgl.c                                        |    1 
 sound/usb/mixer.c                                                    |   10 
 sound/usb/quirks.c                                                   |    3 
 tools/bpf/bpftool/common.c                                           |    5 
 tools/perf/builtin-inject.c                                          |   13 
 tools/perf/builtin-report.c                                          |   33 +
 tools/perf/builtin-sched.c                                           |   33 +
 tools/perf/builtin-script.c                                          |    8 
 tools/perf/tests/event_update.c                                      |    6 
 tools/perf/tests/maps.c                                              |    2 
 tools/perf/tests/topology.c                                          |    1 
 tools/perf/util/data.c                                               |    2 
 tools/perf/util/dso.c                                                |    4 
 tools/perf/util/env.c                                                |    2 
 tools/perf/util/lzma.c                                               |    8 
 tools/perf/util/map.c                                                |    2 
 tools/perf/util/probe-event.c                                        |    4 
 tools/perf/util/probe-file.c                                         |    4 
 tools/perf/util/sort.c                                               |    2 
 tools/perf/util/sort.h                                               |    2 
 tools/testing/selftests/net/icmp_redirect.sh                         |    5 
 tools/testing/selftests/net/mptcp/mptcp_join.sh                      |    2 
 tools/testing/selftests/vm/userfaultfd.c                             |    6 
 209 files changed, 1838 insertions(+), 862 deletions(-)

Adrian Hunter (1):
      driver core: Prevent warning when removing a device link from unregistered consumer

Alain Volmat (1):
      spi: stm32: fixes pm_runtime calls in probe/remove

Alan Young (1):
      ALSA: pcm: Call substream ack() method upon compat mmap commit

Aleksandr Loktionov (1):
      igb: Check if num of q_vectors is smaller than max before array access

Alexander Egorenkov (1):
      s390/boot: fix use of expolines in the DMA code

Alexander Potapenko (2):
      kfence: move the size check to the beginning of __kfence_alloc()
      kfence: skip all GFP_ZONEMASK allocations

Alexander Tsoy (1):
      ALSA: usb-audio: Add registration quirk for JBL Quantum headsets

Alexandru Tachici (1):
      spi: spi-bcm2835: Fix deadlock

Amelie Delaunay (2):
      usb: typec: stusb160x: register role switch before interrupt registration
      usb: typec: stusb160x: Don't block probing of consumer of "connector" nodes

Anand Jain (1):
      btrfs: check for missing device in btrfs_trim_fs

Andy Shevchenko (2):
      efi/dev-path-parser: Switch to use for_each_acpi_dev_match()
      ACPI: utils: Fix reference counting in for_each_acpi_dev_match()

Axel Lin (2):
      regulator: hi6421: Use correct variable type for regmap api val argument
      regulator: hi6421: Fix getting wrong drvdata

Bhaumik Bhatt (2):
      bus: mhi: pci_generic: Apply no-op for wake using sideband wake boolean
      bus: mhi: core: Validate channel ID when processing command completions

Bin Meng (1):
      riscv: Fix 32-bit RISC-V boot failure

Casey Chen (1):
      nvme-pci: do not call nvme_dev_remove_admin from nvme_remove

Charles Baylis (1):
      drm: Return -ENOTTY for non-drm ioctls

Charles Keepax (1):
      ASoC: wm_adsp: Correct wm_coeff_tlv_get handling

Chengwen Feng (1):
      net: hns3: fix possible mismatches resp of mailbox

Chris Packham (1):
      i2c: mpc: Poll for MCF

Christoph Hellwig (2):
      nvme: set the PRACT bit when using Write Zeroes with T10 PI
      mm: call flush_dcache_page() in memcpy_to_page() and memzero_page()

Christophe JAILLET (7):
      ixgbe: Fix an error handling path in 'ixgbe_probe()'
      igc: Fix an error handling path in 'igc_probe()'
      igb: Fix an error handling path in 'igb_probe()'
      fm10k: Fix an error handling path in 'fm10k_probe()'
      e1000e: Fix an error handling path in 'e1000_probe()'
      iavf: Fix an error handling path in 'iavf_probe()'
      gve: Fix an error handling path in 'gve_probe()'

Colin Ian King (2):
      liquidio: Fix unintentional sign extension issue on left shift of u16
      s390/bpf: Perform r1 range checking before accessing jit->seen_reg[r1]

Colin Xu (1):
      drm/i915/gvt: Clear d3_entered on elsp cmd submission.

Daniel Borkmann (1):
      bpf: Fix tail_call_reachable rejection for interpreter when jit failed

David Disseldorp (1):
      scsi: target: Fix NULL dereference on XCOPY completion

David Howells (2):
      afs: Fix tracepoint string placement with built-in AFS
      afs: Fix setting of writeback_index

David Jeffery (1):
      usb: ehci: Prevent missed ehci interrupts with edge-triggered MSI

Dmitry Bogdanov (1):
      scsi: target: Fix protect handling in WRITE SAME(32)

Dongliang Mu (1):
      usb: hso: fix error handling code of hso_create_net_device

Eric Dumazet (1):
      net/tcp_fastopen: fix data races around tfo_active_disable_stamp

Filipe Manana (2):
      btrfs: fix unpersisted i_size on fsync after expanding truncate
      btrfs: fix lock inversion problem when doing qgroup extent tracing

Florian Fainelli (1):
      skbuff: Fix build with SKB extensions disabled

Frederic Weisbecker (1):
      posix-cpu-timers: Fix rearm racing against process tick

Geert Uytterhoeven (1):
      net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should depend on NET_DSA_MV88E6XXX

Geliang Tang (1):
      mptcp: add sk parameter for mptcp_get_options

Greg Kroah-Hartman (2):
      nds32: fix up stack guard gap
      Linux 5.13.6

Greg Thelen (1):
      usb: xhci: avoid renesas_usb_fw.mem when it's unusable

Gustavo A. R. Silva (1):
      media: ngene: Fix out-of-bounds bug in ngene_command_config_free_buf()

Hangbin Liu (2):
      selftests: icmp_redirect: remove from checking for IPv6 route get
      selftests: icmp_redirect: IPv6 PMTU info should be cleared after redirect

Haoran Luo (1):
      tracing: Fix bug in rb_per_cpu_empty() that might cause deadloop.

Heinrich Schuchardt (1):
      RISC-V: load initrd wherever it fits into memory

Hui Wang (1):
      ALSA: hda/realtek: Fix pop noise and 2 Front Mic issues on a machine

Ian Ray (1):
      USB: serial: cp210x: fix comments for GE CS1000

Ilya Dryomov (2):
      rbd: don't hold lock_rwsem while running_list is being drained
      rbd: always kick acquire on "acquired" and "released" notifications

Ioana Ciornei (1):
      dpaa2-switch: seed the buffer pool after allocating the swp

Jakub Sitnicki (1):
      bpf, sockmap, udp: sk_prot needs inuse_idx set for proc stats

Jason Ekstrand (1):
      drm/ttm: Force re-init if ttm_global_init() fails

Jedrzej Jagielski (1):
      igb: Fix position of assignment to *ring

Jens Axboe (1):
      io_uring: fix early fdput() of file

Jian Shen (1):
      net: hns3: fix rx VLAN offload state inconsistent issue

Jianguo Wu (5):
      mptcp: fix warning in __skb_flow_dissect() when do syn cookie for subflow join
      mptcp: remove redundant req destruct in subflow_check_req()
      mptcp: fix syncookie process if mptcp can not_accept new subflow
      mptcp: avoid processing packet if a subflow reset
      selftests: mptcp: fix case multiple subflows limited by server

John Fastabend (2):
      bpf, sockmap: Fix potential memory leak on unlikely error case
      bpf, sockmap, tcp: sk_prot needs inuse_idx set for proc stats

John Keeping (1):
      USB: serial: cp210x: add ID for CEL EM3588 USB ZigBee stick

Julian Sikorski (1):
      USB: usb-storage: Add LaCie Rugged USB3-FW to IGNORE_UAS

Jérôme Glisse (1):
      misc: eeprom: at24: Always append device id even if label property is set.

Kalesh AP (1):
      bnxt_en: don't disable an already disabled PCI device

Lecopzer Chen (1):
      Kbuild: lto: fix module versionings mismatch in GNU make 3.X

Like Xu (1):
      KVM: x86/pmu: Clear anythread deprecated bit when 0xa leaf is unsupported on the SVM

Likun Gao (1):
      drm/amdgpu: update golden setting for sienna_cichlid

Linus Torvalds (1):
      ACPI: fix NULL pointer dereference

Loic Poulain (1):
      bus: mhi: pci_generic: Fix inbound IPCR channel

Luis Henriques (1):
      ceph: don't WARN if we're still opening a session to an MDS

Mahesh Bandewar (1):
      bonding: fix build issue

Marc Zyngier (1):
      firmware/efi: Tell memblock about EFI iomem reservations

Marcelo Henrique Cerri (1):
      proc: Avoid mixing integer types in mem_rw()

Marco De Marco (1):
      USB: serial: option: add support for u-blox LARA-R6 family

Marek Behún (1):
      net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340

Marek Szyprowski (1):
      usb: dwc2: Skip clock gating on Samsung SoCs

Marek Vasut (1):
      spi: cadence: Correct initialisation of runtime PM again

Mark Rutland (2):
      arm64: mte: fix restoration of GCR_EL1 from suspend
      arm64: entry: fix KCOV suppression

Mark Tomlinson (1):
      usb: max-3421: Prevent corruption of freed memory

Markus Boehme (1):
      ixgbe: Fix packet corruption due to missing DMA sync

Martin Kepplinger (1):
      usb: typec: tipd: Don't block probing of consumer of "connector" nodes

Mathias Nyman (3):
      xhci: Fix lost USB 2 remote wake
      usb: hub: Disable USB 3 device initiated lpm if exit latency is too high
      usb: hub: Fix link power management max exit latency (MEL) calculations

Matthieu Baerts (1):
      mptcp: fix 'masking a bool' warning

Maxim Schwalm (1):
      ASoC: rt5631: Fix regcache sync errors on resume

Maxime Ripard (2):
      drm/vc4: hdmi: Drop devm interrupt handler for CEC interrupts
      drm/panel: raspberrypi-touchscreen: Prevent double-free

Michael Chan (3):
      bnxt_en: Refresh RoCE capabilities in bnxt_ulp_probe()
      bnxt_en: Add missing check for BNXT_STATE_ABORT_ERR in bnxt_fw_rset_task()
      bnxt_en: Validate vlan protocol ID on RX packets

Michal Suchanek (1):
      efi/tpm: Differentiate missing and invalid final event log table.

Mike Christie (1):
      scsi: iscsi: Fix iface sysfs attr detection

Mike Kravetz (1):
      hugetlbfs: fix mount mode command line processing

Mike Rapoport (1):
      memblock: make for_each_mem_range() traverse MEMBLOCK_HOTPLUG regions

Minas Harutyunyan (2):
      usb: dwc2: gadget: Fix GOUTNAK flow for Slave mode.
      usb: dwc2: gadget: Fix sending zero length packet in DDMA mode.

Mohammad Athari Bin Ismail (1):
      net: stmmac: Terminate FPE workqueue in suspend

Moritz Fischer (1):
      Revert "usb: renesas-xhci: Fix handling of unknown ROM state"

Nguyen Dinh Phi (1):
      netrom: Decrease sock refcount when sock timers expire

Nicholas Piggin (4):
      KVM: PPC: Book3S: Fix CONFIG_TRANSACTIONAL_MEM=n crash
      KVM: PPC: Fix kvm_arch_vcpu_ioctl vcpu_load leak
      KVM: PPC: Book3S: Fix H_RTAS rets buffer overflow
      KVM: PPC: Book3S HV Nested: Sanitise H_ENTER_NESTED TM state

Nicolas Dichtel (1):
      ipv6: fix 'disable_policy' for fwd packets

Nicolas Saenz Julienne (1):
      timers: Fix get_next_timer_interrupt() with no timers pending

Olivier Langlois (1):
      io_uring: Fix race condition when sqp thread goes to sleep

Paolo Abeni (4):
      mptcp: use fast lock for subflows when possible
      mptcp: refine mptcp_cleanup_rbuf
      mptcp: properly account bulk freed memory
      ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions

Paul Blakey (1):
      skbuff: Release nfct refcount on napi stolen or re-used skbs

Pavel Begunkov (2):
      io_uring: explicitly count entries for poll reqs
      io_uring: remove double poll entry on arm failure

Pavel Skripkin (1):
      net: sched: fix memory leak in tcindex_partial_destroy_work

Peilin Ye (1):
      net/sched: act_skbmod: Skip non-Ethernet packets

Peter Collingbourne (2):
      selftest: use mmap instead of posix_memalign to allocate memory
      userfaultfd: do not untag user pointers

Peter Hess (1):
      spi: mediatek: fix fifo rx mode

Peter Ujfalusi (1):
      driver core: auxiliary bus: Fix memory leak when driver_register() fail

Pierre-Louis Bossart (1):
      ALSA: hda: intel-dsp-cfg: add missing ElkhartLake PCI ID

Qi Zheng (1):
      mm: fix the deadlock in finish_fault()

Randy Dunlap (1):
      net: hisilicon: rename CACHE_LINE_MASK to avoid redefinition

Riccardo Mancini (17):
      perf inject: Fix dso->nsinfo refcounting
      perf map: Fix dso->nsinfo refcounting
      perf probe: Fix dso->nsinfo refcounting
      perf env: Fix sibling_dies memory leak
      perf test session_topology: Delete session->evlist
      perf test event_update: Fix memory leak of evlist
      perf test event_update: Fix memory leak of unit
      perf dso: Fix memory leak in dso__new_map()
      perf test maps__merge_in: Fix memory leak of maps
      perf env: Fix memory leak of cpu_pmu_caps
      perf report: Free generated help strings for sort option
      perf script: Release zstd data
      perf script: Fix memory 'threads' and 'cpus' leaks on exit
      perf lzma: Close lzma stream on exit
      perf probe-file: Delete namelist in del_events() on the error path
      perf data: Close all files in close_dir()
      perf inject: Close inject.output on exit

Robert Richter (2):
      ACPI: Kconfig: Fix table override from built-in initrd
      Documentation: Fix intiramfs script name

Roman Skakun (1):
      dma-mapping: handle vmalloc addresses in dma_common_{mmap,get_sgtable}

Ronnie Sahlberg (2):
      cifs: only write 64kb at a time when fallocating a small region of a file
      cifs: fix fallocate when trying to allocate a hole.

Sathya Prakash M R (1):
      ASoC: SOF: Intel: Update ADL descriptor to use ACPI power states

Sayanta Pattanayak (1):
      r8169: Avoid duplicate sysfs entry creation error

Sean Christopherson (2):
      KVM: SVM: Return -EFAULT if copy_to_user() for SEV mig packet header fails
      KVM: SVM: Fix sev_pin_memory() error checks in SEV migration utilities

Sergei Trofimovich (1):
      mm: page_alloc: fix page_poison=1 / INIT_ON_ALLOC_DEFAULT_ON interaction

Shahjada Abul Husain (1):
      cxgb4: fix IRQ free race during driver unload

Somnath Kotur (2):
      bnxt_en: fix error path of FW reset
      bnxt_en: Check abort error state in bnxt_half_open_nic()

Stefan Wahren (1):
      ARM: multi_v7_defconfig: Make NOP_USB_XCEIV driver built-in

Stephen Boyd (1):
      mmc: core: Don't allocate IDA for OF aliases

Steven Rostedt (VMware) (3):
      tracepoints: Update static_call before tp_funcs when adding a tracepoint
      tracing/histogram: Rename "cpu" to "common_cpu"
      tracing: Synthetic event field_pos is an index not a boolean

Sudeep Holla (1):
      firmware: arm_scmi: Ensure drivers provide a probe function

Sukadev Bhattiprolu (1):
      ibmvnic: Remove the proper scrq flush

Taehee Yoo (8):
      bonding: fix suspicious RCU usage in bond_ipsec_add_sa()
      bonding: fix null dereference in bond_ipsec_add_sa()
      ixgbevf: use xso.real_dev instead of xso.dev in callback functions of struct xfrmdev_ops
      bonding: fix suspicious RCU usage in bond_ipsec_del_sa()
      bonding: disallow setting nested bonding + ipsec offload
      bonding: Add struct bond_ipesc to manage SA
      bonding: fix suspicious RCU usage in bond_ipsec_offload_ok()
      bonding: fix incorrect return value of bond_ipsec_offload_ok()

Takashi Iwai (4):
      ALSA: usb-audio: Add missing proc text entry for BESPOKEN type
      ALSA: sb: Fix potential ABBA deadlock in CSP driver
      ALSA: hdmi: Expose all pins on MSI MS-7C94 board
      ALSA: pcm: Fix mmap capability check

Tao Zhou (1):
      drm/amdgpu: update gc golden setting for dimgrey_cavefish

Tobias Klauser (1):
      bpftool: Check malloc return value in mount_bpffs_for_pin

Tom Rix (2):
      igc: change default return of igc_read_phy_reg()
      afs: check function return

Uwe Kleine-König (1):
      pwm: sprd: Ensure configuring period and duty_cycle isn't wrongly skipped

Vadim Fedorenko (1):
      udp: check encap socket in __udp_lib_err

Vasily Gorbik (1):
      s390/ftrace: fix ftrace_update_ftrace_func implementation

Vijendar Mukunda (1):
      ASoC: soc-pcm: add a flag to reverse the stop sequence

Vincent Palatin (1):
      Revert "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem"

Vinicius Costa Gomes (2):
      igc: Fix use-after-free error during reset
      igb: Fix use-after-free error during reset

Vladimir Oltean (2):
      net: ocelot: fix switchdev objects synced for wrong netdev with LAG offload
      net: dsa: sja1105: make VID 4095 a bridge VLAN too

Wang Hai (1):
      bpf, samples: Fix xdpsock with '-M' parameter missing unload process

Wei Wang (1):
      tcp: disable TFO blackhole logic by default

Xiaojian Du (1):
      drm/amdgpu: update the golden setting for vangogh

Xin Long (2):
      sctp: trim optlen when it's a huge value in sctp_setsockopt
      sctp: update active_key for asoc when old key is being replaced

Xuan Zhuo (2):
      bpf, test: fix NULL pointer dereference on invalid expected_attach_type
      xdp, net: Fix use-after-free in bpf_xdp_link_release

Yajun Deng (2):
      net: decnet: Fix sleeping inside in af_decnet
      net: sched: cls_api: Fix the the wrong parameter

Yang Jihong (1):
      perf sched: Fix record failure when CONFIG_SCHEDSTATS is not set

Yang Yingliang (1):
      io_uring: fix memleak in io_init_wq_offload()

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Fix superfluous irqs happen after usb_pkt_pop()

Yoshitaka Ikeda (3):
      spi: spi-cadence-quadspi: Fix division by zero warning
      spi: spi-cadence-quadspi: Revert "Fix division by zero warning"
      spi: spi-cadence-quadspi: Fix division by zero warning - try2

YueHaibing (1):
      stmmac: platform: Fix signedness bug in stmmac_probe_config_dt()

Zack Rusin (1):
      drm/vmwgfx: Fix a bad merge in otable batch takedown

Zev Weiss (1):
      ARM: dts: aspeed: Update e3c246d4i vuart properties

Zhang Qilong (1):
      usb: gadget: Fix Unbalanced pm_runtime_enable in tegra_xudc_probe

Zhihao Cheng (1):
      nvme-pci: don't WARN_ON in nvme_reset_work if ctrl.state is not RESETTING

Ziyang Xuan (1):
      net: fix uninit-value in caif_seqpkt_sendmsg

Íñigo Huguet (2):
      sfc: fix lack of XDP TX queues - error XDP TX failed (-22)
      sfc: ensure correct number of XDP queues

