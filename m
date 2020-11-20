Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03D92BAFDF
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgKTQRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgKTQRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:17:00 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644CDC0613CF;
        Fri, 20 Nov 2020 08:17:00 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id m6so10572467wrg.7;
        Fri, 20 Nov 2020 08:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UXb4/nAfsSHc/KSXI19AdT/2G62OQwwUOqOXfXRHMvg=;
        b=dVGYXx4DAaO7XnUh9GkMjFjcqd7hTM1jHTUOf+BSPDF113TM6zkR9EXTqhT1125sRA
         a103NyMr2KyFFDlHhF88CiiyyjFNXgARb4qULqL1+FK6nfECGWHAVd2grj6w6agxIbBD
         knXiRrAro9M00wcHDUL1wHWKjcdzzo+G7PPvQQUR1kMQGjajfVNAmWTKYCBQqhiuw8xs
         HxVn3dI6iX8eCS39P1qOFhv7IlHbZZbhTq6FZZ2kdM5emrIbS5jlP5wPfPyamGkN/3rZ
         /4Pj/4/pjNjQp/AbLESYIY5ePis9a3eu0JIpQcI3BDax1vH2cqlEXRr4Ek3GY7sFECHj
         K7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UXb4/nAfsSHc/KSXI19AdT/2G62OQwwUOqOXfXRHMvg=;
        b=GkqqvkjfOj6CDabRQarpg1RQzoVB6QoTDSuujGtaMQU1ay+PDLg/J8rTGK2z1DaZ37
         cbLCAEaJHtc4yw4VNpKyUq3991XyZgWRkYsxTjXbs+jyE3jTTalDL5+0JJZmtUNvYQG8
         X9u5FcmSUclTkO0yXq0YjiRM91C3QuhnXuzQboflN7VsSKhy4syjctESmQbA4cQli2rD
         6gvRaHR6o85V2TYbBUNUqxpbJ1KmESBmtC63u31Vu2cKDxkh3FeMKVRdHBW7fjNB6Ddy
         BWAFmt2j+U0bGt+aNfeRl6Wm0dMPChIYonizn9CZIuYgHdMDPFO1mj0Lf1QPAYSzAgkU
         aBLQ==
X-Gm-Message-State: AOAM5319fFUC2J2MukzCJAf/xEun1Y0YeViZ0QR9sKvr+VVhPf+f6lRF
        sGu29wCz2ywSnqB50lGEQNI=
X-Google-Smtp-Source: ABdhPJwX4TJbjRvvaC1CP/xTB8APxeECkF8Hw9WV/wlsYmp4lAbyIDuQXVQ2sd4X0KM/9uqysJdCxA==
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr16014557wrj.328.1605889019174;
        Fri, 20 Nov 2020 08:16:59 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id q5sm5768056wrf.41.2020.11.20.08.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 08:16:57 -0800 (PST)
Date:   Fri, 20 Nov 2020 17:16:56 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Nicolin Chen <nicoleotsuka@gmail.com>
Cc:     jonathanh@nvidia.com, sboyd@kernel.org, mturquette@baylibre.com,
        pgaikwad@nvidia.com, pdeschrijver@nvidia.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Do not return 0 on failure
Message-ID: <20201120161656.GC3870099@ulmo>
References: <20201029004820.9062-1-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Content-Disposition: inline
In-Reply-To: <20201029004820.9062-1-nicoleotsuka@gmail.com>
User-Agent: Mutt/1.14.7 (2020-08-29)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2020 at 05:48:20PM -0700, Nicolin Chen wrote:
> Return values from read_dt_param() will be either TRUE (1) or
> FALSE (0), while dfll_fetch_pwm_params() returns 0 on success
> or an ERR code on failure.
>=20
> So this patch fixes the bug of returning 0 on failure.
>=20
> Fixes: 36541f0499fe ("clk: tegra: dfll: support PWM regulator control")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> ---
>  drivers/clk/tegra/clk-dfll.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Mike, Stephen,

if you don't mind, I'll pick this up in the Tegra tree since there are a
few other Tegra clock patches on the list that may require coordination
inside the Tegra tree.

Thierry

--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl+36/gACgkQ3SOs138+
s6GoBA//f7gMWWZXjGr+n7voZIht8iquSb+hUuax+QT4Qvhr9K9TdgS00AX/hqKn
E1JDtJ2keLRhD4irovMNjnh+dwtT9N5SvmcvWp0M/uHPTYH+0udOQ77WJ3RwYMLq
QpxCA76zwmET819g5tfI69UwmVc8RL6CdXe3/Ubzw2q52ppvBs6HXucOGzYb7pA/
NyD6Td2lkH8+hXpGBlvGxvL5a5Tiw8V9CfDxULcQEx8S2h0sE7fnoP2aXgcjdx1k
vml+EUsbUWSvHeuBOJR2Uy60sAbZhhCzUAgAFohZ2qqfoqO2mGYQIYME4/ZnPoC2
w1m4bLmy5ezH9FIgj0LfQMsjEjGFfjSSYYzK4PMMLgsjVmogEzhLZIqps/4Fr1YL
4qAw5qWYPuXOgEamYUp6pUr2h1rb2utHm5LCA+vdLgzK/7ehh0gMJgG5ruC6oXA5
lyhYuNt+JWswwncng4L60ov1bf0GBe0q3s66hze5/Y23wE4OZQwiaBykUM212p+h
DvpyBoV/XvmGlR5UipFzhRVM/EkTkoXdDJuP0ZUvv/NV9SIi0qjN4VanTwn7hndB
RwWCEtit//ihpMup//cn8z4XdER+gj7FLHgnIsZxv5aFPVSdQEFvkPBsEP5BxBIn
Y4FQUyMd8v5cMTuKfK3YAcPn+C+FL4Kuyzunh5OxYlercfQAwow=
=mgBq
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
