Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0454B20B254
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgFZNRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 09:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgFZNRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 09:17:36 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A51620885;
        Fri, 26 Jun 2020 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593177456;
        bh=vkelFOVnFjMTXUYQJxXew2YEuFERJumCUSH/x5AGopg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LUziYN2OGQrJzVosp5gAtanwzmPqma2S/TH+TGUwpE7vOHp2EpWgj4D7sggEe8DwC
         c+rMhnTcJ00hERom1xbJcZGAHHfx1uuBELsIGcWEmmeFONu2lOuXHVL16vUjHe8/q0
         CA7q7CqJiJigNYTAvsmGy25Jus2nNsiJj2sW4UCU=
Date:   Fri, 26 Jun 2020 14:17:33 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 003/206] ASoC: tegra: tegra_wm8903: Support nvidia,
 headset property
Message-ID: <20200626131733.GA5289@sirena.org.uk>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195317.089299546@linuxfoundation.org>
 <20200625190119.GA5531@duo.ucw.cz>
 <20200625194516.GH5686@sirena.org.uk>
 <20200626124741.GA29721@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20200626124741.GA29721@duo.ucw.cz>
X-Cookie: You can't get there from here.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 26, 2020 at 02:47:41PM +0200, Pavel Machek wrote:
> On Thu 2020-06-25 20:45:16, Mark Brown wrote:

> > The documentation is an issue (and another thing that probably ought to
> > block stable backports...) but the lack of usage is totally fine, there
> > is zero requirement that DTs be upstream - this is a stable ABI.

> I'd expect stable for fixing known bugs, not really for "someone out
> of tree might be using old kernel with new dts".

I don't think this is suitable for a stable backport, or that we should
just stop calling this stable, I'm just pointing out that there is never
any requirement for any DT stuff to have in-tree users.

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl719WwACgkQJNaLcl1U
h9D9Sgf/dkS1oKv/2PkmFqFG6GqYdmTZqIHLz1Ieq3rw4jIj7z4/5kXVScgkXGUx
maCKUbhf5k10JlyY9LSmZprRAeIQAKsoHxq712e19BTlESSFzmOj4bOon+TVUBhN
THP3+Y4VW3aau1/vxRWe9DS2hEu5TkOf1JhrUjMdxtb0nh2TNfVup1JFMHdXpVJw
rJ7lj1Og7scE0qzB+tzwe2H/F+kz9AMi8CKsRzwLgOUAVSWIuhxeq3ZJsoXbdI9C
R9qmpxn52UsidiFNqm5DYTtjFy+eoGwNcvx0KPw681i+robnjio2teTrY2/b8mBS
imW8dBnZ31ggaENJbIXIkCclDYoIqQ==
=XNAd
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
