Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9D838D3
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 20:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfHFSmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 14:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbfHFSmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 14:42:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9122120818;
        Tue,  6 Aug 2019 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565116941;
        bh=Ltb8VDXyH5likMLA+hyR9D+YYb6cPORjGpUr7oiPCuc=;
        h=Date:From:To:Cc:Subject:From;
        b=PVoP29IJz7RPRt98yqdpJSUbcZHgXptijHf3HqOYjX3Y4b5avp/YnPf5Wa9LqcU8G
         DTOaHUI64buGLWJ8h5qGr1KjMeeBSUuvJP5VpbYMoYdMW3CL8iaBs4PK/HvfWHcj1c
         mUUG9UOvuW7GYNlYQs1hqQ0RfjcYtd4IgzbvPFgE=
Date:   Tue, 6 Aug 2019 20:42:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.137
Message-ID: <20190806184218.GA27725@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.137 kernel.

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

 Documentation/admin-guide/hw-vuln/spectre.rst   |   88 ++++++++++++++++++--
 Documentation/admin-guide/kernel-parameters.txt |    7 -
 Makefile                                        |    5 -
 arch/arm/boot/dts/rk3288-veyron-mickey.dts      |    4=20
 arch/arm/boot/dts/rk3288-veyron-minnie.dts      |    4=20
 arch/arm/boot/dts/rk3288.dtsi                   |    1=20
 arch/arm/mach-rpc/dma.c                         |    5 -
 arch/mips/lantiq/irq.c                          |    5 -
 arch/parisc/boot/compressed/vmlinux.lds.S       |    4=20
 arch/x86/boot/compressed/misc.c                 |    1=20
 arch/x86/boot/compressed/misc.h                 |    1=20
 arch/x86/entry/calling.h                        |   17 +++
 arch/x86/entry/entry_64.S                       |   20 +++-
 arch/x86/entry/vdso/vclock_gettime.c            |   19 +++-
 arch/x86/include/asm/apic.h                     |    2=20
 arch/x86/include/asm/cpufeature.h               |    4=20
 arch/x86/include/asm/cpufeatures.h              |   20 ++--
 arch/x86/include/asm/kvm_host.h                 |   34 ++++---
 arch/x86/include/asm/paravirt.h                 |    1=20
 arch/x86/include/asm/traps.h                    |    2=20
 arch/x86/kernel/apic/apic.c                     |    2=20
 arch/x86/kernel/cpu/bugs.c                      |  105 +++++++++++++++++++=
++---
 arch/x86/kernel/cpu/common.c                    |   94 +++++++++++--------=
--
 arch/x86/kernel/cpu/cpuid-deps.c                |    3=20
 arch/x86/kernel/cpu/scattered.c                 |    4=20
 arch/x86/kernel/kvm.c                           |    1=20
 arch/x86/kvm/cpuid.h                            |    2=20
 arch/x86/kvm/mmu.c                              |    6 -
 arch/x86/math-emu/fpu_emu.h                     |    2=20
 arch/x86/math-emu/reg_constant.c                |    2=20
 arch/x86/xen/enlighten_pv.c                     |    2=20
 arch/x86/xen/xen-asm_64.S                       |    1=20
 drivers/acpi/blacklist.c                        |    4=20
 drivers/block/nbd.c                             |    2=20
 drivers/clk/tegra/clk-tegra210.c                |    8 -
 drivers/dma/sh/rcar-dmac.c                      |    2=20
 drivers/gpio/gpiolib.c                          |    6 -
 drivers/gpu/drm/nouveau/nouveau_connector.c     |    2=20
 drivers/infiniband/hw/hfi1/chip.c               |   11 ++
 drivers/infiniband/hw/hfi1/verbs.c              |    2=20
 drivers/infiniband/hw/mlx5/mlx5_ib.h            |    1=20
 drivers/infiniband/hw/mlx5/mr.c                 |   17 ++-
 drivers/infiniband/hw/mlx5/qp.c                 |   13 +-
 drivers/misc/eeprom/at24.c                      |    2=20
 drivers/mmc/host/dw_mmc.c                       |    3=20
 drivers/net/ethernet/emulex/benet/be_main.c     |    6 +
 drivers/perf/arm_pmu.c                          |    2=20
 drivers/rapidio/devices/rio_mport_cdev.c        |    2=20
 drivers/s390/block/dasd_alias.c                 |   22 +++--
 drivers/s390/scsi/zfcp_erp.c                    |    7 +
 drivers/xen/swiotlb-xen.c                       |    4=20
 fs/adfs/super.c                                 |    5 -
 fs/btrfs/send.c                                 |   77 +++--------------
 fs/btrfs/transaction.c                          |   10 ++
 fs/btrfs/volumes.c                              |    3=20
 fs/ceph/super.h                                 |    7 +
 fs/ceph/xattr.c                                 |   14 +--
 fs/cifs/connect.c                               |    8 -
 fs/coda/psdev.c                                 |    5 -
 include/linux/acpi.h                            |    5 -
 include/linux/coda.h                            |    3=20
 include/linux/coda_psdev.h                      |   11 ++
 include/uapi/linux/coda_psdev.h                 |   13 --
 ipc/mqueue.c                                    |   19 ++--
 kernel/module.c                                 |    6 -
 kernel/trace/ftrace.c                           |   28 +++---
 mm/cma.c                                        |   13 ++
 security/selinux/ss/policydb.c                  |    6 +
 tools/objtool/elf.c                             |    2=20
 69 files changed, 541 insertions(+), 278 deletions(-)

Andrea Parri (1):
      ceph: fix improper use of smp_mb__before_atomic()

Andy Lutomirski (1):
      x86/vdso: Prevent segfaults due to hoisted vclock reads

Arnd Bergmann (4):
      ACPI: blacklist: fix clang warning for unused DMI table
      x86: kvm: avoid constant-conversion warning
      ACPI: fix false-positive -Wuninitialized warning
      x86: math-emu: Hide clang warnings for 16-bit overflow

Benjamin Block (1):
      scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitializ=
ed

Benjamin Poirier (1):
      be2net: Signal that the device cannot transmit during reconfiguration

Borislav Petkov (1):
      x86/cpufeatures: Carve out CQM features retrieval

Cheng Jian (1):
      ftrace: Enable trampoline when rec count returns back to one

Dan Carpenter (1):
      drivers/rapidio/devices/rio_mport_cdev.c: NUL terminate some strings

David Sterba (1):
      btrfs: fix minimum number of chunk errors for DUP

Doug Berger (1):
      mm/cma.c: fail if fixed declaration can't be honored

Douglas Anderson (4):
      ARM: dts: rockchip: Make rk3288-veyron-minnie run at hs200
      ARM: dts: rockchip: Make rk3288-veyron-mickey's emmc work again
      ARM: dts: rockchip: Mark that the rk3288 timer might stop in suspend
      mmc: dw_mmc: Fix occasional hang after tuning on eMMC

Fenghua Yu (1):
      x86/cpufeatures: Combine word 11 and 12 into a new scattered features=
 word

Filipe Manana (2):
      Btrfs: fix incremental send failure after deduplication
      Btrfs: fix race leading to fs corruption after transaction abort

Geert Uytterhoeven (1):
      dmaengine: rcar-dmac: Reject zero-length slave DMA requests

Greg Kroah-Hartman (1):
      Linux 4.14.137

Gustavo A. R. Silva (1):
      IB/hfi1: Fix Spectre v1 vulnerability

Helge Deller (1):
      parisc: Fix build of compressed kernel even with debug enabled

JC Kuo (1):
      clk: tegra210: fix PLLU and PLLU_OUT1

Jean Delvare (1):
      eeprom: at24: make spd world-readable again

Jeff Layton (1):
      ceph: return -ERANGE if virtual xattr value didn't fit in buffer

John Fleck (1):
      IB/hfi1: Check for error on call to alloc_rsm_map_table

Josh Poimboeuf (6):
      x86/kvm: Don't call kvm_spurious_fault() from .fixup
      x86/paravirt: Fix callee-saved function ELF sizes
      objtool: Support GCC 9 cold subfunction naming scheme
      x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations
      x86/speculation: Enable Spectre v1 swapgs mitigations
      Documentation: Add swapgs description to the Spectre v1 documentation

Juergen Gross (1):
      xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()

Kees Cook (1):
      ipc/mqueue.c: only perform resource calculation if user valid

Linus Torvalds (1):
      gcc-9: properly declare the {pv,hv}clock_page storage

Masahiro Yamada (1):
      kbuild: initialize CLANG_FLAGS correctly in the top Makefile

Michael Wu (1):
      gpiolib: fix incorrect IRQ requesting of an active-low lineevent

Mikko Rapeli (1):
      uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel =
side headers

Munehisa Kamata (1):
      nbd: replace kill_bdev() with __invalidate_device() again

Ondrej Mosnacek (1):
      selinux: fix memory leak in policydb_init()

Petr Cvek (1):
      MIPS: lantiq: Fix bitfield masking

Prarit Bhargava (1):
      kernel/module.c: Only return -EEXIST for modules that have finished l=
oading

Qian Cai (1):
      x86/apic: Silence -Wtype-limits compiler warnings

Ronnie Sahlberg (1):
      cifs: Fix a race condition with cifs_echo_request

Russell King (2):
      ARM: riscpc: fix DMA
      fs/adfs: super: fix use-after-free bug

Sam Protsenko (1):
      coda: fix build using bare-metal toolchain

Stefan Haberland (1):
      s390/dasd: fix endless loop after read unit address configuration

Thomas Gleixner (1):
      x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS

Will Deacon (1):
      drivers/perf: arm_pmu: Fix failure path in PM notifier

Yishai Hadas (4):
      IB/mlx5: Fix unreg_umr to ignore the mkey state
      IB/mlx5: Use direct mkey destroy command upon UMR unreg failure
      IB/mlx5: Move MRs to a kernel PD when freeing them to the MR cache
      IB/mlx5: Fix RSS Toeplitz setup to be aligned with the HW specificati=
on

Yongxin Liu (1):
      drm/nouveau: fix memory leak in nouveau_conn_reset()

Zhenzhong Duan (2):
      xen/pv: Fix a boot up hang revealed by int3 self test
      x86, boot: Remove multiple copy of static function sanitize_boot_para=
ms()

Zhouyang Jia (1):
      coda: add error handling for fget


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1JygoACgkQONu9yGCS
aT6QzQ//cFtWy+/nTwjRvPDiNS0WkNjp0UJzpmjllBGl04sRv0IeVuFl3xtZg49a
A4IGMqBUqrG3C2hU/hO3XQuzf8TpAVBKoCT2EQFPb63r4Af4hKGILpG/9xAp8MiC
KprUjVfwthMC6Dtixg+uDDdlnoozd82VJEtFNScr9qO/NjgL6I85p8pvlhLaPotp
H7UE95i4IfvGp3F0Hh/M51w0Sq/OZaJfwgK7tv9NwIS+YRKBInRzl50MESpRwJYL
Z9DHSThTws8C1Q778NY/6S7QREaWdqWcR6RcBdi6TsyfIeZTpxQhZ2WuxY4RkfNb
G5zweXzrQQl+SC13itdfVfWAvmna+1cmvkIzH46m2dOtchdC3+cztiVpQYSMx89w
LDgFPJtUuP/2p7e3wJfnsy8kDsWrkSWA/hQvSFZI3cj6jD0CGTUgaRvyqlUzwVLx
QciXSxlp6Tt3qjRFVveLXSFTZKv1bJAXlSdjL2iyT3sOYtFHYlkhjEBayWamQ939
8Nj9l2G5W9XN680b7qQwfZO8QvuSsre9HuoOwEr36WbGmWA0bUF2TtuXDQdtUW7p
8b6olTAm8vnv+6wEHxInmh4Ouhm7Iy/6HZWArnfPzWvFvUtjVhq8wZS4n51DQNOf
CwaJQNYBs42xMmG81dxE3GVthkyrxeR7VvKGOVX5G9Nf1HlplFY=
=dVRf
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
