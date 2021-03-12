Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CD4339375
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 17:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhCLQdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 11:33:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232043AbhCLQci (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 11:32:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F36F64F9E;
        Fri, 12 Mar 2021 16:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615566757;
        bh=EMl1b1pyURApZczx1x0xsw7fa1cXeaE2MfqTv6FESOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6TmfKTkPSK8xTpMS20k2G71vulcip/IrAyhW6bM/hgGFytiTQMeQlaQ5cNNRarFi
         XKIxO350J6rLEoL5yvhElFXYjCc1uAUGDKS1IiCk2deMB0H7zw68kla/NX1txmxUFE
         Dz1crXvCGeWuH+34AjjVMWKBnUv6Ocu2aG8AUmk/mbiYIjE66PV+HM6HjcAh/n04Jb
         wpRZLFdbvKdeDupoZ8yLOy9YjiI6+ffVawUdtx+v4oCGKd4UB90d4T14bbYCO5In1m
         MTZzoMOnq9ONiE0zv8EZnSxEOh3l5eX4nHQPSrqf0p2D8UsaGa6/hG2G46CzqJZgP7
         SitF638b7QXEg==
Date:   Fri, 12 Mar 2021 16:31:24 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     tiwai@suse.de, alsa-devel@alsa-project.org,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] ASoC: samsung: tm2_wm5110: check of of_parse
 return value
Message-ID: <20210312163124.GK5348@sirena.org.uk>
References: <20210311003516.120003-1-pierre-louis.bossart@linux.intel.com>
 <20210311003516.120003-2-pierre-louis.bossart@linux.intel.com>
 <20210312142812.GA17802@sirena.org.uk>
 <a9caf1c6-d9d0-7e05-31f2-6a8d9026e509@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/rDaUNvWv5XYRSKj"
Content-Disposition: inline
In-Reply-To: <a9caf1c6-d9d0-7e05-31f2-6a8d9026e509@linux.intel.com>
X-Cookie: Lake Erie died for your sins.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/rDaUNvWv5XYRSKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 12, 2021 at 10:30:32AM -0600, Pierre-Louis Bossart wrote:
> On 3/12/21 8:28 AM, Mark Brown wrote:

> > Commit: 11bc3bb24003 ("ASoC: samsung: tm2_wm5110: check of of_parse return value")
> > 	Fixes tag: Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2board")
> > 	Has these problem(s):
> > 		- Subject does not match target commit subject
> > 		  Just use
> > 			git log -1 --format='Fixes: %h ("%s")'

> Sorry, I don't know what to make of this. I don't see this commit
> 11bc3bb24003

> Something odd happened, there was an initial merge and it seems to have
> disappeared, it's no longer in the for-next branch?

That commit is your patch being applied, which I've dropped because of
the error reported.

--/rDaUNvWv5XYRSKj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBLl1sACgkQJNaLcl1U
h9B/nwf/WVJ7MLmAlhVAmtryaOQ1izrwS2+9b0jCB0uKX6RX1ciqf++LO5nLNePt
+NEFA9UH7Qaa8YN4k3Q8tCgoSb7x7g/S8zGwnufZlqiBtprcZKqGUm+34JhsZhEj
oha1PzPGa7TFGYra5DaMOU2NTNjue7BVZDKKx6LOvpmlNC2uMZkThMIUC+fpCHse
20/5Y/W31QpdZHzCMvo9fY039Olbwt3nvxNmM9850uoPNxD5k/LFOSdy61qJZp9k
LfVVdHdlAPifpb5cRg0XKGAwmgncu1Exutb0lFNUerO4srP4B73mGWFmfMFioPxj
ixtaDpBbx7RaBjBBd6GxPdCwk8KVTw==
=4CYu
-----END PGP SIGNATURE-----

--/rDaUNvWv5XYRSKj--
