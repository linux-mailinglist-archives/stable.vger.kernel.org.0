Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDCC203592
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 13:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgFVLXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 07:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729892AbgFVLXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 07:23:34 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 992FE20716;
        Mon, 22 Jun 2020 11:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592825004;
        bh=lKPO9e624hVOJb9ys3y9YhyfWRz6FABHB2gyDaZqj2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rMxttB7FzTiHJEa3tbN3WPIxJHrnt0u8SEYPYobsr7cEH3VUpxi+DC7EAYV+F1X4l
         8QFmz85HHyuh+539leKlpPpSOYSEf3r8Spfs8V/djIJZCuNccky7F0Xl0iBTosnKqA
         kGowYb1JP0oSedLkJKguEaO6QduxXMYsGqSEVmGM=
Date:   Mon, 22 Jun 2020 12:23:21 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 004/388] ASoC: tegra: tegra_wm8903: Support
 nvidia, headset property
Message-ID: <20200622112321.GB4560@sirena.org.uk>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-4-sashal@kernel.org>
 <20200618110023.GB5789@sirena.org.uk>
 <20200618143046.GT1931@sasha-vm>
 <20200618143930.GI5789@sirena.org.uk>
 <20200621233352.GA1931@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20200621233352.GA1931@sasha-vm>
X-Cookie: laser, n.:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 21, 2020 at 07:33:52PM -0400, Sasha Levin wrote:
> On Thu, Jun 18, 2020 at 03:39:30PM +0100, Mark Brown wrote:
> > On Thu, Jun 18, 2020 at 10:30:46AM -0400, Sasha Levin wrote:
> > > On Thu, Jun 18, 2020 at 12:00:23PM +0100, Mark Brown wrote:

> > > > This is a new feature not a bugfix.

> > > I saw this patch more as a hardware quirk.

> > Pretty much any DT property is a hardware quirk :(

> Which is why we're taking most of them :)

That's concerning - please don't do this.  It's not what stable is
expected to be and there's no guarantee that you're getting all the
changes required to actually make things work.

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7wlKgACgkQJNaLcl1U
h9DxBQf9GXl9yCwJEINWq/Z/dhvqydIs7W9lZH5AwwYXFPMJqBw8hFXOc0py8n1n
KyNasLuU3f6KllPb0/5OVx13fx8zGxkO3R+oGlO3Efu7Hy8PGBKDUCvSN3ot0Y/D
G63LKSioz3J8TW/YESn7D1sIHgBeomqhnaXeqeXv3CvcOzSwNrxo7XEFdFezSfby
QMKNjitxBVEiU5JiuuhpWhQ3A9f0bsNONgYLXX/j2nUFF2GTaoVqqAeuVHJsRtvY
AxfBsxyFqe85oe6t6oelQ5DoiQTkEJYKTGpApxIby0uOXAoo2PgF4slrPeEqa+ZS
tp+7ng+EvDqFhLMnHiZq1WTtbV02bw==
=kpI5
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
