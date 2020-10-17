Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E9A291127
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 11:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437901AbgJQJuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 05:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437891AbgJQJuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 05:50:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 702D52075E;
        Sat, 17 Oct 2020 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602928204;
        bh=cdJ/EyL3WNydtyz9HMUOG6SSgCUW2Mwwi4KMkH+pprQ=;
        h=From:To:Cc:Subject:Date:From;
        b=j4xt1xNZodu+wdtjQ9DFJnzi9ntWkdlni8nBixetsBUgQzt+42FBr2jiAf/zCfWVG
         9j3B5BCtIteWqW6DVco1/1qGgxOQioRDiAHqisYkiTMEdpWg0CrbxShrxQBBl3u4TX
         ORncsYxqMGlPvG9WTIXGc4SUZtkY8/oO6DOvmY+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.152
Date:   Sat, 17 Oct 2020 11:50:43 +0200
Message-Id: <160292824411211@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.152 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 -
 arch/arm/boot/compressed/Makefile        |    4 +-
 arch/arm/vdso/Makefile                   |   22 +++++---------
 drivers/crypto/bcm/cipher.c              |   15 +++++++++
 drivers/crypto/qat/qat_common/qat_algs.c |   10 +++++-
 drivers/media/usb/usbtv/usbtv-core.c     |    3 +
 drivers/net/ethernet/marvell/mvmdio.c    |   22 ++++++++++----
 drivers/staging/comedi/drivers/vmk80xx.c |    3 +
 drivers/usb/serial/ftdi_sio.c            |    5 +++
 drivers/usb/serial/ftdi_sio_ids.h        |    7 ++++
 drivers/usb/serial/option.c              |    5 +++
 drivers/usb/serial/pl2303.c              |    1 
 drivers/usb/serial/pl2303.h              |    1 
 fs/reiserfs/inode.c                      |    6 ---
 fs/reiserfs/xattr.c                      |    7 ++++
 include/net/bluetooth/hci_core.h         |   30 +++++++++++++++----
 include/net/bluetooth/l2cap.h            |    2 +
 net/bluetooth/a2mp.c                     |   22 +++++++++++++-
 net/bluetooth/hci_conn.c                 |   17 ++++++++++
 net/bluetooth/hci_event.c                |   48 +++++++------------------------
 net/bluetooth/l2cap_core.c               |    7 ++--
 net/bluetooth/l2cap_sock.c               |   14 +++++++++
 net/bluetooth/mgmt.c                     |    7 +++-
 tools/perf/util/cs-etm.c                 |    3 +
 tools/perf/util/cs-etm.h                 |    3 -
 25 files changed, 185 insertions(+), 81 deletions(-)

Anant Thazhemadam (1):
      staging: comedi: check validity of wMaxPacketSize of usb endpoints found

Arnaud Patard (1):
      drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case

Dmitry Golovin (1):
      ARM: 8939/1: kbuild: use correct nm executable

Dominik Przychodni (1):
      crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA

Greg Kroah-Hartman (1):
      Linux 4.19.152

Herbert Xu (1):
      crypto: bcm - Verify GCM/CCM key length in setkey

Jan Kara (2):
      reiserfs: Initialize inode keys properly
      reiserfs: Fix oops during mount

Jason A. Donenfeld (1):
      ARM: 8867/1: vdso: pass --be8 to linker if necessary

Leo Yan (1):
      perf cs-etm: Move definition of 'traceid_list' global variable from header file

Leonid Bloch (1):
      USB: serial: option: Add Telit FT980-KS composition

Luiz Augusto von Dentz (5):
      Bluetooth: A2MP: Fix not initializing all members
      Bluetooth: L2CAP: Fix calling sk_filter on non-socket based channel
      Bluetooth: MGMT: Fix not checking if BT_HS is enabled
      Bluetooth: Consolidate encryption handling in hci_encrypt_cfm
      Bluetooth: Disconnect if E0 is used for Level 4

Masahiro Yamada (1):
      ARM: 8858/1: vdso: use $(LD) instead of $(CC) to link VDSO

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

