Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB59D4E900D
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 10:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237218AbiC1IXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 04:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiC1IXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 04:23:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE925371B;
        Mon, 28 Mar 2022 01:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39825B80EEF;
        Mon, 28 Mar 2022 08:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B581C004DD;
        Mon, 28 Mar 2022 08:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648455720;
        bh=k1tZS0t5elt6zRHf8nLDR/ZkNdThdm8si800JMb13D8=;
        h=From:To:Cc:Subject:Date:From;
        b=tQxN1qW1WWmmDNn7Djo5tCb3WUZAaNyVemSuUdeKax2yP8JmlicyqKGLwkl3h08/f
         rMMUcrrKR2kKiQf3S0x/k15ZIUR3gje5nwR9Du+cXEuumNzPlZu+IE0kLEO4b4HAHh
         WaaPgM3qr5K0HyIRWkoh4yxsWh1nUKdD8HLKPZ8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.109
Date:   Mon, 28 Mar 2022 10:21:55 +0200
Message-Id: <164845571613863@kroah.com>
X-Mailer: git-send-email 2.35.1
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

I'm announcing the release of the 5.10.109 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/nds32/include/asm/uaccess.h                 |   22 ++++-
 arch/x86/kernel/acpi/boot.c                      |   24 +++++
 drivers/acpi/battery.c                           |   12 ++
 drivers/acpi/video_detect.c                      |   75 +++++++++++++++++
 drivers/char/tpm/tpm-dev-common.c                |    8 +
 drivers/char/tpm/tpm2-space.c                    |    8 -
 drivers/crypto/qat/qat_common/qat_crypto.c       |    8 +
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c |   12 +-
 drivers/net/wireless/ath/regd.c                  |   10 +-
 drivers/net/wireless/ath/wcn36xx/main.c          |    3 
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h       |    1 
 drivers/nfc/st21nfca/se.c                        |   10 ++
 drivers/staging/fbtft/fb_st7789v.c               |    2 
 fs/exfat/super.c                                 |    2 
 include/sound/pcm.h                              |    1 
 kernel/cgroup/cgroup-internal.h                  |   19 ++++
 kernel/cgroup/cgroup-v1.c                        |   32 ++++---
 kernel/cgroup/cgroup.c                           |   84 +++++++++++++------
 kernel/rcu/tree_plugin.h                         |    9 +-
 net/ipv6/ip6_output.c                            |    4 
 net/llc/af_llc.c                                 |   49 +++++++----
 net/mac80211/cfg.c                               |    3 
 net/netfilter/nf_tables_core.c                   |    2 
 sound/core/oss/pcm_oss.c                         |   12 +-
 sound/core/oss/pcm_plugin.c                      |    5 -
 sound/core/pcm.c                                 |    2 
 sound/core/pcm_lib.c                             |    4 
 sound/core/pcm_memory.c                          |   11 +-
 sound/core/pcm_native.c                          |   97 ++++++++++++++---------
 sound/pci/ac97/ac97_codec.c                      |    4 
 sound/pci/cmipci.c                               |    3 
 sound/pci/hda/patch_realtek.c                    |    4 
 sound/soc/sti/uniperif_player.c                  |    6 -
 sound/soc/sti/uniperif_reader.c                  |    2 
 sound/usb/mixer_maps.c                           |   10 ++
 sound/usb/mixer_quirks.c                         |    7 -
 37 files changed, 421 insertions(+), 148 deletions(-)

Arnd Bergmann (1):
      nds32: fix access_ok() checks in get/put_user

Brian Norris (1):
      Revert "ath: add support for special 0x0 regulatory domain"

Bryan O'Donoghue (1):
      wcn36xx: Differentiate wcn3660 from wcn3620

Chen Li (1):
      exfat: avoid incorrectly releasing for root inode

Eric Dumazet (2):
      llc: fix netdevice reference leaks in llc_ui_bind()
      llc: only change llc->dev when bind() succeeds

Giacomo Guiduzzi (1):
      ALSA: pci: fix reading of swapped values from pcmreg in AC97 codec

Giovanni Cabiddu (1):
      crypto: qat - disable registration of algorithms

Greg Kroah-Hartman (1):
      Linux 5.10.109

James Bottomley (1):
      tpm: use try_get_ops() in tpm-space.c

Jason Zheng (1):
      ALSA: hda/realtek: Add quirk for ASUS GA402

Jonathan Teh (1):
      ALSA: cmipci: Restore aux vol on suspend/resume

Jordy Zomer (1):
      nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION

Lars-Peter Clausen (1):
      ALSA: usb-audio: Add mute TLV for playback volumes on RODE NT-USB

Linus Lüssing (1):
      mac80211: fix potential double free on mesh join

Mark Cilissen (1):
      ACPI / x86: Work around broken XSDT on Advantech DAC-BJ01 board

Maximilian Luz (1):
      ACPI: battery: Add device HID and quirk for Microsoft Surface Go 3

Michal Koutný (1):
      cgroup-v1: Correct privileges check in release_agent writes

Oliver Graute (1):
      staging: fbtft: fb_st7789v: reset display before initialization

Pablo Neira Ayuso (1):
      netfilter: nf_tables: initialize registers in nft_do_chain()

Paul E. McKenney (1):
      rcu: Don't deboost before reporting expedited quiescent state

Reza Jahanbakhshi (1):
      ALSA: usb-audio: add mapping for new Corsair Virtuoso SE

Stephane Graber (1):
      drivers: net: xgene: Fix regression in CRC stripping

Tadeusz Struk (2):
      net: ipv6: fix skb_over_panic in __ip6_append_data
      tpm: Fix error handling in async work

Takashi Iwai (7):
      ASoC: sti: Fix deadlock via snd_pcm_stop_xrun() call
      ALSA: oss: Fix PCM OSS buffer allocation overflow
      ALSA: pcm: Fix races among concurrent hw_params and hw_free calls
      ALSA: pcm: Fix races among concurrent read/write and buffer changes
      ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free calls
      ALSA: pcm: Fix races among concurrent prealloc proc writes
      ALSA: pcm: Add stream lock during PCM reset ioctl operations

Tejun Heo (2):
      cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
      cgroup: Use open-time cgroup namespace for process migration perm checks

Tim Crawford (2):
      ALSA: hda/realtek: Add quirk for Clevo NP70PNJ
      ALSA: hda/realtek: Add quirk for Clevo NP50PNJ

Werner Sembach (1):
      ACPI: video: Force backlight native for Clevo NL5xRU and NL5xNU

huangwenhui (1):
      ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671

