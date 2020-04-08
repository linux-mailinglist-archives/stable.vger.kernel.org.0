Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9738B1A2448
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 16:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgDHOtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 10:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728367AbgDHOtG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 10:49:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FC1220787;
        Wed,  8 Apr 2020 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586357345;
        bh=RFUIVmLU6WkaBbi4/OYZYy2VaYSzNSj8fI4CZcmAFe0=;
        h=Date:From:To:Cc:Subject:From;
        b=rYmBeGoEyJbokXoYRUPMPxwodAEipiBeIjs53yga2yMxucVBhpvHSSYiVrDAMgyHo
         vcXh07zeXibj/MWfBsAEiYCzuGL9qhiBxN0FrB7qYB7kEoKWV0bcAFHdTT6CnJd+cS
         0v1jCqmy9K2n2brIwKPQ2wHBDN747AOO01f+1LEQ=
Date:   Wed, 8 Apr 2020 16:49:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.16
Message-ID: <20200408144902.GA1254259@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.16 kernel.

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

 Makefile                                                |    2=20
 drivers/extcon/extcon-axp288.c                          |   32 +++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c              |    4=20
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c                   |    2=20
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c        |   11 ++
 drivers/gpu/drm/bochs/bochs_hw.c                        |    6 -
 drivers/i2c/busses/i2c-i801.c                           |   45 ++-------
 drivers/infiniband/hw/hfi1/user_sdma.c                  |   25 ++++-
 drivers/md/dm.c                                         |    5 -
 drivers/misc/cardreader/rts5227.c                       |    1=20
 drivers/misc/mei/hw-me-regs.h                           |    2=20
 drivers/misc/mei/pci-me.c                               |    2=20
 drivers/misc/pci_endpoint_test.c                        |   14 ++-
 drivers/net/dsa/microchip/Kconfig                       |    1=20
 drivers/net/ethernet/cadence/macb_main.c                |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h |    4=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    2=20
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c             |   25 +----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h             |    6 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c          |    6 +
 drivers/nvme/host/rdma.c                                |    8 +
 drivers/nvmem/nvmem-sysfs.c                             |    6 +
 drivers/nvmem/sprd-efuse.c                              |    2=20
 drivers/pci/pci-sysfs.c                                 |    6 -
 drivers/power/supply/axp288_charger.c                   |   57 ++++++++++++
 drivers/soc/mediatek/mtk-cmdq-helper.c                  |    1=20
 drivers/staging/wfx/hif_tx.c                            |    1=20
 drivers/watchdog/iTCO_vendor.h                          |    2=20
 drivers/watchdog/iTCO_vendor_support.c                  |   16 +--
 drivers/watchdog/iTCO_wdt.c                             |   28 +++---
 include/uapi/linux/coresight-stm.h                      |    6 -
 kernel/padata.c                                         |    6 -
 lib/test_xarray.c                                       |   18 +++
 lib/xarray.c                                            |    3=20
 mm/mempolicy.c                                          |    6 +
 net/core/dev.c                                          |    2=20
 net/ipv4/fib_trie.c                                     |    3=20
 net/ipv4/ip_tunnel.c                                    |    6 -
 net/ipv4/tcp_input.c                                    |    6 +
 net/netlink/genetlink.c                                 |    5 -
 net/rxrpc/sendmsg.c                                     |    4=20
 net/sched/act_api.c                                     |    1=20
 net/sctp/ipv6.c                                         |   20 +++-
 net/sctp/protocol.c                                     |   28 ++++--
 net/sctp/socket.c                                       |   31 +++++-
 net/smc/af_smc.c                                        |   25 +++--
 net/smc/smc_core.c                                      |   12 ++
 net/smc/smc_core.h                                      |    2=20
 sound/pci/hda/patch_ca0132.c                            |    1=20
 tools/power/x86/turbostat/Makefile                      |    2=20
 tools/power/x86/turbostat/turbostat.c                   |   73 ++++++++++-=
-----
 usr/Kconfig                                             |   22 ++--
 52 files changed, 420 insertions(+), 187 deletions(-)

Alexander Usyskin (1):
      mei: me: add cedar fork device ids

Amritha Nambiar (1):
      net: Fix Tx hash bound checking

Bibby Hsieh (1):
      soc: mediatek: knows_txdone needs to be set in Mediatek CMDQ helper

Codrin Ciubotariu (2):
      net: dsa: ksz: Select KSZ protocol tag
      net: macb: Fix handling of fixed-link node

Daniel Jordan (2):
      padata: fix uninitialized return value in padata_replace()
      padata: always acquire cpu_hotplug_lock before pinst->lock

David Howells (1):
      rxrpc: Fix sendmsg(MSG_WAITALL) handling

Eugene Syromiatnikov (1):
      coresight: do not use the BIT() macro in the UAPI header

Eugeniy Paltsev (1):
      initramfs: restore default compression behavior

Evan Quan (1):
      drm/amdgpu: add fbdev suspend/resume on gpu reset

Freeman Liu (1):
      nvmem: sprd: Fix the block lock operation

Geoffrey Allott (1):
      ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on E=
VGA X99 Classified motherboard

Gerd Hoffmann (1):
      drm/bochs: downgrade pci_request_region failure from error to warning

Greg Kroah-Hartman (1):
      Linux 5.5.16

Guenter Roeck (1):
      brcmfmac: abort and release host after error

Hans de Goede (2):
      extcon: axp288: Add wakeup support
      power: supply: axp288_charger: Add special handling for HP Pavilion x=
2 10

James Zhu (1):
      drm/amdgpu: fix typo for vcn1 idle check

Jiri Pirko (1):
      sched: act: count in the size of action flags bitfield

J=E9r=F4me Pouiller (1):
      staging: wfx: fix warning about freeing in-use mutex during device un=
register

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

Marcelo Ricardo Leitner (1):
      sctp: fix possibly using a bad saddr with a given dst

Mario Kleiner (1):
      drm/amd/display: Add link_rate quirk for Apple 15" MBP 2017

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

Paolo Abeni (1):
      net: genetlink: return the error code when attribute parsing fails.

Prabhath Sajeepa (1):
      nvme-rdma: Avoid double freeing of async event data

Qian Cai (1):
      ipv4: fix a RCU-list lock in fib_triestat_seq_show

Qiujun Huang (1):
      sctp: fix refcount bug in sctp_wfree

Randy Dunlap (1):
      mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Tariq Toukan (1):
      net/mlx5e: kTLS, Fix wrong value in record tracker enum

Ursula Braun (1):
      net/smc: fix cleanup for linkgroup setup failures

William Dauchy (1):
      net, ip_tunnel: fix interface lookup with no key

YueHaibing (1):
      misc: rtsx: set correct pcr_ops for rts522A


--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6N5F4ACgkQONu9yGCS
aT57OxAAmQtR7GArNujPh6UGepycpFlmzstLA99W60KBO28bXAhG4wUXNQYd8tJU
FyAEhPqEzIzkH04w+oguLYdmbolvI1Sv4RPhuWPAaaW/GguKobk14b8vY5183a5C
3zf33Vf53boLrL4zwGxjWH0zMz0YOIh9dkK4Y+DXnqtUMXv9XlQeXwtdMPAR08KD
0iLM/0FQaNOuHdlaZvUXA9iYON2oP+s2LfqBBVQrVBS9RbUUIC5++Jbn22Y2Nsaz
aJXr+gA6bfrtUUePewF3NDFrbOCVXHA7BUdEXc9ZZELtKrwrsHIhxhis4zVz1Od0
EfnlzH0VQ3vNx12gLj60GVc0jwW0h1frofOPfSBodfP7n7Gze9QN7u3bv8uI1jg1
QXLoU27nCCVtLPki6iAhFDkrFXotqBJQo8/7VsP0oktuxdvYtWQ6HEXHXvwgp4py
PbnsjKxcS8/tediWVVI9DrTeWbgNxpHePDeI6OFKEuTEIX3Md09Hc1Z4/toLh48o
AcoDLs6BWfNIlmIuxMEPetVom51epcwMtoI5ekKdO54zEA09n7gx207M1IFHjfOd
7QUVIUwWw+Mj/VTWeW5RIdoRSFS/OoOlna4WbpN/4s/H+YNdZoIliIyWKEgIgiNv
U3a0OTkcxSk8uPHAq28MQ4pZR1b9zHt7TlXZt0IlKre29Na0ldk=
=ZT1e
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
