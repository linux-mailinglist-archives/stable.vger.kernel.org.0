Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C5C3605F0
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 11:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhDOJgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 05:36:20 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:60857 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232367AbhDOJgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 05:36:19 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2021 05:36:19 EDT
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id F103D10F3;
        Thu, 15 Apr 2021 05:26:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 15 Apr 2021 05:26:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=PtaPMljBD2boZ8zdNUtTMi1M1Dx
        Oz641bQ2OhBoGMjo=; b=qZJm9bq/q8pqEMr1PDT01gAsiPjumU/BRbuKfpekYpj
        L2DrcagM3UtPSpGEOJw5YaUcMFU9PZYvgLxKCtg1dFp7u5CYxVJDLjzgHBEnD68B
        a+xbxwkyg5Pvou6eHzz+TTFRWf+Ikc4/skKbyGDeVUnUlsMzVftQM3Dju9oJepjZ
        bWn1Sq3R34YmpKSn/0cu6PpfvP8AO5MJHozjLPD7NslF4nnrD+RyS+c5yiWKczAj
        agJ0b2b+dvoLeE+cfqu1d5pL1E3SjKLyk68qXIKO4srq+rwmH2orMWqdEk+69yTB
        YLZIy0koG/H1+tAnTYTlWKoV5ASAhfyI9L/Vk/ezp7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PtaPMl
        jBD2boZ8zdNUtTMi1M1DxOz641bQ2OhBoGMjo=; b=rdruuGFMfbwZsnv/OifYg6
        eF1id0DgmV4ZuqeJ79qlIhTYgdyozjLarNrFq4lOc1Z+yTmv/ItRvPB4o/PZG/nj
        VVTfAj4EAw1CTOtKMWkD/a0C/BcNG90N1hu1oegDHA0ECuETV8oRPzgYo8tiFMXe
        /Bl9elVSYyZzl3osUDfmeWzZhKx5XCFvgJBvwg5aWYw0YqM3vjUPknRWfXC32H1J
        T+C8gqEzp2WUvD4b+84KY/plhPLjbMapTKXeh0EQqQ0pqmfHw7YJ5ss5eT68U9ya
        DZZD2LBtT5lb1leq6vHw3MQNoACTYO/LKmVkx9kiNgLNgqv4QAoDC3k6QeKbiCmw
        ==
X-ME-Sender: <xms:ywZ4YLVEyFbZdE7VindQd54P70eLLG1KZjhhVEbjn05WA6KRUsp4Gg>
    <xme:ywZ4YH3UAM-_BraEqDdmPGpqsDRaos5L-ij__R0qkxs0wChUq2XKgOGnzVtmwbpEL
    Xvwmq4BKwZyy_BfzIM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelfedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepleekgeehhfdutdeljefgleejffehfffgieejhffgueefhfdtveetgeehieeh
    gedunecukfhppeeltddrkeelrdeikedrjeeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepmhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:ywZ4YCa0Ke0eotrSX1S8ssua1fQKjj3JefXX5Slst5mcRUmPisSRXg>
    <xmx:ywZ4YKrhooip1bTHf-TtoaOk3xp1RAbhgkfFmohB0NJfWKDv9ZDbcA>
    <xmx:ywZ4YOpwZNHX7a20ucRaRhiw4JnOmwFsL3Zkt8HFZK4q6fuWlUGzyg>
    <xmx:zgZ4YGwMvDYgXzWoQomG1WFrp3MfFBgBN_jPYXQdp28hAcMgWDwhw66AdRE>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23E0424005B;
        Thu, 15 Apr 2021 05:26:35 -0400 (EDT)
Date:   Thu, 15 Apr 2021 11:26:33 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Simon Ser <contact@emersion.fr>,
        Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/ingenic: Don't request full modeset if property
 is not modified
Message-ID: <20210415092633.4vkteqmqqxfgrjxz@gilmour>
References: <20210329175046.214629-1-paul@crapouillou.net>
 <20210329175046.214629-3-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rbolhufisrxhasd4"
Content-Disposition: inline
In-Reply-To: <20210329175046.214629-3-paul@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rbolhufisrxhasd4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 29, 2021 at 06:50:46PM +0100, Paul Cercueil wrote:
> Avoid requesting a full modeset if the sharpness property is not
> modified, because then we don't actually need it.
>=20
> Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
> Cc: <stable@vger.kernel.org> # 5.8+
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/gpu/drm/ingenic/ingenic-ipu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/ingenic/ingenic-ipu.c b/drivers/gpu/drm/inge=
nic/ingenic-ipu.c
> index 3b1091e7c0cd..95b665c4a7b0 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-ipu.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-ipu.c
> @@ -640,10 +640,12 @@ ingenic_ipu_plane_atomic_set_property(struct drm_pl=
ane *plane,
>  {
>  	struct ingenic_ipu *ipu =3D plane_to_ingenic_ipu(plane);
>  	struct drm_crtc_state *crtc_state;
> +	bool mode_changed;
> =20
>  	if (property !=3D ipu->sharpness_prop)
>  		return -EINVAL;
> =20
> +	mode_changed =3D val !=3D ipu->sharpness;
>  	ipu->sharpness =3D val;
> =20
>  	if (state->crtc) {
> @@ -651,7 +653,7 @@ ingenic_ipu_plane_atomic_set_property(struct drm_plan=
e *plane,
>  		if (WARN_ON(!crtc_state))
>  			return -EINVAL;
> =20
> -		crtc_state->mode_changed =3D true;
> +		crtc_state->mode_changed |=3D mode_changed;
>  	}

I'd just change the condition from

if (state->crtc)

to

if (state->crtc && val !=3D ipu->sharpness)

It's going to be easier to extend if you ever need to. Also, drivers
usually do this in atomic_check, is there a specific reason to do it in
atomic_set_property?

Maxime

--rbolhufisrxhasd4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYHgGyAAKCRDj7w1vZxhR
xbrVAQD22j4BtDq6oO5iGWb7UdC+qPz36k0/YBh5BRbQ5qyf2gD+KYIoom5pUNBU
kg6Yl77CjwRcM0x0V2Ylhu7QwgWEpwA=
=U0dV
-----END PGP SIGNATURE-----

--rbolhufisrxhasd4--
