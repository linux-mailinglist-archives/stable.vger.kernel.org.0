Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B93F4E7783
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377226AbiCYP2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378194AbiCYPZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:25:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2A7ECB37;
        Fri, 25 Mar 2022 08:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 402B3B8288D;
        Fri, 25 Mar 2022 15:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664EEC36AF5;
        Fri, 25 Mar 2022 15:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221598;
        bh=tyJYj+fpxLpvdG2p7A9uxdypB6t8FHWIm7rc35P0H9g=;
        h=From:To:Cc:Subject:Date:From;
        b=FmVUQLmbfDq7wZURXBgOLBvXsy891qotw8CAXQ4My7RDsOpLwMoAZclUIP8UrRJfQ
         5pirGVENa32DWJaXWPmS2RozUV/xVBONc84I4HpTvqbm2y//j+p6IWN0IT6RKfDnTR
         2nbaBboprBwS/faLOSPJ27IUN/F3oLS5hgk2+Gw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.17 00/39] 5.17.1-rc1 review
Date:   Fri, 25 Mar 2022 16:14:15 +0100
Message-Id: <20220325150420.245733653@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.17.1-rc1
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

This is the start of the stable review cycle for the 5.17.1 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.17.1-rc1

Arnd Bergmann <arnd@arndb.de>
    nds32: fix access_ok() checks in get/put_user

Arnd Bergmann <arnd@arndb.de>
    m68k: fix access_ok for coldfire

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Differentiate wcn3660 from wcn3620

James Bottomley <James.Bottomley@HansenPartnership.com>
    tpm: use try_get_ops() in tpm-space.c

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    tpm: fix reference counting for struct tpm_chip

Linus Lüssing <ll@simonwunderlich.de>
    mac80211: fix potential double free on mesh join

Arnd Bergmann <arnd@arndb.de>
    uaccess: fix integer overflow on access_ok()

Paul E. McKenney <paulmck@kernel.org>
    rcu: Don't deboost before reporting expedited quiescent state

Ritesh Harjani <riteshh@linux.ibm.com>
    jbd2: fix use-after-free of transaction_t race

Roberto Sassu <roberto.sassu@huawei.com>
    drm/virtio: Ensure that objs is not NULL in virtio_gpu_array_put_free()

Brian Norris <briannorris@chromium.org>
    Revert "ath: add support for special 0x0 regulatory domain"

Ismael Ferreras Morezuelas <swyterzone@gmail.com>
    Bluetooth: btusb: Use quirk to skip HCI_FLT_CLEAR_ALL on fake CSR controllers

Ismael Ferreras Morezuelas <swyterzone@gmail.com>
    Bluetooth: hci_sync: Add a new quirk to skip HCI_FLT_CLEAR_ALL

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
 drivers/bluetooth/btusb.c                        | 10 ++-
 drivers/char/tpm/tpm-chip.c                      | 46 ++---------
 drivers/char/tpm/tpm-dev-common.c                |  8 +-
 drivers/char/tpm/tpm.h                           |  2 +
 drivers/char/tpm/tpm2-space.c                    | 73 +++++++++++++++++-
 drivers/crypto/qat/qat_4xxx/adf_drv.c            |  7 ++
 drivers/crypto/qat/qat_common/qat_crypto.c       |  7 ++
 drivers/gpu/drm/virtio/virtgpu_gem.c             |  3 +
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 12 +--
 drivers/net/wireless/ath/regd.c                  | 10 +--
 drivers/net/wireless/ath/wcn36xx/main.c          |  3 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h       |  1 +
 fs/jbd2/transaction.c                            | 41 ++++++----
 include/net/bluetooth/hci.h                      | 10 +++
 include/sound/pcm.h                              |  1 +
 kernel/rcu/tree_plugin.h                         |  8 +-
 net/bluetooth/hci_sync.c                         | 16 ++++
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
 43 files changed, 475 insertions(+), 181 deletions(-)


