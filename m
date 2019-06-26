Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D694256623
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 12:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbfFZKDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 06:03:21 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:43726 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZKDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 06:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FPvFLLA8MN96j+d5H7n9B6cwEZmrNu7OG+BAlemz/vk=; b=MICod8o9GgkWFisGDFFD8cz9L
        tg0CH2i4aL9bBCTAO6fHGqe+SpksMZsoh1GF02yXjWoTHuumfxdBbJcJyTYuT4B2oH81jNBVrCb6C
        EkdS2AHhEl1wPPmxFBxwrjKNA0EyxyTtFzSztjFHXtQ4/MpHpRIgCGHswRt7vuSDwUkek=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hg4lp-0007jO-9L; Wed, 26 Jun 2019 10:03:17 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id 323A3440046; Wed, 26 Jun 2019 11:03:16 +0100 (BST)
Date:   Wed, 26 Jun 2019 11:03:15 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.1 07/51] ASoC: soc-dpm: fixup DAI active
 unbalance
Message-ID: <20190626100315.GS5316@sirena.org.uk>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-7-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cAMdxM7kFS4+ma4H"
Content-Disposition: inline
In-Reply-To: <20190626034117.23247-7-sashal@kernel.org>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cAMdxM7kFS4+ma4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2019 at 11:40:23PM -0400, Sasha Levin wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>=20
> [ Upstream commit f7c4842abfa1a219554a3ffd8c317e8fdd979bec ]
>=20
> snd_soc_dai_link_event() is updating snd_soc_dai :: active,
> but it is unbalance.
> It counts up if it has startup callback.

Are you *sure* this doesn't have dependencies?

--cAMdxM7kFS4+ma4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0TQuAACgkQJNaLcl1U
h9AGaQf/ca5ttDVtH3yylwRgoWhhXfiZhmDr7wPKNubOOkK95zHodT6b1dJI9/pp
AngHuYrXElP7chx17dGANkzHif+y8u2YGSJ9TEWkwnE7OnyQc0XGIw0ItQpmCCjA
SsAW/Q0QVuZfDTaEePsu85j0u3bX4prb3TlDudopWqRajpyOYG/PSKSwrHTlf7aa
dj+5j16e5Lp/J0VuLd+scZg5drtudGF6VIEAXlwXmZmrnZjJxABVCo7/qfqpHY49
jJurqN8wxytqeAk9LkFDywdl+K57IYa8LOqiMSUodgjt4CxxzTn7P3+uFfq2Pgyk
INd476XUzgj/QRKDSP/wpjIL7eZfYw==
=awWS
-----END PGP SIGNATURE-----

--cAMdxM7kFS4+ma4H--
