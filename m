Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1634F98C8
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfKLSe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:34:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbfKLSe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 13:34:56 -0500
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FAB420818;
        Tue, 12 Nov 2019 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573583692;
        bh=8aFD1Ia0UhCVnH7Lqo8cd99vIhOtHMQsKshN91khzbc=;
        h=Date:From:To:Cc:Subject:From;
        b=CQBzLnmM/gDqUeHlIzn0V3hBs2uYcZguj9BXsRS/Jr/kFFjZ7epUS0J3l+X5CoywB
         +CsPVLQ2D+kogBPq5l9u/HrjC8uAYI8bKhF5xwDudp7LhU562Cpn1ONyfJwK5EoSNk
         uDYr7Fp6QPsB89HnZ3IHUidTM7SqpHJPAcynKgdY=
Date:   Tue, 12 Nov 2019 19:31:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.11
Message-ID: <20191112183133.GA1828061@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.11 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-devices-system-cpu             |    2=20
 Documentation/admin-guide/hw-vuln/index.rst                    |    2=20
 Documentation/admin-guide/hw-vuln/multihit.rst                 |  163 ++
 Documentation/admin-guide/hw-vuln/tsx_async_abort.rst          |  276 ++++
 Documentation/admin-guide/kernel-parameters.txt                |   92 +
 Documentation/arm64/silicon-errata.rst                         |    7=20
 Documentation/x86/index.rst                                    |    1=20
 Documentation/x86/tsx_async_abort.rst                          |  117 +
 Makefile                                                       |    2=20
 arch/arc/boot/dts/hsdk.dts                                     |    8=20
 arch/arc/configs/hsdk_defconfig                                |    2=20
 arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi                  |    4=20
 arch/arm/boot/dts/stm32mp157c-ev1.dts                          |    1=20
 arch/arm/mach-sunxi/mc_smp.c                                   |    6=20
 arch/arm64/include/asm/cputype.h                               |    2=20
 arch/arm64/include/asm/pgtable.h                               |   17=20
 arch/arm64/include/asm/vdso/vsyscall.h                         |    7=20
 arch/arm64/kernel/cpu_errata.c                                 |   62=20
 arch/powerpc/include/asm/book3s/32/kup.h                       |    1=20
 arch/powerpc/kvm/book3s.c                                      |    8=20
 arch/x86/Kconfig                                               |   45=20
 arch/x86/boot/compressed/eboot.c                               |    4=20
 arch/x86/events/amd/ibs.c                                      |    8=20
 arch/x86/events/intel/uncore.c                                 |   44=20
 arch/x86/events/intel/uncore.h                                 |   12=20
 arch/x86/include/asm/cpufeatures.h                             |    2=20
 arch/x86/include/asm/kvm_host.h                                |    6=20
 arch/x86/include/asm/msr-index.h                               |   16=20
 arch/x86/include/asm/nospec-branch.h                           |    4=20
 arch/x86/include/asm/processor.h                               |    7=20
 arch/x86/kernel/apic/apic.c                                    |   28=20
 arch/x86/kernel/cpu/Makefile                                   |    2=20
 arch/x86/kernel/cpu/bugs.c                                     |  159 ++
 arch/x86/kernel/cpu/common.c                                   |   97 +
 arch/x86/kernel/cpu/cpu.h                                      |   18=20
 arch/x86/kernel/cpu/intel.c                                    |    5=20
 arch/x86/kernel/cpu/tsx.c                                      |  140 ++
 arch/x86/kernel/dumpstack_64.c                                 |    7=20
 arch/x86/kvm/mmu.c                                             |  270 ++++
 arch/x86/kvm/mmu.h                                             |    4=20
 arch/x86/kvm/paging_tmpl.h                                     |   29=20
 arch/x86/kvm/x86.c                                             |   45=20
 block/blk-cgroup.c                                             |   13=20
 drivers/base/cpu.c                                             |   17=20
 drivers/clk/imx/clk-imx8mm.c                                   |    2=20
 drivers/cpufreq/intel_pstate.c                                 |    4=20
 drivers/dma/sprd-dma.c                                         |   27=20
 drivers/dma/xilinx/xilinx_dma.c                                |   10=20
 drivers/firmware/efi/libstub/Makefile                          |    1=20
 drivers/firmware/efi/libstub/arm32-stub.c                      |   16=20
 drivers/firmware/efi/libstub/efi-stub-helper.c                 |   24=20
 drivers/firmware/efi/tpm.c                                     |    1=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c                        |    4=20
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c                         |    1=20
 drivers/gpu/drm/amd/display/dc/core/dc.c                       |    4=20
 drivers/gpu/drm/amd/display/dc/core/dc_link_ddc.c              |   24=20
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c              |    6=20
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c |    3=20
 drivers/gpu/drm/i915/gem/i915_gem_context.c                    |    5=20
 drivers/gpu/drm/i915/gem/i915_gem_context_types.h              |    5=20
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c                 |  109 +
 drivers/gpu/drm/i915/gt/intel_engine_types.h                   |   13=20
 drivers/gpu/drm/i915/gt/intel_gt_pm.c                          |    8=20
 drivers/gpu/drm/i915/i915_cmd_parser.c                         |  435 ++++=
--
 drivers/gpu/drm/i915/i915_drv.c                                |    6=20
 drivers/gpu/drm/i915/i915_drv.h                                |   31=20
 drivers/gpu/drm/i915/i915_gem.c                                |   16=20
 drivers/gpu/drm/i915/i915_reg.h                                |   10=20
 drivers/gpu/drm/i915/intel_pm.c                                |  115 +
 drivers/gpu/drm/i915/intel_pm.h                                |    3=20
 drivers/gpu/drm/radeon/si_dpm.c                                |    1=20
 drivers/gpu/drm/scheduler/sched_main.c                         |   19=20
 drivers/gpu/drm/v3d/v3d_gem.c                                  |    5=20
 drivers/hid/hid-google-hammer.c                                |    4=20
 drivers/hid/hid-ids.h                                          |    2=20
 drivers/hid/intel-ish-hid/ishtp/client-buffers.c               |    2=20
 drivers/hid/wacom.h                                            |   15=20
 drivers/hid/wacom_wac.c                                        |   10=20
 drivers/hwmon/ina3221.c                                        |    2=20
 drivers/hwtracing/intel_th/gth.c                               |    3=20
 drivers/hwtracing/intel_th/pci.c                               |   10=20
 drivers/iio/adc/stm32-adc.c                                    |    4=20
 drivers/iio/imu/adis16480.c                                    |    5=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c                     |    9=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h                      |    2=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c                     |   15=20
 drivers/iio/proximity/srf04.c                                  |   29=20
 drivers/infiniband/core/nldev.c                                |    2=20
 drivers/infiniband/core/uverbs.h                               |    2=20
 drivers/infiniband/core/verbs.c                                |    9=20
 drivers/infiniband/hw/cxgb4/cm.c                               |   30=20
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c                     |    6=20
 drivers/infiniband/hw/mlx5/qp.c                                |    8=20
 drivers/infiniband/hw/qedr/main.c                              |    2=20
 drivers/infiniband/sw/siw/siw_qp.c                             |    2=20
 drivers/infiniband/sw/siw/siw_verbs.c                          |    2=20
 drivers/iommu/amd_iommu_quirks.c                               |   13=20
 drivers/net/bonding/bond_main.c                                |   58=20
 drivers/net/can/c_can/c_can.c                                  |   25=20
 drivers/net/can/c_can/c_can.h                                  |    1=20
 drivers/net/can/dev.c                                          |    1=20
 drivers/net/can/flexcan.c                                      |    1=20
 drivers/net/can/rx-offload.c                                   |    6=20
 drivers/net/can/usb/gs_usb.c                                   |    1=20
 drivers/net/can/usb/mcba_usb.c                                 |    3=20
 drivers/net/can/usb/peak_usb/pcan_usb.c                        |   17=20
 drivers/net/can/usb/peak_usb/pcan_usb_core.c                   |    2=20
 drivers/net/can/usb/usb_8dev.c                                 |    3=20
 drivers/net/ethernet/arc/emac_rockchip.c                       |    3=20
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c               |    2=20
 drivers/net/ethernet/google/gve/gve_rx.c                       |    2=20
 drivers/net/ethernet/google/gve/gve_tx.c                       |   24=20
 drivers/net/ethernet/hisilicon/hip04_eth.c                     |    1=20
 drivers/net/ethernet/hisilicon/hns/hnae.c                      |    1=20
 drivers/net/ethernet/hisilicon/hns/hnae.h                      |    3=20
 drivers/net/ethernet/hisilicon/hns/hns_enet.c                  |   22=20
 drivers/net/ethernet/ibm/ibmvnic.c                             |  224 ++-
 drivers/net/ethernet/ibm/ibmvnic.h                             |    1=20
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c               |    7=20
 drivers/net/ethernet/intel/igb/igb_main.c                      |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h        |    7=20
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c     |   11=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c              |    6=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c                |   35=20
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c            |    4=20
 drivers/net/ethernet/mellanox/mlx5/core/health.c               |    2=20
 drivers/net/ethernet/mscc/ocelot.c                             |   20=20
 drivers/net/ethernet/qlogic/qede/qede_main.c                   |   12=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c             |    4=20
 drivers/net/ethernet/realtek/r8169_main.c                      |    3=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |    1=20
 drivers/net/fjes/fjes_main.c                                   |   15=20
 drivers/net/hyperv/netvsc_drv.c                                |    9=20
 drivers/net/macsec.c                                           |    4=20
 drivers/net/phy/smsc.c                                         |    1=20
 drivers/net/usb/cdc_ncm.c                                      |    6=20
 drivers/net/usb/qmi_wwan.c                                     |    1=20
 drivers/net/wimax/i2400m/op-rfkill.c                           |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                  |  125 -
 drivers/net/wireless/mediatek/mt76/dma.c                       |    6=20
 drivers/net/wireless/mediatek/mt76/mt76.h                      |    5=20
 drivers/net/wireless/virt_wifi.c                               |   54=20
 drivers/nfc/fdp/i2c.c                                          |    2=20
 drivers/nfc/st21nfca/core.c                                    |    1=20
 drivers/nvme/host/multipath.c                                  |    2=20
 drivers/pinctrl/intel/pinctrl-cherryview.c                     |    2=20
 drivers/pinctrl/intel/pinctrl-intel.c                          |   21=20
 drivers/scsi/lpfc/lpfc_nportdisc.c                             |    4=20
 drivers/scsi/lpfc/lpfc_sli.c                                   |    2=20
 drivers/scsi/qla2xxx/qla_bsg.c                                 |    6=20
 drivers/scsi/qla2xxx/qla_mbx.c                                 |    3=20
 drivers/scsi/qla2xxx/qla_os.c                                  |    4=20
 drivers/scsi/sd.c                                              |    3=20
 drivers/scsi/ufs/ufs_bsg.c                                     |    4=20
 drivers/soundwire/Kconfig                                      |    1=20
 drivers/soundwire/bus.c                                        |    2=20
 drivers/usb/core/config.c                                      |    5=20
 drivers/usb/dwc3/Kconfig                                       |    1=20
 drivers/usb/dwc3/core.c                                        |    3=20
 drivers/usb/dwc3/dwc3-pci.c                                    |    2=20
 drivers/usb/dwc3/gadget.c                                      |    6=20
 drivers/usb/gadget/composite.c                                 |    4=20
 drivers/usb/gadget/configfs.c                                  |  110 +
 drivers/usb/gadget/udc/atmel_usba_udc.c                        |    6=20
 drivers/usb/gadget/udc/fsl_udc_core.c                          |    2=20
 drivers/usb/misc/ldusb.c                                       |    7=20
 drivers/usb/usbip/stub.h                                       |    7=20
 drivers/usb/usbip/stub_main.c                                  |   57=20
 drivers/usb/usbip/stub_rx.c                                    |  204 ++-
 drivers/usb/usbip/stub_tx.c                                    |   99 +
 drivers/usb/usbip/usbip_common.c                               |   59=20
 drivers/usb/usbip/vhci_hcd.c                                   |   12=20
 drivers/usb/usbip/vhci_rx.c                                    |    3=20
 drivers/usb/usbip/vhci_tx.c                                    |   69 -
 fs/btrfs/inode.c                                               |   15=20
 fs/btrfs/tree-checker.c                                        |    8=20
 fs/btrfs/volumes.c                                             |    1=20
 fs/ceph/caps.c                                                 |   10=20
 fs/ceph/dir.c                                                  |   15=20
 fs/ceph/file.c                                                 |   15=20
 fs/ceph/inode.c                                                |    1=20
 fs/cifs/smb2pdu.h                                              |    1=20
 fs/configfs/symlink.c                                          |   33=20
 fs/fs-writeback.c                                              |    9=20
 fs/nfs/delegation.c                                            |   10=20
 fs/nfs/delegation.h                                            |    1=20
 fs/nfs/nfs4proc.c                                              |    7=20
 fs/ocfs2/file.c                                                |  134 +-
 include/asm-generic/vdso/vsyscall.h                            |    7=20
 include/linux/cpu.h                                            |   30=20
 include/linux/efi.h                                            |   18=20
 include/linux/filter.h                                         |    1=20
 include/linux/kvm_host.h                                       |    8=20
 include/linux/mm.h                                             |    5=20
 include/linux/mm_types.h                                       |    5=20
 include/linux/page-flags.h                                     |   20=20
 include/linux/skmsg.h                                          |    9=20
 include/linux/sunrpc/bc_xprt.h                                 |    5=20
 include/net/bonding.h                                          |    4=20
 include/net/ip_vs.h                                            |    1=20
 include/net/neighbour.h                                        |    4=20
 include/net/netfilter/nf_tables.h                              |    3=20
 include/net/sch_generic.h                                      |    4=20
 include/net/sock.h                                             |    4=20
 include/net/tls.h                                              |    5=20
 include/rdma/ib_verbs.h                                        |    2=20
 kernel/bpf/core.c                                              |    2=20
 kernel/bpf/syscall.c                                           |   31=20
 kernel/cgroup/cpuset.c                                         |    3=20
 kernel/cpu.c                                                   |   27=20
 kernel/fork.c                                                  |   33=20
 kernel/sched/topology.c                                        |   11=20
 kernel/time/vsyscall.c                                         |    9=20
 lib/dump_stack.c                                               |    7=20
 mm/filemap.c                                                   |    3=20
 mm/khugepaged.c                                                |    7=20
 mm/memcontrol.c                                                |   23=20
 mm/page_alloc.c                                                |   10=20
 mm/slab.h                                                      |    4=20
 mm/vmstat.c                                                    |    2=20
 net/core/lwt_bpf.c                                             |    7=20
 net/core/skmsg.c                                               |   20=20
 net/ipv4/fib_semantics.c                                       |    2=20
 net/ipv6/route.c                                               |   13=20
 net/netfilter/ipset/ip_set_core.c                              |    8=20
 net/netfilter/ipset/ip_set_hash_ipmac.c                        |    2=20
 net/netfilter/ipvs/ip_vs_app.c                                 |   12=20
 net/netfilter/ipvs/ip_vs_ctl.c                                 |   29=20
 net/netfilter/ipvs/ip_vs_pe.c                                  |    3=20
 net/netfilter/ipvs/ip_vs_sched.c                               |    3=20
 net/netfilter/ipvs/ip_vs_sync.c                                |   13=20
 net/netfilter/nf_flow_table_core.c                             |    3=20
 net/netfilter/nft_payload.c                                    |   38=20
 net/nfc/netlink.c                                              |    2=20
 net/openvswitch/vport-internal_dev.c                           |   11=20
 net/sched/cls_api.c                                            |   83 +
 net/smc/smc_pnet.c                                             |    2=20
 net/sunrpc/backchannel_rqst.c                                  |    7=20
 net/sunrpc/xprt.c                                              |    5=20
 net/sunrpc/xprtrdma/backchannel.c                              |    2=20
 net/tls/tls_device.c                                           |   10=20
 net/tls/tls_main.c                                             |    2=20
 net/tls/tls_sw.c                                               |   30=20
 net/vmw_vsock/virtio_transport_common.c                        |    8=20
 net/xdp/xdp_umem.c                                             |    6=20
 sound/core/timer.c                                             |    6=20
 sound/firewire/bebob/bebob_focusrite.c                         |    3=20
 sound/pci/hda/patch_ca0132.c                                   |    2=20
 sound/soc/sh/rcar/dma.c                                        |    4=20
 sound/soc/sof/intel/hda-stream.c                               |    4=20
 sound/usb/Makefile                                             |    3=20
 sound/usb/clock.c                                              |   14=20
 sound/usb/helper.h                                             |    4=20
 sound/usb/mixer.c                                              |  633 ++++=
------
 sound/usb/power.c                                              |    2=20
 sound/usb/quirks.c                                             |    3=20
 sound/usb/stream.c                                             |   25=20
 sound/usb/validate.c                                           |  332 +++++
 tools/gpio/Makefile                                            |    6=20
 tools/perf/util/hist.c                                         |    2=20
 tools/perf/util/map.c                                          |    2=20
 tools/testing/selftests/bpf/test_tc_edt.sh                     |    2=20
 tools/testing/selftests/net/tls.c                              |  108 +
 tools/usb/usbip/libsrc/usbip_device_driver.c                   |    6=20
 virt/kvm/kvm_main.c                                            |  124 +
 265 files changed, 5037 insertions(+), 1451 deletions(-)

Adam Ford (1):
      ARM: dts: imx6-logicpd: Re-enable SNVS power key

Al Viro (3):
      ceph: fix RCU case handling in ceph_d_revalidate()
      ceph: add missing check in d_revalidate snapdir handling
      configfs: fix a deadlock in configfs_symlink()

Alan Stern (1):
      USB: Skip endpoints with 0 maxpacket length

Aleksander Morgado (1):
      net: usb: qmi_wwan: add support for DW5821e with eSIM support

Alex Deucher (1):
      drm/radeon: fix si_enable_smc_cac() failed issue

Alexander Shishkin (3):
      intel_th: gth: Fix the window switching sequence
      intel_th: pci: Add Comet Lake PCH support
      intel_th: pci: Add Jasper Lake PCH support

Alexander Sverdlin (1):
      net: ethernet: octeon_mgmt: Account for second possible VLAN header

Alexandru Ardelean (1):
      iio: imu: adis16480: make sure provided frequency is positive

Amelie Delaunay (1):
      ARM: dts: stm32: change joystick pinctrl definition on stm32mp157c-ev1

Andreas Klinger (1):
      iio: srf04: fix wrong limitation in distance measuring

Andrey Grodzovsky (2):
      drm/sched: Set error to s_fence if HW job submission failed.
      drm/amdgpu: If amdgpu_ib_schedule fails return back the error.

Andy Shevchenko (1):
      pinctrl: intel: Avoid potential glitches if pin is in GPIO mode

Anton Eidelman (1):
      nvme-multipath: fix possible io hang after ctrl reconnect

Ard Biesheuvel (1):
      efi: libstub/arm: Account for firmware reserved memory at the base of=
 RAM

Arnd Bergmann (1):
      usb: dwc3: select CONFIG_REGMAP_MMIO

Avri Altman (1):
      scsi: ufs-bsg: Wake the device before sending raw upiu commands

Baolin Wang (1):
      dmaengine: sprd: Fix the possible memory leak issue

Bard Liao (1):
      soundwire: bus: set initial value to port_status

Ben Hutchings (1):
      drm/i915/cmdparser: Fix jump whitelist clearing

Bjorn Andersson (1):
      arm64: cpufeature: Enable Qualcomm Falkor errata 1009 for Kryo

Catalin Marinas (1):
      arm64: Do not mask out PTE_RDONLY in pte_same()

Chandana Kishori Chiluveru (1):
      usb: gadget: composite: Fix possible double free memory bug

Christian Brauner (1):
      clone3: validate stack arguments

Christophe Leroy (1):
      powerpc/32s: fix allow/prevent_user_access() when crossing segment bo=
undaries.

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

Daniel Borkmann (2):
      bpf: Fix use after free in subprog's jited symbol removal
      bpf: Fix use after free in bpf_get_prog_name

Daniel Wagner (2):
      scsi: lpfc: Check queue pointer before use
      scsi: lpfc: Honor module parameter lpfc_use_adisc

David Ahern (1):
      ipv4: Fix table id reference in fib_sync_down_addr

Davide Caratti (1):
      ipvs: don't ignore errors in case refcounting ip_vs module fails

Doug Berger (1):
      arm64: apply ARM64_ERRATUM_845719 workaround for Brahma-B53 core

Eric Dumazet (4):
      net: fix data-race in neigh_event_send()
      ipv6: fixes rt6_probe() and fib6_nh->last_probe init
      net: prevent load/store tearing on sk->sk_stamp
      ipvs: move old_secure_tcp into struct netns_ipvs

Eugeniy Paltsev (1):
      ARC: [plat-hsdk]: Enable on-board SPI NOR flash IC

Fabrice Gasnier (1):
      iio: adc: stm32-adc: fix stopping dma

Felipe Balbi (1):
      usb: dwc3: gadget: fix race when disabling ep with cancelled xfers

Florian Fainelli (2):
      arm64: Brahma-B53 is SSB and spectre v2 safe
      arm64: apply ARM64_ERRATUM_843419 workaround for Brahma-B53 core

Gomez Iglesias, Antonio (1):
      Documentation: Add ITLB_MULTIHIT documentation

Greg Kroah-Hartman (1):
      Linux 5.3.11

GwanYeong Kim (1):
      usbip: tools: Fix read_usb_vudc_device() error path handling

Haiyang Zhang (1):
      hv_netvsc: Fix error handling in netvsc_attach()

Hannes Reinecke (1):
      scsi: qla2xxx: fixup incorrect usage of host_byte

Hans de Goede (1):
      pinctrl: cherryview: Fix irq_valid_mask calculation

Heiner Kallweit (1):
      r8169: fix page read in r8168g_mdio_read

Hillf Danton (1):
      net: openvswitch: free vport unless register_netdevice() succeeds

Himanshu Madhani (1):
      scsi: qla2xxx: Initialized mailbox to prevent driver load failure

Huacai Chen (1):
      timekeeping/vsyscall: Update VDSO data unconditionally

Imre Deak (1):
      drm/i915/gen8+: Add RC6 CTX corruption WA

Jakub Kicinski (4):
      net/tls: fix sk_msg trim on fallback to copy mode
      net/tls: don't pay attention to sk_write_pending when pushing partial=
 records
      net/tls: add a TX lock
      selftests/tls: add test for concurrent recv and send

Jan Beulich (1):
      x86/apic/32: Avoid bogus LDR warnings

Jason Gerecke (1):
      HID: wacom: generic: Treat serial number and related fields as unsign=
ed

Jay Vosburgh (1):
      bonding: fix state transition issue in link monitoring

Jean-Baptiste Maneyrol (1):
      iio: imu: inv_mpu6050: fix no data on MPU6050

Jeff Layton (1):
      ceph: don't try to handle hashed dentries in non-O_CREAT atomic_open

Jerry Snitselaar (1):
      efi/tpm: Return -EINVAL when determining tpm final events log size fa=
ils

Jiada Wang (1):
      ASoC: rsnd: dma: fix SSI9 4/5/6/7 busif dma address

Jiangfeng Xiao (1):
      net: hisilicon: Fix "Trying to free already-free IRQ"

Jiri Benc (2):
      bpf: lwtunnel: Fix reroute supplying invalid dst
      selftests/bpf: More compatible nc options in test_tc_edt

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

John Hurley (1):
      net: sched: prevent duplicate flower rules from tcf_proto destroy race

John Keeping (1):
      perf map: Use zalloc for map_groups

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

Josef Bacik (1):
      btrfs: save i_size to avoid double evaluation of i_size_read in compr=
ess_file_range

Josh Poimboeuf (1):
      x86/speculation/taa: Fix printing of TAA_MSG_SMT on IBRS_ALL CPUs

Juliet Kim (1):
      net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run

Jun Lei (2):
      drm/amd/display: do not synchronize "drr" displays
      drm/amd/display: add 50us buffer as WA for pstate switch in active

Junaid Shahid (2):
      kvm: Add helper function for creating VM worker threads
      kvm: x86: mmu: Recovery of shattered NX large pages

Kairui Song (1):
      x86, efi: Never relocate kernel below lowest acceptable address

Kamal Heib (1):
      RDMA/qedr: Fix reported firmware version

Kan Liang (1):
      perf/x86/uncore: Fix event group support

Kevin Hao (1):
      dump_stack: avoid the livelock of the dump_lock

Keyon Jie (1):
      ASoC: SOF: Intel: hda-stream: fix the CONFIG_ prefix missing

Kim Phillips (2):
      perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus pre=
cise RIP validity
      perf/x86/amd/ibs: Handle erratum #420 only on the affected CPU family=
 (10h)

Konstantin Khlebnikov (1):
      mm/filemap.c: don't initiate writeback if mapping has no dirty pages

Krishnamraju Eraparaju (1):
      RDMA/siw: free siw_base_qp in kref release routine

Kurt Van Dijck (1):
      can: c_can: c_can_poll(): only read status register after status IRQ

Leonard Crestez (1):
      clk: imx8m: Use SYS_PLL1_800M as intermediate parent of CLK_ARM

Lijun Ou (1):
      RDMA/hns: Prevent memory leaks of eq->buf_list

Lorenzo Bianconi (1):
      mt76: dma: fix buffer unmap with non-linear skbs

Luca Coelho (3):
      iwlwifi: pcie: fix PCI ID 0x2720 configs that should be soc
      iwlwifi: pcie: fix all 9460 entries for qnj
      iwlwifi: pcie: 0x2720 is qu and 0x30DC is not

Luis Henriques (2):
      ceph: fix use-after-free in __ceph_remove_cap()
      ceph: don't allow copy_file_range when stripe_count !=3D 1

Lukas Wunner (1):
      netfilter: nf_tables: Align nft_expr private data to 64-bit

Magnus Karlsson (1):
      xsk: Fix registration of Rx-only sockets

Manfred Rudigier (1):
      igb: Fix constant media auto sense switching when no cable is connect=
ed

Manish Chopra (1):
      qede: fix NULL pointer deref in __qede_remove()

Marc Kleine-Budde (1):
      can: rx-offload: can_rx_offload_queue_sorted(): fix error handling, a=
void skb mem leak

Mark Zhang (1):
      RDMA/nldev: Skip counter if port doesn't match

Martin Fuzzey (1):
      net: phy: smsc: LAN8740: add PHY_RST_AFTER_CLK_EN flag

Mel Gorman (1):
      mm, meminit: recalculate pcpu batch and high limits after init comple=
tes

Michael Strauss (1):
      drm/amd/display: Passive DP->HDMI dongle detection fix

Michal Hocko (2):
      mm, vmstat: hide /proc/pagetypeinfo from normal users
      x86/tsx: Add config options to set tsx=3Don|off|auto

Michal Suchanek (2):
      soundwire: depend on ACPI
      soundwire: depend on ACPI || OF

Navid Emamdoost (6):
      can: gs_usb: gs_can_open(): prevent memory leak
      net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
      net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
      drm/v3d: Fix memory leak in v3d_submit_cl_ioctl
      usb: dwc3: pci: prevent memory leak in dwc3_pci_probe
      wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Nicholas Piggin (1):
      scsi: qla2xxx: stop timer in shutdown path

Nicolas Boichat (1):
      HID: google: add magnemite/masterball USB ids

Nicolin Chen (1):
      hwmon: (ina3221) Fix read timeout issue

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

Paolo Bonzini (2):
      kvm: x86, powerpc: do not allow clearing largepages debugfs entry
      kvm: mmu: ITLB_MULTIHIT mitigation

Parav Pandit (1):
      IB/core: Use rdma_read_gid_l2_fields to compare GID L2 fields

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

Pierre-Eric Pelloux-Prayer (1):
      drm/amdgpu/sdma5: do not execute 0-sized IBs (v2)

Potnuri Bharat Teja (2):
      iw_cxgb4: fix ECN check on the passive accept
      RDMA/iw_cxgb4: Avoid freeing skb twice in arp failure case

Qu Wenruo (2):
      btrfs: Consider system chunk array size for new SYSTEM chunks
      btrfs: tree-checker: Fix wrong check on max devid

Radhey Shyam Pandey (2):
      dmaengine: xilinx_dma: Fix 64-bit simple AXIDMA transfer
      dmaengine: xilinx_dma: Fix control reg update in vdma_channel_set_con=
fig

Rafi Wiener (1):
      RDMA/mlx5: Clear old rate limit when closing QP

Roman Gushchin (1):
      mm: slab: make page_cgroup_ino() to recognize non-compound slab pages=
 properly

Salil Mehta (1):
      net: hns: Fix the stray netpoll locks causing deadlock in NAPI path

Sean Tranchetti (1):
      net: qualcomm: rmnet: Fix potential UAF when unregistering

Shakeel Butt (1):
      mm: memcontrol: fix NULL-ptr deref in percpu stats flush

Shuah Khan (1):
      tools: gpio: Use !building_out_of_srctree to determine srctree

Shuning Zhang (1):
      ocfs2: protect extent tree in ocfs2_prepare_inode_for_write()

Srinivas Pandruvada (1):
      cpufreq: intel_pstate: Fix invalid EPB setting

Stefano Brivio (1):
      netfilter: ipset: Copy the right MAC address in hash:ip,mac IPv6 sets

Stefano Garzarella (1):
      vsock/virtio: fix sock refcnt holding during the shutdown

Stephane Grosjean (1):
      can: peak_usb: fix a potential out-of-sync while decoding packets

Suwan Kim (2):
      usbip: Implement SG support to vhci-hcd and stub driver
      usbip: Fix free of unallocated memory in vhci tx

Taehee Yoo (5):
      bonding: fix unexpected IFF_BONDING bit unset
      bonding: use dynamic lockdep key instead of subclass
      macsec: fix refcnt leak in module exit routine
      virt_wifi: fix refcnt leak in module exit routine
      bonding: fix using uninitialized mode_lock

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

Tariq Toukan (3):
      net/mlx5e: Tx, Fix assumption of single WQEBB of NOP in cleanup flow
      net/mlx5e: kTLS, Release reference on DUMPed fragments in shutdown fl=
ow
      net/mlx5e: TX, Fix consumer index of error cqe dump

Tejun Heo (2):
      blkcg: make blkcg_print_stat() print stats only for online blkgs
      cgroup,writeback: don't switch wbs immediately on dead wbs if the mem=
cg is dead

Thierry Reding (1):
      arm64: errata: Update stale comment

Thomas Gleixner (1):
      x86/dumpstack/64: Don't evaluate exception stacks before setup

Trond Myklebust (4):
      SUNRPC: The TCP back channel mustn't disappear while requests are out=
standing
      SUNRPC: The RDMA back channel mustn't disappear while requests are ou=
tstanding
      SUNRPC: Destroy the back channel when we destroy the host transport
      NFSv4: Don't allow a cached open with a revoked delegation

Tyler Hicks (1):
      cpu/speculation: Uninline and export CPU mitigations helpers

Uma Shankar (1):
      drm/i915: Lower RM timeout to avoid DSI hard hangs

Ursula Braun (1):
      net/smc: fix ethernet interface refcounting

Valentin Schneider (2):
      sched/topology: Don't try to build empty sched domains
      sched/topology: Allow sched_asym_cpucapacity to be disabled

Ville Syrj=E4l=E4 (1):
      mm/khugepaged: fix might_sleep() warn with CONFIG_HIGHPTE=3Dy

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

Xiang Chen (1):
      scsi: sd: define variable dif as unsigned int instead of bool

Yang Shi (1):
      mm: thp: handle page cache THP correctly in PageTransCompoundMap

Yangchun Fu (1):
      gve: Fixes DMA synchronization.

Yinbo Zhu (1):
      usb: dwc3: remove the call trace of USBx_GFLADJ

Zhang Lixu (1):
      HID: intel-ish-hid: fix wrong error handling in ishtp_cl_alloc_tx_rin=
g()

Zhenfang Wang (1):
      dmaengine: sprd: Fix the link-list pointer register configuration iss=
ue

wenxu (1):
      netfilter: nft_payload: fix missing check for matching length in offl=
oads

yuqi jin (1):
      net: stmmac: Fix the problem of tso_xmit

zhongshiqi (1):
      dc.c:use kzalloc without test


--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3K+oUACgkQONu9yGCS
aT5ICw//YwZKGJr73jIu2HRG3zUuGlcVrD8JEKlcGuVLdLtlkHyjJ0GZEdJQWBLQ
164MgAtpvPF230d/QHBjQp1EBt4/myhNrxovtB6rzNwWY7pmiVwDC6cdXbz4x7Rw
+GXaRSeawAgd5pF6n3cUvxJX0sAOq1HIPFlsThinjbNR3YRu5Usfelfi14t4NM2n
3ijCkuCzIQT0VqrVmJo8xlKhjx5xeObS2glmkib0gBdlwIg+nwLEDj4yqqUn2m6a
zfOfBizFhPZnAOcKBKMSZ49EPam2cQXjeddFHDJkqO2/udH43wB2yQ8y/xcApAG+
a5o32QMYlFRNoyR5AWYhqEOiLCodEynlXRfbNreuvOTuGF5CnLQ1JDbEeb6M0ay/
ZkqTtgr80UHuNMQ3lJTwOjYOPNVvcAJAPAF8IEh9iDpXPVieZYJtjZ2ZAI6C0v4u
vnLkuZN8Z7rz3l8WaEaBKtdwz9WAsMasbls18D6kNP7HY6AAupYmR3YYWhlt9byB
CP5k6N2H0jgkGJwUkLjWUT/yZOo36HVbfePvvXcmX3hHEHhkg8zOwAGnBeaAkgjc
e7jrG/ku+V5SuzHf7fTgQ9ubHWxilAy0zb/iFyW5y2NhmOcfH/FsNHpldLPBid+Z
AYHELTTJjXDUaIqSVQEImCTzRjfplZddm3+X+4DWJRrO1Nvkt1s=
=+4iL
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
