Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D125026BF06
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgIPIUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 04:20:48 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39146 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgIPIUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 04:20:47 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4AB6A1C0B76; Wed, 16 Sep 2020 10:20:43 +0200 (CEST)
Date:   Wed, 16 Sep 2020 10:20:42 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/78] 4.19.146-rc1 review
Message-ID: <20200916082042.GE32537@duo.ucw.cz>
References: <20200915140633.552502750@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9crTWz/Z+Zyzu20v"
Content-Disposition: inline
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9crTWz/Z+Zyzu20v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.146 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> Anything received after that time might be too late.

CIP testing did not find any kernel problems:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
90209473

(de0-nano failed, but logs reveal it timed out before reaching
bootloader; likely board has problems.)

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9crTWz/Z+Zyzu20v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2HK2gAKCRAw5/Bqldv6
8u0yAKDDKjhVZiguhcy83DsRHJp2zXepUQCgwQhOZcKrkXRM0aSqMVrDUElvEAo=
=ZM1w
-----END PGP SIGNATURE-----

--9crTWz/Z+Zyzu20v--
