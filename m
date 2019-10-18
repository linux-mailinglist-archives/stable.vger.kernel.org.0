Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885C4DC388
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 13:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407520AbfJRLB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 07:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439248AbfJRLBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 07:01:17 -0400
Received: from localhost (unknown [209.136.236.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D60562064B;
        Fri, 18 Oct 2019 11:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571396476;
        bh=5aGFwVfXczKIvTE5QOUVz6cJuc5DaNKNF0ZHMfxptl8=;
        h=Date:From:To:Cc:Subject:From;
        b=vBvmsv3GrR1nl4Bu39WD91z1M032mfHmje5UrrgqInoFL18BYTGJRykL1coPpcMUv
         i+acdpbDwH4comsXqa4k22jjKIKEwD7STI0Fh5a8AHJU4aGJg5JyMHzqIIzZQQ7w3X
         VA9MojZPu2CpfwPUby3JKl2lPCG/gPNL6hPzXp/E=
Date:   Fri, 18 Oct 2019 04:01:14 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.7
Message-ID: <20191018110114.GA1176597@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.7 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/usb/rio.rst                                   |  109 --
 MAINTAINERS                                                 |    7=20
 Makefile                                                    |    2=20
 arch/arm/configs/badge4_defconfig                           |    1=20
 arch/arm/configs/corgi_defconfig                            |    1=20
 arch/arm/configs/pxa_defconfig                              |    1=20
 arch/arm/configs/s3c2410_defconfig                          |    1=20
 arch/arm/configs/spitz_defconfig                            |    1=20
 arch/arm64/kernel/process.c                                 |   32=20
 arch/arm64/kernel/topology.c                                |   19=20
 arch/mips/configs/mtx1_defconfig                            |    1=20
 arch/mips/configs/rm200_defconfig                           |    1=20
 arch/mips/include/uapi/asm/hwcap.h                          |   11=20
 arch/mips/kernel/cpu-probe.c                                |   33=20
 arch/mips/loongson64/Platform                               |    4=20
 arch/mips/vdso/Makefile                                     |    1=20
 arch/x86/include/asm/mwait.h                                |    2=20
 arch/x86/lib/delay.c                                        |    4=20
 block/blk-rq-qos.c                                          |   14=20
 block/blk-rq-qos.h                                          |    4=20
 block/blk-wbt.c                                             |    6=20
 drivers/acpi/pptt.c                                         |   52 +
 drivers/firmware/efi/efi.c                                  |    3=20
 drivers/firmware/efi/tpm.c                                  |   26=20
 drivers/firmware/google/vpd_decode.c                        |    2=20
 drivers/gpio/gpio-eic-sprd.c                                |    7=20
 drivers/gpio/gpiolib.c                                      |   29=20
 drivers/gpu/drm/i915/display/intel_display.c                |   15=20
 drivers/gpu/drm/i915/gem/i915_gem_mman.c                    |    6=20
 drivers/gpu/drm/i915/gem/i915_gem_pm.c                      |    3=20
 drivers/gpu/drm/i915/gt/intel_workarounds.c                 |    3=20
 drivers/gpu/drm/i915/i915_drv.c                             |    5=20
 drivers/gpu/drm/i915/selftests/i915_gem.c                   |    6=20
 drivers/gpu/drm/msm/msm_gem.c                               |    4=20
 drivers/iio/accel/adxl372.c                                 |   22=20
 drivers/iio/adc/ad799x.c                                    |    4=20
 drivers/iio/adc/axp288_adc.c                                |   32=20
 drivers/iio/adc/hx711.c                                     |   10=20
 drivers/iio/adc/stm32-adc-core.c                            |   70 -
 drivers/iio/adc/stm32-adc-core.h                            |  137 ++
 drivers/iio/adc/stm32-adc.c                                 |  109 --
 drivers/iio/light/opt3001.c                                 |    6=20
 drivers/iio/light/vcnl4000.c                                |   14=20
 drivers/infiniband/core/security.c                          |    2=20
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c               |    2=20
 drivers/media/usb/stkwebcam/stk-webcam.c                    |    3=20
 drivers/misc/mei/bus-fixup.c                                |   14=20
 drivers/misc/mei/hw-me-regs.h                               |    3=20
 drivers/misc/mei/hw-me.c                                    |   21=20
 drivers/misc/mei/hw-me.h                                    |    8=20
 drivers/misc/mei/mei_dev.h                                  |    4=20
 drivers/misc/mei/pci-me.c                                   |   13=20
 drivers/mtd/nand/raw/au1550nd.c                             |    5=20
 drivers/staging/fbtft/Kconfig                               |    2=20
 drivers/staging/fbtft/fbtft-core.c                          |    7=20
 drivers/staging/rtl8188eu/hal/hal8188e_rate_adaptive.c      |    2=20
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c   |    4=20
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c |    1=20
 drivers/staging/vt6655/device_main.c                        |    4=20
 drivers/tty/serial/uartlite.c                               |    3=20
 drivers/tty/serial/xilinx_uartps.c                          |    8=20
 drivers/usb/class/usblp.c                                   |    8=20
 drivers/usb/gadget/udc/dummy_hcd.c                          |    3=20
 drivers/usb/host/xhci-ring.c                                |    4=20
 drivers/usb/host/xhci.c                                     |   78 +
 drivers/usb/image/microtek.c                                |    4=20
 drivers/usb/misc/Kconfig                                    |   10=20
 drivers/usb/misc/Makefile                                   |    1=20
 drivers/usb/misc/adutux.c                                   |   24=20
 drivers/usb/misc/chaoskey.c                                 |    5=20
 drivers/usb/misc/iowarrior.c                                |   16=20
 drivers/usb/misc/ldusb.c                                    |   24=20
 drivers/usb/misc/legousbtower.c                             |   58 -
 drivers/usb/misc/rio500.c                                   |  561 -------=
-----
 drivers/usb/misc/rio500_usb.h                               |   20=20
 drivers/usb/misc/usblcd.c                                   |   33=20
 drivers/usb/misc/yurex.c                                    |   18=20
 drivers/usb/renesas_usbhs/common.h                          |    1=20
 drivers/usb/renesas_usbhs/fifo.c                            |    2=20
 drivers/usb/renesas_usbhs/fifo.h                            |    1=20
 drivers/usb/renesas_usbhs/mod_gadget.c                      |   18=20
 drivers/usb/renesas_usbhs/pipe.c                            |   15=20
 drivers/usb/renesas_usbhs/pipe.h                            |    1=20
 drivers/usb/serial/ftdi_sio.c                               |    3=20
 drivers/usb/serial/ftdi_sio_ids.h                           |    9=20
 drivers/usb/serial/keyspan.c                                |    4=20
 drivers/usb/serial/option.c                                 |   11=20
 drivers/usb/serial/usb-serial.c                             |    5=20
 drivers/usb/typec/tcpm/tcpm.c                               |   14=20
 drivers/usb/typec/ucsi/displayport.c                        |    2=20
 drivers/usb/typec/ucsi/ucsi_ccg.c                           |   42=20
 drivers/usb/usb-skeleton.c                                  |   15=20
 fs/btrfs/file.c                                             |   13=20
 fs/btrfs/inode.c                                            |    3=20
 fs/btrfs/ref-verify.c                                       |    2=20
 fs/btrfs/relocation.c                                       |    9=20
 fs/btrfs/tree-log.c                                         |   36=20
 fs/btrfs/volumes.c                                          |    6=20
 fs/cifs/dir.c                                               |    8=20
 fs/cifs/file.c                                              |   33=20
 fs/cifs/inode.c                                             |    4=20
 fs/io_uring.c                                               |    3=20
 fs/libfs.c                                                  |  134 +-
 fs/nfs/direct.c                                             |   78 -
 include/linux/acpi.h                                        |    5=20
 include/linux/hwmon.h                                       |    2=20
 include/linux/tpm_eventlog.h                                |   16=20
 kernel/fork.c                                               |    4=20
 kernel/panic.c                                              |    1=20
 kernel/trace/ftrace.c                                       |   27=20
 kernel/trace/trace.c                                        |   17=20
 kernel/trace/trace_hwlat.c                                  |    4=20
 mm/page_alloc.c                                             |    8=20
 mm/vmpressure.c                                             |   20=20
 mm/z3fold.c                                                 |   10=20
 security/selinux/ss/services.c                              |    9=20
 tools/perf/util/jitdump.c                                   |    6=20
 tools/perf/util/llvm-utils.c                                |    6=20
 118 files changed, 1115 insertions(+), 1285 deletions(-)

Adit Ranadive (1):
      RDMA/vmw_pvrdma: Free SRQ only once

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

Chris Wilson (2):
      drm/i915: Perform GGTT restore much earlier during resume
      drm/i915: Mark contents as dirty on a write fault

Colin Ian King (1):
      efi/tpm: Fix sanity check of unsigned tbl_size being less than zero

Dan Carpenter (2):
      usb: typec: tcpm: usb: typec: tcpm: Fix a signedness bug in tcpm_fw_g=
et_caps()
      mm/vmpressure.c: fix a signedness bug in vmpressure_register_event()

Daniele Palmas (1):
      USB: serial: option: add Telit FN980 compositions

Dave Wysochanski (1):
      cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a pa=
nic

David Frey (1):
      iio: light: opt3001: fix mutex unlock race

Denis Efremov (1):
      staging: rtl8188eu: fix HighestRate check in odm_ARFBRefresh_8188E()

Fabrice Gasnier (2):
      iio: adc: stm32-adc: move registers definitions
      iio: adc: stm32-adc: fix a race when using several adcs with dma and =
irq

Filipe Manana (1):
      Btrfs: fix memory leak due to concurrent append writes with fiemap

Greg Kroah-Hartman (1):
      Linux 5.3.7

Hans de Goede (1):
      iio: adc: axp288: Override TS pin bias current for some models

Harshad Shirwadkar (1):
      blk-wbt: fix performance regression in wbt scale_up/scale_down

Heikki Krogerus (2):
      usb: typec: ucsi: ccg: Remove run_isr flag
      usb: typec: ucsi: displayport: Fix for the mode entering routine

Ian Rogers (1):
      perf llvm: Don't access out-of-scope array

Jacky.Cao@sony.com (1):
      USB: dummy-hcd: fix power budget for SuperSpeed mode

Jan Schmidt (1):
      xhci: Check all endpoints for LPM timeout

Janakarajan Natarajan (1):
      x86/asm: Fix MWAITX C-state hint value

Jens Axboe (1):
      io_uring: only flush workqueues on fileset removal

Jeremy Linton (2):
      ACPI/PPTT: Add support for ACPI 6.3 thread flag
      arm64: topology: Use PPTT to determine if PE is a thread

Jerry Snitselaar (1):
      efi/tpm: Only set 'efi_tpm_final_log_size' after successful event log=
 parsing

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

Josef Bacik (3):
      btrfs: allocate new inode in NOFS context
      btrfs: fix incorrect updating of log root tree
      btrfs: fix uninitialized ret in ref-verify

Kai-Heng Feng (1):
      xhci: Increase STS_SAVE timeout in xhci_suspend()

Kenneth Graunke (1):
      drm/i915: Whitelist COMMON_SLICE_CHICKEN2

Marco Felsch (4):
      iio: adc: ad799x: fix probe error handling
      iio: light: add missing vcnl4040 of_compatible
      gpio: fix getting nonexclusive gpiods from DT
      iio: light: fix vcnl4000 devicetree hooks

Masayoshi Mizuma (1):
      arm64/sve: Fix wrong free for task->thread.sve_state

Mathias Nyman (4):
      xhci: Fix false warning message about wrong bounce buffer write length
      xhci: Prevent device initiated U1/U2 link pm if exit latency is too l=
ong
      xhci: Fix USB 3.1 capability detection on early xHCI 1.1 spec based h=
osts
      xhci: Fix NULL pointer dereference in xhci_clear_tt_buffer_complete()

Michal Hocko (1):
      kernel/sysctl.c: do not override max_threads provided by userspace

Michal Simek (1):
      serial: uartps: Fix uartps_major handling

Mohamad Heib (1):
      IB/core: Fix wrong iterating on ports

Navid Emamdoost (2):
      Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc
      staging: vt6655: Fix memory leak in vt6655_probe

Noralf Tr=F8nnes (1):
      staging/fbtft: Depend on OF

Nuno S=E1 (1):
      hwmon: Fix HWMON_P_MIN_ALARM mask

Ondrej Mosnacek (1):
      selinux: fix context string corruption in convert_context()

Paul Burton (2):
      MIPS: Disable Loongson MMI instructions for kernel build
      mtd: rawnand: au1550nd: Fix au_read_buf16() prototype

Pavel Shilovsky (3):
      CIFS: Gracefully handle QueryInfo errors during open
      CIFS: Force revalidate inode when dentry is stale
      CIFS: Force reval dentry if LOOKUP_REVAL flag is set

Peter Jones (2):
      efi/tpm: Don't access event->count when it isn't mapped
      efi/tpm: Don't traverse an event log with no events

Qian Cai (1):
      mm/page_alloc.c: fix a crash in free_pages_prepare()

Qu Wenruo (1):
      btrfs: relocation: fix use-after-free on dead relocation roots

Randy Dunlap (1):
      serial: uartlite: fix exit path null pointer

Reinhard Speyerer (1):
      USB: serial: option: add support for Cinterion CLS8 devices

Rick Tseng (1):
      usb: xhci: wait for CNR controller not ready bit in xhci resume

Rob Clark (1):
      drm/msm: Use the correct dma_sync calls harder

Srivatsa S. Bhat (VMware) (2):
      tracing/hwlat: Report total time spent in all NMIs during the sample
      tracing/hwlat: Don't ignore outer-loop duration when calculating max_=
latency

Stefan Popa (3):
      iio: accel: adxl372: Fix/remove limitation for FIFO samples
      iio: accel: adxl372: Fix push to buffers lost samples
      iio: accel: adxl372: Perform a reset at start up

Steve MacLean (1):
      perf inject jit: Fix JIT_CODE_MOVE filename

Steven Rostedt (VMware) (2):
      ftrace: Get a reference counter for the trace_array on filter files
      tracing: Get trace_array reference for available_tracers files

Takashi Iwai (1):
      staging: bcm2835-audio: Fix draining behavior regression

Tomas Winkler (1):
      mei: me: add comet point (lake) LP device ids

Trond Myklebust (1):
      NFS: Fix O_DIRECT accounting of number of bytes read/written

Ville Syrj=E4l=E4 (1):
      drm/i915: Bump skl+ max plane width to 5k for linear/x-tiled

Vitaly Wool (1):
      mm/z3fold.c: claim page in the beginning of free

Will Deacon (1):
      panic: ensure preemption is disabled during panic()

Yoshihiro Shimoda (2):
      usb: renesas_usbhs: gadget: Do not discard queues in usb_ep_set_{halt=
,wedge}()
      usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior

Zygo Blaxell (1):
      btrfs: fix balance convert to single on 32-bit host CPUs


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2pm3oACgkQONu9yGCS
aT6VWg//X6RZYGUf3vSgujEDIJteBEl0/jqijLtmRQV/3geieK1hLMQcIb/F8b9q
JTWvZtxnNpxstC0JYgcfUMLsAGY4owhBi0mVsfSTcFEmXLnE43babEru4JP1Rqwv
bs6lCAbN0j9xWimHIt6ozHSJU0v/HEAA9RZChK2ihoq3KQdTfUK0CPjJUQPuscNS
wOQmF9oJrlEXn56wcxdJmJjJsXNSEYW5aKBnixcKbjXh3PqEVwlTKFcxWfCVNyF6
mkk8I6E3cO7njosACnNuZqP9+d3PMggxSgAPlhAMV0dRM2Pos6NHSmLCr6YgeotA
AThjYcKqoFzEAMWOlNIeaeOGubUK+aj2zJbZxd+SBAiWSa0JXC7+usmUZe2q7/2t
Xc4h8hd8zHo94UrOSNugNtJmNXAQBcPiRQoItWWXigcF2MzBk3suwcoU+P62ugNq
CDzCt2J42Brj2j18l0UMY4ulM3hNVu4gQ4I0mw33/dyl6vhasMU8ZcEuKvaPk0KY
KM8G1rbq4iCjn0eWQ5h7nKpXWR5SgCVNDTMbiLw3hWKCyCxiTJSykeO0o1uFGSNm
3PN4M+Azd1VeMZFfaj+ip/9RtLOnMCqJXXcqsdprSW8aA06K0lY6jH9oq+C6Oxdd
3c5NZDZ6hcvBCy90QSXaPkRlQx5WGwCPy7Z9pj0oRGzbTf39gIs=
=PzqS
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
