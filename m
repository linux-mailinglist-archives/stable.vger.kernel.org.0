Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A368DBBB2C
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 20:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbfIWSWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 14:22:06 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:41084 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfIWSWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 14:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XXgV7GdpmgrRQlQQcHSeBjZLF84UP9XKc48/jnVV6SI=; b=bu2aAu+YXPhQH48WDuTnDrOVX
        IghH+dZIbly1gCKvFJq7zLQCauDtFzTTy/xOxU4CrKWqmizv3So3IZdOwrE7aTNGmE6Dzr+yns/yJ
        lwrhdhjrhQOV0B8sOq5ogFWFKgAGUk23tzhA4ue9aLrhdv2cS4BW/FXnofBW34V1bu57M=;
Received: from [12.157.10.114] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1iCSyH-0004WT-Q4; Mon, 23 Sep 2019 18:22:02 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id A53DFD0218A; Mon, 23 Sep 2019 19:21:59 +0100 (BST)
Date:   Mon, 23 Sep 2019 11:21:59 -0700
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiaxin Yu <jiaxin.yu@mediatek.com>
Subject: Re: [PATCH AUTOSEL 5.3 087/203] ASoC: mediatek: mt6358: add delay
 after dmic clock on
Message-ID: <20190923182159.GV2036@sirena.org.uk>
References: <20190922184350.30563-1-sashal@kernel.org>
 <20190922184350.30563-87-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GvlH2BAVfmx8aXCn"
Content-Disposition: inline
In-Reply-To: <20190922184350.30563-87-sashal@kernel.org>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GvlH2BAVfmx8aXCn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 22, 2019 at 02:41:53PM -0400, Sasha Levin wrote:
> From: Jiaxin Yu <jiaxin.yu@mediatek.com>
>=20
> [ Upstream commit ccb1fa21ef58a2ac15519bb878470762e967e8b3 ]
>=20
> Most dmics produce a high level when they receive clock. The difference
> between power-on and memory record time is about 10ms, but the dmic
> needs 50ms to output normal data.
>=20
> This commit add 100ms delay after SoC output clock so that we can cut
> off the pop noise at the beginning.

This might mess up a production system, please don't backport it.
In general delays to eliminate pops and clicks that are part of
the PCM statup path (as opposed to DAPM) are not safe to
backport.

--GvlH2BAVfmx8aXCn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2JDUYACgkQJNaLcl1U
h9Cfjwf/fbkShV8/UolzJ8PGsV1OdUCT+bsh5Q5GlcvcZu/2l/l1tV6XvaHwI8c6
orAex5tPUCGIiJ1hBdJnwp9T44OL7on8a3leXh1tsQt/4aPuI+XFm5n2EUrsKGRe
tSG+vOEC0zoGa1mfci8LLtSVL8xmABYz/Umi/EbmVqDJhfQT+yX1yTocAl5x7yhz
aSnifbJ4nuOLdwlXeuMPnIVa+MJhP6dsglPd32fEeET8pOuPAEP0/SyeD2Zumzcp
oXO+NcQq4o4btSdNY6miy9i/lYtv7f4CI/i4Jo78/Kl2BUVL/zfOTbNvCxNAEUsB
ZA84mwXstsAh+I9gwkJ9wxjlLGUqvQ==
=7zoR
-----END PGP SIGNATURE-----

--GvlH2BAVfmx8aXCn--
