Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E8F5548D6
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbiFVL5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 07:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbiFVL5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 07:57:42 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FCC3D1F2;
        Wed, 22 Jun 2022 04:57:40 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 959DC5C0378;
        Wed, 22 Jun 2022 07:57:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 22 Jun 2022 07:57:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1655899059; x=1655985459; bh=EDZINAL0dh
        ot/5O6dbWbEFDkXIECpYf2fk3aenKmV6k=; b=bSvUVjyTHbR5vn/+n2sdvpDCjD
        H29wGGKn+fs4zjKtmiErj9NRDgi0x7lP/cVQo6OgsVzG0hV6GMjJ0TvdvA7y0mdG
        j792Fo1YnHyFNIfXUAZe5LGcjxHOdCvSi8+n3MYewqGC5nLTK0vRbsIv6jy6p71r
        QlZ+zVPVObId12j3Je0zfH8JY598ZSuzVgnJuL4vpAUmckPXYM3yAZkeUP2rz1vR
        Qwg5E0c9Ar2G1SFCGS9RuQLok3dBkO10WQKYNDidGKKiDYWyVY0uFO75SjMP5htr
        wnNJAZswW5HizI8VkZr+UtUMmRpZGPvYGNO+dwVwCwkqBOa9K/AW1QSjzeFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1655899059; x=1655985459; bh=EDZINAL0dhot/5O6dbWbEFDkXIEC
        pYf2fk3aenKmV6k=; b=MHerYSMF1AmZB/bD9DOu7ptexDtjiOveuP0WJQ1c395L
        7KvnNcYokIJN9u6GAUg7XMHREBf5mr5QhWwe/vwocshnyvga31cnEDhpFeRiUape
        y/DFvI11vBBZK4wGo0CMyPIqJa1G/qZOac4E4iNtcYCLN8PxFeerl+2nhorU5iy8
        pe3bwub8C+ramWsinv3PNTSQoo+rCdchTeKrHLJc/u4FF83rsgxGSTQTzvQ+7ljE
        gJJE8rG8BzOGphE8dA3hXb2QsWXyuNHm0aHtQ2M+49Wd+7IR6xPmN0GOnpQ2fPJB
        bNLgWwuKmvjwhHvBgJNcc1Lh24UXduXEDpQ6rROkrQ==
X-ME-Sender: <xms:swOzYhi8okQfdJdzUW-FBJgFRxi3grHENjCwAGw3Lo_QApcvjwPnBw>
    <xme:swOzYmDCXeyoW8ULkeXopUO5DKfxvanJmaLrBUQNqdzlwqkizF098dz5tjuPJD6Km
    BQmEfn5gPtFZJv2t9U>
X-ME-Received: <xmr:swOzYhFbbkjsRuP0QWb6312eJKijSUnTR7kE04BUfNoGkUZnj56yb0seIXhGdGhrupymlGtEL4CMvkoz2YGJ3ZwBZDdhCbxzcwoBW7M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudefhedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtvdenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpeetfefffefgkedtfefgledugfdtjeefjedvtddtkeetieffjedvgfehheff
    hfevudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:swOzYmR4XfO87KjovWHMYW2kNkhaxL-EO0EZa-bXKJuhOsDKUrH1lQ>
    <xmx:swOzYuzeaYnLwFoHWwoEo79mXNxA13juS4omoKUf68Bscivck7RxOA>
    <xmx:swOzYs6O0ko4WNy3ctmwVpsCj5eMdkJtly1zkwH44Et6QzoxhzOyGw>
    <xmx:swOzYtkpHhwPaRCY_how9p1IWXUCDaMqL_i37flYYfEo-bVFe_hCBw>
Feedback-ID: i8771445c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jun 2022 07:57:38 -0400 (EDT)
Date:   Wed, 22 Jun 2022 13:57:36 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     drawat.floss@gmail.com, airlied@linux.ie, daniel@ffwll.ch,
        linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jani.nikula@linux.intel.com, ville.syrjala@linux.intel.com,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/hyperv-drm: Include framebuffer and EDID headers
Message-ID: <20220622115736.yr7wjqvwpxvl2scf@houat>
References: <20220622083413.12573-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bmfhgomxypr4cpai"
Content-Disposition: inline
In-Reply-To: <20220622083413.12573-1-tzimmermann@suse.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bmfhgomxypr4cpai
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2022 at 10:34:13AM +0200, Thomas Zimmermann wrote:
> Fix a number of compile errors by including the correct header
> files. Examples are shown below.
>=20
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c: In function 'hyperv_bli=
t_to_vram_rect':
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c:25:48: error: invalid us=
e of undefined type 'struct drm_framebuffer'
>    25 |         struct hyperv_drm_device *hv =3D to_hv(fb->dev);
>       |                                                ^~
>=20
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c: In function 'hyperv_con=
nector_get_modes':
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c:59:17: error: implicit d=
eclaration of function 'drm_add_modes_noedid' [-Werror=3Dimplicit-function-=
declaration]
>    59 |         count =3D drm_add_modes_noedid(connector,
>       |                 ^~~~~~~~~~~~~~~~~~~~
>=20
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c:62:9: error: implicit de=
claration of function 'drm_set_preferred_mode'; did you mean 'drm_mm_reserv=
e_node'? [-Werror=3Dimplicit-function-declaration]
>    62 |         drm_set_preferred_mode(connector, hv->preferred_width,
>       |         ^~~~~~~~~~~~~~~~~~~~~~
>=20
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 76c56a5affeb ("drm/hyperv: Add DRM driver for hyperv synthetic vid=
eo device")
> Cc: Deepak Rawat <drawat.floss@gmail.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: linux-hyperv@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.14+

Acked-by: Maxime Ripard <maxime@cerno.tech>

Maxime

--bmfhgomxypr4cpai
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYrMDsAAKCRDj7w1vZxhR
xVKHAP4+fghoYl/e6tA6tIITV3ihFjhSsVHXohssoD9H/fngoQEA3Cvk0TKKwmlg
zNItzz6F6hBwWuO4+XuRUDPZh0ACuQw=
=wMzT
-----END PGP SIGNATURE-----

--bmfhgomxypr4cpai--
