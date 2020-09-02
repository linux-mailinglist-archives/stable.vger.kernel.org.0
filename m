Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E02025A918
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 12:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgIBKHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 06:07:54 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45512 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBKHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 06:07:52 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E205B1C0B7F; Wed,  2 Sep 2020 12:07:49 +0200 (CEST)
Date:   Wed, 2 Sep 2020 12:07:48 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/61] 4.4.235-rc2 review
Message-ID: <20200902100748.GB3765@duo.ucw.cz>
References: <20200902074814.459749499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <20200902074814.459749499@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.235 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 04 Sep 2020 07:47:57 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
84683545

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX09u9AAKCRAw5/Bqldv6
8k8XAKC9SFLASD4DclvwZTPgwQpd5l8YWwCfVpcwWAwQJTE91Secfch5Ph11i/U=
=srbG
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
