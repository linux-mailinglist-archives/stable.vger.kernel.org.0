Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BAE4CA89
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 11:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfFTJSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 05:18:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50775 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfFTJSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 05:18:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id c66so2313950wmf.0;
        Thu, 20 Jun 2019 02:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xtPabCSG8dqvgaXrQKGEkC8kkoca7crksnnK+Euup6Y=;
        b=N64+7UisPdGPIV/M1pVCCPxiZUnJNpNRojReN2MlKO5uuDqg899tG4B6J8gseGhR1w
         K1fEfGV8G/ictW432uxaIm4NLN4lPxlJ1FmHL10c/3p8FMZ0gTCqYGZe7mh8im0de6aw
         jM8SErqgAII9utBXvlHw4EE1v6WSogoaeM2HCh98O0QeivSJX4YN2PG7XgBebyZgUPvp
         fYlIl42eVdaCNOKp//HnEdxX7gWBBYr9xWuYROaUWJllneoXX9kzqSwWATR67xWAdOMw
         EfEb1tLxQDgvutaPvQc5ac6KiAk1KE71rJBNwzVu1BUuUVAvLbdryDIwEIl+yHWe4CG+
         aSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xtPabCSG8dqvgaXrQKGEkC8kkoca7crksnnK+Euup6Y=;
        b=YYWM4plqGZA8UYr96flnTl13S+W3zmbJdQsyZy88b/UdPVZgZj91xO0aMMGAM4s9wA
         O9vGWQvR+ExthTIolya1ikfjsP+Ek7EzPtlueQadYOPES70FAbs41/m8eGC3P4FPqKnV
         47t/j4bF4crUDhFow6cYnTToi8qDh/foJkBxKjwhCgpCWFJ4bcsCCkk09WpIFYk8d+Tu
         +B6KzPcw9D3YbhexhBKD1sfOQtSCEhcghORskHPlX5tGJ8nmLAT5z8eo+Yg2ynqEXqRu
         7wg9+s3c9hh4RIrKXD42G6ndHMShjcJvg1TS1mlR5uzGel/FVnRdFxM9BCRO5OfYGJbC
         EnUA==
X-Gm-Message-State: APjAAAVO2XvCFSDV60HD/UtazWcMU3B2QdH83sedUGUBMjrldtCpC6vS
        a/VXv/yM5vPwttAIjphih38=
X-Google-Smtp-Source: APXvYqwk7w/nxEPb1Nt3okzsCv4a0LLZZJrWpY/C1z6dueiFbPkn55Zn7iJd87L/qwoaeoOAhBzZWw==
X-Received: by 2002:a7b:cc16:: with SMTP id f22mr2108020wmh.115.1561022318871;
        Thu, 20 Jun 2019 02:18:38 -0700 (PDT)
Received: from localhost (p2E5BEF36.dip0.t-ipconnect.de. [46.91.239.54])
        by smtp.gmail.com with ESMTPSA id e7sm3414052wmd.0.2019.06.20.02.18.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 02:18:38 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:18:36 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] arm64: tegra: Update Jetson TX1 GPU regulator timings
Message-ID: <20190620091836.GG26689@ulmo>
References: <20190620081702.17209-1-jonathanh@nvidia.com>
 <20190620081702.17209-3-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5L6AZ1aJH5mDrqCQ"
Content-Disposition: inline
In-Reply-To: <20190620081702.17209-3-jonathanh@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5L6AZ1aJH5mDrqCQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2019 at 09:17:01AM +0100, Jon Hunter wrote:
> The GPU regulator enable ramp delay for Jetson TX1 is set to 1ms which
> not sufficient because the enable ramp delay has been measured to be
> greater than 1ms. Furthermore, the downstream kernels released by NVIDIA
> for Jetson TX1 are using a enable ramp delay 2ms and a settling delay of
> 160us. Update the GPU regulator enable ramp delay for Jetson TX1 to be
> 2ms and add a settling delay of 160us.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied to for-5.3/arm64/dt, and I added this Fixes: line:

Fixes: 5e6b9a89afce ("arm64: tegra: Add VDD_GPU regulator to Jetson TX1")

Thanks,
Thierry

--5L6AZ1aJH5mDrqCQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl0LT2wACgkQ3SOs138+
s6EIWg//ZOfSQYRaxiwtqAkQMKHfXrfR26rxjTtrybyAQY/NU1shhUp7o6j1teYE
4gCLySuu04WRQQJUfogtufH4GJvYfmY9WOC+6sJAiCB1adKvQQ2beSl2fCO8Emj6
Isk7rE6hOoj+XKysoMDzhAi+8uK61dcRAAeYRjLIRRB1rsXO273FRfT4TYLZodRm
xEUH5jKhaWrhSi8fhJzxjzApuMYHDpB3Oll5tWlucJwms6IltRvXyRomYa4ktmC7
l8D3s3DpKt/HwDztLSIZOi3xP5qpPo5jPujNIBcqXwPOuIqvkKdqU/T5YudvHpHQ
c7Sg/WOF0vhCb1Nt6CKEMuwZg8FHyFHHm3xMmRPdK5Q+Vqr+30jElLwIOrjn9lsk
IfJjfQZ5psUrHG8zerCcvJOHaZ8I+CKBEYcmyqPOJy7poXBRyppvM5HxuxCBt60H
l0LAQpfMGFx7ZzJdzUzLedujp2ZjlGo3zZi1/LIU0fkPe/f9afF24lN7Gsjn7An1
yJkiK30cceof2bklpNr+QY1bsWJJFRrJ+m4/StkaOaZAxxNAoI+o+4xzs7gsy0HP
S6sbvjLnO1y10ODMZzjaL6dFtWht/O6lskhXD3alC5fF44shDHcms4Wh7f3FbUBr
qByVMuFvH0W4MFqzbcqQNhq/lPjRKSLu4C+vj4OduQHWJON+Vhc=
=ynW/
-----END PGP SIGNATURE-----

--5L6AZ1aJH5mDrqCQ--
