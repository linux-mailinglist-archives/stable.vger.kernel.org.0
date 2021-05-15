Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5FF3816E8
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 10:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhEOIYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 04:24:37 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49198 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhEOIYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 04:24:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A47751C0B81; Sat, 15 May 2021 10:23:06 +0200 (CEST)
Date:   Sat, 15 May 2021 10:23:06 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 258/530] security: keys: trusted: fix TPM2
 authorizations
Message-ID: <20210515082305.GC30461@amd>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144828.313826968@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <20210512144828.313826968@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Clean up unreachable code.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trus=
ted-keys/trusted_tpm1.c
index 230c0b27b77d..5bae4ed73c4d 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -813,11 +813,7 @@ static int getoptions(char *c, struct trusted_key_payl=
oad *pay,
 				       opt->blobauth_len);
 				break;
 			}
-
 			return -EINVAL;
-
-			break;
-
 		case Opt_migratable:
 			if (*args[0].from =3D=3D '0')
 				pay->migratable =3D 0;


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCfhOkACgkQMOfwapXb+vJjFACdGCT8GoBVao8ldJrr5D0/HBS0
zToAoKEFvjC/Ih2OU8j9sz5OCtrF9KXK
=gmlC
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--
