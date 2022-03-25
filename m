Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05434E75DF
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359586AbiCYPIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359823AbiCYPIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:08:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B0CDA08C;
        Fri, 25 Mar 2022 08:06:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A31CB828FD;
        Fri, 25 Mar 2022 15:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5F7C340E9;
        Fri, 25 Mar 2022 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220784;
        bh=uD6uTbeDquRq+y7iuvesdrXvoxryN+ZU0QBCk/fsDvA=;
        h=From:To:Cc:Subject:Date:From;
        b=zlF4qQioY5QWEj46euQYGL+BW9Exxx9kJn6qvaL/jUHIaX6TupOzZ9oVsO9Og1FPw
         20SN4OyV0w+30HsEKdQFz15c+mUajxrjNAgBQ0RomtX0p0CVwhBBxQaJrd1GM1T784
         HNFSM39vm9qiIcc6wnblaWbhJwbD5YeRDCV3cWSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/17] 4.14.274-rc1 review
Date:   Fri, 25 Mar 2022 16:04:34 +0100
Message-Id: <20220325150416.756136126@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.274-rc1
X-KernelTest-Deadline: 2022-03-27T15:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.274 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.274-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.274-rc1

Linus Lüssing <ll@simonwunderlich.de>
    mac80211: fix potential double free on mesh join

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - disable registration of algorithms

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for Clevo NL5xRU and NL5xNU

Maximilian Luz <luzmaximilian@gmail.com>
    ACPI: battery: Add device HID and quirk for Microsoft Surface Go 3

Mark Cilissen <mark@yotsuba.nl>
    ACPI / x86: Work around broken XSDT on Advantech DAC-BJ01 board

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: initialize registers in nft_do_chain()

Stephane Graber <stgraber@ubuntu.com>
    drivers: net: xgene: Fix regression in CRC stripping

Giacomo Guiduzzi <guiduzzi.giacomo@gmail.com>
    ALSA: pci: fix reading of swapped values from pcmreg in AC97 codec

Jonathan Teh <jonathan.teh@outlook.com>
    ALSA: cmipci: Restore aux vol on suspend/resume

Lars-Peter Clausen <lars@metafoo.de>
    ALSA: usb-audio: Add mute TLV for playback volumes on RODE NT-USB

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Add stream lock during PCM reset ioctl operations

Eric Dumazet <edumazet@google.com>
    llc: fix netdevice reference leaks in llc_ui_bind()

Chuansheng Liu <chuansheng.liu@intel.com>
    thermal: int340x: fix memory leak in int3400_notify()

Oliver Graute <oliver.graute@kococonnector.com>
    staging: fbtft: fb_st7789v: reset display before initialization

Steffen Klassert <steffen.klassert@secunet.com>
    esp: Fix possible buffer overflow in ESP transformation

Tadeusz Struk <tadeusz.struk@linaro.org>
    net: ipv6: fix skb_over_panic in __ip6_append_data

Jordy Zomer <jordy@pwning.systems>
    nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/x86/kernel/acpi/boot.c                       | 24 ++++++++
 drivers/acpi/battery.c                            | 12 ++++
 drivers/acpi/video_detect.c                       | 75 +++++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c        |  8 +++
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c  | 12 ++--
 drivers/nfc/st21nfca/se.c                         | 10 +++
 drivers/staging/fbtft/fb_st7789v.c                |  2 +
 drivers/thermal/int340x_thermal/int3400_thermal.c |  4 ++
 include/net/esp.h                                 |  2 +
 include/net/sock.h                                |  3 +
 net/core/sock.c                                   |  3 -
 net/ipv4/esp4.c                                   |  5 ++
 net/ipv6/esp6.c                                   |  5 ++
 net/ipv6/ip6_output.c                             |  4 +-
 net/llc/af_llc.c                                  |  8 +++
 net/mac80211/cfg.c                                |  3 -
 net/netfilter/nf_tables_core.c                    |  2 +-
 sound/core/pcm_native.c                           |  4 ++
 sound/pci/ac97/ac97_codec.c                       |  4 +-
 sound/pci/cmipci.c                                |  3 +-
 sound/usb/mixer_quirks.c                          |  7 ++-
 22 files changed, 181 insertions(+), 23 deletions(-)


