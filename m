Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7C34BEE9
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 22:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhC1Uir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 16:38:47 -0400
Received: from maynard.decadent.org.uk ([95.217.213.242]:37094 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhC1UiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 16:38:23 -0400
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcAf-0001v1-GR; Sun, 28 Mar 2021 22:38:05 +0200
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lQcAe-003GQz-0v; Sun, 28 Mar 2021 22:38:04 +0200
Message-ID: <ec12b32022a7767e1e689e9584725aced5dd160d.camel@decadent.org.uk>
Subject: Re: [PATCH 4.9 00/78] 4.9.262-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Date:   Sun, 28 Mar 2021 22:37:48 +0200
In-Reply-To: <11774be7-0738-1a23-f186-0875b9e82ef6@gmail.com>
References: <20210315135212.060847074@linuxfoundation.org>
         <11774be7-0738-1a23-f186-0875b9e82ef6@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-rIV6XJSGGvsqusd4aWkP"
User-Agent: Evolution 3.38.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-rIV6XJSGGvsqusd4aWkP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-03-15 at 13:42 -0700, Florian Fainelli wrote:
>=20
>=20
> On 3/15/2021 6:51 AM, gregkh@linuxfoundation.org=C2=A0wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >=20
> > This is the start of the stable review cycle for the 4.9.262
> > release.
> > There are 78 patches in this series, all will be posted as a
> > response
> > to this one.=C2=A0 If anyone has any issues with these being applied,
> > please
> > let me know.
> >=20
> > Responses should be made by Wed, 17 Mar 2021 13:51:58 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.26=
2-rc1.gz
> > or in the git tree and branch at:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0git://git.kernel.org/pu=
b/scm/linux/kernel/git/stable/linux-
> > stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> >=20
> > thanks,
> >=20
> > greg k-h
>=20
> On ARCH_BRCMSTB using 32-bit and 64-bit kernels, still seeing the
> following futex warning, unfortunately simply running the function
> tracers does not allow me to trigger the warning, so I am having a
> hard
> time coming up with a simple reproducer:
[...]

I've now also seen this warning on x86_64 when running Firefox.  I
don't know why it didn't show up in my earlier testing.

I remain sceptical that a cherry-picking approach is going to work for
fixing futexes on 4.9.  But I now have an additional patch series that
seems to fix this warning (and some other older bugs that I didn't
reproduce) and continues to pass the self-tests.  I'll send that along
shortly.

Ben.

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education.
                                                      - Albert Einstein

--=-rIV6XJSGGvsqusd4aWkP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmBg6RwACgkQ57/I7JWG
EQmdGRAAh2burezwww+xp9zOuzCBxyrl0PezZoU7nrdXQ/knqglBEJE2JUB3PV6j
9rmntBtCl1wJylJMArNXjSnp49aNuzwkt8PGlKn6Rp24UqMp7GImWSVGXS9SJq3X
kapYKRZXZhqi7TbUxGl75YwGz6V7gmW5M/yQxdQgzvyVJOicxJF47GuWoNawrPU0
MiRz046jOtAEwrJriqFOz0S87HNrlg0QAGAk5YZ4l/WMPX/xHm9KWr0Zj04aKBSQ
KZVS+PsIKN9Ggdu/GhQquHmykDENLcC5lI1BwlB4y2h5VaMNjrlFNQwEmAzjA+Vb
999m34iB/Gn9OHkc5G9i6r7bwKsR3vAEYcYZ2EbTzacZE7dQ8pl6kpwetTEuKgTs
Xwn9B+8XlM5LUi0xsHvbdqAxjklSvekTUqYiPBf/R/FtruuqzJxlWWVqf2p0tx4b
jaNxXUh+8+yot0s9EOXBF7RQCh/VYxMJm3I4EY4tjUvUlcg4E1dt6I5oYA1guvUJ
/iPEFjBuGMUacWMTb46eVjTYsya9bf0gtcfArjHQPMTXY7nxk4BocVjILEAsZqlQ
zU8/mo+V69IHa9QLxp1yXq5SnwTnwJZm7ptl6IQ3BT//UC78QQQuisz3a0KMqW1n
kl7R7Di87IL3KqVLgA1rzwQmeA0+vjDAde7+pzqHyY0lgTu0ViY=
=fTa/
-----END PGP SIGNATURE-----

--=-rIV6XJSGGvsqusd4aWkP--
