Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779804E763D
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359738AbiCYPMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359691AbiCYPLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:11:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B67D60DAB;
        Fri, 25 Mar 2022 08:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B759361BF5;
        Fri, 25 Mar 2022 15:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35F7C36AF7;
        Fri, 25 Mar 2022 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220915;
        bh=Wlq/oLzI08+KWmJ95ICd3mxc5cfHdv3bEqCAF5HDVwc=;
        h=From:To:Cc:Subject:Date:From;
        b=np+zg3UdE868ZMztsBMlhKY4B5SJoeIjHEALIogEimXG4ZpzSbuXon0/mQ7ckURvA
         j2t3eptIKtXH5PM7V9VY1zahnCaMOVJe98cOt49MC8ZcNssotX4QLwKVrPFoG41KPq
         cm0soZCECcPf+si2ixre7LofjaOhz+CksRgBClJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/29] 5.4.188-rc1 review
Date:   Fri, 25 Mar 2022 16:04:40 +0100
Message-Id: <20220325150418.585286754@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.188-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.188-rc1
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

This is the start of the stable review cycle for the 5.4.188 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.188-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.188-rc1

Arnd Bergmann <arnd@arndb.de>
    nds32: fix access_ok() checks in get/put_user

James Bottomley <James.Bottomley@HansenPartnership.com>
    tpm: use try_get_ops() in tpm-space.c

Linus Lüssing <ll@simonwunderlich.de>
    mac80211: fix potential double free on mesh join

Paul E. McKenney <paulmck@kernel.org>
    rcu: Don't deboost before reporting expedited quiescent state

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

Jason Zheng <jasonzheng2004@gmail.com>
    ALSA: hda/realtek: Add quirk for ASUS GA402

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671

Takashi Iwai <tiwai@suse.de>
    ALSA: oss: Fix PCM OSS buffer allocation overflow

Takashi Iwai <tiwai@suse.de>
    ASoC: sti: Fix deadlock via snd_pcm_stop_xrun() call

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

Halil Pasic <pasic@linux.ibm.com>
    swiotlb: rework "fix info leak with DMA_FROM_DEVICE"

Halil Pasic <pasic@linux.ibm.com>
    swiotlb: fix info leak with DMA_FROM_DEVICE

Eric Dumazet <edumazet@google.com>
    llc: fix netdevice reference leaks in llc_ui_bind()

Chuansheng Liu <chuansheng.liu@intel.com>
    thermal: int340x: fix memory leak in int3400_notify()

Oliver Graute <oliver.graute@kococonnector.com>
    staging: fbtft: fb_st7789v: reset display before initialization

Tadeusz Struk <tstruk@gmail.com>
    tpm: Fix error handling in async work

Steffen Klassert <steffen.klassert@secunet.com>
    esp: Fix possible buffer overflow in ESP transformation

Tadeusz Struk <tadeusz.struk@linaro.org>
    net: ipv6: fix skb_over_panic in __ip6_append_data

Jordy Zomer <jordy@pwning.systems>
    nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION

Trond Myklebust <trondmy@gmail.com>
    nfsd: Containerise filecache laundrette

Trond Myklebust <trondmy@gmail.com>
    nfsd: cleanup nfsd_file_lru_dispose()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/nds32/include/asm/uaccess.h                   |  22 +-
 arch/x86/kernel/acpi/boot.c                        |  24 ++
 drivers/acpi/battery.c                             |  12 +
 drivers/acpi/video_detect.c                        |  75 +++++++
 drivers/char/tpm/tpm-dev-common.c                  |   8 +-
 drivers/char/tpm/tpm2-space.c                      |   8 +-
 drivers/crypto/qat/qat_common/qat_crypto.c         |   8 +
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |  12 +-
 drivers/nfc/st21nfca/se.c                          |  10 +
 drivers/staging/fbtft/fb_st7789v.c                 |   2 +
 .../intel/int340x_thermal/int3400_thermal.c        |   4 +
 fs/nfsd/filecache.c                                | 247 +++++++++++++++++----
 fs/nfsd/filecache.h                                |   2 +
 fs/nfsd/nfssvc.c                                   |   9 +-
 include/net/esp.h                                  |   2 +
 include/net/sock.h                                 |   3 +
 kernel/dma/swiotlb.c                               |  24 +-
 kernel/rcu/tree_plugin.h                           |   9 +-
 net/core/sock.c                                    |   2 -
 net/ipv4/esp4.c                                    |   5 +
 net/ipv6/esp6.c                                    |   5 +
 net/ipv6/ip6_output.c                              |   4 +-
 net/llc/af_llc.c                                   |   8 +
 net/mac80211/cfg.c                                 |   3 -
 net/netfilter/nf_tables_core.c                     |   2 +-
 sound/core/oss/pcm_oss.c                           |  12 +-
 sound/core/oss/pcm_plugin.c                        |   5 +-
 sound/core/pcm_native.c                            |   4 +
 sound/pci/ac97/ac97_codec.c                        |   4 +-
 sound/pci/cmipci.c                                 |   3 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/sti/uniperif_player.c                    |   6 +-
 sound/soc/sti/uniperif_reader.c                    |   2 +-
 sound/usb/mixer_quirks.c                           |   7 +-
 35 files changed, 459 insertions(+), 100 deletions(-)


