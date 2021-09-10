Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00AF4067F3
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 09:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhIJHqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 03:46:48 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:42610 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbhIJHqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 03:46:48 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2EC0A1C0B76; Fri, 10 Sep 2021 09:45:36 +0200 (CEST)
Date:   Fri, 10 Sep 2021 09:45:36 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: Re: [PATCH AUTOSEL 4.4 24/35] ACPICA: iASL: Fix for WPBT table with
 no command-line arguments
Message-ID: <20210910074535.GA454@amd>
References: <20210909120116.150912-1-sashal@kernel.org>
 <20210909120116.150912-24-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20210909120116.150912-24-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Handle the case where the Command-line Arguments table field
> does not exist.
>=20
> ACPICA commit d6487164497fda170a1b1453c5d58f2be7c873d6

I'm not sure what is going on here, but adding unused definition will
not make any difference for 4.4 users, so we don't need this in
-stable...?

Best regards,
								Pavel

> +++ b/include/acpi/actbl3.h
> @@ -738,6 +738,10 @@ struct acpi_table_wpbt {
>  	u16 arguments_length;
>  };
> =20
> +struct acpi_wpbt_unicode {
> +	u16 *unicode_string;
> +};
> +
>  /***********************************************************************=
********
>   *
>   * XENV - Xen Environment Table (ACPI 6.0)

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmE7DR8ACgkQMOfwapXb+vLqlQCfR6jkW6ewcpQLuqX3A5YfZExW
ASwAnjx+EjRw46urNMfB2LxUZY1RhH0c
=/vN1
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
