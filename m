Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE34E8E92
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 09:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbiC1HFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 03:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbiC1HFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 03:05:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82D0AE57;
        Mon, 28 Mar 2022 00:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A2A4B80EAE;
        Mon, 28 Mar 2022 07:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0600BC004DD;
        Mon, 28 Mar 2022 07:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648451003;
        bh=STCzqcvRLOvG0e/JorDbYRnam8XtBBlirsDGMmdN2dQ=;
        h=From:To:Cc:Subject:Date:From;
        b=P5HNf9HP9+NmN3Mor9yBmCkm8sh1/uGtaN9miLN0zNKI0MkFP9KN8reifqSQoo4f3
         alQGDkE4znQjw2q6NUPVXsz4TmK4AtWX0FejGE5cyLW9yZ+9tntUqhhkWKR5YMVVn6
         ny/jH//HfXCjBhuzrSNOn9zqVO1wVFbEw3TIBVD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.309
Date:   Mon, 28 Mar 2022 09:03:19 +0200
Message-Id: <16484509993211@kroah.com>
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

I'm announcing the release of the 4.9.309 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 
 arch/x86/kernel/acpi/boot.c                |   24 +++++++++
 drivers/acpi/battery.c                     |   12 ++++
 drivers/acpi/video_detect.c                |   75 +++++++++++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c |    8 +++
 drivers/nfc/st21nfca/se.c                  |   10 +++
 drivers/staging/fbtft/fb_st7789v.c         |    2 
 net/ipv6/ip6_output.c                      |    4 -
 net/llc/af_llc.c                           |   49 ++++++++++++------
 net/mac80211/cfg.c                         |    3 -
 net/netfilter/nf_tables_core.c             |    2 
 sound/core/pcm_native.c                    |    4 +
 sound/pci/ac97/ac97_codec.c                |    4 -
 sound/pci/cmipci.c                         |    3 -
 sound/usb/mixer_quirks.c                   |    7 +-
 15 files changed, 178 insertions(+), 31 deletions(-)

Eric Dumazet (2):
      llc: fix netdevice reference leaks in llc_ui_bind()
      llc: only change llc->dev when bind() succeeds

Giacomo Guiduzzi (1):
      ALSA: pci: fix reading of swapped values from pcmreg in AC97 codec

Giovanni Cabiddu (1):
      crypto: qat - disable registration of algorithms

Greg Kroah-Hartman (1):
      Linux 4.9.309

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

Tadeusz Struk (1):
      net: ipv6: fix skb_over_panic in __ip6_append_data

Takashi Iwai (1):
      ALSA: pcm: Add stream lock during PCM reset ioctl operations

Werner Sembach (1):
      ACPI: video: Force backlight native for Clevo NL5xRU and NL5xNU

