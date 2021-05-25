Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0233903DB
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 16:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhEYO0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 10:26:00 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:47330 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbhEYO0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 10:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QbUs3FwUWEWx4dGbr2cU2AbRI9rmpLzqSQAYDeVh5UE=; b=Z9EkHLsFyLIuOeS/emwGDwlHe0
        PGbpf6gZ4rT694iKYXWr7t2+epWCgNGaOgbgzVksAFPuBp/CcfC4rsJ8+yPzSa6YiTfQfOoiXNeJ2
        fTknSt8V9aBq1pzWcSLshWu3ZapmlPIQg7pg/N3ijeCNepGUtEI1RBU6/L/2A3l0kppc=;
Received: from 94.196.90.140.threembb.co.uk ([94.196.90.140] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <broonie@sirena.org.uk>)
        id 1llXcM-005kzZ-C1; Tue, 25 May 2021 14:01:10 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 5F39CD0045C; Tue, 25 May 2021 15:01:40 +0100 (BST)
Date:   Tue, 25 May 2021 15:01:40 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.12 30/63] ASoC: rt5645: add error checking to
 rt5645_probe function
Message-ID: <YK0DRL1hXkWnIjOA@sirena.org.uk>
References: <20210524144620.2497249-1-sashal@kernel.org>
 <20210524144620.2497249-30-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2wMylynYITqWoqAf"
Content-Disposition: inline
In-Reply-To: <20210524144620.2497249-30-sashal@kernel.org>
X-Cookie: The wages of sin are unreported.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2wMylynYITqWoqAf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 24, 2021 at 10:45:47AM -0400, Sasha Levin wrote:
> From: Phillip Potter <phil@philpotter.co.uk>
>=20
> [ Upstream commit 5e70b8e22b64eed13d5bbebcb5911dae65bf8c6b ]
>=20
> Check for return value from various snd_soc_dapm_* calls, as many of
> them can return errors and this should be handled. Also, reintroduce
> the allocation failure check for rt5645->eq_param as well. Make all

I also don't have this commit and can't see any sign of it
having been submitted upstream.

--2wMylynYITqWoqAf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmCtA0MACgkQJNaLcl1U
h9Dfbwf+KaMar+1CO8920nxRtUJqzucHBUts1+0EjlJ++ZLVnGMX2G9HDslPDRwb
GPmS/4xmpbFo2WZtJjfxhh7JxHMUDUALBUaduCen8x4TlrErtQxxn4cdJ5TszAnB
mdiq38gg2ZY0zlA8nt48SkbcO/96EtcwS62Kj0KSsv3aiGI2czPRDCN3B3CIS+nb
Gralf+WmT6RdGUcHdXBA9LZulaGi4iWGQKaJmhZEoZqXyE/LWkbTSCR/aUSlMqxs
a+l68zxxp96/xYjBIj2+8k0AIG2nPGfBisn18BJflMqUO6UCXVWy7EQ/Ipgf4NnA
IYGQQTaQdve9dRRN04g+4oC2nItgwA==
=7W8q
-----END PGP SIGNATURE-----

--2wMylynYITqWoqAf--
