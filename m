Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FF7481B7A
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 11:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbhL3Kwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 05:52:42 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50866 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbhL3Kwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 05:52:42 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 903B31C0B77; Thu, 30 Dec 2021 11:52:40 +0100 (CET)
Date:   Thu, 30 Dec 2021 11:52:39 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        masami256@gmail.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenqing Liu <wenqingliu0120@gmail.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 4.19 30/38] f2fs: fix to do sanity check on last xattr
 entry in __f2fs_setxattr()
Message-ID: <20211230105239.GA9706@amd>
References: <20211227151319.379265346@linuxfoundation.org>
 <20211227151320.383972525@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20211227151320.383972525@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Chao Yu <chao@kernel.org>
>=20
> commit 5598b24efaf4892741c798b425d543e4bed357a1 upstream.

Not sure what went wrong here, but as far as I can tell, this patch is
_not_ yet in upstream.

git log:

commit eec4df26e24e978e49ccf9bcf49ca0f2ccdaeffe
Merge: e7c124bd0463 4eb1782eaa9f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Dec 29 10:07:20 2021 -0800

pavel@amd:/data/l/clean-cg$ git show
5598b24efaf4892741c798b425d543e4bed357a1
fatal: bad object 5598b24efaf4892741c798b425d543e4bed357a1

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHNj3cACgkQMOfwapXb+vJgigCgroPlVTPl3xuJJScI8Ou0cprS
sJcAniWvbYrgRwS5tSJXQHcTPVcLcKpR
=igZQ
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
