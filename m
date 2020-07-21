Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6101F227F6E
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbgGUL51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 07:57:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53750 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgGUL50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 07:57:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C7F5C1C0BE8; Tue, 21 Jul 2020 13:57:24 +0200 (CEST)
Date:   Tue, 21 Jul 2020 13:57:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/58] 4.4.231-rc1 review
Message-ID: <20200721115724.GB26436@amd>
References: <20200720152747.127988571@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.231=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.4.y
> and the diffstat can be found below.

This, too, seems to pass CIP project testing:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
68665031

Best regards,
									Pavel

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8W2CQACgkQMOfwapXb+vKxMACgkaDLXfcjWZ8XmSzM2m1wODMt
wmMAnjA9lbg2t8tsafBFarIi9ur487ix
=8HOL
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
