Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8A81C8660
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEGKFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 06:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbgEGKFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 06:05:06 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07B9C061A10;
        Thu,  7 May 2020 03:05:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h9so5645385wrt.0;
        Thu, 07 May 2020 03:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I3XEZEir8mjaU7+45jVwuKvE1Mu0PTN/zTUIAubFKCI=;
        b=sW4R2D6NmQc/uUkzHBPZ4dq0iO4vvS8WsupKHd3y24pQe39FsaJwi6QzwL7xoDmw2h
         XBHYToik/4pPr6d6Lp7QWkXuNvqEVqW9pHIfEboU3Hbj2TkLLTi2hLU3dz8qitlVWd+8
         D/QvAn3tPNshlPruWsw8B37XSzmQHFNLKAV+kH1x0U2ja6VDNaab7EhOxyUiEq7F+DV0
         hxTgXO98fnmMWf2HeasuQ9AFhPP39Pp8F8woB6fhf4d02R0oqU3TZkPMutliFV6SCPs9
         jhATiucY8rroK5dkA4OImXdOsJclFSJUWSW4+6YoRZMmwlBpEWk5h23c0z08ru1RGf+G
         lbMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I3XEZEir8mjaU7+45jVwuKvE1Mu0PTN/zTUIAubFKCI=;
        b=Gn4dSavsbetfZQOmlHuLoTu3rF3cnOgySgFpPZt347WTifDfbKYlGCDeRY9cZ1Y4iG
         VBjBjtDnMVSkItJos7Oi6LdoZWG1XFKEpvrHLuXqrbw2Re6U19+WBrRzmIPMXy/sIVCV
         +gSI2VQD4Ut2HKSHCy2rtOHlEeNBEnAEsmNHXrRb8vIEk3rwLwhBMopdJxTUVNKHw437
         K8JFRbWyeFztVcW5VSmk1Q4+LvLHOmBQezW0Iu5WXQu4HX4ZkzqzSXSUG02tJCLEzYPF
         kp1p56xViy4pIt9tpjhvW+tM45RyqKYh6uepLsshedirxQsi/xBa7V1UwxJVOb9g1fKP
         u1EA==
X-Gm-Message-State: AGi0PubmUWZxZarzZ5BEx8sh8moi7zQoLA6TqWPfPNR78OQa7NSS6tYF
        3pecC41yYy4x5mW/mO8WOXc=
X-Google-Smtp-Source: APiQypL85Rp4PcfWy+llAW584pUmkpqwuyGQDd09cVbrIG6suk/obuRQvQYjV9Xq1ENcCd2K0dt0pg==
X-Received: by 2002:adf:ed0f:: with SMTP id a15mr1871371wro.320.1588845904337;
        Thu, 07 May 2020 03:05:04 -0700 (PDT)
Received: from localhost (p2E5BE57B.dip0.t-ipconnect.de. [46.91.229.123])
        by smtp.gmail.com with ESMTPSA id w6sm7594181wrt.39.2020.05.07.03.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:05:03 -0700 (PDT)
Date:   Thu, 7 May 2020 12:05:02 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: tegra: Fix ethernet phy-mode for Jetson Xavier
Message-ID: <20200507100502.GB2890327@ulmo>
References: <20200501072756.25348-1-jonathanh@nvidia.com>
 <20200506234218.4E11D2082E@mail.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <20200506234218.4E11D2082E@mail.kernel.org>
User-Agent: Mutt/1.13.1 (2019-12-14)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 06, 2020 at 11:42:17PM +0000, Sasha Levin wrote:
> Hi
>=20
> [This is an automated email]
>=20
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>=20
> The bot has tested the following trees: v5.6.8, v5.4.36, v4.19.119, v4.14=
=2E177, v4.9.220, v4.4.220.
>=20
> v5.6.8: Build OK!
> v5.4.36: Build OK!
> v4.19.119: Build OK!
> v4.14.177: Failed to apply! Possible dependencies:
>     5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
>     b8656c673a6b ("arm64: tegra: Add device tree for the Tegra194 P2972-0=
000 board")
>     f69ce393ec48 ("arm64: tegra: Add GPIO controller on Tegra194")
>     f89b58ce71a9 ("arm64: tegra: Add ethernet controller on Tegra194")
>=20
> v4.9.220: Failed to apply! Possible dependencies:
>     5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
>     99575bceebd6 ("arm64: tegra: Add NVIDIA P2771 board support")
>     b8656c673a6b ("arm64: tegra: Add device tree for the Tegra194 P2972-0=
000 board")
>     f69ce393ec48 ("arm64: tegra: Add GPIO controller on Tegra194")
>     f89b58ce71a9 ("arm64: tegra: Add ethernet controller on Tegra194")
>=20
> v4.4.220: Failed to apply! Possible dependencies:
>     0f279ebdf3ce ("arm64: tegra: Add NVIDIA Tegra132 Norrin support")
>     2cc85bd90337 ("arm64: tegra: Add NVIDIA P2571 board support")
>     34b4f6d0599e ("arm64: tegra: Add Tegra132 support")
>     5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
>     5d17ba6e638e ("arm64: tegra: Add support for Google Pixel C")
>     63023e95bec0 ("arm64: tegra: Add NVIDIA P2371 board support")
>     99575bceebd6 ("arm64: tegra: Add NVIDIA P2771 board support")
>     b8656c673a6b ("arm64: tegra: Add device tree for the Tegra194 P2972-0=
000 board")
>     f69ce393ec48 ("arm64: tegra: Add GPIO controller on Tegra194")
>     f89b58ce71a9 ("arm64: tegra: Add ethernet controller on Tegra194")
>=20
>=20
> NOTE: The patch will not be queued to stable trees until it is upstream.
>=20
> How should we proceed with this patch?

Tegra194 support was merged into v4.17, so it doesn't make backport this
to any stable kernels prior to that.

Thierry

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl6z3U4ACgkQ3SOs138+
s6ERdQ/+M8e+Pq//sHoBLsVfspJENeX9JUSLVqTVsXEnHTxnv0Ri/qKuRYOzWcgU
zktBmBWHxJt8UPlgxRqL9rcRHBf2mXRu7QsRSvBozLOuszdbp2pDq8dKGO1TgBKm
ZQJekFzhEeWm8JAQiDlHjMfqwtPNXhRefl+gyRvWjOsTlROipbcm7Qr/RmztNmWJ
73p4lkUcZ6BuRQoZgn9JDIBhDK3v02DwlJHAUjdYjRt6n4Wh39D4bllyi0JAw6FG
4zV9fLL+PY9ie6ZtRiA3ACmjc9I28UiCMs4/VXnXVxGK+L9UjjrKvONaZtQ+aPDS
wP9P9jihX6wcYOEPSoIvNBw4ne1eyWIOCdDjM0PjtYVov73xoseYv1OQGPfFdR6T
77SWjnbppJNjA1IuV1adwWBJrY8w8jxdXLTXNehURSAc+ve6WOQ725kxIRZ2HAeL
AVZb7nUI/+TiAZVYP4dntzk6rzZsQx4JhyKgYF9yVQ1NANw6QAog+RIc+4KOW+Ee
0bLJeNRNoCvAlJdwaynn6gVXNmgF3jQeMHoLpVWPwDu2ARN1vhcwYmoVC4xtdPaY
V0Eb1gORelEyYb1HwVN446IjAse8ex9wvAMPKu59l7PrbonEO8ismM2tx+8/7bkJ
9ChG18/p+Ln1yUybHvHR+FGTYdBJriPZ33rcLZ1wSkzmbnFAcA4=
=+6E+
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
