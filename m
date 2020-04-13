Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECB31A67CE
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgDMOUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730562AbgDMOUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 10:20:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DDAB20776;
        Mon, 13 Apr 2020 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787650;
        bh=0GTTfBu8ZjkhcZ769Pn8X8xeVcLYCA+0fn72VkovjdY=;
        h=Date:From:To:Cc:Subject:From;
        b=LbaHGYMhWqWo8z9u/8VfPplHv/BC1PtsLP30gCIr75XSECdLqrxUMth8aIVMTq8gk
         txM3qw5eQGacOeG1hTq48MZJ7pQ2sKw/T2J3yTxwm7kGE+Lz+Xxw5AK5dfYYIEeHHy
         lvJ3C2VN+UDWkPbLyphVV0R0HrnvoX8coptq/5ZY=
Date:   Mon, 13 Apr 2020 16:20:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.115
Message-ID: <20200413142048.GA3547745@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.19.115 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Alexander Usyskin (1):
      mei: me: add cedar fork device ids

Amritha Nambiar (1):
      net: Fix Tx hash bound checking

Arun KS (1):
      arm64: Fix size of __early_cpu_boot_status

Avihai Horon (1):
      RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Chris Lew (1):
      rpmsg: glink: Remove chunk size word align warning

Daniel Jordan (1):
      padata: always acquire cpu_hotplug_lock before pinst->lock

David Ahern (1):
      tools/accounting/getdelays.c: fix netlink attribute length

David Howells (1):
      rxrpc: Fix sendmsg(MSG_WAITALL) handling

Eugene Syromiatnikov (1):
      coresight: do not use the BIT() macro in the UAPI header

Eugeniy Paltsev (1):
      initramfs: restore default compression behavior

Florian Fainelli (2):
      net: dsa: bcm_sf2: Do not register slave MDIO bus with OF
      net: dsa: bcm_sf2: Ensure correct sub-node is parsed

Geoffrey Allott (1):
      ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on EVGA X99 Classified motherboard

Gerd Hoffmann (1):
      drm/bochs: downgrade pci_request_region failure from error to warning

Greg Kroah-Hartman (1):
      Linux 4.19.115

Hans Verkuil (1):
      drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_read()

Hans de Goede (2):
      extcon: axp288: Add wakeup support
      power: supply: axp288_charger: Add special handling for HP Pavilion x2 10

Ilya Dryomov (1):
      ceph: canonicalize server path in place

James Zhu (1):
      drm/amdgpu: fix typo for vcn1 idle check

Jarod Wilson (1):
      ipv6: don't auto-add link-local address to lag ports

Jason A. Donenfeld (1):
      random: always use batched entropy for get_random_u{32,64}

Jason Gunthorpe (2):
      RDMA/ucma: Put a lock around every call to the rdma_cm layer
      RDMA/cma: Teach lockdep about the order of rtnl and lock

Jisheng Zhang (1):
      net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Kaike Wan (2):
      IB/hfi1: Call kobject_put() when kobject_init_and_add() fails
      IB/hfi1: Fix memory leaks in sysfs registration and unregistration

Kishon Vijay Abraham I (2):
      misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices
      misc: pci_endpoint_test: Avoid using module parameter to determine irqtype

Len Brown (2):
      tools/power turbostat: Fix gcc build warnings
      tools/power turbostat: Fix missing SYS_LPI counter on some Chromebooks

Lucas Stach (1):
      drm/etnaviv: replace MMU flush marker with flush sequence

Marcelo Ricardo Leitner (1):
      sctp: fix possibly using a bad saddr with a given dst

Mario Kleiner (1):
      drm/amd/display: Add link_rate quirk for Apple 15" MBP 2017

Martin Kaiser (1):
      hwrng: imx-rngc - fix an error path

Miklos Szeredi (1):
      bitops: protect variables in set_mask_bits() macro

Oleksij Rempel (1):
      net: phy: micrel: kszphy_resume(): add delay after genphy_resume() before accessing PHY registers

Paul Cercueil (1):
      ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

Petr Machata (1):
      mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

Prabhath Sajeepa (1):
      nvme-rdma: Avoid double freeing of async event data

Qian Cai (1):
      ipv4: fix a RCU-list lock in fib_triestat_seq_show

Qiujun Huang (3):
      sctp: fix refcount bug in sctp_wfree
      Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl
      fbcon: fix null-ptr-deref in fbcon_switch

Randy Dunlap (1):
      mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Richard Palethorpe (1):
      slcan: Don't transmit uninitialized stack data in padding

Rob Clark (2):
      drm/msm: stop abusing dma_map/unmap for cache
      drm/msm: Use the correct dma_sync calls in msm_gem

Roger Quadros (1):
      usb: dwc3: don't set gadget->is_otg flag

Sam Protsenko (1):
      include/linux/notifier.h: SRCU: fix ctags

Sean Young (1):
      media: rc: IR signal for Panasonic air conditioner too long

Taniya Das (1):
      clk: qcom: rcg: Return failure for RCG update

Thinh Nguyen (1):
      usb: dwc3: gadget: Wrap around when skip TRBs

William Dauchy (1):
      net, ip_tunnel: fix interface lookup with no key

Xiubo Li (1):
      ceph: remove the extra slashes in the server path

YueHaibing (1):
      misc: rtsx: set correct pcr_ops for rts522A


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6UdT8ACgkQONu9yGCS
aT4V0Q/9H+akpi5lqAfNtOIGEdQ+Sp3o2bPacDBWmm9rMMGL5NYfPjEoppqazeBI
CsIhNkCJYk+wPrvvE2KjG9jZ+KS+jNd8rz5WK0M4OI9FvtZQXEVIoJQ8IIfe3BDO
xmsPyLUpdT+EINcZgmt9HuAy/nGWb/9OZFm1zUMKVFBTH4rsdVV4L/7BD9yc445H
9Tkhb47m0jwmuPkgntymMDdedkHWevZtsmRCjLsLGkRlJhNtFdaSk7zWpgEIiVfh
g1h7OYbmuxxYJOnIr2248TNyONEd9Uv/Nc6o/s7kcEodw+4t83gscTtrNYLwMxh2
Azu4V6BzKk2kBg4xv8lCeLLMV5tTAV6DDzOCXNjbWA7TDAnrSl9aBEHCmRoB3PxO
pQNo8n2eArjmbkMVCWoJR+n5a+2d4mA6ErOfV8i1gPHoZjrHub0PQLUY/hDeXD0U
YTlpVZe3jNktpty4T8OKWOI0vFOAsLt44PiKIoRL6XsD5E70VCpKmbQjgGnG3423
v2MC9mOoajpqopQG9Pbh8vWGYO5lRAWU4Bxlae4qIlfoGsYi1iopfVJg2ST9qF+1
+8RqMRCFAfB5XLxnEkGNR8yKVVot7HR6Q2LDxB97PA/RPo0bFzDJoL/G+fSrToZa
emyLaJuzqtnmuOUZkbJCmDh+6Dg+dqPPHe/LLjPcqla9yJkCOJg=
=hd2B
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
