Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51E581F58
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfHEOlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 10:41:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57874 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbfHEOlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 10:41:16 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 1925F80258; Mon,  5 Aug 2019 16:41:01 +0200 (CEST)
Date:   Mon, 5 Aug 2019 16:41:12 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 02/74] ARM: dts: rockchip: Make rk3288-veyron-minnie
 run at hs200
Message-ID: <20190805144112.GA24265@amd>
References: <20190805124935.819068648@linuxfoundation.org>
 <20190805124936.029458352@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20190805124936.029458352@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 1c0479023412ab7834f2e98b796eb0d8c627cd62 ]
>=20
> As some point hs200 was failing on rk3288-veyron-minnie.  See commit
> 984926781122 ("ARM: dts: rockchip: temporarily remove emmc hs200 speed
> from rk3288 minnie").  Although I didn't track down exactly when it
> started working, it seems to work OK now, so let's turn it back on.
>=20
> To test this, I booted from SD card and then used this script to
> stress the enumeration process after fixing a memory leak [1]:
>   cd /sys/bus/platform/drivers/dwmmc_rockchip
>   for i in $(seq 1 3000); do
>     echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D" $i
>     echo ff0f0000.dwmmc > unbind
>     sleep .5
>     echo ff0f0000.dwmmc > bind
>     while true; do
>       if [ -e /dev/mmcblk2 ]; then
>         break;
>       fi
>       sleep .1
>     done
>   done
>=20
> It worked fine.

This may not be suitable for stable. So... hs200 started working in
mainline sometime. That does not mean it was fixed in all the various
stable trees, too.

How was this tested in respective -stable releases?

> [1] https://lkml.kernel.org/r/20190503233526.226272-1-dianders@chromium.o=
rg
>=20
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1IQAgACgkQMOfwapXb+vK1+QCgiyrLP+CFhxZyPjkd07+ydxDL
1JoAn32DOjyKCEJYQQw6DB1POy3fJyRj
=+EKd
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
