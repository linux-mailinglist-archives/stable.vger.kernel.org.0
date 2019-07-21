Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C33066F383
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfGUNsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 09:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbfGUNsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 09:48:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA0F2084C;
        Sun, 21 Jul 2019 13:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563716924;
        bh=BO3MX2FHAGP0hIMznvYE7ZhcWIh/cMULFTn8hpZbWCE=;
        h=Date:From:To:Cc:Subject:From;
        b=GNoer9BPN+izswvvGWn4ksstX85h8/Iq0UJ9gMeZKyqbAwiRf/K1xX1fS+ntSQSq4
         ASXUeYgRyT2B8EO2M0n9F6nRFY7OyDjKApDEfME27Fnlq67jnk07tqyvsJkzjXLO+Y
         a1Gwq3Xdxbd2BmuLj5rmy7tguo3y38oFyg93WZQU=
Date:   Sun, 21 Jul 2019 15:48:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.60
Message-ID: <20190721134841.GA23259@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.60 kernel.

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

 Makefile                                       |    2=20
 arch/arc/kernel/unwind.c                       |    9 +-
 arch/arm/boot/dts/gemini-dlink-dns-313.dts     |    2=20
 arch/arm/boot/dts/imx6ul.dtsi                  |    8 +-
 arch/arm/mach-omap2/prm3xxx.c                  |    2=20
 arch/s390/include/asm/facility.h               |   21 +++--
 arch/x86/entry/entry_32.S                      |   24 ++++++
 arch/x86/entry/entry_64.S                      |   30 ++++++-
 arch/x86/include/asm/hw_irq.h                  |    5 +
 arch/x86/kernel/apic/apic.c                    |   36 ++++++---
 arch/x86/kernel/apic/io_apic.c                 |   46 +++++++++++
 arch/x86/kernel/apic/vector.c                  |    4 -
 arch/x86/kernel/head64.c                       |   20 ++---
 arch/x86/kernel/idt.c                          |    3=20
 arch/x86/kernel/irq.c                          |    2=20
 drivers/base/cacheinfo.c                       |    3=20
 drivers/base/firmware_loader/fallback.c        |    2=20
 drivers/base/regmap/regmap-irq.c               |    6 +
 drivers/clk/ti/clkctrl.c                       |    7 +
 drivers/crypto/nx/nx-842-powernv.c             |    8 +-
 drivers/crypto/talitos.c                       |   99 ++++++++++----------=
-----
 drivers/crypto/talitos.h                       |   30 +++++++
 drivers/firmware/efi/efi-bgrt.c                |    5 -
 drivers/gpu/drm/udl/udl_drv.c                  |   56 +++++++++++---
 drivers/gpu/drm/udl/udl_drv.h                  |    9 +-
 drivers/gpu/drm/udl/udl_fb.c                   |   12 +--
 drivers/gpu/drm/udl/udl_gem.c                  |    2=20
 drivers/gpu/drm/udl/udl_main.c                 |   35 ++------
 drivers/hid/hid-ids.h                          |    2=20
 drivers/hid/hid-multitouch.c                   |    4 +
 drivers/hid/hid-quirks.c                       |    1=20
 drivers/input/mouse/synaptics.c                |    1=20
 drivers/irqchip/irq-gic-v3-its.c               |   35 ++++++--
 drivers/md/dm-table.c                          |    2=20
 drivers/md/dm-verity-target.c                  |    4 -
 drivers/net/ethernet/emulex/benet/be_ethtool.c |   28 +++++--
 drivers/net/ethernet/intel/e1000e/netdev.c     |   21 +++--
 drivers/net/ethernet/sis/sis900.c              |   16 ++--
 drivers/net/ppp/ppp_mppe.c                     |    1=20
 drivers/pinctrl/mediatek/mtk-eint.c            |   34 ++++----
 drivers/pinctrl/pinctrl-mcp23s08.c             |    8 +-
 drivers/s390/cio/qdio_setup.c                  |    2=20
 drivers/s390/cio/qdio_thinint.c                |    5 -
 fs/afs/callback.c                              |    4 -
 fs/afs/internal.h                              |    2=20
 fs/afs/volume.c                                |    1=20
 include/linux/cpuhotplug.h                     |    1=20
 include/linux/kernel.h                         |    3=20
 include/uapi/linux/nilfs2_ondisk.h             |   24 +++---
 kernel/cpu.c                                   |    3=20
 kernel/events/core.c                           |    2=20
 kernel/irq/autoprobe.c                         |    6 -
 kernel/irq/chip.c                              |    6 +
 kernel/irq/cpuhotplug.c                        |    2=20
 kernel/irq/internals.h                         |    5 +
 kernel/irq/manage.c                            |   88 +++++++++++++++++---=
--
 56 files changed, 533 insertions(+), 266 deletions(-)

Arnd Bergmann (2):
      ARM: omap2: remove incorrect __init annotation
      ARC: hide unused function unw_hdr_alloc

Christophe Leroy (2):
      crypto: talitos - move struct talitos_edesc into talitos.h
      crypto: talitos - fix hash on SEC1.

Cole Rogers (1):
      Input: synaptics - enable SMBUS on T480 thinkpad trackpad

Colin Ian King (1):
      x86/apic: Fix integer overflow on 10 bit left shift of cpu_khz

Dave Airlie (2):
      drm/udl: introduce a macro to convert dev to udl.
      drm/udl: move to embedding drm device inside udl device.

David Howells (1):
      afs: Fix uninitialised spinlock afs_volume::cb_break_lock

Eiichi Tsukata (1):
      cpu/hotplug: Fix out-of-bounds read when setting fail state

Greg Kroah-Hartman (1):
      Linux 4.19.60

Hans de Goede (1):
      efi/bgrt: Drop BGRT status field reserved bits check

Haren Myneni (1):
      crypto/NX: Set receive window credits to max number of CRBs in RxFIFO

Heiko Carstens (1):
      s390: fix stfle zero padding

Heyi Guo (1):
      irqchip/gic-v3-its: Fix command queue pointer comparison bug

James Morse (1):
      drivers: base: cacheinfo: Ensure cpu hotplug work is done before Inte=
l RDT

Jerome Marchand (1):
      dm table: don't copy from a NULL pointer in realloc_argv()

Jiri Slaby (1):
      x86/entry/32: Fix ENDPROC of common_spurious

Julian Wiedmann (2):
      s390/qdio: (re-)initialize tiqdio list entries
      s390/qdio: don't touch the dsci in tiqdio_add_input_queues()

Kai-Heng Feng (1):
      HID: multitouch: Add pointstick support for ALPS Touchpad

Kirill A. Shutemov (2):
      x86/boot/64: Fix crash if kernel image crosses page table boundary
      x86/boot/64: Add missing fixup_pointer() for next_early_pgt access

Konstantin Khlebnikov (2):
      Revert "e1000e: fix cyclic resets at link up with active tx"
      e1000e: start network tx queue only when link is up

Linus Walleij (1):
      ARM: dts: gemini Fix up DNS-313 compatible string

Mark Zhang (1):
      regmap-irq: do not write mask register if mask_base is zero

Masahiro Yamada (1):
      nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi hea=
der

Milan Broz (1):
      dm verity: use message limit for data block corruption message

Nicolas Boichat (2):
      pinctrl: mediatek: Ignore interrupts that are wake only during resume
      pinctrl: mediatek: Update cur_mask in mask/mask ops

Oleksandr Natalenko (1):
      HID: chicony: add another quirk for PixArt mouse

Peter Zijlstra (1):
      perf/core: Fix perf_sample_regs_user() mm check

Petr Oros (1):
      be2net: fix link failure after ethtool offline test

Phil Reid (1):
      pinctrl: mcp23s08: Fix add_data and irqchip_add_nested call order

Sergej Benilov (1):
      sis900: fix TX completion

Sven Van Asbroeck (1):
      firmware: improve LSM/IMA security behaviour

S=E9bastien Szymanski (1):
      ARM: dts: imx6ul: fix PWM[1-4] interrupts

Takashi Iwai (1):
      ppp: mppe: Add softdep to arc4

Thomas Gleixner (6):
      genirq: Delay deactivation in free_irq()
      genirq: Fix misleading synchronize_irq() documentation
      genirq: Add optional hardware synchronization for shutdown
      x86/ioapic: Implement irq_get_irqchip_state() callback
      x86/irq: Handle spurious interrupt after shutdown gracefully
      x86/irq: Seperate unused system vectors from spurious entry again

Thomas Zimmermann (1):
      drm/udl: Replace drm_dev_unref with drm_dev_put

Tony Lindgren (1):
      clk: ti: clkctrl: Fix returning uninitialized data

Vinod Koul (1):
      linux/kernel.h: fix overflow for DIV_ROUND_UP_ULL


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl00bTkACgkQONu9yGCS
aT5gjw/+LF2TiSOcuLQrW1CERo1I0CNTQyxuCxMurjJKM5bVPgyeI2s/g3r5MxIc
z7fdcuF6zekJHY8IqiMNbCTQzkbixaxBJApNY6kXCuTcf4EwHDm/lcyJlA3/N+VV
vnJAuDt4qkfT6gbjVc40DVc7rCAcT2eM60xMl2TA+vKrwyPYCPX79yNe/9Rlf2s8
eSSDVqsUlyS+BN+xs2BJ22+8gUjBx80am/BScGXmhiX6vWfTOjR56dfEzscV5Dnj
Z7P5zZEEwavlv4TAAz3NSOMGMFTHeU6iOG6MJ/l76mkVLGovvSJfwahngHwxmu0J
Q+rl1Lj6NBBXiRoyasUZ3mCFExpsHdLMrdJVFy5AErKUxRxHjKc0bYTRDg0FmbxC
lx0pFpu4dEEvYVe4aEWiZNJQSQkuhNBLW7L2RR0FaKQfCcMuGj+R7wHWvA4w5Nlz
Bc/uQsBNln2AmhsxB8Ll3/CwzSMLw/c6s3VYczBvcFm1tR0OeMFOWXezMwwt45Bp
YXAD7wf1M+9Ia/4veTGZjuagk0QJn5QtUGpop52KUTBlieek8/qhs4LA67U0+3Om
3FRWGih2qoaQewYECHBAHkBxF14XTt/hHrPXObys4AWq1i3LkQGtUJCzoFiSDbSk
KJfbWPm/U24MLVIkVIB3azcJePicSYo5bv14T3Zp7G53rJLukpo=
=A1tT
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
