Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1F612BBA1
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 23:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfL0Wn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 17:43:58 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:33654 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfL0Wn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Dec 2019 17:43:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=f/BaAzN/B4zZGG5c/BBQIcz7jRbc0KgYPq9T/PT+PXc=; b=tP3qhjwCEQuwzFSnbi5zPBeeH
        2DRHUAYmEwPxP0/Mgv70UVBEbGkWtveOYNY9EPbCBWxrxBQoSqVeB1GwhORyMzJncJ1LpIyHztptw
        3ucqshefdgD9UKxOKgRzoBHNNIAqInLWBIPTys1c9n3RtGDr/OQSpqw4KRCMAjKCuXUWs=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1ikyKn-0006aD-GF; Fri, 27 Dec 2019 22:43:53 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 0B66FD01A22; Fri, 27 Dec 2019 22:43:53 +0000 (GMT)
Date:   Fri, 27 Dec 2019 22:43:53 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tzung-Bi Shih <tzungbi@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.4 005/187] ASoC: max98090: remove msleep in PLL
 unlocked workaround
Message-ID: <20191227224353.GN27497@sirena.org.uk>
References: <20191227174055.4923-1-sashal@kernel.org>
 <20191227174055.4923-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8MZM6zh5Bb05FW+3"
Content-Disposition: inline
In-Reply-To: <20191227174055.4923-5-sashal@kernel.org>
X-Cookie: I have many CHARTS and DIAGRAMS..
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8MZM6zh5Bb05FW+3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 27, 2019 at 12:37:53PM -0500, Sasha Levin wrote:
> From: Tzung-Bi Shih <tzungbi@google.com>
>=20
> [ Upstream commit acb874a7c049ec49d8fc66c893170fb42c01bdf7 ]
>=20
> It was observed Baytrail-based chromebooks could cause continuous PLL
> unlocked when using playback stream and capture stream simultaneously.
> Specifically, starting a capture stream after started a playback stream.
> As a result, the audio data could corrupt or turn completely silent.

This causes regressions, don't backport it.

--8MZM6zh5Bb05FW+3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl4GiSgACgkQJNaLcl1U
h9Ba1wf+JTLm9Xy9IZQEHitz8MmDgSB05uohq6xgipaiVvBS+AE9dV5vS+WMl7MD
NWtX6HLYJkfZ5c07WbFfK72FcgbST7ppoGkUP7++wc11ltb5oL39hMSoS/y/d6bF
D2QSiwg/1o2NJYCkAtxWDZDUJRVaqkegyP1yeSiWm/fMO9r7NLiU8sbJxSoHxGTv
QtqJu/iWAm8UBvYBsQEM6t3GMCctVlsVq64vOSle1TnjdPjhI+FnLTv+H0C8BztO
qVLM0p0sQG+SbL7YgijpTBI10A2w2Z6Dkqncspf2iAuppjxV1mxsPHWk2Bo/vn+1
VxVYBVB2Vh7/PAnWjL0n86N46IajDA==
=mRDX
-----END PGP SIGNATURE-----

--8MZM6zh5Bb05FW+3--
