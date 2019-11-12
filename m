Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821F0F98BB
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfKLSel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:34:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727153AbfKLSeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 13:34:37 -0500
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D173C20818;
        Tue, 12 Nov 2019 18:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573583675;
        bh=R+JMgKCVzK/JxHsz9ByjRFbTKwKc+eWNdrPiLLIlyzs=;
        h=Date:From:To:Cc:Subject:From;
        b=ZswRuP9PElf3/NtUxY3SunuIJ6rwpbUDiPCJN4CAZ/S9zSFr75GLm3JoX9CUQlPhz
         ojLS5S9PW0Arkb7uc2YRxbIDOEOsWiVF/vDm7TFQJEB5LHdCGEFqfERHiHf3oea8VL
         LdVMZga3azt6GVN08fxqq3/1V1geZJiDKnR/v25A=
Date:   Tue, 12 Nov 2019 19:30:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.154
Message-ID: <20191112183047.GA1827940@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.154 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu    |    2=20
 Documentation/admin-guide/hw-vuln/index.rst           |    2=20
 Documentation/admin-guide/hw-vuln/multihit.rst        |  163 ++++++
 Documentation/admin-guide/hw-vuln/tsx_async_abort.rst |  276 ++++++++++
 Documentation/admin-guide/kernel-parameters.txt       |   92 +++
 Documentation/devicetree/bindings/usb/dwc3.txt        |    2=20
 Documentation/scheduler/sched-bwc.txt                 |   45 +
 Documentation/virtual/kvm/locking.txt                 |    4=20
 Documentation/x86/index.rst                           |    1=20
 Documentation/x86/tsx_async_abort.rst                 |  117 ++++
 Makefile                                              |    2=20
 arch/arm/boot/dts/dra7.dtsi                           |    1=20
 arch/arm64/include/asm/pgtable.h                      |   17=20
 arch/s390/kvm/kvm-s390.c                              |    4=20
 arch/x86/Kconfig                                      |   45 +
 arch/x86/events/amd/ibs.c                             |    8=20
 arch/x86/include/asm/cpufeatures.h                    |    2=20
 arch/x86/include/asm/kvm_host.h                       |    6=20
 arch/x86/include/asm/msr-index.h                      |   16=20
 arch/x86/include/asm/nospec-branch.h                  |    4=20
 arch/x86/include/asm/processor.h                      |    7=20
 arch/x86/include/asm/smp.h                            |   10=20
 arch/x86/kernel/apic/apic.c                           |  122 ++--
 arch/x86/kernel/cpu/Makefile                          |    2=20
 arch/x86/kernel/cpu/bugs.c                            |  161 ++++++
 arch/x86/kernel/cpu/common.c                          |   94 ++-
 arch/x86/kernel/cpu/cpu.h                             |   18=20
 arch/x86/kernel/cpu/intel.c                           |    5=20
 arch/x86/kernel/cpu/tsx.c                             |  140 +++++
 arch/x86/kvm/cpuid.c                                  |    8=20
 arch/x86/kvm/mmu.c                                    |  374 ++++++++++++--
 arch/x86/kvm/mmu.h                                    |    4=20
 arch/x86/kvm/mmutrace.h                               |   59 ++
 arch/x86/kvm/paging_tmpl.h                            |   65 +-
 arch/x86/kvm/svm.c                                    |   10=20
 arch/x86/kvm/vmx.c                                    |   14=20
 arch/x86/kvm/x86.c                                    |   63 ++
 drivers/base/cpu.c                                    |   17=20
 drivers/cpufreq/ti-cpufreq.c                          |    1=20
 drivers/dma/xilinx/xilinx_dma.c                       |    7=20
 drivers/gpu/drm/drm_gem.c                             |    9=20
 drivers/gpu/drm/i915/i915_cmd_parser.c                |  455 ++++++++++++-=
-----
 drivers/gpu/drm/i915/i915_drv.c                       |    4=20
 drivers/gpu/drm/i915/i915_drv.h                       |   30 +
 drivers/gpu/drm/i915/i915_gem.c                       |   26 -
 drivers/gpu/drm/i915/i915_gem_context.c               |    5=20
 drivers/gpu/drm/i915/i915_gem_context.h               |    6=20
 drivers/gpu/drm/i915/i915_gem_execbuffer.c            |  118 +++-
 drivers/gpu/drm/i915/i915_gem_gtt.c                   |   73 +-
 drivers/gpu/drm/i915/i915_gem_gtt.h                   |    7=20
 drivers/gpu/drm/i915/i915_gem_object.h                |   13=20
 drivers/gpu/drm/i915/i915_gem_request.c               |    4=20
 drivers/gpu/drm/i915/i915_reg.h                       |   10=20
 drivers/gpu/drm/i915/intel_drv.h                      |    3=20
 drivers/gpu/drm/i915/intel_pm.c                       |  161 +++++-
 drivers/gpu/drm/i915/intel_ringbuffer.c               |   11=20
 drivers/gpu/drm/i915/intel_ringbuffer.h               |   16=20
 drivers/gpu/drm/radeon/si_dpm.c                       |    1=20
 drivers/hid/intel-ish-hid/ishtp/client-buffers.c      |    2=20
 drivers/hid/wacom.h                                   |   15=20
 drivers/hid/wacom_wac.c                               |   10=20
 drivers/hwtracing/intel_th/pci.c                      |   10=20
 drivers/i2c/busses/i2c-omap.c                         |   25=20
 drivers/iio/adc/stm32-adc.c                           |    4=20
 drivers/iio/imu/adis16480.c                           |    5=20
 drivers/iio/proximity/srf04.c                         |   29 -
 drivers/infiniband/core/uverbs.h                      |    2=20
 drivers/infiniband/hw/cxgb4/cm.c                      |    2=20
 drivers/infiniband/hw/qedr/main.c                     |    2=20
 drivers/mailbox/mailbox.c                             |    4=20
 drivers/mailbox/pcc.c                                 |    4=20
 drivers/mfd/palmas.c                                  |   10=20
 drivers/misc/pci_endpoint_test.c                      |   17=20
 drivers/mtd/spi-nor/cadence-quadspi.c                 |   27 +
 drivers/mtd/spi-nor/spi-nor.c                         |    2=20
 drivers/net/bonding/bond_main.c                       |   47 -
 drivers/net/can/c_can/c_can.c                         |   25=20
 drivers/net/can/c_can/c_can.h                         |    1=20
 drivers/net/can/flexcan.c                             |    1=20
 drivers/net/can/rx-offload.c                          |    6=20
 drivers/net/can/usb/gs_usb.c                          |    1=20
 drivers/net/can/usb/mcba_usb.c                        |    3=20
 drivers/net/can/usb/peak_usb/pcan_usb.c               |   17=20
 drivers/net/can/usb/peak_usb/pcan_usb_core.c          |    2=20
 drivers/net/can/usb/usb_8dev.c                        |    3=20
 drivers/net/ethernet/arc/emac_rockchip.c              |    3=20
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c      |    2=20
 drivers/net/ethernet/hisilicon/hip04_eth.c            |    1=20
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c      |    7=20
 drivers/net/ethernet/intel/igb/igb_main.c             |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c   |    4=20
 drivers/net/ethernet/qlogic/qede/qede_main.c          |   12=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c    |    4=20
 drivers/net/fjes/fjes_main.c                          |   15=20
 drivers/net/hyperv/netvsc_drv.c                       |    9=20
 drivers/net/macsec.c                                  |    4=20
 drivers/net/usb/cdc_ncm.c                             |    6=20
 drivers/net/usb/qmi_wwan.c                            |    1=20
 drivers/nfc/fdp/i2c.c                                 |    2=20
 drivers/nfc/st21nfca/core.c                           |    1=20
 drivers/pci/dwc/pci-dra7xx.c                          |   17=20
 drivers/pci/host/pci-tegra.c                          |    7=20
 drivers/scsi/lpfc/lpfc_nportdisc.c                    |    4=20
 drivers/scsi/qla2xxx/qla_bsg.c                        |    6=20
 drivers/scsi/qla2xxx/qla_mbx.c                        |    3=20
 drivers/scsi/qla2xxx/qla_os.c                         |    4=20
 drivers/usb/core/config.c                             |    5=20
 drivers/usb/dwc3/core.c                               |    6=20
 drivers/usb/dwc3/core.h                               |    3=20
 drivers/usb/dwc3/gadget.c                             |    6=20
 drivers/usb/gadget/composite.c                        |    4=20
 drivers/usb/gadget/configfs.c                         |  110 ++++
 drivers/usb/gadget/udc/atmel_usba_udc.c               |    6=20
 drivers/usb/gadget/udc/fsl_udc_core.c                 |    2=20
 drivers/usb/misc/ldusb.c                              |    7=20
 drivers/usb/usbip/Kconfig                             |    1=20
 drivers/usb/usbip/stub.h                              |    7=20
 drivers/usb/usbip/stub_main.c                         |   57 +-
 drivers/usb/usbip/stub_rx.c                           |  213 +++++---
 drivers/usb/usbip/stub_tx.c                           |   99 +++
 drivers/usb/usbip/usbip_common.c                      |   59 +-
 drivers/usb/usbip/vhci_hcd.c                          |   16=20
 drivers/usb/usbip/vhci_rx.c                           |    3=20
 drivers/usb/usbip/vhci_tx.c                           |   69 ++
 fs/ceph/caps.c                                        |   10=20
 fs/ceph/inode.c                                       |    1=20
 fs/configfs/configfs_internal.h                       |   15=20
 fs/configfs/dir.c                                     |  137 ++++-
 fs/configfs/file.c                                    |  294 +++++------
 fs/configfs/symlink.c                                 |   33 +
 fs/fs-writeback.c                                     |    9=20
 fs/nfs/delegation.c                                   |   10=20
 fs/nfs/delegation.h                                   |    1=20
 fs/nfs/nfs4proc.c                                     |    7=20
 include/drm/drm_vma_manager.h                         |    1=20
 include/linux/cpu.h                                   |   30 -
 include/linux/kvm_host.h                              |   10=20
 include/linux/mfd/palmas.h                            |    3=20
 include/linux/mm.h                                    |    5=20
 include/linux/mm_types.h                              |    5=20
 include/linux/page-flags.h                            |   20=20
 include/linux/scatterlist.h                           |   10=20
 include/net/bonding.h                                 |    3=20
 include/net/ip_vs.h                                   |    1=20
 include/net/neighbour.h                               |    4=20
 include/net/netfilter/nf_tables.h                     |    3=20
 include/net/sock.h                                    |    4=20
 include/rdma/ib_verbs.h                               |    2=20
 kernel/cpu.c                                          |   27 +
 kernel/sched/fair.c                                   |   85 ---
 kernel/sched/sched.h                                  |    4=20
 lib/Kconfig                                           |    4=20
 lib/dump_stack.c                                      |    7=20
 lib/scatterlist.c                                     |  105 ++++
 mm/filemap.c                                          |    3=20
 mm/vmstat.c                                           |    2=20
 net/ipv4/fib_semantics.c                              |    2=20
 net/netfilter/ipset/ip_set_core.c                     |    8=20
 net/netfilter/ipvs/ip_vs_app.c                        |   12=20
 net/netfilter/ipvs/ip_vs_ctl.c                        |   29 -
 net/netfilter/ipvs/ip_vs_pe.c                         |    3=20
 net/netfilter/ipvs/ip_vs_sched.c                      |    3=20
 net/netfilter/ipvs/ip_vs_sync.c                       |   13=20
 net/nfc/netlink.c                                     |    2=20
 net/openvswitch/vport-internal_dev.c                  |   11=20
 sound/core/timer.c                                    |    6=20
 sound/firewire/bebob/bebob_focusrite.c                |    3=20
 sound/pci/hda/patch_ca0132.c                          |    2=20
 sound/soc/codecs/tlv320aic31xx.c                      |   30 -
 sound/soc/davinci/davinci-mcasp.c                     |   21=20
 tools/gpio/Makefile                                   |    6=20
 tools/perf/util/hist.c                                |    2=20
 virt/kvm/kvm_main.c                                   |  154 +++++-
 173 files changed, 4057 insertions(+), 1111 deletions(-)

Al Viro (6):
      ceph: add missing check in d_revalidate snapdir handling
      configfs: stash the data we need into configfs_buffer at open time
      configfs_register_group() shouldn't be (and isn't) called in rmdirabl=
e parts
      configfs: new object reprsenting tree fragments
      configfs: provide exclusion between IO and removals
      configfs: fix a deadlock in configfs_symlink()

Alan Stern (1):
      USB: Skip endpoints with 0 maxpacket length

Aleksander Morgado (1):
      net: usb: qmi_wwan: add support for DW5821e with eSIM support

Alex Deucher (1):
      drm/radeon: fix si_enable_smc_cac() failed issue

Alexander Shishkin (2):
      intel_th: pci: Add Comet Lake PCH support
      intel_th: pci: Add Jasper Lake PCH support

Alexander Sverdlin (1):
      net: ethernet: octeon_mgmt: Account for second possible VLAN header

Alexandru Ardelean (1):
      iio: imu: adis16480: make sure provided frequency is positive

Andreas Klinger (1):
      iio: srf04: fix wrong limitation in distance measuring

Andrew F. Davis (1):
      ASoC: tlv320aic31xx: Handle inverted BCLK in non-DSP modes

Arvind Yadav (1):
      ASoC: davinci-mcasp: Handle return value of devm_kasprintf

Bart Van Assche (1):
      lib/scatterlist: Introduce sgl_alloc() and sgl_free()

Ben Hutchings (1):
      drm/i915/cmdparser: Fix jump whitelist clearing

Catalin Marinas (1):
      arm64: Do not mask out PTE_RDONLY in pte_same()

Chandana Kishori Chiluveru (1):
      usb: gadget: composite: Fix possible double free memory bug

Chris Wilson (4):
      drm/i915/gtt: Disable read-only support under GVT
      drm/i915: Prevent writing into a read-only object via a GGTT mmap
      drm/i915: Silence smatch for cmdparser
      drm/i915: Don't use GPU relocations prior to cmdparser stalls

Christophe Jaillet (1):
      ASoC: davinci-mcasp: Fix an error handling path in 'davinci_mcasp_pro=
be()'

Chuhong Yuan (1):
      net: ethernet: arc: add the missed clk_disable_unprepare

Claudio Foellmi (1):
      i2c: omap: Trigger bus recovery in lockup case

Cristian Birsan (1):
      usb: gadget: udc: atmel: Fix interrupt storm in FIFO mode.

Dan Carpenter (3):
      netfilter: ipset: Fix an error code in ip_set_sockfn_get()
      misc: pci_endpoint_test: Prevent some integer overflows
      RDMA/uverbs: Prevent potential underflow

Daniel Wagner (1):
      scsi: lpfc: Honor module parameter lpfc_use_adisc

Dave Chiluk (1):
      sched/fair: Fix low cpu usage with high throttling by removing expira=
tion of cpu-local slices

David Ahern (1):
      ipv4: Fix table id reference in fib_sync_down_addr

Davide Caratti (1):
      ipvs: don't ignore errors in case refcounting ip_vs module fails

Dou Liyang (2):
      x86/apic: Move pending interrupt check code into it's own function
      x86/apic: Drop logical_smp_processor_id() inline

Eric Dumazet (3):
      net: fix data-race in neigh_event_send()
      ipvs: move old_secure_tcp into struct netns_ipvs
      net: prevent load/store tearing on sk->sk_stamp

Fabrice Gasnier (1):
      iio: adc: stm32-adc: fix stopping dma

Gomez Iglesias, Antonio (1):
      Documentation: Add ITLB_MULTIHIT documentation

Greg Kroah-Hartman (1):
      Linux 4.14.154

Gustavo A. R. Silva (1):
      ASoC: tlv320dac31xx: mark expected switch fall-through

Haiyang Zhang (1):
      hv_netvsc: Fix error handling in netvsc_attach()

Hannes Reinecke (1):
      scsi: qla2xxx: fixup incorrect usage of host_byte

Hillf Danton (1):
      net: openvswitch: free vport unless register_netdevice() succeeds

Himanshu Madhani (1):
      scsi: qla2xxx: Initialized mailbox to prevent driver load failure

Imre Deak (1):
      drm/i915/gen8+: Add RC6 CTX corruption WA

Jan Beulich (1):
      x86/apic/32: Avoid bogus LDR warnings

Jason Gerecke (1):
      HID: wacom: generic: Treat serial number and related fields as unsign=
ed

Jay Vosburgh (1):
      bonding: fix state transition issue in link monitoring

Jiangfeng Xiao (1):
      net: hisilicon: Fix "Trying to free already-free IRQ"

Jiri Olsa (1):
      perf tools: Fix time sorting

Joakim Zhang (1):
      can: flexcan: disable completely the ECC mechanism

Johan Hovold (4):
      can: usb_8dev: fix use-after-free on disconnect
      can: mcba_usb: fix use-after-free on disconnect
      can: peak_usb: fix slab info leak
      USB: ldusb: use unsigned size format specifiers

Jon Bloomfield (11):
      drm/i915/gtt: Add read only pages to gen8_pte_encode
      drm/i915: Rename gen7 cmdparser tables
      drm/i915: Disable Secure Batches for gen6+
      drm/i915: Remove Master tables from cmdparser
      drm/i915: Add support for mandatory cmdparsing
      drm/i915: Support ro ppgtt mapped cmdparser shadow buffers
      drm/i915: Allow parsing of unsized batches
      drm/i915: Add gen9 BCS cmdparsing
      drm/i915/cmdparser: Use explicit goto for error paths
      drm/i915/cmdparser: Add support for backward jumps
      drm/i915/cmdparser: Ignore Length operands during command matching

Josh Poimboeuf (1):
      x86/speculation/taa: Fix printing of TAA_MSG_SMT on IBRS_ALL CPUs

Junaid Shahid (4):
      kvm: Convert kvm_lock to a mutex
      kvm: mmu: Do not release the page inside mmu_set_spte()
      kvm: Add helper function for creating VM worker threads
      kvm: x86: mmu: Recovery of shattered NX large pages

Kamal Heib (1):
      RDMA/qedr: Fix reported firmware version

Keerthy (2):
      mfd: palmas: Assign the right powerhold mask for tps65917
      PCI: dra7xx: Add shutdown handler to cleanly turn off clocks

Kevin Hao (1):
      dump_stack: avoid the livelock of the dump_lock

Kim Phillips (2):
      perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus pre=
cise RIP validity
      perf/x86/amd/ibs: Handle erratum #420 only on the affected CPU family=
 (10h)

Kishon Vijay Abraham I (1):
      misc: pci_endpoint_test: Fix BUG_ON error during pci_disable_msi()

Konstantin Khlebnikov (1):
      mm/filemap.c: don't initiate writeback if mapping has no dirty pages

Kurt Van Dijck (1):
      can: c_can: c_can_poll(): only read status register after status IRQ

Luis Henriques (1):
      ceph: fix use-after-free in __ceph_remove_cap()

Lukas Wunner (1):
      netfilter: nf_tables: Align nft_expr private data to 64-bit

Manfred Rudigier (1):
      igb: Fix constant media auto sense switching when no cable is connect=
ed

Manish Chopra (1):
      qede: fix NULL pointer deref in __qede_remove()

Marc Kleine-Budde (1):
      can: rx-offload: can_rx_offload_queue_sorted(): fix error handling, a=
void skb mem leak

Michal Hocko (2):
      mm, vmstat: hide /proc/pagetypeinfo from normal users
      x86/tsx: Add config options to set tsx=3Don|off|auto

Michal Srb (2):
      drm/i915/cmdparser: Check reg_table_count before derefencing.
      drm/i915/cmdparser: Do not check past the cmd length.

Navid Emamdoost (2):
      can: gs_usb: gs_can_open(): prevent memory leak
      net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq

Nicholas Piggin (1):
      scsi: qla2xxx: stop timer in shutdown path

Nikhil Badola (1):
      usb: fsl: Check memory resource before releasing it

Oliver Neukum (1):
      CDC-NCM: handle incomplete transfer of MTU

Pan Bian (3):
      NFC: fdp: fix incorrect free object
      nfc: netlink: fix double device reference drop
      NFC: st21nfca: fix double free

Paolo Bonzini (8):
      KVM: x86: use Intel speculation bugs and features as derived in gener=
ic x86 code
      kvm: x86, powerpc: do not allow clearing largepages debugfs entry
      KVM: x86: make FNAME(fetch) and __direct_map more similar
      KVM: x86: remove now unneeded hugepage gfn adjustment
      KVM: x86: change kvm_mmu_page_get_gfn BUG_ON to WARN_ON
      KVM: x86: add tracepoints around __direct_map and FNAME(fetch)
      KVM: vmx, svm: always run with EFER.NXE=3D1 when shadow paging is act=
ive
      kvm: mmu: ITLB_MULTIHIT mitigation

Pawan Gupta (9):
      x86/msr: Add the IA32_TSX_CTRL MSR
      x86/cpu: Add a helper function x86_read_arch_cap_msr()
      x86/cpu: Add a "tsx=3D" cmdline option with TSX disabled by default
      x86/speculation/taa: Add mitigation for TSX Async Abort
      x86/speculation/taa: Add sysfs reporting for TSX Async Abort
      kvm/x86: Export MDS_NO=3D0 to guests when TSX is enabled
      x86/tsx: Add "auto" option to the tsx=3D cmdline parameter
      x86/speculation/taa: Add documentation for TSX Async Abort
      x86/cpu: Add Tremont to the cpu vulnerability whitelist

Peter Chen (1):
      usb: gadget: configfs: fix concurrent issue between composite APIs

Potnuri Bharat Teja (1):
      RDMA/iw_cxgb4: Avoid freeing skb twice in arp failure case

Qian Cai (1):
      sched/fair: Fix -Wunused-but-set-variable warnings

Radhey Shyam Pandey (1):
      dmaengine: xilinx_dma: Fix control reg update in vdma_channel_set_con=
fig

Roger Quadros (2):
      usb: dwc3: Allow disabling of metastability workaround
      ARM: dts: dra7: Disable USB metastability workaround for USB2

Roman Yeryomin (1):
      mtd: spi-nor: enable 4B opcodes for mx66l51235l

Sean Tranchetti (1):
      net: qualcomm: rmnet: Fix potential UAF when unregistering

Shuah Khan (3):
      tools: gpio: Use !building_out_of_srctree to determine srctree
      usbip: Fix vhci_urb_enqueue() URB null transfer buffer error path
      usbip: stub_rx: fix static checker warning on unnecessary checks

Stephane Grosjean (1):
      can: peak_usb: fix a potential out-of-sync while decoding packets

Sudeep Holla (1):
      mailbox: reset txdone_method TXDONE_BY_POLL if client knows_txdone

Suwan Kim (2):
      usbip: Implement SG support to vhci-hcd and stub driver
      usbip: Fix free of unallocated memory in vhci tx

Taehee Yoo (2):
      bonding: fix unexpected IFF_BONDING bit unset
      macsec: fix refcnt leak in module exit routine

Takashi Iwai (3):
      ALSA: timer: Fix incorrectly assigned timer instance
      ALSA: hda/ca0132 - Fix possible workqueue stall
      ASoC: davinci: Kill BUG_ON() usage

Takashi Sakamoto (1):
      ALSA: bebob: fix to detect configured source of sampling clock for Fo=
cusrite Saffire Pro i/o series

Tejun Heo (1):
      cgroup,writeback: don't switch wbs immediately on dead wbs if the mem=
cg is dead

Thomas Meyer (1):
      configfs: Fix bool initialization/comparison

Trond Myklebust (1):
      NFSv4: Don't allow a cached open with a revoked delegation

Tvrtko Ursulin (1):
      drm/i915: Move engine->needs_cmd_parser to engine->flags

Tyler Hicks (1):
      cpu/speculation: Uninline and export CPU mitigations helpers

Uma Shankar (1):
      drm/i915: Lower RM timeout to avoid DSI hard hangs

Vidya Sagar (1):
      PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30

Vignesh R (1):
      mtd: spi-nor: cadence-quadspi: add a delay in write sequence

Vineela Tummalapalli (1):
      x86/bugs: Add ITLB_MULTIHIT bug infrastructure

Vivi, Rodrigo (1):
      drm/i915/gtt: Read-only pages for insert_entries on bdw+

Wenwen Wang (1):
      e1000: fix memory leaks

Will Deacon (1):
      fjes: Handle workqueue allocation failure

Yang Shi (1):
      mm: thp: handle page cache THP correctly in PageTransCompoundMap

Yinbo Zhu (1):
      usb: dwc3: remove the call trace of USBx_GFLADJ

Zhang Lixu (1):
      HID: intel-ish-hid: fix wrong error handling in ishtp_cl_alloc_tx_rin=
g()

Zumeng Chen (1):
      cpufreq: ti-cpufreq: add missing of_node_put()


--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3K+lcACgkQONu9yGCS
aT69NQ//S7EgfoLz8qw5rSn6jS7aUbJvaZBkH76GDpBGVcsP98XPtWiS6wwbRYhm
HXXS12JXfmjwf2YnVctfxinJPUfbQ2r/ExFCfPFjhylThgStGW2zFlRtcayph4Mg
dxAKyIyPicbJRyPaPETbJkFufZvYJFndU1oxKqz4XxrVytx1lCiKr5rRLi1CeDue
qxSkewHNUh0o/roMPh+blyaG/B5+tm2dwEUufpGY6dYdYgPYXr74dBApJ3cJ7JLu
CgeGSuxYO4MjkG15VVMWSy+lB1rHlQfBO8XCk1qoiibJtxKTlJJcbZ7X9VQ5jrr9
lYsGEPsDbo4rn2vHjd8ko3+APDVF6Ql4a9bKz1CTIxmB2A5KW48NtXrzFlxB/vWa
861sUvhcHDDG272J/Sb9ZQnUlRKOrLkNA7MG19QFBpASKg5Xcjn6h2md/G+wogif
rl1TWdk5MUiSPnuxWDxlqhSbu9YzOcBFGyLMYmsZ5OMZ5EhNvQr9mx1LIRCwN1jK
ZfgWJZzNmaNYBGSOyyNIKIUPYSpd13y9+LXz2mv3WiRwSaUFQpbU8NROEy5Sv8yw
jZemCWUgF7Ud2l2g28g9VYBkMU+O+36JuIWiVkFph6DwDJVmEJnM9F0EiGWY+0FD
P2nUGdOYRe8JfercFLZ1zLG7KF9a51EEyiDSK/sqdeWVWjLa5yY=
=60G5
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
