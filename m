Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D55818DF19
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 10:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgCUJ1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 05:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgCUJ1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 05:27:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C8182070A;
        Sat, 21 Mar 2020 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584782841;
        bh=+YRs8Fsz4bcMuleuuBaEgH8de0FjGPpORANxlIVVpdI=;
        h=Date:From:To:Cc:Subject:From;
        b=RQA/IBc1wMLLccL08bETqR6kMb7hhCKIRFrQAaot6He/vU9w8gIPQ1ETHMBekjxa1
         i7eHo4VSJPO+vniGhYeM49c4fV615zMvqhdOHOGp0t1VCpl5s6vNiUvcNcPLKuVjbe
         N8+BUyrLYZhxkuddrWFWaKbn7u/cJFl+cslC2qIg=
Date:   Sat, 21 Mar 2020 10:27:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.27
Message-ID: <20200321092719.GA887619@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.27 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt      |    4=20
 Makefile                                             |    5=20
 arch/arm/Makefile                                    |    4=20
 arch/arm/boot/compressed/Makefile                    |    4=20
 arch/arm/kernel/vdso.c                               |    2=20
 arch/arm/lib/copy_from_user.S                        |    2=20
 block/blk-flush.c                                    |    2=20
 block/blk-mq-sched.c                                 |   44 +++-
 block/blk-mq.c                                       |   18 +
 block/blk-mq.h                                       |    3=20
 drivers/acpi/acpi_watchdog.c                         |   12 +
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c               |    5=20
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c                |    8=20
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c            |    6=20
 drivers/hid/hid-apple.c                              |    3=20
 drivers/hid/hid-bigbenff.c                           |   31 ++
 drivers/hid/hid-google-hammer.c                      |    2=20
 drivers/hid/hid-ids.h                                |    2=20
 drivers/hid/hid-quirks.c                             |    1=20
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c             |    8=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c     |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h     |    2=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h      |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h      |    1=20
 drivers/net/ethernet/huawei/hinic/hinic_main.c       |    3=20
 drivers/net/ethernet/huawei/hinic/hinic_rx.c         |    5=20
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
 drivers/scsi/libfc/fc_disc.c                         |    2=20
 drivers/watchdog/wdat_wdt.c                          |   23 ++
 fs/jbd2/transaction.c                                |    8=20
 kernel/signal.c                                      |   23 +-
 kernel/trace/trace_events_hist.c                     |   32 ++
 mm/slub.c                                            |    9=20
 net/ipv4/cipso_ipv4.c                                |    7=20
 net/mac80211/rx.c                                    |    2=20
 net/netfilter/xt_hashlimit.c                         |   36 ---
 net/qrtr/qrtr.c                                      |    2=20
 net/wireless/reg.c                                   |    2=20
 tools/testing/selftests/rseq/Makefile                |    2=20
 50 files changed, 560 insertions(+), 247 deletions(-)

Alex Maftei (amaftei) (1):
      sfc: fix timestamp reconstruction at 16-bit rollover points

Antoine Tenart (1):
      net: phy: mscc: fix firmware paths

Ard Biesheuvel (1):
      ARM: 8961/2: Fix Kbuild issue caused by per-task stack protector GCC =
plugin

Carl Huang (1):
      net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue

Chen-Tsung Hsieh (1):
      HID: google: add moonball USB id

Cong Wang (1):
      netfilter: xt_hashlimit: unregister proc file before releasing mutex

Daniele Palmas (1):
      net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch

Esben Haabendal (4):
      net: ll_temac: Fix race condition causing TX hang
      net: ll_temac: Add more error handling of dma_map_single() calls
      net: ll_temac: Fix RX buffer descriptor handling on GFP_ATOMIC pressu=
re
      net: ll_temac: Handle DMA halt condition caused by buffer underrun

Felix Kuehling (1):
      drm/amdgpu: Fix TLB invalidation request when using semaphore

Florian Fainelli (1):
      ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()

Florian Westphal (1):
      netfilter: hashlimit: do not use indirect calls during gc

Greg Kroah-Hartman (1):
      Linux 5.4.27

Hanno Zulla (3):
      HID: hid-bigbenff: fix general protection fault caused by double kfree
      HID: hid-bigbenff: call hid_hw_stop() in case of error
      HID: hid-bigbenff: fix race condition for scheduled work during remov=
al

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

Linus Torvalds (1):
      signal: avoid double atomic counter increments for user accounting

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

yangerkun (1):
      slip: not call free_netdev before rtnl_unlock in slip_open


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl513fcACgkQONu9yGCS
aT4Hcg/5AToP9qv/84TXysTrIDTfrxwQH75xepDtSgGIiSTLSvGkdtProBDMVQyD
9C84KX1nQQRVk6xZ3a9iUAndbvljXqG4rsq4D1A7dY+rJSfhn85rPrHbIDYN4LmJ
0EFEbWOFDg1KsIoOfsEhDf1s9XjbKilJG+lBf8NddYYtv3/WVWa+wyGxtEZ1WeRQ
ArQRhhaEyT0SfGwzsYpFdXA7HbrRAamuZLE0xHej2D/14Yg1VioUnLDPECGDsXs9
QJNxutRnDxmIBfL79Xy7TPVPKCaOH2eGkVgNNC3zjH+H79nSJ3dPK2xPHqd3mFLz
GQ5Ygb5YituimUSsHGJideDUH3aHAtidLtZ9h1sznKVyiH/wHYGgudG38fdTh0IW
Xw1bwRhBJ5usQQn9jJyuaJagPIoNAT9bRAuPxdQdy1aVOwo9MAy9j1EMZCOBgJAI
7G3lXeD7A8UmYmIXTeUo9Y5WJy+0qeOjNRmEGpCff/Q9b31p57yzPc11n57sviPD
IVg6HuQxC+58BjuLb3WBSwExymyFXnAN5KwbzJG39RnqTsXjl9WW12VqdE5xgJj4
Mj+5GaGe7zA0SIfZCV0aI0o/ILuky/7p+Wx3vmjGyFObSw9i9dzY4A4uDBcWXPM0
I2tDqth5GN98xtOa3ZVOyoCs4T8taPoktjjRZkCX7bpfePBGDW8=
=axnj
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
