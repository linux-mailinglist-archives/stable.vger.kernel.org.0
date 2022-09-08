Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2265B1896
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 11:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiIHJZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 05:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiIHJYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 05:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE8027B24;
        Thu,  8 Sep 2022 02:24:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E6461C12;
        Thu,  8 Sep 2022 09:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BD0C433D6;
        Thu,  8 Sep 2022 09:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662629084;
        bh=xf8i8jVCJk0sbvuXJdCxq36EMZoZejyif5UbP8Vp5SA=;
        h=From:To:Cc:Subject:Date:From;
        b=TRaqUpwIsO8wvVUeYeRekM39Iso37MBrCAyRxczX5FxRDA5HBd2Aitcwj2IZC1hr/
         obcDQ5ebZA4aH29mJjqbx7094WdM8exYX4pIIpKSDoGQZFM9S0NuX5Z+vDYuOSuG4u
         81DRmz/FRocYkoGqispwVagsi3PwmXNgJbxBYi3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.142
Date:   Thu,  8 Sep 2022 11:25:05 +0200
Message-Id: <1662629105129205@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.142 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                             |    2 
 arch/powerpc/kernel/systbl.S                         |    1 
 arch/riscv/mm/pageattr.c                             |    4 -
 arch/s390/include/asm/hugetlb.h                      |    6 +
 arch/s390/kernel/vmlinux.lds.S                       |    1 
 arch/x86/kvm/x86.c                                   |   25 ++++++-
 drivers/android/binder.c                             |   12 +++
 drivers/base/dd.c                                    |   10 +++
 drivers/block/xen-blkback/common.h                   |    3 
 drivers/block/xen-blkback/xenbus.c                   |    6 +
 drivers/block/xen-blkfront.c                         |    8 +-
 drivers/clk/bcm/clk-raspberrypi.c                    |   13 ++-
 drivers/clk/clk.c                                    |    3 
 drivers/gpio/gpio-pca953x.c                          |    8 ++
 drivers/gpu/drm/i915/display/intel_quirks.c          |    3 
 drivers/gpu/drm/i915/gvt/handlers.c                  |    2 
 drivers/gpu/drm/msm/dp/dp_ctrl.c                     |    2 
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                    |    4 -
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c                |    2 
 drivers/hwmon/gpio-fan.c                             |    3 
 drivers/iio/adc/ad7292.c                             |    4 -
 drivers/iio/adc/mcp3911.c                            |   19 ++++-
 drivers/input/joystick/iforce/iforce-serio.c         |    6 -
 drivers/input/joystick/iforce/iforce-usb.c           |    8 +-
 drivers/input/joystick/iforce/iforce.h               |    6 +
 drivers/input/misc/rk805-pwrkey.c                    |    1 
 drivers/media/rc/mceusb.c                            |   35 ++++------
 drivers/misc/fastrpc.c                               |   12 ++-
 drivers/mmc/core/sd.c                                |    6 -
 drivers/net/ethernet/cortina/gemini.c                |   24 +++----
 drivers/net/ethernet/google/gve/gve_ethtool.c        |   16 ++--
 drivers/net/ethernet/google/gve/gve_main.c           |   12 +--
 drivers/net/ethernet/huawei/hinic/hinic_rx.c         |    4 -
 drivers/net/ethernet/huawei/hinic/hinic_tx.c         |    4 -
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  |    8 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c |    8 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c           |    2 
 drivers/net/ieee802154/adf7242.c                     |    3 
 drivers/net/netdevsim/netdev.c                       |    4 -
 drivers/platform/x86/pmc_atom.c                      |    2 
 drivers/staging/rtl8712/rtl8712_cmd.c                |   36 ----------
 drivers/thunderbolt/ctl.c                            |    2 
 drivers/tty/serial/fsl_lpuart.c                      |    5 -
 drivers/tty/vt/vt.c                                  |   12 ++-
 drivers/usb/class/cdc-acm.c                          |    3 
 drivers/usb/core/hub.c                               |   10 +++
 drivers/usb/dwc2/platform.c                          |    8 +-
 drivers/usb/dwc3/core.c                              |   19 +++--
 drivers/usb/dwc3/dwc3-qcom.c                         |   14 +++-
 drivers/usb/dwc3/host.c                              |   11 +++
 drivers/usb/gadget/function/storage_common.c         |    6 +
 drivers/usb/host/xhci-hub.c                          |   13 +++
 drivers/usb/host/xhci.c                              |   19 +----
 drivers/usb/host/xhci.h                              |    4 -
 drivers/usb/serial/ch341.c                           |   16 ++++
 drivers/usb/serial/cp210x.c                          |    1 
 drivers/usb/serial/ftdi_sio.c                        |    2 
 drivers/usb/serial/ftdi_sio_ids.h                    |    6 +
 drivers/usb/serial/option.c                          |   15 ++++
 drivers/usb/storage/unusual_devs.h                   |    7 ++
 drivers/usb/typec/altmodes/displayport.c             |    4 -
 drivers/xen/grant-table.c                            |    3 
 fs/btrfs/volumes.c                                   |   44 +++++++++++--
 include/linux/platform_data/x86/pmc_atom.h           |    6 +
 include/linux/usb.h                                  |    2 
 include/linux/usb/typec_dp.h                         |    5 +
 kernel/bpf/cgroup.c                                  |    4 -
 mm/pagewalk.c                                        |   21 +++---
 mm/ptdump.c                                          |    4 -
 net/ipv4/fib_frontend.c                              |    4 -
 net/ipv4/tcp_input.c                                 |    4 -
 net/kcm/kcmsock.c                                    |   15 ++--
 net/mac80211/ibss.c                                  |    4 +
 net/mac80211/scan.c                                  |   11 ++-
 net/mac80211/sta_info.c                              |    8 +-
 net/mac802154/rx.c                                   |    2 
 net/mpls/af_mpls.c                                   |    4 -
 net/sched/sch_generic.c                              |   31 ++++-----
 net/sched/sch_tbf.c                                  |    4 -
 net/smc/af_smc.c                                     |    1 
 net/wireless/debugfs.c                               |    3 
 sound/core/seq/oss/seq_oss_midi.c                    |    2 
 sound/core/seq/seq_clientmgr.c                       |   12 +--
 sound/hda/intel-nhlt.c                               |   25 ++++---
 sound/pci/hda/patch_realtek.c                        |   63 ++++++++++++++++---
 85 files changed, 519 insertions(+), 278 deletions(-)

Adrian Hunter (1):
      mmc: core: Fix UHS-I SD 1.8V workaround branch

Alan Stern (2):
      media: mceusb: Use new usb_control_msg_*() routines
      USB: core: Prevent nested device-reset calls

Anand Jain (1):
      btrfs: harden identification of a stale device

Andy Shevchenko (1):
      platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask

Armin Wolf (1):
      hwmon: (gpio-fan) Fix array out of bounds access

Carlos Llamas (1):
      binder: fix UAF of ref->proc caused by race condition

Chen-Yu Tsai (2):
      clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops
      clk: core: Fix runtime PM sequence in clk_core_unprepare()

Christophe JAILLET (1):
      clk: bcm: rpi: Use correct order for the parameters of devm_kcalloc()

Colin Ian King (1):
      drm/i915/reg: Fix spelling mistake "Unsupport" -> "Unsupported"

Cong Wang (1):
      kcm: fix strp_init() order and cleanup

Dan Carpenter (3):
      wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()
      staging: rtl8712: fix use after free bugs
      xen/grants: prevent integer overflow in gnttab_dma_alloc_pages()

Diego Santa Cruz (1):
      drm/i915/glk: ECS Liva Q2 needs GLK HDMI port timing quirk

Douglas Anderson (2):
      drm/msm/dsi: Fix number of regulators for msm8996_dsi_cfg
      drm/msm/dsi: Fix number of regulators for SDM660

Duoming Zhou (1):
      ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler

Eric Dumazet (1):
      tcp: annotate data-race around challenge_timestamp

Gerald Schaefer (1):
      s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages

Greg Kroah-Hartman (1):
      Linux 5.10.142

Haibo Chen (1):
      gpio: pca953x: Add mutex_lock for regcache sync in PM

Heiner Kallweit (1):
      usb: dwc2: fix wrong order of phy_power_on and phy_init

Helge Deller (1):
      vt: Clear selection before changing the font

Isaac J. Manjarres (1):
      driver core: Don't probe devices after bus_type.match() probe deferral

Jakub Kicinski (1):
      Revert "sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb"

Jim Mattson (1):
      KVM: x86: Mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES

Johan Hovold (8):
      misc: fastrpc: fix memory corruption on probe
      misc: fastrpc: fix memory corruption on open
      USB: serial: cp210x: add Decagon UCA device id
      usb: dwc3: fix PHY disable sequence
      usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
      usb: dwc3: disable USB core PHY management
      USB: serial: ch341: fix lost character on LCR updates
      USB: serial: ch341: fix disabled rx timer on older devices

Josh Poimboeuf (1):
      s390: fix nospec table alignments

Kacper Michajłow (1):
      ALSA: hda/realtek: Add speaker AMP init for Samsung laptops with ALC298

Krishna Kurapati (1):
      usb: gadget: mass_storage: Fix cdrom data transfers on MAC-OS

Kuogee Hsieh (1):
      drm/msm/dp: delete DP_RECOVERED_CLOCK_OUT_EN to fix tps4

Lin Ma (1):
      ieee802154/adf7242: defer destroy_workqueue call

Marcus Folkesson (2):
      iio: adc: mcp3911: make use of the sign bit
      iio: adc: mcp3911: use correct formula for AD conversion

Masahiro Yamada (1):
      powerpc: align syscall table for ppc32

Mathias Nyman (2):
      Revert "xhci: turn off port power in shutdown"
      xhci: Add grace period after xHC start to prevent premature runtime suspend.

Matti Vaittinen (1):
      iio: ad7292: Prevent regulator double disable

Mika Westerberg (1):
      thunderbolt: Use the actual buffer in tb_async_error()

Miquel Raynal (1):
      net: mac802154: Fix a condition in the receive path

Nicolas Dichtel (1):
      ip: fix triggering of 'icmp redirect'

Niek Nooijens (1):
      USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id

Pablo Sun (1):
      usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles

Peter Robinson (1):
      Input: rk805-pwrkey - fix module autoloading

Peter Ujfalusi (1):
      ALSA: hda: intel-nhlt: Correct the handling of fmt_config flexible array

Pierre-Louis Bossart (1):
      ALSA: hda: intel-nhlt: remove use of __func__ in dev_dbg

Pu Lehui (1):
      bpf, cgroup: Fix kernel BUG in purge_effective_progs

Sebastian Andrzej Siewior (1):
      net: Use u64_stats_fetch_begin_irq() for stats fetch.

SeongJae Park (2):
      xen-blkback: Advertise feature-persistent as user requested
      xen-blkfront: Advertise feature-persistent as user requested

Shenwei Wang (1):
      serial: fsl_lpuart: RS485 RTS polariy is inverse

Sherry Sun (1):
      tty: serial: lpuart: disable flow control while waiting for the transmit engine to complete

Siddh Raman Pant (2):
      wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected
      wifi: mac80211: Fix UAF in ieee80211_scan_rx()

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV32-WA/WB RmNet mode

Stefan Wahren (3):
      clk: bcm: rpi: Fix error handling of raspberrypi_fw_get_rate
      clk: bcm: rpi: Prevent out-of-bounds access
      clk: bcm: rpi: Add missing newline

Stephen Boyd (1):
      Revert "clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops"

Steven Price (1):
      mm: pagewalk: Fix race between unmap and page walker

Takashi Iwai (2):
      ALSA: seq: oss: Fix data-race for max_midi_devs access
      ALSA: seq: Fix data-race at module auto-loading

Tetsuo Handa (1):
      Input: iforce - wake up after clearing IFORCE_XMIT_RUNNING flag

Thierry GUIBERT (1):
      USB: cdc-acm: Add Icom PMR F3400 support (0c26:0020)

Toke Høiland-Jørgensen (1):
      sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb

Wang Hai (1):
      net/sched: fix netdevice reference leaks in attach_default_qdiscs()

Witold Lipieta (1):
      usb-storage: Add ignore-residue quirk for NXP PN7462AU

Yacan Liu (1):
      net/smc: Remove redundant refcount increase

Yan Xinyu (1):
      USB: serial: option: add support for OPPO R11 diag port

Yonglin Tan (1):
      USB: serial: option: add Quectel EM060K modem

Zhengchao Shao (1):
      net: sched: tbf: don't call qdisc_put() while holding tree lock

sunliming (1):
      drm/msm/dsi: fix the inconsistent indenting

