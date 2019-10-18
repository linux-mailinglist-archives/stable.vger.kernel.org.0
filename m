Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598AADC365
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 13:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633550AbfJRLAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 07:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633557AbfJRLAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 07:00:32 -0400
Received: from localhost (unknown [209.136.236.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B41D820700;
        Fri, 18 Oct 2019 11:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571396430;
        bh=Y04CtySInqXgWiv3EWGNrxiF/HwyIMAyMhJTYYtmcoI=;
        h=Date:From:To:Cc:Subject:From;
        b=wR4kEfON2dPvHPzB9Hf72TW1sDon+TMQF3ByjX8OeUiR2yMAGmm10CjbV6ZWcgAPb
         emrA9Bd+zh4gtD2X2nGqGL20pvTg7RfvhAahaYH1NPb58bbnz4mg+MegvThaOFJdgp
         6kj106hmq5V8hYwNyQiUzX3sAXGiMkv/ceRHpzwM=
Date:   Fri, 18 Oct 2019 04:00:30 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.150
Message-ID: <20191018110030.GA1176422@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.150 kernel.

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

 Documentation/usb/rio.txt                |  138 -------
 MAINTAINERS                              |    7=20
 Makefile                                 |    2=20
 arch/arm/configs/badge4_defconfig        |    1=20
 arch/arm/configs/corgi_defconfig         |    1=20
 arch/arm/configs/pxa_defconfig           |    1=20
 arch/arm/configs/s3c2410_defconfig       |    1=20
 arch/arm/configs/spitz_defconfig         |    1=20
 arch/mips/configs/mtx1_defconfig         |    1=20
 arch/mips/configs/rm200_defconfig        |    1=20
 arch/mips/loongson64/Platform            |    4=20
 arch/mips/vdso/Makefile                  |    1=20
 arch/x86/include/asm/mwait.h             |    2=20
 arch/x86/lib/delay.c                     |    4=20
 drivers/firmware/efi/efi.c               |    3=20
 drivers/firmware/google/vpd_decode.c     |    2=20
 drivers/gpio/gpiolib.c                   |   27 +
 drivers/iio/adc/ad799x.c                 |    4=20
 drivers/iio/adc/axp288_adc.c             |   32 +
 drivers/iio/adc/hx711.c                  |   49 ++
 drivers/iio/light/opt3001.c              |    6=20
 drivers/media/usb/stkwebcam/stk-webcam.c |    3=20
 drivers/staging/fbtft/fbtft-core.c       |    7=20
 drivers/staging/vt6655/device_main.c     |    4=20
 drivers/tty/serial/uartlite.c            |    3=20
 drivers/usb/class/usblp.c                |    8=20
 drivers/usb/gadget/udc/dummy_hcd.c       |    3=20
 drivers/usb/host/xhci-ring.c             |    4=20
 drivers/usb/host/xhci.c                  |   32 +
 drivers/usb/image/microtek.c             |    4=20
 drivers/usb/misc/Kconfig                 |   10=20
 drivers/usb/misc/Makefile                |    1=20
 drivers/usb/misc/adutux.c                |   26 -
 drivers/usb/misc/chaoskey.c              |    5=20
 drivers/usb/misc/iowarrior.c             |   16=20
 drivers/usb/misc/ldusb.c                 |   24 -
 drivers/usb/misc/legousbtower.c          |   58 +--
 drivers/usb/misc/rio500.c                |  574 --------------------------=
-----
 drivers/usb/misc/rio500_usb.h            |   37 -
 drivers/usb/misc/usblcd.c                |   33 +
 drivers/usb/misc/yurex.c                 |   18=20
 drivers/usb/renesas_usbhs/common.h       |    1=20
 drivers/usb/renesas_usbhs/fifo.c         |    2=20
 drivers/usb/renesas_usbhs/fifo.h         |    1=20
 drivers/usb/renesas_usbhs/mod_gadget.c   |   18=20
 drivers/usb/renesas_usbhs/pipe.c         |   15=20
 drivers/usb/renesas_usbhs/pipe.h         |    1=20
 drivers/usb/serial/ftdi_sio.c            |    3=20
 drivers/usb/serial/ftdi_sio_ids.h        |    9=20
 drivers/usb/serial/keyspan.c             |    4=20
 drivers/usb/serial/option.c              |   11=20
 drivers/usb/serial/usb-serial.c          |    5=20
 drivers/usb/usb-skeleton.c               |   15=20
 fs/btrfs/tree-log.c                      |   36 +
 fs/cifs/dir.c                            |    8=20
 fs/cifs/file.c                           |    6=20
 fs/cifs/inode.c                          |    4=20
 fs/f2fs/super.c                          |   36 -
 fs/libfs.c                               |  134 +++----
 fs/nfs/direct.c                          |   78 ++--
 fs/xfs/xfs_super.c                       |   10=20
 kernel/fork.c                            |    4=20
 kernel/panic.c                           |    1=20
 kernel/trace/ftrace.c                    |   27 -
 kernel/trace/trace.c                     |   17=20
 kernel/trace/trace_hwlat.c               |    4=20
 tools/perf/util/jitdump.c                |    6=20
 tools/perf/util/llvm-utils.c             |    6=20
 68 files changed, 566 insertions(+), 1054 deletions(-)

Al Viro (1):
      Fix the locking in dcache_readdir() and friends

Alan Stern (1):
      USB: yurex: Don't retry on unexpected errors

Andreas Klinger (2):
      iio: hx711: add delay until DOUT is ready
      iio: adc: hx711: fix bug in sampling of data

Ard Biesheuvel (1):
      efivar/ssdt: Don't iterate over EFI vars if no SSDT override was spec=
ified

Bartosz Golaszewski (1):
      gpiolib: don't clear FLAG_IS_OUT when emulating open-drain/open-source

Bastien Nocera (1):
      USB: rio500: Remove Rio 500 kernel driver

Beni Mahler (1):
      USB: serial: ftdi_sio: add device IDs for Sienna and Echelon PL-20

Brian Norris (1):
      firmware: google: increment VPD key_len properly

Colin Ian King (1):
      USB: adutux: remove redundant variable minor

Daniele Palmas (1):
      USB: serial: option: add Telit FN980 compositions

Dave Chinner (1):
      xfs: clear sb->s_fs_info on mount failure

David Frey (1):
      iio: light: opt3001: fix mutex unlock race

Greg Kroah-Hartman (1):
      Linux 4.14.150

Hans de Goede (1):
      iio: adc: axp288: Override TS pin bias current for some models

Ian Rogers (1):
      perf llvm: Don't access out-of-scope array

Icenowy Zheng (1):
      f2fs: use EINVAL for superblock with invalid magic

Jacky.Cao@sony.com (1):
      USB: dummy-hcd: fix power budget for SuperSpeed mode

Jan Schmidt (1):
      xhci: Check all endpoints for LPM timeout

Janakarajan Natarajan (1):
      x86/asm: Fix MWAITX C-state hint value

Johan Hovold (22):
      USB: yurex: fix NULL-derefs on disconnect
      USB: usb-skeleton: fix runtime PM after driver unbind
      USB: usb-skeleton: fix NULL-deref on disconnect
      USB: adutux: fix use-after-free on disconnect
      USB: adutux: fix NULL-derefs on disconnect
      USB: adutux: fix use-after-free on release
      USB: iowarrior: fix use-after-free on disconnect
      USB: iowarrior: fix use-after-free on release
      USB: iowarrior: fix use-after-free after driver unbind
      USB: usblp: fix runtime PM after driver unbind
      USB: chaoskey: fix use-after-free on release
      USB: ldusb: fix NULL-derefs on driver unbind
      USB: serial: keyspan: fix NULL-derefs on open() and write()
      USB: serial: fix runtime PM after driver unbind
      USB: usblcd: fix I/O after disconnect
      USB: microtek: fix info-leak at probe
      USB: legousbtower: fix slab info leak at probe
      USB: legousbtower: fix deadlock on disconnect
      USB: legousbtower: fix potential NULL-deref on disconnect
      USB: legousbtower: fix open after failed reset request
      USB: legousbtower: fix use-after-free on release
      media: stkwebcam: fix runtime PM after driver unbind

Josef Bacik (1):
      btrfs: fix incorrect updating of log root tree

Kai-Heng Feng (1):
      xhci: Increase STS_SAVE timeout in xhci_suspend()

Marco Felsch (1):
      iio: adc: ad799x: fix probe error handling

Mathias Nyman (2):
      xhci: Fix false warning message about wrong bounce buffer write length
      xhci: Prevent device initiated U1/U2 link pm if exit latency is too l=
ong

Michal Hocko (1):
      kernel/sysctl.c: do not override max_threads provided by userspace

Navid Emamdoost (2):
      staging: vt6655: Fix memory leak in vt6655_probe
      Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc

Paul Burton (1):
      MIPS: Disable Loongson MMI instructions for kernel build

Pavel Shilovsky (3):
      CIFS: Gracefully handle QueryInfo errors during open
      CIFS: Force revalidate inode when dentry is stale
      CIFS: Force reval dentry if LOOKUP_REVAL flag is set

Randy Dunlap (1):
      serial: uartlite: fix exit path null pointer

Reinhard Speyerer (1):
      USB: serial: option: add support for Cinterion CLS8 devices

Rick Tseng (1):
      usb: xhci: wait for CNR controller not ready bit in xhci resume

Srivatsa S. Bhat (VMware) (2):
      tracing/hwlat: Report total time spent in all NMIs during the sample
      tracing/hwlat: Don't ignore outer-loop duration when calculating max_=
latency

Steve MacLean (1):
      perf inject jit: Fix JIT_CODE_MOVE filename

Steven Rostedt (VMware) (2):
      ftrace: Get a reference counter for the trace_array on filter files
      tracing: Get trace_array reference for available_tracers files

Trond Myklebust (1):
      NFS: Fix O_DIRECT accounting of number of bytes read/written

Will Deacon (1):
      panic: ensure preemption is disabled during panic()

Yoshihiro Shimoda (2):
      usb: renesas_usbhs: gadget: Do not discard queues in usb_ep_set_{halt=
,wedge}()
      usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2pm04ACgkQONu9yGCS
aT4dIA/+MRqTKG+JUUXgVQ9cMgk6l3T6OAWSr3g1J9dQae/atCOJabvjEjen4Kbi
UUc3GYpd+Wafn807C3S9r2fv/b9lvEmN4HSJVDDfGUm77/mvWWYCy+0Aw4fxI1QY
x1Cfy6/Av8ZtsKlsKooX4co1Jg3+VX0ixjrjrmdnm6/KCgLCWztmLyLKZQzZ74Ix
eAxcT7Is3I+TBWNzAiZMqD1dez0x4ASq0Sk9tJcrL7sxxyJivazXXV0ztr5G+UD3
KZb/oahgafpnpiWuzn0aUEY/EHm8HBTz/0Y+2UJIPfh4l/lEp0GZeSrh1VYxMBl1
kO9ZATjA2aL7+5rIVnwxRkFMP6lV4cxHaWaigc0CqeEfdBHJ10YiCdBnah/4KM1M
M4s5WmEDGqlyMwFWQufbY0NswO//IXC/Mei1vVzYEKe878v9RSlVNb+e6BjKmZF6
jTKTK51tRvKDBLeJwxcrnS1BJ/ZBBS9Ddg5UXdy7bNFilutYgyOmoKBN1JUc/cBr
sl/Br7LAbxnqXatWcNjZ0ukCKfwe+S6I9UjuLG+3XLd0gfaM6JLnYHx1dwLUeBdh
xuS+joOb/K16wxvqV5hkY9+XACLU5qx8O0dq6PPXYMDiI7K0lr3i/jAr9ia6IvkG
o7zFx/mxT0/cFsSS8uubiq8R1d4VQslv3RCmJ898y1sSj70f+VU=
=1YJY
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
