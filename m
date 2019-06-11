Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE7D63CD0E
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 15:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388956AbfFKNfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 09:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387683AbfFKNfD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 09:35:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B18208E3;
        Tue, 11 Jun 2019 13:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560260102;
        bh=Yu84dYzlbCcXLRtIvLaD9dPaOmPRya2y37aSN9jlfCw=;
        h=Date:From:To:Cc:Subject:From;
        b=OXzKu4wiCTlEsfM5e48UCoY/UWaRhbn0hATrKB7xZoOz+iKmHAUwgt4o7B1J+6teR
         mXSPs+kINQccW7IdeSEwzxvTiTmdXocp+7M26XDZFzrRVligROopwe7QBFJV6OZ4Xu
         DQCS4t/YKx1AkXjyqxjLagWfdvhVTB1+XT00a3vA=
Date:   Tue, 11 Jun 2019 15:34:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.125
Message-ID: <20190611133459.GA30054@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.125 kernel.

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

 Makefile                                        |    2=20
 arch/mips/ath79/setup.c                         |    6=20
 arch/mips/mm/mmap.c                             |    5=20
 arch/mips/pistachio/Platform                    |    1=20
 arch/powerpc/kernel/nvram_64.c                  |    2=20
 arch/x86/power/cpu.c                            |   10=20
 arch/x86/power/hibernate_64.c                   |   33 ++
 drivers/acpi/apei/erst.c                        |    1=20
 drivers/firmware/efi/efi-pstore.c               |    4=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c         |   19 -
 drivers/gpu/drm/gma500/cdv_intel_lvds.c         |    3=20
 drivers/gpu/drm/gma500/intel_bios.c             |    3=20
 drivers/gpu/drm/gma500/psb_drv.h                |    1=20
 drivers/gpu/drm/i915/intel_fbc.c                |    4=20
 drivers/gpu/drm/nouveau/Kconfig                 |   13=20
 drivers/gpu/drm/nouveau/nouveau_drm.c           |    7=20
 drivers/gpu/drm/radeon/radeon_display.c         |    4=20
 drivers/i2c/busses/i2c-xiic.c                   |    5=20
 drivers/irqchip/irq-ath79-misc.c                |   11=20
 drivers/misc/genwqe/card_dev.c                  |    2=20
 drivers/misc/genwqe/card_utils.c                |    4=20
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |    4=20
 drivers/net/ethernet/mellanox/mlx4/port.c       |    5=20
 drivers/net/phy/sfp.c                           |   24 +
 drivers/net/usb/qmi_wwan.c                      |   39 ++
 drivers/parisc/ccio-dma.c                       |    4=20
 drivers/parisc/sba_iommu.c                      |    3=20
 drivers/tty/serial/serial_core.c                |   24 -
 drivers/xen/xenbus/xenbus_dev_frontend.c        |    4=20
 fs/fuse/file.c                                  |    6=20
 fs/open.c                                       |   18 +
 fs/pstore/platform.c                            |   76 ++---
 fs/pstore/ram.c                                 |   37 +-
 fs/read_write.c                                 |    5=20
 include/linux/cpu.h                             |    4=20
 include/linux/fs.h                              |    4=20
 include/linux/pstore.h                          |    7=20
 include/linux/rcupdate.h                        |    6=20
 include/net/arp.h                               |    8=20
 include/net/ip6_fib.h                           |    3=20
 include/uapi/drm/i915_drm.h                     |    2=20
 include/uapi/linux/fuse.h                       |    2=20
 kernel/cpu.c                                    |    4=20
 kernel/power/hibernate.c                        |    9=20
 lib/test_firmware.c                             |   14=20
 net/core/ethtool.c                              |   17 -
 net/core/fib_rules.c                            |    7=20
 net/core/neighbour.c                            |    9=20
 net/core/pktgen.c                               |   11=20
 net/ipv6/raw.c                                  |   25 +
 net/rds/ib_rdma.c                               |   10=20
 net/sctp/sm_make_chunk.c                        |   13=20
 net/sctp/sm_sideeffect.c                        |    5=20
 scripts/coccinelle/api/stream_open.cocci        |  363 +++++++++++++++++++=
+++++
 54 files changed, 737 insertions(+), 175 deletions(-)

Alex Deucher (1):
      drm/amdgpu/psp: move psp version specific function pointers to early_=
init

Chris Wilson (1):
      drm/i915: Fix I915_EXEC_RING_MASK

Christian K=F6nig (1):
      drm/radeon: prefer lower reference dividers

Dan Carpenter (2):
      genwqe: Prevent an integer overflow in the ioctl
      test_firmware: Use correct snprintf() limit

Daniel Drake (1):
      drm/i915/fbc: disable framebuffer compression on GeminiLake

Dave Airlie (1):
      drm/nouveau: add kconfig option to turn off nouveau legacy contexts. =
(v3)

David Ahern (2):
      neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit
      ipv4: Define __ipv4_neigh_lookup_noref when CONFIG_INET is disabled

Erez Alfasi (1):
      net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query

Greg Kroah-Hartman (3):
      Revert "fib_rules: fix error in backport of e9919a24d302 ("fib_rules:=
 return 0...")"
      Revert "MIPS: perf: ath79: Fix perfcount IRQ assignment"
      Linux 4.14.125

Hangbin Liu (1):
      Revert "fib_rules: return 0 directly if an exactly same rule exists w=
hen NLM_F_EXCL not supplied"

Jiri Kosina (1):
      x86/power: Fix 'nosmt' vs hibernation triple fault during resume

Jiri Slaby (1):
      TTY: serial_core, add ->install

John David Anglin (1):
      parisc: Use implicit space register selection for loading the coheren=
ce index of I/O pdirs

Kees Cook (3):
      pstore: Remove needless lock during console writes
      pstore: Convert buf_lock to semaphore
      pstore/ram: Run without kernel crash dump region

Kirill Smelkov (2):
      fs: stream_open - opener for stream-like files so that read and write=
 can run simultaneously without deadlock
      fuse: Add FOPEN_STREAM to use stream_open()

Kristian Evensen (1):
      qmi_wwan: Add quirk for Quectel dynamic config

Linus Torvalds (1):
      rcu: locking and unlocking need to always be at least barriers

Miklos Szeredi (1):
      fuse: fallocate: fix return with locked inode

Neil Horman (1):
      Fix memory leak in sctp_process_init

Olivier Matz (2):
      ipv6: fix EFAULT on sendto with icmpv6 and hdrincl
      ipv6: use READ_ONCE() for inet->hdrincl as in ipv4

Paolo Abeni (1):
      pktgen: do not sleep with the thread lock held.

Patrik Jakobsson (1):
      drm/gma500/cdv: Check vbt config bits when detecting lvds panels

Paul Burton (2):
      MIPS: Bounds check virt_addr_valid
      MIPS: pistachio: Build uImage.gz by default

Robert Hancock (1):
      i2c: xiic: Add max_read_len quirk

Russell King (1):
      net: sfp: read eeprom in maximum 16 byte increments

Vivien Didelot (1):
      ethtool: fix potential userspace buffer overflow

Xin Long (1):
      ipv6: fix the check before getting the cookie in rt6_get_cookie

Yunsheng Lin (1):
      ethtool: check the return value of get_regs_len

Zhu Yanjun (1):
      net: rds: fix memory leak in rds_ib_flush_mr_pool


--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlz/rgMACgkQONu9yGCS
aT6RrxAAgNeslLDky7IFZ7hpTn3nPfPTMQkDX1prr04lqYOJ3HM0U7Ievpctj+O1
fn3QA1QK+Vg4ICh9IPME9W2PVUaeGhOI13ipCN0yvEAZk5Lz27wmCqys/Qfy/iME
yjseuQ2IC05+dSVjg3wO4vdZ9YhKMh1FqfzTBzv/UPgiIFhcKTRtHUtYRrZBQdYI
Jr4gxsFjb6/sDaQef6mJhvxOIFMVkKSknjrHkOT6ZS7HN1hRti7dzwYEDxtYFIVN
9Dm1R+739GuLvRR+zCYYhZwE0oA4RzZ0LxM2KCCryQGUtT0GF0vjiZlkIipS/2wQ
CX4S0PbAiSYS5wmM5pwLofgEaLiKfsy1u0OmhmCFLQsd3b5OHbSmMkM6tXLggJV2
xhYs8/J5OcDNzADSu/tkMWgQ2ZYaY9L7lpKhuqcPhXTGhBYkOZqCekmCweUWnikK
8nBwplWksiu84+FZn0JvN19fBlXF+DVvQo8PUXqFVqFU1tGKYYed5VSn/jFAH8YR
/ycyq1Tlk7Ta3/wLvwKbpoQGHT1iE1h77iCTbZ+6quSlHhwXm+V9I8gPsWS9hG8Y
12So/Z5PKPVpmsUXIrfBzeRr/N2HwNzFwzixQCvNysR7N9HvkjNXNJoDSg1dPAmk
Qg4TOkUhuJGc14fiObYX/CqJMhl8lsszJZNC2fQcwcrhcf8UlhI=
=femd
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
