Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9FD45318D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 12:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhKPMAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 07:00:01 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56786 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhKPMAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 07:00:00 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9176C1C0B76; Tue, 16 Nov 2021 12:57:02 +0100 (CET)
Date:   Tue, 16 Nov 2021 12:57:01 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 182/575] fscrypt: allow 256-bit master keys with
 AES-256-XTS
Message-ID: <20211116115701.GA24252@amd>
References: <20211115165343.579890274@linuxfoundation.org>
 <20211115165349.993529752@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20211115165349.993529752@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Eric Biggers <ebiggers@google.com>
>=20
> [ Upstream commit 7f595d6a6cdc336834552069a2e0a4f6d4756ddf ]
>=20
> fscrypt currently requires a 512-bit master key when AES-256-XTS is
> used, since AES-256-XTS keys are 512-bit and fscrypt requires that the
> master key be at least as long any key that will be derived from it.

Quoting Eric Biggers <ebiggers@kernel.org>

I don't expect any problem with backporting this, but I don't see how
this
follows the stable kernel rules
(Documentation/process/stable-kernel-rules.rst).
I don't see what distinguishes this patch from ones that don't get
picked up by
AUTOSEL; it seems pretty arbitrary to me.

- Eric

And I agree, this should not be in stable.

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmGTnI0ACgkQMOfwapXb+vJalQCfSPdVD69rmCuKPbLhW6TugkEG
4GwAoLNAzaV4Z/fqbrn0hOXmG+fPu8sb
=MNHP
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
