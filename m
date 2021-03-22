Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60ABC344329
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhCVMs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231551AbhCVMqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:46:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FEEA619AA;
        Mon, 22 Mar 2021 12:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416960;
        bh=vvl0v9ryuLPXHXpuFmpObCYVk+lY5geSSYH4w2rxXZ0=;
        h=From:To:Cc:Subject:Date:From;
        b=k8tpoUcoSzH+1ANTUTYrbW9bpZ/GVPpMcnxUSBnAbV5wirgQqoCOw2BXgVmlbgo2T
         jkp9gfPRskbldHmRW+1l7HVCC98e1uckuLG1QQsMoTiPb2amahfhlpKPdfZYf1Uvio
         8EKdppIRJ5kSc8h5pNd7hm/faGgmlzdwb+3W/Ads=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/60] 5.4.108-rc1 review
Date:   Mon, 22 Mar 2021 13:27:48 +0100
Message-Id: <20210322121922.372583154@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.108-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.108-rc1
X-KernelTest-Deadline: 2021-03-24T12:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.108 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.108-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.108-rc1

Johan Hovold <johan@kernel.org>
    x86/apic/of: Fix CPU devicetree-node lookups

Thomas Gleixner <tglx@linutronix.de>
    genirq: Disable interrupts for force threaded handlers

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    firmware/efi: Fix a use after bug in efi_mem_reserve_persistent

Ard Biesheuvel <ardb@kernel.org>
    efi: use 32-bit alignment for efi_guid_t literals

Shijie Luo <luoshijie1@huawei.com>
    ext4: fix potential error in ext4_do_update_inode

zhangyi (F) <yi.zhang@huawei.com>
    ext4: do not try to set xattr into ea_inode if value is empty

zhangyi (F) <yi.zhang@huawei.com>
    ext4: find old entry again if failed to rename whiteout

Oleg Nesterov <oleg@redhat.com>
    x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()

Oleg Nesterov <oleg@redhat.com>
    x86: Move TS_COMPAT back to asm/thread_info.h

Oleg Nesterov <oleg@redhat.com>
    kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Ignore IRQ2 again

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix a crash caused by zero PEBS status

Tyrel Datwyler <tyreld@linux.ibm.com>
    PCI: rpadlpar: Fix potential drc_name corruption in store functions

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-timer-cnt: fix ceiling write max value

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-temperature: Fix issues of timestamp channel

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-prox: Fix scale not correct issue

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-humidity: Fix alignment issue of timestamp channel

Wilfried Wessner <wilfried.wessner@gmail.com>
    iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler

Dan Carpenter <dan.carpenter@oracle.com>
    iio: adis16400: Fix an error code in adis16400_initial_setup()

Jonathan Albrieux <jonathan.albrieux@gmail.com>
    iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:stm32-adc: Add HAS_IOMEM dependency

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Invoke power_supply_changed for tcpm-source-psy-

Jim Lin <jilin@nvidia.com>
    usb: gadget: configfs: Fix KASAN use-after-free

Macpaul Lin <macpaul.lin@mediatek.com>
    USB: replace hardcode maximum usb string length by definition

Colin Ian King <colin.king@canonical.com>
    usbip: Fix incorrect double assignment to udc->ud.tcp_rx

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Add quirk to defeat Kindle's automatic unload

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix possible hang when failing to set io queues

William Breathitt Gray <vilhelm.gray@gmail.com>
    counter: stm32-timer-cnt: Report count function when SLAVE_MODE_DISABLED

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    scsi: myrs: Fix a double free in myrs_cleanup()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: lpfc: Fix some error codes in debugfs

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: Correct SPARSEMEM configuration

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL again

Pavel Skripkin <paskripkin@gmail.com>
    net/qrtr: fix __netdev_alloc_skb call

Daniel Kobras <kobras@puzzle-itc.de>
    sunrpc: fix refcount leak for rpc auth modules

Jason Gunthorpe <jgg@nvidia.com>
    vfio: IOMMU_API should be selected

Timo Rothenpieler <timo@rothenpieler.org>
    svcrdma: disable timeouts on rdma backchannel

Joe Korty <joe.korty@concurrent-rt.com>
    NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Don't keep looking up unhashed files in the nfsd file cache

Sagi Grimberg <sagi@grimberg.me>
    nvmet: don't check iosqes,iocqes for discovery controllers

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix a NULL deref when receiving a 0-length r2t PDU

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible hang when failing to set io queues

Christoph Hellwig <hch@lst.de>
    nvme: fix Write Zeroes limitations

David Howells <dhowells@redhat.com>
    afs: Stop listxattr() from listing "afs.*" attributes

Sameer Pujar <spujar@nvidia.com>
    ASoC: simple-card-utils: Do not handle device clock

Pan Xiuli <xiuli.pan@linux.intel.com>
    ASoC: SOF: intel: fix wrong poll bits in dsp power down

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: unregister DMIC device on probe error

Alexander Shiyan <shc_work@mail.ru>
    ASoC: fsl_ssi: Fix TDM slot setup for I2S mode

David Sterba <dsterba@suse.com>
    btrfs: fix slab cache flags for free space tree bitmap

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race when cloning extent buffer during rewind of an old root

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9044/1: vfp: use undef hook for VFP support detection

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9030/1: entry: omit FP emulation for UND exceptions taken in kernel mode

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/vtime: fix increased steal time accounting

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "PM: runtime: Update device status before letting suppliers suspend"

Xiaoliang Yu <yxl_22@outlook.com>
    ALSA: hda/realtek: Apply headset-mic quirks for Xiaomi Redmibook Air

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: generic: Fix the micmute led init state

Xiaoliang Yu <yxl_22@outlook.com>
    ALSA: hda/realtek: apply pin quirk for XiaomiNotebook Pro

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix null pointer dereference when node is disconnected

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: Add MODULE_DEVICE_TABLE

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak4458: Add MODULE_DEVICE_TABLE


-------------

Diffstat:

 Makefile                                         | 10 ++--
 arch/arm/kernel/entry-armv.S                     | 25 +-------
 arch/arm/vfp/entry.S                             | 17 ------
 arch/arm/vfp/vfphw.S                             |  5 --
 arch/arm/vfp/vfpmodule.c                         | 72 ++++++++++++++++++++++--
 arch/riscv/Kconfig                               |  4 +-
 arch/s390/kernel/vtime.c                         |  2 +-
 arch/x86/events/intel/ds.c                       |  2 +-
 arch/x86/include/asm/processor.h                 |  9 ---
 arch/x86/include/asm/thread_info.h               | 23 +++++++-
 arch/x86/kernel/apic/apic.c                      |  5 ++
 arch/x86/kernel/apic/io_apic.c                   | 10 ++++
 arch/x86/kernel/signal.c                         | 24 +-------
 drivers/base/power/runtime.c                     | 62 ++++++++------------
 drivers/counter/stm32-timer-cnt.c                | 44 ++++++++++-----
 drivers/firmware/efi/efi.c                       |  3 +-
 drivers/iio/adc/Kconfig                          |  1 +
 drivers/iio/adc/ad7949.c                         |  2 +-
 drivers/iio/adc/qcom-spmi-vadc.c                 |  2 +-
 drivers/iio/gyro/mpu3050-core.c                  |  2 +
 drivers/iio/humidity/hid-sensor-humidity.c       | 12 ++--
 drivers/iio/imu/adis16400.c                      |  3 +-
 drivers/iio/light/hid-sensor-prox.c              | 13 ++++-
 drivers/iio/temperature/hid-sensor-temperature.c | 14 +++--
 drivers/nvme/host/core.c                         | 36 ++++--------
 drivers/nvme/host/rdma.c                         |  7 ++-
 drivers/nvme/host/tcp.c                          | 14 ++++-
 drivers/nvme/target/core.c                       | 17 +++++-
 drivers/pci/hotplug/rpadlpar_sysfs.c             | 14 ++---
 drivers/scsi/lpfc/lpfc_debugfs.c                 |  4 +-
 drivers/scsi/myrs.c                              |  2 +-
 drivers/usb/gadget/composite.c                   |  4 +-
 drivers/usb/gadget/configfs.c                    | 16 ++++--
 drivers/usb/gadget/usbstring.c                   |  4 +-
 drivers/usb/storage/transport.c                  |  7 +++
 drivers/usb/storage/unusual_devs.h               | 12 ++++
 drivers/usb/typec/tcpm/tcpm.c                    |  8 ++-
 drivers/usb/usbip/vudc_sysfs.c                   |  2 +-
 drivers/vfio/Kconfig                             |  2 +-
 fs/afs/dir.c                                     |  1 -
 fs/afs/file.c                                    |  1 -
 fs/afs/inode.c                                   |  1 -
 fs/afs/internal.h                                |  1 -
 fs/afs/mntpt.c                                   |  1 -
 fs/afs/xattr.c                                   | 23 --------
 fs/btrfs/ctree.c                                 |  2 +
 fs/btrfs/inode.c                                 |  2 +-
 fs/ext4/inode.c                                  |  8 +--
 fs/ext4/namei.c                                  | 29 +++++++++-
 fs/ext4/xattr.c                                  |  2 +-
 fs/nfsd/filecache.c                              |  2 +
 fs/select.c                                      | 10 ++--
 include/linux/efi.h                              |  6 +-
 include/linux/thread_info.h                      | 13 +++++
 include/linux/usb_usual.h                        |  2 +
 include/uapi/linux/usb/ch9.h                     |  3 +
 kernel/futex.c                                   |  3 +-
 kernel/irq/manage.c                              |  4 ++
 kernel/time/alarmtimer.c                         |  2 +-
 kernel/time/hrtimer.c                            |  2 +-
 kernel/time/posix-cpu-timers.c                   |  2 +-
 net/qrtr/qrtr.c                                  |  2 +-
 net/sunrpc/svc.c                                 |  6 +-
 net/sunrpc/svc_xprt.c                            |  4 +-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c       |  6 +-
 sound/firewire/dice/dice-stream.c                |  5 +-
 sound/pci/hda/hda_generic.c                      |  2 +-
 sound/pci/hda/patch_realtek.c                    |  2 +
 sound/soc/codecs/ak4458.c                        |  1 +
 sound/soc/codecs/ak5558.c                        |  1 +
 sound/soc/fsl/fsl_ssi.c                          |  6 +-
 sound/soc/generic/simple-card-utils.c            | 13 +++--
 sound/soc/sof/intel/hda-dsp.c                    |  2 +-
 sound/soc/sof/intel/hda.c                        |  1 +
 74 files changed, 401 insertions(+), 285 deletions(-)


