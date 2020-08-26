Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE022528EF
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 10:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgHZIHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 04:07:36 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57978 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgHZIHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 04:07:35 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0F2081C0BBC; Wed, 26 Aug 2020 10:07:33 +0200 (CEST)
Date:   Wed, 26 Aug 2020 10:07:32 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/71] 4.19.142-rc1 review
Message-ID: <20200826080732.GA9637@amd>
References: <20200824082355.848475917@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.142 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.14=
2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.19.y
> and the diffstat can be found below.

Uh. I believe this was tested successfully by CIP probject:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
81017473

Yes, there are two "fails" but there seem to be caused by DNS
resolution problems (i.e. test infrastructure problem, not kernel problem).

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9GGEQACgkQMOfwapXb+vI6gACcC8RWRc6j+cDTArZXDE+VqCM8
P4AAn3FGvJapboX83n9xwMEIMK1uCq9v
=dNUj
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
