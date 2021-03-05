Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D424C32E9B1
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhCEMe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:34:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232239AbhCEMd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 771D265036;
        Fri,  5 Mar 2021 12:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947637;
        bh=1TsIkgRRZDSp+Gh0wl/QKOry9w+T4jCvtkVJ9OxvFtw=;
        h=From:To:Cc:Subject:Date:From;
        b=KF0xzu6ARGjdQAIT502pIO/lAfa9Ewk7CwpjD6Zmp5Apb8uT2Oi+yi89DfDTmA+yj
         g2TVH+P7E6+Pay4ijhkciOeN2UkiESQ8jOtBdzb+sGw7d9jkhdKti3Hlb8TDuJu+ko
         +cr6QndlNzK1pHWMfTEY4D3PUHdYO35fNgLg+J+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/72] 5.4.103-rc1 review
Date:   Fri,  5 Mar 2021 13:21:02 +0100
Message-Id: <20210305120857.341630346@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.103-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.103-rc1
X-KernelTest-Deadline: 2021-03-07T12:09+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.103 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.103-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.103-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Apply dual codec quirks for MSI Godlike X570 board

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Intel NUC 10

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
    ASoC: Intel: bytcr_rt5651: Add quirk for the Jumper EZpad 7 tablet

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Voyo Winpad A15 tablet

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for the Estar Beauty HD MID 7316R tablet

Juri Lelli <juri.lelli@redhat.com>
    sched/features: Fix hrtick reprogramming

John David Anglin <dave.anglin@bell.net>
    parisc: Bump 64-bit IRQ stack size to 64 KB

Jim Mattson <jmattson@google.com>
    perf/x86/kvm: Add Cascade Lake Xeon steppings to isolation_ucodes[]

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix error handling in commit_fs_roots

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: Add DMI quirk table to soc_intel_is_byt_cr()

Chao Leng <lengchao@huawei.com>
    nvme-tcp: add clean action for failed reconnection

Chao Leng <lengchao@huawei.com>
    nvme-rdma: add clean action for failed reconnection

Chao Leng <lengchao@huawei.com>
    nvme-core: add cancel tagset helpers

Chao Yu <chao@kernel.org>
    f2fs: fix to set/clear I_LINKABLE under i_lock

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: handle unallocated section and zone on pinned/atgc

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Allow entities with no pads

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Guard against NULL pointer deref when get_i2c_info fails

Nirmoy Das <nirmoy.das@amd.com>
    PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse

Defang Bo <bodefang@126.com>
    drm/amdgpu: Add check to prevent IH overflow

Ard Biesheuvel <ardb@kernel.org>
    crypto: tcrypt - avoid signed overflow in byte count

Tian Tao <tiantao6@hisilicon.com>
    drm/hisilicon: Fix use-after-free

Hans de Goede <hdegoede@redhat.com>
    brcmfmac: Add DMI nvram filename quirk for Voyo winpad A15 tablet

Hans de Goede <hdegoede@redhat.com>
    brcmfmac: Add DMI nvram filename quirk for Predia Basic tablet

Juerg Haefliger <juerg.haefliger@canonical.com>
    staging: bcm2835-audio: Replace unsafe strcpy() with strscpy()

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

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Trigger self-IPI on late deferred wake up before user resume

Marek Vasut <marex@denx.de>
    rsi: Move card interrupt handling to RX thread

Marek Vasut <marex@denx.de>
    rsi: Fix TX EAPOL packet handling against iwlwifi AP

Sergey Senozhatsky <senozhatsky@chromium.org>
    drm/virtio: use kvmalloc for large allocations

Paul Burton <paulburton@kernel.org>
    MIPS: Drop 32-bit asm string functions

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/

Russell King <rmk+kernel@armlinux.org.uk>
    dt-bindings: ethernet-controller: fix fixed-link specification

Cong Wang <cong.wang@bytedance.com>
    net: fix dev_ifsioc_locked() race condition

DENG Qingfang <dqfext@gmail.com>
    net: ag71xx: remove unnecessary MTU reservation

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: bridge: use switchdev for port flags set through sysfs too

Li Xinhai <lixinhai.lxh@gmail.com>
    mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

Josef Bacik <josef@toxicpanda.com>
    nbd: handle device refs for DESTROY_ON_DISCONNECT properly

Marco Elver <elver@google.com>
    net: fix up truesize of cloned skb in skb_prepare_for_shift()

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    smackfs: restrict bytes count in smackfs write functions

Alexander Egorenkov <egorenar@linux.ibm.com>
    net/af_iucv: remove WARN_ONCE on malformed RX packets

Yumei Huang <yuhuang@redhat.com>
    xfs: Fix assert failure in xfs_setattr_size()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ctrls.c: fix shift-out-of-bounds in std_validate

Gao Xiang <hsiangkao@redhat.com>
    erofs: fix shift-out-of-bounds of blkszbits

Sean Young <sean@mess.org>
    media: mceusb: sanity check for prescaler value

Zqiang <qiang.zhang@windriver.com>
    udlfb: Fix memory leak in dlfb_usb_probe

Randy Dunlap <rdunlap@infradead.org>
    JFS: more checks for invalid superblock

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: VDSO: Use CLANG_FLAGS instead of filtering out '--target='

Shaoying Xu <shaoyi@amazon.com>
    arm64 module: set plt* section addresses to 0x0

Christoph Hellwig <hch@lst.de>
    nvme-pci: fix error unwind in nvme_map_data

Christoph Hellwig <hch@lst.de>
    nvme-pci: refactor nvme_unmap_data

jingle.wu <jingle.wu@emc.com.tw>
    Input: elantech - fix protocol errors for some trackpoints in SMBus mode

Lech Perczak <lech.perczak@gmail.com>
    net: usb: qmi_wwan: support ZTE P685M modem


-------------

Diffstat:

 Documentation/devicetree/bindings/net/btusb.txt    |   2 +-
 .../bindings/net/ethernet-controller.yaml          |   5 +
 Documentation/filesystems/sysfs.txt                |   8 +-
 Makefile                                           |   4 +-
 arch/arm/xen/p2m.c                                 |  35 ++++-
 arch/arm64/kernel/module.lds                       |   6 +-
 arch/mips/include/asm/string.h                     | 121 -----------------
 arch/mips/vdso/Makefile                            |   5 +-
 arch/parisc/kernel/irq.c                           |   4 +
 arch/x86/events/intel/core.c                       |   3 +
 arch/x86/kernel/module.c                           |   1 +
 arch/x86/kernel/reboot.c                           |   9 ++
 arch/x86/tools/relocs.c                            |  12 +-
 arch/x86/xen/p2m.c                                 |  44 +++++-
 crypto/tcrypt.c                                    |  20 +--
 drivers/block/nbd.c                                |  32 +++--
 drivers/block/zram/zram_drv.c                      |   2 +-
 drivers/bluetooth/hci_h5.c                         |   5 +
 drivers/gpu/drm/amd/amdgpu/cz_ih.c                 |  37 ++++--
 drivers/gpu/drm/amd/amdgpu/iceland_ih.c            |  36 +++--
 drivers/gpu/drm/amd/amdgpu/tonga_ih.c              |  37 ++++--
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   5 +
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c    |   1 -
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   5 +-
 drivers/input/mouse/elantech.c                     |  99 +++++++++++++-
 drivers/input/mouse/elantech.h                     |   4 +
 drivers/media/rc/mceusb.c                          |   9 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   7 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  19 +--
 drivers/net/ethernet/atheros/ag71xx.c              |   4 +-
 drivers/net/tap.c                                  |   7 +-
 drivers/net/tun.c                                  |   4 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/ath/ath10k/mac.c              |  15 +--
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  32 +++++
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   3 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   6 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |  52 ++------
 drivers/net/wireless/rsi/rsi_sdio.h                |   8 +-
 drivers/net/wireless/ti/wl12xx/main.c              |   3 -
 drivers/net/wireless/ti/wlcore/main.c              |  15 +--
 drivers/net/wireless/ti/wlcore/wlcore.h            |   3 -
 drivers/net/xen-netback/netback.c                  |  12 +-
 drivers/nvme/host/core.c                           |  20 +++
 drivers/nvme/host/nvme.h                           |   2 +
 drivers/nvme/host/pci.c                            | 105 +++++++++------
 drivers/nvme/host/rdma.c                           |  18 ++-
 drivers/nvme/host/tcp.c                            |  18 ++-
 drivers/pci/pci.c                                  |   9 +-
 drivers/scsi/libiscsi.c                            | 148 ++++++++++-----------
 drivers/scsi/scsi_transport_iscsi.c                |  38 ++++--
 drivers/staging/fwserial/fwserial.c                |   2 +
 drivers/staging/most/sound/sound.c                 |   2 +
 .../vc04_services/bcm2835-audio/bcm2835-ctl.c      |   6 +-
 .../vc04_services/bcm2835-audio/bcm2835-pcm.c      |   2 +-
 .../staging/vc04_services/bcm2835-audio/bcm2835.c  |   6 +-
 drivers/tty/vt/consolemap.c                        |   2 +-
 drivers/video/fbdev/udlfb.c                        |   1 +
 fs/btrfs/transaction.c                             |  11 +-
 fs/erofs/super.c                                   |   4 +-
 fs/f2fs/namei.c                                    |   8 ++
 fs/f2fs/segment.h                                  |   4 +-
 fs/jfs/jfs_filsys.h                                |   1 +
 fs/jfs/jfs_mount.c                                 |  10 ++
 fs/sysfs/file.c                                    |  55 ++++++++
 fs/xfs/xfs_iops.c                                  |   2 +-
 include/linux/netdevice.h                          |   3 +
 include/linux/swap.h                               |   1 +
 include/linux/sysfs.h                              |  16 +++
 include/linux/zsmalloc.h                           |   2 +-
 kernel/rcu/tree.c                                  |  21 ++-
 kernel/rcu/tree.h                                  |   2 +-
 kernel/rcu/tree_plugin.h                           |  25 ++--
 kernel/sched/core.c                                |   8 +-
 kernel/sched/sched.h                               |   1 +
 mm/hugetlb.c                                       |  22 +--
 mm/page_io.c                                       |   5 -
 mm/swapfile.c                                      |  13 ++
 mm/zsmalloc.c                                      |  17 ++-
 net/bluetooth/amp.c                                |   3 +
 net/bridge/br_sysfs_if.c                           |   9 +-
 net/core/dev.c                                     |  42 ++++++
 net/core/dev_ioctl.c                               |  20 +--
 net/core/pktgen.c                                  |   2 +-
 net/core/rtnetlink.c                               |   2 +-
 net/core/skbuff.c                                  |  14 +-
 net/iucv/af_iucv.c                                 |   1 -
 security/smack/smackfs.c                           |  21 ++-
 sound/pci/hda/patch_realtek.c                      |  13 ++
 sound/soc/intel/boards/bytcr_rt5640.c              |  37 ++++++
 sound/soc/intel/boards/bytcr_rt5651.c              |  13 ++
 sound/soc/intel/common/soc-intel-quirks.h          |  25 ++++
 93 files changed, 1030 insertions(+), 527 deletions(-)


