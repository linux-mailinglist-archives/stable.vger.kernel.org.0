Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A79566FC
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 12:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfFZKir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 06:38:47 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:46982 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfFZKiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 06:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mLe70bOHRoHREYcixEc1iuvMjBR5uAVQxRoxXvlAR5Y=; b=lt5AwQwZIYUsuWU3FKwDcz9zI
        N7MuB1m//cd5VyGQeW/ZDB6/Bg0BSQBnuQLqgy8O6GSG1CcwOlx/9mtuVt+MKLCAUjDPMoFMadT5h
        XqbPDBq6OOAyVEtlV9PqY6T0Z48PNPko87EB+t/mxnVZYjcqlbJARkTipAtrmJlZf1sz0=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hg5K8-0007lD-AM; Wed, 26 Jun 2019 10:38:44 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id D5C2A440046; Wed, 26 Jun 2019 11:38:43 +0100 (BST)
Date:   Wed, 26 Jun 2019 11:38:43 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tzung-Bi Shih <tzungbi@google.com>
Subject: Re: [PATCH AUTOSEL 5.1 31/51] ASoC: core: move DAI pre-links
 initiation to snd_soc_instantiate_card
Message-ID: <20190626103843.GV5316@sirena.org.uk>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-31-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VuNaACpQBNTJaEiM"
Content-Disposition: inline
In-Reply-To: <20190626034117.23247-31-sashal@kernel.org>
X-Cookie: Editing is a rewording activity.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VuNaACpQBNTJaEiM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2019 at 11:40:47PM -0400, Sasha Levin wrote:
> From: Tzung-Bi Shih <tzungbi@google.com>
>=20
> [ Upstream commit 70fc53734e71ce51f46dfcfd1a1c319e1cfe080c ]
>=20
> Kernel crashes when an ASoC component rebinding.
>=20
> The dai_link->platforms has been reset to NULL by soc_cleanup_platform()
> in soc_cleanup_card_resources() when un-registering component.  However,
> it has no chance to re-allocate the dai_link->platforms when registering
> the component again.

Again, are you sure there's no dependencies?

--VuNaACpQBNTJaEiM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0TSzMACgkQJNaLcl1U
h9DE5gf+K3+2C2SD++rtiCNWWKvRWYnLT741itL+WfND0JnhN2iLLislldBQHwNY
JdhBCCWZwn/GsPlEekgek2TCjF6w4kw9YuszXzMWa/6Irdzb2TBMK6rBRsOWvjBe
NKmjGhmngYEpUL1eO2ITEz+A1pS1EIeux9S9AfoyvDF7AVy2tbAMb/XCbghwgSn0
HfIDPWXrrGJU3n3bZVqnvcV2jmsSmd6WFN1JrY2jtMfmR7BB6SqUW5FGfZFnzCsf
0I662XhouioPrhDFaTcY83k2Vu3gzG+1/50XLvzXMWlLZLsNZ5D8vIQJEhEj9N6y
PAU6ipn93D98UDx0eMA6xKnju3tXJQ==
=jGaQ
-----END PGP SIGNATURE-----

--VuNaACpQBNTJaEiM--
