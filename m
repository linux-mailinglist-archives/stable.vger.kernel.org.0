Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D36618064
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiKCPCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiKCPCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:02:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3601A201;
        Thu,  3 Nov 2022 08:02:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 137E7B828DA;
        Thu,  3 Nov 2022 15:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E24BC433D7;
        Thu,  3 Nov 2022 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667487737;
        bh=CJXyvU8E5EM3tvdKl5OR6zfXAyE3CSzyRgcD4QleVVE=;
        h=From:To:Cc:Subject:Date:From;
        b=Le851wEsULDWu3Zri84YQENGBMPbEsZRPq/tU15snZybwzY8UJA9y2i15Ws0Kudq8
         VbjfQk40xG7lX7jOzINneSfOO1hzckmiJUIlpfvZTLCJo+/xCsviPH3v0GCBdhjDzq
         uvG7TgdGgYR24sDhobFv9Cy8z3VQwnbFn/nYsegA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.298
Date:   Fri,  4 Nov 2022 00:02:50 +0900
Message-Id: <1667487770167141@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.298 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/arm64/silicon-errata.txt             |    2 
 Makefile                                           |    2 
 arch/arc/include/asm/io.h                          |    2 
 arch/arc/mm/ioremap.c                              |    2 
 arch/arm64/Kconfig                                 |   16 +++
 arch/arm64/include/asm/cpucaps.h                   |    3 
 arch/arm64/kernel/cpu_errata.c                     |   16 +++
 arch/arm64/kernel/cpufeature.c                     |   13 ++
 arch/s390/include/asm/futex.h                      |    3 
 arch/x86/kernel/cpu/microcode/amd.c                |   16 ++-
 arch/x86/kernel/unwind_orc.c                       |    2 
 drivers/acpi/acpi_extlog.c                         |   33 ++++--
 drivers/acpi/video_detect.c                        |   64 +++++++++++++
 drivers/ata/ahci.h                                 |    2 
 drivers/ata/ahci_imx.c                             |    2 
 drivers/base/power/domain.c                        |    4 
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |    5 +
 drivers/gpu/drm/msm/mdp/mdp4/mdp4_lvds_connector.c |    5 -
 drivers/hid/hid-magicmouse.c                       |    2 
 drivers/iio/light/tsl2583.c                        |    2 
 drivers/iommu/intel-iommu.c                        |    5 +
 drivers/media/platform/vivid/vivid-core.c          |   22 ++++
 drivers/media/platform/vivid/vivid-core.h          |    2 
 drivers/media/platform/vivid/vivid-vid-cap.c       |   27 ++++-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   14 ++
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   62 +++++++++----
 drivers/mmc/core/sdio_bus.c                        |    3 
 drivers/net/can/mscan/mpc5xxx_can.c                |    8 +
 drivers/net/can/rcar/rcar_canfd.c                  |    6 -
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |   17 ++-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |    4 
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |    1 
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  100 ++++++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_type.h        |    4 
 drivers/net/ethernet/lantiq_etop.c                 |    1 
 drivers/net/ethernet/micrel/ksz884x.c              |    2 
 drivers/net/usb/cdc_ether.c                        |    7 +
 drivers/net/usb/r8152.c                            |    1 
 drivers/usb/core/quirks.c                          |    9 +
 drivers/usb/dwc3/gadget.c                          |    4 
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |    1 
 drivers/usb/host/xhci-mem.c                        |   20 ++--
 drivers/usb/host/xhci-pci.c                        |    8 +
 drivers/video/fbdev/smscufx.c                      |   55 ++++++-----
 drivers/xen/gntdev.c                               |   30 +++++-
 fs/btrfs/backref.c                                 |   33 +++++-
 fs/kernfs/dir.c                                    |    5 -
 fs/ocfs2/namei.c                                   |   23 ++--
 include/uapi/linux/videodev2.h                     |    3 
 kernel/power/hibernate.c                           |    2 
 mm/hugetlb.c                                       |    2 
 net/atm/mpoa_proc.c                                |    3 
 net/ieee802154/socket.c                            |    4 
 net/ipv4/tcp_input.c                               |    3 
 net/kcm/kcmsock.c                                  |   23 +++-
 net/mac802154/rx.c                                 |    5 -
 net/openvswitch/datapath.c                         |    3 
 sound/aoa/soundbus/i2sbus/core.c                   |    7 +
 sound/pci/ac97/ac97_codec.c                        |    1 
 sound/pci/au88x0/au88x0.h                          |    6 -
 sound/pci/au88x0/au88x0_core.c                     |    2 
 sound/synth/emux/emux.c                            |    7 -
 tools/iio/iio_utils.c                              |    4 
 virt/kvm/arm/vgic/vgic-its.c                       |    5 -
 64 files changed, 552 insertions(+), 198 deletions(-)

Aaron Conole (1):
      openvswitch: switch from WARN to pr_warn

Alexander Stein (1):
      ata: ahci-imx: Fix MODULE_ALIAS

Biju Das (1):
      can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive

Borislav Petkov (1):
      x86/microcode/AMD: Apply the patch early on every logical thread

Chen Zhongjin (1):
      x86/unwind/orc: Fix unreliable stack dump with gcov

Chen-Yu Tsai (1):
      media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls

Christian A. Ehrhardt (1):
      kernfs: fix use-after-free in __kernfs_remove

Dongliang Mu (1):
      can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path

Eric Dumazet (2):
      kcm: annotate data-races around kcm->rx_psock
      kcm: annotate data-races around kcm->rx_wait

Eric Ren (1):
      KVM: arm64: vgic: Fix exit condition in scan_its_table()

Filipe Manana (1):
      btrfs: fix processing of delayed data refs during backref walking

Greg Kroah-Hartman (1):
      Linux 4.14.298

Hannu Hartikainen (1):
      USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM

Hans Verkuil (4):
      media: vivid: s_fbuf: add more sanity checks
      media: vivid: dev->bitmap_cap wasn't freed in all cases
      media: v4l2-dv-timings: add sanity checks for blanking values
      media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check 'interlaced'

Heiko Carstens (1):
      s390/futex: add missing EX_TABLE entry to __futex_atomic_op()

Hyunwoo Kim (1):
      fbdev: smscufx: Fix several use-after-free bugs

James Morse (1):
      arm64: errata: Remove AES hwcap for COMPAT tasks

Jan Beulich (1):
      Xen/gntdev: don't ignore kernel unmapping error

Jason A. Donenfeld (1):
      ALSA: au88x0: use explicitly signed char

Jean-Francois Le Fillatre (1):
      r8152: add PID for the Lenovo OneLink+ Dock

Jens Glathe (1):
      usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller

Jerry Snitselaar (1):
      iommu/vt-d: Clean up si_domain in the init_dmars() error path

Johan Hovold (1):
      drm/msm/hdmi: fix memory corruption with too many bridges

Joseph Qi (2):
      ocfs2: clear dinode links count in case of error
      ocfs2: fix BUG when iput after ocfs2_mknod fails

José Expósito (1):
      HID: magicmouse: Do not set BTN_MOUSE on double report

Justin Chen (1):
      usb: bdc: change state when port disconnected

Kai-Heng Feng (1):
      ata: ahci: Match EM_MAX_SLOTS with SATA_PMP_MAX_PORTS

M. Vefa Bicakci (1):
      xen/gntdev: Prevent leaking grants

Mario Limonciello (1):
      PM: hibernate: Allow hybrid sleep to work with s2idle

Mathias Nyman (1):
      xhci: Remove device endpoints from bandwidth list when freeing the device

Matthew Ma (1):
      mmc: core: Fix kernel panic when remove non-standard SDIO card

Matti Vaittinen (1):
      tools: iio: iio_utils: fix digit calculation

Miquel Raynal (1):
      mac802154: Fix LQI recording

Nathan Huckleberry (1):
      drm/msm: Fix return type of mdp4_lvds_connector_mode_valid

Neal Cardwell (1):
      tcp: fix indefinite deferral of RTO with SACK reneging

Raju Rangoju (2):
      amd-xgbe: fix the SFP compliance codes check for DAC cables
      amd-xgbe: add the bit rate quirk for Molex cables

Randy Dunlap (1):
      arc: iounmap() arg is volatile

Rik van Riel (1):
      mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages

Shreeya Patel (1):
      iio: light: tsl2583: Fix module unloading

Slawomir Laba (2):
      i40e: Fix ethtool rx-flow-hash setting for X722
      i40e: Fix flow-type by setting GL_HASH_INSET registers

Steven Rostedt (Google) (1):
      ALSA: Use del_timer_sync() before freeing timer

Sudeep Holla (1):
      PM: domains: Fix handling of unavailable/disabled idle states

Takashi Iwai (1):
      ALSA: aoa: Fix I2S device accounting

Thinh Nguyen (1):
      usb: dwc3: gadget: Don't set IMI for no_interrupt

Tony Luck (1):
      ACPI: extlog: Handle multiple records

Wei Yongjun (1):
      net: ieee802154: fix error return code in dgram_bind()

Werner Sembach (1):
      ACPI: video: Force backlight native for more TongFang devices

Xiaobo Liu (1):
      net/atm: fix proc_mpc_write incorrect return value

Yang Yingliang (5):
      net: hns: fix possible memory leak in hnae_ae_register()
      ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()
      net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()
      ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()
      net: ehea: fix possible memory leak in ehea_register_port()

Zhang Changzhong (1):
      net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY

