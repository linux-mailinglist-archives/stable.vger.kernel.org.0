Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600BC344367
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhCVMuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhCVMsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60DF1619EE;
        Mon, 22 Mar 2021 12:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417073;
        bh=AxXCXFJJPHSM/a/gP4L2CHCHaIJVvP5GXUXJbePlMt0=;
        h=From:To:Cc:Subject:Date:From;
        b=misqksBXhJBnDVrk+chiQ0dxYL7Cy4MDRlfil9eG6gzwBuYiN4Rn40Uv7d8+PWsJs
         cKgvGRmk8CMPa6fv6L/9fGMTwkb/CwUyURD8il6IdTt1jgDQepifrrPhF+9kFlJMAq
         /AIYjlzQ+uuqAAZ7k/218rRpClqlmoQvHmj/KCOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/43] 4.19.183-rc1 review
Date:   Mon, 22 Mar 2021 13:28:14 +0100
Message-Id: <20210322121919.936671417@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.183-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.183-rc1
X-KernelTest-Deadline: 2021-03-24T12:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.183 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.183-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.183-rc1

Johan Hovold <johan@kernel.org>
    x86/apic/of: Fix CPU devicetree-node lookups

Thomas Gleixner <tglx@linutronix.de>
    genirq: Disable interrupts for force threaded handlers

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

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-temperature: Fix issues of timestamp channel

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-prox: Fix scale not correct issue

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-humidity: Fix alignment issue of timestamp channel

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler

Dan Carpenter <dan.carpenter@oracle.com>
    iio: adis16400: Fix an error code in adis16400_initial_setup()

Jonathan Albrieux <jonathan.albrieux@gmail.com>
    iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:stm32-adc: Add HAS_IOMEM dependency

Jim Lin <jilin@nvidia.com>
    usb: gadget: configfs: Fix KASAN use-after-free

Macpaul Lin <macpaul.lin@mediatek.com>
    USB: replace hardcode maximum usb string length by definition

Colin Ian King <colin.king@canonical.com>
    usbip: Fix incorrect double assignment to udc->ud.tcp_rx

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Add quirk to defeat Kindle's automatic unload

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Force inlining of cpu_has_feature() to avoid build failure

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix possible hang when failing to set io queues

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: lpfc: Fix some error codes in debugfs

Pavel Skripkin <paskripkin@gmail.com>
    net/qrtr: fix __netdev_alloc_skb call

Daniel Kobras <kobras@puzzle-itc.de>
    sunrpc: fix refcount leak for rpc auth modules

Timo Rothenpieler <timo@rothenpieler.org>
    svcrdma: disable timeouts on rdma backchannel

Joe Korty <joe.korty@concurrent-rt.com>
    NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

Sagi Grimberg <sagi@grimberg.me>
    nvmet: don't check iosqes,iocqes for discovery controllers

Alexander Shiyan <shc_work@mail.ru>
    ASoC: fsl_ssi: Fix TDM slot setup for I2S mode

David Sterba <dsterba@suse.com>
    btrfs: fix slab cache flags for free space tree bitmap

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race when cloning extent buffer during rewind of an old root

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Check if gettid() is available before providing helper

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build feature: Check if eventfd() is available

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build feature: Check if get_current_dir_name() is available

Jiri Olsa <jolsa@redhat.com>
    perf tools: Use %define api.pure full instead of %pure-parser

Nicolas Boichat <drinkcat@chromium.org>
    lkdtm: don't move ctors to .rodata

Nicolas Boichat <drinkcat@chromium.org>
    vmlinux.lds.h: Create section for protection against instrumentation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "PM: runtime: Update device status before letting suppliers suspend"

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: generic: Fix the micmute led init state

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: Add MODULE_DEVICE_TABLE

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak4458: Add MODULE_DEVICE_TABLE


-------------

Diffstat:

 Makefile                                         |  4 +-
 arch/powerpc/include/asm/cpu_has_feature.h       |  4 +-
 arch/powerpc/kernel/vmlinux.lds.S                |  1 +
 arch/x86/events/intel/ds.c                       |  2 +-
 arch/x86/include/asm/processor.h                 |  9 ----
 arch/x86/include/asm/thread_info.h               | 23 ++++++++-
 arch/x86/kernel/apic/apic.c                      |  5 ++
 arch/x86/kernel/apic/io_apic.c                   | 10 ++++
 arch/x86/kernel/signal.c                         | 24 +--------
 drivers/base/power/runtime.c                     | 62 ++++++++++--------------
 drivers/iio/adc/Kconfig                          |  1 +
 drivers/iio/adc/qcom-spmi-vadc.c                 |  2 +-
 drivers/iio/gyro/mpu3050-core.c                  |  2 +
 drivers/iio/humidity/hid-sensor-humidity.c       | 12 +++--
 drivers/iio/imu/adis16400_core.c                 |  3 +-
 drivers/iio/light/hid-sensor-prox.c              | 13 ++++-
 drivers/iio/temperature/hid-sensor-temperature.c | 14 +++---
 drivers/misc/lkdtm/Makefile                      |  2 +-
 drivers/misc/lkdtm/rodata.c                      |  2 +-
 drivers/nvme/host/rdma.c                         |  7 ++-
 drivers/nvme/target/core.c                       | 17 +++++--
 drivers/pci/hotplug/rpadlpar_sysfs.c             | 14 +++---
 drivers/scsi/lpfc/lpfc_debugfs.c                 |  4 +-
 drivers/usb/gadget/composite.c                   |  4 +-
 drivers/usb/gadget/configfs.c                    | 16 ++++--
 drivers/usb/gadget/usbstring.c                   |  4 +-
 drivers/usb/storage/transport.c                  |  7 +++
 drivers/usb/storage/unusual_devs.h               | 12 +++++
 drivers/usb/usbip/vudc_sysfs.c                   |  2 +-
 fs/btrfs/ctree.c                                 |  2 +
 fs/btrfs/inode.c                                 |  2 +-
 fs/ext4/inode.c                                  |  8 +--
 fs/ext4/namei.c                                  | 29 ++++++++++-
 fs/ext4/xattr.c                                  |  2 +-
 fs/select.c                                      | 10 ++--
 include/asm-generic/sections.h                   |  3 ++
 include/asm-generic/vmlinux.lds.h                | 10 ++++
 include/linux/compiler.h                         | 54 +++++++++++++++++++++
 include/linux/compiler_types.h                   |  6 +++
 include/linux/thread_info.h                      | 13 +++++
 include/linux/usb_usual.h                        |  2 +
 include/uapi/linux/usb/ch9.h                     |  3 ++
 kernel/futex.c                                   |  3 +-
 kernel/irq/manage.c                              |  4 ++
 kernel/time/alarmtimer.c                         |  2 +-
 kernel/time/hrtimer.c                            |  2 +-
 kernel/time/posix-cpu-timers.c                   |  2 +-
 net/qrtr/qrtr.c                                  |  2 +-
 net/sunrpc/svc.c                                 |  6 ++-
 net/sunrpc/svc_xprt.c                            |  4 +-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c       |  6 +--
 scripts/mod/modpost.c                            |  2 +-
 sound/pci/hda/hda_generic.c                      |  2 +-
 sound/soc/codecs/ak4458.c                        |  1 +
 sound/soc/codecs/ak5558.c                        |  1 +
 sound/soc/fsl/fsl_ssi.c                          |  6 ++-
 tools/build/Makefile.feature                     |  3 ++
 tools/build/feature/Makefile                     | 12 +++++
 tools/build/feature/test-all.c                   | 15 ++++++
 tools/build/feature/test-eventfd.c               |  9 ++++
 tools/build/feature/test-get_current_dir_name.c  | 10 ++++
 tools/build/feature/test-gettid.c                | 11 +++++
 tools/perf/Makefile.config                       | 12 +++++
 tools/perf/jvmti/jvmti_agent.c                   |  2 +
 tools/perf/util/Build                            |  1 +
 tools/perf/util/expr.y                           |  3 +-
 tools/perf/util/get_current_dir_name.c           | 18 +++++++
 tools/perf/util/parse-events.y                   |  2 +-
 tools/perf/util/util.h                           |  4 ++
 69 files changed, 420 insertions(+), 151 deletions(-)


