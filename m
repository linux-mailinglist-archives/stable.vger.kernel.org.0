Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D9634D408
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhC2PgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 11:36:17 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58871 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231332AbhC2Pfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 11:35:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4A48B1805;
        Mon, 29 Mar 2021 11:35:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 29 Mar 2021 11:35:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=kofpni9LHJyfoAVFAxd5HEtYVIK
        sHiMa+Wxaf55fK4g=; b=Y9U9r2ccQLGi5aSRjxH4q2VCLeY7mIPjZ4EqeF8/UMj
        elrNFA7cmpMF3a5zFI8DCLMV7E0QHX7v8/+4T3ojuSGTjI7RJKeENtqIuNo7qLmb
        gV/pA6CLwxNA1JSM2LT1BHDYmjqtVrDctqsBlVexpEGLqPRvti2KLAUw7Y9A8SfA
        qVvNSNPPW0afmOQ0gQXOyZdi02cutmCucV5w3BMjwCPTy1cjkaC5fOt/+A69x0Ev
        DpAVfeyPNcrDPjS1TtBHqBt5N1a6tVL2yBbb0PyZ9wLSei1CK/jiSQYOcfjOiVGV
        Sy90QNTUQEmsIOTlygTzfhYxO78fG63ciJ3KVXWGTBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kofpni
        9LHJyfoAVFAxd5HEtYVIKsHiMa+Wxaf55fK4g=; b=BgaYflm3a8yffYmMloF7VQ
        aRh2XmhOHawWxMWdvEZjQ9p31sbIiakSqKyeaRmp387QCbo/4EBxQMzbjmtiRmXq
        OKFUmKLqmEloSQbdqkP14xdWgi9rD54RyjssdyJjcW3DWub1xWqvwVR/A4lh307a
        5BU3hMv08x6o7W5PX9oNUdIHkZYRTdJu3xd6wFuZiTnu1f6kq5KxYZNhlhCMKbUs
        WzNmxlTemQtFDCh8mXqaAZfC8ez5NtZNUGsomahzANjzJgKPcL+asFS7dsTqnMgq
        3UMs0COQSD4TtThgqx+y+/vwWFQzzIgqNXH4zUrGozHlyZgecR68vhSSAAQK7G9Q
        ==
X-ME-Sender: <xms:0PNhYKRmLIQ5Z-18l3qbTJEdlWye460xvVlgpdTev4lRyze22at9Dw>
    <xme:0PNhYPuMxGq1koGV-6iPFOQALNHYQNgV6It92F_v2_x_MdHjx2R_NbeThATVp17wD
    dWFuAFKp8nuP_QYYSE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttddunecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepjeeuieelleeivedvhfdvjeetledvtefhleejjeeiueejjeeileevudeftddv
    ledtnecuffhomhgrihhnpegsohhothhlihhnrdgtohhmnecukfhppeeltddrkeelrdeike
    drjeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    mhgrgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:0PNhYEt-4k6Vvv9BrsB4f9K5OwOuPNaWY-aMVcJwQCeNbZyRd3jqHg>
    <xmx:0PNhYNwUtky4AC7qacLTCrU17duhRjfwFoTqE8IaNiTQE5LjW7ohlA>
    <xmx:0PNhYCiTE1K-F5deCIymelW503ZEiNncitzAUP6r7kPDze5QaHBXcg>
    <xmx:0fNhYC0RsgjHQRZO9o9qwmKsQGCZYnmHCwxUSM1p20loH74EFB42BA>
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16348108006C;
        Mon, 29 Mar 2021 11:35:43 -0400 (EDT)
Date:   Mon, 29 Mar 2021 17:35:41 +0200
From:   Maxime Ripard <maxime@cerno.tech>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Simon Ser <contact@emersion.fr>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm: DON'T require each CRTC to have a unique primary
 plane
Message-ID: <20210329153541.a3yil2aqsrtf2nlj@gilmour>
References: <20210327112214.10252-1-paul@crapouillou.net>
 <20210329140731.tvkfxic4fu47v3rz@gilmour>
 <S1LQQQ.K5HO8ISMBGA02@crapouillou.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ox5m2kdae4pdeh7p"
Content-Disposition: inline
In-Reply-To: <S1LQQQ.K5HO8ISMBGA02@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ox5m2kdae4pdeh7p
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 29, 2021 at 04:15:28PM +0100, Paul Cercueil wrote:
> Hi Maxime,
>=20
> Le lun. 29 mars 2021 =E0 16:07, Maxime Ripard <maxime@cerno.tech> a =E9cr=
it :
> > On Sat, Mar 27, 2021 at 11:22:14AM +0000, Paul Cercueil wrote:
> > >  The ingenic-drm driver has two mutually exclusive primary planes
> > >  already; so the fact that a CRTC must have one and only one primary
> > >  plane is an invalid assumption.
> >=20
> > I mean, no? It's been documented for a while that a CRTC should only
> > have a single primary, so I'd say that the invalid assumption was that
> > it was possible to have multiple primary planes for a CRTC.
>=20
> Documented where?
>=20
> I did read the doc of "enum drm_plane_type" in <drm/drm_plane.h>, and the
> DRM_PLANE_TYPE_PRIMARY describes my two planes, so I went with that.

At least since 4.9, this was in the documentation generated for DRM:
https://elixir.bootlin.com/linux/v4.9.263/source/drivers/gpu/drm/drm_plane.=
c#L43

Maxime

--ox5m2kdae4pdeh7p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCYGHzzQAKCRDj7w1vZxhR
xSgcAQDa8LPGxsVyYp+FHXSppe9HTW99P41ux9jSeGDbunQB9AD+LqQ/2UIcPOcb
uFrNSAR7loZGx5J70GpTipxYKy6/FgQ=
=OPxg
-----END PGP SIGNATURE-----

--ox5m2kdae4pdeh7p--
