Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777E7390E7
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbfFGPpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730622AbfFGPpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:45:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5112A21479;
        Fri,  7 Jun 2019 15:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922312;
        bh=J0LYRP+LppoxHOmAdc2gQHJjrDiSpLZ6wrxVraJ2rNA=;
        h=From:To:Cc:Subject:Date:From;
        b=qXthH++oyblHpzMDCwGMzK+Mght/DlC/AGasa9Xq+fHTEdnLvjEy1r8DguMar1gd7
         VUnVu7zs5qKgaIxLeY1JEPTIrrdBhshKOvZJq2uauAAebEBI0ozu/q3YRcnBARvB/z
         ldZ+74f7sCjPgjidRGh8fyWP9CxR7bX7Hd6hR8jY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/73] 4.19.49-stable review
Date:   Fri,  7 Jun 2019 17:38:47 +0200
Message-Id: <20190607153848.669070800@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.49-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.49-rc1
X-KernelTest-Deadline: 2019-06-09T15:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.49 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 09 Jun 2019 03:37:11 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.49-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.49-rc1

Nadav Amit <namit@vmware.com>
    media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

Frank Rowand <frank.rowand@sony.com>
    of: overlay: set node fields from properties when add new overlay node

Frank Rowand <frank.rowand@sony.com>
    of: overlay: validate overlay properties #address-cells and #size-cells

Nathan Chancellor <natechancellor@gmail.com>
    scsi: lpfc: Fix backport of faf5a744f4f8 ("scsi: lpfc: avoid uninitialized variable warning")

Nadav Amit <namit@vmware.com>
    x86/kprobes: Set instruction page as executable

Nadav Amit <namit@vmware.com>
    x86/ftrace: Set trampoline pages as executable

Steven Rostedt (VMware) <rostedt@goodmis.org>
    x86/ftrace: Do not call function graph from dynamic trampolines

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

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/lease: Make sure implicit planes are leased

Vicente Bergas <vicencb@gmail.com>
    drm/rockchip: shutdown drm subsystem on shutdown

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Fix sun8i HDMI PHY configuration for > 148.5 MHz

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Fix sun8i HDMI PHY clock initialization

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Don't send drm sysfs hotplug events on initial master set

Dmitry Osipenko <digetx@gmail.com>
    drm/tegra: gem: Fix CPU-cache maintenance for BO's allocated using get_pages()

Kees Cook <keescook@chromium.org>
    gcc-plugins: Fix build failures under Darwin host

Benjamin Coddington <bcodding@redhat.com>
    Revert "lockd: Show pid of lockd for remote locks"

Roberto Bergantinos Corpas <rbergant@redhat.com>
    CIFS: cifs_read_allocate_pages: don't iterate through whole page array on ENOMEM

Colin Ian King <colin.king@canonical.com>
    cifs: fix memory leak of pneg_inbuf on -EOPNOTSUPP ioctl case

Tim Collier <osdevtc@gmail.com>
    staging: wlan-ng: fix adapter initialization failure

Dan Carpenter <dan.carpenter@oracle.com>
    staging: vc04_services: prevent integer overflow in create_pagelist()

George G. Davis <george_davis@mentor.com>
    serial: sh-sci: disable DMA for uart_console

Grzegorz Halat <ghalat@redhat.com>
    vt/fbcon: deinitialize resources in visual_init() after failed memory allocation

Roberto Sassu <roberto.sassu@huawei.com>
    evm: check hash algorithm passed to init_desc()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: show rules with IMA_INMASK correctly

Jonathan Corbet <corbet@lwn.net>
    doc: Cope with Sphinx logging deprecations

Jonathan Corbet <corbet@lwn.net>
    doc: Cope with the deprecation of AutoReporter

Jonathan Corbet <corbet@lwn.net>
    docs: Fix conf.py for Sphinx 2.0

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Fix the arm64_personality() syscall wrapper redirection

Zhenliang Wei <weizhenliang@huawei.com>
    kernel/signal.c: trace_signal_deliver when signal_group_exit

Jiri Slaby <jslaby@suse.cz>
    memcg: make it work on sparse non-0-node systems

Joe Burmeister <joe.burmeister@devtank.co.uk>
    tty: max310x: Fix external crystal register setup

Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
    tty: serial: msm_serial: Fix XON/XOFF

Masahisa Kojima <masahisa.kojima@linaro.org>
    i2c: synquacer: fix synquacer_i2c_doxfer() return value

Vadim Pasternak <vadimp@mellanox.com>
    i2c: mlxcpld: Fix wrong initialization order in probe

Lyude Paul <lyude@redhat.com>
    drm/nouveau/i2c: Disable i2c bus access after ->fini()

Thomas Huth <thuth@redhat.com>
    KVM: s390: Do not report unusabled IDs via KVM_CAP_MAX_VCPU_ID

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Improve the headset mic for Acer Aspire laptops

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Set default power save node to 0

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Assure canceling delayed work at disconnection

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/perf: Fix MMCRA corruption by bhrb_filter

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Do not clear IRQ data of passthrough interrupts

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: fix possible sleep during spinlock aquired

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: fix gcm-aes-s390 selftest failures

Sean Nyekjaer <sean@geanix.com>
    iio: adc: ti-ads8688: fix timestamp is not updated in buffer

Ruslan Babayev <ruslan@babayev.com>
    iio: dac: ds4422/ds4424 fix chip verification

Filipe Manana <fdmanana@suse.com>
    Btrfs: incremental send, fix file corruption when no-holes feature is enabled

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix fsync not persisting changed attributes of a directory

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix race updating log root item during fsync

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix wrong ctime and mtime of a directory after log replay

Tomas Bortoli <tomasbortoli@gmail.com>
    tracing: Avoid memory leak in predicate_parse()

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix to prevent port_remove with pure auto scan LUNs (only sdevs)

Steffen Maier <maier@linux.ibm.com>
    scsi: zfcp: fix missing zfcp_port reference put on -EBUSY from port_remove

Piotr Figiel <p.figiel@camlintechnologies.com>
    brcmfmac: fix NULL pointer derefence during USB disconnect

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


-------------

Diffstat:

 Documentation/conf.py                              |   2 +-
 Documentation/sphinx/kerneldoc.py                  |  44 ++++--
 Documentation/sphinx/kernellog.py                  |  28 ++++
 Documentation/sphinx/kfigure.py                    |  40 +++---
 Makefile                                           |   4 +-
 arch/arm64/kernel/sys.c                            |   2 +-
 arch/mips/kvm/mips.c                               |   3 +
 arch/powerpc/kvm/book3s_xive.c                     |   4 +-
 arch/powerpc/kvm/powerpc.c                         |   3 +
 arch/powerpc/perf/core-book3s.c                    |   6 +-
 arch/powerpc/perf/power8-pmu.c                     |   3 +
 arch/powerpc/perf/power9-pmu.c                     |   3 +
 arch/s390/crypto/aes_s390.c                        | 156 +++++++++++++++------
 arch/s390/crypto/des_s390.c                        |   7 +-
 arch/s390/kvm/kvm-s390.c                           |   1 +
 arch/sparc/mm/ultra.S                              |   4 +-
 arch/x86/kernel/ftrace.c                           |  49 ++++---
 arch/x86/kernel/ftrace_64.S                        |   8 +-
 arch/x86/kernel/kprobes/core.c                     |  24 +++-
 arch/x86/kernel/vmlinux.lds.S                      |   6 +-
 arch/x86/kvm/x86.c                                 |   3 +
 drivers/gpu/drm/drm_crtc.c                         |   4 +
 drivers/gpu/drm/drm_plane.c                        |   8 ++
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h  |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c      |  26 +++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h      |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c     |  15 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c      |  21 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h      |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |   9 ++
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |  29 ++--
 drivers/gpu/drm/tegra/gem.c                        |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   8 +-
 drivers/i2c/busses/i2c-mlxcpld.c                   |   2 +-
 drivers/i2c/busses/i2c-synquacer.c                 |   2 +-
 drivers/iio/adc/ti-ads8688.c                       |   2 +-
 drivers/iio/dac/ds4424.c                           |   2 +-
 drivers/media/usb/siano/smsusb.c                   |  33 +++--
 drivers/media/usb/uvc/uvc_driver.c                 |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   4 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  16 ++-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |   3 +-
 drivers/of/dynamic.c                               |  27 ++--
 drivers/of/overlay.c                               |  61 ++++++--
 drivers/s390/scsi/zfcp_ext.h                       |   1 +
 drivers/s390/scsi/zfcp_scsi.c                      |   9 ++
 drivers/s390/scsi/zfcp_sysfs.c                     |  55 +++++++-
 drivers/s390/scsi/zfcp_unit.c                      |   8 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   6 +-
 .../interface/vchiq_arm/vchiq_2835_arm.c           |   9 ++
 drivers/staging/wlan-ng/hfa384x_usb.c              |   3 +-
 drivers/tty/serial/max310x.c                       |   2 +-
 drivers/tty/serial/msm_serial.c                    |   5 +-
 drivers/tty/serial/sh-sci.c                        |   7 +
 drivers/tty/vt/vt.c                                |  11 +-
 drivers/usb/core/config.c                          |   4 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/host/xhci-ring.c                       |  17 ++-
 drivers/usb/host/xhci.c                            |  24 ++--
 drivers/usb/misc/rio500.c                          |  41 ++++--
 drivers/usb/misc/sisusbvga/sisusb.c                |  15 +-
 drivers/usb/usbip/stub_dev.c                       |  75 +++++++---
 drivers/video/fbdev/core/fbcon.c                   |   2 +-
 fs/btrfs/inode.c                                   |  14 +-
 fs/btrfs/send.c                                    |   6 +
 fs/btrfs/tree-log.c                                |  20 +--
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/smb2pdu.c                                  |   3 +-
 fs/lockd/xdr.c                                     |   4 +-
 fs/lockd/xdr4.c                                    |   4 +-
 include/linux/bitops.h                             |  16 +--
 include/linux/compiler-gcc.h                       |   4 +
 include/linux/compiler_types.h                     |   4 +
 include/linux/list_lru.h                           |   1 +
 include/linux/module.h                             |   4 +-
 include/linux/of.h                                 |   6 +
 kernel/signal.c                                    |   2 +
 kernel/trace/trace_events_filter.c                 |   8 +-
 mm/list_lru.c                                      |   8 +-
 scripts/gcc-plugins/gcc-common.h                   |   4 +
 security/integrity/evm/evm_crypto.c                |   3 +
 security/integrity/ima/ima_policy.c                |  21 +--
 sound/pci/hda/patch_realtek.c                      |  18 ++-
 sound/usb/line6/driver.c                           |  12 ++
 sound/usb/line6/driver.h                           |   4 +
 sound/usb/line6/toneport.c                         |  15 +-
 virt/kvm/arm/arm.c                                 |   3 +
 virt/kvm/kvm_main.c                                |   2 -
 92 files changed, 878 insertions(+), 322 deletions(-)


