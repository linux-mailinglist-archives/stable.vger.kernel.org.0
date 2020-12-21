Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAA52DFC42
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 14:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgLUNUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 08:20:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgLUNUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 08:20:39 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.2
Date:   Mon, 21 Dec 2020 14:21:13 +0100
Message-Id: <1608556873196225@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.2 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt |    1 +
 Makefile                                        |    2 +-
 drivers/tty/serial/8250/8250_omap.c             |    5 -----
 drivers/usb/core/quirks.c                       |    3 +++
 drivers/usb/gadget/udc/dummy_hcd.c              |    2 +-
 drivers/usb/host/xhci-hub.c                     |    4 ++++
 drivers/usb/host/xhci-pci.c                     |    6 +++++-
 drivers/usb/host/xhci-plat.c                    |    3 +++
 drivers/usb/host/xhci.h                         |    1 +
 drivers/usb/misc/legousbtower.c                 |    2 +-
 drivers/usb/misc/sisusbvga/Kconfig              |    2 +-
 drivers/usb/storage/uas.c                       |    3 +++
 drivers/usb/storage/unusual_uas.h               |    7 +++++--
 drivers/usb/storage/usb.c                       |    3 +++
 include/linux/usb_usual.h                       |    2 ++
 include/uapi/linux/ptrace.h                     |    3 ++-
 sound/core/oss/pcm_oss.c                        |    6 +++++-
 sound/usb/format.c                              |    2 ++
 sound/usb/stream.c                              |    6 +++---
 tools/testing/ktest/ktest.pl                    |   20 ++++++++++++--------
 20 files changed, 58 insertions(+), 25 deletions(-)

Alan Stern (1):
      USB: legotower: fix logical error in recent commit

Alexander Sverdlin (1):
      serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access

Bui Quang Minh (1):
      USB: dummy-hcd: Fix uninitialized array use in init()

Greg Kroah-Hartman (1):
      Linux 5.10.2

Hans de Goede (1):
      xhci-pci: Allow host runtime PM as default for Intel Alpine Ridge LP

Li Jun (1):
      xhci: Give USB2 ports time to enter U3 in bus suspend

Mika Westerberg (1):
      xhci-pci: Allow host runtime PM as default for Intel Maple Ridge xHCI

Oliver Neukum (2):
      USB: add RESET_RESUME quirk for Snapscan 1212
      USB: UAS: introduce a quirk to set no_write_same

Peilin Ye (1):
      ptrace: Prevent kernel-infoleak in ptrace_get_syscall_info()

Steven Rostedt (VMware) (2):
      ktest.pl: If size of log is too big to email, email error message
      ktest.pl: Fix the logic for truncating the size of the log file for email

Takashi Iwai (3):
      ALSA: usb-audio: Fix potential out-of-bounds shift
      ALSA: usb-audio: Fix control 'access overflow' errors from chmap
      ALSA: pcm: oss: Fix potential out-of-bounds shift

Tejas Joglekar (1):
      usb: xhci: Set quirk for XHCI_SG_TRB_CACHE_SIZE_QUIRK

Thomas Gleixner (1):
      USB: sisusbvga: Make console support depend on BROKEN

