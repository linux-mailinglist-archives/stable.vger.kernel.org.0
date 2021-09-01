Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4878A3FD720
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 11:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243428AbhIAJpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 05:45:30 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34941 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242789AbhIAJpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 05:45:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E9435C0211;
        Wed,  1 Sep 2021 05:44:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 01 Sep 2021 05:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=ObGIxgtavz3gno3t76LBvmoj5Ql
        2fJX6NjBj+UThj6Q=; b=fD9vSbiQMjsju5Wr/6YMldqR0dR7nVHim4kMKlkpg6e
        N/ddGyhhZs7fQOS46tNWmUZvVhrJRwuj5C1DGlqdF4XjYnL+EJ/13Kgsi4m9O6/E
        Qu1JHnkKlgykl1gBYgGHzjaly7yN4yQgkqiMRaVk4iGeRg7H5RfRi2oRrrjeJaWh
        ntH7ve8skERGo5Kn1Ju9i028n2WWnUSq2D1N2j2NDFWryNAxxCt0DpvpjSjACqcC
        2WngnQ0ZRtEJTQrw7gs3MCZcadQ5UwZ4M0sPTcSoAhVzwNaqbpt7kqymUIB5lZOW
        0nrYtHCLkx6A8okEnYzRVAEMFfOozKKIdzPlA9WnfBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ObGIxg
        tavz3gno3t76LBvmoj5Ql2fJX6NjBj+UThj6Q=; b=Kf+ltLw9cRH78lTyx0wdM0
        +wXcWBGj3THi5181qi7Z/j5L2e0Omvf1dNrNjnf2Cv4wEIIbeT8/jGm6QZoCPjXd
        yzRQUwNeUgq9I8wLNkP6l09eVakoyzbHvyltddc3wANztx+AW4M9pAWzberFmF7J
        X8IVj990Agr2L/6CQaR3kON1bjTCo75RCMOIfJsiOEtwEXhd8p4lB5s2Vr8kWr16
        eqVvfWrIFSBgoVhzAaTbiy8xsPV1ShYdBGszZVzA83VibdaJNvJZ6/WVU00p2N4Q
        2kL83GgVm/EfAvf+NusQINP9AwHLtxM014jWQpsaNzvL+a5yVvWRrQJAm5p6oZwA
        ==
X-ME-Sender: <xms:gUsvYeFG3KDBUrpUOEtB3pgzpdq6Jzo1DJo0xMRpbUXCe0FnNewUSA>
    <xme:gUsvYfVv2iI5SR4no5M8O_bOPlUEsJL85kRKdU-q5vnK_A9Jw1c0GAHfvi3H002CP
    QDC0fP8JakWfA7Jjoo>
X-ME-Received: <xmr:gUsvYYIh1Lr603A8LAfwA1NGWEooOukZOnOaCP5-CIQHP5OPSAEiNR33FwsJEWYKDmlmg0piabrD9j_oqbAm6sZfEPv0PIAyjGIy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepmh
    grgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:gUsvYYF8KAdQeuXI97NPjWwpeX4Lb95ZiyZ4GVBgOyti-aKyM1XdXw>
    <xmx:gUsvYUWtSE1e3WWp3NqcvkhDLZ7RAMg2-ffVkGI7lEn_MWtZXRLdEw>
    <xmx:gUsvYbNgIEZLky4TK0swAZXMC9H9_Xc6qloa6AgWw_4VPYZC3q2fNw>
    <xmx:gUsvYYputj4KvjXaczmNAbCZw9J_IaHArtPVAn-vX4Q5RqZFPUf7Ng>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 05:44:33 -0400 (EDT)
Date:   Wed, 1 Sep 2021 11:44:32 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Roman Stratiienko <r.stratiienko@gmail.com>
Subject: Re: [PATCH] drm/sun4i: Fix macros in sun8i_csc.h
Message-ID: <20210901094432.5kc33m2bnmkbjahq@gilmour>
References: <20210831184819.93670-1-jernej.skrabec@gmail.com>
 <CAGb2v67TNrkeP438t3nLcquFvGTfS+F0MvBmGAS=qmZ5JZFmag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jscf64iuvdbjnile"
Content-Disposition: inline
In-Reply-To: <CAGb2v67TNrkeP438t3nLcquFvGTfS+F0MvBmGAS=qmZ5JZFmag@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jscf64iuvdbjnile
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 01, 2021 at 11:13:01AM +0800, Chen-Yu Tsai wrote:
> On Wed, Sep 1, 2021 at 2:48 AM Jernej Skrabec <jernej.skrabec@gmail.com> =
wrote:
> >
> > Macros SUN8I_CSC_CTRL() and SUN8I_CSC_COEFF() don't follow usual
> > recommendation of having arguments enclosed in parenthesis. While that
> > didn't change anything for quiet sometime, it actually become important
>=20
>                              ^ Typo
>=20
> > after CSC code rework with commit ea067aee45a8 ("drm/sun4i: de2/de3:
> > Remove redundant CSC matrices").
> >
> > Without this fix, colours are completely off for supported YVU formats
> > on SoCs with DE2 (A64, H3, R40, etc.).
> >
> > Fix the issue by enclosing macro arguments in parenthesis.
> >
> > Cc: stable@vger.kernel.org # 5.12+
> > Fixes: 883029390550 ("drm/sun4i: Add DE2 CSC library")
> > Reported-by: Roman Stratiienko <r.stratiienko@gmail.com>
> > Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
>=20
> Otherwise,
>=20
> Reviewed-by: Chen-Yu Tsai <wens@csie.org>

Fixed the typo and applied, thanks
Maxime

--jscf64iuvdbjnile
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYS9LgAAKCRDj7w1vZxhR
xQCQAP4rfWKEyPEnTNdnRgDKYsiznnq7wZw/kcJzMyysWVHTCAD/Th6T6Tj85KFX
yNQia6HiL+VmJWmGWJtFXjh0G495iwc=
=nV88
-----END PGP SIGNATURE-----

--jscf64iuvdbjnile--
