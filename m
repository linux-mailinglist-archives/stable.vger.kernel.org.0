Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6172D9EB8
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438890AbfJPWAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:00:48 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:58558 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438880AbfJPWAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 18:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vOolftVE+qMqQMtVfiOgnK134546bxeJQI56LZcIM4Y=; b=JIZS0pOfsM35l2T2m3tPecjkU
        5x0txi2yPRR7W6Yb32egobpzdKl7EB1yQe7Xo/OcVmV2Z+ETuX2ZLrF3jVrFj/I10JS3hEhfRTTmZ
        BcQuZCZy/4vPKE7l69HWnF15UcgyhIcv3nXqi2o/C4ry4+92wO21xyQlOQJUT1j5W9ejM=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iKrLY-0006LQ-Vt; Wed, 16 Oct 2019 22:00:45 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 315FC274325C; Wed, 16 Oct 2019 23:00:44 +0100 (BST)
Date:   Wed, 16 Oct 2019 23:00:44 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Message-ID: <20191016220044.GB11473@sirena.co.uk>
References: <20191016214844.038848564@linuxfoundation.org>
 <20191016214907.599726506@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <20191016214907.599726506@linuxfoundation.org>
X-Cookie: Auction:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2019 at 02:51:44PM -0700, Greg Kroah-Hartman wrote:
> From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
>=20
> commit 694b14554d75f2a1ae111202e71860d58b434a21 upstream.
>=20
> This control mute/unmute the ADC input of SGTL5000
> using its CHIP_ANA_CTRL register.

This seems like a new feature and not an obvious candidate for stable?

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2nkwsACgkQJNaLcl1U
h9Bwqwf/Y3vqzCq3ZLL8G8eg/PcXEoN/fRuR/9k7vBB9oXwFP7JJqyF9zJxjsTqt
rfSquWWXQs7C7IkSIZqluLCmSNrypHYVTW7x2DQKkLDPdj2QHtg34egE8rCRkOB5
i4qZKsiQko8F7lIa3a95DwAdAY3Z4esLIGbFxgD2GgV9w/xiRCqa4tby5WPMKv1N
EmLNuuo0l42HFEENWF34xVRuPUhBuvu2xKA7OeGo0vv5hl8igoWqmdS9sH3889gP
2m2DS1proiwGlxmi1tpXipVmaj4KLumK4qyvviJjea0fjrW89TtbKH+K3bC8HewU
KYXmxPHEGwJ2uLJ8OFcyqzKketb2xg==
=fCKq
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
