Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A032347250E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhLMJkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbhLMJjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:39:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06717C061201;
        Mon, 13 Dec 2021 01:37:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C5C5CE0E77;
        Mon, 13 Dec 2021 09:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F41C341C8;
        Mon, 13 Dec 2021 09:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388251;
        bh=uTBQtCXEDAWgHWFfM7RvpaxcN+a5IwfH98QFUOpf9+I=;
        h=From:To:Cc:Subject:Date:From;
        b=0F5EAwGjcHc0jBAIRhjRkhFBHpYghdOUUQXEU7ZMTkF/zRWDnF6/KyEmfD9fPpIpz
         mhnF4yg9a7sXzK1L/EhOhho6cIYdIwvKiFwMVj6+Z8NvyH9a1f+IIJH5+Wq1zRH8vd
         cLSaLlCDZCPfWV1otGw9MwGOssrF+sOLmp+ZWqwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/53] 4.14.258-rc1 review
Date:   Mon, 13 Dec 2021 10:29:39 +0100
Message-Id: <20211213092928.349556070@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.258-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.258-rc1
X-KernelTest-Deadline: 2021-12-15T09:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.258 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.258-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.258-rc1

Vladimir Murzin <vladimir.murzin@arm.com>
    irqchip: nvic: Fix offset for Interrupt Priority Offsets

Wudi Wang <wangwudi@hisilicon.com>
    irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Fix support for Multi-MSI interrupts

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Fix return value of armada_370_xp_msi_alloc()

Yang Yingliang <yangyingliang@huawei.com>
    iio: accel: kxcjk-1013: Fix possible memory leak in probe and remove

Evgeny Boger <boger@wirenboard.com>
    iio: adc: axp20x_adc: fix charging current reporting on AXP22x

Lars-Peter Clausen <lars@metafoo.de>
    iio: dln2: Check return value of devm_iio_trigger_register()

Noralf Trønnes <noralf@tronnes.org>
    iio: dln2-adc: Fix lockdep complaint

Lars-Peter Clausen <lars@metafoo.de>
    iio: itg3200: Call iio_trigger_notify_done() on error

Lars-Peter Clausen <lars@metafoo.de>
    iio: kxsd9: Don't return error code in trigger handler

Lars-Peter Clausen <lars@metafoo.de>
    iio: ltr501: Don't return error code in trigger handler

Lars-Peter Clausen <lars@metafoo.de>
    iio: mma8452: Fix trigger reference couting

Lars-Peter Clausen <lars@metafoo.de>
    iio: stk3310: Don't return error code in interrupt handler

Alyssa Ross <hi@alyssa.is>
    iio: trigger: stm32-timer: fix MODULE_ALIAS

Lars-Peter Clausen <lars@metafoo.de>
    iio: trigger: Fix reference counting

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: core: config: using bit mask instead of individual bits

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Remove CONFIG_USB_DEFAULT_PERSIST to prevent xHCI from runtime suspending

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: core: config: fix validation of wMaxPacketValue entries

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: zero allocate endpoint 0 buffers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: detect too-big endpoint 0 requests

Dan Carpenter <dan.carpenter@oracle.com>
    net/qla3xxx: fix an error code in ql_adapter_up()

Eric Dumazet <edumazet@google.com>
    net, neigh: clear whole pneigh_entry at alloc time

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()

Dan Carpenter <dan.carpenter@oracle.com>
    net: altera: set a couple error code in probe()

Lee Jones <lee.jones@linaro.org>
    net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero

Manish Chopra <manishc@marvell.com>
    qede: validate non LSO skb length

Davidlohr Bueso <dave@stgolabs.net>
    block: fix ioprio_get(IOPRIO_WHO_PGRP) vs setuid(2)

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Set all files to the same group ownership as the mount option

Eric Biggers <ebiggers@google.com>
    signalfd: use wake_up_pollfree()

Eric Biggers <ebiggers@google.com>
    binder: use wake_up_pollfree()

Eric Biggers <ebiggers@google.com>
    wait: add wake_up_pollfree()

Hannes Reinecke <hare@suse.de>
    libata: add horkage for ASMedia 1092

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sme: Explicitly map new EFI memmap table as encrypted

Brian Silverman <brian.silverman@bluerivertech.com>
    can: m_can: Disable and ignore ELO interrupt

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: pch_can: pch_can_rx_normal: fix use after free

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracefs: Have new files inherit the ownership of their parent

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Handle missing errors in snd_pcm_oss_change_params*()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Limit the period size to 16MB

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix negative period/buffer sizes

Alan Young <consult.awy@gmail.com>
    ALSA: ctl: Fix copy of updated id with element read/write

Manjong Lee <mj0123.lee@samsung.com>
    mm: bdi: initialize bdi_min_ratio when bdi is unregistered

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Correct guard on eager buffer deallocation

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix the iif in the IPv6 socket control block

Jianglei Nie <niejianglei2021@163.com>
    nfp: Fix memory leak in nfp_cpp_area_cache_add()

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Fix the off-by-two error in range markings

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done

Dan Carpenter <dan.carpenter@oracle.com>
    can: sja1000: fix use after free in ems_pcmcia_add_card()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: check for valid USB device for many HID drivers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: wacom: fix problems when device is not a valid USB device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add USB_HID dependancy on some USB HID drivers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add USB_HID dependancy to hid-chicony

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add USB_HID dependancy to hid-prodikeys

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: add hid_is_usb() function to make it simpler for USB detection


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/Kconfig                                   |  1 +
 arch/x86/platform/efi/quirks.c                     |  3 +-
 block/ioprio.c                                     |  3 +
 drivers/android/binder.c                           | 21 +++---
 drivers/ata/libata-core.c                          |  2 +
 drivers/hid/Kconfig                                | 10 +--
 drivers/hid/hid-asus.c                             |  2 +-
 drivers/hid/hid-chicony.c                          |  8 ++-
 drivers/hid/hid-corsair.c                          |  7 +-
 drivers/hid/hid-elo.c                              |  3 +
 drivers/hid/hid-holtek-kbd.c                       |  9 ++-
 drivers/hid/hid-holtek-mouse.c                     |  9 +++
 drivers/hid/hid-lg.c                               | 10 ++-
 drivers/hid/hid-prodikeys.c                        | 10 ++-
 drivers/hid/hid-roccat-arvo.c                      |  3 +
 drivers/hid/hid-roccat-isku.c                      |  3 +
 drivers/hid/hid-roccat-kone.c                      |  3 +
 drivers/hid/hid-roccat-koneplus.c                  |  3 +
 drivers/hid/hid-roccat-konepure.c                  |  3 +
 drivers/hid/hid-roccat-kovaplus.c                  |  3 +
 drivers/hid/hid-roccat-lua.c                       |  3 +
 drivers/hid/hid-roccat-pyra.c                      |  3 +
 drivers/hid/hid-roccat-ryos.c                      |  3 +
 drivers/hid/hid-roccat-savu.c                      |  3 +
 drivers/hid/hid-samsung.c                          |  3 +
 drivers/hid/hid-uclogic.c                          |  3 +
 drivers/hid/wacom_sys.c                            | 19 ++++--
 drivers/iio/accel/kxcjk-1013.c                     |  5 +-
 drivers/iio/accel/kxsd9.c                          |  6 +-
 drivers/iio/accel/mma8452.c                        |  2 +-
 drivers/iio/adc/axp20x_adc.c                       | 18 +----
 drivers/iio/adc/dln2-adc.c                         | 21 +++---
 drivers/iio/gyro/itg3200_buffer.c                  |  2 +-
 drivers/iio/industrialio-trigger.c                 |  1 -
 drivers/iio/light/ltr501.c                         |  2 +-
 drivers/iio/light/stk3310.c                        |  6 +-
 drivers/iio/trigger/stm32-timer-trigger.c          |  2 +-
 drivers/infiniband/hw/hfi1/init.c                  |  2 +-
 drivers/irqchip/irq-armada-370-xp.c                | 16 ++---
 drivers/irqchip/irq-gic-v3-its.c                   |  2 +-
 drivers/irqchip/irq-nvic.c                         |  2 +-
 drivers/net/can/m_can/m_can.c                      | 14 ++--
 drivers/net/can/pch_can.c                          |  2 +-
 drivers/net/can/sja1000/ems_pcmcia.c               |  7 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |  9 ++-
 drivers/net/ethernet/freescale/fec.h               |  3 +
 drivers/net/ethernet/freescale/fec_main.c          |  2 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |  4 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |  7 ++
 drivers/net/ethernet/qlogic/qla3xxx.c              | 19 +++---
 drivers/net/usb/cdc_ncm.c                          |  2 +
 drivers/usb/core/config.c                          |  6 +-
 drivers/usb/gadget/composite.c                     | 14 +++-
 drivers/usb/gadget/legacy/dbgp.c                   | 15 ++++-
 drivers/usb/gadget/legacy/inode.c                  | 16 ++++-
 drivers/usb/host/xhci.c                            |  4 --
 fs/signalfd.c                                      | 12 +---
 fs/tracefs/inode.c                                 | 76 ++++++++++++++++++++++
 include/linux/hid.h                                |  5 ++
 include/linux/wait.h                               | 26 ++++++++
 kernel/bpf/verifier.c                              |  2 +-
 kernel/sched/wait.c                                |  8 +++
 mm/backing-dev.c                                   |  7 ++
 net/core/neighbour.c                               |  2 +-
 net/ipv6/seg6_iptunnel.c                           |  8 +++
 net/nfc/netlink.c                                  |  6 +-
 sound/core/control_compat.c                        |  3 +
 sound/core/oss/pcm_oss.c                           | 37 +++++++----
 69 files changed, 411 insertions(+), 149 deletions(-)


