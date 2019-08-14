Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B2F8CF2C
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 11:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfHNJUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 05:20:55 -0400
Received: from mail-ed1-f100.google.com ([209.85.208.100]:41915 "EHLO
        mail-ed1-f100.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfHNJUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 05:20:55 -0400
Received: by mail-ed1-f100.google.com with SMTP id w5so6468122edl.8
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 02:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LhEaS++A1LV//DEf3NY4zwXglsQkrfanlLNvWkYV9jA=;
        b=ZqgoDKD5V/2dewAArFjiPvMBcIraIqffbj3zsxkJqnaeKkupBhemIo9TbUGK6h7xua
         KTBsTPuKYxdZzAZzF0BkneU30Y2Uvesj4da7QLA5/Sx3+y46jUSWMndhmTOnw2O/NSRx
         P19VIngKLNoYxFRbf4V55qR8657aBvnbVpjHF4iSLHMs7a9kzyPprQ/AOqu8wGCTx3Lr
         KiexstAvAzNEOdfMJ/PFoO8aD9Fg258a2dAsF+owt70w29GrxwEZPkdO0YJAKUsYT9KV
         oIxNOugXCE71Q6mYtfj3bVU9baFGt0OWcddiiKLPCX5zOHd5S0brDo1JUcmO0LxrAW9L
         4R/Q==
X-Gm-Message-State: APjAAAXWErCI+U+o20S5xMI9aH/d7XVCXhQy0hH+1SIo/JLOE2PZqAzm
        1I3dTAb5N7bnHmtASF7GQ3Edl2QUQe9yEKWGV8aU5b661UJKqdnvhaSKXtFNGFxI8Q==
X-Google-Smtp-Source: APXvYqyHUNmi8xJI18o8adu7oBffyihc5CDWqXkuwui2xmnmh7PJJ6fO11wHZF5DIqPD1bBvwONhdh+FMt42
X-Received: by 2002:a50:d8cf:: with SMTP id y15mr46255808edj.213.1565774453496;
        Wed, 14 Aug 2019 02:20:53 -0700 (PDT)
Received: from heliosphere.sirena.org.uk (heliosphere.sirena.org.uk. [2a01:7e01::f03c:91ff:fed4:a3b6])
        by smtp-relay.gmail.com with ESMTPS id w38sm1576451edb.18.2019.08.14.02.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 02:20:53 -0700 (PDT)
X-Relaying-Domain: sirena.org.uk
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1hxpSf-0004db-04; Wed, 14 Aug 2019 09:20:53 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 229702742B4F; Wed, 14 Aug 2019 10:20:52 +0100 (BST)
Date:   Wed, 14 Aug 2019 10:20:52 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>
Subject: Re: [PATCH AUTOSEL 5.2 022/123] ASoC: dapm: Fix handling of
 custom_stop_condition on DAPM graph walks
Message-ID: <20190814092052.GB4640@sirena.co.uk>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-22-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <20190814021047.14828-22-sashal@kernel.org>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2019 at 10:09:06PM -0400, Sasha Levin wrote:
> From: Charles Keepax <ckeepax@opensource.cirrus.com>
>=20
> [ Upstream commit 8dd26dff00c0636b1d8621acaeef3f6f3a39dd77 ]
>=20
> DPCM uses snd_soc_dapm_dai_get_connected_widgets to build a
> list of the widgets connected to a specific front end DAI so it
> can search through this list for available back end DAIs. The

The DPCM code and its users are rather fragile, if nobody noticed a
problem I'd worry about causing some other problem to manifest by
disturbing things.

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1T0nMACgkQJNaLcl1U
h9AtPgf/Y5Y6QGxcsGp6Z1T7CHOfFEShF9+PrrSeFkbTLNtfKfOocePr1QRLruLO
neyUEnupTICm+jd9P6AX/QeDv3vFYNP0hDu03zQbNrHg/Z1F9QE8UhC5xbrl9pN0
/mdWe+mQiCLIoC47jE12PiOP0S/82mSWHTALt6XZjkR92Al+/ocNEYC5z3FhHAeJ
au7ujrpXALXXsZvFTrk+SN2I7js3A/Aeo44QfU9Mg13XFQOKSHIcAXpHaIeOkhNJ
hOUXPIlGqj831IFUsviVYol5uYwRgkKIeDlTE2EvEcaEnkrdkXJ3Hqr5H3JLMzYI
gvzycLLg+JX3t0nSPLBbdx4eApxjjA==
=cbe9
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
