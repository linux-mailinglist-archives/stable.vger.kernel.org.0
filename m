Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A9A4E8EA3
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 09:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbiC1HFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 03:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238731AbiC1HFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 03:05:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8F314002;
        Mon, 28 Mar 2022 00:03:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E339F6117E;
        Mon, 28 Mar 2022 07:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7FFC340F0;
        Mon, 28 Mar 2022 07:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648451027;
        bh=wqvwXkIbY76z0Ywi95MIYSwpU5KO+LR4qy5462lWoLo=;
        h=From:To:Cc:Subject:Date:From;
        b=ABm6rs+SumZi0DVuQEdp1oXBGsCvKy/6yQSVUUkwRkwpHYkb8QAcJM/dAkyrU6yWl
         wiEtjl2xpLQZ95Zao3OgBZ4VmjfhS6/G/gtEdesFdU2ggovF1KPvydlsJp+WWCM2Bn
         VSXqvD/E1LKZQ9IFRznKqjzmhRb0hbvc+1jBkaF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.188
Date:   Mon, 28 Mar 2022 09:03:38 +0200
Message-Id: <164845101973162@kroah.com>
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

I'm announcing the release of the 5.4.188 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/nds32/include/asm/uaccess.h                        |   22 +
 arch/x86/kernel/acpi/boot.c                             |   24 +
 drivers/acpi/battery.c                                  |   12 
 drivers/acpi/video_detect.c                             |   75 ++++
 drivers/char/tpm/tpm-dev-common.c                       |    8 
 drivers/char/tpm/tpm2-space.c                           |    8 
 drivers/crypto/qat/qat_common/qat_crypto.c              |    8 
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c        |   12 
 drivers/nfc/st21nfca/se.c                               |   10 
 drivers/staging/fbtft/fb_st7789v.c                      |    2 
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c |    4 
 fs/nfsd/filecache.c                                     |  247 +++++++++++++---
 fs/nfsd/filecache.h                                     |    2 
 fs/nfsd/nfssvc.c                                        |    9 
 include/net/esp.h                                       |    2 
 include/net/sock.h                                      |    3 
 kernel/rcu/tree_plugin.h                                |    9 
 net/core/sock.c                                         |    2 
 net/ipv4/esp4.c                                         |    5 
 net/ipv6/esp6.c                                         |    5 
 net/ipv6/ip6_output.c                                   |    4 
 net/llc/af_llc.c                                        |   49 ++-
 net/mac80211/cfg.c                                      |    3 
 net/netfilter/nf_tables_core.c                          |    2 
 sound/core/oss/pcm_oss.c                                |   12 
 sound/core/oss/pcm_plugin.c                             |    5 
 sound/core/pcm_native.c                                 |    4 
 sound/pci/ac97/ac97_codec.c                             |    4 
 sound/pci/cmipci.c                                      |    3 
 sound/pci/hda/patch_realtek.c                           |    2 
 sound/soc/sti/uniperif_player.c                         |    6 
 sound/soc/sti/uniperif_reader.c                         |    2 
 sound/usb/mixer_quirks.c                                |    7 
 34 files changed, 466 insertions(+), 108 deletions(-)

Arnd Bergmann (1):
      nds32: fix access_ok() checks in get/put_user

Chuansheng Liu (1):
      thermal: int340x: fix memory leak in int3400_notify()

Eric Dumazet (2):
      llc: fix netdevice reference leaks in llc_ui_bind()
      llc: only change llc->dev when bind() succeeds

Giacomo Guiduzzi (1):
      ALSA: pci: fix reading of swapped values from pcmreg in AC97 codec

Giovanni Cabiddu (1):
      crypto: qat - disable registration of algorithms

Greg Kroah-Hartman (1):
      Linux 5.4.188

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

Oliver Graute (1):
      staging: fbtft: fb_st7789v: reset display before initialization

Pablo Neira Ayuso (1):
      netfilter: nf_tables: initialize registers in nft_do_chain()

Paul E. McKenney (1):
      rcu: Don't deboost before reporting expedited quiescent state

Steffen Klassert (1):
      esp: Fix possible buffer overflow in ESP transformation

Stephane Graber (1):
      drivers: net: xgene: Fix regression in CRC stripping

Tadeusz Struk (2):
      net: ipv6: fix skb_over_panic in __ip6_append_data
      tpm: Fix error handling in async work

Takashi Iwai (3):
      ALSA: pcm: Add stream lock during PCM reset ioctl operations
      ASoC: sti: Fix deadlock via snd_pcm_stop_xrun() call
      ALSA: oss: Fix PCM OSS buffer allocation overflow

Trond Myklebust (2):
      nfsd: cleanup nfsd_file_lru_dispose()
      nfsd: Containerise filecache laundrette

Werner Sembach (1):
      ACPI: video: Force backlight native for Clevo NL5xRU and NL5xNU

huangwenhui (1):
      ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671

