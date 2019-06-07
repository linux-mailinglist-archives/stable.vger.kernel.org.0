Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6785938F54
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfFGPka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbfFGPka (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:40:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD8521479;
        Fri,  7 Jun 2019 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922029;
        bh=NrueRUju4RLIoWak+3Cd9Pf3DNIVGJcI9J+3iD3gxvM=;
        h=From:To:Cc:Subject:Date:From;
        b=HuQ82JyYUTVT4JI2SqEYkEDxtL4fVtIlweoD2kdyfscd/9oJ/0DKsCCU3iv2aayQP
         tA7OZntyblaLI9vrLBZj2CnIjyTxo5H41htCcQYTQ+2SiInNo/nMH4iZCfYmdgpVE4
         B8UEysknF88sKX7F7PljeCYzJP+ItRTwjoUBMUHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/69] 4.14.124-stable review
Date:   Fri,  7 Jun 2019 17:38:41 +0200
Message-Id: <20190607153848.271562617@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.124-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.124-rc1
X-KernelTest-Deadline: 2019-06-09T15:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.124 release.
There are 69 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.124-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.124-rc1

Nadav Amit <namit@vmware.com>
    media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

Todd Kjos <tkjos@android.com>
    binder: fix race between munmap() and direct reclaim

Todd Kjos <tkjos@android.com>
    Revert "binder: fix handling of misaligned binder object"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "x86/build: Move _etext to actual end of .text"

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
    include/linux/module.h: copy __init/__exit attrs to init/cleanup_module

Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
    Compiler Attributes: add support for __copy (gcc >= 9)

Vicente Bergas <vicencb@gmail.com>
    drm/rockchip: shutdown drm subsystem on shutdown

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Don't send drm sysfs hotplug events on initial master set

Kees Cook <keescook@chromium.org>
    gcc-plugins: Fix build failures under Darwin host

Benjamin Coddington <bcodding@redhat.com>
    Revert "lockd: Show pid of lockd for remote locks"

Roberto Bergantinos Corpas <rbergant@redhat.com>
    CIFS: cifs_read_allocate_pages: don't iterate through whole page array on ENOMEM

Tim Collier <osdevtc@gmail.com>
    staging: wlan-ng: fix adapter initialization failure

Dan Carpenter <dan.carpenter@oracle.com>
    staging: vc04_services: prevent integer overflow in create_pagelist()

George G. Davis <george_davis@mentor.com>
    serial: sh-sci: disable DMA for uart_console

Roberto Sassu <roberto.sassu@huawei.com>
    ima: show rules with IMA_INMASK correctly

Jonathan Corbet <corbet@lwn.net>
    doc: Cope with Sphinx logging deprecations

Jonathan Corbet <corbet@lwn.net>
    doc: Cope with the deprecation of AutoReporter

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

Thomas Huth <thuth@redhat.com>
    KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Set default power save node to 0

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/perf: Fix MMCRA corruption by bhrb_filter

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Do not clear IRQ data of passthrough interrupts

Filipe Manana <fdmanana@suse.com>
    Btrfs: incremental send, fix file corruption when no-holes feature is enabled

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix fsync not persisting changed attributes of a directory

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race updating log root item during fsync

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix wrong ctime and mtime of a directory after log replay

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

Russell King <rmk+kernel@armlinux.org.uk>
    net: phy: marvell10g: report if the PHY fails to boot firmware

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

Parav Pandit <parav@mellanox.com>
    net/mlx5: Allocate root ns memory using kzalloc to match kfree

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

Eric Dumazet <edumazet@google.com>
    inet: switch IP ID generator to siphash


-------------

Diffstat:

 Documentation/conf.py                              |   2 +-
 Documentation/sphinx/kerneldoc.py                  |  44 +++--
 Documentation/sphinx/kernellog.py                  |  28 +++
 Documentation/sphinx/kfigure.py                    |  40 ++--
 Makefile                                           |   4 +-
 arch/mips/kvm/mips.c                               |   3 +
 arch/powerpc/kvm/book3s_xive.c                     |   4 +-
 arch/powerpc/kvm/powerpc.c                         |   3 +
 arch/powerpc/perf/core-book3s.c                    |   6 +-
 arch/powerpc/perf/power8-pmu.c                     |   3 +
 arch/powerpc/perf/power9-pmu.c                     |   3 +
 arch/s390/kvm/kvm-s390.c                           |   1 +
 arch/sparc/mm/ultra.S                              |   4 +-
 arch/x86/kernel/vmlinux.lds.S                      |   6 +-
 arch/x86/kvm/x86.c                                 |   3 +
 drivers/crypto/vmx/ghash.c                         | 213 +++++++++------------
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h  |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c      |  26 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h      |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c     |  15 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c      |  21 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h      |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |   9 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   8 +-
 drivers/media/usb/siano/smsusb.c                   |  33 ++--
 drivers/media/usb/uvc/uvc_driver.c                 |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   4 +-
 drivers/net/ethernet/marvell/mvpp2.c               |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   3 +-
 drivers/net/phy/marvell10g.c                       |  14 ++
 drivers/net/usb/usbnet.c                           |   6 +
 drivers/s390/scsi/zfcp_ext.h                       |   1 +
 drivers/s390/scsi/zfcp_scsi.c                      |   9 +
 drivers/s390/scsi/zfcp_sysfs.c                     |  55 +++++-
 drivers/s390/scsi/zfcp_unit.c                      |   8 +-
 .../interface/vchiq_arm/vchiq_2835_arm.c           |   9 +
 drivers/staging/wlan-ng/hfa384x_usb.c              |   3 +-
 drivers/tty/serial/max310x.c                       |   2 +-
 drivers/tty/serial/msm_serial.c                    |   5 +-
 drivers/tty/serial/sh-sci.c                        |   7 +
 drivers/usb/core/config.c                          |   4 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/host/xhci-ring.c                       |  17 +-
 drivers/usb/host/xhci.c                            |  24 ++-
 drivers/usb/misc/rio500.c                          |  41 +++-
 drivers/usb/misc/sisusbvga/sisusb.c                |  15 +-
 drivers/usb/usbip/stub_dev.c                       |  75 +++++---
 drivers/xen/xen-pciback/pciback_ops.c              |   2 -
 fs/btrfs/inode.c                                   |  14 +-
 fs/btrfs/send.c                                    |   6 +
 fs/btrfs/tree-log.c                                |  20 +-
 fs/cifs/file.c                                     |   4 +-
 fs/lockd/xdr.c                                     |   4 +-
 fs/lockd/xdr4.c                                    |   4 +-
 include/linux/bitops.h                             |  16 +-
 include/linux/compiler-gcc.h                       |   4 +
 include/linux/compiler_types.h                     |   4 +
 include/linux/list_lru.h                           |   1 +
 include/linux/module.h                             |   4 +-
 include/linux/siphash.h                            |   5 +
 include/net/netns/ipv4.h                           |   2 +
 include/uapi/linux/tipc_config.h                   |  10 +-
 kernel/signal.c                                    |   2 +
 mm/list_lru.c                                      |   8 +-
 net/core/dev.c                                     |   2 +-
 net/ipv4/igmp.c                                    |  47 +++--
 net/ipv4/route.c                                   |  12 +-
 net/ipv6/output_core.c                             |  30 +--
 net/ipv6/raw.c                                     |   2 +
 net/llc/llc_output.c                               |   2 +
 net/tipc/core.c                                    |  32 ++--
 net/tipc/subscr.c                                  |  14 +-
 net/tipc/subscr.h                                  |   5 +-
 scripts/gcc-plugins/gcc-common.h                   |   4 +
 security/integrity/ima/ima_policy.c                |  21 +-
 sound/pci/hda/patch_realtek.c                      |   2 +-
 virt/kvm/arm/arm.c                                 |   3 +
 virt/kvm/kvm_main.c                                |   2 -
 82 files changed, 728 insertions(+), 369 deletions(-)


