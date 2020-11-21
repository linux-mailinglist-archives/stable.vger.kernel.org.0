Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120122BBE1A
	for <lists+stable@lfdr.de>; Sat, 21 Nov 2020 09:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgKUIh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Nov 2020 03:37:28 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:33210 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbgKUIh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Nov 2020 03:37:28 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9FC321C0B9E; Sat, 21 Nov 2020 09:37:24 +0100 (CET)
Date:   Sat, 21 Nov 2020 09:37:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/14] 4.19.159-rc1 review
Message-ID: <20201121083723.GA22875@amd>
References: <20201120104539.806156260@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20201120104539.806156260@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.159 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

But reviews indicated two patches that are problematic in 4.19:

rc-v4.19.155.list: fd2278164808 o: | memory: emif: Remove bogus
debugfs error handling

- debugfs still returns NULL in 4.19 so this introducesbug. Itis
  just a cleanup so it can be reverted.

rc-v4.19.156.list: 7d5553147613 o: | drm/i915: Break up error capture
compression loops with cond_resched()

- code still needs to be atomic in 4.19; this probably depends on
  a42f45a2a, see _object_create(). It does not fix anything severe so
    it can be simply reverted.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+40cMACgkQMOfwapXb+vIKHACfakcyB9j6ACIRYgkyifjhQSop
56IAnAk2yGsuix/IBHrw0DmNU8bTEeF+
=a2HH
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
