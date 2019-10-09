Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A33D1367
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 18:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731426AbfJIQAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 12:00:37 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:48268 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIQAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 12:00:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZkEZaeUG2LDB7osCCzA5SGc46/Ti4vNDPD35O8V/wEU=; b=fRSoG5IPBwTlf8+/uwewnaoO2
        PPQAsKxb3vydNdYfAmppcADKDWbo4O4IFN7Cb7o6wx2ZXI3BWi+soz5OkrNa/QbPb+2dFqQkwGhLU
        aSdjW9JvtHnotZOkP5i9r5Mp6oiT008KhxfV6TPVeVGY9XJjAVNVQrbmDgrQpx8euT7Ig=;
Received: from 188.29.185.136.threembb.co.uk ([188.29.185.136] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1iIENy-00059v-Ow; Wed, 09 Oct 2019 16:00:22 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 97E72D03ED3; Wed,  9 Oct 2019 17:00:21 +0100 (BST)
Date:   Wed, 9 Oct 2019 17:00:21 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 0/1] [for 4.4/4.9] VAG power control improvement for
 sgtl5000 codec
Message-ID: <20191009160021.GI2036@sirena.org.uk>
References: <20191009142822.14808-1-oleksandr.suvorov@toradex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yqoYZO0eSM9FLp66"
Content-Disposition: inline
In-Reply-To: <20191009142822.14808-1-oleksandr.suvorov@toradex.com>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yqoYZO0eSM9FLp66
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2019 at 02:28:36PM +0000, Oleksandr Suvorov wrote:
>=20
> This is a backport to stable kernel versions 4.4 and 4.9.

Please don't send cover letters for single patches, if there is anything
that needs saying put it in the changelog of the patch or after the ---
if it's administrative stuff.  This reduces mail volume and ensures that=20
any important information is recorded in the changelog rather than being
lost.=20

--yqoYZO0eSM9FLp66
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2eBBIACgkQJNaLcl1U
h9AbxAf+MlzUGC3a6HyTWNrYD7RjNIuqO5iMIsQXvmAOjQQaQcKxIokPtRdZ0DQF
hm0TpNMj97hj0LUvY8P17SP3CJcSJbfsj+ikz2gRL4C1dTmwEIYpeUzvt2ujR58r
mxqx612RmrOalJymH6BKYjw6NUElAjIvO9+bHWCjww3PzfMNj4y9WLZoA9v+BENa
eHNBLuay5ropZOJqhMc6GMNi9EKGnONc1wxw9bFVMGfGK7FiVB9MCOYoeMGVDjvh
5hjeiSmi41giMyjsOQ1NQPtbTW6ymSmT2VPSBEkbulwO0B2oz35hrI9J/JWJmxHh
RofXuI2v8EOT61r3XR7bevxA8PxT8g==
=Psvc
-----END PGP SIGNATURE-----

--yqoYZO0eSM9FLp66--
