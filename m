Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D47FCF2CF
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 08:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbfJHGge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 02:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730059AbfJHGge (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 02:36:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41D2B206BB;
        Tue,  8 Oct 2019 06:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570516592;
        bh=ZNmcO36oRNCAwhEwpe/Uvkf1dF7wpzUpVgMeglXZfSU=;
        h=Date:From:To:Cc:Subject:From;
        b=1q3EX3RRzgIYiDf/c9bCIh1PNbAj58OeK+tPFiY06MsJzwgZAc0WLh8y4pV7vJL7N
         eDtrA8cK+6l383zSpyNI2oE/rzgIWlSsCedlNKAZdSFbxmxycReDTwNe6Kbjd7i9em
         Dvd2LpDGbBxa8+bp1VS0Vs7cFInoNkL/sMggu26Q=
Date:   Tue, 8 Oct 2019 08:36:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.196
Message-ID: <20191008063630.GA2466959@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.196 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                       |    2 -
 arch/arm/mm/fault.c                            |    4 +-
 arch/arm/mm/fault.h                            |    1=20
 arch/arm/mm/mmu.c                              |   16 ++++++++
 arch/arm64/include/asm/cmpxchg.h               |    6 +--
 arch/mips/mm/tlbex.c                           |    2 -
 arch/powerpc/include/asm/futex.h               |    3 -
 arch/powerpc/kernel/exceptions-64s.S           |    4 ++
 arch/powerpc/kernel/rtas.c                     |   11 ++++-
 arch/powerpc/platforms/pseries/mobility.c      |    9 ++++
 arch/powerpc/platforms/pseries/setup.c         |    3 +
 arch/s390/hypfs/inode.c                        |    9 ++--
 drivers/android/binder.c                       |   26 ++++++++++++-
 drivers/char/ipmi/ipmi_si_intf.c               |   24 +++++++++---
 drivers/clk/at91/clk-main.c                    |   10 +++--
 drivers/clk/clk-qoriq.c                        |    2 -
 drivers/clk/sirf/clk-common.c                  |   12 ++++--
 drivers/gpu/drm/amd/amdgpu/si.c                |    6 +--
 drivers/gpu/drm/bridge/tc358767.c              |    2 -
 drivers/gpu/drm/radeon/radeon_connectors.c     |    2 -
 drivers/gpu/drm/radeon/radeon_drv.c            |    8 ++++
 drivers/hid/hid-apple.c                        |   49 ++++++++++++++------=
-----
 drivers/mfd/intel-lpss-pci.c                   |    2 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c |    9 +++-
 drivers/net/ethernet/qlogic/qla3xxx.c          |    1=20
 drivers/net/usb/hso.c                          |   12 ++++--
 drivers/net/usb/qmi_wwan.c                     |    1=20
 drivers/net/xen-netfront.c                     |   17 ++++----
 drivers/pci/host/pci-tegra.c                   |   22 +++++++----
 drivers/pinctrl/tegra/pinctrl-tegra.c          |    4 +-
 drivers/scsi/scsi_logging.c                    |   48 +-------------------=
----
 drivers/vfio/pci/vfio_pci.c                    |   17 ++++++--
 drivers/video/fbdev/ssd1307fb.c                |    2 -
 fs/fat/dir.c                                   |   13 +++++-
 fs/fat/fatent.c                                |    3 +
 fs/ocfs2/dlm/dlmunlock.c                       |   23 +++++++++--
 include/scsi/scsi_dbg.h                        |    2 -
 lib/Kconfig.debug                              |    2 -
 net/core/sock.c                                |   11 ++++-
 net/ipv4/route.c                               |    5 +-
 net/ipv6/addrconf.c                            |   17 ++++++--
 net/ipv6/ip6_input.c                           |   10 +++++
 net/nfc/llcp_sock.c                            |    7 +++
 net/nfc/netlink.c                              |    6 ++-
 net/rds/ib.c                                   |    6 +--
 net/sched/sch_cbq.c                            |   27 +++++++++++--
 net/sched/sch_dsmark.c                         |    2 +
 security/smack/smack_access.c                  |    4 +-
 security/smack/smack_lsm.c                     |    7 ++-
 49 files changed, 327 insertions(+), 164 deletions(-)

Andrey Konovalov (1):
      NFC: fix attrs checks in netlink interface

Andrey Smirnov (1):
      drm/bridge: tc358767: Increase AUX transfer length limit

Arnd Bergmann (1):
      arm64: fix unreachable code issue with cmpxchg

Bart Van Assche (1):
      scsi: core: Reduce memory required for SCSI logging

Changwei Ge (1):
      ocfs2: wait for recovering done after direct unlock request

Christophe Leroy (1):
      powerpc/futex: Fix warning: 'oldval' may be used uninitialized in thi=
s function

Corey Minyard (1):
      ipmi_si: Only schedule continuously in the thread in maintenance mode

David Ahern (1):
      ipv6: Handle missing host route in __ipv6_ifa_notify

David Howells (1):
      hypfs: Fix error number left in struct pointer member

Dongli Zhang (1):
      xen-netfront: do not use ~0U as error return value for xennet_fill_fr=
ags()

Dotan Barak (1):
      net/rds: Fix error handling in rds_ib_add_one()

Eric Biggers (1):
      smack: use GFP_NOFS while holding inode_smack::smk_lock

Eric Dumazet (4):
      ipv6: drop incoming packets having a v4mapped source address
      nfc: fix memory leak in llcp_sock_bind()
      sch_dsmark: fix potential NULL deref in dsmark_init()
      sch_cbq: validate TCA_CBQ_WRROPT to avoid crash

Eugen Hristev (1):
      clk: at91: select parent if main oscillator or bypass is enabled

Greg Kroah-Hartman (1):
      Linux 4.9.196

Jann Horn (1):
      Smack: Don't ignore other bprm->unsafe flags if LSM_UNSAFE_PTRACE is =
set

Jean Delvare (1):
      drm/amdgpu/si: fix ASIC tests

Jia-Ju Bai (2):
      gpu: drm: radeon: Fix a possible null-pointer dereference in radeon_c=
onnector_set_property()
      security: smack: Fix possible null-pointer dereferences in smack_sock=
et_sock_rcv_skb()

Joao Moreno (1):
      HID: apple: Fix stuck function keys when using FN

Johan Hovold (1):
      hso: fix NULL-deref on tty open

Kai-Heng Feng (1):
      mfd: intel-lpss: Remove D3cold delay

KyleMahlkuch (1):
      drm/radeon: Fix EEH during kexec

Marko Kohtala (1):
      video: ssd1307fb: Start page range at page_offset

Martijn Coenen (2):
      ANDROID: binder: remove waitqueue when thread exits.
      ANDROID: binder: synchronize_rcu() when using POLLFREE.

Martin KaFai Lau (1):
      net: Unpublish sk from sk_reuseport_cb before call_rcu

Mike Rapoport (1):
      ARM: 8903/1: ensure that usable memory in bank 0 starts from a PMD-al=
igned address

Nathan Chancellor (1):
      MIPS: tlbex: Explicitly cast _PAGE_NO_EXEC to a boolean

Nathan Huckleberry (1):
      clk: qoriq: Fix -Wunused-const-variable

Nathan Lynch (3):
      powerpc/rtas: use device model APIs and serialization during LPM
      powerpc/pseries/mobility: use cond_resched when updating device tree
      powerpc/pseries: correctly track irq state in default idle

Navid Emamdoost (1):
      net: qlogic: Fix memory leak in ql_alloc_large_buffers

Nicholas Piggin (1):
      powerpc/64s/exception: machine check use correct cfar for late handler

Nicolas Boichat (1):
      kmemleak: increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE default to 16K

Nishka Dasgupta (1):
      PCI: tegra: Fix OF node reference leak

OGAWA Hirofumi (1):
      fat: work around race with userspace's read via blockdev while mounti=
ng

Paolo Abeni (1):
      net: ipv4: avoid mixed n_redirects and rate_tokens usage

Reinhard Speyerer (1):
      qmi_wwan: add support for Cinterion CLS8 devices

Sowjanya Komatineni (1):
      pinctrl: tegra: Fix write barrier placement in pmx_writel

Stephen Boyd (1):
      clk: sirf: Don't reference clk_init_data after registration

Vishal Kulkarni (1):
      cxgb4:Fix out-of-bounds MSI-X info array access

Will Deacon (1):
      ARM: 8898/1: mm: Don't treat faults reported from cache maintenance a=
s writes

hexin (1):
      vfio_pci: Restore original state on release


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2cLmsACgkQONu9yGCS
aT5mBw//bLKFcCG2SvfafwFCrYNtGLQwzU9YzFpQMMhrD1QEr/j3pMU5vcc3ddgj
T/8uvsr1KktBFHNolaOYmlwIAF0up23W1egm1ibYhwh+1oMKRTU4HobcdG4xq6E5
0LHB1xQjfpSR+zMaNSClYNOOp8uS7P6iLzCvbgPdF5kvQvs6FO5AY/PjpNfc6Lpv
CdX8n5MaLEBOxBVM7WDma32/q79OnLK/YzRpqSNi/OozWkxDJs741hR39rBb31Iw
9qBbMx5EYm6LlJRiy6OmpTrklneH8elzYPPU+Yk3jm165jeH81yxl4gfOLa5tdux
Q3xC/M7wzYktwpHW0bE/3yDtnHGRxDFt1msmw0NC4yfkqnigLC31YVcUOfhEe8KO
whDS6PMXO1cE3D5LJq2sUtfp9EViTEwo2EQzP7Wq05d4V2tklSUORw3ZGaMO8hJZ
dYnsO1gUeApccaidPAGahaghoh2w4OfXwmq8PHvs4NzHMtuFJHQ7jNjRJlteo22q
SV8iL13ksS3e21nA98ymxSSErWNsKwI0h2UDxqXmX/ddlUkFb0h83BbJMJM/oU7E
RPnPMNQnn8kHD6i8Mcx0D21e9FVIughU0h92hlm+3xpC6G4JJKM3dwXeTq6Hx9RO
NTa4eX3O80Cnyi8UPHf5txb3ht7p0eEZDdS3qkPe7WaFywFGViE=
=gSoO
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
