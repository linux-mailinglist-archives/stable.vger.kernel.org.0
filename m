Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D10BDC35B
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 12:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406678AbfJRK7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 06:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392257AbfJRK7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 06:59:53 -0400
Received: from localhost (unknown [209.136.236.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A94020700;
        Fri, 18 Oct 2019 10:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571396391;
        bh=C0oaF/LUZbwGSmIKK8nfBLn+DFTEexNnXTvK9V8ECJQ=;
        h=Date:From:To:Cc:Subject:From;
        b=GCdbKZabd0mmNR0MZdjnYfq5flKbovSS5779a2cL5Y/d9BiPSaobQztEDxoPRZ/Ok
         i7BtO1doGjU1Ru3aI/gnswHCE6ZL+wduoEBBvdfVv9Obu0MYL0YVlGmAFaCKoUMuv9
         MWapOB1gNU8hZyn8KOd8znrKXtIXcHgX44tgV5mw=
Date:   Fri, 18 Oct 2019 03:59:50 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.197
Message-ID: <20191018105950.GA1176229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.197 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/usb/rio.txt                      |  138 -----
 MAINTAINERS                                    |    7 
 Makefile                                       |    2 
 arch/arm/configs/badge4_defconfig              |    1 
 arch/arm/configs/corgi_defconfig               |    1 
 arch/arm/configs/s3c2410_defconfig             |    1 
 arch/arm/configs/spitz_defconfig               |    1 
 arch/arm64/include/asm/cpufeature.h            |   29 -
 arch/arm64/kernel/cpufeature.c                 |   35 -
 arch/arm64/kernel/debug-monitors.c             |    2 
 arch/arm64/kvm/sys_regs.c                      |    2 
 arch/arm64/mm/context.c                        |    3 
 arch/mips/configs/mtx1_defconfig               |    1 
 arch/mips/configs/rm200_defconfig              |    1 
 arch/powerpc/platforms/powernv/opal.c          |   11 
 arch/s390/kernel/topology.c                    |    3 
 arch/s390/kvm/kvm-s390.c                       |    2 
 arch/x86/include/asm/mwait.h                   |    2 
 arch/x86/kvm/vmx.c                             |    2 
 arch/x86/lib/delay.c                           |    4 
 drivers/crypto/caam/caamalg.c                  |   11 
 drivers/crypto/qat/qat_common/adf_common_drv.h |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c        |    3 
 drivers/iio/adc/ad799x.c                       |    4 
 drivers/iio/light/opt3001.c                    |    6 
 drivers/media/usb/stkwebcam/stk-webcam.c       |    3 
 drivers/net/can/spi/mcp251x.c                  |   19 
 drivers/net/ieee802154/atusb.c                 |    3 
 drivers/s390/cio/ccwgroup.c                    |    2 
 drivers/s390/cio/css.c                         |    2 
 drivers/staging/fbtft/fbtft-core.c             |    7 
 drivers/staging/vt6655/device_main.c           |    4 
 drivers/thermal/thermal_core.c                 |    2 
 drivers/tty/serial/uartlite.c                  |    3 
 drivers/usb/class/usblp.c                      |    8 
 drivers/usb/gadget/udc/dummy_hcd.c             |    3 
 drivers/usb/host/xhci.c                        |   32 -
 drivers/usb/image/microtek.c                   |    4 
 drivers/usb/misc/Kconfig                       |   10 
 drivers/usb/misc/Makefile                      |    1 
 drivers/usb/misc/adutux.c                      |   26 -
 drivers/usb/misc/chaoskey.c                    |    5 
 drivers/usb/misc/iowarrior.c                   |   16 
 drivers/usb/misc/ldusb.c                       |   24 -
 drivers/usb/misc/legousbtower.c                |   58 +-
 drivers/usb/misc/rio500.c                      |  578 -------------------------
 drivers/usb/misc/rio500_usb.h                  |   37 -
 drivers/usb/misc/usblcd.c                      |   33 +
 drivers/usb/misc/yurex.c                       |   18 
 drivers/usb/renesas_usbhs/common.h             |    1 
 drivers/usb/renesas_usbhs/fifo.c               |    2 
 drivers/usb/renesas_usbhs/fifo.h               |    1 
 drivers/usb/renesas_usbhs/mod_gadget.c         |   18 
 drivers/usb/renesas_usbhs/pipe.c               |   15 
 drivers/usb/renesas_usbhs/pipe.h               |    1 
 drivers/usb/serial/ftdi_sio.c                  |    3 
 drivers/usb/serial/ftdi_sio_ids.h              |    9 
 drivers/usb/serial/keyspan.c                   |    4 
 drivers/usb/serial/option.c                    |   11 
 drivers/usb/serial/usb-serial.c                |    5 
 drivers/usb/usb-skeleton.c                     |   15 
 drivers/xen/pci.c                              |   21 
 fs/9p/vfs_file.c                               |    3 
 fs/ceph/inode.c                                |    7 
 fs/cifs/dir.c                                  |    8 
 fs/cifs/file.c                                 |    6 
 fs/cifs/inode.c                                |   28 +
 fs/fuse/cuse.c                                 |    1 
 fs/nfs/nfs4xdr.c                               |    2 
 fs/xfs/xfs_super.c                             |   10 
 include/linux/ieee80211.h                      |   53 ++
 include/sound/soc-dapm.h                       |    2 
 kernel/elfcore.c                               |    1 
 kernel/fork.c                                  |    4 
 kernel/panic.c                                 |    1 
 kernel/trace/trace.c                           |   17 
 net/wireless/nl80211.c                         |   39 +
 net/wireless/reg.c                             |    2 
 net/wireless/wext-compat.c                     |    2 
 security/integrity/ima/ima_crypto.c            |    5 
 sound/soc/codecs/sgtl5000.c                    |  232 ++++++++--
 tools/lib/traceevent/event-parse.c             |    3 
 tools/perf/builtin-stat.c                      |    2 
 tools/perf/util/llvm-utils.c                   |    6 
 84 files changed, 718 insertions(+), 994 deletions(-)

Alan Stern (1):
      USB: yurex: Don't retry on unexpected errors

Alexander Sverdlin (1):
      crypto: qat - Silence smp_processor_id() warning

Andrew Donnellan (1):
      powerpc/powernv: Restrict OPAL symbol map to only be readable by root

Bastien Nocera (1):
      USB: rio500: Remove Rio 500 kernel driver

Beni Mahler (1):
      USB: serial: ftdi_sio: add device IDs for Sienna and Echelon PL-20

Chengguang Xu (1):
      9p: avoid attaching writeback_fid on mmap with type PRIVATE

Colin Ian King (1):
      USB: adutux: remove redundant variable minor

Daniele Palmas (1):
      USB: serial: option: add Telit FN980 compositions

Dave Chinner (1):
      xfs: clear sb->s_fs_info on mount failure

David Frey (1):
      iio: light: opt3001: fix mutex unlock race

Greg Kroah-Hartman (1):
      Linux 4.4.197

Horia Geantă (1):
      crypto: caam - fix concurrency issue in givencrypt descriptor

Ian Rogers (1):
      perf llvm: Don't access out-of-scope array

Ido Schimmel (1):
      thermal: Fix use-after-free when unregistering thermal zone device

Igor Druzhinin (1):
      xen/pci: reserve MCFG areas earlier

Jack Wang (1):
      KVM: nVMX: handle page fault in vmread fix

Jacky.Cao@sony.com (1):
      USB: dummy-hcd: fix power budget for SuperSpeed mode

Jan Schmidt (1):
      xhci: Check all endpoints for LPM timeout

Janakarajan Natarajan (1):
      x86/asm: Fix MWAITX C-state hint value

Jia-Ju Bai (1):
      fs: nfs: Fix possible null-pointer dereferences in encode_attrs()

Johan Hovold (23):
      ieee802154: atusb: fix use-after-free at disconnect
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

Johannes Berg (3):
      cfg80211: initialize on-stack chandefs
      cfg80211: add and use strongly typed element iteration macros
      nl80211: validate beacon head

Jouni Malinen (1):
      cfg80211: Use const more consistently in for_each_element macros

Kai-Heng Feng (1):
      xhci: Increase STS_SAVE timeout in xhci_suspend()

Luis Henriques (1):
      ceph: fix directories inode i_blkbits initialization

Marc Kleine-Budde (1):
      can: mcp251x: mcp251x_hw_reset(): allow more time after a reset

Marco Felsch (1):
      iio: adc: ad799x: fix probe error handling

Mathias Nyman (1):
      xhci: Prevent device initiated U1/U2 link pm if exit latency is too long

Michal Hocko (1):
      kernel/sysctl.c: do not override max_threads provided by userspace

Navid Emamdoost (2):
      staging: vt6655: Fix memory leak in vt6655_probe
      Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc

Oleksandr Suvorov (2):
      ASoC: Define a set of DAPM pre/post-up events
      ASoC: sgtl5000: Improve VAG power and mute control

Pavel Shilovsky (3):
      CIFS: Gracefully handle QueryInfo errors during open
      CIFS: Force reval dentry if LOOKUP_REVAL flag is set
      CIFS: Force revalidate inode when dentry is stale

Randy Dunlap (1):
      serial: uartlite: fix exit path null pointer

Reinhard Speyerer (1):
      USB: serial: option: add support for Cinterion CLS8 devices

Rick Tseng (1):
      usb: xhci: wait for CNR controller not ready bit in xhci resume

Ross Lagerwall (1):
      cifs: Check uniqueid for SMB2+ and return -ESTALE if necessary

Sascha Hauer (1):
      ima: always return negative code for error

Srikar Dronamraju (1):
      perf stat: Fix a segmentation fault when using repeat forever

Steven Rostedt (VMware) (2):
      tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on failure
      tracing: Get trace_array reference for available_tracers files

Suzuki K Poulose (2):
      arm64: capabilities: Handle sign of the feature bit
      arm64: Rename cpuid_feature field extract routines

Thomas Huth (1):
      KVM: s390: Test for bad access register and size at the start of S390_MEM_OP

Trek (1):
      drm/amdgpu: Check for valid number of registers to read

Valdis Kletnieks (1):
      kernel/elfcore.c: include proper prototypes

Vasily Gorbik (3):
      s390/topology: avoid firing events before kobjs are created
      s390/cio: avoid calling strlen on null pointer
      s390/cio: exclude subchannels with no parent from pseudo check

Will Deacon (1):
      panic: ensure preemption is disabled during panic()

Yoshihiro Shimoda (2):
      usb: renesas_usbhs: gadget: Do not discard queues in usb_ep_set_{halt,wedge}()
      usb: renesas_usbhs: gadget: Fix usb_ep_set_{halt,wedge}() behavior

zhengbin (1):
      fuse: fix memleak in cuse_channel_open

