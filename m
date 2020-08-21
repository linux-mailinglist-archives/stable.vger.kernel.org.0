Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1368A24CF89
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 09:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgHUHjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 03:39:46 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51398 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgHUHje (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 03:39:34 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 488F71C0BE9; Fri, 21 Aug 2020 09:39:31 +0200 (CEST)
Date:   Fri, 21 Aug 2020 09:39:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/92] 4.19.141-rc1 review
Message-ID: <20200821073930.GE23823@amd>
References: <20200820091537.490965042@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="phCU5ROyZO6kBE05"
Content-Disposition: inline
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--phCU5ROyZO6kBE05
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-08-20 11:20:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.141 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.

Here are test results:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
80031554

de0-nano failure is because we do not have any available targets, so
-cip testing did not find any problems.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--phCU5ROyZO6kBE05
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8/ejIACgkQMOfwapXb+vI10QCgq+i7KzCd4SsViovoPK4fTSN5
2DMAnRedsG20wstbtD3m+FuEDcC3ZM6i
=Q+Ba
-----END PGP SIGNATURE-----

--phCU5ROyZO6kBE05--
