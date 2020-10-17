Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1345129112F
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 11:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437955AbgJQJu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 05:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437946AbgJQJuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 05:50:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E590207DE;
        Sat, 17 Oct 2020 09:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602928222;
        bh=8+w1krQ2Su0klYbDRgrt6S0bGVEDNny7K+1mhrEu7WM=;
        h=From:To:Cc:Subject:Date:From;
        b=jazqY4bIWRgL1vZ+SaHTEdRNPEHg8TBCL3blWU7d1vteQJ43ia1EIfOar0/m9Wbuq
         yT39st54tm5wie10La2EkLaJEaDivWK02MTNuSrx7xUQaoglmQKkc5zQPhTKk2m2yj
         qmqZyMpMwUh4RZbwdTHQ3Qv43/06P24xC50nOyBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.1
Date:   Sat, 17 Oct 2020 11:51:07 +0200
Message-Id: <1602928267189102@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.1 kernel.

All users of the 5.9 kernel series must upgrade.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 -
 drivers/crypto/bcm/cipher.c              |   15 +++++++-
 drivers/crypto/qat/qat_common/qat_algs.c |   10 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c   |    9 +++-
 drivers/media/usb/usbtv/usbtv-core.c     |    3 +
 drivers/staging/comedi/drivers/vmk80xx.c |    3 +
 drivers/tty/vt/vt_ioctl.c                |   57 +++++--------------------------
 drivers/usb/serial/ftdi_sio.c            |    5 ++
 drivers/usb/serial/ftdi_sio_ids.h        |    7 +++
 drivers/usb/serial/option.c              |    5 ++
 drivers/usb/serial/pl2303.c              |    1 
 drivers/usb/serial/pl2303.h              |    1 
 fs/reiserfs/inode.c                      |    6 ---
 fs/reiserfs/xattr.c                      |    7 +++
 include/net/bluetooth/l2cap.h            |    2 +
 net/bluetooth/a2mp.c                     |   22 +++++++++++
 net/bluetooth/l2cap_core.c               |    7 ++-
 net/bluetooth/l2cap_sock.c               |   14 +++++++
 net/bluetooth/mgmt.c                     |    7 +++
 19 files changed, 119 insertions(+), 64 deletions(-)

Alex Deucher (1):
      Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs handlers"

Anant Thazhemadam (1):
      staging: comedi: check validity of wMaxPacketSize of usb endpoints found

Dominik Przychodni (1):
      crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA

Greg Kroah-Hartman (1):
      Linux 5.9.1

Herbert Xu (1):
      crypto: bcm - Verify GCM/CCM key length in setkey

Jan Kara (2):
      reiserfs: Initialize inode keys properly
      reiserfs: Fix oops during mount

Leonid Bloch (1):
      USB: serial: option: Add Telit FT980-KS composition

Luiz Augusto von Dentz (3):
      Bluetooth: A2MP: Fix not initializing all members
      Bluetooth: L2CAP: Fix calling sk_filter on non-socket based channel
      Bluetooth: MGMT: Fix not checking if BT_HS is enabled

Mychaela N. Falconia (1):
      USB: serial: ftdi_sio: add support for FreeCalypso JTAG+UART adapters

Oliver Neukum (1):
      media: usbtv: Fix refcounting mixup

Scott Chen (1):
      USB: serial: pl2303: add device-id for HP GC device

Tetsuo Handa (1):
      vt_ioctl: make VT_RESIZEX behave like VT_RESIZE

Wilken Gottwalt (1):
      USB: serial: option: add Cellient MPL200 card

