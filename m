Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB11C192F76
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 18:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCYRiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 13:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgCYRiJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 13:38:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C72AA20777;
        Wed, 25 Mar 2020 17:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585157886;
        bh=8isj3x9k34bKUstFu90kjlnzgMtpgW+TdrQ8raA9a4Y=;
        h=Date:From:To:Cc:Subject:From;
        b=k0f/wf/jHm+ClIwPDpk+3tIcHd/ejILyMDWNcOCcxfbjHqxOgFH7N7n5YyjAiHZw6
         Dla8n9ML76w+pBH3Lk02i//8eyw7Y4PEv021rLb8RN6ZGhG4Zfz/i0mBKn7+n4X76K
         wjXeqJzKw/wE9CZoa1eyfDAr92mQXovSFv1ECQYU=
Date:   Wed, 25 Mar 2020 18:38:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.113
Message-ID: <20200325173803.GA3764069@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.113 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                    |    2=20
 arch/arm/boot/dts/dra7.dtsi                                 |    2=20
 arch/arm64/kernel/smp.c                                     |   25 ++-
 arch/powerpc/kernel/vmlinux.lds.S                           |    6=20
 arch/riscv/kernel/module.c                                  |   16 ++
 arch/x86/mm/fault.c                                         |   26 +++
 block/bfq-cgroup.c                                          |    9 -
 drivers/acpi/apei/ghes.c                                    |    2=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c                 |    6=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    1=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c         |    4=20
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                   |   46 +++--
 drivers/gpu/drm/drm_lease.c                                 |    3=20
 drivers/gpu/drm/exynos/exynos_drm_dsi.c                     |   12 -
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                     |   18 +-
 drivers/hwtracing/intel_th/msu.c                            |    6=20
 drivers/hwtracing/intel_th/pci.c                            |    5=20
 drivers/iio/accel/st_accel_i2c.c                            |    2=20
 drivers/iio/adc/at91-sama5d2_adc.c                          |   15 +
 drivers/iio/light/vcnl4000.c                                |    7=20
 drivers/iio/magnetometer/ak8974.c                           |    2=20
 drivers/iio/trigger/stm32-timer-trigger.c                   |   11 +
 drivers/md/dm-bio-record.h                                  |   15 +
 drivers/md/dm-integrity.c                                   |   32 +---
 drivers/misc/altera-stapl/altera.c                          |   12 -
 drivers/misc/cardreader/rts5227.c                           |    2=20
 drivers/misc/cardreader/rts5249.c                           |    2=20
 drivers/misc/cardreader/rts5260.c                           |    2=20
 drivers/mmc/host/rtsx_pci_sdmmc.c                           |   13 +
 drivers/mmc/host/sdhci-of-at91.c                            |    8 -
 drivers/net/vrf.c                                           |   19 +-
 drivers/perf/arm_pmu_acpi.c                                 |    7=20
 drivers/rtc/Kconfig                                         |    1=20
 drivers/spi/spi-pxa2xx.c                                    |   23 ++
 drivers/spi/spi-qup.c                                       |   11 -
 drivers/spi/spi-zynqmp-gqspi.c                              |    3=20
 drivers/staging/greybus/tools/loopback_test.c               |   21 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                 |    1=20
 drivers/staging/speakup/main.c                              |    2=20
 drivers/usb/class/cdc-acm.c                                 |   34 ++--
 drivers/usb/core/quirks.c                                   |    6=20
 drivers/usb/host/xhci-pci.c                                 |    3=20
 drivers/usb/host/xhci-plat.c                                |    1=20
 drivers/usb/host/xhci-trace.h                               |   23 --
 drivers/usb/serial/option.c                                 |    2=20
 drivers/usb/serial/pl2303.c                                 |    1=20
 drivers/usb/serial/pl2303.h                                 |    1=20
 drivers/xen/xenbus/xenbus_comms.c                           |    4=20
 drivers/xen/xenbus/xenbus_xs.c                              |    9 -
 fs/btrfs/inode.c                                            |    4=20
 fs/inode.c                                                  |    1=20
 include/linux/fs.h                                          |    1=20
 include/linux/futex.h                                       |   17 +-
 include/linux/page-flags.h                                  |    2=20
 include/linux/vmalloc.h                                     |    5=20
 kernel/futex.c                                              |   93 +++++++=
-----
 kernel/notifier.c                                           |    2=20
 mm/memcontrol.c                                             |   10 +
 mm/nommu.c                                                  |   10 -
 mm/slub.c                                                   |   32 ++--
 mm/vmalloc.c                                                |   11 -
 net/ipv6/tcp_ipv6.c                                         |    3=20
 scripts/Makefile.extrawarn                                  |    1=20
 sound/core/oss/pcm_plugin.c                                 |   12 +
 sound/core/seq/oss/seq_oss_midi.c                           |    1=20
 sound/core/seq/seq_virmidi.c                                |    1=20
 sound/pci/hda/patch_realtek.c                               |    2=20
 sound/usb/line6/driver.c                                    |    2=20
 sound/usb/line6/midibuf.c                                   |    2=20
 69 files changed, 457 insertions(+), 239 deletions(-)

Alberto Mattea (1):
      usb: xhci: apply XHCI_SUSPEND_DELAY to AMD XHCI controller 1022:145c

Alexander Shishkin (2):
      intel_th: Fix user-visible error codes
      intel_th: pci: Add Elkhart Lake CPU support

Anthony Mallet (2):
      USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL
      USB: cdc-acm: fix rounding error in TIOCSSERIAL

Bhawanpreet Lakha (1):
      drm/amd/display: Clear link settings on MST disable connector

Carlo Nonato (1):
      block, bfq: fix overwrite of bfq_group pointer in bfq_find_set_group()

Chunguang Xu (1):
      memcg: fix NULL pointer dereference in __mem_cgroup_usage_unregister_=
event

Corentin Labbe (1):
      rtc: max8907: add missing select REGMAP_IRQ

Cristian Marussi (2):
      arm64: smp: fix smp_send_stop() behaviour
      arm64: smp: fix crash_smp_send_stop() behaviour

Daniel Axtens (1):
      altera-stapl: altera_get_note: prevent write beyond end of 'key'

Daniele Palmas (1):
      USB: serial: option: add ME910G1 ECM composition 0x110b

Dongli Zhang (2):
      xenbus: req->body should be updated before req->state
      xenbus: req->err should be updated before req->state

Eugen Hristev (1):
      iio: adc: at91-sama5d2_adc: fix differential channels in triggered mo=
de

Evan Benn (1):
      drm/mediatek: Find the cursor plane instead of hard coding it

Evan Green (1):
      spi: pxa2xx: Add CS control clock quirk

Fabrice Gasnier (1):
      iio: trigger: stm32-timer: disable master mode when stopping

Filipe Manana (1):
      btrfs: fix log context list corruption after rename whiteout error

Greg Kroah-Hartman (1):
      Linux 4.19.113

Hans de Goede (1):
      usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters

Jernej Skrabec (1):
      drm/bridge: dw-hdmi: fix AVI frame colorimetry

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

Linus Torvalds (1):
      mm: slub: be more careful about the double cmpxchg of freelist

Marek Szyprowski (2):
      drm/exynos: dsi: propagate error value and silence meaningless warning
      drm/exynos: dsi: fix workaround for the legacy clock name

Michael Straube (1):
      staging: rtl8188eu: Add device id for MERCUSYS MW150US v2

Micha=C5=82 Miros=C5=82aw (1):
      mmc: sdhci-of-at91: fix cd-gpios for SAMA5D2

Mike Snitzer (2):
      dm bio record: save/restore bi_end_io and bi_integrity
      dm integrity: use dm_bio_record and dm_bio_restore

Nathan Chancellor (1):
      kbuild: Disable -Wpointer-to-enum-cast

Naveen N. Rao (1):
      powerpc: Include .BTF section

Peter Zijlstra (1):
      futex: Fix inode life-time issue

Qian Cai (1):
      page-flags: fix a crash at SetPageError(THP_SWAP)

Qiujun Huang (1):
      drm/lease: fix WARNING in idr_destroy

Ran Wang (1):
      usb: host: xhci-plat: add a shutdown

Ricky Wu (1):
      mmc: rtsx_pci: Fix support for speed-modes that relies on tuning

Samuel Thibault (1):
      staging/speakup: fix get_word non-space look-ahead

Sasha Levin (2):
      Revert "vrf: mark skb for multicast or link-local as enslaved to VRF"
      Revert "ipv6: Fix handling of LLA with VRF and sockets bound to VRF"

Scott Chen (1):
      USB: serial: pl2303: add device-id for HP LD381

Stephan Gerhold (1):
      iio: magnetometer: ak8974: Fix negative raw values in sysfs

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

Tomas Novotny (1):
      iio: light: vcnl4000: update sampling periods for vcnl4200

Vincent Chen (1):
      riscv: avoid the PIC offset of static percpu data in module beyond 2G=
 limits

Vlastimil Babka (1):
      mm, slub: prevent kmalloc_node crashes and memory leaks

Wen-chien Jesse Sung (1):
      iio: st_sensors: remap SMO8840 to LIS2DH12

Yuji Sasaki (1):
      spi: qup: call spi_qup_pm_resume_runtime before suspending

luanshi (1):
      drivers/perf: arm_pmu_acpi: Fix incorrect checking of gicc pointer


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl57lvgACgkQONu9yGCS
aT580xAA1tC/iSI52jPuY6h7B05mQHbb8GwS5SDLPuNQIccoN/KZbYB0h+lnF+7c
6fai1f7y9IlA39a3nF1bkMeFXDsuLk7+8mjpATNjoCYK6i42kjQM14t3sdZjm/wp
Qp8B+c+C8EdYstYXFWcC4o+FXJiZZz3CqYL4bpG3qZ3M/vXGSky19/dSbd3dKCuV
G9GS/jHax7HT1teny5zoUKHcpGlkIQtn20qy1mLG+kqLftlnFOhRTRTug5pZcHRE
lEPnBWHlMDkyv6RO43SjnEL/9F+iZ3N23AqIjMH5dmEAryoRHAPSJsESf/suCp32
LKotcMfyvc4RunmmcqbEL3PzDL3Jxm95nhyLQc11HmEoqUagkZuu0vXCKukelVf9
sbcZMjhDWEUIZoCbiKheTdV7UmwXKEYKWISeOegNX1j42M6B9jYYNHmuFQw3y4zn
ciKzmQu+NEY+zPi6yTIVdRL7sTG9IXJwaGNT/TVtoxBRxuCXggDUPwRJdxa+uq4w
JGP9a0fn1UsObHlNkYhrzJ5d8OMEbb2eYmjQ0R4OikNmPcHk4UrJB5s8i3/fXjt+
YUFHnKOfIQrTF1NNWQ1tQLQGunH3fSKzU3EJVjzzCI3cbgfHzzNjRi4Wp9BM1qRD
SAJ/ykddv8VWZ9G+TVty4heRcm1aCIIGob9TLFfKLBzwqO7wF/c=
=1/e+
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
