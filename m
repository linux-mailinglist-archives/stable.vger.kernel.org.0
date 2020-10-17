Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46544291117
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 11:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436570AbgJQJtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 05:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411665AbgJQJtc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 05:49:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA6B206CB;
        Sat, 17 Oct 2020 09:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602928171;
        bh=CSebjV3iaeivwG2V8vr85gvyzQJdVKqtD6iR1WB6LDY=;
        h=From:To:Cc:Subject:Date:From;
        b=tj2Ldb4qAAPjsRv2xPieET3Wlp1XueJ/lNqbAFNg1ePr0cbREHDM74eUGhAa9qpG0
         lp26w0zs1o30lKzwQ9mnyPUdFAda/rE/xX3vL4iGBvBenDPhDThllgQthqjdVUs4SE
         SwR15vLUn+gIms1RqHYfSdXdHqcpt6FM7YapbwQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.240
Date:   Sat, 17 Oct 2020 11:50:20 +0200
Message-Id: <16029282207465@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.240 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 drivers/crypto/qat/qat_common/qat_algs.c |   10 +++-
 drivers/media/usb/usbtv/usbtv-core.c     |    3 -
 drivers/spi/spi.c                        |    4 -
 drivers/staging/comedi/drivers/vmk80xx.c |    3 +
 drivers/usb/serial/ftdi_sio.c            |    5 ++
 drivers/usb/serial/ftdi_sio_ids.h        |    7 +++
 drivers/usb/serial/option.c              |    5 ++
 drivers/usb/serial/pl2303.c              |    1 
 drivers/usb/serial/pl2303.h              |    1 
 fs/reiserfs/inode.c                      |    6 --
 fs/reiserfs/xattr.c                      |    7 +++
 include/net/bluetooth/hci_core.h         |   30 ++++++++++---
 net/bluetooth/a2mp.c                     |   22 +++++++++
 net/bluetooth/hci_conn.c                 |   17 +++++++
 net/bluetooth/hci_event.c                |   70 ++++++++++++-------------------
 net/bluetooth/mgmt.c                     |    7 ++-
 17 files changed, 140 insertions(+), 60 deletions(-)

Alain Michaud (1):
      Bluetooth: fix kernel oops in store_pending_adv_report

Anant Thazhemadam (1):
      staging: comedi: check validity of wMaxPacketSize of usb endpoints found

Dominik Przychodni (1):
      crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA

Greg Kroah-Hartman (1):
      Linux 4.4.240

Jan Kara (2):
      reiserfs: Initialize inode keys properly
      reiserfs: Fix oops during mount

Leonid Bloch (1):
      USB: serial: option: Add Telit FT980-KS composition

Luiz Augusto von Dentz (4):
      Bluetooth: A2MP: Fix not initializing all members
      Bluetooth: MGMT: Fix not checking if BT_HS is enabled
      Bluetooth: Consolidate encryption handling in hci_encrypt_cfm
      Bluetooth: Disconnect if E0 is used for Level 4

Mychaela N. Falconia (1):
      USB: serial: ftdi_sio: add support for FreeCalypso JTAG+UART adapters

Oliver Neukum (1):
      media: usbtv: Fix refcounting mixup

Patrick Steinhardt (1):
      Bluetooth: Fix update of connection state in `hci_encrypt_cfm`

Scott Chen (1):
      USB: serial: pl2303: add device-id for HP GC device

Wilken Gottwalt (1):
      USB: serial: option: add Cellient MPL200 card

yangerkun (1):
      spi: unbinding slave before calling spi_destroy_queue

