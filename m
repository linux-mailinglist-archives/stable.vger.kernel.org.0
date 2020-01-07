Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E601132999
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 16:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgAGPG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 10:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbgAGPG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 10:06:28 -0500
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83D012087F;
        Tue,  7 Jan 2020 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578409588;
        bh=+y+aWqsEqk2+D9Baxc1ravTEaKC6Hg6OrUKouQASJFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aGcPyhZnC7+FqmaURKzkdbH8gwRkbCGrcv15/QY0sFaTSSpSdUJzt3yF0mMK/Qg3E
         EwdVYzY5dcdj451Mrzm/4tIYZK4MZvAqdm2+nCKxgG7wJSry8pui+CAxbpdkd4mW2v
         T28gft04vtvzuNXQCXdxGba1rPmhNJy7/DbrV5YY=
Date:   Tue, 7 Jan 2020 16:06:25 +0100
From:   Maxime Ripard <mripard@kernel.org>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Chen-Yu Tsai <wens@csie.org>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/sun4i: tcon: Set RGB DCLK min. divider based on
 hardware model
Message-ID: <20200107150625.sj6x4u67diac3v5p@gilmour>
References: <20200107070113.28951-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xezwhxxbc3anpsth"
Content-Disposition: inline
In-Reply-To: <20200107070113.28951-1-wens@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xezwhxxbc3anpsth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 07, 2020 at 03:01:13PM +0800, Chen-Yu Tsai wrote:
> From: Chen-Yu Tsai <wens@csie.org>
>
> In commit 0b8e7bbde5e7 ("drm/sun4i: tcon: Set min division of TCON0_DCLK
> to 1.") it was assumed that all TCON variants support a minimum divider
> of 1 if only DCLK was used.
>
> However, the oldest generation of hardware only supports minimum divider
> of 4 if only DCLK is used. If a divider of 1 was used on this old
> hardware, some scrolling artifact would appear. A divider of 2 seemed
> OK, but a divider of 3 had artifacts as well.
>
> Set the minimum divider when outputing to parallel RGB based on the
> hardware model, with a minimum of 4 for the oldest (A10/A10s/A13/A20)
> hardware, and a minimum of 1 for the rest. A value is not set for the
> TCON variants lacking channel 0.
>
> This fixes the scrolling artifacts seen on my A13 tablet.
>
> Fixes: 0b8e7bbde5e7 ("drm/sun4i: tcon: Set min division of TCON0_DCLK to 1.")
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Applied, thanks

Maxime

--xezwhxxbc3anpsth
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXhSecQAKCRDj7w1vZxhR
xQFaAP9wLF9udsuevqjGAE3LAn6TCRsCdWejtoRRsX5mYATyzgEA6SE+BSoFd/Ct
dU/RYO3cR8I6jmK7T2SuD3yh1MdfgAE=
=Ruky
-----END PGP SIGNATURE-----

--xezwhxxbc3anpsth--
