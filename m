Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C27259B20
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732306AbgIAQ57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729753AbgIAPWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:22:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 078082078B;
        Tue,  1 Sep 2020 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973760;
        bh=42a4MP8p5ZFdyTlJWdSCBogvHFTDs6e9tndJDBK/f7U=;
        h=From:To:Cc:Subject:Date:From;
        b=WPZ9zHYnrq6IJcWxn/k3+bjNDP9gVZ66MJgVbPgik7wFnF9hhIANM2S0HEcyzqna4
         i+nMRBfSHTZDLUbZBrucp6PwqGIyfdcXYYWSXE7MuZXTgRMrGi5MDxZZqpLoZ6fSDK
         bvO/GAPE6PdC203kcRAeVP7P7xQmxYkHZrY52Ek4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/125] 4.19.143-rc1 review
Date:   Tue,  1 Sep 2020 17:09:15 +0200
Message-Id: <20200901150934.576210879@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.143-rc1
X-KernelTest-Deadline: 2020-09-03T15:09+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.143 release.
There are 125 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.143-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.143-rc1

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: Update documentation comment for MS2109 quirk

Peilin Ye <yepeilin.cs@gmail.com>
    HID: hiddev: Fix slab-out-of-bounds write in hiddev_ioctl_usage()

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    tpm: Unify the mismatching TPM space buffer sizes

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Handle ZLP for sg requests

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix handling ZLP

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't setup more than requested

Josef Bacik <josef@toxicpanda.com>
    btrfs: check the right error variable in btrfs_del_dir_entries_in_log

Alan Stern <stern@rowland.harvard.edu>
    usb: storage: Add unusual_uas entry for Sony PSZ drives

Tom Rix <trix@redhat.com>
    USB: cdc-acm: rework notification_buffer resizing

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    USB: gadget: u_f: Unbreak offset calculation in VLAs

Brooke Basile <brookebasile@gmail.com>
    USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()

Brooke Basile <brookebasile@gmail.com>
    USB: gadget: u_f: add overflow checks to VLA macros

Tang Bin <tangbin@cmss.chinamobile.com>
    usb: host: ohci-exynos: Fix error handling in exynos_ohci_probe()

Cyril Roelandt <tipecaml@gmail.com>
    USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge

Alan Stern <stern@rowland.harvard.edu>
    USB: quirks: Ignore duplicate endpoint on Sound Devices MixPre-D

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: quirks: Add no-lpm quirk for another Raydium touchscreen

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: uas: Add quirk for PNY Pro Elite

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Fix bad gfp argument

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct Vega12 swctf limit setting

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct Vega10 swctf limit setting

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Fix buffer overflow in INFO ioctl

qiuguorui1 <qiuguorui1@huawei.com>
    irqchip/stm32-exti: Avoid losing interrupts due to clearing pending bits by mistake

Thomas Gleixner <tglx@linutronix.de>
    genirq/matrix: Deal with the sillyness of for_each_cpu() on UP

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    device property: Fix the secondary firmware node handling in set_primary_fwnode()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Fix the handling of pending runtime resume requests

Ding Hui <dinghui@sangfor.com.cn>
    xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Do warm-reset when both CAS and XDEV_RESUME are set

Li Jun <jun.li@nxp.com>
    usb: host: xhci: fix ep context print mismatch in debugfs

Thomas Gleixner <tglx@linutronix.de>
    XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.

Jan Kara <jack@suse.cz>
    writeback: Fix sync livelock due to b_dirty_time processing

Jan Kara <jack@suse.cz>
    writeback: Avoid skipping inode writeback

Jan Kara <jack@suse.cz>
    writeback: Protect inode->i_io_list with inode->i_lock

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    serial: 8250: change lock order in serial8250_do_startup()

Valmer Huhn <valmer.huhn@concurrent-rt.com>
    serial: 8250_exar: Fix number of ports for Commtech PCIe cards

Lukas Wunner <lukas@wunner.de>
    serial: pl011: Don't leak amba_ports entry on driver register error

Lukas Wunner <lukas@wunner.de>
    serial: pl011: Fix oops on -EPROBE_DEFER

Tamseel Shams <m.shams@samsung.com>
    serial: samsung: Removes the IRQ not found warning

George Kennedy <george.kennedy@oracle.com>
    vt_ioctl: change VT_RESIZEX ioctl to check for error return from vc_resize()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    vt: defer kfree() of vc_screenbuf in vc_do_resize()

Evgeny Novikov <novikov@ispras.ru>
    USB: lvtest: return proper error code in probe

George Kennedy <george.kennedy@oracle.com>
    fbcon: prevent user font height or width change from causing potential out-of-bounds access

Filipe Manana <fdmanana@suse.com>
    btrfs: fix space cache memory leak after transaction abort

Marcos Paulo de Souza <mpdesouza@suse.com>
    btrfs: reset compression level for lzo on remount

Ming Lei <ming.lei@redhat.com>
    blk-mq: order adding requests to hctx->dispatch and checking SCHED_RESTART

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Always sleep 60ms after I2C_HID_PWR_ON commands

Ming Lei <ming.lei@redhat.com>
    block: loop: set discard granularity and alignment for block device backed loop

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix soft lockups due to missed interrupt accounting

Sumera Priyadarsini <sylphrenadin@gmail.com>
    net: gianfar: Add of_node_put() before goto statement

Alvin Šipraga <alsi@bang-olufsen.dk>
    macvlan: validate setting of multiple remote source MAC addresses

Saurav Kashyap <skashyap@marvell.com>
    Revert "scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix null pointer access during disconnect from subsystem

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Check if FW supports MQ before enabling

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Clean up completed request without interrupt notification

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: Improve interrupt handling for shared interrupts

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix possible infinite loop in ufshcd_hold

Mike Christie <michael.christie@oracle.com>
    scsi: fcoe: Fix I/O path allocation

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: wm8994: Avoid attempts to read unreadable registers

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: add cond_resched() in the slow_eval_known_fn() loop

Amelie Delaunay <amelie.delaunay@st.com>
    spi: stm32: fix stm32_spi_prepare_mbr in case of odd clk_rate

Xianting Tian <xianting_tian@126.com>
    fs: prevent BUG_ON in submit_bh_wbc()

Jan Kara <jack@suse.cz>
    ext4: correctly restore system zone info when remount fails

Jan Kara <jack@suse.cz>
    ext4: handle error of ext4_setup_system_zone() on remount

Lukas Czerner <lczerner@redhat.com>
    ext4: handle option set by mount flags correctly

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: abort journal if free a async write error metadata buffer

Lukas Czerner <lczerner@redhat.com>
    ext4: handle read only external journal device

Jan Kara <jack@suse.cz>
    ext4: don't BUG on inconsistent journal feature

Lukas Czerner <lczerner@redhat.com>
    jbd2: make sure jh have b_transaction set in refile/unfile_buffer

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: f_tcm: Fix some resource leaks in some error paths

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: in slave mode, clear NACK earlier

Hou Pu <houpu@bytedance.com>
    null_blk: fix passing of REQ_FUA flag in null_handle_rq

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    nvme-fc: Fix wrong return value in __nvme_fc_init_request()

Rob Clark <robdclark@chromium.org>
    drm/msm/adreno: fix updating ring fence

Sean Young <sean@mess.org>
    media: gpio-ir-tx: improve precision of transmitted signal due to scheduling

Zhi Chen <zhichen@codeaurora.org>
    Revert "ath10k: fix DMA related firmware crashes on multiple devices"

Andrey Konovalov <andreyknvl@google.com>
    efi: provide empty efi_enter_virtual_mode implementation

Changming Liu <charley.ashbringer@gmail.com>
    USB: sisusbvga: Fix a potential UB casued by left shifting a negative value

Arnd Bergmann <arnd@arndb.de>
    powerpc/spufs: add CONFIG_COREDUMP dependency

David Brazdil <dbrazdil@google.com>
    KVM: arm64: Fix symbol dependency in __hyp_call_panic_nvhe

Evgeny Novikov <novikov@ispras.ru>
    media: davinci: vpif_capture: fix potential double free

Jason Baron <jbaron@akamai.com>
    EDAC/ie31200: Fallback if host bridge device is already initialized

Javed Hasan <jhasan@marvell.com>
    scsi: fcoe: Memory leak fix in fcoe_sysfs_fcf_del()

Xiubo Li <xiubli@redhat.com>
    ceph: fix potential mdsc use-after-free crash

Jing Xiangfeng <jingxiangfeng@huawei.com>
    scsi: iscsi: Do not put host in iscsi_set_flashnode_param()

Qu Wenruo <wqu@suse.com>
    btrfs: file: reserve qgroup space after the hole punch range is locked

Chris Wilson <chris@chris-wilson.co.uk>
    locking/lockdep: Fix overflow in presentation of average lock-time

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: Fix reference count leak in nouveau_connector_detect

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: fix reference count leak in nv50_disp_atomic_commit

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau/drm/noveau: fix reference count leak in nouveau_fbcon_open

Li Guifu <bluce.liguifu@huawei.com>
    f2fs: fix use-after-free issue

Ikjoon Jang <ikjn@chromium.org>
    HID: quirks: add NOGET quirk for Logitech GROUP

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    cec-api: prevent leaking memory through hole in structure

Peng Fan <fanpeng@loongson.cn>
    mips/vdso: Fix resource leaks in genvdso.c

Reto Schneider <code@reto-schneider.ch>
    rtlwifi: rtl8192cu: Prevent leaking urb

Yangbo Lu <yangbo.lu@nxp.com>
    ARM: dts: ls1021a: output PPS signal on FIPER2

Qiushi Wu <wu000273@umn.edu>
    PCI: Fix pci_create_slot() reference count leak

Aditya Pakki <pakki001@umn.edu>
    omapfb: fix multiple reference count leaks due to pm_runtime_get_sync

Chao Yu <yuchao0@huawei.com>
    f2fs: fix error path in do_recover_data()

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    selftests/powerpc: Purge extra count_pmc() calls of ebb selftests

Dave Chinner <dchinner@redhat.com>
    xfs: Don't allow logging of XFS_ISTALE inodes

Dick Kennedy <dick.kennedy@broadcom.com>
    scsi: lpfc: Fix shost refcount mismatch when deleting vport

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amdgpu/display: fix ref count leak when pm_runtime_get_sync fails

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amdgpu: fix ref count leak in amdgpu_display_crtc_set_config

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amd/display: fix ref count leak in amdgpu_drm_ioctl

Navid Emamdoost <navid.emamdoost@gmail.com>
    drm/amdgpu: fix ref count leak in amdgpu_driver_open_kms

Aditya Pakki <pakki001@umn.edu>
    drm/radeon: fix multiple reference count leak

Qiushi Wu <wu000273@umn.edu>
    drm/amdkfd: Fix reference count leaks.

Robin Murphy <robin.murphy@arm.com>
    iommu/iova: Don't BUG on invalid PFNs

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Fix crash on ARM during cmd completion

Luis Chamberlain <mcgrof@kernel.org>
    blktrace: ensure our debugfs dir exists

Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
    media: pci: ttpci: av7110: fix possible buffer overflow caused by bad DMA value in debiirq()

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/xive: Ignore kmemleak false positives

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Pull down PDM GPIOs during sleep

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Add Intel Emmitsburg PCH PCI IDs

Qiushi Wu <wu000273@umn.edu>
    ASoC: tegra: Fix reference count leaks.

Qiushi Wu <wu000273@umn.edu>
    ASoC: img-parallel-out: Fix a reference count leak

Qiushi Wu <wu000273@umn.edu>
    ASoC: img: Fix a reference count leak in img_i2s_in_set_fmt

Randy Dunlap <rdunlap@infradead.org>
    ALSA: pci: delete repeated words in comments

Mahesh Bandewar <maheshb@google.com>
    ipvlan: fix device features

Shay Agroskin <shayagr@amazon.com>
    net: ena: Make missed_tx stat incremental

Cong Wang <xiyou.wangcong@gmail.com>
    tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

Peilin Ye <yepeilin.cs@gmail.com>
    net/smc: Prevent kernel-infoleak in __smc_diag_dump()

Necip Fazil Yildiran <necip@google.com>
    net: qrtr: fix usage of idr in port assignment to socket

Miaohe Lin <linmiaohe@huawei.com>
    net: Fix potential wrong skb->protocol in skb_vlan_untag()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Don't init FSCR_DSCR in __init_FSCR()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/ls1021a.dtsi                     |   2 +-
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi         |   2 +-
 arch/arm64/kvm/hyp/switch.c                        |   2 +-
 arch/mips/vdso/genvdso.c                           |  10 ++
 arch/powerpc/kernel/cpu_setup_power.S              |   2 +-
 arch/powerpc/perf/core-book3s.c                    |   4 +
 arch/powerpc/platforms/cell/Kconfig                |   1 +
 arch/powerpc/sysdev/xive/native.c                  |   2 +
 block/blk-mq-sched.c                               |   9 ++
 block/blk-mq.c                                     |   9 ++
 drivers/base/core.c                                |  12 +-
 drivers/base/power/main.c                          |  16 +-
 drivers/block/loop.c                               |  33 ++--
 drivers/block/null_blk_main.c                      |   2 +-
 drivers/char/tpm/tpm-chip.c                        |   9 +-
 drivers/char/tpm/tpm.h                             |   6 +-
 drivers/char/tpm/tpm2-space.c                      |  26 +--
 drivers/char/tpm/tpmrm-dev.c                       |   2 +-
 drivers/edac/ie31200_edac.c                        |  50 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   7 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |  20 ++-
 .../gpu/drm/amd/powerplay/hwmgr/vega10_thermal.c   |   7 +-
 .../gpu/drm/amd/powerplay/hwmgr/vega12_thermal.c   |   6 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |   4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  20 ++-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  22 +--
 drivers/hid/usbhid/hiddev.c                        |   4 +
 drivers/i2c/busses/i2c-rcar.c                      |   1 +
 drivers/iommu/iova.c                               |   4 +-
 drivers/irqchip/irq-stm32-exti.c                   |  14 +-
 drivers/media/cec/cec-api.c                        |   8 +-
 drivers/media/pci/ttpci/av7110.c                   |   5 +-
 drivers/media/platform/davinci/vpif_capture.c      |   2 -
 drivers/media/rc/gpio-ir-tx.c                      |   7 +-
 drivers/mfd/intel-lpss-pci.c                       |   3 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   5 +-
 drivers/net/ethernet/freescale/gianfar.c           |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |   2 +-
 drivers/net/ipvlan/ipvlan_main.c                   |  27 +++-
 drivers/net/macvlan.c                              |  21 ++-
 drivers/net/wireless/ath/ath10k/hw.h               |   2 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   5 +-
 drivers/nvme/host/fc.c                             |   4 +-
 drivers/pci/slot.c                                 |   6 +-
 drivers/s390/cio/css.c                             |   5 +
 drivers/scsi/fcoe/fcoe_ctlr.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |  26 +--
 drivers/scsi/qla2xxx/qla_mbx.c                     |   8 -
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +
 drivers/scsi/qla2xxx/qla_os.c                      |   5 +
 drivers/scsi/scsi_transport_iscsi.c                |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  14 +-
 drivers/spi/spi-stm32.c                            |   3 +-
 drivers/target/target_core_user.c                  |   9 +-
 drivers/tty/serial/8250/8250_exar.c                |  24 ++-
 drivers/tty/serial/8250/8250_port.c                |   9 +-
 drivers/tty/serial/amba-pl011.c                    |  16 +-
 drivers/tty/serial/samsung.c                       |   8 +-
 drivers/tty/vt/vt.c                                |   5 +-
 drivers/tty/vt/vt_ioctl.c                          |  12 +-
 drivers/usb/class/cdc-acm.c                        |  22 ++-
 drivers/usb/core/quirks.c                          |   7 +
 drivers/usb/dwc3/gadget.c                          | 104 +++++++++---
 drivers/usb/gadget/function/f_ncm.c                |  81 ++++++++--
 drivers/usb/gadget/function/f_tcm.c                |   7 +-
 drivers/usb/gadget/u_f.h                           |  38 +++--
 drivers/usb/host/ohci-exynos.c                     |   5 +-
 drivers/usb/host/xhci-debugfs.c                    |   8 +-
 drivers/usb/host/xhci-hub.c                        |  19 +--
 drivers/usb/host/xhci.c                            |   3 +-
 drivers/usb/misc/lvstest.c                         |   2 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |   2 +-
 drivers/usb/misc/yurex.c                           |   2 +-
 drivers/usb/storage/unusual_devs.h                 |   2 +-
 drivers/usb/storage/unusual_uas.h                  |  14 ++
 drivers/video/fbdev/core/fbcon.c                   |  25 ++-
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c       |   7 +-
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c         |   7 +-
 drivers/video/fbdev/omap2/omapfb/dss/dss.c         |   7 +-
 drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c       |   5 +-
 drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c       |   5 +-
 drivers/video/fbdev/omap2/omapfb/dss/venc.c        |   7 +-
 drivers/xen/events/events_base.c                   |  16 +-
 fs/btrfs/disk-io.c                                 |   1 +
 fs/btrfs/file.c                                    |   8 +-
 fs/btrfs/free-space-cache.c                        |   2 +-
 fs/btrfs/super.c                                   |   1 +
 fs/btrfs/tree-log.c                                |  10 +-
 fs/buffer.c                                        |   9 ++
 fs/ceph/mds_client.c                               |  14 +-
 fs/ext4/block_validity.c                           |   8 -
 fs/ext4/super.c                                    | 175 ++++++++++++++-------
 fs/f2fs/f2fs.h                                     |   4 +-
 fs/f2fs/inline.c                                   |  19 ++-
 fs/f2fs/node.c                                     |   6 +-
 fs/f2fs/recovery.c                                 |  10 +-
 fs/f2fs/super.c                                    |   5 +-
 fs/fs-writeback.c                                  |  83 +++++-----
 fs/jbd2/transaction.c                              |  26 +++
 fs/xfs/xfs_icache.c                                |   3 +-
 fs/xfs/xfs_inode.c                                 |  25 ++-
 fs/xfs/xfs_trans_inode.c                           |   2 +
 include/linux/efi.h                                |   4 +
 include/linux/fs.h                                 |   8 +-
 include/trace/events/writeback.h                   |  13 +-
 kernel/irq/matrix.c                                |   7 +
 kernel/locking/lockdep_proc.c                      |   2 +-
 kernel/trace/blktrace.c                            |  12 ++
 net/core/skbuff.c                                  |   4 +-
 net/ipv6/ip6_tunnel.c                              |  10 +-
 net/qrtr/qrtr.c                                    |  20 +--
 net/smc/smc_diag.c                                 |  16 +-
 net/tipc/netlink_compat.c                          |  12 +-
 sound/pci/cs46xx/cs46xx_lib.c                      |   2 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |   2 +-
 sound/pci/hda/hda_codec.c                          |   2 +-
 sound/pci/hda/hda_generic.c                        |   2 +-
 sound/pci/hda/patch_sigmatel.c                     |   2 +-
 sound/pci/ice1712/prodigy192.c                     |   2 +-
 sound/pci/oxygen/xonar_dg.c                        |   2 +-
 sound/soc/codecs/wm8958-dsp2.c                     |   4 +
 sound/soc/img/img-i2s-in.c                         |   4 +-
 sound/soc/img/img-parallel-out.c                   |   4 +-
 sound/soc/tegra/tegra30_ahub.c                     |   4 +-
 sound/soc/tegra/tegra30_i2s.c                      |   4 +-
 sound/usb/quirks-table.h                           |   4 +-
 .../powerpc/pmu/ebb/back_to_back_ebbs_test.c       |   2 -
 .../selftests/powerpc/pmu/ebb/cycles_test.c        |   2 -
 .../powerpc/pmu/ebb/cycles_with_freeze_test.c      |   2 -
 .../powerpc/pmu/ebb/cycles_with_mmcr2_test.c       |   2 -
 tools/testing/selftests/powerpc/pmu/ebb/ebb.c      |   2 -
 .../powerpc/pmu/ebb/ebb_on_willing_child_test.c    |   2 -
 .../powerpc/pmu/ebb/lost_exception_test.c          |   1 -
 .../selftests/powerpc/pmu/ebb/multi_counter_test.c |   7 -
 .../powerpc/pmu/ebb/multi_ebb_procs_test.c         |   2 -
 .../selftests/powerpc/pmu/ebb/pmae_handling_test.c |   2 -
 .../powerpc/pmu/ebb/pmc56_overflow_test.c          |   2 -
 146 files changed, 1106 insertions(+), 474 deletions(-)


