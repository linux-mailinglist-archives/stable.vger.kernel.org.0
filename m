Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4FDD9FCB
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438157AbfJPV62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438009AbfJPV62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:28 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0657D20872;
        Wed, 16 Oct 2019 21:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263106;
        bh=xB+Y9fSFnCsDvOmKxohYE3PxpjKi0TpXnWVQQov+CnI=;
        h=From:To:Cc:Subject:Date:From;
        b=lY6MLRvcVoNcBD62LT81wZyxFLTYRRDddTP8xiWcy7NEIHm0GRCGrr8yR0FyGuGPe
         XJCOLLhuwQaQVhk9Jjsc5dnnVZOlYmxH6MyyI4xYJPyt/IenhhghTpEMrCD3kMV0f8
         EHN7nUSgkY9Z3J9Qk+mCkCD1TX1JPqaxHyoucmKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 000/112] 5.3.7-stable review
Date:   Wed, 16 Oct 2019 14:49:52 -0700
Message-Id: <20191016214844.038848564@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.7-rc1
X-KernelTest-Deadline: 2019-10-18T21:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.7 release.
There are 112 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.7-rc1

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: sgtl5000: add ADC mute control

Colin Ian King <colin.king@canonical.com>
    efi/tpm: Fix sanity check of unsigned tbl_size being less than zero

Jens Axboe <axboe@kernel.dk>
    io_uring: only flush workqueues on fileset removal

Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
    x86/asm: Fix MWAITX C-state hint value

Paul Burton <paul.burton@mips.com>
    mtd: rawnand: au1550nd: Fix au_read_buf16() prototype

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

Rob Clark <robdclark@chromium.org>
    drm/msm: Use the correct dma_sync calls harder

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Mark contents as dirty on a write fault

Kenneth Graunke <kenneth@whitecape.org>
    drm/i915: Whitelist COMMON_SLICE_CHICKEN2

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Bump skl+ max plane width to 5k for linear/x-tiled

Al Viro <viro@zeniv.linux.org.uk>
    Fix the locking in dcache_readdir() and friends

Marco Felsch <m.felsch@pengutronix.de>
    iio: light: fix vcnl4000 devicetree hooks

Jeremy Linton <jeremy.linton@arm.com>
    arm64: topology: Use PPTT to determine if PE is a thread

Jeremy Linton <jeremy.linton@arm.com>
    ACPI/PPTT: Add support for ACPI 6.3 thread flag

Adit Ranadive <aditr@vmware.com>
    RDMA/vmw_pvrdma: Free SRQ only once

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

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix memory leak due to concurrent append writes with fiemap

Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
    btrfs: fix balance convert to single on 32-bit host CPUs

Josef Bacik <josef@toxicpanda.com>
    btrfs: allocate new inode in NOFS context

Qu Wenruo <wqu@suse.com>
    btrfs: relocation: fix use-after-free on dead relocation roots

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    gpiolib: don't clear FLAG_IS_OUT when emulating open-drain/open-source

Marco Felsch <m.felsch@pengutronix.de>
    gpio: fix getting nonexclusive gpiods from DT

Brian Norris <briannorris@chromium.org>
    firmware: google: increment VPD key_len properly

Mohamad Heib <mohamadh@mellanox.com>
    IB/core: Fix wrong iterating on ports

Dan Carpenter <dan.carpenter@oracle.com>
    mm/vmpressure.c: fix a signedness bug in vmpressure_register_event()

Qian Cai <cai@lca.pw>
    mm/page_alloc.c: fix a crash in free_pages_prepare()

Vitaly Wool <vitalywool@gmail.com>
    mm/z3fold.c: claim page in the beginning of free

Michal Hocko <mhocko@suse.com>
    kernel/sysctl.c: do not override max_threads provided by userspace

Dave Wysochanski <dwysocha@redhat.com>
    cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a panic

Pavel Shilovsky <piastryyy@gmail.com>
    CIFS: Force reval dentry if LOOKUP_REVAL flag is set

Pavel Shilovsky <piastryyy@gmail.com>
    CIFS: Force revalidate inode when dentry is stale

Pavel Shilovsky <piastryyy@gmail.com>
    CIFS: Gracefully handle QueryInfo errors during open

Ondrej Mosnacek <omosnace@redhat.com>
    selinux: fix context string corruption in convert_context()

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    blk-wbt: fix performance regression in wbt scale_up/scale_down

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Perform GGTT restore much earlier during resume

Steve MacLean <Steve.MacLean@microsoft.com>
    perf inject jit: Fix JIT_CODE_MOVE filename

Ian Rogers <irogers@google.com>
    perf llvm: Don't access out-of-scope array

Jerry Snitselaar <jsnitsel@redhat.com>
    efi/tpm: Only set 'efi_tpm_final_log_size' after successful event log parsing

Peter Jones <pjones@redhat.com>
    efi/tpm: Don't traverse an event log with no events

Peter Jones <pjones@redhat.com>
    efi/tpm: Don't access event->count when it isn't mapped

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    efivar/ssdt: Don't iterate over EFI vars if no SSDT override was specified

Stefan Popa <stefan.popa@analog.com>
    iio: accel: adxl372: Perform a reset at start up

Stefan Popa <stefan.popa@analog.com>
    iio: accel: adxl372: Fix push to buffers lost samples

Stefan Popa <stefan.popa@analog.com>
    iio: accel: adxl372: Fix/remove limitation for FIFO samples

Marco Felsch <m.felsch@pengutronix.de>
    iio: light: add missing vcnl4040 of_compatible

David Frey <dpfrey@gmail.com>
    iio: light: opt3001: fix mutex unlock race

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: fix a race when using several adcs with dma and irq

Fabrice Gasnier <fabrice.gasnier@st.com>
    iio: adc: stm32-adc: move registers definitions

Hans de Goede <hdegoede@redhat.com>
    iio: adc: axp288: Override TS pin bias current for some models

Marco Felsch <m.felsch@pengutronix.de>
    iio: adc: ad799x: fix probe error handling

Andreas Klinger <ak@it-klinger.de>
    iio: adc: hx711: fix bug in sampling of data

Navid Emamdoost <navid.emamdoost@gmail.com>
    staging: vt6655: Fix memory leak in vt6655_probe

Denis Efremov <efremov@linux.com>
    staging: rtl8188eu: fix HighestRate check in odm_ARFBRefresh_8188E()

Navid Emamdoost <navid.emamdoost@gmail.com>
    Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc

Takashi Iwai <tiwai@suse.de>
    staging: bcm2835-audio: Fix draining behavior regression

Noralf Trønnes <noralf@tronnes.org>
    staging/fbtft: Depend on OF

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

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: displayport: Fix for the mode entering routine

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: ccg: Remove run_isr flag

Dan Carpenter <dan.carpenter@oracle.com>
    usb: typec: tcpm: usb: typec: tcpm: Fix a signedness bug in tcpm_fw_get_caps()

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

Michal Simek <michal.simek@xilinx.com>
    serial: uartps: Fix uartps_major handling

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

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix NULL pointer dereference in xhci_clear_tt_buffer_complete()

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

Will Deacon <will@kernel.org>
    panic: ensure preemption is disabled during panic()


-------------

Diffstat:

 Documentation/usb/rio.rst                          | 109 ----
 MAINTAINERS                                        |   7 -
 Makefile                                           |   4 +-
 arch/arm/configs/badge4_defconfig                  |   1 -
 arch/arm/configs/corgi_defconfig                   |   1 -
 arch/arm/configs/pxa_defconfig                     |   1 -
 arch/arm/configs/s3c2410_defconfig                 |   1 -
 arch/arm/configs/spitz_defconfig                   |   1 -
 arch/arm64/kernel/process.c                        |  32 +-
 arch/arm64/kernel/topology.c                       |  19 +-
 arch/mips/configs/mtx1_defconfig                   |   1 -
 arch/mips/configs/rm200_defconfig                  |   1 -
 arch/mips/include/uapi/asm/hwcap.h                 |  11 +
 arch/mips/kernel/cpu-probe.c                       |  33 ++
 arch/mips/loongson64/Platform                      |   4 +
 arch/mips/vdso/Makefile                            |   1 +
 arch/x86/include/asm/mwait.h                       |   2 +-
 arch/x86/lib/delay.c                               |   4 +-
 block/blk-rq-qos.c                                 |  14 +-
 block/blk-rq-qos.h                                 |   4 +-
 block/blk-wbt.c                                    |   6 +-
 drivers/acpi/pptt.c                                |  52 ++
 drivers/firmware/efi/efi.c                         |   3 +
 drivers/firmware/efi/tpm.c                         |  26 +-
 drivers/firmware/google/vpd_decode.c               |   2 +-
 drivers/gpio/gpio-eic-sprd.c                       |   7 +-
 drivers/gpio/gpiolib.c                             |  29 +-
 drivers/gpu/drm/i915/display/intel_display.c       |  15 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   6 +-
 drivers/gpu/drm/i915/gem/i915_gem_pm.c             |   3 -
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |   3 +
 drivers/gpu/drm/i915/i915_drv.c                    |   5 +
 drivers/gpu/drm/i915/selftests/i915_gem.c          |   6 +
 drivers/gpu/drm/msm/msm_gem.c                      |   4 +-
 drivers/iio/accel/adxl372.c                        |  22 +-
 drivers/iio/adc/ad799x.c                           |   4 +-
 drivers/iio/adc/axp288_adc.c                       |  32 ++
 drivers/iio/adc/hx711.c                            |  10 +-
 drivers/iio/adc/stm32-adc-core.c                   |  70 +--
 drivers/iio/adc/stm32-adc-core.h                   | 137 +++++
 drivers/iio/adc/stm32-adc.c                        | 109 ----
 drivers/iio/light/opt3001.c                        |   6 +-
 drivers/iio/light/vcnl4000.c                       |  14 +-
 drivers/infiniband/core/security.c                 |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c      |   2 -
 drivers/media/usb/stkwebcam/stk-webcam.c           |   3 +-
 drivers/misc/mei/bus-fixup.c                       |  14 +-
 drivers/misc/mei/hw-me-regs.h                      |   3 +
 drivers/misc/mei/hw-me.c                           |  21 +-
 drivers/misc/mei/hw-me.h                           |   8 +-
 drivers/misc/mei/mei_dev.h                         |   4 +
 drivers/misc/mei/pci-me.c                          |  13 +-
 drivers/mtd/nand/raw/au1550nd.c                    |   5 +-
 drivers/staging/fbtft/Kconfig                      |   2 +-
 drivers/staging/fbtft/fbtft-core.c                 |   7 +-
 .../staging/rtl8188eu/hal/hal8188e_rate_adaptive.c |   2 +-
 .../vc04_services/bcm2835-audio/bcm2835-pcm.c      |   4 +-
 .../vc04_services/bcm2835-audio/bcm2835-vchiq.c    |   1 +
 drivers/staging/vt6655/device_main.c               |   4 +-
 drivers/tty/serial/uartlite.c                      |   3 +-
 drivers/tty/serial/xilinx_uartps.c                 |   8 +-
 drivers/usb/class/usblp.c                          |   8 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   3 +-
 drivers/usb/host/xhci-ring.c                       |   4 +-
 drivers/usb/host/xhci.c                            |  78 ++-
 drivers/usb/image/microtek.c                       |   4 +
 drivers/usb/misc/Kconfig                           |  10 -
 drivers/usb/misc/Makefile                          |   1 -
 drivers/usb/misc/adutux.c                          |  24 +-
 drivers/usb/misc/chaoskey.c                        |   5 +-
 drivers/usb/misc/iowarrior.c                       |  16 +-
 drivers/usb/misc/ldusb.c                           |  24 +-
 drivers/usb/misc/legousbtower.c                    |  58 +--
 drivers/usb/misc/rio500.c                          | 561 ---------------------
 drivers/usb/misc/rio500_usb.h                      |  20 -
 drivers/usb/misc/usblcd.c                          |  33 +-
 drivers/usb/misc/yurex.c                           |  18 +-
 drivers/usb/renesas_usbhs/common.h                 |   1 +
 drivers/usb/renesas_usbhs/fifo.c                   |   2 +-
 drivers/usb/renesas_usbhs/fifo.h                   |   1 +
 drivers/usb/renesas_usbhs/mod_gadget.c             |  18 +-
 drivers/usb/renesas_usbhs/pipe.c                   |  15 +
 drivers/usb/renesas_usbhs/pipe.h                   |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   9 +
 drivers/usb/serial/keyspan.c                       |   4 +-
 drivers/usb/serial/option.c                        |  11 +
 drivers/usb/serial/usb-serial.c                    |   5 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  14 +-
 drivers/usb/typec/ucsi/displayport.c               |   2 +
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |  42 +-
 drivers/usb/usb-skeleton.c                         |  15 +-
 fs/btrfs/file.c                                    |  13 +-
 fs/btrfs/inode.c                                   |   3 +
 fs/btrfs/ref-verify.c                              |   2 +-
 fs/btrfs/relocation.c                              |   9 +-
 fs/btrfs/tree-log.c                                |  36 +-
 fs/btrfs/volumes.c                                 |   6 +-
 fs/cifs/dir.c                                      |   8 +-
 fs/cifs/file.c                                     |  33 +-
 fs/cifs/inode.c                                    |   4 +
 fs/io_uring.c                                      |   3 +-
 fs/libfs.c                                         | 134 ++---
 fs/nfs/direct.c                                    |  78 +--
 include/linux/acpi.h                               |   5 +
 include/linux/hwmon.h                              |   2 +-
 include/linux/tpm_eventlog.h                       |  16 +-
 kernel/fork.c                                      |   4 +-
 kernel/panic.c                                     |   1 +
 kernel/trace/ftrace.c                              |  27 +-
 kernel/trace/trace.c                               |  17 +-
 kernel/trace/trace_hwlat.c                         |   4 +-
 mm/page_alloc.c                                    |   8 +-
 mm/vmpressure.c                                    |  20 +-
 mm/z3fold.c                                        |  10 +-
 security/selinux/ss/services.c                     |   9 +-
 sound/soc/codecs/sgtl5000.c                        |   1 +
 tools/perf/util/jitdump.c                          |   6 +-
 tools/perf/util/llvm-utils.c                       |   6 +-
 119 files changed, 1117 insertions(+), 1286 deletions(-)


