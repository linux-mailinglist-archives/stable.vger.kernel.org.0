Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48811A2444
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 16:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgDHOss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 10:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728716AbgDHOsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 10:48:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA64E206F5;
        Wed,  8 Apr 2020 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586357326;
        bh=lgCBVLEGMqzpp6y8XKII5YQZakuRj2VmwOjHHHWEoNc=;
        h=Date:From:To:Cc:Subject:From;
        b=wJ7FbDH92UvJT0etgMLCuuMRUTFqGMPQxW/cK7eCfYtOdtwZ3sHr8K+ZiM5tOgHD4
         3mh6iyL7DrFEcEP3FvsoL3pVmbWKFqD49MDy8aKqm/kK+k5gIW8e31hG5a2KshgG5K
         TCORbyjFru5jJ71tU4eqrDMHd16lYaQlYRkO20YU=
Date:   Wed, 8 Apr 2020 16:48:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.31
Message-ID: <20200408144843.GA1254135@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.31 kernel.

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

 Makefile                                                   |    2=20
 drivers/extcon/extcon-axp288.c                             |   32 +++++
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c                      |    2=20
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c           |   11 +
 drivers/gpu/drm/bochs/bochs_hw.c                           |    6 -
 drivers/i2c/busses/i2c-i801.c                              |   45 ++------
 drivers/infiniband/hw/hfi1/user_sdma.c                     |   25 +++-
 drivers/md/dm.c                                            |    5=20
 drivers/misc/cardreader/rts5227.c                          |    1=20
 drivers/misc/mei/hw-me-regs.h                              |    2=20
 drivers/misc/mei/pci-me.c                                  |    2=20
 drivers/misc/pci_endpoint_test.c                           |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h    |    4=20
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    2=20
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                |   25 +---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h                |    6 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c             |    6 -
 drivers/nvme/host/rdma.c                                   |    8 -
 drivers/nvmem/nvmem-sysfs.c                                |    6 +
 drivers/pci/pci-sysfs.c                                    |    6 -
 drivers/power/supply/axp288_charger.c                      |   57 ++++++++=
+-
 drivers/soc/mediatek/mtk-cmdq-helper.c                     |    1=20
 drivers/watchdog/iTCO_vendor.h                             |    2=20
 drivers/watchdog/iTCO_vendor_support.c                     |   16 +-
 drivers/watchdog/iTCO_wdt.c                                |   28 ++--
 include/uapi/linux/coresight-stm.h                         |    6 -
 kernel/padata.c                                            |    6 -
 lib/test_xarray.c                                          |   18 +++
 lib/xarray.c                                               |    3=20
 mm/mempolicy.c                                             |    6 -
 net/core/dev.c                                             |    2=20
 net/ipv4/tcp_input.c                                       |    6 -
 net/rxrpc/sendmsg.c                                        |    4=20
 scripts/Kconfig.include                                    |    7 +
 sound/pci/hda/patch_ca0132.c                               |    1=20
 tools/power/x86/turbostat/Makefile                         |    2=20
 tools/power/x86/turbostat/turbostat.c                      |   73 ++++++++=
-----
 usr/Kconfig                                                |   22 +--
 39 files changed, 326 insertions(+), 146 deletions(-)

Alexander Usyskin (1):
      mei: me: add cedar fork device ids

Amritha Nambiar (1):
      net: Fix Tx hash bound checking

Bibby Hsieh (1):
      soc: mediatek: knows_txdone needs to be set in Mediatek CMDQ helper

Daniel Jordan (2):
      padata: fix uninitialized return value in padata_replace()
      padata: always acquire cpu_hotplug_lock before pinst->lock

David Howells (1):
      rxrpc: Fix sendmsg(MSG_WAITALL) handling

Eugene Syromiatnikov (1):
      coresight: do not use the BIT() macro in the UAPI header

Eugeniy Paltsev (1):
      initramfs: restore default compression behavior

Geoffrey Allott (1):
      ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on E=
VGA X99 Classified motherboard

Gerd Hoffmann (1):
      drm/bochs: downgrade pci_request_region failure from error to warning

Greg Kroah-Hartman (1):
      Linux 5.4.31

Guenter Roeck (1):
      brcmfmac: abort and release host after error

Hans de Goede (2):
      extcon: axp288: Add wakeup support
      power: supply: axp288_charger: Add special handling for HP Pavilion x=
2 10

James Zhu (1):
      drm/amdgpu: fix typo for vcn1 idle check

Kelsey Skunberg (1):
      PCI: sysfs: Revert "rescan" file renames

Kishon Vijay Abraham I (2):
      misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices
      misc: pci_endpoint_test: Avoid using module parameter to determine ir=
qtype

Len Brown (3):
      tools/power turbostat: Fix gcc build warnings
      tools/power turbostat: Fix missing SYS_LPI counter on some Chromebooks
      tools/power turbostat: Fix 32-bit capabilities warning

Luca Coelho (1):
      iwlwifi: dbg: don't abort if sending DBGC_SUSPEND_RESUME fails

Mario Kleiner (1):
      drm/amd/display: Add link_rate quirk for Apple 15" MBP 2017

Masahiro Yamada (1):
      kconfig: introduce m32-flag and m64-flag

Matthew Wilcox (Oracle) (1):
      XArray: Fix xa_find_next for large multi-index entries

Mika Westerberg (3):
      watchdog: iTCO_wdt: Export vendorsupport
      watchdog: iTCO_wdt: Make ICH_RES_IO_SMI optional
      i2c: i801: Do not add ICH_RES_IO_SMI for the iTCO_wdt device

Mike Marciniszyn (1):
      IB/hfi1: Ensure pq is not left on waitlist

Mike Snitzer (1):
      Revert "dm: always call blk_queue_split() in dm_process_bio()"

Mordechay Goodstein (2):
      iwlwifi: consider HE capability when setting LDPC
      iwlwifi: yoyo: don't add TLV offset when reading FIFOs

Neal Cardwell (1):
      tcp: fix TFO SYNACK undo to avoid double-timestamp-undo

Nicholas Johnson (1):
      nvmem: check for NULL reg_read and reg_write before dereferencing

Prabhath Sajeepa (1):
      nvme-rdma: Avoid double freeing of async event data

Randy Dunlap (1):
      mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Tariq Toukan (2):
      net/mlx5e: kTLS, Fix TCP seq off-by-1 issue in TX resync flow
      net/mlx5e: kTLS, Fix wrong value in record tracker enum

YueHaibing (1):
      misc: rtsx: set correct pcr_ops for rts522A


--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6N5EgACgkQONu9yGCS
aT4nAw/9ESAo/qZd0pSvaaT9nj7/rWUo3axTiqLbp5M0mM/3+l3m+WYvJZBoIhDe
AFXRZmFuAlkXbMxUQSYQDKdPYK2YlahQdD8vEO0CH90B35yozblNG0wVQD3epnK0
mhbU9MN2o7z0SgpCg1zPYrJe6tlTirjn7TRurgjXYeQJwWQ5mbeqNifzxmXIe8yR
1H93ujG6ElHgeGCFsalHFD3eXdDSYj+9VJKcXHFTEcjpnw8Hf7a/VmghlUG9blQG
4jNXrZ8sWfxQDqSG4wowcUS0ok8/P4Ow8TT7qhP4hYDdKNlKoZLMmIKnyZhPy8Ag
OY7owDnuWg+X0sHgoT3rogJN74N7XZGueDLXkqUL/BugFHXjFRgqjG9IREbiuIkv
frQuzrfGVdV77Q5BtDKCfKmBwjbwF1XOY811s8oqTUtoTnoaBl9nI3f6+MPZBmHq
fqYFuqmL1Y9RY8XOx+HSleTSR5tOz+sQB5QRPYwsLl7engBLeajRbaVT1c2icyqu
/hfOOEqlBe2ZOLA1Aueei2W2F+2NOjLYpSpkunssM7Qu9033pcKuVwTTxByinL3i
/DIX3iMmzDi7MDDJYz+NAsN+UJCas+E2nuV8m7tTm8pM3fna1p1QAGndS6ysz5sD
tWB+Vv+/w/gGY7glFeeozsWzZrtJg1rcZU8nv3+R4fBYCHIjBS4=
=KHiy
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
