Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF26C18DF15
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 10:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgCUJ07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 05:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbgCUJ07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 05:26:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44B312070A;
        Sat, 21 Mar 2020 09:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584782817;
        bh=bh0Q5jwPPONwZymIO+NRRCADHZlZolw/ajRERUrr/OA=;
        h=Date:From:To:Cc:Subject:From;
        b=u+N7U6VTpF44OMtKWBoeUqT1pA2WnxFdO3BTvD1oMz3aKOuB4TFB9MqqcUiLmhuXn
         TaSJuz1Bs33cQuvIAdM3+4QhYB+g5AMhH2TiSQpW5oDJ8xoGy1eX6pT5wQ3ocM4nrP
         uI1FD+3+3pdIDwJaifA2jxtBjikQbPpWi5REclFM=
Date:   Sat, 21 Mar 2020 10:26:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.112
Message-ID: <20200321092655.GA887504@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.112 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt      |    4=20
 Documentation/driver-api/device_link.rst             |   63 ++--
 Makefile                                             |    2=20
 arch/arm/kernel/vdso.c                               |    2=20
 arch/arm/lib/copy_from_user.S                        |    2=20
 arch/x86/events/amd/uncore.c                         |   14=20
 drivers/acpi/acpi_watchdog.c                         |   12=20
 drivers/base/core.c                                  |  293 +++++++++++++-=
-----
 drivers/base/dd.c                                    |    2=20
 drivers/base/power/runtime.c                         |    4=20
 drivers/firmware/efi/runtime-wrappers.c              |    2=20
 drivers/hid/hid-apple.c                              |    3=20
 drivers/hid/hid-google-hammer.c                      |    2=20
 drivers/hid/hid-ids.h                                |    1=20
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c             |    8=20
 drivers/mmc/host/Kconfig                             |    2=20
 drivers/mmc/host/sdhci-omap.c                        |  148 +++++++++
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c     |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h     |    2=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h      |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h      |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_rx.c         |    5=20
 drivers/net/ethernet/micrel/ks8851_mll.c             |   14=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c   |  186 +++++-------
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h   |    3=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c |    7=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c      |    8=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h      |    1=20
 drivers/net/ethernet/sfc/ptp.c                       |   38 ++
 drivers/net/slip/slip.c                              |    3=20
 drivers/net/usb/qmi_wwan.c                           |    3=20
 drivers/net/wimax/i2400m/op-rfkill.c                 |    1=20
 drivers/scsi/libfc/fc_disc.c                         |    2=20
 fs/jbd2/transaction.c                                |    8=20
 include/linux/device.h                               |    7=20
 kernel/signal.c                                      |   23 -
 mm/slub.c                                            |    9=20
 net/ipv4/cipso_ipv4.c                                |    7=20
 net/mac80211/rx.c                                    |    2=20
 net/qrtr/qrtr.c                                      |    2=20
 net/wireless/reg.c                                   |    2=20
 41 files changed, 645 insertions(+), 255 deletions(-)

Alex Maftei (amaftei) (1):
      sfc: fix timestamp reconstruction at 16-bit rollover points

Carl Huang (1):
      net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue

Chen-Tsung Hsieh (1):
      HID: google: add moonball USB id

Daniele Palmas (1):
      net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch

Faiz Abbas (5):
      mmc: sdhci-omap: Add platform specific reset callback
      mmc: sdhci-omap: Workaround errata regarding SDR104/HS200 tuning fail=
ures (i929)
      mmc: host: Fix Kconfig warnings on keystone_defconfig
      mmc: sdhci-omap: Don't finish_mrq() on a command error during tuning
      mmc: sdhci-omap: Fix Tuning procedure for temperatures < -20C

Florian Fainelli (1):
      ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()

Greg Kroah-Hartman (1):
      Linux 4.19.112

Igor Druzhinin (1):
      scsi: libfc: free response frame from GPN_ID

Jann Horn (1):
      mm: slub: add missing TID bump in kmem_cache_alloc_bulk()

Jean Delvare (1):
      ACPI: watchdog: Allow disabling WDAT at boot

Johannes Berg (1):
      cfg80211: check reg_rule for NULL in handle_channel_custom()

Kai-Heng Feng (1):
      HID: i2c-hid: add Trekstor Surfbook E11B to descriptor override

Kees Cook (1):
      ARM: 8958/1: rename missed uaccess .fixup section

Kim Phillips (1):
      perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT =
flag

Linus Torvalds (1):
      signal: avoid double atomic counter increments for user accounting

Luo bin (2):
      hinic: fix a irq affinity bug
      hinic: fix a bug of setting hw_ioctxt

Madhuparna Bhowmik (1):
      mac80211: rx: avoid RCU list traversal under mutex

Mansour Behabadi (1):
      HID: apple: Add support for recent firmware on Magic Keyboards

Marek Vasut (1):
      net: ks8851-ml: Fix IRQ handling and locking

Matteo Croce (1):
      ipv4: ensure rcu_read_lock() in cipso_v4_error()

Navid Emamdoost (2):
      wimax: i2400: fix memory leak
      wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Qian Cai (1):
      jbd2: fix data races at struct journal_head

Rafael J. Wysocki (5):
      driver core: Fix adding device links to probing suppliers
      driver core: Make driver core own stateful device links
      driver core: Add device link flag DL_FLAG_AUTOPROBE_CONSUMER
      driver core: Remove device link creation limitation
      driver core: Fix creation of device links with PM-runtime flags

Taehee Yoo (8):
      net: rmnet: fix NULL pointer dereference in rmnet_newlink()
      net: rmnet: fix NULL pointer dereference in rmnet_changelink()
      net: rmnet: fix suspicious RCU usage
      net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
      net: rmnet: do not allow to change mux id if mux id is duplicated
      net: rmnet: use upper/lower device infrastructure
      net: rmnet: fix bridge mode bugs
      net: rmnet: fix packet forwarding in rmnet bridge mode

Waiman Long (1):
      efi: Fix debugobjects warning on 'efi_rts_work'

Yong Wu (1):
      driver core: Remove the link if there is no driver with AUTO flag

yangerkun (1):
      slip: not call free_netdev before rtnl_unlock in slip_open


--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl513d8ACgkQONu9yGCS
aT6GfQ/7BdGp/0EJK4/GTnFCMCHX6eYgd0f3w1lFuZLZqwXjt9MiXB6//9TiT0vY
6cjZGTyjnDHZq91TOn3CTLEPOjUpAmKWuwXaY0m3eiEV2AbPWlVgyzvbeUOxqf73
Kkt3dvX30r0W8XoL2mJuRHZ2bixAfK4jWpqrsEv38xzXHIC8T9KR/gG7GZe7/wQV
1uawirao8PC3yloKWN4O50qFoIZNHtxUZrjr4q+3rwR88sQ+ScsJbC9RYpAC8ltK
arl5RU8p+CvTi5FDUVsw1EW6TFeTUhVJ0uJMFaxRMiOjvfVeD79PHpcabPou78Jr
XQ4x5Q8Hf8BkbGQq9iSl9aD2SfjVXMWFEUdM6XD2CLZcsiG2IbQgkDNGYJoWWBb+
LkmsmTWIwD+LY+W4lnhj9ZzemiARR34Ti0XDmy248uGzAu310AcS6oD2LHuuaf2Y
sHMqaXKTy0dkw9xyvPdxERXFv2vwJ2oTRQbuKq+fAF7jqsXLdu/VqDbhikwXWfPW
KkcywSzzJryWHKm4dJgrv07iqx5t1m0FL8WjsLnmEIwo6gfSgNX4RyPurJlS7ByL
Q6BdHjofH4za8adTlSB9X2ZfbapkoV1B6usHHvrPI9F0ypU2V/JYykagFNyDd17Q
urhGYD7jiH8dy2DfK2tPvkG1a5Ng4KmN7dKq7fvBkenmpKhNbQo=
=ojfq
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
