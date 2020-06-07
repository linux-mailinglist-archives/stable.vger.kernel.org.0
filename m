Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FFA1F0B7E
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 15:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgFGNlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 09:41:01 -0400
Received: from mout-p-101.mailbox.org ([80.241.56.151]:61562 "EHLO
        mout-p-101.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgFGNlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 09:41:00 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 49fyFj4yljzKmhw;
        Sun,  7 Jun 2020 15:40:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id abC9UCy5nAMz; Sun,  7 Jun 2020 15:40:54 +0200 (CEST)
Subject: Re: [PATCH] MIPS: lantiq: xway: sysctrl: fix the GPHY clock alias
 names
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        tsbogend@alpha.franken.de, linux-mips@vger.kernel.org
Cc:     john@phrozen.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200607131023.3136390-1-martin.blumenstingl@googlemail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
Message-ID: <46372597-0a05-837b-0a76-4fe3b8fca117@hauke-m.de>
Date:   Sun, 7 Jun 2020 15:40:49 +0200
MIME-Version: 1.0
In-Reply-To: <20200607131023.3136390-1-martin.blumenstingl@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="c0LCEUbaY2ON6wUrEVxOuKBeUhlk6KjCa"
X-Rspamd-Queue-Id: A8D1B176B
X-Rspamd-Score: -7.33 / 15.00 / 15.00
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c0LCEUbaY2ON6wUrEVxOuKBeUhlk6KjCa
Content-Type: multipart/mixed; boundary="Qqk8OAHvGGx1xOBv6tAs06UR1quTJIamt"

--Qqk8OAHvGGx1xOBv6tAs06UR1quTJIamt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/7/20 3:10 PM, Martin Blumenstingl wrote:
> The dt-bindings for the GSWIP describe that the node should be named
> "switch". Use the same name in sysctrl.c so the GSWIP driver can
> actually find the "gphy0" and "gphy1" clocks.
>=20
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx=
200")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>=


Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  arch/mips/lantiq/xway/sysctrl.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sy=
sctrl.c
> index aa37545ebe8f..b10342018d19 100644
> --- a/arch/mips/lantiq/xway/sysctrl.c
> +++ b/arch/mips/lantiq/xway/sysctrl.c
> @@ -514,8 +514,8 @@ void __init ltq_soc_init(void)
>  		clkdev_add_pmu("1e10b308.eth", NULL, 0, 0, PMU_SWITCH |
>  			       PMU_PPE_DP | PMU_PPE_TC);
>  		clkdev_add_pmu("1da00000.usif", "NULL", 1, 0, PMU_USIF);
> -		clkdev_add_pmu("1e108000.gswip", "gphy0", 0, 0, PMU_GPHY);
> -		clkdev_add_pmu("1e108000.gswip", "gphy1", 0, 0, PMU_GPHY);
> +		clkdev_add_pmu("1e108000.switch", "gphy0", 0, 0, PMU_GPHY);
> +		clkdev_add_pmu("1e108000.switch", "gphy1", 0, 0, PMU_GPHY);
>  		clkdev_add_pmu("1e103100.deu", NULL, 1, 0, PMU_DEU);
>  		clkdev_add_pmu("1e116000.mei", "afe", 1, 2, PMU_ANALOG_DSL_AFE);
>  		clkdev_add_pmu("1e116000.mei", "dfe", 1, 0, PMU_DFE);
> @@ -538,8 +538,8 @@ void __init ltq_soc_init(void)
>  				PMU_SWITCH | PMU_PPE_DPLUS | PMU_PPE_DPLUM |
>  				PMU_PPE_EMA | PMU_PPE_TC | PMU_PPE_SLL01 |
>  				PMU_PPE_QSB | PMU_PPE_TOP);
> -		clkdev_add_pmu("1e108000.gswip", "gphy0", 0, 0, PMU_GPHY);
> -		clkdev_add_pmu("1e108000.gswip", "gphy1", 0, 0, PMU_GPHY);
> +		clkdev_add_pmu("1e108000.switch", "gphy0", 0, 0, PMU_GPHY);
> +		clkdev_add_pmu("1e108000.switch", "gphy1", 0, 0, PMU_GPHY);
>  		clkdev_add_pmu("1e103000.sdio", NULL, 1, 0, PMU_SDIO);
>  		clkdev_add_pmu("1e103100.deu", NULL, 1, 0, PMU_DEU);
>  		clkdev_add_pmu("1e116000.mei", "dfe", 1, 0, PMU_DFE);
>=20



--Qqk8OAHvGGx1xOBv6tAs06UR1quTJIamt--

--c0LCEUbaY2ON6wUrEVxOuKBeUhlk6KjCa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl7c7mEACgkQ8bdnhZyy
68f5PQgAkMT6j+cT5CKTtUAbNjKVi/SLWZN/yQAHqqNloTDe8yHYka3eV7nIclCy
Cz6sN4QED7DZ7oHEKus1dwIVnyYhfaTSaQvHTxcYxEGZ8eF+lvEPeEf04msuC3zM
1jwsxnQsYQNUphZXZNz5p72vDpxWTpBbXo4TMaBlCaAjDnpN1e7ztJ5Yl+a12app
YbtJgzbc9/ia/MudMMewBv7s+JW+QgSfRGw4ZKVt/xS8DEar3gnnBYBi9dn3S6tv
UjtG1JwynT5YD9d+6czxt+R8b1QI6Xdq5WH87XgmPce1AZyPeUMLdT13+OcJ+CSN
hRuK2nB9p/ztaxhaPhgyuwtOeu3GYQ==
=HTd0
-----END PGP SIGNATURE-----

--c0LCEUbaY2ON6wUrEVxOuKBeUhlk6KjCa--
