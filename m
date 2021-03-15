Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DEC33C99D
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 00:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhCOXEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 19:04:35 -0400
Received: from bluehome.net ([96.66.250.149]:48380 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232648AbhCOXE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 19:04:27 -0400
Received: from pc.lan (pc.lan [10.0.0.51])
        by bluehome.net (Postfix) with ESMTPSA id D67A74B40C2F;
        Mon, 15 Mar 2021 15:57:11 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:57:11 -0700
From:   Jason Self <jason@bluehome.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/290] 5.10.24-rc1 review
Message-ID: <20210315155711.3ce67364@pc.lan>
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/99MWdrLO7d+e/.dzthTMyuF"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/99MWdrLO7d+e/.dzthTMyuF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Mar 2021 14:51:33 +0100
gregkh@linuxfoundation.org wrote:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> This is the start of the stable review cycle for the 5.10.24 release.

Tested on amd64, arm64, armhf, i386, m68k, or1k, powerpc, ppc64,
ppc64el, riscv64, s390x, sparc64. No problems detected.

Tested-by: Jason Self <jason@bluehome.net>


--Sig_/99MWdrLO7d+e/.dzthTMyuF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmBP5kcACgkQnQ2zG1Ra
MZgNOBAApFfH/PPczIbgutjmjJnQIwlRzgcDouR28oMWHzIPLiH5ozjuBMkTB4Q9
MmY8o04HbEMxk509IM749PIL8miHaVmPv+rFFqNisGMxDVlEZxDyuMeMfDgPAByh
ynyOKr+9qIczwSZAEOuoMFvgXBjzuS3ZM2s//iWGNEuQGLs5mSsLlJUlbXOkAiRl
iJUFv4cb4Nf/U6S21gAgTma5ETQzZJrqaxv/OJUztqGbr05dHhae7xnxe9bDeahW
3dWi0UKJqiwi/J/Fur5IvsuO3or1q0zbtstWA9obNxcp2ldWugF0H284F652BuN7
Ngs93PJW978FvCVX9ikUe7GdoWOxX9UBC74QYvqWl2JxCZN/pTfk52jMdlRDVOwO
OVR5TUfMPIXwGpdacZGggGxAwpoAIs0wx3e7fhlrHkNZzYwf0Gf2peJUdIKJfv9A
zR+sXbnjesJ9Aov8io3ndjiJT7OwP8mFpt1DVzwZxLLdu5/IibOM30xq3S/hMQma
FRbDEUZ4POC6eP78I6WESzRKOxubrwkOEnN+b4N5j9y4lO2ISgPBM/++iEYv35Lw
UdUWoMy/X3FoAkdtszBU+Or6FWZA8yywDpdsZT/3lNx3lhm31c1H/ZI5e2pSYWQ2
1yMzpGxwrVNsnoHnDL3bjJUe3h95+X17QkEgl2SP/82Je8iz/Zc=
=W8Z5
-----END PGP SIGNATURE-----

--Sig_/99MWdrLO7d+e/.dzthTMyuF--
