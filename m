Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FD82037F9
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 15:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgFVN2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 09:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbgFVN2A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 09:28:00 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4DCF206D7;
        Mon, 22 Jun 2020 13:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592832479;
        bh=lhi0FntWbQp4WIrSKUUmGDerYj3VQxf+0v5+P6/doWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBUfeRI44+v7JXdB6xXg+hIdb2t30haIQsuAJLa0wyZmSthAEVhHdecY9uHhx85nL
         S4HuvyD0gC30/581rYJXWnWLQL2Xevq7246D7yJr74DluWtW9bCTlf60np6xoSIWfs
         NOGQclz2mgoEbpCOGEtVzf6tv7x9ltlrbjyyAi4U=
Date:   Mon, 22 Jun 2020 14:27:57 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 004/388] ASoC: tegra: tegra_wm8903: Support
 nvidia, headset property
Message-ID: <20200622132757.GG4560@sirena.org.uk>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-4-sashal@kernel.org>
 <20200618110023.GB5789@sirena.org.uk>
 <20200618143046.GT1931@sasha-vm>
 <20200618143930.GI5789@sirena.org.uk>
 <20200621233352.GA1931@sasha-vm>
 <20200622112321.GB4560@sirena.org.uk>
 <20200622123118.GF1931@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GdbWtwDHkcXqP16f"
Content-Disposition: inline
In-Reply-To: <20200622123118.GF1931@sasha-vm>
X-Cookie: laser, n.:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GdbWtwDHkcXqP16f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 22, 2020 at 08:31:18AM -0400, Sasha Levin wrote:
> On Mon, Jun 22, 2020 at 12:23:21PM +0100, Mark Brown wrote:

> > That's concerning - please don't do this.  It's not what stable is
> > expected to be and there's no guarantee that you're getting all the
> > changes required to actually make things work.

> How come? This is one of the things stable rules explicitly call for:
> "New device IDs and quirks are also accepted".

I would expect that to be data only additions, I would not expect that
to be adding new code.

> If we're missing anything, the solution is to make sure we stop missing
> it rather than not take anything to begin with :)

It would be much better to not have to watch stable constantly like we
currently do - we're seeing people report breakage often enough to be a
concern as things are, we don't need to be trying to pile extra stuff in
there because there's some keywords in a changelog or whatever.  The
testing coverage for drivers is weak, increasing the change rate puts
more stress on that.

--GdbWtwDHkcXqP16f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7wsdwACgkQJNaLcl1U
h9DAWgf+LXkPTWA3Nc4TkIaUcPd+6AtboLQyyP/9/zEkyr2ajDpxQXLudemBDlSm
kHTVki/gUcoz35AYQ5Hz9grJOzflY0Md4GMge23a8MOKyI4vG/bPkDU1cB0Ui9nz
g6HpTo9KGjOtwUMrL8EOOukvy87Uq9UdfSbffIWDLo8o/RiicXsc+on+Oso9NXdZ
mTI5atdoy6lseE9eaYxGrgmetAytq7nmr79/UBBVIh2WMxgqZjNHE360hUJx8HSQ
O9TUmrx7VKViCZxIhSW0DnJz0ArHTqJ6E/kdsoy6OaM4PkGUGup9xqLe3eHoaFqp
OvEHOplFor4XKOgt1n2JicJP6G+Wrw==
=xyNh
-----END PGP SIGNATURE-----

--GdbWtwDHkcXqP16f--
