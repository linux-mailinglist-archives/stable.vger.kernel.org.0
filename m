Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB60C33C99C
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 00:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhCOXEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 19:04:35 -0400
Received: from bluehome.net ([96.66.250.149]:48380 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232660AbhCOXEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 19:04:30 -0400
Received: from pc.lan (pc.lan [10.0.0.51])
        by bluehome.net (Postfix) with ESMTPSA id F2B234B4047C;
        Mon, 15 Mar 2021 15:57:09 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:57:09 -0700
From:   Jason Self <jason@bluehome.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/120] 4.19.181-rc1 review
Message-ID: <20210315155709.05cbb6bd@pc.lan>
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/9KnWO_rbGDJrYvo7KEjNFCl"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/9KnWO_rbGDJrYvo7KEjNFCl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Mar 2021 14:55:51 +0100
gregkh@linuxfoundation.org wrote:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> This is the start of the stable review cycle for the 4.19.181 release.

Tested on amd64, arm64, armhf, i386, m68k, or1k, powerpc, ppc64,
ppc64el, riscv64, s390x, sparc64. No problems detected.

Tested-by: Jason Self <jason@bluehome.net>

--Sig_/9KnWO_rbGDJrYvo7KEjNFCl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmBP5kUACgkQnQ2zG1Ra
MZjyShAAgE5SnwFHy6+FNSBTayyjAywt999yNHAR3XyXL7EfgMR7/fF4kvgOgsTa
JFZ5Rcy4t1xCbXaz7Z9Ox5FnJI5xTygaDfgpbg18bmV+42VpAuhw9+53lx1ewct3
qTlPodVv9HpjDgmwPm28ojl2h3ONg2vcvjWUF+edZHieqQKF6YzseAdl1GkCNYDN
BLCBHEB/fYKeOFEHTzZ+4HC4pW3vJiYxrORGVywkrwwYk9cGVkzErvSiiibJBKQ4
ys01SaewrHzdgaefXog3BDQJ+WVAQAR2IwmgpuI3X7SAInw+Pi2sNlVcBDsZn4CH
WlqNoU2zjPbhlFxHnxij1x+Pkg+QEAE7Q5V188tL6QigdgwdGY3Tu72WEl/7vy95
u/eIIgs3pvXTCETX7dQIhjsZyH7tr+zF1tFpHinKa2+FGhlbfJ55benpNUQWpXvn
YxgBELOhAjAI8Jg9sW/I02qNxEBiK+Rw8x7pH4BswiqXEMSMC66hUc43A0e0kN7s
e/wGxBWDo62pNhZXPkL9XmICvDwVx8kSh4LqJlWfMSGIJxmbPjD9QP0csYoc8PuO
4Ld2Y0lXOrtNzqI1/F/Vsrci0MsLXmAOetUqNS4yW0tWED2d1TEfGwe5+MVGV8qM
I1FikG/V6TSmxf1Hu/QjWvXP77j8BwwDe7ZvzW1c8N/6gXG3Rac=
=VoBR
-----END PGP SIGNATURE-----

--Sig_/9KnWO_rbGDJrYvo7KEjNFCl--
