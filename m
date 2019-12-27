Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3775812BBA7
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 23:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfL0Wog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 17:44:36 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:34700 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfL0Wog (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Dec 2019 17:44:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tzJQU5CSSV92rINpY/mBKDQersZHZBVAVKXDHAdiH5U=; b=Y4GGwVEetsd9jF2EYMdVo/6g2
        tF4pFXNp7fct+mrZxeQYF2J1wA0CIvDnLXzVoYZ12n+BXqkcElhg9w7gMGgtW+2lXUozNLqDoN48U
        NCgA5kSLqNndH+oQWjlb70VizzVSFsMRViiSYtFy2Qx8cF3RSvpPeAn1P1PA4uYnc/fug=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1ikyLO-0006aP-Sc; Fri, 27 Dec 2019 22:44:30 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 4557CD01A22; Fri, 27 Dec 2019 22:44:30 +0000 (GMT)
Date:   Fri, 27 Dec 2019 22:44:30 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tzung-Bi Shih <tzungbi@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.4 006/187] ASoC: max98090: exit workaround
 earlier if PLL is locked
Message-ID: <20191227224430.GO27497@sirena.org.uk>
References: <20191227174055.4923-1-sashal@kernel.org>
 <20191227174055.4923-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="keoAwTxaagou87Dg"
Content-Disposition: inline
In-Reply-To: <20191227174055.4923-6-sashal@kernel.org>
X-Cookie: I have many CHARTS and DIAGRAMS..
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--keoAwTxaagou87Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 27, 2019 at 12:37:54PM -0500, Sasha Levin wrote:
> From: Tzung-Bi Shih <tzungbi@google.com>
>=20
> [ Upstream commit 6f49919d11690a9b5614445ba30fde18083fdd63 ]
>=20
> According to the datasheet, PLL lock time typically takes 2 msec and
> at most takes 7 msec.

Same here and for the other max98090 patch - once things are
fixed it'll be OK.

--keoAwTxaagou87Dg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl4GiU0ACgkQJNaLcl1U
h9BNywf+Mf20LwkW7rRkBz/u2G2iLzxF0Wo4sLcbhkGSwAPl7O28cPQetnnlSd5Y
jpB6WIuBihSRTrI6omXQKXJo7Iq/ROijkzZ96levBTz8gBZNr1qF4lEsDTd91UpA
fxvqXTmY4drZUTHEXg8oY3KhSsmqA5M0PwbgBZnqP2JwS3rxOOfVWe8QGRuy8m3L
G2rwkoSCW07Fv4O6uQRkcZWHPZCP+oZsaOet5JHPR2619m5qQmB1pM4sWoFeiTGS
tNSCYLP0WeFSqgXAS1s37OcFDMmter0Lu4ROAHNo+ezuRj8m7vwoID7iVetqL8u4
FfBUai/6Gp6ISvEUwTbRenV/T4CfZw==
=micy
-----END PGP SIGNATURE-----

--keoAwTxaagou87Dg--
