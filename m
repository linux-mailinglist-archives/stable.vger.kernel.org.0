Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718C34E76C7
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359868AbiCYPTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376518AbiCYPTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:19:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFE2DF4A2;
        Fri, 25 Mar 2022 08:15:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D2A7618F2;
        Fri, 25 Mar 2022 15:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B71C340F4;
        Fri, 25 Mar 2022 15:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221284;
        bh=N55awgTJ/oXHfQdCl+2Ibp0LggQcczplugqVYTM5ago=;
        h=From:To:Cc:Subject:Date:From;
        b=026dbLHJnte5fJNDsjiYqsO8y9IE6ESnHpR9Ktf4SrJTP9tnZPmJX06GCrW7PXiZU
         NoYRYVNIGOBXvdbf1R265iL/PAfpBV/Vgz4c4ctf0/QtXg/1g7Qgfv/YQ/0pek4z/H
         6/YwBAfFa0J3KiI2CMEqlx2XzSAldsgY0uJlbtjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 00/37] 5.15.32-rc1 review
Date:   Fri, 25 Mar 2022 16:14:01 +0100
Message-Id: <20220325150419.931802116@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.32-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.32-rc1
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

This is the start of the stable review cycle for the 5.15.32 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.32-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.32-rc1

Arnd Bergmann <arnd@arndb.de>
    nds32: fix access_ok() checks in get/put_user

Arnd Bergmann <arnd@arndb.de>
    m68k: fix access_ok for coldfire

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Differentiate wcn3660 from wcn3620

James Bottomley <James.Bottomley@HansenPartnership.com>
    tpm: use try_get_ops() in tpm-space.c

Linus Lüssing <ll@simonwunderlich.de>
    mac80211: fix potential double free on mesh join

Arnd Bergmann <arnd@arndb.de>
    uaccess: fix integer overflow on access_ok()

Paul E. McKenney <paulmck@kernel.org>
    rcu: Don't deboost before reporting expedited quiescent state

Roberto Sassu <roberto.sassu@huawei.com>
    drm/virtio: Ensure that objs is not NULL in virtio_gpu_array_put_free()

Brian Norris <briannorris@chromium.org>
    Revert "ath: add support for special 0x0 regulatory domain"

Larry Finger <Larry.Finger@lwfinger.net>
    Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - disable registration of algorithms

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for Clevo NL5xRU and NL5xNU

Maximilian Luz <luzmaximilian@gmail.com>
    ACPI: battery: Add device HID and quirk for Microsoft Surface Go 3

Mark Cilissen <mark@yotsuba.nl>
    ACPI / x86: Work around broken XSDT on Advantech DAC-BJ01 board

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: validate registers coming from userspace.

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

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent prealloc proc writes

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free calls

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent read/write and buffer changes

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix races among concurrent hw_params and hw_free calls

Jason Zheng <jasonzheng2004@gmail.com>
    ALSA: hda/realtek: Add quirk for ASUS GA402

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo NP50PNJ

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo NP70PNJ

Reza Jahanbakhshi <reza.jahanbakhshi@gmail.com>
    ALSA: usb-audio: add mapping for new Corsair Virtuoso SE

Takashi Iwai <tiwai@suse.de>
    ALSA: oss: Fix PCM OSS buffer allocation overflow

Takashi Iwai <tiwai@suse.de>
    ASoC: sti: Fix deadlock via snd_pcm_stop_xrun() call

Eric Dumazet <edumazet@google.com>
    llc: fix netdevice reference leaks in llc_ui_bind()

Helmut Grohne <helmut@subdivi.de>
    Bluetooth: btusb: Add another Realtek 8761BU

Tadeusz Struk <tstruk@gmail.com>
    tpm: Fix error handling in async work

Tadeusz Struk <tadeusz.struk@linaro.org>
    net: ipv6: fix skb_over_panic in __ip6_append_data

Jordy Zomer <jordy@pwning.systems>
    nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION


-------------

Diffstat:

 Makefile                                         |  4 +-
 arch/csky/include/asm/uaccess.h                  |  7 +-
 arch/hexagon/include/asm/uaccess.h               | 18 ++---
 arch/m68k/include/asm/uaccess.h                  | 15 ++--
 arch/microblaze/include/asm/uaccess.h            | 19 +----
 arch/nds32/include/asm/uaccess.h                 | 22 ++++--
 arch/x86/kernel/acpi/boot.c                      | 24 ++++++
 drivers/acpi/battery.c                           | 12 +++
 drivers/acpi/video_detect.c                      | 75 ++++++++++++++++++
 drivers/bluetooth/btusb.c                        |  4 +
 drivers/char/tpm/tpm-dev-common.c                |  8 +-
 drivers/char/tpm/tpm2-space.c                    |  8 +-
 drivers/crypto/qat/qat_4xxx/adf_drv.c            |  7 ++
 drivers/crypto/qat/qat_common/qat_crypto.c       |  7 ++
 drivers/gpu/drm/virtio/virtgpu_gem.c             |  3 +
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 12 +--
 drivers/net/wireless/ath/regd.c                  | 10 +--
 drivers/net/wireless/ath/wcn36xx/main.c          |  3 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h       |  1 +
 drivers/nfc/st21nfca/se.c                        | 10 +++
 include/sound/pcm.h                              |  1 +
 kernel/rcu/tree_plugin.h                         |  8 +-
 net/ipv6/ip6_output.c                            |  4 +-
 net/llc/af_llc.c                                 |  8 ++
 net/mac80211/cfg.c                               |  3 -
 net/netfilter/nf_tables_api.c                    | 22 ++++--
 net/netfilter/nf_tables_core.c                   |  2 +-
 sound/core/oss/pcm_oss.c                         | 12 ++-
 sound/core/oss/pcm_plugin.c                      |  5 +-
 sound/core/pcm.c                                 |  2 +
 sound/core/pcm_lib.c                             |  4 +
 sound/core/pcm_memory.c                          | 11 ++-
 sound/core/pcm_native.c                          | 97 +++++++++++++++---------
 sound/pci/ac97/ac97_codec.c                      |  4 +-
 sound/pci/cmipci.c                               |  3 +-
 sound/pci/hda/patch_realtek.c                    |  4 +
 sound/soc/sti/uniperif_player.c                  |  6 +-
 sound/soc/sti/uniperif_reader.c                  |  2 +-
 sound/usb/mixer_maps.c                           | 10 +++
 sound/usb/mixer_quirks.c                         |  7 +-
 40 files changed, 357 insertions(+), 127 deletions(-)


