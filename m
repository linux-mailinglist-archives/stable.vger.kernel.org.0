Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB7C44D6B3
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 13:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhKKMkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 07:40:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhKKMkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 07:40:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 314D2610D0;
        Thu, 11 Nov 2021 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636634240;
        bh=ZldMX7P8yRqg7zDNiajTT5IhnxrsMMiI415rZX+n4tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E9dhTem7WS+4GygqjUP0Ph/9ZkLSwpMvwM6q1RJbQsM11dUoS1uNP0dWmBUrq4fWu
         U6I/rHIBoQAkucsVWkxQv9HQO6A5V9/XAtUXR9uyFGyfN2FL9lPepJG5d7A5VorjQq
         8eXUeXQc2JBmeG9ZtrP5dC+mu3N6jJji41xWFJJB1HdSD0HvON4a7/S1spnUMzXtfc
         EVt1RhAt/uTMgRW7120dpsGO4wrKFuXs6dHLw6oGGVt1fGEYwgsPKV0nFCviVQZv+V
         T+528OCrLGyymNljQoh4qH+QeroiBzoXnxk5W9LHTDKKManDrZyV9fC2sQSeECDdWC
         qULuKa8N1xQUg==
Date:   Thu, 11 Nov 2021 12:37:15 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lukas Wunner <lukas@wunner.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: fix use-after-free of the add_lock mutex
Message-ID: <YY0Oe9NjhfUvq0J+@sirena.org.uk>
References: <20211111083713.3335171-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YDC45VpXdzf2X+Oc"
Content-Disposition: inline
In-Reply-To: <20211111083713.3335171-1-michael@walle.cc>
X-Cookie: Teutonic:
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YDC45VpXdzf2X+Oc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 11, 2021 at 09:37:13AM +0100, Michael Walle wrote:

> ---
> changes since RFC:
>  - fix call graph indendation in commit message

If you are sending a new version of something please flag that in the
commit message, this helps both people and automated systems identify
that this is a new version of the same thing.

--YDC45VpXdzf2X+Oc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGNDnsACgkQJNaLcl1U
h9Cspgf/XdoRLS+2cR1u4MbqO1DaVFGe5KI3eUjo6rNKmiX9lkmOr1cZzQuIm9NR
REe45OWyarz5V4AlSGHMgAme2sC7Nwcq7W+saMc2orlrQLuA74navuosFmB5TXI0
U0gBDWPnkuTTkwD/tVXIB7o/rU3yDiAzjQUSpjfZKJ1nRJlNaKCBuNFy1TmmmQ9/
c+YNhDfx7vrvldMWEBr9g81GwTxLFKyScSTfN26kIK0FUxawaZK8PbScQh/mp0eU
XIxsKGW4dyDmviXItnQ0cuEi4RgkYnOIVaDODBuzHVBDPD72EXm2FGBIxlgWPbs1
gOqTNTzJX0dr8n5qk2Pv9OvO2t9iKA==
=ksro
-----END PGP SIGNATURE-----

--YDC45VpXdzf2X+Oc--
