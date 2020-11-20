Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13742BB047
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgKTQSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbgKTQSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:18:43 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04177C0613CF;
        Fri, 20 Nov 2020 08:18:43 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id c17so10547734wrc.11;
        Fri, 20 Nov 2020 08:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bzdc5UA+fyIedMG+sR85R1gd64iwqKp7Gx7wpDOOTo0=;
        b=C1srU+M/BeGZ69BLEW8DP78MF8Xnjr4+oAYhVnL9kOkCPSHOTKVYCj0T2S/qOaItoI
         N8EVig7lM9bwRaMh6HC8IpCCHxYtnbErxtJdNO2f7tFmMOfy+tMcG8LhpHO92q4QqxtQ
         sZ9E2oMsQnubMUwvJSJiEPqzI9T3FLDbIojXszcvnTCpHrF/5SHvOoj63O2ymAM50Sxm
         JlNhUkjYIpnW7EN2VRyPFvMTMqbBAu+vtjxCBtjkNhI+x9WCR/1ZMgaQIPLEYdwBMcCJ
         dG/MIhkGxmms65tfofCKZt19etwVF79t4eTbyrOARimYVxoHU+qcXfHtNFc2eslUAELT
         59JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bzdc5UA+fyIedMG+sR85R1gd64iwqKp7Gx7wpDOOTo0=;
        b=Q6yuKrbrVab4wiAsMq0gh1eN8CQBvsp07ArG+/AMGfMqvueZ8COsbmi2HyvlwnEcCP
         Vlh3EkYR/yVhqW51XD84N+Fm3mcZRXS5uX6lQum+zSpnZsXvk2ktJSUBC8T9/xJ9PXAl
         RqnCFUQL6HjeIQCkbH/GayAd9axbirjq0zl3BN+NY1XctTUFBIEclRVgPfnHhYUcqe1k
         aW4WYJyYBxDkH9EudwZHWsYA2ADJggCNOijV2gPjMiz1UUOmHJgktu9LvuRBAGNPBzbN
         fQFwvEASSWB5WUb8TQcTPu+FDMll2yb2EIRljguaVgp/Dp/NfPmMVvBsA8YCQBE+U308
         6i9Q==
X-Gm-Message-State: AOAM533MT7cLCmLfILlY7R24Wju1i4TK95MVoG9jeMJpJiM3YNXFst9a
        DsF4oNfnDMIs+uI2SNhmhMQ=
X-Google-Smtp-Source: ABdhPJz+HOrcXDrph6ZNn74l4ldsZN2ESkTa5W5UBJBpfdxfG9xniDfC/6kfVOD8P1mTn+9FrUgbzw==
X-Received: by 2002:adf:9066:: with SMTP id h93mr17820577wrh.166.1605889121709;
        Fri, 20 Nov 2020 08:18:41 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id k84sm5092885wmf.42.2020.11.20.08.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 08:18:40 -0800 (PST)
Date:   Fri, 20 Nov 2020 17:18:39 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>
Cc:     Nicolin Chen <nicoleotsuka@gmail.com>, jonathanh@nvidia.com,
        pgaikwad@nvidia.com, pdeschrijver@nvidia.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Do not return 0 on failure
Message-ID: <20201120161839.GD3870099@ulmo>
References: <20201029004820.9062-1-nicoleotsuka@gmail.com>
 <20201120161656.GC3870099@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
Content-Disposition: inline
In-Reply-To: <20201120161656.GC3870099@ulmo>
User-Agent: Mutt/1.14.7 (2020-08-29)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 05:16:56PM +0100, Thierry Reding wrote:
> On Wed, Oct 28, 2020 at 05:48:20PM -0700, Nicolin Chen wrote:
> > Return values from read_dt_param() will be either TRUE (1) or
> > FALSE (0), while dfll_fetch_pwm_params() returns 0 on success
> > or an ERR code on failure.
> >=20
> > So this patch fixes the bug of returning 0 on failure.
> >=20
> > Fixes: 36541f0499fe ("clk: tegra: dfll: support PWM regulator control")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> > ---
> >  drivers/clk/tegra/clk-dfll.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> Mike, Stephen,
>=20
> if you don't mind, I'll pick this up in the Tegra tree since there are a
> few other Tegra clock patches on the list that may require coordination
> inside the Tegra tree.

Also, I do plan on sending the collected set of patches to you for
inclusion via PR at a later date, if that's okay with you.

Thierry

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl+37F8ACgkQ3SOs138+
s6FqBA//bISZURsZ2cBDNx10kQOBl/r8qyojxaqpR5H1TBpduOr/eK/XAf3zQxTg
8kotRx/qWjP4/Wgmtg9SXTpOAx8GksX6MxKsoBQSafFTCkiZkq0yBo6CBpCQQ6vs
pVv2iFfKpT71IifDFaQgol1YDcA+t9HpS3ma8Ss3IdPs9nv+QGrnwjv512KVRy5P
eFQVlSYGjK9hPs+yPKTlmzmzaYRo5eTiGBSdXy3ha0CqxnuVh6AaNPC9B3lRQHmK
6dsOVW9Fdt/8QRSS4JyadlN/XFE39xT28DzcEl2197YawmcBTrIbJCDuRH0D2fk5
U0s5vmqNYOVMJd11oiIiiDnS4Zghd3TW0q4WbNnM3+58kXJPphAatpeyYUy6UJch
fVT1kjXBx97Fc8fALYWp5PJte6evwpsIgRJR44/ELASPc+ml8/paUtZkMGf5TrgJ
3A2Ba2kndOX+p0aKrVSMR/vAmAmLaT3NP/VGlKXUwkLx4x2tCuu1jJB1CiDK5rVa
tcru7Fn4LXzLaMNIf2CV0lMQQj3lYqk6v1UvvgstGxq1yKjtdlaUshVHHbAFP30+
BQmPbeOJpFAKmHZt4ysm1WoA1PkX/JWJtxdsvZ9sAeap+G8FfvFbO8yC4Sh1Ghc8
rA+dN52mmbosvMC6xIDMiA0467pyB7BO0UkxKVfcI7SMmtYaRDs=
=PS/4
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
