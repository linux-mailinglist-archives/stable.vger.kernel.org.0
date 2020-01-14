Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A8F13B4EE
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 22:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgANV5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 16:57:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbgANV5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 16:57:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F53824658;
        Tue, 14 Jan 2020 21:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579039064;
        bh=KVI5lekAU+wTqa2tRVni7Ie2uhvJLakgmu2LoogjIhY=;
        h=Date:From:To:Cc:Subject:From;
        b=UYrY+FF7Qk0BeNQNjoJEJJbQaa5Yz9gyDbWZ5GKiH5pOS2lPbDc9Mh9OeT5vk+A/7
         /W4i3mEQskbVJaVXRJGyV/6hojJPgWda3rcNFSr4hyM4D+7kfQrMKPQFWJVq2XJ5mI
         tYnASsIhDwrF5TyZHVgFX04Yfsw7oIsMB5d1ygYk=
Date:   Tue, 14 Jan 2020 22:57:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.96
Message-ID: <20200114215741.GA2362526@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.96 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 drivers/gpio/gpiolib-acpi.c                           |   51 ++++++++-
 drivers/gpu/drm/drm_dp_mst_topology.c                 |    2=20
 drivers/gpu/drm/drm_fb_helper.c                       |    7 +
 drivers/gpu/drm/i915/intel_lrc.c                      |    9 +
 drivers/gpu/drm/sun4i/sun4i_tcon.c                    |   15 ++
 drivers/gpu/drm/sun4i/sun4i_tcon.h                    |    1=20
 drivers/hid/hid-core.c                                |    6 +
 drivers/hid/hid-input.c                               |   16 ++
 drivers/hid/uhid.c                                    |    2=20
 drivers/hid/usbhid/hiddev.c                           |   97 +++++++------=
-----
 drivers/i2c/i2c-core-base.c                           |   13 +-
 drivers/input/evdev.c                                 |   14 +-
 drivers/input/input.c                                 |   26 ++--
 drivers/input/misc/uinput.c                           |   14 +-
 drivers/net/can/mscan/mscan.c                         |   21 +--
 drivers/net/can/usb/gs_usb.c                          |    4=20
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c     |    2=20
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c      |    2=20
 drivers/net/wireless/ath/ath10k/usb.c                 |    1=20
 drivers/net/wireless/marvell/mwifiex/pcie.c           |    4=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c      |   13 ++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |    1=20
 drivers/phy/motorola/phy-cpcap-usb.c                  |   35 +++---
 drivers/scsi/bfa/bfad_attr.c                          |    4=20
 drivers/staging/comedi/drivers/adv_pci1710.c          |    4=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c           |    1=20
 drivers/staging/vt6656/device.h                       |    1=20
 drivers/staging/vt6656/main_usb.c                     |    1=20
 drivers/staging/vt6656/wcmd.c                         |    1=20
 drivers/tty/serdev/core.c                             |   10 +
 drivers/tty/serial/serial_core.c                      |    1=20
 drivers/usb/chipidea/host.c                           |    4=20
 drivers/usb/core/config.c                             |   12 +-
 drivers/usb/musb/musb_core.c                          |   11 ++
 drivers/usb/musb/musbhsdma.c                          |    2=20
 drivers/usb/serial/option.c                           |    8 +
 drivers/usb/serial/usb-wwan.h                         |    1=20
 drivers/usb/serial/usb_wwan.c                         |    4=20
 fs/char_dev.c                                         |    2=20
 include/linux/can/dev.h                               |   34 ++++++
 include/trace/events/preemptirq.h                     |    8 -
 include/uapi/linux/input.h                            |    1=20
 kernel/trace/trace_sched_wakeup.c                     |    4=20
 kernel/trace/trace_stack.c                            |    5=20
 net/ipv4/netfilter/arp_tables.c                       |   27 ++---
 net/netfilter/ipset/ip_set_core.c                     |    3=20
 net/netfilter/nf_conntrack_proto_dccp.c               |    3=20
 net/netfilter/nf_conntrack_proto_sctp.c               |    3=20
 sound/pci/hda/patch_realtek.c                         |    5=20
 sound/usb/quirks.c                                    |    1=20
 51 files changed, 362 insertions(+), 157 deletions(-)

Akeem G Abodunrin (1):
      drm/i915/gen9: Clear residual context state on context switch

Alan Stern (2):
      HID: Fix slab-out-of-bounds read in hid_field_extract
      USB: Fix: Don't skip endpoint descriptors with maxpacket=3D0

Arnd Bergmann (1):
      Input: input_event - fix struct padding on sparc64

Chen-Yu Tsai (1):
      drm/sun4i: tcon: Set RGB DCLK min. divider based on hardware model

Daniele Palmas (1):
      USB: serial: option: add ZLP support for 0x1bc7/0x9010

Dmitry Torokhov (3):
      HID: hid-input: clear unmapped usages
      Input: add safety guards to input_set_keycode()
      HID: hiddev: fix mess in hiddev_open()

Florian Faber (1):
      can: mscan: mscan_rx_poll(): fix rx path lockup when returning from p=
olling to irq mode

Florian Westphal (3):
      netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
      netfilter: conntrack: dccp, sctp: handle null timeout argument
      netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present

Ganapathi Bhat (1):
      mwifiex: fix possible heap overflow in mwifiex_process_country_ie()

Geert Uytterhoeven (1):
      drm/fb-helper: Round up bits_per_pixel if possible

Greg Kroah-Hartman (1):
      Linux 4.19.96

Guenter Roeck (1):
      usb: chipidea: host: Disable port power only if previously enabled

Hans de Goede (2):
      gpiolib: acpi: Turn dmi_system_id table into a generic quirk table
      gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism

Ian Abbott (1):
      staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713

Joel Fernandes (Google) (1):
      tracing: Change offset type to s32 in preempt/irq tracepoints

Johan Hovold (2):
      can: kvaser_usb: fix interface sanity check
      can: gs_usb: gs_usb_probe(): use descriptors of current altsetting

Kailang Yang (3):
      ALSA: hda/realtek - Add new codec supported for ALCS1200A
      ALSA: hda/realtek - Set EAPD control to default for ALC222
      ALSA: hda/realtek - Add quirk for the bass speaker on Lenovo Yoga X1 =
7th gen

Kaitao Cheng (1):
      kernel/trace: Fix do not unregister tracepoints when register sched_m=
igrate_task fail

Malcolm Priestley (1):
      staging: vt6656: set usb_set_intfdata on driver fail.

Marcel Holtmann (1):
      HID: uhid: Fix returning EPOLLOUT from uhid_char_poll

Michael Straube (1):
      staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21

Navid Emamdoost (4):
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf
      scsi: bfa: release allocated memory in case of error
      rtl8xxxu: prevent leaking urb
      ath10k: fix memory leak

Oliver Hartkopp (1):
      can: can_dropped_invalid_skb(): ensure an initialized headroom in out=
going CAN sk_buffs

Paul Cercueil (2):
      usb: musb: Disable pullup at init
      usb: musb: dma: Correct parameter passed to IRQ handler

Punit Agrawal (1):
      serdev: Don't claim unsupported ACPI serial devices

Russell King (1):
      i2c: fix bus recovery stop mode timing

Steven Rostedt (VMware) (1):
      tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defin=
ed

Sudip Mukherjee (2):
      tty: link tty and port before configuring it as console
      tty: always relink the port

Takashi Iwai (1):
      ALSA: usb-audio: Apply the sample rate quirk for Bose Companion 5

Tony Lindgren (3):
      usb: musb: fix idling for suspend after disconnect interrupt
      phy: cpcap-usb: Fix error path when no host driver is loaded
      phy: cpcap-usb: Fix flakey host idling and enumerating of devices

Wayne Lin (1):
      drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ

Will Deacon (1):
      chardev: Avoid potential use-after-free in 'chrdev_open()'


--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4eOVUACgkQONu9yGCS
aT5ODBAAm5OReQf4YoCIQmvzfhb40sDl0p60HPAu8nK0r22QDhqOrj2q+hx1fckU
EF5/FJwYUFnIPYJwL3z6BaGVLJlxanRKRVQBF5SuT0R3NfqkQNYgNwmUe0sxO7MP
SEMiEGcc49pleW5XvOEYmfpc1THu/36mO5lvUrI/APzVUbaKnc4C2DCjvY88jrmL
HZwQOUI3XZeUbkq61YrexeSfz2mAG9bWgFqxQuXFfVBNtE7jONG3JCS1OGYDa5hA
vkaZp+hqA5Hz7RKu9jDdGl8VJD8e+z5jHR8p1i/XXYC45OMJaIJIrLVgIiPWkg0q
JFrDYDBOLgwKgB4AibLtK9IvdNFxUuptOId0MzNvmYkSiwWml6K37HnlV/7j9RGG
9Lt/oAT67AMz+Pj2AHin/cEMIsKHWoBxsuvKqGLyhzY/JWb9FTF8NTiLtswciar6
DuPsJCMPsP7U8k51O2TWpv4OFQc/JrfTC0jpPMyOSZPI7BUeMlvGpu49b5p2nDRm
83HEWK8nEYfN3KuRWe1hxwWUw43t4ITdhwoUHXCJSd6sEraXyiGCjBxKLbFotY5P
2+/LeyN2xbMs6hnGQ9EXDR1jemorVfhzQEqIWW42nz3B8eKXbw1LvptJxoZ10kLP
MRBGgR9JXi/AE5bqt1jub0Z+brWiDZPU1yaHtDuX94VUXIKK+Cg=
=Nvdr
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
