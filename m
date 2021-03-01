Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4A6329379
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 22:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhCAVUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 16:20:21 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:60060 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239527AbhCAVQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 16:16:12 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 134001C0B88; Mon,  1 Mar 2021 22:15:16 +0100 (CET)
Date:   Mon, 1 Mar 2021 22:15:15 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/246] 4.19.178-rc2 review
Message-ID: <20210301211515.GA1284@amd>
References: <20210301193544.489324430@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20210301193544.489324430@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.178 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 03 Mar 2021 19:35:01 +0000.
> Anything received after that time might be too late.

This causes build failure in our testing:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/106460=
5643


776In file included from ./include/net/ndisc.h:50,
777                 from ./include/net/ipv6.h:21,
778                 from ./include/linux/sunrpc/clnt.h:28,
779                 from ./include/linux/nfs_fs.h:32,
780                 from init/do_mounts.c:22:
781./include/linux/icmpv6.h: In function 'icmpv6_ndo_send':
782./include/linux/icmpv6.h:70:2: error: implicit declaration of
function '__icmpv6_send'; did you mean 'icmpv6_send'?
[-Werror=3Dimplicit-function-declaration]
783  __icmpv6_send(skb_in, type, code, info, &parm);
784  ^~~~~~~~~~~~~
785  icmpv6_send

(And similar for two other boards).

Best regards,
								Pavel
							=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmA9WWIACgkQMOfwapXb+vJl9ACgnqYv1Q4Wgeg/3L3CRELT1zfW
cZUAn2xrgcRRB1f+AnvZuuCzbmGY22nB
=YM+z
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
