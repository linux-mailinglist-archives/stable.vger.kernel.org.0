Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4990411EBEA
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 21:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbfLMUgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 15:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728991AbfLMUgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 15:36:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9312246FB;
        Fri, 13 Dec 2019 20:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576269363;
        bh=Xz/Z6YMNkuoYlim01fyFMx56e4GfKm9AiP1M9eN7CBY=;
        h=Date:From:To:Cc:Subject:From;
        b=R2j/S25ZiWbvNlQ2hk2SnmDCXLUuXFjGpiaMkOgLyPaA3/K8QDdyamSaEWpjFdafh
         GOIpWqPH4clxCLH816JkPGIpFkWf4gvVD58Xv4aWBELixolp7GAe5E8dxBgbT6UwYm
         hC0zbIl0bGw7z+DxEOY1/nozZ3ig6oPINpA4i1bc=
Date:   Fri, 13 Dec 2019 17:15:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.3
Message-ID: <20191213161522.GA2686216@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.3 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/arm64/boot/dts/exynos/exynos5433.dtsi          |    6=20
 arch/arm64/boot/dts/exynos/exynos7.dtsi             |    6=20
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi      |    3=20
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi      |    2=20
 arch/arm64/include/asm/uaccess.h                    |    7=20
 arch/powerpc/kvm/book3s_xive.c                      |   11=20
 arch/powerpc/kvm/book3s_xive_native.c               |   46 ++-
 arch/sparc/include/asm/io_64.h                      |    1=20
 arch/x86/kvm/cpuid.c                                |    5=20
 arch/x86/kvm/vmx/nested.c                           |   10=20
 arch/x86/kvm/vmx/vmx.c                              |   10=20
 arch/x86/kvm/x86.c                                  |   17 -
 arch/x86/mm/fault.c                                 |    2=20
 arch/x86/pci/fixup.c                                |   11=20
 crypto/af_alg.c                                     |    2=20
 crypto/crypto_user_base.c                           |    4=20
 crypto/crypto_user_stat.c                           |    4=20
 crypto/ecc.c                                        |    3=20
 drivers/android/binder_alloc.c                      |   41 +-
 drivers/char/lp.c                                   |    4=20
 drivers/cpufreq/imx-cpufreq-dt.c                    |   20 -
 drivers/crypto/amcc/crypto4xx_core.c                |    6=20
 drivers/crypto/atmel-aes.c                          |   53 ++-
 drivers/crypto/ccp/ccp-dmaengine.c                  |    1=20
 drivers/crypto/geode-aes.c                          |   57 ++-
 drivers/crypto/geode-aes.h                          |    2=20
 drivers/edac/ghes_edac.c                            |   90 ++++--
 drivers/gpu/drm/drm_damage_helper.c                 |    8=20
 drivers/gpu/drm/i810/i810_dma.c                     |    4=20
 drivers/gpu/drm/mcde/mcde_drv.c                     |    3=20
 drivers/gpu/drm/msm/msm_debugfs.c                   |    6=20
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c |   21 -
 drivers/infiniband/hw/qib/qib_sysfs.c               |    6=20
 drivers/input/joystick/psxpad-spi.c                 |    2=20
 drivers/input/mouse/synaptics.c                     |    1=20
 drivers/input/rmi4/rmi_f34v7.c                      |    3=20
 drivers/input/rmi4/rmi_smbus.c                      |    2=20
 drivers/input/touchscreen/goodix.c                  |    9=20
 drivers/mailbox/tegra-hsp.c                         |    4=20
 drivers/md/raid0.c                                  |    2=20
 drivers/media/rc/rc-main.c                          |    1=20
 drivers/net/can/slcan.c                             |    1=20
 drivers/net/can/usb/ucan.c                          |    2=20
 drivers/net/wireless/marvell/mwifiex/main.c         |    5=20
 drivers/net/wireless/marvell/mwifiex/main.h         |    1=20
 drivers/net/wireless/marvell/mwifiex/sdio.c         |   33 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c             |    1=20
 drivers/soc/mediatek/mtk-cmdq-helper.c              |    2=20
 drivers/spi/spi-atmel.c                             |    6=20
 drivers/spi/spi-fsl-qspi.c                          |   38 ++
 drivers/spi/spi-stm32-qspi.c                        |    3=20
 drivers/spi/spi.c                                   |   19 -
 drivers/staging/octeon/octeon-ethernet.h            |    2=20
 drivers/staging/octeon/octeon-stubs.h               |    5=20
 drivers/thermal/thermal_core.c                      |    4=20
 drivers/tty/serial/8250/8250_dw.c                   |    8=20
 drivers/tty/serial/8250/8250_mtk.c                  |    2=20
 drivers/tty/serial/8250/8250_pci.c                  |  292 ---------------=
-----
 drivers/tty/serial/amba-pl011.c                     |    6=20
 drivers/tty/serial/fsl_lpuart.c                     |    4=20
 drivers/tty/serial/ifx6x60.c                        |    3=20
 drivers/tty/serial/msm_serial.c                     |    6=20
 drivers/tty/serial/serial_core.c                    |    2=20
 drivers/tty/serial/stm32-usart.c                    |    6=20
 drivers/tty/vt/keyboard.c                           |    2=20
 drivers/tty/vt/vc_screen.c                          |    3=20
 drivers/usb/gadget/function/u_serial.c              |    2=20
 drivers/watchdog/aspeed_wdt.c                       |   16 -
 fs/block_dev.c                                      |   37 +-
 fs/cifs/file.c                                      |    7=20
 fs/cifs/smb2misc.c                                  |    7=20
 fs/fuse/dir.c                                       |   25 +
 fs/fuse/file.c                                      |    6=20
 fs/fuse/fuse_i.h                                    |    2=20
 fs/fuse/readdir.c                                   |    2=20
 fs/io_uring.c                                       |   27 +
 fs/iomap/direct-io.c                                |    9=20
 fs/kernfs/dir.c                                     |    5=20
 fs/nfsd/nfs4proc.c                                  |    3=20
 fs/nfsd/nfssvc.c                                    |    3=20
 fs/nfsd/vfs.c                                       |    8=20
 fs/nfsd/vfs.h                                       |    2=20
 include/linux/jbd2.h                                |    4=20
 include/linux/kernfs.h                              |    1=20
 include/linux/miscdevice.h                          |    1=20
 include/sound/hdaudio.h                             |    1=20
 kernel/time/time.c                                  |    3=20
 net/rfkill/core.c                                   |    9=20
 net/sunrpc/sched.c                                  |    2=20
 sound/core/oss/linear.c                             |    2=20
 sound/core/oss/mulaw.c                              |    2=20
 sound/core/oss/route.c                              |    2=20
 sound/hda/hdac_stream.c                             |   19 -
 sound/pci/hda/hda_bind.c                            |    4=20
 sound/pci/hda/hda_intel.c                           |    3=20
 sound/pci/hda/patch_conexant.c                      |    1=20
 sound/pci/hda/patch_hdmi.c                          |    5=20
 sound/pci/hda/patch_realtek.c                       |   35 +-
 tools/perf/builtin-script.c                         |    2=20
 tools/perf/scripts/python/exported-sql-viewer.py    |   10=20
 tools/testing/selftests/Makefile                    |    2=20
 virt/kvm/arm/vgic/vgic-v3.c                         |    6=20
 103 files changed, 624 insertions(+), 605 deletions(-)

Adrian Hunter (2):
      perf scripts python: exported-sql-viewer.py: Fix use of TRUE with SQL=
ite
      perf script: Fix invalid LBR/binary mismatch error

Andy Shevchenko (1):
      serial: 8250_dw: Avoid double error messaging when IRQ absent

Anson Huang (1):
      cpufreq: imx-cpufreq-dt: Correct i.MX8MN's default speed grade value

Ard Biesheuvel (2):
      crypto: geode-aes - switch to skcipher for cbc(aes) fallback
      crypto: ecdh - fix big endian bug in ECC library

Arnd Bergmann (1):
      lp: fix sparc64 LPSETTIMEOUT ioctl

Ayush Sawal (1):
      crypto: af_alg - cast ki_complete ternary op to int

Bibby Hsieh (1):
      soc: mediatek: cmdq: fixup wrong input order of write api

Catalin Marinas (1):
      arm64: Validate tagged addresses in access_ok() called from kernel th=
reads

Christian Lamparter (1):
      crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Christophe JAILLET (1):
      drm/mcde: Fix an error handling path in 'mcde_probe()'

Chuhong Yuan (1):
      serial: ifx6x60: add missed pm_runtime_disable

Dan Carpenter (2):
      drm/i810: Prevent underflow in ioctl
      md/raid0: Fix an error message in raid0_make_request()

Dmitry Safonov (1):
      time: Zero the upper 32-bits in __kernel_timespec on 32-bit

Dmitry Torokhov (1):
      tty: vt: keyboard: reject invalid keycodes

Fabrice Gasnier (1):
      serial: stm32: fix clearing interrupt error flags

Frank Wunderlich (1):
      serial: 8250-mtk: Use platform_get_irq_optional() for optional irq

Frieder Schrempf (1):
      spi: spi-fsl-qspi: Clear TDH bits in FLSHCR register

Greg Kroah-Hartman (1):
      Linux 5.4.3

Greg Kurz (3):
      KVM: PPC: Book3S HV: XIVE: Free previous EQ page when setting up a ne=
w one
      KVM: PPC: Book3S HV: XIVE: Fix potential page leak on error path
      KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated

Gregory CLEMENT (3):
      spi: atmel: Fix CS high support
      spi: Fix SPI_CS_HIGH setting when using native and GPIO CS
      spi: Fix NULL pointer when setting SPI_CS_HIGH for GPIO CS

Hans Verkuil (2):
      Input: synaptics - switch another X1 Carbon 6 to RMI/SMbus
      Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers

Hans de Goede (1):
      Input: goodix - add upside-down quirk for Teclast X89 tablet

Hui Wang (1):
      ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

J. Bruce Fields (1):
      nfsd: restore NFSv3 ACL support

Jan Kara (4):
      jbd2: Fix possible overflow in jbd2_log_space_left()
      bdev: Factor out bdev revalidation into a common helper
      bdev: Refresh bdev size for disks without partitioning
      iomap: Fix pipe page leakage during splicing

Jann Horn (3):
      binder: Fix race between mmap() and binder_alloc_print_pages()
      binder: Prevent repeated use of ->mmap() via NULL mapping
      binder: Handle start=3D=3DNULL in binder_update_page_range()

Je Yen Tam (1):
      Revert "serial/8250: Add support for NI-Serial PXI/PXIe+485 devices"

Jeffrey Hugo (1):
      tty: serial: msm_serial: Fix flow control

Jens Axboe (3):
      io_uring: transform send/recvmsg() -ERESTARTSYS to -EINTR
      io_uring: fix missing kmap() declaration on powerpc
      io_uring: ensure req->submit is copied when req is deferred

Jian-Hong Pan (1):
      ALSA: hda/realtek - Enable internal speaker of ASUS UX431FLC

Jiangfeng Xiao (1):
      serial: serial_core: Perform NULL checks for break_ctl ops

Joel Stanley (1):
      watchdog: aspeed: Fix clock behaviour for ast2600

Joerg Roedel (1):
      x86/mm/32: Sync only to VMALLOC_END in vmalloc_sync_all()

Johan Hovold (2):
      drm/msm: fix memleak on release
      can: ucan: fix non-atomic allocation in completion handler

Jon Hunter (3):
      arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator
      arm64: tegra: Fix 'active-low' warning for Jetson Xavier regulator
      mailbox: tegra: Fix superfluous IRQ error message

Jouni Hogander (1):
      can: slcan: Fix use-after-free Read in slcan_open

Kai-Heng Feng (2):
      ALSA: hda - Add mute led support for HP ProBook 645 G4
      x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect

Kailang Yang (1):
      ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Lucas Stach (1):
      Input: synaptics-rmi4 - re-enable IRQs in f34v7_do_reflash

Marcel Holtmann (1):
      rfkill: allocate static minor

Marek Szyprowski (1):
      arm64: dts: exynos: Revert "Remove unneeded address space mapping for=
 soc node"

Mark Salter (1):
      crypto: ccp - fix uninitialized list head

Micha=C5=82 Miros=C5=82aw (1):
      usb: gadget: u_serial: add missing port entry locking

Mike Leach (1):
      coresight: etm4x: Fix input validation for sysfs.

Miklos Szeredi (4):
      fuse: fix leak of fuse_io_priv
      fuse: verify nlink
      fuse: verify write return
      fuse: verify attributes

Navid Emamdoost (4):
      rsi: release skb if rsi_prepare_beacon fails
      Input: Fix memory leak in psxpad_spi_probe
      crypto: user - fix memory leak in crypto_report
      crypto: user - fix memory leak in crypto_reportstat

Nicolas Pitre (1):
      vcs: prevent write access to vcsu devices

Paolo Bonzini (3):
      KVM: x86: do not modify masked bits of shared MSRs
      KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
      KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019=
-19332)

Patrice Chotard (1):
      spi: stm32-qspi: Fix kernel oops when unbinding driver

Paul Burton (1):
      staging/octeon: Use stubs for MIPS && !CAVIUM_OCTEON_SOC

Pavel Begunkov (1):
      io_uring: fix dead-hung for non-iter fixed rw

Pavel Shilovsky (2):
      CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks
      CIFS: Fix SMB2 oplock break processing

Peng Fan (1):
      tty: serial: fsl_lpuart: use the sg count from dma_map_sg

Prabhakar Kushwaha (1):
      kselftest: Fix NULL INSTALL_PATH for TARGETS runlist

Robert Richter (1):
      EDAC/ghes: Fix locking and memory barrier issues

Sean Christopherson (3):
      KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
      KVM: x86: Remove a spurious export of a static function
      KVM: x86: Grab KVM's srcu lock when setting nested state

Sean Paul (1):
      drm: damage_helper: Fix race checking plane->state->fb

Sean Young (1):
      media: rc: mark input device as pointing stick

Takashi Iwai (4):
      ALSA: hda/realtek - Fix inverted bass GPIO pin on Acer 8951G
      ALSA: pcm: oss: Avoid potential buffer overflows
      ALSA: hda: Modify stream stripe mask only when needed
      ALSA: hda - Fix pending unsol events at shutdown

Tejun Heo (1):
      kernfs: fix ino wrap-around detection

Trond Myklebust (2):
      SUNRPC: Avoid RPC delays when exiting suspend
      nfsd: Ensure CLONE persists data and metadata changes to the target f=
ile

Tudor Ambarus (1):
      crypto: atmel-aes - Fix IV handling when req->nbytes < ivsize

Tuowen Zhao (1):
      sparc64: implement ioremap_uc

Ulf Hansson (1):
      mwifiex: Re-work support for SDIO HW reset

Vincent Whitchurch (1):
      serial: pl011: Fix DMA ->flush_buffer()

Viresh Kumar (1):
      RDMA/qib: Validate ->show()/store() callbacks before calling them

Wei Wang (1):
      thermal: Fix deadlock in thermal thermal_zone_device_check

Zenghui Yu (1):
      KVM: arm/arm64: vgic: Don't rely on the wrong pending table


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3zuRoACgkQONu9yGCS
aT7yexAAvlfeUSpWX/LRW2HJnwbdKyvqVsOMy8CWx/nf1G8Z0zyR6AV3juj1obzz
jpdsaW+g6naQcHgqKiIGJ5RYz2Um0+L//vtbecCf6QzRh5MqWxYerYQ4lffHTovt
cKdkSEz55X+aUmN5VGtXTml169l/sSNTZN5vfH3KQQdok0giNW5fGVJCyqmkJyA7
MQtyAQ6FznlHNANu8TUstIWpN/bxwLJ9z0nWt976QX72OCcVYwPWBgmv4kHI4MZu
adkTAnLCregfFce527oZsRicvvEgl/e9aoC8levu5XYtELaOhmfufRJa51aMYT2e
N/cphpBD9KAaHUe+7c2QiAdIN4OEpB2jpkIc2O6gD1GaQzG6iW9KIzZC+QJ9oX1F
eotXjU0beS+ZCRFvBApeBOqIsiXcVPj54EPIlan0jk857lIMEBRg4Dk08+kChmp8
uzEXDWT1lbIRr+k/S+0KUlRYY0GlAB553SC4yzPVQIMcsty7tNEpm4y4TlZKyOH/
2X9laiqqBwzByXTmEQ4SS4UlD6AJv++zyO+ogcBBTaVEL78v//qh9bH5UyKabZoh
4QRuyr4K8kKtk+byfYQvsstxiWg/Kcsqa7QdfPfQgWTiU3T6swMBi6cZ6nGeRwKd
cyJfVG76mCjLbrooa1d0IGtG4mCeY6vzWea66NJTxUvG8OZHGcw=
=xIkA
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
