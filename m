Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F92D9F51
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437688AbfJPVyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437676AbfJPVyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:08 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB3E421D7C;
        Wed, 16 Oct 2019 21:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262847;
        bh=cmJUTy6pKmtlM0DiORiNfY22PHPnHs/iM++l7EdsPtA=;
        h=From:To:Cc:Subject:Date:From;
        b=vVR/lXM2LDHr6saJMFVZJlwqLbU283gHfn9wnLKlpQTarjhdcjTu5RAG++XFjb8Au
         x3u64iiffOdfVpxy622PUlzM/rz8XqE4EWmVOCmSyl/1rg4B2ZkBuyYXVPP+zgZkT3
         DUDJPSbPXpABtqNJlG/AJd5ncbgB1i9q+Y4qZE3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/92] 4.9.197-stable review
Date:   Wed, 16 Oct 2019 14:49:33 -0700
Message-Id: <20191016214759.600329427@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.197-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.197-rc1
X-KernelTest-Deadline: 2019-10-18T21:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.197 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.197-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.197-rc1

Dave Chinner <dchinner@redhat.com>
    xfs: clear sb->s_fs_info on mount failure

Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
    x86/asm: Fix MWAITX C-state hint value

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Get trace_array reference for available_tracers files

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

Navid Emamdoost <navid.emamdoost@gmail.com>
    Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc

Daniel Vetter <daniel.vetter@ffwll.ch>
    staging: fbtft: Stop using BL_CORE_DRIVER1

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

Will Deacon <will@kernel.org>
    panic: ensure preemption is disabled during panic()

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: sgtl5000: Improve VAG power and mute control

Johannes Berg <johannes.berg@intel.com>
    nl80211: validate beacon head

Jouni Malinen <j@w1.fi>
    cfg80211: Use const more consistently in for_each_element macros

Johannes Berg <johannes.berg@intel.com>
    cfg80211: add and use strongly typed element iteration macros

Andrew Murray <andrew.murray@arm.com>
    coresight: etm4x: Use explicit barriers on enable/disable

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - fix concurrency issue in givencrypt descriptor

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    perf stat: Reset previous counts on repeat with interval

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    perf stat: Fix a segmentation fault when using repeat forever

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix segfault in cpu_cache_level__read()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on failure

Valdis Kletnieks <valdis.kletnieks@vt.edu>
    kernel/elfcore.c: include proper prototypes

KeMeng Shi <shikemeng@huawei.com>
    sched/core: Fix migration to invalid CPU in __set_cpus_allowed_ptr()

zhengbin <zhengbin13@huawei.com>
    fuse: fix memleak in cuse_channel_open

Ido Schimmel <idosch@mellanox.com>
    thermal: Fix use-after-free when unregistering thermal zone device

Trek <trek00@inbox.ru>
    drm/amdgpu: Check for valid number of registers to read

Erqi Chen <chenerqi@gmail.com>
    ceph: reconnect connection if session hang in opening state

Luis Henriques <lhenriques@suse.com>
    ceph: fix directories inode i_blkbits initialization

Igor Druzhinin <igor.druzhinin@citrix.com>
    xen/pci: reserve MCFG areas earlier

Chengguang Xu <cgxu519@zoho.com.cn>
    9p: avoid attaching writeback_fid on mmap with type PRIVATE

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: nfs: Fix possible null-pointer dereferences in encode_attrs()

Sascha Hauer <s.hauer@pengutronix.de>
    ima: always return negative code for error

Johannes Berg <johannes.berg@intel.com>
    cfg80211: initialize on-stack chandefs

Johan Hovold <johan@kernel.org>
    ieee802154: atusb: fix use-after-free at disconnect

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    watchdog: imx2_wdt: fix min() calculation in imx2_wdt_set_timeout

Li RongQing <lirongqing@baidu.com>
    timer: Read jiffies once when forwarding base clk

Kees Cook <keescook@chromium.org>
    usercopy: Avoid HIGHMEM pfn warning

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    crypto: qat - Silence smp_processor_id() warning

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251x: mcp251x_hw_reset(): allow more time after a reset

Andrew Donnellan <ajd@linux.ibm.com>
    powerpc/powernv: Restrict OPAL symbol map to only be readable by root

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    ASoC: Define a set of DAPM pre/post-up events

Jack Wang <jinpu.wang@cloud.ionos.com>
    KVM: nVMX: handle page fault in vmread fix

Vasily Gorbik <gor@linux.ibm.com>
    s390/cio: exclude subchannels with no parent from pseudo check

Vasily Gorbik <gor@linux.ibm.com>
    s390/cio: avoid calling strlen on null pointer

Vasily Gorbik <gor@linux.ibm.com>
    s390/topology: avoid firing events before kobjs are created

Thomas Huth <thuth@redhat.com>
    KVM: s390: Test for bad access register and size at the start of S390_MEM_OP


-------------

Diffstat:

 Documentation/usb/rio.txt                      | 138 ------
 MAINTAINERS                                    |   7 -
 Makefile                                       |   4 +-
 arch/arm/configs/badge4_defconfig              |   1 -
 arch/arm/configs/corgi_defconfig               |   1 -
 arch/arm/configs/pxa_defconfig                 |   1 -
 arch/arm/configs/s3c2410_defconfig             |   1 -
 arch/arm/configs/spitz_defconfig               |   1 -
 arch/mips/configs/mtx1_defconfig               |   1 -
 arch/mips/configs/rm200_defconfig              |   1 -
 arch/mips/loongson64/Platform                  |   4 +
 arch/mips/vdso/Makefile                        |   1 +
 arch/powerpc/platforms/powernv/opal.c          |  11 +-
 arch/s390/kernel/topology.c                    |   3 +-
 arch/s390/kvm/kvm-s390.c                       |   2 +-
 arch/x86/include/asm/mwait.h                   |   2 +-
 arch/x86/kvm/vmx.c                             |   2 +-
 arch/x86/lib/delay.c                           |   4 +-
 drivers/crypto/caam/caamalg.c                  |  11 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h |   2 +-
 drivers/firmware/efi/efi.c                     |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c        |   3 +
 drivers/hwtracing/coresight/coresight-etm4x.c  |  14 +-
 drivers/iio/adc/ad799x.c                       |   4 +-
 drivers/iio/light/opt3001.c                    |   6 +-
 drivers/media/usb/stkwebcam/stk-webcam.c       |   3 +-
 drivers/net/can/spi/mcp251x.c                  |  19 +-
 drivers/net/ieee802154/atusb.c                 |   3 +-
 drivers/s390/cio/ccwgroup.c                    |   2 +-
 drivers/s390/cio/css.c                         |   2 +
 drivers/staging/fbtft/fbtft-core.c             |  11 +-
 drivers/staging/fbtft/fbtft.h                  |   1 +
 drivers/staging/vt6655/device_main.c           |   4 +-
 drivers/thermal/thermal_core.c                 |   2 +-
 drivers/tty/serial/uartlite.c                  |   3 +-
 drivers/usb/class/usblp.c                      |   8 +-
 drivers/usb/gadget/udc/dummy_hcd.c             |   3 +-
 drivers/usb/host/xhci-ring.c                   |   4 +-
 drivers/usb/host/xhci.c                        |  32 +-
 drivers/usb/image/microtek.c                   |   4 +
 drivers/usb/misc/Kconfig                       |  10 -
 drivers/usb/misc/Makefile                      |   1 -
 drivers/usb/misc/adutux.c                      |  26 +-
 drivers/usb/misc/chaoskey.c                    |   5 +-
 drivers/usb/misc/iowarrior.c                   |  16 +-
 drivers/usb/misc/ldusb.c                       |  24 +-
 drivers/usb/misc/legousbtower.c                |  58 ++-
 drivers/usb/misc/rio500.c                      | 578 -------------------------
 drivers/usb/misc/rio500_usb.h                  |  37 --
 drivers/usb/misc/usblcd.c                      |  33 +-
 drivers/usb/misc/yurex.c                       |  18 +-
 drivers/usb/renesas_usbhs/common.h             |   1 +
 drivers/usb/renesas_usbhs/fifo.c               |   2 +-
 drivers/usb/renesas_usbhs/fifo.h               |   1 +
 drivers/usb/renesas_usbhs/mod_gadget.c         |  18 +-
 drivers/usb/renesas_usbhs/pipe.c               |  15 +
 drivers/usb/renesas_usbhs/pipe.h               |   1 +
 drivers/usb/serial/ftdi_sio.c                  |   3 +
 drivers/usb/serial/ftdi_sio_ids.h              |   9 +
 drivers/usb/serial/keyspan.c                   |   4 +-
 drivers/usb/serial/option.c                    |  11 +
 drivers/usb/serial/usb-serial.c                |   5 +-
 drivers/usb/usb-skeleton.c                     |  15 +-
 drivers/watchdog/imx2_wdt.c                    |   4 +-
 drivers/xen/pci.c                              |  21 +-
 fs/9p/vfs_file.c                               |   3 +
 fs/ceph/inode.c                                |   7 +-
 fs/ceph/mds_client.c                           |   4 +-
 fs/cifs/dir.c                                  |   8 +-
 fs/cifs/file.c                                 |   6 +
 fs/cifs/inode.c                                |   4 +
 fs/fuse/cuse.c                                 |   1 +
 fs/libfs.c                                     | 134 +++---
 fs/nfs/nfs4xdr.c                               |   2 +-
 fs/xfs/xfs_super.c                             |  10 +
 include/linux/ieee80211.h                      |  53 +++
 include/sound/soc-dapm.h                       |   2 +
 kernel/elfcore.c                               |   1 +
 kernel/fork.c                                  |   4 +-
 kernel/panic.c                                 |   1 +
 kernel/sched/core.c                            |   4 +-
 kernel/time/timer.c                            |   8 +-
 kernel/trace/trace.c                           |  17 +-
 kernel/trace/trace_hwlat.c                     |   4 +-
 mm/usercopy.c                                  |   8 +-
 net/wireless/nl80211.c                         |  39 +-
 net/wireless/reg.c                             |   2 +-
 net/wireless/scan.c                            |  14 +-
 net/wireless/wext-compat.c                     |   2 +-
 security/integrity/ima/ima_crypto.c            |   5 +-
 sound/soc/codecs/sgtl5000.c                    | 232 ++++++++--
 tools/lib/traceevent/event-parse.c             |   3 +-
 tools/perf/builtin-stat.c                      |   5 +-
 tools/perf/util/header.c                       |   2 +-
 tools/perf/util/jitdump.c                      |   6 +-
 tools/perf/util/llvm-utils.c                   |   6 +-
 tools/perf/util/stat.c                         |  17 +
 tools/perf/util/stat.h                         |   1 +
 98 files changed, 802 insertions(+), 1058 deletions(-)


