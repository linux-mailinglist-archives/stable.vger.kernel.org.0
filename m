Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91FD20B1AB
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 14:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgFZMrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 08:47:43 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:60712 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgFZMrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 08:47:43 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B0C7B1C0BD2; Fri, 26 Jun 2020 14:47:41 +0200 (CEST)
Date:   Fri, 26 Jun 2020 14:47:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Mark Brown <broonie@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 003/206] ASoC: tegra: tegra_wm8903: Support nvidia,
 headset property
Message-ID: <20200626124741.GA29721@duo.ucw.cz>
References: <20200623195316.864547658@linuxfoundation.org>
 <20200623195317.089299546@linuxfoundation.org>
 <20200625190119.GA5531@duo.ucw.cz>
 <20200625194516.GH5686@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20200625194516.GH5686@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-06-25 20:45:16, Mark Brown wrote:
> On Thu, Jun 25, 2020 at 09:01:19PM +0200, Pavel Machek wrote:
>=20
> > This property is not properly documented, not it is used anywhere.
>=20
> The documentation is an issue (and another thing that probably ought to
> block stable backports...) but the lack of usage is totally fine, there
> is zero requirement that DTs be upstream - this is a stable ABI.

I'd expect stable for fixing known bugs, not really for "someone out
of tree might be using old kernel with new dts".

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXvXubQAKCRAw5/Bqldv6
8nUDAKDCfj4CzLnARNdPCbIDmArFawtemACgtdBHmcgQoDcxc9mCxyxcdUryPUk=
=cndZ
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
