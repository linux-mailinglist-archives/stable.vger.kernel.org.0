Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4710F3A429
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 09:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfFIHjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 03:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbfFIHjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 03:39:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 212562070B;
        Sun,  9 Jun 2019 07:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560065981;
        bh=CtCg7aOz+X1NoGfaxUtHCPgCBzmAKfJLJgZzKQExcfY=;
        h=Date:From:To:Cc:Subject:From;
        b=cDzWSMkNnbsCKblvTG9U0R9s+Bd2QQMpsouhUYNynxOr8i04JeIwV/o7BY6NgMMB3
         uDCP9tjZG1/zSq3CveiWSOyx86dCmSE5XHu7QlKmxism2RZAvbBqIpo8DQN6FscC4R
         XI28TOeMYw4W/gbWxqRZo2vX4immaSKza/AtAeEU=
Date:   Sun, 9 Jun 2019 09:39:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.49
Message-ID: <20190609073939.GA10295@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.49 kernel.

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

 Documentation/conf.py                                              |    2=
=20
 Documentation/sphinx/kerneldoc.py                                  |   44 =
++
 Documentation/sphinx/kernellog.py                                  |   28 +
 Documentation/sphinx/kfigure.py                                    |   40 =
+-
 Makefile                                                           |    2=
=20
 arch/arm64/kernel/sys.c                                            |    2=
=20
 arch/mips/kvm/mips.c                                               |    3=
=20
 arch/powerpc/kvm/book3s_xive.c                                     |    4=
=20
 arch/powerpc/kvm/powerpc.c                                         |    3=
=20
 arch/powerpc/perf/core-book3s.c                                    |    6=
=20
 arch/powerpc/perf/power8-pmu.c                                     |    3=
=20
 arch/powerpc/perf/power9-pmu.c                                     |    3=
=20
 arch/s390/crypto/aes_s390.c                                        |  156 =
+++++++---
 arch/s390/crypto/des_s390.c                                        |    7=
=20
 arch/s390/kvm/kvm-s390.c                                           |    1=
=20
 arch/sparc/mm/ultra.S                                              |    4=
=20
 arch/x86/kernel/ftrace.c                                           |   49 =
+--
 arch/x86/kernel/ftrace_64.S                                        |    8=
=20
 arch/x86/kernel/kprobes/core.c                                     |   24 +
 arch/x86/kernel/vmlinux.lds.S                                      |    6=
=20
 arch/x86/kvm/x86.c                                                 |    3=
=20
 drivers/gpu/drm/drm_crtc.c                                         |    4=
=20
 drivers/gpu/drm/drm_plane.c                                        |    8=
=20
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h                  |    2=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c                      |   26 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h                      |    2=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c                     |   15=
=20
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c                      |   21 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h                      |    1=
=20
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c                        |    9=
=20
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c                             |   29 +
 drivers/gpu/drm/tegra/gem.c                                        |    4=
=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                                |    8=
=20
 drivers/i2c/busses/i2c-mlxcpld.c                                   |    2=
=20
 drivers/i2c/busses/i2c-synquacer.c                                 |    2=
=20
 drivers/iio/adc/ti-ads8688.c                                       |    2=
=20
 drivers/iio/dac/ds4424.c                                           |    2=
=20
 drivers/media/usb/siano/smsusb.c                                   |   33 =
+-
 drivers/media/usb/uvc/uvc_driver.c                                 |    2=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c            |   11=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h            |    6=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c            |    4=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c        |   16 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h        |    3=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c           |   10=
=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h           |    3=
=20
 drivers/of/dynamic.c                                               |   27 +
 drivers/of/overlay.c                                               |   61 =
+++
 drivers/s390/scsi/zfcp_ext.h                                       |    1=
=20
 drivers/s390/scsi/zfcp_scsi.c                                      |    9=
=20
 drivers/s390/scsi/zfcp_sysfs.c                                     |   55 =
+++
 drivers/s390/scsi/zfcp_unit.c                                      |    8=
=20
 drivers/scsi/lpfc/lpfc_nvme.c                                      |    6=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    9=
=20
 drivers/staging/wlan-ng/hfa384x_usb.c                              |    3=
=20
 drivers/tty/serial/max310x.c                                       |    2=
=20
 drivers/tty/serial/msm_serial.c                                    |    5=
=20
 drivers/tty/serial/sh-sci.c                                        |    7=
=20
 drivers/tty/vt/vt.c                                                |   11=
=20
 drivers/usb/core/config.c                                          |    4=
=20
 drivers/usb/core/quirks.c                                          |    3=
=20
 drivers/usb/host/xhci-ring.c                                       |   17 -
 drivers/usb/host/xhci.c                                            |   24 -
 drivers/usb/misc/rio500.c                                          |   41 =
++
 drivers/usb/misc/sisusbvga/sisusb.c                                |   15=
=20
 drivers/usb/usbip/stub_dev.c                                       |   75 =
+++-
 drivers/video/fbdev/core/fbcon.c                                   |    2=
=20
 fs/btrfs/inode.c                                                   |   14=
=20
 fs/btrfs/send.c                                                    |    6=
=20
 fs/btrfs/tree-log.c                                                |   20 -
 fs/cifs/file.c                                                     |    4=
=20
 fs/cifs/smb2pdu.c                                                  |    3=
=20
 fs/lockd/xdr.c                                                     |    4=
=20
 fs/lockd/xdr4.c                                                    |    4=
=20
 include/linux/bitops.h                                             |   16 -
 include/linux/compiler-gcc.h                                       |    4=
=20
 include/linux/compiler_types.h                                     |    4=
=20
 include/linux/list_lru.h                                           |    1=
=20
 include/linux/module.h                                             |    4=
=20
 include/linux/of.h                                                 |    6=
=20
 kernel/signal.c                                                    |    2=
=20
 kernel/trace/trace_events_filter.c                                 |    8=
=20
 mm/list_lru.c                                                      |    8=
=20
 scripts/gcc-plugins/gcc-common.h                                   |    4=
=20
 security/integrity/evm/evm_crypto.c                                |    3=
=20
 security/integrity/ima/ima_policy.c                                |   21 -
 sound/pci/hda/patch_realtek.c                                      |   18 -
 sound/usb/line6/driver.c                                           |   12=
=20
 sound/usb/line6/driver.h                                           |    4=
=20
 sound/usb/line6/toneport.c                                         |   15=
=20
 virt/kvm/arm/arm.c                                                 |    3=
=20
 virt/kvm/kvm_main.c                                                |    2=
=20
 92 files changed, 877 insertions(+), 321 deletions(-)

Alan Stern (3):
      USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor
      media: usb: siano: Fix general protection fault in smsusb
      media: usb: siano: Fix false-positive "uninitialized variable" warning

Andrey Smirnov (1):
      xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()

Benjamin Coddington (1):
      Revert "lockd: Show pid of lockd for remote locks"

Carsten Schmid (1):
      usb: xhci: avoid null pointer deref when bos field is NULL

Catalin Marinas (1):
      arm64: Fix the arm64_personality() syscall wrapper redirection

Colin Ian King (1):
      cifs: fix memory leak of pneg_inbuf on -EOPNOTSUPP ioctl case

C=E9dric Le Goater (1):
      KVM: PPC: Book3S HV: XIVE: Do not clear IRQ data of passthrough inter=
rupts

Dan Carpenter (1):
      staging: vc04_services: prevent integer overflow in create_pagelist()

Daniel Vetter (1):
      drm/lease: Make sure implicit planes are leased

Dmitry Osipenko (1):
      drm/tegra: gem: Fix CPU-cache maintenance for BO's allocated using ge=
t_pages()

Fabio Estevam (1):
      xhci: Use %zu for printing size_t type

Filipe Manana (4):
      Btrfs: fix wrong ctime and mtime of a directory after log replay
      Btrfs: fix race updating log root item during fsync
      Btrfs: fix fsync not persisting changed attributes of a directory
      Btrfs: incremental send, fix file corruption when no-holes feature is=
 enabled

Frank Rowand (2):
      of: overlay: validate overlay properties #address-cells and #size-cel=
ls
      of: overlay: set node fields from properties when add new overlay node

George G. Davis (1):
      serial: sh-sci: disable DMA for uart_console

Greg Kroah-Hartman (2):
      Revert "x86/build: Move _etext to actual end of .text"
      Linux 4.19.49

Grzegorz Halat (1):
      vt/fbcon: deinitialize resources in visual_init() after failed memory=
 allocation

Harald Freudenberger (2):
      s390/crypto: fix gcm-aes-s390 selftest failures
      s390/crypto: fix possible sleep during spinlock aquired

Henry Lin (1):
      xhci: update bounce buffer with correct sg num

Hui Wang (1):
      ALSA: hda/realtek - Improve the headset mic for Acer Aspire laptops

James Clarke (1):
      sparc64: Fix regression in non-hypervisor TLB flush xcall

Jernej Skrabec (2):
      drm/sun4i: Fix sun8i HDMI PHY clock initialization
      drm/sun4i: Fix sun8i HDMI PHY configuration for > 148.5 MHz

Jiri Slaby (1):
      memcg: make it work on sparse non-0-node systems

Joe Burmeister (1):
      tty: max310x: Fix external crystal register setup

Jonathan Corbet (3):
      docs: Fix conf.py for Sphinx 2.0
      doc: Cope with the deprecation of AutoReporter
      doc: Cope with Sphinx logging deprecations

Jorge Ramirez-Ortiz (1):
      tty: serial: msm_serial: Fix XON/XOFF

Kailang Yang (1):
      ALSA: hda/realtek - Set default power save node to 0

Kees Cook (1):
      gcc-plugins: Fix build failures under Darwin host

Lyude Paul (1):
      drm/nouveau/i2c: Disable i2c bus access after ->fini()

Masahisa Kojima (1):
      i2c: synquacer: fix synquacer_i2c_doxfer() return value

Mauro Carvalho Chehab (1):
      media: smsusb: better handle optional alignment

Maximilian Luz (1):
      USB: Add LPM quirk for Surface Dock GigE adapter

Miguel Ojeda (2):
      Compiler Attributes: add support for __copy (gcc >=3D 9)
      include/linux/module.h: copy __init/__exit attrs to init/cleanup_modu=
le

Nadav Amit (3):
      x86/ftrace: Set trampoline pages as executable
      x86/kprobes: Set instruction page as executable
      media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

Nathan Chancellor (1):
      scsi: lpfc: Fix backport of faf5a744f4f8 ("scsi: lpfc: avoid uninitia=
lized variable warning")

Oliver Neukum (3):
      USB: sisusbvga: fix oops in error path of sisusb_probe
      USB: rio500: refuse more than one device at a time
      USB: rio500: fix memory leak in close after disconnect

Piotr Figiel (1):
      brcmfmac: fix NULL pointer derefence during USB disconnect

Rasmus Villemoes (1):
      include/linux/bitops.h: sanitize rotate primitives

Ravi Bangoria (1):
      powerpc/perf: Fix MMCRA corruption by bhrb_filter

Roberto Bergantinos Corpas (1):
      CIFS: cifs_read_allocate_pages: don't iterate through whole page arra=
y on ENOMEM

Roberto Sassu (2):
      ima: show rules with IMA_INMASK correctly
      evm: check hash algorithm passed to init_desc()

Ruslan Babayev (1):
      iio: dac: ds4422/ds4424 fix chip verification

Sean Nyekjaer (1):
      iio: adc: ti-ads8688: fix timestamp is not updated in buffer

Shuah Khan (2):
      usbip: usbip_host: fix BUG: sleeping function called from invalid con=
text
      usbip: usbip_host: fix stub_dev lock context imbalance regression

Steffen Maier (2):
      scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_r=
emove
      scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only=
 sdevs)

Steven Rostedt (VMware) (1):
      x86/ftrace: Do not call function graph from dynamic trampolines

Takashi Iwai (1):
      ALSA: line6: Assure canceling delayed work at disconnection

Thomas Hellstrom (1):
      drm/vmwgfx: Don't send drm sysfs hotplug events on initial master set

Thomas Huth (1):
      KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID

Tim Collier (1):
      staging: wlan-ng: fix adapter initialization failure

Todd Kjos (2):
      Revert "binder: fix handling of misaligned binder object"
      binder: fix race between munmap() and direct reclaim

Tomas Bortoli (1):
      tracing: Avoid memory leak in predicate_parse()

Vadim Pasternak (1):
      i2c: mlxcpld: Fix wrong initialization order in probe

Vicente Bergas (1):
      drm/rockchip: shutdown drm subsystem on shutdown

Zhenliang Wei (1):
      kernel/signal.c: trace_signal_deliver when signal_group_exit


--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlz8t7sACgkQONu9yGCS
aT7Szg//Rhvml8dB3joVX6QSg6XTQH7WkBa3+84kNssY3OUdHs5K6DjKs9fTmxmG
tYp86owUhf5urQSDURFo3dY0hsmhsTalH9nV3CjPsnLHegDtQpXd8FC3WdMBaOL1
OUjA5cDi/hmgyeO3PQ5qWN+od06Yuq1Syt96UqW/3PESRVI4aXj6s3+CNdKXBGRd
dZVv4KfYQ2yTg2I4ZHVUrlOpldkjNwuqy/j+lL6jeW4DKRTo6R36KqUzL3ueYJki
zVHXkBx2t8Rrvc/m1p5Vlci3qDzUimqEzg//tdsreY0mZV0ZMhU2Js0w6fR1gNkM
7DE75Obtl3SUTnesXQO6AE4f3oyBWzWcxvvVAL6kA8IO4ys2HqSXsuLyahMeB5aG
maj7+waz4TUiQ7L3Su01z6BhHPvS4hYlBN3s+Tko5PoTg8Hn5Iknm4aQrb0V0KZw
x5I/Qv1FxUJnOimmlRcU6JjYI6wSxl5q3bh5G/9AvVhrbAb9oYNwanR1wGkmOPG5
YdOEl+c7I3KAJPw7/JzOmNDdibn7Sw8XjIneKBlAv5QjJnV7wtPhyuGJklLFoS8e
ZS/1g31jCixlq0tr9vccayV13wE+SoG7Z4mM3rNheWqV12yLuKDwYvvS0hJmxuwi
1gXimtauc9aan4c21SV1VOCme06b4RiIWUf9K3DptdxQiZHItq0=
=q7WY
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
