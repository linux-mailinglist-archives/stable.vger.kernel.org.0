Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE8613A61E
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgANKJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbgANKJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:09:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4B320678;
        Tue, 14 Jan 2020 10:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996553;
        bh=1YCSKflKYGtDjMtEPSjK4deozjl2ok/e/v3wp1bMlE0=;
        h=From:To:Cc:Subject:Date:From;
        b=S2yMPhrt+TKVRRl9tUDxj7Ol5i4xo2WuH0IIyRZ3O9Mnsvqw60uVPDiwvRRc6hf4P
         Bozlw4CHzuJ58VpKqkq85WGsJA1UZ+LZmw8PPmq5lD05v4yfs1U3kpjXws9gFme5e7
         4UtDcAZPCCDBBghgKS6qKewdKh95q5IlmNdMUwq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/39] 4.14.165-stable review
Date:   Tue, 14 Jan 2020 11:01:34 +0100
Message-Id: <20200114094336.210038037@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.165-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.165-rc1
X-KernelTest-Deadline: 2020-01-16T09:43+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.165 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.165-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.165-rc1

Florian Westphal <fw@strlen.de>
    netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present

Florian Westphal <fw@strlen.de>
    netfilter: arp_tables: init netns pointer in xt_tgchk_param struct

Tony Lindgren <tony@atomide.com>
    phy: cpcap-usb: Fix flakey host idling and enumerating of devices

Tony Lindgren <tony@atomide.com>
    phy: cpcap-usb: Fix error path when no host driver is loaded

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix: Don't skip endpoint descriptors with maxpacket=0

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hiddev: fix mess in hiddev_open()

Will Deacon <will.deacon@arm.com>
    arm64: cpufeature: Avoid warnings due to unused symbols

Navid Emamdoost <navid.emamdoost@gmail.com>
    ath10k: fix memory leak

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

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/fb-helper: Round up bits_per_pixel if possible

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: add safety guards to input_set_keycode()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: hid-input: clear unmapped usages

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713

Paul Cercueil <paul@crapouillou.net>
    usb: musb: dma: Correct parameter passed to IRQ handler

Paul Cercueil <paul@crapouillou.net>
    usb: musb: Disable pullup at init

Tony Lindgren <tony@atomide.com>
    usb: musb: fix idling for suspend after disconnect interrupt

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add ZLP support for 0x1bc7/0x9010

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: set usb_set_intfdata on driver fail.

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Turn dmi_system_id table into a generic quirk table

Oliver Hartkopp <socketcan@hartkopp.net>
    can: can_dropped_invalid_skb(): ensure an initialized headroom in outgoing CAN sk_buffs

Florian Faber <faber@faberman.de>
    can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode

Johan Hovold <johan@kernel.org>
    can: gs_usb: gs_usb_probe(): use descriptors of current altsetting

Marcel Holtmann <marcel@holtmann.org>
    HID: uhid: Fix returning EPOLLOUT from uhid_char_poll

Alan Stern <stern@rowland.harvard.edu>
    HID: Fix slab-out-of-bounds read in hid_field_extract

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defined

Kaitao Cheng <pilgrimtao@gmail.com>
    kernel/trace: Fix do not unregister tracepoints when register sched_migrate_task fail

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Set EAPD control to default for ALC222

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new codec supported for ALCS1200A

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Apply the sample rate quirk for Bose Companion 5

Guenter Roeck <linux@roeck-us.net>
    usb: chipidea: host: Disable port power only if previously enabled

Will Deacon <will@kernel.org>
    chardev: Avoid potential use-after-free in 'chrdev_open()'


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/kernel/cpufeature.c                     | 12 +--
 drivers/gpio/gpiolib-acpi.c                        | 51 ++++++++++--
 drivers/gpu/drm/drm_dp_mst_topology.c              |  2 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  7 +-
 drivers/hid/hid-core.c                             |  6 ++
 drivers/hid/hid-input.c                            | 16 +++-
 drivers/hid/uhid.c                                 |  3 +-
 drivers/hid/usbhid/hiddev.c                        | 97 ++++++++++------------
 drivers/input/input.c                              | 26 +++---
 drivers/net/can/mscan/mscan.c                      | 21 +++--
 drivers/net/can/usb/gs_usb.c                       |  4 +-
 drivers/net/wireless/ath/ath10k/usb.c              |  1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  4 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   | 13 ++-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  1 +
 drivers/phy/motorola/phy-cpcap-usb.c               | 35 ++++----
 drivers/scsi/bfa/bfad_attr.c                       |  4 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  4 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  1 +
 drivers/staging/vt6656/device.h                    |  1 +
 drivers/staging/vt6656/main_usb.c                  |  1 +
 drivers/staging/vt6656/wcmd.c                      |  1 +
 drivers/tty/serial/serial_core.c                   |  1 +
 drivers/usb/chipidea/host.c                        |  4 +-
 drivers/usb/core/config.c                          | 12 ++-
 drivers/usb/musb/musb_core.c                       | 11 +++
 drivers/usb/musb/musbhsdma.c                       |  2 +-
 drivers/usb/serial/option.c                        |  8 ++
 drivers/usb/serial/usb-wwan.h                      |  1 +
 drivers/usb/serial/usb_wwan.c                      |  4 +
 fs/char_dev.c                                      |  2 +-
 include/linux/can/dev.h                            | 34 ++++++++
 kernel/trace/trace_sched_wakeup.c                  |  4 +-
 kernel/trace/trace_stack.c                         |  5 ++
 net/ipv4/netfilter/arp_tables.c                    | 27 +++---
 net/netfilter/ipset/ip_set_core.c                  |  3 +-
 sound/pci/hda/patch_realtek.c                      |  4 +
 sound/usb/quirks.c                                 |  1 +
 39 files changed, 299 insertions(+), 139 deletions(-)


