Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFC5192F9D
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 18:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCYRoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 13:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbgCYRoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 13:44:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BFD120777;
        Wed, 25 Mar 2020 17:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585158242;
        bh=R1/VHUC1EkkCoYWXn9EPyQ2Q4hEPy8jF2eVg2nHijZU=;
        h=Date:From:To:Cc:Subject:From;
        b=BdoAhN9bO/n9bsS61aE52uuXm+yDFU7+uj2QgSZKpqE+nxypzSD0YaHOMNMzA/0DM
         pufDlQCt/6x9B99M6kekZmnm7vOjLLmf30L6R4ACWoJCmK4tZ9l5HZJHeFkNmQItRj
         iJnx+6Mf15BEJjk4ugQs+twYGaDFslvp+xI4bPc8=
Date:   Wed, 25 Mar 2020 18:44:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.12
Message-ID: <20200325174400.GA3764663@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.12 kernel.

All users of the 5.5 kernel series must upgrade.

The updated 5.5.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.5.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/kbuild/modules.rst                            |    4=20
 Makefile                                                    |    2=20
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts                       |    2=20
 arch/arm/boot/dts/bcm2837-rpi-3-a-plus.dts                  |    2=20
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts                  |    2=20
 arch/arm/boot/dts/dra7-l4.dtsi                              |    4=20
 arch/arm/boot/dts/dra7.dtsi                                 |    2=20
 arch/arm/configs/bcm2835_defconfig                          |    1=20
 arch/arm64/include/asm/unistd.h                             |    2=20
 arch/arm64/kernel/smp.c                                     |   25 ++
 arch/powerpc/kernel/vmlinux.lds.S                           |    6=20
 arch/riscv/Kconfig                                          |    1=20
 arch/riscv/include/asm/syscall.h                            |    7=20
 arch/riscv/kernel/entry.S                                   |   11 -
 arch/riscv/kernel/module.c                                  |   16 +
 arch/riscv/kernel/ptrace.c                                  |   11 -
 arch/riscv/mm/init.c                                        |    2=20
 arch/x86/mm/fault.c                                         |   26 ++-
 drivers/acpi/apei/ghes.c                                    |    2=20
 drivers/android/binderfs.c                                  |    1=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c                 |    6=20
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                      |    1=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                       |    1=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    1=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c         |    4=20
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                   |   46 +++--
 drivers/gpu/drm/drm_client_modeset.c                        |   72 --------
 drivers/gpu/drm/drm_lease.c                                 |    3=20
 drivers/gpu/drm/exynos/exynos_drm_dsi.c                     |   12 -
 drivers/gpu/drm/exynos/exynos_hdmi.c                        |   22 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c                         |   52 +-----
 drivers/gpu/drm/i915/gt/intel_workarounds.c                 |   25 ++
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                     |   26 +--
 drivers/hwtracing/intel_th/msu.c                            |   13 -
 drivers/hwtracing/intel_th/pci.c                            |    5=20
 drivers/hwtracing/stm/p_sys-t.c                             |    6=20
 drivers/iio/accel/adxl372.c                                 |    1=20
 drivers/iio/accel/st_accel_i2c.c                            |    2=20
 drivers/iio/adc/at91-sama5d2_adc.c                          |   15 +
 drivers/iio/adc/stm32-dfsdm-adc.c                           |   43 +----
 drivers/iio/chemical/Kconfig                                |    2=20
 drivers/iio/light/vcnl4000.c                                |   15 -
 drivers/iio/magnetometer/ak8974.c                           |    2=20
 drivers/iio/trigger/stm32-timer-trigger.c                   |   11 +
 drivers/md/dm-bio-record.h                                  |   15 +
 drivers/md/dm-integrity.c                                   |   32 +--
 drivers/misc/altera-stapl/altera.c                          |   12 -
 drivers/misc/cardreader/rts5227.c                           |    2=20
 drivers/misc/cardreader/rts5249.c                           |    2=20
 drivers/misc/cardreader/rts5260.c                           |    2=20
 drivers/misc/cardreader/rts5261.c                           |    2=20
 drivers/mmc/host/rtsx_pci_sdmmc.c                           |   13 -
 drivers/mmc/host/sdhci-acpi.c                               |   84 +++++++=
++
 drivers/mmc/host/sdhci-cadence.c                            |   18 +-
 drivers/mmc/host/sdhci-of-at91.c                            |    8=20
 drivers/nvme/target/tcp.c                                   |   12 +
 drivers/perf/arm_pmu_acpi.c                                 |    7=20
 drivers/perf/fsl_imx8_ddr_perf.c                            |   10 -
 drivers/phy/ti/phy-gmii-sel.c                               |   10 -
 drivers/rtc/Kconfig                                         |    1=20
 drivers/spi/spi-omap2-mcspi.c                               |   77 ++++----
 drivers/spi/spi-pxa2xx.c                                    |   23 ++
 drivers/spi/spi-qup.c                                       |   11 -
 drivers/spi/spi-zynqmp-gqspi.c                              |    3=20
 drivers/spi/spi.c                                           |   32 +--
 drivers/staging/greybus/tools/loopback_test.c               |   21 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                 |    1=20
 drivers/staging/speakup/main.c                              |    2=20
 drivers/thunderbolt/switch.c                                |    2=20
 drivers/tty/tty_io.c                                        |    6=20
 drivers/usb/chipidea/udc.c                                  |    7=20
 drivers/usb/class/cdc-acm.c                                 |   34 ++-
 drivers/usb/core/quirks.c                                   |    6=20
 drivers/usb/host/xhci-pci.c                                 |    3=20
 drivers/usb/host/xhci-plat.c                                |    1=20
 drivers/usb/host/xhci-trace.h                               |   23 --
 drivers/usb/serial/option.c                                 |    2=20
 drivers/usb/serial/pl2303.c                                 |    1=20
 drivers/usb/serial/pl2303.h                                 |    1=20
 drivers/usb/typec/ucsi/displayport.c                        |   12 +
 drivers/xen/xenbus/xenbus_comms.c                           |    4=20
 drivers/xen/xenbus/xenbus_xs.c                              |    9 -
 fs/btrfs/block-group.c                                      |    4=20
 fs/btrfs/inode.c                                            |    4=20
 fs/cifs/cifs_dfs_ref.c                                      |    2=20
 fs/cifs/cifsfs.c                                            |    2=20
 fs/cifs/file.c                                              |    3=20
 fs/cifs/smb2ops.c                                           |    2=20
 fs/eventpoll.c                                              |    8=20
 fs/inode.c                                                  |    1=20
 fs/io-wq.c                                                  |   20 +-
 fs/io_uring.c                                               |    9 +
 fs/locks.c                                                  |   60 +++++-
 include/linux/fs.h                                          |    1=20
 include/linux/futex.h                                       |   17 +
 include/linux/page-flags.h                                  |    2=20
 include/linux/vmalloc.h                                     |    5=20
 init/Kconfig                                                |    3=20
 kernel/futex.c                                              |   93 ++++++-=
---
 kernel/notifier.c                                           |    2=20
 mm/madvise.c                                                |   12 +
 mm/memcontrol.c                                             |  103 +++++++=
-----
 mm/nommu.c                                                  |   10 -
 mm/slub.c                                                   |   32 ++-
 mm/sparse.c                                                 |    8=20
 mm/vmalloc.c                                                |   11 -
 scripts/Kconfig.include                                     |    7=20
 scripts/Makefile.extrawarn                                  |    1=20
 scripts/export_report.pl                                    |    2=20
 scripts/mod/modpost.c                                       |   27 +--
 sound/core/oss/pcm_plugin.c                                 |   12 +
 sound/core/seq/oss/seq_oss_midi.c                           |    1=20
 sound/core/seq/seq_virmidi.c                                |    1=20
 sound/pci/hda/patch_realtek.c                               |   25 ++
 sound/soc/stm/stm32_sai_sub.c                               |   18 +-
 sound/usb/line6/driver.c                                    |    2=20
 sound/usb/line6/midibuf.c                                   |    2=20
 117 files changed, 944 insertions(+), 594 deletions(-)

Aaro Koskinen (1):
      spi: spi_register_controller(): free bus id on error paths

Alberto Mattea (1):
      usb: xhci: apply XHCI_SUSPEND_DELAY to AMD XHCI controller 1022:145c

Alexander Shishkin (4):
      intel_th: msu: Fix the unexpected state warning
      intel_th: Fix user-visible error codes
      intel_th: pci: Add Elkhart Lake CPU support
      stm class: sys-t: Fix the use of time_after()

Alexandre Ghiti (1):
      riscv: Fix range looking for kernel image memblock

Alexandru Tachici (1):
      iio: accel: adxl372: Set iio_chan BE

Anthony Mallet (2):
      USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL
      USB: cdc-acm: fix rounding error in TIOCSSERIAL

Baoquan He (1):
      mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case

Bhawanpreet Lakha (1):
      drm/amd/display: Clear link settings on MST disable connector

Caz Yokoyama (1):
      Revert "drm/i915/tgl: Add extra hdc flush workaround"

Chris Down (2):
      mm, memcg: fix corruption on 64-bit divisor in memory.high throttling
      mm, memcg: throttle allocators based on ancestral memory.high

Chris Wilson (1):
      drm/i915/execlists: Track active elements during dequeue

Christian Brauner (1):
      binderfs: use refcount for binder control devices too

Chunguang Xu (1):
      memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregister_=
event

Corentin Labbe (1):
      rtc: max8907: add missing select REGMAP_IRQ

Cristian Marussi (2):
      arm64: smp: fix smp_send_stop() behaviour
      arm64: smp: fix crash_smp_send_stop() behaviour

Damien Le Moal (1):
      riscv: Force flat memory model with no-mmu

Dan Carpenter (1):
      thunderbolt: Fix error code in tb_port_is_width_supported()

Daniel Axtens (1):
      altera-stapl: altera_get_note: prevent write beyond end of 'key'

Daniele Palmas (1):
      USB: serial: option: add ME910G1 ECM composition 0x110b

Dongli Zhang (2):
      xenbus: req->body should be updated before req->state
      xenbus: req->err should be updated before req->state

Eric Biggers (2):
      tty: fix compat TIOCGSERIAL leaking uninitialized memory
      tty: fix compat TIOCGSERIAL checking wrong function ptr

Eugen Hristev (1):
      iio: adc: at91-sama5d2_adc: fix differential channels in triggered mo=
de

Evan Benn (1):
      drm/mediatek: Find the cursor plane instead of hard coding it

Evan Green (1):
      spi: pxa2xx: Add CS control clock quirk

Fabrice Gasnier (1):
      iio: trigger: stm32-timer: disable master mode when stopping

Filipe Manana (2):
      btrfs: fix log context list corruption after rename whiteout error
      btrfs: fix removal of raid[56|1c34} incompat flags after removing blo=
ck group

Greg Kroah-Hartman (1):
      Linux 5.5.12

Grygorii Strashko (3):
      phy: ti: gmii-sel: fix set of copy-paste errors
      phy: ti: gmii-sel: do not fail in case of gmii
      ARM: dts: dra7-l4: mark timer13-16 as pwm capable

Hans de Goede (3):
      usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters
      mmc: sdhci-acpi: Switch signal voltage back to 3.3V on suspend on ext=
ernal microSD on Lenovo Miix 320
      mmc: sdhci-acpi: Disable write protect detection on Acer Aspire Switc=
h 10 (SW5-012)

Heikki Krogerus (2):
      usb: typec: ucsi: displayport: Fix NULL pointer dereference
      usb: typec: ucsi: displayport: Fix a potential race during registrati=
on

Jernej Skrabec (1):
      drm/bridge: dw-hdmi: fix AVI frame colorimetry

Jessica Yu (1):
      modpost: move the namespace field in Module.symvers last

Jian-Hong Pan (2):
      ALSA: hda/realtek - Enable headset mic of Acer X2660G with ALC662
      ALSA: hda/realtek - Enable the headset of Acer N50-600 with ALC662

Joakim Zhang (1):
      drivers/perf: fsl_imx8_ddr: Correct the CLEAR bit definition

Joerg Roedel (1):
      x86/mm: split vmalloc_sync_all()

Johan Hovold (3):
      staging: greybus: loopback_test: fix poll-mask build breakage
      staging: greybus: loopback_test: fix potential path truncation
      staging: greybus: loopback_test: fix potential path truncations

Jonathan Neusch=C3=A4fer (1):
      parse-maintainers: Mark as executable

Josip Pavic (1):
      drm/amd/display: fix dcc swath size calculations on dcn1

Kai-Heng Feng (2):
      USB: Disable LPM on WD19's Realtek Hub
      ALSA: hda/realtek: Fix pop noise on ALC225

Kishon Vijay Abraham I (1):
      ARM: dts: dra7: Add "dma-ranges" property to PCIe RC DT nodes

Linus Torvalds (2):
      locks: reinstate locks_delete_block optimization
      mm: slub: be more careful about the double cmpxchg of freelist

Marek Szyprowski (3):
      drm/exynos: dsi: propagate error value and silence meaningless warning
      drm/exynos: dsi: fix workaround for the legacy clock name
      drm/exynos: hdmi: don't leak enable HDMI_EN regulator if probe fails

Masahiro Yamada (3):
      mmc: sdhci-cadence: set SDHCI_QUIRK2_PRESET_VALUE_BROKEN for UniPhier
      kconfig: introduce m32-flag and m64-flag
      int128: fix __uint128_t compiler test in Kconfig

Matt Roper (1):
      drm/i915: Handle all MCR ranges

Michael Straube (1):
      staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

Michal Hocko (1):
      mm: do not allow MADV_PAGEOUT for CoW pages

Micha=C5=82 Miros=C5=82aw (1):
      mmc: sdhci-of-at91: fix cd-gpios for SAMA5D2

Mike Snitzer (2):
      dm bio record: save/restore bi_end_io and bi_integrity
      dm integrity: use dm_bio_record and dm_bio_restore

Murphy Zhou (1):
      CIFS: fiemap: do not return EINVAL if get nothing

Nathan Chancellor (1):
      kbuild: Disable -Wpointer-to-enum-cast

Naveen N. Rao (1):
      powerpc: Include .BTF section

Olivier Moysan (2):
      ASoC: stm32: sai: manage rebind issue
      iio: adc: stm32-dfsdm: fix sleep in atomic context

Paulo Alcantara (SUSE) (1):
      cifs: fix potential mismatch of UNC paths

Pavel Begunkov (3):
      io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation
      io_uring: fix lockup with timeouts
      io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}

Peter Chen (1):
      usb: chipidea: udc: fix sleeping function called from invalid context

Peter Zijlstra (1):
      futex: Fix inode life-time issue

Petr =C5=A0tetiar (1):
      iio: chemical: sps30: fix missing triggered buffer dependency

Qian Cai (1):
      page-flags: fix a crash at SetPageError(THP_SWAP)

Qiujun Huang (1):
      drm/lease: fix WARNING in idr_destroy

Ran Wang (1):
      usb: host: xhci-plat: add a shutdown

Ricky Wu (1):
      mmc: rtsx_pci: Fix support for speed-modes that relies on tuning

Roman Penyaev (1):
      epoll: fix possible lost wakeup on epoll_ctl() path

Sagi Grimberg (1):
      nvmet-tcp: set MSG_MORE only if we actually have more to send

Samuel Thibault (1):
      staging/speakup: fix get_word non-space look-ahead

Sasha Levin (1):
      Revert "drm/fbdev: Fallback to non tiled mode if all tiles not presen=
t"

Scott Chen (1):
      USB: serial: pl2303: add device-id for HP LD381

Sean Paul (1):
      drm/mediatek: Ensure the cursor plane is on top of other overlays

Stefan Wahren (2):
      ARM: dts: bcm283x: Add missing properties to the PWR LED
      ARM: bcm2835_defconfig: Explicitly restore CONFIG_DEBUG_FS

Stephan Gerhold (1):
      iio: magnetometer: ak8974: Fix negative raw values in sysfs

Steve French (1):
      cifs: add missing mount option to /proc/mounts

Steven Rostedt (VMware) (1):
      xhci: Do not open code __print_symbolic() in xhci trace events

Takashi Iwai (5):
      ALSA: line6: Fix endless MIDI read loop
      ALSA: seq: virmidi: Fix running status after receiving sysex
      ALSA: seq: oss: Fix running status after receiving sysex
      ALSA: pcm: oss: Avoid plugin buffer overflow
      ALSA: pcm: oss: Remove WARNING from snd_pcm_plug_alloc() checks

Thomas Gleixner (1):
      futex: Unbreak futex hashing

Thommy Jakobsson (1):
      spi/zynqmp: remove entry that causes a cs glitch

Tom St Denis (1):
      drm/amd/amdgpu: Fix GPR read from debugfs (v2)

Tomas Novotny (2):
      iio: light: vcnl4000: update sampling periods for vcnl4200
      iio: light: vcnl4000: update sampling periods for vcnl4040

Tycho Andersen (1):
      riscv: fix seccomp reject syscall code path

Vignesh Raghavendra (1):
      spi: spi-omap2-mcspi: Support probe deferral for DMA channels

Vincent Chen (1):
      riscv: avoid the PIC offset of static percpu data in module beyond 2G=
 limits

Vincenzo Frascino (1):
      arm64: compat: Fix syscall number of compat_clock_getres

Vlastimil Babka (1):
      mm, slub: prevent kmalloc_node crashes and memory leaks

Wen-chien Jesse Sung (1):
      iio: st_sensors: remap SMO8840 to LIS2DH12

Xiao Yang (1):
      modpost: Get proper section index by get_secindex() instead of st_shn=
dx

Yintian Tao (1):
      drm/amdgpu: clean wptr on wb when gpu recovery

Yuji Sasaki (1):
      spi: qup: call spi_qup_pm_resume_runtime before suspending

luanshi (1):
      drivers/perf: arm_pmu_acpi: Fix incorrect checking of gicc pointer

yangerkun (1):
      locks: fix a potential use-after-free problem when wakeup a waiter


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl57mGAACgkQONu9yGCS
aT6o5g/8CKapIaVyCPJZHuoEq0fxeXqeox9F7ojSmhNyGm91MgNLJ+2ydYew9ShJ
sSjHLwqBlWKkBgPa4AwhQpMQiVK1kOozF0ebeGUYKSwZ9lOOeB6XnxClFnwHGbT/
h+f2Bn1ZrfpJeC7fiq0gYNUq3/+y7OJGATRJeeWqYUG7SoEhZYc7KhBxHl+DzmlR
6h3rtLOov2vaaKcdWVTfH26Z8nFSR+ziJvEsYf2HhrHLGfp1tDMDNGUQoECL0j6N
KyIa4/CTBlTku5JiQIbOl8F3dcsVV5XMZruuZ7Sbd9TyWdWuCLkAcUOfz6N6h8+L
azPLCvVbS26KRhvouYe5fqyxf0PAECSLM1mTEuxD0hgSQn9tQLvIE0KNeKCRrwGz
RjZmRjVWH+SXYNsPYXC5BSUjgeF62el0tEDcKfEUR++aaaemwBrbsDZvpy1GZnz8
nASoaeS2szcwGbihEY5izFVpGcmLKVYr0BDtnoZRwl7D3RzqR2w97uOaN8iZSmf6
hiUKHhbJvfFwb6db/m5w9jxQiTIoo4QUqztIuo5Vao7aCyjcDMoqsxqbKLlnq/a7
jOjzJ1BZZRS4Ej19GBtqGiqsaVLr2ctLCHzC8eMjDWE6MUO4NiqTrGO3Lqu+hitN
EbZUIOJV5UaQ9KC7HszF8K7lljFQ5w643+V+RJD+w8aJKep+igE=
=huXT
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
