Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C886F387
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 15:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfGUNtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 09:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfGUNtE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 09:49:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F85A208E4;
        Sun, 21 Jul 2019 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563716943;
        bh=+37SyEkhnf25WneKinzXZ6O+tm3wz3w7GMdGLLpRkOM=;
        h=Date:From:To:Cc:Subject:From;
        b=jYCWMrxmEb36Cq2+N8cYLM8QtW1lYSd3N26pW90B9fKqdmICgSPqcewnUDC1uG+NP
         /DAM9fYPf8Fs7BcTM2z+uThOFmIP67rnLAiqvEFFbIeoZfi4dfz/R9Q2Wf9NJYi5zH
         DAVLxvGF0oKzaUU0nvTn5gPzcg1OMj+Cap5J2iIA=
Date:   Sun, 21 Jul 2019 15:49:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.19
Message-ID: <20190721134900.GA23372@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.19 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                      |    2=20
 arch/arc/kernel/unwind.c                                      |    9=20
 arch/arm/boot/dts/gemini-dlink-dns-313.dts                    |    2=20
 arch/arm/boot/dts/imx6ul.dtsi                                 |    8=20
 arch/arm/boot/dts/meson8.dtsi                                 |    5=20
 arch/arm/boot/dts/meson8b.dtsi                                |   10 -
 arch/arm/mach-omap2/prm3xxx.c                                 |    2=20
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                |   18 -
 arch/s390/include/asm/facility.h                              |   21 +-
 arch/x86/entry/entry_32.S                                     |   24 ++
 arch/x86/entry/entry_64.S                                     |   30 ++-
 arch/x86/include/asm/hw_irq.h                                 |    5=20
 arch/x86/kernel/apic/apic.c                                   |   36 ++-
 arch/x86/kernel/apic/io_apic.c                                |   46 ++++
 arch/x86/kernel/apic/vector.c                                 |    4=20
 arch/x86/kernel/head64.c                                      |   20 +-
 arch/x86/kernel/idt.c                                         |    3=20
 arch/x86/kernel/irq.c                                         |    2=20
 arch/x86/platform/efi/quirks.c                                |    2=20
 drivers/base/cacheinfo.c                                      |    3=20
 drivers/base/firmware_loader/fallback.c                       |    2=20
 drivers/clk/ti/clkctrl.c                                      |    7=20
 drivers/crypto/nx/nx-842-powernv.c                            |    8=20
 drivers/crypto/talitos.c                                      |   99 ++++-=
-----
 drivers/crypto/talitos.h                                      |   30 +++
 drivers/firmware/efi/efi-bgrt.c                               |    5=20
 drivers/hid/hid-ids.h                                         |    3=20
 drivers/hid/hid-multitouch.c                                  |    4=20
 drivers/hid/hid-quirks.c                                      |    1=20
 drivers/hid/hid-uclogic-core.c                                |    2=20
 drivers/hid/hid-uclogic-params.c                              |    2=20
 drivers/input/mouse/synaptics.c                               |    1=20
 drivers/irqchip/irq-csky-mpintc.c                             |   15 +
 drivers/irqchip/irq-gic-v3-its.c                              |   35 ++-
 drivers/md/dm-table.c                                         |    2=20
 drivers/md/dm-verity-target.c                                 |    4=20
 drivers/net/ethernet/emulex/benet/be_ethtool.c                |   28 ++
 drivers/net/ethernet/intel/e1000e/netdev.c                    |   21 +-
 drivers/net/ethernet/sis/sis900.c                             |   16 -
 drivers/net/ppp/ppp_mppe.c                                    |    1=20
 drivers/pinctrl/mediatek/mtk-eint.c                           |   34 +--
 drivers/pinctrl/pinctrl-mcp23s08.c                            |    8=20
 drivers/pinctrl/pinctrl-ocelot.c                              |   18 +
 drivers/s390/cio/qdio_setup.c                                 |    2=20
 drivers/s390/cio/qdio_thinint.c                               |    5=20
 fs/afs/callback.c                                             |    4=20
 fs/afs/internal.h                                             |    2=20
 fs/afs/volume.c                                               |    1=20
 include/linux/cpuhotplug.h                                    |    1=20
 include/linux/kernel.h                                        |    3=20
 include/uapi/linux/nilfs2_ondisk.h                            |   24 +-
 kernel/cpu.c                                                  |    3=20
 kernel/events/core.c                                          |    2=20
 kernel/fork.c                                                 |    6=20
 kernel/irq/autoprobe.c                                        |    6=20
 kernel/irq/chip.c                                             |    6=20
 kernel/irq/cpuhotplug.c                                       |    2=20
 kernel/irq/internals.h                                        |    5=20
 kernel/irq/manage.c                                           |   90 +++++=
+---
 mm/oom_kill.c                                                 |   12 -
 tools/testing/selftests/powerpc/mm/.gitignore                 |    3=20
 tools/testing/selftests/powerpc/mm/Makefile                   |    4=20
 tools/testing/selftests/powerpc/mm/large_vm_fork_separation.c |   87 +++++=
+++
 63 files changed, 609 insertions(+), 257 deletions(-)

Alexandre Belloni (2):
      pinctrl: ocelot: fix gpio direction for pins after 31
      pinctrl: ocelot: fix pinmuxing for pins after 31

Andrea Arcangeli (1):
      fork,memcg: alloc_thread_stack_node needs to set tsk->stack

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

David Howells (1):
      afs: Fix uninitialised spinlock afs_volume::cb_break_lock

Eiichi Tsukata (1):
      cpu/hotplug: Fix out-of-bounds read when setting fail state

Greg Kroah-Hartman (1):
      Linux 5.1.19

Guo Ren (1):
      irqchip/irq-csky-mpintc: Support auto irq deliver to all cpus

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

Kyle Godbey (1):
      HID: uclogic: Add support for Huion HS64 tablet

Linus Walleij (1):
      ARM: dts: gemini Fix up DNS-313 compatible string

Martin Blumenstingl (2):
      ARM: dts: meson8: fix GPU interrupts and drop an undocumented property
      ARM: dts: meson8b: fix the operating voltage of the Mali GPU

Masahiro Yamada (1):
      nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi hea=
der

Michael Ellerman (1):
      selftests/powerpc: Add test of fork with mapping above 512TB

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

Qian Cai (1):
      x86/efi: fix a -Wtype-limits compilation warning

Ran Wang (1):
      arm64: dts: ls1028a: Fix CPU idle fail.

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

Tony Lindgren (1):
      clk: ti: clkctrl: Fix returning uninitialized data

Vinod Koul (1):
      linux/kernel.h: fix overflow for DIV_ROUND_UP_ULL

Yafang Shao (1):
      mm/oom_kill.c: fix uninitialized oc->constraint


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl00bUwACgkQONu9yGCS
aT6GSQ/+Nk4OarIp8w0fpwtNM98r3Ux+5jQxdFwbHpPa7CcoWapLljCqEeZ1ff0B
xCHiYhjJGS1oQDKiI3hDo+1s9icm7zdsLp4b0qit6JQKt/8rpkMMRkGImCErJurh
wNib+QuG0Q2NJVYG3r+d8oezrm7VwRtOg0sMYIsI8yX7itBgWWPoA/TyYYUGrRDh
RvrI2y3OKIG1rb6PEL9DA87YSN3Ja87za30DxVKTSim2UYTnd8UfiI+gl/Q3JAM8
J4hlWOj7S6x/N+a0EDJ7VND3yc6jfOWbdqMOqVOILYn0di+KXrktUbW/dmWxKts7
U8K2jN97Vsh2Lk/EYF9/D8Emfxe5EVJFHgCrMq5iLxyfYDfUSwgrm1zY+o73buWk
KwMemstOcm+GY0HNFuVzAh5Ep9Mi9AE6JfNNU26xw2vBx9mHNlC3+AvJ10YptR+5
0joOz39+m7u9RGylJatMXq1lZ3sPPsR3Ur02LcMYVgW/N+HNU0akdBFoIYMsnEtQ
+reObNQgdPC+lSz3J1aT/yKXsmHD8+0zhvBc0sv1u4sg+KgTN4tVKtCT/Obwd8tV
EsPwnM5YY96WVUJroCp2DYpspJFX+2TUIRQSw2y1AqHjKkEEVJ4KaxxeBgf8vgB6
d5FruCSSX5IfAj5Zt8Glvb0CyReyQ20RamCoK823BJ6oPjqqYq0=
=7F9T
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
