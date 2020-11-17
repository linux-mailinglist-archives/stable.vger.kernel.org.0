Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C132B6D51
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 19:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKQS1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 13:27:45 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:52412 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgKQS1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 13:27:45 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B693F1C0B9D; Tue, 17 Nov 2020 19:27:41 +0100 (CET)
Date:   Tue, 17 Nov 2020 19:27:41 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/64] 4.4.244-rc1 review
Message-ID: <20201117182741.GA15274@duo.ucw.cz>
References: <20201117122106.144800239@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.244 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX7QWHQAKCRAw5/Bqldv6
8oAlAKDBDdO6Y/FCgZPDPMyO1+r6RVVFzwCfaqQn0o4qGLHvp4ZdwflNb3j2Xfc=
=6Pwu
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
