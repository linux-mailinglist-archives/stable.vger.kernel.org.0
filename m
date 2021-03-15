Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6DA33C99A
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 00:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhCOXEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 19:04:34 -0400
Received: from bluehome.net ([96.66.250.149]:48380 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232651AbhCOXE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 19:04:28 -0400
Received: from pc.lan (pc.lan [10.0.0.51])
        by bluehome.net (Postfix) with ESMTPSA id AB4574B40CB0;
        Mon, 15 Mar 2021 15:57:15 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:57:14 -0700
From:   Jason Self <jason@bluehome.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/75] 4.4.262-rc1 review
Message-ID: <20210315155714.5caafe05@pc.lan>
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/j8.TAwZkG/kanqgb.oxiqCA"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/j8.TAwZkG/kanqgb.oxiqCA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Mar 2021 14:51:14 +0100
gregkh@linuxfoundation.org wrote:

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> This is the start of the stable review cycle for the 4.4.262 release.

Tested on amd64, arm64, armhf, i386, m68k, or1k, powerpc, ppc64,
ppc64el, s390x, sparc64. No problems detected.

Tested-by: Jason Self <jason@bluehome.net>

--Sig_/j8.TAwZkG/kanqgb.oxiqCA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmBP5koACgkQnQ2zG1Ra
MZjDQg//UFgL8zd1SlKvELsgos4EM/P2fRL57+uTnP6KeDf+6V5XTGp4rwSdgl2l
WDqsRs1poCrGssqrUwuTO/GPTL/h3gm8g+VAN9bQsjnwMRNEveD2/pNFDzxm1D9e
OlPICSFO04+7unKtHhe5cphD6tUGoF+gYA1WVwypYfp9AHSkybL3YNBCsy7LuE/D
XNoZLu5GJyqaf9Kw7MpMOjjO/ibFLzdfVIEy8HzeXtaAaW9J32zxVXHCfpzocXQ0
nB5swxAjlMtgqvpkkjq3NC7mAffxAjEVqAN9uAokakeW0hxhM7bKfXetYdam2egr
3wxIPr3GeBnMOZoYjteDwtzl0m+wT/dKOMCUa03sChwcBBARivbtKLvijzLk4x0W
UDdvqimfBag65hUqJjZoI4h1qAa672Icpnygoa+HCptjYHya4vvQ2f1d7rgJjk7k
mMMA5wklE12H0bTY7e8WN1wk9ALk41E2oNfpmvwsTuPb02mHNjVkdM9AOBITmxY2
tLot3ciZ4LKEJpRtM1K+iS36V/ZNginaUQEJZzA++Ujn/9n6m5nr6S0UMMNrR1iL
8jFO3zjs4txrlRVlW9srDuGZ9y666nW7zvHsjbKiSCOMWGkbH/xonuhGIku1xGg/
s1E4eR/o1WDDlqGS1MNFBpCyFRlJ0u4zB8kckijqP/b98KYpK9Q=
=oHHl
-----END PGP SIGNATURE-----

--Sig_/j8.TAwZkG/kanqgb.oxiqCA--
