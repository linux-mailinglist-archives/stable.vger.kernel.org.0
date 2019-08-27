Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3790A9E631
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 12:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfH0Kyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 06:54:35 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:37846 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfH0Kyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 06:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9qktllCdtWjxEHtE8pHlyd4rtHjdGpGQjQOP1g/TPOs=; b=TPJ1X3+JKBtnR3HtNFbYdvEsI
        1FHLsfNGMTMIgopVPWK2uGBsUcafRJt5PRLALEIEe/VhNWnEVf4qbkgx7iWwBDAEA9inHC8WPBDA9
        0cQ1b1JbzKv8UQnoJoNA5hn685cx0xK5TjqLrYjo0rXC8bppOKoTUm141+W2h4im+3wwU=;
Received: from [92.54.175.117] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1i2Z7O-0007uc-Kp; Tue, 27 Aug 2019 10:54:30 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 46D4AD02CE6; Tue, 27 Aug 2019 11:54:30 +0100 (BST)
Date:   Tue, 27 Aug 2019 11:54:30 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>
Subject: Re: [PATCH AUTOSEL 5.2 022/123] ASoC: dapm: Fix handling of
 custom_stop_condition on DAPM graph walks
Message-ID: <20190827105430.GC23391@sirena.co.uk>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-22-sashal@kernel.org>
 <20190814092052.GB4640@sirena.co.uk>
 <20190826013342.GF5281@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cjVziHhGDpplWqiR"
Content-Disposition: inline
In-Reply-To: <20190826013342.GF5281@sasha-vm>
X-Cookie: Don't SANFORIZE me!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cjVziHhGDpplWqiR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 25, 2019 at 09:33:42PM -0400, Sasha Levin wrote:
> On Wed, Aug 14, 2019 at 10:20:52AM +0100, Mark Brown wrote:
> > On Tue, Aug 13, 2019 at 10:09:06PM -0400, Sasha Levin wrote:
> > > From: Charles Keepax <ckeepax@opensource.cirrus.com>
> > >=20
> > > [ Upstream commit 8dd26dff00c0636b1d8621acaeef3f6f3a39dd77 ]
> > >=20
> > > DPCM uses snd_soc_dapm_dai_get_connected_widgets to build a
> > > list of the widgets connected to a specific front end DAI so it
> > > can search through this list for available back end DAIs. The

> > The DPCM code and its users are rather fragile, if nobody noticed a
> > problem I'd worry about causing some other problem to manifest by
> > disturbing things.

> Doesn't this patch imply that someone noticed it?

During new development.

> And if not, it'll just break when folks update their kernel...

> If it creates other problems we should address them now rather than
> later.

Well, if we don't touch anything hopefully everything will
continue to work just as well.  DPCM is a bit fragile so I'm
nervous about backporting stuff without people actively working
with it paying attention to the backports.

--cjVziHhGDpplWqiR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1lC+UACgkQJNaLcl1U
h9AxoQf/Q46Ql9GZfDxAAKQC9wcjQ+pBcOS1yBYst3p354FqEfA2OwuEjuobwP7M
p94eSGmfdVqPCZed5jCdB15k0TjpdrB7ms3ACw8dNKW4H7MCUUGjw9HfItc0sB9E
VXa1ZschrV55MeZfpKVmNSDzAMlqs0R1BtlNR+yYWpDw8yLMP5O2xDLXEbe5rKz9
ig9d4b88N90tslYwOQSJAyTLR3wyAkYAKhLkBpjP8B/0kWfELlk4k2R30wgAFr4C
ssdE3NZSjscpogP8Ftt1uc+Qq7uuggLQl5vBRjy9wSXHiWBBR3wGFd69QADZUcEo
0jMA/EDXJBAn3vKH6Bk2XSi+Yhkkmw==
=xQzC
-----END PGP SIGNATURE-----

--cjVziHhGDpplWqiR--
