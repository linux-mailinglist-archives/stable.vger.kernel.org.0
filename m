Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959C5347663
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 11:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhCXKnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 06:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235581AbhCXKmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 06:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DB1961A01;
        Wed, 24 Mar 2021 10:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616582574;
        bh=zqefoITQwBGulDDaVFSPRVotTGH79NA1NBuo2VE9WbU=;
        h=From:To:Cc:Subject:Date:From;
        b=u2/EFNK2Sh//2G+kXr8FHLgUFwltcGt99Hs/h/IFeedAI1lhJoCuFzNnKfdgv185u
         oSwz4b8ZIRNSwb4QKiO29Z11ATPvT+VrTo6R5FMmLOmMjwwSiz4Ze4hrpKodnpw5Ur
         gebA+34O+5zsSdapIwtJ4u73FqO1Qa5yZOdkaeMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.108
Date:   Wed, 24 Mar 2021 11:42:51 +0100
Message-Id: <161658257123367@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.108 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    8 +-
 arch/arm/kernel/entry-armv.S                     |   25 -------
 arch/arm/vfp/entry.S                             |   17 -----
 arch/arm/vfp/vfphw.S                             |    5 -
 arch/arm/vfp/vfpmodule.c                         |   72 +++++++++++++++++++++--
 arch/riscv/Kconfig                               |    4 -
 arch/s390/kernel/vtime.c                         |    2 
 arch/x86/events/intel/ds.c                       |    2 
 arch/x86/include/asm/processor.h                 |    9 --
 arch/x86/include/asm/thread_info.h               |   23 +++++++
 arch/x86/kernel/apic/apic.c                      |    5 +
 arch/x86/kernel/apic/io_apic.c                   |   10 +++
 arch/x86/kernel/signal.c                         |   24 -------
 drivers/base/power/runtime.c                     |   62 +++++++------------
 drivers/counter/stm32-timer-cnt.c                |   44 +++++++++-----
 drivers/firmware/efi/efi.c                       |    3 
 drivers/iio/adc/Kconfig                          |    1 
 drivers/iio/adc/ad7949.c                         |    2 
 drivers/iio/adc/qcom-spmi-vadc.c                 |    2 
 drivers/iio/gyro/mpu3050-core.c                  |    2 
 drivers/iio/humidity/hid-sensor-humidity.c       |   12 ++-
 drivers/iio/imu/adis16400.c                      |    3 
 drivers/iio/light/hid-sensor-prox.c              |   13 +++-
 drivers/iio/temperature/hid-sensor-temperature.c |   14 ++--
 drivers/nvme/host/core.c                         |   36 +++--------
 drivers/nvme/host/rdma.c                         |    7 +-
 drivers/nvme/host/tcp.c                          |   14 +++-
 drivers/nvme/target/core.c                       |   17 ++++-
 drivers/pci/hotplug/rpadlpar_sysfs.c             |   14 +---
 drivers/scsi/lpfc/lpfc_debugfs.c                 |    4 -
 drivers/scsi/myrs.c                              |    2 
 drivers/usb/gadget/composite.c                   |    4 -
 drivers/usb/gadget/configfs.c                    |   16 +++--
 drivers/usb/gadget/usbstring.c                   |    4 -
 drivers/usb/storage/transport.c                  |    7 ++
 drivers/usb/storage/unusual_devs.h               |   12 +++
 drivers/usb/typec/tcpm/tcpm.c                    |    8 ++
 drivers/usb/usbip/vudc_sysfs.c                   |    2 
 drivers/vfio/Kconfig                             |    2 
 fs/afs/dir.c                                     |    1 
 fs/afs/file.c                                    |    1 
 fs/afs/inode.c                                   |    1 
 fs/afs/internal.h                                |    1 
 fs/afs/mntpt.c                                   |    1 
 fs/afs/xattr.c                                   |   23 -------
 fs/btrfs/ctree.c                                 |    2 
 fs/btrfs/inode.c                                 |    2 
 fs/cifs/transport.c                              |    7 +-
 fs/ext4/inode.c                                  |    8 +-
 fs/ext4/namei.c                                  |   29 ++++++++-
 fs/ext4/xattr.c                                  |    2 
 fs/nfsd/filecache.c                              |    2 
 fs/select.c                                      |   10 +--
 include/linux/efi.h                              |    6 +
 include/linux/thread_info.h                      |   13 ++++
 include/linux/usb_usual.h                        |    2 
 include/uapi/linux/usb/ch9.h                     |    3 
 kernel/futex.c                                   |    3 
 kernel/irq/manage.c                              |    4 +
 kernel/time/alarmtimer.c                         |    2 
 kernel/time/hrtimer.c                            |    2 
 kernel/time/posix-cpu-timers.c                   |    2 
 net/qrtr/qrtr.c                                  |    2 
 net/sunrpc/svc.c                                 |    6 +
 net/sunrpc/svc_xprt.c                            |    4 -
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c       |    6 -
 sound/firewire/dice/dice-stream.c                |    5 -
 sound/pci/hda/hda_generic.c                      |    2 
 sound/pci/hda/patch_realtek.c                    |    2 
 sound/soc/codecs/ak4458.c                        |    1 
 sound/soc/codecs/ak5558.c                        |    1 
 sound/soc/fsl/fsl_ssi.c                          |    6 +
 sound/soc/generic/simple-card-utils.c            |   13 ++--
 sound/soc/sof/intel/hda-dsp.c                    |    2 
 sound/soc/sof/intel/hda.c                        |    1 
 75 files changed, 406 insertions(+), 285 deletions(-)

Alan Stern (1):
      usb-storage: Add quirk to defeat Kindle's automatic unload

Alexander Shiyan (1):
      ASoC: fsl_ssi: Fix TDM slot setup for I2S mode

Ard Biesheuvel (3):
      ARM: 9030/1: entry: omit FP emulation for UND exceptions taken in kernel mode
      ARM: 9044/1: vfp: use undef hook for VFP support detection
      efi: use 32-bit alignment for efi_guid_t literals

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Invoke power_supply_changed for tcpm-source-psy-

Christoph Hellwig (1):
      nvme: fix Write Zeroes limitations

Colin Ian King (1):
      usbip: Fix incorrect double assignment to udc->ud.tcp_rx

Dan Carpenter (2):
      scsi: lpfc: Fix some error codes in debugfs
      iio: adis16400: Fix an error code in adis16400_initial_setup()

Daniel Kobras (1):
      sunrpc: fix refcount leak for rpc auth modules

David Howells (1):
      afs: Stop listxattr() from listing "afs.*" attributes

David Sterba (1):
      btrfs: fix slab cache flags for free space tree bitmap

Dinghao Liu (1):
      iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler

Fabrice Gasnier (1):
      counter: stm32-timer-cnt: fix ceiling write max value

Filipe Manana (1):
      btrfs: fix race when cloning extent buffer during rewind of an old root

Gerald Schaefer (1):
      s390/vtime: fix increased steal time accounting

Greg Kroah-Hartman (1):
      Linux 5.4.108

Hui Wang (1):
      ALSA: hda: generic: Fix the micmute led init state

Jason Gunthorpe (1):
      vfio: IOMMU_API should be selected

Jim Lin (1):
      usb: gadget: configfs: Fix KASAN use-after-free

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

Kefeng Wang (1):
      riscv: Correct SPARSEMEM configuration

Lv Yunlong (2):
      scsi: myrs: Fix a double free in myrs_cleanup()
      firmware/efi: Fix a use after bug in efi_mem_reserve_persistent

Macpaul Lin (1):
      USB: replace hardcode maximum usb string length by definition

Masahiro Yamada (1):
      kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL again

Oleg Nesterov (3):
      kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()
      x86: Move TS_COMPAT back to asm/thread_info.h
      x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()

Pan Xiuli (1):
      ASoC: SOF: intel: fix wrong poll bits in dsp power down

Pavel Skripkin (1):
      net/qrtr: fix __netdev_alloc_skb call

Pierre-Louis Bossart (1):
      ASoC: SOF: Intel: unregister DMIC device on probe error

Rafael J. Wysocki (1):
      Revert "PM: runtime: Update device status before letting suppliers suspend"

Sagi Grimberg (4):
      nvme-tcp: fix possible hang when failing to set io queues
      nvme-tcp: fix a NULL deref when receiving a 0-length r2t PDU
      nvmet: don't check iosqes,iocqes for discovery controllers
      nvme-rdma: fix possible hang when failing to set io queues

Sameer Pujar (1):
      ASoC: simple-card-utils: Do not handle device clock

Shengjiu Wang (2):
      ASoC: ak4458: Add MODULE_DEVICE_TABLE
      ASoC: ak5558: Add MODULE_DEVICE_TABLE

Shijie Luo (1):
      ext4: fix potential error in ext4_do_update_inode

Takashi Sakamoto (1):
      ALSA: dice: fix null pointer dereference when node is disconnected

Thomas Gleixner (2):
      x86/ioapic: Ignore IRQ2 again
      genirq: Disable interrupts for force threaded handlers

Timo Rothenpieler (1):
      svcrdma: disable timeouts on rdma backchannel

Trond Myklebust (1):
      nfsd: Don't keep looking up unhashed files in the nfsd file cache

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix potential drc_name corruption in store functions

Vincent Whitchurch (1):
      cifs: Fix preauth hash corruption

Wilfried Wessner (1):
      iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask

William Breathitt Gray (1):
      counter: stm32-timer-cnt: Report count function when SLAVE_MODE_DISABLED

Xiaoliang Yu (2):
      ALSA: hda/realtek: apply pin quirk for XiaomiNotebook Pro
      ALSA: hda/realtek: Apply headset-mic quirks for Xiaomi Redmibook Air

Ye Xiang (3):
      iio: hid-sensor-humidity: Fix alignment issue of timestamp channel
      iio: hid-sensor-prox: Fix scale not correct issue
      iio: hid-sensor-temperature: Fix issues of timestamp channel

zhangyi (F) (2):
      ext4: find old entry again if failed to rename whiteout
      ext4: do not try to set xattr into ea_inode if value is empty

