Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A85A2D6970
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393977AbgLJVHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:07:39 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56762 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393902AbgLJVHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:07:36 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D61731C0BB7; Thu, 10 Dec 2020 22:06:53 +0100 (CET)
Date:   Thu, 10 Dec 2020 22:06:52 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/39] 4.19.163-rc1 review
Message-ID: <20201210210652.GA4812@amd>
References: <20201210142602.272595094@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20201210142602.272595094@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-12-10 15:26:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.163 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/SjewACgkQMOfwapXb+vJxRACfYlNCBOAm0D1SoJTlHLM3MbqV
8icAn0E9JXh3A93gDUGz6sgW2mjovovR
=EIKT
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
