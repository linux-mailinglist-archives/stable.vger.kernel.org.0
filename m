Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC23E3908C
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbfFGPsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731727AbfFGPsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:48:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C236820657;
        Fri,  7 Jun 2019 15:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922489;
        bh=FoYZ2qz7FYax+8x73t1YKGO6eWAo+TDjA9mTcwr1nJo=;
        h=From:To:Cc:Subject:Date:From;
        b=xAOO8ukKObU+lXHd5e+ePMX9Dq+qZMw63OEQNJXE8FdfsZNdDxzYL5aaH8gtfS32F
         0NGRVW74QhgD8ADefZI+lNLGotxoBF4IW00ID0M6imB6SczdBaYm50kklTN3kxBXgB
         cRkWLtSkBnMrfk40qCVksXfCHhvWzJm66c2bmfSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.1 00/85] 5.1.8-stable review
Date:   Fri,  7 Jun 2019 17:38:45 +0200
Message-Id: <20190607153849.101321647@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.1.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.1.8-rc1
X-KernelTest-Deadline: 2019-06-09T15:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.1.8 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 09 Jun 2019 03:37:09 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.1.8-rc1

Nadav Amit <namit@vmware.com>
    x86/kprobes: Set instruction page as executable

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "x86/build: Move _etext to actual end of .text"

Noralf Trønnes <noralf@tronnes.org>
    drm/cma-helper: Fix drm_gem_cma_free_object()

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/lease: Make sure implicit planes are leased

Vicente Bergas <vicencb@gmail.com>
    drm/rockchip: shutdown drm subsystem on shutdown

Deepak Rawat <drawat@vmware.com>
    drm: Expose "FB_DAMAGE_CLIPS" property to atomic aware user-space only

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/atomic: Wire file_priv through for property changes

Noralf Trønnes <noralf@tronnes.org>
    drm/fb-helper: generic: Call drm_client_add() after setup is done

Philipp Zabel <p.zabel@pengutronix.de>
    drm/imx: ipuv3-plane: fix atomic update status query for non-plus i.MX6Q

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Fix sun8i HDMI PHY configuration for > 148.5 MHz

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: Fix sun8i HDMI PHY clock initialization

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Don't send drm sysfs hotplug events on initial master set

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix compat mode shader operation

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix user space handle equal to zero

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

Peng Fan <peng.fan@nxp.com>
    clk: imx: imx8mm: fix int pll clk gate

Roberto Sassu <roberto.sassu@huawei.com>
    evm: check hash algorithm passed to init_desc()

Roberto Sassu <roberto.sassu@huawei.com>
    ima: show rules with IMA_INMASK correctly

Petr Vorel <pvorel@suse.cz>
    ima: fix wrong signed policy requirement when not appraising

Scott Wood <swood@redhat.com>
    x86/ima: Check EFI_RUNTIME_SERVICES before using

Jonathan Corbet <corbet@lwn.net>
    doc: Cope with Sphinx logging deprecations

Jonathan Corbet <corbet@lwn.net>
    doc: Cope with the deprecation of AutoReporter

Jonathan Corbet <corbet@lwn.net>
    docs: Fix conf.py for Sphinx 2.0

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Fix the arm64_personality() syscall wrapper redirection

Suzuki K Poulose <suzuki.poulose@arm.com>
    mm, compaction: make sure we isolate a valid PFN

Eric W. Biederman <ebiederm@xmission.com>
    signal/arm64: Use force_sig not force_sig_fault for SIGKILL

Zhenliang Wei <weizhenliang@huawei.com>
    kernel/signal.c: trace_signal_deliver when signal_group_exit

Nathan Chancellor <natechancellor@gmail.com>
    kasan: initialize tag to 0xff in __kasan_kmalloc

Jiri Slaby <jslaby@suse.cz>
    memcg: make it work on sparse non-0-node systems

Chris Down <chris@chrisdown.name>
    mm, memcg: consider subtrees in memory.events

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

Thiago Jung Bauermann <bauerman@linux.ibm.com>
    powerpc/kexec: Fix loading of kernel + initramfs with kexec_file_load()

Ravi Bangoria <ravi.bangoria@linux.ibm.com>
    powerpc/perf: Fix MMCRA corruption by bhrb_filter

Suraj Jitindar Singh <sjitindarsingh@gmail.com>
    KVM: PPC: Book3S HV: Restore SPRG3 in kvmhv_p9_guest_entry()

Paul Mackerras <paulus@ozlabs.org>
    KVM: PPC: Book3S HV: Fix lockdep warning when entering guest on POWER9

Cédric Le Goater <clg@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Do not clear IRQ data of passthrough interrupts

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: fix possible sleep during spinlock aquired

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: fix gcm-aes-s390 selftest failures

Sean Nyekjaer <sean@geanix.com>
    iio: adc: ti-ads8688: fix timestamp is not updated in buffer

Tomer Maimon <tmaimon77@gmail.com>
    iio: adc: modify NPCM ADC read reference voltage

Vincent Stehlé <vincent.stehle@laposte.net>
    iio: adc: ads124: avoid buffer overflow

Ruslan Babayev <ruslan@babayev.com>
    iio: dac: ds4422/ds4424 fix chip verification

Qu Wenruo <wqu@suse.com>
    btrfs: reloc: Also queue orphan reloc tree for cleanup to avoid BUG_ON()

Filipe Manana <fdmanana@suse.com>
    Btrfs: incremental send, fix file corruption when no-holes feature is enabled

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: Check bg while resuming relocation to avoid NULL pointer dereference

Dennis Zhou <dennis@kernel.org>
    btrfs: correct zstd workspace manager lock to use spin_lock_bh()

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

 Documentation/admin-guide/cgroup-v2.rst            |   9 ++
 Documentation/conf.py                              |   2 +-
 Documentation/sphinx/kerneldoc.py                  |  44 ++++--
 Documentation/sphinx/kernellog.py                  |  28 ++++
 Documentation/sphinx/kfigure.py                    |  40 +++---
 Makefile                                           |   4 +-
 arch/arm64/kernel/sys.c                            |   2 +-
 arch/arm64/kernel/traps.c                          |   5 +-
 arch/mips/kvm/mips.c                               |   3 +
 arch/powerpc/kernel/kexec_elf_64.c                 |   6 +-
 arch/powerpc/kvm/book3s_hv.c                       |   8 +-
 arch/powerpc/kvm/book3s_xive.c                     |   4 +-
 arch/powerpc/kvm/powerpc.c                         |   3 +
 arch/powerpc/perf/core-book3s.c                    |   6 +-
 arch/powerpc/perf/power8-pmu.c                     |   3 +
 arch/powerpc/perf/power9-pmu.c                     |   3 +
 arch/s390/crypto/aes_s390.c                        | 156 +++++++++++++++------
 arch/s390/crypto/des_s390.c                        |   7 +-
 arch/s390/kvm/kvm-s390.c                           |   1 +
 arch/sparc/mm/ultra.S                              |   4 +-
 arch/x86/kernel/ima_arch.c                         |   5 +
 arch/x86/kernel/kprobes/core.c                     |  24 +++-
 arch/x86/kernel/vmlinux.lds.S                      |   6 +-
 arch/x86/kvm/x86.c                                 |   3 +
 drivers/clk/imx/clk-imx8mm.c                       |  12 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |  32 +++--
 drivers/gpu/drm/drm_crtc.c                         |   4 +
 drivers/gpu/drm/drm_crtc_internal.h                |   1 +
 drivers/gpu/drm/drm_fb_helper.c                    |   4 +-
 drivers/gpu/drm/drm_gem_cma_helper.c               |   8 +-
 drivers/gpu/drm/drm_mode_config.c                  |   5 +-
 drivers/gpu/drm/drm_mode_object.c                  |   5 +-
 drivers/gpu/drm/drm_plane.c                        |   8 ++
 drivers/gpu/drm/imx/ipuv3-plane.c                  |  13 +-
 drivers/gpu/drm/imx/ipuv3-plane.h                  |   1 -
 drivers/gpu/drm/nouveau/include/nvkm/subdev/i2c.h  |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c      |  26 +++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.h      |   2 +
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c     |  15 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.c      |  21 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/bus.h      |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c        |   9 ++
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |  29 ++--
 drivers/gpu/drm/tegra/gem.c                        |   4 +-
 drivers/gpu/drm/vmwgfx/ttm_object.c                |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  13 ++
 drivers/i2c/busses/i2c-mlxcpld.c                   |   2 +-
 drivers/i2c/busses/i2c-synquacer.c                 |   2 +-
 drivers/iio/adc/npcm_adc.c                         |   2 +-
 drivers/iio/adc/ti-ads124s08.c                     |   2 +-
 drivers/iio/adc/ti-ads8688.c                       |   2 +-
 drivers/iio/dac/ds4424.c                           |   2 +-
 drivers/media/usb/siano/smsusb.c                   |  33 +++--
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   4 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  16 ++-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |   3 +-
 drivers/s390/scsi/zfcp_ext.h                       |   1 +
 drivers/s390/scsi/zfcp_scsi.c                      |   9 ++
 drivers/s390/scsi/zfcp_sysfs.c                     |  55 +++++++-
 drivers/s390/scsi/zfcp_unit.c                      |   8 +-
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
 fs/btrfs/qgroup.c                                  |   8 +-
 fs/btrfs/relocation.c                              |  27 ++--
 fs/btrfs/send.c                                    |   6 +
 fs/btrfs/tree-log.c                                |  20 +--
 fs/btrfs/zstd.c                                    |  20 +--
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/smb2pdu.c                                  |   3 +-
 fs/lockd/xdr.c                                     |   4 +-
 fs/lockd/xdr4.c                                    |   4 +-
 include/linux/bitops.h                             |  16 +--
 include/linux/cgroup-defs.h                        |   5 +
 include/linux/list_lru.h                           |   1 +
 include/linux/memcontrol.h                         |  10 +-
 kernel/cgroup/cgroup.c                             |  16 ++-
 kernel/signal.c                                    |   2 +
 kernel/trace/trace_events_filter.c                 |   8 +-
 mm/compaction.c                                    |   2 +-
 mm/kasan/common.c                                  |   2 +-
 mm/list_lru.c                                      |   8 +-
 scripts/gcc-plugins/gcc-common.h                   |   4 +
 security/integrity/evm/evm_crypto.c                |   3 +
 security/integrity/ima/ima_policy.c                |  28 ++--
 sound/pci/hda/patch_realtek.c                      |  18 ++-
 sound/usb/line6/driver.c                           |  12 ++
 sound/usb/line6/driver.h                           |   4 +
 sound/usb/line6/toneport.c                         |  15 +-
 virt/kvm/arm/arm.c                                 |   3 +
 virt/kvm/kvm_main.c                                |   2 -
 108 files changed, 913 insertions(+), 346 deletions(-)


