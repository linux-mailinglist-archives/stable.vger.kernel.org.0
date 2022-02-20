Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F814BCDFA
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 11:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiBTJzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 04:55:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiBTJzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 04:55:22 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD4443ED6;
        Sun, 20 Feb 2022 01:55:01 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 16E9C1C0B77; Sun, 20 Feb 2022 10:54:59 +0100 (CET)
Date:   Sun, 20 Feb 2022 10:54:33 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Anup Patel <anup@brainfault.org>,
        Marc Zyngier <maz@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Samuel Holland <samuel@sholland.org>,
        Thomas Gleixner <tglx@linutronix.de>, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 03/11] irqchip/sifive-plic: Add missing
 thead,c900-plic match string
Message-ID: <20220220095431.GA5251@amd>
References: <20220215153104.581786-1-sashal@kernel.org>
 <20220215153104.581786-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20220215153104.581786-3-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 1d4df649cbb4b26d19bea38ecff4b65b10a1bbca ]
>=20
> The thead,c900-plic has been used in opensbi to distinguish
> PLIC [1]. Although PLICs have the same behaviors in Linux,
> they are different hardware with some custom initializing in
> firmware(opensbi).
>=20
> Qute opensbi patch commit-msg by Samuel:
>=20
>   The T-HEAD PLIC implementation requires setting a delegation bit
>   to allow access from S-mode. Now that the T-HEAD PLIC has its own
>   compatible string, set this bit automatically from the PLIC driver,
>   instead of reaching into the PLIC's MMIO space from another driver.
>=20
> [1]: https://github.com/riscv-software-src/opensbi/commit/78c2b19218bd626=
53b9fb31623a42ced45f38ea6
>

The "thead,c900-plic" string is added into single place in the
kernel. This means that a) it will probably not do anything useful in
-stable kernels and b) it is certainly missing documentation etc.

In mainline, string is documented in
Documentation/devicetree/bindings/interrupt-controller/sifive,plic-1.0.0.ya=
ml

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmISD9YACgkQMOfwapXb+vK9jACfQTLkUHy984y7w6PEcmacU/f5
gl0AoMGom32Nsn9qBUIkVf8Gzsw0x861
=5jIH
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
