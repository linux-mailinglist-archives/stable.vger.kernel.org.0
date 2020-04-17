Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8171ADD63
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 14:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgDQMfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 08:35:34 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55774 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgDQMfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 08:35:34 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4B1791C01FB; Fri, 17 Apr 2020 14:35:32 +0200 (CEST)
Date:   Fri, 17 Apr 2020 14:35:31 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        chris.paterson2@renesas.com
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/146] 4.19.116-rc1 review
Message-ID: <20200417123531.GA19028@duo.ucw.cz>
References: <20200416131242.353444678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.116 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.11=
6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.19.y
> and the diffstat can be found below.

CIP project ran tests on this one, and we have de0-nano failure:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/136=
707029

Detailed results should be at:

https://lava.ciplatform.org/scheduler/job/14716
https://lava.ciplatform.org/scheduler/job/14717

=2E.but those results do not load for me (?).

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXpmikwAKCRAw5/Bqldv6
8rteAJ9oEJhd6KdD7SDd7a+wYGzoxTToVQCfWte+OA4WLHYjgi0e7tDkg2HEF90=
=uuJJ
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
