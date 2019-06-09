Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645123A7B7
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732234AbfFIQwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbfFIQwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74537204EC;
        Sun,  9 Jun 2019 16:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099152;
        bh=spmqT+xRFZzPhEI9L3mzhq93AkAFCphqotHPbZf5aHw=;
        h=From:To:Cc:Subject:Date:From;
        b=04/TTQ4nWNEL+Jp4HqWVZwK4+pgGtcePw1dVL+Pj4XCnFSdHp8KCkGSkqvGosAcmg
         A59YzvYJQC33OQs/zZmhGcvK6QPFFIipRqg53CqviYCHg+OKTPWzNDNFN+5S6kzXGG
         SurCXl4d4QhKC9Kb4PiiS7O3IEsZ6WntfVHs2OGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/83] 4.9.181-stable review
Date:   Sun,  9 Jun 2019 18:41:30 +0200
Message-Id: <20190609164127.843327870@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.181-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.181-rc1
X-KernelTest-Deadline: 2019-06-11T16:41+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.181 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue 11 Jun 2019 04:39:58 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.181-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.181-rc1

Kirill Smelkov <kirr@nexedi.com>
    fuse: Add FOPEN_STREAM to use stream_open()

Kirill Smelkov <kirr@nexedi.com>
    fs: stream_open - opener for stream-like files so that read and write can run simultaneously without deadlock

Jiri Slaby <jslaby@suse.cz>
    TTY: serial_core, add ->install

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix I915_EXEC_RING_MASK

Christian König <christian.koenig@amd.com>
    drm/radeon: prefer lower reference dividers

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500/cdv: Check vbt config bits when detecting lvds panels

Dan Carpenter <dan.carpenter@oracle.com>
    genwqe: Prevent an integer overflow in the ioctl

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "MIPS: perf: ath79: Fix perfcount IRQ assignment"

Paul Burton <paul.burton@mips.com>
    MIPS: pistachio: Build uImage.gz by default

Jiri Kosina <jkosina@suse.cz>
    x86/power: Fix 'nosmt' vs hibernation triple fault during resume

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fallocate: fix return with locked inode

John David Anglin <dave.anglin@bell.net>
    parisc: Use implicit space register selection for loading the coherence index of I/O pdirs

Linus Torvalds <torvalds@linux-foundation.org>
    rcu: locking and unlocking need to always be at least barriers

Hangbin Liu <liuhangbin@gmail.com>
    Revert "fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "fib_rules: fix error in backport of e9919a24d302 ("fib_rules: return 0...")"

Olivier Matz <olivier.matz@6wind.com>
    ipv6: use READ_ONCE() for inet->hdrincl as in ipv4

Olivier Matz <olivier.matz@6wind.com>
    ipv6: fix EFAULT on sendto with icmpv6 and hdrincl

Paolo Abeni <pabeni@redhat.com>
    pktgen: do not sleep with the thread lock held.

Zhu Yanjun <yanjun.zhu@oracle.com>
    net: rds: fix memory leak in rds_ib_flush_mr_pool

Erez Alfasi <ereza@mellanox.com>
    net/mlx4_en: ethtool, Remove unsupported SFP EEPROM high pages query

David Ahern <dsahern@gmail.com>
    neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit

Vivien Didelot <vivien.didelot@gmail.com>
    ethtool: fix potential userspace buffer overflow

Nadav Amit <namit@vmware.com>
    media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    efi/libstub: Unify command line param parsing

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "x86/build: Move _etext to actual end of .text"

Linus Torvalds <torvalds@linux-foundation.org>
    mm: make page ref count overflow check tighter and more explicit

Linus Torvalds <torvalds@linux-foundation.org>
    mm: prevent get_user_pages() from overflowing page refcount

Punit Agrawal <punit.agrawal@arm.com>
    mm, gup: ensure real head page is ref-counted when using hugepages

Will Deacon <will.deacon@arm.com>
    mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages

Matthew Wilcox <willy@infradead.org>
    fs: prevent page refcount overflow in pipe_buf_get

Todd Kjos <tkjos@android.com>
    binder: replace "%p" with "%pK"

Ben Hutchings <ben.hutchings@codethink.co.uk>
    binder: Replace "%p" with "%pK" for stable

Arend van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: add subtype check for event handling in data path

Arend van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: assure SSID length from firmware is limited

Arend Van Spriel <arend.vanspriel@broadcom.com>
    brcmfmac: add length checks in scheduled scan result handler

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Don't send drm sysfs hotplug events on initial master set

Kees Cook <keescook@chromium.org>
    gcc-plugins: Fix build failures under Darwin host

Roberto Bergantinos Corpas <rbergant@redhat.com>
    CIFS: cifs_read_allocate_pages: don't iterate through whole page array on ENOMEM

Dan Carpenter <dan.carpenter@oracle.com>
    staging: vc04_services: prevent integer overflow in create_pagelist()

Jonathan Corbet <corbet@lwn.net>
    docs: Fix conf.py for Sphinx 2.0

Zhenliang Wei <weizhenliang@huawei.com>
    kernel/signal.c: trace_signal_deliver when signal_group_exit

Jiri Slaby <jslaby@suse.cz>
    memcg: make it work on sparse non-0-node systems

Joe Burmeister <joe.burmeister@devtank.co.uk>
    tty: max310x: Fix external crystal register setup

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    tty: serial: msm_serial: Fix XON/XOFF

Lyude Paul <lyude@redhat.com>
    drm/nouveau/i2c: Disable i2c bus access after ->fini()

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Set default power save node to 0

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/perf: Fix MMCRA corruption by bhrb_filter

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race updating log root item during fsync

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only sdevs)

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_remove

Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
    media: smsusb: better handle optional alignment

Alan Stern <stern@rowland.harvard.edu>
    media: usb: siano: Fix false-positive "uninitialized variable" warning

Alan Stern <stern@rowland.harvard.edu>
    media: usb: siano: Fix general protection fault in smsusb

Oliver Neukum <oneukum@suse.com>
    USB: rio500: fix memory leak in close after disconnect

Oliver Neukum <oneukum@suse.com>
    USB: rio500: refuse more than one device at a time

Maximilian Luz <luzmaximilian@gmail.com>
    USB: Add LPM quirk for Surface Dock GigE adapter

Oliver Neukum <oneukum@suse.com>
    USB: sisusbvga: fix oops in error path of sisusb_probe

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor

Shuah Khan <skhan@linuxfoundation.org>
    usbip: usbip_host: fix stub_dev lock context imbalance regression

Shuah Khan <skhan@linuxfoundation.org>
    usbip: usbip_host: fix BUG: sleeping function called from invalid context

Carsten Schmid <carsten_schmid@mentor.com>
    usb: xhci: avoid null pointer deref when bos field is NULL

Andrey Smirnov <andrew.smirnov@gmail.com>
    xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()

Fabio Estevam <festevam@gmail.com>
    xhci: Use %zu for printing size_t type

Henry Lin <henryl@nvidia.com>
    xhci: update bounce buffer with correct sg num

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    include/linux/bitops.h: sanitize rotate primitives

James Clarke <jrtc27@jrtc27.com>
    sparc64: Fix regression in non-hypervisor TLB flush xcall

Junwei Hu <hujunwei4@huawei.com>
    tipc: fix modprobe tipc failed after switch order of device registration

David S. Miller <davem@davemloft.net>
    Revert "tipc: fix modprobe tipc failed after switch order of device registration"

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pciback: Don't disable PCI_COMMAND on PCI device reset.

Daniel Axtens <dja@axtens.net>
    crypto: vmx - ghash: do nosimd fallback manually

Antoine Tenart <antoine.tenart@bootlin.com>
    net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: mvneta: Fix err code path of probe

Rasmus Villemoes <rasmus.villemoes@prevas.dk>
    net: dsa: mv88e6xxx: fix handling of upper half of STATS_TYPE_PORT

Eric Dumazet <edumazet@google.com>
    ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST

Eric Dumazet <edumazet@google.com>
    ipv4/igmp: fix another memory leak in igmpv3_del_delrec()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix aggregation buffer leak under OOM condition.

Chris Packham <chris.packham@alliedtelesis.co.nz>
    tipc: Avoid copying bytes beyond the supplied data

Kloetzke Jan <Jan.Kloetzke@preh.de>
    usbnet: fix kernel crash after disconnect

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    net: stmmac: fix reset gpio free missing

Eric Dumazet <edumazet@google.com>
    net-gro: fix use-after-free read in napi_gro_frags()

Andy Duan <fugang.duan@nxp.com>
    net: fec: fix the clk mismatch in failed_reset path

Eric Dumazet <edumazet@google.com>
    llc: fix skb leak in llc_build_and_send_ui_pkt()

Mike Manning <mmanning@vyatta.att-mail.com>
    ipv6: Consider sk_bound_dev_if when binding a raw socket to an address


-------------

Diffstat:

 Documentation/conf.py                              |   2 +-
 Makefile                                           |   4 +-
 arch/mips/ath79/setup.c                            |   6 +
 arch/mips/pistachio/Platform                       |   1 +
 arch/powerpc/perf/core-book3s.c                    |   6 +-
 arch/powerpc/perf/power8-pmu.c                     |   3 +
 arch/powerpc/perf/power9-pmu.c                     |   3 +
 arch/sparc/mm/ultra.S                              |   4 +-
 arch/x86/kernel/vmlinux.lds.S                      |   6 +-
 arch/x86/power/cpu.c                               |  10 +
 arch/x86/power/hibernate_64.c                      |  33 ++
 drivers/android/binder.c                           |  36 +-
 drivers/crypto/vmx/ghash.c                         | 213 +++++-------
 drivers/firmware/efi/libstub/arm-stub.c            |  23 +-
 drivers/firmware/efi/libstub/arm64-stub.c          |   4 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c     |  19 +-
 drivers/firmware/efi/libstub/efistub.h             |   2 +
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   3 +
 drivers/gpu/drm/gma500/intel_bios.c                |   3 +
 drivers/gpu/drm/gma500/psb_drv.h                   |   1 +
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h  |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c      |  26 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h      |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c     |  15 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c      |  21 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h      |   1 +
 drivers/gpu/drm/radeon/radeon_display.c            |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   8 +-
 drivers/irqchip/irq-ath79-misc.c                   |  11 -
 drivers/media/usb/siano/smsusb.c                   |  33 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   2 +-
 drivers/misc/genwqe/card_dev.c                     |   2 +
 drivers/misc/genwqe/card_utils.c                   |   4 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   4 +-
 drivers/net/ethernet/marvell/mvpp2.c               |  10 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |   5 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   3 +-
 drivers/net/usb/usbnet.c                           |   6 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  16 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |  16 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   2 +-
 drivers/parisc/ccio-dma.c                          |   4 +-
 drivers/parisc/sba_iommu.c                         |   3 +-
 drivers/s390/scsi/zfcp_ext.h                       |   1 +
 drivers/s390/scsi/zfcp_scsi.c                      |   9 +
 drivers/s390/scsi/zfcp_sysfs.c                     |  55 +++-
 drivers/s390/scsi/zfcp_unit.c                      |   8 +-
 .../interface/vchiq_arm/vchiq_2835_arm.c           |   9 +
 drivers/tty/serial/max310x.c                       |   2 +-
 drivers/tty/serial/msm_serial.c                    |   5 +-
 drivers/tty/serial/serial_core.c                   |  24 +-
 drivers/usb/core/config.c                          |   4 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/host/xhci-ring.c                       |  17 +-
 drivers/usb/host/xhci.c                            |  24 +-
 drivers/usb/misc/rio500.c                          |  41 ++-
 drivers/usb/misc/sisusbvga/sisusb.c                |  15 +-
 drivers/usb/usbip/stub_dev.c                       |  75 +++--
 drivers/xen/xen-pciback/pciback_ops.c              |   2 -
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
 fs/btrfs/tree-log.c                                |   8 +-
 fs/cifs/file.c                                     |   4 +-
 fs/fuse/dev.c                                      |  12 +-
 fs/fuse/file.c                                     |   6 +-
 fs/open.c                                          |  18 +
 fs/pipe.c                                          |   4 +-
 fs/read_write.c                                    |   5 +-
 fs/splice.c                                        |  12 +-
 include/linux/bitops.h                             |  16 +-
 include/linux/cpu.h                                |   4 +
 include/linux/efi.h                                |   2 +-
 include/linux/fs.h                                 |   4 +
 include/linux/list_lru.h                           |   1 +
 include/linux/mm.h                                 |   6 +-
 include/linux/pipe_fs_i.h                          |  10 +-
 include/linux/rcupdate.h                           |   6 +-
 include/uapi/drm/i915_drm.h                        |   2 +-
 include/uapi/linux/fuse.h                          |   2 +
 include/uapi/linux/tipc_config.h                   |  10 +-
 kernel/cpu.c                                       |   4 +-
 kernel/power/hibernate.c                           |   9 +
 kernel/signal.c                                    |   2 +
 kernel/trace/trace.c                               |   6 +-
 mm/gup.c                                           |  54 ++-
 mm/hugetlb.c                                       |  16 +-
 mm/list_lru.c                                      |   8 +-
 net/core/dev.c                                     |   2 +-
 net/core/ethtool.c                                 |   5 +-
 net/core/fib_rules.c                               |   7 +-
 net/core/neighbour.c                               |   9 +-
 net/core/pktgen.c                                  |  11 +
 net/ipv4/igmp.c                                    |  47 ++-
 net/ipv6/raw.c                                     |  27 +-
 net/llc/llc_output.c                               |   2 +
 net/rds/ib_rdma.c                                  |  10 +-
 net/tipc/core.c                                    |  32 +-
 net/tipc/subscr.c                                  |  14 +-
 net/tipc/subscr.h                                  |   5 +-
 scripts/coccinelle/api/stream_open.cocci           | 363 +++++++++++++++++++++
 scripts/gcc-plugins/gcc-common.h                   |   4 +
 sound/pci/hda/patch_realtek.c                      |   2 +-
 106 files changed, 1223 insertions(+), 441 deletions(-)


