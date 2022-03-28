Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CE84E901C
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 10:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbiC1I3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 04:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbiC1I24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 04:28:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14777DF0F;
        Mon, 28 Mar 2022 01:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0E6461252;
        Mon, 28 Mar 2022 08:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B7AC004DD;
        Mon, 28 Mar 2022 08:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648456035;
        bh=/SnzK8Alu8SNrgWsrRPLJAQUju1NKeRaDfceb8KuD1c=;
        h=From:To:Cc:Subject:Date:From;
        b=Qswf0RyuJNITYRKl98JmzGw6xf4JkAtNfE1RJ6rbh1hZAag4t2EoPfoEKD2BzBziy
         Zpli4JkNRcrc5bfElmm+0vn4oAyvJRq7CbpStD8AKs8h8OuUXke4qDgkRGmqsw/yZL
         MKRx/hQ/U3rFTjpzJtTv0FlD+Dasidtw2utVdEZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.16.18
Date:   Mon, 28 Mar 2022 10:27:11 +0200
Message-Id: <164845603135138@kroah.com>
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

I'm announcing the release of the 5.16.18 kernel.

All users of the 5.16 kernel series must upgrade.

The updated 5.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.16.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 
 arch/csky/include/asm/uaccess.h                  |    7 -
 arch/hexagon/include/asm/uaccess.h               |   18 ++--
 arch/m68k/include/asm/uaccess.h                  |   15 ++-
 arch/microblaze/include/asm/uaccess.h            |   19 ----
 arch/nds32/include/asm/uaccess.h                 |   22 ++++-
 arch/x86/kernel/acpi/boot.c                      |   24 +++++
 drivers/acpi/battery.c                           |   12 ++
 drivers/acpi/video_detect.c                      |   75 +++++++++++++++++
 drivers/bluetooth/btusb.c                        |    4 
 drivers/char/tpm/tpm-dev-common.c                |    8 +
 drivers/char/tpm/tpm2-space.c                    |    8 -
 drivers/crypto/qat/qat_4xxx/adf_drv.c            |    7 +
 drivers/crypto/qat/qat_common/qat_crypto.c       |    7 +
 drivers/gpu/drm/virtio/virtgpu_gem.c             |    3 
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c |   12 +-
 drivers/net/wireless/ath/regd.c                  |   10 +-
 drivers/net/wireless/ath/wcn36xx/main.c          |    3 
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h       |    1 
 drivers/nfc/st21nfca/se.c                        |   10 ++
 include/sound/pcm.h                              |    1 
 kernel/rcu/tree_plugin.h                         |    8 -
 net/ipv6/ip6_output.c                            |    4 
 net/llc/af_llc.c                                 |   48 +++++++----
 net/mac80211/cfg.c                               |    3 
 net/netfilter/nf_tables_api.c                    |   22 ++++-
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
 40 files changed, 380 insertions(+), 142 deletions(-)

Arnd Bergmann (3):
      uaccess: fix integer overflow on access_ok()
      m68k: fix access_ok for coldfire
      nds32: fix access_ok() checks in get/put_user

Brian Norris (1):
      Revert "ath: add support for special 0x0 regulatory domain"

Bryan O'Donoghue (1):
      wcn36xx: Differentiate wcn3660 from wcn3620

Eric Dumazet (2):
      llc: fix netdevice reference leaks in llc_ui_bind()
      llc: only change llc->dev when bind() succeeds

Giacomo Guiduzzi (1):
      ALSA: pci: fix reading of swapped values from pcmreg in AC97 codec

Giovanni Cabiddu (1):
      crypto: qat - disable registration of algorithms

Greg Kroah-Hartman (1):
      Linux 5.16.18

Helmut Grohne (1):
      Bluetooth: btusb: Add another Realtek 8761BU

James Bottomley (1):
      tpm: use try_get_ops() in tpm-space.c

Jason Zheng (1):
      ALSA: hda/realtek: Add quirk for ASUS GA402

Jonathan Teh (1):
      ALSA: cmipci: Restore aux vol on suspend/resume

Jordy Zomer (1):
      nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION

Larry Finger (1):
      Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE

Lars-Peter Clausen (1):
      ALSA: usb-audio: Add mute TLV for playback volumes on RODE NT-USB

Linus Lüssing (1):
      mac80211: fix potential double free on mesh join

Mark Cilissen (1):
      ACPI / x86: Work around broken XSDT on Advantech DAC-BJ01 board

Maximilian Luz (1):
      ACPI: battery: Add device HID and quirk for Microsoft Surface Go 3

Pablo Neira Ayuso (2):
      netfilter: nf_tables: initialize registers in nft_do_chain()
      netfilter: nf_tables: validate registers coming from userspace.

Paul E. McKenney (1):
      rcu: Don't deboost before reporting expedited quiescent state

Reza Jahanbakhshi (1):
      ALSA: usb-audio: add mapping for new Corsair Virtuoso SE

Roberto Sassu (1):
      drm/virtio: Ensure that objs is not NULL in virtio_gpu_array_put_free()

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

Tim Crawford (2):
      ALSA: hda/realtek: Add quirk for Clevo NP70PNJ
      ALSA: hda/realtek: Add quirk for Clevo NP50PNJ

Werner Sembach (1):
      ACPI: video: Force backlight native for Clevo NL5xRU and NL5xNU

huangwenhui (1):
      ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671

