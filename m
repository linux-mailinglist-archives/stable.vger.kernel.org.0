Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B5823B5F6
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 09:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgHDHqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 03:46:25 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49098 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729515AbgHDHqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 03:46:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9C2991C0BDE; Tue,  4 Aug 2020 09:46:23 +0200 (CEST)
Date:   Tue, 4 Aug 2020 09:46:23 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        chris.paterson2@renesas.com
Subject: Re: [PATCH 4.19 00/56] 4.19.137-rc1 review
Message-ID: <20200804074623.6nhrryvq46zi7qkv@duo.ucw.cz>
References: <20200803121850.306734207@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="takxjhi3fjugbesm"
Content-Disposition: inline
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--takxjhi3fjugbesm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.137 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 05 Aug 2020 12:18:33 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.13=
7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.19.y
> and the diffstat can be found below.

CIP test farm does not see any problems...

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
73700523

=2E..except that one of the targets is unavailable.

Chris, could we get distinction between "we ran a test and it failed"
and "we could not run a test because mice ate the cables"?

Best regards,
									Pavel


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--takxjhi3fjugbesm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXykSTwAKCRAw5/Bqldv6
8i12AJ4+lO2WxlN6arO0fq8P17UgZk5kHACcCDkSpm2ToY7ljzFkKK8OCgtDPCE=
=vNmG
-----END PGP SIGNATURE-----

--takxjhi3fjugbesm--
