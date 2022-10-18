Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3351F60287B
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 11:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJRJh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 05:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiJRJh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 05:37:28 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF682A73D;
        Tue, 18 Oct 2022 02:37:28 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CECD51C09D9; Tue, 18 Oct 2022 11:37:26 +0200 (CEST)
Date:   Tue, 18 Oct 2022 11:37:25 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marek Bykowski <marek.bykowski@gmail.com>,
        Rob Herring <robh@kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 1/8] of/fdt: Don't calculate initrd size from
 DT if start > end
Message-ID: <20221018093725.GC1264@duo.ucw.cz>
References: <20221018001202.2732458-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <20221018001202.2732458-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> It should be stressed, it is generally a fault of the bootloader's with
> the kernel relying on it, however we should not allow the bootloader's
> misconfiguration to lead to the kernel oops. Not only the kernel
> should be

I believe we should at least printk() if we detect bootloader bug of
this severity.

Best regards,
								Pavel


> +++ b/drivers/of/fdt.c
> @@ -917,6 +917,8 @@ static void __init early_init_dt_check_for_initrd(uns=
igned long node)
>  	if (!prop)
>  		return;
>  	end =3D of_read_number(prop, len/4);
> +	if (start > end)
> +		return;
> =20
>  	__early_init_dt_declare_initrd(start, end);
> =20
> --=20
> 2.35.1

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY05z1QAKCRAw5/Bqldv6
8ql/AKCg9oS8C4ZuU/xkeG7iWO3HpQPUhgCeLcwc3IO2azfdvu9oZF93Vs3Fklk=
=SD+H
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
