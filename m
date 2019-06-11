Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59773CD0A
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 15:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388505AbfFKNeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 09:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387683AbfFKNeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 09:34:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 881D02063F;
        Tue, 11 Jun 2019 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560260083;
        bh=ZNnmr7r5mKg1hE8g0Oi0rYvf57W9c21iWbVZm+SuoPo=;
        h=Date:From:To:Cc:Subject:From;
        b=fC2GaAfp9cHoiTfBd5wNwrC6NiEv4mGhnMjUeNDuwPogGXp9iW8zKDrYwNGeelfsG
         1lNes5O2Wg2twfcIWs29okTa51ijIEkiyoUEy/7oo0GabiuSWSX6KafdotgymZPwKZ
         rywuzhGWdORo40TQziCozHUb+pcmJHI9BFHPJDOA=
Date:   Tue, 11 Jun 2019 15:34:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.50
Message-ID: <20190611133440.GA26537@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.50 kernel.

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

 Makefile                                        |    2=20
 arch/mips/ath79/setup.c                         |    6 +
 arch/mips/mm/mmap.c                             |    5 +
 arch/mips/pistachio/Platform                    |    1=20
 arch/powerpc/kernel/nvram_64.c                  |    2=20
 arch/s390/mm/fault.c                            |    5 +
 arch/x86/lib/insn-eval.c                        |   47 +++++++-------
 arch/x86/power/cpu.c                            |   10 +++
 arch/x86/power/hibernate_64.c                   |   33 +++++++++
 drivers/acpi/apei/erst.c                        |    1=20
 drivers/block/xen-blkfront.c                    |   38 +++++------
 drivers/firmware/efi/efi-pstore.c               |    4 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c        |    3=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c         |   19 +++--
 drivers/gpu/drm/drm_atomic_helper.c             |   22 +++---
 drivers/gpu/drm/drm_edid.c                      |   25 +++++++
 drivers/gpu/drm/gma500/cdv_intel_lvds.c         |    3=20
 drivers/gpu/drm/gma500/intel_bios.c             |    3=20
 drivers/gpu/drm/gma500/psb_drv.h                |    1=20
 drivers/gpu/drm/i915/gvt/gtt.c                  |    6 +
 drivers/gpu/drm/i915/i915_reg.h                 |    6 -
 drivers/gpu/drm/i915/intel_fbc.c                |    4 +
 drivers/gpu/drm/i915/intel_workarounds.c        |    2=20
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c      |    4 +
 drivers/gpu/drm/nouveau/Kconfig                 |   13 +++
 drivers/gpu/drm/nouveau/nouveau_drm.c           |    7 +-
 drivers/gpu/drm/radeon/radeon_display.c         |    4 -
 drivers/i2c/busses/i2c-xiic.c                   |    5 +
 drivers/irqchip/irq-ath79-misc.c                |   11 ---
 drivers/misc/genwqe/card_dev.c                  |    2=20
 drivers/misc/genwqe/card_utils.c                |    4 +
 drivers/mtd/nand/spi/macronix.c                 |    8 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    4 -
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |    4 -
 drivers/net/ethernet/mellanox/mlx4/port.c       |    5 -
 drivers/net/ethernet/ti/cpsw.c                  |    2=20
 drivers/net/phy/sfp.c                           |   24 ++++++-
 drivers/parisc/ccio-dma.c                       |    4 -
 drivers/parisc/sba_iommu.c                      |    3=20
 drivers/tty/serial/serial_core.c                |   24 +++----
 fs/fuse/file.c                                  |    2=20
 fs/nfs/nfs4proc.c                               |   32 +++------
 fs/pstore/platform.c                            |   80 ++++++++++---------=
-----
 fs/pstore/ram.c                                 |   37 ++++++-----
 include/drm/drm_modeset_helper_vtables.h        |    8 ++
 include/linux/cpu.h                             |    4 +
 include/linux/pstore.h                          |    7 --
 include/linux/rcupdate.h                        |    6 -
 include/net/arp.h                               |    8 ++
 include/net/ip6_fib.h                           |    3=20
 include/net/tls.h                               |    4 +
 include/uapi/drm/i915_drm.h                     |    2=20
 kernel/cpu.c                                    |    4 -
 kernel/power/hibernate.c                        |    9 ++
 lib/test_firmware.c                             |   14 ++--
 net/core/ethtool.c                              |   17 ++++-
 net/core/fib_rules.c                            |    6 -
 net/core/neighbour.c                            |    9 ++
 net/core/pktgen.c                               |   11 +++
 net/ipv4/route.c                                |   22 +++---
 net/ipv6/raw.c                                  |   25 +++++--
 net/packet/af_packet.c                          |    2=20
 net/rds/ib_rdma.c                               |   10 +--
 net/sctp/sm_make_chunk.c                        |   13 ---
 net/sctp/sm_sideeffect.c                        |    5 +
 net/tls/tls_device.c                            |   27 ++++++--
 66 files changed, 473 insertions(+), 270 deletions(-)

Aaron Liu (1):
      drm/amdgpu: remove ATPX_DGPU_REQ_POWER_FOR_DISPLAYS check when hotplu=
g-in

Alex Deucher (1):
      drm/amdgpu/psp: move psp version specific function pointers to early_=
init

Andres Rodriguez (1):
      drm: add non-desktop quirk for Valve HMDs

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

Emil Lenngren (1):
      mtd: spinand: macronix: Fix ECC Status Read

Erez Alfasi (1):
      net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query

Gerald Schaefer (1):
      s390/mm: fix address space detection in exception handling

Greg Kroah-Hartman (2):
      Revert "MIPS: perf: ath79: Fix perfcount IRQ assignment"
      Linux 4.19.50

Hangbin Liu (1):
      Revert "fib_rules: return 0 directly if an exactly same rule exists w=
hen NLM_F_EXCL not supplied"

Helen Koike (2):
      drm/msm: fix fb references in async update
      drm: don't block fb changes for async plane updates

Ivan Khoronzhuk (1):
      net: ethernet: ti: cpsw_ethtool: fix ethtool ring param set

Jakub Kicinski (1):
      net/tls: replace the sleeping lock around RX resync with a bit lock

Jann Horn (1):
      x86/insn-eval: Fix use-after-free access to LDT entry

Jiri Kosina (1):
      x86/power: Fix 'nosmt' vs hibernation triple fault during resume

Jiri Slaby (1):
      TTY: serial_core, add ->install

John David Anglin (1):
      parisc: Use implicit space register selection for loading the coheren=
ce index of I/O pdirs

Jonathan Corbet (1):
      drm/i915: Maintain consistent documentation subsection ordering

Kees Cook (3):
      pstore: Remove needless lock during console writes
      pstore: Convert buf_lock to semaphore
      pstore/ram: Run without kernel crash dump region

Linus Torvalds (1):
      rcu: locking and unlocking need to always be at least barriers

Maxime Chevallier (1):
      net: mvpp2: Use strscpy to handle stat strings

Miklos Szeredi (1):
      fuse: fallocate: fix return with locked inode

Neil Horman (1):
      Fix memory leak in sctp_process_init

Olivier Matz (2):
      ipv6: use READ_ONCE() for inet->hdrincl as in ipv4
      ipv6: fix EFAULT on sendto with icmpv6 and hdrincl

Paolo Abeni (1):
      pktgen: do not sleep with the thread lock held.

Patrik Jakobsson (1):
      drm/gma500/cdv: Check vbt config bits when detecting lvds panels

Paul Burton (2):
      MIPS: Bounds check virt_addr_valid
      MIPS: pistachio: Build uImage.gz by default

Pi-Hsun Shih (1):
      pstore: Set tfm to NULL on free_buf_for_compression

Robert Hancock (1):
      i2c: xiic: Add max_read_len quirk

Roger Pau Monne (1):
      xen-blkfront: switch kcalloc to kvcalloc for large array allocation

Russell King (1):
      net: sfp: read eeprom in maximum 16 byte increments

Ryan Pavlik (1):
      drm: add non-desktop quirks to Sensics and OSVR headsets.

Tina Zhang (1):
      drm/i915/gvt: Initialize intel_gvt_gtt_entry in stack

Vivien Didelot (1):
      ethtool: fix potential userspace buffer overflow

Willem de Bruijn (1):
      packet: unconditionally free po->rollover

Xin Long (2):
      ipv4: not do cache for local delivery if bc_forwarding is enabled
      ipv6: fix the check before getting the cookie in rt6_get_cookie

Yihao Wu (2):
      NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails to wake a waiter
      NFSv4.1: Fix bug only first CB_NOTIFY_LOCK is handled

Yunsheng Lin (1):
      ethtool: check the return value of get_regs_len

Zhu Yanjun (1):
      net: rds: fix memory leak in rds_ib_flush_mr_pool


--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlz/rfAACgkQONu9yGCS
aT6fZg/9H2cn0eDHNLQq1JmxJn10UmNZir87xTe993Ev163VeB1F+hcAQJuT7gBM
XHcIrYfXqWpWE/lb63JGNnuhtxrVvKGd/DedGlDhtnL+eFrEm4UYTMJHpvywNOll
f8OXOQ3XUkbfbvohaQy+oiI85Za0SQd5Nj5zJOsiha2m6H3DIoMfbk7I/UL9u0su
AjzpnLIhYKi3YMB8PChYPom87T5CBaPV9lMMlU4CZ/BaBhlcG6oKH+8sw/akxLD9
S//DIR13GI1tlICHrxUvLucXFHcwGjkbFFoH5wPVEdoGdQ3xZIZ+CVwYit/ruipB
S7lXuod5ZxjY+SwFuA0U694eR720PlZBE3DNL+f9suZUyTPtbN+c2nfiaPX7gC0E
bYvYtm/5VIHZvtaaKppoBcGKF2ZnTCLrZxnthM4CxTQ7/+Nky7VqrAipDkrFuDAN
IEAAnr7gdqu3oT+m0D9aXH1FVWsPZmK4+iyF1/grNe+ggngNxlNYd0Ff2ra5T3Av
Wfk+Dvf+/Pdy+XqFuI6rA5/qpgBQyhxX1Yw3d+lTBq2Sd7WL3ylt/6Aa3ARnLuzP
twNAOKmr9oxz2b1gPXbqJCBGXq2toBPFWFT40nFbm+mkc8g0qvu1u/SFxi42UJkr
GDjVeA1N+u+ndQBJHEfVQteYB3yfyM111m0LSTe2EI3SE5hrYF8=
=UuQj
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
