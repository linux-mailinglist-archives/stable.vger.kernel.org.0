Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C697833C999
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 00:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhCOXEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 19:04:34 -0400
Received: from bluehome.net ([96.66.250.149]:48376 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232645AbhCOXE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 19:04:26 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2021 19:04:26 EDT
Received: from pc.lan (pc.lan [10.0.0.51])
        by bluehome.net (Postfix) with ESMTPSA id B2DFF4B4066C;
        Mon, 15 Mar 2021 15:57:07 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:57:07 -0700
From:   Jason Self <jason@bluehome.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/168] 5.4.106-rc1 review
Message-ID: <20210315155707.73da59f8@pc.lan>
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/q.BWF7Tv_7mXA=43ilo8jCH"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/q.BWF7Tv_7mXA=43ilo8jCH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Mar 2021 14:53:52 +0100
gregkh@linuxfoundation.org wrote:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> This is the start of the stable review cycle for the 5.4.106 release.

Tested on amd64, arm64, armhf, i386, m68k, or1k, powerpc, ppc64,
ppc64el, riscv64, s390x, sparc64. No problems detected.

Tested-by: Jason Self <jason@bluehome.net>

--Sig_/q.BWF7Tv_7mXA=43ilo8jCH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmBP5kMACgkQnQ2zG1Ra
MZgjMg//Yi1TDd+URxBk8QUYctAdSPMxQqsctek5eIW7Pv92Xvs3jwTNZQ86ixxN
LavMPYMRNhjw079pf8IHj/rHb42MQuAYdRstQ4zoZQh6EMQ1/jO2VXF6quHcOCNE
0ut3+gacbzHGZjr7nitC9uG41sZZ1SQg978WX0imM+FX134BvJia35+lzKTcTuBm
Htoo0xjShpoxMVC4xdw8LK2aX24ud1elDKi83Obi0ukI3zYZN6dcV05rucLD0X91
FeuagObRPaE7FTKkjEvzM4fh9f7tOOM0f3m6VLTeohswTRT0V05ZlKyj7+YTJjPT
7Pp1S0ZUGRkz/AwyUX50mcYC4anpbL1904UKS6cSJ2y6Nq7iXIbpF0IzOUl6FaJk
vQTeQlpFS1+T9bbIbLrC10elYF2J5U+2bwPr8p6bhvWbkSE9LDvF+qmsI8DSAYqb
TXzjlVHaMl2oqy/Xo0R63NSNHlhZ8KfVmRyxJchPjjrQy3h/FyEp+/CjNsN3HniO
WMncPb9zG9mpLZVU+Z2xPFRB8mIvtuCeVaR6YbQ8TaJvB52cZxqA7jyAGj93+WG9
aa0oly3z0NIgbG5ZPIjxA22v/jcbfTIq+pllbHea6jakLQf2h54WQ8gPk1KNqSpE
MQNrIEIsj9WHY7sJD/MK8N+l4WMsX4NwUEwoRQAL4DaDP4iLsjM=
=HUH8
-----END PGP SIGNATURE-----

--Sig_/q.BWF7Tv_7mXA=43ilo8jCH--
