Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E121DB24B
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 13:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgETLwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 07:52:00 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36548 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETLwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 07:52:00 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id EE6A32A2C09
Received: by earth.universe (Postfix, from userid 1000)
        id 7DFD33C08C6; Wed, 20 May 2020 13:51:55 +0200 (CEST)
Date:   Wed, 20 May 2020 13:51:55 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Robert Beckett <bob.beckett@collabora.com>, stable@vger.kernel.org
Subject: Re: [PATCHv1] ARM: dts/imx6q-bx50v3: Set display interface clock
 parents
Message-ID: <20200520115155.5vezit2f6tnxxq3l@earth.universe>
References: <20200514170236.24814-1-sebastian.reichel@collabora.com>
 <20200519114915.DA36520709@mail.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3qtduk3zpdcb47ls"
Content-Disposition: inline
In-Reply-To: <20200519114915.DA36520709@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3qtduk3zpdcb47ls
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 19, 2020 at 11:49:15AM +0000, Sasha Levin wrote:
> [This is an automated email]
>=20
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>=20
> The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.1=
4.180, v4.9.223, v4.4.223.
>=20
> v5.6.13: Build OK!
> v5.4.41: Build OK!
> v4.19.123: Build OK!
>
> v4.14.180: Failed to apply! Possible dependencies:
>     e26dead44268 ("ARM: dts: imx6q-bx50v3: Add internal switch")
>=20
> v4.9.223: Failed to apply! Possible dependencies:
>     1d0c7bb20c08 ("ARM: dts: imx: Correct B850v3 clock assignment")
>     e26dead44268 ("ARM: dts: imx6q-bx50v3: Add internal switch")
>=20
> v4.4.223: Failed to apply! Possible dependencies:
>     15ef03b86247 ("ARM: dts: imx: b450/b650v3: Move ldb_di clk assignment=
")
>     1d0c7bb20c08 ("ARM: dts: imx: Correct B850v3 clock assignment")
>     2252792b4677 ("ARM: dts: imx: Add support for Advantech/GE B850v3")
>     226d16c80c61 ("ARM: dts: imx: Add support for Advantech/GE Bx50v3")
>     547da6bbcf08 ("ARM: dts: imx: Add support for Advantech/GE B450v3")
>     987e71877ae6 ("ARM: dts: imx: Add support for Advantech/GE B650v3")
>     b492b8744da9 ("ARM: dts: imx6q-b850v3: Update display clock source")
>     e26dead44268 ("ARM: dts: imx6q-bx50v3: Add internal switch")
>=20
>=20
> NOTE: The patch will not be queued to stable trees until it is upstream.
>=20
> How should we proceed with this patch?

Applying it to v4.4 does not make sense (impacted devices are not
supported on that version) and it should be fine to ignore it for
v4.9 and v4.14. The impact is broken dual display setup. I tested
the patch on 4.19 stable tree and I think it makes sense to apply
it to 4.19 and newer.

-- Sebastian

--3qtduk3zpdcb47ls
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl7FGdIACgkQ2O7X88g7
+poWuRAAhcNg9OB9fWhZOxkLfvk+OgUbxsGYAt2blVqZEcVUxRhsoqXiQlh3bGOi
21sRNV13puW05z9IxJrOOJcgVk2qII19//8aFAo5feuumBRhJnC1BOBkdxGZ43K+
bNskcb2CxKEwMeaIJAI0pvWthb5ioJOi5Qie0GeWPNRRFAAatgjXRsCaIaGX3b9v
LGY6Z4ojSCo0qoHsChDBMPMqZQIJH6zvbICK4Cp6W1VC0HB9cYZ8bYEfHFN2flwi
3zwcmnEGsue5AF01VOapQ8ojw2C5SKcYpeJR3OKiwdElB2sypDe3aqcSVnrxm1Xd
oCVou0eYK8mn5ZUisGJRVBZYhYssOkJxt7ZNzSa+pz+ZwKe8tCe6OHLyL/Jkq5+y
hSYP30JSQ4zxxOwbj1AH0lqh8pA2xuXg1/VAfuXHBe9HymiqlS3T5eMo1njc57GQ
jJ9JUqiu0Kj31va9k36bgg4pdO6gvrTXm/qVv6BGJr2XX0u11L9oyELPKLtuGK8o
YcW6vacHlg4yEh0yf/L+DipwnFeKmNeG+EcZq+Myq1+LclXbKQ7AeZm0TPrBtCWI
CgZaCCPk9qJ2C0ZGN2BGZxFNejsReoeAOuvt30hGen5t21i4b1G3pudXHoZleGes
iRBva8IHyuNfQvpXFJeLF1TW3Xv/M2VEiwJkTehJnajVOFcsJSg=
=CtEu
-----END PGP SIGNATURE-----

--3qtduk3zpdcb47ls--
