Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C6832E814
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhCEMYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCEMYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E7666501D;
        Fri,  5 Mar 2021 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947076;
        bh=iSOapZvYyAkmXiHwagcnPpqdoR2vsLXq9sRLB49CrgM=;
        h=From:To:Cc:Subject:Date:From;
        b=K/t8bocpVyz2jbd6lRQ0xKxJdezfsEvNXLhWcVVwqOwHRYrj1OhpV0DlEZNXq4doT
         d5Cv4ubVjG9vtKynHeYY1gIkIie61jTcaYJbzGbzR0xDrbks1sA/iwoz7G0Xf31bwV
         PptIxsAFnRzibitib0xcJ1lOzzqN3Cy2/Nqd2KNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 000/104] 5.11.4-rc1 review
Date:   Fri,  5 Mar 2021 13:20:05 +0100
Message-Id: <20210305120903.166929741@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.11.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.4-rc1
X-KernelTest-Deadline: 2021-03-07T12:09+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.4 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.4-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Apply dual codec quirks for MSI Godlike X570 board

Werner Sembach <wse@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Intel NUC 10

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Clevo NH55RZQ

Boris Brezillon <boris.brezillon@collabora.com>
    phy: mediatek: Add missing MODULE_DEVICE_TABLE()

Linus Torvalds <torvalds@linux-foundation.org>
    tty: teach the n_tty ICANON case about the new "cookie continuations" too

Linus Torvalds <torvalds@linux-foundation.org>
    tty: teach n_tty line discipline about the new "cookie continuations"

Linus Torvalds <torvalds@linux-foundation.org>
    tty: clean up legacy leftovers from n_tty line discipline

Linus Torvalds <torvalds@linux-foundation.org>
    tty: fix up hung_up_tty_read() conversion

Linus Torvalds <torvalds@linux-foundation.org>
    tty: fix up iterate_tty_read() EOVERFLOW handling

Jens Axboe <axboe@kernel.dk>
    swap: fix swapfile read/write offset

Juergen Gross <jgross@suse.com>
    xen: fix p2m size in dom0 for disabled memory hotplug case

Jan Beulich <jbeulich@suse.com>
    xen-netback: respect gnttab_map_refs()'s return value

Jan Beulich <jbeulich@suse.com>
    Xen/gnttab: handle p2m update errors on a per-slot basis

Chris Leech <cleech@redhat.com>
    scsi: iscsi: Verify lengths on passthrough PDUs

Chris Leech <cleech@redhat.com>
    scsi: iscsi: Ensure sysfs attributes are limited to PAGE_SIZE

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

Rander Wang <rander.wang@intel.com>
    ASoC: Intel: sof_sdw: detect DMIC number based on mach params

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof-sdw: indent and add quirks consistently

Jim Mattson <jmattson@google.com>
    perf/x86/kvm: Add Cascade Lake Xeon steppings to isolation_ucodes[]

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: enable only one high prio compute queue

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix error handling in commit_fs_roots

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: Add DMI quirk table to soc_intel_is_byt_cr()

Olivia Mackintosh <livvy@base.nu>
    ALSA: usb-audio: Add DJM-450 to the quirks table

Olivia Mackintosh <livvy@base.nu>
    ALSA: usb-audio: Add DJM450 to Pioneer format quirk

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

Jingwen Chen <Jingwen.Chen2@amd.com>
    drm/amd/amdgpu: add error handling to amdgpu_virt_read_pf2vf_data

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Guard against NULL pointer deref when get_i2c_info fails

Olivia Mackintosh <livvy@base.nu>
    ALSA: usb-audio: Add support for Pioneer DJM-750

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add new BYT_RT5640_NO_SPEAKERS quirk-flag

Nirmoy Das <nirmoy.das@amd.com>
    PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse

Defang Bo <bodefang@126.com>
    drm/amdgpu: Add check to prevent IH overflow

Jens Axboe <axboe@kernel.dk>
    fs: make unlazy_walk() error handling consistent

Ard Biesheuvel <ardb@kernel.org>
    crypto: tcrypt - avoid signed overflow in byte count

Tian Tao <tiantao6@hisilicon.com>
    drm/hisilicon: Fix use-after-free

Vsevolod Kozlov <zaba@mm.st>
    wilc1000: Fix use of void pointer as a wrong struct type

Hans de Goede <hdegoede@redhat.com>
    brcmfmac: Add DMI nvram filename quirk for Voyo winpad A15 tablet

Hans de Goede <hdegoede@redhat.com>
    brcmfmac: Add DMI nvram filename quirk for Predia Basic tablet

Alex Elder <elder@linaro.org>
    net: ipa: avoid field overflow

Juerg Haefliger <juerg.haefliger@canonical.com>
    staging: bcm2835-audio: Replace unsafe strcpy() with strscpy()

Christian Gromm <christian.gromm@microchip.com>
    staging: most: sound: add sanity check for function argument

Gopal Tiwari <gtiwari@redhat.com>
    Bluetooth: Fix null pointer dereference in amp_read_loc_assoc_final_data

Hans de Goede <hdegoede@redhat.com>
    Bluetooth: Add new HCI_QUIRK_NO_SUSPEND_NOTIFIER quirk

Pali Rohár <pali@kernel.org>
    net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix wmi mgmt tx queue full due to race condition

Di Zhu <zhudi21@huawei.com>
    pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7615: reset token when mac_reset happens

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: reset token when mac_reset happens

Björn Töpel <bjorn@kernel.org>
    selftests/bpf: Remove memory leak

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    Bluetooth: btusb: fix memory leak on suspend and resume

Claire Chang <tientzu@chromium.org>
    Bluetooth: hci_h5: Set HCI_QUIRK_SIMULTANEOUS_DISCOVERY for btrtl

Tony Lindgren <tony@atomide.com>
    wlcore: Fix command execute failure 19 for wl12xx

Jiri Slaby <jirislaby@kernel.org>
    vt/consolemap: do font sum unsigned

Joakim Zhang <qiangqing.zhang@nxp.com>
    can: flexcan: add CAN wakeup function for i.MX8QM

Heiner Kallweit <hkallweit1@gmail.com>
    x86/reboot: Add Zotac ZBOX CI327 nano PCI reboot quirk

Dinghao Liu <dinghao.liu@zju.edu.cn>
    staging: fwserial: Fix error handling in fwserial_create

Borislav Petkov <bp@suse.de>
    EDAC/amd64: Do not load on family 0x15, model 0x13

Wen Gong <wgong@codeaurora.org>
    ath10k: prevent deinitializing NAPI twice

Stephen Boyd <swboyd@chromium.org>
    ASoC: qcom: Remove useless debug print

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/

Russell King <rmk+kernel@armlinux.org.uk>
    dt-bindings: ethernet-controller: fix fixed-link specification

Cong Wang <cong.wang@bytedance.com>
    net: fix dev_ifsioc_locked() race condition

Chris Mi <cmi@nvidia.com>
    net: psample: Fix netlink skb length with tunnel info

Marco Wenzel <marco.wenzel@a-eberle.de>
    net: hsr: add support for EntryForgetTime

DENG Qingfang <dqfext@gmail.com>
    net: ag71xx: remove unnecessary MTU reservation

Linus Walleij <linus.walleij@linaro.org>
    net: dsa: tag_rtl4_a: Support also egress tags

wenxu <wenxu@ucloud.cn>
    net/sched: cls_flower: Reject invalid ct_state flags rules

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: bridge: use switchdev for port flags set through sysfs too

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix DATA_FIN generation on early shutdown

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not wakeup listener for MPJ subflows

Eric Dumazet <edumazet@google.com>
    tcp: fix tcp_rmem documentation

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-srv: Do not signal REG_MR

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs-clt: Use bitmask to check sess->flags

Jack Wang <jinpu.wang@cloud.ionos.com>
    RDMA/rtrs: Do not signal for heatbeat

Alex Williamson <alex.williamson@redhat.com>
    vfio/type1: Use follow_pte()

Li Xinhai <lixinhai.lxh@gmail.com>
    mm/hugetlb.c: fix unnecessary address expansion of pmd sharing

Josef Bacik <josef@toxicpanda.com>
    nbd: handle device refs for DESTROY_ON_DISCONNECT properly

Alexandre Ghiti <alex@ghiti.fr>
    riscv: Get rid of MAX_EARLY_MAPPING_SIZE

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix spurious retransmissions

Marco Elver <elver@google.com>
    net: fix up truesize of cloned skb in skb_prepare_for_shift()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: ignore data race while checking quota

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    smackfs: restrict bytes count in smackfs write functions

Alexander Egorenkov <egorenar@linux.ibm.com>
    net/af_iucv: remove WARN_ONCE on malformed RX packets

Yumei Huang <yuhuang@redhat.com>
    xfs: Fix assert failure in xfs_setattr_size()

Dan Carpenter <dan.carpenter@oracle.com>
    media: zr364xx: fix memory leaks in probe()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ctrls.c: fix shift-out-of-bounds in std_validate

Gao Xiang <hsiangkao@redhat.com>
    erofs: fix shift-out-of-bounds of blkszbits

Sean Young <sean@mess.org>
    media: mceusb: sanity check for prescaler value

Zqiang <qiang.zhang@windriver.com>
    udlfb: Fix memory leak in dlfb_usb_probe

Peter Zijlstra <peterz@infradead.org>
    sched/core: Allow try_invoke_on_locked_down_task() with irqs disabled

Randy Dunlap <rdunlap@infradead.org>
    JFS: more checks for invalid superblock

Fangrui Song <maskray@google.com>
    x86/build: Treat R_386_PLT32 relocation as R_386_PC32

Ihab Zhaika <ihab.zhaika@intel.com>
    iwlwifi: add new cards for So and Qu family

Lech Perczak <lech.perczak@gmail.com>
    net: usb: qmi_wwan: support ZTE P685M modem


-------------

Diffstat:

 Documentation/devicetree/bindings/net/btusb.txt    |   2 +-
 .../bindings/net/ethernet-controller.yaml          |   5 +
 Documentation/networking/ip-sysctl.rst             |   7 +-
 Makefile                                           |   4 +-
 arch/arm/xen/p2m.c                                 |  35 ++++-
 arch/parisc/kernel/irq.c                           |   4 +
 arch/riscv/mm/init.c                               |  21 +--
 arch/x86/events/intel/core.c                       |   3 +
 arch/x86/include/asm/xen/page.h                    |  12 ++
 arch/x86/kernel/module.c                           |   1 +
 arch/x86/kernel/reboot.c                           |   9 ++
 arch/x86/tools/relocs.c                            |  12 +-
 arch/x86/xen/p2m.c                                 |  54 +++++++-
 arch/x86/xen/setup.c                               |  25 +---
 crypto/tcrypt.c                                    |  20 +--
 drivers/block/nbd.c                                |  32 +++--
 drivers/bluetooth/hci_h5.c                         |   5 +
 drivers/edac/amd64_edac.c                          |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |  15 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/cz_ih.c                 |  37 ++++--
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/iceland_ih.c            |  36 +++--
 drivers/gpu/drm/amd/amdgpu/tonga_ih.c              |  37 ++++--
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   5 +
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c    |   1 -
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |  15 +--
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs.c                 |   4 +-
 drivers/media/rc/mceusb.c                          |   9 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   7 +-
 drivers/media/usb/zr364xx/zr364xx.c                |  49 ++++---
 drivers/media/v4l2-core/v4l2-ctrls.c               |   3 +-
 drivers/net/can/flexcan.c                          | 123 ++++++++++++++---
 drivers/net/ethernet/atheros/ag71xx.c              |   4 +-
 drivers/net/ipa/ipa_reg.h                          |  22 +--
 drivers/net/phy/sfp-bus.c                          |  15 +++
 drivers/net/phy/sfp.c                              |  17 ++-
 drivers/net/tap.c                                  |   7 +-
 drivers/net/tun.c                                  |   5 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/ath/ath10k/ahb.c              |   5 +-
 drivers/net/wireless/ath/ath10k/core.c             |  25 ++++
 drivers/net/wireless/ath/ath10k/core.h             |   5 +
 drivers/net/wireless/ath/ath10k/mac.c              |  15 +--
 drivers/net/wireless/ath/ath10k/pci.c              |   7 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   5 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   6 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  32 +++++
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  18 +++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  26 ++++
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  20 +++
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   2 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  18 +--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  24 ++++
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   1 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   2 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |  15 ++-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |   3 +-
 drivers/net/wireless/ti/wl12xx/main.c              |   3 -
 drivers/net/wireless/ti/wlcore/main.c              |  15 +--
 drivers/net/wireless/ti/wlcore/wlcore.h            |   3 -
 drivers/net/xen-netback/netback.c                  |  12 +-
 drivers/nvme/host/core.c                           |  20 +++
 drivers/nvme/host/nvme.h                           |   2 +
 drivers/nvme/host/rdma.c                           |  18 ++-
 drivers/nvme/host/tcp.c                            |  18 ++-
 drivers/pci/pci.c                                  |   9 +-
 drivers/phy/mediatek/phy-mtk-hdmi.c                |   1 +
 drivers/phy/mediatek/phy-mtk-mipi-dsi.c            |   1 +
 drivers/scsi/libiscsi.c                            | 148 ++++++++++-----------
 drivers/scsi/scsi_transport_iscsi.c                |  40 ++++--
 drivers/staging/fwserial/fwserial.c                |   2 +
 drivers/staging/most/sound/sound.c                 |   2 +
 .../vc04_services/bcm2835-audio/bcm2835-ctl.c      |   6 +-
 .../vc04_services/bcm2835-audio/bcm2835-pcm.c      |   2 +-
 .../staging/vc04_services/bcm2835-audio/bcm2835.c  |   6 +-
 drivers/tty/n_tty.c                                |  87 ++++++++----
 drivers/tty/tty_io.c                               |  28 ++--
 drivers/tty/vt/consolemap.c                        |   2 +-
 drivers/vfio/vfio_iommu_type1.c                    |  15 ++-
 drivers/video/fbdev/udlfb.c                        |   1 +
 fs/btrfs/transaction.c                             |  11 +-
 fs/erofs/super.c                                   |   4 +-
 fs/f2fs/namei.c                                    |   8 ++
 fs/f2fs/segment.h                                  |   4 +-
 fs/jfs/jfs_filsys.h                                |   1 +
 fs/jfs/jfs_mount.c                                 |  10 ++
 fs/namei.c                                         |  43 +++---
 fs/xfs/xfs_iops.c                                  |   2 +-
 include/linux/netdevice.h                          |   3 +
 include/linux/swap.h                               |   1 +
 include/net/bluetooth/hci.h                        |   8 ++
 include/uapi/linux/pkt_cls.h                       |   2 +
 kernel/sched/core.c                                |  17 +--
 kernel/sched/sched.h                               |   1 +
 mm/hugetlb.c                                       |  22 +--
 mm/page_io.c                                       |   5 -
 mm/swapfile.c                                      |  13 ++
 net/bluetooth/amp.c                                |   3 +
 net/bluetooth/hci_core.c                           |  21 +--
 net/bridge/br_sysfs_if.c                           |   9 +-
 net/core/dev.c                                     |  42 ++++++
 net/core/dev_ioctl.c                               |  20 +--
 net/core/pktgen.c                                  |   2 +-
 net/core/rtnetlink.c                               |   2 +-
 net/core/skbuff.c                                  |  14 +-
 net/dsa/tag_rtl4_a.c                               |  43 ++++--
 net/hsr/hsr_framereg.c                             |   9 +-
 net/hsr/hsr_framereg.h                             |   1 +
 net/hsr/hsr_main.h                                 |   1 +
 net/iucv/af_iucv.c                                 |   1 -
 net/mptcp/options.c                                |  22 +--
 net/mptcp/protocol.c                               |   3 +-
 net/mptcp/protocol.h                               |  11 +-
 net/mptcp/subflow.c                                |   6 +
 net/psample/psample.c                              |   4 +-
 net/sched/cls_flower.c                             |  39 +++++-
 security/smack/smackfs.c                           |  21 ++-
 security/tomoyo/file.c                             |  16 +--
 security/tomoyo/network.c                          |   8 +-
 security/tomoyo/util.c                             |  24 ++--
 sound/pci/hda/patch_realtek.c                      |  13 ++
 sound/soc/intel/boards/bytcr_rt5640.c              |  63 ++++++++-
 sound/soc/intel/boards/bytcr_rt5651.c              |  13 ++
 sound/soc/intel/boards/sof_sdw.c                   |  15 ++-
 sound/soc/intel/common/soc-intel-quirks.h          |  25 ++++
 sound/soc/qcom/lpass-cpu.c                         |   1 -
 sound/usb/implicit.c                               |   3 +-
 sound/usb/quirks-table.h                           | 117 ++++++++++++++++
 sound/usb/quirks.c                                 |  20 +++
 tools/testing/selftests/bpf/xdpxceiver.c           |   1 -
 137 files changed, 1529 insertions(+), 607 deletions(-)


