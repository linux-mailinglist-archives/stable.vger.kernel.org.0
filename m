Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEDD3FFCA7
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348670AbhICJDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348694AbhICJDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:03:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E79761051;
        Fri,  3 Sep 2021 09:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659763;
        bh=4hVIEu5E+6bMCMtDkR7VirTFOfTcLhhkqvSGzPulYmc=;
        h=From:To:Cc:Subject:Date:From;
        b=a307VCyLpZMMj/dm00E73MkBJwK6atleGiyAfroylZpbYFhVdGL9FjP5+FK+xUBpK
         JtzS2H/OFWzI2NxTboAXQYhSf7AUw4xGkas8vqOSYY9aSd8Fhu6FIV2z7VKriSi/D8
         JqsTMcxA94fsVZqi2ZonrlG2JqL2l7vx6hMZU3PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.1
Date:   Fri,  3 Sep 2021 11:02:40 +0200
Message-Id: <16306597601523@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.1 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                  |    2 +-
 drivers/block/floppy.c    |   30 +++++++++++++++---------------
 drivers/bluetooth/btusb.c |   22 ++++++++++++++--------
 drivers/net/dsa/mt7530.c  |    5 +----
 drivers/tty/vt/vt_ioctl.c |   10 ++++++----
 fs/btrfs/volumes.c        |    2 +-
 fs/crypto/hooks.c         |   44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/symlink.c         |   12 +++++++++++-
 fs/f2fs/namei.c           |   12 +++++++++++-
 fs/ubifs/file.c           |   13 ++++++++++++-
 include/linux/fscrypt.h   |    7 +++++++
 include/linux/netdevice.h |    4 ++++
 kernel/audit_tree.c       |    2 +-
 net/socket.c              |    6 +++++-
 14 files changed, 133 insertions(+), 38 deletions(-)

DENG Qingfang (1):
      net: dsa: mt7530: fix VLAN traffic leaks again

Denis Efremov (1):
      Revert "floppy: reintroduce O_NDELAY fix"

Eric Biggers (4):
      fscrypt: add fscrypt_symlink_getattr() for computing st_size
      ext4: report correct st_size for encrypted symlinks
      f2fs: report correct st_size for encrypted symlinks
      ubifs: report correct st_size for encrypted symlinks

Greg Kroah-Hartman (1):
      Linux 5.14.1

Linus Torvalds (1):
      vt_kdsetmode: extend console locking

Pauli Virtanen (1):
      Bluetooth: btusb: check conditions before enabling USB ALT 3 for WBS

Peter Collingbourne (1):
      net: don't unconditionally copy_from_user a struct ifreq for socket ioctls

Qu Wenruo (1):
      btrfs: fix NULL pointer dereference when deleting device by invalid id

Richard Guy Briggs (1):
      audit: move put_tree() to avoid trim_trees refcount underflow and UAF

