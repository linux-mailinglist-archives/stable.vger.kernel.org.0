Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F2C1C1222
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 14:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgEAMZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 08:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbgEAMZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 08:25:39 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8D7F206F0;
        Fri,  1 May 2020 12:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588335939;
        bh=lbHm2sZNgmp3xDR80ZjBmeiaApE7ajQoqCcVAqDgfgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zrF3lGKQPpXX6JTIbE+Knz2sn0YQPnyc4YtbdPh/DiS+5mS6DF5Ygk3fQa42tDBwa
         cVHsrt1i8wqi82NsuS5SeRrh7UeZNVimqtdPm4ZsFNrYs3iBiMmljn+uUma2PTRrpg
         7PuEpijuzm3s3AMAP+01cNeMfLDGfysSqJsKwzzg=
Date:   Fri, 1 May 2020 13:25:36 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Guillaume Tucker <guillaume.tucker@collabora.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernelci@groups.io, Kevin Hilman <khilman@baylibre.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.dmesg.alert on
 meson-g12a-x96-max
Message-ID: <20200501122536.GA38314@sirena.org.uk>
References: <5eabecbf.1c69fb81.2c617.628f@mx.google.com>
 <cc10812b-19bd-6bd1-75da-32082241640a@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <cc10812b-19bd-6bd1-75da-32082241640a@collabora.com>
X-Cookie: Androphobia:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 01, 2020 at 12:57:27PM +0100, Guillaume Tucker wrote:

> The call stack is not the same as in the commit message found by
> the bisection, so maybe it only fixed part of the problem:

No, it is a backport which was fixing an issue that wasn't present in
v5.4.

> >   Result:     09f4294793bd3 ASoC: meson: axg-card: fix codec-to-codec link setup

As I said in reply to the AUTOSEL mail:

| > Since the addition of commit 9b5db059366a ("ASoC: soc-pcm: dpcm: Only allow
| > playback/capture if supported"), meson-axg cards which have codec-to-codec
| > links fail to init and Oops:

| This clearly describes the issue as only being present after the above
| commit which is not in v5.6.

Probably best that this not be backported.

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6sFT8ACgkQJNaLcl1U
h9CjCwf6A/KP149/7ilTWJylUigNvyI1cVIskzDBGQREGWK0VI2Z8qGOKkNgLzZw
F8H2cYXmeDRb0MJRqgNwV0mDl3iHd7l2lqtIUd4kQdvL7id2OlZV2NEso/o28AwF
x5GDVyl5E9rRto72Krs/X1R1V2+ACbNJORJiargnx7mv7QlmY5L0axZKbifhjP/C
aEA5DlAD6eZXLpOCh++yPZYuatnik0c5uSao+TKsurFgxfC2+xdUnFC9QTYRd7NA
jchP5RvU86y4V7yzhlBcndg+msHZ9/EjcJj1zdbJuaeDX2y895T3jCtgLzlhHVAM
bCa8P2t5jxwaaDQxCLHjRE+uFUbt+w==
=Ue/C
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
