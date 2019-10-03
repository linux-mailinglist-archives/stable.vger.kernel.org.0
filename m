Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D45CACC3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfJCR24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:28:56 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:45960 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729919AbfJCR2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 13:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Wz+eQC+UzzXMO3cj6KoEK+ua1IHt4po3SKhJunCXvhM=; b=aAHu99PJWJmhLCkdoetR5x6ta
        87wZuBvCNTp9yc+7nwoM+YWCKCDYIZUwaQ/0RjdY3iyYUXe06VD2IPAG+SZCbM8T1GTA9ib9tqwlK
        A0eCQqyz59SwSrd9q69UHO0jaXLnFKH9eed5iy6fa6pX0oOIughCg4D02AdwUXiYYuork=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iG4uI-0005un-5I; Thu, 03 Oct 2019 17:28:50 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 6B72B2740210; Thu,  3 Oct 2019 18:28:49 +0100 (BST)
Date:   Thu, 3 Oct 2019 18:28:49 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.3 204/344] SoC: simple-card-utils: set 0Hz to sysclk
 when shutdown
Message-ID: <20191003172849.GB6090@sirena.co.uk>
References: <20191003154540.062170222@linuxfoundation.org>
 <20191003154600.389003319@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <20191003154600.389003319@linuxfoundation.org>
X-Cookie: Reactor error - core dumped!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 03, 2019 at 05:52:49PM +0200, Greg Kroah-Hartman wrote:
> From: Katsuhiro Suzuki <katsuhiro@katsuster.net>
>=20
> [ Upstream commit 2458adb8f92ad4d07ef7ab27c5bafa1d3f4678d6 ]
>=20
> This patch set 0Hz to sysclk when shutdown the card.
>=20
> Some codecs set rate constraints that derives from sysclk. This
> mechanism works correctly if machine drivers give fixed frequency.
>=20
> But simple-audio and audio-graph card set variable clock rate if
> 'mclk-fs' property exists. In this case, rate constraints will go
> bad scenario. For example a codec accepts three limited rates
> (mclk / 256, mclk / 384, mclk / 512).

This is a new feature which seems out of scope for stable - I thought
I'd raised this already?

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2WL9AACgkQJNaLcl1U
h9CewQf/XkRvV56xTjFgd5erQO5OFt76kRZB7GSNctBEKI0RZ1HDaoQJ9tDirQpn
OaDgs8oshhyKspmUZVZUwjMJeMGD4IH4iTAZEq3CPMNuOpN866sWT6vXCy0iwIJT
+OXYW79Wox1bTRrqV4GNMYdM8DDCk0CKiQ0rmhjYcsiKzVwW5q0kx73D382oCEpS
v+XvC4eSN+VJJWN9eAwgCAZGM85LWu2IfpQJEmXM7e0BqhCLmw5rdmysA+wYPqYS
PLFt1wka73AKlZ6mfFw5jA3yLoQa6lOw+ZFgdfXu0loJggRdhAfasHXlYPmJZOZG
c0qf0Bq6P+IgU0Ot6T9mBoHb3VQTfw==
=Goot
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
