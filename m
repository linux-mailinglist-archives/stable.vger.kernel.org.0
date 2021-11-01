Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938ED441A06
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 11:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhKAKkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 06:40:11 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45762 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhKAKkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 06:40:10 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B2DE71C0B76; Mon,  1 Nov 2021 11:37:36 +0100 (CET)
Date:   Mon, 1 Nov 2021 11:37:32 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/35] 4.19.215-rc1 review
Message-ID: <20211101103732.GA24359@duo.ucw.cz>
References: <20211101082451.430720900@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.215 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm getting some failures on 4.19.215-rc1, and at least this one is real:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/173461=
4739

  CC      drivers/mtd/nand/raw/nand_samsung.o
3313drivers/mmc/host/sdhci-esdhc-imx.c: In function 'esdhc_reset_tuning':
3314drivers/mmc/host/sdhci-esdhc-imx.c:966:10: error: implicit declaration =
of function 'readl_poll_timeout'; did you mean 'key_set_timeout'? [-Werror=
=3Dimplicit-function-declaration]
3315    ret =3D readl_poll_timeout(host->ioaddr + SDHCI_AUTO_CMD_STATUS,
3316          ^~~~~~~~~~~~~~~~~~
3317          key_set_timeout
3318  AR      drivers/pci/controller/dwc/built-in.a

Best regards,
							Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYX/DbAAKCRAw5/Bqldv6
8jUCAJ9Ovld54o3fxbvqQycsgR6J3FcH+wCfYJqdEQUqYXmrBD01Est7sa1Q41Q=
=WL7X
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
