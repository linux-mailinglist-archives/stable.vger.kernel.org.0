Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F69321F48
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhBVSmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 13:42:17 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:41944 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbhBVSls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 13:41:48 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3C9351C0B76; Mon, 22 Feb 2021 19:40:57 +0100 (CET)
Date:   Mon, 22 Feb 2021 19:40:56 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/50] 4.19.177-rc1 review
Message-ID: <20210222184056.GA22197@duo.ucw.cz>
References: <20210222121019.925481519@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2021-02-22 13:12:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.177 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing has one board failing, but it has problem booting, so it
is not kernel fault.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDP6uAAKCRAw5/Bqldv6
8ht0AJsHg1IYv4drW7WPdaS48gOr7ngT+gCggYW8OJbPF6hNHdAQwr4og1XraJU=
=OJ7E
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
