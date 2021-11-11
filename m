Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EC844D782
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 14:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhKKNuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 08:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232699AbhKKNuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 08:50:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEB9460F4A;
        Thu, 11 Nov 2021 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636638441;
        bh=9TFTxcUEdEwhp48u9fNkDL4nwF4RxAlnd8sjIj3YoQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XXnI40erBUzui9bY1inM9UXZaj7r75cqdyYeqmZfqzBxLwvou3n+G5QQ5oZZu5Vzd
         4CuKdyCkEifiATxnu+Ibg2qaYnvK8KNZnsvuA6tapAQRozlRKhx1IqIVG3G0v5nLb4
         MnyUgYpskTg+mwNRN6ENI2vDagxPkK5nw0Y82c0g5phFIcsKgUd6fSsg+266SfeHyE
         Daoqmm9aDauY88oN2sBogs/ZRCymaek9QOQBvrYVfuWeQEBXR8nmztWQwv13pDxtdD
         9/8zU45xWKxfS/Odm07owHwhWrGFxmn7VCF/NApS9zyPtXdrV6dQiyl69E8GaQfoaq
         Z4QtCy92Rmdww==
Date:   Thu, 11 Nov 2021 13:47:16 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lukas Wunner <lukas@wunner.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: fix use-after-free of the add_lock mutex
Message-ID: <YY0e5GFrdgNde3m4@sirena.org.uk>
References: <20211111083713.3335171-1-michael@walle.cc>
 <YY0Oe9NjhfUvq0J+@sirena.org.uk>
 <20cde88dd11fde7f6847506ffcaa67ed@walle.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Ser8Hc8y7Eyt67W5"
Content-Disposition: inline
In-Reply-To: <20cde88dd11fde7f6847506ffcaa67ed@walle.cc>
X-Cookie: Teutonic:
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Ser8Hc8y7Eyt67W5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 11, 2021 at 01:46:01PM +0100, Michael Walle wrote:
> Am 2021-11-11 13:37, schrieb Mark Brown:

> > If you are sending a new version of something please flag that in the
> > commit message, this helps both people and automated systems identify
> > that this is a new version of the same thing.

> Are RFC patches eligible to be picked up? I wasn't sure if I had to
> resend it at all. But since there was a mistake in the commit message
> anyway, I went ahead and the the first "real" version. How would
> you flag that? Isn't changing the subject from "[PATCH RFC]" (ok it
> was "RFC PATCH", my bad) to "[PATCH]" enough?

No, both people and machines are going to get confused.

--Ser8Hc8y7Eyt67W5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGNHuQACgkQJNaLcl1U
h9C2Ugf+PquYMxxYsWbB/sZkRXTWaLfsSZc9dPdO82Cc4RXf0ckpdjZA+uHhbles
A1xhgfsUNvv9UekloIvZzc61NkcgM8r4GWFFI4skv7fvWxowYtn6iF/g2APvzmvw
18v3TU+IIa4gKXHrYT96Iooo0gi6LmLbHQCI60ggDmMouurmGGLPYJovxJvQmuSs
L+tx9obJQrxF3sGG8auD74u165362wU93weIHuN7UCUF0rGWosvopt4C1ekkT1UA
cmyV/iSai8oXA2HUERoD21cZEceiWAUgK64v5dOGIRWAU4ne2p6LkTIccdFd0tje
qpsy/E+oG8IEsQ2+ta2aE6pcVbyvHQ==
=mcCk
-----END PGP SIGNATURE-----

--Ser8Hc8y7Eyt67W5--
