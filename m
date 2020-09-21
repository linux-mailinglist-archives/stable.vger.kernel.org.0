Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58864272982
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 17:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgIUPIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 11:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbgIUPHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 11:07:54 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25DA2076E;
        Mon, 21 Sep 2020 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600700874;
        bh=CrIwS1xYozSl7U4DdOij9bK6ssn3A331CEG0ka0admY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gQ8sjHjBXZo+vNEWDNum3/lDMUIxQ5EI5VLGzt5Pl5kby/naiCoM79B8dR9dOAjgM
         KcvEeJlAli4UXuLjhwveDzf8fr/gX6A+SVmjUBNN0gUUp9ZP4TFE6snymN1TOX5b41
         Cq72zKQhVaI0NUQVDcvbRBSZgfSF/3CPAc6sKfp4=
Date:   Mon, 21 Sep 2020 16:07:01 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.8 03/20] ASoC: wm8994: Skip setting of the
 WM8994_MICBIAS register for WM1811
Message-ID: <20200921150701.GA12231@sirena.org.uk>
References: <20200921144027.2135390-1-sashal@kernel.org>
 <20200921144027.2135390-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20200921144027.2135390-3-sashal@kernel.org>
X-Cookie: Alimony is the high cost of leaving.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 21, 2020 at 10:40:10AM -0400, Sasha Levin wrote:

> The WM8994_MICBIAS register is not available in the WM1811 CODEC so skip
> initialization of that register for that device.
> This suppresses an error during boot:
> "wm8994-codec: ASoC: error at snd_soc_component_update_bits on wm8994-codec"

This is pretty much a cosmetic change - previously we were silently not
reading the register, this just removes the attempt to read it since we
added an error message in the core.

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl9owZQACgkQJNaLcl1U
h9DuEAf9E4btRI0NX2oe8V1deZw2buPvoKQPGvwseEr3w1FrbC1fM6nn3sirDyae
RdfP/1qR3WXfI5SZOztv8kG+g88mHWaT2Y1cDv6zZkBJs9+OicUPftZgBS7C30zU
m8avzwevF96pjt70HMjxEPUya2ogLChAFrYA0CMGV1pwEkzOIxl7yv3aEfu0wdv6
eIbwwwrlcs+HDAkwbptYy5sC2xMPRpn2rCBJG290M3x99Xbdy0ShUR+Ac3iuhERy
zVLQgPtt/tj6spPaEXN+mBLw/vshwSwMX5ueJG6TLL6iNlY74l7Wli9u2fbUIAKP
rDH9KHoSSnjFFGNpN31VNuUdi7x8BQ==
=7sIW
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
