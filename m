Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CAE3D413F
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 22:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhGWTXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 15:23:23 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38426 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 15:23:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4073F1C0B88; Fri, 23 Jul 2021 22:03:55 +0200 (CEST)
Date:   Fri, 23 Jul 2021 22:03:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 031/125] ARM: dts: am57xx-cl-som-am57x: fix
 ti,no-reset-on-init flag for gpios
Message-ID: <20210723200354.GA22684@duo.ucw.cz>
References: <20210722155624.672583740@linuxfoundation.org>
 <20210722155625.727125079@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20210722155625.727125079@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit b644c5e01c870056e13a096e14b9a92075c8f682 ]
>=20
> The ti,no-reset-on-init flag need to be at the interconnect target module
> level for the modules that have it defined.
> The ti-sysc driver handles this case, but produces warning, not a critical
> issue.

Ok... But there's status =3D "okay" removed in the patch below (and it
is removed for gpio3 but not for gpio2)... and there's no mention in
changelog. Is it okay or oversight?

Best regards,
								Pavel

> index 0d5fe2bfb683..39eba2bc36dd 100644
> --- a/arch/arm/boot/dts/am57xx-cl-som-am57x.dts
> +++ b/arch/arm/boot/dts/am57xx-cl-som-am57x.dts
> @@ -610,12 +610,11 @@
>  	>;
>  };
> =20
> -&gpio3 {
> -	status =3D "okay";
> +&gpio3_target {
>  	ti,no-reset-on-init;
>  };
> =20
> -&gpio2 {
> +&gpio2_target {
>  	status =3D "okay";
>  	ti,no-reset-on-init;
>  };

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYPsgqgAKCRAw5/Bqldv6
8irXAKC0qXRGAtlrtnWs7I/UjDA+mvrxFgCgjAhppLo+HeTn6wyT+tSTwJZMCYI=
=jtfx
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
