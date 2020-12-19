Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD542DEEF2
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgLSM4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:56:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgLSM4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:56:46 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.10 00/16] 5.10.2-rc1 review
Date:   Sat, 19 Dec 2020 13:57:07 +0100
Message-Id: <20201219125339.066340030@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.10.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.2-rc1
X-KernelTest-Deadline: 2020-12-21T12:53+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.2 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.2-rc1

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix potential out-of-bounds shift

Thomas Gleixner <tglx@linutronix.de>
    USB: sisusbvga: Make console support depend on BROKEN

Oliver Neukum <oneukum@suse.com>
    USB: UAS: introduce a quirk to set no_write_same

Mika Westerberg <mika.westerberg@linux.intel.com>
    xhci-pci: Allow host runtime PM as default for Intel Maple Ridge xHCI

Hans de Goede <hdegoede@redhat.com>
    xhci-pci: Allow host runtime PM as default for Intel Alpine Ridge LP

Tejas Joglekar <Tejas.Joglekar@synopsys.com>
    usb: xhci: Set quirk for XHCI_SG_TRB_CACHE_SIZE_QUIRK

Li Jun <jun.li@nxp.com>
    xhci: Give USB2 ports time to enter U3 in bus suspend

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix control 'access overflow' errors from chmap

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential out-of-bounds shift

Oliver Neukum <oneukum@suse.com>
    USB: add RESET_RESUME quirk for Snapscan 1212

Bui Quang Minh <minhquangbui99@gmail.com>
    USB: dummy-hcd: Fix uninitialized array use in init()

Alan Stern <stern@rowland.harvard.edu>
    USB: legotower: fix logical error in recent commit

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ktest.pl: Fix the logic for truncating the size of the log file for email

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ktest.pl: If size of log is too big to email, email error message

Peilin Ye <yepeilin.cs@gmail.com>
    ptrace: Prevent kernel-infoleak in ptrace_get_syscall_info()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt |  1 +
 Makefile                                        |  4 ++--
 drivers/tty/serial/8250/8250_omap.c             |  5 -----
 drivers/usb/core/quirks.c                       |  3 +++
 drivers/usb/gadget/udc/dummy_hcd.c              |  2 +-
 drivers/usb/host/xhci-hub.c                     |  4 ++++
 drivers/usb/host/xhci-pci.c                     |  6 +++++-
 drivers/usb/host/xhci-plat.c                    |  3 +++
 drivers/usb/host/xhci.h                         |  1 +
 drivers/usb/misc/legousbtower.c                 |  2 +-
 drivers/usb/misc/sisusbvga/Kconfig              |  2 +-
 drivers/usb/storage/uas.c                       |  3 +++
 drivers/usb/storage/unusual_uas.h               |  7 +++++--
 drivers/usb/storage/usb.c                       |  3 +++
 include/linux/usb_usual.h                       |  2 ++
 include/uapi/linux/ptrace.h                     |  3 ++-
 sound/core/oss/pcm_oss.c                        |  6 +++++-
 sound/usb/format.c                              |  2 ++
 sound/usb/stream.c                              |  6 +++---
 tools/testing/ktest/ktest.pl                    | 20 ++++++++++++--------
 20 files changed, 59 insertions(+), 26 deletions(-)


