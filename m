Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC1B473FDA
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 10:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhLNJwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 04:52:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43650 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhLNJwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 04:52:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EB69B817D4;
        Tue, 14 Dec 2021 09:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB963C34600;
        Tue, 14 Dec 2021 09:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639475522;
        bh=SLNW3IwS0LNnygBiKF6+i/IabQApBZKzM8lQj2pvejs=;
        h=From:To:Cc:Subject:Date:From;
        b=aPi5AkexZv7y1TLp/lxSkOJzSI/iUGIw2V9TZuJolf/8fthDtT+MPwKhIw8OYBuIi
         V9e1dVUZQ5vccylcWmm3ahIVgtRdEyhsloDWx9Vxa1jtj25G4/VlGXFNQPtelE0l5g
         OjSti/wYPRIlQ5GybDrrY/AxHNQK4FNXaJYOK4XE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.295
Date:   Tue, 14 Dec 2021 10:51:58 +0100
Message-Id: <16394755191947@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.295 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 
 block/ioprio.c                                |    3 +
 drivers/android/binder.c                      |   21 +++----
 drivers/ata/libata-core.c                     |    2 
 drivers/hid/Kconfig                           |   10 +--
 drivers/hid/hid-chicony.c                     |    8 ++
 drivers/hid/hid-corsair.c                     |    7 ++
 drivers/hid/hid-elo.c                         |    3 +
 drivers/hid/hid-holtek-kbd.c                  |    9 ++-
 drivers/hid/hid-holtek-mouse.c                |    9 +++
 drivers/hid/hid-lg.c                          |   10 ++-
 drivers/hid/hid-prodikeys.c                   |   10 ++-
 drivers/hid/hid-roccat-arvo.c                 |    3 +
 drivers/hid/hid-roccat-isku.c                 |    3 +
 drivers/hid/hid-roccat-kone.c                 |    3 +
 drivers/hid/hid-roccat-koneplus.c             |    3 +
 drivers/hid/hid-roccat-konepure.c             |    3 +
 drivers/hid/hid-roccat-kovaplus.c             |    3 +
 drivers/hid/hid-roccat-lua.c                  |    3 +
 drivers/hid/hid-roccat-pyra.c                 |    3 +
 drivers/hid/hid-roccat-ryos.c                 |    3 +
 drivers/hid/hid-roccat-savu.c                 |    3 +
 drivers/hid/hid-samsung.c                     |    3 +
 drivers/hid/hid-uclogic.c                     |    3 +
 drivers/hid/i2c-hid/i2c-hid.c                 |    3 -
 drivers/hid/uhid.c                            |    3 -
 drivers/hid/usbhid/hid-core.c                 |    3 -
 drivers/hid/wacom_sys.c                       |   17 ++++-
 drivers/iio/accel/kxcjk-1013.c                |    5 -
 drivers/iio/accel/mma8452.c                   |    2 
 drivers/iio/gyro/itg3200_buffer.c             |    2 
 drivers/iio/light/ltr501.c                    |    2 
 drivers/iio/light/stk3310.c                   |    6 +-
 drivers/irqchip/irq-gic-v3-its.c              |    2 
 drivers/irqchip/irq-nvic.c                    |    2 
 drivers/net/can/pch_can.c                     |    2 
 drivers/net/can/sja1000/ems_pcmcia.c          |    7 ++
 drivers/net/ethernet/altera/altera_tse_main.c |    9 ++-
 drivers/net/ethernet/freescale/fec.h          |    3 +
 drivers/net/ethernet/freescale/fec_main.c     |    2 
 drivers/net/ethernet/qlogic/qla3xxx.c         |   19 +++---
 drivers/net/usb/cdc_ncm.c                     |    2 
 drivers/usb/core/config.c                     |    2 
 drivers/usb/gadget/composite.c                |   14 ++++
 drivers/usb/gadget/legacy/dbgp.c              |   15 ++++-
 drivers/usb/gadget/legacy/inode.c             |   16 +++++
 fs/signalfd.c                                 |   12 ----
 fs/tracefs/inode.c                            |   76 ++++++++++++++++++++++++++
 include/linux/hid.h                           |   16 +++++
 include/linux/wait.h                          |   26 ++++++++
 kernel/sched/wait.c                           |    8 ++
 mm/backing-dev.c                              |    7 ++
 net/bluetooth/hidp/core.c                     |    3 -
 net/core/neighbour.c                          |    2 
 net/nfc/netlink.c                             |    6 +-
 sound/core/control_compat.c                   |    3 +
 sound/core/oss/pcm_oss.c                      |   37 ++++++++----
 57 files changed, 371 insertions(+), 93 deletions(-)

Alan Young (1):
      ALSA: ctl: Fix copy of updated id with element read/write

Dan Carpenter (3):
      can: sja1000: fix use after free in ems_pcmcia_add_card()
      net: altera: set a couple error code in probe()
      net/qla3xxx: fix an error code in ql_adapter_up()

Davidlohr Bueso (1):
      block: fix ioprio_get(IOPRIO_WHO_PGRP) vs setuid(2)

Eric Biggers (3):
      wait: add wake_up_pollfree()
      binder: use wake_up_pollfree()
      signalfd: use wake_up_pollfree()

Eric Dumazet (1):
      net, neigh: clear whole pneigh_entry at alloc time

Greg Kroah-Hartman (9):
      HID: add hid_is_usb() function to make it simpler for USB detection
      HID: add USB_HID dependancy to hid-prodikeys
      HID: add USB_HID dependancy to hid-chicony
      HID: add USB_HID dependancy on some USB HID drivers
      HID: wacom: fix problems when device is not a valid USB device
      HID: check for valid USB device for many HID drivers
      USB: gadget: detect too-big endpoint 0 requests
      USB: gadget: zero allocate endpoint 0 buffers
      Linux 4.4.295

Hannes Reinecke (1):
      libata: add horkage for ASMedia 1092

Jason Gerecke (1):
      HID: introduce hid_is_using_ll_driver

Joakim Zhang (1):
      net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()

Krzysztof Kozlowski (1):
      nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done

Lars-Peter Clausen (4):
      iio: stk3310: Don't return error code in interrupt handler
      iio: mma8452: Fix trigger reference couting
      iio: ltr501: Don't return error code in trigger handler
      iio: itg3200: Call iio_trigger_notify_done() on error

Lee Jones (1):
      net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero

Manjong Lee (1):
      mm: bdi: initialize bdi_min_ratio when bdi is unregistered

Pavel Hofman (1):
      usb: core: config: fix validation of wMaxPacketValue entries

Steven Rostedt (VMware) (2):
      tracefs: Have new files inherit the ownership of their parent
      tracefs: Set all files to the same group ownership as the mount option

Takashi Iwai (3):
      ALSA: pcm: oss: Fix negative period/buffer sizes
      ALSA: pcm: oss: Limit the period size to 16MB
      ALSA: pcm: oss: Handle missing errors in snd_pcm_oss_change_params*()

Vincent Mailhol (1):
      can: pch_can: pch_can_rx_normal: fix use after free

Vladimir Murzin (1):
      irqchip: nvic: Fix offset for Interrupt Priority Offsets

Wudi Wang (1):
      irqchip/irq-gic-v3-its.c: Force synchronisation when issuing INVALL

Yang Yingliang (1):
      iio: accel: kxcjk-1013: Fix possible memory leak in probe and remove

