Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436CF33C828
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 22:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhCOVGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 17:06:09 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59772 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbhCOVFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 17:05:41 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CF7821C0B8B; Mon, 15 Mar 2021 22:05:38 +0100 (CET)
Date:   Mon, 15 Mar 2021 22:05:38 +0100
From:   Pavel Machek <pavel@denx.de>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/75] 4.4.262-rc1 review
Message-ID: <20210315210537.GA1968@amd>
References: <20210315135208.252034256@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.262 release.
> There are 75 patches in this series, all will be posted as a response
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

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBPzCEACgkQMOfwapXb+vJd9ACeMImcW3HHMP3A3wC+xjY1ev77
UkIAoIGb307MIn0lVxyNcYbaqESYyK01
=JbHU
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
