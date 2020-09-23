Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6A0276008
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 20:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgIWSgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 14:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbgIWSge (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 14:36:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F08472193E;
        Wed, 23 Sep 2020 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600886192;
        bh=YRDsF434cR0ONrTH2PkWApAjVLS4HqMUaPPFSe5qrHY=;
        h=From:To:Cc:Subject:Date:From;
        b=jPDRVX7+FancmgNeX6BY6TnYQ1hRurqwywH06cKTkWRHupHAXJjEfiM6m7lezi3mq
         m6Vl30go2XDBs0196ppWWFLO/SIGnUs46CH0XEWYFndRESHRYCxmSZaPkAO4dhgvQo
         rpRD9o3a6KQ7j08wB5Rsqz9arSkF3MMDiJKA7By8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.199
Date:   Wed, 23 Sep 2020 20:36:38 +0200
Message-Id: <1600886199980@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.199 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/arc/boot/dts/hsdk.dts                       |    6 
 arch/arc/plat-eznps/include/plat/ctop.h          |    1 
 arch/arm/boot/dts/bcm5301x.dtsi                  |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi           |    2 
 arch/arm/boot/dts/vfxxx.dtsi                     |    2 
 arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi |    2 
 arch/mips/Kconfig                                |    1 
 arch/mips/kvm/mips.c                             |    2 
 arch/mips/sni/a20r.c                             |    9 
 arch/powerpc/configs/pasemi_defconfig            |    1 
 arch/powerpc/configs/ppc6xx_defconfig            |    1 
 arch/powerpc/kernel/dma-iommu.c                  |    3 
 arch/x86/configs/i386_defconfig                  |    2 
 arch/x86/configs/x86_64_defconfig                |    2 
 arch/x86/kvm/vmx.c                               |    1 
 drivers/atm/firestream.c                         |    1 
 drivers/block/rbd.c                              |   12 
 drivers/clk/rockchip/clk-rk3228.c                |    2 
 drivers/cpufreq/intel_pstate.c                   |   12 
 drivers/dma/acpi-dma.c                           |    4 
 drivers/gpu/drm/mediatek/mtk_drm_drv.c           |    7 
 drivers/gpu/drm/mediatek/mtk_hdmi.c              |   26 +
 drivers/hv/channel_mgmt.c                        |    7 
 drivers/i2c/algos/i2c-algo-pca.c                 |   35 +-
 drivers/i2c/busses/i2c-i801.c                    |   21 -
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
 drivers/infiniband/sw/rxe/rxe.c                  |    3 
 drivers/infiniband/sw/rxe/rxe_mr.c               |    1 
 drivers/infiniband/sw/rxe/rxe_verbs.c            |    2 
 drivers/input/mouse/trackpoint.c                 |   10 
 drivers/input/mouse/trackpoint.h                 |   10 
 drivers/input/serio/i8042-x86ia64io.h            |   16 +
 drivers/mmc/host/sdhci-msm.c                     |   18 +
 drivers/net/hyperv/netvsc_drv.c                  |    2 
 drivers/net/wan/hdlc_cisco.c                     |    1 
 drivers/net/wan/lapbether.c                      |    3 
 drivers/nfc/st95hf/core.c                        |    2 
 drivers/nvme/host/fc.c                           |    1 
 drivers/rapidio/Kconfig                          |    2 
 drivers/regulator/core.c                         |   46 +--
 drivers/scsi/libfc/fc_disc.c                     |    2 
 drivers/scsi/libsas/sas_ata.c                    |    5 
 drivers/scsi/lpfc/lpfc_els.c                     |    4 
 drivers/scsi/pm8001/pm8001_sas.c                 |    2 
 drivers/spi/spi-loopback-test.c                  |    2 
 drivers/spi/spi.c                                |    9 
 drivers/staging/greybus/audio_topology.c         |   29 +
 drivers/staging/wlan-ng/hfa384x_usb.c            |    5 
 drivers/staging/wlan-ng/prism2usb.c              |   19 -
 drivers/target/iscsi/iscsi_target.c              |   17 +
 drivers/target/iscsi/iscsi_target_login.c        |    6 
 drivers/target/iscsi/iscsi_target_login.h        |    3 
 drivers/target/iscsi/iscsi_target_nego.c         |    3 
 drivers/tty/serial/8250/8250_pci.c               |   11 
 drivers/usb/class/usblp.c                        |    5 
 drivers/usb/core/message.c                       |   91 ++----
 drivers/usb/core/quirks.c                        |    4 
 drivers/usb/core/sysfs.c                         |    5 
 drivers/usb/host/ehci-hcd.c                      |    1 
 drivers/usb/host/ehci-hub.c                      |    1 
 drivers/usb/serial/ftdi_sio.c                    |    1 
 drivers/usb/serial/ftdi_sio_ids.h                |    1 
 drivers/usb/serial/option.c                      |   22 -
 drivers/usb/storage/uas.c                        |   14 
 drivers/usb/typec/ucsi/ucsi_acpi.c               |    4 
 drivers/video/console/Kconfig                    |   46 ---
 drivers/video/console/vgacon.c                   |  220 ---------------
 drivers/video/fbdev/core/bitblit.c               |   11 
 drivers/video/fbdev/core/fbcon.c                 |  336 -----------------------
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
 fs/f2fs/node.c                                   |    3 
 fs/gfs2/glops.c                                  |    2 
 fs/gfs2/log.c                                    |    2 
 fs/gfs2/trans.c                                  |    2 
 fs/nfs/nfs4proc.c                                |    7 
 fs/xfs/libxfs/xfs_attr_leaf.c                    |    4 
 include/linux/i2c-algo-pca.h                     |   15 +
 include/soc/nps/common.h                         |    6 
 include/uapi/linux/kvm.h                         |    5 
 kernel/gcov/gcc_4_7.c                            |    4 
 mm/percpu.c                                      |    2 
 net/core/skbuff.c                                |   10 
 net/sunrpc/rpcb_clnt.c                           |    4 
 sound/hda/hdac_device.c                          |    2 
 sound/pci/hda/patch_hdmi.c                       |    5 
 tools/perf/tests/pmu.c                           |    1 
 tools/perf/util/pmu.c                            |   11 
 tools/perf/util/pmu.h                            |    1 
 112 files changed, 597 insertions(+), 918 deletions(-)

Adam Borowski (1):
      x86/defconfig: Enable CONFIG_USB_XHCI_HCD=y

Aleksander Morgado (1):
      USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules

Alexey Kardashevskiy (1):
      powerpc/dma: Fix dma_map_ops::get_required_mask

Angelo Compagnucci (2):
      iio: adc: mcp3422: fix locking scope
      iio: adc: mcp3422: fix locking on error path

Bjørn Mork (1):
      USB: serial: option: support dynamic Quectel USB compositions

Bob Peterson (1):
      gfs2: initialize transaction tr_ailX_lists earlier

Chris Healy (1):
      ARM: dts: vfxxx: Add syscon compatible with OCOTP

Darrick J. Wong (1):
      xfs: initialize the shortform attr header padding entry

David Milburn (1):
      nvme-fc: cancel async events before freeing event struct

Dinghao Liu (4):
      RDMA/rxe: Fix memleak in rxe_mem_init_user
      NFC: st95hf: Fix memleak in st95hf_in_send_cmd
      firestream: Fix memleak in fs_open
      scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort

Dinh Nguyen (1):
      ARM: dts: socfpga: fix register entry for timer3 on Arria10

Douglas Anderson (1):
      mmc: sdhci-msm: Add retries when all tuning phases are found valid

Evan Nimmo (1):
      i2c: algo: pca: Reapply i2c bus settings after reset

Evgeniy Didin (1):
      ARC: [plat-hsdk]: Switch ethernet phy-mode to rgmii-id

Filipe Manana (1):
      btrfs: fix wrong address when faulting in pages in the search ioctl

Florian Fainelli (2):
      ARM: dts: BCM5301X: Fixed QSPI compatible string
      arm64: dts: ns2: Fixed QSPI compatible string

Greg Kroah-Hartman (1):
      Linux 4.14.199

Gustav Wiklander (1):
      spi: Fix memory leak on splited transfers

Haiyang Zhang (1):
      hv_netvsc: Remove "unlikely" from netvsc_select_queue

Hanjun Guo (1):
      dmaengine: acpi: Put the CSRT table after using it

Hans de Goede (1):
      Input: i8042 - add Entroware Proteus EL07R4 to nomux and reset lists

Heikki Krogerus (1):
      usb: typec: ucsi: acpi: Check the _DEP dependencies

Hou Pu (1):
      scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

Huacai Chen (1):
      KVM: MIPS: Change the definition of kvm type

Ilya Dryomov (1):
      rbd: require global CAP_SYS_ADMIN for mapping and unmapping

J. Bruce Fields (1):
      SUNRPC: stop printk reading past end of string

James Smart (1):
      scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery

Javed Hasan (1):
      scsi: libfc: Fix for double free()

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

Josef Bacik (1):
      btrfs: fix lockdep splat in add_missing_dev

Kamal Heib (2):
      RDMA/rxe: Drop pointless checks in rxe_init_ports
      RDMA/core: Fix reported speed and width

Laurent Pinchart (1):
      rapidio: Replace 'select' DMAENGINES 'with depends on'

Leon Romanovsky (1):
      gcov: Disable gcov build with GCC 10

Linus Torvalds (3):
      fbcon: remove soft scrollback code
      fbcon: remove now unusued 'softback_lines' cursor() argument
      vgacon: remove software scrollback support

Luo Jiaxing (1):
      scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA

Mathias Nyman (1):
      usb: Fix out of sync data toggle if a configured device is reconfigured

Maxim Kochetkov (1):
      iio: adc: ti-ads1015: fix conversion when CONFIG_PM is not set

Miaohe Lin (1):
      net: handle the return value of pskb_carve_frag_list() correctly

Michael Kelley (1):
      Drivers: hv: vmbus: Add timeout to vmbus_wait_for_unload

Michał Mirosław (1):
      regulator: push allocation in set_consumer_device_supply() out of lock

Mohan Kumar (1):
      ALSA: hda: Fix 2 channel swapping for Tegra

Namhyung Kim (1):
      perf test: Free formats for perf pmu parse test

Nathan Chancellor (1):
      clk: rockchip: Fix initialization of mux_pll_src_4plls_p

Olga Kornievskaia (1):
      NFSv4.1 handle ERR_DELAY error reclaiming locking state on delegation recall

Oliver Neukum (2):
      USB: UAS: fix disconnect by unplugging a hub
      usblp: fix race between disconnect() and read()

Patrick Riphagen (1):
      USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter

Penghao (1):
      USB: quirks: Add USB_QUIRK_IGNORE_REMOTE_WAKEUP quirk for BYD zhaoxin notebook

Peter Oberparleiter (1):
      gcov: add support for GCC 10.1

Qu Wenruo (1):
      btrfs: require only sector size alignment for parent eb bytenr

Quentin Perret (1):
      ehci-hcd: Move include to keep CRC stable

Rafael J. Wysocki (1):
      cpufreq: intel_pstate: Refuse to turn off with HWP enabled

Rander Wang (1):
      ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled

Rustam Kovhaev (1):
      staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()

Sahitya Tummala (1):
      f2fs: fix indefinite loop scanning for free nid

Sunghyun Jin (1):
      percpu: fix first chunk size calculation for populated bitmap

Tetsuo Handa (2):
      video: fbdev: fix OOB read in vga_8planes_imageblit()
      fbcon: Fix user font detection test at fbcon_resize().

Thomas Bogendoerfer (2):
      MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT
      MIPS: SNI: Fix spurious interrupts

Tobias Diedrich (1):
      serial: 8250_pci: Add Realtek 816a and 816b

Vaibhav Agarwal (1):
      staging: greybus: audio: fix uninitialized value issue

Varun Prakash (1):
      scsi: target: iscsi: Fix data digest calculation

Vincent Huang (1):
      Input: trackpoint - add new trackpoint variant IDs

Vincent Whitchurch (1):
      spi: spi-loopback-test: Fix out-of-bounds read

Vineet Gupta (2):
      ARC: HSDK: wireup perf irq
      irqchip/eznps: Fix build error for !ARC700 builds

Volker Rümelin (1):
      i2c: i801: Fix resume bug

Wanpeng Li (1):
      KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit

Xie He (3):
      drivers/net/wan/lapbether: Added needed_tailroom
      drivers/net/wan/lapbether: Set network_header before transmitting
      drivers/net/wan/hdlc_cisco: Add hard_header_len

Yi Zhang (1):
      RDMA/rxe: Fix the parent sysfs read when the interface has 15 chars

Yu Kuai (2):
      drm/mediatek: Add exception handing in mtk_drm_probe() if component init fail
      drm/mediatek: Add missing put_device() call in mtk_hdmi_dt_parse_pdata()

Zeng Tao (1):
      usb: core: fix slab-out-of-bounds Read in read_descriptors

