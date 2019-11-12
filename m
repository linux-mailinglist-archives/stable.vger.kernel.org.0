Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFBBF98C2
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfKLSet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:34:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfKLSeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 13:34:46 -0500
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D919220818;
        Tue, 12 Nov 2019 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573583685;
        bh=oam2JAyvZjqQYGzU1AAtfQVb7ioxS0Urvpq8jU2jX3A=;
        h=Date:From:To:Cc:Subject:From;
        b=J3BsP3cS1pWUPZUzB48sVSLw1kuSpRAVwGOpbHzBHsCQkub08ODuYwycSfP0zoQ0B
         RebC6jcVT39CA41GqqUAoMGU+agFJ6ySXnjgkSKTlSiftaXJ0Vffu8iQ1/wLL8s6Yr
         Fb5+bkOWXmOygWxUNCeb38kG7lYgWT0xROh93UkU=
Date:   Tue, 12 Nov 2019 19:31:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.84
Message-ID: <20191112183113.GA1828006@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.84 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu    |    2=20
 Documentation/admin-guide/hw-vuln/index.rst           |    2=20
 Documentation/admin-guide/hw-vuln/multihit.rst        |  163 ++++
 Documentation/admin-guide/hw-vuln/tsx_async_abort.rst |  276 +++++++
 Documentation/admin-guide/kernel-parameters.txt       |   92 ++
 Documentation/scheduler/sched-bwc.txt                 |   45 +
 Documentation/virtual/kvm/locking.txt                 |    4=20
 Documentation/x86/index.rst                           |    1=20
 Documentation/x86/tsx_async_abort.rst                 |  117 +++
 Makefile                                              |    2=20
 arch/arm/mach-sunxi/mc_smp.c                          |    6=20
 arch/arm64/include/asm/pgtable.h                      |   17=20
 arch/s390/kvm/kvm-s390.c                              |    4=20
 arch/x86/Kconfig                                      |   45 +
 arch/x86/events/amd/ibs.c                             |    8=20
 arch/x86/events/intel/uncore.c                        |   44 +
 arch/x86/events/intel/uncore.h                        |   12=20
 arch/x86/include/asm/cpufeatures.h                    |    2=20
 arch/x86/include/asm/kvm_host.h                       |    6=20
 arch/x86/include/asm/msr-index.h                      |   16=20
 arch/x86/include/asm/nospec-branch.h                  |    4=20
 arch/x86/include/asm/processor.h                      |    7=20
 arch/x86/kernel/apic/apic.c                           |   28=20
 arch/x86/kernel/cpu/Makefile                          |    2=20
 arch/x86/kernel/cpu/bugs.c                            |  161 ++++
 arch/x86/kernel/cpu/common.c                          |   94 +-
 arch/x86/kernel/cpu/cpu.h                             |   18=20
 arch/x86/kernel/cpu/intel.c                           |    5=20
 arch/x86/kernel/cpu/tsx.c                             |  140 +++
 arch/x86/kvm/cpuid.c                                  |    8=20
 arch/x86/kvm/mmu.c                                    |  374 ++++++++--
 arch/x86/kvm/mmu.h                                    |    4=20
 arch/x86/kvm/mmutrace.h                               |   59 +
 arch/x86/kvm/paging_tmpl.h                            |   65 +
 arch/x86/kvm/svm.c                                    |   10=20
 arch/x86/kvm/vmx.c                                    |   14=20
 arch/x86/kvm/x86.c                                    |   67 +
 block/blk-cgroup.c                                    |   13=20
 drivers/base/cpu.c                                    |   17=20
 drivers/dma/sprd-dma.c                                |   15=20
 drivers/dma/xilinx/xilinx_dma.c                       |    7=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c               |    4=20
 drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c     |   24=20
 drivers/gpu/drm/i915/i915_cmd_parser.c                |  435 ++++++++----
 drivers/gpu/drm/i915/i915_drv.c                       |    5=20
 drivers/gpu/drm/i915/i915_drv.h                       |   31=20
 drivers/gpu/drm/i915/i915_gem.c                       |   24=20
 drivers/gpu/drm/i915/i915_gem_context.c               |    5=20
 drivers/gpu/drm/i915/i915_gem_context.h               |    6=20
 drivers/gpu/drm/i915/i915_gem_execbuffer.c            |  110 ++-
 drivers/gpu/drm/i915/i915_gem_gtt.c                   |    3=20
 drivers/gpu/drm/i915/i915_reg.h                       |   10=20
 drivers/gpu/drm/i915/intel_drv.h                      |    3=20
 drivers/gpu/drm/i915/intel_pm.c                       |  115 +++
 drivers/gpu/drm/i915/intel_ringbuffer.h               |   17=20
 drivers/gpu/drm/radeon/si_dpm.c                       |    1=20
 drivers/hid/hid-google-hammer.c                       |    4=20
 drivers/hid/hid-ids.h                                 |    2=20
 drivers/hid/intel-ish-hid/ishtp/client-buffers.c      |    2=20
 drivers/hid/wacom.h                                   |   15=20
 drivers/hid/wacom_wac.c                               |   10=20
 drivers/hwtracing/intel_th/pci.c                      |   10=20
 drivers/iio/adc/stm32-adc.c                           |    4=20
 drivers/iio/imu/adis16480.c                           |    5=20
 drivers/iio/imu/inv_mpu6050/Kconfig                   |    8=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c            |   86 ++
 drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c             |    6=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h             |   30=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c            |   18=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_spi.c             |   12=20
 drivers/iio/proximity/srf04.c                         |   29=20
 drivers/infiniband/core/uverbs.h                      |    2=20
 drivers/infiniband/hw/cxgb4/cm.c                      |   30=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c            |    6=20
 drivers/infiniband/hw/mlx5/qp.c                       |    8=20
 drivers/infiniband/hw/qedr/main.c                     |    2=20
 drivers/iommu/amd_iommu_quirks.c                      |   13=20
 drivers/net/bonding/bond_main.c                       |   47 -
 drivers/net/can/c_can/c_can.c                         |   25=20
 drivers/net/can/c_can/c_can.h                         |    1=20
 drivers/net/can/dev.c                                 |    1=20
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
 drivers/net/ethernet/hisilicon/hns/hnae.c             |    1=20
 drivers/net/ethernet/hisilicon/hns/hnae.h             |    3=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c         |   22=20
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c      |    7=20
 drivers/net/ethernet/intel/igb/igb_main.c             |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c       |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c   |    4=20
 drivers/net/ethernet/mscc/ocelot.c                    |   20=20
 drivers/net/ethernet/qlogic/qede/qede_main.c          |   12=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c    |    4=20
 drivers/net/fjes/fjes_main.c                          |   15=20
 drivers/net/hyperv/netvsc_drv.c                       |    9=20
 drivers/net/macsec.c                                  |    4=20
 drivers/net/usb/cdc_ncm.c                             |    6=20
 drivers/net/usb/qmi_wwan.c                            |    1=20
 drivers/nfc/fdp/i2c.c                                 |    2=20
 drivers/nfc/st21nfca/core.c                           |    1=20
 drivers/nvme/host/multipath.c                         |    2=20
 drivers/pci/controller/pci-tegra.c                    |    7=20
 drivers/pinctrl/intel/pinctrl-cherryview.c            |    2=20
 drivers/pinctrl/intel/pinctrl-intel.c                 |   21=20
 drivers/scsi/lpfc/lpfc_nportdisc.c                    |    4=20
 drivers/scsi/qla2xxx/qla_bsg.c                        |    6=20
 drivers/scsi/qla2xxx/qla_mbx.c                        |    3=20
 drivers/scsi/qla2xxx/qla_os.c                         |    4=20
 drivers/soundwire/Kconfig                             |    1=20
 drivers/soundwire/bus.c                               |    2=20
 drivers/usb/core/config.c                             |    5=20
 drivers/usb/dwc3/core.c                               |    3=20
 drivers/usb/dwc3/dwc3-pci.c                           |    2=20
 drivers/usb/dwc3/gadget.c                             |    6=20
 drivers/usb/gadget/composite.c                        |    4=20
 drivers/usb/gadget/configfs.c                         |  110 ++-
 drivers/usb/gadget/udc/atmel_usba_udc.c               |    6=20
 drivers/usb/gadget/udc/fsl_udc_core.c                 |    2=20
 drivers/usb/misc/ldusb.c                              |    7=20
 drivers/usb/usbip/stub.h                              |    7=20
 drivers/usb/usbip/stub_main.c                         |   57 +
 drivers/usb/usbip/stub_rx.c                           |  204 ++++-
 drivers/usb/usbip/stub_tx.c                           |   99 ++
 drivers/usb/usbip/usbip_common.c                      |   59 +
 drivers/usb/usbip/vhci_hcd.c                          |   16=20
 drivers/usb/usbip/vhci_rx.c                           |    3=20
 drivers/usb/usbip/vhci_tx.c                           |   69 +
 fs/ceph/caps.c                                        |   10=20
 fs/ceph/inode.c                                       |    1=20
 fs/cifs/smb2pdu.h                                     |    1=20
 fs/configfs/configfs_internal.h                       |   15=20
 fs/configfs/dir.c                                     |  137 ++-
 fs/configfs/file.c                                    |  280 +++----
 fs/configfs/symlink.c                                 |   33=20
 fs/fs-writeback.c                                     |    9=20
 fs/nfs/delegation.c                                   |   10=20
 fs/nfs/delegation.h                                   |    1=20
 fs/nfs/nfs4proc.c                                     |    7=20
 fs/ocfs2/file.c                                       |  134 ++-
 include/linux/cpu.h                                   |   30=20
 include/linux/kvm_host.h                              |   10=20
 include/linux/mm.h                                    |    5=20
 include/linux/mm_types.h                              |    5=20
 include/linux/page-flags.h                            |   20=20
 include/net/bonding.h                                 |    3=20
 include/net/ip_vs.h                                   |    1=20
 include/net/neighbour.h                               |    4=20
 include/net/netfilter/nf_tables.h                     |    3=20
 include/net/sock.h                                    |    4=20
 include/rdma/ib_verbs.h                               |    2=20
 kernel/cpu.c                                          |   27=20
 kernel/sched/fair.c                                   |   91 --
 kernel/sched/sched.h                                  |    4=20
 lib/dump_stack.c                                      |    7=20
 mm/filemap.c                                          |    3=20
 mm/memcontrol.c                                       |    9=20
 mm/page_alloc.c                                       |   10=20
 mm/vmstat.c                                           |    2=20
 net/ipv4/fib_semantics.c                              |    2=20
 net/ipv6/route.c                                      |   13=20
 net/netfilter/ipset/ip_set_core.c                     |    8=20
 net/netfilter/ipset/ip_set_hash_ipmac.c               |    2=20
 net/netfilter/ipvs/ip_vs_app.c                        |   12=20
 net/netfilter/ipvs/ip_vs_ctl.c                        |   29=20
 net/netfilter/ipvs/ip_vs_pe.c                         |    3=20
 net/netfilter/ipvs/ip_vs_sched.c                      |    3=20
 net/netfilter/ipvs/ip_vs_sync.c                       |   13=20
 net/netfilter/nf_flow_table_core.c                    |    3=20
 net/nfc/netlink.c                                     |    2=20
 net/openvswitch/vport-internal_dev.c                  |   11=20
 net/vmw_vsock/virtio_transport_common.c               |    8=20
 sound/core/timer.c                                    |    6=20
 sound/firewire/bebob/bebob_focusrite.c                |    3=20
 sound/pci/hda/patch_ca0132.c                          |    2=20
 sound/usb/Makefile                                    |    3=20
 sound/usb/clock.c                                     |   14=20
 sound/usb/helper.h                                    |    4=20
 sound/usb/mixer.c                                     |  633 ++++++++-----=
-----
 sound/usb/power.c                                     |    2=20
 sound/usb/quirks.c                                    |    3=20
 sound/usb/stream.c                                    |   25=20
 sound/usb/validate.c                                  |  332 +++++++++
 tools/gpio/Makefile                                   |    6=20
 tools/perf/util/hist.c                                |    2=20
 tools/usb/usbip/libsrc/usbip_device_driver.c          |    6=20
 virt/kvm/kvm_main.c                                   |  154 +++-
 194 files changed, 4691 insertions(+), 1505 deletions(-)

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

Andrey Grodzovsky (1):
      drm/amdgpu: If amdgpu_ib_schedule fails return back the error.

Andy Shevchenko (1):
      pinctrl: intel: Avoid potential glitches if pin is in GPIO mode

Anton Eidelman (1):
      nvme-multipath: fix possible io hang after ctrl reconnect

Baolin Wang (1):
      dmaengine: sprd: Fix the possible memory leak issue

Bard Liao (1):
      soundwire: bus: set initial value to port_status

Ben Hutchings (1):
      drm/i915/cmdparser: Fix jump whitelist clearing

Catalin Marinas (1):
      arm64: Do not mask out PTE_RDONLY in pte_same()

Chandana Kishori Chiluveru (1):
      usb: gadget: composite: Fix possible double free memory bug

Chuhong Yuan (1):
      net: ethernet: arc: add the missed clk_disable_unprepare

Claudiu Manoil (2):
      net: mscc: ocelot: don't handle netdev events for other netdevs
      net: mscc: ocelot: fix NULL pointer on LAG slave removal

Cristian Birsan (1):
      usb: gadget: udc: atmel: Fix interrupt storm in FIFO mode.

Dan Carpenter (3):
      netfilter: ipset: Fix an error code in ip_set_sockfn_get()
      ALSA: usb-audio: remove some dead code
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

Eric Dumazet (4):
      net: fix data-race in neigh_event_send()
      ipv6: fixes rt6_probe() and fib6_nh->last_probe init
      ipvs: move old_secure_tcp into struct netns_ipvs
      net: prevent load/store tearing on sk->sk_stamp

Fabrice Gasnier (1):
      iio: adc: stm32-adc: fix stopping dma

Felipe Balbi (1):
      usb: dwc3: gadget: fix race when disabling ep with cancelled xfers

Gomez Iglesias, Antonio (1):
      Documentation: Add ITLB_MULTIHIT documentation

Greg Kroah-Hartman (1):
      Linux 4.19.84

GwanYeong Kim (1):
      usbip: tools: Fix read_usb_vudc_device() error path handling

Haiyang Zhang (1):
      hv_netvsc: Fix error handling in netvsc_attach()

Hannes Reinecke (1):
      scsi: qla2xxx: fixup incorrect usage of host_byte

Hans de Goede (1):
      pinctrl: cherryview: Fix irq_valid_mask calculation

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

Jean-Baptiste Maneyrol (1):
      iio: imu: inv_mpu6050: fix no data on MPU6050

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

Johannes Weiner (1):
      mm: memcontrol: fix network errors from failing __GFP_ATOMIC charges

Jon Bloomfield (10):
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

Kan Liang (1):
      perf/x86/uncore: Fix event group support

Kevin Hao (1):
      dump_stack: avoid the livelock of the dump_lock

Kim Phillips (2):
      perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus pre=
cise RIP validity
      perf/x86/amd/ibs: Handle erratum #420 only on the affected CPU family=
 (10h)

Konstantin Khlebnikov (1):
      mm/filemap.c: don't initiate writeback if mapping has no dirty pages

Kurt Van Dijck (1):
      can: c_can: c_can_poll(): only read status register after status IRQ

Lijun Ou (1):
      RDMA/hns: Prevent memory leaks of eq->buf_list

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

Mel Gorman (1):
      mm, meminit: recalculate pcpu batch and high limits after init comple=
tes

Michael Strauss (1):
      drm/amd/display: Passive DP->HDMI dongle detection fix

Michal Hocko (2):
      mm, vmstat: hide /proc/pagetypeinfo from normal users
      x86/tsx: Add config options to set tsx=3Don|off|auto

Michal Suchanek (1):
      soundwire: depend on ACPI

Navid Emamdoost (3):
      can: gs_usb: gs_can_open(): prevent memory leak
      net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
      usb: dwc3: pci: prevent memory leak in dwc3_pci_probe

Nicholas Piggin (1):
      scsi: qla2xxx: stop timer in shutdown path

Nicolas Boichat (1):
      HID: google: add magnemite/masterball USB ids

Nikhil Badola (1):
      usb: fsl: Check memory resource before releasing it

Oliver Neukum (1):
      CDC-NCM: handle incomplete transfer of MTU

Ondrej Jirman (1):
      ARM: sunxi: Fix CPU powerdown on A83T

Pablo Neira Ayuso (1):
      netfilter: nf_flow_table: set timeout before insertion into hashes

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

Pavel Shilovsky (1):
      SMB3: Fix persistent handles reconnect

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

Potnuri Bharat Teja (2):
      iw_cxgb4: fix ECN check on the passive accept
      RDMA/iw_cxgb4: Avoid freeing skb twice in arp failure case

Qian Cai (1):
      sched/fair: Fix -Wunused-but-set-variable warnings

Radhey Shyam Pandey (1):
      dmaengine: xilinx_dma: Fix control reg update in vdma_channel_set_con=
fig

Rafi Wiener (1):
      RDMA/mlx5: Clear old rate limit when closing QP

Randolph Maa=DFen (1):
      iio: imu: mpu6050: Add support for the ICM 20602 IMU

Salil Mehta (1):
      net: hns: Fix the stray netpoll locks causing deadlock in NAPI path

Sean Tranchetti (1):
      net: qualcomm: rmnet: Fix potential UAF when unregistering

Shuah Khan (2):
      tools: gpio: Use !building_out_of_srctree to determine srctree
      usbip: Fix vhci_urb_enqueue() URB null transfer buffer error path

Shuning Zhang (1):
      ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()

Stefano Brivio (1):
      netfilter: ipset: Copy the right MAC address in hash:ip,mac IPv6 sets

Stefano Garzarella (1):
      vsock/virtio: fix sock refcnt holding during the shutdown

Stephane Grosjean (1):
      can: peak_usb: fix a potential out-of-sync while decoding packets

Steve Moskovchenko (1):
      iio: imu: mpu6050: Fix FIFO layout for ICM20602

Suwan Kim (2):
      usbip: Implement SG support to vhci-hcd and stub driver
      usbip: Fix free of unallocated memory in vhci tx

Taehee Yoo (2):
      bonding: fix unexpected IFF_BONDING bit unset
      macsec: fix refcnt leak in module exit routine

Takashi Iwai (10):
      ALSA: timer: Fix incorrectly assigned timer instance
      ALSA: hda/ca0132 - Fix possible workqueue stall
      ALSA: usb-audio: More validations of descriptor units
      ALSA: usb-audio: Simplify parse_audio_unit()
      ALSA: usb-audio: Unify the release of usb_mixer_elem_info objects
      ALSA: usb-audio: Remove superfluous bLength checks
      ALSA: usb-audio: Clean up check_input_term()
      ALSA: usb-audio: Fix possible NULL dereference at create_yamaha_midi_=
quirk()
      ALSA: usb-audio: Fix copy&paste error in the validator
      iommu/amd: Apply the same IVRS IOAPIC workaround to Acer Aspire A315-=
41

Takashi Sakamoto (1):
      ALSA: bebob: fix to detect configured source of sampling clock for Fo=
cusrite Saffire Pro i/o series

Tariq Toukan (1):
      net/mlx5e: TX, Fix consumer index of error cqe dump

Tejun Heo (2):
      blkcg: make blkcg_print_stat() print stats only for online blkgs
      cgroup,writeback: don't switch wbs immediately on dead wbs if the mem=
cg is dead

Trond Myklebust (1):
      NFSv4: Don't allow a cached open with a revoked delegation

Tyler Hicks (1):
      cpu/speculation: Uninline and export CPU mitigations helpers

Uma Shankar (1):
      drm/i915: Lower RM timeout to avoid DSI hard hangs

Vidya Sagar (1):
      PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30

Vineela Tummalapalli (1):
      x86/bugs: Add ITLB_MULTIHIT bug infrastructure

Vladimir Oltean (2):
      net: mscc: ocelot: fix vlan_filtering when enslaving to bridge before=
 link is up
      net: mscc: ocelot: refuse to overwrite the port's native vlan

Wen Yang (1):
      can: dev: add missing of_node_put() after calling of_get_child_by_nam=
e()

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


--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3K+nEACgkQONu9yGCS
aT5GnhAAwLJ7XSCWVTN+hlJBO/Ei+ZGqkrNBsHiDYJeGQ/t+UbWTvHvFPMcbivKa
4flZwhBzbqzZX8DeQ/RnNvC0FAR6HFDY94lvurqv8EO70UpXhRLMYTv03eR7mZCG
vrE4THxBPCvO00cTAfvhpthn9bk6ScIQ8gOyXv1m0KyuDorkhl0v/eexrZt291PS
TnhIYKx/FeBk+IgHGmjwQ3xbte0WOcXsx4vuph9f87ndlutIZ1+P+z08dXhQVZR2
Xka+c67OWFpbTQVjQQLAAyixNLm9CTlpw6eHo22S6fBM2iLrL6mH3uZAvR0hVdpi
YN3Vi/MjdZ/eN3un8W6XRbvsHWzF38i13HlZarKgpmg6LUXJI4AgmHCu/YCO9CN4
T+sOqoPSN0DF7u7rp5H0KbSL5sK4IgwhvCw7vIqT5WfNwL/dGPexB+lb8mo081CQ
x+yMNEkVqcq0aNPM1w6myfQjo+RJaHIpSRoxjYSpqcTlJXvYeP3CqGtec50Ciwtc
mJHD+Zyr8Cv4Le2Ce9DdCLnQ4gGuxH+G/39JiPgWfOb6HKWdGIjUmSu7WsDL/SMN
E8mr5aCDTetsq1HQTnlFBVKtMlzGiX9Ut8p/kFyU78wPKSjwh0SMTN7rR/Z4n4D5
9thlYqKZ+MQJ6jBDzwe6v5K2LAHTzQAi6AScA7i8T+4rMCVbbg8=
=Q9iY
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
