Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76226261EC7
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbgIHTy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:54:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46726 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729935AbgIHTyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 15:54:50 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0D77B1C0B8A; Tue,  8 Sep 2020 21:54:49 +0200 (CEST)
Date:   Tue, 8 Sep 2020 21:54:48 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/88] 4.19.144-rc1 review
Message-ID: <20200908195448.GD6758@duo.ucw.cz>
References: <20200908152221.082184905@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TybLhxa8M7aNoW+V"
Content-Disposition: inline
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TybLhxa8M7aNoW+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.144 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.

-cip testing did not find any problems:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
87400771

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--TybLhxa8M7aNoW+V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX1fhiAAKCRAw5/Bqldv6
8oJwAJ4qD2Ak33Ba1URRXxCTwrBDe6AXFQCdFTxVhGBBT3kmXn3E0l6jnw2bBUM=
=NY/L
-----END PGP SIGNATURE-----

--TybLhxa8M7aNoW+V--
