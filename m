Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F5FFD117
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 23:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKNWph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 17:45:37 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:39064 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKNWph (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 17:45:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VBWSxyqFNu57a211AegG4LgleE/has5MXudCMHIozs4=; b=up5DdfD/1x/hAHbiXVOVPlRfP
        NPuQjpXURVaBXynlhBNx3/LW7UvG/N9gVE5hcrGPKpV1CNS7+Latc0RbONtqvZmyy8m9Cm2o9BSHg
        SE6ywZHp4ILU7svhX+iDbhSLFdcjJ74xMvLJ+GrLSPS5f8iPzqC5wyxrJSgoL+DO3TNJI=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iVNrD-0007jQ-8S; Thu, 14 Nov 2019 22:44:55 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 566CF274328B; Thu, 14 Nov 2019 22:44:54 +0000 (GMT)
Date:   Thu, 14 Nov 2019 22:44:54 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jacob Rasmussen <jacobraz@google.com>
Cc:     Ross Zwisler <zwisler@google.com>,
        Jacob Rasmussen <jacobraz@chromium.org>,
        linux-kernel@vger.kernel.org, Bard Liao <bardliao@realtek.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ASoC: rt5645: Fixed typo for buddy jack support.
Message-ID: <20191114224454.GD4664@sirena.co.uk>
References: <20191114190844.42484-1-jacobraz@google.com>
 <20191114214301.GA159315@google.com>
 <CAPZ+yN+EP=ffzWDz4hWZ3W=usDoYt7VFKaoMAgzvjo7WL_jW=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Content-Disposition: inline
In-Reply-To: <CAPZ+yN+EP=ffzWDz4hWZ3W=usDoYt7VFKaoMAgzvjo7WL_jW=g@mail.gmail.com>
X-Cookie: Santa Claus is watching!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 14, 2019 at 03:43:32PM -0700, Jacob Rasmussen wrote:
> On Thu, Nov 14, 2019 at 2:43 PM Ross Zwisler <zwisler@google.com> wrote:

> > On Thu, Nov 14, 2019 at 12:08:44PM -0700, Jacob Rasmussen wrote:
> > > Had a typo in e7cfd867fd98 that resulted in buddy jack support not being
> > > fixed.

> > > Fixes: e7cfd867fd98 ("ASoC: rt5645: Fixed buddy jack support.")
> > > Cc: <zwisler@google.com>
> > > Cc: <jacobraz@google.com>
> > > CC: stable@vger.kernel.org

> > Need to add your signed-off-by.  With that added you can add:

> > Reviewed-by: Ross Zwisler <zwisler@google.com>
> Signed-off-by: Jacob Rasmussen <jacobraz@google.com>

I'd be more comfortable with this if you could repost with the signoff
and the patch in one mail.

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl3N2OUACgkQJNaLcl1U
h9AMRgf7BSP5AIvGA9TnvKf2VoXlRlNS8DrafSXItt9h4X1RVJgmcCFoF+W9AZrL
2UM5V9NfuB0A+PsVYWTdUWbIvDYrBRb4NecaaYJvEa7XVL+dtvOLrqGZcANn/Trr
lnqwHZhMrHyIRPWXjCdWuM6XymaC8n31ptGJH+OJ6/QJBvwiM/HvMBVPNjFczuU3
1NOVR4shUdS83vqRTWzqNOwQaOfRbSxlG8OH1de0inLiqDXM+4BN6T2BabBfTelI
f/JnxMOvQBaIAnjN2hsY/f4Q3acDof1btff0hSLSH25wOKeUtrWq3MRt6H94CkbJ
1T0d6DDwjKphYDn6J9ijVUWO5pOi+A==
=SPvm
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
