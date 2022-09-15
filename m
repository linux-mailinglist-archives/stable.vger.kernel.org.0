Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE985B98F2
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 12:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiIOKkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 06:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiIOKkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 06:40:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9C6205E6;
        Thu, 15 Sep 2022 03:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8530B81F90;
        Thu, 15 Sep 2022 10:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47823C433D6;
        Thu, 15 Sep 2022 10:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663238437;
        bh=mNhJsaL4ts7pblCGti3TO0KQME4UxiY7B8Un1LBSLOk=;
        h=From:To:Cc:Subject:Date:From;
        b=oa/iMLfSto0zUW6onw86PvoyhA7S/pvjFeayCQ2YE/A7DTv2yBpXi9FVPnL9oO9p+
         jK+A1lnf78OOgNmian4P1zqxvbL8pPITcxOGySby0VvSDo7/inG13kiuooH6tyuN1q
         qb9pmW5eAlubqI4YZsOPz/TsWk9ZzKMc0c0BP47s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.293
Date:   Thu, 15 Sep 2022 12:41:02 +0200
Message-Id: <166323846360157@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.293 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 -
 arch/mips/loongson32/ls1c/board.c             |    1 
 arch/parisc/kernel/head.S                     |   43 +++++++++++++++++++++++++-
 arch/s390/include/asm/hugetlb.h               |    6 ++-
 arch/s390/kernel/vmlinux.lds.S                |    1 
 drivers/android/binder.c                      |   12 +++++++
 drivers/base/dd.c                             |   10 ++++++
 drivers/firmware/efi/capsule-loader.c         |   31 ++++--------------
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c         |    3 +
 drivers/gpu/drm/i915/gvt/handlers.c           |    2 -
 drivers/gpu/drm/msm/dsi/dsi_cfg.c             |    2 -
 drivers/gpu/drm/radeon/radeon_device.c        |    3 +
 drivers/hwmon/gpio-fan.c                      |    3 +
 drivers/input/misc/rk805-pwrkey.c             |    1 
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |    2 -
 drivers/net/wireless/intel/iwlegacy/4965-rs.c |    5 ---
 drivers/parisc/ccio-dma.c                     |   11 ++++--
 drivers/platform/x86/pmc_atom.c               |    2 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          |    2 -
 drivers/staging/rtl8712/rtl8712_cmd.c         |   36 ---------------------
 drivers/thunderbolt/ctl.c                     |    2 -
 drivers/tty/serial/fsl_lpuart.c               |    4 +-
 drivers/tty/vt/vt.c                           |   12 ++++---
 drivers/usb/class/cdc-acm.c                   |    3 +
 drivers/usb/core/hub.c                        |   10 ++++++
 drivers/usb/dwc2/platform.c                   |    8 ++--
 drivers/usb/dwc3/core.c                       |   20 ++++++------
 drivers/usb/gadget/function/storage_common.c  |    6 ++-
 drivers/usb/host/xhci-hub.c                   |   11 ++++++
 drivers/usb/host/xhci.c                       |    4 +-
 drivers/usb/host/xhci.h                       |    2 -
 drivers/usb/serial/ch341.c                    |   15 +++++++--
 drivers/usb/serial/cp210x.c                   |    1 
 drivers/usb/serial/ftdi_sio.c                 |    2 +
 drivers/usb/serial/ftdi_sio_ids.h             |    6 +++
 drivers/usb/serial/option.c                   |   15 +++++++++
 drivers/usb/storage/unusual_devs.h            |    7 ++++
 drivers/video/fbdev/chipsfb.c                 |    1 
 include/linux/buffer_head.h                   |   11 ++++++
 include/linux/platform_data/x86/pmc_atom.h    |    6 ++-
 include/linux/usb.h                           |    2 +
 kernel/bpf/verifier.c                         |    1 
 kernel/kprobes.c                              |    1 
 mm/kmemleak.c                                 |    8 ++--
 net/bridge/br_netfilter_hooks.c               |    2 +
 net/bridge/br_netfilter_ipv6.c                |    1 
 net/ipv4/tcp_input.c                          |   25 ++++++++++-----
 net/ipv6/seg6.c                               |    5 +++
 net/kcm/kcmsock.c                             |   15 ++++-----
 net/mac80211/ibss.c                           |    4 ++
 net/mac802154/rx.c                            |    2 -
 net/netfilter/nf_conntrack_irc.c              |    5 +--
 net/sched/sch_sfb.c                           |   13 ++++---
 net/sunrpc/xprt.c                             |    4 +-
 net/tipc/monitor.c                            |    2 -
 net/wireless/debugfs.c                        |    3 +
 sound/core/seq/oss/seq_oss_midi.c             |    2 +
 sound/core/seq/seq_clientmgr.c                |   12 +++----
 sound/drivers/aloop.c                         |    7 ++--
 sound/pci/emu10k1/emupcm.c                    |    2 -
 sound/usb/stream.c                            |    2 -
 tools/testing/selftests/bpf/test_align.c      |   27 ++++++++--------
 tools/testing/selftests/bpf/test_verifier.c   |   16 ++++-----
 63 files changed, 314 insertions(+), 171 deletions(-)

Alan Stern (1):
      USB: core: Prevent nested device-reset calls

Andy Shevchenko (1):
      platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask

Armin Wolf (1):
      hwmon: (gpio-fan) Fix array out of bounds access

Candice Li (1):
      drm/amdgpu: Check num_gfx_rings for gfx v9_0 rb setup.

Carlos Llamas (1):
      binder: fix UAF of ref->proc caused by race condition

Christian A. Ehrhardt (1):
      kprobes: Prohibit probes in gate area

Colin Ian King (1):
      drm/i915/reg: Fix spelling mistake "Unsupport" -> "Unsupported"

Cong Wang (1):
      kcm: fix strp_init() order and cleanup

Dan Carpenter (3):
      wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()
      staging: rtl8712: fix use after free bugs
      tipc: fix shift wrapping bug in map_get()

David Leadbeater (1):
      netfilter: nf_conntrack_irc: Fix forged IP logic

David Lebrun (1):
      ipv6: sr: fix out-of-bounds read when setting HMAC data.

Dongxiang Ke (1):
      ALSA: usb-audio: Fix an out-of-bounds bug in __snd_usb_parse_audio_interface()

Douglas Anderson (1):
      drm/msm/dsi: Fix number of regulators for msm8996_dsi_cfg

Duoming Zhou (1):
      ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler

Gerald Schaefer (1):
      s390/hugetlb: fix prepare_hugepage_range() check for 2 GB hugepages

Greg Kroah-Hartman (1):
      Linux 4.14.293

Harsh Modi (1):
      netfilter: br_netfilter: Drop dst references before setting.

Heiner Kallweit (1):
      usb: dwc2: fix wrong order of phy_power_on and phy_init

Helge Deller (2):
      vt: Clear selection before changing the font
      parisc: Add runtime check to prevent PA2.0 kernels on PA1.x machines

Hyunwoo Kim (1):
      efi: capsule-loader: Fix use-after-free in efi_capsule_write

Isaac J. Manjarres (1):
      driver core: Don't probe devices after bus_type.match() probe deferral

Johan Hovold (4):
      USB: serial: cp210x: add Decagon UCA device id
      usb: dwc3: fix PHY disable sequence
      USB: serial: ch341: fix lost character on LCR updates
      USB: serial: ch341: fix disabled rx timer on older devices

John Fastabend (1):
      bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()

Josh Poimboeuf (1):
      s390: fix nospec table alignments

Krishna Kurapati (1):
      usb: gadget: mass_storage: Fix cdrom data transfers on MAC-OS

Li Qiong (1):
      parisc: ccio-dma: Handle kmalloc failure in ccio_init_resources()

Linus Torvalds (1):
      fs: only do a memory barrier for the first set_buffer_uptodate()

Mathias Nyman (1):
      xhci: Add grace period after xHC start to prevent premature runtime suspend.

Maxim Mikityanskiy (1):
      bpf: Fix the off-by-two error in range markings

Mika Westerberg (1):
      thunderbolt: Use the actual buffer in tb_async_error()

Miquel Raynal (1):
      net: mac802154: Fix a condition in the receive path

Neal Cardwell (1):
      tcp: fix early ETIMEDOUT after spurious non-SACK RTO

NeilBrown (1):
      SUNRPC: use _bh spinlocking on ->transport_lock

Niek Nooijens (1):
      USB: serial: ftdi_sio: add Omron CS1W-CIF31 device id

Pattara Teerapong (1):
      ALSA: aloop: Fix random zeros in capture data when using jiffies timer

Peter Robinson (1):
      Input: rk805-pwrkey - fix module autoloading

Shenwei Wang (1):
      serial: fsl_lpuart: RS485 RTS polariy is inverse

Siddh Raman Pant (1):
      wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected

Slark Xiao (1):
      USB: serial: option: add support for Cinterion MV32-WA/WB RmNet mode

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix use-after-free warning

Stanislav Fomichev (1):
      selftests/bpf: Fix test_align verifier log patterns

Stanislaw Gruszka (1):
      wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

Takashi Iwai (2):
      ALSA: seq: oss: Fix data-race for max_midi_devs access
      ALSA: seq: Fix data-race at module auto-loading

Tasos Sahanidis (1):
      ALSA: emu10k1: Fix out of bounds access in snd_emu10k1_pcm_channel_alloc()

Thierry GUIBERT (1):
      USB: cdc-acm: Add Icom PMR F3400 support (0c26:0020)

Toke Høiland-Jørgensen (2):
      sch_sfb: Don't assume the skb is still around after enqueueing to child
      sch_sfb: Also store skb len before calling child enqueue

Witold Lipieta (1):
      usb-storage: Add ignore-residue quirk for NXP PN7462AU

Yan Xinyu (1):
      USB: serial: option: add support for OPPO R11 diag port

Yang Ling (1):
      MIPS: loongson32: ls1c: Fix hang during startup

Yang Yingliang (1):
      fbdev: chipsfb: Add missing pci_disable_device() in chipsfb_pci_init()

Yee Lee (1):
      Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"

Yonglin Tan (1):
      USB: serial: option: add Quectel EM060K modem

Zhenneng Li (1):
      drm/radeon: add a force flush to delay work when radeon

