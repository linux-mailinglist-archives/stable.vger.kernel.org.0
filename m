Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BA82528F4
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 10:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHZIJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 04:09:39 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:58198 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgHZIJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 04:09:38 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 31BD91C0BBC; Wed, 26 Aug 2020 10:09:35 +0200 (CEST)
Date:   Wed, 26 Aug 2020 10:09:34 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/33] 4.4.234-rc1 review
Message-ID: <20200826080934.GB9637@amd>
References: <20200824082346.498653578@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <20200824082346.498653578@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.234=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.4.y
> and the diffstat can be found below.
>

I believe this was tested successfully with CIP project:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
81017460

Yes, they are failures, but they are DNS resolution problems during
testing.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9GGL4ACgkQMOfwapXb+vJX5ACgw4URW8tZBmqKaRedeAiHuKVJ
xpYAnRH3sxonRWLmp+awdULetN7awy1/
=GvYG
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
