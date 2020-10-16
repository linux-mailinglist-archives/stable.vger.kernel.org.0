Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D660290161
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405913AbgJPJN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405251AbgJPJL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:11:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EB5120FC3;
        Fri, 16 Oct 2020 09:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839489;
        bh=4ghlP60giDXjSjaDWYgwi2CS//en7vTSZugg+p8CZXU=;
        h=From:To:Cc:Subject:Date:From;
        b=yyoOhuxrtOVNzLPSi8cBX/r22WZ+Egemc9KeVDvagwhnyYs2/Z+jNcZE336jiqT0v
         q5USAsX5ggXeElhAj26uQUMVJYmTOJkynYC6Y/In+cFn14fUnweDapBhx6vNrKBf8v
         RCY+i/zw+w43jKmb77TgBsuQbuJxF0mJqiyx5E7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.8 00/14] 5.8.16-rc1 review
Date:   Fri, 16 Oct 2020 11:07:45 +0200
Message-Id: <20201016090437.153175229@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.16-rc1
X-KernelTest-Deadline: 2020-10-18T09:04+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.16 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.16-rc1

Jan Kara <jack@suse.cz>
    reiserfs: Fix oops during mount

Jan Kara <jack@suse.cz>
    reiserfs: Initialize inode keys properly

Mychaela N. Falconia <falcon@freecalypso.org>
    USB: serial: ftdi_sio: add support for FreeCalypso JTAG+UART adapters

Scott Chen <scott@labau.com.tw>
    USB: serial: pl2303: add device-id for HP GC device

Anant Thazhemadam <anant.thazhemadam@gmail.com>
    staging: comedi: check validity of wMaxPacketSize of usb endpoints found

Leonid Bloch <lb.workbox@gmail.com>
    USB: serial: option: Add Telit FT980-KS composition

Wilken Gottwalt <wilken.gottwalt@mailbox.org>
    USB: serial: option: add Cellient MPL200 card

Oliver Neukum <oneukum@suse.com>
    media: usbtv: Fix refcounting mixup

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Disconnect if E0 is used for Level 4

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix not checking if BT_HS is enabled

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix calling sk_filter on non-socket based channel

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: A2MP: Fix not initializing all members

Dominik Przychodni <dominik.przychodni@intel.com>
    crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: bcm - Verify GCM/CCM key length in setkey


-------------

Diffstat:

 Makefile                                 |  4 ++--
 drivers/crypto/bcm/cipher.c              | 15 ++++++++++++++-
 drivers/crypto/qat/qat_common/qat_algs.c | 10 +++++++++-
 drivers/media/usb/usbtv/usbtv-core.c     |  3 ++-
 drivers/staging/comedi/drivers/vmk80xx.c |  3 +++
 drivers/usb/serial/ftdi_sio.c            |  5 +++++
 drivers/usb/serial/ftdi_sio_ids.h        |  7 +++++++
 drivers/usb/serial/option.c              |  5 +++++
 drivers/usb/serial/pl2303.c              |  1 +
 drivers/usb/serial/pl2303.h              |  1 +
 fs/reiserfs/inode.c                      |  6 +-----
 fs/reiserfs/xattr.c                      |  7 +++++++
 include/net/bluetooth/hci_core.h         | 10 ++++++----
 include/net/bluetooth/l2cap.h            |  2 ++
 net/bluetooth/a2mp.c                     | 22 +++++++++++++++++++++-
 net/bluetooth/hci_conn.c                 | 17 +++++++++++++++++
 net/bluetooth/hci_event.c                | 20 ++++++++------------
 net/bluetooth/l2cap_core.c               |  7 ++++---
 net/bluetooth/l2cap_sock.c               | 14 ++++++++++++++
 net/bluetooth/mgmt.c                     |  7 ++++++-
 20 files changed, 135 insertions(+), 31 deletions(-)


