Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA9D5E5427
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 22:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiIUUGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 16:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiIUUGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 16:06:05 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B96A0261;
        Wed, 21 Sep 2022 13:06:03 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8C04C1C0001; Wed, 21 Sep 2022 22:06:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1663790762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=omSxbeRuWfGoqRrj59tV4BZ/8Tdv+u60XdujG3jn7Y4=;
        b=fl0FonWmTOJ84tAxKRGe0jo17sep+Cwu8OQIxoJSC8RhXXJtL/A614esM6mNHmf6VVogOI
        WMXQUVYJ4R9bNSYaEkwZYKY5mq2wQ3wB3MTdiNFOFuXx+z9LHsrchaiYBT0tXxd/hGB7qz
        g11RTnNfwPh7c3zWxaz/kDGK20emTgQ=
Date:   Wed, 21 Sep 2022 22:06:02 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Youling Tang <tangyouling@loongson.cn>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 36/39] mksysmap: Fix the mismatch of L0 symbols in
 System.map
Message-ID: <20220921200602.GB32055@duo.ucw.cz>
References: <20220921153645.663680057@linuxfoundation.org>
 <20220921153646.896567524@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <20220921153646.896567524@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Youling Tang <tangyouling@loongson.cn>
>=20
> [ Upstream commit c17a2538704f926ee4d167ba625e09b1040d8439 ]
>=20
> When System.map was generated, the kernel used mksysmap to filter the
> kernel symbols, we need to filter "L0" symbols in LoongArch architecture.
>=20
> $ cat System.map | grep L0
> 9000000000221540 t L0
>=20
> The L0 symbol exists in System.map, but not in .tmp_System.map. When
> "cmp -s System.map .tmp_System.map" will show "Inconsistent kallsyms
> data" error message in link-vmlinux.sh script.

LoongArch is not supported in 5.10 (nor 4.19) so we should not have
this patch.

Best regards,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYytuqgAKCRAw5/Bqldv6
8mMgAKCO9t7E4JONM65xtmy4wDVRo1q+1QCgjA7vkylhQb6A3uL9vnN3V7TlCFk=
=WqN1
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
