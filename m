Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411785ED30
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 22:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfGCUIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 16:08:24 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:37208 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfGCUIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 16:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=95ySJca7aDUHQfVnY7n0PFU5PPGDK2zcemrI1diRXqk=; b=tC/yluJ0ITBF4AboY3FTStid/
        hDYojrKIXGFGG1/Vl8g89LSNKae9YlbKIa6gB/lQ/ONWiF6k12rm+JfkvxOTpH1iSohhj4wkDbo19
        DNLB76el6SpDdynxANYg7ugiVXE+RNLjpbvvkz1b4Nmz9aWmUkfb9eaXxJC+Y4kchkHuU=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hilYA-0007AO-Sn; Wed, 03 Jul 2019 20:08:18 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id 182BB440046; Wed,  3 Jul 2019 21:08:18 +0100 (BST)
Date:   Wed, 3 Jul 2019 21:08:18 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Georgii Staroselskii <georgii.staroselskii@emlid.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH AUTOSEL 5.1 11/51] ASoC: sun4i-codec: fix first delay on
 Speaker
Message-ID: <20190703200818.GX2793@sirena.org.uk>
References: <20190626034117.23247-1-sashal@kernel.org>
 <20190626034117.23247-11-sashal@kernel.org>
 <20190626103741.GU5316@sirena.org.uk>
 <20190703142047.GX11506@sasha-vm>
 <20190703170744.GB3490@sirena.org.uk>
 <20190703181005.GB2733@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ggEtdcIX3XIOBw6T"
Content-Disposition: inline
In-Reply-To: <20190703181005.GB2733@sasha-vm>
X-Cookie: This sentence no verb.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ggEtdcIX3XIOBw6T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 03, 2019 at 02:10:05PM -0400, Sasha Levin wrote:

> Sure, but I don't see any work upstream on trying to correct this?

There's nothing to do to correct it, it's a normal thing that
might happen in an audio system.  Probably users on the old
kernel who are bothered by it either did a local kernel change or
inserted a delay at the application level.  Correcting it again
separately will double the delay, the problem is changing it
affecting system integrations.

> These sort of things are a reason why users stick with the same kernel
> for years, which is what we'd like to avoid.

Domain specific knowledge can be helpful...

--ggEtdcIX3XIOBw6T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl0dCy8ACgkQJNaLcl1U
h9CIdwf+JU0ifEXpdltuikrRRWLLmTkfjleFoPsOeFhqfEPnOLFZLHfM/q/sfz84
1n2U81kmwzv6nyKihLXyf9ykFhI8jJ2gshiSsDJjqwFbP7/qy0QwDSUkDaq8rbw7
npyN9rFybW1UnD9rBYNsuRRcAs8Q0chv6ifHdInIKVLwe09L8JeqSpisxlOlWL3u
kpMzXkHF8Ut+vpsBTlqSa/IZ640o1z+GjZIMClXpDWS68iWDAlBB+o4cT5W3sMcg
NfH0m6PQLoHaE07HArpBIyAO0Aw3GFtqFRB7MAGW0Vmhrw4TAH8eLxHm+2PkRCS7
TzTAYV3eJgRBAiA8aIpsLzIgJldsrw==
=6g13
-----END PGP SIGNATURE-----

--ggEtdcIX3XIOBw6T--
