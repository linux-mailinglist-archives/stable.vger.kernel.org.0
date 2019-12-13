Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F047711EBDF
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 21:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbfLMUf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 15:35:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbfLMUfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Dec 2019 15:35:55 -0500
Received: from localhost (unknown [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8CB4246A8;
        Fri, 13 Dec 2019 20:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576269352;
        bh=Nsv8GFqfKgQvWauW/4av6YMgLPIYQm0DZWvNrDjd1gQ=;
        h=Date:From:To:Cc:Subject:From;
        b=Yr0q5AN2QPq9hGYOYek03drOnJNOwE/qc84W1WIKqQ1B8h9MBL3feaXxb2ez950uu
         nzInv3akAQjXwgC5qZGKs47WQHIReMGgFor2g7U/yZK6nTAMvK0rn3l0thau8JHk/F
         D9BjtpvUKeQaYwNT+zEmr3e/cqmLDtCy4jfvm3Js=
Date:   Fri, 13 Dec 2019 17:14:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.16
Message-ID: <20191213161457.GA2684619@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.16 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 arch/arm64/boot/dts/exynos/exynos5433.dtsi             |    6 -
 arch/arm64/boot/dts/exynos/exynos7.dtsi                |    6 -
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi         |    2=20
 arch/mips/sgi-ip27/Kconfig                             |    7 -
 arch/mips/sgi-ip27/ip27-init.c                         |   21 +--
 arch/mips/sgi-ip27/ip27-memory.c                       |    4=20
 arch/powerpc/kvm/book3s_xive.c                         |   11 --
 arch/powerpc/kvm/book3s_xive_native.c                  |   46 +++++---
 arch/sparc/include/asm/io_64.h                         |    1=20
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                 |    4=20
 arch/x86/kvm/cpuid.c                                   |    5=20
 arch/x86/kvm/vmx/nested.c                              |   10 +
 arch/x86/kvm/vmx/vmx.c                                 |   10 +
 arch/x86/kvm/x86.c                                     |   17 ++-
 arch/x86/mm/fault.c                                    |    2=20
 arch/x86/pci/fixup.c                                   |   11 ++
 block/bio.c                                            |    2=20
 crypto/af_alg.c                                        |    2=20
 crypto/crypto_user_base.c                              |    4=20
 crypto/crypto_user_stat.c                              |    4=20
 crypto/ecc.c                                           |    3=20
 drivers/android/binder_alloc.c                         |   41 ++++---
 drivers/block/rbd.c                                    |    2=20
 drivers/block/rsxx/core.c                              |    2=20
 drivers/char/lp.c                                      |    4=20
 drivers/cpufreq/imx-cpufreq-dt.c                       |   20 +--
 drivers/crypto/amcc/crypto4xx_core.c                   |    6 -
 drivers/crypto/atmel-aes.c                             |   53 +++++-----
 drivers/crypto/ccp/ccp-dmaengine.c                     |    1=20
 drivers/crypto/geode-aes.c                             |   57 ++++++----
 drivers/crypto/geode-aes.h                             |    2=20
 drivers/edac/ghes_edac.c                               |   90 ++++++++++++=
-----
 drivers/gpu/drm/drm_damage_helper.c                    |    8 +
 drivers/gpu/drm/i810/i810_dma.c                        |    4=20
 drivers/gpu/drm/mcde/mcde_drv.c                        |    3=20
 drivers/gpu/drm/msm/msm_debugfs.c                      |    6 -
 drivers/gpu/drm/sun4i/sun4i_tcon.c                     |    2=20
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c    |   21 ++-
 drivers/i2c/i2c-core-of.c                              |    4=20
 drivers/infiniband/hw/hns/hns_roce_hem.h               |    2=20
 drivers/infiniband/hw/hns/hns_roce_srq.c               |    2=20
 drivers/infiniband/hw/qib/qib_sysfs.c                  |    6 +
 drivers/input/joystick/psxpad-spi.c                    |    2=20
 drivers/input/mouse/synaptics.c                        |    1=20
 drivers/input/rmi4/rmi_f34v7.c                         |    3=20
 drivers/input/rmi4/rmi_smbus.c                         |    2=20
 drivers/input/touchscreen/cyttsp4_core.c               |    7 -
 drivers/input/touchscreen/goodix.c                     |    9 +
 drivers/md/raid0.c                                     |    2=20
 drivers/media/rc/rc-main.c                             |    1=20
 drivers/net/can/slcan.c                                |    1=20
 drivers/net/can/usb/ucan.c                             |    2=20
 drivers/net/ethernet/cirrus/ep93xx_eth.c               |    5=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |   19 +++
 drivers/net/ethernet/renesas/ravb.h                    |    3=20
 drivers/net/ethernet/renesas/ravb_main.c               |   26 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c      |   20 +--
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                |    1=20
 drivers/nfc/nxp-nci/i2c.c                              |    6 -
 drivers/spi/spi-atmel.c                                |    6 -
 drivers/spi/spi-fsl-qspi.c                             |   38 ++++++-
 drivers/spi/spi-stm32-qspi.c                           |    3=20
 drivers/spi/spi.c                                      |   19 +--
 drivers/thermal/thermal_core.c                         |    4=20
 drivers/tty/serial/amba-pl011.c                        |    6 -
 drivers/tty/serial/fsl_lpuart.c                        |    4=20
 drivers/tty/serial/ifx6x60.c                           |    3=20
 drivers/tty/serial/msm_serial.c                        |    6 -
 drivers/tty/serial/serial_core.c                       |    2=20
 drivers/tty/serial/stm32-usart.c                       |    6 -
 drivers/tty/vt/keyboard.c                              |    2=20
 drivers/tty/vt/vc_screen.c                             |    3=20
 drivers/usb/gadget/function/u_serial.c                 |    2=20
 drivers/watchdog/aspeed_wdt.c                          |   16 +--
 fs/afs/dir.c                                           |    7 +
 fs/aio.c                                               |   10 -
 fs/autofs/expire.c                                     |    5=20
 fs/cifs/file.c                                         |    7 -
 fs/cifs/smb2misc.c                                     |    7 -
 fs/ecryptfs/inode.c                                    |   65 +++++++-----
 fs/exportfs/expfs.c                                    |   31 +++--
 fs/fuse/dir.c                                          |   25 +++-
 fs/fuse/fuse_i.h                                       |    2=20
 fs/fuse/readdir.c                                      |    2=20
 fs/io_uring.c                                          |    9 +
 fs/iomap/direct-io.c                                   |    9 +
 fs/kernfs/dir.c                                        |    5=20
 fs/nfsd/nfs4proc.c                                     |    3=20
 fs/nfsd/nfssvc.c                                       |    3=20
 fs/nfsd/vfs.c                                          |    8 +
 fs/nfsd/vfs.h                                          |    2=20
 include/linux/jbd2.h                                   |    4=20
 include/linux/kernfs.h                                 |    1=20
 include/sound/hdaudio.h                                |    1=20
 kernel/audit_watch.c                                   |    2=20
 kernel/cgroup/cgroup.c                                 |    5=20
 kernel/events/core.c                                   |    2=20
 kernel/sched/core.c                                    |    3=20
 kernel/sched/fair.c                                    |   29 +++--
 kernel/time/time.c                                     |    3=20
 net/sunrpc/sched.c                                     |    2=20
 net/xfrm/xfrm_input.c                                  |    3=20
 sound/core/oss/linear.c                                |    2=20
 sound/core/oss/mulaw.c                                 |    2=20
 sound/core/oss/route.c                                 |    2=20
 sound/core/pcm_lib.c                                   |    8 +
 sound/hda/hdac_stream.c                                |   19 ++-
 sound/pci/hda/hda_bind.c                               |    4=20
 sound/pci/hda/hda_intel.c                              |    6 +
 sound/pci/hda/patch_conexant.c                         |    1=20
 sound/pci/hda/patch_hdmi.c                             |    9 +
 sound/pci/hda/patch_realtek.c                          |   18 ++-
 tools/perf/builtin-script.c                            |    2=20
 tools/perf/scripts/python/exported-sql-viewer.py       |   10 +
 tools/testing/selftests/Makefile                       |    2=20
 tools/testing/selftests/kvm/lib/assert.c               |    4=20
 virt/kvm/arm/vgic/vgic-v3.c                            |    6 -
 118 files changed, 701 insertions(+), 395 deletions(-)

Adrian Hunter (2):
      perf scripts python: exported-sql-viewer.py: Fix use of TRUE with SQL=
ite
      perf script: Fix invalid LBR/binary mismatch error

Al Viro (5):
      autofs: fix a leak in autofs_expire_indirect()
      cgroup: don't put ERR_PTR() into fc->root
      exportfs_decode_fh(): negative pinned may become positive without the=
 parent locked
      audit_get_nd(): don't unlock parent too early
      ecryptfs: fix unlink and rmdir in face of underlying fs modifications

Alexander Shishkin (1):
      perf/core: Consistently fail fork on allocation failures

Anson Huang (1):
      cpufreq: imx-cpufreq-dt: Correct i.MX8MN's default speed grade value

Ard Biesheuvel (2):
      crypto: geode-aes - switch to skcipher for cbc(aes) fallback
      crypto: ecdh - fix big endian bug in ECC library

Arnd Bergmann (1):
      lp: fix sparc64 LPSETTIMEOUT ioctl

Ayush Sawal (1):
      crypto: af_alg - cast ki_complete ternary op to int

Chiou, Cooper (1):
      ALSA: hda: Add Cometlake-S PCI ID

Christian Lamparter (1):
      crypto: crypto4xx - fix double-free in crypto4xx_destroy_sdr

Christophe JAILLET (1):
      drm/mcde: Fix an error handling path in 'mcde_probe()'

Chuhong Yuan (3):
      serial: ifx6x60: add missed pm_runtime_disable
      rsxx: add missed destroy_workqueue calls in remove
      net: ep93xx_eth: fix mismatch of request_mem_region in remove

Dan Carpenter (2):
      drm/i810: Prevent underflow in ioctl
      md/raid0: Fix an error message in raid0_make_request()

David Howells (1):
      afs: Fix race in commit bulk status fetch

Dmitry Safonov (1):
      time: Zero the upper 32-bits in __kernel_timespec on 32-bit

Dmitry Torokhov (1):
      tty: vt: keyboard: reject invalid keycodes

Fabrice Gasnier (1):
      serial: stm32: fix clearing interrupt error flags

Frieder Schrempf (1):
      spi: spi-fsl-qspi: Clear TDH bits in FLSHCR register

Greg Kroah-Hartman (1):
      Linux 5.3.16

Greg Kurz (3):
      KVM: PPC: Book3S HV: XIVE: Free previous EQ page when setting up a ne=
w one
      KVM: PPC: Book3S HV: XIVE: Fix potential page leak on error path
      KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated

Gregory CLEMENT (3):
      spi: atmel: Fix CS high support
      spi: Fix SPI_CS_HIGH setting when using native and GPIO CS
      spi: Fix NULL pointer when setting SPI_CS_HIGH for GPIO CS

Guillem Jover (1):
      aio: Fix io_pgetevents() struct __compat_aio_sigset layout

Hans Verkuil (2):
      Input: synaptics - switch another X1 Carbon 6 to RMI/SMbus
      Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers

Hans de Goede (1):
      Input: goodix - add upside-down quirk for Teclast X89 tablet

Hui Wang (1):
      ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop

Ilya Dryomov (1):
      rbd: silence bogus uninitialized warning in rbd_object_map_update_fin=
ish()

J. Bruce Fields (1):
      nfsd: restore NFSv3 ACL support

Jan Kara (2):
      jbd2: Fix possible overflow in jbd2_log_space_left()
      iomap: Fix pipe page leakage during splicing

Jann Horn (3):
      binder: Fix race between mmap() and binder_alloc_print_pages()
      binder: Prevent repeated use of ->mmap() via NULL mapping
      binder: Handle start=3D=3DNULL in binder_update_page_range()

Jeffrey Hugo (1):
      tty: serial: msm_serial: Fix flow control

Jens Axboe (2):
      io_uring: transform send/recvmsg() -ERESTARTSYS to -EINTR
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

Jon Hunter (1):
      arm64: tegra: Fix 'active-low' warning for Jetson TX1 regulator

Jouni Hogander (1):
      can: slcan: Fix use-after-free Read in slcan_open

Junichi Nomura (1):
      block: check bi_size overflow before merge

Kai Vehmanen (1):
      ALSA: hda: hdmi - fix pin setup on Tigerlake

Kai-Heng Feng (2):
      ALSA: hda - Add mute led support for HP ProBook 645 G4
      x86/PCI: Avoid AMD FCH XHCI USB PME# from D0 defect

Kailang Yang (1):
      ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236

Lucas Stach (1):
      Input: synaptics-rmi4 - re-enable IRQs in f34v7_do_reflash

Marek Szyprowski (1):
      arm64: dts: exynos: Revert "Remove unneeded address space mapping for=
 soc node"

Mark Salter (1):
      crypto: ccp - fix uninitialized list head

Micha=C5=82 Miros=C5=82aw (1):
      usb: gadget: u_serial: add missing port entry locking

Mike Leach (1):
      coresight: etm4x: Fix input validation for sysfs.

Miklos Szeredi (2):
      fuse: verify nlink
      fuse: verify attributes

Mordechay Goodstein (1):
      iwlwifi: pcie: don't consider IV len in A-MSDU

Navid Emamdoost (4):
      rsi: release skb if rsi_prepare_beacon fails
      Input: Fix memory leak in psxpad_spi_probe
      crypto: user - fix memory leak in crypto_report
      crypto: user - fix memory leak in crypto_reportstat

Nicolas Pitre (1):
      vcs: prevent write access to vcsu devices

Pan Bian (1):
      Input: cyttsp4_core - fix use after free bug

Paolo Bonzini (3):
      KVM: x86: do not modify masked bits of shared MSRs
      KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES
      KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019=
-19332)

Patrice Chotard (1):
      spi: stm32-qspi: Fix kernel oops when unbinding driver

Pavel Shilovsky (2):
      CIFS: Fix NULL-pointer dereference in smb2_push_mandatory_locks
      CIFS: Fix SMB2 oplock break processing

Peng Fan (1):
      tty: serial: fsl_lpuart: use the sg count from dma_map_sg

Peter Zijlstra (1):
      sched/core: Avoid spurious lock dependencies

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

Sirong Wang (1):
      RDMA/hns: Correct the value of HNS_ROCE_HEM_CHUNK_LEN

Stephan Gerhold (1):
      NFC: nxp-nci: Fix NULL pointer dereference after I2C communication er=
ror

Takashi Iwai (3):
      ALSA: pcm: oss: Avoid potential buffer overflows
      ALSA: hda: Modify stream stripe mask only when needed
      ALSA: hda - Fix pending unsol events at shutdown

Tejun Heo (1):
      kernfs: fix ino wrap-around detection

Thomas Bogendoerfer (1):
      MIPS: SGI-IP27: fix exception handler replication

Trond Myklebust (2):
      SUNRPC: Avoid RPC delays when exiting suspend
      nfsd: Ensure CLONE persists data and metadata changes to the target f=
ile

Tudor Ambarus (1):
      crypto: atmel-aes - Fix IV handling when req->nbytes < ivsize

Tuowen Zhao (1):
      sparc64: implement ioremap_uc

Ulrich Hecht (1):
      ravb: implement MTU change while device is up

Vincent Guittot (1):
      sched/pelt: Fix update of blocked PELT ordering

Vincent Whitchurch (1):
      serial: pl011: Fix DMA ->flush_buffer()

Viresh Kumar (1):
      RDMA/qib: Validate ->show()/store() callbacks before calling them

Vitaly Kuznetsov (1):
      selftests: kvm: fix build with glibc >=3D 2.30

Wei Wang (1):
      thermal: Fix deadlock in thermal thermal_zone_device_check

Wen Yang (1):
      i2c: core: fix use after free in of_i2c_notify

Wenpeng Liang (1):
      RDMA/hns: Correct the value of srq_desc_size

Xiaochen Shen (1):
      x86/resctrl: Fix potential lockdep warning

Xiaodong Xu (1):
      xfrm: release device reference for invalid state

Yonglong Liu (1):
      net: hns3: fix ETS bandwidth validation bug

Yunhao Tian (1):
      drm/sun4i: tcon: Set min division of TCON0_DCLK to 1.

Yunsheng Lin (1):
      net: hns3: reallocate SSU' buffer size when pfc_en changes

Zenghui Yu (1):
      KVM: arm/arm64: vgic: Don't rely on the wrong pending table

paulhsia (1):
      ALSA: pcm: Fix stream lock usage in snd_pcm_period_elapsed()


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3zuP8ACgkQONu9yGCS
aT6NPxAAhIJt/V7bCIBRt6DshGvvjpQKkjvmjKDmI2c3wS6INnRIRh9HvXc737Iu
J/NTDB30kPuXYe877w+Walc98OM5NxwX5JbDPqiOUCRHnrPKtNDJqPVYfmvcT5Do
X8Wjq3iwMTwb8tTTqNV5okuQhFbYPTP8ZpzVo2e5orQalsLto2ND5D3NZAKKqiaf
8697b6zdPGP/G9a6DwEbHAHL/cfbHHGkK08XdpxSmNPFbT3oRJHx5rbBQshcwOuu
4hmrNMJYCfn3VLLEyUNIXK4N4f2unKcVfyi3tZJvrx1CY13RZ7J16BEx572+Ebfm
TNb4ah9V6IejqcAXog5q5UYn5gfLF2pXjeETSz7TjoqVi8VZ/cKaTaVa6+sNb/YM
7yJDiaGS+FKCv5AeqXQfNnNJEy7hqB7wCpGgN/qirf1+dgnQw0bRHlKQbTXPRilc
AttKHeHS2qsExMseerB/5b9TiqAWclegkvhAMjSyVGeEQhKdqCdblvYLeEr4Nz9U
4QSBHicZRZnHH9mk0Ek30cdVtIo4JuWBhenbT81zNiaiErP/BBft+ny0eVqqMLC6
nFOFycdcV2hcJQMeAjxJp1dbTIgna7rV+ZmuED+EukTaTWAlrE600Ol3NOdq+ho+
d2HJoDFQRKI1eTIxVu/KeIyQdgybh/rvbq8lqPsCqbyM/54fFOE=
=5j5H
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
