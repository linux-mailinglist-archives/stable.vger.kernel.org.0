Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191CBBBB32
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 20:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbfIWSW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 14:22:56 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:42518 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfIWSW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 14:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bAM4CSVbzV0vZ0pXGxDrI5dK05r42EGdRkewL3qJKB4=; b=L02ahr1eXKpBw8NCRfILxV97x
        3mm4hd1byFCUn8tOx6I7NX/EwHWSB++P7HTJP3XPAzc6J+9lbbVa7mw1IXRx7door5oViC0dSUm21
        evu2kBGDAlH8ev9xd5tLZhS8k3bM4PuIroZ27Knm2x4yXdN56jJHFqFFvVHQI7fppTWhE=;
Received: from [12.157.10.114] (helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1iCSz5-0004Wn-W8; Mon, 23 Sep 2019 18:22:52 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 48C8DD02998; Mon, 23 Sep 2019 19:22:50 +0100 (BST)
Date:   Mon, 23 Sep 2019 11:22:50 -0700
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Katsuhiro Suzuki <katsuhiro@katsuster.net>
Subject: Re: [PATCH AUTOSEL 5.3 173/203] ASoC: es8316: support fixed and
 variable both clock rates
Message-ID: <20190923182250.GW2036@sirena.org.uk>
References: <20190922184350.30563-1-sashal@kernel.org>
 <20190922184350.30563-173-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WkmTq0Xj5pNQBic9"
Content-Disposition: inline
In-Reply-To: <20190922184350.30563-173-sashal@kernel.org>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WkmTq0Xj5pNQBic9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 22, 2019 at 02:43:19PM -0400, Sasha Levin wrote:
> From: Katsuhiro Suzuki <katsuhiro@katsuster.net>
>=20
> [ Upstream commit ebe02a5b9ef05e3b812af3d628cdf6206d9ba610 ]
>=20
> This patch supports some type of machine drivers that set 0 to mclk
> when sound device goes to idle state. After applied this patch,
> sysclk =3D=3D 0 means there is no constraint of sound rate and other
> values will set constraints which is derived by sysclk setting.

This is a new feature and clearly out of scope for stable.

--WkmTq0Xj5pNQBic9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2JDXkACgkQJNaLcl1U
h9Dp7wf+MIAr6TsZDQrcehy+HNi7BJlZPWx6oxifo4xxvgugWou0IB7MkrqhVq2s
fr5qlDKKi47Sbl+sZNtu8LfMZbmD6YW3GBC5srcgTSyn9hMsHWPgDJBxLN495Otm
B5VFn5LwyyK+376tXeoWlXXx2L/7OCmW0fpfJK7cQ290tz7zeRya6Vw6fKrP69hs
n6FgoAplZPoceSOTNXg3AofsrfVS1MrLHN9MU2GgX6JMEFaXyf3B9G5qX/7KfNfy
nI1VHrW/FEmb6nwgWsoh4ot3f19q6lsUjY9T8QbwIXlp7xTVdH0kjXidfA3Zuv2n
R+rIGfl2eQwXmPv6gW9R0qG0YC+Vkg==
=z+Z1
-----END PGP SIGNATURE-----

--WkmTq0Xj5pNQBic9--
