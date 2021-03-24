Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD83475EA
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 11:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCXKXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 06:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230484AbhCXKXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 06:23:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91536619C0;
        Wed, 24 Mar 2021 10:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616581403;
        bh=bMJ3cUoRwtkFVOl9ffDAX/zKQI6jvvc9VaCBwHzhwdU=;
        h=From:To:Cc:Subject:Date:From;
        b=1p71Ioq5cGnc7uSmBkK1ziVYXE6o2Up1Hv0OZ1mESkbYmOajDYq+fOGgGAilU3Ah2
         rvca4xc/CcvNMOXK+LwurbImNrocmmK+0i3P4345uio5bXV+XFU43SaGzYg3Cqu0SU
         1Ud/KOfu8kUUXdLbvUS2na47FILVS10FRPdkaW0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.183
Date:   Wed, 24 Mar 2021 11:23:17 +0100
Message-Id: <161658139724883@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.183 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/powerpc/include/asm/cpu_has_feature.h       |    4 -
 arch/powerpc/kernel/vmlinux.lds.S                |    1 
 arch/x86/events/intel/ds.c                       |    2 
 arch/x86/include/asm/processor.h                 |    9 ---
 arch/x86/include/asm/thread_info.h               |   23 ++++++++
 arch/x86/kernel/apic/apic.c                      |    5 +
 arch/x86/kernel/apic/io_apic.c                   |   10 +++
 arch/x86/kernel/signal.c                         |   24 --------
 drivers/base/power/runtime.c                     |   62 +++++++++--------------
 drivers/iio/adc/Kconfig                          |    1 
 drivers/iio/adc/qcom-spmi-vadc.c                 |    2 
 drivers/iio/gyro/mpu3050-core.c                  |    2 
 drivers/iio/humidity/hid-sensor-humidity.c       |   12 ++--
 drivers/iio/imu/adis16400_core.c                 |    3 -
 drivers/iio/light/hid-sensor-prox.c              |   13 ++++
 drivers/iio/temperature/hid-sensor-temperature.c |   14 ++---
 drivers/misc/lkdtm/Makefile                      |    2 
 drivers/misc/lkdtm/rodata.c                      |    2 
 drivers/nvme/host/rdma.c                         |    7 +-
 drivers/nvme/target/core.c                       |   17 +++++-
 drivers/pci/hotplug/rpadlpar_sysfs.c             |   14 ++---
 drivers/scsi/lpfc/lpfc_debugfs.c                 |    4 -
 drivers/usb/gadget/composite.c                   |    4 -
 drivers/usb/gadget/configfs.c                    |   16 ++++-
 drivers/usb/gadget/usbstring.c                   |    4 -
 drivers/usb/storage/transport.c                  |    7 ++
 drivers/usb/storage/unusual_devs.h               |   12 ++++
 drivers/usb/usbip/vudc_sysfs.c                   |    2 
 fs/btrfs/ctree.c                                 |    2 
 fs/btrfs/inode.c                                 |    2 
 fs/cifs/transport.c                              |    7 ++
 fs/ext4/inode.c                                  |    8 +-
 fs/ext4/namei.c                                  |   29 ++++++++++
 fs/ext4/xattr.c                                  |    2 
 fs/select.c                                      |   10 +--
 include/asm-generic/sections.h                   |    3 +
 include/asm-generic/vmlinux.lds.h                |   10 +++
 include/linux/compiler.h                         |   54 ++++++++++++++++++++
 include/linux/compiler_types.h                   |    6 ++
 include/linux/thread_info.h                      |   13 ++++
 include/linux/usb_usual.h                        |    2 
 include/uapi/linux/usb/ch9.h                     |    3 +
 kernel/futex.c                                   |    3 -
 kernel/irq/manage.c                              |    4 +
 kernel/time/alarmtimer.c                         |    2 
 kernel/time/hrtimer.c                            |    2 
 kernel/time/posix-cpu-timers.c                   |    2 
 net/qrtr/qrtr.c                                  |    2 
 net/sunrpc/svc.c                                 |    6 +-
 net/sunrpc/svc_xprt.c                            |    4 -
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c       |    6 +-
 scripts/mod/modpost.c                            |    2 
 sound/pci/hda/hda_generic.c                      |    2 
 sound/soc/codecs/ak4458.c                        |    1 
 sound/soc/codecs/ak5558.c                        |    1 
 sound/soc/fsl/fsl_ssi.c                          |    6 +-
 tools/build/Makefile.feature                     |    3 +
 tools/build/feature/Makefile                     |   12 ++++
 tools/build/feature/test-all.c                   |   15 +++++
 tools/build/feature/test-eventfd.c               |    9 +++
 tools/build/feature/test-get_current_dir_name.c  |   10 +++
 tools/build/feature/test-gettid.c                |   11 ++++
 tools/perf/Makefile.config                       |   12 ++++
 tools/perf/jvmti/jvmti_agent.c                   |    2 
 tools/perf/util/Build                            |    1 
 tools/perf/util/expr.y                           |    3 -
 tools/perf/util/get_current_dir_name.c           |   18 ++++++
 tools/perf/util/parse-events.y                   |    2 
 tools/perf/util/util.h                           |    4 +
 70 files changed, 425 insertions(+), 151 deletions(-)

Alan Stern (1):
      usb-storage: Add quirk to defeat Kindle's automatic unload

Alexander Shiyan (1):
      ASoC: fsl_ssi: Fix TDM slot setup for I2S mode

Arnaldo Carvalho de Melo (3):
      tools build feature: Check if get_current_dir_name() is available
      tools build feature: Check if eventfd() is available
      tools build: Check if gettid() is available before providing helper

Christophe Leroy (1):
      powerpc: Force inlining of cpu_has_feature() to avoid build failure

Colin Ian King (1):
      usbip: Fix incorrect double assignment to udc->ud.tcp_rx

Dan Carpenter (2):
      scsi: lpfc: Fix some error codes in debugfs
      iio: adis16400: Fix an error code in adis16400_initial_setup()

Daniel Kobras (1):
      sunrpc: fix refcount leak for rpc auth modules

David Sterba (1):
      btrfs: fix slab cache flags for free space tree bitmap

Dinghao Liu (1):
      iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler

Filipe Manana (1):
      btrfs: fix race when cloning extent buffer during rewind of an old root

Greg Kroah-Hartman (1):
      Linux 4.19.183

Hui Wang (1):
      ALSA: hda: generic: Fix the micmute led init state

Jim Lin (1):
      usb: gadget: configfs: Fix KASAN use-after-free

Jiri Olsa (1):
      perf tools: Use %define api.pure full instead of %pure-parser

Joe Korty (1):
      NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

Johan Hovold (1):
      x86/apic/of: Fix CPU devicetree-node lookups

Jonathan Albrieux (1):
      iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel

Jonathan Cameron (1):
      iio:adc:stm32-adc: Add HAS_IOMEM dependency

Kan Liang (1):
      perf/x86/intel: Fix a crash caused by zero PEBS status

Macpaul Lin (1):
      USB: replace hardcode maximum usb string length by definition

Nicolas Boichat (2):
      vmlinux.lds.h: Create section for protection against instrumentation
      lkdtm: don't move ctors to .rodata

Oleg Nesterov (3):
      kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()
      x86: Move TS_COMPAT back to asm/thread_info.h
      x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()

Pavel Skripkin (1):
      net/qrtr: fix __netdev_alloc_skb call

Rafael J. Wysocki (1):
      Revert "PM: runtime: Update device status before letting suppliers suspend"

Sagi Grimberg (2):
      nvmet: don't check iosqes,iocqes for discovery controllers
      nvme-rdma: fix possible hang when failing to set io queues

Shengjiu Wang (2):
      ASoC: ak4458: Add MODULE_DEVICE_TABLE
      ASoC: ak5558: Add MODULE_DEVICE_TABLE

Shijie Luo (1):
      ext4: fix potential error in ext4_do_update_inode

Thomas Gleixner (2):
      x86/ioapic: Ignore IRQ2 again
      genirq: Disable interrupts for force threaded handlers

Timo Rothenpieler (1):
      svcrdma: disable timeouts on rdma backchannel

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix potential drc_name corruption in store functions

Vincent Whitchurch (1):
      cifs: Fix preauth hash corruption

Ye Xiang (3):
      iio: hid-sensor-humidity: Fix alignment issue of timestamp channel
      iio: hid-sensor-prox: Fix scale not correct issue
      iio: hid-sensor-temperature: Fix issues of timestamp channel

zhangyi (F) (2):
      ext4: find old entry again if failed to rename whiteout
      ext4: do not try to set xattr into ea_inode if value is empty

