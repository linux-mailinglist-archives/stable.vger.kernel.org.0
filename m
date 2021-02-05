Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A1431193D
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 04:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhBFC7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 21:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhBFCqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 21:46:21 -0500
X-Greylist: delayed 595 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 Feb 2021 15:04:56 PST
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [IPv6:2a00:da80:fff0:2::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EA4C08ED31;
        Fri,  5 Feb 2021 15:04:56 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B05E31C0B81; Fri,  5 Feb 2021 23:54:16 +0100 (CET)
Date:   Fri, 5 Feb 2021 23:54:15 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/17] 4.19.174-rc1 review
Message-ID: <20210205225415.GA10080@amd>
References: <20210205140649.825180779@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.174 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

But AFAIK this should not be in 4.19/5.10 as it does not fix anything
w/o 5ba2ffba13a1e:

> Peter Zijlstra <peterz@infradead.org>
>     kthread: Extract KTHREAD_IS_PER_CPU

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAdzJcACgkQMOfwapXb+vIOPQCgrLFFsl8NDfVs4ADcHA4eRPvu
nScAmwSc+b/ihnbrFrs3ob7C4n9Sxzjo
=Yd0Z
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
