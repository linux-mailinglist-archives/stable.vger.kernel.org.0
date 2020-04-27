Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEA61B9863
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 09:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgD0HWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 03:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgD0HWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 03:22:38 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE972C061A0F;
        Mon, 27 Apr 2020 00:22:37 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 188so18324098wmc.2;
        Mon, 27 Apr 2020 00:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dDUA58woNMYWtq/WZ0FMwKygFL3GgcsV4f9N5IHf/Kc=;
        b=pHe59qy5ojU6cXub8km6XzQVj3gmdsbjcUTPw9PASyzhnUSdUb052LDVBpgrNWUs0i
         zISLDBmMwFLKQgRz+gKkOu1liH2Zuxcfefyh4OilISy+xE+s+PNhofIuFIaWIXl8LSeS
         XeLoLFJ7PmUfky+fAYZddD77jknp+sivABw+B1iqG+LuGWVMamYbsSJlQv2cuC1Af6v7
         9Cl1GpCFitSOuXoG/GD+NRiotp0sYnvm0NJFaodXyW3TJ5hflQcu1nZbwaZmyO/l1sqs
         0CLK3Ado448yW4b+r2Tf20VswTWfH1L8vEGFyejJylOa7INrpxmu+z9kl44wVLmSjHnm
         GeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dDUA58woNMYWtq/WZ0FMwKygFL3GgcsV4f9N5IHf/Kc=;
        b=gJnbtWkBeJoDPimPOJDDVTkRN1yJwyq1WXh2JC7Ep7kjjpy7Nrcqp3DOvQuU+9+Zo9
         e56ycgXwGm7SibeDR13AG4AYFZXlRNmT7nndqWB0Vr8vS6qCSc3CJXIlS2UnhuTkX68G
         cXLlhq6Twpl+dn7Q9AEx7nVL/gq0FAM5wbpg2CSkLp+4PdHyfF8/6Gy8/zgHP3cvzCCp
         rvIk1Qt6S5EC7UkoocTBI2dzFB2DL+kGgNimIcc4Wt3hIu60ksbZdWkrLT26tIH7kYvf
         +bZ2HZ67GO5K9+2pv1FmVxT52IPoOdaJpoNI/7jCW1bkfLKezmgSPXvd88Gs9RyrlgZo
         UgBg==
X-Gm-Message-State: AGi0PubzeTSDL4mfjovZjtlo5G3IQy2TZwMBpAMZu8LnklNVyT74IOY5
        FibwwofO5U0NUz/MCYF9AqI=
X-Google-Smtp-Source: APiQypLeNiAFTrmjOqdYRGfgbEQ1703B0wGhHNZ1ghOBSl+jWG953+jr7f60BIokHkPrqhnPf4esqg==
X-Received: by 2002:a1c:49:: with SMTP id 70mr23417501wma.184.1587972156630;
        Mon, 27 Apr 2020 00:22:36 -0700 (PDT)
Received: from localhost (p2E5BEDBA.dip0.t-ipconnect.de. [46.91.237.186])
        by smtp.gmail.com with ESMTPSA id i74sm2222631wri.49.2020.04.27.00.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 00:22:35 -0700 (PDT)
Date:   Mon, 27 Apr 2020 09:22:33 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 30/38] i2c: tegra: Better handle case where
 CPU0 is busy for a long time
Message-ID: <20200427072233.GB3451400@ulmo>
References: <20200424122237.9831-1-sashal@kernel.org>
 <20200424122237.9831-30-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <20200424122237.9831-30-sashal@kernel.org>
User-Agent: Mutt/1.13.1 (2019-12-14)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2020 at 08:22:28AM -0400, Sasha Levin wrote:
> From: Dmitry Osipenko <digetx@gmail.com>
>=20
> [ Upstream commit a900aeac253729411cf33c6cb598c152e9e4137f ]
>=20
> Boot CPU0 always handle I2C interrupt and under some rare circumstances
> (like running KASAN + NFS root) it may stuck in uninterruptible state for
> a significant time. In this case we will get timeout if I2C transfer is
> running on a sibling CPU, despite of IRQ being raised. In order to handle
> this rare condition, the IRQ status needs to be checked after completion
> timeout.
>=20
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/i2c/busses/i2c-tegra.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)

Hi Sasha,

can you drop this from the v5.6 stable queue please? Jon discovered that
this patch introduces a regression in v5.7, and since we don't have a
good understanding of why this is breaking things I think it'd be best
if we reverted it for v5.7 until we come up with a good fix.

I think the same applies for the other i2c/tegra patch that's 31/38 of
this series.

Thanks,
Thierry

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl6miDkACgkQ3SOs138+
s6HFbhAAkw4kw0wOkZzY/9qlB+gSAit5MKAPOvPoPQ+f4LjUlhNdKDu3XysVK0dS
sKAk/f2CHLCm7SMgEATxuVw5agM5I33ufzlr8Jc5zUPpmlIuoOKkV3R433s9O9lC
9sUMHWDn34zJagJKLZ9KIMMpwf4cWD4wp29u/TrZgqhfC2JQSIi72uyk3CzKJxtI
3y0383+ju7JYQ+1iyaJPSsZ5F/Dbmk2cViZC+X2oxe9LozVIM2PAP9GkSx6HXgU7
WJhn92GDamvh1AuOD+K7XRHY+7QqVaK2vAPjPAof3DH0Tn3MH3kStt1P9AuO+IyO
5kdFaJXrbrspmmViYpC/QHdW6IxRlpYnjYDOJJ0ZCrqSDgUH2UfI4zCX0bkBilpZ
qVGqXnnPWhtOAK2hpMxJnZ2T7DCcyldLQKhgaQs+sYRrgS0pDXWsQyiInCUMEgsh
W9dM9rHcWkVNaEJyYlpXb5SAvv5tA0ctcidaCr/LXBfBiwWbDjSxHMBbUxLnfGmD
5EZNx49+q7M4y6E8YO3+iUY83aHx60zUivwElPx2kg7Y8nAeUWVy7QRUGaH1Uk6o
e96D8cHiswWsUV1C2xDakAMdFCLw3w/XXRDuVsZGpq/Y2XYOpQG/2NiBtLJMFqCb
ywW3eBGTPuKlnB7CF9yF/0+3UuyEA69wkUfMvFPSv2A9furafpc=
=W6uU
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
