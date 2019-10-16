Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58ED6DA04C
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388047AbfJPWKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437990AbfJPV5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:20 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F931218DE;
        Wed, 16 Oct 2019 21:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263040;
        bh=TnigRd3YWHCHpzaAyPktopl8n+Y+EA2r4ErhDpP4VzU=;
        h=From:To:Cc:Subject:Date:From;
        b=IrEijvzL82QEz234kbb4x1TLbEoBxhTDBnsdvtek6RrTYTGpbXjVNLHMH0ruJe3xw
         GhSY2NczE8Eo4Ul0U3h1Jf3P27/WlqkoaLEF8o6n1HOyaj4a1K6Ku8rVwMTeBxbtrV
         MmluWKw6sv7vUoIbLGQTdV+OLl9bWFJGNJPgg4k4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/81] 4.19.80-stable review
Date:   Wed, 16 Oct 2019 14:50:11 -0700
Message-Id: <20191016214805.727399379@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.80-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.80-rc1
X-KernelTest-Deadline: 2019-10-18T21:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.80 release.
There are 81 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.80-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.80-rc1

Mark-PK Tsai <mark-pk.tsai@mediatek.com>
    perf/hw_breakpoint: Fix arch_hw_breakpoint use-before-initialization

Jon Derrick <jonathan.derrick@intel.com>
    PCI: vmd: Fix config addressing when using bus offsets

Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
    x86/asm: Fix MWAITX C-state hint value

Nuno Sá <nuno.sa@analog.com>
    hwmon: Fix HWMON_P_MIN_ALARM mask

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Get trace_array reference for available_tracers files

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Get a reference counter for the trace_array on filter files

Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
    tracing/hwlat: Don't ignore outer-loop duration when calculating max_latency

Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
    tracing/hwlat: Report total time spent in all NMIs during the sample

Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
    arm64/sve: Fix wrong free for task->thread.sve_state

Johan Hovold <johan@kernel.org>
    media: stkwebcam: fix runtime PM after driver unbind

Al Viro <viro@zeniv.linux.org.uk>
    Fix the locking in dcache_readdir() and friends

Jeremy Linton <jeremy.linton@arm.com>
    arm64: topology: Use PPTT to determine if PE is a thread

Jeremy Linton <jeremy.linton@arm.com>
    ACPI/PPTT: Add support for ACPI 6.3 thread flag

Erik Schmauss <erik.schmauss@intel.com>
    ACPICA: ACPI 6.3: PPTT add additional fields in Processor Structure Flags

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: elf_hwcap: Export userspace ASEs

Paul Burton <paul.burton@mips.com>
    MIPS: Disable Loongson MMI instructions for kernel build

Trond Myklebust <trondmy@gmail.com>
    NFS: Fix O_DIRECT accounting of number of bytes read/written

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix uninitialized ret in ref-verify

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix incorrect updating of log root tree

Dave Wysochanski <dwysocha@redhat.com>
    cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a panic

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: fix a race when using several adcs with dma and irq

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: move registers definitions

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpiolib: don't clear FLAG_IS_OUT when emulating open-drain/open-source

Brian Norris <briannorris@chromium.org>
    firmware: google: increment VPD key_len properly

Dan Carpenter <dan.carpenter@oracle.com>
    mm/vmpressure.c: fix a signedness bug in vmpressure_register_event()

Michal Hocko <mhocko@suse.com>
    kernel/sysctl.c: do not override max_threads provided by userspace

Pavel Shilovsky <piastryyy@gmail.com>
    CIFS: Force reval dentry if LOOKUP_REVAL flag is set

Pavel Shilovsky <piastryyy@gmail.com>
    CIFS: Force revalidate inode when dentry is stale

Pavel Shilovsky <piastryyy@gmail.com>
    CIFS: Gracefully handle QueryInfo errors during open

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    blk-wbt: fix performance regression in wbt scale_up/scale_down

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

Andreas Klinger <ak@it-klinger.de>
    iio: adc: hx711: fix bug in sampling of data

Navid Emamdoost <navid.emamdoost@gmail.com>
    staging: vt6655: Fix memory leak in vt6655_probe

Navid Emamdoost <navid.emamdoost@gmail.com>
    Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc

Bruce Chen <bruce.chen@unisoc.com>
    gpio: eic: sprd: Fix the incorrect EIC offset when toggling

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: avoid FW version request on Ibex Peak and earlier

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add comet point (lake) LP device ids

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

Kai-Heng Feng <kai.heng.feng@canonical.com>
    xhci: Increase STS_SAVE timeout in xhci_suspend()

Bill Kuzeja <William.Kuzeja@stratus.com>
    xhci: Prevent deadlock when xhci adapter breaks during init

Rick Tseng <rtseng@nvidia.com>
    usb: xhci: wait for CNR controller not ready bit in xhci resume

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix USB 3.1 capability detection on early xHCI 1.1 spec based hosts

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
 arch/arm64/kernel/process.c              |  32 +-
 arch/arm64/kernel/topology.c             |  19 +-
 arch/mips/configs/mtx1_defconfig         |   1 -
 arch/mips/configs/rm200_defconfig        |   1 -
 arch/mips/include/uapi/asm/hwcap.h       |  11 +
 arch/mips/kernel/cpu-probe.c             |  33 ++
 arch/mips/loongson64/Platform            |   4 +
 arch/mips/vdso/Makefile                  |   1 +
 arch/x86/include/asm/mwait.h             |   2 +-
 arch/x86/lib/delay.c                     |   4 +-
 block/blk-rq-qos.c                       |  14 +-
 block/blk-rq-qos.h                       |   4 +-
 block/blk-wbt.c                          |   6 +-
 drivers/acpi/pptt.c                      |  52 +++
 drivers/firmware/efi/efi.c               |   3 +
 drivers/firmware/google/vpd_decode.c     |   2 +-
 drivers/gpio/gpio-eic-sprd.c             |   7 +-
 drivers/gpio/gpiolib.c                   |  27 +-
 drivers/iio/adc/ad799x.c                 |   4 +-
 drivers/iio/adc/axp288_adc.c             |  32 ++
 drivers/iio/adc/hx711.c                  |  10 +-
 drivers/iio/adc/stm32-adc-core.c         |  70 ++--
 drivers/iio/adc/stm32-adc-core.h         | 137 ++++++++
 drivers/iio/adc/stm32-adc.c              | 109 ------
 drivers/iio/light/opt3001.c              |   6 +-
 drivers/media/usb/stkwebcam/stk-webcam.c |   3 +-
 drivers/misc/mei/bus-fixup.c             |  14 +-
 drivers/misc/mei/hw-me-regs.h            |   3 +
 drivers/misc/mei/hw-me.c                 |  21 +-
 drivers/misc/mei/hw-me.h                 |   8 +-
 drivers/misc/mei/mei_dev.h               |   4 +
 drivers/misc/mei/pci-me.c                |  13 +-
 drivers/pci/controller/vmd.c             |  16 +-
 drivers/staging/fbtft/fbtft-core.c       |   7 +-
 drivers/staging/vt6655/device_main.c     |   4 +-
 drivers/tty/serial/uartlite.c            |   3 +-
 drivers/usb/class/usblp.c                |   8 +-
 drivers/usb/gadget/udc/dummy_hcd.c       |   3 +-
 drivers/usb/host/xhci-ring.c             |   4 +-
 drivers/usb/host/xhci.c                  |  70 +++-
 drivers/usb/image/microtek.c             |   4 +
 drivers/usb/misc/Kconfig                 |  10 -
 drivers/usb/misc/Makefile                |   1 -
 drivers/usb/misc/adutux.c                |  24 +-
 drivers/usb/misc/chaoskey.c              |   5 +-
 drivers/usb/misc/iowarrior.c             |  16 +-
 drivers/usb/misc/ldusb.c                 |  24 +-
 drivers/usb/misc/legousbtower.c          |  58 ++--
 drivers/usb/misc/rio500.c                | 561 -------------------------------
 drivers/usb/misc/rio500_usb.h            |  20 --
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
 fs/btrfs/ref-verify.c                    |   2 +-
 fs/btrfs/tree-log.c                      |  36 +-
 fs/cifs/dir.c                            |   8 +-
 fs/cifs/file.c                           |  33 +-
 fs/cifs/inode.c                          |   4 +
 fs/f2fs/super.c                          |  36 +-
 fs/libfs.c                               | 134 ++++----
 fs/nfs/direct.c                          |  78 +++--
 include/acpi/actbl2.h                    |   7 +-
 include/linux/acpi.h                     |   5 +
 include/linux/hwmon.h                    |   2 +-
 kernel/events/hw_breakpoint.c            |   4 +-
 kernel/fork.c                            |   4 +-
 kernel/panic.c                           |   1 +
 kernel/trace/ftrace.c                    |  27 +-
 kernel/trace/trace.c                     |  17 +-
 kernel/trace/trace_hwlat.c               |   4 +-
 mm/vmpressure.c                          |  20 +-
 tools/perf/util/jitdump.c                |   6 +-
 tools/perf/util/llvm-utils.c             |   6 +-
 92 files changed, 967 insertions(+), 1252 deletions(-)


