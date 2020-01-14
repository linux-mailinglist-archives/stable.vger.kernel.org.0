Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89DC13A6AC
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732825AbgANKMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:12:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732836AbgANKMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:12:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51FF4207FF;
        Tue, 14 Jan 2020 10:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996771;
        bh=fGMcLkEw+1ExU0MbhexjgPpX6ghyKR9xMy6brQNzmSU=;
        h=From:To:Cc:Subject:Date:From;
        b=Ydw7UnlnbBcQg/Y4NuS4Jc5W5hvU3SzH/SE5o2A8VRUySKKxm8P0Kks/m4jY5+Dct
         469GgyjwetS9jE6v0BOOc4uDKh+KYiFgqMWcYaRu9bh2OGht0uS8t+MOgKpXuYpAMJ
         NCdhdPAhgmkMx+uRAcO6mtuPe6SDgTIZMHv/Ntf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 00/28] 4.4.210-stable review
Date:   Tue, 14 Jan 2020 11:02:02 +0100
Message-Id: <20200114094336.845958665@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.210-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.210-rc1
X-KernelTest-Deadline: 2020-01-16T09:43+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.210 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.210-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.210-rc1

Florian Westphal <fw@strlen.de>
    netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present

Florian Westphal <fw@strlen.de>
    netfilter: arp_tables: init netns pointer in xt_tgchk_param struct

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix: Don't skip endpoint descriptors with maxpacket=0

Navid Emamdoost <navid.emamdoost@gmail.com>
    rtl8xxxu: prevent leaking urb

Navid Emamdoost <navid.emamdoost@gmail.com>
    scsi: bfa: release allocated memory in case of error

Navid Emamdoost <navid.emamdoost@gmail.com>
    mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf

Ganapathi Bhat <gbhat@marvell.com>
    mwifiex: fix possible heap overflow in mwifiex_process_country_ie()

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    tty: always relink the port

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    tty: link tty and port before configuring it as console

Michael Straube <straube.linux@gmail.com>
    staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21

Paul Cercueil <paul@crapouillou.net>
    usb: musb: dma: Correct parameter passed to IRQ handler

Paul Cercueil <paul@crapouillou.net>
    usb: musb: Disable pullup at init

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add ZLP support for 0x1bc7/0x9010

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: set usb_set_intfdata on driver fail.

Oliver Hartkopp <socketcan@hartkopp.net>
    can: can_dropped_invalid_skb(): ensure an initialized headroom in outgoing CAN sk_buffs

Florian Faber <faber@faberman.de>
    can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode

Johan Hovold <johan@kernel.org>
    can: gs_usb: gs_usb_probe(): use descriptors of current altsetting

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: add safety guards to input_set_keycode()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: clear unmapped usages

Marcel Holtmann <marcel@holtmann.org>
    HID: uhid: Fix returning EPOLLOUT from uhid_char_poll

Alan Stern <stern@rowland.harvard.edu>
    HID: Fix slab-out-of-bounds read in hid_field_extract

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defined

Kaitao Cheng <pilgrimtao@gmail.com>
    kernel/trace: Fix do not unregister tracepoints when register sched_migrate_task fail

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Apply the sample rate quirk for Bose Companion 5

Guenter Roeck <linux@roeck-us.net>
    usb: chipidea: host: Disable port power only if previously enabled

Will Deacon <will@kernel.org>
    chardev: Avoid potential use-after-free in 'chrdev_open()'

Jan Kara <jack@suse.cz>
    kobject: Export kobject_get_unless_zero()


-------------

Diffstat:

 Makefile                                         |  4 +--
 drivers/gpu/drm/drm_dp_mst_topology.c            |  2 +-
 drivers/hid/hid-core.c                           |  6 +++++
 drivers/hid/hid-input.c                          | 16 ++++++++---
 drivers/hid/uhid.c                               |  3 ++-
 drivers/input/input.c                            | 26 +++++++++++-------
 drivers/net/can/mscan/mscan.c                    | 21 +++++++--------
 drivers/net/can/usb/gs_usb.c                     |  4 +--
 drivers/net/wireless/mwifiex/pcie.c              |  4 ++-
 drivers/net/wireless/mwifiex/sta_ioctl.c         | 11 +++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c |  1 +
 drivers/scsi/bfa/bfad_attr.c                     |  4 ++-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c      |  1 +
 drivers/staging/vt6656/device.h                  |  1 +
 drivers/staging/vt6656/main_usb.c                |  1 +
 drivers/staging/vt6656/wcmd.c                    |  1 +
 drivers/tty/serial/serial_core.c                 |  1 +
 drivers/usb/chipidea/host.c                      |  4 ++-
 drivers/usb/core/config.c                        | 12 ++++++---
 drivers/usb/musb/musb_core.c                     |  3 +++
 drivers/usb/musb/musbhsdma.c                     |  2 +-
 drivers/usb/serial/option.c                      |  8 ++++++
 drivers/usb/serial/usb-wwan.h                    |  1 +
 drivers/usb/serial/usb_wwan.c                    |  4 +++
 fs/char_dev.c                                    |  2 +-
 include/linux/can/dev.h                          | 34 ++++++++++++++++++++++++
 include/linux/kobject.h                          |  2 ++
 kernel/trace/trace_sched_wakeup.c                |  4 ++-
 kernel/trace/trace_stack.c                       |  5 ++++
 lib/kobject.c                                    |  5 +++-
 net/ipv4/netfilter/arp_tables.c                  | 27 +++++++++++--------
 net/netfilter/ipset/ip_set_core.c                |  3 ++-
 sound/usb/quirks.c                               |  1 +
 33 files changed, 169 insertions(+), 55 deletions(-)


