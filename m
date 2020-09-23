Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BC4275FFE
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 20:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIWSgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 14:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIWSgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 14:36:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBBCE206B2;
        Wed, 23 Sep 2020 18:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600886167;
        bh=verFunekuAhpXhVJ023wFlfLseCVWjb5x9EOcXzMmkI=;
        h=From:To:Cc:Subject:Date:From;
        b=urX2CPYRkiVlIkzBs6vCMZK9COiwJVoegewdsJuh9zSWnU9qd8LMgBXGPrADWD4Mt
         gzS64ZuqrO3jsvduq4ZUVkJh05RXGonlD9BPCJYAmMWA7LGfKwHV4M2I4n0AjzISWV
         1UjDhmTY3M4wL5RtlUfVeGcFMQgoEzZb2WMaRFKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.237
Date:   Wed, 23 Sep 2020 20:36:24 +0200
Message-Id: <1600886184241244@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.237 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 
 arch/arm/boot/dts/socfpga_arria10.dtsi    |    2 
 arch/mips/Kconfig                         |    1 
 arch/mips/sni/a20r.c                      |    9 
 arch/powerpc/configs/pasemi_defconfig     |    1 
 arch/powerpc/configs/ppc6xx_defconfig     |    1 
 arch/powerpc/kernel/dma-iommu.c           |    3 
 arch/x86/configs/i386_defconfig           |    2 
 arch/x86/configs/x86_64_defconfig         |    2 
 arch/x86/kvm/vmx.c                        |    1 
 drivers/atm/firestream.c                  |    1 
 drivers/block/rbd.c                       |    9 
 drivers/i2c/algos/i2c-algo-pca.c          |   35 ++-
 drivers/iio/accel/bmc150-accel-core.c     |   15 +
 drivers/iio/accel/mma8452.c               |   11 
 drivers/iio/adc/mcp3422.c                 |   16 -
 drivers/iio/light/ltr501.c                |   15 -
 drivers/input/serio/i8042-x86ia64io.h     |   16 +
 drivers/net/wan/hdlc_cisco.c              |    1 
 drivers/net/wan/lapbether.c               |    3 
 drivers/rapidio/Kconfig                   |    2 
 drivers/scsi/libsas/sas_ata.c             |    5 
 drivers/scsi/lpfc/lpfc_els.c              |    4 
 drivers/scsi/pm8001/pm8001_sas.c          |    2 
 drivers/staging/wlan-ng/hfa384x_usb.c     |    5 
 drivers/staging/wlan-ng/prism2usb.c       |   19 -
 drivers/target/iscsi/iscsi_target_login.c |    6 
 drivers/target/iscsi/iscsi_target_login.h |    3 
 drivers/target/iscsi/iscsi_target_nego.c  |    3 
 drivers/tty/serial/8250/8250_pci.c        |   11 
 drivers/usb/class/usblp.c                 |    5 
 drivers/usb/core/message.c                |   91 +++-----
 drivers/usb/core/quirks.c                 |    4 
 drivers/usb/core/usb.c                    |   83 +++++++
 drivers/usb/host/ehci-hcd.c               |    1 
 drivers/usb/host/ehci-hub.c               |    1 
 drivers/usb/serial/ftdi_sio.c             |    1 
 drivers/usb/serial/ftdi_sio_ids.h         |    1 
 drivers/usb/serial/option.c               |    2 
 drivers/usb/storage/uas.c                 |   14 +
 drivers/video/console/Kconfig             |   25 --
 drivers/video/console/bitblit.c           |   11 
 drivers/video/console/fbcon.c             |  338 ------------------------------
 drivers/video/console/fbcon.h             |    2 
 drivers/video/console/fbcon_ccw.c         |   11 
 drivers/video/console/fbcon_cw.c          |   11 
 drivers/video/console/fbcon_ud.c          |   11 
 drivers/video/console/tileblit.c          |    2 
 drivers/video/console/vgacon.c            |  161 --------------
 drivers/video/fbdev/vga16fb.c             |    2 
 fs/btrfs/ioctl.c                          |    3 
 fs/nfs/nfs4proc.c                         |    7 
 fs/xfs/libxfs/xfs_attr_leaf.c             |    4 
 include/linux/i2c-algo-pca.h              |   15 +
 include/linux/usb.h                       |   35 +++
 kernel/gcov/gcc_4_7.c                     |    4 
 net/sunrpc/rpcb_clnt.c                    |    4 
 sound/hda/hdac_device.c                   |    2 
 tools/perf/tests/pmu.c                    |    1 
 tools/perf/util/pmu.c                     |   11 
 tools/perf/util/pmu.h                     |    1 
 61 files changed, 382 insertions(+), 688 deletions(-)

Adam Borowski (1):
      x86/defconfig: Enable CONFIG_USB_XHCI_HCD=y

Aleksander Morgado (1):
      USB: serial: option: add support for SIM7070/SIM7080/SIM7090 modules

Alexey Kardashevskiy (1):
      powerpc/dma: Fix dma_map_ops::get_required_mask

Angelo Compagnucci (2):
      iio: adc: mcp3422: fix locking scope
      iio: adc: mcp3422: fix locking on error path

Darrick J. Wong (1):
      xfs: initialize the shortform attr header padding entry

Dinghao Liu (2):
      firestream: Fix memleak in fs_open
      scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort

Dinh Nguyen (1):
      ARM: dts: socfpga: fix register entry for timer3 on Arria10

Evan Nimmo (1):
      i2c: algo: pca: Reapply i2c bus settings after reset

Filipe Manana (1):
      btrfs: fix wrong address when faulting in pages in the search ioctl

Greg Kroah-Hartman (1):
      Linux 4.4.237

Hans de Goede (1):
      Input: i8042 - add Entroware Proteus EL07R4 to nomux and reset lists

Hou Pu (1):
      scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

Ilya Dryomov (1):
      rbd: require global CAP_SYS_ADMIN for mapping and unmapping

J. Bruce Fields (1):
      SUNRPC: stop printk reading past end of string

James Smart (1):
      scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery

Johan Hovold (1):
      USB: core: add helpers to retrieve endpoints

Jonathan Cameron (3):
      iio:light:ltr501 Fix timestamp alignment issue.
      iio:accel:bmc150-accel: Fix timestamp alignment and prevent data leak.
      iio:accel:mma8452: Fix timestamp alignment and prevent data leak.

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

Namhyung Kim (1):
      perf test: Free formats for perf pmu parse test

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

Quentin Perret (1):
      ehci-hcd: Move include to keep CRC stable

Rander Wang (1):
      ALSA: hda: fix a runtime pm issue in SOF when integrated GPU is disabled

Rustam Kovhaev (1):
      staging: wlan-ng: fix out of bounds read in prism2sta_probe_usb()

Tetsuo Handa (2):
      video: fbdev: fix OOB read in vga_8planes_imageblit()
      fbcon: Fix user font detection test at fbcon_resize().

Thomas Bogendoerfer (2):
      MIPS: SNI: Fix MIPS_L1_CACHE_SHIFT
      MIPS: SNI: Fix spurious interrupts

Tobias Diedrich (1):
      serial: 8250_pci: Add Realtek 816a and 816b

Wanpeng Li (1):
      KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit

Xie He (3):
      drivers/net/wan/lapbether: Added needed_tailroom
      drivers/net/wan/lapbether: Set network_header before transmitting
      drivers/net/wan/hdlc_cisco: Add hard_header_len

