Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4320B18DF1F
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 10:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgCUJ1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 05:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgCUJ1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 05:27:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F19C520753;
        Sat, 21 Mar 2020 09:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584782867;
        bh=SUkUL2HvApFNrzV3pK9UHWRKPAc4zOmJ6itdSNX4HgQ=;
        h=Date:From:To:Cc:Subject:From;
        b=hjV/kh5fCWTjuv2SI6SFugAKJSl6vtW84fCJvxvtozX4hXlQr2B6St/WMUr9yOIcd
         7z7pocgRyGt2aa5JA5NMpx99JiBBDrwO3ykc8o41s/4iXAEgLXY8VOUgSe4DDHA/1D
         0NK055BcqodScCiokkr2r/n9tieRTJw/0NxKg6yo=
Date:   Sat, 21 Mar 2020 10:27:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.11
Message-ID: <20200321092744.GA887771@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.11 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt      |    4=20
 Makefile                                             |    5=20
 arch/arm/Makefile                                    |    4=20
 arch/arm/boot/compressed/Makefile                    |    4=20
 arch/arm/kernel/vdso.c                               |    2=20
 arch/arm/lib/copy_from_user.S                        |    2=20
 arch/riscv/include/asm/csr.h                         |   12 +
 arch/riscv/kernel/head.S                             |    6=20
 block/blk-flush.c                                    |    2=20
 block/blk-mq-sched.c                                 |   44 +++-
 block/blk-mq.c                                       |   18 +
 block/blk-mq.h                                       |    3=20
 drivers/acpi/acpi_watchdog.c                         |   12 +
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c            |    6=20
 drivers/hid/hid-apple.c                              |    3=20
 drivers/hid/hid-bigbenff.c                           |   31 ++
 drivers/hid/hid-google-hammer.c                      |    2=20
 drivers/hid/hid-ids.h                                |    2=20
 drivers/hid/hid-quirks.c                             |    1=20
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c             |    8=20
 drivers/net/dsa/mv88e6xxx/global1.c                  |    4=20
 drivers/net/ethernet/broadcom/genet/bcmmii.c         |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c     |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h     |    2=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h      |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h      |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_main.c       |    3=20
 drivers/net/ethernet/huawei/hinic/hinic_rx.c         |    5=20
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h         |    2=20
 drivers/net/ethernet/micrel/ks8851_mll.c             |   14 -
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c   |  186 ++++++++------=
--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h   |    3=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c |    7=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c      |    8=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h      |    1=20
 drivers/net/ethernet/sfc/ptp.c                       |   38 +++
 drivers/net/ethernet/xilinx/ll_temac.h               |    4=20
 drivers/net/ethernet/xilinx/ll_temac_main.c          |  209 ++++++++++++++=
+----
 drivers/net/phy/mscc.c                               |    4=20
 drivers/net/slip/slip.c                              |    3=20
 drivers/net/usb/qmi_wwan.c                           |    3=20
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c             |    2=20
 drivers/scsi/libfc/fc_disc.c                         |    2=20
 drivers/watchdog/wdat_wdt.c                          |   23 ++
 fs/io_uring.c                                        |   67 ++----
 fs/jbd2/transaction.c                                |    8=20
 kernel/signal.c                                      |   23 +-
 kernel/trace/trace_events_hist.c                     |   32 ++
 mm/slub.c                                            |    9=20
 net/ipv4/cipso_ipv4.c                                |    7=20
 net/mac80211/rx.c                                    |    2=20
 net/wireless/reg.c                                   |    2=20
 tools/testing/kunit/kunit.py                         |   12 +
 tools/testing/selftests/rseq/Makefile                |    2=20
 54 files changed, 609 insertions(+), 253 deletions(-)

Alex Maftei (amaftei) (1):
      sfc: fix timestamp reconstruction at 16-bit rollover points

Amit Cohen (1):
      mlxsw: pci: Wait longer before accessing the device after reset

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Fix masking of egress port

Antoine Tenart (1):
      net: phy: mscc: fix firmware paths

Ard Biesheuvel (1):
      ARM: 8961/2: Fix Kbuild issue caused by per-task stack protector GCC =
plugin

Chen-Tsung Hsieh (1):
      HID: google: add moonball USB id

Daniele Palmas (1):
      net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch

Esben Haabendal (4):
      net: ll_temac: Fix race condition causing TX hang
      net: ll_temac: Add more error handling of dma_map_single() calls
      net: ll_temac: Fix RX buffer descriptor handling on GFP_ATOMIC pressu=
re
      net: ll_temac: Handle DMA halt condition caused by buffer underrun

Florian Fainelli (1):
      ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()

Greentime Hu (1):
      riscv: set pmp configuration if kernel is running in M-mode

Greg Kroah-Hartman (1):
      Linux 5.5.11

Hanno Zulla (3):
      HID: hid-bigbenff: fix general protection fault caused by double kfree
      HID: hid-bigbenff: call hid_hw_stop() in case of error
      HID: hid-bigbenff: fix race condition for scheduled work during remov=
al

Heidi Fahim (1):
      kunit: run kunit_tool from any directory

Igor Druzhinin (1):
      scsi: libfc: free response frame from GPN_ID

Jann Horn (1):
      mm: slub: add missing TID bump in kmem_cache_alloc_bulk()

Jean Delvare (1):
      ACPI: watchdog: Allow disabling WDAT at boot

Jens Axboe (1):
      io_uring: pick up link work on submit reference drop

Johannes Berg (1):
      cfg80211: check reg_rule for NULL in handle_channel_custom()

Kai-Heng Feng (1):
      HID: i2c-hid: add Trekstor Surfbook E11B to descriptor override

Kees Cook (1):
      ARM: 8958/1: rename missed uaccess .fixup section

Linus Torvalds (1):
      signal: avoid double atomic counter increments for user accounting

Linus Walleij (1):
      pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug

Luo bin (3):
      hinic: fix a irq affinity bug
      hinic: fix a bug of setting hw_ioctxt
      hinic: fix a bug of rss configuration

Madhuparna Bhowmik (1):
      mac80211: rx: avoid RCU list traversal under mutex

Mansour Behabadi (1):
      HID: apple: Add support for recent firmware on Magic Keyboards

Marek Vasut (1):
      net: ks8851-ml: Fix IRQ handling and locking

Masahiro Yamada (2):
      kbuild: add dtbs_check to PHONY
      kbuild: add dt_binding_check to PHONY in a correct place

Matteo Croce (1):
      ipv4: ensure rcu_read_lock() in cipso_v4_error()

Michael Ellerman (1):
      selftests/rseq: Fix out-of-tree compilation

Mika Westerberg (1):
      ACPI: watchdog: Set default timeout in probe

Ming Lei (2):
      blk-mq: insert passthrough request into hctx->dispatch directly
      blk-mq: insert flush request to the front of dispatch queue

Monk Liu (1):
      drm/amdgpu: fix memory leak during TDR test(v2)

Nicolas Saenz Julienne (1):
      net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed

Qian Cai (1):
      jbd2: fix data races at struct journal_head

Taehee Yoo (8):
      net: rmnet: fix NULL pointer dereference in rmnet_newlink()
      net: rmnet: fix NULL pointer dereference in rmnet_changelink()
      net: rmnet: fix suspicious RCU usage
      net: rmnet: remove rcu_read_lock in rmnet_force_unassociate_device()
      net: rmnet: do not allow to change mux id if mux id is duplicated
      net: rmnet: use upper/lower device infrastructure
      net: rmnet: fix bridge mode bugs
      net: rmnet: fix packet forwarding in rmnet bridge mode

Tom Zanussi (1):
      tracing: Fix number printing bug in print_synth_event()

Tony Fischetti (1):
      HID: add ALWAYS_POLL quirk to lenovo pixart mouse

Xiaoguang Wang (1):
      io_uring: fix poll_list race for SETUP_IOPOLL|SETUP_SQPOLL

yangerkun (1):
      slip: not call free_netdev before rtnl_unlock in slip_open


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl513hAACgkQONu9yGCS
aT4kcQ/+NfDWOqREngvX7ulu90l0xPXcgy2N/sFOz7PErLgGzoW38Qv6nVL5MHLG
1/W83godKSUnvYU0pI2s1Ley7Nme9g2d84HDrfFg5R6Wk5nf7AL4TNd12L+mUGOp
r/tuEbVRn4u8RlYHoOlCeWMGYLEpd9MQu4JV3lWkN3at5RDfXujodeIREUddUP7E
3Ha90fxjFRD/Ly5YexYG7udqxqJ6riIqQrIejyxu3G0Tqdh9tk+u08kSBZwt/7dt
K0NOD91HBTIFSWV+2BcVxISWtI85+fkhAcjlzNyxLy7o1Homq9VDFW8BO4d9aBeG
pKlg/AdD0uo27CQbXW63phqY3Os5RefkYROoX4qrfLRL/VVVpWM+Zh7Fex1l3103
IjdclVQCTJXsMNIbM4uTFPh7PTJl3sS0OC6Hx2wE6W/5v/MKoa8LQ5uL0hi2G6nf
ljiYJVZvmpNZ0SKtSHKh65eAreKDJ78iJDtWXpRVAesw+r/3hru3grhSGUrSx4In
/I83LibMJL+gb++bLHEvVOTkTCakDV1MrS4+T+p+treVv46W7EklIu1ZGYpmxR+a
oRLWb9eAYdqlP9J+IRCflXyCY7q8Yi2i3K3uqqTfHMZBTgSULlyCJGLMmWOhADT1
YPOP8EE4C4Ff3uj1ingWnOe4JEQoArMYwXWOAdZC3x5m3l6L4Lk=
=waMN
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
