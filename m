Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B25A338FFB
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 15:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhCLO03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 09:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhCLO0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 09:26:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 227B064FB2;
        Fri, 12 Mar 2021 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615559184;
        bh=RaGXMvtngGPPtkkC/wsE4ETfUTd8b3MZ7rwhK5ToRGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qsTT96Q6oC/DSPDmXvuuplJzPWy6szt7f73H267AKB6RUu3AIjUf9WInswnr5jDF8
         ZMKd1Z0bXmgudtWL5/0FDmhKPXx5yT7iQu6tJl0AV9C20Iwvr89Z4YkH8Rs6zggXrX
         zKXDHrdOXZqaZIz11F3tW8FAAaeUEXy1f72FYVO+b6QH4E3Sufi7rQeo1sLKKFecMg
         9K8fryI/FzemIxgVo3ni+c8HuUY6tkY9/SWy5fwxOmJOJ7cjWvrNwHNZhxM13zM4s9
         IO8Z3AZ2zzGkTIXQ0jgkUaZSmMjAikh+LCOt870XAc0Dk9v8uUBW4zvNLha6E59cM5
         ZIJq9n1EwmMig==
Date:   Fri, 12 Mar 2021 14:25:11 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ASoC: intel: atom: Stop advertising non working
 S24LE support
Message-ID: <20210312142511.GA16445@sirena.org.uk>
References: <20210309105520.9185-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20210309105520.9185-1-hdegoede@redhat.com>
X-Cookie: Subject to change without notice.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 09, 2021 at 11:55:19AM +0100, Hans de Goede wrote:

> Fixes: 098c2cd281409 ("ASoC  ASoC: Intel: Atom: add 24-bit support for  media playback and capture")
> Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

	Fixes tag: Fixes: 098c2cd281409 ("ASoC  ASoC: Intel: Atom: add 24-bit support for  media playback and capture")
	Has these problem(s):
		- Subject does not match target commit subject
		  Just use
			git log -1 --format='Fixes: %h ("%s")'

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBLecYACgkQJNaLcl1U
h9CoYwf/ReyC7yEurS99wNbE/0I0AFXHjpmJqXNPLqIulJDGDLjPyaHWTtS6PEa7
i76gEAw7WWTGR73FgHAcoD+0ZOkOcKg6Qk64bAPUk4oemQo7m0JBvUKssmC+9M9W
eNf2LuJJiqJRe3DMp5AO8Ew3cuP3JfZzS7sHGo/U1C7251gIUG/YKG2Qj2wKBQJi
5X+rjj849qH9WS0IZSGEsjCPrlqiiFhuw60nM+KuZcts4M0tANhEYJ4TrPV5Fp8Q
VRC1edyWaFewm0iYX6QtKAQjR6Zdb0z68AGe20mSwPV05Ghz2lMjxD7YY36EtlX7
+++59pH+l0RJunCKumT5oe2Xcli8BA==
=FD5i
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
