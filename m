Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2AEADAB2
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 16:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405142AbfIIOEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 10:04:25 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:59264 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404997AbfIIOEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 10:04:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NMGAZ2kso2CJvMMFlGWgyiOLFbmHpsfQY9TMalmQTQI=; b=HaVEIgzOh4ofkQ5vWoDixXQBW
        x4qLygbbGZYUKO25bDxUNn96y8DMZpE+kQRqMEVEEw0P0rZGCQk4am5hYpJp1kQ0vTvyRyO5aY3W8
        OsrldiI6krdp5Pleof99z8J2hbkQ1djy+u0ifSPwHM4de2Kewvzu7i0jnCu4sRk0OnDaA=;
Received: from [148.69.85.38] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i7KHC-0002bF-TQ; Mon, 09 Sep 2019 14:04:18 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 42CC1D02D3E; Mon,  9 Sep 2019 15:04:18 +0100 (BST)
Date:   Mon, 9 Sep 2019 15:04:18 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     Andreas Kemnade <andreas@kemnade.info>,
        Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Nishanth Menon <nm@ti.com>, vireshk@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] regulator: twl: voltage lists for vdd1/2 on twl4030
Message-ID: <20190909140418.GH2036@sirena.org.uk>
References: <20190814214319.24087-1-andreas@kemnade.info>
 <CAHCN7xL4K+1nJDXDRs7yVi6LhGL-4uPu9M+SN1dcOPu8=M8s2g@mail.gmail.com>
 <CAHCN7xJ0RmRQwo3bSF6FoLjOtrg5YZAMD9+=332LMzLLR1qdDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3VRmKSg17yJg2MZg"
Content-Disposition: inline
In-Reply-To: <CAHCN7xJ0RmRQwo3bSF6FoLjOtrg5YZAMD9+=332LMzLLR1qdDA@mail.gmail.com>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3VRmKSg17yJg2MZg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 09, 2019 at 08:32:06AM -0500, Adam Ford wrote:

> I am not sure who the right maintainer is, but as of today, cpufreq
> for users of twl4030 on 5.3-RC8 is still broken without this patch.
> Is there any way it can be applied before the final release?

Ugh, this affects cpufreq :/  I hadn't realized, sorry.  At this
point it's probably a bit late to get it into the release, but it
is tagged for stable so if it doesn't make it in it will be in
one of the first stable releases.

--3VRmKSg17yJg2MZg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl12W98ACgkQJNaLcl1U
h9B5Egf/RSjS9nKNpgdxDfA8C+vwvwNwsFjhjR9RlJ2MbT2bQhFOeDiV/x6bYOJS
97B50GiDQ/srWPPpvHfFQDhYVrlbBFPuBVYxD8HcpvXvEooKdyKvsrarPxgMSxn0
hqrWt0DaPWjlhQRqs9PIMZctl+92QT2+YtA40uF2xbESgYOr1GSP76vPJrph/gS2
woFz8MjXyZL8bHtRv7vGhJem61Fcm8CjRZFWLX3h5B4k7mAKH1W5gZWoB2PaZicD
7+X9001/NbA1xirpe2cdUkwnjPJ6xfHqYQcm2kT233A4X57q88Et4l0rYFG3nqJp
2BHnXooXkmnlQHLXs2kgZuTxldDSZA==
=UEcM
-----END PGP SIGNATURE-----

--3VRmKSg17yJg2MZg--
