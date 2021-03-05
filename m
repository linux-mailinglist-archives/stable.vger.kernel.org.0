Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481DA32EA51
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhCEMhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhCEMhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:37:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E99FE65012;
        Fri,  5 Mar 2021 12:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947850;
        bh=sBu1sFHW7dEi+mzmTadccIDVwo63SowL+d2vF4IWrqA=;
        h=From:To:Cc:Subject:Date:From;
        b=D9Hm9wrGy6f8N8JAXkaM6zzW7g03zA3pomIAWIde4Xdx/qmamGsHOnChEG+lDRlP9
         +r4fBtw79Hqsaq7Z8FPjATgtZ1UqOoYlKLHjY8IxAYlZWXGHdli0Kd1ed8G9aluP3E
         +UMWRnXIe1zVKo3d2LR0lSO097RdF73eyT0wcJBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.19 00/52] 4.19.179-rc1 review
Date:   Fri,  5 Mar 2021 13:21:31 +0100
Message-Id: <20210305120853.659441428@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.179-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.179-rc1
X-KernelTest-Deadline: 2021-03-07T12:08+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.179 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.179-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.179-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Apply dual codec quirks for MSI Godlike X570 board

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Clevo NH55RZQ

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: ioctl: Fix memory leak in video_usercopy

Jens Axboe <axboe@kernel.dk>
    swap: fix swapfile read/write offset

Rokudo Yan <wu-yan@tcl.com>
    zsmalloc: account the number of compacted pages correctly

Jan Beulich <jbeulich@suse.com>
    xen-netback: respect gnttab_map_refs()'s return value

Jan Beulich <jbeulich@suse.com>
    Xen/gnttab: handle p2m update errors on a per-slot basis

Chris Leech <cleech@redhat.com>
    scsi: iscsi: Verify lengths on passthrough PDUs

Chris Leech <cleech@redhat.com>
    scsi: iscsi: Ensure sysfs attributes are limited to PAGE_SIZE

Joe Perches <joe@perches.com>
    sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs output

Lee Duncan <lduncan@suse.com>
    scsi: iscsi: Restrict sessions and handles to admin capabilities

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Acer One S1002 tablet

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Voyo Winpad A15 tablet

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Estar Beauty HD MID 7316R tablet

John David Anglin <dave.anglin@bell.net>
    parisc: Bump 64-bit IRQ stack size to 64 KB

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix error handling in commit_fs_roots

Chao Yu <yuchao0@huawei.com>
    f2fs: fix to set/clear I_LINKABLE under i_lock

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: handle unallocated section and zone on pinned/atgc

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Allow entities with no pads

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Guard against NULL pointer deref when get_i2c_info fails

Nirmoy Das <nirmoy.das@amd.com>
    PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse

Ard Biesheuvel <ardb@kernel.org>
    crypto: tcrypt - avoid signed overflow in byte count

Christian Gromm <christian.gromm@microchip.com>
    staging: most: sound: add sanity check for function argument

Gopal Tiwari <gtiwari@redhat.com>
    Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data

Fangrui Song <maskray@google.com>
    x86/build: Treat R_386_PLT32 relocation as R_386_PC32

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix wmi mgmt tx queue full due to race condition

Di Zhu <zhudi21@huawei.com>
    pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()

Claire Chang <tientzu@chromium.org>
    Bluetooth: hci_h5: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for btrtl

Tony Lindgren <tony@atomide.com>
    wlcore: Fix command execute failure 19 for wl12xx

Jiri Slaby <jslaby@suse.cz>
    vt/consolemap: do font sum unsigned

Heiner Kallweit <hkallweit1@gmail.com>
    x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk

Dinghao Liu <dinghao.liu@zju.edu.cn>
    staging: fwserial: Fix error handling in fwserial_create

Marek Vasut <marex@denx.de>
    rsi: Move card interrupt handling to RX thread

Marek Vasut <marex@denx.de>
    rsi: Fix TX EAPOL packet handling against iwlwifi AP

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: bridge: use switchdev for port flags set through sysfs too

Li Xinhai <lixinhai.lxh@gmail.com>
    mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

Marco Elver <elver@google.com>
    net: fix up truesize of cloned skb in skb_prepare_for_shift()

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    smackfs: restrict bytes count in smackfs write functions

Yumei Huang <yuhuang@redhat.com>
    xfs: Fix assert failure in xfs_setattr_size()

Sean Young <sean@mess.org>
    media: mceusb: sanity check for prescaler value

Zqiang <qiang.zhang@windriver.com>
    udlfb: Fix memory leak in dlfb_usb_probe

Randy Dunlap <rdunlap@infradead.org>
    JFS: more checks for invalid superblock

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: VDSO: Use CLANG_FLAGS instead of filtering out '--target='

Andrew Murray <andrew.murray@arm.com>
    arm64: Use correct ll/sc atomic constraints

Will Deacon <will.deacon@arm.com>
    arm64: cmpxchg: Use "K" instead of "L" for ll/sc immediate constraint

Will Deacon <will.deacon@arm.com>
    arm64: Avoid redundant type conversions in xchg() and cmpxchg()

Shaoying Xu <shaoyi@amazon.com>
    arm64 module: set plt* section addresses to 0x0

Cornelia Huck <cohuck@redhat.com>
    virtio/s390: implement virtio-ccw revision 2 correctly

Sergey Senozhatsky <senozhatsky@chromium.org>
    drm/virtio: use kvmalloc for large allocations

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix update_and_free_page contig page struct assumption

Lech Perczak <lech.perczak@gmail.com>
    net: usb: qmi_wwan: support ZTE P685M modem


-------------

Diffstat:

 Documentation/devicetree/bindings/net/btusb.txt |   2 +-
 Documentation/filesystems/sysfs.txt             |   8 +-
 Makefile                                        |   4 +-
 arch/arm/xen/p2m.c                              |  35 +++++-
 arch/arm64/include/asm/atomic_ll_sc.h           | 108 +++++++++--------
 arch/arm64/include/asm/atomic_lse.h             |  46 ++++----
 arch/arm64/include/asm/cmpxchg.h                | 116 +++++++++----------
 arch/arm64/kernel/module.lds                    |   6 +-
 arch/mips/vdso/Makefile                         |   5 +-
 arch/parisc/kernel/irq.c                        |   4 +
 arch/x86/kernel/module.c                        |   1 +
 arch/x86/kernel/reboot.c                        |   9 ++
 arch/x86/tools/relocs.c                         |  12 +-
 arch/x86/xen/p2m.c                              |  44 ++++++-
 crypto/tcrypt.c                                 |  20 ++--
 drivers/block/zram/zram_drv.c                   |   2 +-
 drivers/bluetooth/hci_h5.c                      |   5 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c   |   5 +
 drivers/gpu/drm/virtio/virtgpu_vq.c             |   6 +-
 drivers/media/rc/mceusb.c                       |   9 +-
 drivers/media/usb/uvc/uvc_driver.c              |   7 +-
 drivers/media/v4l2-core/v4l2-ioctl.c            |  19 ++-
 drivers/net/usb/qmi_wwan.c                      |   1 +
 drivers/net/wireless/ath/ath10k/mac.c           |  15 +--
 drivers/net/wireless/rsi/rsi_91x_hal.c          |   3 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c         |   6 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c     |  52 +++------
 drivers/net/wireless/rsi/rsi_sdio.h             |   8 +-
 drivers/net/wireless/ti/wl12xx/main.c           |   3 -
 drivers/net/wireless/ti/wlcore/main.c           |  15 +--
 drivers/net/wireless/ti/wlcore/wlcore.h         |   3 -
 drivers/net/xen-netback/netback.c               |  12 +-
 drivers/pci/pci.c                               |   9 +-
 drivers/s390/virtio/virtio_ccw.c                |   4 +-
 drivers/scsi/libiscsi.c                         | 148 ++++++++++++------------
 drivers/scsi/scsi_transport_iscsi.c             |  38 ++++--
 drivers/staging/fwserial/fwserial.c             |   2 +
 drivers/staging/most/sound/sound.c              |   2 +
 drivers/tty/vt/consolemap.c                     |   2 +-
 drivers/video/fbdev/udlfb.c                     |   1 +
 fs/btrfs/transaction.c                          |  11 +-
 fs/f2fs/namei.c                                 |   8 ++
 fs/f2fs/segment.h                               |   4 +-
 fs/jfs/jfs_filsys.h                             |   1 +
 fs/jfs/jfs_mount.c                              |  10 ++
 fs/sysfs/file.c                                 |  55 +++++++++
 fs/xfs/xfs_iops.c                               |   2 +-
 include/linux/sysfs.h                           |  16 +++
 include/linux/zsmalloc.h                        |   2 +-
 mm/hugetlb.c                                    |  28 +++--
 mm/page_io.c                                    |  11 +-
 mm/swapfile.c                                   |   2 +-
 mm/zsmalloc.c                                   |  17 ++-
 net/bluetooth/amp.c                             |   3 +
 net/bridge/br_sysfs_if.c                        |   9 +-
 net/core/pktgen.c                               |   2 +-
 net/core/skbuff.c                               |  14 ++-
 security/smack/smackfs.c                        |  21 +++-
 sound/pci/hda/patch_realtek.c                   |   2 +
 sound/soc/intel/boards/bytcr_rt5640.c           |  37 ++++++
 60 files changed, 652 insertions(+), 400 deletions(-)


