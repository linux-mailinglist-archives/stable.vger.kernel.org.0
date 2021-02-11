Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEC4318EA9
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBKPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:32:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhBKP2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:28:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7543964D87;
        Thu, 11 Feb 2021 15:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613057270;
        bh=5CaJiFoG/fwUYfQnBEAeBMgRK+ntGqqdbkCchfAnmqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GFw8GhBxfjdR5BlSWcHkeTPN1ufTNy6ZoFvRY9UAWUt/yCd+T3O89rE+jlB5Lul6O
         qFQRlq2hEikTIOBZd5hsMqE3U9+mW7YbkjQhcsRHZvUr6FEvX6MQkP7QMxk8dbW/B6
         /YZ6mzwTScvA52yvP8SzwTmYZzHSkzJZ4LMPvV6AUor6/gaNzUMmlFiZIv8fksyGAQ
         NT2nKwpMeo03+0yeMOnR7GcDMnymqtLGIliv5JPIu8oOeZSvd5qTYKDMGTkmyabSth
         Uf3GX8oe0RXr8aSqD0UPDEBpJ7bwBd8cSlvj7Y4scTJ+2tWf06X2q11nF3ggnq0p58
         ejCWv6CF/66Dw==
Date:   Thu, 11 Feb 2021 15:26:56 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 07/24] regulator: core: avoid
 regulator_resolve_supply() race condition
Message-ID: <20210211152656.GD5217@sirena.org.uk>
References: <20210211150147.743660073@linuxfoundation.org>
 <20210211150148.069380965@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <20210211150148.069380965@linuxfoundation.org>
X-Cookie: Do not pick the flowers.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 11, 2021 at 04:02:41PM +0100, Greg Kroah-Hartman wrote:
> From: David Collins <collinsd@codeaurora.org>
>=20
> [ Upstream commit eaa7995c529b54d68d97a30f6344cc6ca2f214a7 ]
>=20
> The final step in regulator_register() is to call
> regulator_resolve_supply() for each registered regulator

This is buggy without a followup which doesn't seem to have been
backported here.

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmAlTL8ACgkQJNaLcl1U
h9DW+gf+IS7hwdAZRY+j1bSIul433VAxLvBks9GcB7EwmixSKg9PC/2IofbYOTpA
spNvrFMe5vREV5+7KTz6ZzViMLmy5ZQwhGYF8Uyn2SxsOTHhEh90zpvHyKpCeZlR
owvCoQ2wNg3gbm30658skJQIc6YhstTIrPRWsw9cD3hs/TlhS2RX4HOHSqO17P65
RE/76uU8/WoauqmcsVUELLrxOWzuasi8c9hJJZHLvpVgHOUvFPiHkBdMlQlqRMZ+
q0YC/LokZmXIPM+jougbSfF7YUqq9oSKPVTgg0JMPIqAd8+BdKzY8o9HXoJnpsMn
SaU0KO8G1f7tA+0lIvn3IFS53vYWKg==
=wJ4/
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
