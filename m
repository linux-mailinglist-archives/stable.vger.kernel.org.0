Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1350E2B9047
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 11:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgKSKlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 05:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgKSKlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 05:41:50 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6A4C0613CF;
        Thu, 19 Nov 2020 02:41:49 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id p1so5839488wrf.12;
        Thu, 19 Nov 2020 02:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MHnEOrvbhSGLANAE+Q8C5QoyY9bWqAkkZShUSQ8tDPw=;
        b=aOwMUqi6ySn9E5v+v354chGwzw4NAxicuP1Dlbo815E1QJ2MJmueKxnMK5+6hb7aDg
         98Acb3w11R3Od8qNR0PuEYTKwbSH4R21rLCmhtVbHk37qoqzIQzqN+lCC4OqFHqMMHej
         pNkZa7tBWlh7BZZ33T+XEKiXKC1rKQWNoHHUptFkDt+tuUno0hdN8dXxx8kUT4K6jUM+
         +xTA+pNiKkehIoHCiO2ErriO6akMaY7hIyu7OaXgHXTWeZlre7lwy8cJ9xiOvUi25C6H
         E9KCf/xcGrnr+0e3nP32LpKth8WTLhTkvhmrq80KXtQIFfP6GUHO4ROUt2skIOn9x+FM
         CexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MHnEOrvbhSGLANAE+Q8C5QoyY9bWqAkkZShUSQ8tDPw=;
        b=Ltu5UJPpnJBO6zIZ6Ek1g60CbNqrOZIe2G3b/YaHgDmcRy/2Y7gBYWNoAM1OOaATfD
         XP2V18kaJ4hF0AmMTyfMFj5HivqjzcMLOEmiliJu6FnzJ75wPGGOwq2GyxuasWxi7peZ
         Y7tK7Sp1KGo7oDXQMNsE48fkXLzuWbmj4GxdL5mlrhE8NHceqkE3OamLs5HqNNn9a9py
         6Cju1pQ0vZGZuhV8GRHBxfx+rp8wx7bC7YzIHq4/SDGrhIiiDyanyaIBVxC1qHFo2xhE
         14Sg16OgiHRS2rc+u4eUJGvZWQO3skPjinT8HokzDNTnFQeEhvl9vIC9IeEWNABet4kh
         r6MQ==
X-Gm-Message-State: AOAM53346bg9MUFN7N1dr93bAAn5noNqQXaKndG4xZksSQY9ayjV3BIR
        59PydIkbzbOoTisYVbQvm40=
X-Google-Smtp-Source: ABdhPJzkcln9b61qXWm4b6rcBoHmz0B4k78//yNJQV2rRUVSxv/jIkZUVrCbcFlDY7IwkvnKZecX7g==
X-Received: by 2002:adf:f542:: with SMTP id j2mr9431236wrp.107.1605782508408;
        Thu, 19 Nov 2020 02:41:48 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id v8sm9267340wmg.28.2020.11.19.02.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 02:41:47 -0800 (PST)
Date:   Thu, 19 Nov 2020 11:41:45 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     JC Kuo <jckuo@nvidia.com>
Cc:     gregkh@linuxfoundation.org, jonathanh@nvidia.com,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] arm64: tegra: jetson-tx1: Fix USB_VBUS_EN0 regulator
Message-ID: <20201119104145.GA3559705@ulmo>
References: <20201119072345.447793-1-jckuo@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <20201119072345.447793-1-jckuo@nvidia.com>
User-Agent: Mutt/1.14.7 (2020-08-29)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2020 at 03:23:45PM +0800, JC Kuo wrote:
> USB Host mode is broken at OTG port of Jetson-TX1 platform because
> USB_VBUS_EN0 regulator (regulator@11) is being overwritten by vdd-cam-1v2
> regulator. This commit rearrange USB_VBUS_EN0 to be regulator@14.
>=20
> Fixes: 257c8047be44 ("arm64: tegra: jetson-tx1: Add camera supplies")
> Cc: stable@vger.kernel.org
> Signed-off-by: JC Kuo <jckuo@nvidia.com>
> Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
> ---
> v3:
>     add 'Cc: stable@vger.kernel.org' tag
> v2:
>     add 'Fixes:' tag
>     add Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
>=20
>  .../arm64/boot/dts/nvidia/tegra210-p2597.dtsi | 20 +++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Applied, thanks.

Thierry

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl+2S+cACgkQ3SOs138+
s6HYIRAAq92ZFhrbwrU0jsQytIdgpzznSQqFr8t3RAw/JxmWcR0UhY2Zavv3OjRg
z/pj0hVWdBYLboF8m7794n5yL7E2e2KjntsKrd2nquXQNt+XKeZhlg3loRzc8J1x
ZUO2jWn3TxGowKbMhm7w1LLSo52nWN5+VNux8rC6WM+Y3EBTZ3/byof0bmiTb3Fd
NI6/HwitV3K+YOiPq1ZUVldz5ZEFrTu2gH/Vmv6PPTrLqCqdJkKLNrAMqVxFweYx
KXt+pdaxCWR/A8U7E96MmqBRK1naRU7yqaZZoU1lyiPV5tG2U5eZYCnhrWYkAl0h
vycVFHNhn3P/Gtd6QkALR0zJNA/q27/YG1agsZqMN0vF61VxOceQp2x34mtT9TQD
e7WEQ1zySu0OJJg/4MxMChsIgPniWxEdtKxNVAQ2AreSC5+sZCbzK9/4C2xFCrYE
x8A3vP0PaLG3Noi7uOfoyc1sEJY6rCXmCl1IqQdDRgIBeJ11uVdA3PWuYHCB5pQ1
cT/quo0tHvgZTKS3uqzRuTuN55FMlcq4+l6dlNuOpHYeWDsIkEXtwX7wsvsrPw0X
JAtDpupIcN+07c04R8rjDNPPEuITfFIkZRiciECnip7JMZqG4nKgVl2UaWMNNV8B
9SsWS/FfcKt2bsO6YM37fEHTLfrRP+OeLKURMjc0tSwcl8BDEz0=
=O36O
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
