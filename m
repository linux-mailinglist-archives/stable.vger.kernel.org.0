Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7961B1FF02A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 13:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgFRLDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 07:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727825AbgFRLDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 07:03:01 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32B95204EA;
        Thu, 18 Jun 2020 11:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592478180;
        bh=T0ml4vNIA9iwQ8rd38WFt5IPvevTyZHHBCYeXpr3C/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K3s6a0OywmvoIatRfxXcvbLw40QFmm4mXNkB2Gf9QFuNQ/3FXjEvQcMC6NmKGN63Z
         YhgFhpYtR3IXV5Q9/GyiiCxJlcyEXAK2azNTZcB4Dqj4Jd6DhvaMC4sIJUJDVtTb7D
         cNJ1wolF6ibWH0wyN98IZk+zZU5WSPcxvQrrqH/c=
Date:   Thu, 18 Jun 2020 12:02:58 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wei Li <liwei391@huawei.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.7 130/388] ASoC: Fix wrong dependency of da7210
 and wm8983
Message-ID: <20200618110258.GD5789@sirena.org.uk>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-130-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Content-Disposition: inline
In-Reply-To: <20200618010805.600873-130-sashal@kernel.org>
X-Cookie: Androphobia:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2020 at 09:03:47PM -0400, Sasha Levin wrote:
> From: Wei Li <liwei391@huawei.com>
>=20
> [ Upstream commit c1c050ee74d67aeb879fd38e3a07139d7fdb79f4 ]
>=20
> As these two drivers support I2C and SPI, we should add the SND_SOC_I2C_A=
ND_SPI
> dependency instead.

This is purely about build testing, are you sure this is stable
material?

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7rSeEACgkQJNaLcl1U
h9BhCAf/ciV+cf+M61TGXRdOnfuoSVBILoCzTRjUDUZjTFenxNYOL6pn5Xv+aFeK
RbGbTG45EDMNN9LQhtUYX3r4PAPtTux43olQHdd4D5WfW+qdOh+mewub/+Gw85X8
82H4kZgiFEWz6w9GU7oEBv6A8aRJnh0ULOk0mNign0wzgtFozUiqpx9GQFZtk2FN
DttJK3pNdsRcJbPLEWO//vc7NVq+1UeUbIIs7s4j/cH3NGC7NnDTVupWQ9dv6uik
VTun8Mz+TTz+UQOGK4DmubFUqV1WhCnQ2Nd5CCEVmTvVRDiUm3GYGXxbwMsen3Ks
Zy1VQsifFNRJrQ+PKFj3h9tf/SBcJQ==
=mxzp
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
