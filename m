Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C970102D6C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 21:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfKSUTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 15:19:48 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50728 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfKSUTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 15:19:48 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3D40A1C1984; Tue, 19 Nov 2019 21:19:46 +0100 (CET)
Date:   Tue, 19 Nov 2019 21:19:45 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 182/422] ARM: imx6: register pm_power_off handler if
 "fsl,pmic-stby-poweroff" is set
Message-ID: <20191119201945.GA4495@amd>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051410.265926410@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20191119051410.265926410@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Oleksij Rempel <o.rempel@pengutronix.de>
>=20
> [ Upstream commit 8148d2136002da2e2887caf6a07bbd9c033f14f3 ]
>=20
> One of the Freescale recommended sequences for power off with external
> PMIC is the following:
> ...
> 3.  SoC is programming PMIC for power off when standby is asserted.
> 4.  In CCM STOP mode, Standby is asserted, PMIC gates SoC supplies.
>=20
> See:
> http://www.nxp.com/assets/documents/data/en/reference-manuals/IMX6DQRM.pdf
> page 5083
>=20
> This patch implements step 4. of this sequence.


> +	if (of_property_read_bool(np, "fsl,pmic-stby-poweroff"))
> +		imx6_pm_stby_poweroff_probe();
>  }

This is only active when fsl,pmic-stby-poweroff is present somewhere
in the tree, and that is not the case for 4.19-stable AFAICT. Is it
still good idea to have it stable branch?

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3UTmEACgkQMOfwapXb+vJ0hACfVyx4kkZSWTMN9WsDOCImBKP7
45IAnirmpyk+OFm8ehXefqz9nCRfcfmI
=hYAp
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
