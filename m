Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6381026DEC6
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbgIQOw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbgIQOtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:49:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B39FD2072E;
        Thu, 17 Sep 2020 14:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353932;
        bh=DNxmVxa46L8HNfrpQmZbEuLPoBvvHucUm5htpv+GqP8=;
        h=From:To:Cc:Subject:Date:From;
        b=QiX/zu3moVfwQRQ6zfGJBlgjH8oQ2+6+Kkbcuy+l7kK0aYr+HTzeCaA/IvyyYakL7
         TgirUnyWVU7bEK01qflL/5fbyTk75MWtykOTXln1NrawGpIfLe5NdX7E29VAn0T0CN
         wgOGmJ5/H7XGW8YvqGxdMaCk0te8PMTh1KzBpXVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.66
Date:   Thu, 17 Sep 2020 16:45:53 +0200
Message-Id: <160035395369154@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.66 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 arch/arc/boot/dts/hsdk.dts                                |    6 
 arch/arc/plat-eznps/include/plat/ctop.h                   |    1 
 arch/arm/boot/dts/bcm-hr2.dtsi                            |    2 
 arch/arm/boot/dts/bcm-nsp.dtsi                            |    2 
 arch/arm/boot/dts/bcm5301x.dtsi                           |    2 
 arch/arm/boot/dts/imx7ulp.dtsi                            |    8 
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi           |   29 -
 arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi          |    2 
 arch/arm/boot/dts/ls1021a.dtsi                            |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi                    |    2 
 arch/arm/boot/dts/vfxxx.dtsi                              |    2 
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi          |    2 
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                 |    2 
 arch/arm64/kernel/module-plts.c                           |    3 
 arch/powerpc/configs/pasemi_defconfig                     |    1 
 arch/powerpc/configs/ppc6xx_defconfig                     |    1 
 arch/x86/configs/i386_defconfig                           |    1 
 arch/x86/configs/x86_64_defconfig                         |    1 
 arch/x86/kvm/vmx/vmx.c                                    |    1 
 block/bio.c                                               |    4 
 drivers/atm/firestream.c                                  |    1 
 drivers/block/rbd.c                                       |   12 
 drivers/cpufreq/intel_pstate.c                            |   14 
 drivers/dma/acpi-dma.c                                    |    4 
 drivers/dma/dma-jz4780.c                                  |   38 -
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c          |    3 
 drivers/gpu/drm/i915/gvt/cmd_parser.c                     |   12 
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c                     |    5 
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c                     |   10 
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c                     |   10 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                     |   14 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                     |    7 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c                   |   27 -
 drivers/gpu/drm/msm/msm_ringbuffer.c                      |    3 
 drivers/gpu/drm/sun4i/sun4i_backend.c                     |    4 
 drivers/gpu/drm/sun4i/sun4i_tcon.c                        |    8 
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                    |    4 
 drivers/gpu/drm/tve200/tve200_display.c                   |   22 
 drivers/hid/hid-elan.c                                    |    2 
 drivers/hid/hid-ids.h                                     |    3 
 drivers/hid/hid-microsoft.c                               |    2 
 drivers/hid/hid-quirks.c                                  |    2 
 drivers/iio/accel/bmc150-accel-core.c                     |   15 
 drivers/iio/accel/kxsd9.c                                 |   16 
 drivers/iio/accel/mma7455_core.c                          |   16 
 drivers/iio/accel/mma8452.c                               |   11 
 drivers/iio/adc/ina2xx-adc.c                              |   11 
 drivers/iio/adc/max1118.c                                 |   10 
 drivers/iio/adc/mcp3422.c                                 |   16 
 drivers/iio/adc/ti-adc081c.c                              |   11 
 drivers/iio/adc/ti-adc084s021.c                           |   10 
 drivers/iio/adc/ti-ads1015.c                              |   10 
 drivers/iio/chemical/ccs811.c                             |   13 
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c |    5 
 drivers/iio/light/ltr501.c                                |   15 
 drivers/iio/light/max44000.c                              |   12 
 drivers/iio/magnetometer/ak8975.c                         |   16 
 drivers/iio/proximity/mb1232.c                            |   17 
 drivers/infiniband/core/verbs.c                           |    2 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c                  |   21 
 drivers/infiniband/hw/mlx4/main.c                         |    3 
 drivers/infiniband/sw/rxe/rxe.c                           |    7 
 drivers/infiniband/sw/rxe/rxe.h                           |    2 
 drivers/infiniband/sw/rxe/rxe_mr.c                        |    1 
 drivers/infiniband/sw/rxe/rxe_sysfs.c                     |    5 
 drivers/infiniband/sw/rxe/rxe_verbs.c                     |    2 
 drivers/infiniband/ulp/isert/ib_isert.c                   |   93 +--
 drivers/infiniband/ulp/isert/ib_isert.h                   |   41 +
 drivers/iommu/amd_iommu_v2.c                              |    7 
 drivers/mmc/core/sdio_ops.c                               |   39 -
 drivers/mmc/host/sdhci-acpi.c                             |   31 +
 drivers/mmc/host/sdhci-msm.c                              |   18 
 drivers/mmc/host/sdhci-of-esdhc.c                         |   10 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c           |    6 
 drivers/net/wan/hdlc_cisco.c                              |    1 
 drivers/net/wan/lapbether.c                               |    3 
 drivers/nfc/st95hf/core.c                                 |    2 
 drivers/nvme/host/core.c                                  |    3 
 drivers/nvme/host/fabrics.c                               |   13 
 drivers/nvme/host/nvme.h                                  |    2 
 drivers/nvme/host/pci.c                                   |    4 
 drivers/nvme/host/rdma.c                                  |   68 ++
 drivers/nvme/host/tcp.c                                   |   80 ++-
 drivers/nvme/target/tcp.c                                 |   10 
 drivers/phy/qualcomm/phy-qcom-qmp.c                       |   16 
 drivers/phy/qualcomm/phy-qcom-qmp.h                       |    2 
 drivers/regulator/core.c                                  |  155 +++---
 drivers/scsi/libsas/sas_ata.c                             |    5 
 drivers/scsi/megaraid/megaraid_sas_fusion.c               |    2 
 drivers/scsi/mpt3sas/mpt3sas_base.c                       |    2 
 drivers/soundwire/stream.c                                |    8 
 drivers/spi/spi-stm32.c                                   |    8 
 drivers/staging/greybus/audio_topology.c                  |   29 -
 drivers/staging/wlan-ng/hfa384x_usb.c                     |    5 
 drivers/staging/wlan-ng/prism2usb.c                       |   19 
 drivers/target/iscsi/iscsi_target.c                       |   17 
 drivers/target/iscsi/iscsi_target_login.c                 |    6 
 drivers/target/iscsi/iscsi_target_login.h                 |    3 
 drivers/target/iscsi/iscsi_target_nego.c                  |    3 
 drivers/usb/core/message.c                                |   91 +--
 drivers/usb/core/sysfs.c                                  |    5 
 drivers/usb/serial/ftdi_sio.c                             |    1 
 drivers/usb/serial/ftdi_sio_ids.h                         |    1 
 drivers/usb/serial/option.c                               |   22 
 drivers/usb/typec/ucsi/ucsi_acpi.c                        |    4 
 drivers/video/console/Kconfig                             |   46 -
 drivers/video/console/vgacon.c                            |  221 ---------
 drivers/video/fbdev/core/bitblit.c                        |   11 
 drivers/video/fbdev/core/fbcon.c                          |  334 --------------
 drivers/video/fbdev/core/fbcon.h                          |    2 
 drivers/video/fbdev/core/fbcon_ccw.c                      |   11 
 drivers/video/fbdev/core/fbcon_cw.c                       |   11 
 drivers/video/fbdev/core/fbcon_ud.c                       |   11 
 drivers/video/fbdev/core/tileblit.c                       |    2 
 drivers/video/fbdev/vga16fb.c                             |    2 
 fs/btrfs/extent-tree.c                                    |   19 
 fs/btrfs/ioctl.c                                          |    3 
 fs/btrfs/print-tree.c                                     |   12 
 fs/btrfs/volumes.c                                        |   10 
 fs/debugfs/file.c                                         |    4 
 fs/xfs/libxfs/xfs_attr_leaf.c                             |    4 
 fs/xfs/libxfs/xfs_ialloc.c                                |    4 
 fs/xfs/libxfs/xfs_trans_space.h                           |    2 
 include/linux/netfilter/nf_conntrack_sctp.h               |    2 
 include/soc/nps/common.h                                  |    6 
 kernel/gcov/gcc_4_7.c                                     |    4 
 lib/kobject.c                                             |    6 
 net/netfilter/nf_conntrack_proto_sctp.c                   |   39 +
 net/wireless/util.c                                       |    8 
 sound/hda/hdac_device.c                                   |    2 
 sound/pci/hda/hda_tegra.c                                 |    7 
 sound/pci/hda/patch_hdmi.c                                |    6 
 tools/testing/selftests/timers/Makefile                   |    1 
 tools/testing/selftests/timers/settings                   |    1 
 virt/kvm/arm/mmu.c                                        |    7 
 virt/kvm/kvm_main.c                                       |   21 
 137 files changed, 992 insertions(+), 1192 deletions(-)

Adam Ford (3):
      ARM: dts: logicpd-torpedo-baseboard: Fix broken audio
      ARM: dts: logicpd-som-lv-baseboard: Fix broken audio
      ARM: dts: logicpd-som-lv-baseboard: Fix missing video

Adrian Hunter (1):
      mmc: sdio: Use mmc_pre_req() / mmc_post_req()

Aleksander Morgado (1):
      USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules

Amar Singhal (1):
      cfg80211: Adjust 6 GHz frequency to channel conversion

Andy Shevchenko (1):
      kobject: Restore old behaviour of kobject_del(NULL)

Angelo Compagnucci (2):
      iio: adc: mcp3422: fix locking on error path
      iio: adc: mcp3422: fix locking scope

Anson Huang (1):
      ARM: dts: imx7ulp: Correct gpio ranges

Bjørn Mork (1):
      USB: serial: option: support dynamic Quectel USB compositions

Brian Foster (1):
      xfs: fix off-by-one in inode alloc block reservation calculation

Chris Healy (1):
      ARM: dts: vfxxx: Add syscon compatible with OCOTP

Chris Packham (1):
      mmc: sdhci-of-esdhc: Don't walk device-tree on every interrupt

Dan Carpenter (1):
      spi: stm32: fix pm_runtime_get_sync() error checking

Darrick J. Wong (1):
      xfs: initialize the shortform attr header padding entry

Dinghao Liu (4):
      RDMA/rxe: Fix memleak in rxe_mem_init_user
      NFC: st95hf: Fix memleak in st95hf_in_send_cmd
      firestream: Fix memleak in fs_open
      HID: elan: Fix memleak in elan_input_configured

Dinh Nguyen (1):
      ARM: dts: socfpga: fix register entry for timer3 on Arria10

Dmitry Osipenko (1):
      regulator: core: Fix slab-out-of-bounds in regulator_unlock_recursive()

Douglas Anderson (1):
      mmc: sdhci-msm: Add retries when all tuning phases are found valid

Evgeniy Didin (1):
      ARC: [plat-hsdk]: Switch ethernet phy-mode to rgmii-id

Filipe Manana (1):
      btrfs: fix wrong address when faulting in pages in the search ioctl

Florian Fainelli (4):
      ARM: dts: bcm: HR2: Fixed QSPI compatible string
      ARM: dts: NSP: Fixed QSPI compatible string
      ARM: dts: BCM5301X: Fixed QSPI compatible string
      arm64: dts: ns2: Fixed QSPI compatible string

Florian Westphal (1):
      netfilter: conntrack: allow sctp hearbeat after connection re-use

Francisco Jerez (1):
      cpufreq: intel_pstate: Fix intel_pstate_get_hwp_max() for turbo disabled

Greg Kroah-Hartman (1):
      Linux 5.4.66

Gwendal Grignou (1):
      iio: cros_ec: Set Gyroscope default frequency to 25Hz

Hanjun Guo (1):
      dmaengine: acpi: Put the CSRT table after using it

Heikki Krogerus (1):
      usb: typec: ucsi: acpi: Check the _DEP dependencies

Hou Pu (1):
      scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

Ilya Dryomov (1):
      rbd: require global CAP_SYS_ADMIN for mapping and unmapping

Jessica Yu (1):
      arm64/module: set trampoline section flags regardless of CONFIG_DYNAMIC_FTRACE

Joerg Roedel (1):
      iommu/amd: Do not use IOMMUv2 functionality when SME is active

Jonathan Cameron (13):
      iio:light:ltr501 Fix timestamp alignment issue.
      iio:proximity:mb1232: Fix timestamp alignment and prevent data leak.
      iio:accel:bmc150-accel: Fix timestamp alignment and prevent data leak.
      iio:adc:ti-adc084s021 Fix alignment and data leak issues.
      iio:adc:ina2xx Fix timestamp alignment issue.
      iio:adc:max1118 Fix alignment of timestamp and data leak issues
      iio:adc:ti-adc081c Fix alignment and data leak issues
      iio:magnetometer:ak8975 Fix alignment and data leak issues.
      iio:light:max44000 Fix timestamp alignment and prevent data leak.
      iio:chemical:ccs811: Fix timestamp alignment and prevent data leak.
      iio: accel: kxsd9: Fix alignment of local buffer.
      iio:accel:mma7455: Fix timestamp alignment and prevent data leak.
      iio:accel:mma8452: Fix timestamp alignment and prevent data leak.

Jordan Crouse (2):
      drm/msm: Disable preemption on all 5xx targets
      drm/msm: Disable the RPTR shadow

Josef Bacik (1):
      btrfs: fix lockdep splat in add_missing_dev

Kamal Heib (3):
      RDMA/rxe: Drop pointless checks in rxe_init_ports
      RDMA/rxe: Fix panic when calling kmem_cache_create()
      RDMA/core: Fix reported speed and width

Krzysztof Kozlowski (1):
      arm64: dts: imx8mq: Fix TMU interrupt property

Leon Romanovsky (1):
      gcov: Disable gcov build with GCC 10

Linus Torvalds (3):
      fbcon: remove soft scrollback code
      fbcon: remove now unusued 'softback_lines' cursor() argument
      vgacon: remove software scrollback support

Linus Walleij (1):
      drm/tve200: Stabilize enable/disable

Luo Jiaxing (1):
      scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA

Madhuparna Bhowmik (1):
      drivers/dma/dma-jz4780: Fix race condition between probe and irq handler

Marc Zyngier (1):
      KVM: arm64: Do not try to map PUDs when they are folded into PMD

Marek Vasut (1):
      spi: stm32: Rate-limit the 'Communication suspended' message

Mark Bloch (1):
      RDMA/mlx4: Read pkey table length instead of hardcoded value

Mathias Nyman (1):
      usb: Fix out of sync data toggle if a configured device is reconfigured

Matthias Schiffer (1):
      ARM: dts: ls1021a: fix QuadSPI-memory reg range

Maxim Kochetkov (1):
      iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set

Maxime Ripard (2):
      drm/sun4i: backend: Support alpha property on lowest plane
      drm/sun4i: backend: Disable alpha on the lowest plane on the A20

Michał Mirosław (6):
      regulator: push allocation in regulator_ena_gpio_request() out of lock
      regulator: remove superfluous lock in regulator_resolve_coupling()
      regulator: push allocation in regulator_init_coupling() outside of lock
      regulator: push allocations in create_regulator() outside of lock
      regulator: push allocation in set_consumer_device_supply() out of lock
      regulator: plug of_node leak in regulator_register()'s error path

Mohan Kumar (2):
      ALSA: hda: Fix 2 channel swapping for Tegra
      ALSA: hda/tegra: Program WAKEEN register for Tegra

Nicholas Miell (1):
      HID: microsoft: Add rumble support for the 8bitdo SN30 Pro+ controller

Nirenjan Krishnan (1):
      HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for all Saitek X52 devices

Ondrej Jirman (1):
      drm/sun4i: Fix dsi dcs long write function

Patrick Riphagen (1):
      USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter

Peter Oberparleiter (1):
      gcov: add support for GCC 10.1

Po-Hsu Lin (1):
      selftests/timers: Turn off timeout setting

Qu Wenruo (1):
      btrfs: require only sector size alignment for parent eb bytenr

Rafael J. Wysocki (1):
      cpufreq: intel_pstate: Refuse to turn off with HWP enabled

Rander Wang (2):
      ALSA: hda: hdmi - add Rocketlake support
      ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled

Raul E Rangel (1):
      mmc: sdhci-acpi: Clear amd_sdhci_host on reset

Ritesh Harjani (1):
      block: Set same_page to false in __bio_try_merge_page if ret is false

Rob Clark (1):
      drm/msm/gpu: make ringbuffer readonly

Rustam Kovhaev (2):
      staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()
      KVM: fix memory leak in kvm_io_bus_unregister_dev()

Sagi Grimberg (10):
      nvme-fabrics: allow to queue requests for live queues
      IB/isert: Fix unaligned immediate-data handling
      nvme-fabrics: don't check state NVME_CTRL_NEW for request acceptance
      nvme: have nvme_wait_freeze_timeout return if it timed out
      nvme-tcp: serialize controller teardown sequences
      nvme-tcp: fix timeout handler
      nvme-tcp: fix reset hang if controller died in the middle of a reset
      nvme-rdma: serialize controller teardown sequences
      nvme-rdma: fix timeout handler
      nvme-rdma: fix reset hang if controller died in the middle of a reset

Sandeep Raghuraman (1):
      drm/amdgpu: Fix bug in reporting voltage for CIK

Selvin Xavier (1):
      RDMA/bnxt_re: Do not report transparent vlan from QP1

Sivaprakash Murugesan (1):
      phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init

Tetsuo Handa (1):
      video: fbdev: fix OOB read in vga_8planes_imageblit()

Tom Rix (1):
      soundwire: fix double free of dangling pointer

Tomas Henzl (2):
      scsi: megaraid_sas: Don't call disable_irq from process IRQ poll
      scsi: mpt3sas: Don't call disable_irq from IRQ poll handler

Tong Zhang (1):
      nvme-pci: cancel nvme device request before disabling

Vaibhav Agarwal (1):
      staging: greybus: audio: fix uninitialized value issue

Varun Prakash (1):
      scsi: target: iscsi: Fix data digest calculation

Vineet Gupta (2):
      ARC: HSDK: wireup perf irq
      irqchip/eznps: Fix build error for !ARC700 builds

Vladis Dronov (1):
      debugfs: Fix module state check condition

Wanpeng Li (1):
      KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit

Xie He (3):
      drivers/net/wan/lapbether: Added needed_tailroom
      drivers/net/wan/lapbether: Set network_header before transmitting
      drivers/net/wan/hdlc_cisco: Add hard_header_len

Yan Zhao (1):
      drm/i915/gvt: do not check len & max_len for lri

Yi Li (1):
      net: hns3: Fix for geneve tx checksum bug

Yi Zhang (1):
      RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars

Yu Kuai (1):
      drm/sun4i: add missing put_device() call in sun8i_r40_tcon_tv_set_mux()

Zeng Tao (1):
      usb: core: fix slab-out-of-bounds Read in read_descriptors

Ziye Yang (1):
      nvmet-tcp: Fix NULL dereference when a connect data comes in h2cdata pdu

