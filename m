Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E845EA10
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfGCRHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 13:07:52 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:44292 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCRHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 13:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4eaUjlGIh2ae11eaOiVm5gdPPuQ5PSi+Agb5MdWcY7c=; b=Sl9TtrMVk5jHRJO6Tm1nDhQxN
        Jy8RqRzuX9yRj9bDAwC3iT79dhs1UkCnaNVfFhZqWdURFTgyyP6Mgajg5078j2C7i8Y4xCzM4yqyb
        swRRM3inGJL5aenRDHMvMtsv+yIBkTxlGTskktyUrlenJELKT7j1x0llldKmZmOpuTK3E=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=debutante.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpa (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hiijR-0006vj-7N; Wed, 03 Jul 2019 17:07:45 +0000
Received: by debutante.sirena.org.uk (Postfix, from userid 1000)
        id E21EB1128FB2; Wed,  3 Jul 2019 18:07:44 +0100 (BST)
Date:   Wed, 3 Jul 2019 18:07:44 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Georgii Staroselskii <georgii.staroselskii@emlid.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH AUTOSEL 5.1 11/51] ASoC: sun4i-codec: fix first delay on
 Speaker
Message-ID: <20190703170744.GB3490@sirena.org.uk>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-11-sashal@kernel.org>
 <20190626103741.GU5316@sirena.org.uk>
 <20190703142047.GX11506@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <20190703142047.GX11506@sasha-vm>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 03, 2019 at 10:20:47AM -0400, Sasha Levin wrote:
> On Wed, Jun 26, 2019 at 11:37:41AM +0100, Mark Brown wrote:
> > On Tue, Jun 25, 2019 at 11:40:27PM -0400, Sasha Levin wrote:

> > > Allwinner DAC seems to have a delay in the Speaker audio routing. When
> > > playing a sound for the first time, the sound gets chopped. On a second
> > > play the sound is played correctly. After some time (~5s) the issue gets
> > > back.

> > This is inserting a big delay in the startup and might disrupt some
> > production system.

> But that would be a problem upstream as well, no?

There's a difference between a problem that gets introduced in normal
development tracking upstream and something that gets dropped into a
stable release, we don't want people deciding that stable is something
they can't just take en masse without really looking at what's in there.

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0c4OAACgkQJNaLcl1U
h9CWYgf+Jnwet2KcfLZTzlj/yyDEIF75VsnK1s60xns9FE+7EMVYDdOANMQ3nM4t
ghRs/y65BPCnV9RX81DiWefJyw2axtXSdhGLnnifg7NFMuSSgzSajTEVr+IzT7J5
v2dTHvpq1DHHL9Vd+Ma4WqAYmtg5sHbMlSjtLi3DnZM4C7JEZ/N5OalA92wNyfCU
iUnW9tuoJuycWJ7bhL5xAeRRMa05sq+ElrbnnnvOu1X02qTHn8UWtw1Zo4w5HRti
i3xVF7qBPXAoHQAl5pLq0JocrDWoyptA82jVe/n9zKke7xlEuzAhrlDAErP/qSHw
5I5+NWPQLtcl2UBTLwbpwr3xGPyTQA==
=68IP
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
