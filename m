Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BA13474D4
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 10:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhCXJkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 05:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236296AbhCXJk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 05:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6A75619AE;
        Wed, 24 Mar 2021 09:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616578827;
        bh=NblXvTCK1kczA0v5OSU/Qs6i7Tfk/QPjTg0/GNr0z5o=;
        h=From:To:Cc:Subject:Date:From;
        b=NgH41FF25aHdvsfAdC1VLzjqdfjjhqwZ3BDAxEZfFB2F/VypxCyIExzSukJAJJGhb
         CRT4sLSXLiwW6WPr6hoEP4mWw/QrO4WrpXalyXXty4KWUbAtYu96zIOrFDrPSn+am9
         e7VDYwhnUcvkaoCtgGtgZnNPha6BdwqHJVi/WmyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/150] 5.10.26-rc3 review
Date:   Wed, 24 Mar 2021 10:40:21 +0100
Message-Id: <20210324093435.962321672@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.26-rc3
X-KernelTest-Deadline: 2021-03-26T09:34+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.26 release.
There are 150 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.26-rc3

Vincent Whitchurch <vincent.whitchurch@axis.com>
    cifs: Fix preauth hash corruption

Johan Hovold <johan@kernel.org>
    x86/apic/of: Fix CPU devicetree-node lookups

Thomas Gleixner <tglx@linutronix.de>
    genirq: Disable interrupts for force threaded handlers

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    firmware/efi: Fix a use after bug in efi_mem_reserve_persistent

Ard Biesheuvel <ardb@kernel.org>
    efi: use 32-bit alignment for efi_guid_t literals

Peter Zijlstra <peterz@infradead.org>
    static_call: Fix static_call_update() sanity check

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    MAINTAINERS: move the staging subsystem to lists.linux.dev

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    MAINTAINERS: move some real subsystems off of the staging mailing list

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    ext4: fix rename whiteout with fast commit

Shijie Luo <luoshijie1@huawei.com>
    ext4: fix potential error in ext4_do_update_inode

zhangyi (F) <yi.zhang@huawei.com>
    ext4: do not try to set xattr into ea_inode if value is empty

Pan Bian <bianpan2016@163.com>
    ext4: stop inode update before return

zhangyi (F) <yi.zhang@huawei.com>
    ext4: find old entry again if failed to rename whiteout

Eric Biggers <ebiggers@google.com>
    ext4: fix error handling in ext4_end_enable_verity()

Shawn Guo <shawn.guo@linaro.org>
    efivars: respect EFI_UNSUPPORTED return from firmware

Oleg Nesterov <oleg@redhat.com>
    x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()

Oleg Nesterov <oleg@redhat.com>
    x86: Move TS_COMPAT back to asm/thread_info.h

Oleg Nesterov <oleg@redhat.com>
    kernel, fs: Introduce and use set_restart_fn() and arch_set_restart_data()

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Ignore IRQ2 again

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix unchecked MSR access error caused by VLBR_EVENT

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix a crash caused by zero PEBS status

Tyrel Datwyler <tyreld@linux.ibm.com>
    PCI: rpadlpar: Fix potential drc_name corruption in store functions

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-timer-cnt: fix ceiling miss-alignment with reload register

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-timer-cnt: fix ceiling write max value

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-temperature: Fix issues of timestamp channel

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-prox: Fix scale not correct issue

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-humidity: Fix alignment issue of timestamp channel

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: adc: adi-axi-adc: add proper Kconfig dependencies

Wilfried Wessner <wilfried.wessner@gmail.com>
    iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask

Linus Walleij <linus.walleij@linaro.org>
    iio: adc: ab8500-gpadc: Fix off by 10 to 3

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iio: gyro: mpu3050: Fix error handling in mpu3050_trigger_handler

Dan Carpenter <dan.carpenter@oracle.com>
    iio: adis16400: Fix an error code in adis16400_initial_setup()

Jonathan Albrieux <jonathan.albrieux@gmail.com>
    iio:adc:qcom-spmi-vadc: add default scale to LR_MUX2_BAT_ID channel

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:stm32-adc: Add HAS_IOMEM dependency

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Increase runtime PM reference count on DP tunnel discovery

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Initialize HopID IDAs in tb_switch_alloc()

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Prevent EP queuing while stopping transfers

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Allow runtime suspend if UDC unbinded

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Invoke power_supply_changed for tcpm-source-psy-

Elias Rudberg <mail@eliasrudberg.se>
    usb: typec: Remove vdo[3] part of tps6598x_rx_identity_reg struct

Jim Lin <jilin@nvidia.com>
    usb: gadget: configfs: Fix KASAN use-after-free

Colin Ian King <colin.king@canonical.com>
    usbip: Fix incorrect double assignment to udc->ud.tcp_rx

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Add quirk to defeat Kindle's automatic unload

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: Force inlining of cpu_has_feature() to avoid build failure

Bob Peterson <rpeterso@redhat.com>
    gfs2: bypass signal_our_withdraw if no journal

Bob Peterson <rpeterso@redhat.com>
    gfs2: move freeze glock outside the make_fs_rw and _ro functions

Bob Peterson <rpeterso@redhat.com>
    gfs2: Add common helper for holding and releasing the freeze glock

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Clear PRESET_EN bit to fix BUCK1/2/3 voltage setting

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Enable system reset on WDOG_B assertion

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Add SD_VSEL GPIO for LDO5

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: bonding: fix error return code of bond_neigh_init()

Jens Axboe <axboe@kernel.dk>
    io_uring: clear IOCB_WAITQ for non -EIOCBQUEUED return

Jens Axboe <axboe@kernel.dk>
    io_uring: don't attempt IO reissue from the ring exit path

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: fulfill the Polaris implementation for get_clock_by_type_with_latency()

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: schedule TX NAPI on QAOB completion

Junlin Yang <yangjunlin@yulong.com>
    ibmvnic: remove excessive irqsave

Ezequiel Garcia <ezequiel@collabora.com>
    media: cedrus: h264: Support profile controls

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix inconsistent lock state

Matti Gottlieb <matti.gottlieb@intel.com>
    iwlwifi: Add a new card for MA family

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: turn DPMS off on connector unplug

Alexander Lobakin <alobakin@pm.me>
    MIPS: compressed: fix build with enabled UBSAN

Christian Melki <christian.melki@t2data.com>
    net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081

Norbert Ciosek <norbertx.ciosek@intel.com>
    i40e: Fix endianness conversions

Sandipan Das <sandipan@linux.ibm.com>
    powerpc/sstep: Fix darn emulation

Sandipan Das <sandipan@linux.ibm.com>
    powerpc/sstep: Fix load-store and update emulation

Mark Bloch <mbloch@nvidia.com>
    RDMA/mlx5: Allow creating all QPs even when non RDMA profile is used

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: isci: Pass gfp_t flags in isci_port_bc_change_received()

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: isci: Pass gfp_t flags in isci_port_link_up()

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: isci: Pass gfp_t flags in isci_port_link_down()

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: mvsas: Pass gfp_t flags to libsas event notifiers

Ahmed S. Darwish <a.darwish@linutronix.de>
    scsi: libsas: Introduce a _gfp() variant of event notifiers

John Garry <john.garry@huawei.com>
    scsi: libsas: Remove notifier indirection

Joe Perches <joe@perches.com>
    scsi: pm8001: Neaten debug logging macros and uses

yuuzheng <yuuzheng@google.com>
    scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp() race condition

Viswas G <Viswas.G@microchip.com>
    scsi: pm80xx: Make running_req atomic

peter chang <dpf@google.com>
    scsi: pm80xx: Make mpi_build_cmd locking consistent

Frank van der Linden <fllinden@amazon.com>
    module: harden ELF info handling

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    module: avoid *goto*s in module_sig_check()

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    module: merge repetitive strings in module_sig_check()

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs: Fix KASAN: stack-out-of-bounds bug

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    RDMA/rtrs: Introduce rtrs_post_send

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    RDMA/rtrs-srv: Jump to dereg_mr label if allocate iu fails

Gioh Kim <gi-oh.kim@cloud.ionos.com>
    RDMA/rtrs: Remove unnecessary argument dir of rtrs_iu_free

Andrii Nakryiko <andrii@kernel.org>
    bpf: Declare __bpf_free_used_maps() unconditionally

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix DMA initialization error handling

Lee Jones <lee.jones@linaro.org>
    tty: serial: stm32-usart: Remove set but unused 'cookie' variables

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: serialize access to work queue on remove

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: add some debugs

Sagi Grimberg <sagi@grimberg.me>
    nvme-rdma: fix possible hang when failing to set io queues

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: Assign fwnode to parent's if no primary one provided

William Breathitt Gray <vilhelm.gray@gmail.com>
    counter: stm32-timer-cnt: Report count function when SLAVE_MODE_DISABLED

Heinrich Schuchardt <xypron.glpk@gmx.de>
    RISC-V: correct enum sbi_ext_rfence_fid

dongjian <dongjian@yulong.com>
    scsi: ufs: ufs-mediatek: Correct operator & -> &&

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    scsi: myrs: Fix a double free in myrs_cleanup()

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: lpfc: Fix some error codes in debugfs

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: Correct SPARSEMEM configuration

Steve French <stfrench@microsoft.com>
    cifs: fix allocation size on newly created files

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL again

Pavel Skripkin <paskripkin@gmail.com>
    net/qrtr: fix __netdev_alloc_skb call

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure that SQPOLL thread is started for exit

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    pstore: Fix warning in pstore_kill_sb()

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    i915/perf: Start hrtimer only if sampling the OA buffer

Daniel Kobras <kobras@puzzle-itc.de>
    sunrpc: fix refcount leak for rpc auth modules

Gautam Dawar <gdawar.xilinx@gmail.com>
    vhost_vdpa: fix the missing irq_bypass_unregister_producer() invocation

Jason Gunthorpe <jgg@ziepe.ca>
    vfio: IOMMU_API should be selected

Timo Rothenpieler <timo@rothenpieler.org>
    svcrdma: disable timeouts on rdma backchannel

Olga Kornievskaia <kolga@netapp.com>
    NFSD: fix dest to src mount in inter-server COPY

Joe Korty <joe.korty@concurrent-rt.com>
    NFSD: Repair misuse of sv_lock in 5.10.16-rt30.

J. Bruce Fields <bfields@redhat.com>
    nfsd: don't abort copies early

Trond Myklebust <trond.myklebust@hammerspace.com>
    nfsd: Don't keep looking up unhashed files in the nfsd file cache

Sagi Grimberg <sagi@grimberg.me>
    nvmet: don't check iosqes,iocqes for discovery controllers

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix a NULL deref when receiving a 0-length r2t PDU

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix possible hang when failing to set io queues

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix misuse of __smp_processor_id with preemption enabled

Christoph Hellwig <hch@lst.de>
    nvme: fix Write Zeroes limitations

Colin Ian King <colin.king@canonical.com>
    ALSA: usb-audio: Fix unintentional sign extension issue

David Howells <dhowells@redhat.com>
    afs: Stop listxattr() from listing "afs.*" attributes

David Howells <dhowells@redhat.com>
    afs: Fix accessing YFS xattrs on a non-YFS server

Sameer Pujar <spujar@nvidia.com>
    ASoC: simple-card-utils: Do not handle device clock

Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
    ASoC: qcom: lpass-cpu: Fix lpass dai ids parse

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wcd934x: add a sanity check in set channel map

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: sdm845: Fix array out of range on rx slim channels

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qcom: sdm845: Fix array out of bounds access

Pan Xiuli <xiuli.pan@linux.intel.com>
    ASoC: SOF: intel: fix wrong poll bits in dsp power down

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: unregister DMIC device on probe error

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Fix HP Pavilion x2 10-p0XX OVCD current threshold

Alexander Shiyan <shc_work@mail.ru>
    ASoC: fsl_ssi: Fix TDM slot setup for I2S mode

Calvin Hou <Calvin.Hou@amd.com>
    drm/amd/display: Correct algorithm for reversed gamma

Stefano Garzarella <sgarzare@redhat.com>
    vhost-vdpa: set v->config_ctx to NULL if eventfd_ctx_fdget() fails

Stefano Garzarella <sgarzare@redhat.com>
    vhost-vdpa: fix use-after-free of v->config_ctx

David Sterba <dsterba@suse.com>
    btrfs: fix slab cache flags for free space tree bitmap

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race when cloning extent buffer during rewind of an old root

Chao Yu <chao@kernel.org>
    zonefs: fix to update .i_wr_refcnt correctly in zonefs_open_zone()

Damien Le Moal <damien.lemoal@wdc.com>
    zonefs: prevent use of seq files as swap file

Damien Le Moal <damien.lemoal@wdc.com>
    zonefs: Fix O_APPEND async write handling

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: fix leak of PCI device structure

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: remove superfluous zdev->zbus check

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: refactor zpci_create_device()

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/vtime: fix increased steal time accounting

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "PM: runtime: Update device status before letting suppliers suspend"

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP 850 G8

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP 440 G8

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP 840 G8

Xiaoliang Yu <yxl_22@outlook.com>
    ALSA: hda/realtek: Apply headset-mic quirks for Xiaomi Redmibook Air

Hui Wang <hui.wang@canonical.com>
    ALSA: hda: generic: Fix the micmute led init state

Xiaoliang Yu <yxl_22@outlook.com>
    ALSA: hda/realtek: apply pin quirk for XiaomiNotebook Pro

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: fix null pointer dereference when node is disconnected

Meng Li <Meng.Li@windriver.com>
    spi: cadence: set cqspi to the driver_data field of struct device

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: Add MODULE_DEVICE_TABLE

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak4458: Add MODULE_DEVICE_TABLE


-------------

Diffstat:

 Documentation/scsi/libsas.rst                      |   10 +-
 MAINTAINERS                                        |    7 +-
 Makefile                                           |   10 +-
 arch/mips/boot/compressed/Makefile                 |    1 +
 arch/powerpc/include/asm/cpu_has_feature.h         |    4 +-
 arch/powerpc/lib/sstep.c                           |   16 +-
 arch/riscv/Kconfig                                 |    4 +-
 arch/riscv/include/asm/sbi.h                       |    4 +-
 arch/s390/include/asm/pci.h                        |    6 +-
 arch/s390/kernel/vtime.c                           |    2 +-
 arch/s390/pci/pci.c                                |   85 +-
 arch/s390/pci/pci_clp.c                            |   40 +-
 arch/s390/pci/pci_event.c                          |   22 +-
 arch/x86/events/intel/core.c                       |    3 +
 arch/x86/events/intel/ds.c                         |    2 +-
 arch/x86/include/asm/processor.h                   |    9 -
 arch/x86/include/asm/thread_info.h                 |   23 +-
 arch/x86/kernel/apic/apic.c                        |    5 +
 arch/x86/kernel/apic/io_apic.c                     |   10 +
 arch/x86/kernel/signal.c                           |   24 +-
 drivers/base/power/runtime.c                       |   62 +-
 drivers/counter/stm32-timer-cnt.c                  |   55 +-
 drivers/firmware/efi/efi.c                         |    3 +-
 drivers/firmware/efi/vars.c                        |    4 +
 drivers/gpio/gpiolib.c                             |    7 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   32 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   13 +
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |    1 +
 .../gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c |   26 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |   67 +
 drivers/gpu/drm/i915/i915_perf.c                   |   13 +-
 drivers/iio/adc/Kconfig                            |    3 +
 drivers/iio/adc/ab8500-gpadc.c                     |    2 +-
 drivers/iio/adc/ad7949.c                           |    2 +-
 drivers/iio/adc/qcom-spmi-vadc.c                   |    2 +-
 drivers/iio/gyro/mpu3050-core.c                    |    2 +
 drivers/iio/humidity/hid-sensor-humidity.c         |   12 +-
 drivers/iio/imu/adis16400.c                        |    3 +-
 drivers/iio/light/hid-sensor-prox.c                |   13 +-
 drivers/iio/temperature/hid-sensor-temperature.c   |   14 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   26 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   14 +-
 drivers/infiniband/ulp/rtrs/rtrs-pri.h             |    3 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   17 +-
 drivers/infiniband/ulp/rtrs/rtrs.c                 |   73 +-
 drivers/net/bonding/bond_main.c                    |    8 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   52 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |    5 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |    2 +-
 drivers/net/phy/micrel.c                           |    1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   11 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    2 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |    6 +
 drivers/nvme/host/core.c                           |   36 +-
 drivers/nvme/host/rdma.c                           |    7 +-
 drivers/nvme/host/tcp.c                            |   16 +-
 drivers/nvme/target/core.c                         |   17 +-
 drivers/pci/hotplug/rpadlpar_sysfs.c               |   14 +-
 drivers/pci/hotplug/s390_pci_hpc.c                 |    3 +-
 drivers/regulator/pca9450-regulator.c              |   30 +
 drivers/s390/net/qeth_core_main.c                  |   18 +-
 drivers/scsi/aic94xx/aic94xx_scb.c                 |   20 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   12 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |    3 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |    3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |    3 +-
 drivers/scsi/isci/port.c                           |   11 +-
 drivers/scsi/libsas/sas_event.c                    |   66 +-
 drivers/scsi/libsas/sas_init.c                     |   27 +-
 drivers/scsi/libsas/sas_internal.h                 |    5 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    4 +-
 drivers/scsi/mvsas/mv_sas.c                        |   25 +-
 drivers/scsi/myrs.c                                |    2 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |    7 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   | 1492 ++++++++---------
 drivers/scsi/pm8001/pm8001_init.c                  |   93 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |  150 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |   47 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   | 1740 +++++++++-----------
 drivers/scsi/ufs/ufs-mediatek.c                    |    2 +-
 drivers/spi/spi-cadence-quadspi.c                  |    1 +
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   19 +
 drivers/thunderbolt/switch.c                       |   18 +-
 drivers/thunderbolt/tb.c                           |    4 +
 drivers/tty/serial/stm32-usart.c                   |   26 +-
 drivers/usb/dwc3/gadget.c                          |   22 +-
 drivers/usb/gadget/configfs.c                      |   14 +-
 drivers/usb/storage/transport.c                    |    7 +
 drivers/usb/storage/unusual_devs.h                 |   12 +
 drivers/usb/typec/tcpm/tcpm.c                      |    9 +-
 drivers/usb/typec/tps6598x.c                       |    1 -
 drivers/usb/usbip/vudc_sysfs.c                     |    2 +-
 drivers/vfio/Kconfig                               |    2 +-
 drivers/vhost/vdpa.c                               |   20 +-
 fs/afs/dir.c                                       |    1 -
 fs/afs/file.c                                      |    1 -
 fs/afs/fs_operation.c                              |    7 +-
 fs/afs/inode.c                                     |    1 -
 fs/afs/internal.h                                  |    1 -
 fs/afs/mntpt.c                                     |    1 -
 fs/afs/xattr.c                                     |   31 +-
 fs/btrfs/ctree.c                                   |    2 +
 fs/btrfs/inode.c                                   |    2 +-
 fs/cifs/inode.c                                    |   10 +-
 fs/cifs/transport.c                                |    7 +-
 fs/ext4/ext4.h                                     |    2 +
 fs/ext4/fast_commit.c                              |    9 +-
 fs/ext4/inode.c                                    |   12 +-
 fs/ext4/namei.c                                    |   32 +-
 fs/ext4/verity.c                                   |   89 +-
 fs/ext4/xattr.c                                    |    2 +-
 fs/gfs2/ops_fstype.c                               |   33 +-
 fs/gfs2/recovery.c                                 |    8 +-
 fs/gfs2/super.c                                    |   45 +-
 fs/gfs2/util.c                                     |   58 +-
 fs/gfs2/util.h                                     |    3 +
 fs/io_uring.c                                      |   19 +-
 fs/nfsd/filecache.c                                |    2 +
 fs/nfsd/nfs4proc.c                                 |    2 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/pstore/inode.c                                  |    2 +-
 fs/select.c                                        |   10 +-
 fs/zonefs/super.c                                  |  101 +-
 include/linux/bpf.h                                |    5 +-
 include/linux/efi.h                                |    6 +-
 include/linux/regulator/pca9450.h                  |   10 +
 include/linux/thread_info.h                        |   13 +
 include/linux/usb_usual.h                          |    2 +
 include/scsi/libsas.h                              |   11 +-
 kernel/futex.c                                     |    3 +-
 kernel/irq/manage.c                                |    4 +
 kernel/jump_label.c                                |    8 +
 kernel/module.c                                    |  166 +-
 kernel/module_signature.c                          |    2 +-
 kernel/module_signing.c                            |    2 +-
 kernel/static_call.c                               |   11 +-
 kernel/time/alarmtimer.c                           |    2 +-
 kernel/time/hrtimer.c                              |    2 +-
 kernel/time/posix-cpu-timers.c                     |    2 +-
 net/qrtr/qrtr.c                                    |    2 +-
 net/sunrpc/svc.c                                   |    6 +-
 net/sunrpc/svc_xprt.c                              |    4 +-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c         |    6 +-
 sound/firewire/dice/dice-stream.c                  |    5 +-
 sound/pci/hda/hda_generic.c                        |    2 +-
 sound/pci/hda/patch_realtek.c                      |   16 +
 sound/soc/codecs/ak4458.c                          |    1 +
 sound/soc/codecs/ak5558.c                          |    1 +
 sound/soc/codecs/wcd934x.c                         |    6 +
 sound/soc/fsl/fsl_ssi.c                            |    6 +-
 sound/soc/generic/simple-card-utils.c              |   13 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |    2 +-
 sound/soc/qcom/lpass-cpu.c                         |    2 +-
 sound/soc/qcom/sdm845.c                            |    6 +-
 sound/soc/sof/intel/hda-dsp.c                      |    2 +-
 sound/soc/sof/intel/hda.c                          |    1 +
 sound/usb/mixer_quirks.c                           |    4 +-
 158 files changed, 2994 insertions(+), 2700 deletions(-)


