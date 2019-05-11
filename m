Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAFA1A6E9
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 08:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfEKGs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 02:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbfEKGs5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 02:48:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6A62173B;
        Sat, 11 May 2019 06:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557557336;
        bh=pDuluf7nsW8VikVd8v4p3ngM14Ned6ar+uHkIfVZgp0=;
        h=Date:From:To:Cc:Subject:From;
        b=LYQwYQwqjcG8ubX0uEgaGbc1wDgbuT6bP2djqcpPgJinbIMj5Up6S3jpe54rZc3ZA
         sEOxNNN08uzQzNka4Ej8PI/6dbt5QeRsvColDKVrRXCgja2H6LSj6oxbtj800Gltmu
         pb71eFEzojScsmdI8XOD1z4KVMbxoPKkJKwEuRMw=
Date:   Sat, 11 May 2019 08:48:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.175
Message-ID: <20190511064853.GA27200@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.175 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                               |    2 -
 arch/arm/boot/compressed/efi-header.S  |    3 +-
 arch/x86/events/intel/core.c           |    2 -
 drivers/block/virtio_blk.c             |    2 +
 drivers/gpu/drm/mediatek/mtk_hdmi.c    |    2 -
 drivers/infiniband/hw/hfi1/rc.c        |    4 +-
 drivers/iommu/amd_iommu_init.c         |    2 -
 drivers/scsi/csiostor/csio_scsi.c      |    5 ++-
 drivers/scsi/libsas/sas_expander.c     |    9 ++----
 drivers/scsi/qla2xxx/qla_attr.c        |    4 +-
 drivers/staging/greybus/power_supply.c |    2 -
 drivers/usb/dwc3/core.c                |    2 -
 drivers/usb/serial/f81232.c            |   39 ++++++++++++++++++++++++++
 drivers/usb/storage/scsiglue.c         |   26 ++++++++---------
 drivers/usb/storage/uas.c              |   35 ++++++++++++++---------
 include/linux/kernel.h                 |    4 +-
 include/linux/mm.h                     |    9 ++++++
 include/net/bluetooth/hci_core.h       |    3 ++
 kernel/irq/manage.c                    |    4 ++
 kernel/time/timer_stats.c              |    2 -
 lib/ubsan.c                            |   49 +++++++++++++++-------------=
-----
 net/bluetooth/hci_conn.c               |    8 +++++
 net/bluetooth/hidp/sock.c              |    1=20
 sound/soc/codecs/cs4270.c              |    1=20
 sound/soc/codecs/nau8810.c             |    4 +-
 sound/soc/codecs/tlv320aic32x4.c       |    2 +
 sound/soc/intel/common/sst-firmware.c  |    8 ++++-
 sound/soc/soc-pcm.c                    |    7 +++-
 28 files changed, 161 insertions(+), 80 deletions(-)

Alan Stern (1):
      usb-storage: Set virt_boundary_mask to avoid SG overflows

Andrew Vasquez (1):
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS rout=
ines

Andrey Ryabinin (1):
      ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings

Annaliese McDermond (1):
      ASoC: tlv320aic32x4: Fix Common Pins

Ard Biesheuvel (1):
      ARM: 8680/1: boot/compressed: fix inappropriate Thumb2 mnemonic for _=
_nop

Ben Hutchings (1):
      timer/debug: Change /proc/timer_stats from 0644 to 0600

Dan Carpenter (1):
      drm/mediatek: Fix an error code in mtk_hdmi_dt_parse_pdata()

Daniel Mack (1):
      ASoC: cs4270: Set auto-increment bit for register writes

Dongli Zhang (1):
      virtio-blk: limit number of hw queues by nr_cpu_ids

Greg Kroah-Hartman (1):
      Linux 4.9.175

Jann Horn (1):
      linux/kernel.h: Use parentheses around argument in u64_to_user_ptr()

Jason Yan (1):
      scsi: libsas: fix a race condition when smp task timeout

Ji-Ze Hong (Peter Hong) (1):
      USB: serial: f81232: fix interrupt worker not stop

Joerg Roedel (1):
      iommu/amd: Set exclusion range correctly

Johan Hovold (1):
      staging: greybus: power_supply: fix prop-descriptor request size

John Hsu (1):
      ASoC: nau8810: fix the issue of widget with prefixed name

Kaike Wan (1):
      IB/hfi1: Eliminate opcode tests on mr deref

Linus Torvalds (1):
      mm: add 'try_get_page()' helper function

Marcel Holtmann (1):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions

Oliver Neukum (1):
      UAS: fix alignment of scatter/gather segments

Prasad Sodagudi (1):
      genirq: Prevent use-after-free and work list corruption

Rander Wang (1):
      ASoC:soc-pcm:fix a codec fixup issue in TDM case

Ross Zwisler (1):
      ASoC: Intel: avoid Oops if DMA setup fails

Stephane Eranian (1):
      perf/x86/intel: Fix handling of wakeup_events for multi-entry PEBS

Thinh Nguyen (1):
      usb: dwc3: Fix default lpm_nyet_threshold value

Varun Prakash (1):
      scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Wen Yang (1):
      drm/mediatek: fix possible object reference leak

Young Xiao (1):
      Bluetooth: hidp: fix buffer overflow


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzWcFIACgkQONu9yGCS
aT5EPg//Ty3sP2nIE1cbRjlW6tQS96S6V97r8v4pvKy9BkuzJCfVr5XUKt7XXLt9
9aaSkfestVWGyv+wxd28OLp3KCRyJPbw5mMHf3MClV+X2svYx/EfDG0AfZUeYtof
Pjjs8OkM/jdRvwRdbcpmavrNWivMQWgUicGvfg8umNQ+6Ss6hDvfIlHuI7mlL1jb
kio5wtxliSDpA3aBQfhl3JNty8s1Kdk3bXgiLced6/5wyOT2CNy82jyIB0zPMuBg
knpfLayDV1akvdVsENkBNSEHQUpK+R61sBWNkAoIbhrY5iDFAY3oVHe+ckegh19L
kUJdSDpuizaBq03KitIjnt/UD/VfnXZKzCwqosqBz6rhqkknntVEGx8QfjKhX3xf
n5qlPQHLBruCIEa/4xmCI9wec46L/9mBsrXyJu28J/a8rEadO7TNdNoJy+XU3Oho
fXRI7DEA6wi2w7O4/iRPejZQ7ysm2vVCzy+4uT0rPGONMjjJHKiXX5cVO+noacdS
kRyK3WO/+tscxXIqjJ9s0SRRxVQ96Htiibu5W9qRhe19PXxRuJ6yhRrd96dSIL6L
DGr4+W+syXpobzxDpEEfkYiW+pHvaksD4pcVEclSzgminNhB52nDibocc3HG/2Wa
DMLOZSnAEBtrITHR1uDrEpLkOpFqQTP2T6NCtkfUNEug1v+eijQ=
=WNEk
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
