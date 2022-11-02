Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEECE615AC4
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiKBDkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiKBDke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:40:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2470126AE4;
        Tue,  1 Nov 2022 20:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF3546172F;
        Wed,  2 Nov 2022 03:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB556C433C1;
        Wed,  2 Nov 2022 03:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360432;
        bh=e678T+R2fxEJ740u5s3t7MemNupWXqB25at5L+1Uv80=;
        h=From:To:Cc:Subject:Date:From;
        b=Wv3LLo/j23ugUckcSqg2bY83w7N6jm8wONA1MWcDfmvP4roCLjRjwVzaNFVro/7J3
         6x+aio0FByxII1+zubeeYQyX7f31q8tMcAap6cXXvvLAq+AXZnENYKQVqzMMn+7jk0
         Z4xSuQgow+qIqres2tczicoTFOkh1mbK524TiI0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: [PATCH 4.14 00/60] 4.14.298-rc1 review
Date:   Wed,  2 Nov 2022 03:34:21 +0100
Message-Id: <20221102022051.081761052@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.298-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.298-rc1
X-KernelTest-Deadline: 2022-11-04T02:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.298 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.298-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.298-rc1

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive

Yang Yingliang <yangyingliang@huawei.com>
    net: ehea: fix possible memory leak in ehea_register_port()

Aaron Conole <aconole@redhat.com>
    openvswitch: switch from WARN to pr_warn

Takashi Iwai <tiwai@suse.de>
    ALSA: aoa: Fix I2S device accounting

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()

Sudeep Holla <sudeep.holla@arm.com>
    PM: domains: Fix handling of unavailable/disabled idle states

Yang Yingliang <yangyingliang@huawei.com>
    net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()

Slawomir Laba <slawomirx.laba@intel.com>
    i40e: Fix flow-type by setting GL_HASH_INSET registers

Slawomir Laba <slawomirx.laba@intel.com>
    i40e: Fix ethtool rx-flow-hash setting for X722

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check 'interlaced'

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-dv-timings: add sanity checks for blanking values

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: dev->bitmap_cap wasn't freed in all cases

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: s_fbuf: add more sanity checks

Mario Limonciello <mario.limonciello@amd.com>
    PM: hibernate: Allow hybrid sleep to work with s2idle

Dongliang Mu <dzm91@hust.edu.cn>
    can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path

Neal Cardwell <ncardwell@google.com>
    tcp: fix indefinite deferral of RTO with SACK reneging

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY

Eric Dumazet <edumazet@google.com>
    kcm: annotate data-races around kcm->rx_wait

Eric Dumazet <edumazet@google.com>
    kcm: annotate data-races around kcm->rx_psock

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: add the bit rate quirk for Molex cables

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix the SFP compliance codes check for DAC cables

Chen Zhongjin <chenzhongjin@huawei.com>
    x86/unwind/orc: Fix unreliable stack dump with gcov

Yang Yingliang <yangyingliang@huawei.com>
    ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()

Randy Dunlap <rdunlap@infradead.org>
    arc: iounmap() arg is volatile

Nathan Huckleberry <nhuck@google.com>
    drm/msm: Fix return type of mdp4_lvds_connector_mode_valid

Wei Yongjun <weiyongjun1@huawei.com>
    net: ieee802154: fix error return code in dgram_bind()

Rik van Riel <riel@surriel.com>
    mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages

M. Vefa Bicakci <m.v.b@runbox.com>
    xen/gntdev: Prevent leaking grants

Jan Beulich <jbeulich@suse.com>
    Xen/gntdev: don't ignore kernel unmapping error

Heiko Carstens <hca@linux.ibm.com>
    s390/futex: add missing EX_TABLE entry to __futex_atomic_op()

Christian A. Ehrhardt <lk@c--e.de>
    kernfs: fix use-after-free in __kernfs_remove

Matthew Ma <mahongwei@zeku.com>
    mmc: core: Fix kernel panic when remove non-standard SDIO card

Johan Hovold <johan+linaro@kernel.org>
    drm/msm/hdmi: fix memory corruption with too many bridges

Miquel Raynal <miquel.raynal@bootlin.com>
    mac802154: Fix LQI recording

Hyunwoo Kim <imv4bel@gmail.com>
    fbdev: smscufx: Fix several use-after-free bugs

Shreeya Patel <shreeya.patel@collabora.com>
    iio: light: tsl2583: Fix module unloading

Matti Vaittinen <mazziesaccount@gmail.com>
    tools: iio: iio_utils: fix digit calculation

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Remove device endpoints from bandwidth list when freeing the device

Jens Glathe <jens.glathe@oldschoolsolutions.biz>
    usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller

Justin Chen <justinpopo6@gmail.com>
    usb: bdc: change state when port disconnected

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Don't set IMI for no_interrupt

Hannu Hartikainen <hannu@hrtk.in>
    USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM

Jason A. Donenfeld <Jason@zx2c4.com>
    ALSA: au88x0: use explicitly signed char

Steven Rostedt (Google) <rostedt@goodmis.org>
    ALSA: Use del_timer_sync() before freeing timer

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for more TongFang devices

Chen-Yu Tsai <wenst@chromium.org>
    media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls

Jerry Snitselaar <jsnitsel@redhat.com>
    iommu/vt-d: Clean up si_domain in the init_dmars() error path

Yang Yingliang <yangyingliang@huawei.com>
    net: hns: fix possible memory leak in hnae_ae_register()

Xiaobo Liu <cppcoffee@gmail.com>
    net/atm: fix proc_mpc_write incorrect return value

José Expósito <jose.exposito89@gmail.com>
    HID: magicmouse: Do not set BTN_MOUSE on double report

Tony Luck <tony.luck@intel.com>
    ACPI: extlog: Handle multiple records

Filipe Manana <fdmanana@suse.com>
    btrfs: fix processing of delayed data refs during backref walking

Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
    r8152: add PID for the Lenovo OneLink+ Dock

James Morse <james.morse@arm.com>
    arm64: errata: Remove AES hwcap for COMPAT tasks

Eric Ren <renzhengeek@gmail.com>
    KVM: arm64: vgic: Fix exit condition in scan_its_table()

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ata: ahci: Match EM_MAX_SLOTS with SATA_PMP_MAX_PORTS

Alexander Stein <alexander.stein@ew.tq-group.com>
    ata: ahci-imx: Fix MODULE_ALIAS

Borislav Petkov <bp@suse.de>
    x86/microcode/AMD: Apply the patch early on every logical thread

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix BUG when iput after ocfs2_mknod fails

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: clear dinode links count in case of error


-------------

Diffstat:

 Documentation/arm64/silicon-errata.txt             |   2 +
 Makefile                                           |   4 +-
 arch/arc/include/asm/io.h                          |   2 +-
 arch/arc/mm/ioremap.c                              |   2 +-
 arch/arm64/Kconfig                                 |  16 ++++
 arch/arm64/include/asm/cpucaps.h                   |   3 +-
 arch/arm64/kernel/cpu_errata.c                     |  16 ++++
 arch/arm64/kernel/cpufeature.c                     |  13 ++-
 arch/s390/include/asm/futex.h                      |   3 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  16 +++-
 arch/x86/kernel/unwind_orc.c                       |   2 +-
 drivers/acpi/acpi_extlog.c                         |  33 ++++---
 drivers/acpi/video_detect.c                        |  64 +++++++++++++
 drivers/ata/ahci.h                                 |   2 +-
 drivers/ata/ahci_imx.c                             |   2 +-
 drivers/base/power/domain.c                        |   4 +
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   5 ++
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c |   5 +-
 drivers/hid/hid-magicmouse.c                       |   2 +-
 drivers/iio/light/tsl2583.c                        |   2 +-
 drivers/iommu/intel-iommu.c                        |   5 ++
 drivers/media/platform/vivid/vivid-core.c          |  22 +++++
 drivers/media/platform/vivid/vivid-core.h          |   2 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |  27 ++++--
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  14 +++
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  62 +++++++++----
 drivers/mmc/core/sdio_bus.c                        |   3 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |   8 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  17 ++--
 drivers/net/ethernet/hisilicon/hns/hnae.c          |   4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 100 ++++++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   4 +
 drivers/net/ethernet/lantiq_etop.c                 |   1 -
 drivers/net/ethernet/micrel/ksz884x.c              |   2 +-
 drivers/net/usb/cdc_ether.c                        |   7 ++
 drivers/net/usb/r8152.c                            |   1 +
 drivers/usb/core/quirks.c                          |   9 ++
 drivers/usb/dwc3/gadget.c                          |   4 +-
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |   1 +
 drivers/usb/host/xhci-mem.c                        |  20 +++--
 drivers/usb/host/xhci-pci.c                        |   8 +-
 drivers/video/fbdev/smscufx.c                      |  55 ++++++------
 drivers/xen/gntdev.c                               |  30 +++++--
 fs/btrfs/backref.c                                 |  33 +++++--
 fs/kernfs/dir.c                                    |   5 +-
 fs/ocfs2/namei.c                                   |  23 +++--
 include/uapi/linux/videodev2.h                     |   3 +-
 kernel/power/hibernate.c                           |   2 +-
 mm/hugetlb.c                                       |   2 +-
 net/atm/mpoa_proc.c                                |   3 +-
 net/ieee802154/socket.c                            |   4 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/kcm/kcmsock.c                                  |  23 +++--
 net/mac802154/rx.c                                 |   5 +-
 net/openvswitch/datapath.c                         |   3 +-
 sound/aoa/soundbus/i2sbus/core.c                   |   7 +-
 sound/pci/ac97/ac97_codec.c                        |   1 +
 sound/pci/au88x0/au88x0.h                          |   6 +-
 sound/pci/au88x0/au88x0_core.c                     |   2 +-
 sound/synth/emux/emux.c                            |   7 +-
 tools/iio/iio_utils.c                              |   4 +
 virt/kvm/arm/vgic/vgic-its.c                       |   5 +-
 64 files changed, 553 insertions(+), 199 deletions(-)


