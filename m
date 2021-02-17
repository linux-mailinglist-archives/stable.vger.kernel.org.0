Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BE831D6CD
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 10:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhBQJJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 04:09:41 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45650 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbhBQJJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 04:09:40 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B9BC61C0BA3; Wed, 17 Feb 2021 10:08:57 +0100 (CET)
Date:   Wed, 17 Feb 2021 10:08:54 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 022/104] kbuild: simplify GCC_PLUGINS enablement in
 dummy-tools/gcc
Message-ID: <20210217090854.GA7693@amd>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152720.193592547@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20210215152720.193592547@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Masahiro Yamada <masahiroy@kernel.org>
>=20
> [ Upstream commit f4c3b83b75b91c5059726cb91e3165cc01764ce7 ]
>=20
> With commit 1e860048c53e ("gcc-plugins: simplify GCC plugin-dev
> capability test") applied, this hunk can be way simplified because
> now scripts/gcc-plugins/Kconfig only checks plugin-version.h

AFAICT referenced commit 1e860048c53e ("gcc-plugins: simplify GCC
plugin-dev capability test") is not present in 5.10-stable branch, so
I believe this should not be applied, either.

Best regards,
								Pavel
							=09
> +++ b/scripts/dummy-tools/gcc
> @@ -75,16 +75,12 @@ if arg_contain -S "$@"; then
>  	fi
>  fi
> =20
> -# For scripts/gcc-plugin.sh
> +# To set GCC_PLUGINS
>  if arg_contain -print-file-name=3Dplugin "$@"; then
>  	plugin_dir=3D$(mktemp -d)
> =20
> -	sed -n 's/.*#include "\(.*\)"/\1/p' $(dirname $0)/../gcc-plugins/gcc-co=
mmon.h |
> -	while read header
> -	do
> -		mkdir -p $plugin_dir/include/$(dirname $header)
> -		touch $plugin_dir/include/$header
> -	done
> +	mkdir -p $plugin_dir/include
> +	touch $plugin_dir/include/plugin-version.h
> =20
>  	echo $plugin_dir
>  	exit 0

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAs3SUACgkQMOfwapXb+vKSpACfYY4bl1SC7VVzI3PuPxkKxAxx
2FcAn3h9w9eXu7sX5UBeVS0NfQsJTMw0
=Ue8t
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
