Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42AB838CC
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 20:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfHFSmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 14:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbfHFSmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 14:42:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F1DC20818;
        Tue,  6 Aug 2019 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565116925;
        bh=TzALEPr5zhCfjmU1Nxbez9OXd0oNsp2ueX3GNLRmV6U=;
        h=Date:From:To:Cc:Subject:From;
        b=WCiqXMBqpNiN3N3F6hfFg+KSxKOnm7G1EmlIpxIu0JMWjPsfS83gHcQW0eLfYnX2M
         GeEX0kxgRZrgzGAmxv+CGLfRC9n9tVMbKVgzfHzSwUoklrTD+ztpMCswC95AXdQlgq
         Sq5TPhombsKkpW4gVv8R7NHBLI6zDfcNZkWPP+Vc=
Date:   Tue, 6 Aug 2019 20:42:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.188
Message-ID: <20190806184202.GA27622@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.188 kernel.

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

 Makefile                                    |    5 +
 arch/arm/boot/dts/rk3288-veyron-mickey.dts  |    4 -
 arch/arm/boot/dts/rk3288-veyron-minnie.dts  |    4 -
 arch/arm/boot/dts/rk3288.dtsi               |    1=20
 arch/arm/mach-rpc/dma.c                     |    5 +
 arch/mips/lantiq/irq.c                      |    5 +
 arch/x86/boot/compressed/misc.c             |    1=20
 arch/x86/boot/compressed/misc.h             |    1=20
 arch/x86/include/asm/apic.h                 |    2=20
 arch/x86/include/asm/kvm_host.h             |   34 ++++++------
 arch/x86/kernel/apic/apic.c                 |    2=20
 arch/x86/math-emu/fpu_emu.h                 |    2=20
 arch/x86/math-emu/reg_constant.c            |    2=20
 arch/x86/mm/gup.c                           |   32 ++++++++++-
 drivers/android/binder.c                    |    6 ++
 drivers/dma/sh/rcar-dmac.c                  |    2=20
 drivers/gpio/gpiolib.c                      |    6 +-
 drivers/infiniband/hw/mlx4/main.c           |    4 +
 drivers/infiniband/hw/mlx5/main.c           |    3 +
 drivers/infiniband/hw/mlx5/qp.c             |    1=20
 drivers/misc/eeprom/at24.c                  |    2=20
 drivers/mmc/host/dw_mmc.c                   |    3 -
 drivers/net/ethernet/emulex/benet/be_main.c |    6 +-
 drivers/perf/arm_pmu.c                      |    2=20
 drivers/rapidio/devices/rio_mport_cdev.c    |    2=20
 drivers/s390/block/dasd_alias.c             |   22 +++++---
 drivers/s390/scsi/zfcp_erp.c                |    7 ++
 drivers/xen/swiotlb-xen.c                   |    4 -
 fs/adfs/super.c                             |    5 +
 fs/btrfs/send.c                             |   77 +++++------------------=
-----
 fs/btrfs/volumes.c                          |    3 -
 fs/ceph/super.h                             |    7 ++
 fs/ceph/xattr.c                             |   14 ++---
 fs/coda/psdev.c                             |    5 +
 fs/proc/task_mmu.c                          |   18 ++++++
 fs/userfaultfd.c                            |    9 +++
 include/linux/acpi.h                        |    5 +
 include/linux/coda.h                        |    3 -
 include/linux/coda_psdev.h                  |   11 ++++
 include/linux/compiler.h                    |   16 +++++
 include/linux/mm.h                          |   24 ++++++++
 include/linux/module.h                      |    4 -
 include/uapi/linux/coda_psdev.h             |   13 ----
 ipc/mqueue.c                                |   19 +++---
 kernel/module.c                             |    6 --
 kernel/trace/ftrace.c                       |   28 +++++-----
 mm/cma.c                                    |   13 ++++
 mm/khugepaged.c                             |    3 +
 mm/mmap.c                                   |    6 +-
 security/selinux/ss/policydb.c              |    6 +-
 tools/objtool/elf.c                         |    2=20
 51 files changed, 293 insertions(+), 174 deletions(-)

Ajay Kaher (1):
      infiniband: fix race condition between infiniband mlx4, mlx5 driver a=
nd core dumping

Andrea Arcangeli (2):
      coredump: fix race condition between mmget_not_zero()/get_task_mm() a=
nd core dumping
      coredump: fix race condition between collapse_huge_page() and core du=
mping

Andrea Parri (1):
      ceph: fix improper use of smp_mb__before_atomic()

Arnd Bergmann (2):
      ACPI: fix false-positive -Wuninitialized warning
      x86: math-emu: Hide clang warnings for 16-bit overflow

Benjamin Block (1):
      scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitializ=
ed

Benjamin Poirier (1):
      be2net: Signal that the device cannot transmit during reconfiguration

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

Filipe Manana (1):
      Btrfs: fix incremental send failure after deduplication

Geert Uytterhoeven (1):
      dmaengine: rcar-dmac: Reject zero-length slave DMA requests

Greg Kroah-Hartman (1):
      Linux 4.9.188

Jean Delvare (1):
      eeprom: at24: make spd world-readable again

Jeff Layton (1):
      ceph: return -ERANGE if virtual xattr value didn't fit in buffer

Josh Poimboeuf (2):
      x86/kvm: Don't call kvm_spurious_fault() from .fixup
      objtool: Support GCC 9 cold subfunction naming scheme

Juergen Gross (1):
      xen/swiotlb: fix condition for calling xen_destroy_contiguous_region()

Kees Cook (1):
      ipc/mqueue.c: only perform resource calculation if user valid

Masahiro Yamada (1):
      kbuild: initialize CLANG_FLAGS correctly in the top Makefile

Michael Wu (1):
      gpiolib: fix incorrect IRQ requesting of an active-low lineevent

Miguel Ojeda (2):
      Backport minimal compiler_attributes.h to support GCC 9
      include/linux/module.h: copy __init/__exit attrs to init/cleanup_modu=
le

Mikko Rapeli (1):
      uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel =
side headers

Ondrej Mosnacek (1):
      selinux: fix memory leak in policydb_init()

Petr Cvek (1):
      MIPS: lantiq: Fix bitfield masking

Prarit Bhargava (1):
      kernel/module.c: Only return -EEXIST for modules that have finished l=
oading

Qian Cai (1):
      x86/apic: Silence -Wtype-limits compiler warnings

Russell King (2):
      ARM: riscpc: fix DMA
      fs/adfs: super: fix use-after-free bug

Sam Protsenko (1):
      coda: fix build using bare-metal toolchain

Stefan Haberland (1):
      s390/dasd: fix endless loop after read unit address configuration

Vlastimil Babka (1):
      x86, mm, gup: prevent get_page() race with munmap in paravirt guest

Will Deacon (1):
      drivers/perf: arm_pmu: Fix failure path in PM notifier

Yishai Hadas (1):
      IB/mlx5: Fix RSS Toeplitz setup to be aligned with the HW specificati=
on

Zhenzhong Duan (1):
      x86, boot: Remove multiple copy of static function sanitize_boot_para=
ms()

Zhouyang Jia (1):
      coda: add error handling for fget


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1JyfoACgkQONu9yGCS
aT487hAA1lmMI26Of3WWD8/+WO1+xjMlce9LHu1bOMaEbczkHZwmdXe936fUaHvc
qbZohh7N32fwEzqQjGFNmSO8wwdVZ5TRDEBZtVR+LShdif2BIRVDOTgHV5j9VFQy
x1HoWbEQ2KQpyREvENBwNZ7lIHtXQRGA7V6+O3VtrV0uDB/svbMhV2D6KUFu1pM2
NW3RiuA+xgc7hr7lCvvjPnChlbnV5M52yCgJYiblBL8FWrg6mYtk00vh3zukVdTC
mnA3w3eW+IFptSmyIh+x+zEnvmMdCnxCb/GskMfBAQ46CbJZ4P0VHhEmvk+R/DeS
DJUvOEFamogRDZK5Ezv4MpybsWiO0DJC7xZyJ0Zp5QyCQYLj7jrnqwt94m2bRW4w
WZCTwacyHZvaEKAEIKVD31piNYXK2RrBXTRUzxavc8ogNTHdGW4t5oiugwQl2PAz
R8ir7vky5K4QV6wWEVKwL+xELisGYFFxX778BPK7ym/Om+RlsTjJZ7Uudku+QnrD
6SEL/M+v8TzqAP7e42E03ItTM2B2tbyEvWwr7c6ljLKa5iyvBskeN8DSmmOKVhAi
4gppe3ce0IFbKWxCTkem0SJhWVOh6in7I+Muzhoo8s1hqLipcUNBKYu9ShpDDMsG
9h9NG7XWinARFntzLTZW3zOchCCnf0kbzcnbqjcTF9gymuU3sVc=
=Vq45
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
