Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E164760C6
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 19:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343805AbhLOSc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 13:32:28 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:33532 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbhLOSc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 13:32:26 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 393861C0B98; Wed, 15 Dec 2021 19:32:25 +0100 (CET)
Date:   Wed, 15 Dec 2021 19:32:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        chris.paterson2@renesas.com, alice.ferrazzi@miraclelinux.com,
        nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: 5.10.85 breaks CIP testing Re: [PATCH 5.10 00/33] 5.10.86-rc1 review
Message-ID: <20211215183223.GB10909@duo.ucw.cz>
References: <20211215172024.787958154@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.86 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm getting the gmp.h failures :-(.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/4=
30434332

I believe we should not change build requirements in the middle of
stable series.

To our testing team: 5.10.85 introduced new requirements for the
build. gmp.h is now required in our configs, and maybe something else.

Easiest fix might be to add

# CONFIG_GCC_PLUGINS is not set

to our configs. Alternatively I know which patch to revert.

But I believe -stable should be the one doing the revert, as the patch
does not fix serious bug and introduces problem. Faster compile is
nice but let mainline have those kind of changes.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYbo0twAKCRAw5/Bqldv6
8jYjAJ424ukuK6MQ2EFM7wTIGH3l1dRfuQCgjfRQIoQTDjinstOOYoqoCTgzZhM=
=aU6i
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
