Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA67240882
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHJPUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbgHJPUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E381F2075F;
        Mon, 10 Aug 2020 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072808;
        bh=g4AkQXQ8epWXJR1F/Mkz5pr4PwZfYD7rBhbIngIE3o4=;
        h=From:To:Cc:Subject:Date:From;
        b=HRemLRYDybuoZV+Yhp4Oou/BsTcYU49rY3O9CHpIJPbU4+abz51+1h3Tg7Z/X9kl0
         KJ09alfXsoYL4k2LhkQr5SMM/XZj81nPZx8BVl7yM0jnyaxiVHMZ4g01iH5Czgla9a
         SeUth7CnOSC1eIjE366ygZF9Lm/D4hAImOaAVltw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.8 00/38] 5.8.1-rc1 review
Date:   Mon, 10 Aug 2020 17:18:50 +0200
Message-Id: <20200810151803.920113428@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.1-rc1
X-KernelTest-Deadline: 2020-08-12T15:18+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.1 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.1-rc1

Guenter Roeck <linux@roeck-us.net>
    arm64: kaslr: Use standard early random function

Linus Torvalds <torvalds@linux-foundation.org>
    random: random.h should include archrandom.h, not the other way around

Linus Torvalds <torvalds@linux-foundation.org>
    random32: move the pseudo-random 32-bit definitions to prandom.h

Bruno Meneguele <bmeneg@redhat.com>
    ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY to runtime

Nicolas Chauvet <kwizart@gmail.com>
    PCI: tegra: Revert tegra124 raw_violation_fixup

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/kasan: Fix shadow pages allocation failure

Christophe Leroy <christophe.leroy@csgroup.eu>
    Revert "powerpc/kasan: Fix shadow pages allocation failure"

Frank van der Linden <fllinden@amazon.com>
    xattr: break delegations in {set,remove}xattr

Dmitry Osipenko <digetx@gmail.com>
    gpio: max77620: Fix missing release of interrupt

Johan Hovold <johan@kernel.org>
    leds: 88pm860x: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: lm3533: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: da903x: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: lm36274: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    leds: wm831x-status: fix use-after-free on unbind

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mtd: properly check all write ioctls for permissions

Yunhai Zhang <zhangyunhai@nsfocus.com>
    vgacon: Fix for missing check in scrollback handling

Kees Cook <keescook@chromium.org>
    lkdtm/heap: Avoid edge and middle of slabs

Matthias Maennich <maennich@google.com>
    scripts: add dummy report mode to add_namespace.cocci

Eric Biggers <ebiggers@google.com>
    Smack: fix use-after-free in smk_write_relabel_self()

Jann Horn <jannh@google.com>
    binder: Prevent context manager from incrementing ref 0

Adam Ford <aford173@gmail.com>
    omapfb: dss: Fix max fclk divider for omap36xx

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_with_rssi_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Prevent out-of-bounds read in hci_inquiry_result_evt()

Peilin Ye <yepeilin.cs@gmail.com>
    Bluetooth: Fix slab-out-of-bounds read in hci_extended_inquiry_result_evt()

Dinghao Liu <dinghao.liu@zju.edu.cn>
    Staging: rtl8188eu: rtw_mlme: Fix uninitialized variable authmode

Rustam Kovhaev <rkovhaev@gmail.com>
    staging: rtl8712: handle firmware load failure

Suren Baghdasaryan <surenb@google.com>
    staging: android: ashmem: Fix lockdep warning for write operation

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Serialize ioctls

Connor McAdams <conmanx360@gmail.com>
    ALSA: hda/ca0132 - Fix AE-5 microphone selection commands.

Connor McAdams <conmanx360@gmail.com>
    ALSA: hda/ca0132 - Fix ZxR Headphone gain control get value.

Connor McAdams <conmanx360@gmail.com>
    ALSA: hda/ca0132 - Add new quirk ID for Recon3D.

Huacai Chen <chenhc@lemote.com>
    ALSA: hda/realtek: Add alc269/alc662 pin-tables for Loongson-3 laptops

Hui Wang <hui.wang@canonical.com>
    Revert "ALSA: hda: call runtime_allow() for all hda controllers"

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: Fix ASMedia ASM1142 DMA addressing

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: define IDs for various ASMedia host controllers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: iowarrior: fix up report size handling for some devices

Erik Ekman <erik@kryo.se>
    USB: serial: qcserial: add EM7305 QDL product ID

Stanley Chu <stanley.chu@mediatek.com>
    scsi: ufs: Fix and simplify setup_xfer_req variant operation


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/arm64/include/asm/archrandom.h         |   1 -
 arch/arm64/kernel/kaslr.c                   |  14 ++--
 arch/powerpc/include/asm/kasan.h            |   2 +
 arch/powerpc/mm/init_32.c                   |   2 +
 arch/powerpc/mm/kasan/kasan_init_32.c       |  29 ++++---
 drivers/android/binder.c                    |  15 +++-
 drivers/gpio/gpio-max77620.c                |   5 +-
 drivers/leds/leds-88pm860x.c                |  14 +++-
 drivers/leds/leds-da903x.c                  |  14 +++-
 drivers/leds/leds-lm3533.c                  |  12 ++-
 drivers/leds/leds-lm36274.c                 |  15 +++-
 drivers/leds/leds-wm831x-status.c           |  14 +++-
 drivers/misc/lkdtm/heap.c                   |   9 ++-
 drivers/mtd/mtdchar.c                       |  56 +++++++++++---
 drivers/pci/controller/pci-tegra.c          |  32 --------
 drivers/scsi/ufs/ufshcd.c                   |   9 ++-
 drivers/staging/android/ashmem.c            |  12 +++
 drivers/staging/rtl8188eu/core/rtw_mlme.c   |   4 +-
 drivers/staging/rtl8712/hal_init.c          |   3 +-
 drivers/staging/rtl8712/usb_intf.c          |  11 ++-
 drivers/usb/host/xhci-pci.c                 |  10 ++-
 drivers/usb/misc/iowarrior.c                |  35 ++++++---
 drivers/usb/serial/qcserial.c               |   1 +
 drivers/video/console/vgacon.c              |   4 +
 drivers/video/fbdev/omap2/omapfb/dss/dss.c  |   2 +-
 fs/xattr.c                                  |  84 ++++++++++++++++++--
 include/linux/prandom.h                     |  78 +++++++++++++++++++
 include/linux/random.h                      |  66 +---------------
 include/linux/xattr.h                       |   2 +
 net/bluetooth/hci_event.c                   |  11 ++-
 scripts/coccinelle/misc/add_namespace.cocci |   8 +-
 scripts/nsdeps                              |   2 +-
 security/integrity/ima/Kconfig              |   2 +-
 security/integrity/ima/ima_appraise.c       |   6 ++
 security/smack/smackfs.c                    |  13 +++-
 sound/core/seq/oss/seq_oss.c                |   8 +-
 sound/pci/hda/hda_intel.c                   |   1 -
 sound/pci/hda/patch_ca0132.c                |  12 ++-
 sound/pci/hda/patch_realtek.c               | 114 ++++++++++++++++++++++++++++
 40 files changed, 549 insertions(+), 187 deletions(-)


