Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14A03816D1
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 10:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhEOITa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 04:19:30 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48826 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhEOIT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 04:19:29 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CE7D91C0B80; Sat, 15 May 2021 10:18:15 +0200 (CEST)
Date:   Sat, 15 May 2021 10:18:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 160/530] arm64: dts: qcom: db845c: fix correct
 powerdown pin for WSA881x
Message-ID: <20210515081814.GA30461@amd>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144825.099918971@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20210512144825.099918971@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>=20
> [ Upstream commit c561740e7cfefaf3003a256f3a0cd9f8a069137c ]
>=20
> WSA881x powerdown pin is connected to GPIO1 not gpio2, so correct this.
> This was working so far due to a shift bug in gpio driver, however
> once that is fixed this will stop working, so fix this!

I don't see the correspoing update to the driver this talks about.

Do we have corresponding driver in 5.10 and was it fixed to match?

Best regards,
									Pavel

> +++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
> @@ -1015,7 +1015,7 @@
>  		left_spkr: wsa8810-left{
>  			compatible =3D "sdw10217201000";
>  			reg =3D <0 1>;
> -			powerdown-gpios =3D <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
> +			powerdown-gpios =3D <&wcdgpio 1 GPIO_ACTIVE_HIGH>;
>  			#thermal-sensor-cells =3D <0>;
>  			sound-name-prefix =3D "SpkrLeft";
>  			#sound-dai-cells =3D <0>;
> @@ -1023,7 +1023,7 @@
> =20
>  		right_spkr: wsa8810-right{
>  			compatible =3D "sdw10217201000";
> -			powerdown-gpios =3D <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
> +			powerdown-gpios =3D <&wcdgpio 1 GPIO_ACTIVE_HIGH>;
>  			reg =3D <0 2>;
>  			#thermal-sensor-cells =3D <0>;
>  			sound-name-prefix =3D "SpkrRight";

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCfg8UACgkQMOfwapXb+vIGwgCgm9f/g6T3H85/g632FUrtEbnm
eAsAn1XiGbgb5xaqmtahS2z/rLbWCRBy
=2Xlc
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
