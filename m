Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660F414FCF9
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 13:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgBBMAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 07:00:42 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:57004 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgBBMAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Feb 2020 07:00:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/8I4PJVyzRO2zKgNQXcEsMEOQYRmKEwmQb/+v3+hXck=; b=cO/wD8KUbcDx253Djn0XRFYqV
        8iCdytlEdwJ3NUWSoQWdd3Gt3nbkUEWl16iWqag5vIkEg/XoPHuEz/Lo7Zk84ICR3goILfGSOhlLu
        CsRrpJQZCNsSGNa5CAcJLS54EI8zau9xQK6Gt9RgdKw4prliZAKBar4IdVoLdgSY0I8+8=;
Received: from [151.216.144.116] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1iyDvT-0006pm-EH; Sun, 02 Feb 2020 12:00:31 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id BF079D00E4A; Sat,  1 Feb 2020 11:27:37 +0000 (GMT)
Date:   Sat, 1 Feb 2020 11:27:37 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Dmitry Osipenko <digetx@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ASoC: tegra: Allow 24bit and 32bit samples"
Message-ID: <20200201112737.GS3897@sirena.org.uk>
References: <20200131091901.13014-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Wty5iWagpjJlozQq"
Content-Disposition: inline
In-Reply-To: <20200131091901.13014-1-jonathanh@nvidia.com>
X-Cookie: Programming is an unnatural act.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Wty5iWagpjJlozQq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 31, 2020 at 09:19:01AM +0000, Jon Hunter wrote:
> Commit f3ee99087c8ca0ecfdd549ef5a94f557c42d5428 ("ASoC: tegra: Allow
> 24bit and 32bit samples") added 24-bit and 32-bit support for to the
> Tegra30 I2S driver. However, there are two additional commits that are

Please submit patches using subject lines reflecting the style for the
subsystem, this makes it easier for people to identify relevant patches.
Look at what existing commits in the area you're changing are doing and
make sure your subject lines visually resemble what they're doing.
There's no need to resubmit to fix this alone.

--Wty5iWagpjJlozQq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl41YKgACgkQJNaLcl1U
h9C48wf/XDYc+rP2dIu/vZ21qwktMH3XJC7y6d0I2npbH96AkZTpWmJd1Xni6LMO
X9XDm6w29xXEQvMvkQ+p6n7q74ZdCwfwNgHdPujzyQNEY33uSWkQ+gFzFyDKrec7
EGgzNKoCogdGHBTu6SED3em04EGbLIulAi2qwOd5jJ8ZCXErpBqUvwvFBRx9qQmK
Fy2RivEzWysEXqYe/Icsn4wVgZ4Nm5vyNQDEDkiigGKISdDMYqS5Y3W2Yg43Mpx/
KfLeQqxI7JZ3rodqfkpksVuzzhdvT/nyWuU46TOXyri4WhQMI75HewY/ZFKzQ9R0
38NCD8W5/kRbbfv8Y8+x8j423SX3dA==
=yaIF
-----END PGP SIGNATURE-----

--Wty5iWagpjJlozQq--
