Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FCF32AEF6
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbhCCALX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:11:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380020AbhCBK0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 05:26:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A196146D;
        Tue,  2 Mar 2021 10:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614680731;
        bh=cR6X9Cd0vMnwZ4g6Jmo3xLT7af9FGbl6INHhlNwt6dk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XkvLV407+ViojfzJLEntMc9A3UZEEcPyH4RqWluwsWYBas28hmSrMPWa8k4wvCY5u
         iTQTR/f4BaxrK7kKQ47G49zw2a0kOWuAuPcUXnyA/NvOYrvnc/nfFRoczza4jJLxDD
         fR6Ta5NthN9hqgLD4/5d5ou6SZzjPgE3GYdgc7KsiIMKpmlVRz2rf0o0XMNOD/+o5n
         XdGs+ZQrT8CwYX8lsDyXGjlkfMDgCwcGRkW1z2hlt19mBo5BrM2vP5JurM4AJhcITB
         i6iXisiqXb/rstGrTG1acf1Kz30pZsBexLiPBJ9ZpH5KDaHppYG62UHRTrXcl35Xk4
         I8JbFHQd/jcCQ==
Date:   Tue, 2 Mar 2021 15:55:27 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Linux Phy <linux-phy@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: Commits for 5.11 stable
Message-ID: <YD4SlyXIVFZQYip5@vkoul-mobl>
References: <YD4LfQEXWawk2b4C@vkoul-mobl>
 <YD4NINW6u28SxedJ@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k4PKXNVeIlpj/zIy"
Content-Disposition: inline
In-Reply-To: <YD4NINW6u28SxedJ@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k4PKXNVeIlpj/zIy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


HI Greg,

On 02-03-21, 11:02, Greg KH wrote:
> On Tue, Mar 02, 2021 at 03:25:09PM +0530, Vinod Koul wrote:
> > Hi Greg,
> >=20
> > Please include these commits for 5.11 stable series
> >=20
> > 9a8b9434c60f phy: mediatek: Add missing MODULE_DEVICE_TABLE()
> > 25e3ee590f62 phy: phy-brcm-sata: remove unneeded semicolon
> > 6b46e60a6943 phy: USB_LGM_PHY should depend on X86
> > 36acd5e24e30 phy: lantiq: rcu-usb2: wait after clock enable
> > c188365402f6 phy: rockchip: emmc, add vendor prefix to dts properties
> > 88d9f40c4b71 devicetree: phy: rockchip-emmc optional add vendor prefix
> > aaf316de3bba phy: cpcap-usb: remove unneeded conversion to bool
> > 39961bd6b70e phy: rockchip-emmc: emmc_phy_init() always return 0
>=20
> Why take these?
>=20
> What problems do they solve?

Sorry I should have provided the context. I had sent these as fixes for
5.11 but that was bit late so we merged it for 5.12 [1]

> How does 25e3ee590f62 meet the stable tree rules?
>=20
> > Please note that below commit is applicable for 5.7+
> > 36acd5e24e30 phy: lantiq: rcu-usb2: wait after clock enable
>=20
> So for 5.10 also?

yes, the patch has been tagged stable 5.7+

Thanks

[1]: https://lore.kernel.org/lkml/20210210091249.GC2774@vkoul-mobl.Dlink/

--=20
~Vinod

--k4PKXNVeIlpj/zIy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+vs47OPLdNbVcHzyfBQHDyUjg0cFAmA+EpcACgkQfBQHDyUj
g0ciPA/9GpPqLhQY/ogvYp+A9aDSLvc5NwLvbHsx8+y8Hv4OHjbdB0TRLQVeusuN
N+nr0qxQyl4eEFR9mlUW5MAvF4yMA7Y8dBR4e/b1728BPzaCWP93myye9EJBOg5f
U3B9K+ifp3ZO1yrz9CXAX/Tl7ML7a0xzVq1nyfN5EV9DO7b0znwJr13G4rK60G5P
OLJfxvU6xys0PBSNaVTr9lSrAcQ52nIzYmq2rswEgvQtL9MrqQ4ixDzYp7N9UFTp
/UgpPZh5o9LJBeJCeFCjkZaPhwJHsTfmjGsKu1BAhn8Vpel4ELD6UD5F7UJe2Hfb
wp9g8u4V+jyNRfttqk0zS7kcv2Kk6hCHBPcYUhCRAvpKNdi8glpLPGwFAdPUx/BI
v9pBdxiVE4hPO02dvROUqWhuLYrDG7/SGpP0aoJ18X68wO+jfM1I0kyzz21qVIkY
4aAgicoF7fDLas0wJFPRPOW59CHFljj9UWhFNK4n87A8iddVs73nhHkoq5zF5lyp
XgDLaESpRJ5fU1s8wixVov1Id8dtFAFiYXbDFKf8wfDktwOk9ndvWzUTPkDNnYq5
MDvLNhEQTSXvYQT3CR6iiL71NKUgcnEEbkYb/U42QW5DvTbS+0ZiiOjvBT5s205t
BUxSMK0vNb213AZg5kQJ37dpJBcDQWImJlJywuP2Kv7+JF1t4jE=
=e4B/
-----END PGP SIGNATURE-----

--k4PKXNVeIlpj/zIy--
