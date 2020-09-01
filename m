Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5CA259C5C
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgIAROJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728779AbgIAPP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:15:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D11020BED;
        Tue,  1 Sep 2020 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973326;
        bh=1J5YDQAXNIv7w37V3IfQB0WaMa7S5OTI69zbQxz12+I=;
        h=From:To:Cc:Subject:Date:From;
        b=QZ/HGhOW7pE1PPNVfpwzZ2fke+T41wRkrclM6xNhMwFLSsfyxqVKGWX5sfhwRfPwA
         g72AQxfrvV0/nIVHU3ta2/dd495g4BbqpUAw1L9+R1GHlFLo3bHPYXCG8Kpa3+6bCe
         CBwci7OIQzTCCaxXvzFDcTONCsL3/G7hLmQcJ74s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/78] 4.9.235-rc1 review
Date:   Tue,  1 Sep 2020 17:09:36 +0200
Message-Id: <20200901150924.680106554@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.235-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.235-rc1
X-KernelTest-Deadline: 2020-09-03T15:09+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.235 release.
There are 78 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.235-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.235-rc1

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: Update documentation comment for MS2109 quirk

Peilin Ye <yepeilin.cs@gmail.com>
    HID: hiddev: Fix slab-out-of-bounds write in hiddev_ioctl_usage()

Josef Bacik <josef@toxicpanda.com>
    btrfs: check the right error variable in btrfs_del_dir_entries_in_log

Alan Stern <stern@rowland.harvard.edu>
    usb: storage: Add unusual_uas entry for Sony PSZ drives

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    USB: gadget: u_f: Unbreak offset calculation in VLAs

Brooke Basile <brookebasile@gmail.com>
    USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()

Brooke Basile <brookebasile@gmail.com>
    USB: gadget: u_f: add overflow checks to VLA macros

Kees Cook <keescook@chromium.org>
    overflow.h: Add allocation size calculation helpers

Tang Bin <tangbin@cmss.chinamobile.com>
    usb: host: ohci-exynos: Fix error handling in exynos_ohci_probe()

Cyril Roelandt <tipecaml@gmail.com>
    USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: quirks: Add no-lpm quirk for another Raydium touchscreen

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: uas: Add quirk for PNY Pro Elite

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Fix bad gfp argument

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    device property: Fix the secondary firmware node handling in set_primary_fwnode()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Fix the handling of pending runtime resume requests

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Do warm-reset when both CAS and XDEV_RESUME are set

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

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Always sleep 60ms after I2C_HID_PWR_ON commands

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix soft lockups due to missed interrupt accounting

Sumera Priyadarsini <sylphrenadin@gmail.com>
    net: gianfar: Add of_node_put() before goto statement

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: Improve interrupt handling for shared interrupts

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix possible infinite loop in ufshcd_hold

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: add cond_resched() in the slow_eval_known_fn() loop

Xianting Tian <xianting_tian@126.com>
    fs: prevent BUG_ON in submit_bh_wbc()

zhangyi (F) <yi.zhang@huawei.com>
    jbd2: abort journal if free a async write error metadata buffer

Lukas Czerner <lczerner@redhat.com>
    jbd2: make sure jh have b_transaction set in refile/unfile_buffer

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: f_tcm: Fix some resource leaks in some error paths

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: in slave mode, clear NACK earlier

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

Chris Wilson <chris@chris-wilson.co.uk>
    locking/lockdep: Fix overflow in presentation of average lock-time

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau: Fix reference count leak in nouveau_connector_detect

Aditya Pakki <pakki001@umn.edu>
    drm/nouveau/drm/noveau: fix reference count leak in nouveau_fbcon_open

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    cec-api: prevent leaking memory through hole in structure

Peng Fan <fanpeng@loongson.cn>
    mips/vdso: Fix resource leaks in genvdso.c

Reto Schneider <code@reto-schneider.ch>
    rtlwifi: rtl8192cu: Prevent leaking urb

Qiushi Wu <wu000273@umn.edu>
    PCI: Fix pci_create_slot() reference count leak

Aditya Pakki <pakki001@umn.edu>
    omapfb: fix multiple reference count leaks due to pm_runtime_get_sync

Desnes A. Nunes do Rosario <desnesn@linux.ibm.com>
    selftests/powerpc: Purge extra count_pmc() calls of ebb selftests

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

Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
    media: pci: ttpci: av7110: fix possible buffer overflow caused by bad DMA value in debiirq()

Stephan Gerhold <stephan@gerhold.net>
    arm64: dts: qcom: msm8916: Pull down PDM GPIOs during sleep

Qiushi Wu <wu000273@umn.edu>
    ASoC: tegra: Fix reference count leaks.

Randy Dunlap <rdunlap@infradead.org>
    ALSA: pci: delete repeated words in comments

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gre6: Fix reception with IP6_TNL_F_RCV_DSCP_COPY

Mahesh Bandewar <maheshb@google.com>
    ipvlan: fix device features

Cong Wang <xiyou.wangcong@gmail.com>
    tipc: fix uninit skb->data in tipc_nl_compat_dumpit()

Miaohe Lin <linmiaohe@huawei.com>
    net: Fix potential wrong skb->protocol in skb_vlan_untag()

Jarod Wilson <jarod@redhat.com>
    bonding: show saner speed for broadcast mode

Cong Wang <xiyou.wangcong@gmail.com>
    bonding: fix a potential double-unregister


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi         |  2 +-
 arch/arm64/kvm/hyp/switch.c                        |  2 +-
 arch/mips/vdso/genvdso.c                           | 10 +++
 arch/powerpc/perf/core-book3s.c                    |  4 ++
 arch/powerpc/platforms/cell/Kconfig                |  1 +
 drivers/base/core.c                                | 12 ++--
 drivers/base/power/main.c                          | 16 +++--
 drivers/edac/ie31200_edac.c                        | 50 ++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     | 16 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |  5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          | 20 ++++--
 drivers/gpu/drm/nouveau/nouveau_connector.c        |  4 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |  4 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         | 20 ++++--
 drivers/hid/i2c-hid/i2c-hid-core.c                 | 22 +++---
 drivers/hid/usbhid/hiddev.c                        |  4 ++
 drivers/i2c/busses/i2c-rcar.c                      |  1 +
 drivers/iommu/iova.c                               |  4 +-
 drivers/md/dm-table.c                              | 10 +--
 drivers/media/pci/ttpci/av7110.c                   |  5 +-
 drivers/media/platform/davinci/vpif_capture.c      |  2 -
 drivers/net/bonding/bond_main.c                    | 24 +++++--
 drivers/net/ethernet/freescale/gianfar.c           |  4 +-
 drivers/net/ipvlan/ipvlan_main.c                   | 25 +++++--
 drivers/net/wireless/ath/ath10k/hw.h               |  2 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  5 +-
 drivers/pci/slot.c                                 |  6 +-
 drivers/s390/cio/css.c                             |  5 ++
 drivers/scsi/fcoe/fcoe_ctlr.c                      |  2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     | 26 +++----
 drivers/scsi/scsi_transport_iscsi.c                |  2 +-
 drivers/scsi/ufs/ufshcd.c                          | 11 +--
 drivers/staging/media/cec/cec-api.c                |  8 ++-
 drivers/target/target_core_user.c                  |  9 ++-
 drivers/tty/serial/8250/8250_port.c                |  9 ++-
 drivers/tty/serial/amba-pl011.c                    | 16 +++--
 drivers/tty/serial/samsung.c                       |  8 ++-
 drivers/tty/vt/vt.c                                |  5 +-
 drivers/tty/vt/vt_ioctl.c                          | 12 +++-
 drivers/usb/core/quirks.c                          |  2 +
 drivers/usb/gadget/function/f_ncm.c                | 81 +++++++++++++++++----
 drivers/usb/gadget/function/f_tcm.c                |  7 +-
 drivers/usb/gadget/u_f.h                           | 38 +++++++---
 drivers/usb/host/ohci-exynos.c                     |  5 +-
 drivers/usb/host/xhci-hub.c                        | 19 ++---
 drivers/usb/misc/lvstest.c                         |  2 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |  2 +-
 drivers/usb/misc/yurex.c                           |  2 +-
 drivers/usb/storage/unusual_devs.h                 |  2 +-
 drivers/usb/storage/unusual_uas.h                  | 14 ++++
 drivers/video/console/fbcon.c                      | 25 ++++++-
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c       |  7 +-
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c         |  7 +-
 drivers/video/fbdev/omap2/omapfb/dss/dss.c         |  7 +-
 drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c       |  5 +-
 drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c       |  5 +-
 drivers/video/fbdev/omap2/omapfb/dss/venc.c        |  7 +-
 drivers/xen/events/events_base.c                   | 16 ++---
 fs/btrfs/disk-io.c                                 |  1 +
 fs/btrfs/free-space-cache.c                        |  2 +-
 fs/btrfs/tree-log.c                                | 10 +--
 fs/buffer.c                                        |  9 +++
 fs/ceph/mds_client.c                               | 14 +++-
 fs/ext4/super.c                                    |  7 --
 fs/fs-writeback.c                                  | 83 ++++++++++++----------
 fs/jbd2/transaction.c                              | 26 +++++++
 include/linux/efi.h                                |  4 ++
 include/linux/fs.h                                 |  8 ++-
 include/linux/overflow.h                           | 73 +++++++++++++++++++
 include/trace/events/writeback.h                   | 13 ++--
 kernel/locking/lockdep_proc.c                      |  2 +-
 net/core/skbuff.c                                  |  4 +-
 net/ipv6/ip6_tunnel.c                              | 10 ++-
 net/tipc/netlink_compat.c                          | 12 +++-
 sound/pci/cs46xx/cs46xx_lib.c                      |  2 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |  2 +-
 sound/pci/hda/hda_codec.c                          |  2 +-
 sound/pci/hda/hda_generic.c                        |  2 +-
 sound/pci/hda/patch_sigmatel.c                     |  2 +-
 sound/pci/ice1712/prodigy192.c                     |  2 +-
 sound/pci/oxygen/xonar_dg.c                        |  2 +-
 sound/soc/tegra/tegra30_ahub.c                     |  4 +-
 sound/soc/tegra/tegra30_i2s.c                      |  4 +-
 sound/usb/quirks-table.h                           |  4 +-
 .../powerpc/pmu/ebb/back_to_back_ebbs_test.c       |  2 -
 .../selftests/powerpc/pmu/ebb/cycles_test.c        |  2 -
 .../powerpc/pmu/ebb/cycles_with_freeze_test.c      |  2 -
 .../powerpc/pmu/ebb/cycles_with_mmcr2_test.c       |  2 -
 tools/testing/selftests/powerpc/pmu/ebb/ebb.c      |  2 -
 .../powerpc/pmu/ebb/ebb_on_willing_child_test.c    |  2 -
 .../powerpc/pmu/ebb/lost_exception_test.c          |  1 -
 .../selftests/powerpc/pmu/ebb/multi_counter_test.c |  7 --
 .../powerpc/pmu/ebb/multi_ebb_procs_test.c         |  2 -
 .../selftests/powerpc/pmu/ebb/pmae_handling_test.c |  2 -
 .../powerpc/pmu/ebb/pmc56_overflow_test.c          |  2 -
 98 files changed, 710 insertions(+), 276 deletions(-)


