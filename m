Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AA71A6EE
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 08:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbfEKGt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 02:49:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbfEKGt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 02:49:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C112D2173B;
        Sat, 11 May 2019 06:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557557366;
        bh=ITxz8GKt+mgE/o6eRTUp3pYhjarXsbIVEV+uhwFNtDo=;
        h=Date:From:To:Cc:Subject:From;
        b=SdIer95E7CsiQfIUOjA9eAwIHQPuy1gS0xeMtbeIB5U8ZEz9MYIrBuA15RGFK7MWX
         j54YkZdxfWurJqSSBpu2hr1dqPzPZhcb5fVOlZUIi4NxO+vmhUeuYUOVfarnPUXW5Z
         YnquSE+Qv/j2JwKVWV/Jr8mhteS7qs4ZeTmVT9gk=
Date:   Sat, 11 May 2019 08:49:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.118
Message-ID: <20190511064923.GA27372@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.118 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/arm64/include/asm/futex.h                      |   55 +++--
 arch/mips/kernel/kgdb.c                             |    3=20
 arch/x86/events/intel/core.c                        |    8=20
 drivers/block/virtio_blk.c                          |    2=20
 drivers/gpu/drm/mediatek/mtk_hdmi.c                 |    2=20
 drivers/hv/hv.c                                     |    1=20
 drivers/hwtracing/intel_th/pci.c                    |    5=20
 drivers/infiniband/hw/hfi1/rc.c                     |    4=20
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c      |    2=20
 drivers/iommu/amd_iommu_init.c                      |    2=20
 drivers/platform/x86/pmc_atom.c                     |    2=20
 drivers/scsi/csiostor/csio_scsi.c                   |    5=20
 drivers/scsi/libsas/sas_expander.c                  |    9=20
 drivers/scsi/qla2xxx/qla_attr.c                     |    4=20
 drivers/staging/greybus/power_supply.c              |    2=20
 drivers/usb/class/cdc-acm.c                         |   32 ++-
 drivers/usb/dwc3/core.c                             |    2=20
 drivers/usb/serial/f81232.c                         |   39 ++++
 drivers/usb/storage/scsiglue.c                      |   26 +-
 drivers/usb/storage/uas.c                           |   35 ++-
 drivers/virtio/virtio_pci_common.c                  |    8=20
 include/linux/kernel.h                              |    4=20
 include/net/bluetooth/hci_core.h                    |    3=20
 kernel/futex.c                                      |  188 ++++++++++++---=
-----
 kernel/irq/manage.c                                 |    4=20
 lib/ubsan.c                                         |   49 ++---
 mm/slab.c                                           |    3=20
 net/bluetooth/hci_conn.c                            |    8=20
 net/bluetooth/hidp/sock.c                           |    1=20
 sound/soc/codecs/cs4270.c                           |    1=20
 sound/soc/codecs/hdmi-codec.c                       |  118 ++++++------
 sound/soc/codecs/nau8810.c                          |    4=20
 sound/soc/codecs/nau8824.c                          |   46 ++++
 sound/soc/codecs/tlv320aic32x4.c                    |    2=20
 sound/soc/codecs/wm_adsp.c                          |   11 -
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c |    2=20
 sound/soc/intel/common/sst-firmware.c               |    8=20
 sound/soc/rockchip/rockchip_pdm.c                   |    2=20
 sound/soc/samsung/odroid.c                          |    4=20
 sound/soc/soc-pcm.c                                 |    7=20
 41 files changed, 458 insertions(+), 257 deletions(-)

Alan Stern (1):
      usb-storage: Set virt_boundary_mask to avoid SG overflows

Alexander Shishkin (1):
      intel_th: pci: Add Comet Lake support

Andrew Vasquez (1):
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS rout=
ines

Andrey Ryabinin (1):
      ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings

Annaliese McDermond (1):
      ASoC: tlv320aic32x4: Fix Common Pins

Charles Keepax (1):
      ASoC: wm_adsp: Add locking to wm_adsp2_bus_error

Chong Qiao (1):
      MIPS: KGDB: fix kgdb support for SMP platforms.

Dan Carpenter (1):
      drm/mediatek: Fix an error code in mtk_hdmi_dt_parse_pdata()

Daniel Mack (1):
      ASoC: cs4270: Set auto-increment bit for register writes

Dexuan Cui (1):
      Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cl=
eanup()

Dongli Zhang (1):
      virtio-blk: limit number of hw queues by nr_cpu_ids

Greg Kroah-Hartman (1):
      Linux 4.14.118

Jann Horn (1):
      linux/kernel.h: Use parentheses around argument in u64_to_user_ptr()

Jason Yan (1):
      scsi: libsas: fix a race condition when smp task timeout

Ji-Ze Hong (Peter Hong) (1):
      USB: serial: f81232: fix interrupt worker not stop

Joerg Roedel (1):
      iommu/amd: Set exclusion range correctly

Johan Hovold (2):
      staging: greybus: power_supply: fix prop-descriptor request size
      USB: cdc-acm: fix unthrottle races

John Hsu (2):
      ASoC: nau8824: fix the issue of the widget with prefix name
      ASoC: nau8810: fix the issue of widget with prefixed name

Kaike Wan (1):
      IB/hfi1: Eliminate opcode tests on mr deref

Kamal Heib (1):
      RDMA/vmw_pvrdma: Fix memory leak on pvrdma_pci_remove

Longpeng (1):
      virtio_pci: fix a NULL pointer reference in vp_del_vqs

Marcel Holtmann (1):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions

Oliver Neukum (1):
      UAS: fix alignment of scatter/gather segments

Peter Zijlstra (1):
      perf/x86/intel: Initialize TFA MSR

Prasad Sodagudi (1):
      genirq: Prevent use-after-free and work list corruption

Qian Cai (1):
      slab: fix a crash by reading /proc/slab_allocators

Rander Wang (1):
      ASoC:soc-pcm:fix a codec fixup issue in TDM case

Ross Zwisler (1):
      ASoC: Intel: avoid Oops if DMA setup fails

Russell King (1):
      ASoC: hdmi-codec: fix S/PDIF DAI

Stephane Eranian (1):
      perf/x86/intel: Fix handling of wakeup_events for multi-entry PEBS

Stephen Boyd (1):
      platform/x86: pmc_atom: Drop __initconst on dmi table

Sugar Zhang (1):
      ASoC: rockchip: pdm: fix regmap_ops hang issue

Sylwester Nawrocki (1):
      ASoC: samsung: odroid: Fix clock configuration for 44100 sample rate

Thinh Nguyen (1):
      usb: dwc3: Fix default lpm_nyet_threshold value

Tzung-Bi Shih (1):
      ASoC: Intel: kbl: fix wrong number of channels

Varun Prakash (1):
      scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Wen Yang (1):
      drm/mediatek: fix possible object reference leak

Will Deacon (2):
      locking/futex: Allow low-level atomic operations to return -EAGAIN
      arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP

Young Xiao (1):
      Bluetooth: hidp: fix buffer overflow


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzWcHMACgkQONu9yGCS
aT5wGQ/7BH5b5kIG1REIeQIZLcMpT8lUDSrnpWHPjwvrZzSKYc7+Oi1iiFcGxc4y
ay+oAktP2NwhpSAoIy2HTtq3NPJusbaQfU2Hv8KMN7NmUyJhbch++GLoaYxmWxtQ
fTjqz8g22ERe+/MK0ckdI0ZrCqbTg9WI8X5XicClMVPADsUz/nwpqr1DiZnj6Hjy
OExmfjQLcjpuuQKOcTCEgTq0ocbhrzDW0QuA/3fz1Tv1YVTw8xos9Vm/Gc4JA6Bn
mbyZWJvYn5EuO3XfzHsaFqbFgz5f5hC83OmMyECGG4BDxO/mtDZBTe1AC9n4aRSu
Xpl5ePmRvSsOx8/AIDFhgOwGsZT8S75DYbZjKerklRyzT5cDB0s9KW6X2sFIuVVM
MCHYM51uRrIRHEpH0IKRxNsUPlLBUsebXR545K94snb8wbb4irQEvIkpTvMZbfPw
gYm0VaTD8/fVZ2aEO1BoMeXbdrueIEehwwtO5F8hdFi+iZaU8ek/7g7QH/vC3ny1
TS1myeuqygMjt3NAsjSKj9c5NjLf3SBP0Pej9XLx9Oum19+X9+PpHzXwLqQQqoiq
6YevpBKmXZAbHroLWkE1QPJbV1HMse57eOapP312LvqFrkRUY90RI0Lq40XT0Nno
CkZhX6vJmZwQJar4wSIng8FauESLm1Ave9uGkkB65uppzPoa9k0=
=qoXA
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
