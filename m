Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51FB2ADCDC
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 18:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKJR1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 12:27:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKJR1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 12:27:36 -0500
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B98D8206B2;
        Tue, 10 Nov 2020 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605029256;
        bh=ks1LOyBLNDhuxQqZ3iJG1mWuNRCAGal3eA/eaf0LRQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uFxi95SE6F1jiW0+cRqP0WSX0ETwYTfQlpDHPYjc8e3gIns3Q9PiilszYYNKZorSZ
         yzArHERxio2peXf4P2EwjgH3osxneWffCzxi19A8YnsEHt9EnAoIuvlkcbQDrAYSLG
         nrChi6ADjMEKhOk7gD+o+vvd5QvfZy9TT3FvZ35Q=
Date:   Tue, 10 Nov 2020 17:27:21 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sean Nyekjaer <sean@geanix.com>
Cc:     yibin.gong@nxp.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] regualtor: pfuze100: limit pfuze-support-disable-sw to
 pfuze{100,200}
Message-ID: <20201110172721.GA49286@sirena.org.uk>
References: <20201105114926.734553-1-sean@geanix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20201105114926.734553-1-sean@geanix.com>
X-Cookie: Filmed before a live audience.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 05, 2020 at 12:49:26PM +0100, Sean Nyekjaer wrote:
> Limit the fsl,pfuze-support-disable-sw to the pfuze100 and pfuze200
> variants.
> When enabling fsl,pfuze-support-disable-sw and using a pfuze3000 or
> pfuze3001, the driver would choose pfuze100_sw_disable_regulator_ops
> instead of the newly introduced and correct pfuze3000_sw_regulator_ops.
>=20
> Fixes: 6f1cf5257acc ("regualtor: pfuze100: correct sw1a/sw2 on pfuze3000")
> Cc: stable@vger.kernel.org
> ---

You've not provided a Signed-off-by for this so I can't do anything with
it, please see Documentation/process/submitting-patches.rst for details
on what this is and why it's important.

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+qzXkACgkQJNaLcl1U
h9BN8Af/ZOXBrv35z3PfUXA046OtEj86hc8nm8zaCT3pUFLreFjoN5v/vScxOfLn
ud3sMlFRA04ypHa9Y2hl35OGdrOGotsVl5pFagkjS7sSiuakGCY5IXifWwGy5DCb
FHjmxJ+BfF624nbYdENmwZkEM1nsf5qHJo+0YBVYio9sKF5DYl7oKfkcT8BcfUvs
XWHAUPBWj5LiJKPdm8bdE8h2B3T5d2W9xJeWc9XngjKixtM0VuFbJxxPSN77AovT
ZD9yywg/rzjmaLMWcLYo2wZhrDtBqAhKPW5NTyrd8ltuz7cmZpAxh9NCLWIGonjC
yMmQc3K4Na/Rv/1SUIdKyrfgbArs8w==
=VNle
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
