Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C011A2450
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 16:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgDHOta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 10:49:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgDHOt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 10:49:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E23B20678;
        Wed,  8 Apr 2020 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586357367;
        bh=7JEb8l6efcy9qtD8hsFyu8199RYVj+RFbZx+OLxXjPw=;
        h=Date:From:To:Cc:Subject:From;
        b=WKKX70GLG33+JcDd0rgBIlII9gfnRpKh50SbdGYb/F04+yC4X3kvxBcpfe3jDssLC
         lyMm9QpY3qBR/1BzT7TyTRVQWZJh2DjWP3TAM7lmZnaAxdK1bhVbBo1XGSB/OPBXe1
         QqYsOb00eRYCtLvD4HR/duVFLsPBRtogwgNuxops=
Date:   Wed, 8 Apr 2020 16:49:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.6.3
Message-ID: <20200408144924.GA1254356@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.6.3 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                |    2=20
 drivers/extcon/extcon-axp288.c                          |   32 ++++++++
 drivers/gpu/drm/bridge/analogix/analogix-anx6345.c      |    4 -
 drivers/gpu/drm/i915/display/intel_display.c            |    4 -
 drivers/md/dm.c                                         |    5 -
 drivers/misc/cardreader/rts5227.c                       |    1=20
 drivers/misc/mei/hw-me-regs.h                           |    2=20
 drivers/misc/mei/pci-me.c                               |    2=20
 drivers/misc/pci_endpoint_test.c                        |   14 ++-
 drivers/net/dsa/microchip/Kconfig                       |    1=20
 drivers/net/ethernet/cadence/macb_main.c                |    3=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    2=20
 drivers/nvmem/core.c                                    |    1=20
 drivers/nvmem/nvmem-sysfs.c                             |    6 +
 drivers/nvmem/sprd-efuse.c                              |    2=20
 drivers/pci/pci-sysfs.c                                 |    6 +
 drivers/power/supply/axp288_charger.c                   |   57 +++++++++++=
++++-
 drivers/soc/mediatek/mtk-cmdq-helper.c                  |    1=20
 include/uapi/linux/coresight-stm.h                      |    6 +
 include/uapi/sound/asoc.h                               |    1=20
 kernel/padata.c                                         |    2=20
 lib/test_xarray.c                                       |   18 +++++
 lib/xarray.c                                            |    3=20
 mm/mempolicy.c                                          |    6 +
 net/core/skbuff.c                                       |    1=20
 net/ipv4/fib_trie.c                                     |    3=20
 net/ipv4/ip_tunnel.c                                    |    6 -
 net/ipv4/udp_offload.c                                  |    1=20
 net/sctp/ipv6.c                                         |   20 +++--
 net/sctp/protocol.c                                     |   28 +++++--
 net/sctp/socket.c                                       |   31 ++++++--
 sound/pci/hda/patch_ca0132.c                            |    1=20
 tools/perf/util/setup.py                                |    2=20
 33 files changed, 225 insertions(+), 49 deletions(-)

Alexander Usyskin (1):
      mei: me: add cedar fork device ids

Arnaldo Carvalho de Melo (1):
      perf python: Fix clang detection to strip out options passed in $CC

Bibby Hsieh (1):
      soc: mediatek: knows_txdone needs to be set in Mediatek CMDQ helper

Codrin Ciubotariu (2):
      net: dsa: ksz: Select KSZ protocol tag
      net: macb: Fix handling of fixed-link node

Daniel Jordan (1):
      padata: fix uninitialized return value in padata_replace()

Eugene Syromiatnikov (1):
      coresight: do not use the BIT() macro in the UAPI header

Florian Westphal (1):
      net: fix fraglist segmentation reference count leak

Freeman Liu (1):
      nvmem: sprd: Fix the block lock operation

Geoffrey Allott (1):
      ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on E=
VGA X99 Classified motherboard

Greg Kroah-Hartman (1):
      Linux 5.6.3

Guenter Roeck (1):
      brcmfmac: abort and release host after error

Hans de Goede (2):
      extcon: axp288: Add wakeup support
      power: supply: axp288_charger: Add special handling for HP Pavilion x=
2 10

Kelsey Skunberg (1):
      PCI: sysfs: Revert "rescan" file renames

Khouloud Touil (1):
      nvmem: release the write-protect pin

Kishon Vijay Abraham I (2):
      misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices
      misc: pci_endpoint_test: Avoid using module parameter to determine ir=
qtype

Marcelo Ricardo Leitner (1):
      sctp: fix possibly using a bad saddr with a given dst

Matthew Wilcox (Oracle) (1):
      XArray: Fix xa_find_next for large multi-index entries

Mike Snitzer (1):
      Revert "dm: always call blk_queue_split() in dm_process_bio()"

Nicholas Johnson (1):
      nvmem: check for NULL reg_read and reg_write before dereferencing

Qian Cai (1):
      ipv4: fix a RCU-list lock in fib_triestat_seq_show

Qiujun Huang (1):
      sctp: fix refcount bug in sctp_wfree

Randy Dunlap (1):
      mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Takashi Iwai (1):
      Revert "ALSA: uapi: Drop asound.h inclusion from asoc.h"

Torsten Duwe (1):
      drm/bridge: analogix-anx6345: Avoid duplicate -supply suffix

Uma Shankar (1):
      drm/i915/display: Fix mode private_flags comparison at atomic_check

William Dauchy (1):
      net, ip_tunnel: fix interface lookup with no key

Xin Long (1):
      udp: initialize is_flist with 0 in udp_gro_receive

YueHaibing (1):
      misc: rtsx: set correct pcr_ops for rts522A


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6N5HQACgkQONu9yGCS
aT62mQ/9FTsqrOt5EncNzybBQCOgfAJQDoAnPl/yG8U5sT7ldM70wIu4cfv0FDvr
VtXMk/BOW5koYHgXm99Jd6mpR3Lg6L50IDMaGsT8QUZKR1H5UcyStCK9Dp44XpS8
TkmZsX9a+ctiFWycoP4r8NIpRbEpMWL3z9uyR2sMdVLGOv2PANU8iJMm1SsbyY5n
/4Ag3rXs258HeeLavQNhKNy/iVf19KGDzP+oIA1+OU/T2jGS6I0UayaVT8IZxPPR
GV1HtkOXIRvDGNKs9Y88aEOuldoP+F+jLky7Qm80+Hsz84ezxrmc/7uVXp8E8Tgg
6HD9du6efTNhb8QVvCwgV7he8p00pfbIaK/b9fqacfs55DWAU4Aq00tPO8R7inU1
C6zVnAdUQMv9ijDH0YRhGkB1mLFq2UBnAJ7Gf2J+v909aLJNm8zpx/g8Lldpxd+Z
dVJCsDXe+9NRIpdnPFOsRmc/D45WFbBFDJUg6D+yFaYWVBAYTrxOs0AbAsXWziNX
xs5TIhxGUaDzaFT+AgBS/9lLyVASpsyZSDJxEOT/vyGAWMcBhRiLojruIP7R7o/0
TYIAxblUVFFRQ0bntIb6NlbOJ3wrk6chvq/FBf2ldDvVAQ87vZEUfz9jnYin4Ps7
X6Ct5+WoaYirh3AWmF48kctz/cydHMi8/4viJYsoJz8agRmiXw8=
=4iYp
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
