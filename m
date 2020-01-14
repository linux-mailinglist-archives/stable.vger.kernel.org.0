Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A7C13B4F2
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 22:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgANV6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 16:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbgANV6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 16:58:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07CC724673;
        Tue, 14 Jan 2020 21:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579039082;
        bh=QZmmQhtTZhFn5RWULXkcKZqRQZnjU475IG6k7KlYd9E=;
        h=Date:From:To:Cc:Subject:From;
        b=QUOl4D/cHI71iePKCA2+uptSAeQclr1dQ4YeiqeO1FysbZIMDEs8oy2USo5749bXj
         jzYkPzZDEGRRZe5MZJ9je/ZGnvEs5n1anpzYlK/BwpUz58nxECoBN+HsfMpJykxZl0
         275wCZ9vZxlw/IA4kezZUav+Xl/omnspJ7uyXs+k=
Date:   Tue, 14 Jan 2020 22:57:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.12
Message-ID: <20200114215759.GA2362638@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.12 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                              |    2=20
 arch/arm/Kconfig                                      |    1=20
 arch/arm/kernel/process.c                             |    6 -
 arch/arm64/Kconfig                                    |    1=20
 arch/arm64/include/asm/unistd.h                       |    1=20
 arch/arm64/include/uapi/asm/unistd.h                  |    1=20
 arch/arm64/kernel/process.c                           |   10 -
 arch/parisc/Kconfig                                   |    1=20
 arch/parisc/kernel/process.c                          |    8 -
 arch/riscv/Kconfig                                    |    1=20
 arch/riscv/kernel/process.c                           |    6 -
 arch/um/Kconfig                                       |    1=20
 arch/um/include/asm/ptrace-generic.h                  |    2=20
 arch/um/kernel/process.c                              |    6 -
 arch/x86/um/tls_32.c                                  |    6 -
 arch/x86/um/tls_64.c                                  |    7 -
 arch/xtensa/Kconfig                                   |    1=20
 arch/xtensa/kernel/process.c                          |    8 -
 drivers/char/tpm/tpm-dev-common.c                     |    2=20
 drivers/char/tpm/tpm-dev.h                            |    2=20
 drivers/char/tpm/tpm_tis_core.c                       |   34 ++----
 drivers/gpio/gpiolib-acpi.c                           |   51 ++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c               |    4=20
 drivers/gpu/drm/drm_dp_mst_topology.c                 |    2=20
 drivers/gpu/drm/drm_fb_helper.c                       |    7 +
 drivers/gpu/drm/i915/gt/intel_lrc.c                   |   10 +
 drivers/gpu/drm/i915/i915_reg.h                       |    8 +
 drivers/gpu/drm/i915/intel_pm.c                       |   11 ++
 drivers/gpu/drm/sun4i/sun4i_tcon.c                    |   15 ++
 drivers/gpu/drm/sun4i/sun4i_tcon.h                    |    1=20
 drivers/hid/hid-core.c                                |    6 +
 drivers/hid/hid-input.c                               |   16 ++
 drivers/hid/hidraw.c                                  |    4=20
 drivers/hid/uhid.c                                    |    2=20
 drivers/hid/usbhid/hiddev.c                           |   97 +++++++------=
-----
 drivers/i2c/i2c-core-base.c                           |   13 +-
 drivers/infiniband/hw/hfi1/tid_rdma.c                 |    9 +
 drivers/input/evdev.c                                 |   14 +-
 drivers/input/input.c                                 |   26 ++--
 drivers/input/misc/uinput.c                           |   14 +-
 drivers/iommu/intel-iommu.c                           |    9 +
 drivers/net/can/m_can/tcan4x5x.c                      |    4=20
 drivers/net/can/mscan/mscan.c                         |   21 +--
 drivers/net/can/usb/gs_usb.c                          |    4=20
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c     |    2=20
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c      |    2=20
 drivers/net/wireless/ath/ath10k/usb.c                 |    1=20
 drivers/net/wireless/marvell/mwifiex/pcie.c           |    4=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c      |   13 ++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |    1=20
 drivers/phy/motorola/phy-cpcap-usb.c                  |   35 +++---
 drivers/powercap/intel_rapl_common.c                  |    3=20
 drivers/rpmsg/rpmsg_char.c                            |    6 -
 drivers/rtc/rtc-sun6i.c                               |   16 ++
 drivers/scsi/bfa/bfad_attr.c                          |    4=20
 drivers/staging/comedi/drivers/adv_pci1710.c          |    4=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c           |    1=20
 drivers/staging/vt6656/baseband.c                     |    4=20
 drivers/staging/vt6656/card.c                         |    2=20
 drivers/staging/vt6656/device.h                       |    1=20
 drivers/staging/vt6656/main_usb.c                     |    3=20
 drivers/staging/vt6656/usbpipe.c                      |   25 ++++
 drivers/staging/vt6656/usbpipe.h                      |    5=20
 drivers/staging/vt6656/wcmd.c                         |    1=20
 drivers/tty/serdev/core.c                             |   10 +
 drivers/tty/serial/serial_core.c                      |    1=20
 drivers/usb/cdns3/gadget.c                            |   14 --
 drivers/usb/chipidea/host.c                           |    4=20
 drivers/usb/core/config.c                             |   12 +-
 drivers/usb/host/ohci-da8xx.c                         |    8 +
 drivers/usb/musb/musb_core.c                          |   11 ++
 drivers/usb/musb/musbhsdma.c                          |    2=20
 drivers/usb/serial/option.c                           |    8 +
 drivers/usb/serial/usb-wwan.h                         |    1=20
 drivers/usb/serial/usb_wwan.c                         |    4=20
 drivers/usb/typec/tcpm/tcpci.c                        |   20 ++-
 fs/char_dev.c                                         |    2=20
 fs/pstore/ram.c                                       |    4=20
 fs/pstore/ram_core.c                                  |    2=20
 include/linux/can/dev.h                               |   34 ++++++
 include/trace/events/preemptirq.h                     |    8 -
 include/uapi/linux/input.h                            |    1=20
 kernel/fork.c                                         |   10 +
 kernel/trace/trace_sched_wakeup.c                     |    4=20
 kernel/trace/trace_stack.c                            |    5=20
 net/ipv4/netfilter/arp_tables.c                       |   27 ++---
 net/netfilter/ipset/ip_set_core.c                     |    3=20
 net/netfilter/nf_conntrack_proto_dccp.c               |    3=20
 net/netfilter/nf_conntrack_proto_sctp.c               |    3=20
 sound/pci/hda/patch_realtek.c                         |    5=20
 sound/usb/quirks.c                                    |    1=20
 91 files changed, 552 insertions(+), 243 deletions(-)

Akeem G Abodunrin (1):
      drm/i915/gen9: Clear residual context state on context switch

Alan Stern (2):
      HID: Fix slab-out-of-bounds read in hid_field_extract
      USB: Fix: Don't skip endpoint descriptors with maxpacket=3D0

Alex Deucher (1):
      Revert "drm/amdgpu: Set no-retry as default."

Amanieu d'Antras (8):
      arm64: Move __ARCH_WANT_SYS_CLONE3 definition to uapi headers
      arm64: Implement copy_thread_tls
      arm: Implement copy_thread_tls
      parisc: Implement copy_thread_tls
      riscv: Implement copy_thread_tls
      xtensa: Implement copy_thread_tls
      clone3: ensure copy_thread_tls is implemented
      um: Implement copy_thread_tls

Arnd Bergmann (1):
      Input: input_event - fix struct padding on sparc64

Chen-Yu Tsai (2):
      rtc: sun6i: Add support for RTC clocks on R40
      drm/sun4i: tcon: Set RGB DCLK min. divider based on hardware model

Chris Wilson (1):
      drm/i915/gt: Mark up virtual engine uabi_instance

Colin Ian King (1):
      usb: ohci-da8xx: ensure error return on variable error is set

Daniele Palmas (1):
      USB: serial: option: add ZLP support for 0x1bc7/0x9010

Dmitry Torokhov (3):
      HID: hid-input: clear unmapped usages
      Input: add safety guards to input_set_keycode()
      HID: hiddev: fix mess in hiddev_open()

Douglas Gilbert (1):
      USB-PD tcpm: bad warning+size, PPS adapters

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
      Linux 5.4.12

Guenter Roeck (1):
      usb: chipidea: host: Disable port power only if previously enabled

Hans de Goede (2):
      gpiolib: acpi: Turn dmi_system_id table into a generic quirk table
      gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism

Harry Pan (1):
      powercap: intel_rapl: add NULL pointer check to rapl_mmio_cpu_online()

Ian Abbott (1):
      staging: comedi: adv_pci1710: fix AI channels 16-31 for PCI-1713

Jarkko Sakkinen (1):
      tpm: Revert "tpm_tis: reserve chip for duration of tpm_tis_core_init"

Joel Fernandes (Google) (1):
      tracing: Change offset type to s32 in preempt/irq tracepoints

Johan Hovold (2):
      can: kvaser_usb: fix interface sanity check
      can: gs_usb: gs_usb_probe(): use descriptors of current altsetting

Kaike Wan (1):
      IB/hfi1: Adjust flow PSN with the correct resync_psn

Kailang Yang (3):
      ALSA: hda/realtek - Add new codec supported for ALCS1200A
      ALSA: hda/realtek - Set EAPD control to default for ALC222
      ALSA: hda/realtek - Add quirk for the bass speaker on Lenovo Yoga X1 =
7th gen

Kaitao Cheng (1):
      kernel/trace: Fix do not unregister tracepoints when register sched_m=
igrate_task fail

Kees Cook (1):
      pstore/ram: Regularize prz label allocation lifetime

Malcolm Priestley (5):
      staging: vt6656: set usb_set_intfdata on driver fail.
      staging: vt6656: Fix non zero logical return of, usb_control_msg
      staging: vt6656: correct return of vnt_init_registers.
      staging: vt6656: limit reg output to block size
      staging: vt6656: remove bool from vnt_radio_power_on ret

Marcel Holtmann (2):
      HID: uhid: Fix returning EPOLLOUT from uhid_char_poll
      HID: hidraw: Fix returning EPOLLOUT from hidraw_poll

Matt Roper (2):
      drm/i915: Add Wa_1408615072 and Wa_1407596294 to icl,ehl
      drm/i915: Add Wa_1407352427:icl,ehl

Michael Straube (1):
      staging: rtl8188eu: Add device code for TP-Link TL-WN727N v5.21

Navid Emamdoost (5):
      mwifiex: pcie: Fix memory leak in mwifiex_pcie_alloc_cmdrsp_buf
      rpmsg: char: release allocated memory
      scsi: bfa: release allocated memory in case of error
      rtl8xxxu: prevent leaking urb
      ath10k: fix memory leak

Oliver Hartkopp (1):
      can: can_dropped_invalid_skb(): ensure an initialized headroom in out=
going CAN sk_buffs

Patrick Steinhardt (1):
      iommu/vt-d: Fix adding non-PCI devices to Intel IOMMU

Paul Cercueil (2):
      usb: musb: Disable pullup at init
      usb: musb: dma: Correct parameter passed to IRQ handler

Peter Chen (1):
      usb: cdns3: should not use the same dev_id for shared interrupt handl=
er

Punit Agrawal (1):
      serdev: Don't claim unsupported ACPI serial devices

Russell King (1):
      i2c: fix bus recovery stop mode timing

Sean Nyekjaer (1):
      can: tcan4x5x: tcan4x5x_can_probe(): get the device out of standby be=
fore register access

Stefan Berger (2):
      tpm: Revert "tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for i=
nterrupts"
      tpm: Revert "tpm_tis_core: Turn on the TPM before probing IRQ's"

Steven Rostedt (VMware) (1):
      tracing: Have stack tracer compile when MCOUNT_INSN_SIZE is not defin=
ed

Sudip Mukherjee (2):
      tty: link tty and port before configuring it as console
      tty: always relink the port

Tadeusz Struk (1):
      tpm: Handle negative priv->response_len in tpm_common_read()

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


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4eOWcACgkQONu9yGCS
aT6dDQ/8CAoBItrTPIiTL9ti9LxkaFSETCf6eQ8TNqOhen+qU323OTwMXTLmGKQI
vbUFIKjSkJyvoIThopUjZ4GQrgg2WFdtpYIRjIVKotFFnxkikNuw7bJeiuttIPqC
OFnAC6nEqy8EPwXZlRiv0Xp9Bu4rjAhn0tnJ3ppB/XdYm85D9VpAvJ3HnkK/tDdR
bXwc38ckVQW2J9SjEv0KflM0dsZpsVzY4a5CWdDthl8J6cYu2gnMAyuH1vSB1EPr
exfLGA9XSyjty/SGpvFg3/BwukFn/Oo0I4+du7K38AOyFqFMea74WSk1r5S+uZe9
eF2USXHfl8utTeIs4msMtX5/lMnzbXFnYYWNDZy3GQK4sGlb3xHRptFlpJyEdykS
PLAA9rz4Uu8HyIDUjflBwoGSxsZk0rMjS9sEdLHNr7o7cU5hdYVuqeApfsOtlho9
qRt04N23p/6DsTKhTT/o8tT2EiTUml/IYY4g79eXiUyHVTFXqWnuqTdYCaxoGuXB
trulgDyN9Y2UqiMlNTyVhkitjmJGNq8rt2Sw5hW0g0zforv8E66hSlKCp5nNewUA
7vnBDXmAhnWxrdVdRMCvhr8aG9mclZiIantwyiRZRD+jX9mlBXfVvpurYA7iy7L9
hwFpKBptz6OU89wKZMhKNTlEBee6CWMiCg0n3g6/N7Itc9/a4vQ=
=x/6t
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
