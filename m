Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0E913B4DC
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 22:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgANV4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 16:56:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANV4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 16:56:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B198624658;
        Tue, 14 Jan 2020 21:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579039007;
        bh=9425JJ83vGjcl6tbAKKf2+EsrY3loIxKAbFzQxAN3Kw=;
        h=Date:From:To:Cc:Subject:From;
        b=0qNW69XWtqY0SfE/nbwHe8ukzdgzAo5ZzTGI8PmrpHorX7UPvUxArmghXmkaQf0W4
         JfmSj+DdcH4W8Gpt2agyw3JOUEItc1HQTYMQ15QH74hYwQCMqIMLYQCDXg2qRLmBD0
         mYtdHpzlW0GhMa4gjMLdBN+P4f7ahmhOn2In3W+E=
Date:   Tue, 14 Jan 2020 22:56:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.210
Message-ID: <20200114215644.GA2362170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.210 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                         |    2 -
 drivers/gpu/drm/drm_dp_mst_topology.c            |    2 -
 drivers/gpu/drm/i915/intel_lrc.c                 |   14 +++++++++
 drivers/hid/hid-core.c                           |    6 ++++
 drivers/hid/hid-input.c                          |   16 ++++++++--
 drivers/hid/uhid.c                               |    3 +-
 drivers/input/input.c                            |   26 ++++++++++-------
 drivers/net/can/mscan/mscan.c                    |   21 ++++++--------
 drivers/net/can/usb/gs_usb.c                     |    4 +-
 drivers/net/wireless/mwifiex/pcie.c              |    4 ++
 drivers/net/wireless/mwifiex/sta_ioctl.c         |   11 ++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c |    1 
 drivers/scsi/bfa/bfad_attr.c                     |    4 ++
 drivers/staging/rtl8188eu/os_dep/usb_intf.c      |    1 
 drivers/staging/vt6656/device.h                  |    1 
 drivers/staging/vt6656/main_usb.c                |    1 
 drivers/staging/vt6656/wcmd.c                    |    1 
 drivers/tty/serial/serial_core.c                 |    1 
 drivers/usb/chipidea/host.c                      |    4 ++
 drivers/usb/core/config.c                        |   12 +++++---
 drivers/usb/musb/musb_core.c                     |    3 ++
 drivers/usb/musb/musbhsdma.c                     |    2 -
 drivers/usb/serial/option.c                      |    8 +++++
 drivers/usb/serial/usb-wwan.h                    |    1 
 drivers/usb/serial/usb_wwan.c                    |    4 ++
 fs/char_dev.c                                    |    2 -
 include/linux/can/dev.h                          |   34 +++++++++++++++++++++++
 include/linux/kobject.h                          |    2 +
 kernel/trace/trace_sched_wakeup.c                |    4 ++
 kernel/trace/trace_stack.c                       |    5 +++
 lib/kobject.c                                    |    5 ++-
 net/ipv4/netfilter/arp_tables.c                  |   27 ++++++++++--------
 net/netfilter/ipset/ip_set_core.c                |    3 +-
 sound/usb/quirks.c                               |    1 
 34 files changed, 182 insertions(+), 54 deletions(-)

Akeem G Abodunrin (1):
      drm/i915/gen9: Clear residual context state on context switch

Alan Stern (2):
      HID: Fix slab-out-of-bounds read in hid_field_extract
      USB: Fix: Don't skip endpoint descriptors with maxpacket=0

Daniele Palmas (1):
      USB: serial: option: add ZLP support for 0x1bc7/0x9010

Dmitry Torokhov (2):
      HID: hid-input: clear unmapped usages
      Input: add safety guards to input_set_keycode()

Florian Faber (1):
      can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode

Florian Westphal (2):
      netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
      netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present

Ganapathi Bhat (1):
      mwifiex: fix possible heap overflow in mwifiex_process_country_ie()

Greg Kroah-Hartman (1):
      Linux 4.4.210

Guenter Roeck (1):
      usb: chipidea: host: Disable port power only if previously enabled

Jan Kara (1):
      kobject: Export kobject_get_unless_zero()

Johan Hovold (1):
      can: gs_usb: gs_usb_probe(): use descriptors of current altsetting

Kaitao Cheng (1):
      kernel/trace: Fix do not unregister tracepoints when register sched_migrate_task fail

Malcolm Priestley (1):
      staging: vt6656: set usb_set_intfdata on driver fail.

Marcel Holtmann (1):
      HID: uhid: Fix returning EPOLLOUT from uhid_char_poll

Michael Straube (1):
      staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21

Navid Emamdoost (3):
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf
      scsi: bfa: release allocated memory in case of error
      rtl8xxxu: prevent leaking urb

Oliver Hartkopp (1):
      can: can_dropped_invalid_skb(): ensure an initialized headroom in outgoing CAN sk_buffs

Paul Cercueil (2):
      usb: musb: Disable pullup at init
      usb: musb: dma: Correct parameter passed to IRQ handler

Steven Rostedt (VMware) (1):
      tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defined

Sudip Mukherjee (2):
      tty: link tty and port before configuring it as console
      tty: always relink the port

Takashi Iwai (1):
      ALSA: usb-audio: Apply the sample rate quirk for Bose Companion 5

Wayne Lin (1):
      drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ

Will Deacon (1):
      chardev: Avoid potential use-after-free in 'chrdev_open()'

