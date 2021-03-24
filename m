Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213E43475E7
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 11:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCXKXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 06:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230062AbhCXKXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 06:23:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF74619BB;
        Wed, 24 Mar 2021 10:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616581394;
        bh=EUA1CgAcquNK5omzMCv5dB4lN5cNt5r4f3YiuknYrcE=;
        h=From:To:Cc:Subject:Date:From;
        b=h4U5cMz1FaXhBqHy+7QJcMrwsO6oYlZ8O3BXHv1Q4FfemlMlZfIHNN6obw3gp06P3
         lPR0gsFpxmM5fDjoj6VFAysFn++ACGja4IQgA9C39i8GQ6EASgz6VWooQx8eia0WA8
         UAY2wXRvP5j4sgSFp++R+9B9dlZtcDa9ikaDMjkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.227
Date:   Wed, 24 Mar 2021 11:23:11 +0100
Message-Id: <16165813912347@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.227 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/x86/events/intel/ds.c                       |    2 
 arch/x86/include/asm/processor.h                 |    9 --
 arch/x86/include/asm/thread_info.h               |   23 +++++++
 arch/x86/kernel/apic/io_apic.c                   |   10 +++
 arch/x86/kernel/signal.c                         |   24 -------
 drivers/base/power/runtime.c                     |   62 ++++++++------------
 drivers/iio/adc/Kconfig                          |    1 
 drivers/iio/adc/qcom-spmi-vadc.c                 |    2 
 drivers/iio/gyro/mpu3050-core.c                  |    2 
 drivers/iio/humidity/hid-sensor-humidity.c       |   12 ++-
 drivers/iio/imu/adis16400_core.c                 |    3 
 drivers/iio/light/hid-sensor-prox.c              |   13 +++-
 drivers/iio/temperature/hid-sensor-temperature.c |   14 ++--
 drivers/net/dsa/b53/b53_common.c                 |   20 ++++++
 drivers/net/dsa/b53/b53_regs.h                   |    1 
 drivers/net/dsa/bcm_sf2.c                        |    5 +
 drivers/net/dsa/bcm_sf2_regs.h                   |    2 
 drivers/nvme/host/rdma.c                         |    7 +-
 drivers/nvme/target/core.c                       |   17 ++++-
 drivers/pci/hotplug/rpadlpar_sysfs.c             |   14 +---
 drivers/scsi/lpfc/lpfc_debugfs.c                 |    4 -
 drivers/usb/gadget/composite.c                   |    4 -
 drivers/usb/gadget/configfs.c                    |   16 +++--
 drivers/usb/gadget/usbstring.c                   |    4 -
 drivers/usb/storage/transport.c                  |    7 ++
 drivers/usb/storage/unusual_devs.h               |   12 +++
 fs/btrfs/ctree.c                                 |    2 
 fs/ext4/block_validity.c                         |   71 ++++++++++-------------
 fs/ext4/ext4.h                                   |    6 -
 fs/ext4/extents.c                                |   16 +----
 fs/ext4/indirect.c                               |    6 -
 fs/ext4/inode.c                                  |   13 +---
 fs/ext4/mballoc.c                                |    4 -
 fs/ext4/namei.c                                  |   29 ++++++++-
 fs/ext4/super.c                                  |    5 +
 fs/ext4/xattr.c                                  |    2 
 fs/select.c                                      |   10 +--
 include/linux/thread_info.h                      |   13 ++++
 include/linux/usb_usual.h                        |    2 
 include/uapi/linux/usb/ch9.h                     |    3 
 kernel/bpf/verifier.c                            |   33 ++++++----
 kernel/futex.c                                   |    3 
 kernel/irq/manage.c                              |    4 +
 kernel/time/alarmtimer.c                         |    2 
 kernel/time/hrtimer.c                            |    2 
 kernel/time/posix-cpu-timers.c                   |    2 
 net/qrtr/qrtr.c                                  |    2 
 net/sunrpc/svc.c                                 |    6 +
 net/sunrpc/svc_xprt.c                            |    4 -
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c       |    6 -
 tools/build/Makefile.feature                     |    4 +
 tools/build/feature/Makefile                     |   16 +++++
 tools/build/feature/test-all.c                   |   20 ++++++
 tools/build/feature/test-eventfd.c               |    9 ++
 tools/build/feature/test-get_current_dir_name.c  |   10 +++
 tools/build/feature/test-gettid.c                |   11 +++
 tools/build/feature/test-pthread-barrier.c       |   12 +++
 tools/perf/Makefile.config                       |   16 +++++
 tools/perf/jvmti/jvmti_agent.c                   |    2 
 tools/perf/util/Build                            |    1 
 tools/perf/util/expr.y                           |    3 
 tools/perf/util/get_current_dir_name.c           |   18 +++++
 tools/perf/util/parse-events.y                   |    2 
 tools/perf/util/srcline.c                        |   16 ++++-
 tools/perf/util/util.h                           |    4 +
 66 files changed, 468 insertions(+), 214 deletions(-)

Alan Stern (1):
      usb-storage: Add quirk to defeat Kindle's automatic unload

Arnaldo Carvalho de Melo (4):
      tools build feature: Check if get_current_dir_name() is available
      tools build feature: Check if eventfd() is available
      tools build: Check if gettid() is available before providing helper
      tools build feature: Check if pthread_barrier_t is available

Changbin Du (1):
      perf: Make perf able to build with latest libbfd

Dan Carpenter (2):
      scsi: lpfc: Fix some error codes in debugfs
      iio: adis16400: Fix an error code in adis16400_initial_setup()

Daniel Kobras (1):
      sunrpc: fix refcount leak for rpc auth modules

Dinghao Liu (1):
      iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler

Filipe Manana (1):
      btrfs: fix race when cloning extent buffer during rewind of an old root

Florian Fainelli (1):
      net: dsa: b53: Support setting learning on port

Greg Kroah-Hartman (1):
      Linux 4.14.227

Jan Kara (3):
      ext4: handle error of ext4_setup_system_zone() on remount
      ext4: don't allow overlapping system zones
      ext4: check journal inode extents more carefully

Jim Lin (1):
      usb: gadget: configfs: Fix KASAN use-after-free

Jiri Olsa (1):
      perf tools: Use %define api.pure full instead of %pure-parser

Joe Korty (1):
      NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

Jonathan Albrieux (1):
      iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel

Jonathan Cameron (1):
      iio:adc:stm32-adc: Add HAS_IOMEM dependency

Kan Liang (1):
      perf/x86/intel: Fix a crash caused by zero PEBS status

Macpaul Lin (1):
      USB: replace hardcode maximum usb string length by definition

Oleg Nesterov (3):
      kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()
      x86: Move TS_COMPAT back to asm/thread_info.h
      x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()

Pavel Skripkin (1):
      net/qrtr: fix __netdev_alloc_skb call

Piotr Krysiuk (4):
      bpf: Fix off-by-one for area size in creating mask to left
      bpf: Simplify alu_limit masking for pointer arithmetic
      bpf: Add sanity check for upper ptr_limit
      bpf: Prohibit alu ops for pointer types not defining ptr_limit

Rafael J. Wysocki (1):
      Revert "PM: runtime: Update device status before letting suppliers suspend"

Sagi Grimberg (2):
      nvmet: don't check iosqes,iocqes for discovery controllers
      nvme-rdma: fix possible hang when failing to set io queues

Shijie Luo (1):
      ext4: fix potential error in ext4_do_update_inode

Thomas Gleixner (2):
      x86/ioapic: Ignore IRQ2 again
      genirq: Disable interrupts for force threaded handlers

Timo Rothenpieler (1):
      svcrdma: disable timeouts on rdma backchannel

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix potential drc_name corruption in store functions

Ye Xiang (3):
      iio: hid-sensor-humidity: Fix alignment issue of timestamp channel
      iio: hid-sensor-prox: Fix scale not correct issue
      iio: hid-sensor-temperature: Fix issues of timestamp channel

zhangyi (F) (2):
      ext4: find old entry again if failed to rename whiteout
      ext4: do not try to set xattr into ea_inode if value is empty

