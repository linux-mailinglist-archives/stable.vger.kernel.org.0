Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C1526DEB0
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgIQOtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727775AbgIQOtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:49:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6474F22208;
        Thu, 17 Sep 2020 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353934;
        bh=sm4VW3CObHbU8qAi1m+Q5w8ZeItSEyrIHENETdNVau4=;
        h=From:To:Cc:Subject:Date:From;
        b=vOf8LFPJt2fBnSzja3T5dScXSg9u8nJ3BgCa24OYL+NlphoKB4BIVBTQEiscC55Rm
         tOnA0+mpYHzBIzZtVHw0u9+dZwbQEACeUeTjOG+DB/eUpdd1udPRKTc1qv0HqCD+Fg
         EbWnquVM71xqxMVSdMkxc5kFi0bdvlWwim6AET8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.146
Date:   Thu, 17 Sep 2020 16:45:59 +0200
Message-Id: <1600353959116126@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.146 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/arc/boot/dts/hsdk.dts                       |    6 
 arch/arc/plat-eznps/include/plat/ctop.h          |    1 
 arch/arm/boot/dts/bcm-hr2.dtsi                   |    2 
 arch/arm/boot/dts/bcm-nsp.dtsi                   |    2 
 arch/arm/boot/dts/bcm5301x.dtsi                  |    2 
 arch/arm/boot/dts/logicpd-som-lv-baseboard.dtsi  |    2 
 arch/arm/boot/dts/logicpd-torpedo-baseboard.dtsi |    2 
 arch/arm/boot/dts/ls1021a.dtsi                   |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi           |    2 
 arch/arm/boot/dts/vfxxx.dtsi                     |    2 
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi |    2 
 arch/powerpc/configs/pasemi_defconfig            |    1 
 arch/powerpc/configs/ppc6xx_defconfig            |    1 
 arch/x86/configs/i386_defconfig                  |    1 
 arch/x86/configs/x86_64_defconfig                |    1 
 arch/x86/kvm/vmx.c                               |    1 
 drivers/atm/firestream.c                         |    1 
 drivers/block/rbd.c                              |   12 
 drivers/cpufreq/intel_pstate.c                   |   14 
 drivers/dma/acpi-dma.c                           |    4 
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c |    3 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c            |    3 
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c           |    4 
 drivers/gpu/drm/tve200/tve200_display.c          |   22 +
 drivers/hid/hid-elan.c                           |    2 
 drivers/hid/hid-ids.h                            |    2 
 drivers/hid/hid-quirks.c                         |    2 
 drivers/iio/accel/bmc150-accel-core.c            |   15 -
 drivers/iio/accel/kxsd9.c                        |   16 -
 drivers/iio/accel/mma7455_core.c                 |   16 -
 drivers/iio/accel/mma8452.c                      |   11 
 drivers/iio/adc/ina2xx-adc.c                     |   11 
 drivers/iio/adc/max1118.c                        |   10 
 drivers/iio/adc/mcp3422.c                        |   16 -
 drivers/iio/adc/ti-adc081c.c                     |   11 
 drivers/iio/adc/ti-adc084s021.c                  |   10 
 drivers/iio/adc/ti-ads1015.c                     |   10 
 drivers/iio/chemical/ccs811.c                    |   13 
 drivers/iio/light/ltr501.c                       |   15 -
 drivers/iio/light/max44000.c                     |   12 
 drivers/iio/magnetometer/ak8975.c                |   16 -
 drivers/infiniband/core/verbs.c                  |    2 
 drivers/infiniband/hw/bnxt_re/ib_verbs.c         |   21 +
 drivers/infiniband/sw/rxe/rxe.c                  |    3 
 drivers/infiniband/sw/rxe/rxe_mr.c               |    1 
 drivers/infiniband/sw/rxe/rxe_verbs.c            |    2 
 drivers/iommu/amd_iommu_v2.c                     |    7 
 drivers/mmc/host/sdhci-msm.c                     |   18 +
 drivers/net/wan/hdlc_cisco.c                     |    1 
 drivers/net/wan/lapbether.c                      |    3 
 drivers/nfc/st95hf/core.c                        |    2 
 drivers/nvme/host/fabrics.c                      |    1 
 drivers/nvme/host/rdma.c                         |    6 
 drivers/phy/qualcomm/phy-qcom-qmp.c              |   16 -
 drivers/phy/qualcomm/phy-qcom-qmp.h              |    2 
 drivers/regulator/core.c                         |   46 +--
 drivers/scsi/libsas/sas_ata.c                    |    5 
 drivers/staging/greybus/audio_topology.c         |   29 +
 drivers/staging/wlan-ng/hfa384x_usb.c            |    5 
 drivers/staging/wlan-ng/prism2usb.c              |   19 -
 drivers/target/iscsi/iscsi_target.c              |   17 +
 drivers/target/iscsi/iscsi_target_login.c        |    6 
 drivers/target/iscsi/iscsi_target_login.h        |    3 
 drivers/target/iscsi/iscsi_target_nego.c         |    3 
 drivers/usb/core/message.c                       |   91 ++----
 drivers/usb/core/sysfs.c                         |    5 
 drivers/usb/serial/ftdi_sio.c                    |    1 
 drivers/usb/serial/ftdi_sio_ids.h                |    1 
 drivers/usb/serial/option.c                      |   22 -
 drivers/usb/typec/ucsi/ucsi_acpi.c               |    4 
 drivers/video/console/Kconfig                    |   46 ---
 drivers/video/console/vgacon.c                   |  221 ---------------
 drivers/video/fbdev/core/bitblit.c               |   11 
 drivers/video/fbdev/core/fbcon.c                 |  334 -----------------------
 drivers/video/fbdev/core/fbcon.h                 |    2 
 drivers/video/fbdev/core/fbcon_ccw.c             |   11 
 drivers/video/fbdev/core/fbcon_cw.c              |   11 
 drivers/video/fbdev/core/fbcon_ud.c              |   11 
 drivers/video/fbdev/core/tileblit.c              |    2 
 drivers/video/fbdev/vga16fb.c                    |    2 
 fs/btrfs/extent-tree.c                           |   19 -
 fs/btrfs/ioctl.c                                 |    3 
 fs/btrfs/print-tree.c                            |   12 
 fs/btrfs/volumes.c                               |   10 
 fs/xfs/libxfs/xfs_attr_leaf.c                    |    4 
 include/linux/netfilter/nf_conntrack_sctp.h      |    2 
 include/soc/nps/common.h                         |    6 
 kernel/gcov/gcc_4_7.c                            |    4 
 net/netfilter/nf_conntrack_proto_sctp.c          |   39 ++
 sound/hda/hdac_device.c                          |    2 
 sound/pci/hda/patch_hdmi.c                       |    5 
 92 files changed, 505 insertions(+), 877 deletions(-)

Adam Ford (2):
      ARM: dts: logicpd-torpedo-baseboard: Fix broken audio
      ARM: dts: logicpd-som-lv-baseboard: Fix broken audio

Aleksander Morgado (1):
      USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules

Angelo Compagnucci (2):
      iio: adc: mcp3422: fix locking scope
      iio: adc: mcp3422: fix locking on error path

Bjørn Mork (1):
      USB: serial: option: support dynamic Quectel USB compositions

Chris Healy (1):
      ARM: dts: vfxxx: Add syscon compatible with OCOTP

Darrick J. Wong (1):
      xfs: initialize the shortform attr header padding entry

Dinghao Liu (4):
      RDMA/rxe: Fix memleak in rxe_mem_init_user
      NFC: st95hf: Fix memleak in st95hf_in_send_cmd
      firestream: Fix memleak in fs_open
      HID: elan: Fix memleak in elan_input_configured

Dinh Nguyen (1):
      ARM: dts: socfpga: fix register entry for timer3 on Arria10

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
      Linux 4.19.146

Hanjun Guo (1):
      dmaengine: acpi: Put the CSRT table after using it

Heikki Krogerus (1):
      usb: typec: ucsi: acpi: Check the _DEP dependencies

Hou Pu (1):
      scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

Ilya Dryomov (1):
      rbd: require global CAP_SYS_ADMIN for mapping and unmapping

Joerg Roedel (1):
      iommu/amd: Do not use IOMMUv2 functionality when SME is active

Jonathan Cameron (12):
      iio:light:ltr501 Fix timestamp alignment issue.
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

Jordan Crouse (1):
      drm/msm: Disable preemption on all 5xx targets

Josef Bacik (1):
      btrfs: fix lockdep splat in add_missing_dev

Kamal Heib (2):
      RDMA/rxe: Drop pointless checks in rxe_init_ports
      RDMA/core: Fix reported speed and width

Leon Romanovsky (1):
      gcov: Disable gcov build with GCC 10

Linus Torvalds (3):
      vgacon: remove software scrollback support
      fbcon: remove soft scrollback code
      fbcon: remove now unusued 'softback_lines' cursor() argument

Linus Walleij (1):
      drm/tve200: Stabilize enable/disable

Luo Jiaxing (1):
      scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA

Mathias Nyman (1):
      usb: Fix out of sync data toggle if a configured device is reconfigured

Matthias Schiffer (1):
      ARM: dts: ls1021a: fix QuadSPI-memory reg range

Maxim Kochetkov (1):
      iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set

Michał Mirosław (1):
      regulator: push allocation in set_consumer_device_supply() out of lock

Mohan Kumar (1):
      ALSA: hda: Fix 2 channel swapping for Tegra

Nirenjan Krishnan (1):
      HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for all Saitek X52 devices

Ondrej Jirman (1):
      drm/sun4i: Fix dsi dcs long write function

Patrick Riphagen (1):
      USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter

Peter Oberparleiter (1):
      gcov: add support for GCC 10.1

Qu Wenruo (1):
      btrfs: require only sector size alignment for parent eb bytenr

Rafael J. Wysocki (1):
      cpufreq: intel_pstate: Refuse to turn off with HWP enabled

Rander Wang (1):
      ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled

Rustam Kovhaev (1):
      staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()

Sagi Grimberg (2):
      nvme-fabrics: don't check state NVME_CTRL_NEW for request acceptance
      nvme-rdma: serialize controller teardown sequences

Sandeep Raghuraman (1):
      drm/amdgpu: Fix bug in reporting voltage for CIK

Selvin Xavier (1):
      RDMA/bnxt_re: Do not report transparent vlan from QP1

Sivaprakash Murugesan (1):
      phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init

Tetsuo Handa (1):
      video: fbdev: fix OOB read in vga_8planes_imageblit()

Vaibhav Agarwal (1):
      staging: greybus: audio: fix uninitialized value issue

Varun Prakash (1):
      scsi: target: iscsi: Fix data digest calculation

Vineet Gupta (2):
      ARC: HSDK: wireup perf irq
      irqchip/eznps: Fix build error for !ARC700 builds

Wanpeng Li (1):
      KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit

Xie He (3):
      drivers/net/wan/lapbether: Added needed_tailroom
      drivers/net/wan/lapbether: Set network_header before transmitting
      drivers/net/wan/hdlc_cisco: Add hard_header_len

Yi Zhang (1):
      RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars

Zeng Tao (1):
      usb: core: fix slab-out-of-bounds Read in read_descriptors

