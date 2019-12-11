Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573F411B826
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfLKQMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730482AbfLKPIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:08:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1870222C4;
        Wed, 11 Dec 2019 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076934;
        bh=/FjlNjSUJAfBIWHfskICqHVbbfG78y8PF1JsD8ipeis=;
        h=From:To:Cc:Subject:Date:From;
        b=jr6qiitdHt8hGzMqFH2T3ph46yfUS305QLjt+1DCFyzlhQwZCpvVxcLZdNeCVTPMz
         rYxH5EI2UzJxbG5wK3jcCQzqNVuOlnYnsl44hDbFdPd/DqXbi1tsqaThHLXfBkMvWK
         rso71OsY5WnqM7Ux/dfdCbTaUmnY4zsXow8A4vjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/92] 5.4.3-stable review
Date:   Wed, 11 Dec 2019 16:04:51 +0100
Message-Id: <20191211150221.977775294@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.3-rc1
X-KernelTest-Deadline: 2019-12-13T15:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.3 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.3-rc1

Jann Horn <jannh@google.com>
    binder: Handle start==NULL in binder_update_page_range()

Jann Horn <jannh@google.com>
    binder: Prevent repeated use of ->mmap() via NULL mapping

Jann Horn <jannh@google.com>
    binder: Fix race between mmap() and binder_alloc_print_pages()

Je Yen Tam <je.yen.tam@ni.com>
    Revert "serial/8250: Add support for NI-Serial PXI/PXIe+485 devices"

Nicolas Pitre <nico@fluxnic.net>
    vcs: prevent write access to vcsu devices

Wei Wang <wvw@google.com>
    thermal: Fix deadlock in thermal thermal_zone_device_check

Jan Kara <jack@suse.cz>
    iomap: Fix pipe page leakage during splicing

Jan Kara <jack@suse.cz>
    bdev: Refresh bdev size for disks without partitioning

Jan Kara <jack@suse.cz>
    bdev: Factor out bdev revalidation into a common helper

Marcel Holtmann <marcel@holtmann.org>
    rfkill: allocate static minor

Viresh Kumar <viresh.kumar@linaro.org>
    RDMA/qib: Validate ->show()/store() callbacks before calling them

Johan Hovold <johan@kernel.org>
    can: ucan: fix non-atomic allocation in completion handler

Gregory CLEMENT <gregory.clement@bootlin.com>
    spi: Fix NULL pointer when setting SPI_CS_HIGH for GPIO CS

Gregory CLEMENT <gregory.clement@bootlin.com>
    spi: Fix SPI_CS_HIGH setting when using native and GPIO CS

Gregory CLEMENT <gregory.clement@bootlin.com>
    spi: atmel: Fix CS high support

Patrice Chotard <patrice.chotard@st.com>
    spi: stm32-qspi: Fix kernel oops when unbinding driver

Frieder Schrempf <frieder.schrempf@kontron.de>
    spi: spi-fsl-qspi: Clear TDH bits in FLSHCR register

Navid Emamdoost <navid.emamdoost@gmail.com>
    crypto: user - fix memory leak in crypto_reportstat

Navid Emamdoost <navid.emamdoost@gmail.com>
    crypto: user - fix memory leak in crypto_report

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: ecdh - fix big endian bug in ECC library

Mark Salter <msalter@redhat.com>
    crypto: ccp - fix uninitialized list head

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: geode-aes - switch to skcipher for cbc(aes) fallback

Ayush Sawal <ayush.sawal@chelsio.com>
    crypto: af_alg - cast ki_complete ternary op to int

Tudor Ambarus <tudor.ambarus@microchip.com>
    crypto: atmel-aes - Fix IV handling when req->nbytes < ivsize

Christian Lamparter <chunkeey@gmail.com>
    crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Grab KVM's srcu lock when setting nested state

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Remove a spurious export of a static function

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: do not modify masked bits of shared MSRs

Zenghui Yu <yuzenghui@huawei.com>
    KVM: arm/arm64: vgic: Don't rely on the wrong pending table

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter

Greg Kurz <groug@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated

Greg Kurz <groug@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Fix potential page leak on error path

Greg Kurz <groug@kaod.org>
    KVM: PPC: Book3S HV: XIVE: Free previous EQ page when setting up a new one

Marek Szyprowski <m.szyprowski@samsung.com>
    arm64: dts: exynos: Revert "Remove unneeded address space mapping for soc node"

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Validate tagged addresses in access_ok() called from kernel threads

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i810: Prevent underflow in ioctl

Sean Paul <seanpaul@chromium.org>
    drm: damage_helper: Fix race checking plane->state->fb

Johan Hovold <johan@kernel.org>
    drm/msm: fix memleak on release

Jan Kara <jack@suse.cz>
    jbd2: Fix possible overflow in jbd2_log_space_left()

Tejun Heo <tj@kernel.org>
    kernfs: fix ino wrap-around detection

J. Bruce Fields <bfields@redhat.com>
    nfsd: restore NFSv3 ACL support

Trond Myklebust <trondmy@gmail.com>
    nfsd: Ensure CLONE persists data and metadata changes to the target file

Jouni Hogander <jouni.hogander@unikie.com>
    can: slcan: Fix use-after-free Read in slcan_open

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    tty: vt: keyboard: reject invalid keycodes

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix SMB2 oplock break processing

Pavel Shilovsky <pshilov@microsoft.com>
    CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks

Kai-Heng Feng <kai.heng.feng@canonical.com>
    x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect

Joerg Roedel <jroedel@suse.de>
    x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()

Sean Young <sean@mess.org>
    media: rc: mark input device as pointing stick

Navid Emamdoost <navid.emamdoost@gmail.com>
    Input: Fix memory leak in psxpad_spi_probe

Mike Leach <mike.leach@linaro.org>
    coresight: etm4x: Fix input validation for sysfs.

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add upside-down quirk for Teclast X89 tablet

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers

Lucas Stach <l.stach@pengutronix.de>
    Input: synaptics-rmi4 - re-enable IRQs in f34v7_do_reflash

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Input: synaptics - switch another X1 Carbon 6 to RMI/SMbus

Bibby Hsieh <bibby.hsieh@mediatek.com>
    soc: mediatek: cmdq: fixup wrong input order of write api

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Modify stream stripe mask only when needed

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda - Add mute led support for HP ProBook 645 G4

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Avoid potential buffer overflows

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix inverted bass GPIO pin on Acer 8951G

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable internal speaker of ASUS UX431FLC

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Avoid RPC delays when exiting suspend

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure req->submit is copied when req is deferred

Jens Axboe <axboe@kernel.dk>
    io_uring: fix missing kmap() declaration on powerpc

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify attributes

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify write return

Miklos Szeredi <mszeredi@redhat.com>
    fuse: verify nlink

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix leak of fuse_io_priv

Jens Axboe <axboe@kernel.dk>
    io_uring: transform send/recvmsg() -ERESTARTSYS to -EINTR

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix dead-hung for non-iter fixed rw

Ulf Hansson <ulf.hansson@linaro.org>
    mwifiex: Re-work support for SDIO HW reset

Chuhong Yuan <hslester96@gmail.com>
    serial: ifx6x60: add missed pm_runtime_disable

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Avoid double error messaging when IRQ absent

Fabrice Gasnier <fabrice.gasnier@st.com>
    serial: stm32: fix clearing interrupt error flags

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    serial: serial_core: Perform NULL checks for break_ctl ops

Vincent Whitchurch <vincent.whitchurch@axis.com>
    serial: pl011: Fix DMA ->flush_buffer()

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    tty: serial: msm_serial: Fix flow control

Peng Fan <peng.fan@nxp.com>
    tty: serial: fsl_lpuart: use the sg count from dma_map_sg

Frank Wunderlich <frank-w@public-files.de>
    serial: 8250-mtk: Use platform_get_irq_optional() for optional irq

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    usb: gadget: u_serial: add missing port entry locking

Paul Burton <paulburton@kernel.org>
    staging/octeon: Use stubs for MIPS && !CAVIUM_OCTEON_SOC

Jon Hunter <jonathanh@nvidia.com>
    mailbox: tegra: Fix superfluous IRQ error message

Dmitry Safonov <0x7f454c46@gmail.com>
    time: Zero the upper 32-bits in __kernel_timespec on 32-bit

Arnd Bergmann <arnd@arndb.de>
    lp: fix sparc64 LPSETTIMEOUT ioctl

Tuowen Zhao <ztuowen@gmail.com>
    sparc64: implement ioremap_uc

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix use of TRUE with SQLite

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix 'active-low' warning for Jetson Xavier regulator

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator

Navid Emamdoost <navid.emamdoost@gmail.com>
    rsi: release skb if rsi_prepare_beacon fails


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/exynos/exynos5433.dtsi         |   6 +-
 arch/arm64/boot/dts/exynos/exynos7.dtsi            |   6 +-
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi     |   3 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |   2 +-
 arch/arm64/include/asm/uaccess.h                   |   7 +-
 arch/powerpc/kvm/book3s_xive.c                     |  11 +-
 arch/powerpc/kvm/book3s_xive_native.c              |  46 ++--
 arch/sparc/include/asm/io_64.h                     |   1 +
 arch/x86/kvm/vmx/nested.c                          |  10 +
 arch/x86/kvm/vmx/vmx.c                             |  10 +-
 arch/x86/kvm/x86.c                                 |  17 +-
 arch/x86/mm/fault.c                                |   2 +-
 arch/x86/pci/fixup.c                               |  11 +
 crypto/af_alg.c                                    |   2 +-
 crypto/crypto_user_base.c                          |   4 +-
 crypto/crypto_user_stat.c                          |   4 +-
 crypto/ecc.c                                       |   3 +-
 drivers/android/binder_alloc.c                     |  41 +--
 drivers/char/lp.c                                  |   4 +
 drivers/crypto/amcc/crypto4xx_core.c               |   6 +-
 drivers/crypto/atmel-aes.c                         |  53 ++--
 drivers/crypto/ccp/ccp-dmaengine.c                 |   1 +
 drivers/crypto/geode-aes.c                         |  57 ++--
 drivers/crypto/geode-aes.h                         |   2 +-
 drivers/gpu/drm/drm_damage_helper.c                |   8 +-
 drivers/gpu/drm/i810/i810_dma.c                    |   4 +-
 drivers/gpu/drm/msm/msm_debugfs.c                  |   6 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |  21 +-
 drivers/infiniband/hw/qib/qib_sysfs.c              |   6 +
 drivers/input/joystick/psxpad-spi.c                |   2 +-
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/rmi4/rmi_f34v7.c                     |   3 +
 drivers/input/rmi4/rmi_smbus.c                     |   2 -
 drivers/input/touchscreen/goodix.c                 |   9 +
 drivers/mailbox/tegra-hsp.c                        |   4 +-
 drivers/media/rc/rc-main.c                         |   1 +
 drivers/net/can/slcan.c                            |   1 +
 drivers/net/can/usb/ucan.c                         |   2 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   5 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |   1 +
 drivers/net/wireless/marvell/mwifiex/sdio.c        |  33 ++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   1 +
 drivers/soc/mediatek/mtk-cmdq-helper.c             |   2 +-
 drivers/spi/spi-atmel.c                            |   6 +-
 drivers/spi/spi-fsl-qspi.c                         |  38 ++-
 drivers/spi/spi-stm32-qspi.c                       |   3 +-
 drivers/spi/spi.c                                  |  19 +-
 drivers/staging/octeon/octeon-ethernet.h           |   2 +-
 drivers/staging/octeon/octeon-stubs.h              |   5 +-
 drivers/thermal/thermal_core.c                     |   4 +-
 drivers/tty/serial/8250/8250_dw.c                  |   8 +-
 drivers/tty/serial/8250/8250_mtk.c                 |   2 +-
 drivers/tty/serial/8250/8250_pci.c                 | 292 +--------------------
 drivers/tty/serial/amba-pl011.c                    |   6 +-
 drivers/tty/serial/fsl_lpuart.c                    |   4 +-
 drivers/tty/serial/ifx6x60.c                       |   3 +
 drivers/tty/serial/msm_serial.c                    |   6 +-
 drivers/tty/serial/serial_core.c                   |   2 +-
 drivers/tty/serial/stm32-usart.c                   |   6 +-
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/tty/vt/vc_screen.c                         |   3 +
 drivers/usb/gadget/function/u_serial.c             |   2 +
 fs/block_dev.c                                     |  37 +--
 fs/cifs/file.c                                     |   7 +-
 fs/cifs/smb2misc.c                                 |   7 +-
 fs/fuse/dir.c                                      |  25 +-
 fs/fuse/file.c                                     |   6 +-
 fs/fuse/fuse_i.h                                   |   2 +
 fs/fuse/readdir.c                                  |   2 +-
 fs/io_uring.c                                      |  27 +-
 fs/iomap/direct-io.c                               |   9 +-
 fs/kernfs/dir.c                                    |   5 +-
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/nfsd/nfssvc.c                                   |   3 +-
 fs/nfsd/vfs.c                                      |   8 +-
 fs/nfsd/vfs.h                                      |   2 +-
 include/linux/jbd2.h                               |   4 +-
 include/linux/kernfs.h                             |   1 +
 include/linux/miscdevice.h                         |   1 +
 include/sound/hdaudio.h                            |   1 +
 kernel/time/time.c                                 |   3 +-
 net/rfkill/core.c                                  |   9 +-
 net/sunrpc/sched.c                                 |   2 +-
 sound/core/oss/linear.c                            |   2 +
 sound/core/oss/mulaw.c                             |   2 +
 sound/core/oss/route.c                             |   2 +
 sound/hda/hdac_stream.c                            |  19 +-
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_hdmi.c                         |   5 +
 sound/pci/hda/patch_realtek.c                      |  35 +--
 tools/perf/scripts/python/exported-sql-viewer.py   |  10 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |   6 +-
 93 files changed, 523 insertions(+), 561 deletions(-)


