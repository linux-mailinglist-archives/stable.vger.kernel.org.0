Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B73201893
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405326AbgFSQtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387986AbgFSOjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:39:09 -0400
Received: from earth.universe (dyndsl-037-138-190-043.ewe-ip-backbone.de [37.138.190.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 673B320DD4;
        Fri, 19 Jun 2020 14:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577548;
        bh=GhmndpCx0NtSvR5PEsSvK9su8y7F9B9W/85J59fhrTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b6Q4n+E5Dk+L+BUYxW++OziNU6+ncxzIZSDlPwNkoW0CxkAggKh8nfcXgFXLzxuDx
         EJ/7nNdgDgcw81Mjo+PHn4VfVxOsxOopZmTnRo56r2nc44BOoraHqojrIopiFOUiUt
         vAjcvxaaljitJIN4Mfu9h37y+E93LduiyX1ThH3Q=
Received: by earth.universe (Postfix, from userid 1000)
        id C348B3C08CD; Fri, 19 Jun 2020 16:39:06 +0200 (CEST)
Date:   Fri, 19 Jun 2020 16:39:06 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: power: supply: bq25890: Document
 required interrupt
Message-ID: <20200619143906.33twapu6mgyay4yr@earth.universe>
References: <20200617102305.14241-1-krzk@kernel.org>
 <20200617102305.14241-2-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gyqjsa47ulgkpkl2"
Content-Disposition: inline
In-Reply-To: <20200617102305.14241-2-krzk@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gyqjsa47ulgkpkl2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 17, 2020 at 12:23:05PM +0200, Krzysztof Kozlowski wrote:
> The driver requires interrupts (fails probe if it is not provided) so
> document this requirement in bindings.
>=20
> Fixes: 4aeae9cb0dad ("power_supply: Add support for TI BQ25890 charger ch=
ip")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---

Thanks, queued.

-- Sebastian

>  Documentation/devicetree/bindings/power/supply/bq25890.txt | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/power/supply/bq25890.txt b=
/Documentation/devicetree/bindings/power/supply/bq25890.txt
> index 51ecc756521f..3b4c69a7fa70 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq25890.txt
> +++ b/Documentation/devicetree/bindings/power/supply/bq25890.txt
> @@ -10,6 +10,7 @@ Required properties:
>      * "ti,bq25895"
>      * "ti,bq25896"
>  - reg: integer, i2c address of the device.
> +- interrupts: interrupt line;
>  - ti,battery-regulation-voltage: integer, maximum charging voltage (in u=
V);
>  - ti,charge-current: integer, maximum charging current (in uA);
>  - ti,termination-current: integer, charge will be terminated when curren=
t in
> @@ -39,6 +40,9 @@ bq25890 {
>  	compatible =3D "ti,bq25890";
>  	reg =3D <0x6a>;
> =20
> +	interrupt-parent =3D <&gpio1>;
> +	interrupts =3D <16 IRQ_TYPE_EDGE_FALLING>;
> +
>  	ti,battery-regulation-voltage =3D <4200000>;
>  	ti,charge-current =3D <1000000>;
>  	ti,termination-current =3D <50000>;
> --=20
> 2.17.1
>=20

--gyqjsa47ulgkpkl2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl7szgoACgkQ2O7X88g7
+pobjw/8Cpw1OzyHiGjyxlvzVKNvp4LndLYSD4J8cdqGPeSNEAHae4sCqmae3G89
ZCd2Zohd2LwXXire9sQtIXJb96o+1ocWQIzR3wMIypCO8dy83IZqqy+SfZW4ivGW
K2KmQChB/8os3O74Jw9DSPc4UfK0ISy+7HR4Ot8kyfhg1Dvm9z4NVnId2dHohXoL
EOn4KYAvjSrevUfXSRwIadCxLxLW7dA1IV1+AS13p0XHdjq4OGQ5dsxNoqYd/X1Q
MyF3f01Dfic0PDQE3StBTYKW8sYaXI73IftAxZ3gPTcPjS7AzFj+3wpXVEKjfxqR
e7G40IJYwKtXiyIBg0aQhXOvC3/32LQV4c7suPNmNez4tSn6BkrnFvBOPiVeNZRq
PLrFNdtatoX3otvbuJEoULD7jLIgSg3Oi8Fkbxu3zmpeCO8yNDPGTmZdhHyxfk7s
xxUTNlOr7f5rbxYGVe2q0Vz7o5H6s5ukgjSsiqCSMZrNkJd2DYfnvPsSL6Ymd+jP
SCdfiauLIwrXOzoX/lJXHj/fGzmJGUnU7ogW7OWqclWIGoTxAjIuen+lEWXNIjOH
L/sAxLp/Sp1gS4rTRFJSite5x8A6h4QGxmsCN1mxuiKgeu9Lyrw4JmKEo40hYa8S
Ayr385VFbX//luhm435eFe27tMPikUC1GdQwu/tFJk+mkoq5XVs=
=XIWY
-----END PGP SIGNATURE-----

--gyqjsa47ulgkpkl2--
