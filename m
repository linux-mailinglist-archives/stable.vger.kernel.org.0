Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93D367E21
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 09:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfGNHTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 03:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfGNHTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jul 2019 03:19:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBBE3214AE;
        Sun, 14 Jul 2019 07:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563088759;
        bh=9PSVY8lRS3wZGaXVlKDYjVpboF3tPM2zLNV54uuweEs=;
        h=Date:From:To:Cc:Subject:From;
        b=f/Zuu7dDuOT3JtyWcNNlkOQVwY2mOFpQZqkJOz5v2VyRcQF/rRye9DI2HSxbYLaku
         Xgo84KNc1LfUBv/25CHOws4fWSzq9KadwFrqJ449W394CAwYSseLygpkeR5IUKQu2c
         8H/erJvcJKLMQj9OcLL1hn1w0KCpQ4ZcYqkNVNcM=
Date:   Sun, 14 Jul 2019 09:19:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.1
Message-ID: <20190714071916.GA29794@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.1 kernel.

All users of the 5.2 kernel series must upgrade.

The updated 5.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/index.rst                        |    1=
=20
 Documentation/admin-guide/hw-vuln/spectre.rst                      |  697 =
++++++++++
 Documentation/admin-guide/kernel-parameters.txt                    |    6=
=20
 Documentation/userspace-api/spec_ctrl.rst                          |    2=
=20
 Makefile                                                           |    2=
=20
 arch/x86/kernel/ptrace.c                                           |    5=
=20
 arch/x86/kernel/tls.c                                              |    9=
=20
 arch/x86/kernel/vmlinux.lds.S                                      |    6=
=20
 block/bfq-iosched.c                                                |    1=
=20
 block/bio.c                                                        |   10=
=20
 crypto/lrw.c                                                       |    2=
=20
 drivers/android/binder.c                                           |  157 =
+-
 drivers/android/binder_alloc.c                                     |   44=
=20
 drivers/android/binder_alloc.h                                     |   22=
=20
 drivers/char/tpm/tpm-chip.c                                        |    6=
=20
 drivers/char/tpm/tpm1-cmd.c                                        |    7=
=20
 drivers/char/tpm/tpm2-cmd.c                                        |    7=
=20
 drivers/crypto/talitos.c                                           |   16=
=20
 drivers/hid/hid-ids.h                                              |    1=
=20
 drivers/hid/hid-quirks.c                                           |    1=
=20
 drivers/hwtracing/coresight/coresight-etb10.c                      |    6=
=20
 drivers/hwtracing/coresight/coresight-funnel.c                     |    1=
=20
 drivers/hwtracing/coresight/coresight-tmc-etf.c                    |    6=
=20
 drivers/hwtracing/coresight/coresight-tmc-etr.c                    |   13=
=20
 drivers/iio/adc/stm32-adc-core.c                                   |   21=
=20
 drivers/media/dvb-frontends/stv0297.c                              |    2=
=20
 drivers/misc/lkdtm/Makefile                                        |    3=
=20
 drivers/misc/vmw_vmci/vmci_context.c                               |   80 -
 drivers/misc/vmw_vmci/vmci_handle_array.c                          |   38=
=20
 drivers/misc/vmw_vmci/vmci_handle_array.h                          |   29=
=20
 drivers/net/wireless/ath/carl9170/usb.c                            |   39=
=20
 drivers/net/wireless/intersil/p54/p54usb.c                         |   43=
=20
 drivers/net/wireless/intersil/p54/txrx.c                           |    5=
=20
 drivers/net/wireless/marvell/mwifiex/fw.h                          |   12=
=20
 drivers/net/wireless/marvell/mwifiex/scan.c                        |   18=
=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c                   |    4=
=20
 drivers/net/wireless/marvell/mwifiex/wmm.c                         |    2=
=20
 drivers/staging/comedi/drivers/amplc_pci230.c                      |    3=
=20
 drivers/staging/comedi/drivers/dt282x.c                            |    3=
=20
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c                            |    1=
=20
 drivers/staging/mt7621-pci/pci-mt7621.c                            |    2=
=20
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c                      |  157 =
+-
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c      |   43=
=20
 drivers/staging/vc04_services/bcm2835-camera/controls.c            |   19=
=20
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c          |   32=
=20
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h          |    3=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    2=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c      |   21=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c     |   31=
=20
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_util.c     |    6=
=20
 drivers/staging/wilc1000/wilc_netdev.c                             |   12=
=20
 drivers/tty/serial/8250/8250_port.c                                |    3=
=20
 drivers/usb/dwc2/core.c                                            |    2=
=20
 drivers/usb/gadget/function/f_fs.c                                 |    3=
=20
 drivers/usb/gadget/function/u_ether.c                              |    6=
=20
 drivers/usb/renesas_usbhs/fifo.c                                   |   34=
=20
 drivers/usb/serial/ftdi_sio.c                                      |    1=
=20
 drivers/usb/serial/ftdi_sio_ids.h                                  |    6=
=20
 drivers/usb/serial/option.c                                        |    1=
=20
 drivers/usb/typec/tps6598x.c                                       |    6=
=20
 fs/crypto/policy.c                                                 |    2=
=20
 fs/iomap.c                                                         |    2=
=20
 fs/udf/inode.c                                                     |   93 -
 fs/xfs/xfs_aops.c                                                  |    2=
=20
 include/linux/bio.h                                                |   18=
=20
 include/linux/vmw_vmci_defs.h                                      |   11=
=20
 include/uapi/linux/usb/audio.h                                     |   37=
=20
 sound/pci/hda/patch_realtek.c                                      |    2=
=20
 sound/usb/mixer.c                                                  |   16=
=20
 tools/perf/Documentation/intel-pt.txt                              |   10=
=20
 tools/perf/util/auxtrace.c                                         |    3=
=20
 tools/perf/util/header.c                                           |    1=
=20
 tools/perf/util/intel-pt.c                                         |    3=
=20
 tools/perf/util/pmu.c                                              |   28=
=20
 tools/perf/util/thread-stack.c                                     |   30=
=20
 75 files changed, 1481 insertions(+), 498 deletions(-)

Adrian Hunter (4):
      perf intel-pt: Fix itrace defaults for perf script
      perf auxtrace: Fix itrace defaults for perf script
      perf intel-pt: Fix itrace defaults for perf script intel-pt documenta=
tion
      perf thread-stack: Fix thread stack return from kernel for kernel-onl=
y case

Ajay Singh (1):
      staging: wilc1000: fix error path cleanup in wilc_wlan_initialize()

Alan Stern (1):
      p54usb: Fix race between disconnect and firmware loading

Andreas Fritiofson (1):
      USB: serial: ftdi_sio: add ID for isodebug v1

Andy Lutomirski (1):
      Documentation/admin: Remove the vsyscall=3Dnative documentation

Arnd Bergmann (1):
      staging: rtl8712: reduce stack usage, again

Brian Norris (1):
      mwifiex: Don't abort on small, spec-compliant vendor IEs

Christian Lamparter (2):
      p54: fix crash during initialization
      carl9170: fix misuse of device driver API

Christophe Leroy (1):
      crypto: talitos - rename alternative AEAD algos.

Colin Ian King (1):
      staging: fsl-dpaa2/ethsw: fix memory leak of switchdev_work

Dan Carpenter (1):
      coresight: Potential uninitialized variable in probe()

Dave Stevenson (4):
      staging: bcm2835-camera: Replace spinlock protecting context_map with=
 mutex
      staging: bcm2835-camera: Ensure all buffers are returned on disable
      staging: bcm2835-camera: Remove check of the number of buffers suppli=
ed
      staging: bcm2835-camera: Handle empty EOS buffers whilst streaming

Dianzhang Chen (2):
      x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
      x86/tls: Fix possible spectre-v1 in do_get_thread_area()

Douglas Anderson (1):
      block, bfq: NULL out the bic when it's no longer valid

Eric Biggers (1):
      crypto: lrw - use correct alignmask

Fabrice Gasnier (1):
      iio: adc: stm32-adc: add missing vdda-supply

Fei Yang (1):
      usb: gadget: f_fs: data_len used before properly set

Greg Kroah-Hartman (1):
      Linux 5.2.1

Hongjie Fang (1):
      fscrypt: don't set policy for a dead directory

Ian Abbott (2):
      staging: comedi: dt282x: fix a null pointer deref on interrupt
      staging: comedi: amplc_pci230: fix null pointer deref on interrupt

John Garry (1):
      perf pmu: Fix uncore PMU alias list for ARM64

J=F6rgen Storvist (1):
      USB: serial: option: add support for GosunCn ME3630 RNDIS mode

Kailang Yang (1):
      ALSA: hda/realtek - Headphone Mic can't record after S3

Kees Cook (1):
      tpm: Actually fail on TPM errors during "get random"

Kiruthika Varadarajan (1):
      usb: gadget: ether: Fix race between gether_disconnect and rx_submit

Martin Blumenstingl (1):
      usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()

Mauro Carvalho Chehab (1):
      media: stv0297: fix frequency range limit

Ming Lei (1):
      block: fix .bi_size overflow

Nick Desaulniers (1):
      lkdtm: support llvm-objcopy

Nicolas Saenz Julienne (3):
      staging: vchiq_2835_arm: revert "quit using custom down_interruptible=
()"
      staging: vchiq: make wait events interruptible
      staging: vchiq: revert "switch to wait_for_completion_killable"

Nikolaus Voss (2):
      drivers/usb/typec/tps6598x.c: fix portinfo width
      drivers/usb/typec/tps6598x.c: fix 4CC cmd write

Oliver Barta (1):
      Revert "serial: 8250: Don't service RX FIFO if interrupts are disable=
d"

Ross Zwisler (1):
      Revert "x86/build: Move _etext to actual end of .text"

Sebastian Parschauer (1):
      HID: Add another Primax PIXART OEM mouse quirk

Sergio Paracuellos (1):
      staging: mt7621-pci: fix PCIE_FTS_NUM_LO macro

Song Liu (1):
      perf header: Assign proper ff->ph in perf_event__synthesize_features()

Stefan Wahren (1):
      staging: bcm2835-camera: Restore return behavior of ctrl_set_bitrate()

Steven J. Magnani (1):
      udf: Fix incorrect final NOT_ALLOCATED (hole) extent length

Suzuki K Poulose (4):
      coresight: etb10: Do not call smp_processor_id from preemptible
      coresight: tmc-etr: Do not call smp_processor_id() from preemptible
      coresight: tmc-etr: alloc_perf_buf: Do not call smp_processor_id from=
 preemptible
      coresight: tmc-etf: Do not call smp_processor_id from preemptible

Takashi Iwai (1):
      ALSA: usb-audio: Fix parse of UAC2 Extension Units

Tim Chen (1):
      Documentation: Add section about CPU vulnerabilities for Spectre

Todd Kjos (2):
      binder: fix memory leak in error path
      binder: return errors from buffer copy functions

Vadim Sukhomlinov (1):
      tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM operations

Vishnu DASA (1):
      VMCI: Fix integer overflow in VMCI handle arrays

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: add a workaround for a race condition of workqueue


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0q13QACgkQONu9yGCS
aT7sKg//XJ7C4Ewu/Ja+ip/zQwkx1SWPWUiqP5NaiIcW+QSyGUZpORMAh3/6vXqZ
UD9hn6x/O1cQWvMpxCZ/qjUNpwH2qfk2amwtUYLqHOayiDz4qae5h5eToe3erL38
Uj/zFQNCkn5c5X6MPtqvlszW65CbZXM3QkdrGZ5KPuCuuxLuAtGxwmTlXmbMwhO4
WDVljCtXp+1P1j1/obtZ4I9tyK1CSvovfPW9uEHMWkTRRomZM/nwvBrtRaRzNR+C
NTBWBZ+tGWTiJDhTY0Yw3seblR+rqtMF2cUh5CNN2RwBb6NyDvWb2dskxisMyJF1
UaYpAqSni2+Pvdg0ihck1WetHe+tAxSmJ4aqLxFCzOCMoMt0f8hgVBig2GvuoPcK
xMop+Xy3DI6TdsrwZ3E6PlCsWfFjTKqVfYWZVTKqSVr0d+5i9cqbGuKnFyFvMoDm
SiY5JszdIYgE1PCb2IlC5dtLvTDYy95fHtRrX9sQLSVLLQHxaUlZeTEAihhrwkjD
di4Lv6yeDRp53uHm0LiPTjUKFHE1vUGUS6K+y9GTidrxyJDiQhZivE+hgHlps2he
VxXUCzACKtQFtPxfYuMyWMovq7QZtOz9RC/h8JDgRCY40IDyLj8iPPNsGrtMDMuZ
/pU+H/Pf/2QEIMJCc9aY+KeHyrrMgWSnZFfx7VAJzxre+OAnc2A=
=Ilpd
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
