Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDCB35DDD9
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 13:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbhDMLhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 07:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241052AbhDMLhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 07:37:21 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB0EC061574;
        Tue, 13 Apr 2021 04:37:01 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id z24-20020a1cf4180000b029012463a9027fso8552982wma.5;
        Tue, 13 Apr 2021 04:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d8prWghJv+BkiPsQ41cXnPAO/NBhcn05YDXuxcrhtEc=;
        b=iff6X5Dx5VtccL1uM8p2zLSXcrty+PuUGC7J7z8zXEhInb/+xp6sCmr4WpXqZMvgb8
         U/sI9sbF3KF8QWGS2ZH58/wbAC/7sFyazmiDGUsMMbiZdsdaQsyFRpSyaG/tncNYD7s3
         b6F6wj3u3w1W3ik+XIzTB254U47VrGsIrfJCf1oonuFB3mpok5f2SQ1oAuc1yPmn3Ski
         DYYNM2390gZtJEKQy/7PKGmwKrmIIzmf+Qjm0+BnJb5dxaY9IWr3JG1W0V+CDbW4edn9
         5m022ytrZ/AQR+nTw4hpDAfaI8luLhP1/kebH6wChvq4bm0gWtj+Dc6Q+lYkhQqBRZyR
         sW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d8prWghJv+BkiPsQ41cXnPAO/NBhcn05YDXuxcrhtEc=;
        b=sLiKxot75Fa85MzK8UaPSyALDS3z9utgozsh1BsdupRKIcRbCmgeOJZ16+hel18qME
         3Rm95+c5KzJr7Y2AtR84R59jliwmDetnG051buSeXuc6iErYe+kCovzbVn1pOFpiEKlb
         35kcbKn0yCOjlWn1EoaNowN35JZc6xWl4cCghiRVe9PilXopRCyLF6+daK/Pl/9D4R0d
         pBRAx6zgHJJ4APmaYSAyEGbPgkkK58tiB0W0xN3mPaMWBm8lERT4QC1hcu0oAEA+aKQ0
         1LBZGyEcepMrRYVAZNyB+gP+y0iY6HV4xqmLR6WHk8zlve2AHJCwaErpOdqx7G4g1biU
         vjxQ==
X-Gm-Message-State: AOAM533geah6i/Obbo163hhDhT+8CLppmlTg1J0A9HbPJcJzxASH9e0R
        YvC2iClA6ZLl08D3Xeu2ce8=
X-Google-Smtp-Source: ABdhPJxeKrK3zuVlsI2tuMeQzuZfRj5oEbBzKypg8YvEhMsDsu8BDty5SEpGMzwepcRaCUlSBf8+IA==
X-Received: by 2002:a1c:7311:: with SMTP id d17mr3559703wmb.183.1618313819915;
        Tue, 13 Apr 2021 04:36:59 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id v18sm2141913wmh.28.2021.04.13.04.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 04:36:58 -0700 (PDT)
Date:   Tue, 13 Apr 2021 13:37:38 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 10/12] drm/tegra: Don't set allow_fb_modifiers explicitly
Message-ID: <YHWCgpq5fVpSGdSN@orome.fritz.box>
References: <20210413094904.3736372-1-daniel.vetter@ffwll.ch>
 <20210413094904.3736372-10-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3zY2OYTARJAQNWvh"
Content-Disposition: inline
In-Reply-To: <20210413094904.3736372-10-daniel.vetter@ffwll.ch>
User-Agent: Mutt/2.0.6 (98f8cb83) (2021-03-06)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3zY2OYTARJAQNWvh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 13, 2021 at 11:49:01AM +0200, Daniel Vetter wrote:
> Since
>=20
> commit 890880ddfdbe256083170866e49c87618b706ac7
> Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Date:   Fri Jan 4 09:56:10 2019 +0100
>=20
>     drm: Auto-set allow_fb_modifiers when given modifiers at plane init
>=20
> this is done automatically as part of plane init, if drivers set the
> modifier list correctly. Which is the case here.
>=20
> It was slightly inconsistently though, since planes with only linear
> modifier support haven't listed that explicitly. Fix that, and cc:
> stable to allow userspace to rely on this. Again don't backport
> further than where Paul's patch got added.
>=20
> Cc: stable@vger.kernel.org # v5.1 +
> Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: linux-tegra@vger.kernel.org
> ---
>  drivers/gpu/drm/tegra/dc.c  | 10 ++++++++--
>  drivers/gpu/drm/tegra/drm.c |  2 --
>  2 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
> index c9385cfd0fc1..f9845a50f866 100644
> --- a/drivers/gpu/drm/tegra/dc.c
> +++ b/drivers/gpu/drm/tegra/dc.c
> @@ -959,6 +959,11 @@ static const struct drm_plane_helper_funcs tegra_cur=
sor_plane_helper_funcs =3D {
>  	.atomic_disable =3D tegra_cursor_atomic_disable,
>  };
> =20
> +static const uint64_t linear_modifiers[] =3D {
> +	DRM_FORMAT_MOD_LINEAR,
> +	DRM_FORMAT_MOD_INVALID
> +};
> +
>  static struct drm_plane *tegra_dc_cursor_plane_create(struct drm_device =
*drm,
>  						      struct tegra_dc *dc)
>  {
> @@ -987,7 +992,7 @@ static struct drm_plane *tegra_dc_cursor_plane_create=
(struct drm_device *drm,
> =20
>  	err =3D drm_universal_plane_init(drm, &plane->base, possible_crtcs,
>  				       &tegra_plane_funcs, formats,
> -				       num_formats, NULL,
> +				       num_formats, linear_modifiers,
>  				       DRM_PLANE_TYPE_CURSOR, NULL);
>  	if (err < 0) {
>  		kfree(plane);
> @@ -1106,7 +1111,8 @@ static struct drm_plane *tegra_dc_overlay_plane_cre=
ate(struct drm_device *drm,
> =20
>  	err =3D drm_universal_plane_init(drm, &plane->base, possible_crtcs,
>  				       &tegra_plane_funcs, formats,
> -				       num_formats, NULL, type, NULL);
> +				       num_formats, linear_modifiers,
> +				       type, NULL);

I think we can do better than linear_modifiers for overlay planes, but
given that this doesn't change existing behaviour, I'll do that in a
separate patch.

Acked-by: Thierry Reding <treding@nvidia.com>

--3zY2OYTARJAQNWvh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmB1goAACgkQ3SOs138+
s6HiPg/9F2IhGz7bj0R3eFPU3cBNVrP3Fi7Q48YLUZofkiN0ka7nGaDGknhgaupF
bE3N2Yk9Qp+tsN82z3R7PsFfmmPfy3uBKp8lcXV2jMJtb/sqH+JmRZAUl3wzT0qb
ZwnaBs5xjoPATt8oFC8/8Y1sQ2GW7+6yWCWIaVC8PqiQ5g78L6gsu2N7Ig/rB+P6
VAI6t1MGjdfiF8lrMF3+kkvbpxrqIybiAHXVhsUxViXH88AWq56lu9LRUWZTk3T9
eLyBcbyth7XrO4KJOMuOFqXYjPn8f7dKittgCwSacGkItWmQv0+GBrdFeA+i0WZW
b0SRu1QdGY9ClU0Z+rs9YCRV9P853vCUQs2E6rPEpO9Ul8tP/OKoGu0/DUFV98gJ
iReAe4bP6CSJN96oJ+FUunvOyJ40gGWToWCmZ37fM1Vt/qH2+LkPAkkbdAPkCqBx
1frCx2qFhxRNL+laXN7tkkmjg+ZPBqK8VjEQJ+dl5gBQsM8g1o4cliI6KSKgjm4B
oAArUFz3u9zYzT0sFuqj+lyh9/Tu+gevrUNkcyAkUrngNaEZkCgSL6A6rJLKSOLY
ZH964cF3UDvzZGwuOaVgR9agCBXh2i/WFa1AtE6HsvB/HELLxg3nUHYe5CBAGrjM
4BLaGiVxVaYx73qjnaB2LKcqybVO8S+NEP48pWjwnGXz1fu0z/8=
=0rrw
-----END PGP SIGNATURE-----

--3zY2OYTARJAQNWvh--
