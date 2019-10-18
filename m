Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828E8DC36A
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 13:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633595AbfJRLAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 07:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633582AbfJRLAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 07:00:55 -0400
Received: from localhost (unknown [209.136.236.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FBE42064B;
        Fri, 18 Oct 2019 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571396453;
        bh=Ghgtdz7/hgGhtdlLqYQd41AwDvEFzT4L+s5fNS241LI=;
        h=Date:From:To:Cc:Subject:From;
        b=n94kyabe0AnRoEp31hsBImjRnHvi9avgYupgbweUP9RhZ/2BY7RVAmbbL9r/V/oo1
         srLOCckbDzqKjC2dy3R+aRORMwq+9rzsB34vL3XD1yPjYPTh4JJlu9ds0H425+weWi
         ImZVFmtHpdgzjBO9i9NmeplEZncAneBdnew6Biz4=
Date:   Fri, 18 Oct 2019 04:00:52 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.80
Message-ID: <20191018110052.GA1176506@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.80 kernel.

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

 Documentation/usb/rio.txt                |  138 -------
 MAINTAINERS                              |    7=20
 Makefile                                 |    2=20
 arch/arm/configs/badge4_defconfig        |    1=20
 arch/arm/configs/corgi_defconfig         |    1=20
 arch/arm/configs/pxa_defconfig           |    1=20
 arch/arm/configs/s3c2410_defconfig       |    1=20
 arch/arm/configs/spitz_defconfig         |    1=20
 arch/arm64/kernel/process.c              |   32 -
 arch/arm64/kernel/topology.c             |   19 -
 arch/mips/configs/mtx1_defconfig         |    1=20
 arch/mips/configs/rm200_defconfig        |    1=20
 arch/mips/include/uapi/asm/hwcap.h       |   11=20
 arch/mips/kernel/cpu-probe.c             |   33 +
 arch/mips/loongson64/Platform            |    4=20
 arch/mips/vdso/Makefile                  |    1=20
 arch/x86/include/asm/mwait.h             |    2=20
 arch/x86/lib/delay.c                     |    4=20
 block/blk-rq-qos.c                       |   14=20
 block/blk-rq-qos.h                       |    4=20
 block/blk-wbt.c                          |    6=20
 drivers/acpi/pptt.c                      |   52 ++
 drivers/firmware/efi/efi.c               |    3=20
 drivers/firmware/google/vpd_decode.c     |    2=20
 drivers/gpio/gpio-eic-sprd.c             |    7=20
 drivers/gpio/gpiolib.c                   |   27 +
 drivers/iio/adc/ad799x.c                 |    4=20
 drivers/iio/adc/axp288_adc.c             |   32 +
 drivers/iio/adc/hx711.c                  |   10=20
 drivers/iio/adc/stm32-adc-core.c         |   70 ++-
 drivers/iio/adc/stm32-adc-core.h         |  137 +++++++
 drivers/iio/adc/stm32-adc.c              |  109 ------
 drivers/iio/light/opt3001.c              |    6=20
 drivers/media/usb/stkwebcam/stk-webcam.c |    3=20
 drivers/misc/mei/bus-fixup.c             |   14=20
 drivers/misc/mei/hw-me-regs.h            |    3=20
 drivers/misc/mei/hw-me.c                 |   21 -
 drivers/misc/mei/hw-me.h                 |    8=20
 drivers/misc/mei/mei_dev.h               |    4=20
 drivers/misc/mei/pci-me.c                |   13=20
 drivers/pci/controller/vmd.c             |   16=20
 drivers/staging/fbtft/fbtft-core.c       |    7=20
 drivers/staging/vt6655/device_main.c     |    4=20
 drivers/tty/serial/uartlite.c            |    3=20
 drivers/usb/class/usblp.c                |    8=20
 drivers/usb/gadget/udc/dummy_hcd.c       |    3=20
 drivers/usb/host/xhci-ring.c             |    4=20
 drivers/usb/host/xhci.c                  |   70 +++
 drivers/usb/image/microtek.c             |    4=20
 drivers/usb/misc/Kconfig                 |   10=20
 drivers/usb/misc/Makefile                |    1=20
 drivers/usb/misc/adutux.c                |   24 -
 drivers/usb/misc/chaoskey.c              |    5=20
 drivers/usb/misc/iowarrior.c             |   16=20
 drivers/usb/misc/ldusb.c                 |   24 -
 drivers/usb/misc/legousbtower.c          |   58 +--
 drivers/usb/misc/rio500.c                |  561 --------------------------=
-----
 drivers/usb/misc/rio500_usb.h            |   20 -
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
 fs/btrfs/ref-verify.c                    |    2=20
 fs/btrfs/tree-log.c                      |   36 +
 fs/cifs/dir.c                            |    8=20
 fs/cifs/file.c                           |   33 -
 fs/cifs/inode.c                          |    4=20
 fs/f2fs/super.c                          |   36 -
 fs/libfs.c                               |  134 +++----
 fs/nfs/direct.c                          |   78 ++--
 include/acpi/actbl2.h                    |    7=20
 include/linux/acpi.h                     |    5=20
 include/linux/hwmon.h                    |    2=20
 kernel/events/hw_breakpoint.c            |    4=20
 kernel/fork.c                            |    4=20
 kernel/panic.c                           |    1=20
 kernel/trace/ftrace.c                    |   27 -
 kernel/trace/trace.c                     |   17=20
 kernel/trace/trace_hwlat.c               |    4=20
 mm/vmpressure.c                          |   20 -
 tools/perf/util/jitdump.c                |    6=20
 tools/perf/util/llvm-utils.c             |    6=20
 92 files changed, 966 insertions(+), 1251 deletions(-)

Al Viro (1):
      Fix the locking in dcache_readdir() and friends

Alan Stern (1):
      USB: yurex: Don't retry on unexpected errors

Alexander Usyskin (1):
      mei: avoid FW version request on Ibex Peak and earlier

Andreas Klinger (1):
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

Bill Kuzeja (1):
      xhci: Prevent deadlock when xhci adapter breaks during init

Brian Norris (1):
      firmware: google: increment VPD key_len properly

Bruce Chen (1):
      gpio: eic: sprd: Fix the incorrect EIC offset when toggling

Dan Carpenter (1):
      mm/vmpressure.c: fix a signedness bug in vmpressure_register_event()

Daniele Palmas (1):
      USB: serial: option: add Telit FN980 compositions

Dave Wysochanski (1):
      cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a pa=
nic

David Frey (1):
      iio: light: opt3001: fix mutex unlock race

Erik Schmauss (1):
      ACPICA: ACPI 6.3: PPTT add additional fields in Processor Structure F=
lags

Fabrice Gasnier (2):
      iio: adc: stm32-adc: move registers definitions
      iio: adc: stm32-adc: fix a race when using several adcs with dma and =
irq

Greg Kroah-Hartman (1):
      Linux 4.19.80

Hans de Goede (1):
      iio: adc: axp288: Override TS pin bias current for some models

Harshad Shirwadkar (1):
      blk-wbt: fix performance regression in wbt scale_up/scale_down

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

Jeremy Linton (2):
      ACPI/PPTT: Add support for ACPI 6.3 thread flag
      arm64: topology: Use PPTT to determine if PE is a thread

Jiaxun Yang (1):
      MIPS: elf_hwcap: Export userspace ASEs

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

Jon Derrick (1):
      PCI: vmd: Fix config addressing when using bus offsets

Josef Bacik (2):
      btrfs: fix incorrect updating of log root tree
      btrfs: fix uninitialized ret in ref-verify

Kai-Heng Feng (1):
      xhci: Increase STS_SAVE timeout in xhci_suspend()

Marco Felsch (1):
      iio: adc: ad799x: fix probe error handling

Mark-PK Tsai (1):
      perf/hw_breakpoint: Fix arch_hw_breakpoint use-before-initialization

Masayoshi Mizuma (1):
      arm64/sve: Fix wrong free for task->thread.sve_state

Mathias Nyman (3):
      xhci: Fix false warning message about wrong bounce buffer write length
      xhci: Prevent device initiated U1/U2 link pm if exit latency is too l=
ong
      xhci: Fix USB 3.1 capability detection on early xHCI 1.1 spec based h=
osts

Michal Hocko (1):
      kernel/sysctl.c: do not override max_threads provided by userspace

Navid Emamdoost (2):
      Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc
      staging: vt6655: Fix memory leak in vt6655_probe

Nuno S=E1 (1):
      hwmon: Fix HWMON_P_MIN_ALARM mask

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

Tomas Winkler (1):
      mei: me: add comet point (lake) LP device ids

Trond Myklebust (1):
      NFS: Fix O_DIRECT accounting of number of bytes read/written

Will Deacon (1):
      panic: ensure preemption is disabled during panic()

Yoshihiro Shimoda (2):
      usb: renesas_usbhs: gadget: Do not discard queues in usb_ep_set_{halt=
,wedge}()
      usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2pm2QACgkQONu9yGCS
aT52hRAAzfpXj3FcJ6yXaM6FW84Zlf9FZkWZ80lwnHina/FshwDwc7wJu6QSJpkz
v/LiioKYTTA1j564DnNVZ92e2xsPxK/emn5OIebZIwA+QwhpYo2JFvsEa+WsMy/c
qgaotjN/TgpRG5bTeVA0LFwIOAsfyj0Ae6GL45bFDbBJzy9I+5RcEdAJ+lOe3HXa
LTD+yL0G7tNaZgetWedt7R4A6MUm/oJvQwy7tsxRhJw5JQOF+gfZ73peSvQkZ6xu
A7poUC3vhiAUgCmRsxhCzdwPCPAIz9njEQBFMLSjvddTHZDK56FPD5U3NQiK0Wy7
mwrfHtYMzi/pfpGgN1WWEHKsGU0E8CBJSWd2pyMpAgcm6dOMtvw50sqDrNDy7grp
4/eM1mZ+x522Hae/eur5TcDLRPl8YX+5PROQQYr32jBfp+NwbDv5N8u3sesGYj+I
uF4HeXXK1lmmYHJdrMC1p9DhWGiVDYMhQEoCD7gKWqRqYurVf9/yPDg73GSZR82f
prfrHzy8c1H9iZ8JYfpM7t1h+USyrC2jAaqC57VjDCNeki+W/rj5//QF3IDd8Aae
NNgaktsmlkmElnIDbf1RISpsS2Za5iJiP10/ZNhQWkoKndF0+hqVVgf2RZdwuERu
20Oh5hz0Z+Pk+yatrTxwzNhCEAExydU7fPDd9YEl5EmHdgBALfA=
=MWv/
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
