Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861DE33A1A5
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 23:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhCMWad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 17:30:33 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35266 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbhCMWaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 17:30:13 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 08FD01C0B7F; Sat, 13 Mar 2021 23:30:10 +0100 (CET)
Date:   Sat, 13 Mar 2021 23:30:09 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/24] 5.4.105-rc1 review
Message-ID: <20210313223009.GA12835@amd>
References: <20210310132320.550932445@linuxfoundation.org>
 <29dcd801-7f1e-ae09-9b88-ce17cb096f60@gmail.com>
 <YEoWT85kGVYbBnKY@kroah.com>
 <61cef8f0-c40a-c4e4-5322-9939ed21bff7@gmail.com>
 <YEpV/FZ8mLivt0hy@kroah.com>
 <40f06036-c6de-706b-30a0-e20de0c6ff57@gmail.com>
 <72fd4a3f-1548-96eb-16f6-55907019afbf@gmail.com>
 <YEzBQCU/4kk8qcWr@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <YEzBQCU/4kk8qcWr@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > So I guess we are good, until we are not. It concerns me however that
> > this (latent at the time) issue was reported at Wed, 10 Mar 2021
> > 20:19:48 -0800 which is well before the deadline of Fri, 12 Mar 2021
> > 13:23:09 +0000, and yet, the v5.4.105 was announced on Thu, 11 Mar 2021
> > 05:33:31 -0800 (PST) and it went through with that patch nonetheless.
>=20
> It's a judgement call on my side as to when to do the release, based on
> the testing that has happened, any reports, and my knowledge of what is
> in the patches themselves.  For this patchset, all of the expected
> testers came back with no problems, except for your report.
>=20
> And if your report turned out to be real (the fact that it was a
> backport of an "old" patch made it much less likely to be real), I can
> always instantly revert it and push out a new release quickly for the
> tiny subset of those that have problems with this.
>=20
> So I took a guess based on all of this and decided it was more important
> to get the release out early, so that it can start to make its way to
> the huge majority of systems that did report testing worked fine, than
> to delay it to wait for your single system report.  Because again, if
> this turned out to be a real issue, a quick release for any affected
> systems would have been trivial to create.

You are setting yourself (and testers) a deadline... and then you
ignore it.

People are not only testing the release, they are also reviewing the
patches, and having at least two days for that is useful.

You clearly disagree, but in any case you should not mention deadline
in the initial if you don't intend to keep them. Thats confusing, and
clearly it is not only confusing to me.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBNPPAACgkQMOfwapXb+vLpywCfU8QUOys3itqxfaoUmmQMughF
2eEAn0mPrWsi16CoRU+APxQbKQboSvLh
=4ESJ
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
