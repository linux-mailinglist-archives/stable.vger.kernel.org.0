Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 123641A6FE
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 08:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfEKGuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 02:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbfEKGuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 02:50:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6AF217F9;
        Sat, 11 May 2019 06:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557557434;
        bh=vKWpPuAgC4cMFoneKeeVDt2c07jTe4V08XTgPqYMnUU=;
        h=Date:From:To:Cc:Subject:From;
        b=tAPWP5lzvzSemcoPT8rJca3h3x49SjRD1PCXt2obPfZK18LCCIQt450vIY3xBz/Uy
         42urVzkNBT8ahMJG9DjCUBcsHUJ5MGAjbg/cgHQuDwKcGHEmqbnQ3WOHC7VCmMj54E
         y0hb+k1rBdRJqFnZ5peyeAtEodQi5bwcV4rjhD5E=
Date:   Sat, 11 May 2019 08:50:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.1
Message-ID: <20190511065032.GA27580@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.1 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                               |    2=20
 arch/arm64/include/asm/futex.h         |   55 ++-
 drivers/acpi/acpi_lpss.c               |    4=20
 drivers/bluetooth/hci_bcm.c            |   20 +
 drivers/cpufreq/armada-37xx-cpufreq.c  |   22 +
 drivers/hv/hv.c                        |    1=20
 drivers/hwtracing/intel_th/pci.c       |    5=20
 drivers/i3c/master.c                   |    5=20
 drivers/iio/adc/qcom-spmi-adc5.c       |    1=20
 drivers/scsi/lpfc/lpfc_attr.c          |  196 ++++++-------
 drivers/scsi/lpfc/lpfc_ct.c            |   12=20
 drivers/scsi/lpfc/lpfc_debugfs.c       |  474 ++++++++++++++++------------=
-----
 drivers/scsi/lpfc/lpfc_debugfs.h       |    6=20
 drivers/scsi/qla2xxx/qla_attr.c        |    4=20
 drivers/scsi/qla2xxx/qla_nvme.c        |   19 -
 drivers/scsi/qla2xxx/qla_target.c      |    4=20
 drivers/soc/sunxi/Kconfig              |    1=20
 drivers/staging/greybus/power_supply.c |    2=20
 drivers/staging/most/cdev/cdev.c       |    2=20
 drivers/staging/most/sound/sound.c     |    2=20
 drivers/staging/wilc1000/wilc_netdev.c |    2=20
 drivers/usb/class/cdc-acm.c            |   32 +-
 drivers/usb/dwc3/Kconfig               |    6=20
 drivers/usb/dwc3/core.c                |    2=20
 drivers/usb/musb/Kconfig               |    2=20
 drivers/usb/serial/f81232.c            |   39 ++
 drivers/usb/storage/scsiglue.c         |   26 -
 drivers/usb/storage/uas.c              |   35 +-
 include/net/bluetooth/hci_core.h       |    3=20
 kernel/futex.c                         |  188 ++++++++-----
 kernel/irq/manage.c                    |    4=20
 lib/ubsan.c                            |   49 +--
 net/bluetooth/hci_conn.c               |    8=20
 net/bluetooth/hidp/sock.c              |    1=20
 net/bluetooth/l2cap_core.c             |    9=20
 sound/soc/intel/common/sst-firmware.c  |    8=20
 36 files changed, 715 insertions(+), 536 deletions(-)

Alan Stern (1):
      usb-storage: Set virt_boundary_mask to avoid SG overflows

Alexander Shishkin (1):
      intel_th: pci: Add Comet Lake support

Andrew Vasquez (1):
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS rout=
ines

Andrey Ryabinin (1):
      ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings

Bjorn Andersson (1):
      iio: adc: qcom-spmi-adc5: Fix of-based module autoloading

Chen-Yu Tsai (1):
      Bluetooth: hci_bcm: Fix empty regulator supplies for Intel Macs

Christian Gromm (1):
      staging: most: sound: pass correct device when creating a sound card

Dan Carpenter (1):
      i3c: Fix a shift wrap bug in i3c_bus_set_addr_slot_status()

Dexuan Cui (1):
      Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cl=
eanup()

Giridhar Malavali (1):
      scsi: qla2xxx: Set remote port devloss timeout to 0

Greg Kroah-Hartman (1):
      Linux 5.1.1

Gregory CLEMENT (1):
      cpufreq: armada-37xx: fix frequency calculation for opp

Hans de Goede (1):
      ACPI / LPSS: Use acpi_lpss_* instead of acpi_subsys_* functions for h=
ibernate

Ji-Ze Hong (Peter Hong) (1):
      USB: serial: f81232: fix interrupt worker not stop

Johan Hovold (2):
      staging: greybus: power_supply: fix prop-descriptor request size
      USB: cdc-acm: fix unthrottle races

Luiz Augusto von Dentz (1):
      Bluetooth: Fix not initializing L2CAP tx_credits

Marc Gonzalez (1):
      usb: dwc3: Allow building USB_DWC3_QCOM without EXTCON

Marcel Holtmann (1):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions

Oliver Neukum (1):
      UAS: fix alignment of scatter/gather segments

Prasad Sodagudi (1):
      genirq: Prevent use-after-free and work list corruption

Quinn Tran (1):
      scsi: qla2xxx: Fix device staying in blocked state

Ross Zwisler (1):
      ASoC: Intel: avoid Oops if DMA setup fails

Samuel Holland (1):
      soc: sunxi: Fix missing dependency on REGMAP_MMIO

Silvio Cesare (1):
      scsi: lpfc: change snprintf to scnprintf for possible overflow

Suresh Udipi (1):
      staging: most: cdev: fix chrdev_region leak in mod_exit

Tetsuo Handa (1):
      staging: wilc1000: Avoid GFP_KERNEL allocation from atomic context.

Thinh Nguyen (1):
      usb: dwc3: Fix default lpm_nyet_threshold value

Will Deacon (2):
      locking/futex: Allow low-level atomic operations to return -EAGAIN
      arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP

Young Xiao (1):
      Bluetooth: hidp: fix buffer overflow


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzWcLgACgkQONu9yGCS
aT51yw/9EpXkufO9+LcXIFUTfPiNx0kqMdYmFG/Ud6/ZWKAXSWAC80rPRJPNX3r6
tx4efNr0sW27tWkcCU7pz92QDdrBmYE4ufTiIHOj3EDqw1FT3yN6Szux3LLotyRn
glkQYbRXdPjiy+dE9lZTtP3S3HXGvbdNNSYhHeWkHKoxKczLDdBy5HmTkYUnYVOy
Ku11NEdjLg3e40Y2ZhfZICziA4Dpm1TQnyD2PCViZIUuYmn6U2PnCJcBDOHKaZ43
ax/Z+mezsEHZJVyMd+U5uUVM1JPApfNPgcCALeFs0BWrMoRsp1tI3WxtmR753F5R
4ivmnQu29EmDCWZynCUQTHPc8XAGv6vLOC5nvuCuRoFWnp4VNTlN5mMtY9U4fCdW
i9QNp5ifSQuroat4sJI1IwRnGqonx3tNJRokSwcOKQkkXotbBsZ0kolTzWyPXOGT
CWZJLKDHXAne86K4h/faZi4wyGrPCbxAfbI6G1DBUPDZIs6QNWA63Zoctfm4XUDW
hlj46uU2zhZmHXgjUdqpoP2rohBXv9q46baXjtzwvVZJWWf/z2HSoWa+893ooGnz
iQVZbB4BAMwQlPwJOKMnn6/HW2KzDnQMkiXNOmylrEMGzEq4mKIifI0Ax+s7a4mE
hsr+BzhPlTI557rjMmubn+XsdxJ0lj3VtEtwcCWXQyVJBRjl80E=
=FuBe
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
