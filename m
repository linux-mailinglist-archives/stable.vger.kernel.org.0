Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723BD13B4EA
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 22:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgANV51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 16:57:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbgANV50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 16:57:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6898424676;
        Tue, 14 Jan 2020 21:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579039046;
        bh=MlkzMAjVlT/B7Gx9ayr31sePmz3Tirc1G4XXJ9dkMOA=;
        h=Date:From:To:Cc:Subject:From;
        b=kzoyIrQjg8z8/DiUHWau01LN9lS68wysxVjoKJ1eYboI9uTCOKesFaS/RUCe+qo8w
         1eVreN32XRbsEsQR2DkYIwcFU4QtTbkNUMVwDb+bhzPDSUnakiiGQEN7itqPnJNY5y
         gcB2Bid7gCUewGDxwkwzVdu6VpSUPDS8980S/6pE=
Date:   Tue, 14 Jan 2020 22:57:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.165
Message-ID: <20200114215723.GA2362401@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.165 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 arch/arm64/kernel/cpufeature.c                        |   12 +-
 drivers/gpio/gpiolib-acpi.c                           |   51 ++++++++-
 drivers/gpu/drm/drm_dp_mst_topology.c                 |    2=20
 drivers/gpu/drm/drm_fb_helper.c                       |    7 +
 drivers/gpu/drm/i915/intel_lrc.c                      |   19 +--
 drivers/hid/hid-core.c                                |    6 +
 drivers/hid/hid-input.c                               |   16 ++
 drivers/hid/uhid.c                                    |    3=20
 drivers/hid/usbhid/hiddev.c                           |   97 +++++++------=
-----
 drivers/input/input.c                                 |   26 ++--
 drivers/net/can/mscan/mscan.c                         |   21 +--
 drivers/net/can/usb/gs_usb.c                          |    4=20
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
 kernel/trace/trace_sched_wakeup.c                     |    4=20
 kernel/trace/trace_stack.c                            |    5=20
 net/ipv4/netfilter/arp_tables.c                       |   27 ++---
 net/netfilter/ipset/ip_set_core.c                     |    3=20
 sound/pci/hda/patch_realtek.c                         |    4=20
 sound/usb/quirks.c                                    |    1=20
 40 files changed, 306 insertions(+), 149 deletions(-)

Akeem G Abodunrin (1):
      drm/i915/gen9: Clear residual context state on context switch

Alan Stern (2):
      HID: Fix slab-out-of-bounds read in hid_field_extract
      USB: Fix: Don't skip endpoint descriptors with maxpacket=3D0

Daniele Palmas (1):
      USB: serial: option: add ZLP support for 0x1bc7/0x9010

Dmitry Torokhov (3):
      HID: hid-input: clear unmapped usages
      Input: add safety guards to input_set_keycode()
      HID: hiddev: fix mess in hiddev_open()

Florian Faber (1):
      can: mscan: mscan_rx_poll(): fix rx path lockup when returning from p=
olling to irq mode

Florian Westphal (2):
      netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
      netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present

Ganapathi Bhat (1):
      mwifiex: fix possible heap overflow in mwifiex_process_country_ie()

Geert Uytterhoeven (1):
      drm/fb-helper: Round up bits_per_pixel if possible

Greg Kroah-Hartman (1):
      Linux 4.14.165

Guenter Roeck (1):
      usb: chipidea: host: Disable port power only if previously enabled

Hans de Goede (2):
      gpiolib: acpi: Turn dmi_system_id table into a generic quirk table
      gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism

Ian Abbott (1):
      staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713

Johan Hovold (1):
      can: gs_usb: gs_usb_probe(): use descriptors of current altsetting

Kailang Yang (2):
      ALSA: hda/realtek - Add new codec supported for ALCS1200A
      ALSA: hda/realtek - Set EAPD control to default for ALC222

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

Will Deacon (2):
      chardev: Avoid potential use-after-free in 'chrdev_open()'
      arm64: cpufeature: Avoid warnings due to unused symbols


--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4eOUIACgkQONu9yGCS
aT7H/BAAq1FAi9vh/5vRDbiu6VCrTP/Fs2b65Hb0eDO8NvUVozoyTl5ZqPhFgKIb
xWcTIn0zytvmBiZX8ccquKXudXzbKHJ/6+naf7iOPoPbmcHroQcmStR2ReJlxMIE
Gh6rDRwu5k0dH92DhiXY/HzqE9bS8vlw+l+cewPv8Zi3kF4HwmCO/c99A4zTwCkU
YASKvjUmQ03vIAcQxw3fbhVopSYTElkWteqUN5Xe0aHmm3A5Exa2dUG1mA7qMK+o
dGXU6kmIKa2kP0p+IGFKufmvE8OfN9mWILB9ajKQ0jwYQiff5F+4Pk93x5/xEqWM
9fUMvBh2ArGfzHuxG4pArOAz2hhILKv2/9NaPoCOHginrCT7L1Zf/S7cXNTjvR9m
0cLVqxdqIpvhRwRs80TBLxEfXCRwhYXHYD+IGOjWQz4w9qYnVaUgdPmKtBdQPD36
eAi4JQpUTJ1GKS+PZsXm6Ef9FckIvA+4zDNGVfmDCfiyoXItlby+sn4HZq+77fmB
3r+RJC5bEXiIjSAabfj1eoPCzNpavdKiY4dZdSDNZCMip4kYuzMkQ0S3aDy5+j1b
hHDKHclEf3METCDbjRC7x7lHNc27Z+PMlrPOCxoqueHGJGokXhNA6tOCiHci6JMn
ZFhQWHTXT50EKACnUKvUIb8qzmvbekfmX+65vH0MeT/EYu3x31Y=
=Loif
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
