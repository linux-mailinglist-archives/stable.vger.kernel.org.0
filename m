Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 122B35C0FA
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 18:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfGAQSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 12:18:07 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:35758 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfGAQSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 12:18:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6L/tQQxfuMuPU6Ah9rMNBCpNvZISFMW8+8uGSmy7GjM=; b=p6FZEAfHJaN7A76fQOI5LTBiV
        eIZtl8IFtuH2l8DTDHoGT6lt35leXxiKKuWD2fS0S0FfzFtyQD2Py9EyEN9VTfoVn0bX0fLUwV1Ss
        MoiHOr09WM94NdI2xS04vWvuGfWhJjBi/QwyNLWCqdm6/85sbASswp/w3K/lJKs5D3QnI=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hhz0E-0001iA-O7; Mon, 01 Jul 2019 16:18:02 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id DBB63440046; Mon,  1 Jul 2019 17:18:01 +0100 (BST)
Date:   Mon, 1 Jul 2019 17:18:01 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.1 07/51] ASoC: soc-dpm: fixup DAI active
 unbalance
Message-ID: <20190701161801.GD2793@sirena.org.uk>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-7-sashal@kernel.org>
 <20190626100315.GS5316@sirena.org.uk>
 <20190627002059.GN7898@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
Content-Disposition: inline
In-Reply-To: <20190627002059.GN7898@sasha-vm>
X-Cookie: This sentence no verb.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 26, 2019 at 08:20:59PM -0400, Sasha Levin wrote:
> On Wed, Jun 26, 2019 at 11:03:15AM +0100, Mark Brown wrote:
> > On Tue, Jun 25, 2019 at 11:40:23PM -0400, Sasha Levin wrote:

> > > [ Upstream commit f7c4842abfa1a219554a3ffd8c317e8fdd979bec ]

> > > snd_soc_dai_link_event() is updating snd_soc_dai :: active,
> > > but it is unbalance.
> > > It counts up if it has startup callback.

> > Are you *sure* this doesn't have dependencies?

> The actual code seems to correspond with the issue described in the
> commit message, so I'd think not.

> I can remove this patch if you're not confident about it.

I'm not entirely, no.

--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0aMjkACgkQJNaLcl1U
h9BuvAf/ZDm6L36jMsP1TA7VcGMotEV+DWVKIaD4g3xr08GBpdX4re+bvy57pciJ
eH/zLnx2Ho9A8Dxx0uWbaKFtXrgnl5AB03DckfNhjPkTpfxnjhy8kBJNEyolkuQ0
8TEpnSCnx99PNeqIkE9ihJFb8nFa3xY1xOfIX1Hj6tPdJX++lBp4oamtlBbkg0jY
YQlgqvtyif3CqDZBi/FlDU9jOzPR29r/B3MbBuOxAZuCFFcdKVsofZKSlGEXtBbd
UqoLUNC9EvLZGbyEwC0S6O+5u0trDoATIgtYwApjUtN9fgdQSliBBblA1ESoZDjk
9HBf1LZw8Ej/e69eXBLsTDNmR2TfDA==
=I5pz
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--
