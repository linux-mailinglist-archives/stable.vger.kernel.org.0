Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B94B454F77
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 22:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240513AbhKQVlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 16:41:52 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58580 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbhKQVlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 16:41:51 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 626651C0B76; Wed, 17 Nov 2021 22:38:51 +0100 (CET)
Date:   Wed, 17 Nov 2021 22:38:49 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/569] 5.10.80-rc4 review
Message-ID: <20211117213849.GA9944@amd>
References: <20211117144602.341592498@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20211117144602.341592498@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.80 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
http://www.livejournal.com/~pavelmachek

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmGVdmkACgkQMOfwapXb+vK2HACeJzVFfMIiFmQAIeL82gBt80PR
1YEAoL5mPKyo/v10puQJps8RrToLbaX8
=Jaku
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
