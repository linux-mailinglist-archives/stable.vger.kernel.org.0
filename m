Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7880432EAD1
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhCEMk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:40:28 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58214 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbhCEMkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 07:40:13 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5BF321C0B8A; Fri,  5 Mar 2021 13:40:11 +0100 (CET)
Date:   Fri, 5 Mar 2021 13:40:10 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 23/56] fs: make unlazy_walk() error handling
 consistent
Message-ID: <20210305124010.GA20055@amd>
References: <20210224125212.482485-1-sashal@kernel.org>
 <20210224125212.482485-23-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20210224125212.482485-23-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2021-02-24 07:51:39, Sasha Levin wrote:
> From: Jens Axboe <axboe@kernel.dk>
>=20
> [ Upstream commit e36cffed20a324e116f329a94061ae30dd26fb51 ]
>=20
> Most callers check for non-zero return, and assume it's -ECHILD (which
> it always will be). One caller uses the actual error return. Clean this
> up and make it fully consistent, by having unlazy_walk() return a bool
> instead. Rename it to try_to_unlazy() and return true on success, and
> failure on error. That's easier to read.
>=20
> No functional changes in this patch.
=20
Easier to read, but not fixing bug. I don't believe this is suitable
for stable.

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBCJqoACgkQMOfwapXb+vIg0ACgr4NcGrVVUSNQxWP+N8S8CIek
l4oAn3eibpP7tkD0XuRue51PBT9jMWtZ
=smpG
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
