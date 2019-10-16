Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B1CD9E11
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406611AbfJPV4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406603AbfJPV4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:15 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12AAB21928;
        Wed, 16 Oct 2019 21:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262975;
        bh=1wRhUPX/YB9BZt4tha0c6Pz1MO4vlrr1JZilj1NUghY=;
        h=From:To:Cc:Subject:Date:From;
        b=HozqOSuQ9RTaKb6TVOpQHES5LvtBqej4h8LQ1NE+oMSYfMtsYGGWClZ56P52HhtSe
         n8Ae/XxAkzcwj/zyJns+r0KF3+/41kQMy9tMFgLWORwN68KwP9k2EzuKxx+cSdoeXN
         9Hi+/E/Sg5X3m8Ia1mRLnnqhwzuhC5nujKgMCFYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/65] 4.14.150-stable review
Date:   Wed, 16 Oct 2019 14:50:14 -0700
Message-Id: <20191016214756.457746573@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.150-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.150-rc1
X-KernelTest-Deadline: 2019-10-18T21:48+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.150 release.
There are 65 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.150-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.150-rc1

Dave Chinner <dchinner@redhat.com>
    xfs: clear sb->s_fs_info on mount failure

Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
    x86/asm: Fix MWAITX C-state hint value

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Get trace_array reference for available_tracers files

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Get a reference counter for the trace_array on filter files

Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
    tracing/hwlat: Don't ignore outer-loop duration when calculating max_latency

Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
    tracing/hwlat: Report total time spent in all NMIs during the sample

Johan Hovold <johan@kernel.org>
    media: stkwebcam: fix runtime PM after driver unbind

Al Viro <viro@zeniv.linux.org.uk>
    Fix the locking in dcache_readdir() and friends

Paul Burton <paul.burton@mips.com>
    MIPS: Disable Loongson MMI instructions for kernel build

Trond Myklebust <trondmy@gmail.com>
    NFS: Fix O_DIRECT accounting of number of bytes read/written

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix incorrect updating of log root tree

Andreas Klinger <ak@it-klinger.de>
    iio: adc: hx711: fix bug in sampling of data

Andreas Klinger <ak@it-klinger.de>
    iio: hx711: add delay until DOUT is ready

Navid Emamdoost <navid.emamdoost@gmail.com>
    Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpiolib: don't clear FLAG_IS_OUT when emulating open-drain/open-source

Brian Norris <briannorris@chromium.org>
    firmware: google: increment VPD key_len properly

Michal Hocko <mhocko@suse.com>
    kernel/sysctl.c: do not override max_threads provided by userspace

Pavel Shilovsky <piastryyy@gmail.com>
    CIFS: Force reval dentry if LOOKUP_REVAL flag is set

Pavel Shilovsky <piastryyy@gmail.com>
    CIFS: Force revalidate inode when dentry is stale

Pavel Shilovsky <piastryyy@gmail.com>
    CIFS: Gracefully handle QueryInfo errors during open

Steve MacLean <Steve.MacLean@microsoft.com>
    perf inject jit: Fix JIT_CODE_MOVE filename

Ian Rogers <irogers@google.com>
    perf llvm: Don't access out-of-scope array

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    efivar/ssdt: Don't iterate over EFI vars if no SSDT override was specified

David Frey <dpfrey@gmail.com>
    iio: light: opt3001: fix mutex unlock race

Hans de Goede <hdegoede@redhat.com>
    iio: adc: axp288: Override TS pin bias current for some models

Marco Felsch <m.felsch@pengutronix.de>
    iio: adc: ad799x: fix probe error handling

Navid Emamdoost <navid.emamdoost@gmail.com>
    staging: vt6655: Fix memory leak in vt6655_probe

Johan Hovold <johan@kernel.org>
    USB: legousbtower: fix use-after-free on release

Johan Hovold <johan@kernel.org>
    USB: legousbtower: fix open after failed reset request

Johan Hovold <johan@kernel.org>
    USB: legousbtower: fix potential NULL-deref on disconnect

Johan Hovold <johan@kernel.org>
    USB: legousbtower: fix deadlock on disconnect

Johan Hovold <johan@kernel.org>
    USB: legousbtower: fix slab info leak at probe

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: gadget: Do not discard queues in usb_ep_set_{halt,wedge}()

Jacky.Cao@sony.com <Jacky.Cao@sony.com>
    USB: dummy-hcd: fix power budget for SuperSpeed mode

Johan Hovold <johan@kernel.org>
    USB: microtek: fix info-leak at probe

Johan Hovold <johan@kernel.org>
    USB: usblcd: fix I/O after disconnect

Johan Hovold <johan@kernel.org>
    USB: serial: fix runtime PM after driver unbind

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add support for Cinterion CLS8 devices

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN980 compositions

Beni Mahler <beni.mahler@gmx.net>
    USB: serial: ftdi_sio: add device IDs for Sienna and Echelon PL-20

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan: fix NULL-derefs on open() and write()

Randy Dunlap <rdunlap@infradead.org>
    serial: uartlite: fix exit path null pointer

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix NULL-derefs on driver unbind

Johan Hovold <johan@kernel.org>
    USB: chaoskey: fix use-after-free on release

Johan Hovold <johan@kernel.org>
    USB: usblp: fix runtime PM after driver unbind

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix use-after-free after driver unbind

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix use-after-free on release

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix use-after-free on disconnect

Johan Hovold <johan@kernel.org>
    USB: adutux: fix use-after-free on release

Johan Hovold <johan@kernel.org>
    USB: adutux: fix NULL-derefs on disconnect

Johan Hovold <johan@kernel.org>
    USB: adutux: fix use-after-free on disconnect

Colin Ian King <colin.king@canonical.com>
    USB: adutux: remove redundant variable minor

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Increase STS_SAVE timeout in xhci_suspend()

Rick Tseng <rtseng@nvidia.com>
    usb: xhci: wait for CNR controller not ready bit in xhci resume

Jan Schmidt <jan@centricular.com>
    xhci: Check all endpoints for LPM timeout

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent device initiated U1/U2 link pm if exit latency is too long

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix false warning message about wrong bounce buffer write length

Johan Hovold <johan@kernel.org>
    USB: usb-skeleton: fix NULL-deref on disconnect

Johan Hovold <johan@kernel.org>
    USB: usb-skeleton: fix runtime PM after driver unbind

Johan Hovold <johan@kernel.org>
    USB: yurex: fix NULL-derefs on disconnect

Alan Stern <stern@rowland.harvard.edu>
    USB: yurex: Don't retry on unexpected errors

Bastien Nocera <hadess@hadess.net>
    USB: rio500: Remove Rio 500 kernel driver

Icenowy Zheng <icenowy@aosc.io>
    f2fs: use EINVAL for superblock with invalid magic

Will Deacon <will@kernel.org>
    panic: ensure preemption is disabled during panic()


-------------

Diffstat:

 Documentation/usb/rio.txt                | 138 --------
 MAINTAINERS                              |   7 -
 Makefile                                 |   4 +-
 arch/arm/configs/badge4_defconfig        |   1 -
 arch/arm/configs/corgi_defconfig         |   1 -
 arch/arm/configs/pxa_defconfig           |   1 -
 arch/arm/configs/s3c2410_defconfig       |   1 -
 arch/arm/configs/spitz_defconfig         |   1 -
 arch/mips/configs/mtx1_defconfig         |   1 -
 arch/mips/configs/rm200_defconfig        |   1 -
 arch/mips/loongson64/Platform            |   4 +
 arch/mips/vdso/Makefile                  |   1 +
 arch/x86/include/asm/mwait.h             |   2 +-
 arch/x86/lib/delay.c                     |   4 +-
 drivers/firmware/efi/efi.c               |   3 +
 drivers/firmware/google/vpd_decode.c     |   2 +-
 drivers/gpio/gpiolib.c                   |  27 +-
 drivers/iio/adc/ad799x.c                 |   4 +-
 drivers/iio/adc/axp288_adc.c             |  32 ++
 drivers/iio/adc/hx711.c                  |  49 ++-
 drivers/iio/light/opt3001.c              |   6 +-
 drivers/media/usb/stkwebcam/stk-webcam.c |   3 +-
 drivers/staging/fbtft/fbtft-core.c       |   7 +-
 drivers/staging/vt6655/device_main.c     |   4 +-
 drivers/tty/serial/uartlite.c            |   3 +-
 drivers/usb/class/usblp.c                |   8 +-
 drivers/usb/gadget/udc/dummy_hcd.c       |   3 +-
 drivers/usb/host/xhci-ring.c             |   4 +-
 drivers/usb/host/xhci.c                  |  32 +-
 drivers/usb/image/microtek.c             |   4 +
 drivers/usb/misc/Kconfig                 |  10 -
 drivers/usb/misc/Makefile                |   1 -
 drivers/usb/misc/adutux.c                |  26 +-
 drivers/usb/misc/chaoskey.c              |   5 +-
 drivers/usb/misc/iowarrior.c             |  16 +-
 drivers/usb/misc/ldusb.c                 |  24 +-
 drivers/usb/misc/legousbtower.c          |  58 ++--
 drivers/usb/misc/rio500.c                | 574 -------------------------------
 drivers/usb/misc/rio500_usb.h            |  37 --
 drivers/usb/misc/usblcd.c                |  33 +-
 drivers/usb/misc/yurex.c                 |  18 +-
 drivers/usb/renesas_usbhs/common.h       |   1 +
 drivers/usb/renesas_usbhs/fifo.c         |   2 +-
 drivers/usb/renesas_usbhs/fifo.h         |   1 +
 drivers/usb/renesas_usbhs/mod_gadget.c   |  18 +-
 drivers/usb/renesas_usbhs/pipe.c         |  15 +
 drivers/usb/renesas_usbhs/pipe.h         |   1 +
 drivers/usb/serial/ftdi_sio.c            |   3 +
 drivers/usb/serial/ftdi_sio_ids.h        |   9 +
 drivers/usb/serial/keyspan.c             |   4 +-
 drivers/usb/serial/option.c              |  11 +
 drivers/usb/serial/usb-serial.c          |   5 +-
 drivers/usb/usb-skeleton.c               |  15 +-
 fs/btrfs/tree-log.c                      |  36 +-
 fs/cifs/dir.c                            |   8 +-
 fs/cifs/file.c                           |   6 +
 fs/cifs/inode.c                          |   4 +
 fs/f2fs/super.c                          |  36 +-
 fs/libfs.c                               | 134 ++++----
 fs/nfs/direct.c                          |  78 +++--
 fs/xfs/xfs_super.c                       |  10 +
 kernel/fork.c                            |   4 +-
 kernel/panic.c                           |   1 +
 kernel/trace/ftrace.c                    |  27 +-
 kernel/trace/trace.c                     |  17 +-
 kernel/trace/trace_hwlat.c               |   4 +-
 tools/perf/util/jitdump.c                |   6 +-
 tools/perf/util/llvm-utils.c             |   6 +-
 68 files changed, 567 insertions(+), 1055 deletions(-)


