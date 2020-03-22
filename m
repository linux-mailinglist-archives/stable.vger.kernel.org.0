Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1275318EC04
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 20:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCVTvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 15:51:37 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36356 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgCVTvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Mar 2020 15:51:37 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1D0771C033C; Sun, 22 Mar 2020 20:51:35 +0100 (CET)
Date:   Sun, 22 Mar 2020 20:51:34 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>
Subject: Re: [PATCH 5.5 00/65] 5.5.11-rc1 review
Message-ID: <20200322195134.GA3127@duo.ucw.cz>
References: <20200319123926.466988514@linuxfoundation.org>
 <fcf6db4c-cebe-9ad3-9f19-00d49a7b1043@roeck-us.net>
 <20200319145900.GC92193@kroah.com>
 <32c627bf-0e6b-8bc4-88d3-032a69484aa6@roeck-us.net>
 <20200320144658.GK4189@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20200320144658.GK4189@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Thanks for letting me know, I've now dropped that patch (others
> > > complained about it for other reasons) and will push out a -rc2 with
> > > that fix.
> > >=20
> >=20
> > I did wonder why the offending patch was included, but then I figured t=
hat
> > I lost the "we apply too many patches to stable releases" battle, and I=
 didn't
> > want to re-litigate it.
>=20
> I usually much rather take prerequisite patches rather than do
> backports, which is why that patch was selected.

Unfortunately, that results in less useful -stable.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXnfBxgAKCRAw5/Bqldv6
8vd0AJ4zzgG0kwMalfU/hzmGareDQj+tkgCfXEoBcazXsKSah/ct3Zx1qGWDwc8=
=BRHX
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
