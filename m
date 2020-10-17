Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578F9291132
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 11:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437937AbgJQJuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 05:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437934AbgJQJuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 05:50:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B79E2075E;
        Sat, 17 Oct 2020 09:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602928220;
        bh=0R/ZWi0U5adGAAhNFWkO4HPUI2T71+0HkgXOSMTxKRw=;
        h=From:To:Cc:Subject:Date:From;
        b=VOZGwgGzM56ZZ1ZMX4DzojjauIETdAkQyW7rS2Kz60Y3r24JPsDFUAm9zUlwkTlJU
         EDJmhLgzIworLlzU/axcv1KITedu8CpsiaeOReT2JItmxDyPTX57n0kqqE5dKW22iU
         ITN2O9NxaYTLRxCj5xxD8gniJBSsM3meliGV2T+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.8.16
Date:   Sat, 17 Oct 2020 11:51:00 +0200
Message-Id: <1602928260114131@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.8.16 kernel.

All users of the 5.8 kernel series must upgrade.

The updated 5.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.8.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 +-
 drivers/crypto/bcm/cipher.c              |   15 ++++++++++++++-
 drivers/crypto/qat/qat_common/qat_algs.c |   10 +++++++++-
 drivers/media/usb/usbtv/usbtv-core.c     |    3 ++-
 drivers/staging/comedi/drivers/vmk80xx.c |    3 +++
 drivers/usb/serial/ftdi_sio.c            |    5 +++++
 drivers/usb/serial/ftdi_sio_ids.h        |    7 +++++++
 drivers/usb/serial/option.c              |    5 +++++
 drivers/usb/serial/pl2303.c              |    1 +
 drivers/usb/serial/pl2303.h              |    1 +
 fs/reiserfs/inode.c                      |    6 +-----
 fs/reiserfs/xattr.c                      |    7 +++++++
 include/net/bluetooth/hci_core.h         |   10 ++++++----
 include/net/bluetooth/l2cap.h            |    2 ++
 net/bluetooth/a2mp.c                     |   22 +++++++++++++++++++++-
 net/bluetooth/hci_conn.c                 |   17 +++++++++++++++++
 net/bluetooth/hci_event.c                |   20 ++++++++------------
 net/bluetooth/l2cap_core.c               |    7 ++++---
 net/bluetooth/l2cap_sock.c               |   14 ++++++++++++++
 net/bluetooth/mgmt.c                     |    7 ++++++-
 20 files changed, 134 insertions(+), 30 deletions(-)

Anant Thazhemadam (1):
      staging: comedi: check validity of wMaxPacketSize of usb endpoints found

Dominik Przychodni (1):
      crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA

Greg Kroah-Hartman (1):
      Linux 5.8.16

Herbert Xu (1):
      crypto: bcm - Verify GCM/CCM key length in setkey

Jan Kara (2):
      reiserfs: Initialize inode keys properly
      reiserfs: Fix oops during mount

Leonid Bloch (1):
      USB: serial: option: Add Telit FT980-KS composition

Luiz Augusto von Dentz (4):
      Bluetooth: A2MP: Fix not initializing all members
      Bluetooth: L2CAP: Fix calling sk_filter on non-socket based channel
      Bluetooth: MGMT: Fix not checking if BT_HS is enabled
      Bluetooth: Disconnect if E0 is used for Level 4

Mychaela N. Falconia (1):
      USB: serial: ftdi_sio: add support for FreeCalypso JTAG+UART adapters

Oliver Neukum (1):
      media: usbtv: Fix refcounting mixup

Scott Chen (1):
      USB: serial: pl2303: add device-id for HP GC device

Wilken Gottwalt (1):
      USB: serial: option: add Cellient MPL200 card

