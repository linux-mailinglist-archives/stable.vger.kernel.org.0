Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F13629015B
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406063AbgJPJNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405465AbgJPJMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:12:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 989E72145D;
        Fri, 16 Oct 2020 09:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839528;
        bh=lzm+jLE2P7Vo7sKxbeA83fAf+Nh9GliipOJ1rgA++vI=;
        h=From:To:Cc:Subject:Date:From;
        b=xFNkfWS78lVPbpbtgasTpT8emyfLjuAjM6uTwamiDI43vQY8U+2uwA8w/rsu4v4nR
         VH539tO7r8eGXLJgoh2xLuzHHMtoU9xHIrzxBOXFSDtJ5soWqB2b9FBujwHm7+vGPM
         JX5EEGTRdmLGPpHSv+Cu0MLu7AZ7jiSTd8rr+0A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 00/15] 5.9.1-rc1 review
Date:   Fri, 16 Oct 2020 11:08:02 +0200
Message-Id: <20201016090437.170032996@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.1-rc1
X-KernelTest-Deadline: 2020-10-18T09:04+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.9.1 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.1-rc1

Dominik Przychodni <dominik.przychodni@intel.com>
    crypto: qat - check cipher length for aead AES-CBC-HMAC-SHA

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: bcm - Verify GCM/CCM key length in setkey

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: Fix NULL dereference in dpm sysfs handlers"

Jan Kara <jack@suse.cz>
    reiserfs: Fix oops during mount

Jan Kara <jack@suse.cz>
    reiserfs: Initialize inode keys properly

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    vt_ioctl: make VT_RESIZEX behave like VT_RESIZE

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
    Bluetooth: MGMT: Fix not checking if BT_HS is enabled

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix calling sk_filter on non-socket based channel

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: A2MP: Fix not initializing all members


-------------

Diffstat:

 Makefile                                 |  4 +--
 drivers/crypto/bcm/cipher.c              | 15 ++++++++-
 drivers/crypto/qat/qat_common/qat_algs.c | 10 +++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c   |  9 +++--
 drivers/media/usb/usbtv/usbtv-core.c     |  3 +-
 drivers/staging/comedi/drivers/vmk80xx.c |  3 ++
 drivers/tty/vt/vt_ioctl.c                | 57 ++++++--------------------------
 drivers/usb/serial/ftdi_sio.c            |  5 +++
 drivers/usb/serial/ftdi_sio_ids.h        |  7 ++++
 drivers/usb/serial/option.c              |  5 +++
 drivers/usb/serial/pl2303.c              |  1 +
 drivers/usb/serial/pl2303.h              |  1 +
 fs/reiserfs/inode.c                      |  6 +---
 fs/reiserfs/xattr.c                      |  7 ++++
 include/net/bluetooth/l2cap.h            |  2 ++
 net/bluetooth/a2mp.c                     | 22 +++++++++++-
 net/bluetooth/l2cap_core.c               |  7 ++--
 net/bluetooth/l2cap_sock.c               | 14 ++++++++
 net/bluetooth/mgmt.c                     |  7 +++-
 19 files changed, 120 insertions(+), 65 deletions(-)


