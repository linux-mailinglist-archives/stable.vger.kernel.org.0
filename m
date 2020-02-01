Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FD414F768
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 10:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgBAJqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 04:46:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbgBAJqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Feb 2020 04:46:18 -0500
Received: from localhost (unknown [83.216.75.91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35372067C;
        Sat,  1 Feb 2020 09:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580550376;
        bh=8xBCY2Ukab3ELk1VnRlOmAoS2eA2ID/SmNi8IIBdfoQ=;
        h=Date:From:To:Cc:Subject:From;
        b=Ptx8TmpR8eCBoNq9ISQR1Hxv3Sq9t9s6agvZffwOp2rX5uoi8LdqP34wqrcU/Lo8C
         wGbXZeQX0sH6+k7H0eDOp871Vp7watdxNgIWDGds0UG8ZIMHaPIkR8uiigZQlTASpy
         FzdvXyqub0ODonU1lh5IKJlCun9tqpZDgPgi067U=
Date:   Sat, 1 Feb 2020 09:46:09 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.1
Message-ID: <20200201094609.GA2302709@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.1 kernel.

All users of the 5.5 kernel series must upgrade.

The updated 5.5.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.5.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 arch/arm64/kvm/debug.c                                 |    6=20
 arch/um/include/asm/common.lds.S                       |    2=20
 arch/um/kernel/dyn.lds.S                               |    1=20
 crypto/af_alg.c                                        |    6=20
 crypto/pcrypt.c                                        |    3=20
 drivers/android/binder.c                               |   37 ++--
 drivers/base/component.c                               |    8 -
 drivers/base/test/test_async_driver_probe.c            |    3=20
 drivers/bluetooth/btusb.c                              |    2=20
 drivers/crypto/caam/ctrl.c                             |    6=20
 drivers/crypto/chelsio/chcr_algo.c                     |   16 --
 drivers/crypto/vmx/aes_xts.c                           |    3=20
 drivers/iio/adc/stm32-dfsdm-adc.c                      |    2=20
 drivers/iio/gyro/st_gyro_core.c                        |   75 +++++++++
 drivers/misc/mei/hdcp/mei_hdcp.c                       |   33 +++-
 drivers/misc/mei/hw-me-regs.h                          |    6=20
 drivers/misc/mei/pci-me.c                              |    4=20
 drivers/net/ethernet/marvell/mvneta.c                  |    6=20
 drivers/net/ethernet/mellanox/mlxsw/minimal.c          |    2=20
 drivers/net/ethernet/socionext/netsec.c                |    4=20
 drivers/net/wireless/ath/ath9k/hif_usb.c               |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    4=20
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c    |    4=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    2=20
 drivers/net/wireless/rsi/rsi_91x_hal.c                 |   12 -
 drivers/net/wireless/rsi/rsi_91x_usb.c                 |   37 +++-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c           |    2=20
 drivers/power/supply/ingenic-battery.c                 |   15 +
 drivers/staging/most/net/net.c                         |   10 +
 drivers/staging/vt6656/device.h                        |    2=20
 drivers/staging/vt6656/int.c                           |    6=20
 drivers/staging/vt6656/main_usb.c                      |    1=20
 drivers/staging/vt6656/rxtx.c                          |   26 +--
 drivers/staging/wlan-ng/prism2mgmt.c                   |    2=20
 drivers/tty/serial/8250/8250_bcm2835aux.c              |    2=20
 drivers/tty/serial/imx.c                               |   51 ++++--
 drivers/usb/dwc3/core.c                                |    3=20
 drivers/usb/dwc3/dwc3-pci.c                            |    4=20
 drivers/usb/host/xhci-tegra.c                          |    1=20
 drivers/usb/serial/ir-usb.c                            |  136 ++++++++++++=
+----
 drivers/usb/typec/tcpm/fusb302.c                       |    2=20
 drivers/usb/typec/tcpm/wcove.c                         |    2=20
 fs/cifs/cifsglob.h                                     |    1=20
 fs/cifs/smb2misc.c                                     |    2=20
 fs/cifs/smb2ops.c                                      |    9 -
 fs/cifs/smb2transport.c                                |    2=20
 fs/cifs/transport.c                                    |    3=20
 fs/debugfs/file.c                                      |   17 +-
 include/linux/usb/irda.h                               |   13 +
 include/net/pkt_cls.h                                  |   33 ++--
 include/net/sch_generic.h                              |    3=20
 include/net/udp.h                                      |    3=20
 init/Kconfig                                           |    1=20
 kernel/gcov/Kconfig                                    |    2=20
 net/ipv4/nexthop.c                                     |    4=20
 net/rxrpc/input.c                                      |   12 -
 net/sched/cls_basic.c                                  |   11 +
 net/sched/cls_bpf.c                                    |   11 +
 net/sched/cls_flower.c                                 |   11 +
 net/sched/cls_fw.c                                     |   11 +
 net/sched/cls_matchall.c                               |   11 +
 net/sched/cls_route.c                                  |   11 +
 net/sched/cls_rsvp.h                                   |   11 +
 net/sched/cls_tcindex.c                                |   11 +
 net/sched/cls_u32.c                                    |   11 +
 net/sched/ematch.c                                     |    3=20
 net/sched/sch_api.c                                    |   47 ++++-
 68 files changed, 590 insertions(+), 217 deletions(-)

Andrew Murray (1):
      KVM: arm64: Write arch.mdcr_el2 changes since last vcpu_load on VHE

Andrey Shvetsov (1):
      staging: most: net: fix buffer overflow

Andy Shevchenko (1):
      iio: st_gyro: Correct data for LSM9DS0 gyro

Bin Liu (1):
      usb: dwc3: turn off VBUS when leaving host mode

Christophe JAILLET (1):
      mlxsw: minimal: Fix an error handling path in 'mlxsw_m_port_create()'

Colin Ian King (1):
      staging: wlan-ng: ensure error return is actually returned

Cong Wang (2):
      net_sched: fix ops->bind_class() implementations
      net_sched: walk through all child classes in tc_bind_tclass()

Daniel Axtens (1):
      crypto: vmx - reject xts inputs that are too short

David Howells (1):
      rxrpc: Fix use-after-free in rxrpc_receive_data()

Eric Biggers (1):
      crypto: chelsio - fix writing tfm flags to wrong place

Eric Dumazet (1):
      net_sched: ematch: reject invalid TCF_EM_SIMPLE

Eric Snowberg (1):
      debugfs: Return -EPERM when locked down

Greg Kroah-Hartman (1):
      Linux 5.5.1

Guenter Roeck (1):
      driver core: Fix test_async_driver_probe if NUMA is disabled

Heikki Krogerus (1):
      usb: dwc3: pci: add ID for the Intel Comet Lake -V variant

Herbert Xu (2):
      crypto: af_alg - Use bh_lock_sock in sk_destruct
      crypto: pcrypt - Fix user-after-free on module unload

Iuliana Prodan (1):
      crypto: caam - do not reset pointer size from MCFGR register

Johan Hovold (14):
      Bluetooth: btusb: fix non-atomic allocation in completion handler
      orinoco_usb: fix interface sanity check
      rsi_91x_usb: fix interface sanity check
      USB: serial: ir-usb: add missing endpoint sanity check
      USB: serial: ir-usb: fix link-speed handling
      USB: serial: ir-usb: fix IrLAP framing
      ath9k: fix storage endpoint lookup
      brcmfmac: fix interface sanity check
      rtl8xxxu: fix interface sanity check
      zd1211rw: fix storage endpoint lookup
      rsi: fix use-after-free on failed probe and unbind
      rsi: fix use-after-free on probe errors
      rsi: fix memory leak on failed URB submission
      rsi: fix non-atomic allocation in completion handler

Johannes Berg (1):
      Revert "um: Enable CONFIG_CONSTRUCTORS"

Lorenzo Bianconi (2):
      net: socionext: fix possible user-after-free in netsec_process_rx
      net: socionext: fix xdp_result initialization in netsec_process_rx

Lubomir Rintel (1):
      component: do not dereference opaque pointer in debugfs

Lukas Wunner (1):
      serial: 8250_bcm2835aux: Fix line mismatch on driver unbind

Malcolm Priestley (3):
      staging: vt6656: correct packet types for CTS protect, mode.
      staging: vt6656: use NULLFUCTION stack on mac80211
      staging: vt6656: Fix false Tx excessive retries reporting.

Martin Fuzzey (1):
      binder: fix log spam for existing debugfs file creation.

Olivier Moysan (1):
      iio: adc: stm32-dfsdm: fix single conversion

Paul Cercueil (1):
      power/supply: ingenic-battery: Don't change scale if there's only one

Paulo Alcantara (SUSE) (1):
      cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()

Peter Robinson (1):
      usb: host: xhci-tegra: set MODULE_FIRMWARE for tegra186

Ronnie Sahlberg (1):
      cifs: set correct max-buffer-size for smb2_ioctl_init()

Stephen Worley (1):
      net: include struct nhmsg size in nh nlmsg size

Sven Auhagen (1):
      mvneta driver disallow XDP program on hardware buffer management

Thomas Hebb (2):
      usb: typec: wcove: fix "op-sink-microwatt" default that was in mW
      usb: typec: fusb302: fix "op-sink-microwatt" default that was in mW

Tomas Winkler (3):
      mei: hdcp: bind only with i915 on the same PCH
      mei: me: add comet point (lake) H device ids
      mei: me: add jasper point DID

Uwe Kleine-K=F6nig (1):
      serial: imx: fix a race condition in receive path

Vincent Whitchurch (1):
      CIFS: Fix task struct use-after-free on reconnect

Willem de Bruijn (1):
      udp: segment looped gso packets correctly


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl41SOEACgkQONu9yGCS
aT5BZBAAyLdF3e0r60AK1fWHcvWnbXwZJavLYiX75R62bRFHO6DtmTjRxNm8+UXc
nsRzinfHbKbBzxK+I0iZ9RUD54U5DSZJJsWfHmVH/tTstkH1otUxippKChuz97lW
g3y+fDUKPZvM7vzFQdM3l6zAxYtlrzWA12Ge+BL/InU7RGl4nlUlA+V+/4onrskk
R65CpqvsR6k0JlCNUOT/LtAaEPY8bKhBn+QDfEFS1pM7kla8hOjb/ZOl732T/xB0
+4ckbWrljcKb9uPL+/zu+EhhuyiHbedjZMPvQF8V5KByUlg8LjHM4/Ld1qacLRjd
pXhrwu0GDMsTxOOVJoAelm3KpEN7qmDgur8knfwiY4Lf6SNWhMMrq5Spyx9d1cXm
8yxBYOelJwHj6wC4hXsmH+utYHkMMSPy6ew+xmnLRijn9ya3xImfZkUiIpmptUT9
IeZoVqaGuvGfSzERgJNNefFLqe9RALWuuzrKW6dHCLQ7RbR3bhMsPF8/wuZqWg+e
QwxPBEGDy0tAOcZVihtKyj98ivVMfnuJV6oYHcvEAg3+ziAtwALqMYLWdVKDFgG3
JABn91X5XdljUxwlvfMn4YrYWT4Dosa5dywiqNrAWQMiGxjA3bIem/Vg6CyJtMv5
N9eOJVjoDkgYDWeHgfd2fWl7FssgN5einMqwk1XPFKAelB1iPEE=
=tl6h
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
