Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795E833C9A1
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 00:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhCOXEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 19:04:36 -0400
Received: from bluehome.net ([96.66.250.149]:48380 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhCOXE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 19:04:29 -0400
Received: from pc.lan (pc.lan [10.0.0.51])
        by bluehome.net (Postfix) with ESMTPSA id 36B424B40C43;
        Mon, 15 Mar 2021 15:57:14 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:57:12 -0700
From:   Jason Self <jason@bluehome.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/78] 4.9.262-rc1 review
Message-ID: <20210315155712.02fcf918@pc.lan>
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/SyEaWKYG7yq3j5LIlLwdjIJ"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/SyEaWKYG7yq3j5LIlLwdjIJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Mar 2021 14:51:23 +0100
gregkh@linuxfoundation.org wrote:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> This is the start of the stable review cycle for the 4.9.262 release.

Tested on amd64, arm64, armhf, i386, m68k, or1k, powerpc, ppc64,
ppc64el, s390x, sparc64. No problems detected.

Tested-by: Jason Self <jason@bluehome.net>

--Sig_/SyEaWKYG7yq3j5LIlLwdjIJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmBP5kgACgkQnQ2zG1Ra
MZiHww//XllVw9ap3XuxcvMtMoet8AkgltZjLJ4HnzlhqF7D4dpX9uKtQTSytMec
O9H5yI0HgQJo3fyzMyWwCSTUE8hAgFxoWxu3fP3au24YgkERy4pgQWf5/RdXFvt7
pgDkfaeOJsnux7IUWFa65o03Gv1b9OKo8YwUqSB0IPA++wN0OV3M4UobslHdVixN
4CoTN2zbGjq6BRGpIP1QqyxsEh/TiNo8fBuZmJCO8DuPSnrrp8VFBp+yp8x3T14X
wk4R0ElgptJB8PZWrydzecyYkr36K14JxsE5WJQAv8XxgF1VOgpx2DR7bGlP4P7V
bUwiUuGVXgCEdcyoNcHMoVijhS+gjzqZGclhFYLn1oLJbopVnEHSO1ubkiGUWcqM
4BXaT/5JdfmQR5yyVmTMXiqGSsD9NRKmzw1h05X00FhJ2L8+Di5LR3nMSVVkRKY4
N6S2mmM9P9nv0YnHCKG4znDAn7pF1Ex7L2MQfV5ApZ1dKEFkIcvYwBzAnX8vAyqY
/hxUMBmfAoXDRDAbtC9s2VMHB++IKJvtoRv22HWnZMj+A7exTcip0FXLg8mX5+d5
ftWhpZSa/dB9fcmtfDCt29sXtvbfb4RFj9fDZcY7kMbRXUsNLD+EAObb5NToVLeP
6txFEIh8n8yamp/+4dnY6B+N72df0QCuAi5vUvBE6726UBgfjAA=
=G2rj
-----END PGP SIGNATURE-----

--Sig_/SyEaWKYG7yq3j5LIlLwdjIJ--
