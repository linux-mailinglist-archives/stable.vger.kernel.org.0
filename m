Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA533816D3
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 10:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhEOIWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 04:22:42 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49044 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhEOIWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 04:22:41 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 516C51C0B80; Sat, 15 May 2021 10:21:28 +0200 (CEST)
Date:   Sat, 15 May 2021 10:21:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 258/530] security: keys: trusted: fix TPM2
 authorizations
Message-ID: <20210515082127.GB30461@amd>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144828.313826968@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <20210512144828.313826968@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit de66514d934d70ce73c302ce0644b54970fc7196 ]
>=20
> In TPM 1.2 an authorization was a 20 byte number.  The spec actually
> recommended you to hash variable length passwords and use the sha1
> hash as the authorization.  Because the spec doesn't require this
> hashing, the current authorization for trusted keys is a 40 digit hex
> number.  For TPM 2.0 the spec allows the passing in of variable length
> passwords and passphrases directly, so we should allow that in trusted
> keys for ease of use.  Update the 'blobauth' parameter to take this
> into account, so we can now use plain text passwords for the keys.

I guess break should now be deleted. If tools don't warn about this,
they should.

> +			if (tpm2 && opt->blobauth_len <=3D sizeof(opt->blobauth)) {
> +				memcpy(opt->blobauth, args[0].from,
> +				       opt->blobauth_len);
> +				break;
> +			}
> +
> +			return -EINVAL;
> +
>  			break;
> +

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCfhIcACgkQMOfwapXb+vKm2ACggno1RliLzNtetFUyIS8ckHrV
ehkAoMRtT8jnuTV6ppswHlCuIDqysQ7U
=l6dO
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
