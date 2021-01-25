Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1169C3033CE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731392AbhAZFF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:29 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35938 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731442AbhAYS7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 13:59:41 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9F1A11C0B78; Mon, 25 Jan 2021 19:58:29 +0100 (CET)
Date:   Mon, 25 Jan 2021 19:58:29 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anthony Iliopoulos <ailiop@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 12/58] dm integrity: select CRYPTO_SKCIPHER
Message-ID: <20210125185829.GA2818@duo.ucw.cz>
References: <20210125183156.702907356@linuxfoundation.org>
 <20210125183157.221452946@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20210125183157.221452946@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Anthony Iliopoulos <ailiop@suse.com>
>=20
> [ Upstream commit f7b347acb5f6c29d9229bb64893d8b6a2c7949fb ]
>=20
> The integrity target relies on skcipher for encryption/decryption, but
> certain kernel configurations may not enable CRYPTO_SKCIPHER, leading to
> compilation errors due to unresolved symbols. Explicitly select
> CRYPTO_SKCIPHER for DM_INTEGRITY, since it is unconditionally dependent
> on it.

There is no such config option in 4.19. This patch is not suitable
here.

grep -r CRYPTO_SKCIPHER .
=2E/include/crypto/skcipher.h:#ifndef _CRYPTO_SKCIPHER_H
=2E/include/crypto/skcipher.h:#define _CRYPTO_SKCIPHER_H
=2E/include/crypto/skcipher.h:#endif	/* _CRYPTO_SKCIPHER_H */

Best regards,
								Pavel

> +++ b/drivers/md/Kconfig
> @@ -527,6 +527,7 @@ config DM_INTEGRITY
>  	select BLK_DEV_INTEGRITY
>  	select DM_BUFIO
>  	select CRYPTO
> +	select CRYPTO_SKCIPHER
>  	select ASYNC_XOR
>  	---help---
>  	  This device-mapper target emulates a block device that has

--=20
http://www.livejournal.com/~pavelmachek

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYA8U1QAKCRAw5/Bqldv6
8rEVAJ0bHdzq+GcOETeQUFDZ3r73okWsVACfQ4ljhvoDXG5rfaqCk9Oig7CqDNM=
=n2XG
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
