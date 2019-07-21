Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAA26F38B
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 15:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfGUNtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 09:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfGUNtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 09:49:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8623620823;
        Sun, 21 Jul 2019 13:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563716962;
        bh=hTjHL1Qw5ZfMWSMUjH5KwOYB+oZ8IBKbi1XRHtPUECk=;
        h=Date:From:To:Cc:Subject:From;
        b=MRrj+bje78dFSewpYflHtqxfW23y1kS8qiNpxY+u3jTnZ2ctXeXothWoChHMY9mQr
         5QGOdCKM2InR+FokyLhqUs07xlMo9k5Sp48dd5Qk7FYJyGa2/d0mQg8bVLz38SIZp2
         PWcYUHTqwldmCcUC3f/tdjFFHuTOdQ7uooVW3Nw4=
Date:   Sun, 21 Jul 2019 15:49:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.2
Message-ID: <20190721134918.GA23461@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.2 kernel.

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

 Makefile                                   |    2=20
 arch/arc/kernel/unwind.c                   |    9 +-
 arch/s390/include/asm/facility.h           |   21 ++++--
 arch/s390/include/asm/sclp.h               |    1=20
 arch/s390/kernel/ipl.c                     |    7 --
 arch/x86/entry/entry_32.S                  |   24 +++++++
 arch/x86/entry/entry_64.S                  |   30 +++++++-
 arch/x86/include/asm/hw_irq.h              |    5 +
 arch/x86/kernel/apic/apic.c                |   33 ++++++---
 arch/x86/kernel/apic/io_apic.c             |   46 +++++++++++++
 arch/x86/kernel/apic/vector.c              |    4 -
 arch/x86/kernel/idt.c                      |    3=20
 arch/x86/kernel/irq.c                      |    2=20
 drivers/base/cacheinfo.c                   |    3=20
 drivers/base/firmware_loader/fallback.c    |    2=20
 drivers/crypto/nx/nx-842-powernv.c         |    8 +-
 drivers/crypto/talitos.c                   |   99 ++++++++++++------------=
-----
 drivers/crypto/talitos.h                   |   30 ++++++++
 drivers/input/mouse/synaptics.c            |    1=20
 drivers/net/ethernet/intel/e1000e/netdev.c |   21 +++---
 drivers/s390/char/sclp_early.c             |    1=20
 drivers/s390/cio/qdio_setup.c              |    2=20
 drivers/s390/cio/qdio_thinint.c            |    5 -
 include/linux/cpuhotplug.h                 |    1=20
 include/uapi/linux/nilfs2_ondisk.h         |   24 +++----
 kernel/irq/autoprobe.c                     |    6 -
 kernel/irq/chip.c                          |    6 +
 kernel/irq/cpuhotplug.c                    |    2=20
 kernel/irq/internals.h                     |    5 +
 kernel/irq/manage.c                        |   90 ++++++++++++++++++++----=
--
 30 files changed, 341 insertions(+), 152 deletions(-)

Arnd Bergmann (1):
      ARC: hide unused function unw_hdr_alloc

Christophe Leroy (2):
      crypto: talitos - move struct talitos_edesc into talitos.h
      crypto: talitos - fix hash on SEC1.

Cole Rogers (1):
      Input: synaptics - enable SMBUS on T480 thinkpad trackpad

Greg Kroah-Hartman (1):
      Linux 5.2.2

Haren Myneni (1):
      crypto/NX: Set receive window credits to max number of CRBs in RxFIFO

Heiko Carstens (1):
      s390: fix stfle zero padding

James Morse (1):
      drivers: base: cacheinfo: Ensure cpu hotplug work is done before Inte=
l RDT

Jiri Slaby (1):
      x86/entry/32: Fix ENDPROC of common_spurious

Julian Wiedmann (2):
      s390/qdio: (re-)initialize tiqdio list entries
      s390/qdio: don't touch the dsci in tiqdio_add_input_queues()

Konstantin Khlebnikov (2):
      Revert "e1000e: fix cyclic resets at link up with active tx"
      e1000e: start network tx queue only when link is up

Masahiro Yamada (1):
      nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi hea=
der

Philipp Rudo (1):
      s390/ipl: Fix detection of has_secure attribute

Sven Van Asbroeck (1):
      firmware: improve LSM/IMA security behaviour

Thomas Gleixner (6):
      genirq: Delay deactivation in free_irq()
      genirq: Fix misleading synchronize_irq() documentation
      genirq: Add optional hardware synchronization for shutdown
      x86/ioapic: Implement irq_get_irqchip_state() callback
      x86/irq: Handle spurious interrupt after shutdown gracefully
      x86/irq: Seperate unused system vectors from spurious entry again


--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl00bV4ACgkQONu9yGCS
aT6p+xAAqPaKx+mD7m5+o4p6PkZu8jE+jUM0RPhQIlBMSM3qcnUSSPOCIR++rjTp
8dc0YeYN3+OcRALX5chyJYovBVAxId88paGlOPdm33XlPAU2HsiZnDfN0zgOLlxt
hbxPl+FoTX9yrPPx4WKTSmuHm+WvA6kgnJLRS9xyJYoIDIE1nPSHS0jBqJvZlS64
hheuxHcvdIJkIzvL2C8riWFtVxtLV8pPEkD8jKvCc9ydtTXcxGGD25x+7mx03kCN
Ph/JsYKKo5WOUKBSYP6kMDm5Lka3TREhQdPj4bBJMAw6c16F/rhU+PF+oNeDAZ2m
8gVB81ZzMOokff2NX3cFSOtXFnDCrxngVt063dIdKgTCJE5nCPny+F+CylxpSzfX
ZwB1ZPrcyMhhYfVUb8hL3G5VB//a9mRh9xFVpV3SMDWKVhji+GZfuVM+42o77zJH
D/nYoupWwG285br5izYTWw9IWPMIy9m4igGs7ssJE2PQMckL2WBhEgCui9oDQKSX
02ETdrJOSRpwYbULkW41yrxgymVBF4XXQFqGPOruHiBjX/rwcJY8JMTtMOAwGJtT
W3c/1kSatIwBFBYssQYOIwx8NKGn9dtI3s0NBu7Joa78v5tIWGyWG07zLFLdWK5m
bpL6Xt8spzvpRFCdxn9LV2wfopAllVXtwjasvQUn2hHoRO44Qo8=
=uG7a
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
